function setInsecureTransport(obj)
% SETINSECURETRANSPORT Use http as transport for back-end calls instead of https
% This is to allow unit testing using mock or fake web servers. Warning: Do not
% use this for talking to real Azure Data Lake service, since https is the only
% supported protocol on the server.
%
% Example:
%       myStoreOptions.setInsecureTransport();

% Copyright 2018 The MathWorks, Inc.


obj.Handle.setInsecureTransport();


end %function
