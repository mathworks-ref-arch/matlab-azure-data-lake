function setTimes(obj, pathVal, atime, mtime)
% SETTIMES Sets one or both of Modified and Access times of the file or directory
% path - full pathname of file or directory to set times for
% atime - Access time as datetime
% mtime - Modified time as a datetime
%
% Example:
%   setExpiryTime('/my/path/myfile.txt', atime, mtime);
%

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'setTimes';
validatePathVal = @(x) ischar(x) && ~isempty(x);
addRequired(p,'pathVal',validatePathVal);
%validateTimeLong = @(x) (isempty(x) || (x>=0)) && isa(x,'int64') && (isscalar(x) || isempty(x));
addRequired(p,'atime',@isdatetime);
addRequired(p,'mtime',@isdatetime);

parse(p,pathVal, atime, mtime);

% if NaT pass nulls to Java
if isnat(atime)   
    atimeJ = [];
else
    atimeJ = java.util.Date(int64(posixtime(atime)*1000));
end

if isnat(mtime)
    mtimeJ = [];
else
    mtimeJ = java.util.Date(int64(posixtime(mtime)*1000));
end

obj.Handle.setTimes(pathVal, atimeJ, mtimeJ);

end %function
