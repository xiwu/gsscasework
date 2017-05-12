
#Integrate BRMS with Fuse

##Issue
I have got troubles to deploy my service in a fabric environment. This service has components to integrate itself with JBoss BRMS 6.4.
In the log, I see below ERROR, how to resolve the issue?
```
2017-04-19 15:16:25,956 | ERROR | 6.0.1-1-thread-1 | DeploymentAgent                  | 86 - io.fabric8.fabric-agent - 1.2.0.redhat-621084 | Unable to update agent
org.osgi.service.resolver.ResolutionException: Unable to resolve root: missing requirement [root] osgi.identity; osgi.identity=org.drools.core; type=osgi.bundle; version="[6.4.0.201605010108,6.4.0.201605010108]"; resolution:=mandatory [caused by: Unable to resolve org.drools.core/6.4.0.201605010108: missing requirement [org.drools.core/6.4.0.201605010108] osgi.wiring.package; filter:="(osgi.wiring.package=com.google.protobuf)"]
	at org.apache.felix.resolver.ResolutionError.toException(ResolutionError.java:42)[86:io.fabric8.fabric-agent:1.2.0.redhat-621084]
	at org.apache.felix.resolver.ResolverImpl.resolve(ResolverImpl.java:236)[86:io.fabric8.fabric-agent:1.2.0.redhat-621084]
	at org.apache.felix.resolver.ResolverImpl.resolve(ResolverImpl.java:159)[86:io.fabric8.fabric-agent:1.2.0.redhat-621084]
	at io.fabric8.agent.region.SubsystemResolver.resolve(SubsystemResolver.java:190)[86:io.fabric8.fabric-agent:1.2.0.redhat-621084]
	at io.fabric8.agent.service.Deployer.deploy(Deployer.java:273)[86:io.fabric8.fabric-agent:1.2.0.redhat-621084]
	at io.fabric8.agent.service.Agent.provision(Agent.java:366)[86:io.fabric8.fabric-agent:1.2.0.redhat-621084]
	at io.fabric8.agent.service.Agent.provision(Agent.java:199)[86:io.fabric8.fabric-agent:1.2.0.redhat-621084]
	at io.fabric8.agent.DeploymentAgent.doUpdate(DeploymentAgent.java:727)[86:io.fabric8.fabric-agent:1.2.0.redhat-621084]
	at io.fabric8.agent.DeploymentAgent$4.run(DeploymentAgent.java:283)[86:io.fabric8.fabric-agent:1.2.0.redhat-621084]
	at java.util.concurrent.Executors$RunnableAdapter.call(Executors.java:511)[:1.8.0_121]
	at java.util.concurrent.FutureTask.run(FutureTask.java:266)[:1.8.0_121]
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1142)[:1.8.0_121]
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:617)[:1.8.0_121]
	at java.lang.Thread.run(Thread.java:745)[:1.8.0_121]
```

##Resolution
###common steps
For the BRMS related artifacts, you need to add related repo to the fuse maven repo so that these artifacts can be downloaded. 
    https://maven.repository.redhat.com/ga
    https://maven.repository.redhat.com/earlyaccess/all
    
 which contains drools artifacts into the profile's repository.[1]Or if you would like to use the offline repo, you can download from [2].

By default, all the profiles inherit form the profile "default". So  you can edit the "default" profile
edit the file

`io.fabric8.agent through the admin console http://localhost:8181/hawtio: 
WiKi-> Root/fabric/profiles/default->io.fabric8.agent.properties`


change the property:
`org.ops4j.pax.url.mvn.repositories`

adding the related repo:

https://maven.repository.redhat.com/ga
https://maven.repository.redhat.com/earlyaccess/all


like below format
    http://repository.springsource.com/maven/bundles/external@id=ebrexternal, \
    https://maven.repository.redhat.com/ga@id=redhatga, \
    https://maven.repository.redhat.com/earlyaccess/all@id=redhatearlyaccess

or using the command line like: 

fabric:profile-edit --append --pid io.fabric8.agent/org.ops4j.pax.url.mvn.repositories=https://maven.repository.redhat.com/ga@id=redhatga default

fabric:profile-edit --append --pid io.fabric8.agent/org.ops4j.pax.url.mvn.repositories=https://maven.repository.redhat.com/earlyaccess/all@id=redhatearlyaccess default


[1]https://access.redhat.com/maven-repository
[2]https://access.redhat.com/jbossnetwork/restricted/listSoftware.html?downloadType=distributions&product=jboss.fuse&version=6.2.1

###standalone env


###steps

- Before start the fuse,

pls modify the file $Fuse/etc/org.ops4j.pax.url.mvn.cfg, add the repos which contains the BxMS artifacts:

https://maven.repository.redhat.com/ga
https://maven.repository.redhat.com/earlyaccess/all


