function tf = rename(obj, oldName, newName, varargin)
% RENAME Method to rename Azure Data Lake files
% This method will rename a Data Lake file. If the overwrite boolean is%
% true an existing file will be overwritten.
% If the destination is a non-empty directory, then the call fails rather than
% overwrite the directory. True is returned if the call succeeds.
%
% Example:
%   Rename file1.mat to file2.mat overwriting file2 if is already exists
%   dlClient.rename('file1.mat','file2.mat', true)
%

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'rename';
addRequired(p,'oldName',@ischar);
addRequired(p,'newName',@ischar);
checkOverwrite = @(x) isscaler(x) && islogical(x);
addOptional(p,'overwrite',[],checkOverwrite);
parse(p,oldName,newName,varargin{:})
overwrite = p.Results.overwrite;

write(logObj,'verbose',['Renaming ',oldName,' to ',newName]);
if isempty(overwrite)
    tf = obj.Handle.rename(oldName, newName);
else
    tf = obj.Handle.rename(oldName, newName, overwrite);
end
end
