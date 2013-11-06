var rootLocate="Development";
var locate="dashboards/heatmap_demo";
var maxDate="";
var minDate="";
var start_date="";
var end_date="";
var current_date="";
var date_range=new Array();
var list_event_names=new Array();
var list_flight_ids=new Array();
var getFirstDataURL=pentahoActionURL( rootLocate, locate, "GetFirstData.xaction");
var getListEventURL=pentahoActionURL( rootLocate, locate, "getListEvent.xaction");
//map var
var mapDataURL=pentahoActionURL(rootLocate, locate, "mapData.xaction");
var mapData=new Array();
var myLatlng;
var myOptions;
var map;
var markerCluster;
var markerClustertoggle=0;
var heatmap;
//
var autoIncrementRepeat=0;
var autoIncrementTime=5000;
var canAble=0;
var MetaLayer ={
	/*startDate: MetaLayer.getLastMonthDate(), // Default start date
	endDate: MetaLayer.getCurrentDate(), // Default end date
	startMonth: MetaLayer.getMonth(), // Default month date*/
};

MetaLayer = {
	init: function(){
		//load the init data
		$.ajax({
		  url: getFirstDataURL,
		  dataType: 'json',
		  success: function(data){
			maxDate=data.maxDate;
			minDate=data.minDate;//2012-03-02
			start_date=data.start_date;
			current_date=start_date;
			end_date=maxDate;
			//init map
			MetaLayer.initMap();
			//control panel create list flight ids
			list_flight_ids=data.list_flight_ids;
			createHTMLList(list_flight_ids,$('#lc_flightID'),'p_flight_id','radio');
			createFillter($('#sr_flightID'),$('#lc_flightID'),'name','single');	
			$('#lc_flightID input').each(function(index){
				var checkBox=$(this);
				var label=checkBox.next('label');
				checkBox.click(function(){
					MetaLayer.refreshListOfEventName();
				});		
				label.click(function(){
					MetaLayer.refreshListOfEventName();
				});				
			});
			//load event name
			MetaLayer.refreshListOfEventName();
			MetaLayer.initToolbar();			
			//create date range
			var arrayDate=start_date.split('-');
			var myDate1=new Date(arrayDate[0],(arrayDate[1]/1)-1,arrayDate[2]/1);
			var arrayDate=end_date.split('-');
			var myDate2=new Date(arrayDate[0],(arrayDate[1]/1)-1,arrayDate[2]/1);
			date_range = getDates(myDate1, myDate2);	
			//show control panel button
			$('#control-panel').show();
			$('#dialog-form').show();
			$('#heatMapToggle').show();
		  }
		 });
	},
	initToolbar: function(){	
		$( "#start_date" ).attr('value',start_date);
		$( "#start_date" ).datepicker({
			defaultDate: start_date,
			dateFormat: 'yy-mm-dd',
			maxDate: maxDate,
			minDate: minDate,
			onSelect: function(dateText, inst) { 
				$( "#end_date" ).datepicker( "option", "minDate", dateText );
				start_date=dateText;
				//MetaLayer.refresh();
			 }
		});
		$( "#end_date" ).attr('value',end_date);
		$( "#end_date" ).datepicker({
			defaultDate: end_date,
			dateFormat: 'yy-mm-dd',
			maxDate: maxDate,
			minDate: minDate,
			onSelect: function(dateText, inst) { 
				$( "#start_date" ).datepicker( "option", "maxDate", dateText );
				end_date=dateText;
				//MetaLayer.refresh();
			 }
		});

		//install digital clock
		$('#digital-clock').clock({offset: '-7', type: 'digital'});
		$('#digital-clock-SaiGon').clock({offset: '+7', type: 'digital'});

		
		//create control panel
		$( "#dialog-form" ).dialog({
			autoOpen: true,
			height: 510,
			width: 465,
			modal: true,
			resizable: false,
			buttons: {
				"OK": function() {					
					var dispaly_type=$('select[name=display_type]').attr('value');
					if(dispaly_type=='Auto Increment'){
						current_date=start_date;
						MetaLayer.refresh(current_date);
						setTimeout(function(){
							MetaLayer.autoIncrement();
						},autoIncrementTime);
					}
					if(dispaly_type=='Summation'){
						MetaLayer.summation();
					}
					if(dispaly_type=='Stepwise'){
						current_date=start_date;
						MetaLayer.refresh(current_date);
						$( "#next-date" ).show();
						$( "#prev-date" ).show();
					}else{
						$( "#next-date" ).hide();
						$( "#prev-date" ).hide();
					}
					 $( this ).dialog( "close" );
							 
				},
				Cancel: function() {
					canAble=1;
					$( this ).dialog( "close" );
				}
			},
			close: function() {
				
			}
		});
		
		//control panel button
		$( "#control-panel" )
			.button()
			.click(function() {	
				current_date=end_date;
				$( "#dialog-form" ).dialog( "open" );
				$( "#start_date" ).datepicker("hide");
				$('#sr_flightID').focus();
			});
			
		//heatMapToggle
		$('#heatMapToggle').click(function(){
			heatmap.toggle();
		});
		
		//market cluster toggle
		$('#marketClusterToggle').click(function(){
			MetaLayer.refreshMarkersCluster();
		});
		
		//next date and pre date button
		$( "#next-date" )
			.button({
				icons:{
					primary:"ui-icon-carat-1-e"
				},
				text: false})
			.click(function(){
				if(canAble==0){
					return false;
				}
				var date=parseDateConvert(current_date).addDays(1);
				var stop_date=parseDateConvert(end_date);
				if(date<=stop_date){
					current_date=parseDate(date);
					MetaLayer.refresh(current_date);	
				}
				
			});
		$( "#prev-date" )
			.button({
				icons:{
					primary:"ui-icon-carat-1-w"
				},
				text: false})
			.click(function(){
				if(canAble==0){
					return false;
				}
				var date=parseDateConvert(current_date).addDays(-1);
				var stop_date=parseDateConvert(start_date);
				if(date>=stop_date){
					current_date=parseDate(date);
					MetaLayer.refresh(current_date);
				}
			});
		// marker icon select
		$('#marker_icon_panel input').each(function(index){
			var dom=$(this);
			dom.click(function(){
				MetaLayer.refreshMarkersCluster();
			});
		});
	},
	initMap: function(){
		myLatlng = new google.maps.LatLng(39.677129,-102.441406);
		// sorry - this demo is a beta
		// there is lots of work todo
		// but I don't have enough time for eg redrawing on dragrelease right now	
		var myOptions = {
		  zoom: 4,
		  center: myLatlng,
		  mapTypeId: google.maps.MapTypeId.ROADMAP,
		  disableDefaultUI: false,
		  scrollwheel: true,
		  draggable: true,
		  navigationControl: true,
		  mapTypeControl: false,
		  scaleControl: true,
		  disableDoubleClickZoom: false
		};		
		map = new google.maps.Map(document.getElementById("heatmapArea"), myOptions);

		heatmap = new HeatmapOverlay(map, {"radius":15, "visible":true, "opacity":60});
		
		var testData={max: 46,data: mapData};
		
		// this is important, because if you set the data set too early, the latlng/pixel projection doesn't work
		google.maps.event.addListenerOnce(map, "idle", function(){
			heatmap.setDataSet(testData);
		});
	},
	refresh: function(full_date){
			canAble=0;
			//load map data			
			var loadingNote='<img src="/verve_style/images/loading-16.gif" style="float:right;margin-right: 5px;"/>';
			$("#title_map").append(loadingNote);
			var dataString=$('#control_panel_form').serialize()+'&full_date='+full_date;
			$.ajax({
			  url: mapDataURL,
			  dataType: 'json',
			  data: dataString,
			  success: function(data){
				
				mapData=data.mapData;
				var testData={
					max: 46,
					data: mapData
				};
				
				heatmap.setDataSet(testData);
				MetaLayer.refreshMarkersCluster();	
				loadingNote='By Date <b>'+full_date+'</b> With ID= <b>'+$('#lc_flightID input:checked').attr('value')+'</b> And Event name= <b>'+$('#lc_eventName input:checked').attr('value')+'</b>';
				$("#title_map").empty();
				$("#title_map").append(loadingNote);
				canAble=1;
			  }
			 });
	},
	autoIncrement: function(){
		if(canAble==0){
			setTimeout(function(){
				MetaLayer.autoIncrement();
			},autoIncrementTime);
			return false;
		}else{
			var date=parseDateConvert(current_date).addDays(1);
			var stop_date=parseDateConvert(end_date);
			
			if(date<=stop_date ){
				current_date=parseDate(date);
				MetaLayer.refresh(current_date);	
				setTimeout(function(){
					MetaLayer.autoIncrement();
				},autoIncrementTime);
			}else{
				if(autoIncrementRepeat==1){
					current_date=start_date;
					MetaLayer.refresh(current_date);
					setTimeout(function(){
						MetaLayer.autoIncrement();
					},autoIncrementTime);
				}else{
					MetaLayer.summation();
				}
			}
		}

	},
	summation: function(){
			if(canAble==0){
				return false;
			}
			canAble=0;
			//load map data	
		
			var loadingNote='<img src="/verve_style/images/loading-16.gif" style="float:right;margin-right: 5px;"/>';
			$("#title_map").append(loadingNote);
			var dataString=$('#control_panel_form').serialize()+'&p_summary=true';
			$.ajax({
			  url: mapDataURL,
			  dataType: 'json',
			  data: dataString,
			  success: function(data){
				
				mapData=data.mapData;
				var testData={max: 46,data: mapData};
				heatmap.setDataSet(testData);
				
				loadingNote='Summary From <b>'+start_date+'</b> To <b>'+end_date+'</b> With ID= <b>'+$('#lc_flightID input:checked').attr('value')+'</b> And Event name= <b>'+$('#lc_eventName input:checked').attr('value')+'</b>';
				$("#title_map").empty();
				$("#title_map").append(loadingNote);
				MetaLayer.refreshMarkersCluster();	
				canAble=1;
			  }
			 });
	},
	refreshMarkersCluster: function(){
				if (markerCluster) {
				  markerCluster.clearMarkers();
				}
				
				var enableMarkersCluster=$('#marketClusterToggle').attr('checked');
				
				if(enableMarkersCluster != 'checked'){
					// not enable markersCluster
					return false;
				}

				var markers = [];
				var eventCounts=[];
				for (var i = 0; i < mapData.length; i++) {
				  var data = mapData[i];
				  var lat=data.lat;
				  var lng=data.lng;
				  var count=data.data;
				  var imageUrl=$('#marker_icon_panel input:checked').attr('value');
				  var image_size=32;
				  if(count>=3){					
					image_size=38;
				  }else if(count>=6){					
					image_size=48;
				  }else if(count>=10){					
					image_size=58;
				  }else if(count>=20){					
					image_size=64;
				  }else if(count>=30){					
					image_size=80;
				  }else if(count>=50){					
					image_size=100;
				  }else if(count>=100){					
					image_size=128;
				  }
				  var markerImage = new google.maps.MarkerImage(imageUrl,new google.maps.Size(image_size, image_size),null,null,new google.maps.Size(image_size, image_size));
				  var latLng = new google.maps.LatLng(lat,lng);
				  var marker = new google.maps.Marker({
					position: latLng,
					title:'Event count='+count,
					icon: markerImage
				  });
					google.maps.event.addListener(marker, 'mouseover', function() {
						//alert('');
					});
				  markers.push(marker);
				  eventCounts.push(count);
				}
				var mcOptions = { gridSize: 50, maxZoom: 15};
				markerCluster = new MarkerClusterer(map,markers,mcOptions,eventCounts,sumEventCount);
	},
	refreshListOfEventName: function(){
		var flight_id=$('#lc_flightID input:checked').attr('value');
		canAble=0;
		$('#lc_eventName').empty();
		$('#lc_eventName').append('Loading...');
		$.ajax({
			  url: getListEventURL,
			  dataType: 'json',
			  data:{p_flight_id:flight_id},
			  success: function(data){
				canAble=1;
				//control panel create list event names
				$('#lc_eventName').empty();
				list_event_names=data.list_event_names;
				createHTMLList(list_event_names,$('#lc_eventName'),'p_event_name','radio');
				createFillter($('#sr_eventName'),$('#lc_eventName'),'name','single');
			  }
			});
	}
};



