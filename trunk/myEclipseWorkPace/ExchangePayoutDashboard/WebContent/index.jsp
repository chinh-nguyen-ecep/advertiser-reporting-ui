<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Exchange Payout Dashboard</title>
    <!-- Bootstrap -->
    
    <link href="scripts/bootstrap-3.0.0/css/bootstrap.min.css" rel="stylesheet" media="screen">
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
      <script src="scripts/bootstrap-3.0.0/js/html5shiv.js"></script>
      <script src="scripts/bootstrap-3.0.0/js/respond.min.js"></script>
    <![endif]-->
    <script src="scripts/jquery-1.8.2.js"></script>
	<!--   Hight chart -->
    <script src="scripts/Highcharts-3.0.4/js/highcharts.js"></script>
    <script src="scripts/Highcharts-3.0.4/js/highcharts-more.js"></script>
    <script src="scripts/Highcharts-3.0.4/js/modules/exporting.js"></script>
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
	<!-- font-awesome	-->
	<link href="//netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css" rel="stylesheet">
	<!--  control scripts -->
	<script type="text/javascript" src="scripts/control/utils.js"></script>	
	<link href="css/web.css" rel="stylesheet" media="screen">
  </head>
  <body >
  <iframe id="apipage" style="display: none;" src="/ExchangePayoutApi"></iframe>
	<jsp:include page="/header.jsp" />
    <div id="index_container" class="container theme-showcase loadingDots" style="min-height: 200px;">
		
	</div>
	
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
   
    <!-- Include all compiled plugins (below), or include individual files as needed -->
    <script src="scripts/bootstrap-3.0.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
	// Callback funtion when apipage are loaded by iframe
	document.getElementById('apipage').contentWindow.callBackParent = doStuff();
	function doStuff(){
		console.log('Api page load completed...');
		$(document).ready(function(){ 
			
			//loadPage(page);
			verifyApiPageConnection();
		});
	}
	function verifyApiPageConnection(){
		var urlToVarify=apiRootUrl+"/dailyExchangeCostAnalysis?info";
		$.ajax({
			url: urlToVarify,
			dataType : "json",
			success: function(data){
				var responeUrl=data.apiUrl;			
				if(responeUrl==""){
					delayTimeout(5000,function(){
						location.reload(false);
					});
				}else{
					var page=urlMaster.getParam('p');
					if(page==''){
						page='overview';
						urlMaster.clear();
						urlMaster.addParam('p',page);
					}
					loadPage(page);
				}				
			},
			error: function(){
				//changePage('pageNotFound');
				delayTimeout(5000,function(){
					location.reload(false);
				});
			}
		});
		
	}
	function changePage(page){
		urlMaster.clear();
		urlMaster.addParam('p',page);
		$('#index_container').addClass('loadingDots');
		var url=rootUrl+'/'+page+'.jsp';
		$.ajax({
			url: url,
			dataType : 'html',
			success: function(data){
				$('#index_container').html(data);
				$('#index_container').removeClass('loadingDots');
			},
			error: function(){
				//changePage('pageNotFound');
			}
		});
	}
	function loadPage(page){
		$('#index_container').addClass('loadingDots');
		var url=rootUrl+'/'+page+'.jsp';
		$.ajax({
			url: url,
			dataType : 'html',
			success: function(data){
				$('#index_container').html(data);
				$('#index_container').removeClass('loadingDots');
			},
			error: function(){
				//changePage('pageNotFound');
			}
		});	
	}
	</script>
  </body>
</html>
