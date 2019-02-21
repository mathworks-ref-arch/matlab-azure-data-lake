function modifyAclEntries(obj, pathVal, aclSpec)
% MODIFYACLENTRIES Modify the ACL entries for a file or directory
% This call merges the supplied list with existing ACLs. If an entry with the
% same scope, type and user already exists, then the permissions are replaced.
% If not, than an new ACL entry if added.
%
% Example:
%   dlClient.modifyAclEntries('myPath/myMatFile.mat', myAclSpec)
%

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;
import com.microsoft.azure.datalake.store.acl.AclEntry;


% Create a logger object
% logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'modifyAclEntries';
addRequired(p,'pathVal',@ischar);
aclSpecValid = @(x) iscell(x);
addRequired(p,'aclSpec',aclSpecValid);
parse(p,pathVal,aclSpec);

aclSpecJ = java.util.ArrayList();
for n = 1:numel(aclSpec)
    aclSpecJ.add(aclSpec{n}.Handle);
end

obj.Handle.modifyAclEntries(pathVal, aclSpecJ);

end %function
