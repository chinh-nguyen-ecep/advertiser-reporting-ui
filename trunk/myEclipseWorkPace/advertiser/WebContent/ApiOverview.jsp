
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
				<td><a href="apiDetail?api=AdvertiserByDate">Advertiser by Date</a></td>
				<td>...</td>
			</tr>
			<tr>
				<td><a href="apiDetail?api=AdvertiserByHour">Advertiser by Hour</a></td>
				<td>...</td>
			</tr>
			<tr>
				<td><a href="apiDetail?api=AdvertiserByDistance">Advertiser by Distance</a></td>
				<td>...</td>
			</tr>
			<tr>
				<td><a href="apiDetail?api=AdvertiserByDma">Advertiser by DMA</a></td>
				<td>...</td>
			</tr>
		</table>
		<nav>
			<ul class='breadcrumb'>
				<li class='active'>Dimension Lookup</li>
			</ul>
		</nav>
		<table class='table table-bordered'>
			<tr>
				<td><a href="apiDetail?api=LookupOrders">Orders</a></td>
				<td></td>
			</tr>
			<tr>
				<td><a href="apiDetail?api=LookupFlights">Flights</a></td>
				<td></td>
			</tr>
			<tr>
				<td><a href="apiDetail?api=LookupCreatives">Creatives</a></td>
				<td></td>
			</tr>
		</table> 
	</div>

</div>
<jsp:include page="/footer.jsp" />
<script src="../../scripts/bootstrap-3.0.0/js/bootstrap.min.js"></script>
</body>
</html>


