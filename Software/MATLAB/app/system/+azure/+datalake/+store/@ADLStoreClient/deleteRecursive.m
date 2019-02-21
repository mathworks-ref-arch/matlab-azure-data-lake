function tf = deleteRecursive(obj, pathval)
% DELETERECURSIVE deletes directory and it's child directories and files recursively.
% True is returned if the call succeeds.
%
% Example:
%   dlClient.deleteRecursive('/my/path/to/mydirectory');
%

% Copyright 2017 The MathWorks, Inc.

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'deleteRecursive';
addRequired(p,'pathval',@ischar);
parse(p,pathval);

write(logObj,'verbose',['Deleting recursively: ',pathval]);

tf = obj.Handle.deleteRecursive(pathval);

end
