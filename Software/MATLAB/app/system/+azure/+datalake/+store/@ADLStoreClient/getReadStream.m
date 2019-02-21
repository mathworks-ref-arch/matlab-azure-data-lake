function  myADLFileInputStream = getReadStream(obj, pathVal)
% GETREADSTREAM Returns an ADLFileInputStream to read the file contents from


% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'getReadStream';
addRequired(p,'pathVal',@ischar);
parse(p,pathVal);

myADLFileInputStream = obj.Handle.getReadStream(pathVal);

end %function