like:
org.ops4j.pax.url.mvn.repositories= \
    http://repo1.maven.org/maven2@id=maven.central.repo, \
    http://repository.jboss.org/nexus/content/repositories/public@id=jboss.public.repo, \
    https://repo.fusesource.com/nexus/content/repositories/releases@id=fusesource.release.repo, \
    https://repo.fusesource.com/nexus/content/groups/ea@id=fusesource.ea.repo, \
    http://svn.apache.org/repos/asf/servicemix/m2-repo@id=servicemix.repo, \
    http://repository.springsource.com/maven/bundles/release@id=springsource.release.repo, \
    http://repository.springsource.com/maven/bundles/external@id=springsource.external.repo, \
    https://maven.repository.redhat.com/ga@id=redhatga, \
    https://maven.repository.redhat.com/earlyaccess/all@id=redhatearlyaccess

- Install the dependencies in karaf.

```
features:addurl mvn:org.drools/drools-karaf-features/6.5.0.Final-redhat-2/xml/features
features:addurl mvn:org.jboss.integration.fuse/karaf-features/1.6.0.redhat-621013/xml/features

(note for myself, I made a mistake
below should be used if using BRMS 6.3. the BRMS version 6.3 is using the community 6.4 version.

)
features:addurl mvn:org.drools/drools-karaf-features/6.4.0.Final-redhat-3/xml/features
features:addurl mvn:org.jboss.integration.fuse/karaf-features/1.4.0.redhat-621038/xml/features



features:install drools-module
features:install drools-decisiontable
features:install kie-aries-blueprint
features:install kie-camel
features:install camel-dozer
features:install kie-server-client

osgi:install file:///home/wuxiaohui/cases/01833199/cosmoplas-compra-grabar/target/compra-grabar-1.0.0.jar
```







- I suggest you can have a look about the quickstarts provided by the fuse-integration-karaf-distro-1.6.0.redhat-621013[1] to check how the features are defined.

$fuse-integration-karaf-distro-1.6.0.redhat-621013/system/org/jboss/integration/fuse/quickstarts/karaf-features/1.6.0.redhat-621013/karaf-features-1.6.0.redhat-621013-features.xml

and also check the features which provided in 
mvn:org.drools/drools-karaf-features/6.5.0.Final-redhat-2/xml/features
mvn:org.jboss.integration.fuse/karaf-features/1.6.0.redhat-621013/xml/features.
they are available in https://maven.repository.redhat.com/ga.


- for the osgi dependency issue, you can check[2] to see how to trouble shooting this kind of  issue.



[1]Integration Pack for Red Hat JBoss Fuse 6.2.1 Roll Up 5 on Karaf, BRMS 6.4.0, and BPM Suite 6.4.0
https://access.redhat.com/jbossnetwork/restricted/softwareDetail.html?softwareId=48571&product=brms&version=6.4&downloadType=distributions
[2]Troubleshooting Dependencies
https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_Fuse/6.2.1/html/Deploying_into_Apache_Karaf/ch07s04.html

###fabric env
####steps
- create a fabric env, then modify the default profile's maven repo.

you need to add related repo which contains drools artifacts into the profile's repository.[1] Or if you would like to use the offline repo, you can download from [2].

By default, all the profiles inherit form the profile "default". So  you can edit the "default" profile
edit the file

io.fabric8.agent through the admin console http://localhost:8181/hawtio: 
WiKi-> Root/fabric/profiles/default->io.fabric8.agent.properties


change the property:
org.ops4j.pax.url.mvn.repositories

adding the related repo:

https://maven.repository.redhat.com/ga
https://maven.repository.redhat.com/earlyaccess/all
http://YOUR_LOCAL_REPO/

like below format
    http://repository.springsource.com/maven/bundles/external@id=ebrexternal, \
    https://maven.repository.redhat.com/ga@id=redhatga, \
    https://maven.repository.redhat.com/earlyaccess/all@id=redhatearlyaccess

- create your own profile, adding the dependency features and bundles into it. 
```
profile-create --parent default cosprofile
fabric:profile-change-parents cosprofile feature-camel

fabric:profile-edit --repository  mvn:org.drools/drools-karaf-features/6.4.0.Final-redhat-3/xml/features cosprofile
fabric:profile-edit --repository  mvn:org.jboss.integration.fuse/karaf-features/1.4.0.redhat-621038/xml/features cosprofile

(use below if using BRMS 6.4)
==
fabric:profile-edit --repository  mvn:org.drools/drools-karaf-features/6.5.0.Final-redhat-2/xml/features cosprofile
fabric:profile-edit --repository  mvn:org.jboss.integration.fuse/karaf-features/1.6.0.redhat-621013/xml/features cosprofile
==

fabric:profile-edit --feature drools-module cosprofile
fabric:profile-edit --feature drools-decisiontable cosprofile
fabric:profile-edit --feature kie-aries-blueprint cosprofile
fabric:profile-edit --feature kie-camel cosprofile
fabric:profile-edit --feature camel-dozer cosprofile
fabric:profile-edit --feature kie-server-client cosprofile
fabric:profile-edit --bundle file:///home/wuxiaohui/cases/01833199/cosmoplas-compra-grabar/target/compra-grabar-1.0.0.jar cosprofile
```
-  then create the container.
```
container-create-child root child
container-add-profile child cosprofile
```





