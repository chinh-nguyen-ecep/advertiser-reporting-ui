<style>

</style>
<script>
	//Set locate
	urlMaster.replaceParam('page', 'template');
	urlMaster.replaceParam('actionPath', 'adjusted_units_management');
	activeTab('Adjustment');
</script>
<div class="page-header">

	<div class="btn-group pull-right">

	</div>
	<h1 id="page_header">Adjusted Units</h1>
</div>
<!-- Table -->
<table id="mainDataTable"
	class="table table-bordered table-striped table-hover">
	<thead>
		<tr>
			<th class="buttons" colspan="6"><a class="btn btn-success"	href="#" id="addAdjustedUnitsButton">
				<i	class="icon-plus icon-white"></i> Add Adjusted Units</a>
				<div class="pull-right">
							<form role="form" class="form-inline">
								<div class="form-group">
									<select	class="form-control input-sm" id="selectbox_month_sk">									
									</select>
								</div>
								<div class="form-group">
									<input class="form-control input-sm" id="search_input" name="search" placeholder="Search..." type="text">
								</div>
							</form>
				</div>
			</th>
		</tr>
		<tr>
			<th class="col-md-1">Month</th>
			<th class="col-md-1">Combined IDs</th>
			<th class="col-md-4">Line Item Name</th>
			<th class="col-md-1" style="text-align: right;">Adjusted Units</th>
			<th class="col-md-3">Comment</th>
			<th class="col-md-2"></th>
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
	var dataTableAjustedUnits=[];
	$( document ).ready(function(){
		loadSelectBoxMonthOfAdjustedUnits();
	}) ;
	/////////////////////////////////////
	//	Load list of month
	//////////////////////////////////////
	function loadSelectBoxMonthOfAdjustedUnits(){
		loadListMonthAdjustedUnits({
			success: function(arrayJson){
				var rows=[];
				var row='<option value="0">All Months</option>';
				rows.push(row);
				for(var i=0;i<arrayJson.length;i++){
					var month_sk=arrayJson[i].month_since_2005;
					var month=arrayJson[i].calendar_year_month;
					if(i==0){
						row='<option value="'+month_sk+'" selected>'
							+	month
							+	'</option>';
					}else{
						row='<option value="'+month_sk+'">'
							+	month
							+	'</option>';
					}
					rows.push(row);
				}
				$('#selectbox_month_sk').html(rows.join(""));
				var month_sk=urlMaster.getParam('msk');		
				if(month_sk==''){
					urlMaster.replaceParam('msk',$('#selectbox_month_sk').val());
				}else{
					$('#selectbox_month_sk').prop("value",month_sk);
				}
				loadTableAdjustedUnit();
			}
		});
		$('#selectbox_month_sk').change(function(){
			urlMaster.replaceParam('msk', $('#selectbox_month_sk').val());
			delay_timeout(1000,function(){
				loadTableAdjustedUnit();
			});
		});
	}
	/////////////////////////////////////
	// Change seatch input 
	////////////////////////////////////
		$('#search_input').keyup(function(){
			delay_timeout(2000,function(){
				loadTableAdjustedUnit();
			});
		});
	/////////////////////////////////////
	// Load table adjusted unit 
	/////////////////////////////////////
	function loadTableAdjustedUnit(){
		var month_sk=urlMaster.getParam('msk');		
		loadAdjustedUnits({
			p_month_sk: month_sk,
			p_io_line_item_name: $.trim($('#search_input').val()),
			success: function(json){
				dataTableAjustedUnits=json;
				createTableContent(dataTableAjustedUnits);
			}
		});
		function createTableContent(data){
			var rows=[];
			for(var i=0;i<data.length;i++){
				var io_orders_id        = data[i].io_orders_id;
				var io_line_item_id     = data[i].io_line_item_id;
				var combine_ids         = data[i].combine_ids;
				var io_line_item_name   = data[i].io_line_item_name;
				var adjusted_units      = data[i].adjusted_units;
				var comment             = data[i].comment;
				var month_sk            = data[i].month_since_2005;
				var calendar_year_month = data[i].calendar_year_month;
				
				var row = '<tr>' 
					+ '<td>' + calendar_year_month + '</td>'
					+ '<td><a href="#" onclick="showDetail(' + month_sk + ',' + io_orders_id + ',' + io_line_item_id + ',' + i + ')">#' + combine_ids + '</a></td>' 
					+ '<td>' + io_line_item_name + '</td>'
					+ '<td align="right">' + accounting.formatNumber(adjusted_units) + '</td>' 
					+ '<td>' + comment + '</td>' 
					+ '<td><div class="btn-toolbar" role="toolbar"><button type="button" class="btn btn-primary btn-xs" title="Edit" onclick="loadEditForm('+i+');"><span class="glyphicon glyphicon-edit"></span></button><button type="button" class="btn btn-success btn-xs" title="Copy" onclick="loadAddForm('+i+');"><span class="glyphicon glyphicon-share"></span></button><button type="button" data-toggle="modal" data-target="#deleteAdjustmentDialog" class="btn btn-danger btn-xs" title="Delete" onclick="loadDeleteForm('+i+');"><span class="glyphicon glyphicon-remove"></span></button></div></td>' 
					+ '</tr>';
				rows.push(row);
			}
			$('#mainDataTable tbody').html(rows.join(""));
		}
	}
	////////////////////////////////////
	// Load Add Form on Click
	////////////////////////////////////
	$('#addAdjustedUnitsButton').click(function(){
		adjustedUnitsLoadAddForm({
			success: function(html){
				$('#summary-content div.content').html(html);
			}
		});		
	});
	////////////////////////////////////////
	// Load Add Form
	////////////////////////////////////////
	function loadAddForm(row){
		var adjusted_units = dataTableAjustedUnits[row].adjusted_units;				
		//load add form
		$('#summary-content div.content').load(rootPath_AdjustedUnits,{
			actions: 'adjustedUnitsAddForm',
			p_adjusted_units: adjusted_units
		},function(){
		
		});
	}
	////////////////////////////////////////
	// Load Add Form
	////////////////////////////////////////
	function loadEditForm(row){
		var io_orders_id        = dataTableAjustedUnits[row].io_orders_id;
		var io_line_item_id     = dataTableAjustedUnits[row].io_line_item_id;
		var combine_ids         = dataTableAjustedUnits[row].combine_ids; 
		var io_line_item_name   = dataTableAjustedUnits[row].io_line_item_name;
		var adjusted_units      = dataTableAjustedUnits[row].adjusted_units;
		var comment             = dataTableAjustedUnits[row].comment;
		var month_since_2005    = dataTableAjustedUnits[row].month_since_2005;
		var calendar_year_month = dataTableAjustedUnits[row].calendar_year_month;
		var displayed_name      = combine_ids + ' | ' + io_line_item_name;
		
		//load edit form
		$('#summary-content div.content').load(rootPath_AdjustedUnits,{
			actions: 'adjustedUnitsEditForm',
			p_month_sk: month_since_2005,
			p_calendar_year_month: calendar_year_month,
			p_io_orders_id: io_orders_id,
			p_io_line_item_id: io_line_item_id,
			p_displayed_name: displayed_name,
			p_adjusted_units: adjusted_units,
			p_comment: comment
		},function(){
		
		});
	}
	///////////////////////////
	// View detail
	///////////////////////////
	function showDetail(month_sk,io_orders_id,io_line_item_id,row){
		urlMaster.replaceParam('p_month_sk',month_sk);
		urlMaster.replaceParam('p_io_orders_id',io_orders_id);
		urlMaster.replaceParam('p_io_line_item_id',io_line_item_id);
		urlMaster.replaceParam('ac','detail');
		loadAdjustmentDetailPage({
			p_month_sk: month_sk,
			p_io_orders_id: io_orders_id,
			p_io_line_item_id: io_line_item_id,
			p_row: row,
			success: function(html){
				$('#summary-content div.content').empty();
				$('#summary-content div.content').append(html);
			}
		});
	}
	
	///////////////////////////////////
	// load delete adjusted units form
	//////////////////////////////////
	
	function loadDeleteForm(row){
		var io_orders_id        = dataTableAjustedUnits[row].io_orders_id;
		var io_line_item_id     = dataTableAjustedUnits[row].io_line_item_id;
		var combine_ids         = dataTableAjustedUnits[row].combine_ids; 
		var io_line_item_name   = dataTableAjustedUnits[row].io_line_item_name;
		var adjusted_units      = dataTableAjustedUnits[row].adjusted_units;
		var comment             = dataTableAjustedUnits[row].comment;
		var month_since_2005    = dataTableAjustedUnits[row].month_since_2005;
		var calendar_year_month = dataTableAjustedUnits[row].calendar_year_month;
		var displayed_name      = combine_ids + ' | ' + io_line_item_name;
		
		$('#deleteAdjustmentTable td[name=td_calendar_year_month]').html(calendar_year_month);
		$('#deleteAdjustmentTable td[name=td_combine_ids]').html(displayed_name);
		$('#deleteAdjustmentTable td[name=td_adjusted_units]').html(accounting.formatNumber(adjusted_units));
		$('#deleteAdjustmentTable td[name=td_comment]').html(comment);
		$('#deleteAdjustmentForm input[name=p_month_sk]').val(month_since_2005);
		$('#deleteAdjustmentForm input[name=p_io_orders_id]').val(io_orders_id);
		$('#deleteAdjustmentForm input[name=p_io_line_item_id]').val(io_line_item_id);
	}
	
	/////////////////////////////////////
	// Update Adjusted Units
	/////////////////////////////////////
	
	function deleteAdjustedUnitsAction(){
		var comment = $('#deleteAdjustmentForm input[name=comment]').val();
		
		if (comment == '') {
			alert("Please fill required fields");
			return false;
		}
		
		$('#deleteAdjustmentDialog').modal('hide');
		deleteAdjustedUnits({
			p_io_orders_id: $('#deleteAdjustmentForm input[name=p_io_orders_id]').val(),
			p_io_line_item_id: $('#deleteAdjustmentForm input[name=p_io_line_item_id]').val(),
			p_month_sk: $('#deleteAdjustmentForm input[name=p_month_sk]').val(),
			p_comment: $('#deleteAdjustmentForm input[name=comment]').val(),
			success: function(data){
				var msg=data[0].fn_ba_national_dim_adjustment_delete;
				if(msg=='SUCCESSED'){
					alert("Deleted successfully");
					loadPage();
				}
			}		
		});
	}

</script>