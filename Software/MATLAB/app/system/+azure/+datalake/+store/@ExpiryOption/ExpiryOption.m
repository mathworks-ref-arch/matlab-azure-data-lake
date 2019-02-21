classdef ExpiryOption < azure.object
    % EXPIRYOPTION Specifies how to interpret an expiry time in a setExpiry call
    %   ABSOLUTE  : Interpret as date/time
    %   NEVEREXPIRE : No expiry
    %   RELATIVETOCREATIONDATE : Interpret as milliseconds from the file's creation date+time
    %   RELATIVETONOW : Interpret as milliseconds from now
    %

    % Copyright 2017 The MathWorks, Inc.

    enumeration
        ABSOLUTE
        NEVEREXPIRE
        RELATIVETOCREATIONDATE
        RELATIVETONOW
    end

end %class
