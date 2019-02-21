function tf = checkAccess(obj, pathval, permission)
% CHECKACCESS Check if user has file or directory access permissions
% The permission to check for should be in rwx string form. The call returns
% true if the caller has all the requested permissions. For example, specifying
% 'r-x' succeeds if the caller has read and execute permissions.
% True is returned if the call succeeds otherwise false.
%
% Example:
%   dlClient.checkAccess('/my/path/to/file1.mat','r-x');
%

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
% logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'checkAccess';
addRequired(p,'pathval',@ischar);
addRequired(p,'permission',@ischar);
parse(p,pathval, permission);

tf = obj.Handle.checkAccess(pathval, permission);

end
