var dataTableSummary=[];
var dataTableDetail=[];
//////////////////////////////////////////////
// Load list month of billing - select option
///////////////////////////////////////////////
function generateBillingMonthListDropDown(input){
	this.input = $.extend({}, {
		p_select_object : '',		
		success : function() {
		},
		change: function(){			
		}
	}, input);
	var request = $.ajax({
		url : rootPath_Biiling,
		type: "POST",
		dataType : 'json',
		data:{
			actions: 'loadListMonths',
			data: 'json'
		}
	});
 	request.done(function(data){
 		var resultData=data;
 		var myData= [];
		$.each(resultData,function(index,item){	
			var option='<option value="'+item.month_since_2005+'">'+item.calendar_year_month+'</option>';
			input.p_select_object.append(option);
		});		
		input.success();
 	});
 	input.p_select_object.change(function(){
 		input.change();
 	});	
}

/////////////////////////////////////////////
// Load summary table
/////////////////////////////////////////////

function loadBillingSummaryTable(input){
	input = $.extend({}, {
		p_month_since_2005 : '',
		p_io_orders: '',
		p_io_line_items: '',
		obj_table: '',
		success : function() {
		}
	}, input);
	
	$.ajax({
		url : rootPath_Biiling,
		dataType : 'json',
		data : {
			actions: 'loadBillingSummary',
			data: 'json',
			p_month_since_2005: input.p_month_since_2005,
			p_io_orders: input.p_io_orders,
			p_io_line_items: input.p_io_line_items
		},
		success : function(json) {
			dataTableSummary = json;
			setTableData(dataTableSummary);
			input.success();
		}
	});
	function setTableData(data) {
		var i = 0;
		var rows = [];
		for (var i = 0; i < data.length; i++) {
			var io_number = data[i].io_number;
			var io_orders_id=data[i].io_orders_id;
			var io_revision_date=data[i].io_revision_date;
			var advertiser=data[i].advertiser;
			var campaign_name=data[i].campaign_name;
			var agency=data[i].agency;
			var delivered_units=data[i].delivered_units;
			var invoice_amount=data[i].invoice_amount;
			var total_amount_invoiced_upto_month=data[i].total_amount_invoiced_upto_month;
			
			var row = '<tr>' 
					+ '<td><b>' + io_orders_id + '</b><br/><i>' + io_number + '</i><br/>' + io_revision_date + '</td>' 
					+ '<td><b>' + campaign_name + '</b><br/><i>' + advertiser + '</i><br/>' + agency + '</td>' 
					+ '<td align="right">' + accounting.formatNumber(delivered_units) + '</td>' 
					+ '<td align="right">' + accounting.formatMoney(invoice_amount) + '</td>'
					+ '<td align="right">' + accounting.formatMoney(total_amount_invoiced_upto_month) + '</td>'
					+ '</tr>';
				
			rows.push(row);
		}
		var htmlTable = rows.join("");
		//console.log(htmlTable);
		input.obj_table.find('tbody').empty();
		input.obj_table.find('tbody').append(htmlTable);
	}		
}

/////////////////////////////////////////////
//Load detail table
/////////////////////////////////////////////

function loadBillingDetailTable(input){
	input = $.extend({}, {
		p_month_since_2005 : '',
		p_io_orders: '',
		p_io_line_items: '',
		obj_table: '',
		success : function() {
		}
	}, input);
	
	$.ajax({
		url : rootPath_Biiling,
		dataType : 'json',
		data : {
			actions: 'loadBillingDetailTable',
			data: 'json',
			p_month_since_2005: input.p_month_since_2005,
			p_io_orders: input.p_io_orders,
			p_io_line_items: input.p_io_line_items
		},
		success : function(json) {
			dataTableDetail = json;
			setTableData(dataTableDetail);
			input.success();
		}
	});
	function setTableData(data) {
		var i = 0;
		var rows = [];
		for (var i = 0; i < data.length; i++) {
			var month_since_2005=data[i].month_since_2005;
			var io_orders_id=data[i].io_orders_id;
			var io_line_item_id=data[i].io_line_item_id;
			var io_line_item_start_date=data[i].io_line_item_start_date;
			var io_line_item_end_date=data[i].io_line_item_end_date;
			var combined_ids = data[i].combined_ids;
			var placement_group = data[i].placement_group;
			var placement_id = data[i].placement_id;
			var campaign_id=data[i].campaign_id;
			var billing_contact=data[i].billing_contact;
			var adjusted_units=data[i].adjusted_units;
			var information_control=data[i].information_control;
			var adjusted_units_control=data[i].adjusted_units_control;
			
			var start_date = new Date(io_line_item_start_date).format('mmm dd, yyyy');
			var end_date = new Date(io_line_item_end_date).format('mmm dd, yyyy'); 
			var placement_group_truncated = placement_group;
			if (placement_group.length > 30) {
				placement_group_truncated = placement_group.substring(0, 50) + '...';
			}
			
			
			var row = '<tr>' 
					+ '<td><a href="#" onclick="showBillingDetail('+month_since_2005+','+io_orders_id+','+io_line_item_id+')">' + combined_ids + ' | ' + start_date + ' - ' + end_date +'</a><br/><i>'+placement_group_truncated+'</i></td>' 
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
		input.obj_table.find('tbody').empty();
		input.obj_table.find('tbody').append(htmlTable);
	}	
}

////////////////////////////////////
// Load Billing Detail
///////////////////////////////////
function loadBillingDetail(input){
	input = $.extend({}, {
		p_month_since_2005 : '',
		p_io_order_id: '',
		p_io_line_item_id: '',
		success : function(content) {
		}
	}, input);
	
	$.ajax({
		url : rootPath_Biiling,
		dataType : 'html',
		data : {
			actions: 'LoadBillingDetail',
			data: 'html',
			p_month_since_2005: input.p_month_since_2005,
			p_io_order_id: input.p_io_order_id,
			p_io_line_item_id: input.p_io_line_item_id
		},
		success : function(html) {			
			input.success(html);
		}
	});	
}

//////////////////////////////////
// Export report
/////////////////////////////////
function exportNationalBillingReport(input){
	input = $.extend({}, {
		p_export_output: 'html',
		p_month_since_2005 : '',
		p_io_orders: '',
		p_io_line_items: ''		
	}, input);
	var urlExport=rootPath_Biiling
					+'&actions=export'
					+'&p_export_output='+input.p_export_output
					+'&p_month_since_2005='+input.p_month_since_2005
					+'&p_io_orders='+input.p_io_orders
					+'&p_io_line_items='+input.p_io_line_items;
	window.open(urlExport);
	
};