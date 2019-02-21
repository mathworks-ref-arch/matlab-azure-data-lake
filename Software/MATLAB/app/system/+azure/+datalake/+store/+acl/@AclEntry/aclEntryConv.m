function aclEntry = aclEntryConv(aclEntryJ)
% ACLENTRYCONV Convert a Java ACL Entry object to MATLAB ACL Entry object
% Accepts input of type com.microsoft.azure.datalake.store.acl.AclEntry
% and returns an equivalent object of type azure.datalake.store.acl.AclEntry
%

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.acl.AclEntry;

% Create a logger object
logObj = Logger.getLogger();

if ~isa(aclEntryJ,'com.microsoft.azure.datalake.store.acl.AclEntry')
    write(logObj,'error','Error invalid input argument type');
end

% extract the scope to a MATLAB scope
switch char(aclEntryJ.scope.toString())
    case 'ACCESS'
        scope = azure.datalake.store.acl.AclScope.ACCESS;
    case 'DEFAULT'
        scope = azure.datalake.store.acl.AclScope.DEFAULT;
    otherwise
        write(logObj,'error','Error invalid ACL Scope');
end

switch char(aclEntryJ.type.toString())
    case 'USER'
        type = azure.datalake.store.acl.AclType.USER;
    case 'GROUP'
        type = azure.datalake.store.acl.AclType.GROUP;
    case 'OTHER'
        type = azure.datalake.store.acl.AclType.OTHER;
    case 'MASK'
        type = azure.datalake.store.acl.AclType.MASK;
    otherwise
        write(logObj,'error','Error invalid ACL Type');
end

switch char(aclEntryJ.action.toString())
    case 'rwx'
        action = azure.datalake.store.acl.AclAction.ALL;
    case '--x'
        action = azure.datalake.store.acl.AclAction.EXECUTE;
    case '---'
        action = azure.datalake.store.acl.AclAction.NONE;
    case 'r--'
        action = azure.datalake.store.acl.AclAction.READ;
    case 'r-x'
        action = azure.datalake.store.acl.AclAction.READ_EXECUTE;
    case 'rw-'
        action = azure.datalake.store.acl.AclAction.READ_WRITE;
    case '-w-'
        action = azure.datalake.store.acl.AclAction.WRITE;
    case '-wx'
        action = azure.datalake.store.acl.AclAction.WRITE_EXECUTE;
    otherwise
        write(logObj,'error',['Error invalid ACL Action: ', char(aclEntryJ.action.toString())]);
end

name = char(aclEntryJ.name);

% create the MATLAB entry
aclEntry = azure.datalake.store.acl.AclEntry(scope, type, name, action);

end %function
