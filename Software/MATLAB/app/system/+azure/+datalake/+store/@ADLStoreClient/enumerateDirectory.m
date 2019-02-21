function [varargout] = enumerateDirectory(obj, pathval, varargin)
% ENUMERATEDIRECTORY List of DirectoryEntry objects for the specified directory
% Enumerates the contents of a directory, returning a table of directory
% object metadata, one row per file or directory in the specified directory.
% To avoid overwhelming the client or the server, the call may return a
% partial list. A number of options exist to control the number of entries
% returned. Arguments other than the path value are parameterised. If a directory
% contains no files or directories an empty table is returned.
%
% Examples:
%   dirTable = dlClient.enumerateDirectory('/mydirectory')
%       Where /mydirectory is the path to the directory to enumerate
%
%   rep = azure.datalake.store.UserGroupRepresentation.UPN;
%   dirTable = enumerateDirectory('/mydirectory', 'UserGroupRepresentation', rep)
%       Where  myUserGroupRepresentation is a UserGroupRepresentation
%       enumeration specifying whether to return user and group information
%       as OID or UPN.
%
%   dirTable = enumerateDirectory('/mydirectory', 'maxEntriesToRetrieve', 10)
%       Where 10 is the maximum number of entries to retrieve. Note
%       that server can limit the number of entries retrieved to a number
%       smaller than the number specified.
%
%   dirTable = enumerateDirectory('/mydirectory', 'startAfter', 'FilenameABC')
%       Where FilenameABC is the filename after which to begin enumeration.
%
%   dirTable = enumerateDirectory('/mydirectory', 'maxEntriesToRetrieve', 10,...
%        'startAfter', 'FilenameABC')
%
%   dirTable = enumerateDirectory('/mydirectory', 'startAfter', 'FilenameABC',
%        'endBefore', 'FilenameXYZ')
%       Where FilenameXYZ is the filename before which to end the enumeration.
%
%   rep = azure.datalake.store.UserGroupRepresentation.OID
%   dirTable = enumerateDirectory('/mydirectory', 'maxEntriesToRetrieve', 10,...
%       'startAfter', 'FilenameABC', 'UserGroupRepresentation', rep)
%
%   *******************************************************************
%   *
%   * Note: due to an issue with the underlying Azure SDK the endBefore
%   * argument is not currently functional, instead rely on
%   * startAfter and maxEntriesToRetrieve
%   *
%   *******************************************************************

% endBefore is effectively ignored by the Azure SDK

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'enumerateDirectory';
addRequired(p,'pathval',@ischar);

maxValidationFcn = @(x) (x>=0) && isnumeric(x) && isscalar(x);
addParameter(p,'maxEntriesToRetrieve',[],maxValidationFcn);
addParameter(p,'startAfter','',@ischar);
addParameter(p,'endBefore','',@ischar);
UGRValidationFcn = @(x) isa(x, 'azure.datalake.store.UserGroupRepresentation');
addParameter(p,'UserGroupRepresentation',[],UGRValidationFcn);
parse(p,pathval, varargin{:});

maxEntries = int32(p.Results.maxEntriesToRetrieve);
startAfter = p.Results.startAfter;
endBefore = p.Results.endBefore;
UGR = p.Results.UserGroupRepresentation;


% create a java UGR enum if using UGR
if ~isempty(UGR)
    if UGR == azure.datalake.store.UserGroupRepresentation.UPN
        UGRJ = com.microsoft.azure.datalake.store.UserGroupRepresentation.UPN;
    elseif UGR == azure.datalake.store.UserGroupRepresentation.OID
        UGRJ = com.microsoft.azure.datalake.store.UserGroupRepresentation.OID;
    else
        write(logObj,'error','Error invalid UserGroupRepresentation');
    end
end


% pathval must always have a value, otherwise call the appropriate form
if isempty(maxEntries) && isempty(startAfter) && isempty(endBefore) && isempty(UGR)
    LDE = obj.Handle.enumerateDirectory(string(pathval));

elseif isempty(maxEntries) && isempty(startAfter) && isempty(endBefore) && ~isempty(UGR)
    LDE = obj.Handle.enumerateDirectory(string(pathval),UGRJ);

elseif ~isempty(maxEntries) && isempty(startAfter) && isempty(endBefore) && isempty(UGR)
    LDE = obj.Handle.enumerateDirectory(string(pathval),maxEntries);

