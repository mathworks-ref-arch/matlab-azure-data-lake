function myADLFileOutputStream = createFile(obj, pathVal, ifExistsMode, varargin)
% CREATEFILE Creates a file
% Returns an ADLFileOutputStream that can then be written to unless
% ifExistsMode is false and the file already exists.
%

% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'createFile';
validatePathVal = @(x) ischar(x) && ~isempty(x);
addRequired(p,'pathVal',validatePathVal);
validateifExistsMode = @(x) isa(x,'azure.datalake.store.IfExists') && ~isempty(x);
addRequired(p,'ifExistsMode',validateifExistsMode);
addOptional(p,'octalPermission','',@ischar);
addOptional(p,'createParent',[],@islogical);
parse(p, pathVal, ifExistsMode, varargin{:});

octalPermission = p.Results.octalPermission;
createParent = p.Results.createParent;


if ifExistsMode == azure.datalake.store.IfExists.FAIL
    ifExistsModeJ = com.microsoft.azure.datalake.store.datalake.store.IfExists.FAIL;
elseif ifExistsMode == azure.datalake.store.IfExists.OVERWRITE
    ifExistsModeJ = com.microsoft.azure.datalake.store.IfExists.OVERWRITE;
else
    write(logObj,'error','Invalid IfExists mode enum');
end


if ~isempty(octalPermission) && ~isempty(createParent)
    myADLFileOutputStream = obj.Handle.createFile(pathVal, ifExistsModeJ, octalPermission, createParent);
elseif isempty(octalPermission) && isempty(createParent)
    myADLFileOutputStream = obj.Handle.createFile(pathVal, ifExistsModeJ);
else
    write(logObj,'error','Invalid octalPermission and or createParent arguments');
end

end %function
