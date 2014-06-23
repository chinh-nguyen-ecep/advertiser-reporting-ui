<script>
	//Set locate
	urlMaster.replaceParam('page', 'billing_script');
	urlMaster.replaceParam('actionPath', 'billing_management');
	activeTab('Billing');
</script>
<div class="page-header">
	<div class="btn-group pull-right">
		<button type="button" class="btn btn-success" onclick="loadPage()">
			<span class="glyphicon glyphicon-chevron-left"></span> Back
		</button>
	</div>
	<h1>{combined_ids}</h1>
</div>

<table class="table table-bordered">
	<tbody>
		<tr>
			<th>Year month</th>
			<td>{calendar_year_month}</td>
		</tr>

		<tr>
			<th>IO Number</th>
			<td>{io_number}</td>
		</tr>
		<tr>
			<th>io_revision_date</th>
			<td>{io_revision_date}</td>
		</tr>
		<tr>
			<th>io_line_item_start_date</th>
			<td>{io_line_item_start_date}</td>
		</tr>
		<tr>
			<th>io_line_item_end_date</th>
			<td>{io_line_item_end_date}</td>
		</tr>
		<tr>
			<th>organization_name</th>
			<td>{organization_name}</td>
		</tr>
		<tr>
			<th>campaign_id</th>
			<td>{campaign_id}</td>
		</tr>
		<tr>
			<th>campaign_name</th>
			<td>{campaign_name}</td>
		</tr>
		<tr>
			<th>agency</th>
			<td>{agency}</td>
		</tr>
		<tr>
			<th>billing_contact</th>
			<td>{billing_contact}</td>
		</tr>
		<tr>
			<th>placement_group</th>
			<td>{placement_group}</td>
		</tr>
		<tr>
			<th>placement_id</th>
			<td>{placement_id}</td>
		</tr>
		<tr>
			<th>rate_type</th>
			<td>{rate_type}</td>
		</tr>
		<tr>
			<th>rate</th>
			<td>{rate}</td>
		</tr>
		<tr>
			<th>planned_units</th>
			<td>{planned_units}</td>
		</tr>
		<tr>
			<th>contracted_budget</th>
			<td>{contracted_budget}</td>
		</tr>
		<tr>
			<th>dfp_delivered_imps</th>
			<td>{dfp_delivered_imps}</td>
		</tr>
		<tr>
			<th>dfp_delivered_clicks</th>
			<td>{dfp_delivered_clicks}</td>
		</tr>
		<tr>
			<th>dfa_delivered_imps</th>
			<td>{dfa_delivered_imps}</td>
		</tr>
		<tr>
			<th>dfa_delivered_clicks</th>
			<td>{dfa_delivered_clicks}</td>
		</tr>
		<tr>
			<th>adjusted_units</th>
			<td>{adjusted_units}</td>
		</tr>
		<tr>
			<th>delivered_units</th>
			<td>{delivered_units}</td>
		</tr>
		<tr>
			<th>remaining_units</th>
			<td>{remaining_units}</td>
		</tr>
		<tr>
			<th>billable_units</th>
			<td>{billable_units}</td>
		</tr>
		<tr>
			<th>invoice_amount</th>
			<td>{invoice_amount}</td>
		</tr>
		<tr>
			<th>total_amount_invoiced_upto_month</th>
			<td>{total_amount_invoiced_upto_month}</td>
		</tr>
		<tr>
			<th>remaining_budget</th>
			<td>{remaining_budget}</td>
		</tr>
	</tbody>
</table>
<script>
	var information_control='{information_control}';
	var adjusted_units_control='{adjusted_units_control}';
</script>