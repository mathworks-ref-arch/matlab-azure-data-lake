# Frequently Asked Questions

## FAQ
### 1) I cannot delete an Application Registration in the Azure Portal
This is most likely caused by the application being set to multi-tenant, which is the default case for native applications. To resolve this first edit the manifest for the application and change:
```
availableToOtherTenants=false
```

### 2) I am getting an error and I need more information on an exception
Logged error messages generate and throw an exception. This can be caught in higher level code using a standard try-catch. Note an exception may include lower-level exceptions in the *cause* property and or may include additional information in the *stack* property value. Inspect an error that has just occurred at the console as follows:
```
Error using azure.datalake.store.ADLStoreClient/enumerateDirectory (line 78)
my sample bad error message
Caused by:
    my sample causal exception message
m = MException.last
m =
  MException with properties:

    identifier: 'Azure:DataLake'
       message: 'my sample bad error message'
         cause: {[1×1 MException]}
         stack: [1×1 struct]
```


By design many methods are minimal wrappers of the corresponding Java SDK methods. Thus much of the error checking and reporting is handled at the SDK level. However the debug information returned by an exception in the Java SDK is not always complete and it may be possible to get more information by further interrogating the exception. The following example shows how to modify the code to extract such information when investigating a problem.

Many Data Lake exception are of class *com.microsoft.azure.datalake.store.ADLException* which is derived from *java.io.IOException*. In the following example we will catch such an exception and use it to determine the root cause of an error. Consider the *setAcl()* function. This function takes a path and a cell array of ACL Specs and applies the Specs to the file or directory given by the path. The ACL Specs may be quite complex with many entries. The SDK call within this method is as follows:
```
obj.Handle.setAcl(pathVal, aclEntryListJ);
```

If we call this method with an ACL cell array that results in aclEntryListJ value of the following:
```
aclEntryListJ.toString

ans =

[user:joe.blog@mycompany.com:rwx, group::rwx]
```
This error is returned:

```
dlClient.setAcl('/myDirName/myFile.txt', aclStat.aclSpec)
Error using azure.datalake.store.ADLStoreClient/setAcl (line 37)
Java exception occurred:
com.microsoft.azure.datalake.store.ADLException: Error setting ACLs for /myDirName/myFile.txt
Operation SETACL failed with HTTP403 : AclException
Last encountered exception thrown after 1 tries. [HTTP403(AclException)]
 [ServerRequestId:cff3e47d-e9cd-4190-8b26-cbd3d9d784ce]

	at com.microsoft.azure.datalake.store.ADLStoreClient.getExceptionFromResponse(ADLStoreClient.java:1158)

	at com.microsoft.azure.datalake.store.ADLStoreClient.setAcl(ADLStoreClient.java:894)
```

If this generic message from the Data Lake SDK is not sufficient to diagnose the problem, we can catch the exception an examine it further as it contains a number of additional fields that contain information about the success or failure of the server call. Replace the *obj.Handle.setAcl(pathVal, aclEntryListJ)* call with the following code and rerun the call with a break point following *ex = e.ExceptionObject*.
```
try
  obj.Handle.setAcl(pathVal, aclEntryListJ);
catch e
  e.message
  if(isa(e,'matlab.exception.JavaException'))
    ex = e.ExceptionObject;
    assert(isjava(ex));
    ex.printStackTrace;
  end
end
```

When the exception has been caught we can examine its fields. The fields can be determined in detail from the Data Lake documentation or from a debugging breakpoint with the following command:
```
fieldnames(ex)

ans =

  9x1 cell array

    {'httpResponseCode'            }
    {'httpResponseMessage'         }
    {'requestId'                   }
    {'numRetries'                  }
    {'lastCallLatency'             }
    {'responseContentLength'       }
    {'remoteExceptionName'         }
    {'remoteExceptionMessage'      }
    {'remoteExceptionJavaClassName'}
```
In this case remoteExceptionMessage is remote exception message returned by the server in an HTTP error message. The Microsoft SDK does not display this information in its exception message.

```
ex.remoteExceptionMessage

ans =

Invalid ACL: the user, group and other entries are required. [23c6a9cf-5da9-42bd-8fd2-1462d30f8fa2][2018-02-12T04:21:15.2665333-08:00]
```
This gives a further clue as to what the underlying problem may be.

## References
[1. Data Lake store end user authenticate using Active Directory](https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-end-user-authenticate-using-active-directory)

[2. Azure Data Lake Storage Gen1 Java API docs](https://azure.github.io/azure-data-lake-store-java/javadoc/)

----------------
[//]: #  (Copyright 2017 The MathWorks, Inc.)
