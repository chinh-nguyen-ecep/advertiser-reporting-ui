function pentahoActionURL( solution, path, action, params) {
	// execute an Action Sequence on the server

	var url = "/pentaho/ViewAction";
	
	// create the URL we need
	var query = "wrapper=false&solution="+solution+"&path="+path+"&action="+action;
	// add any parameters provided
	if( params ) {
		var idx;
		for( idx=0; idx<params.length; idx++ ) {
			query += "&" +encodeURIComponent( params[idx][0] ) + "=" + encodeURIComponent( params[idx][1] );
		}
	}
	// submit this as a post
	return url+'?'+query;
} 

function pentahoActionAjax(settings){
	settings=$.extend({},{
		success: function(){},
		url:'',
		dataType:'html',
		params:{},
		dom: null,
		textAlert:'Loading...',
		timeout: 600000,
		timeoutMessage: 'Request timeout!',
		errorMessage: 'Request error! Please try again.'
		},settings);
	var my_URL=settings.url;
	var map_params=settings.params;//option
	var dom=settings.dom;
	var func=settings.success;//option	
	var textAlert=settings.textAlert;//option
	$.ajax({
		url: my_URL,
		async: true,
		data: map_params,
		dataType: settings.dataType,
		timeout: settings.timeout,	
		beforeSend: function() {
			openProcessingAlert({
				text: textAlert
			});			
			dom.html('Loading...');
		},
		success: function(data, textStatus, xhr){
			dom.html(data);
			
		},
		complete: function(){
			closeProcessingAlert();
			func();
		},
		error: function(xhr, textStatus, errorThrown) {
				if(textStatus==='timeout'){
					alertText(settings.timeoutMessage);
				}else{
					alertText(settings.errorMessage);
				}
		},
		statusCode:{
			404: function(){
				alertText("page not found");
			}
		}	
	});
}

function doFormAjax(settings){
	settings=$.extend({},{
							success: function(data){},
							domResult:'',
							params:{},
							form: '',
							dataType: 'html',
							timeout: 600000,
							timeoutMessage: 'Request take a long time to process. Please try again in a few minutes!',
							errorMessage: 'Request take a long time to process. Please try again in a few minutes!',
							textAlert:'Loading...'
						},
							settings);
	var domResult=settings.domResult;
	var form=settings.form;
	var completedFn=settings.success;
	var textAlert=settings.textAlert;//option
	var params=form.serialize();
	var submitUrl='ViewAction?wrapper=false&'+params;
	//alert($.param(settings.params));
	//return true;
	if(domResult.is('div')==true){		
		var my_URL=submitUrl;
		$.ajax({
			url: my_URL,
			async: true,	
			data: settings.params,
			dataType: settings.dataType,
			timeout: settings.timeout,			
			beforeSend: function() {
				openProcessingAlert({
					text: textAlert
				});	
				//domResult.empty();
			},
			success: function(data, type){
				if(settings.dataType=='html'){
					domResult.html(data);
				}				
				completedFn(data);
			},
			complete: function(){
				closeProcessingAlert();
			},
			error: function(xhr, textStatus, errorThrown) {
				if(textStatus==='timeout'){
					alertText(settings.timeoutMessage);
				}else{
					alertText(settings.errorMessage);
				}
			},
			statusCode:{
				404: function(){
					alertText("page not found");
				}
			}
		});
	}
	if(domResult.is('iframe')==true){
		domResult.attr('onload',function(){
			//alert('iframe loaded');
		});
		window.open( submitUrl, domResult.attr('name') );
	}
}

//Load param
function loadParam(settings){
	settings=$.extend({},{
	success: function(){},
	text:'Loading...',
	p_table:'',
	p_value_field:'',
	p_name_field:'',
	p_condition:'',
	p_prompt_stype:'pulldown', //pulldown or Scrolling Check List
	p_all_name:'',
	p_all_value:'0',
	p_jndi:'verveReportConnection',//option
	p_param_name:'',
	dom_content_result:'',
	p_option_field:'',
	p_group_by:''
	},settings);
	
	var param={	
		p_table:settings.p_table,
		p_value_field:settings.p_value_field,
		p_name_field:settings.p_name_field,
		p_condition:settings.p_condition,
		p_prompt_stype:settings.p_prompt_stype,
		p_all_name:settings.p_all_name,
		p_all_value: settings.p_all_value,
		p_jndi:settings.p_jndi,//option		
		p_param_name:settings.p_param_name,
		p_option_field:settings.p_option_field,
		p_group_by:settings.p_group_by
	}
	var url_load_param=pentahoActionURL('Development','','load_param.xaction');
	pentahoActionAjax({
		url:url_load_param,
		params: param,
		dom:settings.dom_content_result,
		textAlert:settings.text,
		success: settings.success
	});
}
