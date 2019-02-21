classdef DirectoryEntry < azure.object
    % DIRECTORYENTRY Class to represent metadata for directories or files
    % DirectoryEntry objects are returned by calls such as enumerateDirectory
    % and getDirectoryEntry.
    %
    % Examples:
    %   obj = DirectoryEntry(name,fullName,length,group,user,lastAccessTime,...
    %        lastModifiedTime,type,blocksize,replicationFactor,permission,...
    %        aclBit, expiryTime)
    %
    %   myDirEntry = dlClient.getDirectoryEntry('/path/to/myMatFile.mat')
    %

    % Copyright 2017 The MathWorks, Inc.

    properties (SetAccess=immutable)
        name = '';
        fullName = '';
        length = 0;
        group = '';
        user = '';
        lastAccessTime;
        lastModifiedTime;
        type;
        blocksize = 0;
        replicationFactor;
        permission = '';
        aclBit;
        expiryTime;
    end


    methods
        %% Constructor
        function obj = DirectoryEntry(name,fullName,length,group,user,...
                lastAccessTime,lastModifiedTime,type,...
                blocksize,replicationFactor,permission,...
                aclBit, expiryTime)

            import com.microsoft.azure.datalake.store.DirectoryEntry;

            % Create a logger object
            logObj = Logger.getLogger();

            p = inputParser;
            p.CaseSensitive = false;
            p.FunctionName = 'DirectoryEntry';
            addRequired(p,'name',@ischar);
            addRequired(p,'fullName',@ischar);
            longValidationFcn = @(x) (x>=0) && isa(x,'int64') && isscalar(x);
            addRequired(p,'length',longValidationFcn);
            addRequired(p,'group',@ischar);
            addRequired(p,'user',@ischar);
            addRequired(p,'lastAccessTime',@isdatetime);
            addRequired(p,'lastModifiedTime',@isdatetime);
            checkTypeClass = @(x) isa(x,'azure.datalake.store.DirectoryEntryType');
            addRequired(p,'type',checkTypeClass);
            addRequired(p,'blocksize',longValidationFcn);
            blockValidationFcn = @(x) (x>=0) && isa(x,'int32') && isscalar(x);
            addRequired(p,'replicationFactor',blockValidationFcn);
            addRequired(p,'permission',@ischar);
            addRequired(p,'aclBit',@islogical);
            addRequired(p,'expiryTime',@isdatetime);

            parse(p,name,fullName,length,group,user,lastAccessTime,...
                lastModifiedTime,type,blocksize,replicationFactor,permission,...
                aclBit, expiryTime);

            obj.name = p.Results.name;
            obj.fullName  = p.Results.fullName;
            obj.length = p.Results.length;
            obj.group = p.Results.group;
            obj.user = p.Results.user;
            obj.lastAccessTime = p.Results.lastAccessTime;
            obj.lastModifiedTime = p.Results.lastModifiedTime;
            obj.type = p.Results.type;
            obj.blocksize = p.Results.blocksize;
            obj.replicationFactor = p.Results.replicationFactor;
            obj.permission = p.Results.permission;
            obj.aclBit = p.Results.aclBit;
            obj.expiryTime = p.Results.expiryTime;

            %% create the Java DirectoryEntry object
            % this 'may not' be required if nothing uses the Java object as input
            % convert to POSIX time and from seconds to milliseconds to Java Date
            lastAccessTimeJ = java.util.Date(int64(posixtime(obj.lastAccessTime)*1000));
            lastModifiedTimeJ = java.util.Date(int64(posixtime(obj.lastModifiedTime)*1000));
            if isnat(obj.expiryTime)
                expiryTimeJ = [];
            else
                expiryTimeJ = java.util.Date(int64(posixtime(obj.expiryTime)*1000));
            end

            if obj.type == azure.datalake.store.DirectoryEntryType.DIRECTORY
                typeJ = com.microsoft.azure.datalake.store.DirectoryEntryType.DIRECTORY;
            elseif type == azure.datalake.store.DirectoryEntryType.FILE
                typeJ = com.microsoft.azure.datalake.store.DirectoryEntryType.FILE;
            else
                write(logObj,'error','Error invalid directory entry type');
            end

            obj.Handle = com.microsoft.azure.datalake.store.DirectoryEntry...
                (name,fullName,length,group,...
                user,lastAccessTimeJ,lastModifiedTimeJ,typeJ,blocksize,...
                replicationFactor,permission,aclBit,expiryTimeJ);

        end %function
    end %methods
end %class
