<script>
//Set locate
	urlMaster.replaceParam('page','billing_script');
	urlMaster.replaceParam('actionPath','billing_management');
	activeTab('Billing Monthly Worksheet');
</script>
<div class="page-header">

	<!-- Split button -->
	<div class="btn-group pull-right" style="margin-left: 5px;">
	  <button type="button" class="btn btn-success"><span class="glyphicon glyphicon-file"></span> Export</button>
	  <button type="button" class="btn btn-success dropdown-toggle" data-toggle="dropdown">
	    <span class="caret"></span>
	    <span class="sr-only">Toggle Dropdown</span>
	  </button>
	  <ul class="dropdown-menu" role="menu">
	    <li><a href="#" onclick="exportReport('html')">Review</a></li>
	    <li class="divider"></li>
	    <li><a href="#" onclick="exportReport('pdf')">Pdf</a></li>
	    <li><a href="#" onclick="exportReport('xls')">Excel</a></li>
	  </ul>
	</div>
	<div class="btn-group pull-right">
		<button type="button" class="btn btn-info" onclick="loadBillingDetailFromUrl()" >
		  <span class="glyphicon glyphicon-refresh"></span> Refresh
		</button>
		<button type="button" class="btn btn-info" data-toggle="modal" data-target="#myModal">
		  <span class="glyphicon glyphicon-cog"></span> Control Panel
		</button>
	</div>
	<h1 id="page_header">
		Billing Monthly Worksheet
	</h1>
</div>
<!-- Control panel -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Control panel</h4>
			</div>
			<div class="modal-body">
				<form role="form">
					<div class="form-group">
						<label for="exampleInputEmail1">Months</label>
						<input id="month_list_input" type="text" class="form-control" style="display: none;"/>
						<div id="month_list" class="form-group" style="overflow: auto;height: 100px;margin-bottom: 10px;"></div>
					</div>
					<div class="form-group">
						<label for="io_order_list">IO Orders</label>
						<input id="io_order_search_input" type="text" class="form-control"/>
						<div id="io_order_list" class="form-group" style="overflow: auto;height: 100px;margin-bottom: 10px;">
						</div>
					</div>
					<div class="form-group">
						<label for="io_line_item_list">IO Line Items</label>
						<input id="io_line_item_search_input" type="text" class="form-control"/>
						<div id="io_line_item_list" class="form-group" style="overflow: auto;height: 100px;">
						</div>
					</div>
				</form>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				<button type="button" class="btn btn-primary" onclick="applyControlPanel()">Apply</button>
			</div>
		</div>
	</div>
</div>
<!-- Control panel -->

<!-- Form edit information -->
<div class="modal fade bs-example-modal-lg" id="editInformationDialog" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Edit Information</h4>
      </div>
      <div class="modal-body">
		<form class="form-horizontal" role="form"  onsubmit="return informationFormAction()" id="editInformationForm">
			<div class="form-group">
				<label for="io_orders_id" class="required control-label">IO Order ID <abbr title="Required">*</abbr></label>
				<input class="form-control" type="hidden" name="p_io_orders_id" style="width: 100%" value="" />
				<input class="form-control" type="text" name="selectbox_io_orders_id" style="width: 100%" value="" disabled/>
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Campaign ID</label>
				<input type="text" class="form-control" maxlength="255" placeholder="Enter campaign id" name="campaign_id" value="">
			</div>
			<div class="form-group">
				<label for="billing_contact" class="required control-label">Billing Contact</label>
				<input type="text" class="form-control" maxlength="255" placeholder="Enter billing contact" name="billing_contact" value="">
			</div>
			<div class="form-group">
				<label for="comment" class="required control-label">Comment</label>
				<input type="text" class="form-control" maxlength="255" placeholder="Enter comment" name="comment" value="">
			</div>
		</form>      
      </div>
		<div class="modal-footer">
	    	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	    	<button type="button" class="btn btn-primary" onclick="billingUpdateInformation()">Update</button>
	    </div>
    </div>

  </div>
</div>
<!-- End -->

