function aclStr = aclListToString(aclEntryList, varargin)
% ACLLISTTOSTRING Convert an aclEntries cell array to a POSIX aclspec string
% If the aclspec string will be used to remove an existing ACL from a file
% or folder, then the permission level does not need to be specified.
% Passing true as a removeAcl argument omits the permission level in the
% output string. The string is returned as a character vector.
%
% Example:
%       removeAcl = true;
%       myPosixStr = azure.datalake.store.acl.AclEntry.aclListToString(...
%                           myAclEntryCellArray,...
%                           removelAcl);

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.acl.AclEntry;

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'aclListToString';
% check it is a cell array and that the first entry is an aclEntry
validationFcnList = @(x) iscell(x) && ~isempty(x) && isa(x{1}, 'azure.datalake.store.acl.AclEntry');
addRequired(p,'aclEntryList', validationFcnList);
validationFcnRemove = @(x) islogical(x) && isscalar(x);
% removeAcl argument omits the permission level in the output string
addOptional(p,'removeAcl',[],validationFcnRemove);
parse(p,aclEntryList,varargin{:});

removeAcl = p.Results.removeAcl;

% build a java list using aclEntry Handle java objects
aclEntryListJ = java.util.ArrayList();
for n = 1:numel(aclEntryList)
    aclEntryListJ.add(aclEntryList{n}.Handle);
end

% pass this list to the com.microsoft.azure.datalake.store.acl.AclEntry.aclListToString static method
if isempty(removeAcl)
    aclStr = com.microsoft.azure.datalake.store.acl.AclEntry.aclListToString(aclEntryListJ);
else
    aclStr = com.microsoft.azure.datalake.store.acl.AclEntry.aclListToString(aclEntryListJ, removeAcl);
end

aclStr = char(aclStr);

end %function
