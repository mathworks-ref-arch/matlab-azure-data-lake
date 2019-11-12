# Azure Data Lake Basic Usage

## First steps
This document assumes the following steps described in [Getting Started](GettingStarted.md) have been completed:

* Configured Active Directory
* Configured a Data Lake Store
* Installed the client software
* Preferably configured an azuredatalakestore.json credentials file

Not all of the operations supported by the Interface are described here. For further documentation refer to the help for the individual commands or the [API reference](AzureDataLakeApi.md) document.

By and large the Azure Data Lake API wraps the HDFS API and thus a subset of functionality normally available in that API is available through the MATLAB client.

See [Logging](Logging.md) for details of enabling verbose output during development and testing.

## Set paths
Run the *startup.m* file in the */Azure-Data-Lake-Storage/Software/MATLAB* directory, this configures required paths in advance of using the client.
```
startup
Adding Interface for Azure Data Lake Storage Paths
Adding /home/username/mydir/Azure-Data-Lake-Storage/Software/MATLAB/app
Adding /home/username/mydir/Azure-Data-Lake-Storage/Software/MATLAB/app/functions
Adding /home/username/mydir/Azure-Data-Lake-Storage/Software/MATLAB/app/system
Adding /home/username/mydir/Azure-Data-Lake-Storage/Software/MATLAB/lib
Adding /home/username/mydir/Azure-Data-Lake-Storage/Software/MATLAB/config
Running post setup operations
Adding: /home/username/mydir/Azure-Data-Lake-Storage/Software/MATLAB/lib/jar/target/azure-dl-sdk-0.1.0.jar
```

## Declare and initialize a client
A client is declared as follows:
```
dlClient = azure.datalake.store.ADLStoreClient

dlClient =

  ADLStoreClient with properties:

             ClientId: ''
    AuthTokenEndpoint: ''
            ClientKey: ''
          AccountFQDN: ''
          NativeAppId: ''
           AuthOption: SERVICETOSERVICE
           ConfigFile: ''
```
However this client must now be initialized, this means setting configuration values for the client and creating an underlying client using the Azure SDK. As can be seen from the above properties these are mainly used for authentication. [Getting Started](GettingStarted.md) describes two authentication methods; End-user and Service-to-service. As can be seen Service-to-service is enabled by default. Templates are provided for the configuration files and [Getting Started](GettingStarted.md) describes where get the values required.

If the AccountFQDN property is not set, i.e. the client has not been configured manually or in a script, then by default the MATLAB path will be searched for a configuration file named *azuredatalakestore.json*. This file should contain values that are used to configure some of the properties depending on the authentication method being used. To use an alternate configuration file set dlClient.ConfigFile to the path of this file prior to calling initialize().
```
dlClient.ConfigFile = '/home/username/myconfigfile.json';
```
This is useful if using more than one client at a time with differing credentials. It is recommended that authentication credentials not be hard-wired into code where they will be subject to sharing and revision control.

Initializing a declared client is done by calling the initialize() method as follows:
```
dlClient.initialize();
```

## Listing stored files
Begin by listing or enumerating the files we have stored in Data Lake. Note Data Lake uses Unix style forward slash path separators i.e. '/' and names are case sensitive. Drive letters are not used and the root directory is indicated by a leading forward slash.
```
dlClient = azure.datalake.store.ADLStoreClient;
dlClient.initialize();
dirTable = dlClient.enumerateDirectory('/')

dirTable =

  4x13 table

          Name                FullName         Length                    Group                                      User                         LastAccessTime             LastModified            Type         Blocksize     ReplicationFactor    Permission    AclBit    ExpiryTime
    _________________    __________________    ______    ______________________________________    ______________________________________    ______________________    ______________________    ___________    ___________    _________________    __________    ______    __________

    'MyTestDirectory'    '/MyTestDirectory'    [   0]    '007c1793-1234-1234-1234-7af3d135f990'    '9f528dd4-7813-4f10-bbfb-84f0b43459d8'    [10-Jan-2018 16:17:46]    [10-Jan-2018 16:17:46]    [DIRECTORY]    [        0]    [0]                  '770'         [0]       [NaT]     
    'README.md'          '/README.md'          [1707]    '007c1793-1234-1234-1234-7af3d135f990'    '007c1793-1234-1234-1234-7af3d135f990'    [21-Dec-2017 14:50:14]    [21-Dec-2017 14:50:14]    [FILE     ]    [268435456]    [1]                  '770'         [0]       [NaT]     
    'RELEASENOTES.md'    '/RELEASENOTES.md'    [ 651]    '007c1793-1234-1234-1234-7af3d135f990'    '007c1793-1234-1234-1234-7af3d135f990'    [21-Dec-2017 14:50:08]    [21-Dec-2017 14:50:08]    [FILE     ]    [268435456]    [1]                  '770'         [0]       [NaT]     
    'Readme.txt'         '/Readme.txt'         [2962]    '007c1793-1234-1234-1234-7af3d135f990'    '007c1793-1234-1234-1234-7af3d135f990'    [08-Dec-2017 18:16:02]    [08-Dec-2017 18:16:02]    [FILE     ]    [268435456]    [1]                  '770'         [1]       [NaT]     

```

Here we can see entries in a table corresponding to the metadata for the listed files and directories. The 36 character strings representing Users and Groups are not very user friendly, specifying a UPN UserGroupRepresentation can improve this.

