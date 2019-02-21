function aclActionEnum = fromOctal(perm)
% FROMOCTAL Returns an AclAction enum corresponding to an octal digit
% false is returned in the case of invalid input.
%
% Example:
%       % set and aclAction enum to ALL (i.e. rwx)
%       myAclEnum = azure.datalake.store.acl.AclAction.fromOctal(7);

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'fromOctal';
validatePerm = @(x) isscalar(x) && isnumeric(x);
addRequired(p,'perm',validatePerm);
parse(p,perm);

permi = int32(perm);

switch permi
    case 7
        aclActionEnum = azure.datalake.store.acl.AclAction.ALL;
    case 6
        aclActionEnum = azure.datalake.store.acl.AclAction.READ_WRITE;
    case 5
        aclActionEnum = azure.datalake.store.acl.AclAction.READ_EXECUTE;
    case 4
        aclActionEnum = azure.datalake.store.acl.AclAction.READ;
    case 3
        aclActionEnum = azure.datalake.store.acl.AclAction.WRITE_EXECUTE;
    case 2
        aclActionEnum = azure.datalake.store.acl.AclAction.WRITE;
    case 1
        aclActionEnum = azure.datalake.store.acl.AclAction.EXECUTE;
    case 0
        aclActionEnum = azure.datalake.store.acl.AclAction.NONE;
    otherwise
        write(logObj,'error',['Invalid octal permission value, expected 0-7: ' num2str(permi)]);
        aclActionEnum = false;
end

end
