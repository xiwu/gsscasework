#ftp component readLock=changed
###Issue
I am using the sftp component consumer. I have the following route:

```
<camelContext xmlns="http://camel.apache.org/schema/spring">
<route>
<from uri="sftp://apps_e2open_b2b@10.180.10.25/InetPub/EFTRoot/Internal/landing%20zone%20san/corp%20store/auto/receive/pickup/amd/austin/b3/ausdwlz/chartered/singapore/fab1/wet/dis/data?password=123456&amp;passiveMode=true&amp;preferredAuthentications=password&amp;readLock=completed"/>
       <to uri="ESBAMQ://fileEvent" />
		</route>
    </camelContext>
```

I want it to wait till the file is finshed being writen to by another program on the ftp file server. The option seem easy to impliment. but it not doing what I think. What am i doing doing wrong? The consumer xml is not throwen ing a error and it runs. It just trys to consume the file to early.

###Environment

- JBoss Fuse 6.0

###Solution
You need to set the option 
`readLock=changed`

so the uri should be :
 
```
<from uri="sftp://apps_e2open_b2b@10.180.10.25/InetPub/EFTRoot/Internal/landing%20zone%20san/corp%20store/auto/receive/pickup/amd/austin/b3/ausdwlz/chartered/singapore/fab1/wet/dis/data?password=pw123&amp;passiveMode=true&amp;preferredAuthentications=password&amp;readLock=changed"/>
```
The option readLock can be used to force Camel not to consume files that is currently in the progress of being written. However, this option is turned off by default, as it requires that the user has write access. See the options table at File2 for more details about read locks.
There are other solutions to avoid consuming files that are currently being written over FTP; for instance, you can write to a temporary destination and move the file after it has been written.

For the detail, you can ref[https://camel.apache.org/ftp2.html](https://camel.apache.org/ftp2.html) & [https://camel.apache.org/file2.html](https://camel.apache.org/file2.html)
