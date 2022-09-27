# MATLAB Interface *for Azure Data Lake Storage*

This is a MATLAB® interface that connects to the Azure™ Data Lake™ Storage service.

**This package has been deprecated, please use the following package instead: [https://github.com/mathworks-ref-arch/matlab-azure-services](https://github.com/mathworks-ref-arch/matlab-azure-services)
This package may be removed in the future.**

## Requirements
### MathWorks products
* Requires MATLAB R2017a or later

### 3rd party products
To build a required JAR file:
* Maven™
* JDK 8
* Microsoft® Azure Data Lake Storage SDK for Java®

## Getting Started
The following assumes the following steps described in [Getting Started](Documentation/GettingStarted.md) have been completed:

* Configured Active Directory
* Configured a Data Lake Storage
* Installed the MATLAB interface
* Preferably configured an azuredatalakestore.json credentials file


### Create and initialize the Data Lake Client
Run the *startup.m* file in the */Azure-Data-Lake-Storage/Software/MATLAB* directory, this configures required paths in advance of using the client. Then declare and initialize a Client as follows:
```
startup;
dlClient = azure.datalake.store.ADLStoreClient;
dlClient.initialize();
```

### Creating a directory

```
dlClient.createDirectory('myDirName')
Creating directory: myDirName

ans =

  logical

   1
```

### Uploading a file to Data Lake
upload() can be used to upload an arbitrary local file to a given location on Data Lake as follows:
```
dlClient.upload('myadlfilename.csv', 'mylocalfilename.csv');
```

### Downloading a file from Data Lake
Files can be downloaded from Data Lake using the download method as follows:
```
dlClient.download('myadlfilename.csv', 'mylocalfilename.csv');
```


### Deleting a file
Delete a file or directory as follows:
```
tf = dlClient.delete('/my/path/to/file1.mat');
```

### Deleting a client
When finished using a client it is good practice to delete it as follows:
```
dlClient.delete;
```


## Supported Products

MathWorks Products (https://www.mathworks.com)
1.  MATLAB (R2017a or later)
2.  MATLAB Compiler and Compiler SDK (R2017a or later)
3.  MATLAB Production Server (R2017a or later)
4.  MATLAB Distributed Computing Server (R2017a or later)   

This package is primarily tested on Ubuntu 16.04 and Windows 10.

## License
The license for the MATLAB Interface for Azure Data Lake Storage is available in the [LICENSE.md](LICENSE.md) file in this GitHub repository. This package uses certain third-party content which is licensed under separate license agreements. See the [pom.xml](Software/Java/pom.xml) file for third-party software downloaded at build time.

## Enhancement Request
Provide suggestions for additional features or capabilities using the following link:   
https://www.mathworks.com/products/reference-architectures/request-new-reference-architectures.html

## Support
Email: `mwlab@mathworks.com`

[//]: #  (Copyright 2017 The MathWorks, Inc.)
