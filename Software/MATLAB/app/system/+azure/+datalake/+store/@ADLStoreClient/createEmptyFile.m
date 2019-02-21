function createEmptyFile(obj, fileName)
% CREATEEMPTYFILE creates an empty file
%

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% Create a logger object
%logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'createEmptyFile';
validatePathVal = @(x) ischar(x) && ~isempty(x);
addRequired(p,'fileName',validatePathVal);
parse(p, fileName);

obj.Handle.createEmptyFile(fileName);

end %function
