function  myADLFileInputStream = getAppendStream(obj, pathVal)
% GETAPPENDSTREAM returns an ADLFileInputStream to append to an existing file


% Copyright 2017 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'getAppendStream';
addRequired(p,'pathVal',@ischar);
parse(p,pathVal);

myADLFileInputStream = obj.Handle.getAppendStream(pathVal);

end %function
