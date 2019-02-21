classdef testADLAclEntry < matlab.unittest.TestCase
    % TESTDLSTORECLIENT This is a test stub for a unit testing
    % The assertions that you can use in your test cases:
    %
    %    assertTrue
    %    assertFalse
    %    assertEqual
    %    assertFilesEqual
    %    assertElementsAlmostEqual
    %    assertVectorsAlmostEqual
    %    assertExceptionThrown
    %
    %   A more detailed explanation goes here.
    %
    % Notes:
    
    % Copyright 2017 The MathWorks, Inc.
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Please add your test cases below
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    properties
        logObj
    end
    
    methods (TestMethodSetup)
        function testSetup(testCase)
            testCase.logObj = Logger.getLogger();
            testCase.logObj.DisplayLevel = 'verbose';
        end
    end
    
    methods (TestMethodTeardown)
    end
    
    methods (Test)
        
        function testConstructor(testCase)
            % create the object
            disp('Running testConstructor');
            filename = 'myTmpADLUnitTestFileName1.tmp';
            myAclEntry = azure.datalake.store.acl.AclEntry(azure.datalake.store.acl.AclScope.DEFAULT,...
                azure.datalake.store.acl.AclType.USER,...
                filename,...
                azure.datalake.store.acl.AclAction.READ_WRITE);
            % check the object type
            testCase.verifyClass(myAclEntry,'azure.datalake.store.acl.AclEntry');
        end
        
        function testToString(testCase)
            disp('Running testToString');
            filename = 'myTmpADLUnitTestFileName1.tmp';
            % build an entry
            myAclEntry = azure.datalake.store.acl.AclEntry(azure.datalake.store.acl.AclScope.DEFAULT,...
                azure.datalake.store.acl.AclType.USER,...
                filename,...
                azure.datalake.store.acl.AclAction.READ_WRITE);
            str = myAclEntry.toString();
            % check the posix form of that entry
            testCase.verifyEqual(str,'default:user:myTmpADLUnitTestFileName1.tmp:rw-');
            % test that the permissions get removed
            removeAcl = true;
            str = myAclEntry.toString(removeAcl);
            testCase.verifyEqual(str,'default:user:myTmpADLUnitTestFileName1.tmp');
        end
        
        function testParseAclEntry(testCase)
            disp('Running testParseAclEntry');
            str = 'default:user:bob:r-x';
            myAclEntry =  azure.datalake.store.acl.AclEntry.parseAclEntry(str);
            % test class and value of action
            testCase.verifyClass(myAclEntry.action, 'azure.datalake.store.acl.AclAction');
            testCase.verifyEqual(azure.datalake.store.acl.AclAction.toString(myAclEntry.action), 'r-x');
            % test class and value of scope
            testCase.verifyClass(myAclEntry.scope, 'azure.datalake.store.acl.AclScope');
            testCase.verifyEqual(char(myAclEntry.scope), 'DEFAULT');
            % test class and value of type
            testCase.verifyClass(myAclEntry.type, 'azure.datalake.store.acl.AclType');
            testCase.verifyEqual(char(myAclEntry.type), 'USER');
            % test class and value of name
            testCase.verifyClass(myAclEntry.name, 'char');
            testCase.verifyEqual(myAclEntry.name, 'bob');
        end
        
        function testParseAclSpec(testCase)
            disp('Running testParseAclSpec');
            user1 = 'user:foo:rw-';
            user2 = 'user:bar:r--';
            group1 = 'group::r--';
            myAclSpec = [user1 ',' user2 ',' group1];
            aclEntries = azure.datalake.store.acl.AclEntry.parseAclSpec(myAclSpec);
            % check the return type
            testCase.verifyClass(aclEntries{1}, 'azure.datalake.store.acl.AclEntry');
            % check the names
            testCase.verifyEqual(aclEntries{1}.name, 'foo');
            testCase.verifyEqual(aclEntries{2}.name, 'bar');
            testCase.verifyEqual(aclEntries{3}.name, '');
            % check the types
            testCase.verifyEqual(char(aclEntries{1}.type), 'USER');
            testCase.verifyEqual(char(aclEntries{2}.type), 'USER');
            testCase.verifyEqual(char(aclEntries{3}.type), 'GROUP');
            % check the scopes
            testCase.verifyEqual(char(aclEntries{1}.scope), 'ACCESS');
            testCase.verifyEqual(char(aclEntries{2}.scope), 'ACCESS');
            testCase.verifyEqual(char(aclEntries{3}.scope), 'ACCESS');
            % check the permissions
            testCase.verifyEqual(char(aclEntries{1}.action), 'READ_WRITE');
            testCase.verifyEqual(char(aclEntries{2}.action), 'READ');
            testCase.verifyEqual(char(aclEntries{3}.action), 'READ');
        end
        
        function testAclListToString(testCase)
            disp('Running testAclListToString');
            user1 = 'user:foo:rw-';
            user2 = 'user:bar:r--';
            group1 = 'group::r--';
            myAclSpec = [user1 ',' user2 ',' group1];
            aclEntries = azure.datalake.store.acl.AclEntry.parseAclSpec(myAclSpec);
            result = azure.datalake.store.acl.AclEntry.aclListToString(aclEntries);
            testCase.verifyEqual(result,'user:foo:rw-,user:bar:r--,group::r--');
            removeAcl = true;
            result = azure.datalake.store.acl.AclEntry.aclListToString(aclEntries,removeAcl);
            testCase.verifyEqual(result,'user:foo,user:bar,group:');
        end
        
    end
    
end
