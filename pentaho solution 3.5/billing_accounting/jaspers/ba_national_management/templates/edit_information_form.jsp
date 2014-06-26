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
		<label for="io_order_id" class="required control-label">IO Order ID <abbr title="Required">*</abbr></label>
		<input  class="form-control" id="p_io_orders_id" type="hidden" name="p_io_orders_id" style="width: 100%" value="{p_io_orders_id}" />
		<input  class="form-control" id="selectbox-io_order_id" type="text" name="io_order_id" style="width: 100%" value="{p_displayed_name}" disabled/>
	</div>
	<div class="form-group">
		<label for="campaign_id" class="required control-label">Campaign ID <abbr title="Required">*</abbr></label>
		<input type="text" class="form-control" id="campaign_id" maxlength="255" placeholder="Enter campaign id" name="campaign_id" value="{p_campaign_id}">
	</div>
	<div class="form-group">
		<label for="billing_contact" class="required control-label">Billing Contact <abbr title="Required">*</abbr></label>
		<input type="text" class="form-control" id="billing_contact" maxlength="255" placeholder="Enter billing contact" name="billing_contact" value="{p_billing_contact}">
	</div>
	<div class="form-group">
		<label for="comment" class="required control-label">Comment</label>
		<input type="text" class="form-control" id="comment" maxlength="255" placeholder="Enter comment" name="comment" value="{p_comment}">
	</div>
	<div class="form-actions">
		<input class="btn btn-primary" data-disable-with="Please wait ..." name="commit" type="submit" value="Update">
		<a class="btn" href="#" onclick="urlMaster.replaceParam('page','information_script');loadPage()">Cancel</a>
	</div>
</form>

<script>

var current_campaign_id=$('#campaign_id').val();
var current_billing_contact=$('#billing_contact').val(); 
var current_comment=$('#comment').val(); 

function formAction(){
	var io_order_id=$('#p_io_orders_id').val();
	var campaign_id=$('#campaign_id').val();
	var billing_contact=$('#billing_contact').val();
	var comment=$('#comment').val();
	
	var is_valid = true;
	if (current_campaign_id == campaign_id && current_billing_contact == billing_contact || current_comment == comment) {
		alert("There is no change!");
		is_valid = false;
	}
	
	if (is_valid == true) {
		updateInfomation({
			p_io_orders_id: io_order_id,
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