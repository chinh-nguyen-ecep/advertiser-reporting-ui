var globalTimeout = null; 
var solution=gup('solution');
var path=gup('path');
function myformatter(date){
            var y = date.getFullYear();
            var m = date.getMonth()+1;
            var d = date.getDate();
            return y+'-'+(m<10?('0'+m):m)+'-'+(d<10?('0'+d):d);
        }
function myparser(s){
	if (!s) return new Date();
	var ss = (s.split('-'));
	var y = parseInt(ss[0],10);
	var m = parseInt(ss[1],10);
	var d = parseInt(ss[2],10);
	if (!isNaN(y) && !isNaN(m) && !isNaN(d)){
		return new Date(y,m-1,d);
	} else {
		return new Date();
	}
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
$.fn.serializeObject = function() {
	var o = {};
	var a = this.serializeArray();
	$.each(a, function() {
		if (o[this.name]) {
			if (!o[this.name].push) {
				o[this.name] = [o[this.name]];
			}
			o[this.name].push(this.value || '');
		} else {
			o[this.name] = this.value || '';
		}
	});
	return o;
};		
function getDataTest(page,temp,lm){
	var result=[];
	for(var i=0;i < 10;i++){
		var idvl=page+'_'+i;
		var textvl=page+'_text_'+i;
		var row={id: idvl,text: textvl};
		result.push(row);
	}
	return result;
}
	
function generateSelect2(options){
	options=$.extend({},{
		inputID:'',
		divID: '',
		name: 'name',
		ajaxUrl: '',
		multi: true,
		selectAll: false,
		data: function(term, page){
			return {
                q: term, //search term
                page_limit: 10, // page size
                page: page // page number
            };
		},
		result: function(data, page){
			return {results: data,more: false}
		},
		success: function(){
		
		},
		clickEvent: function(id){
		 console.log("Click on: "+id);
		}
	},options);
	var drawArea=$('#'+options.divID);
	var inputArea=$('#'+options.inputID);
	var page=1;
	var term='';
	this.getID=getID;
	this.action=action;
	var ajaxObject=$.ajax({
		type: "POST",
		url: "some.php",
		data: "name=John&location=Boston",
	});
	
	function action(){
		load(inputArea.val());	
	}

	inputArea.keyup(function(event){
		delay_timeout(1000,function(){
			load(inputArea.val());
		})
	});

	function load(term){
		ajaxObject.abort();
		term=term;
		page=1;
		ajaxObject=$.ajax({
			type: "POST",
			dataType: "json",
			url: options.ajaxUrl,
			data: options.data(term,page),
			success: function(ajaxData){
			   var result=options.result(ajaxData,page);
			   var data=result.results;
			   var more=result.more;
			   rawData(data,more);
			   options.success();
			}
		})
		
	}
	function rawData(data,more,isLoadMore){
		if(page==1){
			drawArea.empty();
			if(data.length==0){
				var row="Don't have results....";
				drawArea.append(row);
			}
			
			if(options.selectAll){
				var row=[0,'All'];
				data.unshift(row);
			}
		}
		$.each(data,function(index,temp){
			var id=temp[0];
			var text=temp[1];
			var row='<input id="checkbox_'+id+'" value="'+id+'" type="checkbox" name="'+options.name+'" safari="1"/> <label for="checkbox_'+id+'">'+text+'</label><br/>';
			if(index==0 && !isLoadMore){
				row='<input id="checkbox_'+id+'" value="'+id+'" type="checkbox" name="'+options.name+'" safari="1" checked/> <label for="checkbox_'+id+'">'+text+'</label><br/>';
			}
			if(index==0 && !options.multi && !isLoadMore){
				row='<input id="radio_'+id+'" value="'+id+'" type="radio" name="'+options.name+'" safari="1" checked/> <label for="radio_'+id+'">'+text+'</label><br/>';
			}
			if(index>0 && !options.multi){
				row='<input id="radio_'+id+'" value="'+id+'" type="radio" name="'+options.name+'" safari="1"/> <label for="radio_'+id+'">'+text+'</label><br/>';
			}
			drawArea.append(row);
		});
		//check all event
		if(options.selectAll){
			var allCheckbox=$('#'+options.divID+' input:not(:button)').first();
			$('#'+options.divID+' input:not(:button)').change(function(){				
				var isChecked=$(this).is(':checked');
				if(isChecked){
					allCheckbox.prop('checked',false);
				}
				
			});
			allCheckbox.change(function(){
				var isChecked=$(this).is(':checked');
				console.log(isChecked);
				if(!isChecked){
					$('#'+options.divID+' input:not(:button)').prop('checked',false);
					allCheckbox.prop('checked',true);
				}
			});
		}
		if(!options.multi){
			$('#'+options.divID+' input:radio').checkbox({cls:'jquery-safari-checkbox',empty: '/verve_style/scripts2/checkbox/empty.png'});
			$('#'+options.divID+' input:radio').change(function(event){
				var value=$(this).val();
				options.clickEvent(value);
			});
		}else{
			$('#'+options.divID+' input:checkbox').checkbox({cls:'jquery-safari-checkbox',empty: '/verve_style/scripts2/checkbox/empty.png'});
			$('#'+options.divID+' input:checkbox').change(function(event){
				var value=$(this).val();
				options.clickEvent(value);
			});
		}

		addMoreButton(more);

		
	}
	
	function addMoreButton(more){
		if(more){
			var button=$('<input type="button" value="Load more..." />');
			drawArea.append(button);
			button.click(function(){
				loadMore(inputArea.val());
			});
		}
	}
	function loadMore(term){
		$('#'+options.divID+' input:button').val("Loading...");
		ajaxObject.abort();
		term=term;
		page=page+1;
		ajaxObject=$.ajax({
			type: "POST",
			dataType: "json",
			url: options.ajaxUrl,
			data: options.data(term,page),
			success: function(ajaxData){
			   var result=options.result(ajaxData,page);
			   var data=result.results;
			   var more=result.more;
			   $('#'+options.divID+' input:button').remove();
			   rawData(data,more,true);
			}
		})
	}
	
	function getID(){
		var multi=options.multi;
		var result=[];
		if(true){
			var array=$('#'+options.divID+' input:checked');
			$.each(array,function(index,item){
				var value=item.value;
				result.push(value);
			});
		}
		return result;
	}
	
}