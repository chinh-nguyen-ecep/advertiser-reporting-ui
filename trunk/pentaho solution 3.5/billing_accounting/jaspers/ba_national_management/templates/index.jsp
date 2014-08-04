<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Billing/Accounting National Management</title>
<link rel="stylesheet" type="text/css"	href="/verve-lib/scripts/bootstrap-3.0.0/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css"	href="/verve-lib/scripts/bootstrap-3.0.0/css/bootstrap - custom.css" />	
<link href="/verve-lib/scripts/bootstrap-3.0.0/blugins/font-awesome/css/font-awesome.css" rel="stylesheet" />

<script src="/verve-lib/scripts/jquery-2.0.min.js"></script>
<script type="text/javascript" src="/verve-lib/scripts/bootstrap-3.0.0/js/bootstrap.min.js"></script>
<script type="text/javascript"	src="/verve-lib/scripts/bootstrap-3.0.0/blugins/moment.min.js"></script>
<script type="text/javascript"	src="/verve-lib/scripts/bootstrap-3.0.0/blugins/jquery.validate.bootstrap.popover.min.js"></script>
<script type="text/javascript"	src="/verve-lib/scripts/bootstrap-3.0.0/blugins/jquery.validate.min.js"></script>
<script type="text/javascript"	src="/verve-lib/scripts/bootstrap-3.0.0/blugins/bootbox.min.js"></script>
<script type="text/javascript"	src="/verve-lib/scripts/accounting.min.js"></script>
<script type="text/javascript"	src="/verve-lib/scripts/date.format.js"></script>
<script src="/verve-lib/scripts/async-master/lib/async.js"></script>
<!-- Select 2 -->
<link rel="stylesheet" type="text/css" media="screen" href="/verve-lib/scripts/select2-3.4.3/select2.css"> 
<script src="/verve-lib/scripts/select2-3.4.3/select2.js"></script>

<script type="text/javascript" src="/verve-lib/scripts/bootstrap-3.0.0/myUtils.js"></script>
<script src="/verve_style/scripts2/utils.js"></script>

<style>
div.first-tab {
	margin-top: 80px;
	margin-bottom: 5px;
}

.loading{
	background-image: url("http://www.oenovaults.com/images/loading.gif");
	background-repeat: no-repeat;
	background-position: center;
	background-size: 50px 50px;
}

.breadcrumbs{
	text-align: right;
	margin-bottom: 10px;
}
.breadcrumbs a{
	color: #5E5E5E;
	text-decoration: none;
}

.form-actions {
	padding: 19px 20px 20px;
	margin-top: 20px;
	margin-bottom: 20px;
	border-top: 1px solid #e5e5e5;
	padding-left: 0px;
}
.form-horizontal .form-group{
	margin-right: 0px; 
	margin-left: 0px; 
}

label.required abbr[title] {
	color: #CA3935;
	border: none;
	font-weight: bold;
}
tr.selected{
background: #F8F8F8;
}

table thead th.buttons {
background-color: #e7e7e7;
background-image: -moz-linear-gradient(top, #eeeeee, #dddddd);
background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#eeeeee), to(#dddddd));
/* background-image: -webkit-linear-gradient(top, #eeeeee, #dddddd); */
background-image: -o-linear-gradient(top, #eeeeee, #dddddd);
/* background-image: linear-gradient(to bottom, #eeeeee, #dddddd); */
/* background-repeat: repeat-x; */
filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffeeeeee', endColorstr='#ffdddddd', GradientType=0);
border-bottom: 1px solid #ccc;
}

tr.summary {
background-color: #e7e7e7;
background-image: -moz-linear-gradient(top, #eeeeee, #dddddd);
background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#eeeeee), to(#dddddd));
filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffeeeeee', endColorstr='#ffdddddd', GradientType=0);
}

tr.month_summary{
background-color: #FAFAFA;
background-image: -moz-linear-gradient(top, #eeeeee, #dddddd);
background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#eeeeee), to(#dddddd));
filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffeeeeee', endColorstr='#ffdddddd', GradientType=0);
}
.btn {
border-color: #e6e6e6 #e6e6e6 #bfbfbf;
border-color: rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.1) rgba(0, 0, 0, 0.25);
}

.muted {
color: #999999;
}
</style>
</head>
<body>
	<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="navbar-ex1-collapse">
				<span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="#"><span class="icon-stack">
					<i class="icon-sign-blank icon-stack-base"></i> <i class="icon-usd icon-light"></i>
			</span>Billing/Accounting National Management</a>			
		</div>

		<!-- Collect the nav links, forms, and other content for toggling -->
		<div class="collapse navbar-collapse navbar-ex1-collapse">
			<form novalidate="novalidate" id="topForm" class="navbar-form navbar-left" role="search"	style="margin-top: 20px;">
				<div class="form-group">
					
				</div>	
			</form>
			<form novalidate="novalidate" id="exportSummary_bt" class="navbar-form navbar-right" role="search"	style="margin-top: 20px;display: none;">
				<div class="form-group">
					
				</div>	
			</form>			

		</div>
		<!-- /.navbar-collapse -->
	</nav>
	<div class="container first-tab theme-showcase " id="page-tab">
		<ul class="nav nav-tabs">
			<li title="Billing Worksheet" class="active"><a href="#" onclick="goHomePage()">Billing Monthly Worksheet</a></li>
			<li title="Billing MonthTODate Worksheet" class="active"><a href="#" onclick="goMonthToDate()">Billing MonthToDate  Worksheet</a></li>
			<li title="Information"><a href="#" onclick="goInformationPage()">Information</a></li>
			<li title="Adjustment"><a href="#" onclick="goAdjustedUnitPage()">Adjustment</a></li>
		</ul>
	</div>

	<div class="container" id="main-content">
		<div id="summary-content" style="min-height: 200px;" class="loading">
		<div class="content"></div>		
		</div>
		<div id="invoice-detail" style="display: none;min-height: 200px;"></div>
	</div>
<!-- Modal Publishing Status-->

<!-- /.modal -->
	<script>
		{mainScript}
		{informationControl}
		{adjustedUnitsControl}
		{billingControl}
	</script>
</body>
</html>