# MATLAB Interface *for Azure Data Lake Storage* API documentation


## Objects:
* `Software\MATLAB\app\system\+azure\@object`
* `Software\MATLAB\app\system\+azure\+datalake\+store\@ADLStoreClient`
* `Software\MATLAB\app\system\+azure\+datalake\+store\@ADLStoreOptions`
* `Software\MATLAB\app\system\+azure\+datalake\+store\@AuthenticationOption`
* `Software\MATLAB\app\system\+azure\+datalake\+store\@ContentSummary`
* `Software\MATLAB\app\system\+azure\+datalake\+store\@DirectoryEntry`
* `Software\MATLAB\app\system\+azure\+datalake\+store\@DirectoryEntryType`
* `Software\MATLAB\app\system\+azure\+datalake\+store\@ExpiryOption`
* `Software\MATLAB\app\system\+azure\+datalake\+store\@IfExists`
* `Software\MATLAB\app\system\+azure\+datalake\+store\@OperationResponse`
* `Software\MATLAB\app\system\+azure\+datalake\+store\@UserGroupRepresentation`
* `Software\MATLAB\app\system\+azure\+datalake\+store\+acl\@AclAction`
* `Software\MATLAB\app\system\+azure\+datalake\+store\+acl\@AclEntry`
* `Software\MATLAB\app\system\+azure\+datalake\+store\+acl\@AclScope`
* `Software\MATLAB\app\system\+azure\+datalake\+store\+acl\@AclStatus`
* `Software\MATLAB\app\system\+azure\+datalake\+store\+acl\@AclType`



------

## @object

### @object/object.m
```notalanguage
  OBJECT Root Class for all Azure wrapper objects



```

------


## @ADLStoreClient

