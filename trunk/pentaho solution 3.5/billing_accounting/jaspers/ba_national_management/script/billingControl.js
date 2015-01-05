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
		url : rootPath_Billing,
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
		url : rootPath_Billing,
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
		is_monthly: 'true',
		success : function() {
		}
	}, input);
	
	$.ajax({
		url : rootPath_Billing,
		cache : false,
		dataType : 'json',
		data : {
			actions: 'loadBillingDetailTable',
			data: 'json',
			p_month_since_2005: input.p_month_since_2005,
			p_io_orders: input.p_io_orders,
			p_io_line_items: input.p_io_line_items,
			is_monthly: input.is_monthly
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
		var current_io_orders_id = '';
		var rowSummary = '';
		var rowDetail = '';
		var total_booking_units = 0;
		var total_booking_amount = 0;
		var total_billable_units = 0;
		var total_amount_invoiced_to_date = 0;
		var total_remaining_units = 0;
		var total_remaining_budget = 0;
		var total_billable_units_to_date = 0;
		var total_billable_remaining_units=0;
		
		if (data.length > 0){
			current_io_orders_id = data[0].io_orders_id;
		}
		
		for (var i = 0; i < data.length; i++) {
			var month_since_2005        = data[i].month_since_2005;
			var io_number               = data[i].io_number;
			var io_revision_date        = data[i].io_revision_date;
			var io_orders_id            = data[i].io_orders_id;
			var io_line_item_id         = data[i].io_line_item_id;
			var io_line_item_start_date = data[i].io_line_item_start_date;
			var io_line_item_end_date   = data[i].io_line_item_end_date;
			var advertiser              = data[i].advertiser;
			var campaign_id             = data[i].campaign_id;
			var campaign_name           = data[i].campaign_name;
			var agency                  = data[i].agency;
			var billing_contact         = data[i].billing_contact;
			var comment                 = data[i].comment;
			var combined_ids            = data[i].combined_ids;
			var placement_group         = data[i].placement_group;
			var placement_id            = data[i].placement_id;
			var rate_type               = data[i].rate_type;
			var rate                    = data[i].rate;
			var planned_units           = data[i].planned_units;
			var contracted_budget       = data[i].contracted_budget;
			var dfp_delivered_imps      = data[i].dfp_delivered_imps;
			var dfp_delivered_clicks    = data[i].dfp_delivered_clicks;
			var dfa_delivered_imps      = data[i].dfa_delivered_imps;
			var dfa_delivered_clicks    = data[i].dfa_delivered_clicks;
			var adjusted_units          = data[i].adjusted_units;
			var delivered_units         = data[i].delivered_units;
			var remaining_units         = data[i].remaining_units;
			var billable_units          = data[i].billable_units;
			var invoice_amount          = data[i].invoice_amount;
			var amount_invoiced_to_date = data[i].amount_invoiced_to_date;
			var remaining_budget        = data[i].remaining_budget;
			var information_control     = data[i].information_control;
			var adjusted_units_control  = data[i].adjusted_units_control;
			var billable_units_to_date  = data[i].billable_units_to_date;
			var billable_remaining_units= data[i].billable_remaining_units;
			
			total_booking_units           += parseInt(planned_units);
			total_booking_amount          += parseFloat(contracted_budget);
			total_billable_units          += parseInt(billable_units);
			total_amount_invoiced_to_date += parseFloat(amount_invoiced_to_date);
			total_remaining_budget        += parseFloat(remaining_budget);
			total_remaining_units         += parseInt(remaining_units);
			total_billable_units_to_date  += parseInt(billable_units_to_date);
			total_billable_remaining_units+= parseInt(billable_remaining_units);
			
			var revision_date = verveDateConvert(io_revision_date).format('mmm dd, yyyy');
			var start_date = verveDateConvert(io_line_item_start_date).format('mmm dd');
			var end_date = verveDateConvert(io_line_item_end_date).format('mmm dd'); 
			var placement_group_truncated = placement_group;
			if (placement_group.length > 45) {
				placement_group_truncated = placement_group.substring(0, 45) + '...';
			}
			
			if (adjusted_units != 'null'){
				accounting.formatNumber(adjusted_units)
			}
			
			var detail = '';
			detail += '<tr class="class' + io_orders_id + '" style="display: none;">';
			detail += '<td colspan="2"><a href="#" onclick="showBillingDetail(' + month_since_2005 + ',' + io_orders_id + ',' + io_line_item_id + ')">#' + combined_ids + ' | ' + start_date + ' - ' + end_date + '</a><br/><i class="muted">' + placement_group_truncated + '</i></td>';
			detail += '<td colspan="2">' + accounting.formatMoney(contracted_budget) + '&nbsp;&nbsp;' + accounting.formatNumber(planned_units) + '<br/><span class="muted">' + accounting.formatMoney(rate) + ' ' + rate_type + '</span></td>';
			detail += '<td align="right">' + accounting.formatNumber(dfp_delivered_imps) + ' imps<br/>' + accounting.formatNumber(dfp_delivered_clicks) + ' clicks</td>';
			detail += '<td align="right">' + accounting.formatNumber(dfa_delivered_imps) + ' imps<br/>' + accounting.formatNumber(dfa_delivered_clicks) + ' clicks</td>';
		    detail += '<td align="right">' + accounting.formatNumber(adjusted_units);
			console.log(adjusted_units_control);
			if(adjusted_units_control=='add'){
				detail += '<button type="button" data-toggle="modal" data-target="#addAdjustedUnitDialog" class="btn btn-success btn-xs" style="float: left;" title="Add" onclick="loadAdjustedAddForm('+i+');"><span class="glyphicon glyphicon-plus"></span></button>';
			}else if(adjusted_units_control=='edit'){
				detail += '<div class="btn-group-vertical" style="float: left;"><button type="button" data-toggle="modal" data-target="#updateAdjustedUnitDialog" class="btn btn-primary btn-xs" title="Edit" onclick="loadAdjustedUpdateForm('+i+');"><span class="glyphicon glyphicon-edit"></span></button></div>';
			}
			detail += '</td>';
			detail += '<td align="right">' + accounting.formatNumber(billable_units) + '</td>';
			detail += '<td align="right">' + accounting.formatMoney(invoice_amount) + '</td>';
			detail += '<td align="right">' + accounting.formatNumber(billable_units_to_date) + '</td>';
			detail += '<td align="right">' + accounting.formatMoney(amount_invoiced_to_date) + '</td>';
			detail += '<td align="right">' + accounting.formatMoney(remaining_budget) + '<br/>' + accounting.formatNumber(billable_remaining_units) + '</td>';
			detail += '</tr>';
			
			if (current_io_orders_id != io_orders_id){			
				rows.push(rowSummary);
				rows.push(rowDetail);
				rowDetail = detail;
				
				current_io_orders_id = io_orders_id;
				
				total_booking_units           = parseInt(planned_units);
				total_booking_amount          = parseFloat(contracted_budget);
				total_billable_units          = parseInt(billable_units);
				total_amount_invoiced_to_date = parseFloat(amount_invoiced_to_date);
				total_remaining_budget        = parseFloat(remaining_budget);
				total_remaining_units         = parseInt(remaining_units);
				total_billable_units_to_date  = parseInt(billable_units_to_date);
				total_billable_remaining_units= parseInt(billable_remaining_units);
			} else {
				rowDetail += detail;
			}
			
			rowSummary = '';
			rowSummary += '<tr class="summary">';
			rowSummary += '<td colspan="2"><b><a href="#" onclick="showDetail(' + io_orders_id + ');">#' + io_orders_id + '</a></b><br/><i class="muted">#' + io_number + '</i><br/>' + revision_date + '</td>';
			rowSummary += '<td colspan="3"><b>' + campaign_name + '</b><br/><i class="muted">' + advertiser + '</i><br/>' + agency + '</td>';
			rowSummary += '<td colspan="3"><b>' + campaign_id + '</b>';
			if(information_control=='add'){
				rowSummary += '<button title="" data-toggle="modal" data-target="#addInformationDialog" type="button" class="btn btn-success btn-xs" style="float: right;" title="Add" onclick="loadInfomationAddForm('+i+');"><span class="glyphicon glyphicon-plus"></span></button>';
			} else if(information_control=='edit'){
				rowSummary += '<button type="button" data-toggle="modal" data-target="#editInformationDialog" class="btn btn-primary btn-xs" style="float: right;" title="Edit" onclick="loadInfomationEditForm('+i+');"><span class="glyphicon glyphicon-edit"></span></button>';
			}
			rowSummary += '<br/><i class="muted">' + billing_contact + '</i><br/>' + comment + '</td>';
			rowSummary += '<td align="right"><b>' + accounting.formatMoney(total_booking_amount) + '<br/>' + accounting.formatNumber(total_booking_units) + '</b></td>';
			rowSummary += '<td align="right"><b>' + accounting.formatNumber(total_billable_units_to_date) + '</b></td>';
			rowSummary += '<td align="right"><b>' + accounting.formatMoney(total_amount_invoiced_to_date)+ '</b></td>';
			rowSummary += '<td align="right"><b>' + accounting.formatMoney(total_remaining_budget) + '<br/>'+ accounting.formatNumber(total_billable_remaining_units) + '</b></td>';
			rowSummary += '</tr>';
			rowSummary += '<tr class="class' + io_orders_id + '" style="display: none;">';
			rowSummary += '<td colspan="2"><b>IO Line Item</b></td>';
			rowSummary += '<td colspan="2"><b>Booking</b></td>';
			rowSummary += '<td align="right"><b>DFP Delivered</b></td>';
			rowSummary += '<td align="right"><b>3rd Party Delivered</b></td>';
			rowSummary += '<td align="right"><b>Adjusted Units</b></td>';
			rowSummary += '<td align="right"><b>Billable Units</b></td>';
			rowSummary += '<td align="right"><b>Amount Inv.</b></td>';
			rowSummary += '<td align="right"><b>Units Inv. ToDate</b></td>';
			rowSummary += '<td align="right"><b>Amount Inv. ToDate</b></td>';
			rowSummary += '<td align="right"><b>Remaining Balance</b></td>';
			rowSummary += '</tr>';
		}
				
		rows.push(rowSummary);
		rows.push(rowDetail);

		var htmlTable = rows.join("");
		//console.log(htmlTable);
//		input.obj_table.find('tbody').empty();
		input.obj_table.find('tbody').html(htmlTable);
		$('a').click(function(event){
			console.log();
			if($(this).attr('href')=='#'){
				event.preventDefault();
			}
		});
	}	
}

/////////////////////////////////////////////
//Load detail table in multiple month 
/////////////////////////////////////////////

function loadBillingDetailTableInMultipleMonth(input){
	input = $.extend({}, {
		p_month_since_2005 : '',
		p_io_orders: '',
		p_io_line_items: '',
		obj_table: '',
		success : function() {
		}
	}, input);
	
	$.ajax({
		url : rootPath_Billing,
		dataType : 'json',
		cache : false,
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
		var order_id_key=[];
		var order_id_month_key=[];

		var pre_order_id=0;
		var pre_order_id_month=0;
		
		for (var i = 0; i < data.length; i++) {
			var month_since_2005        = data[i].month_since_2005;
			var calendar_year_month		= data[i].calendar_year_month;
			var io_number               = data[i].io_number;
			var io_revision_date        = data[i].io_revision_date;
			var io_orders_id            = data[i].io_orders_id;
			var io_line_item_id         = data[i].io_line_item_id;
			var io_line_item_start_date = data[i].io_line_item_start_date;
			var io_line_item_end_date   = data[i].io_line_item_end_date;
			var advertiser              = data[i].advertiser;
			var campaign_id             = data[i].campaign_id;
			var campaign_name           = data[i].campaign_name;
			var agency                  = data[i].agency;
			var billing_contact         = data[i].billing_contact;
			var comment                 = data[i].comment;
			var combined_ids            = data[i].combined_ids;
			var placement_group         = data[i].placement_group;
			var placement_id            = data[i].placement_id;
			var rate_type               = data[i].rate_type;
			var rate                    = data[i].rate;
			var planned_units           = data[i].planned_units;
			var contracted_budget       = data[i].contracted_budget;
			var dfp_delivered_imps      = data[i].dfp_delivered_imps;
			var dfp_delivered_clicks    = data[i].dfp_delivered_clicks;
			var dfa_delivered_imps      = data[i].dfa_delivered_imps;
			var dfa_delivered_clicks    = data[i].dfa_delivered_clicks;
			var adjusted_units          = data[i].adjusted_units;
			var delivered_units         = data[i].delivered_units;
			var remaining_units         = data[i].remaining_units;
			var billable_units          = data[i].billable_units;
			var invoice_amount          = data[i].invoice_amount;
			var amount_invoiced_to_date = data[i].amount_invoiced_to_date;
			var remaining_budget        = data[i].remaining_budget;
			var information_control     = data[i].information_control;
			var adjusted_units_control  = data[i].adjusted_units_control;
			var billable_units_to_date  = data[i].billable_units_to_date;
			var billable_remaining_units= data[i].billable_remaining_units;
			
			if(pre_order_id != io_orders_id){
				order_id_key.push(io_orders_id);
				pre_order_id=io_orders_id;
			}
			if(pre_order_id_month != io_orders_id + '_' + month_since_2005){
				order_id_month_key.push(io_orders_id + '_' + month_since_2005);
				pre_order_id_month = io_orders_id + '_' + month_since_2005;
			}
			
			var revision_date = verveDateConvert(io_revision_date).format('mmm dd, yyyy');
			var start_date = verveDateConvert(io_line_item_start_date).format('mmm dd');
			var end_date = verveDateConvert(io_line_item_end_date).format('mmm dd'); 
			var placement_group_truncated = placement_group;
			if (placement_group.length > 45) {
				placement_group_truncated = placement_group.substring(0, 45) + '...';
			}
			
			if (adjusted_units != 'null'){
				accounting.formatNumber(adjusted_units)
			}
			
			var detail = '';
			detail += '<tr class="row_' + io_orders_id +'_'+ month_since_2005 + '" row="'+i+'" style="display: none;">';
			detail += '<td colspan="2"><a href="#" onclick="showBillingDetail(' + month_since_2005 + ',' + io_orders_id + ',' + io_line_item_id + ')">#' + combined_ids + ' | ' + start_date + ' - ' + end_date + '</a><br/><i class="muted">' + placement_group_truncated + '</i></td>';
			detail += '<td colspan="2">' + accounting.formatMoney(contracted_budget) + '&nbsp;&nbsp;' + accounting.formatNumber(planned_units) + '<br/><span class="muted">' + accounting.formatMoney(rate) + ' ' + rate_type + '</span></td>';
			detail += '<td align="right">' + accounting.formatNumber(dfp_delivered_imps) + ' imps<br/>' + accounting.formatNumber(dfp_delivered_clicks) + ' clicks</td>';
			detail += '<td align="right">' + accounting.formatNumber(dfa_delivered_imps) + ' imps<br/>' + accounting.formatNumber(dfa_delivered_clicks) + ' clicks</td>';
		    detail += '<td align="right">' + accounting.formatNumber(adjusted_units);
			if(adjusted_units_control=='add'){
				detail += '<button type="button" data-toggle="modal" data-target="#addAdjustedUnitDialog" class="btn btn-success btn-xs" style="float: left;" title="Add" onclick="loadAdjustedAddForm('+i+');"><span class="glyphicon glyphicon-plus"></span></button>';
			}else if(adjusted_units_control=='edit'){
				detail += '<div class="btn-group-vertical" style="float: left;"><button type="button" data-toggle="modal" data-target="#updateAdjustedUnitDialog" class="btn btn-primary btn-xs" title="Edit" onclick="loadAdjustedUpdateForm('+i+');"><span class="glyphicon glyphicon-edit"></span></button></div>';
			}
			detail += '</td>';
			detail += '<td align="right">' + accounting.formatNumber(billable_units) + '</td>';
			detail += '<td align="right">' + accounting.formatMoney(invoice_amount) + '</td>';
			detail += '<td align="right">' + accounting.formatNumber(billable_units_to_date) + '</td>';
			detail += '<td align="right">' + accounting.formatMoney(amount_invoiced_to_date) + '</td>';
			detail += '<td align="right">' + accounting.formatMoney(remaining_budget) + '<br/>' + accounting.formatNumber(billable_remaining_units) + '</td>';
			detail += '</tr>';
						
			rows.push(detail);
			
		}
		
		var htmlTable = rows.join("");
		input.obj_table.find('tbody').html(htmlTable);
		//console.log(order_id_key);
		//console.log(order_id_month_key);
		
		//Insert row group by month
		for(var i = 0; i < order_id_month_key.length; i++){
			var key = order_id_month_key[i];
			var total_booking_units = 0;
			var total_booking_amount = 0;
			var total_billable_units = 0;
			var total_amount_invoiced_to_date = 0;
			var total_remaining_units = 0;
			var total_remaining_budget = 0;
			var total_billable_units_to_date = 0;
			var total_billable_remaining_units=0;
			var calendar_year_month = '';
			var order_id = 0;
			
			$('tr.row_' + key).each(function() {
				var row_index_in_data = $( this ).attr('row');
				
				var row_data = data[row_index_in_data];
				//console.log(JSON.stringify(row_data));
				total_booking_units           += parseInt(row_data.planned_units);
				total_booking_amount          += parseFloat(row_data.contracted_budget);
				total_billable_units          += parseInt(row_data.billable_units);
				total_amount_invoiced_to_date += parseFloat(row_data.amount_invoiced_to_date);
				total_remaining_budget        += parseFloat(row_data.remaining_budget);
				total_remaining_units         += parseInt(row_data.remaining_units);
				total_billable_units_to_date  += parseInt(row_data.billable_units_to_date);
				total_billable_remaining_units+= parseInt(row_data.billable_remaining_units);
				
				calendar_year_month            = row_data.calendar_year_month;
				order_id                       = row_data.io_orders_id;
			});
			
			rowSummaryByMonth = '';
			rowSummaryByMonth += '<tr class="month_summary group_month_'+order_id+'" style="display:none">'+
							'<td colspan="8"><b><a href="#" onclick="showDetailGroupMonth(\''+key+'\')">'+calendar_year_month+'</a></b></td>'+
							'<td align="right"><b>' + accounting.formatMoney(total_booking_amount) + '<br/>' + accounting.formatNumber(total_booking_units) + '</b></td>'+
							'<td align="right"><b>' + accounting.formatNumber(total_billable_units_to_date) + '</b></td>'+
							'<td align="right"><b>' + accounting.formatMoney(total_amount_invoiced_to_date)+ '</b></td>'+
							'<td align="right"><b>' + accounting.formatMoney(total_remaining_budget) + '<br/>'+ accounting.formatNumber(total_billable_remaining_units) + '</b></td>'+
							'</tr>';
			rowSummaryByMonth += '<tr class="row_head_title_' + key + '" style="display:none">';
			rowSummaryByMonth += '<td colspan="2"><b>IO Line Item</b></td>';
			rowSummaryByMonth += '<td colspan="2"><b>Booking</b></td>';
			rowSummaryByMonth += '<td align="right"><b>DFP Delivered</b></td>';
			rowSummaryByMonth += '<td align="right"><b>3rd Party Delivered</b></td>';
			rowSummaryByMonth += '<td align="right"><b>Adjusted Units</b></td>';
			rowSummaryByMonth += '<td align="right"><b>Billable Units</b></td>';
			rowSummaryByMonth += '<td align="right"><b>Amount Inv.</b></td>';
			rowSummaryByMonth += '<td align="right"><b>Units Inv. ToDate</b></td>';
			rowSummaryByMonth += '<td align="right"><b>Amount Inv. ToDate</b></td>';
			rowSummaryByMonth += '<td align="right"><b>Remaining Balance</b></td>';
			rowSummaryByMonth += '</tr>';
			
			var target = 'tr[class=row_'+key+']:first';
			$(target).before(rowSummaryByMonth);
		}
		
		//insert row summay
		$.each(order_id_key,function(index,value){
			var total_booking_units = 0;
			var total_booking_amount = 0;
			var total_billable_units = 0;
			var total_amount_invoiced_to_date = 0;
			var total_remaining_units = 0;
			var total_remaining_budget = 0;
			var total_billable_units_to_date = 0;
			var total_billable_remaining_units=0;
			var io_orders_id;
			var campaign_name;
			var campaign_id;
			var io_number;
			var revision_date;
			var advertiser;
			var agency;
			var billing_contact;
			var comment;
			var revision_date;
			var information_control;
						
			var row_index_in_data=$('tr[class^=row_'+value+']:first').attr('row');
				
			var row_data=data[row_index_in_data];
			//console.log(JSON.stringify(row_data));
			total_booking_units           = parseInt(row_data.planned_units);
			total_booking_amount          = parseFloat(row_data.contracted_budget);
			total_billable_units          = parseInt(row_data.billable_units);
			total_amount_invoiced_to_date = parseFloat(row_data.amount_invoiced_to_date);
			total_remaining_budget        = parseFloat(row_data.remaining_budget);
			total_remaining_units         = parseInt(row_data.remaining_units);
			total_billable_units_to_date  = parseInt(row_data.billable_units_to_date);
			total_billable_remaining_units= parseInt(row_data.billable_remaining_units);
			
			io_orders_id    = row_data.io_orders_id;
			campaign_name   = row_data.campaign_name;
			campaign_id     = row_data.campaign_id;
			revision_date   = row_data.revision_date;
			agency          = row_data.agency;
			billing_contact = row_data.billing_contact;
			advertiser      = row_data.advertiser;
			comment         = row_data.comment;
			io_number       = row_data.io_number;
			revision_date   = verveDateConvert(row_data.io_revision_date).format('mmm dd, yyyy');
			information_control=row_data.information_control;
			console.log(information_control);
			
			rowSummary = '';
			rowSummary += '<tr class="summary">';
			rowSummary += '<td colspan="2"><b><a href="#" onclick="showDetailGroupOrder(' + io_orders_id + ');">#' + io_orders_id + '</a></b><br/><i class="muted">#' + io_number + '</i><br/>' + revision_date + '</td>';
			rowSummary += '<td colspan="3"><b>' + campaign_name + '</b><br/><i class="muted">' + advertiser + '</i><br/>' + agency + '</td>';
			rowSummary += '<td colspan="3"><b>' + campaign_id + '</b>';
			if(information_control=='add'){
				rowSummary += '<button title="" data-toggle="modal" data-target="#addInformationDialog" type="button" class="btn btn-success btn-xs" style="float: right;" title="Add" onclick="loadInfomationAddForm('+row_index_in_data+');"><span class="glyphicon glyphicon-plus"></span></button>';
			} else if(information_control=='edit'){
				rowSummary += '<button type="button" data-toggle="modal" data-target="#editInformationDialog" class="btn btn-primary btn-xs" style="float: right;" title="Edit" onclick="loadInfomationEditForm('+row_index_in_data+');"><span class="glyphicon glyphicon-edit"></span></button>';
			}
			rowSummary += '<br/><i class="muted">' + billing_contact + '</i><br/>' + comment + '</td>';
			
			
			rowSummary += $('tr.group_month_'+value+':first td').get(1).outerHTML;
			rowSummary += $('tr.group_month_'+value+':first td').get(2).outerHTML;
			rowSummary += $('tr.group_month_'+value+':first td').get(3).outerHTML;
			rowSummary += $('tr.group_month_'+value+':first td').get(4).outerHTML;
			rowSummary += '</tr>';
			
			$('tr.group_month_'+io_orders_id+':first').before(rowSummary);
		});
		$('a').click(function(event){
			console.log();
			if($(this).attr('href')=='#'){
				event.preventDefault();
			}
		});
		//console.log(htmlTable);
//		input.obj_table.find('tbody').empty();
		
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
		url : rootPath_Billing,
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
	var urlExport=rootPath_Billing
					+'&actions=export'
					+'&p_export_output='+input.p_export_output
					+'&p_month_since_2005='+input.p_month_since_2005
					+'&p_io_orders='+input.p_io_orders
					+'&p_io_line_items='+input.p_io_line_items;
	window.open(urlExport);
	
};
///////////////////////////////////////////////////////////
// Get data refresh date in Billing MonthToDate aggregate
/////////////////////////////////////////////////////////////
function getRefreshDate(input){
	input = $.extend({}, {	
		p_month_since_2005:'0',	
		success : function(refreshDate) {
		
		}
	}, input);
	$.ajax({
			url : rootPath_Billing,
			dataType : 'json',
			data : {
				actions: 'getRefreshDateInBillingMonthToDate',
				data: 'json',
				p_month_since_2005: input.p_month_since_2005				
			},
			success : function(data) {
				var refreshDate=data[0].end_full_date;
				input.success(refreshDate);
			}
		});		
}