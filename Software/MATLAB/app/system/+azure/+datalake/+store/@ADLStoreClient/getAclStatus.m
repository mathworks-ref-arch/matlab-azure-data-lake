function  status = getAclStatus(obj, pathval, varargin)
% GETACLSTATUS Queries the ACLs and permissions for a file or directory
% An object of type azure.datalake.store.acl.AclStatus is returned.
%
% Example:
%   aclStat = dlClient.getAclStatus(dirName, azure.datalake.store.UserGroupRepresentation.UPN);
%

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'getAclStatus';
addRequired(p,'pathVal',@ischar);
validationFcn = @(x) isa(x, 'azure.datalake.store.UserGroupRepresentation');
addOptional(p,'oidOrUpn',[],validationFcn);
parse(p,pathval,varargin{:});

oidOrUpn = p.Results.oidOrUpn;

if isempty(oidOrUpn)
    statusJ = obj.Handle.getAclStatus(string(pathval));
else
    if oidOrUpn == azure.datalake.store.UserGroupRepresentation.OID
        statusJ = obj.Handle.getAclStatus(string(pathval),com.microsoft.azure.datalake.store.UserGroupRepresentation.OID);
    elseif oidOrUpn == azure.datalake.store.UserGroupRepresentation.UPN
        statusJ = obj.Handle.getAclStatus(string(pathval),com.microsoft.azure.datalake.store.UserGroupRepresentation.UPN);
    else
        write(logObj,'error','Error invalid UserGroupRepresentation type');
        statusJ = obj.Handle.getAclStatus(string(pathval),com.microsoft.azure.datalake.store.UserGroupRepresentation.OID);
    end
end

aclEntries =  azure.datalake.store.acl.AclEntry.aclEntryListToCellArray(statusJ.aclSpec);

status = azure.datalake.store.acl.AclStatus(aclEntries,char(statusJ.group),char(statusJ.octalPermissions),char(statusJ.owner),statusJ.stickyBit);

end %function