<!-- Form add information -->
<div class="modal fade bs-example-modal-lg" id="addInformationDialog" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Add Information</h4>
      </div>
      <div class="modal-body">
		<form class="form-horizontal" role="form"  onsubmit="return informationFormAction()" id="addInformationForm">
			<div class="form-group">
				<label for="io_orders_id" class="required control-label">IO Order ID <abbr title="Required">*</abbr></label>
				<input class="form-control" type="hidden" name="p_io_orders_id" style="width: 100%" value="" />
				<input class="form-control" type="text" name="selectbox_io_orders_id" style="width: 100%" value="" disabled/>
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Campaign ID</label>
				<input type="text" class="form-control" maxlength="255" placeholder="Enter campaign id" name="campaign_id" value="">
			</div>
			<div class="form-group">
				<label for="billing_contact" class="required control-label">Billing Contact</label>
				<input type="text" class="form-control" maxlength="255" placeholder="Enter billing contact" name="billing_contact" value="">
			</div>
			<div class="form-group">
				<label for="comment" class="required control-label">Comment</label>
				<input type="text" class="form-control" maxlength="255" placeholder="Enter comment" name="comment" value="">
			</div>
		</form>      
      </div>
		<div class="modal-footer">
	    	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	    	<button type="button" class="btn btn-primary" onclick="billingAddInformation()">Add</button>
	    </div>
    </div>

  </div>
</div>
<!-- End -->

<!-- Form adjusted information -->
<div class="modal fade bs-example-modal-lg" id="addAdjustedUnitDialog" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Add Adjusted Units</h4>
      </div>
      <div class="modal-body">
		<form class="form-horizontal" role="form"  onsubmit="return informationFormAction()" id="addAdjustedUnitForm">
			<div class="form-group">
				<label for="combined_ids" class="required control-label">Combined IDs <abbr title="Required">*</abbr></label>
				<input class="form-control" type="hidden" name="p_io_orders_id" style="width: 100%" value="" />
				<input class="form-control" type="hidden" name="p_io_line_item_id" style="width: 100%" value="" />
				<input class="form-control" type="hidden" name="p_month_sk" style="width: 100%" value="" />
				<input class="form-control" type="text" name="selectbox-combined_ids" style="width: 100%" value="{p_io_orders_id} - {p_io_line_item_id} | {p_io_line_item_name}" disabled/>
				
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Month<abbr title="Required">*</abbr></label>
				<input type="text" class="form-control" name="month" value="" disabled>
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Adjusted Units<abbr title="Required">*</abbr></label>
				<input type="text" class="form-control" maxlength="10" placeholder="Enter adjusted units" name="adjusted_units" value="">
			</div>
			<div class="form-group">
				<label for="comment" class="required control-label">Comment</label>
				<input type="text" class="form-control" maxlength="255" placeholder="Enter comment" name="comment" value="">
			</div>
		</form>      
      </div>
		<div class="modal-footer">
	    	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	    	<button type="button" class="btn btn-primary" onclick="billingAddAdjustedUnits()">Add</button>
	    </div>
    </div>

  </div>
</div>
<!-- End -->

<!-- Form update adjusted units  -->
<div class="modal fade bs-example-modal-lg" id="updateAdjustedUnitDialog" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="myModalLabel">Update Adjusted Units</h4>
      </div>
      <div class="modal-body">
		<form class="form-horizontal" role="form"  onsubmit="return informationFormAction()" id="updateAdjustedUnitForm">
			<div class="form-group">
				<label for="combined_ids" class="required control-label">Combined IDs <abbr title="Required">*</abbr></label>
				<input class="form-control" type="hidden" name="p_io_orders_id" style="width: 100%" value="" />
				<input class="form-control" type="hidden" name="p_io_line_item_id" style="width: 100%" value="" />
				<input class="form-control" type="hidden" name="p_month_sk" style="width: 100%" value="" />
				<input class="form-control" type="text" name="selectbox-combined_ids" style="width: 100%" value="" disabled/>				
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Month<abbr title="Required">*</abbr></label>
				<input type="text" class="form-control" name="month" value="" disabled>
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Adjusted Units<abbr title="Required">*</abbr></label>
				<input type="text" class="form-control" maxlength="10" placeholder="Enter adjusted units" name="adjusted_units" value="">
			</div>
			<div class="form-group">
				<label for="comment" class="required control-label">Comment</label>
				<input type="text" class="form-control" maxlength="255" placeholder="Enter comment" name="comment" value="">
			</div>
		</form>      
      </div>
		<div class="modal-footer">
	    	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	    	<button type="button" class="btn btn-primary" onclick="billingUpdateAjustedUnits()">Update</button>
	    </div>
    </div>

  </div>
