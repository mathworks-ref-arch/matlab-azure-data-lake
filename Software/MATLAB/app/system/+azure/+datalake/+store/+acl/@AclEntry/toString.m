function  str = toString(obj, varargin)
% TOSTRING Returns the POSIX string form of an aclEntry
% A character vector is returned, e.g. 'default:user:bob:r-x'
% If the ACL string will be used to remove an existing ACL from a file or
% folder, then the permission level does not need to be specified.
% Passing true to the removeAcl argument omits the permission level in the
% output string.
%
% Example:
%       removeAcl = true;
%       myPosixStr = myAclEntry.toString();

% Copyright 2017 The MathWorks, Inc.

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'toString';
validationFcn = @(x) islogical(x) && isscalar(x);
addOptional(p,'removeAcl',[],validationFcn);
parse(p,varargin{:});

removeAcl = p.Results.removeAcl;

if isempty(removeAcl)
    str = obj.Handle.toString();
else
    str = obj.Handle.toString(removeAcl);
end

str = char(str);

end %function
