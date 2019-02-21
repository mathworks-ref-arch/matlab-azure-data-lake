# Permissions and Access Control Lists

## Octal Permissions

Octal permissions are a relatively simple way to control access permissions to for files and directories and are widely documented.

To set the octal permissions on a file or directory use the following call:
```
dlClient.setPermission('myMatFile.mat','744');
```

To check if a file or directory has specific permissions for the user as follows:
```
tf = dlClient.checkAccess('/my/path/to/file1.mat','r-x');
```


## Using Access Control Lists (ACLs)

#### *Please note Data Lake ACL support is not complete in this release. If additional ACL functionality is required contact MathWorks*

### Getting an ACL
Access Control Lists provide a more flexible way to control access to files and directories than octal permissions.

To query the ACLs associated with a file or directory use getAclStatus() as follows:
```
aclStat = dlClient.getAclStatus('/mymatfile.mat')

aclStat =

  AclStatus with properties:

             aclSpec: {}
               group: '007c1783-7438-453c-a713-7af3d167f990'
    octalPermissions: '770'
               owner: '007c1783-7438-453c-a713-7af3d167f990'
           stickyBit: 0
```
aclstat.aclSpec will be returned as a cell array containing azure.datalake.store.acl.AclEntry objects for the file or directory in question if they exist.

To display a more easily read group an owner ID, request the User Principal Name or UPN form as follows:
```
ugr = azure.datalake.store.UserGroupRepresentation.UPN;
aclStat = dlClient.getAclStatus('/README.md', ugr)

aclStat =

  AclStatus with properties:

             aclSpec: {}
               group: 'myemail@mycompany.com'
    octalPermissions: '770'
               owner: 'myemail@mycompany.com'
           stickyBit: 0
```



### Further Reading
The following links provide further information on access control:

*  [HDFS Permissions Guide ](https://hadoop.apache.org/docs/current/hadoop-project-dist/hadoop-hdfs/HdfsPermissionsGuide.html#ACLs_.28Access_Control_Lists.29)

* [Data Lake Access Control](https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-access-control)

* [Microsoft data-lake-adlstool](https://azure.github.io/data-lake-adlstool/doc/)

----------------
[//]: #  (Copyright 2017 The MathWorks, Inc.)
