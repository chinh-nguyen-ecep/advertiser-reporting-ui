var rootLocate="Development";
var locate="dashboards/daily_process_status";
var process_date="";
var maxDate="";
var dateBefore="";
var minDate="";
var defaultServer='dw3dw3'; //it is the JNDI for connect to the host
var dataURL = pentahoActionURL( rootLocate, locate, "GetListLogFiles.xaction");
//var jasperReportURL=pentahoActionURL( rootLocate, locate, "JasperReport.xaction");
var processStatusDataURL=pentahoActionURL( rootLocate, locate, "ProcessStatus.xaction");
var getFirstDataURL=pentahoActionURL( rootLocate, locate, "GetFirstData.xaction");
var process_concurrent_transURL=pentahoActionURL( rootLocate, locate, "process_concurrent_trans.xaction");
var oTable;
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
			maxDate=data.processCurrentDate;
			minDate=data.minDate;//2012-03-02
			dateBefore=data.dateBefore;//2012-03-01
			process_date=data.processCurrentDate;

			MetaLayer.initToolbar();
			MetaLayer.eventButon();
			MetaLayer.autoRefresh();
		  }
		 });
	},
	initToolbar: function(){
		$( "#datepicker" ).attr('value',process_date);
		$( "#datepicker" ).datepicker({
			defaultDate: process_date,
			dateFormat: 'yy-mm-dd',
			//maxDate: +0,
			minDate: minDate,
			onSelect: function(dateText, inst) { 
				process_date=dateText;
				var arrayDate=process_date.split('-');
				var myDate=new Date(arrayDate[0],(arrayDate[1]/1)-1,arrayDate[2]/1);
				var date = myDate;
				date.setDate(date.getDate()-1);
				dateBefore=parseDate(date);
				MetaLayer.refresh();
			 }
		});
		
		//install digital clock
		$('#digital-clock').clock({offset: '-7', type: 'digital'});
		$('#digital-clock-newyork').clock({offset: '-4', type: 'digital'});
		$('#digital-clock-SaiGon').clock({offset: '+7', type: 'digital'});
		$('#digital-clock-UTC').clock({offset: '+0', type: 'digital'});
	},
	loadProcessStatusData: function(host){
		$.ajax({
		  url: processStatusDataURL,
		  dataType: 'json',
		  data: {'full_date':process_date,'p_server':host},
		  beforeSend: function(){
			//remove old row
			if(host=='dw3dw3'){
				$('#3rdAdnetwork').empty();
				$('#doubleClick').empty();
				$('#adm20').empty();
				$('#adcel').empty();
			}else if(host=='dw6'){
				$('#eventTracker_dw6').empty();
			}else if(host=='dw4'){
				$('#adcel_dw4').empty();
			}else if(host=='dw5'){
				$('#adcel_dw5').empty();
			}
			
			var loadingNote='<tr><td colspan="8" style="text-align: left"><img src="/verve_style/images/loading.gif" /></td></tr>';
			if(host=='dw3dw3'){
				$('#3rdAdnetwork').append(loadingNote);
				$('#doubleClick').append(loadingNote);
				$('#adm20').append(loadingNote);
				$('#adcel').append(loadingNote);
			}else if(host=='dw4'){
				$('#adcel_dw4').append(loadingNote);
			}else if(host=='dw5'){
				$('#adcel_dw5').append(loadingNote);
			}else if(host=='dw6'){
				$('#eventTracker_dw6').append(loadingNote);
			}

		  },
		  success: function(json){
			if(host=='dw3dw3'){
				$('#3rdAdnetwork').empty();
				$('#doubleClick').empty();
				$('#adm20').empty();
				$('#adcel').empty();
			}else if(host=='dw4'){
				$('#adcel_dw4').empty();
			}else if(host=='dw5'){
				$('#adcel_dw5').empty();
			}else if(host=='dw6'){
				$('#eventTracker_dw6').empty();
			}

			var dataArray=json.adata;
			if(dataArray.length==0){
				var noData='<tr><td colspan="8" style="text-align: left">No Process has run today...</td></tr>';
				if(host=='dw3dw3'){
					$('#3rdAdnetwork').append(noData);
					$('#doubleClick').append(noData);
					$('#adm20').append(noData);
					$('#adcel').append(noData);
				}else if(host=='dw4'){
					$('#adcel_dw4').append(noData);
				}else if(host=='dw5'){
					$('#adcel_dw5').append(noData);
				}else if(host=='dw6'){
					$('#eventTracker_dw6').append(noData);
				}

			}
			
			for(var i=0;i<dataArray.length;i++){
				var temp=dataArray[i];
				var process_config_id=temp[0];
				var group_process_name=temp[1];
				var process_description=temp[2];
				var process_status=temp[3];
				var start_date=temp[4];
				var end_date=temp[5];
				var id_process_checking=temp[6];
				var e_star_time=temp[7];
				var e_completion_time=temp[8];
				var note_status=temp[9];
				
				if(start_date=='null') start_date='';
				if(end_date=='null') end_date='';
				
				if(process_status=='Waiting') process_status='<font color="red">'+process_status+'</font>';
				if(process_status=='Processing') process_status='<font color="blue">'+process_status+'</font>';
				if(process_status=='Completed') process_status='<font color="green">'+process_status+'</font>';
				
				if(note_status=='Started late!') note_status='<font color="red">'+note_status+'</font>';
				if(note_status=='Completed late!') note_status='<font color="red">'+note_status+'</font>';
				//note_status='';
				var node='';
				if(i%2==0){
					node+='<tr class="tr1">';
				}else{
					node+='<tr>';
				}
				
				//alert(group_process_name);
				node+='<th><a href="'+process_concurrent_transURL+'&process_id='+id_process_checking+'&p_server='+host+'" title="'+process_description+'-'+id_process_checking+'" rel="1020-300" class="bumpbox">'+process_description+'</a></th>'
				+'<td style="text-align: center">'+process_config_id+'</td>'
				+'<td style="text-align: center">'+process_status+'</td>'
				+'<td>'+start_date+'</td>'
				+'<td>'+e_star_time+'</td>'
				+'<td>'+end_date+'</td>'
				+'<td>'+e_completion_time+'</td>'
				+'<td>'+note_status+'</td>'
				+'</tr>';
				
				if(group_process_name=='3rdAdnetwork' && host == 'dw3dw3'){
					$('#3rdAdnetwork').append(node);
				}else if (group_process_name=='Double Click' && host == 'dw3dw3'){
					$('#doubleClick').append(node);
				}else if (group_process_name=='ADM-DFP' && host == 'dw3dw3'){
					$('#adm20').append(node);
				}else if (group_process_name=='Adcel' && host == 'dw3dw3'){
					$('#adcel').append(node);
				}else if (group_process_name=='Adcel' && host == 'dw4'){
					$('#adcel_dw4').append(node);
				}else if (group_process_name=='Adcel' && host == 'dw5'){
					$('#adcel_dw5').append(node);
				}else if (group_process_name=='Event Tracker' && host == 'dw6'){
					$('#eventTracker_dw6').append(node);
				}
			}
			bumpboxInstall();
		  }
		});
	},
	loadETLStatus: function(dom,group_process,full_date,host){
	var ajaxURL=pentahoActionURL( rootLocate, locate, "CheckLogFileStatus.xaction");
		//adcel
			var a=$.ajax({
			  url: ajaxURL,
			  dataType: 'html',
			  data: {'full_date':full_date,'group_process':group_process,'p_server':host},
			  beforeSend: function(){
				dom.empty();
				var loadingNote='<tr><td colspan="8" style="text-align: left"><img src="/verve_style/images/loading.gif" /></td></tr>';
				dom.append(loadingNote);
			  },
			  success: function(html){
				dom.empty();
				dom.append(html);
			  }
			 });			
	},
	loadLogFilesDetail: function(data_file_config_id,log_title,full_date,host){
				$( "#list_log_files_dl" ).dialog( "destroy" );
				var tempTable=$('#list_log_files_tb').clone();
				oTable = $('#list_log_files_tb').dataTable({
				"bSort" : true,
				"bJQueryUI": true,
				"iDisplayLength": 8,
				//"sPaginationType": "full_numbers",
				"bProcessing": true,
				"bServerSide": true,
				"aaSorting": [[ 2, "asc" ]],
				"sAjaxSource": dataURL,
				"fnServerData": fnDataTablesPipeline,
				"fnServerParams": function ( aoData ) {
				aoData.push( { "name": "full_date", "value": full_date } );
				aoData.push( { "name": "table", "value": 'control.data_file' } );
				aoData.push( { "name": "dimensions", "value": 'data_file_id,file_name,file_timestamp,dt_process_loaded,file_status,staging_load_count,fact_table_load_count' } );
				aoData.push( { "name": "measures", "value": '' } );
				aoData.push( { "name": "search_by", "value": 'file_name' } );
				aoData.push( { "name": "p_server", "value": host } );
				aoData.push( { "name": "data_file_config_id", "value": data_file_config_id } );
				},
				"oLanguage": {
					 "sLengthMenu": 'Display <select><option value="8">8</option><option value="10">10</option><option value="30">30</option><option value="40">40</option><option value="50">50</option><option value="10000">All</option></select> records'
				}
			});
			
			$( "#list_log_files_dl" ).dialog({
				height: 'auto',
				width: 1020,
				position: 'top',
				draggable: true,
				show: "fade",
				title: log_title,
				modal: true,
				resizable: false,
				buttons: {
					Ok: function() {
						$( this ).dialog( "close" );
					}
				},
				close: function(event, ui) {oTable.fnDestroy(true);
				$('#list_log_files_dl').append(tempTable);
				}
			});

	},
	eventButon: function(){
		//daily process status refersh button
		$('#bt_daily_process_status_refresh').click(function(){
			MetaLayer.refresh();
		});	
		
		//install dialog for view detail log files
		$( "#list_log_files_dl" ).dialog({
			autoOpen: false
		});
		
		//init view log files a tag
		
		$('.view_log_detail').click(function(event) {
		  event.preventDefault();
		  var title=$(this).attr('title');
		  var date=dateBefore;
		  if(title == 'ADM Data mart log files'){
			date=process_date;
		  }
		  var data_file_config_id=$(this).attr('rev');
		  //MetaLayer.loadLogFilesDetail(data_file_config_id,title,date);
		});
	},
	autoRefresh: function(){
		MetaLayer.refresh();
		setTimeout(function(){
			MetaLayer.autoRefresh();
		},60000);
	},
	refresh: function(){
		MetaLayer.loadProcessStatusData(defaultServer);
		MetaLayer.loadProcessStatusData('dw6');
		MetaLayer.loadProcessStatusData('dw4');
		MetaLayer.loadProcessStatusData('dw5');
		setTimeout(function(){
			MetaLayer.loadETLStatus($('#adcel_etl_status'),'Adcel',dateBefore,defaultServer);
		},1000);
		setTimeout(function(){
			MetaLayer.loadETLStatus($('#3rd_etl_status'),'3rdAdnetwork',dateBefore,defaultServer);
		},2000);
		setTimeout(function(){
			MetaLayer.loadETLStatus($('#dbclk_etl_status'),'Double Click',process_date,defaultServer);
		},3000);
		setTimeout(function(){
			MetaLayer.loadETLStatus($('#adm_20_etl_status'),'ADM2.0',process_date,defaultServer);
		},4000);
		setTimeout(function(){
			MetaLayer.loadETLStatus($('#adcel_etl_status_dw4'),'Adcel',dateBefore,'dw4');
		},5000);
		setTimeout(function(){
			MetaLayer.loadETLStatus($('#adcel_etl_status_dw5'),'Adcel',dateBefore,'dw5');
		},6000);
		setTimeout(function(){
			MetaLayer.loadETLStatus($('#adcel_etl_status_dw6'),'Adcel',dateBefore,'dw6');
		},7000);
		setTimeout(function(){
			MetaLayer.loadETLStatus($('#event_etl_status_dw6'),'Event Tracker',dateBefore,'dw6');
		},8000);
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

/* When using server-side processing with DataTables, 
it can be quite intensive on your server having an Ajax call every time the user performs some kind of interaction - 
you can effectively DDOS your server with your own application!*/

var oCache = {
    iCacheLower: -1
};
 
function fnSetKey( aoData, sKey, mValue )
{
    for ( var i=0, iLen=aoData.length ; i<iLen ; i++ )
    {
        if ( aoData[i].name == sKey )
        {
            aoData[i].value = mValue;
        }
    }
}
 
function fnGetKey( aoData, sKey )
{
    for ( var i=0, iLen=aoData.length ; i<iLen ; i++ )
    {
        if ( aoData[i].name == sKey )
        {
            return aoData[i].value;
        }
    }
    return null;
}
 
function fnDataTablesPipeline ( sSource, aoData, fnCallback ) {
    var iPipe = 5; /* Ajust the pipe size */
     
    var bNeedServer = false;
    var sEcho = fnGetKey(aoData, "sEcho");
    var iRequestStart = fnGetKey(aoData, "iDisplayStart");
    var iRequestLength = fnGetKey(aoData, "iDisplayLength");
    var iRequestEnd = iRequestStart + iRequestLength;
    oCache.iDisplayStart = iRequestStart;
     
    /* outside pipeline? */
    if ( oCache.iCacheLower < 0 || iRequestStart < oCache.iCacheLower || iRequestEnd > oCache.iCacheUpper )
    {
        bNeedServer = true;
    }
     
    /* sorting etc changed? */
    if ( oCache.lastRequest && !bNeedServer )
    {
        for( var i=0, iLen=aoData.length ; i<iLen ; i++ )
        {
            if ( aoData[i].name != "iDisplayStart" && aoData[i].name != "iDisplayLength" && aoData[i].name != "sEcho" )
            {
                if ( aoData[i].value != oCache.lastRequest[i].value )
                {
                    bNeedServer = true;
                    break;
                }
            }
        }
    }
     
    /* Store the request for checking next time around */
    oCache.lastRequest = aoData.slice();
     
    if ( bNeedServer )
    {
        if ( iRequestStart < oCache.iCacheLower )
        {
            iRequestStart = iRequestStart - (iRequestLength*(iPipe-1));
            if ( iRequestStart < 0 )
            {
                iRequestStart = 0;
            }
        }
         
        oCache.iCacheLower = iRequestStart;
        oCache.iCacheUpper = iRequestStart + (iRequestLength * iPipe);
        oCache.iDisplayLength = fnGetKey( aoData, "iDisplayLength" );
        fnSetKey( aoData, "iDisplayStart", iRequestStart );
        fnSetKey( aoData, "iDisplayLength", iRequestLength*iPipe );
         
        $.getJSON( sSource, aoData, function (json) { 
            /* Callback processing */
            oCache.lastJson = jQuery.extend(true, {}, json);
             
            if ( oCache.iCacheLower != oCache.iDisplayStart )
            {
                json.aaData.splice( 0, oCache.iDisplayStart-oCache.iCacheLower );
            }
            json.aaData.splice( oCache.iDisplayLength, json.aaData.length );
             
            fnCallback(json)
        } );
    }
    else
    {
        json = jQuery.extend(true, {}, oCache.lastJson);
        json.sEcho = sEcho; /* Update the echo for each response */
        json.aaData.splice( 0, iRequestStart-oCache.iCacheLower );
        json.aaData.splice( iRequestLength, json.aaData.length );
        fnCallback(json);
        return;
    }
}

  

