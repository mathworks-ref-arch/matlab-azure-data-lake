function aclActionEnum = fromRwx(rwx)
% FROMRWX Returns AclAction enum corresponding to the rwx permission string
% The input character vector can be upper or lower case and unset fields
% should be set to '-' e.g. 'r-x'. In the case of invlaid input logical
% false is returned.
%
% Example:
%       % set and aclAction enum to WRITE
%       myAclEnum = azure.datalake.store.acl.AclAction.fromRwx('-w-')

% Copyright 2018 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'fromRwx';
addRequired(p,'rwx',@ischar);
parse(p,rwx);

switch lower(strtrim(rwx))
    case 'rwx'
        aclActionEnum = azure.datalake.store.acl.AclAction.ALL;
    case '--x'
        aclActionEnum = azure.datalake.store.acl.AclAction.EXECUTE;
    case '-w-'
        aclActionEnum = azure.datalake.store.acl.AclAction.WRITE;
    case '-wx'
        aclActionEnum = azure.datalake.store.acl.AclAction.WRITE_EXECUTE;
    case 'r--'
        aclActionEnum = azure.datalake.store.acl.AclAction.READ;
    case 'r-x'
        aclActionEnum = azure.datalake.store.acl.AclAction.READ_EXECUTE;
    case 'rw-'
        aclActionEnum = azure.datalake.store.acl.AclAction.READ_WRITE;
    case '---'
        aclActionEnum = azure.datalake.store.acl.AclAction.NONE;
    otherwise
        % in the case of an error don't return an valid enum and give an
        % error message
        write(logObj,'error',['Error invalid rwx value: ', rwx]);
        aclActionEnum = false;
end

end
