<?xml version="1.0" encoding="UTF-8"?>
<Context path="AdvertiserDashboard " docbase="webapps/AdvertiserDashboard/">
   	 <Resource name="IBConnection" auth="Container" type="javax.sql.DataSource"
               maxActive="100" maxIdle="30" maxWait="-1"
               username="vrvdataadmin" password="ecep-2009" driverClassName="com.mysql.jdbc.Driver"
               url="jdbc:mysql://localhost:5029/adv_ui"/>
   	 <Resource name="verveReportConnection" auth="Container" type="javax.sql.DataSource"
          maxActive="100" maxIdle="30" maxWait="-1"
          username="pentaho" password="ECEP-2009" driverClassName="org.postgresql.Driver"
          url="jdbc:postgresql://localhost:55432/warehouse"/>
   	 <!-- Resource name="verveReportConnection" auth="Container" type="javax.sql.DataSource"
          maxActive="100" maxIdle="30" maxWait="-1"
          username="pentaho" password="ECEP-2009" driverClassName="org.postgresql.Driver"
          url="jdbc:postgresql://localhost:55432/warehouse"/-->
</Context>