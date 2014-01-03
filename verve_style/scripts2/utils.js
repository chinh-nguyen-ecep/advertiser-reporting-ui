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
	
function generateSelect(options){
	$.extend({},{
		inputID:'',
		divID: '',
		name: 'name',
		ajaxUrl: '',
		data: function(term, page){
			return {
                q: term, //search term
                page_limit: 10, // page size
                page: page // page number
            };
		},
		result: function(data, page){
			return {results: data,more: false}
		}
	},options);
	var drawArea=$('#'+options.divID);
	var inputArea=$('#'+options.inputID);
	var page=1;
	var term='';
	var ajaxObject=$.ajax({
		type: "POST",
		url: "some.php",
		data: "name=John&location=Boston",
		success: function(msg){
		   
		}
	});
	
	load(inputArea.val());
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
			}
		})
		
	}
	function rawData(data,more){
		if(page==1){
			drawArea.empty();
			if(data.length==0){
				var row="Don't have results....";
				drawArea.append(row);
			}
		}
		$.each(data,function(index,temp){
			var id=temp[0];
			var text=temp[1];
			var row='<input id="checkbox_'+id+'" value="'+id+'" type="checkbox" name="'+options.name+'" safari="1"/> <label for="checkbox_'+id+'">'+text+'</label><br/>';
			drawArea.append(row);
		});
		$('#'+options.divID+' input:checkbox').checkbox({cls:'jquery-safari-checkbox',empty: '/verve_style/scripts2/checkbox/empty.png'});
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
			   rawData(data,more);
			}
		})
	}
	
}