Pls note even there are logs:`Stopped KahaDB`
Messages can be sent to the Broker. So the broker is not crashed. It is still working. Looks like the warning message is harmless.
==========5.11.0.redhat-621090===============
```

11:30:37,813 | INFO  | l Console Thread | KahaDBStore                      | 185 - org.apache.activemq.activemq-osgi - 5.11.0.redhat-621090 | Stopping async queue tasks
11:30:37,814 | INFO  | l Console Thread | KahaDBStore                      | 185 - org.apache.activemq.activemq-osgi - 5.11.0.redhat-621090 | Stopping async topic tasks
11:30:37,814 | INFO  | l Console Thread | KahaDBStore                      | 185 - org.apache.activemq.activemq-osgi - 5.11.0.redhat-621090 | Stopped KahaDB
11:30:47,788 | WARN  | r[amq] Scheduler | Topic                            | 185 - org.apache.activemq.activemq-osgi - 5.11.0.redhat-621090 | Failed to browse Topic: /topic/com/lynden/crossdock/JMS-Tester_Topic5
java.lang.IllegalStateException: PageFile is not loaded
	at org.apache.activemq.store.kahadb.disk.page.PageFile.assertLoaded(PageFile.java:811)[185:org.apache.activemq.activemq-osgi:5.11.0.redhat-621090]
	at org.apache.activemq.store.kahadb.disk.page.PageFile.tx(PageFile.java:304)[185:org.apache.activemq.activemq-osgi:5.11.0.redhat-621090]
	at org.apache.activemq.store.kahadb.KahaDBStore$KahaDBMessageStore.recover(KahaDBStore.java:557)[185:org.apache.activemq.activemq-osgi:5.11.0.redhat-621090]
	at org.apache.activemq.store.ProxyTopicMessageStore.recover(ProxyTopicMessageStore.java:62)[185:org.apache.activemq.activemq-osgi:5.11.0.redhat-621090]
	at org.apache.activemq.store.ProxyTopicMessageStore.recover(ProxyTopicMessageStore.java:62)[185:org.apache.activemq.activemq-osgi:5.11.0.redhat-621090]
	at org.apache.activemq.broker.region.Topic.doBrowse(Topic.java:595)[185:org.apache.activemq.activemq-osgi:5.11.0.redhat-621090]
	at org.apache.activemq.broker.region.Topic.access$100(Topic.java:66)[185:org.apache.activemq.activemq-osgi:5.11.0.redhat-621090]
	at org.apache.activemq.broker.region.Topic$6.run(Topic.java:734)[185:org.apache.activemq.activemq-osgi:5.11.0.redhat-621090]
	at org.apache.activemq.thread.SchedulerTimerTask.run(SchedulerTimerTask.java:33)[185:org.apache.activemq.activemq-osgi:5.11.0.redhat-621090]
	at java.util.TimerThread.mainLoop(Timer.java:555)[:1.8.0_92]
	at java.util.TimerThread.run(Timer.java:505)[:1.8.0_92]
```
==========5.11.0.redhat-621090===============

but on version 5.11.0.redhat-630187,  the exception like below:

============5.11.0.redhat-630187===============
```
14:21:05,418 | INFO  | producer-1       | ProducerThread                   | 219 - org.apache.activemq.activemq-osgi - 5.11.0.redhat-630187 | producer-1 Started to calculate elapsed time ...n  | 
14:21:05,429 | INFO  | producer-1       | ProducerThread                   | 219 - org.apache.activemq.activemq-osgi - 5.11.0.redhat-630187 | producer-1 Produced: 100 messages
14:21:05,429 | INFO  | producer-1       | ProducerThread                   | 219 - org.apache.activemq.activemq-osgi - 5.11.0.redhat-630187 | producer-1 Elapsed time in second : 0 s
14:21:05,429 | INFO  | producer-1       | ProducerThread                   | 219 - org.apache.activemq.activemq-osgi - 5.11.0.redhat-630187 | producer-1 Elapsed time in milli second : 11 milli seconds
14:21:20,505 | INFO  | l Console Thread | KahaDBStore                      | 219 - org.apache.activemq.activemq-osgi - 5.11.0.redhat-630187 | Stopping async queue tasks
14:21:20,505 | INFO  | l Console Thread | KahaDBStore                      | 219 - org.apache.activemq.activemq-osgi - 5.11.0.redhat-630187 | Stopping async topic tasks
14:21:20,505 | INFO  | l Console Thread | KahaDBStore                      | 219 - org.apache.activemq.activemq-osgi - 5.11.0.redhat-630187 | Stopped KahaDB
```
============5.11.0.redhat-630187===============



