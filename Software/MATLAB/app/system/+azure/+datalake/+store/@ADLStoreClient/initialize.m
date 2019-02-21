function initialize(obj, varargin)
% INITIALIZE Method to initialize the Data Lake Client prior to use
% This method will initialize client. It checks authentication credentials
% if already set or reads then from a configuration file. By default
% Service-to-service authentication is used.
%
% Examples:
%   % default service-to-service authentication with default configuration
%   file
%   dlClient = azure.datalake.store.ADLStoreClient;
%   dlClient.initialize();
%
%   % authentication using a non default configuration file
%   dlClient = azure.datalake.store.ADLStoreClient;
%   dlClient.ConfigFile = '/home/username/myconfigfile.json'
%   dlClient.initialize;
%   To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code DYE69A87C to authenticate.
%   % Once the browser based sign in process has completed client ca be used
%   % to access Data Lake.
%
%   % end user authentication without using a configuration file
%   dlClient = azure.datalake.store.ADLStoreClient;
%   dlClient.AuthOption = azure.datalake.store.AuthenticationOption.ENDUSER;
%   dlClient.AccountFQDN = 'matlabdemo.azuredatalakestore.net';
%   dlClient.NativeAppId = '1d184e4a-62c0-4244-8b68-4cffe757131c';
%   dlClient.initialize;
%   To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code DYE69A87C to authenticate.
%   % Once the browser based sign in process has completed client ca be used
%   % to access Data Lake.
%

% Copyright 2018 The MathWorks, Inc.

% Import
import com.microsoft.azure.datalake.store.oauth2.*;
import com.microsoft.azure.datalake.store.ADLStoreClient;
import com.microsoft.azure.datalake.store.ADLException;
import com.microsoft.azure.datalake.store.DirectoryEntry;
import com.microsoft.azure.datalake.store.IfExists;

% TODO resolve log4j logging issue with Microsoft SDK
%import org.apache.log4j.BasicConfigurator;
%import org.apache.log4j.Logger;
% Turn on log4j for the Azure SDK & make this coexist with the ML logger in
% due course if useful, see BasicConfigurator.configure();

% Create a logger object
logObj = Logger.getLogger();

%% process the configuration file if used
% AccountFQDN is required regardless of which auth method is desired so test
% that to see if a method is configured before reading the config file
if ~isempty(obj.AccountFQDN)
    % Credentials have been set so use those which have been set in preference
    % to the credentials file
else
    if ~isempty(obj.ConfigFile)
        % if a file is specified use that
        configFile = obj.ConfigFile;
    else
        % otherwise check the path for the default
        configFile = which('azuredatalakestore.json');
    end

    % Check whether we can successfully find the config/credentials file
    if isempty(configFile) || (exist(configFile,'file') ~= 2)
        write(logObj,'error','No configuration file found');
    else
        % write(logObj,'debug',['Reading authentication credentials from: ',configFile]);
        % Found the file, let us read it and initialize
        credentials = jsondecode(fileread(configFile));

        % If there is a ClientId then expecting service-to-service
        % else assume NativeAppId and end-user authentication
        if isfield(credentials, 'ClientId')
            obj.ClientId = credentials.ClientId;
            obj.AuthTokenEndpoint = credentials.AuthTokenEndpoint;
            obj.ClientKey = credentials.ClientKey;
            obj.AccountFQDN = credentials.AccountFQDN;
            obj.AuthOption = azure.datalake.store.AuthenticationOption.SERVICETOSERVICE;
        else
            obj.NativeAppId = credentials.NativeAppId;
            obj.AccountFQDN = credentials.AccountFQDN;
            obj.AuthOption = azure.datalake.store.AuthenticationOption.ENDUSER;
        end
    end
end

%% check settings required for each auth method
% check end user settings
if (obj.AuthOption == azure.datalake.store.AuthenticationOption.ENDUSER) && isempty(obj.NativeAppId)
    write(logObj,'error','Authentication Option is set to ENDUSER but NativeAppId is not specified as a Client property or via a configuration file');
end

% check service to service settings
if (obj.AuthOption == azure.datalake.store.AuthenticationOption.SERVICETOSERVICE) && isempty(obj.ClientId)
    write(logObj,'error','Authentication Option is set to SERVICETOSERVICE but ClientId is not specified as a Client property or via a configuration file');
end

if (obj.AuthOption == azure.datalake.store.AuthenticationOption.SERVICETOSERVICE) && isempty(obj.AuthTokenEndpoint)
    write(logObj,'error','Authentication Option is set to SERVICETOSERVICE but AuthTokenEndpoint is not specified as a Client property or via a configuration file');
end

if (obj.AuthOption == azure.datalake.store.AuthenticationOption.SERVICETOSERVICE) && isempty(obj.ClientKey)
    write(logObj,'error','Authentication Option is set to SERVICETOSERVICE but ClientKey is not specified as a Client property or via a configuration file');
end

% check common settings
if isempty(obj.AccountFQDN)
    write(logObj,'error','AccountFQDN is not specified as a Client property or via a configuration file');
end

%% create the provider
if obj.AuthOption == azure.datalake.store.AuthenticationOption.SERVICETOSERVICE
    % Create a TokenProvider for OAuth2 authentication
    provider = com.microsoft.azure.datalake.store.oauth2.ClientCredsTokenProvider(string(obj.AuthTokenEndpoint), string(obj.ClientId), string(obj.ClientKey));
elseif obj.AuthOption == azure.datalake.store.AuthenticationOption.ENDUSER
    % create end user auth provider
    provider = com.microsoft.azure.datalake.store.oauth2.DeviceCodeTokenProvider(obj.NativeAppId);
else
    write(logObj,'error','Invalid AuthenticationOption');
end

%% create the client handle
% Use the token provider to create a handle to the ADL
obj.Handle = com.microsoft.azure.datalake.store.ADLStoreClient.createClient(string(obj.AccountFQDN), provider);

end %function
