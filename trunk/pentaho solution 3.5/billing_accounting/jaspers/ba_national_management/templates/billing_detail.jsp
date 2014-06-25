<script>
	//Set locate
	urlMaster.replaceParam('page', 'billing_script');
	urlMaster.replaceParam('actionPath', 'billing_management');
	activeTab('Billing');
</script>
<div class="page-header">
	<div class="btn-group pull-right" id="command">
		<button type="button" class="btn btn-default" onclick="loadPage()">
			<span class="glyphicon glyphicon-chevron-left"></span> Back
		</button>
	</div>
	<h1>{combined_ids}</h1>
</div>

<table class="table table-bordered table-striped table-hover" id="lineItemDetail">
	<tbody>
		<tr>
			<th>Year Month</th><td>{calendar_year_month}</td>
		</tr>
		<tr>
			<th>IO Number #</th><td>{io_number}</td>
		</tr>
		<tr>
			<th>IO Revision Date</th><td>{io_revision_date}</td>
		</tr>
		<tr>
			<th>Start_date</th><td>{io_line_item_start_date}</td>
		</tr>
		<tr>
			<th>End_date</th><td>{io_line_item_end_date}</td>
		</tr>
		<tr>
			<th>Advertiser</th><td>{organization_name}</td>
		</tr>
		<tr>
			<th>Campaign_ID</th><td>{campaign_id}</td>
		</tr>
		<tr>
			<th>Campaign_Name</th><td>{campaign_name}</td>
		</tr>
		<tr>
			<th>Agency</th><td>{agency}</td>
		</tr>
		<tr>
			<th>Billing Contact</th><td>{billing_contact}</td>
		</tr>
		<tr>
			<th>Placement Group</th><td>{placement_group}</td>
		</tr>
		<tr>
			<th>Placement ID</th><td>{placement_id}</td>
		</tr>
		<tr>
			<th>Rate Type</th><td>{rate_type}</td>
		</tr>
		<tr>
			<th>Rate</th><td name="rate">{rate}</td>
		</tr>
		<tr>
			<th>Planned Units</th><td name="planned_units">{planned_units}</td>
		</tr>
		<tr>
			<th>Contracted Budget</th><td name="contracted_budget">{contracted_budget}</td>
		</tr>
		<tr>
			<th>DFP Delivered Imps</th><td name="dfp_delivered_imps">{dfp_delivered_imps}</td>
		</tr>
		<tr>
			<th>DFP Delivered Clicks</th><td name="dfp_delivered_clicks">{dfp_delivered_clicks}</td>
		</tr>
		<tr>
			<th>DFA Delivered Imps</th><td name="dfa_delivered_imps">{dfa_delivered_imps}</td>
		</tr>
		<tr>
			<th>DFA Delivered Clicks</th><td name="dfa_delivered_clicks">{dfa_delivered_clicks}</td>
		</tr>
		<tr>
			<th>Adjusted Units</th><td name="adjusted_units">{adjusted_units}</td>
		</tr>
		<tr>
			<th>Delivered Units</th><td name="delivered_units">{delivered_units}</td>
		</tr>
		<tr>
			<th>Remaining Units</th><td name="remaining_units">{remaining_units}</td>
		</tr>
		<tr>
			<th>Billable Units</th><td name="billable_units">{billable_units}</td>
		</tr>
		<tr>
			<th>Amount Invoiced</th><td name="invoice_amount">{invoice_amount}</td>
		</tr>
		<tr>
			<th>Amount Invoiced ToDate</th><td name="total_amount_invoiced_upto_month">{total_amount_invoiced_upto_month}</td>
		</tr>
		<tr>
			<th>Remaining Budget</th><td name="remaining_budget">{remaining_budget}</td>
		</tr>
	</tbody>
</table>
<script>
	var information_control='{information_control}';
	var adjusted_units_control='{adjusted_units_control}';
	
	$('#lineItemDetail td[name=rate]').html(accounting.formatMoney({rate}));
	$('#lineItemDetail td[name=planned_units]').html(accounting.formatNumber({planned_units}));
	$('#lineItemDetail td[name=contracted_budget]').html(accounting.formatMoney({contracted_budget}));
	$('#lineItemDetail td[name=delivered_units]').html(accounting.formatNumber({delivered_units}));
	$('#lineItemDetail td[name=dfp_delivered_imps]').html(accounting.formatNumber({dfp_delivered_imps}));
	$('#lineItemDetail td[name=dfp_delivered_clicks]').html(accounting.formatNumber({dfp_delivered_clicks}));
	$('#lineItemDetail td[name=dfa_delivered_imps]').html(accounting.formatNumber({dfa_delivered_imps}));
	$('#lineItemDetail td[name=dfa_delivered_clicks]').html(accounting.formatNumber({dfa_delivered_clicks}));
	if ({adjusted_units} != 'null') {
		$('#lineItemDetail td[name=adjusted_units]').html(accounting.formatNumber({adjusted_units}));
	}
	$('#lineItemDetail td[name=delivered_units]').html(accounting.formatNumber({delivered_units}));
	$('#lineItemDetail td[name=remaining_units]').html(accounting.formatNumber({remaining_units}));
	$('#lineItemDetail td[name=billable_units]').html(accounting.formatNumber({billable_units}));
	$('#lineItemDetail td[name=invoice_amount]').html(accounting.formatMoney({invoice_amount}));
	$('#lineItemDetail td[name=total_amount_invoiced_upto_month]').html(accounting.formatMoney({total_amount_invoiced_upto_month}));
	$('#lineItemDetail td[name=remaining_budget]').html(accounting.formatMoney({remaining_budget}));
</script>