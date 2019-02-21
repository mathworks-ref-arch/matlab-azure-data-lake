function upload(obj, filename, localFilename, varargin)
% UPLOAD Upload contents of a local file to an Azure Data Lake file
% upload will overwrite an existing file if present by default.
%
% Example:
%       % upload a local file
%       dlClient.upload('myadlfilename.csv', 'mylocalfilename.csv');
%
%       % optionally have the function fail if the destination file already exists
%       dlClient.upload('myadlfilename.csv', 'mylocalfilename.csv', azure.datalake.store.IfExists.FAIL);
%

% Copyright 2018 The MathWorks, Inc.

% imports
import java.io.File
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.BufferedOutputStream
import org.apache.commons.io.IOUtils

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'upload';
addRequired(p,'filename',@ischar);
addRequired(p,'localFilename',@ischar);
% by default overwrite
modeValidation = @(x) isa(x, 'azure.datalake.store.IfExists');
addOptional(p,'mode', azure.datalake.store.IfExists.OVERWRITE, modeValidation);
parse(p, filename, localFilename, varargin{:});

IfExistsMode = p.Results.mode;

% uploading a file so first check it exists, does not check if it is a MAT file
if exist(localFilename,'file') ~= 2
    write(logObj,'error',['File not found: ',localFilename]);
end

% set the java version of the IfExists Enum
if IfExistsMode == azure.datalake.store.IfExists.FAIL
    IfExistsModeJ = com.microsoft.azure.datalake.store.datalake.store.IfExists.FAIL;
elseif IfExistsMode == azure.datalake.store.IfExists.OVERWRITE
    IfExistsModeJ = com.microsoft.azure.datalake.store.IfExists.OVERWRITE;
else
    write(logObj,'error','Invalid IfExits Mode enum');
end

% open streams for each file
inputStream = FileInputStream(localFilename);
outputStream = obj.Handle.createFile(string(filename),IfExistsModeJ);
IOUtils.copy(inputStream,outputStream);
% close the file streams
inputStream.close();
outputStream.close();

end %function
