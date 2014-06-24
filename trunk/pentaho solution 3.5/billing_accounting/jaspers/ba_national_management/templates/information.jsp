<style>

</style>
<script>
//Set locate
	urlMaster.clear();
	urlMaster.replaceParam('page','information_script');
	urlMaster.replaceParam('actionPath','information_management');
	activeTab('Information');
</script>

	<!-- Table -->
	<div class="breadcrumbs">
		<a href="#" onclick="goHomePage()">
		<i class="icon-home"></i>
		Home
		</a>
		<span class="separator">/</span> 
		<a class="first item-0" href="#" onclick="goInformationPage()">Information</a> 
	</div>
	<table id="mainDataTable" class="table table-bordered table-striped table-hover">
		<thead>
			<tr>
				<th class="buttons" colspan="4">
				<a class="btn btn-success" href="#" onclick="showAddInfomationForm();"><i class="icon-plus icon-white" ></i>
				Add Information
				</a>
				</th>
			</tr>
			<tr>				
				<th  class="col-md-4">IO Order ID</th>
				<th  class="col-md-3">Campaign ID</th>
				<th  class="col-md-3">Billing Contact</th>
				<th  class="col-md-2"></th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>

<script>
	var dataTableInformation = [];
	$.ajax({
		url : rootPath_Information,
		dataType : 'json',
		data : {
			actions: 'loadInfomationTable',
			data: 'json'
		},
		success : function(json) {
			dataTableInformation = json;
			setTableData(dataTableInformation);
		}
	});
	function setTableData(data) {
		var i = 0;
		var rows = [];
		for (var i = 0; i < data.length; i++) {
			var io_orders_id    = dataTableInformation[i].io_orders_id;
			var displayed_name  = dataTableInformation[i].displayed_name;
			var campaign_id     = dataTableInformation[i].campaign_id;
			var billing_contact = dataTableInformation[i].billing_contact;			
			
			var row = '<tr>' 
					+ '<td><a href="#" onclick="showDetail('+io_orders_id+','+i+')">' + displayed_name + '</a></td>' 
					+ '<td>' + campaign_id + '</td>'
					+ '<td>' + billing_contact + '</td>' 
					+ '<td><div class="btn-toolbar"><button type="button" class="btn btn-info btn-xs" onclick="loadEditForm('+i+');">  <span class="glyphicon glyphicon-edit"></span> Edit</button><button type="button" class="btn btn-success btn-xs" onclick="loadAddForm('+i+');">  <span class="glyphicon glyphicon-share"></span> Copy</button></div></td>' 
					+ '</tr>';
			rows.push(row);
		}
		var htmlTable = rows.join("");
		//console.log(htmlTable);
		$('#mainDataTable tbody').empty();
		$('#mainDataTable tbody').append(htmlTable);
	}
	function showAddInfomationForm(){
		urlMaster.replaceParam('page','add_infomation_form');
		loadPage();		
	}
	function loadEditForm(row){
		var io_orders_id    = dataTableInformation[row].io_orders_id;
		var displayed_name  = dataTableInformation[row].displayed_name;
		var campaign_id     = dataTableInformation[row].campaign_id;
		var billing_contact = dataTableInformation[row].billing_contact;	
		var comment         = dataTableInformation[row].comment;				
		//load edit form
		$('#summary-content div.content').load(rootPath_Information,{
			actions: 'edit_infomation_form',
			p_io_orders_id: io_orders_id,
			p_displayed_name: displayed_name,
			p_campaign_id: campaign_id,
			p_billing_contact: billing_contact,
			p_comment: comment
		},function(){
		
		});
	}
	function loadAddForm(row){
		var campaign_id=dataTableInformation[row].campaign_id;
		var billing_contact=dataTableInformation[row].billing_contact;				
		//load add form
		$('#summary-content div.content').load(rootPath_Information,{
			actions: 'add_infomation_form',
			p_campaign_id: campaign_id,
			p_billing_contact: billing_contact
		},function(){
		
		});
	}
	///////////////////////////
	// View detail
	///////////////////////////
	function showDetail(order_id,row){
		urlMaster.replaceParam('p_io_orders_id',order_id);
		urlMaster.replaceParam('ac','detail');
		loadInformationDetailPage({
			p_io_orders_id: order_id,
			p_row: row,
			success: function(html){
				$('#summary-content div.content').empty();
				$('#summary-content div.content').append(html);
			}
		});
	}
	
	function loadEditFormInDetailPage(io_orders_id,displayed_name,campaign_id,billing_contact,comment){		
		alert(displayed_name);
		//load edit form
		$('#summary-content div.content').load(rootPath_Information,{
			actions: 'edit_infomation_form',
			p_io_orders_id: io_orders_id,
			p_displayed_name: displayed_name,
			p_campaign_id: campaign_id,
			p_billing_contact: billing_contact,
			p_comment: comment
		},function(){
		
		});
	}
</script>