```
rep = azure.datalake.store.UserGroupRepresentation.UPN;
dirTable = dlClient.enumerateDirectory('/', 'UserGroupRepresentation', rep)

dirTable =

  4x13 table

          Name                FullName         Length           Group                    User                LastAccessTime             LastModified            Type         Blocksize     ReplicationFactor    Permission    AclBit    ExpiryTime
    _________________    __________________    ______    ____________________    ____________________    ______________________    ______________________    ___________    ___________    _________________    __________    ______    __________

    'MyTestDirectory'    '/MyTestDirectory'    [   0]    'myemail@mycompany.com'    'MATLAB'                [10-Jan-2018 16:17:46]    [10-Jan-2018 16:17:46]    [DIRECTORY]    [        0]    [0]                  '770'         [0]       [NaT]     
    'README.md'          '/README.md'          [1707]    'myemail@mycompany.com'    'myemail@mycompany.com'    [21-Dec-2017 14:50:14]    [21-Dec-2017 14:50:14]    [FILE     ]    [268435456]    [1]                  '770'         [0]       [NaT]     
    'RELEASENOTES.md'    '/RELEASENOTES.md'    [ 651]    'myemail@mycompany.com'    'myemail@mycompany.com'    [21-Dec-2017 14:50:08]    [21-Dec-2017 14:50:08]    [FILE     ]    [268435456]    [1]                  '770'         [0]       [NaT]     
    'Readme.txt'         '/Readme.txt'         [2962]    'myemail@mycompany.com'    'myemail@mycompany.com'    [08-Dec-2017 18:16:02]    [08-Dec-2017 18:16:02]    [FILE     ]    [268435456]    [1]                  '770'         [1]       [NaT]     
```
Other options that control directory enumeration are:
* maxEntriesToRetrieve
* startAfter
* endBefore

To get metadata information about just one directory entry, e.g. to check file size, use the getDirectoryEntry() function.

To check if a file or directory exists without enumerating the directory use the checkExists() function.


## Creating a directory

```
dlClient.createDirectory('myDirName')
Creating directory: myDirName

ans =

  logical

   1
```
To create a directory with specific access permissions using Unix style octal permissions:
```
dlClient.createDirectory('myMatFiles', '744')
```


## Saving variables directly to Data Lake

save() will save variables to a .mat (or other supported format) file on Data Lake. It can be used very much like the functional form of the built-in save command with three caveats:
* The '-append' option is not supported.
* An entire workspace cannot be saved i.e. dlClient.save('myfile.mat') because the Azure Data Lake objects are not serializable. The workspace variables should be listed explicitly to overcome this.
* Only the formal functional form  interface, i.e. save(<my-arguments>), is supported.

```
x = rand(10);
y = rand(10);
dlClient.save('mymatfile.mat', 'x', 'y');
```
Save will overwrite files and create parent directories if required.


## Uploading a file to Data Lake
upload() can be used to upload an arbitrary local file to a given location on Data Lake as follows:
```
dlClient.upload('myadlfilename.csv', 'mylocalfilename.csv');

```
An IfExists ENUM can control if the operation will overwrite an existing file (default) or fail and throw an exception.
```
% optionally have the function fail if the destination file already exists
dlClient.upload('myadlfilename.csv', 'mylocalfilename.csv', azure.datalake.store.IfExists.FAIL);
```
This method can be used with any file type.


## Saving data via OutputStreams

Alternatively use the following functions to return a com.microsoft.azure.datalake.store.ADLFileOutputStream this can be used to write arbitrary data to a file as though using java.io.OutputStream.
* createFile()
* getAppendStream()

Concatenate files already stored in Data Lake as follows:
```
myFileList = cellstr({'myFile1.txt','myFile2.txt'});
tf = dlClient.concatenateFiles('myFile3.txt',myFileList);
```
The files listed by myFileList are concatenated to form myFile3.txt. Note, this is typically only appropriate for text based files e.g. log or CSV files. It should not be used with binary .mat files.


## Retrieving variables directly from Data Lake

The load function loads variables from an Azure Data Lake file into a struct. Load can be used very much like the functional form of the built-in load command.
```
myVars = dlClient.load('mymatfile.mat');
```

Alternatively load specific variables as follows
```
myVars = dlClient.load('mymatfile.mat', 'x', 'y');
```
Note, as the entire mat file must be downloaded from Data Lake in each case, the latter approach may not save a significant amount of time.

The getReadStream() function can be used to return a Java input stream, specifically
a com.microsoft.azure.datalake.store.ADLFileInputStream. This can be used to read arbitrary data as with a conventional java.io.InputStream.

## Downloading a file from Data Lake
Files can be downloaded from Data Lake using the download method as follows:
```
dlClient.download('myadlfilename.csv', 'mylocalfilename.csv');
```
This method can be used with any file type, download will overwrite an existing local file if present.


## Deleting a file

Delete a file or directory as follows:
```
tf = dlClient.delete('/my/path/to/file1.mat');
```
To recursively delete a directory tree in one operation use the deleteRecursive() function.


## Deleting a Client
When finished using a client it is good practice to delete it as follows:
```
dlClient.delete;
```

----------------

[//]: #  (Copyright 2017 The MathWorks, Inc.)
