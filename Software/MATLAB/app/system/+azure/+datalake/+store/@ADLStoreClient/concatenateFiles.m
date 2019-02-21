function tf = concatenateFiles(obj, pathVal, fileList)
% CONCATENATEFILES Concatenate the specified list of files into this file.
% The target should not exist. The source files will be deleted if the
% concatenate succeeds. Returns true if the call succeeds. pathVal is the full
% pathname of the destination to concatenate files into and fileList is cell
% array of character vectors containing full pathnames of the files to
% concatenate. This cannot be empty.
%
% Example:
%   % create a cellstr array listing paths
%   myFileList = cellstr({'/my/path1/file1.txt','/my/path2/file2.txt'});
%   tf = dlClient.concatentateFiles('/destination/path/output.txt',myFileList);
%

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
%logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'concatentateFiles';
validatePathVal = @(x) ischar(x) && ~isempty(x);
addRequired(p,'pathVal',validatePathVal);
% accepting character vectors only
validateFileList = @(x) iscellstr(x) && ~isempty(x); %#ok<ISCLSTR>
addRequired(p,'fileList',validateFileList);
parse(p,pathVal, fileList);

fileListJ = java.util.LinkedList;
for n = 1:numel(fileList)
    fileListJ.add(fileList{n});
end

tf = obj.Handle.concatenateFiles(pathVal, fileListJ);

end %function
