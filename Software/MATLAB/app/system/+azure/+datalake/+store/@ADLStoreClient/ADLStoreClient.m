classdef ADLStoreClient < azure.object
    % ADLSTORECLIENT Client for the Azure Data Lake
    % Connect to the Azure Data Lake Store and use for an extensible persistence
    % from MATLAB applications. This client will use OAuth2 to connect to the
    % Azure Data Store via the SDK and permit access to the contents in the
    % store.
    %

    % Copyright 2018 The MathWorks, Inc.

    properties
        ClientId = '';
        AuthTokenEndpoint = '';
        ClientKey = '';
        AccountFQDN = '';
        NativeAppId = '';
        AuthOption = azure.datalake.store.AuthenticationOption.SERVICETOSERVICE;
        ConfigFile = '';
    end

    methods
        %% Constructor
        function obj = ADLStoreClient(~, varargin)
            logObj = Logger.getLogger();
            % Logger prefix of Azure Data Lake Store Interface, can be used when catching errors
            logObj.MsgPrefix = 'Azure:DataLake';
            % In normal operation use default level: debug
            % logObj.DisplayLevel = 'verbose';

            % write(logObj,'debug','Creating Data Lake Store Client');
            if ~usejava('jvm')
                write(logObj,'error','MATLAB must be used with the JVM enabled to access Azure');
            end
            if verLessThan('matlab','9.2') % R2017a
                write(logObj,'error','MATLAB Release 2017a or newer is required');
            end

            % Configure log4j if a properties file exists
            % start in <package directory>/matlab-azure-data-lake-storage/Software/MATLAB/app/system/+azure/+datalake/+store/@ADLStoreClient/
            % and move up to <package directory>/matlab-azure-data-lake-storage/Software/MATLAB
            basePath = fileparts(fileparts(fileparts(fileparts(fileparts(fileparts(fileparts(mfilename('fullpath'))))))));
            % append the properties file location and configure it
            log4jPropertiesPath = fullfile(basePath, 'lib', 'jar', 'log4j.properties');
            if exist(log4jPropertiesPath, 'file') == 2
                org.apache.log4j.PropertyConfigurator.configure(log4jPropertiesPath);
            end

        end
    end


    methods
        function tf = delete(obj, varargin)
            % DELETE Method to delete an Azure Data Lake file or directory
            % True is returned if the call succeeds.
            %
            % Example:
            %   % Delete file /my/path/to/file1.mat
            %   tf = dlClient.delete('/my/path/to/file1.mat');
            %

            % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            % To support automated documentation generation via the
            % generateApiDoc.m script a separate delete.m file is
            % maintained with just the help header. Otherwise the file is
            % ignored and contains no functional code.
            % ANY UPDATES TO THE ABOVE MUST ALSO BE MADE TO THAT FILE
            % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

            % Defining delete here is required to permit the following
            % syntax: tf = dlClient.delete('mypath')
            % Ordinarily defining this in a separate file will fail as it
            % will not override the inherited handle delete method, one can
            % define the delete method as static but then the consistent
            % tf = dlClient.delete('mypath') syntax will fail as the
            % dlClient object is not passed to the object and one would
            % need to do tf = dlClient.delete(dlClient,'mypath')
            % explicitly.
            %
            % To understand further why this is necessary see:
            % doc Methods / Methods in Separate Files / delete
            %

            % Create a logger object
            logObj = Logger.getLogger();

            % validate input
            p = inputParser;
            p.CaseSensitive = false;
            p.FunctionName = 'delete';
            % pathval is optional as maybe calling destructor
            addOptional(p,'pathval',[],@ischar);
            parse(p,varargin{:});
            pathval = p.Results.pathval;

            if isempty(pathval)
                % call destructor on the object
                tf = true;
            else
                % there is a path string so call the Handle delete method to
                % delete the ADL file or directory referred to
                write(logObj,'verbose',['Deleting: ',pathval]);
                tf = obj.Handle.delete(pathval);
            end

        end
    end

end %class
