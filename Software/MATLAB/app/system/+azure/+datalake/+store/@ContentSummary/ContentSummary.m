classdef ContentSummary < azure.object
    % CONTENTSUMMARY Contains the return values from getContentSummary call
    %

    % Copyright 2018 The MathWorks, Inc.

    properties (SetAccess=immutable)
        directoryCount = int64(0);
        fileCount = int64(0);
        length = int64(0);
        spaceConsumed = int64(0);
    end

    methods
        %% constructor
        function obj = ContentSummary(directoryCount, fileCount, length, spaceConsumed)
            obj.directoryCount = int64(directoryCount);
            obj.fileCount = int64(fileCount);
            obj.length = int64(length);
            obj.spaceConsumed = int64(spaceConsumed);
        end %function
    end %methods
end %class
