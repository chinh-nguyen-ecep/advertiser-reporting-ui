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
	<a class="btn" href="" onclick="loadPage()"><i class="icon-chevron-left icon-black"></i>
		Back
	</a>
	</div>
	<h1 id="page_header">Edit Adjusted Units</h1>
</div>
<form class="form-horizontal" role="form"  onsubmit="return formAction();">
	<div class="form-group">
		<label for="io_order_id" class="required control-label">Month <abbr title="Required">*</abbr></label>
		<input  class="form-control" id="p_month_sk" type="hidden" name="p_month_sk" style="width: 100%" value="{p_month_sk}" />
		<input  class="form-control" id="selectbox_month_sk" type="text" name="month_sk" style="width: 100%" value="{p_calendar_year_month}" disabled/>
	</div>
	<div class="form-group">
		<label for="combined_ids" class="required control-label">Combined IDs <abbr title="Required">*</abbr></label>
		<input  class="form-control" id="p_io_orders_id" type="hidden" name="p_io_orders_id" style="width: 100%" value="{p_io_orders_id}" />
		<input  class="form-control" id="p_io_line_item_id" type="hidden" name="p_io_line_item_id" style="width: 100%" value="{p_io_line_item_id}" />
		<input  class="form-control" id="selectbox_combined_ids" type="text" name="combined_ids" style="width: 100%" value="{p_displayed_name}" disabled/>
	</div>
	<div class="form-group">
		<label for="adjusted_units" class="required control-label">Adjusted Units<abbr title="Required">*</abbr></label>
		<input type="text" class="form-control" id="adjusted_units" maxlength="10" placeholder="Enter adjusted units" name="adjusted_units" value="{p_adjusted_units}">
	</div>
	<div class="form-group">
		<label for="comment" class="required control-label">Comment</label>
		<input type="text" class="form-control" id="comment" maxlength="255" placeholder="Enter comment" name="comment" value="{p_comment}">
	</div>
	<div class="form-actions">
	<input class="btn btn-primary" data-disable-with="Please wait ..." name="commit" type="submit" value="Update">
	<a class="btn" href="#" onclick="loadPage()">Cancel</a>
	</div>
</form>  

<script>
var current_adjusted_units = $('#adjusted_units').val();
var current_comment = $('#comment').val(); 

function formAction(){
	var p_month_sk=$('#p_month_sk').val();
	var p_io_orders_id=$('#p_io_orders_id').val();
	var p_io_line_item_id=$('#p_io_line_item_id').val();
	var adjusted_units=$('#adjusted_units').val();
	var comment=$('#comment').val();
	
	var is_valid = true;
	if (current_adjusted_units == adjusted_units && current_comment == comment) {
		alert("There is no change!");
		is_valid = false;
	}
	
	if (is_valid == true) {
		updateAdjustedUnits({
			p_combined_ids : p_io_orders_id + '-' + p_io_line_item_id,
			p_io_orders_id : p_io_orders_id,
			p_io_line_item_id : p_io_line_item_id,
			p_adjusted_units : adjusted_units,
			p_month_sk : p_month_sk,
			p_comment : comment,
			success: function(data){
				var msg=data[0].fn_ba_national_dim_adjustment_update;
				if(msg=='SUCCESSED'){
					alert("Edited successfully");
				}
			}
		});
	}
	return false;
}
</script>