### @ADLStoreClient/ADLStoreClient.m
```notalanguage
  ADLSTORECLIENT Client for the Azure Data Lake
  Connect to the Azure Data Lake Store and use for an extensible persistence
  from MATLAB applications. This client will use OAuth2 to connect to the
  Azure Data Store via the SDK and permit access to the contents in the
  store.
 



```
### @ADLStoreClient/checkAccess.m
```notalanguage
  CHECKACCESS Check if user has file or directory access permissions
  The permission to check for should be in rwx string form. The call returns
  true if the caller has all the requested permissions. For example, specifying
  'r-x' succeeds if the caller has read and execute permissions.
  True is returned if the call succeeds otherwise false.
 
  Example:
    dlClient.checkAccess('/my/path/to/file1.mat','r-x');
 



```
### @ADLStoreClient/checkExists.m
```notalanguage
  CHECKEXISTS Checks that a file or directory exists.
  Returns true if it exists otherwise false
 
  Example:
    dlClient.checkExists('file1.mat');
 



```
### @ADLStoreClient/concatenateFiles.m
```notalanguage
  CONCATENATEFILES Concatenate the specified list of files into this file.
  The target should not exist. The source files will be deleted if the
  concatenate succeeds. Returns true if the call succeeds. pathVal is the full
  pathname of the destination to concatenate files into and fileList is cell
  array of character vectors containing full pathnames of the files to
  concatenate. This cannot be empty.
 
  Example:
    % create a cellstr array listing paths
    myFileList = cellstr({'/my/path1/file1.txt','/my/path2/file2.txt'});
    tf = dlClient.concatentateFiles('/destination/path/output.txt',myFileList);
 



```
### @ADLStoreClient/createDirectory.m
```notalanguage
  CREATEDIRECTORY Creates a directory and parent directories as required.
 
  Example:
    dlClient.createDirectory('myMatFiles')
 
    % Or create a file with specific octal permissions
    dlClient.createDirectory('myMatFiles', '744')
 



```
### @ADLStoreClient/createEmptyFile.m
```notalanguage
  CREATEEMPTYFILE creates an empty file
 



```
### @ADLStoreClient/createFile.m
```notalanguage
  CREATEFILE Creates a file
  Returns an ADLFileOutputStream that can then be written to unless
  ifExistsMode is false and the file already exists.
 



```
### @ADLStoreClient/delete.m
```notalanguage
  DELETE Method to delete an Azure Data Lake file or directory
  True is returned if the call succeeds.
 
  Example:
    % Delete file /my/path/to/file1.mat
    tf = dlClient.delete('/my/path/to/file1.mat');
 



```
### @ADLStoreClient/deleteRecursive.m
```notalanguage
  DELETERECURSIVE deletes directory and it's child directories and files recursively.
  True is returned if the call succeeds.
 
  Example:
    dlClient.deleteRecursive('/my/path/to/mydirectory');
 



```
### @ADLStoreClient/download.m
```notalanguage
  DOWNLOAD Download contents of an Azure Data Lake file to a local file
  download will overwrite an existing file if present.
 
  Example:
        % download myadlfilename.csv to a local file
        dlClient.download('myadlfilename.csv', 'mylocalfilename.csv');
 



```
### @ADLStoreClient/enumerateDirectory.m
```notalanguage
  ENUMERATEDIRECTORY List of DirectoryEntry objects for the specified directory
  Enumerates the contents of a directory, returning a table of directory
  object metadata, one row per file or directory in the specified directory.
  To avoid overwhelming the client or the server, the call may return a
  partial list. A number of options exist to control the number of entries
  returned. Arguments other than the path value are parameterised. If a directory
  contains no files or directories an empty table is returned.
 
  Examples:
    dirTable = dlClient.enumerateDirectory('/mydirectory')
        Where /mydirectory is the path to the directory to enumerate
 
    rep = azure.datalake.store.UserGroupRepresentation.UPN;
    dirTable = enumerateDirectory('/mydirectory', 'UserGroupRepresentation', rep)
        Where  myUserGroupRepresentation is a UserGroupRepresentation
        enumeration specifying whether to return user and group information
        as OID or UPN.
 
    dirTable = enumerateDirectory('/mydirectory', 'maxEntriesToRetrieve', 10)
        Where 10 is the maximum number of entries to retrieve. Note
        that server can limit the number of entries retrieved to a number
        smaller than the number specified.
 
    dirTable = enumerateDirectory('/mydirectory', 'startAfter', 'FilenameABC')
        Where FilenameABC is the filename after which to begin enumeration.
 
    dirTable = enumerateDirectory('/mydirectory', 'maxEntriesToRetrieve', 10,...
         'startAfter', 'FilenameABC')
 
    dirTable = enumerateDirectory('/mydirectory', 'startAfter', 'FilenameABC',
         'endBefore', 'FilenameXYZ')
        Where FilenameXYZ is the filename before which to end the enumeration.
 
    rep = azure.datalake.store.UserGroupRepresentation.OID
    dirTable = enumerateDirectory('/mydirectory', 'maxEntriesToRetrieve', 10,...
        'startAfter', 'FilenameABC', 'UserGroupRepresentation', rep)
 
    *******************************************************************
    *
    * Note: due to an issue with the underlying Azure SDK the endBefore
    * argument is not currently functional, instead rely on
    * startAfter and maxEntriesToRetrieve
    *
    *******************************************************************



```
### @ADLStoreClient/getAclStatus.m
```notalanguage
  GETACLSTATUS Queries the ACLs and permissions for a file or directory
  An object of type azure.datalake.store.acl.AclStatus is returned.
 
  Example:
    aclStat = dlClient.getAclStatus(dirName, azure.datalake.store.UserGroupRepresentation.UPN);
 



```
### @ADLStoreClient/getAppendStream.m
```notalanguage
  GETAPPENDSTREAM returns an ADLFileInputStream to append to an existing file



```
### @ADLStoreClient/getContentSummary.m
```notalanguage
  GETCONTENTSUMMARY Gets the content summary of a file or directory
 
  Example:
    dlClient.getContentSummary('/myPath/myMatFile.mat')
 



```
### @ADLStoreClient/getDirectoryEntry.m
```notalanguage
  GETDIRECTORYENTRY Gets the directory metadata about a file or directory
 
  Example:
    myDirEntry = dlClient.getDirectoryEntry('/path/to/myMatFile.mat')
  or
    myDirEntry = dlClient.getDirectoryEntry('/path/to/myMatFile.mat',UGRType)
 



```
### @ADLStoreClient/getReadStream.m
```notalanguage
  GETREADSTREAM Returns an ADLFileInputStream to read the file contents from



```
### @ADLStoreClient/initialize.m
```notalanguage
  INITIALIZE Method to initialize the Data Lake Client prior to use
  This method will initialize client. It checks authentication credentials
  if already set or reads then from a configuration file. By default
  Service-to-service authentication is used.
 
  Examples:
    % default service-to-service authentication with default configuration
    file
    dlClient = azure.datalake.store.ADLStoreClient;
    dlClient.initialize();
 
    % authentication using a non default configuration file
    dlClient = azure.datalake.store.ADLStoreClient;
    dlClient.ConfigFile = '/home/username/myconfigfile.json'
    dlClient.initialize;
    To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code DYE69A87C to authenticate.
    % Once the browser based sign in process has completed client ca be used
    % to access Data Lake.
 
    % end user authentication without using a configuration file
    dlClient = azure.datalake.store.ADLStoreClient;
    dlClient.AuthOption = azure.datalake.store.AuthenticationOption.ENDUSER;
    dlClient.AccountFQDN = 'matlabdemo.azuredatalakestore.net';
    dlClient.NativeAppId = '1d184e4a-62c0-4244-8b68-4cffe757131c';
    dlClient.initialize;
    To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code DYE69A87C to authenticate.
    % Once the browser based sign in process has completed client ca be used
    % to access Data Lake.
 



```
### @ADLStoreClient/load.m
```notalanguage
  LOAD Loads variables from an Azure Data Lake file into a struct
  Note if only a subset of the variables in a file are required the entire
  file must still be downloaded in the background from Azure. load can be
  used very much like the functional form of the built-in load command.
 
  Example:
        % load the variables from a matfile
        dlClient = azure.datalake.store.ADLStoreClient;
        dlClient.initialize();
        myVars = dlClient.load('mymatfile.mat');
    Or
        myVars = dlClient.load('mymatfile.mat', 'x', 'y');
 



```
### @ADLStoreClient/modifyAclEntries.m
```notalanguage
  MODIFYACLENTRIES Modify the ACL entries for a file or directory
  This call merges the supplied list with existing ACLs. If an entry with the
  same scope, type and user already exists, then the permissions are replaced.
  If not, than an new ACL entry if added.
 
  Example:
    dlClient.modifyAclEntries('myPath/myMatFile.mat', myAclSpec)
 



```
### @ADLStoreClient/removeAclEntries.m
```notalanguage
  REMOVEACLENTRIES Removes the specified ACL entries from a file or directory
 
  Example:
    dlClient.removeAclEntries('myPath/myMatFile.mat', myAclSpec)
 



```
### @ADLStoreClient/removeAllAcls.m
```notalanguage
  REMOVEALLACLS removes all ACL entries from a directory
 
  Example:
    dlClient.removeAllAcls('/my/directory/path')
 



```
### @ADLStoreClient/removeDefaultAcls.m
```notalanguage
  REMOVEDEFAULTACLS Removes all default ACL entries from a directory
 
  Example:
    dlClient.removeDefaultAcls('/my/directory/path')
 



```
### @ADLStoreClient/rename.m
```notalanguage
  RENAME Method to rename Azure Data Lake files
  This method will rename a Data Lake file. If the overwrite boolean is%
  true an existing file will be overwritten.
  If the destination is a non-empty directory, then the call fails rather than
  overwrite the directory. True is returned if the call succeeds.
 
  Example:
    Rename file1.mat to file2.mat overwriting file2 if is already exists
    dlClient.rename('file1.mat','file2.mat', true)
 



```
### @ADLStoreClient/save.m
```notalanguage
  SAVE Save variables to an Azure Data Lake file
  Save will overwrite files and create parent directories if required.
  If required parent directories do not exist they will not be created and
  the call will fail. True is returned if the call succeeds.
 
  Save can be used very much like the functional form of the built-in save
  command with two exceptions:
    1) The '-append' option is not supported.
    2) An entire workspace cannot be saved i.e. dlClient.save('myfile.mat')
       because the Azure Data Lake objects are not serializable. The
       workspace variables should be listed explicitly to overcome this.
 
  Example:
        % save the variables x and y to a .mat file
        dlClient = azure.datalake.store.ADLStoreClient;
        dlClient.initialize();
        x = rand(10);
        y = rand(10);
        dlClient.save('mymatfile.mat', 'x', 'y');
 



```
### @ADLStoreClient/setAcl.m
```notalanguage
  SETACL Sets the ACLs for a file or directory
  If the file or directory already has any ACLs associated with it, then all the
  existing ACLs are removed before adding the specified ACLs. aclSpecs is a
  cell array of aclEntry objects.
 
  Example:
    aclString = 'user:myemail@mycompany.com:rwx, group::rwx, other::r--';
    aclEntries = azure.datalake.store.acl.AclEntry.parseAclSpec(aclString);
    dlClient.setAcl('myPath/myMatFile.mat', aclEntries);
 
   **********************************************************************
   *
   * There is a known issue with the setting of some ACLs, validate ACLs
   % are applied via the Azure portal
   *
   **********************************************************************
 



```
### @ADLStoreClient/setExpiryTime.m
```notalanguage
  SETEXPIRYTIME Sets the expiry time on a file
 
  Example:
    % Set the expiry time to 24 hours from now
    setExpiryTime('/my/path/myfile.txt', azure.datalake.store.ExpiryOption.RELATIVETONOW, int64(1000*60*60*24));
 



```
### @ADLStoreClient/setOptions.m
```notalanguage
  SETOPTIONS Sets the options to configure the behavior of this client
  The options argument can be of type:
  com.microsoft.azure.datalake.store.ADLStoreOptions or
  azure.datalake.store.ADLStoreOptions
 
  Example:
    myStoreOptions = azure.datalake.store.ADLStoreOptions();
    myStoreOptions.setFilePathPrefix('mypathprefix');
    dlClient.setOptions(myStoreOptions);
 



```
### @ADLStoreClient/setOwner.m
```notalanguage
  SETOWNER Sets the owner and group of a file
  To change either the user or group but leave one value unchanged pass an
  empty character vector '' for that value. Both values cannot be ''.
 
  Example:
    dlClient.setOwner('myPath/myMatFile.mat','OwnerID','GroupID')
 
  Note, setting the ownership of a file or directory requires superuser
  privileges for the Data Lake store. Ownership can only be changed by the
  account owner, not by the owner of a given file or directory.
  To check ownership in the Data Lake store account in the Azure portal
  click on Access Control. The user should be listed and the role should
  say "Owner".
 
  This methods can only be used with End User based authentication.
 



```
### @ADLStoreClient/setPermission.m
```notalanguage
  SETPERMISSION Sets the Octal Permissions on a file
 
  Example:
    dlClient = azure.datalake.store.ADLStoreClient;
    dlClient.initialize();
    dlClient.setPermission('myMatFile.mat','744')
 



```
### @ADLStoreClient/setTimes.m
```notalanguage
  SETTIMES Sets one or both of Modified and Access times of the file or directory
  path - full pathname of file or directory to set times for
  atime - Access time as datetime
  mtime - Modified time as a datetime
 
  Example:
    setExpiryTime('/my/path/myfile.txt', atime, mtime);
 



```
### @ADLStoreClient/updateToken.m
```notalanguage
  UPDATETOKEN Update token on existing client
  Tokens can be passed in as a character vector or as an AzureADToekn.
  This can be used if the client is to be used over long time and token has
  expired. The token is the AAD token string or OAuth2 token.
  Note a required methods to retrieve the token is not currently implemented.
 



```
### @ADLStoreClient/upload.m
```notalanguage
  UPLOAD Upload contents of a local file to an Azure Data Lake file
  upload will overwrite an existing file if present by default.
 
  Example:
        % upload a local file
        dlClient.upload('myadlfilename.csv', 'mylocalfilename.csv');
 
        % optionally have the function fail if the destination file already exists
        dlClient.upload('myadlfilename.csv', 'mylocalfilename.csv', azure.datalake.store.IfExists.FAIL);
 



```

