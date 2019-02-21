function aclEntriesCell = aclEntryListToCellArray(aclEntriesList)
% ACLENTRYLISTTOCELLARRAY Converts an aclEntry list to aclEntry cell array
%
% Example:
%       myAclEntryCellArray = azure.datalake.store.acl.AclEntry.aclEntryListToCellArray(myJavaAclEntryList)

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.acl.AclEntry;

% Create a logger object
logObj = Logger.getLogger();

% parseAclSpec() will pass return a linked list
% getAclStatus() will pass and ArrayList
if ~isa(aclEntriesList, 'java.util.ArrayList') && ~isa(aclEntriesList, 'java.util.LinkedList')
    write(logObj,'error','Error invalid ACL Entry list argument');
end

aclEntriesCell = {};
n = 1;
while (aclEntriesList.iterator.hasNext())
    % pick off each entry as a Java aclEntry
    aclEntryJ = aclEntriesList.iterator.next();
    % convert it and add it to the cell array
    % okay to grow in place as size will always be modest
    aclEntriesCell{n} = azure.datalake.store.acl.AclEntry.aclEntryConv(aclEntryJ); %#ok<AGROW>
    n = n + 1;
    aclEntriesList.remove(0);
end

end %function
