#How to enable the jetty access log in Fuse?
###Issue
How to enable the jetty access log in Fuse?
###Environment

- JBoss Fuse 6.1

###Solution
1. I deployed the `$Fuse6.1/quickstart/rest` example to the fuse, so the service can be visited
like `http://localhost:8181/cxf/crm/customerservice/customers/123`
For such request, need to modify the `etc/org.ops4j.pax.web` and added below lines: 
```
org.ops4j.pax.web.log.ncsa.format=yyyy_mm_dd.request.log
org.ops4j.pax.web.log.ncsa.retaindays=90
org.ops4j.pax.web.log.ncsa.append=true
org.ops4j.pax.web.log.ncsa.extended=true
org.ops4j.pax.web.log.ncsa.timezone=GMT
org.ops4j.pax.web.log.ncsa.enabled=true 
```
2. If the customer's service is as below, the jetty will be a embedded one, how to enable the access request log?
``` 
<cxf:rsServer id="rsServer" address="https://localhost:9292/rest/tara/v1" staticSubresourceResolution="true"
                  serviceClass="sol.dwh.tara.TaraRestInterface"
                  loggingFeatureEnabled="false" loggingSizeLimit="20" skipFaultLogging="false">
        <cxf:providers>
            <ref bean="authenticationFilter"/>
            <ref bean="authorizationFilter"/>
        </cxf:providers>
    </cxf:rsServer> 
```
For the #2 question, if the address like address="https://localhost:9292/rest/tara/v1" , you are not use the OSGi http service(pax-web), you start a standalone jetty server, you need configure the jetty through cxf httpj configuration, something like
```
<httpj:engine-factory bus="cxf">
 <httpj:engine port="9292">
  <httpj:handlers>

   <bean class="org.eclipse.jetty.server.handler.RequestLogHandler">
     <property name="requestLog">
       <bean class="org.mortbay.jetty.NCSARequestLog">
        <property name="filename" value="..."/>
          ...
       </bean>
     </property>
   </bean>
   
  </httpj:handlers>
 </httpj:engine>
</httpj:engine-factory>
```
