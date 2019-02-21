function tf = createDirectory(obj, dirPath, varargin)
% CREATEDIRECTORY Creates a directory and parent directories as required.
%
% Example:
%   dlClient.createDirectory('myMatFiles')
%
%   % Or create a file with specific octal permissions
%   dlClient.createDirectory('myMatFiles', '744')
%

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
 logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'createDirectory';
addRequired(p,'dirPath',@ischar);
addOptional(p,'permissions','',@ischar);
parse(p,dirPath,varargin{:});
permissions = p.Results.permissions;

write(logObj,'verbose',['Creating directory: ',dirPath]);
if isempty(permissions)
    tf = obj.Handle.createDirectory(dirPath);
else
    tf = obj.Handle.createDirectory(dirPath, permissions);
end

end
