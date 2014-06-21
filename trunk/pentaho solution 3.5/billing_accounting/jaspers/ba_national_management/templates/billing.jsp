<script>
//Set locate
	urlMaster.replaceParam('page','billing_script');
	urlMaster.replaceParam('actionPath','billing_management');
	activeTab('Billing');
</script>
<div class="page-header">
	<div class="btn-group pull-right">
		<button type="button" class="btn btn-success" onclick="applyControlPanel()" >
		  <span class="glyphicon glyphicon-refresh"></span> Refresh
		</button>
		<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#myModal">
		  <span class="glyphicon glyphicon-cog"></span> Control Panel
		</button>
	</div>
	<h1>
	National Billing
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
		    <label for="exampleInputEmail1">Month</label>		   
		   <select class="form-control" id="selectbox-month_sk">			  
			</select>
		   
		  </div>
		  <div class="form-group">
		    <label for="exampleInputPassword1">IO Orders</label>
							<input id="io_order_search_input" type="text" class="form-control"/>
							<div id="io_order_list" class="form-group" style="overflow: auto;height: 100px;margin: 10px;">
							</div>
		  </div>
		  <div class="form-group">
		    <label for="exampleInputPassword1">IO Line Items</label>
							<input id="io_line_item_search_input" type="text" class="form-control"/>
							<div id="io_line_item_list" class="form-group" style="overflow: auto;height: 100px;margin: 10px;">
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
				<label for="combined_ids" class="required control-label">Combined IDs <abbr title="Required">*</abbr></label>
				<input  class="form-control" type="hidden" name="p_io_orders_id" style="width: 100%" value="{p_io_orders_id}" />
				<input  class="form-control" type="hidden" name="p_io_line_item_id" style="width: 100%" value="{p_io_line_item_id}" />
				<input  class="form-control" type="text" name="selectbox-combined_ids" style="width: 100%" value="{p_io_orders_id} - {p_io_line_item_id} | {p_io_line_item_name}" disabled/>
				<p class="help-block">Please select your combined ids</p>
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Campaign ID <abbr title="Required">*</abbr></label>
				<input type="text" class="form-control" placeholder="Enter campaign id" name="campaign_id" value="{p_campaign_id}">
				<p class="help-block">Enter a friendly campaign id</p>
			</div>
			<div class="form-group">
				<label for="billing_contact" class="required control-label">Billing Contact <abbr title="Required">*</abbr></label>
				<input type="text" class="form-control" placeholder="Enter billing contact" name="billing_contact" value="{p_billing_contact}">
				<p class="help-block">Enter a billing contact</p>
			</div>
			<div class="form-group">
				<label for="comment" class="required control-label">Comment</label>
				<input type="text" class="form-control" placeholder="Enter comment" name="comment" value="">
				<p class="help-block">Enter your comment</p>
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
				<label for="combined_ids" class="required control-label">Combined IDs <abbr title="Required">*</abbr></label>
				<input  class="form-control" type="hidden" name="p_io_orders_id" style="width: 100%" value="{p_io_orders_id}" />
				<input  class="form-control" type="hidden" name="p_io_line_item_id" style="width: 100%" value="{p_io_line_item_id}" />
				<input  class="form-control" type="text" name="selectbox-combined_ids" style="width: 100%" value="{p_io_orders_id} - {p_io_line_item_id} | {p_io_line_item_name}" disabled/>
				<p class="help-block">Please select your combined ids</p>
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Campaign ID <abbr title="Required">*</abbr></label>
				<input type="text" class="form-control"  placeholder="Enter campaign id" name="campaign_id" value="{p_campaign_id}">
				<p class="help-block">Enter a friendly campaign id</p>
			</div>
			<div class="form-group">
				<label for="billing_contact" class="required control-label">Billing Contact <abbr title="Required">*</abbr></label>
				<input type="text" class="form-control" placeholder="Enter billing contact" name="billing_contact" value="{p_billing_contact}">
				<p class="help-block">Enter a billing contact</p>
			</div>
			<div class="form-group">
				<label for="comment" class="required control-label">Comment</label>
				<input type="text" class="form-control" placeholder="Enter comment" name="comment" value="">
				<p class="help-block">Enter your comment</p>
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
				<input  class="form-control" type="hidden" name="p_io_orders_id" style="width: 100%" value="" />
				<input  class="form-control" type="hidden" name="p_io_line_item_id" style="width: 100%" value="" />
				<input  class="form-control" type="hidden" name="p_month_sk" style="width: 100%" value="" />
				<input  class="form-control" type="text" name="selectbox-combined_ids" style="width: 100%" value="{p_io_orders_id} - {p_io_line_item_id} | {p_io_line_item_name}" disabled/>
				
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Month<abbr title="Required">*</abbr></label>
				<input type="text" class="form-control" name="month" value="" disabled>
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Ajusted Units<abbr title="Required">*</abbr></label>
				<input type="text" class="form-control"  placeholder="Enter ajusted units" name="adjusted_units" value="">
			</div>
			<div class="form-group">
				<label for="comment" class="required control-label">Comment</label>
				<input type="text" class="form-control" placeholder="Enter comment" name="comment" value="">
			</div>
		</form>      
      </div>
		<div class="modal-footer">
	    	<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
	    	<button type="button" class="btn btn-primary" onclick="billingAddAjustedUnits()">Add</button>
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
				<input  class="form-control" type="hidden" name="p_io_orders_id" style="width: 100%" value="" />
				<input  class="form-control" type="hidden" name="p_io_line_item_id" style="width: 100%" value="" />
				<input  class="form-control" type="hidden" name="p_month_sk" style="width: 100%" value="" />
				<input  class="form-control" type="text" name="selectbox-combined_ids" style="width: 100%" value="" disabled/>				
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Month<abbr title="Required">*</abbr></label>
				<input type="text" class="form-control" name="month" value="" disabled>
			</div>
			<div class="form-group">
				<label for="campaign_id" class="required control-label">Ajusted Units<abbr title="Required">*</abbr></label>
				<input type="text" class="form-control"  placeholder="Enter ajusted units" name="adjusted_units" value="">
			</div>
			<div class="form-group">
				<label for="comment" class="required control-label">Comment</label>
				<input type="text" class="form-control" placeholder="Enter comment" name="comment" value="">
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
	<table id="summaryTable"	class="table table-bordered table-striped table-hover">
		<thead>
			<tr>
				<th class="buttons" colspan="5">
					<p>The summary at the IO Order level</p>
				</th>
			</tr>
			<tr>				
				<th class="col-md-2">IO Number<br/>IO Revision Date<br/>IO Order<br/></th>
				<th class="col-md-4">Advertiser<br/>Campaign Name<br/>Agency</th>
				<th class="col-md-2">Delivered Units</th>
				<th class="col-md-2">Invoice Amount</th>
				<th class="col-md-2">Total Amount Invoiced Upto Month</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<table id="detailTable"	class="table table-bordered table-striped table-hover">
		<thead>
			<tr>
				<th class="buttons" colspan="5">
					<p>The detail at the IO Line Item level</p>
				</th>
			</tr>
			<tr>				
				<th>Combined IDs</th>
				<th>Campaign ID</th>
				<th>Billing Contact</th>
				<th>Adjusted Units</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
