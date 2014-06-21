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