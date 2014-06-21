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
			data = json;
			setTableData(data);
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
					+ '<td>' + io_number+'<br/>'+io_revision_date+'<br/>'+ io_orders_id+'</td>' 
					+ '<td>' + advertiser+'<br/>'+campaign_name+'<br/>'+ agency+'</td>' 
					+ '<td>' + delivered_units + '</td>' 
					+ '<td>' + invoice_amount + '</td>'
					+ '<td>' + total_amount_invoiced_upto_month + '</td>'
					+ '</tr>';
				
			rows.push(row);
		}
		var htmlTable = rows.join("");
		//console.log(htmlTable);
		input.obj_table.find('tbody').empty();
		input.obj_table.find('tbody').append(htmlTable);
	}		
}