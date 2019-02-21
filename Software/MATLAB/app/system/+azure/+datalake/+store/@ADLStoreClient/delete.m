function tf = delete(~)
% DELETE Method to delete an Azure Data Lake file or directory
% True is returned if the call succeeds.
%
% Example:
%   % Delete file /my/path/to/file1.mat
%   tf = dlClient.delete('/my/path/to/file1.mat');
%

% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
% This file exists for automated documentation generation reasons only and
% should not be called see ADLStoreClient.m for an explanation of
% why this is so.
% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

% Copyright 2018 The MathWorks, Inc.


% Create a logger object
logObj = Logger.getLogger();
write(logObj,'error','This delete.m function should not be called, see ADLStoreClient.m');
tf = false;

end
