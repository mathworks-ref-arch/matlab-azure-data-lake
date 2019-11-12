# MATLAB Interface *for Azure Data Lake*
# Release Notes

## Release 0.6.1 5th November 2019
* Renamed azRoot function to distinguish from other Azure interfaces
* Added Security notice
* Added Proxy support
* Updated Data Lake SDK to version 2.3.4
* Added a log4j.properties configuration file

## Release 0.6.0 February 18th 2019
* Documentation improvements
* Changed License agreement
* Removed Scripts directory level from utilities
* Removed SDK directory level from MATLAB
* Renamed and relocated jar file
* Improvements to logging infrastructure

## Release 0.5.1 September 25th 2018
* Minor documentation updates
* Fixed a bug in startup.m handling of the dynamic javaclasspath
* Improved load's handling of non .mat file types

## Release 0.5.0 September 21th 2018
* Split WASB and Data Lake support into separate packages, this package retains only Data Lake support
* Removed demos pending updates
* Documentation updates

## Release 0.4.0 August 15th 2018
* *MAY REQUIRE UPDATES TO EXISTING CODE*
* Syntax fix in Data Lake End user credentials file and associated documentation
* Significant and wide ranging WASB documentation improvements
* Updated unit tests
* CloudBlobClient Class
    * Added getDirectoryDelimiter() & setDirectoryDelimiter()
    * Removed Parent property
    * listContainers(), bug fix
* CloudBlobContainer Class
    * Moved Parent property to a method, getParent()
    * Added ServiceClient property
    * Converter Name property to character vector type
    * getBlockBlobReference(), added specified blob name support
    * getDirectoryReference, bug fix
    * Enabled getStorageUri()
    * listBlobs(), bug fixes
    * Added a StorageUri constructor for SAS support
* CloudBlobDirectory Class
    * Moved Parent property to a method, getParent()
    * Added getContiner() & getPrefix()
    * Constructor bug fix
    * listBlobs(), bug fixes
    * Change to trailing delimiter behavior
* CloudBlockBlob Class
    * Constructor bug fix
    * Moved Parent property to a method, getParent()
    * download(), changed delimiter handling
    * Added getContainer()

## Release 0.3.5 August 9th 2018
* Data Lake Store documentation improvements
* CloudBlobContainer documentation improvements
* Improved CloudBlobClient.getContainerReference implementation
* Fix to CloudBlobDirectory constructor
* Minor fix to CloudStorageAccount
* Improved documentation

## Release 0.3.4 June 19th 2018
* Fix to Data Lake client constructor and initialize documentation
* Added support for alternate Data Lake configuration files
* Added End-user authentication for Data Lake
* Improved Data Lake documentation

## Release 0.3.3 June 7th 2018
* Added Data Lake upload method
* Added Data Lake download method
* Improved documentation
* Minor bug fixes

## Release 0.3.2 May 10th 2018
* Added verbose mode support to logging functionality
* Documentation improvements
* Minor bug fixes
* Added Blob SAS functionality
* Improved Table SAS functionality

## Release 0.3.1 May 2nd 2018
* Added blob exists() method
* Added blob triggered azure function demo

## Release 0.3.0 May 1st 2018
* The following calls are not backwardly compatible and require minor code changes, please review the relevant documentation listBlobs() download() upload() *REQUIRES UPDATES TO EXISTING CODE*
* Improved unit tests
* Added CloudBlobDirectory support
* Improved documentation
* Added basic SAS support

## Release 0.2.0 February 16th 2018
* Refactored object hierarchy to closer match MS SDK, *REQUIRES UPDATES TO EXISTING CODE*
* Added further ADL and Table functionality
* Improved documentation
* Added integration to Storage Explorer and Cloud Shell
* Moved main test environment to R2017b
* Added initial demo scripts in SDK/public

## Release 0.1.5 December 22nd 2017
* Fixed jar build to allow for Java 1.8 manifest handling
* Improved automated document generation
* Added preliminary Data Lake functionality
* Added preliminary Table functionality

## Release 0.1.4 December 8th 2017
* Added initial Table support classes
* Moved to logger based messages
* Improved documentation

## Release 0.1.3 November 27th 2017
* Added initial Data Lake support
* Documentation updates
* Automated pdf generation

## Release 0.1.2 November 14th 2017
* Reorganized directory structure

## Release 0.1.1 November 10th 2017
* Added proxy support and documentation for Blob Storage

## Release 0.1.0 October 18th 2017
* Initial release with support for Blob Storage

------------
[//]: #  (Copyright 2017 The MathWorks, Inc.)
