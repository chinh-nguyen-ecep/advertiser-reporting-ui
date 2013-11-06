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

function drawTableFromArray(settings){
	settings=$.extend({},{
		paging: false,
		page: 1,
		page_items: 10,
		table_id: 'myTable',
		table_colums: ['Date','values'],
		table_data: [['2013-01-01',10],['2013-01-01',13],['2013-01-01',12]]
	},settings);
	var myTable=$('#'+settings.table_id);
	myTable.empty();
	myTable.addClass('table');
	myTable.addClass('table-bordered');
	myTable.addClass('table-hover');
	//add head table
	var head=$("<thead></thead>");
	var tr='<tr>';
	for(var i=0;i<settings.table_colums.length;i++){
		tr+='<th class="header"><a href="#">'+settings.table_colums[i]+'</a><span class="glyphicon glyphicon-sort-by-attributes-alt"></span></th>';
	}
	tr+='</tr>';
	head.append(tr);
	myTable.append(head);
	//add head row
	var body=$('<tbody></tbody>');
	var rows=[];
	var start=0;
	var end=settings.table_data.length;
	if(paging){
		start=(settings.page-1)*settings.page_items;
		end=start+settings.page_items-1;
	}
	for(var i=start;i<end;i++){
		var row_data=settings.table_data[i];
		var tr='<tr>';
		for(var j=0;j<row_data.length;j++){
			tr+='<td>'+row_data[j]+'</td>';
		}
		tr+='</tr>';
		rows.push(tr);
	}
	body.append(rows.join(''));
	myTable.append(body);
}

