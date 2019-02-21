function setAcl(obj, pathVal, aclEntries)
% SETACL Sets the ACLs for a file or directory
% If the file or directory already has any ACLs associated with it, then all the
% existing ACLs are removed before adding the specified ACLs. aclSpecs is a
% cell array of aclEntry objects.
%
% Example:
%   aclString = 'user:myemail@mycompany.com:rwx, group::rwx, other::r--';
%   aclEntries = azure.datalake.store.acl.AclEntry.parseAclSpec(aclString);
%   dlClient.setAcl('myPath/myMatFile.mat', aclEntries);
%
%  **********************************************************************
%  *
%  * There is a known issue with the setting of some ACLs, validate ACLs
%  % are applied via the Azure portal
%  *
%  **********************************************************************
%

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;
import com.microsoft.azure.datalake.store.acl.AclEntry;


% Create a logger object
% logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'setAcl';
addRequired(p,'pathVal',@ischar);
aclSpecValid = @(x) iscell(x);
addRequired(p,'aclEntries',aclSpecValid);
parse(p,pathVal,aclEntries);


aclEntryListJ = java.util.ArrayList();
for n = 1:numel(aclEntries)
    aclEntryListJ.add(aclEntries{n}.Handle);
end

obj.Handle.setAcl(pathVal, aclEntryListJ);

%try
%  obj.Handle.setAcl(pathVal, aclEntryListJ);
%catch e
%  e.message
%  if(isa(e,'matlab.exception.JavaException'))
%    ex = e.ExceptionObject;
%    assert(isjava(ex));
%    ex.printStackTrace;
%  end
%end

end