</div>
<script>

	/////////////////////////
	// Load list of month
	/////////////////////////
	generateBillingMonthListDropDown({
		p_select_object: $('#selectbox-month_sk'),
		success: function(){
			loadIoOrders.action();
		},
		change: function(){
	 		loadIoOrders.action();
	 		loadIoLineItems.clearList();			
		}
	});
	
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
				actions: 'loadListIoOrders',
				p_month_since_2005: $('#selectbox-month_sk').val()
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
				p_month_since_2005: $('#selectbox-month_sk').val(),
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
	var data=[];
	
	function applyControlPanel(){
		//verify input 
		if(loadIoOrders.getID().length==0){
			alert("Please select IO Orders!");
			return false;
		}else if(loadIoLineItems.getID().length==0){
			alert("Please select IO Line Items!");
			return false;
		}
		//hide modal
		$('#myModal').modal('hide');
		//get input
		var p_month_since_2005=$('#selectbox-month_sk').val();
		var p_io_orders=loadIoOrders.getID().join(",");
		var p_io_line_items=loadIoLineItems.getID().join(",");
		// Load summary table
		loadBillingSummaryTable({
			p_month_since_2005 : p_month_since_2005,
			p_io_orders: p_io_orders,
			p_io_line_items: p_io_line_items,
			obj_table: $('#summaryTable'),
			success: function(){
				
			}
		});
		// Load detail table
		$.ajax({
			url : rootPath_Biiling,
			dataType : 'json',
			data : {
				actions: 'loadBillingDetail',
				data: 'json',
				p_month_since_2005: p_month_since_2005,
				p_io_orders: p_io_orders,
				p_io_line_items: p_io_line_items
			},
			success : function(json) {
				data = json;
				setTableData(data);
			}
		});
		function setTableData(data) {
			var i = 0;
			var rows = [];
			for (var i = 0; i < data.length; i++) {
				var combined_ids = data[i].combined_ids;
				var campaign_id=data[i].campaign_id;
				var billing_contact=data[i].billing_contact;
				var adjusted_units=data[i].adjusted_units;
				var information_control=data[i].information_control;
				var adjusted_units_control=data[i].adjusted_units_control;
				
				var row = '<tr>' 
						+ '<td>' + combined_ids +'</td>' 
						+ '<td>' + campaign_id + '</td>'
						+ '<td>' + billing_contact + '</td>' 
						+ '<td>' + adjusted_units + '</td>'
						+ '<td><div class="btn-toolbar">';
						
				if(information_control=='add'){
					row +='<button title="" data-toggle="modal" data-target="#addInformationDialog" type="button" class="btn btn-success btn-xs" onclick="loadInfomationAddForm('+i+');">  <span class="glyphicon glyphicon-plus"></span> Information</button>';
				}else if(information_control=='edit'){
					row +='<button type="button" data-toggle="modal" data-target="#editInformationDialog" class="btn btn-info btn-xs" onclick="loadInfomationEditForm('+i+');">  <span class="glyphicon glyphicon-edit"></span> Information</button>';
				}
				
				if(adjusted_units_control=='add'){
					row +='<button type="button" data-toggle="modal" data-target="#addAdjustedUnitDialog" class="btn btn-success btn-xs" onclick="loadAdjustedAddForm('+i+');">  <span class="glyphicon glyphicon-plus"></span> Adjusted Units</button>';
				}else if(adjusted_units_control=='edit'){
					row +='<button type="button" data-toggle="modal" data-target="#updateAdjustedUnitDialog" class="btn btn-info btn-xs" onclick="loadAdjustedUpdateForm('+i+');">  <span class="glyphicon glyphicon-edit"></span> Adjusted Units</button>';
				}
					row+='</div></td></tr>' ;
					
				rows.push(row);
			}
			var htmlTable = rows.join("");
			//console.log(htmlTable);
			$('#detailTable tbody').empty();
			$('#detailTable tbody').append(htmlTable);
		}		
	}
	///////////////////////////////////
	// load information edit form
	//////////////////////////////////
	function loadInfomationEditForm(row){
		var combined_ids = data[row].combined_ids;
		var io_line_item_name=data[row].io_line_item_name;
		var campaign_id=data[row].campaign_id;
		var billing_contact=data[row].billing_contact;	
		var p_io_orders_id=combined_ids.split("-")[0];
		var p_io_line_item_id=combined_ids.split("-")[1];
		
		$('#editInformationForm input[name=p_io_orders_id]').val(p_io_orders_id);
		$('#editInformationForm input[name=p_io_line_item_id]').val(p_io_line_item_id);
		$('#editInformationForm input[name=campaign_id]').val(campaign_id);
		$('#editInformationForm input[name=billing_contact]').val(billing_contact);	
		$('#editInformationForm input[name=selectbox-combined_ids]').val(combined_ids+" | "+io_line_item_name);
	}
	///////////////////////////////////
	// load information add form
	//////////////////////////////////
	function loadInfomationAddForm(row){
		var combined_ids = data[row].combined_ids;
		var io_line_item_name=data[row].io_line_item_name;
		var campaign_id=data[row].campaign_id;
		var billing_contact=data[row].billing_contact;	
		var p_io_orders_id=combined_ids.split("-")[0];
		var p_io_line_item_id=combined_ids.split("-")[1];
		
		$('#addInformationForm input[name=p_io_orders_id]').val(p_io_orders_id);
		$('#addInformationForm input[name=p_io_line_item_id]').val(p_io_line_item_id);
		$('#addInformationForm input[name=campaign_id]').val(campaign_id);
		$('#addInformationForm input[name=billing_contact]').val(billing_contact);	
		$('#addInformationForm input[name=selectbox-combined_ids]').val(combined_ids+" | "+io_line_item_name);
		$('#addInformationForm input[name=comment]').val('');
	}
	/////////////////////////////////////
	// Update information
	/////////////////////////////////////
	function billingUpdateInformation(){
		updateInfomation({
			p_combined_ids: $('#editInformationForm input[name=selectbox-combined_ids]').val(),
			p_io_orders_id: $('#editInformationForm input[name=p_io_orders_id]').val(),
			p_io_line_item_id: $('#editInformationForm input[name=p_io_line_item_id]').val(),
			p_campaign_id: $('#editInformationForm input[name=campaign_id]').val(),
			p_billing_contact: $('#editInformationForm input[name=billing_contact]').val(),
			p_comment: '',
			success: function(data){
				$('#editInformationDialog').modal('hide');
				applyControlPanel();
				//var msg=data[0].fn_ba_national_dim_io_update;
				//alert(msg);
			}
		});
	}
	/////////////////////////////////////
	// Add information
	/////////////////////////////////////
	function billingAddInformation(){
		addInfomation({
			p_combined_ids: $('#addInformationForm input[name=selectbox-combined_ids]').val(),
			p_io_orders_id: $('#addInformationForm input[name=p_io_orders_id]').val(),
			p_io_line_item_id: $('#addInformationForm input[name=p_io_line_item_id]').val(),
			p_campaign_id: $('#addInformationForm input[name=campaign_id]').val(),
			p_billing_contact: $('#addInformationForm input[name=billing_contact]').val(),
			p_comment: $('#addInformationForm input[name=comment]').val(),
			success: function(data){
				$('#addInformationDialog').modal('hide');
				applyControlPanel();
				//var msg=data[0].fn_ba_national_dim_io_update;
				//alert(msg);
			}
		});
	}
	
	///////////////////////////////////
	// load adjusted add form
	//////////////////////////////////	
	function loadAdjustedAddForm(row){
		var combined_ids = data[row].combined_ids;
		var io_line_item_name=data[row].io_line_item_name;
		var month_since_2005=data[row].month_since_2005;
		var calendar_year_month=data[row].calendar_year_month;
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
	function billingAddAjustedUnits(){
		addAjustedUnits({
			p_combined_ids: $('#addAdjustedUnitForm input[name=selectbox-combined_ids]').val(),
			p_io_orders_id: $('#addAdjustedUnitForm input[name=p_io_orders_id]').val(),
			p_io_line_item_id: $('#addAdjustedUnitForm input[name=p_io_line_item_id]').val(),
			p_adjusted_units: $('#addAdjustedUnitForm input[name=adjusted_units]').val(),
			p_month_sk: $('#addAdjustedUnitForm input[name=p_month_sk]').val(),
			p_comment: $('#addAdjustedUnitForm input[name=comment]').val(),
			success: function(data){
				$('#addAdjustedUnitDialog').modal('hide');
				applyControlPanel();
				//var msg=data[0].fn_ba_national_dim_io_update;
				//alert(msg);
			}
		});
	}
	///////////////////////////////////
	// load adjusted update form
	//////////////////////////////////	
	function loadAdjustedUpdateForm(row){
		var combined_ids = data[row].combined_ids;
		var io_line_item_name=data[row].io_line_item_name;
		var month_since_2005=data[row].month_since_2005;
		var calendar_year_month=data[row].calendar_year_month;
		var p_io_orders_id=combined_ids.split("-")[0];
		var p_io_line_item_id=combined_ids.split("-")[1];
		var p_adjusted_units=data[row].adjusted_units;
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
		updateAdjustedUnits({
			p_combined_ids: $('#updateAdjustedUnitForm input[name=selectbox-combined_ids]').val(),
			p_io_orders_id: $('#updateAdjustedUnitForm input[name=p_io_orders_id]').val(),
			p_io_line_item_id: $('#updateAdjustedUnitForm input[name=p_io_line_item_id]').val(),
			p_adjusted_units: $('#updateAdjustedUnitForm input[name=adjusted_units]').val(),
			p_month_sk: $('#updateAdjustedUnitForm input[name=p_month_sk]').val(),
			p_comment: $('#updateAdjustedUnitForm input[name=comment]').val(),
			success: function(data){
				$('#updateAdjustedUnitDialog').modal('hide');
				applyControlPanel();
				//var msg=data[0].fn_ba_national_dim_io_update;
				//alert(msg);
			}		
		});
	}
</script>