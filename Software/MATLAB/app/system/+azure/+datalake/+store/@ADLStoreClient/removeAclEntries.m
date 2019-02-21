function removeAclEntries(obj, pathVal, aclSpec)
% REMOVEACLENTRIES Removes the specified ACL entries from a file or directory
%
% Example:
%   dlClient.removeAclEntries('myPath/myMatFile.mat', myAclSpec)
%

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;
import com.microsoft.azure.datalake.store.acl.AclEntry;


% Create a logger object
% logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'removeAclEntries';
addRequired(p,'pathVal',@ischar);
aclSpecValid = @(x) iscell(x);
addRequired(p,'aclSpec',aclSpecValid);
parse(p,pathVal,aclSpec);

aclSpecJ = java.util.ArrayList();
for n = 1:numel(aclSpec)
    aclSpecJ.add(aclSpec{n}.Handle);
end

obj.Handle.removeAclEntries(pathVal, aclSpecJ);

end %function
