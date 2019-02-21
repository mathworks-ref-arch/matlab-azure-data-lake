classdef DirectoryEntryType < azure.object
    % DIRECTORYENTRYTYPE specifies if a directory entry is a file or directory
    %   FILE      : directory entry is a file
    %   DIRECTORY : directory entry is a directory

    % Copyright 2018 The MathWorks, Inc.

    enumeration
        DIRECTORY
        FILE
    end

end %class
