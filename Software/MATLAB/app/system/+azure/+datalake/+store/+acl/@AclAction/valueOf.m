function aclActionEnum = valueOf(name)
% VALUEOF Returns the enum constant of the type specified by name
% false is returned if an invalid name is given.
%
% Example:
%       myAclActionEnum = azure.datalake.store.acl.AclAction.valueOf('WRITE')

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'valueOf';
addRequired(p,'name',@ischar);
parse(p,name);

name = upper(strtrim(name));

switch name
    case 'ALL'
        aclActionEnum = azure.datalake.store.acl.AclAction.ALL;
    case 'EXECUTE'
        aclActionEnum = azure.datalake.store.acl.AclAction.EXECUTE;
    case 'WRITE'
        aclActionEnum = azure.datalake.store.acl.AclAction.WRITE;
    case 'WRITE_EXECUTE'
        aclActionEnum = azure.datalake.store.acl.AclAction.WRITE_EXECUTE;
    case 'READ'
        aclActionEnum = azure.datalake.store.acl.AclAction.READ;
    case 'READ_EXECUTE'
        aclActionEnum = azure.datalake.store.acl.AclAction.READ_EXECUTE;
    case 'READ_WRITE'
        aclActionEnum = azure.datalake.store.acl.AclAction.READ_WRITE;
    case 'NONE'
        aclActionEnum = azure.datalake.store.acl.AclAction.NONE;
    otherwise
        write(logObj,'error',['Invalid ACL Action name: ',name]);
end

end
