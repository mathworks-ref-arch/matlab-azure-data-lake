function setDefaultTimeout(obj, defaultTimeoutInMillis)
% SETDEFAULTTIMEOUT Sets default timeout for calls by ADLStoreClient methods
%
% Example:
%       myStoreOptions.setDefaultTimeout(10000);

% Copyright 2018 The MathWorks, Inc.


% Create a logger object
logObj = Logger.getLogger();

if isnumeric(defaultTimeoutInMillis)
    obj.Handle.setDefaultTimeout(int32(defaultTimeoutInMillis));
else
    write(logObj,'error','Error invalid defaultTimeoutInMillis type');
end

end %function