------


## @ADLStoreOptions

### @ADLStoreOptions/ADLStoreOptions.m
```notalanguage
  ADLSTOREOPTIONS Options to configure the behavior of ADLStoreClient
 
  Example:
        myStoreOptions = azure.datalake.store.ADLStoreOptions();



```
### @ADLStoreOptions/enableThrowingRemoteExceptions.m
```notalanguage
  ENABLETHROWINGREMOTEEXCEPTIONS Throw server-returned exception name
  Throw server-returned exception name instead of ADLExcetption. ADLStoreClient
  methods throw ADLException on failure. ADLException contains additional fields
  that have details on the error that occurred, like the HTTP response code and
  the server request ID, etc. However, in some cases, server returns an
  exception name in it's HTTP error stream. Calling this method causes the
  ADLStoreClient methods to throw the exception name returned by the server
  rather than ADLException. In general, this is not recommended, since the name
  of the remote exception can also be retrieved from ADLException.
  This method exists to enable usage within Hadoop as a file system.
 
  Example:
        myStoreOptions.enableThrowingRemoteExceptions();



```
### @ADLStoreOptions/setDefaultTimeout.m
```notalanguage
  SETDEFAULTTIMEOUT Sets default timeout for calls by ADLStoreClient methods
 
  Example:
        myStoreOptions.setDefaultTimeout(10000);



```
### @ADLStoreOptions/setFilePathPrefix.m
```notalanguage
  SETFILEPATHPREFIX Set a prefix that will be prepended to all file paths
  This allows the client to be scoped to a subset of the directory Azure Data
  Lake Store tree.
 
  Example:
        myStoreOptions.setFilePathPrefix('mypathprefix');



```
### @ADLStoreOptions/setInsecureTransport.m
```notalanguage
  SETINSECURETRANSPORT Use http as transport for back-end calls instead of https
  This is to allow unit testing using mock or fake web servers. Warning: Do not
  use this for talking to real Azure Data Lake service, since https is the only
  supported protocol on the server.
 
  Example:
        myStoreOptions.setInsecureTransport();



```
### @ADLStoreOptions/setUserAgentSuffix.m
```notalanguage
  SETUSERAGENTSUFFIX Sets the user agent suffix in http User-Agent header
  sets the user agent suffix to be added to the User-Agent header in all HTTP
  requests made to the server. This suffix is appended to the end of the
  User-Agent string constructed by the SDK.
 
  Example:
        myUserOptions.setUserAgentSuffix('my header string');



```

