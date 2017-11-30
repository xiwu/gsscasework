#!/bin/bash

export Fuse_HOME=/home/wuxiaohui/apps/fabric/jboss-fuse-6.1.0.redhat-379/instances/child
export Fuse_newversion_HOME=/home/wuxiaohui/software/fuse/6.1/jboss-fuse-6.1.1.redhat-454-r4/



#4#


cp $Fuse_newversion_HOME/manual_steps/lib/ext/bcprov-jdk15on-1.49.jar $Fuse_HOME/lib/ext
echo "step4 done"
#4.1#
cp $Fuse_newversion_HOME/manual_steps/etc/config.properties $Fuse_HOME/etc
echo "step4.1 done"
#5#
cp $Fuse_newversion_HOME/manual_steps/lib/endorsed/* $Fuse_HOME/lib/endorsed/
echo "step5 done"


#9#

cp $Fuse_newversion_HOME/manual_steps/etc/io.fabric8.datastore.cfg $Fuse_HOME/etc
echo "step9 done"
#10#
cp $Fuse_newversion_HOME/manual_steps/etc/io.fabric8.jolokia.properties $Fuse_HOME/etc
echo "#10 done"



