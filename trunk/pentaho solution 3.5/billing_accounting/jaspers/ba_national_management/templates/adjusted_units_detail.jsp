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
		<button type="button" data-toggle="modal" data-target="#deleteAdjustmentDialog" class="btn btn-danger" onclick="loadDeleteForm({p_row});">
			<span class="glyphicon glyphicon-remove"></span> Delete
		</button>
	</div>
	<div class="btn-group pull-right" style="margin-right: 5px;margin-left: 50px;">
		<button type="button" class="btn btn-default" onclick="loadPage()">
			<span class="glyphicon glyphicon-chevron-left"></span> Back
		</button>
	</div>
	<h1>#{combine_ids} | {io_line_item_name}</h1>
</div>

<table class="table table-bordered table-striped table-hover" id="lineItemDetail">
	<tbody>
		<tr>
			<th>Month</th>
			<td>{calendar_year_month}</td>
		</tr>
		<tr>
			<th>Adjusted Units</th>
			<td name="adjusted_units">{adjusted_units}</td>
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

<!-- Form Delete Adjusted Units -->
<div class="modal fade bs-example-modal-lg" id="deleteAdjustmentDialog" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Delete Adjusted Units</h4>
      </div>
      <div class="modal-body">
		<table id="deleteAdjustmentTable" class="table table-bordered table-hover">
			<tbody>
				<tr>
					<th>Month</th><td name="td_calendar_year_month"></td>
				</tr>
				<tr>
					<th>Combined IDs</th><td name="td_combine_ids"></td>
				</tr>
				<tr>
					<th>Adjusted Units</th><td name="td_adjusted_units"></td>
				</tr>
				<tr>
					<th>Comment</th><td name="td_comment"></td>
				</tr>
			</tbody>
		</table>
		<form class="form-horizontal" role="form" id="deleteAdjustmentForm">
			<div class="form-group">
				<label for="comment" class="required control-label">Comment <abbr title="Required">*</abbr></label>
				<input class="form-control" type="hidden" name="p_io_orders_id" style="width: 100%" value="" />
				<input class="form-control" type="hidden" name="p_io_line_item_id" style="width: 100%" value="" />
				<input class="form-control" type="hidden" name="p_month_sk" style="width: 100%" value="" />
				<input type="text" class="form-control" maxlength="255" placeholder="Enter comment" name="comment" value="">
			</div> 
		</form>
      </div>
		<div class="modal-footer">
	    	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	    	<button type="button" class="btn btn-danger" onclick="deleteAdjustedUnitsAction()">Delete</button>
	    </div>
    </div>

  </div>
</div>
<!-- End -->
<script>
	$('#lineItemDetail td[name=adjusted_units]').html(accounting.formatNumber({adjusted_units}));

	var dataHistoryTable={historyJson};
	////////////////////////
	//process history table
	////////////////////////
	function drawHistoryTable(){
		var rows = [];
		var row = '';
		var i = 0;
		var campaign_id;
		var created_by;
		var created_at;
		var updated_by;
		var updated_at;
		var comment;
		var is_active;
		var dateFormatted;
		var dateDeleted;
		
		for(var i=0;i<dataHistoryTable.length - 1;i++){
			adjusted_units = dataHistoryTable[i].adjusted_units;
			created_by     = dataHistoryTable[i].created_by;
			created_at     = dataHistoryTable[i].created_at;
			updated_by     = dataHistoryTable[i].updated_by;
			updated_at     = dataHistoryTable[i].updated_at;
			comment        = dataHistoryTable[i].comment;
			is_active      = dataHistoryTable[i].is_active;
			
			dateFormatted = new Date(created_at).format('mmm dd, yyyy HH:MM:ss');
			dateDeleted = new Date(updated_at).format('mmm dd, yyyy HH:MM:ss');
			
			row = '';
			row += '<tr>';
			console.log("Update Ajusted Units: " + is_active);
			if (dateFormatted == dateDeleted && is_active == 'false'){
				row += '<td>' + dateFormatted + '<br/><span class="muted">Delete</span></td>';
			}else{
				row += '<td>' + dateFormatted + '<br/><span class="muted">Update</span></td>';
			}
			row += '<td>' + created_by + '</td>';
			row += '<td><ul>';
			if (adjusted_units != dataHistoryTable[i+1].adjusted_units){
				row += '<li><b>Adjusted Units:</b> ' + (dataHistoryTable[i+1].adjusted_units == 'null' ? 'none' : dataHistoryTable[i+1].adjusted_units) + ' &raquo; ' + (adjusted_units == 'null' ? 'none' : adjusted_units) + '</li>';
			}
			if (comment != dataHistoryTable[i+1].comment){
				row += '<li><b>Comment:</b> ' + (dataHistoryTable[i+1].comment == '' ? 'none' : dataHistoryTable[i+1].comment) + ' &raquo; ' + (comment == '' ? 'none' : comment) + '</li>';
			}
			row += '</td></ul>';
			row += '</tr>';
			
			rows.push(row);	
		}
		
		// created
		adjusted_units = dataHistoryTable[i].adjusted_units;
		created_by     = dataHistoryTable[i].created_by;
		created_at     = dataHistoryTable[i].created_at;
		updated_by     = dataHistoryTable[i].updated_by;
		updated_at     = dataHistoryTable[i].updated_at;
		comment        = dataHistoryTable[i].comment;
		is_active      = dataHistoryTable[i].is_active;
		
		dateFormatted = new Date(created_at).format('mmm dd, yyyy HH:MM:ss');
		
		row = '';
		row += '<tr>';
		row += '<td>' + dateFormatted + '<br/><span class="muted">Create</span></td>';
		row += '<td>' + created_by + '</td>';
		row += '<td><ul>';
		if (adjusted_units != ''){
			row += '<li><b>Adjusted Units:</b> none &raquo; ' + adjusted_units + '</li>';
		}else{
			row += '<li><b>Adjusted Units:</b> none</li>';
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