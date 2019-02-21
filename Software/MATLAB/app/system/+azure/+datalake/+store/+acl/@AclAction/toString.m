function rwx = toString(action)
% TOSTRING returns the rwx string representation of an AclAction
%
% Example:
%       myRwxStr = azure.datalake.store.acl.AclAction.toString(myAclAction)


% Copyright 2018 The MathWorks, Inc.

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'toString';
validationFcn = @(x) isa(x, 'azure.datalake.store.acl.AclAction');
addRequired(p,'action',validationFcn);
parse(p,action);

switch action.char()
    case 'ALL'
        rwx = 'rwx';
    case 'READ_WRITE'
        rwx = 'rw-';
    case 'READ_EXECUTE'
        rwx = 'r-x';
    case 'READ'
        rwx = 'r--';
    case 'WRITE_EXECUTE'
        rwx = '-wx';
    case 'WRITE'
        rwx = '-w-';
    case 'EXECUTE'
        rwx = '--x';
    case 'NONE'
        rwx = '---';
end

end %function
