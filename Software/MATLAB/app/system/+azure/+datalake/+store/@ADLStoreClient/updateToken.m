function updateToken(obj, token)
% UPDATETOKEN Update token on existing client
% Tokens can be passed in as a character vector or as an AzureADToekn.
% This can be used if the client is to be used over long time and token has
% expired. The token is the AAD token string or OAuth2 token.
% Note a required methods to retrieve the token is not currently implemented.
%

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
logObj = Logger.getLogger();

if ischar(token) && ~isempty(token)
    obj.Handle.updateToken(string(token));
elseif isa(token,'com.microsoft.azure.datalake.store.oauth2.AzureADToken')
    obj.Handle.updateToken(token);
else
    write(logObj,'error','Error invalid token');
end

end
