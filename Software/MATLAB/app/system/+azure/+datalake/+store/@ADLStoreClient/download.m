function download(obj, filename, localFilename)
% DOWNLOAD Download contents of an Azure Data Lake file to a local file
% download will overwrite an existing file if present.
%
% Example:
%       % download myadlfilename.csv to a local file
%       dlClient.download('myadlfilename.csv', 'mylocalfilename.csv');
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
parse(p, filename, localFilename);

% downloading a file so first check it exists, does not check if it is a MAT file
if ~obj.Handle.checkExists(filename)
    write(logObj,'error',['File not found: ',filename]);
end

% open streams for each file
outputStream = FileOutputStream(string(localFilename));
inputStream = obj.Handle.getReadStream(string(filename));
IOUtils.copy(inputStream,outputStream);
% close the file streams
inputStream.close();
outputStream.close();

end %function
