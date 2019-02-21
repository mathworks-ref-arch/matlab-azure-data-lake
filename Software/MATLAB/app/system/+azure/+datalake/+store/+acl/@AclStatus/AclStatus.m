classdef AclStatus < azure.object
    % ACLSTATUS Contains ACL and Permission information for a file or directory
    %

    % Copyright 2018 The MathWorks, Inc.

    properties (SetAccess=immutable)
        aclSpec;  % aclEntryList
        group = '';
        octalPermissions = '';
        owner = '';
        stickyBit; % logical
    end

    methods
        %% constructor
        function obj = AclStatus(aclSpec, group, octalPermissions, owner, stickyBit)
            obj.aclSpec = aclSpec;
            obj.group = group;
            obj.octalPermissions = octalPermissions;
            obj.owner = owner;
            obj.stickyBit = stickyBit;
        end %function
    end %methods
end %class
