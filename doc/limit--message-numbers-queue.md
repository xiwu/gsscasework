#How to limit the number of messages in a queue?
###Issue
We want to know how to limit the messages size in a queue/limit the disk usage of a queue.

We know that if there is not any limit for the queue and if this queue's consumer is too slow then the disk size will be full of the messages for this destination. Our purpose is not letting one destination have a global impact.

We want to limit a queue only can have 4000 messages size. If the queue messages size achieved this limit, then the client can not send messages to the queue.
###Environment

- Red Hat JBoss A-MQ 6.1

###Solution
You need to implement a broker plugin and intercept the send() method and query the broker stats for queue size.
Block or reject the send as appropriate.

There are plenty of plugin examples at: 
https://github.com/apache/activemq/tree/trunk/activemq-broker/src/main/java/org/apache/activemq/broker/util

And there is an implemention too:
https://github.com/abouchama/activemq_flow_control_plugins

You can also ref[1][2]

- [1]http://activemq.apache.org/interceptors.html
- [2]http://activemq.apache.org/developing-plugins.html
