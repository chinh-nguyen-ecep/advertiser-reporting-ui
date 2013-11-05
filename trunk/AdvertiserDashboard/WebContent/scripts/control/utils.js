/**
 * 
 */
var loginUser;
var today=new Date();
var yesterday=new Date(new Date().setDate(new Date().getDate()-1));
var thirtyDayBefore=new Date(new Date().setDate(new Date().getDate()-30));
var apiRootUrl='http://localhost:8080/advertiserapi';


function setTabActive(tab_title){
		$('#page-tab ul li[title='+tab_title+']').attr('class','active');
}

function generateDateRange(settings){
	settings=$.extend({},{stargetId: '',start_date: thirtyDayBefore,end_date: yesterday,callback: function(start_date,end_date,value){}},settings);
 	//function generate date range
		var html=settings.start_date.format('yyyy-mm-dd') + '..' + settings.end_date.format('yyyy-mm-dd');
		 $('#'+settings.stargetId+' span').html(html);
		 $('#'+settings.stargetId+' input').val('where[date.between]='+html);
 		$('#'+settings.stargetId).daterangepicker({
		      ranges: {
		         'Today': [moment(), moment()],
		         'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
		         'Last 7 Days': [moment().subtract('days', 6), moment()],
		         'Last 30 Days': [moment().subtract('days', 29), moment()],
		         'This Month': [moment().startOf('month'), moment().endOf('month')],
		         'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
		      },
		      startDate: moment().subtract('days', 29),
		      endDate: moment(),
		     format: 'YYYY-MM-DD'
		    },
		    function(start, end) {
		    	var html=start.format('YYYY-MM-DD') + '..' + end.format('YYYY-MM-DD');
		    	console.log(html);
		        $('#'+settings.stargetId+' span').html(html);
		        $('#'+settings.stargetId+' input').val('where[date.between]='+html);
		        var startDate=new Date(start.format('YYYY-MM-DD'));
		        var endDate=new Date(end.format('YYYY-MM-DD'));
		        settings.callback(startDate, endDate,html);
		    });	 		

}

