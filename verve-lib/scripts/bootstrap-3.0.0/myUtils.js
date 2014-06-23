function myProcessDialog(config){
	this.config=$.extend({},{
		title:'Default Modal!',
		bootrapModal: $('<div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" > <div class="modal-dialog"> 	<div class="modal-content"> <div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h4 class="modal-title"></h4> </div> <div class="modal-body"><div class="alert alert-danger fade in" style="display: none;"></div> <div class="alert alert-info fade in"></div> <div class="progress progress-striped active"><div class="progress-bar"  role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%"> <span class="sr-only">0% Complete</span></div></div></div> </div> </div> </div>'),
		alertInfo:'Info text here',
		alertDanger:'Danger here',
		processBarMaxValue: 100,
		processBarNowValue:0				
	},config);
	var bootrapModal=this.config.bootrapModal;
	//init function
	//set title for dialog
	bootrapModal.find('.modal-title').first().html(this.config.title);
	setProcessBarValue(this.config.processBarNowValue);
	//public function
	this.getTitle=getTitle;
	this.setTitle=setTitle;
	this.setAlertInfo=setAlertInfo;
	this.show=show;
	this.hide=hide;
	this.setAlertDanger=setAlertDanger;
	this.setProcessBarValue=setProcessBarValue;
	function setTitle(title){
		bootrapModal.find('.modal-title').first().html(title);
	}
	function show(){
		console.log('show modal');
		bootrapModal.modal({backdrop:'static',show:true});
	}
	function hide(){
		bootrapModal.modal('hide');
	}
	function setAlertInfo(text){
		bootrapModal.find('div.alert-info').first().html(text);
	}
	function setAlertDanger(text){
		var dangerAlert=bootrapModal.find('div.alert-danger').first();
		dangerAlert.html(text);
		dangerAlert.show();
		
		setTimeout(function(){
			dangerAlert.fadeOut(1000,function(){});
		},5000)
		
	}
	function setProcessBarValue(value){
		console.log('Set proccess bar for value: '+value);
		var proccessBar=bootrapModal.find('div.progress-bar').first();
		
		proccessBar.css('width',value+'%');
		proccessBar.attr('aria-valuenow',value);
		proccessBar.find('span').first().html(value+'% Completed');
	}
	function getTitle(){
		return this.config.title;
	}
}
function myDialog(config){
	this.config=$.extend({},{
		title:'Default Modal!',
		bootrapModal: $('<div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" > <div class="modal-dialog"> 	<div class="modal-content"> <div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h4 class="modal-title"></h4> </div> <div class="modal-body">  </div></div></div> </div>'),
		content: ''
	},config);
	var bootrapModal=this.config.bootrapModal;
	//init function
	//set title for dialog
	bootrapModal.find('.modal-title').first().html(this.config.title);
	setProcessBarValue(this.config.processBarNowValue);
	//public function
	this.getTitle=getTitle;
	this.setTitle=setTitle;
	this.setContent=setContent;
	this.show=show;
	this.hide=hide;
	
	function setTitle(title){
		bootrapModal.find('.modal-title').first().html(title);
	}
	function show(){
		console.log('show modal');
		bootrapModal.modal({backdrop:'static',show:true});
	}
	function hide(){
		bootrapModal.modal('hide');
	}
	function setContent(text){
		bootrapModal.find('.modal-title').first().html(title);
	}
	function getTitle(){
		return this.config.title;
	}
}
function isValidEmailAddress(emailAddress) {
    var pattern = new RegExp(/^((([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?$/i);
    return pattern.test(emailAddress);
};

var urlMaster=new urlMaster();
function urlMaster(){
	var local=0;
	this.clear=clear;
	this.addParam=addParam;
	this.getParam=getParam;
	this.replaceParam=replaceParam;
	function clear(){
		window.history.replaceState('local '+local, 'Title '+local, rootUrl+"");
		local++;
	}
	function addParam(name,value){
		var currentUrl=window.location.href;
		currentUrl=currentUrl.replace("\#", "");
		window.history.replaceState('local '+local, 'Title '+local, currentUrl+"&"+name+"="+value);
		local++;
	}
	function getParam(name){
		  name = name.replace(/[\[]/,"\\\[").replace(/[\]]/,"\\\]");
		  var regexS = "[\\?&]"+name+"=([^&#]*)";
		  var regex = new RegExp( regexS );
		  var results = regex.exec( window.location.href );
		  if( results == null )
		    return "";
		  else
		    return results[1];
	}
	function replaceParam(name,value){
		var currentValue=this.getParam(name);
		if(currentValue==''){
			this.addParam(name,value);
		}else{
			var currentUrl=window.location.href;
			currentUrl=currentUrl.replace("\#", "");
			currentUrl=currentUrl.replace(name+'='+currentValue, name+'='+value);
			window.history.replaceState('local '+local, 'Title '+local, currentUrl);
			local++;
		}
	}
}
