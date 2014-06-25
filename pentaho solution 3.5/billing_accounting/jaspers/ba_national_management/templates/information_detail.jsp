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
		<button type="button" class="btn btn-info" onclick="loadEditForm({p_row})">
		  <span class="glyphicon glyphicon-edit"></span> Edit
		</button>
		<button type="button" class="btn btn-success" onclick="loadAddForm({p_row})">
		  <span class="glyphicon glyphicon-share"></span> Copy
		</button>
	</div>
	<div class="btn-group pull-right" style="margin-right: 5px;margin-left: 50px;">
		<button type="button" class="btn btn-primary" onclick="loadPage()">
			<span class="glyphicon glyphicon-chevron-left"></span> Back
		</button>
	</div>
	<h1>{displayName}</h1>
</div>

<table class="table table-bordered table-striped table-hover">
	<thead>
		<tr>
			<th class="buttons" colspan="2">
			</th>
		</tr>
	</thead>
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
			<th>Created By</th>
			<td>{created_by}</td>
		</tr>
		<tr>
			<th>Create At</th>
			<td>{created_at}</td>
		</tr>
		<tr>
			<th>Update by</th>
			<td>{updated_by}</td>
		</tr>
		<tr>
			<th>Update At</th>
			<td>{updated_at}</td>
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
				Contact Name
			</th>
			<th>
				Campaign ID
			</th>
			<th>
				Billing Contact
			</th>
			<th>
				Created By
			</th>
			<th>
				Create At
			</th>
			<th>
				Update By
			</th>
			<th>
				Update At
			</th>
			<th>
				Comment
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
		var rows=[];
		for(var i=0;i<dataHistoryTable.length;i++){
			var io_orders_id=dataHistoryTable[i].io_orders_id;
			var campaign_id=dataHistoryTable[i].campaign_id;
			var billing_contact=dataHistoryTable[i].billing_contact;
			var created_by=dataHistoryTable[i].created_by;
			var created_at=dataHistoryTable[i].created_at;
			var updated_by=dataHistoryTable[i].updated_by;
			var updated_at=dataHistoryTable[i].updated_at;
			var comment=dataHistoryTable[i].comment;
			var row="<tr>"
					+ "<td>"+io_orders_id+"</td>"
					+ "<td>"+campaign_id+"</td>"
					+ "<td>"+billing_contact+"</td>"
					+ "<td>"+created_by+"</td>"
					+ "<td>"+created_at+"</td>"
					+ "<td>"+updated_by+"</td>"
					+ "<td>"+updated_at+"</td>"
					+ "<td>"+comment+"</td>"
					+"</tr>";
			rows.push(row);			
		}
		var htlm=rows.join("");
		$('#historyTable tbody').append(htlm);
	}
	drawHistoryTable();
</script>