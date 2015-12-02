Configuring JDBC Persistence with Fuse MQ Enterprise/JBoss Fuse 

The configuration used in the broker's configuration file (`activemq.xml`) will be similar to that used in a standalone broker and will look something like the following when using a MySQL database:

~~~
...
<persistenceAdapter>  
   <jdbcPersistenceAdapter dataDirectory="${data}/kahadb" dataSource="#mysql-ds"/>  
</persistenceAdapter>
...

...
<bean id="mysql-ds" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">  
       <property name="driverClassName" value="com.mysql.jdbc.Driver"/>  
       <property name="url" value="jdbc:mysql://localhost/activemq?relaxAutoCommit=true"/>  
       <property name="username" value="activemq"/>  
       <property name="password" value="activemq"/>  
       <property name="maxActive" value="200"/>  
       <property name="poolPreparedStatements" value="true"/>  
</bean>
...
~~~

For Fuse MQ Enterprise you will also need to install the org.apache.servicemix.bundles.commons-dbcp bundle which can be done as follows:

~~~
osgi:install mvn:org.apache.servicemix.bundles/org.apache.servicemix.bundles.commons-dbcp/1.4_3
~~~

Users will also need to install the database driver into the container.  For MySQL, this can be done as follows:

~~~
osgi:install wrap:mvn:mysql/mysql-connector-java/5.1.26
~~~

