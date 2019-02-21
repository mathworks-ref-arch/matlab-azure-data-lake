function setOwner(obj, filename, owner, group)
% SETOWNER Sets the owner and group of a file
% To change either the user or group but leave one value unchanged pass an
% empty character vector '' for that value. Both values cannot be ''.
%
% Example:
%   dlClient.setOwner('myPath/myMatFile.mat','OwnerID','GroupID')
%
% Note, setting the ownership of a file or directory requires superuser
% privileges for the Data Lake store. Ownership can only be changed by the
% account owner, not by the owner of a given file or directory.
% To check ownership in the Data Lake store account in the Azure portal
% click on Access Control. The user should be listed and the role should
% say "Owner".
%
% This methods can only be used with End User based authentication.
%

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;


% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'setOwner';
addRequired(p,'filename',@ischar);
addRequired(p,'owner',@ischar);
addRequired(p,'group',@ischar);
parse(p,filename,owner,group);

if isempty(owner) && isempty(group)
    write(logObj,'error','Both the owner and group cannot be empty');
else
    % if owner is '' set to [] so that a null is passed rather than
    % an empty string, do the same for group
    if isempty(owner)
        ownerJ = [];
    else
        ownerJ = owner;
    end

    if isempty(group)
        groupJ = [];
    else
        groupJ = group;
    end

    obj.Handle.setOwner(filename, ownerJ, groupJ);

end

end
