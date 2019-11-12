classdef testADLStoreClient < matlab.unittest.TestCase
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

            % Configure a license file for service to service auth
            customCredsFile = which('azuredatalakestore.json_servicetoservice');
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
            testCase.verifyNotEmpty(dlClient.Handle);
            testCase.verifyNotEmpty(dlClient.AccountFQDN);
            dlClient.delete();
        end

        function testCreateFile(testCase)
            import java.io.File;
            import java.io.FileInputStream;
            import java.io.FileOutputStream;
            import java.io.BufferedOutputStream;
            import java.io.PrintStream;

            disp('Running testCreateFile');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            stream = dlClient.createFile(fileName1, azure.datalake.store.IfExists.OVERWRITE);
            out = PrintStream(stream);
            for n = 1:10
                out.println("Line: " + n);
            end
            out.close();
            stream.close();
            dirEntry = dlClient.getDirectoryEntry(fileName1);
            if ispc
                testCase.verifyEqual(dirEntry.length,int64(91));
            else
                % if unix will be 10 bytes less because of line endings
                testCase.verifyEqual(dirEntry.length,int64(81));
            end
            % test with create Parent and octalPermissions
            fileName2 = 'myTmpADLUnitTestFileName2.tmp';
            dirName1 = 'myTmpADLUnitTestDirName1';
            octalPermission = '774';
            createParent = true;
            stream = dlClient.createFile(...
                    [dirName1,'/',fileName2],...
                    azure.datalake.store.IfExists.OVERWRITE,...
                    octalPermission,...
                    createParent);
            out = PrintStream(stream);
            for n = 1:10
                out.println("Line: " + n);
            end
            out.close();
            stream.close();
            dirEntry = dlClient.getDirectoryEntry([dirName1,'/',fileName2]);
            if ispc
                testCase.verifyEqual(dirEntry.length,int64(91));
            else
                % if unix will be 10 bytes less because of line endings
                testCase.verifyEqual(dirEntry.length,int64(81));
            end
            testCase.verifyEqual(dirEntry.permission,octalPermission);
            dlClient.delete;
        end

        function testConcatenateFiles(testCase)
            import java.io.File;
            import java.io.FileInputStream;
            import java.io.FileOutputStream;
            import java.io.BufferedOutputStream;
            import java.io.PrintStream;

            disp('Running testConcatenateFiles');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            stream = dlClient.createFile(fileName1, azure.datalake.store.IfExists.OVERWRITE);
            out = PrintStream(stream);
            for n = 1:10
                out.println("Line: " + n);
            end
            out.close();
            stream.close();
            fileName2 = 'myTmpADLUnitTestFileName2.tmp';
            stream = dlClient.createFile(fileName2, azure.datalake.store.IfExists.OVERWRITE);
            out = PrintStream(stream);
            for n = 1:10
                out.println("Line: " + n);
            end
            out.close();
            stream.close();
            % build a list for the files
            myFileList = cellstr({fileName1,fileName2});
            fileName3 = 'myTmpADLUnitTestFileName3.tmp';
            tf = dlClient.concatenateFiles(fileName3,myFileList);
            testCase.verifyTrue(tf);
            dirEntry = dlClient.getDirectoryEntry(fileName3);
            if ispc
                testCase.verifyEqual(dirEntry.length,int64(182));
            else
                % if unix number lower due to single byte line endings
                testCase.verifyEqual(dirEntry.length,int64(162));
            end
            dlClient.delete;
        end

        function testGetReadStream(testCase)
            import java.io.File;
            import java.io.FileInputStream;
            import java.io.FileOutputStream;
            import java.io.BufferedOutputStream;
            import java.io.PrintStream;

            disp('Running testGetReadStream');
            % write out some data
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            stream = dlClient.createFile(fileName1, azure.datalake.store.IfExists.OVERWRITE);
            out = PrintStream(stream);
            for n = 1:10
                out.println("Line: " + n);
            end
            out.close();
            stream.close();
            % read back the data
            stream = dlClient.getReadStream(fileName1);
            testCase.verifyTrue(isa(stream,'com.microsoft.azure.datalake.store.ADLFileInputStream'));
            data = stream.read();
            while(data ~= -1)
                data = [data stream.read()]; %#ok<AGROW>
            end
            stream.close();
            % check the first line reads back as 'Line: 1'
            testCase.verifyEqual(char(data(1:7)), 'Line: 1');
            dlClient.delete;
        end

        function testGetAppendStream(testCase)
            import java.io.File;
            import java.io.FileInputStream;
            import java.io.FileOutputStream;
            import java.io.BufferedOutputStream;
            import java.io.PrintStream;

            disp('Running testGetAppendStream');
            % write out some data
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            stream = dlClient.createFile(fileName1, azure.datalake.store.IfExists.OVERWRITE);
            out = PrintStream(stream);
            for n = 1:10
                out.println("Line: " + n);
            end
            out.close();
            stream.close();
            dirEntry = dlClient.getDirectoryEntry(fileName1);
            if ispc
                testCase.verifyEqual(dirEntry.length,int64(91));
            else
                testCase.verifyEqual(dirEntry.length,int64(81));
            end
            % read back the data
            stream = dlClient.getAppendStream(fileName1);
            testCase.verifyTrue(isa(stream,'com.microsoft.azure.datalake.store.ADLFileOutputStream'));
            out = PrintStream(stream);
            for n = 1:10
                out.println("Line: " + n);
            end
            out.close()
            stream.close();
            dirEntry = dlClient.getDirectoryEntry(fileName1);
            % check we appended the same amount of data sucessfully
            if ispc
                testCase.verifyEqual(dirEntry.length,int64(182));
            else
                testCase.verifyEqual(dirEntry.length,int64(162));
            end
            dlClient.delete;
        end

        function testCheckLoadnSave(testCase)
            disp('Running testCheckLoadnSave');
            % write out some data
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.mat';
            % create some random data and save it to ADL
            x = rand(10);
            dlClient.save(fileName1,'x');
            % redownload it from ADL and compare
            myVar = dlClient.load(fileName1);
            matches = (x == myVar.x);
            % should get a logical '1' i.e. non zero for each of the 10000 values
            testCase.verifyEqual(nnz(matches),100);
            dlClient.delete();
        end

        function testCheckAccess(testCase)
            disp('Running testCheckAccess');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            dirName = 'myTmpADLUnitTestDirName';
            tf = dlClient.createDirectory(dirName);
            testCase.verifyTrue(tf);
            tf = dlClient.checkAccess(dirName,'r--');
            testCase.verifyTrue(tf);
            dlClient.delete();
        end

        function testCreateDirectory(testCase)
            disp('Running testCreateDirectory');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            dirName = 'myTmpADLUnitTestDirName';
            tf = dlClient.createDirectory(dirName);
            testCase.verifyTrue(tf);
            dlClient.delete();
         end

        function testCheckExists(testCase)
            disp('Running testCheckExists');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            dirName = 'myTmpADLUnitTestDirName';
            tf = dlClient.createDirectory(dirName);
            testCase.verifyTrue(tf);
            % check is works on a directory
            tf = dlClient.checkExists(dirName);
            testCase.verifyTrue(tf);
            % define a nonsense value to check it works on a file
            % that does not exist
            fileName1 = 'myNonExistantFile1234567.tmp';
            tf = dlClient.checkExists(fileName1);
            testCase.verifyFalse(tf);
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            dlClient.createEmptyFile(fileName1);
            % check it works on a file
            tf = dlClient.checkExists(fileName1);
            testCase.verifyTrue(tf);
            dlClient.delete();
        end

        function testcreateEmptyFile(testCase)
            disp('Running testcreateEmptyFile');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            dlClient.createEmptyFile(fileName1);
            tf = dlClient.checkExists(fileName1);
            testCase.verifyTrue(tf);
            dlClient.delete();
        end

        function testRename(testCase)
            disp('Running testRename');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            fileName2 = 'myTmpADLUnitTestFileName2.tmp';
            dlClient.createEmptyFile(fileName1);
            % check the rename returned true
            tf = dlClient.rename(fileName1, fileName2);
            testCase.verifyTrue(tf);
            % check the new file exists
            tf = dlClient.checkExists(fileName2);
            testCase.verifyTrue(tf);
            % check the new original file no longer exists
            tf = dlClient.checkExists(fileName1);
            testCase.verifyFalse(tf);
            dlClient.delete();
        end

        function testDeleteRecursive(testCase)
            disp('Running testDeleteRecursive');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            dirName1 = 'myTmpADLUnitTestDirName1';
            dirName2 = 'myTmpADLUnitTestDirName2';
            dirName3 = 'myTmpADLUnitTestDirName3';
            allDirs = [dirName1,'/',dirName2,'/',dirName3];
            tf = dlClient.createDirectory(allDirs);
            testCase.verifyTrue(tf);
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            fullPath = [allDirs,'/',fileName1];
            dlClient.createEmptyFile(fullPath);
            % check creation worked
            tf = dlClient.checkExists(fullPath);
            testCase.verifyTrue(tf);
            tf = dlClient.deleteRecursive(dirName1);
            testCase.verifyTrue(tf);
            % check file has been deleted
            tf = dlClient.checkExists(fullPath);
            testCase.verifyFalse(tf);
            dlClient.delete();
        end

        function testUpload(testCase)
           disp('Running testUpload');
           dlClient = azure.datalake.store.ADLStoreClient;
           dlClient.initialize();
           fileName1 = 'myTmpADLUnitTestFileName1.tmp';
           testCase.verifyFalse(dlClient.checkExists(fileName1));
           x=rand(10);
           fileName2 = 'myTmpADLUnitTestFileName2.mat';
           save(fileName2,'x');
           dlClient.upload(fileName1, fileName2);
           testCase.verifyTrue(dlClient.checkExists(fileName1));
           tf = dlClient.delete(fileName1);
           delete(fileName2);
           testCase.verifyTrue(tf);
           dlClient.delete();
        end

        function testDownload(testCase)
           disp('Running testDownload');
           dlClient = azure.datalake.store.ADLStoreClient;
           dlClient.initialize();
           fileName1 = 'myTmpADLUnitTestFileName1.mat';
           testCase.verifyFalse(dlClient.checkExists(fileName1));
           x=rand(10);
           y=x;
           save(fileName1,'x');
           dlClient.upload(fileName1, fileName1);
           delete(fileName1);
           testCase.verifyTrue(dlClient.checkExists(fileName1));
           dlClient.download(fileName1, fileName1);
           load(fileName1,'x');
           matches = (x == y);
           % should get a logical '1' i.e. non zero for each of the 100 values
           testCase.verifyEqual(nnz(matches),100);

           tf = dlClient.delete(fileName1);
           testCase.verifyTrue(tf);
           delete(fileName1);
           dlClient.delete();
        end

        function testGetContentSummary(testCase)
            import matlab.unittest.TestCase;
            import matlab.unittest.constraints.IsGreaterThan;
            import matlab.unittest.constraints.IsEqualTo;

            disp('Running testGetContentSummary');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            dlClient.createEmptyFile(fileName1);
            dirName1 = 'myTmpADLUnitTestDirName1';
            tf = dlClient.createDirectory(dirName1);
            testCase.verifyTrue(tf);
            cs = dlClient.getContentSummary('/');
            testCase.verifyThat(cs.directoryCount, IsGreaterThan(0) );
            testCase.verifyThat(cs.fileCount, IsGreaterThan(0) );
            cs = dlClient.getContentSummary(fileName1);
            % cast to a double for the unit test FW, safe in this case
            testCase.verifyThat(double(cs.length),IsEqualTo(0));
            cs = dlClient.getContentSummary(dirName1);
            testCase.verifyThat(double(cs.length),IsEqualTo(0));
            dlClient.delete();
        end

        function testEnumerateDirectory(testCase)
            disp('Running testEnumerateDirectory');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            dirName1 = 'myTmpADLUnitTestDirName1';
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            fileName2 = 'myTmpADLUnitTestFileName2.tmp';
            tf = dlClient.createDirectory(dirName1);
            testCase.verifyTrue(tf);
            % test for the empty testRemoveDefaultAclsdirectory entry
            dirTable = dlClient.enumerateDirectory(dirName1);
            testCase.verifySize(dirTable,[0 0]);
            % test for directory plus two files
            dlClient.createEmptyFile([dirName1,'/',fileName1]);
            dlClient.createEmptyFile([dirName1,'/',fileName2]);
            dirTable = dlClient.enumerateDirectory(dirName1);
            testCase.verifySize(dirTable,[2 13]);
            % test for 1 entry retrieved
            dirTable = dlClient.enumerateDirectory(dirName1, 'maxEntriesToRetrieve', int32(1));
            testCase.verifySize(dirTable,[1 13]);
            % test startAfter returning only fileName2 entry
            dirTable = dlClient.enumerateDirectory(dirName1, 'startAfter', fileName1);
            testCase.verifySize(dirTable,[1 13]);
            testCase.verifyEqual(dirTable.Name{1},fileName2);
            % test the end before option should return no entries
            dirTable = dlClient.enumerateDirectory(dirName1, 'startAfter', fileName1, 'endBefore', fileName2);
            % TODO update when a fix for endBefore behaviour is known
            %
            % testCase.verifySize(dirTable,[0 0]);
            % test the UGR modes (UPN Human readable form)
            rep = azure.datalake.store.UserGroupRepresentation.UPN;
            OIDLength = 36;
            dirTable = dlClient.enumerateDirectory(dirName1, 'UserGroupRepresentation', rep);
            % very unlikely that both would otherwise equal 36 as too long for normal use
            testCase.verifyNotEqual(length(dirTable.Group{1}),OIDLength);
            testCase.verifyNotEqual(length(dirTable.User{1}),OIDLength);
            rep = azure.datalake.store.UserGroupRepresentation.OID;
            dirTable = dlClient.enumerateDirectory(dirName1, 'UserGroupRepresentation', rep);
            % in this case both should have a length of 36
            testCase.verifyEqual(length(dirTable.Group{1}),OIDLength);
            testCase.verifyEqual(length(dirTable.User{1}),OIDLength);
            dlClient.delete();
        end

        function testGetDirectoryEntry(testCase)
            disp('Running testGetDirectoryEntry');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            dirName1 = 'myTmpADLUnitTestDirName1';
            rep = azure.datalake.store.UserGroupRepresentation.UPN;
            tf = dlClient.createDirectory(dirName1);
            testCase.verifyTrue(tf);
            % test with a UGR arg
            dirEntry = dlClient.getDirectoryEntry(dirName1,rep);
            testCase.verifyEqual(dirEntry.name,dirName1);
            % OID entries are 36 chars
            testCase.verifyNotEqual(length(dirEntry.group),36);
            dirEntry = dlClient.getDirectoryEntry(dirName1);
            testCase.verifyEqual(dirEntry.name,dirName1);
            dlClient.delete();
        end

        function testSetExpiryTime(testCase)
            disp('Running testSetExpiryTime');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            if dlClient.checkExists(fileName1)
                tf = dlClient.delete(fileName1);
                testCase.verifyTrue(tf);
            end
            dlClient.createEmptyFile(fileName1);
            expOpt = azure.datalake.store.ExpiryOption.RELATIVETONOW;
            rep = azure.datalake.store.UserGroupRepresentation.UPN;
            % set the expiry time to now + 24 hours
            dlClient.setExpiryTime(fileName1, expOpt, int64(1000*60*60*24));
            dirTable = dlClient.enumerateDirectory(fileName1, 'UserGroupRepresentation', rep);
            timeNew = dirTable.ExpiryTime{1};
            nowIsh = datetime('now','TimeZone','UTC');
            timeDelta = seconds(timeNew - nowIsh);
            % Fail if more than a 24 hour + 5 second delta between the time
            % just set and returned expiry time
            disp(dirTable);
            disp('timeNew');
            disp(timeNew);
            disp('nowIsh');
            disp(nowIsh);
            disp('timeDelta');
            disp(timeDelta);
            testCase.verifyLessThan(timeDelta,5+24*60*60);
            tf = dlClient.delete(fileName1);
            testCase.verifyTrue(tf);
            dlClient.delete();
        end

        function testSetPermission(testCase)
            disp('Running testSetPermission');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            dlClient.createEmptyFile(fileName1);
            dirEntry1 = dlClient.getDirectoryEntry(fileName1);
            % test default permission
            testCase.verifyEqual(dirEntry1.permission, '770');
            newPerm = '744';
            dlClient.setPermission(fileName1,newPerm)
            dirEntry2 = dlClient.getDirectoryEntry(fileName1);
            % test new permission set
            testCase.verifyEqual(dirEntry2.permission, newPerm);
            dlClient.delete();
        end

        function testSetTimes(testCase)
            disp('Running testSetTimes');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            dlClient.createEmptyFile(fileName1);
            % get files timestamps
            dirEntry1 = dlClient.getDirectoryEntry(fileName1);
            % introduce some 'measureble' delta T
            pause(1);
            nowIsh = datetime('now','TimeZone','UTC');
            % tolerate a small difference in time between now and the
            % recently created file times
            timeDelta = seconds(nowIsh - dirEntry1.lastAccessTime);
            testCase.verifyLessThan(timeDelta,10);
            timeDelta = seconds(nowIsh - dirEntry1.lastModifiedTime);
            testCase.verifyLessThan(timeDelta,10);
            newAccessTime = nowIsh + hours(1.5);
            dlClient.setTimes(fileName1,newAccessTime,NaT);
            dirEntry2 = dlClient.getDirectoryEntry(fileName1);
            accessTimeDelta = newAccessTime - dirEntry2.lastAccessTime;
            testCase.verifyLessThan(accessTimeDelta,10);
            dlClient.delete();
        end

        function testRemoveAllAcls(testCase)
            disp('Running testRemoveAllAcls');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            dlClient.createEmptyFile(fileName1);
            aclStat1 = dlClient.getAclStatus(fileName1);
            testCase.verifyTrue(isempty(aclStat1.aclSpec));
            % TODO add some ACLs and verify they take
            dlClient.removeAllAcls(fileName1);
            aclStat2 = dlClient.getAclStatus(fileName1);
            testCase.verifyTrue(isempty(aclStat2.aclSpec));
            dlClient.delete();
        end

        function testGetAclStatus(testCase)
            disp('Running testGetAclStatus');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            dlClient.createEmptyFile(fileName1);
            % check the octal permissions
            aclStat = dlClient.getAclStatus(fileName1, azure.datalake.store.UserGroupRepresentation.UPN);
            testCase.verifyTrue(ischar(aclStat.octalPermissions));
            testCase.verifyEqual(length(aclStat.octalPermissions),3);
            % check the OID UGR length
            aclStat = dlClient.getAclStatus(fileName1);
            testCase.verifyTrue(ischar(aclStat.owner));
            testCase.verifyEqual(length(aclStat.owner),36);
            % check the sticky bit
            testCase.verifyTrue(islogical(aclStat.stickyBit));
            % check the default aclSpec is empty
            testCase.verifyTrue(isempty(aclStat.aclSpec));
            dlClient.delete();
        end

        function testSetAcl(testCase)
            disp('Running testSetAcl');
            % setup a client
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            % create a file
            fileName1 = 'myTmpADLUnitTestFileName1.tmp';
            dlClient.createEmptyFile(fileName1);
            % check the default acl is not set
            aclStat = dlClient.getAclStatus(fileName1,azure.datalake.store.UserGroupRepresentation.UPN);
            testCase.verifyTrue(isempty(aclStat.aclSpec));
            % build and acl spec
            myAclEntryList{1} = azure.datalake.store.acl.AclEntry(azure.datalake.store.acl.AclScope.ACCESS,...
                                                            azure.datalake.store.acl.AclType.USER,...
                                                            'myemail@mycompany.com',...
                                                            azure.datalake.store.acl.AclAction.READ_WRITE);
            % dlClient.setAcl(fileName1,myAclEntryList);
            % TODO determine why this fails
            dlClient.delete();
        end

        function testUpdateToken(testCase)
            % TODO requires methods to get token, for now provider only exists
            % in initialize()
        end

        function testSetOptions(testCase)
            % TODO address pending fix for setAcl behaviour
            %   myStoreOptions = azure.datalake.store.ADLStoreOptions();
            %   myStoreOptions.setFilePathPrefix('mypathprefix');
            %   dlClient.setOptions(myStoreOptions);
        end

        function testModifyAclEntries(testCase)
            % TODO address pending fix for setAcl behaviour
        end

        function testRemoveAclEntries(testCase)
            % TODO address pending fix for setAcl behaviour
