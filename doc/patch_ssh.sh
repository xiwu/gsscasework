
export Fuse_HOME=/home/wuxiaohui/apps/fabric/jboss-fuse-6.1.0.redhat-379
export Fuse_newversion_HOME=/home/wuxiaohui/software/fuse/6.1/jboss-fuse-6.1.1.redhat-454-r4/

# step 1#
cp $Fuse_newversion_HOME/manual_steps/lib/bin/karaf-client.jar $Fuse_HOME/lib/bin

echo " #step1# cp the newversion karaf-client.jar to " + $Fuse_newversion_HOME

# step2 #

 #cannot simply copy from the manual_steps directory

# step2.3 #
cp -r $Fuse_newversion_HOME/manual_steps/fabric-system-updates/system/org/apache/sshd/sshd-core/0.12.0.redhat-002/ /home/wuxiaohui/apps/fabric/jboss-fuse-6.1.0.redhat-379/system/org/apache/sshd/sshd-core

# step2.4 #
cp -r $Fuse_newversion_HOME/manual_steps/fabric-system-updates/system/org/apache/karaf/shell/org.apache.karaf.shell.console
/2.3.0.redhat-611454/ $Fuse_HOME/system/org/apache/karaf/shell/org.apache.karaf.shell.console


# step3.1 #

cp $Fuse_newversion_HOME/manual_steps/manual_steps/bin/admin $Fuse_HOME/bin

echo " #step3.1# cp the newversion admin to " + $Fuse_HOME/bin

#3.2#

cp -r $Fuse_newversion_HOME/manual_steps/fabric-system-updates/system/ $Fuse_HOME/

#4#


cp $Fuse_newversion_HOME/manual_steps/lib/ext/bcprov-jdk15on-1.49.jar $Fuse_HOME/lib/ext

#4.1#
cp $Fuse_newversion_HOME/manual_steps/etc/config.properties $Fuse_HOME/etc

#5#
cp $Fuse_newversion_HOME/manual_steps/lib/endorsed/* $Fuse_HOME/lib/endorsed/

#6#
  #donot need for ssh container#

#7#
$Fuse_HOME/bin/client "profile-edit --bundles mvn:org.apache.servicemix.bundles/org.apache.servicemix.bundles.bcel/5.2_4 karaf 1.0"
#8#
$Fuse_HOME/bin/client "profile-edit --bundles mvn:io.fabric8/common-util/1.0.0.redhat-379 default 1.0"

#9#

cp $Fuse_newversion_HOME/manual_steps/etc/io.fabric8.datastore.cfg $Fuse_HOME/etc
#10#
cp $Fuse_newversion_HOME/manual_steps/etc/io.fabric8.jolokia.properties $Fuse_HOME/etc

#11#
cp $Fuse_newversion_HOME/manual_steps/lib/karaf.jar $Fuse_HOME/lib/

