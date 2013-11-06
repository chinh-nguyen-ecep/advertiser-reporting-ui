var globalTimeout = null;  
var ProcessingBox=null;
var alertDialog=$('<div id="alert_dialog"><span></span></div>');


function alertText(text,buttonArray){
	buttonArray=$.extend({},buttonArray,{			
			Ok: function() {
				$( this ).dialog( "close" );
			}
			});
	alertDialog.find('span').html(text);
	alertDialog.dialog({
		modal: true,
		title: "Alert",
		height: 'auto',
		draggable: false,
		resizable: false,
		position: {
				my: 'center center',
				at: 'center center',
				collision: 'fit',
				of: window,
				using: function(pos) {					
					var topOffset = $(this).css(pos).offset().top;
					//alert(topOffset+'-'+pos.top+' window.pageXOffset:'+window.pageXOffset+" window.pageYOffset:"+window.pageYOffset+" window.innerWidth:"+window.innerWidth+" window.innerHeight:"+window.innerHeight);
					
					$(this).css({
						top: (window.innerHeight - $(this).height()) / 2+window.pageXOffset,
						left: (window.innerWidth - $(this).width()) / 2+window.pageYOffset
					});					
					
				}
			},
		buttons: buttonArray
	});
}
function initProcessingBoxAlert(settings){
	settings=$.extend({},{success: function(){},text:'Loading...'},settings);
	var text=settings.text;
	var successFn=settings.success;
	
	ProcessingBox=$('<div id="processing_box"><img src="'+root_folder+'/images/processing_box_loading.gif"/><br/>'+text+'</div>');
	//var domCotent='<div id="processing_box"><img src="http://www.prestowonders.com/gifts/loading.gif"/>Loading...</div>';
	ProcessingBox.dialog({            
			resizable: false,
			width:300,
            height:200,
			autoOpen: false,
			position: {
				my: 'center center',
				at: 'center center',
				collision: 'fit',
				of: window,
				using: function(pos) {					
					var topOffset = $(this).css(pos).offset().top;
					//alert(topOffset+'-'+pos.top+' window.pageXOffset:'+window.pageXOffset+" window.pageYOffset:"+window.pageYOffset+" window.innerWidth:"+window.innerWidth+" window.innerHeight:"+window.innerHeight);
					
					$(this).css({
						top: (window.innerHeight - $(this).height()) / 2+window.pageXOffset,
						left: (window.innerWidth - $(this).width()) / 2+window.pageYOffset
					});					
					
				}
			},
            modal: true,
			open: function( event, ui ){
				successFn();
			}
		});
		
	ProcessingBox.parent().css({background:'none',border:'none'});
	ProcessingBox.prev().css({display: 'none'});
	ProcessingBox.show();
}
function openProcessingAlert(settings){
	if(ProcessingBox==null){
		initProcessingBoxAlert(settings);
	}	
	ProcessingBox.dialog('open');
}
function closeProcessingAlert(){
	ProcessingBox.dialog('close');
	ProcessingBox.dialog('destroy');
	ProcessingBox.remove();
	ProcessingBox=null;
}
function parseDate(date){
	var result='';
	var months = new Array('01','02','03','04','05','06','07','08','09','10','11','12');
	var tdate=date.getDate();
	if(tdate<10) tdate='0'+tdate;
	result=date.getFullYear()+'-'+months[date.getMonth()]+'-'+tdate;
	return result;
}
function delay_timeout(second_time,func){
	if(globalTimeout != null) clearTimeout(globalTimeout); 
	globalTimeout =setTimeout(function(){func();},second_time);
}
//this function paser param from url
function gup( name ){
  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
  var regexS = "[\\?&]"+name+"=([^&#]*)";
  var regex = new RegExp( regexS );
  var results = regex.exec( window.location.href );
  if( results == null )
    return "";
  else
    return results[1];
}

//This function return a string content values of checkbox selected
function checkBoxSelected(checkBoxName){
	var array=new Array();
	var checkName='input[name='+checkBoxName+']:checked';
	$(checkName).each(function(index){
		array[index]=$(this).attr('value');
	});	
	return array.join(',');
}
function checkBoxSelected2(settings){	
	settings=$.extend({},{checkBoxDom: '',checkBoxName:'',separator: ','},settings);
	var array=new Array();
	var checkName=settings.checkBoxDom.find('input[name='+settings.checkBoxName+']:checked');
	$(checkName).each(function(index){
		array[index]=$(this).attr('value');
	});	
	return array.join(settings.separator);
}
var solution=gup('solution');
var path=gup('path');
var text=solution + '-' + path;
//alert(text);