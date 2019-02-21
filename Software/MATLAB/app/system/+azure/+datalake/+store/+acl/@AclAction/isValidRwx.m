function tf = isValidRwx(rwx)
% ISVALIDRWX Checks if a string is a valid rwx permission string
% Leading and trailing white space and mixed case are ignored.
% true is returned for valid inputs and false for invalid inputs.
%
% Example:
%       % Test a valid value
%       tf = azure.datalake.store.acl.AclAction.isValidRwx('-W-');
%       % Test an invalid value
%       tf = azure.datalake.store.acl.AclAction.isValidRwx('-W');

% Copyright 2018 The MathWorks, Inc.

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'isValidRwx';
addRequired(p,'rwx',@ischar);
parse(p,rwx);

rwx = lower(strtrim(rwx));

if strcmp(rwx,'rwx') || ...
        strcmp(rwx,'rw-') || ...
        strcmp(rwx,'r-x') || ...
        strcmp(rwx,'r--') || ...
        strcmp(rwx,'-wx') || ...
        strcmp(rwx,'-w-') || ...
        strcmp(rwx,'--x') || ...
        strcmp(rwx,'---')
    tf = true;
else
    tf = false;
end

end
