#Patching mechmism in Fuse
###Issue

###Environment

- Red Hat JBoss Fuse 6.1.0

###The patch type
There are two patch types: one is Rollup Patch, antoher is Basic Patch. For example,
6.1R2 is the RollupPatch, 6.1R2P4 is the Basic Patch. Because these patches are culmutitive, so when you need to apply the patch, you only 
need the latest Rollup Patch and the acoording Basic Patch. 6.1R2 + 6.1R2P4. All the patches which are released before are not needed.

For the detail, you can ref [Understanding JBoss Fuse/JBoss A-MQ Patches 6.1](https://access.redhat.com/solutions/1345973).

###Patching in Standalone mode
`patch:add file:///temp/jboss-fuse-6.1.0.redhat-379-r2-611423.zip`

`patch:install jboss-fuse-6.1.0.redhat-379-r2`

then you will see these patch list through the command:
`patch:list`

```
JBossFuse:karaf@root> patch:list 
[name]                                   [installed] [description]
jboss-fuse-6.1.0.redhat-379-r2           true       JBoss Fuse 6.1 R2
```

After rollback the jboss-fuse-6.1.0.redhat-379-r2, you can see the status of "installed" is false.
```
JBossFuse:karaf@root> patch:list 
[name]                                   [installed] [description]
jboss-fuse-6.1.0.redhat-379-r2           false      JBoss Fuse 6.1 R2
```
After adding the patch, you will see the new bundles are copied into the `$Fuse_HOME/system` directory.

After applying it, you will see the bundle is updated in the runtime. Pay attention to the file below, you can see the mvn location is updated
to the new version.

```
/home/daniel/jboss-fuse-6.1-r2p4-0520/data/cache/bundle139

[daniel@pvm-xiwu-fuse61 bundle139]$ tree
.
├── bundle.info
└── version0.0
    ├── bundle.jar
	└── revision.location
```


the content of the file bundle.info:
```
139
mvn:org.apache.camel/camel-core/2.12.0.redhat-611423
32
50
1433140087339
```
####What is being improved in 6.1?
$Fuse_HOME/etc/
overrides.properties ,startup.properties


[Improve patch functionality](https://issues.jboss.org/browse/ENTESB-1031)

[feature:install does not honor patch overrides](https://issues.jboss.org/browse/ENTESB-1250) 

[Provide a way to override bundles at feature installation time](https://issues.apache.org/jira/browse/KARAF-2752) 


you will see the maven versions in the overrides.properties,startup.properties are changed to reflect the patch release version.

Here are the changes since 6.0.

- Offline patching

A bin/patch script has been introduced which provides offline patching.
The patch file provided on the command line will be extracted, jars copied into the system folder, and the etc/startup.properties and etc/overrides.properties will be modified as needed. This can be done before the container is first started and is persistent (i.e. if you delete the data folder, the patch should still be applied). Note that the application of a patch can't be rolled back when performed this way.

When a patch is applied to a started container using the patch:install command (in a non fabric environment), the modifications will also be persisted. Those patches can be rolled back but need to be done in the reverse order of applied patch (i.e. installing p3, p5 and rolling back p3 is a bad idea).

Note that even offline patching work, switching a patched container to fabric will get rid of the patch and will effectively revert the patch. The patch needs to be applied again using the fabric:apply-patch or hawtio mechanism.

- Maven plugin


A maven plugin has been added which can be used to apply a patch to a karaf based distribution the offline way. It is supposed to be used in cooperation with the assembly and features-maven-plugin.

- Fabric patching


A fabric:patch-apply command has been introduced which allow to apply a patch to a given version from the console. It's exact the same mechanism than applying a patch from hawtio.


###Fabric mode
steps:

[1] Install a standalone Fuse instance

[2] Create a fabric

[3] Create a new fabric profile e.g. v1.1

[4] Apply the first patch

[5] Make v1.1 default and update the fabric instances to v1.1

[6] Create a second fabric profile e.g. v1.2

[7] Apply the second patch

[8] Make v1.2 the default and update the fabric instances to v1.2

when meet below issue, pls ref the kcs:
https://access.redhat.com/solutions/1363593 missing requirement [io.fabric8.fabric-core/1.0.0.redhat-433

There are 3 parts bundle files in the file system.

- on the ensemble server:
1. downloads directory

/home/daniel/jboss-fuse-6.1-r2p4-0520-fabric/data/maven/proxy/downloads

io  jline  org  sg

the customer's bundle is in this directory too.

/home/daniel/jboss-fuse-6.1-r2p4-0520-fabric/data/maven/proxy/downloads/sg/fuse

2. tmp directory:

/home/daniel/jboss-fuse-6.1-r2p4-0520-fabric/data/maven/proxy/tmp
seems temp directory when handling these bundles

camel-core-2.12.0.redhat-611423.jar                   cxf-rt-frontend-js-2.7.0.redhat-611423.jar                    org.apache.karaf.admin.management-2.3.0.redhat-611429.jar
camel-core-2.12.0.redhat-611433.jar   


- on the child containers:

/home/daniel/jboss-fuse-6.1-r2p4-0520-fabric/instances/child/data/maven/agent/

/home/daniel/jboss-fuse-6.1-r2p4-0520-fabric/instances/child/data/maven/agent/org/apache/camel/camel-core
```
[daniel@pvm-xiwu-fuse61 camel-core]$ tree
.
├── 2.12.0.redhat-611423
│   └── camel-core-2.12.0.redhat-611423.jar
└── 2.12.0.redhat-611433
    └── camel-core-2.12.0.redhat-611433.jar
```    
as to how to verify the patch, pls see the doc [How do i verify if my Fuse 6.0/6.1 installation had already installed any patch](https://access.redhat.com/solutions/1339163)




###Exisiting issues
Can not rollback to the previous patch
There are several issues found about the patch rollback mechnism like below:
https://issues.jboss.org/browse/ENTESB-1548 Unable to rollback 6.0 R1 patch after 6.0 R1P3 has been rolled back
https://issues.jboss.org/browse/ENTESB-2674 patch:rollback mechanism in Fuse 6.1 is broken

https://issues.jboss.org/browse/ENTESB-2737 Unable to rollback Fuse 6.1 R2P1 patch
Now they are fixed in the Fuse 6.1R2P3. 

###FAQ
Does 6.1 Rollup 1 contain 6.1 Patch 1 and 6.1 Patch 2 ?

==> Yes

From reading other cases once I have installed the Rollup 1 patch I can go straight to the Rollup 1 Patch 2 , is this correct ?
==> Yes

When patching containers within a Fabric cluster to I have to create a new profile version for each patch or can all the patches be rolled into the same profile ?

==> a new profile for each patch, like r1 --> 1.1 version, r1p2--> 2.0 version. 
Then you need to apply them one by one. 
These patches can be appled easily in the hawto io webconsole.

You can also ref the readme.txt in the Rollup 1 Patch 2 zip file or [Patching a Container in a Fabric](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Fuse/6.1/html/Configuring_and_Running_Red_Hat_JBoss_Fuse/ESBRuntimePatchFabric.html)


Regarding the Fabric patching and creating a version per patch, what happens when I add a new fabric container after I've applied the patches to existing containers. Will the patches automatically be applied to the new containers or will I have to upgrade them manually ?
==> After applying the patch, you can set the new version to the default one. Then every time when you created a new container, then it will apply the default version ie the patched version. 


Also would it be better to apply patches before creating the fabric i.e. are patches automatically propagated when using fabric:create-container ?

==> As above, the default version will be applied. 


Does this mean that if I install a single standalone Fuse instance (no fabric created) and patch it via the patch:add and patch:install commands these patches are not propagated to managed containers when a fabric is created at a later stage ?
==> Yes, you are right.
So is it better to:
[1] Install a standalone Fuse instance
[2] Create a fabric
[3] Create a new fabric profile e.g. v1.1
[4] Apply the first patch
[5] Make v1.1 default and update the fabric instances to v1.1
[6] Create a second fabric profile e.g. v1.2
[7] Apply the second patch
[8] Make v1.2 the default and update the fabric instances to v1.2

==> Yes, using the hawtio is very easy to do these steps. You can also using the command to apply the patches.
