function tf = save(obj, filename, varargin)
% SAVE Save variables to an Azure Data Lake file
% Save will overwrite files and create parent directories if required.
% If required parent directories do not exist they will not be created and
% the call will fail. True is returned if the call succeeds.
%
% Save can be used very much like the functional form of the built-in save
% command with two exceptions:
%   1) The '-append' option is not supported.
%   2) An entire workspace cannot be saved i.e. dlClient.save('myfile.mat')
%      because the Azure Data Lake objects are not serializable. The
%      workspace variables should be listed explicitly to overcome this.
%
% Example:
%       % save the variables x and y to a .mat file
%       dlClient = azure.datalake.store.ADLStoreClient;
%       dlClient.initialize();
%       x = rand(10);
%       y = rand(10);
%       dlClient.save('mymatfile.mat', 'x', 'y');
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

tf = false;
% assume same syntax as build-in save as will pass varargin through
if ~ischar(filename)
    write(logObj,'error','Invalid filename type expecting character vector');
    return;
end

% scan varargin for -append
% can't handle this as the file being appended to is not local it would
% have to be downloaded first, see also dlClient.getAppendStream
for n = 1:numel(varargin)
    if ischar(varargin{n})
        if strcmpi(varargin{n}, '-append')
            write(logObj,'error','-append is not support when saving to Azure Data Lake, either download the target file and append locally or consider the getAppendStream() method');
            return;
        end
    end
end

if nargin == 2
    str1 = 'Cannot save the complete workspace as the Azure Data Lake objects are not serializable, ';
    str2 = 'Instead specify the variables to be saved: ';
    str3 = 'dlClient.save(''mymatfile.mat'', ''x'', ''y'');';
    write(logObj,'error', [str1, str2, str3]);
    return
else
    % create a temp file and use built in save to save there
    % fix the extension so it does not vary based on save args e.g. -ascii
    % it will not be used in the long term in any case
    tmpName = [tempname, '.mat'];

    % build an expression to pass to a built-in save in the calling workspace
    % function ins the calling workspace will not be saved
    expr = 'save(';
    expr = [expr '''' tmpName ''''];
    for n = 1:numel(varargin)
        expr = [expr ',' '''' varargin{n} '''']; %#ok<AGROW>
    end
    expr = [expr ')'];
    evalin('caller', expr);
end

% overwrite existing files
ifExistsModeJ = azure.datalake.store.IfExists.OVERWRITE;

% copy the local file to Data Lake using IOutils
inputStream = FileInputStream(tmpName);
outputStream = obj.createFile(filename, ifExistsModeJ);
IOUtils.copy(inputStream,outputStream);
% close the file streams and delete the local temp file
inputStream.close();
outputStream.close();
delete(tmpName);

tf = true;

end %function
