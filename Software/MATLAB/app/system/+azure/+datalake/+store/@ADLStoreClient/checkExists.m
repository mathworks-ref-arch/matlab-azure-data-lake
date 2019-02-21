function tf = checkExists(obj, filename)
% CHECKEXISTS Checks that a file or directory exists.
% Returns true if it exists otherwise false
%
% Example:
%   dlClient.checkExists('file1.mat');
%

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
logObj = Logger.getLogger();

if ~ischar(filename)
    write(logObj,'warning','Invalid argument');
    tf = false;
else
    tf = obj.Handle.checkExists(filename);
end

end
