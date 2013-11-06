<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Advertiser Dashboard</title>
    <!-- Bootstrap -->
    <link href="css/web.css" rel="stylesheet" media="screen">
    <link href="scripts/bootstrap-3.0.0/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="scripts/bootstrap-3.0.0/js/html5shiv.js"></script>
      <script src="scripts/bootstrap-3.0.0/js/respond.min.js"></script>
    <![endif]-->
    <script src="scripts/jquery-1.8.2.js"></script>
    <script src="scripts/Highcharts-3.0.4/js/highcharts.js"></script>
    <script src="scripts/Highcharts-3.0.4/js/highcharts-more.js"></script>
    <!-- Select 2 -->
    <link rel="stylesheet" type="text/css" media="screen" href="scripts/select2-3.4.3/select2.css"> 
    <script src="scripts/select2-3.4.3/select2.js"></script>
    <!-- Date range picker -->
    <link rel="stylesheet" type="text/css" media="all" href="scripts/bootstrap-daterangepicker-master/daterangepicker-bs3.css" />
    <script type="text/javascript" src="scripts/bootstrap-daterangepicker-master/moment.js"></script>
    <script type="text/javascript" src="scripts/bootstrap-daterangepicker-master/daterangepicker.js"></script>
    <!-- Date format date.format.js -->
	<script type="text/javascript" src="scripts/date.format.js"></script>
	<!-- Number format -->
	<script type="text/javascript" src="scripts/accounting.min.js"></script>
	<!--  control scripts -->
	<script type="text/javascript" src="scripts/control/utils.js"></script>	
  </head>
  <body >
  <iframe style="display: none;" src="/advertiserapi"></iframe>
	<jsp:include page="/header.jsp" />
    <div class="container theme-showcase">
		<%
		 String p="overview";
		 if(request.getParameter("p")!=null)
		 { 
		   p = request.getParameter("p");		
		 }
		 String includePage="/"+p+".jsp";
		%>
		<jsp:include page="<%= includePage %>" flush="true"/>
	</div>
	
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
   
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="scripts/bootstrap-3.0.0/js/bootstrap.min.js"></script>

  </body>
</html>