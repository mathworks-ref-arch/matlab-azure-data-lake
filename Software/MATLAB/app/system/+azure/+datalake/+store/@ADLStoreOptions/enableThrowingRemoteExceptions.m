function enableThrowingRemoteExceptions(obj)
% ENABLETHROWINGREMOTEEXCEPTIONS Throw server-returned exception name
% Throw server-returned exception name instead of ADLExcetption. ADLStoreClient
% methods throw ADLException on failure. ADLException contains additional fields
% that have details on the error that occurred, like the HTTP response code and
% the server request ID, etc. However, in some cases, server returns an
% exception name in it's HTTP error stream. Calling this method causes the
% ADLStoreClient methods to throw the exception name returned by the server
% rather than ADLException. In general, this is not recommended, since the name
% of the remote exception can also be retrieved from ADLException.
% This method exists to enable usage within Hadoop as a file system.
%
% Example:
%       myStoreOptions.enableThrowingRemoteExceptions();

% Copyright 2018 The MathWorks, Inc.


obj.Handle.enableThrowingRemoteExceptions();


end %function
