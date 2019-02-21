classdef ADLStoreOptions < azure.object
    % ADLSTOREOPTIONS Options to configure the behavior of ADLStoreClient
    %
    % Example:
    %       myStoreOptions = azure.datalake.store.ADLStoreOptions();

    % Copyright 2018 The MathWorks, Inc.


    methods
        %% constructor
        function obj = ADLStoreOptions()
            obj.Handle = com.microsoft.azure.datalake.store.ADLStoreOptions();
        end 
       
    end %methods
end %class
