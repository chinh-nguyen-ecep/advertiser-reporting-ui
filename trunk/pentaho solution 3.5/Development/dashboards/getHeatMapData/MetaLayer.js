var rootLocate="event_tracker";
var locate="jaspers/getHeatMapData";
var maxDate="";
var minDate="";
var start_date="";
var end_date="";
var current_date="";
var selectedMeasures="";
var p_id="";
var p_event_name="";
var list_event_names=new Array();
var list_flight_ids=new Array();
var getFirstDataURL=pentahoActionURL( rootLocate, locate, "GetFirstData.xaction");
var getListEventURL=pentahoActionURL( rootLocate, locate, "getListEvent.xaction");




var MetaLayer ={
	/*startDate: MetaLayer.getLastMonthDate(), // Default start date
	endDate: MetaLayer.getCurrentDate(), // Default end date
	startMonth: MetaLayer.getMonth(), // Default month date*/
};

MetaLayer =  {
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
			//control panel create list flight ids
			list_flight_ids=data.list_flight_ids;
			createHTMLList(list_flight_ids,$('#lc_flightID'),'p_flight_id','checkbox');
			createFillter($('#sr_flightID'),$('#lc_flightID'),'name','single');	
			$('#lc_flightID input').each(function(index){
				var checkBox=$(this);
				var label=checkBox.next('label');
				checkBox.click(function(){
					//MetaLayer.refreshListOfEventName();
				});		
				label.click(function(){
					//MetaLayer.refreshListOfEventName();
				});				
			});

			MetaLayer.initToolbar();		
			//show control panel button
			$('#control-panel').button({ label: "Control Panel" });
			$('#dialog-form').show();
			//load event name
			MetaLayer.refreshListOfEventName();
		  }
		 });
	},
	initToolbar: function(){	
		$( "#start_date" ).attr('value',start_date);
		$( "#start_date" ).datepicker({
			defaultDate: start_date,
			dateFormat: 'yy-mm-dd',
			regional: ["en-GB"],
			maxDate: maxDate,
			minDate: minDate,
			onSelect: function(dateText, inst) { 
				$( "#end_date" ).datepicker( "option", "minDate", dateText );
				start_date=dateText;
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
			 }
		});
		
		//create control panel
		$( "#dialog-form" ).dialog({
			autoOpen: true,
			height: 430,
			width: 465,
			modal: true,
			position: [350,100],
			resizable: false,
			buttons: {
				"OK": function() {
					MetaLayer.refreshOlap();
					$( this ).dialog( "close" );
							 
				},
				Cancel: function() {					
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
	},
	refreshListOfEventName: function(){
		var flight_id=$('#lc_flightID input:checked').attr('value');
		$('#lc_eventName').empty();
		$('#lc_eventName').append('Loading...');
		$.ajax({
			  url: getListEventURL,
			  dataType: 'json',
			  //data:{p_flight_id:flight_id},
			  success: function(data){
				//control panel create list event names
				$('#lc_eventName').empty();
				list_event_names=data.list_event_names;
				createHTMLList(list_event_names,$('#lc_eventName'),'p_event_name','checkbox');
				createFillter($('#sr_eventName'),$('#lc_eventName'),'name','single');
			  }
			});
	},
	refreshOlap: function(){
		var param=new Array();
		if($('#lc_flightID input:checked').length==0){
		 alert("Please select ID!");
		 return false;
		}		
		p_id="";
		$('#lc_flightID input:checked').each(function(index){
			if(index>0){p_id+=';';}
			p_id+=$(this).attr('value');
		});
		p_event_name="";
		$('#lc_eventName input:checked').each(function(index){
			if(index>0){p_event_name+=';';}
			p_event_name+=$(this).attr('value');
		});
		param[0]=new Array(2);
		param[0][0]="p_end_date";
		param[0][1]='"'+end_date+'"';
		param[1]=new Array(2);
		param[1][0]="p_id";
		param[1][1]='"'+p_id+'"';
		
		param[2]=new Array(2);
		param[2][0]="p_start_date";
		param[2][1]='"'+start_date+'"';
		
		param[3]=new Array(2);
		param[3][0]="p_event_name";
		param[3][1]='"'+p_event_name+'"';
		var topTenCustomersPivot = 
		{
		type: "jpivot",
		name: "topTenCustomersPivot",
		solution: rootLocate,
		path: locate,
		action: "Pivot2.xaction",
		htmlObject: "sampleObject",
		parameters:param,
		iframeWidth: "997px",
		iframeHeight: "500px",
		iframeScrolling:"auto",
		executeAtStart: true 
		}

		var components = [topTenCustomersPivot];
		Dashboards.init(components);			
	}
};
  

