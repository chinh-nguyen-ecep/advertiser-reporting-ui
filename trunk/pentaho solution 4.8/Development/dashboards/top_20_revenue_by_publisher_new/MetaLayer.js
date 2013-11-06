var report_date="2012-02-10";
var dataURL = pentahoActionURL( "Development", "dashboards/top_20_revenue_by_publisher_new", "GetDataTable.xaction");
var jasperReportURL=pentahoActionURL( "Development", "dashboards/top_20_revenue_by_publisher_new", "JasperReport.xaction");
var oTable;
var MetaLayer ={
	/*startDate: MetaLayer.getLastMonthDate(), // Default start date
	endDate: MetaLayer.getCurrentDate(), // Default end date
	startMonth: MetaLayer.getMonth(), // Default month date*/
};

MetaLayer = {
	init: function(){
		this.initToolbar();
		this.initControlPanel();
		this.initTable();
	},
	initTable: function(){
		oTable = $('#example').dataTable({
			"bSort" : true,
			"bJQueryUI": true,
			"iDisplayLength": 20,
			//"sPaginationType": "full_numbers",
			"bProcessing": true,
			"bServerSide": true,
			"aaSorting": [[ 1, "desc" ]],
			"sAjaxSource": dataURL,
			"fnServerData": fnDataTablesPipeline,
			"fnServerParams": function ( aoData ) {
			aoData.push( { "name": "full_date", "value": report_date } );
			},
			"oLanguage": {
				 "sLengthMenu": 'Display <select><option value="10">10</option><option value="20">20</option><option value="30">30</option><option value="40">40</option><option value="50">50</option><option value="10000">All</option></select> records'
			}
		});
			/* Add events */
			$('#example tbody tr').live('click', function () {
				var sTitle;
				var nTds = $('td', this);
				var publisherName = $(nTds[0]).text();
				var revenue = $(nTds[1]).text();
				$('#jasperReport').html("loading...");
				$.get(jasperReportURL, function(data) {
				  $('#jasperReport').html(data);
				});
			} );
	},
	initControlPanel: function(){
		$( "#dialog-form" ).dialog({
			autoOpen: false,
			height: 300,
			width: 350,
			modal: true,
			resizable: false,
			buttons: {
				"Submit": function() {							
					report_date=$('#full_date').attr('value');
					$('#setDate').button({ label: report_date });
					oTable.fnDraw();
					$( this ).dialog( "close" );
					
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				}
			},
			close: function() {
				allFields.val( "" ).removeClass( "ui-state-error" );
			}
		});
	},
	initToolbar: function(){
		$( "#datepicker" ).attr('value',report_date);
		$( "#datepicker" ).datepicker({
			defaultDate: report_date,
			dateFormat: 'yy-mm-dd',
			onSelect: function(dateText, inst) { 
				report_date=dateText;				
				oTable.fnDraw();
			 }
		});

	}
};


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

  

