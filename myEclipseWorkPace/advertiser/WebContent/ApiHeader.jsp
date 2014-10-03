<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link
	href="https://df9urjk039lhc.cloudfront.net/assets/favicon-68ac198092837bfbc600263a7c29c904.png"
	rel="shortcut icon" />
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Verve Mobile</title>
    <!-- Bootstrap -->
    <link href="../../scripts/bootstrap-3.0.0/css/bootstrap.min.css" rel="stylesheet">
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="../../scripts/bootstrap-3.0.0/js/html5shiv.js"></script>
      <script src="../../scripts/bootstrap-3.0.0/js/respond.min.js"></script>
    <![endif]-->
    <script src="../../scripts/jquery-2.0.min.js"></script>
	<!--   Hight chart -->
    <script src="../../scripts/Highcharts-4.0.3/js/highcharts.js"></script>
    <script src="../../scripts/Highcharts-4.0.3/js/highcharts-more.js"></script>
    <script src="../../scripts/Highcharts-4.0.3/js/modules/exporting.js"></script>
    <!-- Select 2 -->
    <link rel="stylesheet" type="text/css" media="screen" href="../../scripts/select2-3.4.3/select2.css"> 
    <script src="../../scripts/select2-3.4.3/select2.js"></script>
    <!-- Date range picker -->
    <link rel="stylesheet" type="text/css" media="all" href="../../scripts/bootstrap-daterangepicker-master/daterangepicker-bs3.css" />
    <script type="text/javascript" src="../../scripts/bootstrap-daterangepicker-master/moment.js"></script>
    <script type="text/javascript" src="../../scripts/bootstrap-daterangepicker-master/daterangepicker.js"></script>
    <!-- Date format date.format.js -->
	<script type="text/javascript" src="../../scripts/date.format.js"></script>
	<!-- Number format -->
	<script type="text/javascript" src="../../scripts/accounting.min.js"></script>
	<!-- font-awesome	-->
	<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" rel="stylesheet">
	<!--  control scripts -->
	<script type="text/javascript" src="../../scripts/control/utils.js"></script>	
	<link href="../../css/sticky-footer-navbar.css" rel="stylesheet" media="screen">
	<link href="../../css/web.css" rel="stylesheet" media="screen">
  </head>
  <body >
<%@page import="java.util.Enumeration"%>
<%@page import="java.security.MessageDigest"%>
<%
	String user=request.getRemoteUser();
	MessageDigest md = MessageDigest.getInstance("MD5");
	String imgCode="";
	md.update(user.getBytes());
	 byte byteData[] = md.digest();
	//convert the byte to hex format method 1
     StringBuffer sb = new StringBuffer();
     for (int i = 0; i < byteData.length; i++) {
      sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
     }
     imgCode=sb.toString();
  %>
  <div class="navbar navbar-default navbar-fixed-top">
	  <div class="navbar navbar-default navbar-fixed-top">
	  <div class="navbar-inner" style="background-image: url('../../images/reports_back-fb.png');height: 90px;padding-top: 10px;">
	      <div class="container">
	        <div class="navbar-header">
	          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	          </button>
	          <img alt="Verve logo" src="../../images/verve-logo.png">
	          
	        </div>
	        <div class="navbar-collapse collapse">
	        <a class="navbar-brand" href="../../api/v1/overview" style="color: white;font-size: 15pt;">Advertiser API</a>
 	        <form class="navbar-form navbar-right" action="../../" role="search">
            <div class="form-group">
               <div class="btn-group" style="float: right; margin-right: 0px">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#" style="color: white;margin-left: 10px;margin-right: 10px;">
							<img class="gravatar" src="https://secure.gravatar.com/avatar/<%=imgCode%>.png?s=20"/>
							<%=user%>
							<span class="caret" style="border-top: 4px solid #FFF;"></span>
							</a>
							<ul class="dropdown-menu">
							<li>
							<a href="http://gravatar.com" target="_blank"><i class="fa fa-user"></i>
							Change Avatar
							</a></li>
								<li><a href="logout.jsp"><i class="fa fa-sign-out"></i>Logout</a></li>
							</ul>
						</div>
				<span style="float: right;margin-right: 5px; color: white;">Welcome back</span>
            </div>
            <button type="submit" class="btn btn-xs btn-success">DashBoard</button>
          </form>
			         
	        </div><!--/.nav-collapse -->
	      </div>	  
	  </div>
	  	<div class="subbar-inner">
		<div class="container">
			<div class="nav-collapse collapse">
				<ul class="nav">
					
				</ul>

			</div>
		</div>
	</div>
    </div>
    </div>
    <script>
    loginUser='<%=user %>';
    </script>