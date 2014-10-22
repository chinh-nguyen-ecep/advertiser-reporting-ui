<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link
	href="https://df9urjk039lhc.cloudfront.net/assets/favicon-68ac198092837bfbc600263a7c29c904.png"
	rel="shortcut icon" />
<title>Verve Mobile</title>
<!-- Bootstrap -->
<link href="scripts/bootstrap-3.0.0/css/bootstrap.min.css"
	rel="stylesheet">
<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
      <script src="scripts/bootstrap-3.0.0/js/html5shiv.js"></script>
      <script src="scripts/bootstrap-3.0.0/js/respond.min.js"></script>
    <![endif]-->
<script src="scripts/jquery-2.0.min.js"></script>
<!--   Hight chart -->
<script src="scripts/Highcharts-4.0.3/js/highcharts.js"></script>
<script src="scripts/Highcharts-4.0.3/js/highcharts-more.js"></script>
<script src="scripts/Highcharts-4.0.3/js/modules/data.js"></script>
<script src="scripts/Highcharts-4.0.3/js/modules/heatmap.js"></script>
<script src="scripts/Highcharts-4.0.3/js/modules/exporting.js"></script>

<!-- Select 2 -->
<link rel="stylesheet" type="text/css" media="screen"
	href="scripts/select2-3.4.3/select2.css">
<script src="scripts/select2-3.4.3/select2.js"></script>
<!-- Date range picker -->
<link rel="stylesheet" type="text/css" media="all"
	href="scripts/bootstrap-daterangepicker-master/daterangepicker-bs3.css" />
<script type="text/javascript"	src="scripts/bootstrap-daterangepicker-master/moment.js"></script>
<script type="text/javascript"	src="scripts/bootstrap-daterangepicker-master/daterangepicker.js"></script>

<!-- Date format date.format.js -->
<script type="text/javascript" src="scripts/date.format.js"></script>
<!-- Number format -->
<script type="text/javascript" src="scripts/accounting.min.js"></script>
<!-- Moment time zone -->
<script type="text/javascript" src="scripts/moment-timezone-with-data.js"></script>
<!-- font-awesome	-->
<link href="css/font-awesome.min.css" rel="stylesheet">
<!--  control scripts -->
<script type="text/javascript" src="scripts/control/utils.js"></script>

<link href="css/sticky-footer-navbar.css" rel="stylesheet" media="screen">
<link href="css/web.css" rel="stylesheet" media="screen">
</head>
<body>
	<!--   <iframe id="apipage" style="display: none;" src="/vlmoApi"></iframe> -->
	<jsp:include page="/header.jsp" />
	<div id="index_container" class="container theme-showcase loadingDots" style=""></div>
	<jsp:include page="/footer.jsp" />
	<!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->

	<!-- Include all compiled plugins (below), or include individual files as needed -->
	<script src="scripts/bootstrap-3.0.0/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		$(document).ready(function() {
			moment().tz("UTC").format();
			verifyApiPageConnection();
		});
		function verifyApiPageConnection() {
			var urlToVarify = apiRootUrl + "/dailyExchangeCostAnalysis?info";
			$.ajax({
				url : urlToVarify,
				dataType : "json",
				success : function(data) {
					var responeUrl = data.apiUrl;
					if (responeUrl == "") {
						delayTimeout(5000, function() {
							location.reload(false);
						});
					} else {
						var page = urlMaster.getParam('p');
						var workbook = urlMaster.getParam('wb');
						if (workbook == ''){
							urlMaster.clear();
							workbook = 'exchange';
							urlMaster.replaceParam('wb',workbook);
						}
						loadPage(workbook);
					}
				},
				error : function() {
					//changePage('pageNotFound');
					delayTimeout(5000, function() {
						location.reload(false);
					});
				}
			});

		}
		function changePage(page,workbook) {
			urlMaster.clear();
			urlMaster.replaceParam('p', page);
			urlMaster.replaceParam('wb', workbook);
			loadPage(workbook);
		}
		function loadPage(workbook) {
			$('#index_container').addClass('loadingDots');
			var url = rootUrl + '/'+'content_'+workbook+'/' + 'index.jsp';
			$.ajax({
				url : url,
				dataType : 'html',
				success : function(data) {
					$('#index_container').removeClass('loadingDots');
					$('#index_container').html(data);
					
				},
				error : function() {
					//changePage('pageNotFound');
				}
			});
		}
		function loadSubPage(page,workbook){
			$('#subPageContent').addClass('loadingDots');
			var url = rootUrl + '/'+'content_'+workbook+'/' + page+'.jsp';
			$.ajax({
				url : url,
				dataType : 'html',
				success : function(data) {
					$('#subPageContent').removeClass('loadingDots');
					$('#subPageContent').html(data);
					
				},
				error : function() {
					//changePage('pageNotFound');
				}
			});
		}
	</script>
</body>
</html>
