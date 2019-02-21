classdef IfExists < azure.object
    % IFEXISTS specifies actions to take if creating a file that already exists.
    %
    %   FAIL      : fail the request
    %   OVERWRITE : overwrite the file

    % Copyright 2017 The MathWorks, Inc.

    enumeration
        FAIL
        OVERWRITE
    end

end %class
