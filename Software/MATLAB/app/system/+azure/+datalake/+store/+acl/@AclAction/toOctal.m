function octInt = toOctal(action)
% TOOCTAL returns the octal representation of an AclAction
% 
% Example:
%       % return the octal value of myAclAction
%       myOctalInt = azure.datalake.store.acl.AclAction.toOctal(myAclAction)

% Copyright 2018 The MathWorks, Inc.

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'toOctal';
validationFcn = @(x) isa(x, 'azure.datalake.store.acl.AclAction');
addRequired(p,'action',validationFcn);
parse(p,action);


switch action.char()
    case 'ALL'
        octInt = 7;
    case 'READ_WRITE'
        octInt = 6;
    case 'READ_EXECUTE'
        octInt = 5;
    case 'READ'
        octInt = 4;
    case 'WRITE_EXECUTE'
        octInt = 3;
    case 'WRITE'
        octInt = 2;
    case 'EXECUTE'
        octInt = 1;
    case 'NONE'
        octInt = 0;
        
end


end %function
