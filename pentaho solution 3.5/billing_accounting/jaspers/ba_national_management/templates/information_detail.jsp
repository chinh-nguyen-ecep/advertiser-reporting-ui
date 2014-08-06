<style>

</style>
<script>
//Set locate
	//urlMaster.clear();
	//urlMaster.replaceParam('page','information_script');
	//urlMaster.replaceParam('actionPath','information_management');
	//activeTab('Information');
</script>

<div class="page-header">
	<div class="btn-group pull-right">
		<button type="button" class="btn btn-primary" onclick="loadEditForm({p_row})">
		  <span class="glyphicon glyphicon-edit"></span> Edit
		</button>
		<button type="button" class="btn btn-success" onclick="loadAddForm({p_row})">
		  <span class="glyphicon glyphicon-share"></span> Copy
		</button>
	</div>
	<div class="btn-group pull-right" style="margin-right: 5px;margin-left: 50px;">
		<button type="button" class="btn btn-default" onclick="loadPage()">
			<span class="glyphicon glyphicon-chevron-left"></span> Back
		</button>
	</div>
	<h1>#{displayName}</h1>
</div>

<table class="table table-bordered table-striped table-hover">
	<tbody>
		<tr>
			<th>IO Orders ID</th>
			<td>{io_orders_id}</td>
		</tr>
		<tr>
			<th>Contact Name</th>
			<td>{contact_name}</td>
		</tr>
		<tr>
			<th>Campaign ID</th>
			<td>{campaign_id}</td>
		</tr>
		<tr>
			<th>Billing Contact</th>
			<td>{billing_contact}</td>
		</tr>
		<tr>
			<th>Comment</th>
			<td>{comment}</td>
		</tr>				
	</tbody>
</table>

<table id="historyTable" class="table table-bordered table-striped table-hover">
	<thead>
		<tr>
			<th class="buttons" colspan="8">
			History
			</th>
		</tr>
		<tr>
			<th>
				Created at
			</th>
			<th>
				Created by
			</th>
			<th>
				Changed
			</th>
		</tr>
	</thead>
	<tbody>
		
	</tbody>
</table>
<script>
	var dataHistoryTable={historyJson};
	////////////////////////
	//process history table
	////////////////////////
	function drawHistoryTable(){
		var rows = [];
		var row = '';
		var i = 0;
		var io_orders_id;
		var campaign_id;
		var billing_contact;
		var created_by;
		var created_at;
		var updated_by;
		var updated_at;
		var comment;
		var dateFormatted;
		
		for(var i=0;i<dataHistoryTable.length - 1;i++){
			io_orders_id    = dataHistoryTable[i].io_orders_id;
			campaign_id     = dataHistoryTable[i].campaign_id;
			billing_contact = dataHistoryTable[i].billing_contact;
			created_by      = dataHistoryTable[i].created_by;
			created_at      = dataHistoryTable[i].created_at;
			updated_by      = dataHistoryTable[i].updated_by;
			updated_at      = dataHistoryTable[i].updated_at;
			comment         = dataHistoryTable[i].comment;
			
			dateFormatted = verveDateTimeConvert(created_at).format('mmm dd, yyyy HH:MM:ss');
			
			row = '';
			row += '<tr>';
			row += '<td>' + dateFormatted + '<br/><span class="muted">Update</span></td>';
			row += '<td>' + created_by + '</td>';
			row += '<td><ul>';
			if (campaign_id != dataHistoryTable[i+1].campaign_id){
				row += '<li><b>Campaign ID:</b> ' + (dataHistoryTable[i+1].campaign_id == '' ? 'none' : dataHistoryTable[i+1].campaign_id) + ' &raquo; ' + (campaign_id == '' ? 'none' : campaign_id) + '</li>';
			}
			if (billing_contact != dataHistoryTable[i+1].billing_contact){
				row += '<li><b>Billing Contact:</b> ' + (dataHistoryTable[i+1].billing_contact == '' ? 'none' : dataHistoryTable[i+1].billing_contact) + ' &raquo; ' + (billing_contact == '' ? 'none' : billing_contact) + '</li>';
			}
			if (comment != dataHistoryTable[i+1].comment){
				row += '<li><b>Comment:</b> ' + (dataHistoryTable[i+1].comment == '' ? 'none' : dataHistoryTable[i+1].comment) + ' &raquo; ' + (comment == '' ? 'none' : comment) + '</li>';
			}
			row += '</td></ul>';
			row += '</tr>';
			
			rows.push(row);	
		}
		
		// created
		io_orders_id    = dataHistoryTable[i].io_orders_id;
		campaign_id     = dataHistoryTable[i].campaign_id;
		billing_contact = dataHistoryTable[i].billing_contact;
		created_by      = dataHistoryTable[i].created_by;
		created_at      = dataHistoryTable[i].created_at;
		updated_by      = dataHistoryTable[i].updated_by;
		updated_at      = dataHistoryTable[i].updated_at;
		comment         = dataHistoryTable[i].comment;
		
		dateFormatted = verveDateTimeConvert(created_at).format('mmm dd, yyyy HH:MM:ss');
		
		row = '';
		row += '<tr>';
		row += '<td>' + dateFormatted + '<br/><span class="muted">Create</span></td>';
		row += '<td>' + created_by + '</td>';
		row += '<td><ul>';
		if (campaign_id != ''){
			row += '<li><b>Campaign ID:</b> none &raquo; ' + campaign_id + '</li>';
		}else{
			row += '<li><b>Campaign ID:</b> none</li>';
		}
		if (billing_contact != ''){
			row += '<li><b>Billing Contact:</b> none &raquo; ' + billing_contact + '</li>';
		}else{
			row += '<li><b>Billing Contact:</b> none</li>';
		}
		if (comment != ''){
			row += '<li><b>Comment:</b> none &raquo; ' + comment + '</li>';
		}else{
			row += '<li><b>Comment:</b> none</li>';
		}
		row += '</td></ul>';
		row += '</tr>';
		
		rows.push(row);
		
		var htlm=rows.join("");
		$('#historyTable tbody').append(htlm);
	}
	drawHistoryTable();
</script>