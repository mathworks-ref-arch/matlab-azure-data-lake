function setUserAgentSuffix(obj, userAgentSuffix)
% SETUSERAGENTSUFFIX Sets the user agent suffix in http User-Agent header
% sets the user agent suffix to be added to the User-Agent header in all HTTP
% requests made to the server. This suffix is appended to the end of the
% User-Agent string constructed by the SDK.
%
% Example:
%       myUserOptions.setUserAgentSuffix('my header string');

% Copyright 2018 The MathWorks, Inc.


% Create a logger object
logObj = Logger.getLogger();

if ischar(userAgentSuffix)
    obj.Handle.setUserAgentSuffix(userAgentSuffix);
else
    write(logObj,'error','Error invalid userAgentSuffix type');
end

end %function
