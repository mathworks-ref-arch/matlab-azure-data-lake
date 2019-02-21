function removeDefaultAcls(obj, dirPath)
% REMOVEDEFAULTACLS Removes all default ACL entries from a directory
%
% Example:
%   dlClient.removeDefaultAcls('/my/directory/path')
%

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'removeDefaultAcls';
validatedirPath = @(x) ischar(x) && ~isempty(x);
addRequired(p,'dirPath',validatedirPath);
parse(p,dirPath)

write(logObj,'verbose',['Removing default Acls for: ',dirPath]);
obj.Handle.removeDefaultAcls(dirPath);

end
