<div class="container theme-showcase" id="page-tab"
	style="padding-top: 110px;">
	<ul class="nav nav-tabs">

		<li title="overview"><a href="#"
			onclick="changePage('overview','winrate')">DashBoard Overview</a></li>
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
loadSubPage(page,'winrate');
</script>