function parseDate(date){
	var result='';
	var months = new Array('01','02','03','04','05','06','07','08','09','10','11','12');
	var tdate=date.getDate();
	if(tdate<10) tdate='0'+tdate;
	result=date.getFullYear()+'-'+months[date.getMonth()]+'-'+tdate;
	return result;
}
//convert 2012-05-23 to date object
function parseDateConvert(date_string){
	var arrayDate=date_string.split('-');
	var myDate=new Date(arrayDate[0],(arrayDate[1]/1)-1,arrayDate[2]/1);
	return myDate;
}

Date.prototype.addDays = function(days) {
   var dat = new Date(this.valueOf())
   dat.setDate(dat.getDate() + days);
   return dat;
}

function getDates(startDate, stopDate) {
  var dateArray = new Array();
  var currentDate = startDate;
  while (currentDate <= stopDate) {
	dateArray.push( new Date (currentDate) )
	currentDate = currentDate.addDays(1);
  }
  return dateArray;
}
	


function createHTMLList(dataArray,locateDiv,param_name,type){
	$.each(dataArray,function(index,item){
		var value=item.value;
		var name=item.name;
		var title=item.title;
		var node="";
		if(index==0){
		node='<input type="'+type+'" id="'+index+'_'+param_name+'" name="'+param_name+'" title="'+title+'" value="'+value+'" checked="checked"/>'
		+'<label class="radio_checkbox" title="'+title+'" for="'+index+'_'+param_name+'">'+name+'</label><br />';		
		}else{
		node='<input type="'+type+'" id="'+index+'_'+param_name+'" name="'+param_name+'" title="'+title+'" value="'+value+'" />'
		+'<label class="radio_checkbox" title="'+title+'" for="'+index+'_'+param_name+'">'+name+'</label><br />';		
		}
		
		locateDiv.append(node);
		
		//alert(node);
		});
}


