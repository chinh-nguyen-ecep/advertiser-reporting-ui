<style>

</style>
<script>
	//Set locate
	urlMaster.replaceParam('page', 'template');
	urlMaster.replaceParam('actionPath', 'adjusted_units_management');
	activeTab('Additional Adjustment');
</script>
<div class="page-header">
	<div class="btn-group pull-right">
	<a class="btn" href="" onclick="loadPage()"><i class="icon-chevron-left icon-black"></i>
		Back
	</a>
	</div>
	<h1 id="page_header">Add Adjusted Units</h1>
</div>
<form class="form-horizontal" role="form"  onsubmit="return false;">
	<div class="form-group">
	<label for="io_order_id" class="required control-label">IO Order ID <abbr title="Required">*</abbr></label>
	<input class="input-xlarge" id="selectbox-io_order_id" type="hidden" name="io_order_id" data-placeholder="Select IO Order ID" style="width: 100%"/>
	<p class="help-block">Please select your IO Order ID</p>
	</div>
	<div class="form-group">
		<label for="selectbox_month_sk" class="required control-label">Month<abbr title="Required">*</abbr></label>
		<select	class="form-control" id="selectbox_month_sk">									
		</select>
		<p class="help-block">Please select month</p>
	</div>
	<div class="form-group">
		<label for="campaign_id" class="required control-label">Adjusted Units<abbr title="Required">*</abbr></label>
		<input type="text" class="form-control"  placeholder="Enter adjusted units" name="adjusted_units" value="">
		<p class="help-block">Please enter adjusted unit number</p>
	</div>
	<div class="form-group">
		<label for="comment" class="required control-label">Comment</label>
		<input type="text" class="form-control" placeholder="Enter comment" name="comment" value="">
		<p class="help-block">Comment for your add new adjusted unit</p>
	</div>
	<div class="form-actions">
	<input class="btn btn-primary" data-disable-with="Please wait ..." name="commit" type="submit" value="Create">
	<a class="btn" href="#" onclick="loadPage()">Cancel</a>
	</div>
</form>  

<script>
$('#selectbox-io_order_id').select2({
	minimumInputLength: 0,
	ajax: {
		url: rootPath_AdjustedUnits,
		quietMillis: 1000,
		dataType: 'json',
		data: function (term, page) {
			return {
				actions: 'loadListIoOrders',
				page: page,
				limit: 20,
				data: 'json',
				term: term
			};
		},
		results: function (data, page) {
			var resultData=data;
			var myData=[];
			var more=false;
			if(resultData.length==20){
				more=true;
			}
			$.each(resultData,function(index,item){
				var row={
					id: item.io_orders_id,
					text: item.displayed_name
				};
				myData.push(row);
			});
			return { results: myData ,  more: more};
		}
	}
}).change(function(e){
});

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
		}
	});
}
loadSelectBoxMonthOfAdjustedUnits();
</script>