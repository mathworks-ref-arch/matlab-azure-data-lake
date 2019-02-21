classdef AclEntry < azure.object
    % ACLENTRY An ACL for an object consists of a List of ACL entries
    % Contains one ACL entry. An ACL entry consists of a scope (access or
    % default), the type of the ACL (user, group, other or mask), the name of
    % the user or group associated with this ACL (can be blank to specify the
    % default permissions for users and groups, and must be blank for mask
    % entries), and the action permitted by this ACL entry.
    %
    % Example:
    %   myAclEntry = azure.datalake.store.acl.AclEntry(azure.datalake.store.acl.AclScope.DEFAULT,...
    %                               azure.datalake.store.acl.AclType.USER,...
    %                               'myfilename.ext',...
    %                               azure.datalake.store.acl.AclAction.READ_WRITE);
    %


    % Copyright 2018 The MathWorks, Inc.

    properties (SetAccess=immutable)
        action;
        name = '';
        scope;
        type;
    end

    methods (Static)
         % Java -> MATLAB conversion functions
         aclEntry = aclEntryConv(aclEntryJ);
         aclEntriesCell = aclEntryListToCellArray(aclEntriesList);
         % static methods corresponding to
         % com.microsoft.azure.datalake.store.acl.AclEntry methods
         % NB toString() is not a static method
         aclStr = aclListToString(aclEntryList, varargin);
         aclEntry = parseAclEntry(entryString, varargin);
         aclEntries = parseAclSpec(aclString);
    end

    methods
        % constructor
        function obj = AclEntry(scope, type, name, action)
            import com.microsoft.azure.datalake.store.acl.AclEntry;
            import com.microsoft.azure.datalake.store.acl.AclStatus;
            import com.microsoft.azure.datalake.store.acl.AclType;
            import com.microsoft.azure.datalake.store.acl.AclScope;

            % Create a logger object
            logObj = Logger.getLogger();

            p = inputParser;
            p.CaseSensitive = false;
            p.FunctionName = 'AclEntry';
            checkScopeClass = @(x) isa(x,'azure.datalake.store.acl.AclScope');
            addRequired(p,'scope',checkScopeClass);
            checkTypeClass = @(x) isa(x,'azure.datalake.store.acl.AclType');
            addRequired(p,'type',checkTypeClass);
            addRequired(p,'name',@ischar);
            checkActionClass = @(x) isa(x,'azure.datalake.store.acl.AclAction');
            addRequired(p,'action',checkActionClass);
            parse(p,scope,type,name,action);

            obj.scope = p.Results.scope;
            obj.type = p.Results.type;
            obj.name = p.Results.name;
            obj.action = p.Results.action;

            switch obj.scope
                case azure.datalake.store.acl.AclScope.ACCESS
                    scopeJ = com.microsoft.azure.datalake.store.acl.AclScope.ACCESS;
                case azure.datalake.store.acl.AclScope.DEFAULT
                    scopeJ = com.microsoft.azure.datalake.store.acl.AclScope.DEFAULT;
                otherwise
                    write(logObj,'error','Error invalid ACL Scope');
            end

            switch obj.type
                case azure.datalake.store.acl.AclType.USER
                    typeJ = com.microsoft.azure.datalake.store.acl.AclType.USER;
                case azure.datalake.store.acl.AclType.GROUP
                    typeJ = com.microsoft.azure.datalake.store.acl.AclType.GROUP;
                case azure.datalake.store.acl.AclType.OTHER
                    typeJ = com.microsoft.azure.datalake.store.acl.AclType.OTHER;
                case azure.datalake.store.acl.AclType.MASK
                    typeJ = com.microsoft.azure.datalake.store.acl.AclType.MASK;
                otherwise
                    write(logObj,'error','Error invalid ACL Type');
            end

            switch obj.action
                case azure.datalake.store.acl.AclAction.ALL
                    actionJ = com.microsoft.azure.datalake.store.acl.AclAction.ALL;
                case azure.datalake.store.acl.AclAction.EXECUTE
                    actionJ = com.microsoft.azure.datalake.store.acl.AclAction.EXECUTE;
                case azure.datalake.store.acl.AclAction.NONE
                    actionJ = com.microsoft.azure.datalake.store.acl.AclAction.NONE;
                case azure.datalake.store.acl.AclAction.READ
                    actionJ = com.microsoft.azure.datalake.store.acl.AclAction.READ;
                case azure.datalake.store.acl.AclAction.READ_EXECUTE
                    actionJ = com.microsoft.azure.datalake.store.acl.AclAction.READ_EXECUTE;
                case azure.datalake.store.acl.AclAction.READ_WRITE
                    actionJ = com.microsoft.azure.datalake.store.acl.AclAction.READ_WRITE;
                case azure.datalake.store.acl.AclAction.WRITE
                    actionJ = com.microsoft.azure.datalake.store.acl.AclAction.WRITE;
                case azure.datalake.store.acl.AclAction.WRITE_EXECUTE
                    actionJ = com.microsoft.azure.datalake.store.acl.AclAction.WRITE_EXECUTE;
                otherwise
                    write(logObj,'error','Error invalid ACL Action');
            end

            obj.Handle = com.microsoft.azure.datalake.store.acl.AclEntry...
                (scopeJ, typeJ, string(name), actionJ);

        end %function
    end %methods
end %class
