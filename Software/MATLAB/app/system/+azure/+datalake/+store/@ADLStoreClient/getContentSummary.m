function cs = getContentSummary(obj, pathval)
% GETCONTENTSUMMARY Gets the content summary of a file or directory
%
% Example:
%   dlClient.getContentSummary('/myPath/myMatFile.mat')
%

% Copyright 2018 The MathWorks, Inc.

import com.microsoft.azure.datalake.store.ADLStoreClient;


% Create a logger object
%logObj = Logger.getLogger();

% validate input
p = inputParser;
p.CaseSensitive = false;
p.FunctionName = 'getContentSummary';
addRequired(p,'pathval',@ischar);
parse(p,pathval);

contentSummaryJ = obj.Handle.getContentSummary(pathval);
directoryCount = int64(contentSummaryJ.directoryCount);
fileCount = int64(contentSummaryJ.fileCount);
length = int64(contentSummaryJ.length);
spaceConsumed = int64(contentSummaryJ.spaceConsumed);

cs = azure.datalake.store.ContentSummary(directoryCount,fileCount,length,spaceConsumed);

end %function
