<style>
tr.selected{
background: #F8F8F8;
}

table thead th.buttons {
background-color: #e7e7e7;
background-image: -moz-linear-gradient(top, #eeeeee, #dddddd);
background-image: -webkit-gradient(linear, 0 0, 0 100%, from(#eeeeee), to(#dddddd));
/* background-image: -webkit-linear-gradient(top, #eeeeee, #dddddd); */
background-image: -o-linear-gradient(top, #eeeeee, #dddddd);
/* background-image: linear-gradient(to bottom, #eeeeee, #dddddd); */
/* background-repeat: repeat-x; */
filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#ffeeeeee', endColorstr='#ffdddddd', GradientType=0);
border-bottom: 1px solid #ccc;
}
</style>
	<!-- Table -->
	<div class="breadcrumbs">
		<a href="#" onclick="goHomePage()">
		<i class="icon-home"></i>
		Home
		</a>
		<span class="separator">/</span> 
		<a class="first item-0" href="#" onclick="goHomePage()">Information</a> 
	</div>
	<table id="mainDataTable"		class="table table-bordered table-hover table-responsive">
		<thead>
			<tr>
				<th class="buttons" colspan="4">
				<a class="btn btn-success" href="#" onclick="showAddInfomationForm();"><i class="icon-plus icon-white" ></i>
				Add Information
				</a>
				</th>
			</tr>
			<tr>				
				<th>Combine IDs</th>
				<th>Campain ID</th>
				<th>Billing Contact</th>
				<th></th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>

<script>

	//Load invoice data
	urlMaster.replaceParam('page','information_script');
	urlMaster.replaceParam('actionPath','information_management');
	var data = [];
	$.ajax({
		url : rootPath_Information + '&actions=loadInfomationTable&data=json',
		dataType : 'json',
		data : data,
		success : function(json) {
			data = json;
			setTableData(data);
		}
	});
	function setTableData(data) {
		var i = 0;
		var rows = [];
		for (var i = 0; i < data.length; i++) {
			var urlLoadContentDetail = rootPath_Information	+ '&actions=invoiceDetail&p_inv_detail_id=' + data[i].id;
			var combine_ids = data[i].combine_ids;
			var io_line_item_name=data[i].io_line_item_name;
			var campaign_id=data[i].campaign_id;
			var billing_contact=data[i].billing_contact;			
			
			var row = '<tr>' 
					+ '<td>' + combine_ids +' | '+ io_line_item_name+'</td>' 
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
		var combine_ids = data[row].combine_ids;
		var io_line_item_name=data[row].io_line_item_name;
		var campaign_id=data[row].campaign_id;
		var billing_contact=data[row].billing_contact;	
		var p_io_orders_id=combine_ids.split("-")[0];
		var p_io_line_item_id=combine_ids.split("-")[1];
		var comment=data[row].comment;				
		//load edit form
		$('#summary-content div.content').load(rootPath_Information,{
			actions: 'edit_infomation_form',
			p_io_orders_id: p_io_orders_id,
			p_io_line_item_id: p_io_line_item_id,
			p_io_line_item_name: io_line_item_name,
			p_campaign_id: campaign_id,
			p_billing_contact: billing_contact,
			p_comment: comment
		},function(){
		
		});
	}
	function loadAddForm(row){
		var combine_ids = data[row].combine_ids;
		var io_line_item_name=data[row].io_line_item_name;
		var campaign_id=data[row].campaign_id;
		var billing_contact=data[row].billing_contact;	
		var p_io_orders_id=combine_ids.split("-")[0];
		var p_io_line_item_id=combine_ids.split("-")[1];
		var comment=data[row].comment;				
		//load add form
		$('#summary-content div.content').load(rootPath_Information,{
			actions: 'add_infomation_form',
			p_campaign_id: campaign_id,
			p_billing_contact: billing_contact
		},function(){
		
		});
	}
</script>