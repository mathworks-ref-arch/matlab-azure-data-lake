classdef testADLStoreEndUserAuth < matlab.unittest.TestCase
    % TESTDLSTOREENDUSERAUTH This is a test stub for a unit testing
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

    % Copyright 2017-2019 The MathWorks, Inc.

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

            % Configure a license file for end user auth
            customCredsFile = which('azuredatalakestore.json_enduser');
            [filepath,name,~] = fileparts(customCredsFile);
            standardCredsFile = fullfile(filepath, [name, '.json']);
            copyfile(customCredsFile, standardCredsFile);

            % recover from a bad cleanup
            % disp('Running testSetup');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            cleanList = {'myTmpADLUnitTestDirName',...
                'myNonExistantFile1234567.tmp',...
                'myTmpADLUnitTestFileName1.tmp',...
                'myTmpADLUnitTestFileName2.tmp',...
                'myTmpADLUnitTestFileName3.tmp',...
                'myTmpADLUnitTestFileName1.mat',...
                'myTmpADLUnitTestDirName1'
                };
            for n = 1:numel(cleanList)
                if dlClient.checkExists(cleanList{n})
                    tf = dlClient.deleteRecursive(cleanList{n});
                    testCase.verifyTrue(tf);
                end
            end
            dlClient.delete();
        end
    end

    methods (TestMethodTeardown)
        function testTearDown(testCase)
            % recover from a bad cleanup
            % disp('Running testTearDown');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            cleanList = {'myTmpADLUnitTestDirName',...
                'myNonExistantFile1234567.tmp',...
                'myTmpADLUnitTestFileName1.tmp',...
                'myTmpADLUnitTestFileName2.tmp',...
                'myTmpADLUnitTestFileName3.tmp',...
                'myTmpADLUnitTestFileName1.mat',...
                'myTmpADLUnitTestDirName1'
                };
            for n = 1:numel(cleanList)
                if dlClient.checkExists(cleanList{n})
                    tf = dlClient.deleteRecursive(cleanList{n});
                    testCase.verifyTrue(tf);
                end
            end
            dlClient.delete();
        end
    end

    methods (Test)

        function testConstructor(testCase)
            % create the object
            disp('Running testConstructor');
            dlClient = azure.datalake.store.ADLStoreClient;
            testCase.verifyClass(dlClient,'azure.datalake.store.ADLStoreClient');
            %close the client
            dlClient.delete();
        end

        function testInitialization(testCase)
            disp('Running testInitialization');
            dlClient = azure.datalake.store.ADLStoreClient;

            dlClient.initialize();
            % basic checks
            testCase.verifyNotEmpty(dlClient.Handle);
            testCase.verifyNotEmpty(dlClient.AccountFQDN);

            dlClient.delete();

        end

        function testInitNoConfig(testCase)
            disp('Running testInitNoConfig');
            dlClient = azure.datalake.store.ADLStoreClient;
            testCredsFile = which('azuredatalakestore.json_enduser');
            testCreds = jsondecode(fileread(testCredsFile));
            dlClient.NativeAppId = testCreds.NativeAppId;
            dlClient.AccountFQDN = testCreds.AccountFQDN;
            dlClient.AuthOption = azure.datalake.store.AuthenticationOption.ENDUSER;

            dlClient.initialize();
            testCase.verifyNotEmpty(dlClient.Handle);
            testCase.verifyNotEmpty(dlClient.AccountFQDN);
            testCase.verifyNotEmpty(dlClient.NativeAppId);

            dirName1 = 'myTmpADLUnitTestDirName1';
            tf = dlClient.createDirectory(dirName1);
            testCase.verifyTrue(tf);
            dirTable = dlClient.enumerateDirectory(dirName1);
            testCase.verifySize(dirTable,[0 0]);

            dlClient.delete();
        end

        function testInitNamedConfig(testCase)
            disp('Running testInitNamedConfig');
            dlClient = azure.datalake.store.ADLStoreClient;
            testCredsFile = which('azuredatalakestore.json_enduser');
            dlClient.ConfigFile = testCredsFile;

            dlClient.initialize();
            testCase.verifyNotEmpty(dlClient.Handle);
            testCase.verifyNotEmpty(dlClient.AccountFQDN);
            testCase.verifyNotEmpty(dlClient.NativeAppId);

            dirName1 = 'myTmpADLUnitTestDirName1';
            tf = dlClient.createDirectory(dirName1);
            testCase.verifyTrue(tf);
            dirTable = dlClient.enumerateDirectory(dirName1);
            testCase.verifySize(dirTable,[0 0]);

            dlClient.delete();
        end

        % ownership change requires end user auth
        function testSetOwner(testCase)
            disp('Running testSetOwner');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            dlClient.createEmptyFile(fileName1);
            rep = azure.datalake.store.UserGroupRepresentation.UPN;
            dirTable = dlClient.enumerateDirectory(fileName1, 'UserGroupRepresentation', rep);
            oldGroup = dirTable.Group{1};
            oldUser = dirTable.User{1};
            newGroup = 'mynewgroup';
            newUser = 'mynewowner';
            dlClient.setOwner(fileName1, newUser, '');
            dirTable = dlClient.enumerateDirectory(fileName1, 'UserGroupRepresentation', rep);
            % check user has changed
            testCase.verifyEqual(dirTable.User{1},newUser);
            %check group has not changed
            testCase.verifyEqual(dirTable.Group{1},oldGroup);
            % TODO add a group change test
            dlClient.delete();
        end

    end

end
