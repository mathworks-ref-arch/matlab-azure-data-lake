function [str] = azDLRoot(varargin)
% AZDLROOT Helper function to locate the Azure Data Lake interface
%
% Locate the installation of the Azure tooling to allow easier construction
% of absolute paths to the required dependencies.

% Copyright 2016 The MathWorks, Inc.

str = fileparts(fileparts(fileparts(mfilename('fullpath'))));

end %function
