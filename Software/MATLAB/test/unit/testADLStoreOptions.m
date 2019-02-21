classdef testADLStoreOptions < matlab.unittest.TestCase
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
            myOpts = azure.datalake.store.ADLStoreOptions();
            % check the object type
            testCase.verifyClass(myOpts,'azure.datalake.store.ADLStoreOptions');
        end
        
        % TODO add tests to apply the following option configurations
        
        % TODO determine if this is supported in the latest SDK versions or has been deprecated.
        %         function testSetDefaultTimeout(testCase)
        %             % TODO test with a client
        %             myOpts = azure.datalake.store.ADLStoreOptions();
        %             myOpts.setDefaultTimeout(10000);
        %         end
        
        function testSetFilePathPrefix(testCase)
            disp('Running testSetFilePathPrefix');
            % TODO test with a client
            myOpts = azure.datalake.store.ADLStoreOptions();
            myOpts.setFilePathPrefix('myprefix');
        end
        
        function testSetUserAgentSuffix(testCase)
            % TODO test with a client
            disp('Running testSetUserAgentSuffix');
            myOpts = azure.datalake.store.ADLStoreOptions();
            myOpts.setUserAgentSuffix('mysuffix');
        end
        
        function testEnableThrowingRemoteExceptions(testCase)
            % TODO test with a client
            disp('Running testEnableThrowingRemoteExceptions');
            myOpts = azure.datalake.store.ADLStoreOptions();
            myOpts.enableThrowingRemoteExceptions();
        end
        
        function testSetInsecureTransport(testCase)
            % TODO test with a client
            disp('Running testSetInsecureTransport');
            myOpts = azure.datalake.store.ADLStoreOptions();
            myOpts.setInsecureTransport();
        end
        
    end
    
end
