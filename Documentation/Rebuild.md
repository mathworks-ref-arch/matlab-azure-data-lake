# Building the Interface

The jar files required by this package can be downloaded and built as follows. The package's *pom.xml* file can be found in: */Azure-Data-Lake-Storage/Software/Java*.

Use the following commands or OS specific equivalents to do a maven build of the package's jar file. If not already installed first install Maven.
```
$ cd Azure-Data-Lake-Storage/Software/Java
$ mvn clean verify package
```

The above pom file currently references version *2.3.0-preview2* of the Azure Data Lake SDK:
```
<dependency>
    <groupId>com.microsoft.azure</groupId>
    <artifactId>azure-data-lake-store-sdk</artifactId>
    <version>2.3.0-preview2</version>
</dependency>
```

To build with a more recent version of the SDK, amend the pom file to a specific version or use the following syntax to allow maven to select a newer version. Caution, this may result in build or runtime issues.
```
<dependency>
    <groupId>com.microsoft.azure</groupId>
    <artifactId>azure-data-lake-store-sdk</artifactId>
    <version>[2.3.0-preview2,)</version>
</dependency>
```

-------------
[//]: #  (Copyright 2017 The MathWorks, Inc.)
