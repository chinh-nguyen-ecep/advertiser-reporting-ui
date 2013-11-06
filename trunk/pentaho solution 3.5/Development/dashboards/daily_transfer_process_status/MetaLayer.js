var rootLocate="Development";
var locate="dashboards/daily_transfer_process_status";
var process_date="";
var maxDate="";
var dateBefore="";
var minDate="";
var defaultServer='dw3'; //it is the JNDI for connect to the host
var dataURL = pentahoActionURL( rootLocate, locate, "GetListLogFiles.xaction");
var getFirstDataURL=pentahoActionURL( rootLocate, locate, "GetFirstData.xaction");
var oTable;
var oTableTempTable=$('#list_log_files_tb').clone();
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
			MetaLayer.loadLogFilesDetail(process_date,defaultServer);
			//MetaLayer.autoRefresh();			
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
	loadLogFilesDetail: function(full_date,host){	
				if(oTable){oTable.fnDestroy(true);}
				$('#list_log_files_dl').append(oTableTempTable);
				oTableTempTable=$('#list_log_files_tb').clone();				
				oTable = $('#list_log_files_tb').dataTable({
				"bSort" : true,
				"bJQueryUI": true,
				"iDisplayLength": 10,
				//"sPaginationType": "full_numbers",
				"bProcessing": true,
				"bServerSide": true,
				"aaSorting": [[ 0, "desc" ]],
				"sAjaxSource": dataURL,
				//"fnServerData": fnDataTablesPipeline,
				"fnServerParams": function ( aoData ) {
				aoData.push( { "name": "full_date", "value": full_date } );
				aoData.push( { "name": "table", "value": 'control.transfer_process_log' } );
				aoData.push( { "name": "dimensions", "value": 'process_id,from_host,table_name,conditions,export_count,start_time,to_host,end_time,import_count,transfer_type,is_complete' } );
				aoData.push( { "name": "measures", "value": '' } );
				aoData.push( { "name": "search_by", "value": 'table_name' } );
				aoData.push( { "name": "p_server", "value": host } );
				},
				"oLanguage": {
					 "sLengthMenu": 'Display <select><option value="10">10</option><option value="15">15</option><option value="40">40</option><option value="50">50</option><option value="70">70</option><option value="10000">All</option></select> records'
				}
			});

	},
	eventButon: function(){
		//daily process status refersh button
		$('#bt_daily_process_status_refresh').click(function(){
			MetaLayer.loadLogFilesDetail(process_date,defaultServer);
		});	
	},
	autoRefresh: function(){
		MetaLayer.refresh();
		setTimeout(function(){
			MetaLayer.autoRefresh();
		},60000);
	},
	refresh: function(){
		MetaLayer.loadLogFilesDetail(process_date,defaultServer);
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

  

