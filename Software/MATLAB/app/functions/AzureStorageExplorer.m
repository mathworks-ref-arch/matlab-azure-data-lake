function AzureStorageExplorer(varargin)
% AZURESTORAGEEXPLORER Invokes the Azure Storage Explorer
% Launches the Azure Storage Explorer. It is possible to specify the local
% installation of the storage explorer in the configuration file.

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% Locate the path
configFile = which('cloudstorageaccount.json');

if exist(configFile,'file')==2
    % Read the config file
    config = jsondecode(fileread(configFile));

    if isfield(config, 'LocalPathToStorageExplorer')
        % Storage explorer is at:
        sePath = config.LocalPathToStorageExplorer;

        % Check if we are good to go
        if exist(sePath,'file')==2
            % attempt to start storage explorer
            system([config.LocalPathToStorageExplorer, ' &']);
        else
            write(logObj,'error',['Storage explorer not found at path: ', sePath]);
        end
    else
        write(logObj,'error','LocalPathToStorageExplorer not set in cloudstorageaccount.json');
    end
else
    write(logObj,'error','cloudstorageaccount.json with Storage Explorer path not found');
end %function
