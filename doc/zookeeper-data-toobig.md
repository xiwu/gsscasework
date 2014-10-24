#Zookeeper/data folder is too big

###Issue
ZooKeeper/data folder at the primary node grows out of control - 4GB by now and increasing.

This folder contains snapshots and logs - is there a clean-up procedure that can be followed to reduce it to a tolerable size?
###Environment

- Red Hat JBoss Fuse
 - 6.x

###Solution

Zookeeper includes utility PurgeTxnLog for cleaning the data directory as explained in the [documentation](https://zookeeper.apache.org/doc/r3.3.3/zookeeperAdmin.html#sc_maintenance):

```
java -cp zookeeper.jar:log4j.jar:conf org.apache.zookeeper.server.PurgeTxnLog <dataDir> <snapDir> -n <count>
```
If you want to use the zookeeper command to achieve the goal, please download the according 6.1 zookeeper verions 3.4.5, then you can run the command like below:
```
export zookeeper_home=/home/wuxiaohui/apps/zookeeper-3.4.5-server1
export zookeeper_data_dir=$jboss-fuse-6.1.0.redhat-379/data/zookeeper/0000/
cd $zookeeper_home
java -cp zookeeper-3.4.5.jar:./lib/log4j-1.2.15.jar:./lib/slf4j-api-1.6.1.jar:./lib/slf4j-log4j12-1.6.1.jar:conf org.apache.zookeeper.server.PurgeTxnLog   $zookeeper_data_dir $zookeeper_data_dir -n 3
```
However, given the fact that the zookeeper is internal component of JBoss Fuse the cleaning should not be delegated to end user by issuing clean up commands manually, but rather, the clean up should be done automatically by JBoss Fuse. This has been reported as a Enhancement under id [ENH-383](https://issues.jboss.org/browse/ENH-383).
