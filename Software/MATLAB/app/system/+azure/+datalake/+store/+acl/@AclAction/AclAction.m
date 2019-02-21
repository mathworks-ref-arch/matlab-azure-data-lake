classdef AclAction < azure.object
    % ACLACTION Specifies the possible combinations of actions allowed in an ACL
    %

    % Copyright 2018 The MathWorks, Inc.

    enumeration
        ALL
        EXECUTE
        NONE
        READ
        READ_EXECUTE
        READ_WRITE
        WRITE
        WRITE_EXECUTE
    end

    methods (Static)
        aclActionEnum = fromOctal(perm);
        aclActionEnum = fromRwx(rwx);
        tf = isValidRwx(rwx);
        octInt = toOctal(action);
        rwx = toString(action);
        aclActionEnum = valueOf(name);
        aclActionEnums = values(~);
    end

end %class
