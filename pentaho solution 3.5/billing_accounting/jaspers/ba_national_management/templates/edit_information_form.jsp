<div class="breadcrumbs">
	<a href="" onclick="goHomePage()">
	<i class="icon-home"></i>
	Home
	</a>
	<span class="separator">/</span> 
	<a class="first item-0" href="#" onclick="goInformationPage()">Information</a> 
	<span class="separator">/</span> 
	<a class="first item-0" href="#">Edit Information</a>
</div>
<div class="page-header">
	<div class="btn-group pull-right">
	<a class="btn" href="" onclick="urlMaster.replaceParam('page','information_script');loadPage()"><i class="icon-chevron-left icon-black"></i>
	Back
	</a>
	</div>
	<h1>
	Edit Information
	</h1>
</div>
<form class="form-horizontal" role="form"  onsubmit="return formAction()">
	<div class="form-group">
		<label for="combined_ids" class="required control-label">Combined IDs <abbr title="Required">*</abbr></label>
		<input  class="form-control" id="p_io_orders_id" type="hidden" name="p_io_orders_id" style="width: 100%" value="{p_io_orders_id}" />
		<input  class="form-control" id="p_io_line_item_id" type="hidden" name="p_io_line_item_id" style="width: 100%" value="{p_io_line_item_id}" />
		<input  class="form-control" id="selectbox-combined_ids" type="text" name="combined_ids" style="width: 100%" value="{p_io_orders_id} - {p_io_line_item_id} | {p_io_line_item_name}" disabled/>
		<p class="help-block">Please select your combined ids</p>
	</div>
	<div class="form-group">
		<label for="campaign_id" class="required control-label">Campaign ID <abbr title="Required">*</abbr></label>
		<input type="text" class="form-control" id="campaign_id" placeholder="Enter campaign id" name="campaign_id" value="{p_campaign_id}">
		<p class="help-block">Enter a friendly campaign id</p>
	</div>
	<div class="form-group">
		<label for="billing_contact" class="required control-label">Billing Contact <abbr title="Required">*</abbr></label>
		<input type="text" class="form-control" id="billing_contact" placeholder="Enter billing contact" name="billing_contact" value="{p_billing_contact}">
		<p class="help-block">Enter a billing contact</p>
	</div>
	<div class="form-group">
		<label for="comment" class="required control-label">Comment</label>
		<input type="text" class="form-control" id="comment" placeholder="Enter comment" name="comment" value="">
		<p class="help-block">Enter your comment</p>
	</div>
	<div class="form-actions">
		<input class="btn btn-primary" data-disable-with="Please wait ..." name="commit" type="submit" value="Update">
		<a class="btn" href="#" onclick="urlMaster.replaceParam('page','information_script');loadPage()">Cancel</a>
	</div>
</form>

<script>

var current_campaign_id=$('#campaign_id').val();
var current_billing_contact=$('#billing_contact').val(); 

function formAction(){
	var combined_ids=$('#selectbox-combined_ids').val();
	var campaign_id=$('#campaign_id').val();
	var billing_contact=$('#billing_contact').val();
	var comment=$('#comment').val();
	var p_io_orders_id=$('#p_io_orders_id').val();
	var p_io_line_item_id =$('#p_io_line_item_id').val();
	
	var is_valid = true;
	if (current_campaign_id == campaign_id && current_billing_contact == billing_contact) {
		alert("There is no change!");
		is_valid = false;
	}
	
	if (is_valid == true) {
		updateInfomation({
			p_combined_ids: combined_ids,
			p_io_orders_id: p_io_orders_id,
			p_io_line_item_id: p_io_line_item_id,
			p_campaign_id: campaign_id,
			p_billing_contact: billing_contact,
			p_comment: comment,
			success: function(data){
				var msg=data[0].fn_ba_national_dim_io_update;
				if(msg=='SUCCESSED'){
					alert("Edited successfully");
				}
			}
		});
	}
	return false;
}
</script>