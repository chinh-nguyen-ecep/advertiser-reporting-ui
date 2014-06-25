<style>

</style>
<script>
	//Set locate
	urlMaster.clear();
	urlMaster.replaceParam('page', 'template');
	urlMaster.replaceParam('actionPath', 'adjusted_units_management');
	activeTab('Additional Adjustment');
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
			<th class="buttons" colspan="10"><a class="btn btn-success"	href="#" onclick="showAddInfomationForm();">
				<i	class="icon-plus icon-white"></i> Add Adjusted Unit </a>
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
			<th class="col-md-1">IO Order ID</th>
			<th class="col-md-1">io_line_item_id</th>
			<th class="col-md-1">combine_ids</th>
			<th class="col-md-2">io_line_item_name</th>
			<th class="col-md-2">adjusted_units</th>
			<th class="col-md-1">created_by</th>
			<th class="col-md-1">created_at</th>
			<th class="col-md-1">updated_by</th>
			<th class="col-md-1">updated_at</th>
			<th class="col-md-1">comment</th>
		</tr>
	</thead>
	<tbody>
	</tbody>
</table>

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
				
					loadTableAdjustedUnit();
			}
		});
		$('#selectbox_month_sk').change(function(){
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
		loadAdjustedUnits({
			p_month_sk: $('#selectbox_month_sk').val(),
			p_io_line_item_name: $.trim($('#search_input').val()),
			success: function(json){
				dataTableAjustedUnits=json;
				createTableContent(dataTableAjustedUnits);
			}
		});
		function createTableContent(data){
			var rows=[];
			for(var i=0;i<data.length;i++){
				var io_orders_id=data[i].io_orders_id;
				var io_line_item_id=data[i].io_line_item_id;
				var combine_ids=data[i].combine_ids;
				var io_line_item_name=data[i].io_line_item_name;
				var adjusted_units=data[i].adjusted_units;
				var created_by=data[i].created_by;
				var created_at=data[i].created_at;
				var updated_by=data[i].updated_by;
				var updated_at=data[i].updated_at;
				var comment=data[i].comment;
				
				var row='<tr>'
						+	'<td>'+io_orders_id+'</td>'
						+	'<td>'+io_line_item_id+'</td>'
						+	'<td>'+combine_ids+'</td>'
						+	'<td>'+io_line_item_name+'</td>'
						+	'<td>'+adjusted_units+'</td>'
						+	'<td>'+created_by+'</td>'
						+	'<td>'+created_at+'</td>'
						+	'<td>'+updated_by+'</td>'
						+	'<td>'+updated_at+'</td>'
						+	'<td>'+comment+'</td>'
						+	'</tr>';
				rows.push(row);
			}
			$('#mainDataTable tbody').html(rows.join(""));
		}
	}
</script>