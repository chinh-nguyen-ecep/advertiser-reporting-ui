// /////////////////////////
// Add information
// /////////////////////////
function addInfomation(input) {
	this.input = $.extend({}, {
		p_io_orders_id : '',
		p_campaign_id : '',
		p_billing_contact : '',
		p_comment : '',
		success : function(data) {
		}
	}, input);
	if (this.input.p_io_orders_id == '' && this.input.p_campaign_id == ''
			&& this.input.p_billing_contact == '' && this.input.p_comment == '') {
		alert("Please fill required fields");
		return false;
	}
	// call request to insert information
	var request = $.ajax({
		url : rootPath_Information,
		type : "POST",
		data : {
			actions : 'insertInformation',
			data : 'json',
			p_io_orders_id : this.input.p_io_orders_id,
			p_campaign_id : this.input.p_campaign_id,
			p_billing_contact : this.input.p_billing_contact,
			p_comment : this.input.p_comment
		},
		dataType : "json"
	});
	request.done(function(data) {
		input.success(data);
		var msg = data[0].fn_ba_national_dim_io_insert;
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

// /////////////////////////
// Update infomation
// ////////////////////////
function updateInfomation(input) {
	this.input = $.extend({}, {
		p_io_orders_id : '',
		p_campaign_id : '',
		p_billing_contact : '',
		p_comment : '',
		success : function(data) {
		}
	}, input);
	if (this.input.p_io_orders_id == '' && this.input.p_campaign_id == ''
			&& this.input.p_billing_contact == '' && this.input.p_comment == '') {
		alert("Please fill required fields");
		return false;
	}
	// call request to insert information
	var request = $.ajax({
		url : rootPath_Information,
		type : "POST",
		data : {
			actions : 'updateInformation',
			data : 'json',
			p_io_orders_id : this.input.p_io_orders_id,
			p_campaign_id : this.input.p_campaign_id,
			p_billing_contact : this.input.p_billing_contact,
			p_comment : this.input.p_comment
		},
		dataType : "json"
	});
	request.done(function(data) {
		input.success(data);
		var msg = data[0].fn_ba_national_dim_io_update;
		if (msg == 'SUCCESSED') {
			// alert("Edited successfully");
		} else {
			alert("Error occur!");
		}
	});

	request.fail(function(jqXHR, textStatus) {
		alert("Request failed: " + textStatus);
	});
	return false;
}
/////////////////////////////////
// Load Page Information Detail
/////////////////////////////////
function loadInformationDetailPage(input){
	this.input = $.extend({}, {
		p_io_orders_id : '',	
		p_row: 1,
		success : function(html) {
		}
	}, input);
	
	//verify input
	if(input.p_io_orders_id==''){
		alert("Load detail page need to input param: p_io_orders_id");
		return;
	}
	// call request to insert information
	var request = $.ajax({
		url : rootPath_Information,
		type : "POST",
		data : {
			actions : 'LoadInformatinoDetailPage',
			data : 'html',
			p_io_orders_id : this.input.p_io_orders_id,
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