------


## @AuthenticationOption

### @AuthenticationOption/AuthenticationOption.m
```notalanguage
  AUTHENTICATIONOPTION Specifies how to authenticate to Data Lake
    ENDUSER  : An end user's Azure credentials are used to authenticate.
               MATLAB returns a message with a URL and code that prompts
               the user for their credentials. This authentication mechanism
               is interactive and the application runs in the logged in
               user's context.
 
    SERVICETOSERVICE : The application authenticates itself with Data Lake
               Create an Azure Active Directory (AD) application and use
               the key from the Azure AD application to authenticate with
               Data Lake.This authentication mechanism is non-interactive.
 
  The default authentication method is SERVICETOSERVICE.
 



```

------


## @ContentSummary

### @ContentSummary/ContentSummary.m
```notalanguage
  CONTENTSUMMARY Contains the return values from getContentSummary call
 



```

------


## @DirectoryEntry

### @DirectoryEntry/DirectoryEntry.m
```notalanguage
  DIRECTORYENTRY Class to represent metadata for directories or files
  DirectoryEntry objects are returned by calls such as enumerateDirectory
  and getDirectoryEntry.
 
  Examples:
    obj = DirectoryEntry(name,fullName,length,group,user,lastAccessTime,...
         lastModifiedTime,type,blocksize,replicationFactor,permission,...
         aclBit, expiryTime)
 
    myDirEntry = dlClient.getDirectoryEntry('/path/to/myMatFile.mat')
 



```

