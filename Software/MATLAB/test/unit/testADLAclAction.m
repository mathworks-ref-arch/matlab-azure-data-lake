classdef testADLAclAction < matlab.unittest.TestCase
    % TESTACLACTION This is a test stub for a unit testing
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
            action = azure.datalake.store.acl.AclAction.ALL;
            testCase.verifyClass(action,'azure.datalake.store.acl.AclAction');
            testCase.verifyEqual(char(action),'ALL');
        end


        function testFromOctal(testCase)
            disp('Running testFromOctal');
            action = azure.datalake.store.acl.AclAction.fromOctal(7);
            testCase.verifyEqual(char(action),'ALL');
            action = azure.datalake.store.acl.AclAction.fromOctal(6);
            testCase.verifyEqual(char(action),'READ_WRITE');
            action = azure.datalake.store.acl.AclAction.fromOctal(5);
            testCase.verifyEqual(char(action),'READ_EXECUTE');
            action = azure.datalake.store.acl.AclAction.fromOctal(4);
            testCase.verifyEqual(char(action),'READ');
            action = azure.datalake.store.acl.AclAction.fromOctal(3);
            testCase.verifyEqual(char(action),'WRITE_EXECUTE');
            action = azure.datalake.store.acl.AclAction.fromOctal(2);
            testCase.verifyEqual(char(action),'WRITE');
            action = azure.datalake.store.acl.AclAction.fromOctal(1);
            testCase.verifyEqual(char(action),'EXECUTE');
            action = azure.datalake.store.acl.AclAction.fromOctal(0);
            testCase.verifyEqual(char(action),'NONE');
        end


        function testFromRwx(testCase)
            disp('Running testFromRwx');
            action = azure.datalake.store.acl.AclAction.fromRwx('rwx');
            testCase.verifyEqual(char(action),'ALL');
            action = azure.datalake.store.acl.AclAction.fromRwx('rw-');
            testCase.verifyEqual(char(action),'READ_WRITE');
            action = azure.datalake.store.acl.AclAction.fromRwx('r-x');
            testCase.verifyEqual(char(action),'READ_EXECUTE');
            action = azure.datalake.store.acl.AclAction.fromRwx('r--');
            testCase.verifyEqual(char(action),'READ');
            action = azure.datalake.store.acl.AclAction.fromRwx('-wx');
            testCase.verifyEqual(char(action),'WRITE_EXECUTE');
            action = azure.datalake.store.acl.AclAction.fromRwx('-w-');
            testCase.verifyEqual(char(action),'WRITE');
            action = azure.datalake.store.acl.AclAction.fromRwx('--x');
            testCase.verifyEqual(char(action),'EXECUTE');
            action = azure.datalake.store.acl.AclAction.fromRwx('---');
            testCase.verifyEqual(char(action),'NONE');
        end


        function testIsValidRwx(testCase)
            disp('Running testIsValidRwx');
            % check legitimate values
            tf = azure.datalake.store.acl.AclAction.isValidRwx('rwx');
            testCase.verifyTrue(tf);
            tf = azure.datalake.store.acl.AclAction.isValidRwx('rw-');
            testCase.verifyTrue(tf);
            tf = azure.datalake.store.acl.AclAction.isValidRwx('r-x');
            testCase.verifyTrue(tf);
            tf = azure.datalake.store.acl.AclAction.isValidRwx('r--');
            testCase.verifyTrue(tf);
            tf = azure.datalake.store.acl.AclAction.isValidRwx('-wx');
            testCase.verifyTrue(tf);
            tf = azure.datalake.store.acl.AclAction.isValidRwx('-w-');
            testCase.verifyTrue(tf);
            tf = azure.datalake.store.acl.AclAction.isValidRwx('--x');
            testCase.verifyTrue(tf);
            tf = azure.datalake.store.acl.AclAction.isValidRwx('---');
            testCase.verifyTrue(tf);
            % check uppercase
            tf = azure.datalake.store.acl.AclAction.isValidRwx('--X');
            testCase.verifyTrue(tf);
            % check with white space
            tf = azure.datalake.store.acl.AclAction.isValidRwx(' --X ');
            testCase.verifyTrue(tf);
            % check invalid
            tf = azure.datalake.store.acl.AclAction.isValidRwx(' --F ');
            testCase.verifyFalse(tf);
        end


        function testToOctal(testCase)
            disp('Running testToOctal');
            action = azure.datalake.store.acl.AclAction.ALL;
            octInt = azure.datalake.store.acl.AclAction.toOctal(action);
            testCase.verifyEqual(octInt,7);
            action = azure.datalake.store.acl.AclAction.READ_WRITE;
            octInt = azure.datalake.store.acl.AclAction.toOctal(action);
            testCase.verifyEqual(octInt,6);
            action = azure.datalake.store.acl.AclAction.READ_EXECUTE;
            octInt = azure.datalake.store.acl.AclAction.toOctal(action);
            testCase.verifyEqual(octInt,5);
            action = azure.datalake.store.acl.AclAction.READ;
            octInt = azure.datalake.store.acl.AclAction.toOctal(action);
            testCase.verifyEqual(octInt,4);
            action = azure.datalake.store.acl.AclAction.WRITE_EXECUTE;
            octInt = azure.datalake.store.acl.AclAction.toOctal(action);
            testCase.verifyEqual(octInt,3);
            action = azure.datalake.store.acl.AclAction.WRITE;
            octInt = azure.datalake.store.acl.AclAction.toOctal(action);
            testCase.verifyEqual(octInt,2);
            action = azure.datalake.store.acl.AclAction.EXECUTE;
            octInt = azure.datalake.store.acl.AclAction.toOctal(action);
            testCase.verifyEqual(octInt,1);
            action = azure.datalake.store.acl.AclAction.NONE;
            octInt = azure.datalake.store.acl.AclAction.toOctal(action);
            testCase.verifyEqual(octInt,0);
        end


        function testToString(testCase)
            disp('Running testToString');
            action = azure.datalake.store.acl.AclAction.ALL;
            str = azure.datalake.store.acl.AclAction.toString(action);
            testCase.verifyEqual(str,'rwx');
            action = azure.datalake.store.acl.AclAction.READ_WRITE;
            str = azure.datalake.store.acl.AclAction.toString(action);
            testCase.verifyEqual(str,'rw-');
            action = azure.datalake.store.acl.AclAction.READ_EXECUTE;
            str = azure.datalake.store.acl.AclAction.toString(action);
            testCase.verifyEqual(str,'r-x');
            action = azure.datalake.store.acl.AclAction.READ;
            str = azure.datalake.store.acl.AclAction.toString(action);
            testCase.verifyEqual(str,'r--');
            action = azure.datalake.store.acl.AclAction.WRITE_EXECUTE;
            str = azure.datalake.store.acl.AclAction.toString(action);
            testCase.verifyEqual(str,'-wx');
            action = azure.datalake.store.acl.AclAction.WRITE;
            str = azure.datalake.store.acl.AclAction.toString(action);
            testCase.verifyEqual(str,'-w-');
            action = azure.datalake.store.acl.AclAction.EXECUTE;
            str = azure.datalake.store.acl.AclAction.toString(action);
            testCase.verifyEqual(str,'--x');
            action = azure.datalake.store.acl.AclAction.NONE;
            str = azure.datalake.store.acl.AclAction.toString(action);
            testCase.verifyEqual(str,'---');
        end

        function testValueOf(testCase)
            disp('Running testValueOf');
            testCase.logObj.MsgPrefix = 'Azure:DataLake';
            % set the logger prefix to that expected by the test below
            action = azure.datalake.store.acl.AclAction.valueOf('ALL');
            testCase.verifyEqual(char(action),'ALL');
            action = azure.datalake.store.acl.AclAction.valueOf('EXECUTE');
            testCase.verifyEqual(char(action),'EXECUTE');
            action = azure.datalake.store.acl.AclAction.valueOf('WRITE');
            testCase.verifyEqual(char(action),'WRITE');
            action = azure.datalake.store.acl.AclAction.valueOf('WRITE_EXECUTE');
            testCase.verifyEqual(char(action),'WRITE_EXECUTE');
            action = azure.datalake.store.acl.AclAction.valueOf('READ');
            testCase.verifyEqual(char(action),'READ');
            action = azure.datalake.store.acl.AclAction.valueOf('READ_EXECUTE');
            testCase.verifyEqual(char(action),'READ_EXECUTE');
            action = azure.datalake.store.acl.AclAction.valueOf('READ_WRITE');
            testCase.verifyEqual(char(action),'READ_WRITE');
            action = azure.datalake.store.acl.AclAction.valueOf('NONE');
            testCase.verifyEqual(char(action),'NONE');
            testCase.verifyError(@()azure.datalake.store.acl.AclAction.valueOf('invalid'), 'Azure:DataLake');
        end


        function testValues(testCase)
            disp('Running testValues');
            aclActionEnums = {...
                'ALL',...
                'EXECUTE',...
                'NONE',...
                'READ',...
                'READ_EXECUTE',...
                'READ_WRITE',...
                'WRITE',...
                'WRITE_EXECUTE',...
                };

            enums = azure.datalake.store.acl.AclAction.values();

            for n=1:numel(aclActionEnums)
                testCase.verifyEqual(enums{n},aclActionEnums{n});
            end
        end
    end

end
