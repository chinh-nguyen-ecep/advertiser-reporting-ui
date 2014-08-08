
<jsp:include page="../../ApiHeader.jsp" />
<div id="index_container" class='container' style="margin-top: 100px;">
	<div class='content'>
		<nav>
			<ul class='breadcrumb'>
				<li class='active'>API Overview</li>
			</ul>
		</nav>
		<table class='table table-bordered'>
			<tr>
				<th colspan='2'>Demand Sites</th>
			</tr>
			<tr>
				<td><a href="apiDetail?api=offersOverview">Offers
						Overview</a></td>
				<td>offer</td>
			</tr>
			<tr>
				<th colspan='2'>Supply Sites</th>
			</tr>
			<tr>
				<td><a href="apiDetail?api=agenciesRunningRevenue">Agencies
						Running Revenue</a></td>
				<td>agency</td>
			</tr>
			<tr>
				<td><a href="apiDetail?api=runningRevenueOverview">Running
						Revenue Overview</a></td>
				<td>overview</td>
			</tr>

		</table>
		<nav>
			<ul class='breadcrumb'>
				<li class='active'>Dimension Lookup</li>
			</ul>
		</nav>
		<table class='table table-bordered'>
			<tr>
				<td><a href="apiDetail?api=LookupNetworks">Networks</a></td>
				<td></td>
			</tr>
		</table> 
	</div>

</div>
<jsp:include page="/footer.jsp" />
<script src="../../scripts/bootstrap-3.0.0/js/bootstrap.min.js"></script>
</body>
</html>