------


## @DirectoryEntryType

### @DirectoryEntryType/DirectoryEntryType.m
```notalanguage
  DIRECTORYENTRYTYPE specifies if a directory entry is a file or directory
    FILE      : directory entry is a file
    DIRECTORY : directory entry is a directory



```

------


## @ExpiryOption

### @ExpiryOption/ExpiryOption.m
```notalanguage
  EXPIRYOPTION Specifies how to interpret an expiry time in a setExpiry call
    ABSOLUTE  : Interpret as date/time
    NEVEREXPIRE : No expiry
    RELATIVETOCREATIONDATE : Interpret as milliseconds from the file's creation date+time
    RELATIVETONOW : Interpret as milliseconds from now
 



```

------


## @IfExists

### @IfExists/IfExists.m
```notalanguage
  IFEXISTS specifies actions to take if creating a file that already exists.
 
    FAIL      : fail the request
    OVERWRITE : overwrite the file



```

------


## @OperationResponse

### @OperationResponse/OperationResponse.m
```notalanguage
  OPERATIONRESPONSE Information about a response from a server call
  This class is a container for all the information from making a server call.
 



```
### @OperationResponse/reset.m
```notalanguage
  RESET Reset response object to initial state
 



```

------


## @UserGroupRepresentation

### @UserGroupRepresentation/UserGroupRepresentation.m
```notalanguage
  USERGROUPREPRESENTATION specifies how user & group objects are represented
  Determines return type in calls that return user and group ID
    OID : Object ID, a GUID representing the ID of the user or group
    UPN : User Principal Name of the group or user, the human-friendly
          user name.
  An instance can be declared as follows:
 
  Example:
    ugr = azure.datalake.store.UserGroupRepresentation.UPN;
 
  This can then be used to to specify a return type for example:
    aclStat = dlClient.getAclStatus('/README.md',ugr);
 



```

