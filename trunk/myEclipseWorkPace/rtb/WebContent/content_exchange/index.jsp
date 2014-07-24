<div class="container theme-showcase" id="page-tab"
	style="padding-top: 110px;">
	<ul class="nav nav-tabs">

		<li title="overview"><a href="#"
			onclick="changePage('overview','exchange')">DashBoard Overview</a></li>
		<li title="dailyExchangePayoutByHour"><a href="#"
			onclick="changePage('dailyExchangePayoutByHour','exchange')">Hour</a></li>

	</ul>
</div>
<div id="subPageContent">
</div>
<script type="text/javascript">
<!--

//-->
var page=urlMaster.getParam('p');
if(page==''){
	page='overview';
	urlMaster.addParam('page',page);
}
loadSubPage(page,'exchange');
</script>
