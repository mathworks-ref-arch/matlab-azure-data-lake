function setPermission(obj, filename, permission)
% SETPERMISSION Sets the Octal Permissions on a file
%
% Example:
%   dlClient = azure.datalake.store.ADLStoreClient;
%   dlClient.initialize();
%   dlClient.setPermission('myMatFile.mat','744')
%

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;


% Create a logger object
%logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'setPermission';
addRequired(p,'filename',@ischar);
addRequired(p,'permission',@ischar);
parse(p,filename,permission);

obj.Handle.setPermission(filename, permission);

end
