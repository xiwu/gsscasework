#How to make the fabric discovery broker url work when using http protocol?

###Issue

We want to use the http protocol in our broker and use it through the fabric discovery mechanism like

discovery:(fabric:broker-group-name) in our application, would you please how to make it work?

We me many errors like:

```

java.lang.NoClassDefFoundError: org/apache/http/message/AbstractHttpMessage

    at org.apache.activemq.transport.http.HttpTransportFactory.createTransport(HttpTransportFactory.java:79)

    at org.apache.activemq.transport.TransportFactory.doCompositeConnect(TransportFactory.java:131)

    at org.apache.activemq.transport.TransportFactory.compositeConnect(TransportFactory.java:90)

    at org.apache.activemq.transport.failover.FailoverTransport.doReconnect(FailoverTransport.java:986)

    at org.apache.activemq.transport.failover.FailoverTransport$2.iterate(FailoverTransport.java:143)

    at org.apache.activemq.thread.PooledTaskRunner.runTask(PooledTaskRunner.java:129)

    at org.apache.activemq.thread.PooledTaskRunner$1.run(PooledTaskRunner.java:47)

    at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)

    at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)

    at java.lang.Thread.run(Thread.java:744)

Caused by: java.lang.ClassNotFoundException: org.apache.http.message.AbstractHttpMessage not found by org.apache.activemq.activemq-osgi [101]

    at org.apache.felix.framework.BundleWiringImpl.findClassOrResourceByDelegation(BundleWiringImpl.java:1532)

    at org.apache.felix.framework.BundleWiringImpl.access$400(BundleWiringImpl.java:75)

    at org.apache.felix.framework.BundleWiringImpl$BundleClassLoader.loadClass(BundleWiringImpl.java:1955)

    at java.lang.ClassLoader.loadClass(ClassLoader.java:358)

    ... 10 more

```

and

```

2014-09-10 15:39:56,498 | INFO  | ActiveMQ Task-3  | HttpClientTransport              | sport.http.HttpClientTransport$1  261 | 101 - org.apache.activemq.activemq-osgi - 5.8.0.redhat-60024 | Broker Servlet supports GZip compression.

Exception in thread "ActiveMQ Transport: HTTP Reader http://dhcp-192-140.pek.redhat.com:62000" com.thoughtworks.xstream.io.StreamException: Cannot create XmlPullParser

    at com.thoughtworks.xstream.io.xml.AbstractXppDriver.createReader(AbstractXppDriver.java:56)

    at com.thoughtworks.xstream.XStream.fromXML(XStream.java:912)

    at com.thoughtworks.xstream.XStream.fromXML(XStream.java:903)

    at org.apache.activemq.transport.xstream.XStreamWireFormat.unmarshalText(XStreamWireFormat.java:53)

    at org.apache.activemq.transport.util.TextWireFormat.unmarshal(TextWireFormat.java:56)

    at org.apache.activemq.transport.http.HttpClientTransport.run(HttpClientTransport.java:191)

    at java.lang.Thread.run(Thread.java:744)

```

###Environment



- JBoss Fuse 6.0



###Solution



unzip the attached project, you will see two projects camel-consumer and camel-producer.

you need to modify the jndi.properties in these two projects and point it to your broker url.

`java.naming.provider.url = discovery:(fabric:mybroker)`



you can run the command `fabric:cluster-list` to see the fabric broker url.



```

JBossFuse:karaf@root> cluster-list

[cluster] [masters] [slaves] [services]

stats/default

fusemq/mybroker

mybroker mybroker - http://dhcp-192-140.pek.redhat.com:62000

```

build and install these two projects bundles through command `mvn clean install`.



- create the example-camel-producer-mybroker profile and Producer-mybroker container.



```

fabric:profile-create --parents activemq-client example-camel-producer-mybroker

fabric:profile-edit --repositories mvn:org.apache.camel.karaf/apache-camel/2.10.0.redhat-60024/xml/features example-camel-producer-mybroker

fabric:profile-edit --features activemq,activemq-camel,camel-spring example-camel-producer-mybroker

fabric:profile-edit --bundles mvn:org.fusebyexample.mq-fabric/camel-producer-mybroker/2.0.0-SNAPSHOT example-camel-producer-mybroker

below will install the http and xml related bundles



fabric:profile-edit --bundles mvn:org.apache.httpcomponents/httpcore-osgi/4.3 example-camel-consumer-mybroker

fabric:profile-edit --bundles 'wrap:mvn:org.apache.httpcomponents/httpclient/4.2.5\$Export-Package=*' example-camel-consumer-mybroker



fabric:profile-edit --features xml-specs-api example-camel-consumer-mybroker



fabric:profile-edit --bundles mvn:org.apache.servicemix.bundles/org.apache.servicemix.bundles.xstream/1.4.4_1 example-camel-consumer-mybroker

fabric:profile-edit --bundles mvn:org.apache.servicemix.bundles/org.apache.servicemix.bundles.xpp3/1.1.4c_6 example-camel-consumer-mybroker

fabric:profile-edit --bundles mvn:org.apache.servicemix.bundles/org.apache.servicemix.bundles.scala-library/2.9.1_3 example-camel-consumer-mybroker



fabric:container-create-child --profile example-camel-producer-mybroker root Producer-mybroker

```



- create the example-camel-consumer-mybroker profile and Consumer-mybroker container.

```

fabric:profile-create --parents activemq-client example-camel-consumer-mybroker

    fabric:profile-edit --repositories mvn:org.apache.camel.karaf/apache-camel/2.10.0.redhat-60024/xml/features example-camel-consumer-mybroker

    fabric:profile-edit --features activemq,activemq-camel,camel-spring example-camel-consumer-mybroker

    fabric:profile-edit --bundles mvn:org.fusebyexample.mq-fabric/camel-consumer-mybroker/2.0.0-SNAPSHOT example-camel-consumer-mybroker

```

- below will install the http and xml related bundles



```

fabric:profile-edit --bundles mvn:org.apache.httpcomponents/httpcore-osgi/4.3 example-camel-consumer-mybroker

fabric:profile-edit --bundles 'wrap:mvn:org.apache.httpcomponents/httpclient/4.2.5\$Export-Package=*' example-camel-consumer-mybroker



fabric:profile-edit --features xml-specs-api example-camel-consumer-mybroker

fabric:profile-edit --bundles mvn:org.apache.servicemix.bundles/org.apache.servicemix.bundles.xstream/1.4.4_1 example-camel-consumer-mybroker

fabric:profile-edit --bundles mvn:org.apache.servicemix.bundles/org.apache.servicemix.bundles.xpp3/1.1.4c_6 example-camel-consumer-mybroker

fabric:profile-edit --bundles mvn:org.apache.servicemix.bundles/org.apache.servicemix.bundles.scala-library/2.9.1_3 example-camel-consumer-mybroker



fabric:container-create-child --profile example-camel-consumer-mybroker root Consumer-mybroker

```

now you will see the message like below in the log of container Producer-mybroker



```

2014-09-10 16:30:21,493 | INFO | timer://producer | ProducerRoute | rg.apache.camel.util.CamelLogger 176 | 109 - org.apache.camel.camel-core - 2.10.0.redhat-60024 | Sending to destination: queue://fabric.simple this text: 4823. message sent



the message like below in the log of container Consumer-mybroker

2014-09-10 16:31:33,985 | INFO | er[queue/simple] | ConsumerRoute | rg.apache.camel.util.CamelLogger 176 | 109 - org.apache.camel.camel-core - 2.10.0.redhat-60024 | Got 14963. message: 4823. message sent

```
