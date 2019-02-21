function reset(obj)
% RESET Reset response object to initial state
%

% TODO add example

% Copyright 2018 The MathWorks, Inc.

% classdef for description of the fields
obj.ex = ''; % exception type
obj.exceptionHistory = '';
obj.httpResponseCode = [];
obj.lastCallLatency = int64(0);
obj.message = '';
obj.numRetries = [];
obj.opCode = '';
obj.remoteExceptionJavaClassName = '';
obj.remoteExceptionMessage = '';
obj.remoteExceptionName = '';
obj.requestId = '';
obj.responseChunked = false;
obj.responseContentLength = int64(0);
obj.responseStream;
obj.successful = true;
obj.tokenAcquisitionLatency = int64(0);

end %function
