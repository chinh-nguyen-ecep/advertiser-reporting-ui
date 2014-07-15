<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>VLMO Dashboard</title>
    <!-- Bootstrap -->
    <link href="../../scripts/bootstrap-3.0.0/css/bootstrap.min.css" rel="stylesheet">
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="../../scripts/bootstrap-3.0.0/js/html5shiv.js"></script>
      <script src="../../scripts/bootstrap-3.0.0/js/respond.min.js"></script>
    <![endif]-->
    <script src="../../scripts/jquery-2.0.min.js"></script>
	<!--   Hight chart -->
    <script src="../../scripts/Highcharts-3.0.4/js/highcharts.js"></script>
    <script src="../../scripts/Highcharts-3.0.4/js/highcharts-more.js"></script>
    <script src="../../scripts/Highcharts-3.0.4/js/modules/exporting.js"></script>
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
	<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
	<!--  control scripts -->
	<script type="text/javascript" src="../../scripts/control/utils.js"></script>	
	<link href="../../css/web.css" rel="stylesheet" media="screen">
  </head>
  <body >
<%@page import="java.util.Enumeration"%>
<%
	String user=request.getRemoteUser();
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
	        <a class="navbar-brand" href="../../" style="color: white;font-size: 15pt;">VLMO Dashboard</a>
	 		    <!-- form class="navbar-form navbar-right form-inline" role="form">
					<div class="form-group">
			   	     <select class="form-control">			        
				        <option>Advertiser</option>
				        <option>Order</option>
				      </select>
					</div>
			      <div class="form-group">
			        <input type="text" class="form-control" placeholder="">
			      </div>
			      <button type="submit" class="btn btn-primary">Filter</button>
			    </form-->  
			    <div class="row" >
			   
			    <div class="col-md-8" style="color: white;padding-top: 2px">
			    	 <div class="btn-group" style="float: right;margin-right: 0px">
						  <button class="btn btn-warning btn-xs dropdown-toggle" type="button" data-toggle="dropdown">
						    <%=user %> <span class="caret"></span>
						  </button>
						  <a class="dropdown-toggle" data-toggle="dropdown" href=""></a>
						  <ul class="dropdown-menu">
						   <li><a href="logout.jsp">Logout</a></li>
						  </ul>
					</div> 
					<span style="float: right;margin-right: 5px">Welcome back</span>
			    </div>
			    	 
			    </div>
			         
	        </div><!--/.nav-collapse -->
	      </div>	  
	  </div>
    </div>
    </div>
    <script>
    loginUser='<%=user %>';
    </script>