------


## @AclAction

### @AclAction/AclAction.m
```notalanguage
  ACLACTION Specifies the possible combinations of actions allowed in an ACL
 



```
### @AclAction/fromOctal.m
```notalanguage
  FROMOCTAL Returns an AclAction enum corresponding to an octal digit
  false is returned in the case of invalid input.
 
  Example:
        % set and aclAction enum to ALL (i.e. rwx)
        myAclEnum = azure.datalake.store.acl.AclAction.fromOctal(7);



```
### @AclAction/fromRwx.m
```notalanguage
  FROMRWX Returns AclAction enum corresponding to the rwx permission string
  The input character vector can be upper or lower case and unset fields
  should be set to '-' e.g. 'r-x'. In the case of invlaid input logical
  false is returned.
 
  Example:
        % set and aclAction enum to WRITE
        myAclEnum = azure.datalake.store.acl.AclAction.fromRwx('-w-')



```
### @AclAction/isValidRwx.m
```notalanguage
  ISVALIDRWX Checks if a string is a valid rwx permission string
  Leading and trailing white space and mixed case are ignored.
  true is returned for valid inputs and false for invalid inputs.
 
  Example:
        % Test a valid value
        tf = azure.datalake.store.acl.AclAction.isValidRwx('-W-');
        % Test an invalid value
        tf = azure.datalake.store.acl.AclAction.isValidRwx('-W');



```
### @AclAction/toOctal.m
```notalanguage
  TOOCTAL returns the octal representation of an AclAction
 
  Example:
        % return the octal value of myAclAction
        myOctalInt = azure.datalake.store.acl.AclAction.toOctal(myAclAction)



```
### @AclAction/toString.m
```notalanguage
  TOSTRING returns the rwx string representation of an AclAction
 
  Example:
        myRwxStr = azure.datalake.store.acl.AclAction.toString(myAclAction)



```
### @AclAction/valueOf.m
```notalanguage
  VALUEOF Returns the enum constant of the type specified by name
  false is returned if an invalid name is given.
 
  Example:
        myAclActionEnum = azure.datalake.store.acl.AclAction.valueOf('WRITE')



```
### @AclAction/values.m
```notalanguage
  VALUES Returns cell array containing constants of this enum type
  The order is the order in which they are declared.
 



```

------


## @AclEntry

