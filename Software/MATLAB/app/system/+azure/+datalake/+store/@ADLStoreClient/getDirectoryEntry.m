function dirEntry = getDirectoryEntry(obj, pathval, varargin)
% GETDIRECTORYENTRY Gets the directory metadata about a file or directory
%
% Example:
%   myDirEntry = dlClient.getDirectoryEntry('/path/to/myMatFile.mat')
% or
%   myDirEntry = dlClient.getDirectoryEntry('/path/to/myMatFile.mat',UGRType)
%

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;
import com.microsoft.azure.datalake.store.DirectoryEntry;
import com.microsoft.azure.datalake.store.UserGroupRepresentation;

% Create a logger object
logObj = Logger.getLogger();

p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'getDirectoryEntry';
addRequired(p,'name',@ischar);
validationFcn = @(x) isa(x, 'azure.datalake.store.UserGroupRepresentation');
addOptional(p,'oidOrUpn',[],validationFcn);
parse(p,pathval,varargin{:});

oidOrUpn = p.Results.oidOrUpn;

if isempty(oidOrUpn)
    dej = obj.Handle.getDirectoryEntry(string(pathval));
else
    if oidOrUpn == azure.datalake.store.UserGroupRepresentation.OID
        dej = obj.Handle.getDirectoryEntry(string(pathval),com.microsoft.azure.datalake.store.UserGroupRepresentation.OID);
    elseif oidOrUpn == azure.datalake.store.UserGroupRepresentation.UPN
        dej = obj.Handle.getDirectoryEntry(string(pathval),com.microsoft.azure.datalake.store.UserGroupRepresentation.UPN);
    else
        write(logObj,'error','Error invalid UserGroupRepresentation type');
        dej = obj.Handle.getDirectoryEntry(string(pathval),com.microsoft.azure.datalake.store.UserGroupRepresentation.OID);
    end
end

lastModifiedTime = datetime(dej.lastModifiedTime.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');
lastAccessTime = datetime(dej.lastAccessTime.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');

if isempty(dej.expiryTime)
    expiryTime = NaT;
else
    expiryTime = datetime(dej.expiryTime.getTime()/1000,'convertfrom','posixtime','TimeZone','UTC');
end

if strcmp(dej.type.toString(),'FILE')
    typeval = azure.datalake.store.DirectoryEntryType.FILE;
elseif strcmp(dej.type.toString(),'DIRECTORY')
    typeval = azure.datalake.store.DirectoryEntryType.DIRECTORY;
else
    % enum handling so should not get here
    write(logObj,'error',['Invalid DirectoryEntryType: ', dej.type.toString()]);
    typeval = azure.datalake.store.DirectoryEntryType.FILE;
end

dirEntry = azure.datalake.store.DirectoryEntry(...
    char(dej.name),...
    char(dej.fullName),...
    int64(dej.length),...
    char(dej.group),...
    char(dej.user),...
    lastAccessTime,...
    lastModifiedTime,...
    typeval,...
    int64(dej.blocksize),...
    int32(dej.replicationFactor),...
    char(dej.permission),...
    dej.aclBit,...
    expiryTime...
    );

end