</div>
<!-- End -->

<!-- Table -->
<div>
	<table id="detailTable"	class="table table-bordered table-hover">
		<thead>
			<tr>
				<th class="buttons col-md-1"></th>
				<th class="buttons col-md-1"></th>
				<th class="buttons col-md-1"></th>
				<th class="buttons col-md-1"></th>
				<th class="buttons col-md-1"></th>
				<th class="buttons col-md-1"></th>
				<th class="buttons col-md-1"></th>
				<th class="buttons col-md-1"></th>
				<th class="buttons col-md-1"></th>
				<th class="buttons col-md-1"></th>
				<th class="buttons col-md-1"></th>
				<th class="buttons col-md-1"></th>
			</tr>
				<th class="buttons" colspan="2"><b>ADM IO Order # | IO # | IO Revision Date</b></th>
				<th class="buttons" colspan="3"><b>Campaign Name | Advertiser | Agency</b></th>
				<th class="buttons" colspan="3"><b>Campaign ID | Billing Contact | Comment</b></th>
				<th class="buttons" style="text-align: right;"><b>Booking</b></th>
				<th class="buttons" style="text-align: right;"><b>Units Inv. ToDate</b></th>
				<th class="buttons" style="text-align: right;"><b>Amount Inv. ToDate</b></th>
				<th class="buttons" style="text-align: right;"><b>Remaining Balance</b></th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>
