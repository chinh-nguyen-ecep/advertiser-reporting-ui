function setCheckboxView(check_box_list){
	check_box_list.find('input[type=checkbox]').each(function(index){
		var input_checkbox=$(this);
		var is_disable=$(this).attr('disabled');
		var is_checked=$(this).attr('checked');	
		input_checkbox.hide();
		if(is_checked){
			if($(this).next().is("img")==false){
				$(this).after('<img class="checkBox" src="/verve-lib/images/ui_check_box.png" alt="checked"/>');
			}			
		}else{
			if($(this).next().is("img")==false){
				$(this).after('<img class="checkBox" src="/verve-lib/images/ui_check_box_uncheck.png" alt="unchecked"/>');
			}			
		}
		input_checkbox.change(function(){
				var is_disable=$(this).attr('disabled');
				var is_checked=$(this).attr('checked');
				if(is_checked){
					if($(this).next().is("img")!=false){
						$(this).next().attr('src','/verve-lib/images/ui_check_box.png');
						$(this).next().attr('alt','unchecked');
					}			
				}else{
					if($(this).next().is("img")!=false){
						$(this).next().attr('src','/verve-lib/images/ui_check_box_uncheck.png');
						$(this).next().attr('alt','unchecked');
					}			
				}
		});
		
	});
}

function createHTMLList(dataArray,locateDiv,param_name,type){
	var htmlContent="<table>";
	$.each(dataArray,function(index,item){
		var value=item.value;
		var name=item.name;
		var title=item.title;
		var node="";
		if(index==0){
		node='<tr><td><input type="'+type+'" id="'+index+'_'+param_name+'" name="'+param_name+'" title="'+title+'" value="'+value+'" checked="checked"/>'
		+'<span class="radio_checkbox" title="'+title+'" for="'+index+'_'+param_name+'">'+name+'</span></td></tr>';		
		}else{
		node='<tr><td><input type="'+type+'" id="'+index+'_'+param_name+'" name="'+param_name+'" title="'+title+'" value="'+value+'" />'
		+'<span class="radio_checkbox" title="'+title+'" for="'+index+'_'+param_name+'">'+name+'</span></td></tr>';		
		}
		htmlContent+=node;
		
		
		//alert(node);
		});
	htmlContent+="</table>";
	locateDiv.append(htmlContent);
}

function createFillter(settings){
		settings=$.extend({},{
			box_filter:'',
			check_box_list:'',
			fillter_by:'value',//option name,title,value
			select_type:'check_all'//option check_all,single_mode
		},settings);
		
		var box_filter=settings.box_filter;
		var check_box_list=settings.check_box_list;
		var fillter_by=settings.fillter_by;
		var select_type=settings.select_type;
		
		if(box_filter==''){
			
		}else{
				box_filter.keyup(function(){
				if(globalTimeout != null) clearTimeout(globalTimeout); 
				globalTimeout =setTimeout(function(){
					var fillter_value=box_filter.attr('value').toLowerCase();
					//alert(fillter_value);
					if(fillter_value != ''){
						var list=check_box_list.find("input:not(:checked)");
						//var listArray=$.makeArray(list);
						list.each(function(index){
							var currentInput=$(this);
							var labelELM=currentInput.next().next('span');
							if(labelELM.is('span') == false){labelELM=currentInput.next('span');};
							var valueOfItem=currentInput.attr('value');
							var trELM=currentInput.parent().parent();
							if(fillter_by=='name'){
								valueOfItem=labelELM.text();
							}
							if(fillter_by=='title'){
								valueOfItem=labelELM.attr('title');
							}
							valueOfItem=valueOfItem.toLowerCase();
							
							if(valueOfItem.indexOf(fillter_value)>-1){								
								trELM.show();
							}else{
								//alert(valueOfItem+' fill value ='+fillter_value);
								trELM.hide();
							}
						});
						
					}else{
						var list=check_box_list.find('input');
						list.each(function(index){
							var trELM=$(this).parent().parent();
							trELM.show();					
						});
					}
				},1000); 
			});
		}

		//check select_type-------
		// select_type: check_all -- Add event on fist check input. When you check on fist input, the remaining inputs will be disable.
		// select_type: single_mode -- Change all input checkbox to radio.
		if(select_type=='check_all'){
			var check_all_box=check_box_list.find("input:first");
			check_all_box.change(function(){
				var is_checked=$(this).attr('checked');
				if(is_checked){
					check_box_list.find("input").each(function(index){
						if(index>0){
							$(this).removeAttr("checked");
							$(this).attr("disabled","disabled");
							$(this).next().attr('src','/verve-lib/images/ui_check_box_uncheck.png');
							$(this).next().attr('alt','unchecked');
						}
					});
				}else{
					check_box_list.find("input").each(function(index){
						$(this).removeAttr("disabled");
					});
				}
			});
			check_box_list.find("input").each(function(index){
					if(index>0){
						$(this).change(function(){
							var is_checked=$(this).attr('checked');
							if(is_checked){
								check_all_box.removeAttr('checked');
								check_all_box.next().attr('src','/verve-lib/images/ui_check_box_uncheck.png');
								check_all_box.next().attr('alt','unchecked');
							}
						});
					}
			});
		}else if(select_type=='single_mode'){
			var listInputCheckbox=check_box_list.find("input");
			listInputCheckbox.each(function(index){
				$(this).clone().attr('type','radio').insertAfter($(this)).prev().remove();
			});
		}
		check_box_list.find('td').each(function(index){
			var input=$(this).children('input');				
			//Set click event
			$(this).click(function(){	
				var is_disable=input.attr('disabled');
				var is_checked=input.attr('checked');
				if(is_disable){
					return false;
				}else{					
					if(is_checked){
						if(select_type!='single_mode'){
							input.removeAttr("checked");							
						}						
					}else{
						input.attr("checked","checked");						
					}
					input.trigger('change');
				}
				
			});
		});
		setCheckboxView(check_box_list);
}