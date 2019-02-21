function aclEntries = parseAclSpec(aclString)
% PARSEACLSPEC Converts a POSIX ACL spec string to aclEntry objects
% Returns a cell array of MATLAB aclEntry objects
%
% Example:
%       user1 = 'user:foo:rw-';
%       user2 = 'user:bar:r--';
%       group1 = 'group::r--';
%       myAclSpec = [user1 ',' user2 ',' group1];
%       aclEntries = azure.datalake.store.acl.AclEntry.parseAclSpec(myAclSpec);

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.acl.AclEntry;

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'parseAclSpec';
addRequired(p,'aclString',@ischar);
parse(p,aclString);

aclEntryListJ = com.microsoft.azure.datalake.store.acl.AclEntry.parseAclSpec(string(aclString));
aclEntries = azure.datalake.store.acl.AclEntry.aclEntryListToCellArray(aclEntryListJ);

end %function
