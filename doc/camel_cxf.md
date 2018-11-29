CXF in camel

Camel 中使用了cxf，里面有很多容易混淆的部分。简单介绍如下：

如果使用soap11时，默认的 WSDL ，如果使用soapUI 访问时，默认使用`Content-Type: text/xml;charset=UTF-8`，
```
POST http://localhost:8181/cxf/camel-example-cxf-blueprint/webservices/incident HTTP/1.1
Accept-Encoding: gzip,deflate
User-Agent: charset=utf-8
Content-Type: text/xml;charset=UTF-8
SOAPAction: "http://reportincident.example.camel.apache.org/ReportIncident"
Content-Length: 635
Host: localhost:8181
Connection: Keep-Alive

<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:rep="http://reportincident.example.camel.apache.org">
   <soapenv:Header/>
   <soapenv:Body>
      <rep:inputReportIncident>
         <incidentId>gero et</incidentId>
         <incidentDate>sonoras imperio</incidentDate>
         <givenName>quae divum incedo</givenName>
         <familyName>verrantque per auras</familyName>
         <summary>per auras</summary>
         <details>circum claustra</details>
         <email>nimborum in</email>
         <phone>foedere certo</phone>
      </rep:inputReportIncident>
   </soapenv:Body>
</soapenv:Envelope>
```
如果使用soap12时，默认使用的是`application/soap+xml;charset=UTF-8`

```
POST http://0.0.0.0:8888/ws/Uti/InterfacesWeb HTTP/1.1
Accept-Encoding: gzip,deflate
User-Agent: charset=utf-8
Content-Type: application/soap+xml;charset=UTF-8
Content-Length: 1401
Host: 0.0.0.0:8888
Connection: Keep-Alive

<soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope" xmlns:tem="http://tempuri.org/">
   <soap:Header xmlns:wsa="http://www.w3.org/2005/08/addressing"><wsa:Action>http://tempuri.org/IInterfacesWeb/RegistrarComercioPatrocinado</wsa:Action><wsa:MessageID>uuid:cfe2e077-8b2e-4820-b61d-4332d3259b65</wsa:MessageID><wsa:To>http://0.0.0.0:8888/ws/Uti/InterfacesWeb</wsa:To></soap:Header>
   <soap:Body>
      <tem:RegistrarComercioPatrocinado>
         <!--Optional:-->
         <tem:codcomerciopadre/>
         <!--Optional:-->
         <tem:codcomerciopatro>22222</tem:codcomerciopatro>
         <!--Optional:-->
         <tem:nomcomerciopatro>TEST</tem:nomcomerciopatro>
         <!--Optional:-->
         <tem:ruccompatro>999999</tem:ruccompatro>
         <!--Optional:-->
         <tem:rzcompatro>TEST</tem:rzcompatro>
         <!--Optional:-->
         <tem:mccintcompatro>8041</tem:mccintcompatro>
         <!--Optional:-->
         <tem:replegcompatro>TESt</tem:replegcompatro>
         <!--Optional:-->
         <tem:emailcompatro>TEST@TEST.COM</tem:emailcompatro>
         <!--Optional:-->
         <tem:telefcompatro>11223344</tem:telefcompatro>
         <!--Optional:-->
         <tem:urlcompatro>HTTP://TEST.COM</tem:urlcompatro>
         <!--Optional:-->
         <tem:usrregistro>VISA</tem:usrregistro>
      </tem:RegistrarComercioPatrocinado>
   </soap:Body>
</soap:Envelope>
```

比如如下的<camelcxf:cxfEndpoint> 该endpoint是使用camel route的实现提供了一个webservice的endpoint，访问地址是：
http://localhost:8181/cxf/camel-example-cxf-blueprint/webservices/incident
可以通过访问wsdl url来得知该service的详细信息。
```
<blueprint xmlns="http://www.osgi.org/xmlns/blueprint/v1.0.0"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           xmlns:cm="http://aries.apache.org/blueprint/xmlns/blueprint-cm/v1.0.0"
           xmlns:jaxws="http://cxf.apache.org/blueprint/jaxws"
           xmlns:cxf="http://cxf.apache.org/blueprint/core"
           xmlns:camel="http://camel.apache.org/schema/blueprint"
           xmlns:camelcxf="http://camel.apache.org/schema/blueprint/cxf"
           xsi:schemaLocation="
             http://www.osgi.org/xmlns/blueprint/v1.0.0 https://www.osgi.org/xmlns/blueprint/v1.0.0/blueprint.xsd
             http://cxf.apache.org/blueprint/jaxws http://cxf.apache.org/schemas/blueprint/jaxws.xsd
             http://cxf.apache.org/blueprint/core http://cxf.apache.org/schemas/blueprint/core.xsd
             ">

  <camelcxf:cxfEndpoint id="reportIncident"
                        address="/camel-example-cxf-blueprint/webservices/incident"
                        endpointName="s:ReportIncidentEndpoint"
                        serviceName="s:ReportIncidentEndpointService"
                        wsdlURL="META-INF/wsdl/report_incident.wsdl"
                        serviceClass="org.apache.camel.example.reportincident.ReportIncidentEndpoint"
                        xmlns:s="http://reportincident.example.camel.apache.org">
    <camelcxf:inInterceptors>
      <bean id="loggingInInterceptor" class="org.apache.cxf.interceptor.LoggingInInterceptor"/>
    </camelcxf:inInterceptors>
    <camelcxf:outInterceptors>
      <bean id="loggingOutInterceptor" class="org.apache.cxf.interceptor.LoggingOutInterceptor"/>
    </camelcxf:outInterceptors>

  </camelcxf:cxfEndpoint>

  <bean id="reportIncidentRoutes" class="org.apache.camel.example.reportincident.ReportIncidentRoutes"/>

  <camelContext id="camel" xmlns="http://camel.apache.org/schema/blueprint">
    <routeBuilder ref="reportIncidentRoutes"/>
  </camelContext>

</blueprint>
```

the route defined the service through camel cxf component.
```
        from("cxf:bean:reportIncident")
            .convertBodyTo(InputReportIncident.class)
            .wireTap("file://target/inbox/?fileName=request-${date:now:yyyy-MM-dd-HHmmssSSS}")
            .choice().when(simple("${body.givenName} == 'Claus'"))
                .transform(constant(ok))
            .otherwise()
                .transform(constant(accepted));
```
