classdef OperationResponse < azure.object
    % OPERATIONRESPONSE Information about a response from a server call
    % This class is a container for all the information from making a server call.
    %

    % TODO Add examples


    % Copyright 2018 The MathWorks, Inc.

    properties
        % exceptions encountered when processing the request or response
        ex = ''; % Java exception type expected

        % Comma-separated list of exceptions encountered but not thrown by this call
        exceptionHistory = '';

        % the HTTP response code from the call
        httpResponseCode = [];

        % the latency of the last try, in milliseconds
        lastCallLatency = int64(0);

        % error message, used for errors that originate within the SDK
        message = '';

        % the number of retries attempted before returning from the call
        numRetries = [];

        % The WebHDFS opCode of the remote operation
        opCode = '';

        % the exception's Java Class Name as reported by the server,
        % if the call failed on server This is there for WebHDFS compatibility.
        remoteExceptionJavaClassName = '';

        % the exception message as reported by the server, if the call failed on server
        remoteExceptionMessage = '';

        % the exception name as reported by the server, if the call failed on server
        remoteExceptionName = '';

        % the server request ID
        requestId = '';

        % indicates whether HTTP body used chunked for Transfer-Encoding of the response
        responseChunked = false;

        % Content-Length of the returned HTTP body (if return was not chunked)
        responseContentLength = int64(0);

        % for methods that return data from server, this field contains the ADLFileInputStream
        responseStream;

        % whether the request was successful
        successful = true;

        % time taken to get the token for this request, in nanoseconds.
        tokenAcquisitionLatency = int64(0);
    end


    methods
        %% constructor
        function obj = OperationResponse()
            obj = com.microsoft.azure.datalake.store.OperationResponse();
        end %function
    end %methods
end %class
