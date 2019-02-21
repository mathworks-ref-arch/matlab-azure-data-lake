function setExpiryTime(obj, pathVal, expiryOption, expiryTimeMilliseconds)
% SETEXPIRYTIME Sets the expiry time on a file
%
% Example:
%   % Set the expiry time to 24 hours from now
%   setExpiryTime('/my/path/myfile.txt', azure.datalake.store.ExpiryOption.RELATIVETONOW, int64(1000*60*60*24));
%

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'setExpiryTime';
validatePathVal = @(x) ischar(x) && ~isempty(x);
addRequired(p,'pathVal',validatePathVal);
validateExpiryOpt = @(x) isa(x,'azure.datalake.store.ExpiryOption');
addRequired(p,'expiryOption',validateExpiryOpt);
validateExpiryTimeMilliseconds = @(x) (x>=0) && isa(x,'int64') && isscalar(x);
addRequired(p,'expiryTimeMilliseconds',validateExpiryTimeMilliseconds);
parse(p,pathVal, expiryOption, expiryTimeMilliseconds);

switch expiryOption
    case azure.datalake.store.ExpiryOption.ABSOLUTE
        expiryOptionJ = com.microsoft.azure.datalake.store.ExpiryOption.Absolute;
    case azure.datalake.store.ExpiryOption.NEVEREXPIRE
        expiryOptionJ = com.microsoft.azure.datalake.store.ExpiryOption.NeverExpire;
    case azure.datalake.store.ExpiryOption.RELATIVETOCREATIONDATE
        expiryOptionJ = com.microsoft.azure.datalake.store.ExpiryOption.RelativeToCreationDate;
    case azure.datalake.store.ExpiryOption.RELATIVETONOW
        expiryOptionJ = com.microsoft.azure.datalake.store.ExpiryOption.RelativeToNow;
    otherwise
        write(logObj,'error','Error invalid ExpiryOption');
end

obj.Handle.setExpiryTime(pathVal, expiryOptionJ, expiryTimeMilliseconds);

end %function
