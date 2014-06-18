<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>BA National Management</title>
<link rel="stylesheet" type="text/css"
	href="/verve-lib/scripts/bootstrap-3.0.0/css/bootstrap.min.css" />
<link href="/verve-lib/scripts/bootstrap-3.0.0/blugins/font-awesome/css/font-awesome.css" rel="stylesheet" />

<script src="/verve-lib/scripts/jquery-2.0.min.js"></script>
<script type="text/javascript" src="/verve-lib/scripts/bootstrap-3.0.0/js/bootstrap.min.js"></script>
<script type="text/javascript"	src="/verve-lib/scripts/bootstrap-3.0.0/blugins/moment.min.js"></script>
<script type="text/javascript"	src="/verve-lib/scripts/bootstrap-3.0.0/blugins/jquery.validate.bootstrap.popover.min.js"></script>
<script type="text/javascript"	src="/verve-lib/scripts/bootstrap-3.0.0/blugins/jquery.validate.min.js"></script>
<script type="text/javascript"	src="/verve-lib/scripts/bootstrap-3.0.0/blugins/bootbox.min.js"></script>
<script src="/verve-lib/scripts/async-master/lib/async.js"></script>
    <!-- Select 2 -->
    <link rel="stylesheet" type="text/css" media="screen" href="/verve-lib/scripts/select2-3.4.3/select2.css"> 
    <script src="/verve-lib/scripts/select2-3.4.3/select2.js"></script>

<script type="text/javascript" src="/verve-lib/scripts/bootstrap-3.0.0/myUtils.js"></script>

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
	background-color: #f5f5f5;
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

</style>
</head>
<body>
	<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
		<!-- Brand and toggle get grouped for better mobile display -->
		<div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse"data-target="navbar-ex1-collapse">
				<span class="sr-only">Toggle navigation</span> <span class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>
			<a class="navbar-brand" href="#"><span class="icon-stack">
					<i class="icon-sign-blank icon-stack-base"></i> <i class="icon-twitter icon-light"></i>
			</span>BA National Management</a>			
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
			<li title="Information" class="active"><a href="#"	onclick="goHomePage()">Information</a></li>
			<li title="Additional Adjustment"><a href="#" onclick="">Additional Adjustment</a></li>
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
var globalTimeout=null;
function delay_timeout(second_time,func){
	if(globalTimeout != null) clearTimeout(globalTimeout); 
	globalTimeout =setTimeout(function(){func();},second_time);
}
		//this function paser param from url
		function gup(name) {
			name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
			var regexS = "[\\?&]" + name + "=([^&#]*)";
			var regex = new RegExp(regexS);
			var results = regex.exec(window.location.href);
			if (results == null)
				return "";
			else
				return results[1];
		}

		var solution = gup('solution');
		var path = gup('path');
		var rootPath = 'ViewAction?solution=' + solution + '&path=' + path+ '&action=ba_national_management.xaction';
		var rootPath_Information = 'ViewAction?solution=' + solution + '&path=' + path+'/ba_national_management'+ '&action=information_management.xaction';
		
		// end process start date , end date 
		$(document).ready(function() {
			console.log("ready!");
			console.log("jQuery verion: " + jQuery.fn.jquery);
			initProcessingPage();
		});

		//*******************************
		// Script code on Processing page
		//*******************************
		var initProcessingPage = function() {		
			loadPage();
		};
		//*******************************
		// Script code on Processing page
		//*******************************
		
		function loadPage(){
			var page=urlMaster.getParam('page');	
			var actionPath=	urlMaster.getParam('actionPath');	
			if(page==''){
				page='information_script';
				actionPath='information_management';
				urlMaster.addParam('page',page);
				urlMaster.addParam('actionPath',actionPath);
			}
			var url='ViewAction?solution=' + solution + '&path=' + path+'/ba_national_management'+ '&action='+actionPath+'.xaction'+'&actions='+page;			
			$('#summary-content div.content').load(	url,function(){
				$('#summary-content').removeClass('loading');				
			});
		}
		
		function goHomePage(){
				var page='information_script';
				var actionPath='information_management';
				urlMaster.replaceParam('page',page);
				urlMaster.replaceParam('actionPath',actionPath);
				loadPage();				
		}
		
	</script>
</body>
</html>