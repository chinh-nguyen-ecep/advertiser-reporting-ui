// /////////////////////////
// Add adjusted units
// /////////////////////////
function addAdjustedUnits(input) {
	this.input = $.extend({}, {
		p_combined_ids : '',
		p_io_orders_id : '',
		p_io_line_item_id : '',
		p_adjusted_units : '',
		p_month_sk : '',
		p_comment : '',
		success : function(data) {
		}
	}, input);
	
	if (this.input.p_combined_ids == '' || this.input.p_adjusted_units == ''
			|| this.input.p_month_sk == '') {
		alert("Please fill required fields");
		return false;
	}
	// verify adjusted units input
	if (!$.isNumeric(this.input.p_adjusted_units)) {
		alert("Adjusted units must be a number!");
		return false;
	}
	// call request to insert information
	var request = $.ajax({
		url : rootPath_AdjustedUnits,
		type : "POST",
		data : {
			actions : 'insertAjustedUnits',
			data : 'json',
			p_io_orders_id : this.input.p_io_orders_id,
			p_io_line_item_id : this.input.p_io_line_item_id,
			p_month_sk : this.input.p_month_sk,
			p_adjusted_units : this.input.p_adjusted_units,
			p_comment : this.input.p_comment
		},
		dataType : "json"
	});
	request.done(function(data) {
		input.success(data);
		var msg = data[0].fn_ba_national_dim_adjustment_insert;
		if (msg == 'SUCCESSED') {
			// alert("Edited successfully");
		} else if (msg == 'DUPLICATED') {
			alert("Duplicated information");
		} else {
			alert("Error occur!");
		}
	});

	request.fail(function(jqXHR, textStatus) {
		alert("Request failed: " + textStatus);
	});
	return false;
}

// ////////////////////////////
// Update adjusted units
// ///////////////////////////
function updateAdjustedUnits(input) {
	this.input = $.extend({}, {
		p_combined_ids : '',
		p_io_orders_id : '',
		p_io_line_item_id : '',
		p_adjusted_units : '',
		p_month_sk : '',
		p_comment : '',
		success : function(data) {
		}
	}, input);
	console.log("Update Adjusted Units: " + this.input);
	if (this.input.p_combined_ids == '' || this.input.p_ajusted_units == '' || this.input.p_month_sk == '') {
		alert("Please fill required fields");
		return false;
	}
	// verify adjusted units input
	if (!$.isNumeric(this.input.p_adjusted_units)) {
		alert("Adjusted units must be a number!");
		return false;
	}
	// call request to insert information
	var request = $.ajax({
		url : rootPath_AdjustedUnits,
		type : "POST",
		data : {
			actions : 'updateAjustedUnits',
			data : 'json',
			p_io_orders_id : this.input.p_io_orders_id,
			p_io_line_item_id : this.input.p_io_line_item_id,
			p_month_sk : this.input.p_month_sk,
			p_adjusted_units : this.input.p_adjusted_units,
			p_comment : this.input.p_comment
		},
		dataType : "json"
	});
	request.done(function(data) {
		input.success(data);
		var msg = data[0].fn_ba_national_dim_adjustment_update;
		if (msg == 'SUCCESSED') {
			// alert("Edited successfully");
		} else if (msg == 'DUPLICATED') {
			alert("Duplicated information");
		} else {
			alert("Error occur!");
		}
	});

	request.fail(function(jqXHR, textStatus) {
		alert("Request failed: " + textStatus);
	});
	return false;
}

// ////////////////////////////
// Delete adjusted units
// ///////////////////////////
function deleteAdjustedUnits(input) {
	this.input = $.extend({}, {
		p_io_orders_id : '',
		p_io_line_item_id : '',
		p_month_sk : '',
		p_comment : '',
		success : function(data) {
		}
	}, input);
	//console.log("Update Adjusted Units: " + this.input);
	//console.log("Update Adjusted Units: " + this.input.p_io_orders_id);
	//console.log("Update Adjusted Units: " + this.input.p_io_line_item_id);
	//console.log("Update Adjusted Units: " + this.input.p_month_sk);
	//console.log("Update Adjusted Units: " + this.input.p_comment);
	if (input.p_io_orders_id == '' || input.p_io_line_item_id == '' || input.p_month_sk == '' || input.p_comment == '') {
		alert("Please fill required fields");
		return false;
	}
	// call request to delete adjustment
	var request = $.ajax({
		url : rootPath_AdjustedUnits,
		type : "POST",
		data : {
			actions : 'deleteAjustedUnits',
			data : 'json',
			p_io_orders_id : this.input.p_io_orders_id,
			p_io_line_item_id : this.input.p_io_line_item_id,
			p_month_sk : this.input.p_month_sk,
			p_comment : this.input.p_comment
		},
		dataType : "json"
	});
	request.done(function(data) {
		input.success(data);
		var msg = data[0].fn_ba_national_dim_adjustment_delete;
		if (msg == 'SUCCESSED') {
			// alert("Edited successfully");
		} else if (msg == 'DUPLICATED') {
			alert("Duplicated information");
		} else {
			alert("Error occur!");
		}
	});

	request.fail(function(jqXHR, textStatus) {
		alert("Request failed: " + textStatus);
	});
	return false;
}