%             disp('Running testRemoveDefaultAcls');
%             dlClient = azure.datalake.store.ADLStoreClient;
%             dlClient.initialize();
%             dlClient.delete();
        end

        function testRemoveDefaultAcls(testCase)
            disp('Running testRemoveDefaultAcls');
            dlClient = azure.datalake.store.ADLStoreClient;
            dlClient.initialize();
            dirName = 'myTmpADLUnitTestDirName';
            tf = dlClient.createDirectory(dirName);
            testCase.verifyTrue(tf);
            dirEntry1 = dlClient.getDirectoryEntry(dirName,azure.datalake.store.UserGroupRepresentation.UPN);
            % check the ACL is not set to begin with
            testCase.verifyFalse(dirEntry1.aclBit);
            aclStat1 = dlClient.getAclStatus(dirName, azure.datalake.store.UserGroupRepresentation.UPN);
            testCase.verifyEqual(size(aclStat1.aclSpec),[0 0]);
            % setup an ACL entry object and test it matches to posix form
            myAclEntry1 = azure.datalake.store.acl.AclEntry(azure.datalake.store.acl.AclScope.ACCESS,azure.datalake.store.acl.AclType.USER,aclStat1.owner,azure.datalake.store.acl.AclAction.READ_WRITE);
            myAclPosixStr1 = ['user:' aclStat1.owner ':rw-'];
            testCase.verifyEqual(myAclPosixStr1,char(myAclEntry1.toString()));
            % setup another to build a spec
            myAclEntry2 = azure.datalake.store.acl.AclEntry(azure.datalake.store.acl.AclScope.ACCESS,azure.datalake.store.acl.AclType.GROUP,aclStat1.group,azure.datalake.store.acl.AclAction.READ_WRITE);
            myAclPosixStr2 = ['group:' aclStat1.group ':rw-'];
            testCase.verifyEqual(myAclPosixStr2,char(myAclEntry2.toString()));
            myAclSpecStr = [myAclPosixStr1 ',' myAclPosixStr2];
            % convert the string to a spec
            myAclSpec = myAclEntry2.parseAclSpec(myAclSpecStr);
% TODO see setAcl to fix application of ACL and update
%             % apply the spec
%             dlClient.setAcl(dirName,myAclSpec);
%             % TODO why is this failing
%             dirEntry2 = dlClient.getDirectoryEntry(dirName1,azure.datalake.store.UserGroupRepresentation.UPN);
%             aclStat2 = dlClient.getAclStatus(dirName1, azure.datalake.store.UserGroupRepresentation.UPN);
            dlClient.delete();
        end
    end

end