elseif isempty(maxEntries) && ~isempty(startAfter) && isempty(endBefore) && isempty(UGR)
    LDE = obj.Handle.enumerateDirectory(string(pathval),string(startAfter));

elseif isempty(maxEntries) && ~isempty(startAfter) && ~isempty(endBefore) && isempty(UGR)
    LDE = obj.Handle.enumerateDirectory(string(pathval),string(startAfter),string(endBefore));

elseif ~isempty(maxEntries) && ~isempty(startAfter) && isempty(endBefore) && isempty(UGR)
    LDE = obj.Handle.enumerateDirectory(string(pathval),maxEntries,string(startAfter));

elseif  ~isempty(maxEntries) && ~isempty(startAfter) && ~isempty(endBefore) && isempty(UGR)
    LDE = obj.Handle.enumerateDirectory(string(pathval),maxEntries,string(startAfter),string(endBefore));

elseif  ~isempty(maxEntries) && ~isempty(startAfter) && ~isempty(endBefore) && ~isempty(UGR)
    LDE = obj.Handle.enumerateDirectory(string(pathval),maxEntries,string(startAfter),string(endBefore),UGRJ);
else
    write(logObj,'error','Error invalid arguments');
end


dCount = 0; % a counter/index for the directories
while (LDE.iterator.hasNext())
    % there is a directory to process, take an entry and increment the counter
    dej = LDE.iterator.next();
    dCount = dCount+1;

    % Get the table entries for this iteration
    % Does not use Java 8 Java.time package
    eName(dCount) = {char(dej.name)}; %#ok<AGROW>
    eFullName(dCount) = {char(dej.fullName)}; %#ok<AGROW>
    eLength(dCount) = {dej.length}; %#ok<AGROW>
    eGroup(dCount) = {char(dej.group)}; %#ok<AGROW>
    eUser(dCount) = {char(dej.user)}; %#ok<AGROW>

    % convert java times from ms to s using posix time
    eLastAccessTime(dCount) = {datetime(dej.lastAccessTime.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC')}; %#ok<AGROW>
    eLastModifiedTime(dCount) = {datetime(dej.lastModifiedTime.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC')}; %#ok<AGROW>

    if strcmp(dej.type.toString(),'FILE')
        eType(dCount) = {azure.datalake.store.DirectoryEntryType.FILE}; %#ok<AGROW>
    elseif strcmp(dej.type.toString(),'DIRECTORY')
        eType(dCount) = {azure.datalake.store.DirectoryEntryType.DIRECTORY}; %#ok<AGROW>
    else
        % enum handling so should not get here
        write(logObj,'error',['Invalid type: ', dej.type.toString()]);
    end

    eBlocksize(dCount) = {dej.blocksize}; %#ok<AGROW>
    eReplicationFactor(dCount) = {dej.replicationFactor}; %#ok<AGROW>
    ePermission(dCount) = {char(dej.permission)}; %#ok<AGROW>
    % A boolean
    eAclBit(dCount) = {dej.aclBit}; %#ok<AGROW>

    if isempty(dej.expiryTime)
        eExpiryTime(dCount) = {NaT}; %#ok<AGROW>
    else
        eExpiryTime(dCount) = {datetime(dej.expiryTime.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC')}; %#ok<AGROW>
    end

    % Pop the owner from the array
    LDE.remove(0); % Java uses 0 based indexing
end

% Create a MATLAB table from the results, if directory is empty return an
% empty table
if dCount > 0
    bucketTable = table(...
        eName',...
        eFullName',...
        eLength',...
        eGroup',...
        eUser',...
        eLastAccessTime',...
        eLastModifiedTime',...
        eType',...
        eBlocksize',...
        eReplicationFactor',...
        ePermission',...
        eAclBit',...
        eExpiryTime',...
        'VariableNames',{...
        'Name',...
        'FullName',...
        'Length',...
        'Group',...
        'User',...
        'LastAccessTime',...
        'LastModified',...
        'Type',...
        'Blocksize',...
        'ReplicationFactor',...
        'Permission',...
        'AclBit',...
        'ExpiryTime'
        });
else
    bucketTable = table;
end


% Return table as an output or display the table
if nargout == 1
    varargout{1} = bucketTable;
else
    % TODO write a table to logger output function
    % test:
    % y = evalc('disp(bucketTable)');
    % write(logObj,'error',y);

    disp(bucketTable);
end

end