<script>
	var data=[];
	var g_information_campaign_id = '';
	var g_information_billing_contact = '';
	var g_information_comment = '';
	var g_adjustment_adjusted_units = '';
	
	//////////////////////////
	// First load billing page
	/////////////////////////
	$( document ).ready(function(){
		loadBillingDetailFromUrl();
		
	}) ;
	
	///////////////////////////////////
	// Load page from param on url
	////////////////////////////////////
	function loadBillingDetailFromUrl(){
		var p_month_since_2005=urlMaster.getParam('month_sk');
		var p_calendar_year_month=urlMaster.getParam('year_month');
		var p_io_orders=urlMaster.getParam('io_orders');
		var p_io_line_items=urlMaster.getParam('io_line_items');
		
		if (p_calendar_year_month != '') {
			$('#page_header').html('Billing Monthly Worksheet - ' + p_calendar_year_month);
		}
		
		if(p_month_since_2005!=''&&p_io_orders!=''&&p_io_line_items!=''){
		console.log(p_month_since_2005);
			if(p_month_since_2005.indexOf(",")>0 || p_month_since_2005==0 ){
				$('#page_header').html('Billing Monthly Worksheet');
				loadBillingDetailTableInMultipleMonth({
					p_month_since_2005 : p_month_since_2005,
					p_io_orders: p_io_orders,
					p_io_line_items: p_io_line_items,
					obj_table: $('#detailTable'),
					success: function(){
						
					}
				});
			}else{
				// Load detail table
				$('#page_header').html('Billing Monthly Worksheet - ' + p_calendar_year_month);
				loadBillingDetailTable({
					p_month_since_2005 : p_month_since_2005,
					p_io_orders: p_io_orders,
					p_io_line_items: p_io_line_items,
					obj_table: $('#detailTable'),
					success: function(){
						
					}
				});
			}
			
		}	
	}
	/////////////////////////
	// Load list of month
	/////////////////////////
	
	var loadMonthList=new generateSelect2({
		inputID: 'month_list_input',
		divID: 'month_list',
		name: 'month_since_2005',
		multi: true,
		selectAll: true,
		ajaxUrl: '/pentaho/ViewAction',
		data: function(term,page){
			return {
				solution: solution,
				path: path+'/ba_national_management',
				data: 'json',
				action: 'billing_management.xaction',
				term: term, //search term
				limit: 20, // page size
				page: page, // page number
				actions: 'loadListMonths'
				//p_month_since_2005: $('#selectbox-month_sk').val().join(",")
			};
		},
		result: function(data, page){
			var results=[];
			for(var i=0;i<data.length;i++){
				var row=data[i];
				var id=row.month_since_2005;
				var name=row.calendar_year_month ;
				var dataRow=[id,name];
				results.push(dataRow);
			}
			data.data;
			var more=false;
			if(results.length==20){
				more=true
			}
			return {results: results,more: more}
		},
		success: function(){
			//mySearch2.action();
			loadIoOrders.action();
		},
		clickEvent: function(id){
			//mySearch2.action();
		}
	});
	
	loadMonthList.action();
	
	//////////////////////////////
	//Load list order
	/////////////////////////////
	var loadIoOrders=new generateSelect2({
		inputID: 'io_order_search_input',
		divID: 'io_order_list',
		name: 'loadIoOrders',
		multi: true,
		selectAll: true,
		ajaxUrl: '/pentaho/ViewAction',
		data: function(term,page){
			return {
				solution: solution,
				path: path+'/ba_national_management',
				data: 'json',
				action: 'billing_management.xaction',
				term: term, //search term
				limit: 20, // page size
				page: page, // page number
				actions: 'loadListIoOrders'
				//p_month_since_2005: $('#selectbox-month_sk').val().join(",")
			};
		},
		result: function(data, page){
			
			var results=[];
			for(var i=0;i<data.length;i++){
				var row=data[i];
				var id=row.io_orders_id;
				var name=id+' | '+row.contract_name;
				var dataRow=[id,name];
				results.push(dataRow);
			}
			data.data;
			var more=false;
			if(results.length==20){
				more=true
			}
			return {results: results,more: more}
		},
		success: function(){
			//mySearch2.action();
		},
		clickEvent: function(id){
			//mySearch2.action();
			if(loadIoOrders.getID().length>0){
				loadIoLineItems.action();				
			}
			
		}
	});
	
	var loadIoLineItems=new generateSelect2({
		inputID: 'io_line_item_search_input',
		divID: 'io_line_item_list',
		name: 'loadIoLineItems',
		multi: true,
		selectAll: true,
		ajaxUrl: '/pentaho/ViewAction',
		data: function(term,page){
			return {
				solution: solution,
				path: path+'/ba_national_management',
				data: 'json',
				action: 'billing_management.xaction',
				term: term, //search term
				limit: 20, // page size
				page: page, // page number
				actions: 'loadListIoLineItems',
				//p_month_since_2005: $('#selectbox-month_sk').val().join(","),
				p_io_orders: loadIoOrders.getID().join(",")
			};
		},
		result: function(data, page){
			
			var results=[];
			for(var i=0;i<data.length;i++){
				var row=data[i];
				var id=row.io_line_item_id;
				var name=id+' | '+row.io_line_item_name;
				var dataRow=[id,name];
				results.push(dataRow);
			}
			data.data;
			var more=false;
			if(results.length==20){
				more=true
			}
			return {results: results,more: more}
		},
		success: function(){
			//mySearch2.action();
		},
		clickEvent: function(id){
			//mySearch2.action();
		}
	});
	
	////////////////////////////////
	// Load billing detail
	////////////////////////////////
	
	function applyControlPanel(){
		//get input
		var p_month_since_2005    = loadMonthList.getID().join(",");
		var p_calendar_year_month = [];
		var p_io_orders           = loadIoOrders.getID().join(",");
		var p_io_line_items       = loadIoLineItems.getID().join(",");
				
				
		if(loadMonthList.getID().length==0){
			alert("Please select Months!");
			return false;
		}else if(loadIoOrders.getID().length==0){
			alert("Please select IO Orders!");
			return false;
		}else if(loadIoLineItems.getID().length==0){
			alert("Please select IO Line Items!");
			return false;
		}
		
		// get select month value
		$.each(loadMonthList.getID(),function(index,month_sk){
			var month=$('#month_list label[for=checkbox_month_since_2005_'+month_sk+']:first').html();
			p_calendar_year_month.push(month);
		});
		//hide modal
		$('#myModal').modal('hide');
		//set to url
		urlMaster.replaceParam('month_sk',p_month_since_2005);
		urlMaster.replaceParam('year_month',p_calendar_year_month.join(","));
		urlMaster.replaceParam('io_orders',p_io_orders);
		urlMaster.replaceParam('io_line_items',p_io_line_items);
		// Load summary table
		loadBillingDetailFromUrl();
	}
	
	///////////////////////////////////
	// load information edit form
	//////////////////////////////////
	
	function loadInfomationEditForm(row){
		var io_orders_id    = dataTableDetail[row].io_orders_id;
		var displayed_name  = dataTableDetail[row].io_orders_id + ' | ' + dataTableDetail[row].campaign_name;
		var campaign_id     = dataTableDetail[row].campaign_id;
		var billing_contact = dataTableDetail[row].billing_contact;
		var comment         = dataTableDetail[row].comment;
		
		// keep history
		g_information_campaign_id     = campaign_id;
		g_information_billing_contact = billing_contact;
		g_information_comment         = comment;
		
		$('#editInformationForm input[name=p_io_orders_id]').val(io_orders_id);
		$('#editInformationForm input[name=campaign_id]').val(campaign_id);
		$('#editInformationForm input[name=billing_contact]').val(billing_contact);	
		$('#editInformationForm input[name=selectbox_io_orders_id]').val(displayed_name);
		$('#editInformationForm input[name=comment]').val(comment);
	}
	
	///////////////////////////////////
	// load information add form
	//////////////////////////////////
	
	function loadInfomationAddForm(row){
		var io_orders_id    = dataTableDetail[row].io_orders_id;
		var displayed_name  = dataTableDetail[row].io_orders_id + ' | ' + dataTableDetail[row].campaign_name;
		
		$('#addInformationForm input[name=p_io_orders_id]').val(io_orders_id);
		$('#addInformationForm input[name=selectbox_io_orders_id]').val(displayed_name);
	}
	
	/////////////////////////////////////
	// Update information
	/////////////////////////////////////
	
	function billingUpdateInformation(){
		var campaign_id     = $('#editInformationForm input[name=campaign_id]').val();
		var billing_contact = $('#editInformationForm input[name=billing_contact]').val();
		var comment         = $('#editInformationForm input[name=comment]').val();
		
		if (campaign_id == '' && billing_contact == '' && comment == ''){
			alert("Please fill required fields");
			return false;
		}
		
		if (campaign_id == g_information_campaign_id
            && billing_contact == g_information_billing_contact
			&& comment == g_information_comment) {
			alert('There is no change!');
			return false;
		}
		
		$('#editInformationDialog').modal('hide');
		updateInfomation({
			p_io_orders_id: $('#editInformationForm input[name=p_io_orders_id]').val(),
			p_campaign_id: $('#editInformationForm input[name=campaign_id]').val(),
			p_billing_contact: $('#editInformationForm input[name=billing_contact]').val(),
			p_comment: $('#editInformationForm input[name=comment]').val(),
			success: function(data){				
				loadBillingDetailFromUrl();
			}
		});
	}
	
	/////////////////////////////////////
	// Add information
	/////////////////////////////////////
	
	function billingAddInformation(){
		var campaign_id     = $('#addInformationForm input[name=campaign_id]').val();
		var billing_contact = $('#addInformationForm input[name=billing_contact]').val();
		var comment         = $('#addInformationForm input[name=comment]').val();
		
		if (campaign_id == '' && billing_contact == '' && comment == ''){
			alert("Please fill required fields");
			
		} else {
			$('#addInformationDialog').modal('hide');
			addInfomation({
				p_io_orders_id: $('#addInformationForm input[name=p_io_orders_id]').val(),
				p_campaign_id: $('#addInformationForm input[name=campaign_id]').val(),
				p_billing_contact: $('#addInformationForm input[name=billing_contact]').val(),
				p_comment: $('#addInformationForm input[name=comment]').val(),
				success: function(data){				
					loadBillingDetailFromUrl();
				}
			});
		}
	}
	
	///////////////////////////////////
	// load adjusted add form
	//////////////////////////////////	
	
	function loadAdjustedAddForm(row){
		var combined_ids = dataTableDetail[row].combined_ids;
		var io_line_item_name=dataTableDetail[row].placement_group;
		var month_since_2005=dataTableDetail[row].month_since_2005;
		var calendar_year_month=dataTableDetail[row].calendar_year_month;
		var p_io_orders_id=combined_ids.split("-")[0];
		var p_io_line_item_id=combined_ids.split("-")[1];
		
		// set value to form
		$('#addAdjustedUnitDialog input[name=p_io_orders_id]').val(p_io_orders_id);
		$('#addAdjustedUnitDialog input[name=p_io_line_item_id]').val(p_io_line_item_id);	
		$('#addAdjustedUnitDialog input[name=month]').val(calendar_year_month);	
		$('#addAdjustedUnitDialog input[name=p_month_sk]').val(month_since_2005);	
		$('#addAdjustedUnitDialog input[name=adjusted_units]').val('');	
		$('#addAdjustedUnitDialog input[name=selectbox-combined_ids]').val(combined_ids+" | "+io_line_item_name);
		$('#addAdjustedUnitDialog input[name=comment]').val('');		
	}
	
	/////////////////////////////////////
	// Add Adjusted Units
	/////////////////////////////////////
	
	function billingAddAdjustedUnits(){
		var adjusted_units  = $('#addAdjustedUnitForm input[name=adjusted_units]').val();
		var comment         = $('#addAdjustedUnitForm input[name=comment]').val();
		
		if (adjusted_units == '') {
			alert("Please fill required fields");
			return false;
		}
		// verify adjusted units input
		if (!$.isNumeric(adjusted_units)) {
			alert("Adjusted units must be a number!");
			return false;
		}
		
		$('#addAdjustedUnitDialog').modal('hide');
		addAdjustedUnits({
			p_combined_ids: $('#addAdjustedUnitForm input[name=selectbox-combined_ids]').val(),
			p_io_orders_id: $('#addAdjustedUnitForm input[name=p_io_orders_id]').val(),
			p_io_line_item_id: $('#addAdjustedUnitForm input[name=p_io_line_item_id]').val(),
			p_adjusted_units: $('#addAdjustedUnitForm input[name=adjusted_units]').val(),
			p_month_sk: $('#addAdjustedUnitForm input[name=p_month_sk]').val(),
			p_comment: $('#addAdjustedUnitForm input[name=comment]').val(),
			success: function(data){				
				loadBillingDetailFromUrl();
			}
		});
	}
	
	///////////////////////////////////
	// load adjusted update form
	//////////////////////////////////	
	
	function loadAdjustedUpdateForm(row){
		var combined_ids = dataTableDetail[row].combined_ids;
		var io_line_item_name=dataTableDetail[row].placement_group;
		var month_since_2005=dataTableDetail[row].month_since_2005;
		var calendar_year_month=dataTableDetail[row].calendar_year_month;
		var p_io_orders_id=combined_ids.split("-")[0];
		var p_io_line_item_id=combined_ids.split("-")[1];
		var p_adjusted_units=dataTableDetail[row].adjusted_units;
		
		//Keep history
		g_adjustment_adjusted_units = p_adjusted_units;
		
		//Set value to form
		$('#updateAdjustedUnitForm input[name=p_io_orders_id]').val(p_io_orders_id);
		$('#updateAdjustedUnitForm input[name=p_io_line_item_id]').val(p_io_line_item_id);	
		$('#updateAdjustedUnitForm input[name=month]').val(calendar_year_month);	
		$('#updateAdjustedUnitForm input[name=p_month_sk]').val(month_since_2005);	
		$('#updateAdjustedUnitForm input[name=adjusted_units]').val(p_adjusted_units);	
		$('#updateAdjustedUnitForm input[name=selectbox-combined_ids]').val(combined_ids+" | "+io_line_item_name);
		$('#updateAdjustedUnitForm input[name=comment]').val('');		
	}
	
	/////////////////////////////////////
	// Update Adjusted Units
	/////////////////////////////////////
	
	function billingUpdateAjustedUnits(){
		var adjusted_units  = $('#updateAdjustedUnitForm input[name=adjusted_units]').val();
		
		if (adjusted_units == '') {
			alert("Please fill required fields");
			return false;
		}
		// verify adjusted units input
		if (!$.isNumeric(adjusted_units)) {
			alert("Adjusted units must be a number!");
			return false;
		}
		//Check changed
		if (g_adjustment_adjusted_units == adjusted_units){
			alert("This is no change on Adjusted units!");
			return false;
		}
		
		$('#updateAdjustedUnitDialog').modal('hide');
		updateAdjustedUnits({
			p_combined_ids: $('#updateAdjustedUnitForm input[name=selectbox-combined_ids]').val(),
			p_io_orders_id: $('#updateAdjustedUnitForm input[name=p_io_orders_id]').val(),
			p_io_line_item_id: $('#updateAdjustedUnitForm input[name=p_io_line_item_id]').val(),
			p_adjusted_units: $('#updateAdjustedUnitForm input[name=adjusted_units]').val(),
			p_month_sk: $('#updateAdjustedUnitForm input[name=p_month_sk]').val(),
			p_comment: $('#updateAdjustedUnitForm input[name=comment]').val(),
			success: function(data){
				loadBillingDetailFromUrl();
			}		
		});
	}
	
	///////////////////////////////////
	//	Show billing detail
	///////////////////////////////////
	
	function showBillingDetail(p_month_since_2005,p_io_order_id,p_io_line_item_id){
		$("#summary-content div.content").empty();
		loadBillingDetail({
			p_month_since_2005:p_month_since_2005,
			p_io_order_id: p_io_order_id,
			p_io_line_item_id: p_io_line_item_id,
			success: function(content){				
				var divDetail=$(content);
				$("#summary-content div.content").append(divDetail);
			}
		});
	}
	
	///////////////////////////
	// Export
	//////////////////////////
	
	function exportReport(exportType){
		var p_month_since_2005=urlMaster.getParam('month_sk',p_month_since_2005);
		var p_io_orders=urlMaster.getParam('io_orders',p_io_orders);
		var p_io_line_items=urlMaster.getParam('io_line_items',p_io_line_items);
		
		if(p_month_since_2005!=''&&p_io_orders!=''&&p_io_line_items!=''){
			exportNationalBillingReport({
				p_export_output: exportType,
				p_month_since_2005 : p_month_since_2005,
				p_io_orders: p_io_orders,
				p_io_line_items: p_io_line_items
			});
		}else{
			
		}
	}
	
	////////////////////////////////////////
	// Show/Hide IO Line Item Detail by IO Order
	////////////////////////////////////////
	
	function showDetailGroupOrder(io_order_id){
		if ($('tr.group_month_' + io_order_id).first().css('display') == 'none') {
			$('tr.group_month_' + io_order_id).show();
		} else {
			$('tr.group_month_' + io_order_id).hide();
			$('tr[class^=row_' + io_order_id+']').hide();
			$('tr[class^=row_head_title_' + io_order_id+']').hide();
		}
	}
	
	function showDetailGroupMonth(key){
		if ($('tr.row_' + key).first().css('display') == 'none') {
			$('tr.row_' + key).show();
			$('tr.row_head_title_' + key).show();
		} else {
			$('tr.row_' + key).hide();
			$('tr.row_head_title_' + key).hide();
		}
	}
	
	function showDetail(io_order_id){
		if ($('tr.class' + io_order_id).first().css('display') == 'none') {
			$('tr.class' + io_order_id).show();
		} else {
			$('tr.class' + io_order_id).hide();
		}
	}
</script>