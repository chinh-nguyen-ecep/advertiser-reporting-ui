var globalTimeout = null; 
var solution=gup('solution');
var path=gup('path');

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


function createFillter(box_filter,check_box_list,fillter_by,select_type){
		box_filter.keyup(function(){
			var fillter_value=box_filter.attr('value').toLowerCase();
			if(fillter_value != ''){
				var list=check_box_list.find('input:not(:checked)');
				//alert(list.length);
				list.each(function(index){
					var inputELM=$(this);
					var labelELM=$(this).next('span');
					var valueOfItem=inputELM.attr('value');
					var trELM=inputELM.parent().parent();
					if(fillter_by=='name'){
						valueOfItem=labelELM.text();
					}
					if(fillter_by=='title'){
						valueOfItem=inputELM.attr('title');
					}
					valueOfItem=valueOfItem.toLowerCase();
					//alert(valueOfItem);
					if(valueOfItem.indexOf(fillter_value)>-1){
						trELM.show();
					}else{
						trELM.hide();
					}
				});
				
			}else{
				var list=check_box_list.children('input');
				list.each(function(index){
					var trELM=$(this).parent().parent();
					trELM.show();				
				});
			}
		});
}	
function delay_timeout(second_time,func){
	if(globalTimeout != null) clearTimeout(globalTimeout); 
	globalTimeout =setTimeout(function(){func();},second_time);
}		
				
function gup( name )
{
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}	