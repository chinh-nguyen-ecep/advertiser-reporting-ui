<?xml version="1.0" encoding="UTF-8"?>
<Context path="/vlmo" docbase="webapps/vlmo/">
   	 <Resource name="IBConnection" auth="Container" type="javax.sql.DataSource"
               maxActive="100" maxIdle="30" maxWait="-1"
               username="nhut" password="Nl0218" driverClassName="com.mysql.jdbc.Driver"
               url="jdbc:mysql://ec2-107-22-90-50.compute-1.amazonaws.com:5029/binh"/>
   	 <Resource name="verveReportConnection" auth="Container" type="javax.sql.DataSource"
          maxActive="100" maxIdle="30" maxWait="-1"
          username="pentaho" password="verve-2013" driverClassName="org.postgresql.Driver"
          url="jdbc:postgresql://localhost:35432/warehouse"/>
</Context>