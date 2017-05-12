
# Karaf related 

## features


### features related format
`feature:repo-add mvn:<groupId>/<artifactId>/<version>/xml/features`

`mvn:org.apache.servicemix.camel/features/6.0.0.redhat-024/xml/features`

### feature.xml
<?xml version='1.0' encoding='UTF-8'?>
<features xmlns="http://karaf.apache.org/xmlns/features/v1.0.0" name="testlocalrepo-6.3.0.redhat-187">
    <feature name="testlocalrepo" version="1.0">
        <bundle>mvn:org.jboss.quickstarts.fuse/beginner-camel-cbr/6.3.0.redhat-187</bundle>
    </feature>
</features>

### how to generate the feature.xml?
below plugin will generate the feature.xml 

      <plugin>
        <groupId>org.apache.karaf.tooling</groupId>
        <artifactId>features-maven-plugin</artifactId>
        <version>2.4.0</version>
          <executions>
            <execution>
              <id>generate</id>
              <phase>generate-resources</phase>
              <goals>
                <goal>generate-features-xml</goal>
              </goals>
              <configuration>
                <kernelVersion>2.4.0</kernelVersion>
                <outputFile>target/features.xml</outputFile>
              </configuration>
            </execution>
          </executions>
        </plugin>


eg:
fuse-6.3.0.redhat-187

then put the file into the directory:

`/home/wuxiaohui/.m2/repository/org/jboss/quickstarts/fuse/beginner-camel-cbr/6.3.0.redhat-187`
`ls`

`beginner-camel-cbr-6.3.0.redhat-187-features.xml`

`beginner-camel-cbr-6.3.0.redhat-187.jar`

`features:addurl mvn:org.jboss.quickstarts.fuse/beginner-camel-cbr/6.3.0.redhat-187/xml/features`

which is the same directory with the bundle

`osgi:install mvn:org.jboss.quickstarts.fuse/beginner-camel-cbr/6.3.0.redhat-187`

commands to create a profile
```
profile-create --parent default cosprofile
fabric:profile-change-parents cosprofile feature-camel
fabric:profile-edit --repository  mvn:org.jboss.quickstarts.fuse/beginner-camel-cbr/6.3.0.redhat-187/xml/features cosprofile
fabric:profile-edit --feature testlocalrepo cosprofile
container-create-child root testrepocon
container-add-profile testrepocon cosprofile
```

# fabric related
shutting down a fabric
https://access.redhat.com/documentation/en-us/red_hat_jboss_fuse/6.3/html/fabric_guide/esbruntimefabricshutdown

### repository
By default, all the profiles inherit form the profile "default". So  you can edit the "default" profile
edit the file
```
io.fabric8.agent through the admin console http://localhost:8181/hawtio: 
WiKi-> Root/fabric/profiles/default->io.fabric8.agent.properties
```

change the property:
```
org.ops4j.pax.url.mvn.defaultRepositories= \
    file:${runtime.home}/${karaf.default.repository}@snapshots@id=karaf-default,\
    file:${runtime.data}/maven/upload@snapshots@id=fabric-upload,\
    file:${user.home}/.m2/repository@snapshots@id=local
```

modify the one 
 `file:${user.home}/.m2/repository@snapshots@id=local`

to the real maven repository like:

    `file:///home/daniel/customrepository@snapshots@id=local`

for more information about the maven repo, pls check 

[1]https://access.redhat.com/documentation/en-us/red_hat_jboss_fuse/6.3/html/configuring_and_running_jboss_fuse/fabricmavenproxy


especially this part: 

```
org.ops4j.pax.url.mvn.settings
    Specifies a path on the file system to override the default location of the Maven settings.xml file. The Fabric8 agent resolves the location of the Maven settings.xml file in the following order:

        The location specified by org.ops4j.pax.url.mvn.settings.
        ${user.home}/.m2/settings.xml
        ${maven.home}/conf/settings.xml
        M2_HOME/conf/settings.xml 

    Note
    All settings.xml files are ignored, if the org.ops4j.pax.url.mvn.repositories property is set.
```
