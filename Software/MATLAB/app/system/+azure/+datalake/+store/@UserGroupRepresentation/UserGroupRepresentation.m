classdef UserGroupRepresentation < azure.object
    % USERGROUPREPRESENTATION specifies how user & group objects are represented
    % Determines return type in calls that return user and group ID
    %   OID : Object ID, a GUID representing the ID of the user or group
    %   UPN : User Principal Name of the group or user, the human-friendly
    %         user name.
    % An instance can be declared as follows:
    %
    % Example:
    %   ugr = azure.datalake.store.UserGroupRepresentation.UPN;
    %
    % This can then be used to to specify a return type for example:
    %   aclStat = dlClient.getAclStatus('/README.md',ugr);
    %

    % Copyright 2017 The MathWorks, Inc.

    enumeration
        OID
        UPN
    end

end %class