var loadAdjustedUnitsRequest=$.ajax({url:rootPath_AdjustedUnits});
/////////////////////////////////
// Load list of adjusted units 
/////////////////////////////////
function loadAdjustedUnits(input){
	input = $.extend({}, {
		p_month_sk : '',
		p_io_line_item_name: '',
		success : function(json) {
		}
	}, input);
	loadAdjustedUnitsRequest.abort();
	loadAdjustedUnitsRequest=$.ajax({
		url : rootPath_AdjustedUnits,
		dataType : 'json',
		data : {
			actions: 'loadListAjustedUnit',
			data: 'json',
			p_month_sk: input.p_month_sk,
			p_io_line_item_name: input.p_io_line_item_name
		},
		success : function(json) {			
			input.success(json);
		}
	});	
}
////////////////////////////////////////
//Load list of month from adjusted dim
////////////////////////////////////////

function loadListMonthAdjustedUnits(input){
	input = $.extend({}, {
		success : function(arrayJson) {
		}
	}, input);

	var request=$.ajax({
		url : rootPath_AdjustedUnits,
		type : "POST",
		dataType : 'json',
		data : {
			actions: 'loadListMonths',
			data: 'json'
		}		
	});
	
	request.done(function(arrayJson) {
		input.success(arrayJson);
	});
	request.fail(function(jqXHR, textStatus) {
		alert("loadListMonthAdjustedUnits - Request failed: " + textStatus);
	});
}

function loadListMonthForAdd(input){
	input = $.extend({}, {
		success : function(arrayJson) {
		}
	}, input);

	var request=$.ajax({
		url : rootPath_AdjustedUnits,
		type : "POST",
		dataType : 'json',
		data : {
			actions: 'loadListMonthsForAdd',
			data: 'json'
		}		
	});
	
	request.done(function(arrayJson) {
		input.success(arrayJson);
	});
	request.fail(function(jqXHR, textStatus) {
		alert("loadListMonthForAdd - Request failed: " + textStatus);
	});
}

////////////////////////////////////
// Load Add form
//////////////////////////////////
function adjustedUnitsLoadAddForm(input){
	input = $.extend({}, {
		success : function(html) {
		}
	}, input);

	var request=$.ajax({
		url : rootPath_AdjustedUnits,
		type : "POST",
		dataType : 'html',
		data : {
			actions: 'adjustedUnitsAddForm',
			data: 'html'
		}		
	});
	
	request.done(function(html) {
		input.success(html);
	});
	request.fail(function(jqXHR, textStatus) {
		alert("adjustedUnitsLoadAddForm - Request failed: " + textStatus);
	});	
}
/////////////////////////////////
// Load Page Information Detail
/////////////////////////////////
function loadAdjustmentDetailPage(input){
	this.input = $.extend({}, {
		p_month_sk : '',
		p_io_orders_id : '',
		p_io_line_item_id : '',
		p_row: 1,
		success : function(html) {
		}
	}, input);
	
	//verify input
	if(input.p_month_sk==''){
		alert("Load detail page need to input param: p_month_sk");
		return;
	}
	if(input.p_io_orders_id==''){
		alert("Load detail page need to input param: p_io_orders_id");
		return;
	}
	if(input.p_io_line_item_id==''){
		alert("Load detail page need to input param: p_io_line_item_id");
		return;
	}
	//console.log("Update Adjusted Units: " + input.p_month_sk);
	//console.log("Update Adjusted Units: " + input.p_io_orders_id);
	//console.log("Update Adjusted Units: " + input.p_io_line_item_id);
	// call request to insert information
	var request = $.ajax({
		url : rootPath_AdjustedUnits,
		type : "POST",
		data : {
			actions : 'loadAdjustmentDetailPage',
			data : 'html',
			p_month_sk : input.p_month_sk,
			p_io_orders_id : input.p_io_orders_id,
			p_io_line_item_id : input.p_io_line_item_id,
			p_row: input.p_row
		},
		dataType : "html"
	});
	request.done(function(html) {
		input.success(html);		
	});

	request.fail(function(jqXHR, textStatus) {
		alert("Request failed: " + textStatus);
	});
	return false;
}