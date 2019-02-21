function aclEntry = parseAclEntry(entryString, varargin)
% PARSEACLENTRY Parses an aclEntry from its POSIX string form
% Parses an aclEntry from its POSIX string form. For example:
% 'default:user:bob:r-x'
% If the ACL string will be used to remove an existing ACL from a file or
% folder, then the permission level does not need to be specified. Passing
% false to the removeAcl argument tells the parser to accept such strings.
%
% Example:
%       removeAcl = false;
%       myAclEntry = azure.datalake.store.acl.AclEntry(...
%                          'default:user:bob:r-x',...
%                          removeAcl);

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.acl.AclEntry;

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'parseAclEntry';
addRequired(p,'entryString',@ischar);
validationFcn = @(x) islogical(x) && iscalar(x);
addOptional(p,'removeAcl',[],validationFcn);
parse(p,entryString,varargin{:});

removeAcl = p.Results.removeAcl;

% use the com.microsoft.azure.datalake.store.acl.AclEntry.parseAclEntry
% static method to convert the string and return a java aclEntry
if isempty(removeAcl)
    aclEntryJ = com.microsoft.azure.datalake.store.acl.AclEntry.parseAclEntry(entryString);
else
    aclEntryJ = com.microsoft.azure.datalake.store.acl.AclEntry.parseAclEntry(entryString,removeAcl);
end

% convert the java aclEntry to a MATLAB aclEntry
aclEntry = azure.datalake.store.acl.AclEntry.aclEntryConv(aclEntryJ);

end %function
