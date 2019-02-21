function setFilePathPrefix(obj, prefix)
% SETFILEPATHPREFIX Set a prefix that will be prepended to all file paths
% This allows the client to be scoped to a subset of the directory Azure Data
% Lake Store tree.
%
% Example:
%       myStoreOptions.setFilePathPrefix('mypathprefix');

% Copyright 2018 The MathWorks, Inc.


% Create a logger object
logObj = Logger.getLogger();

if ischar(prefix)
    obj.Handle.setFilePathPrefix(prefix);
else
    write(logObj,'error','Error invalid prefix type');
end

end %function
