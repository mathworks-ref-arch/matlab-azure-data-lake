classdef AuthenticationOption < azure.object
    % AUTHENTICATIONOPTION Specifies how to authenticate to Data Lake
    %   ENDUSER  : An end user's Azure credentials are used to authenticate.
    %              MATLAB returns a message with a URL and code that prompts
    %              the user for their credentials. This authentication mechanism
    %              is interactive and the application runs in the logged in
    %              user's context.
    %
    %   SERVICETOSERVICE : The application authenticates itself with Data Lake
    %              Create an Azure Active Directory (AD) application and use
    %              the key from the Azure AD application to authenticate with
    %              Data Lake.This authentication mechanism is non-interactive.
    %
    % The default authentication method is SERVICETOSERVICE.
    %

    % Copyright 2018 The MathWorks, Inc.

    enumeration
        ENDUSER
        SERVICETOSERVICE
    end

end %class
