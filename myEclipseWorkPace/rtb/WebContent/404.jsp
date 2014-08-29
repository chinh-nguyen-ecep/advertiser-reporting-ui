<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.security.MessageDigest"%>
<%
	String user = request.getRemoteUser();
	MessageDigest md = MessageDigest.getInstance("MD5");
	String imgCode = "";
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link	href="https://df9urjk039lhc.cloudfront.net/assets/favicon-68ac198092837bfbc600263a7c29c904.png"	rel="shortcut icon" />
<title>Verve Mobile</title>
<!-- Bootstrap -->
	<link href="/rtb/scripts/bootstrap-3.0.0/css/bootstrap.min.css"	rel="stylesheet">
<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
      <script src="/rtb/scripts/bootstrap-3.0.0/js/html5shiv.js"></script>
      <script src="/rtb/scripts/bootstrap-3.0.0/js/respond.min.js"></script>
    <![endif]-->
	<script src="/rtb/scripts/jquery-2.0.min.js"></script>
<!--   Hight chart -->
	<script src="/rtb/scripts/Highcharts-3.0.4/js/highcharts.js"></script>
	<script src="/rtb/scripts/Highcharts-3.0.4/js/highcharts-more.js"></script>
	<script src="/rtb/scripts/Highcharts-3.0.4/js/modules/exporting.js"></script>
<!-- Select 2 -->
	<link rel="stylesheet" type="text/css" media="screen"	href="/rtb/scripts/select2-3.4.3/select2.css">
	<script src="/rtb/scripts/select2-3.4.3/select2.js"></script>
<!-- Date range picker -->
	<link rel="stylesheet" type="text/css" media="all"	href="/rtb/scripts/bootstrap-daterangepicker-master/daterangepicker-bs3.css" />
	<script type="text/javascript"	src="/rtb/scripts/bootstrap-daterangepicker-master/moment.js"></script>
	<script type="text/javascript"	src="/rtb/scripts/bootstrap-daterangepicker-master/daterangepicker.js"></script>
<!-- Date format date.format.js -->
	<script type="text/javascript" src="/rtb/scripts/date.format.js"></script>
<!-- Number format -->
	<script type="text/javascript" src="/rtb/scripts/accounting.min.js"></script>
<!-- font-awesome	-->
	<link	href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css"	rel="stylesheet">
<!--  control scripts -->
	<script type="text/javascript" src="/rtb/scripts/control/utils.js"></script>
	<link href="/rtb/css/sticky-footer-navbar.css" rel="stylesheet"	media="screen">
	<link href="/rtb/css/web.css" rel="stylesheet" media="screen">
	<style type="text/css">
	center.pageNotFound,center.pageNotFound h1,center.pageNotFound h3,center.pageNotFound h5{
		color: #848484;
		font-family: "Lucida", Grande, sans-serif;
	}
	</style>
</head>
<body>
	<div class="navbar navbar-inverse navbar-fixed-top"	style="border: none;">
		<div class="navbar-inner"	style="background-image: url('/rtb/images/reports_back-fb.png'); height: 90px; padding-top: 10px;">
			<div class="container">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse"
						data-target=".navbar-collapse">
						<span class="icon-bar"></span> <span class="icon-bar"></span> <span
							class="icon-bar"></span>
					</button>
					<img alt="Verve logo" src="/rtb/images/verve-logo.png">
				</div>
				<div class="navbar-collapse collapse">
					<a class="navbar-brand" href="/rtb"	style="color: white; font-size: 15pt;">RTB DashBoard</a>
				</div>
				<!--/.nav-collapse -->
			</div>
		</div>
	</div>
	<div id="index_container" class="container theme-showcase">
		<center class="pageNotFound" style="margin-top: 100px;">
			<h1 style="font-size: 100pt;">404</h1>
			<h3>PAGE NOT FOUND</h3>
			<h1>OH MY GOSH! YOU FOUND IT!!!</h1>
			
			<h5 style="margin-top: 30px;">Looks like the page you're trying visit doesn't exist.</h5>
			<h5>Please check the URL and try your luck again.</h5>
			
			<a style="margin-top: 20px;" class="btn btn-xl btn-warning" href="/rtb" >Take Me Home</a>
		</center>
	</div>
	<jsp:include page="/footer.jsp" />
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script src="/rtb/scripts/bootstrap-3.0.0/js/bootstrap.min.js"></script>
</body>
</html>
