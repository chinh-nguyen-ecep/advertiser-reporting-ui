// /////////////////////////
// Add ajusted units
// /////////////////////////
function addAjustedUnits(input) {
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
	console.log(this.input);
	if (this.input.p_combined_ids == '' || this.input.p_ajusted_units == ''
			|| this.input.p_month_sk == '') {
		alert("Please fill required fields");
		return false;
	}
	// verify ajusted units input
	if (!$.isNumeric(this.input.p_adjusted_units)) {
		alert("Ajusted units must be a number!");
		return false;
	}
	// call request to insert information
	var request = $.ajax({
		url : rootPath_AjustedUnits,
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