<div class="page-header">
	<div class="btn-group pull-right">
		<form class="for-control" role="export">
			<div class="form-group">
				<!-- <select class="form-control input-sm" id="selectbox_month_sk"><option
				value="0">All Months</option>
			<option value="113" selected="">2014-May</option>
			<option value="112">2014-Apr</option></select> -->
			</div>
		</form>
	</div>

	<h1 id="page_header">Running Revenue<small id="dataDate"></small></h1>
</div>

<table id="summaryTable"
	class="table table-bordered table-striped table-hover">
	<thead>
		<tr>
			<th class="buttons" colspan="7">Summary</th>
		</tr>
		<tr>
			<th class="col-md-3">VLMO Agency</th>
			<th class="col-md-1">ADM Account ID</th>
			<th class="col-md-1">Delivered Imps</th>
			<th class="col-md-1">Billable Rate</th>
			<th class="col-md-2">Gross Revenue</th>
			<th class="col-md-2">Pub Net Revenue</th>
			<th class="col-md-2">Profit Margin</th>
		</tr>
	</thead>
	<tbody>

	</tbody>
</table>
<ul class="nav nav-tabs" style="margin-bottom: 10px;" id="subTab">
  <li title="Campaign" class="active"><a href="#" onclick="urlMaster.replaceParam('detail','campaign');urlMaster.replaceParam('page',1);loadRunningDetail();">Merchant -> Campaign</a></li>
  <li title="Offer" ><a href="#" onclick="urlMaster.replaceParam('detail','offer');urlMaster.replaceParam('page',1);loadRunningDetail();">Merchant -> Offer</a></li>
  <li title="Tiers and rate" ><a href="#" onclick="urlMaster.replaceParam('detail','tierRate');urlMaster.replaceParam('page',1);loadAgencyTierRate();">Tiers & Rate Details</a></li>
</ul>

<div id="detailDiv">
<table id="detailTable"
	class="table table-bordered table-striped table-hover">
	<thead>
		<tr>
			<th class="buttons" colspan="8"><span class="detailTitlte">Detail</span>
				<div class="pull-right">
					<form role="form" class="form-inline">
						<div class="form-group">
							<select class="form-control input-sm" id="selectbox_agency"></select>
						</div>	
						<div class="form-group">
							<input class="form-control input-sm" id="search_input" name="search" placeholder="Search by Merchant" type="text">
						</div>					
					</form>
				</div>
			</th>
		</tr>
		<tr>
			<th class="col-md-2">Merchant</th>
			<th class="col-md-4" name="detailType">Campaign</th>
			<th class="col-md-1">Booked Imps</th>
			<th class="col-md-1">Delivered Imps</th>
			<th class="col-md-1">Billable Imps</th>
			<th class="col-md-1">Clicks</th>
			<th class="col-md-1">Billable Rate</th>
			<th class="col-md-1">Gross Revenue</th>
		</tr>
	</thead>
	<tbody>

	</tbody>
</table>
<ul class="pagination pagination-sm" id="detailPaging">
        
</ul>
</div>
<div id="tiers_and_rate">
<table id="detailTableTierAndRate"
	class="table table-bordered table-striped table-hover">
	<thead>
		<tr>
			<th class="buttons" colspan="3"><span class="detailTitlte">Detail</span>
			</th>
		</tr>
		<tr>
			<th class="col-md-8">VLMO Agency</th>
			<th class="col-md-2">Impressions</th>
			<th class="col-md-2">Billable Rate</th>
		</tr>
	</thead>
	<tbody>

	</tbody>
</table>
</div>


<script src="scripts/control/runningRevenue.js"></script>