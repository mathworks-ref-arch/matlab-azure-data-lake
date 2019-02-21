function S = load(obj, filename, varargin)
% LOAD Loads variables from an Azure Data Lake file into a struct
% Note if only a subset of the variables in a file are required the entire
% file must still be downloaded in the background from Azure. load can be
% used very much like the functional form of the built-in load command.
%
% Example:
%       % load the variables from a matfile
%       dlClient = azure.datalake.store.ADLStoreClient;
%       dlClient.initialize();
%       myVars = dlClient.load('mymatfile.mat');
%   Or
%       myVars = dlClient.load('mymatfile.mat', 'x', 'y');
%

% Copyright 2018 The MathWorks, Inc.

% Imports
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.BufferedOutputStream;
import org.apache.commons.io.IOUtils;

% Create a logger object
logObj = Logger.getLogger();

% empty struct to return if there is an error
S = [];

% assume same syntax as build-in load as will pass varargin through
if ~ischar(filename)
    write(logObj,'error',['Invalid filename argument: ',filename]);
    return;
end

[~, ~, fileExt] = fileparts(filename);
% create a temp file to save the results to using IOUtils.copy
% use the extension of the provided filename
% load from the resulting temp file with the built in load
tmpName = [tempname, fileExt];


% copy the local file from Data Lake using IOutils
outputStream = FileOutputStream(tmpName);
inputStream = obj.getReadStream(filename);
IOUtils.copy(inputStream,outputStream);
% close the file streams
inputStream.close();
outputStream.close();

% check what has been downloaded
try
    output = whos('-file',tmpName); %#ok<NASGU>
catch
    warnType = true;
    for n = 1:numel(varargin)
        if ischar(varargin{n})
            if strcmpi(varargin{n}, '-ascii')
                warnType = false;
            end
        end
    end
    % if whos can read the file and it is not -ascii that is being passed warn
    % about the type as load is likely to fail
    if warnType
        write(logObj,'debug',['Warning ' filename ' is not a mat file']);
    end
end

% return a struct containing the variables from the file
S = load(tmpName, varargin{:});

% delete the local temp file
delete(tmpName);

end %function
