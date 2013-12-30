var globalTimeout = null; 
var solution=gup('solution');
var path=gup('path');

var MyCheckBox = new Class({
						initialize: function(selectdiv,showdiv){
						//clear showdiv
									showdiv.set('html','');
									
									//get list checkbox is checked
									var listChecked=selectdiv.getElements('input:checked');
									listChecked.each(function(item1, index1, object1){
										var divItem=new Element('div');
										divItem.set('html',item1.get('value'));
										showdiv.grab(divItem,'top');
									});	
									
									this.run(selectdiv,showdiv);
						},

						run: function(selectdiv,showdiv){
							var listCheckBox=selectdiv.getElements('input');
							listCheckBox.each(function(item, index, object){
								item.addEvent('click',function(){
									//clear showdiv
									showdiv.set('html','');
									
									//get list checkbox is checked
									var listChecked=selectdiv.getElements('input:checked');
									listChecked.each(function(item1, index1, object1){
										var divItem=new Element('div.itemChooseList');
										divItem.set('html',item1.get('value'));
										var inputItem=new Element('input',{
											styles:{
												display: 'none'
											}
										});
										inputItem.set('name',item1.get('name'));
										inputItem.set('value',item1.get('value'));
										showdiv.grab(divItem,'top');
										showdiv.grab(inputItem,'top');
									});	
								});
							});
						}
					});

var Fillter=new Class({
	initialize: function(device_fillter_id,check_box_list){
		var device_fillter=$(device_fillter_id);
		device_fillter.addEvent('keyup', function(){
			var fillter_value=this.get('value').toLowerCase();
			if(fillter_value != ""){
				//get all check box contant value fillter
				var list=$(check_box_list).getElements('input:not(:checked)');
				list.each(function(item,index){
					var valueOfItem=item.get('value').toLowerCase();
					if(valueOfItem.indexOf(fillter_value)>-1){
						var tr=item.getParent('tr');
						tr.setStyles({display: ''});
					}else{
						var tr=item.getParent('tr');
						tr.setStyles({display: 'none'});
					};
				});
			}else{
				//get all check box contant value fillter
				var list=$(check_box_list).getElements('input');
				list.each(function(item,index){							
				var tr=item.getParent('tr');								
				tr.setStyles({display: ''});							
				});
			};
		});
	}
});

var Fillter=new Class({
	initialize: function(device_fillter_id,check_box_list,fillter_by,select_type){
		var device_fillter=$(device_fillter_id);
		device_fillter.addEvent('keyup', function(){
			delay_timeout(1000,function(){
				var fillter_value=device_fillter.get('value').toLowerCase();
				if(fillter_value != ""){
					//get all check box contant value fillter
					var list=$(check_box_list).getElements('input:not(:checked)');
					list.each(function(item,index){
						var valueOfItem=item.get('value').toLowerCase();
						if(fillter_by=='name'){
							valueOfItem=item.getNext('span').get('text').toLowerCase();
						}
						if(fillter_by=='title'){
							valueOfItem=item.getNext('span').get('title').toLowerCase();
						}
						if(valueOfItem.indexOf(fillter_value)>-1){
							var tr=item.getParent('tr');
							tr.setStyles({display: ''});
						}else{
							var tr=item.getParent('tr');
							tr.setStyles({display: 'none'});
						};
					});
				}else{
					//get all check box contant value fillter
					var list=$(check_box_list).getElements('input');
					list.each(function(item,index){							
					var tr=item.getParent('tr');								
					tr.setStyles({display: ''});							
					});
				};			
			});
		});
		//select type
		if(select_type=='single'){
			var list=$(check_box_list).getElements('input');
			list.each(function(item,index){
				item.addEvent('click',function(){
					var list2=$(check_box_list).getElements('input:checked');
					list2.each(function(item1,index){
						item1.set('checked','');
					});
				item.set('checked','true');
				});
			});
		};
		
		if(select_type=='muti all check'){
			$(check_box_list).getElement('input').addEvent('click',function(){
							var checked=this.get('checked');

							if(checked){
								var list=$(check_box_list).getElements('input:not(:checked)');
								list.each(function(item,index){
									item.set('checked','true')
								});
							}else{
								var list=$(check_box_list).getElements('input:checked');
								list.each(function(item,index){
									item.set('checked','')
								});
							};
						});
		};
		
		if(select_type=='muti not all check'){
			$(check_box_list).getElement('input').addEvent('click',function(){
							var checked=this.get('checked');

							if(checked){
								var list=$(check_box_list).getElements('input');
								list.each(function(item,index){
									if(index>0){
										item.set('checked','');
										item.set('disabled','disabled');
									}
								});
							}else{
								var list=$(check_box_list).getElements('input');
								list.each(function(item,index){
									item.set('checked','');
									item.set('disabled','');
								});
							};
						});
		};
		
	}
});		

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
										
function select(){
	var id;
	this.id=id;
	this.hello=hello;
	function hello(){
		alert(this.id);
	}
}				
					
					
						
							
							
																
								
							
																
								
							
					
						
						
					
					
											
						