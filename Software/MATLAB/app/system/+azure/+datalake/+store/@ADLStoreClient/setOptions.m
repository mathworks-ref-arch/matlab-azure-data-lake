function setOptions(obj, options)
% SETOPTIONS Sets the options to configure the behavior of this client
% The options argument can be of type:
% com.microsoft.azure.datalake.store.ADLStoreOptions or
% azure.datalake.store.ADLStoreOptions
%
% Example:
%   myStoreOptions = azure.datalake.store.ADLStoreOptions();
%   myStoreOptions.setFilePathPrefix('mypathprefix');
%   dlClient.setOptions(myStoreOptions);
%

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
logObj = Logger.getLogger();

if isa(options, 'com.microsoft.azure.datalake.store.ADLStoreOptions')
    obj.Handle.setOptions(options);
elseif (isa(options, 'azure.datalake.store.ADLStoreOptions'))
    obj.Handle.setOptions(options.Handle);
else
    write(logObj,'error','Error invalid options argument type');
end

end