If you are using the [journaled JDBC](https://access.redhat.com/documentation/en-US/Red_Hat_JBoss_A-MQ/6.1/html/Configuring_Broker_Persistence/files/FuseMBPersistJDBCJournaled.html) you also need the activeio-core-3.1.4.jar.  This can be installed as follows:

~~~
osgi:install wrap:mvn:org.apache.activemq/activeio-core/3.1.4
~~~

**Note:** the High performance journal should be configured similar to the following in the broker configuration:

~~~
<persistenceFactory>
            <journalPersistenceAdapterFactory journalLogFiles="5" dataDirectory="${data}/kahadb" dataSource="#mysql-ds" useDatabaseLock="true" useDedicatedTaskRunner="false"/>
 </persistenceFactory>
~~~

Once this is done the Broker should start successfully and you should see a similar output in the log:

~~~
2013-02-28 23:09:04,384 | INFO  | Q Broker: fusemq | ActiveMQServiceFactory$$anon$1   | pport.AbstractApplicationContext  456 | 77 - org.springframework.context - 3.0.7.RELEASE | Refreshing org.fusesource.mq.fabric.ActiveMQServiceFactory$$anon$1@6ba00355: startup date [Thu Feb 28 23:09:04 EST 2013]; root of context hierarchy
2013-02-28 23:09:04,386 | INFO  | Q Broker: fusemq | XBeanXmlBeanDefinitionReader     | tory.xml.XmlBeanDefinitionReader  315 | 75 - org.springframework.beans - 3.0.7.RELEASE | Loading XML bean definitions from file [/Users/jsherman/Development/tools/activemq/fuse-mq-7.1.0.fuse-047/etc/activemq.xml]
2013-02-28 23:09:04,416 | INFO  | Q Broker: fusemq | DefaultListableBeanFactory       | pport.DefaultListableBeanFactory  557 | 75 - org.springframework.beans - 3.0.7.RELEASE | Pre-instantiating singletons in org.springframework.beans.factory.support.DefaultListableBeanFactory@25b13009: defining beans [org.springframework.beans.factory.config.PropertyPlaceholderConfigurer#0,org.apache.activemq.xbean.XBeanBrokerService#0,mysql-ds]; root of factory hierarchy
2013-02-28 23:09:04,423 | INFO  | Q Broker: fusemq | PListStore                       | mq.store.kahadb.plist.PListStore  331 | 104 - org.apache.activemq.activemq-core - 5.7.0.fuse-71-047 | PListStore:[/Users/jsherman/Development/tools/activemq/fuse-mq-7.1.0.fuse-047/data/fusemq/fusemq/tmp_storage] started
2013-02-28 23:09:04,429 | INFO  | Q Broker: fusemq | BrokerService                    | he.activemq.broker.BrokerService  619 | 104 - org.apache.activemq.activemq-core - 5.7.0.fuse-71-047 | Using Persistence Adapter: JDBCPersistenceAdapter(org.apache.commons.dbcp.BasicDataSource@79cbf844)
2013-02-28 23:09:07,387 | INFO  | Q Broker: fusemq | JDBCPersistenceAdapter           | tore.jdbc.JDBCPersistenceAdapter  439 | 104 - org.apache.activemq.activemq-core - 5.7.0.fuse-71-047 | Database adapter driver override recognized for : [mysql-ab_jdbc_driver] - adapter: class org.apache.activemq.store.jdbc.adapter.MySqlJDBCAdapter
2013-02-28 23:09:11,462 | INFO  | Q Broker: fusemq | JDBCPersistenceAdapter           | tore.jdbc.JDBCPersistenceAdapter  441 | 104 - org.apache.activemq.activemq-core - 5.7.0.fuse-71-047 | Database lock driver override not found for : [mysql-ab_jdbc_driver].  Will use default implementation.
2013-02-28 23:09:11,463 | INFO  | Q Broker: fusemq | DefaultDatabaseLocker            | store.jdbc.DefaultDatabaseLocker   63 | 104 - org.apache.activemq.activemq-core - 5.7.0.fuse-71-047 | Attempting to acquire the exclusive lock to become the Master broker
2013-02-28 23:09:11,510 | INFO  | Q Broker: fusemq | DefaultDatabaseLocker            | store.jdbc.DefaultDatabaseLocker  130 | 104 - org.apache.activemq.activemq-core - 5.7.0.fuse-71-047 | Becoming the master on dataSource: org.apache.commons.dbcp.BasicDataSource@79cbf844
2013-02-28 23:09:11,892 | INFO  | Q Broker: fusemq | BrokerService                    | he.activemq.broker.BrokerService  659 | 104 - org.apache.activemq.activemq-core - 5.7.0.fuse-71-047 | Apache ActiveMQ 5.7.0.fuse-71-047 (fusemq, ID:new-host-2.home-59129-1362110951568-0:1) is starting
2013-02-28 23:09:11,941 | INFO  | Q Broker: fusemq | TransportServerThreadSupport     | ort.TransportServerThreadSupport   72 | 104 - org.apache.activemq.activemq-core - 5.7.0.fuse-71-047 | Listening for connections at: tcp://new-host-2.home:61616?maximumConnections=1000
2013-02-28 23:09:11,942 | INFO  | Q Broker: fusemq | TransportConnector               | tivemq.broker.TransportConnector  246 | 104 - org.apache.activemq.activemq-core - 5.7.0.fuse-71-047 | Connector openwire Started
2013-02-28 23:09:11,942 | INFO  | Q Broker: fusemq | BrokerService                    | he.activemq.broker.BrokerService  696 | 104 - org.apache.activemq.activemq-core - 5.7.0.fuse-71-047 | Apache ActiveMQ 5.7.0.fuse-71-047 (fusemq, ID:new-host-2.home-59129-1362110951568-0:1) started
2013-02-28 23:09:11,943 | INFO  | Q Broker: fusemq | BrokerService                    | he.activemq.broker.BrokerService  698 | 104 - org.apache.activemq.activemq-core - 5.7.0.fuse-71-047 | For help or more information please see: http://activemq.apache.org
2013-02-28 23:09:11,943 | INFO  | Q Broker: fusemq | ActiveMQServiceFactory           | q.fabric.ActiveMQServiceFactory$   52 | 116 - org.fusesource.mq.mq-fabric - 7.1.0.fuse-047 | Broker fusemq has started.
~~~