function createFillter(box_filter,check_box_list,fillter_by,select_type){
		box_filter.keyup(function(){
			var fillter_value=box_filter.attr('value').toLowerCase();
			if(fillter_value != ''){
				var list=check_box_list.children('input:not(:checked)');
				//alert(list.length);
				list.each(function(index){
					var inputELM=$(this);
					var labelELM=$(this).next('label');
					var valueOfItem=inputELM.attr('value');
					if(fillter_by=='name'){
						valueOfItem=labelELM.text();
					}
					if(fillter_by=='title'){
						valueOfItem=inputELM.attr('title');
					}
					valueOfItem=valueOfItem.toLowerCase();
					//alert(valueOfItem);
					if(valueOfItem.indexOf(fillter_value)>-1){
						inputELM.show();
						labelELM.show();
					}else{
						inputELM.hide();
						labelELM.hide();
					}
				});
				
			}else{
				var list=check_box_list.children('input');
				list.each(function(index){
					var inputELM=$(this);
					var labelELM=$(this).next('label');	
					inputELM.show();
					labelELM.show();					
				});
			}
		});
}		

function sumEventCount(eventCounts) {
	var total=0
	for (var i=0;i<eventCounts.length; i++) {
		total=total+parseFloat(eventCounts[i])
	}
	return total;
};
