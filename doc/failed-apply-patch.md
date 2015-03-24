#Patch Rollup 2 failed to install
###Issue
In our system test environment I attempted to install Rollup 2 and Rollup 2 Patch 1 (after doing so in my environment).

The install into the system test environment appears to have failed and generated many zero length jar files in /var/opt/jboss-fuse/data/maven.

I can now not apply the patch again as I get an IOException.

I have rolled back to the previous fabric version, but cannot now roll forward to the patched version as I can't install it.
```
java.lang.RuntimeException: Unable to apply patch
        at io.fabric8.service.PatchServiceImpl.applyPatch(PatchServiceImpl.java:143)
        at io.fabric8.commands.PatchApply.doExecute(PatchApply.java:62)
        at org.apache.karaf.shell.console.OsgiCommandSupport.execute(OsgiCommandSupport.java:39)
        at org.apache.felix.gogo.commands.basic.AbstractCommand.execute(AbstractCommand.java:35)
        at org.apache.felix.gogo.runtime.CommandProxy.execute(CommandProxy.java:78)[15:org.apache.felix.gogo.runtime:0.11.0.redhat-610379]
        at org.apache.felix.gogo.runtime.Closure.executeCmd(Closure.java:477)[15:org.apache.felix.gogo.runtime:0.11.0.redhat-610379]
        at org.apache.felix.gogo.runtime.Closure.executeStatement(Closure.java:403)[15:org.apache.felix.gogo.runtime:0.11.0.redhat-610379]
        at org.apache.felix.gogo.runtime.Pipe.run(Pipe.java:108)[15:org.apache.felix.gogo.runtime:0.11.0.redhat-610379]
        at org.apache.felix.gogo.runtime.Closure.execute(Closure.java:183)[15:org.apache.felix.gogo.runtime:0.11.0.redhat-610379]
        at org.apache.felix.gogo.runtime.Closure.execute(Closure.java:120)[15:org.apache.felix.gogo.runtime:0.11.0.redhat-610379]
        at org.apache.felix.gogo.runtime.CommandSessionImpl.execute(CommandSessionImpl.java:89)
        at org.apache.karaf.shell.console.jline.Console.run(Console.java:189)
        at java.lang.Thread.run(Thread.java:745)[:1.7.0_65]
        at org.apache.karaf.shell.ssh.ShellFactoryImpl$ShellImpl$4.doRun(ShellFactoryImpl.java:158)[49:org.apache.karaf.shell.ssh:2.3.0.redhat-610379]
        at org.apache.karaf.shell.ssh.ShellFactoryImpl$ShellImpl$4$1.run(ShellFactoryImpl.java:149)
        at java.security.AccessController.doPrivileged(Native Method)[:1.7.0_65]
        at org.apache.karaf.jaas.modules.JaasHelper.doAs(JaasHelper.java:47)[27:org.apache.karaf.jaas.modules:2.3.0.redhat-610379]
        at org.apache.karaf.shell.ssh.ShellFactoryImpl$ShellImpl$4.run(ShellFactoryImpl.java:147)[49:org.apache.karaf.shell.ssh:2.3.0.redhat-610379]
Caused by: java.lang.NullPointerException
        at io.fabric8.service.PatchServiceImpl.applyPatch(PatchServiceImpl.java:65)
```

```
[svcmktfusetst@test maven]$ pwd
/var/opt/jboss-fuse/data/maven
[svcmktfusetst@test maven]$ du -sh *
5.0M    agent
18M	proxy
[svcmktfusetst@test maven]$ 


-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-agent-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-agent-1.0.0.redhat-424.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-agent-commands-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-autoscale-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-boot-commands-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-camel-autotest-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-commands-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-docker-api-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-dosgi-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-features-service-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-git-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-git-1.0.0.redhat-424.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-git-hawtio-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-groups-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-hadoop-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-redirect-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-web-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-zookeeper-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-zookeeper-1.0.0.redhat-424.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 fabric-zookeeper-commands-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 gateway-fabric-support-1.0.0.redhat-423.jar
-rw-r--r--. 1 svcmktfusetst mktjbossfuse 0 Mar 19 10:42 mq-fabric-camel-6.1.1.redhat-423.jar
```
###Environment

- Red Hat JBoss Fuse 6.1.0

###Solution
In fabric env, the correct way to rollback a container is the command: 
`container-rollback`

So can you apply the command or rollback it in the hawtio? If yes, then you can create a new profile version and then apply this new one to the current containers.

If all these above steps does not work, then may be you can try to see whether the containers are patched or not. For example, if the container "root" has been patched,  you can go to the directory `$Fuse61/data/cache`, then check which  bundle is the camel-core, in my env, it is bundle 142. then unzip the 

`$jboss-fuse-6.1.0.redhat-379/data/cache/bundle142/version0.1/bundle.jar/META-INF/MANIFEST.MF` to see the Bundle-Version: `2.12.0.redhat-610379` or has been patched to the latest one `2.12.0.redhat-611424`. 

if all these bundles are not patched. then you can keep the cache directory. 

Just try to delete the `/var/opt/jboss-fuse/data/maven` directory  to see whether it the server can be started or not. And make sure you did the same steps in the child container's directory too. 

And pls backup all the datas before you do above steps. 


### And please note: 

When applying the patch, you must ensure that root container that has the patch applied is upgraded last. It hosts the Bundles, and if it goes down then all servers fail to find the bundles as we don't have them in our repo.

To fix the problem after the patch failed I:
Unzipped the rollup to a directory and put all the repo bundles into a directory
Unzipped the p1 patch and applied this over the rollup bundles
I then copied these bundles to the `<x>/data/maven/agent` directory in ALL containers
I then upgraded all containers to the patched version of Fabric

We now have our existing environment patched without having to rebuild.