### @AclEntry/AclEntry.m
```notalanguage
  ACLENTRY An ACL for an object consists of a List of ACL entries
  Contains one ACL entry. An ACL entry consists of a scope (access or
  default), the type of the ACL (user, group, other or mask), the name of
  the user or group associated with this ACL (can be blank to specify the
  default permissions for users and groups, and must be blank for mask
  entries), and the action permitted by this ACL entry.
 
  Example:
    myAclEntry = azure.datalake.store.acl.AclEntry(azure.datalake.store.acl.AclScope.DEFAULT,...
                                azure.datalake.store.acl.AclType.USER,...
                                'myfilename.ext',...
                                azure.datalake.store.acl.AclAction.READ_WRITE);
 



```
### @AclEntry/aclEntryConv.m
```notalanguage
  ACLENTRYCONV Convert a Java ACL Entry object to MATLAB ACL Entry object
  Accepts input of type com.microsoft.azure.datalake.store.acl.AclEntry
  and returns an equivalent object of type azure.datalake.store.acl.AclEntry
 



```
### @AclEntry/aclEntryListToCellArray.m
```notalanguage
  ACLENTRYLISTTOCELLARRAY Converts an aclEntry list to aclEntry cell array
 
  Example:
        myAclEntryCellArray = azure.datalake.store.acl.AclEntry.aclEntryListToCellArray(myJavaAclEntryList)



```
### @AclEntry/aclListToString.m
```notalanguage
  ACLLISTTOSTRING Convert an aclEntries cell array to a POSIX aclspec string
  If the aclspec string will be used to remove an existing ACL from a file
  or folder, then the permission level does not need to be specified.
  Passing true as a removeAcl argument omits the permission level in the
  output string. The string is returned as a character vector.
 
  Example:
        removeAcl = true;
        myPosixStr = azure.datalake.store.acl.AclEntry.aclListToString(...
                            myAclEntryCellArray,...
                            removelAcl);



```
### @AclEntry/parseAclEntry.m
```notalanguage
  PARSEACLENTRY Parses an aclEntry from its POSIX string form
  Parses an aclEntry from its POSIX string form. For example:
  'default:user:bob:r-x'
  If the ACL string will be used to remove an existing ACL from a file or
  folder, then the permission level does not need to be specified. Passing
  false to the removeAcl argument tells the parser to accept such strings.
 
  Example:
        removeAcl = false;
        myAclEntry = azure.datalake.store.acl.AclEntry(...
                           'default:user:bob:r-x',...
                           removeAcl);



```
### @AclEntry/parseAclSpec.m
```notalanguage
  PARSEACLSPEC Converts a POSIX ACL spec string to aclEntry objects
  Returns a cell array of MATLAB aclEntry objects
 
  Example:
        user1 = 'user:foo:rw-';
        user2 = 'user:bar:r--';
        group1 = 'group::r--';
        myAclSpec = [user1 ',' user2 ',' group1];
        aclEntries = azure.datalake.store.acl.AclEntry.parseAclSpec(myAclSpec);



```
### @AclEntry/toString.m
```notalanguage
  TOSTRING Returns the POSIX string form of an aclEntry
  A character vector is returned, e.g. 'default:user:bob:r-x'
  If the ACL string will be used to remove an existing ACL from a file or
  folder, then the permission level does not need to be specified.
  Passing true to the removeAcl argument omits the permission level in the
  output string.
 
  Example:
        removeAcl = true;
        myPosixStr = myAclEntry.toString();



```

------


## @AclScope

### @AclScope/AclScope.m
```notalanguage
  ACLSCOPE The scope of an ACL Entry (access or default)
 



```

------


## @AclStatus

### @AclStatus/AclStatus.m
```notalanguage
  ACLSTATUS Contains ACL and Permission information for a file or directory
 



```

------


## @AclType

### @AclType/AclType.m
```notalanguage
  ACLTYPE Type of Acl entry (user, group, other, or mask)
 



```

------

## Misc. Related Functions
### functions/AzureShell.m
```notalanguage
  AZURESHELL Invokes the Azure Web Browser based shell
  Cloud Shell enables access to a browser-based command-line experience with
  Azure. It is an interactive, browser-accessible shell for managing Azure
  resources. The shell can be Bash or PowerShell. The system configured browser
  is used. Authentication will be requested if not already in place within the
  browser.



```
### functions/AzureStorageExplorer.m
```notalanguage
  AZURESTORAGEEXPLORER Invokes the Azure Storage Explorer
  Launches the Azure Storage Explorer. It is possible to specify the local
  installation of the storage explorer in the configuration file.



```
### functions/Logger.m
```notalanguage
  Logger - Object definition for Logger
  ---------------------------------------------------------------------
  Abstract: A logger object to encapsulate logging and debugging
            messages for a MATLAB application.
 
  Syntax:
            logObj = Logger.getLogger();
 
  Logger Properties:
 
      LogFileLevel - The level of log messages that will be saved to the
      log file
 
      DisplayLevel - The level of log messages that will be displayed
      in the command window
 
      LogFile - The file name or path to the log file. If empty,
      nothing will be logged to file.
 
      Messages - Structure array containing log messages
 
  Logger Methods:
 
      clearMessages(obj) - Clears the log messages currently stored in
      the Logger object
 
      clearLogFile(obj) - Clears the log messages currently stored in
      the log file
 
      write(obj,Level,MessageText) - Writes a message to the log
 
  Examples:
      logObj = Logger.getLogger();
      write(logObj,'warning','My warning message')
 



```
### functions/azRoot.m
```notalanguage
  AZROOT Helper function to locate the Azure tooling.
 
  Locate the installation of the Azure tooling to allow easier construction
  of absolute paths to the required dependencies.



```



------------    

[//]: #  (Copyright 2019 The MathWorks, Inc.)
