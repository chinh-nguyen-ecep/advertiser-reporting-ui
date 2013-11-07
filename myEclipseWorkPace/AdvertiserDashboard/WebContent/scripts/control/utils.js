/**
 * 
 */
var loginUser;
var today=new Date();
var yesterday=new Date(new Date().setDate(new Date().getDate()-1));
var thirtyDayBefore=new Date(new Date().setDate(new Date().getDate()-30));
var apiRootUrl='http://'+window.location.hostname+':'+window.location.port +'/advertiserapi';


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
		columns_format:[],
		table_data: [['2013-01-01',10],['2013-01-01',13],['2013-01-01',12]],
		sort_by: '',
		sortable: false,
		sort_type: 'desc',
		onClickRow: function(rowArray){
			
		}
	},settings);
	
	if(settings.sortable && settings.sort_by==''){
		settings.sort_by=settings.table_colums[0];
	}	
	if(settings.sort_by==''){
		refreshData();
	}else{
		settings.sortable=true;
		sort(settings.sort_by);		
	}
	this.next=next;
	this.previous=previous;
	this.sort=sort;
	function next(){
		var maxPage=parseInt(settings.table_data.length/settings.page_items);
		if(settings.table_data.length%settings.page_items>0){
			maxPage=maxPage+1;
		}
		settings.page=settings.page+1;
		if(settings.page>maxPage){
			settings.page=settings.page-1;
		}
		console.log("Next to page: "+settings.page+"/"+maxPage);
		refreshData();
	}
	function previous(){
		
		settings.page=settings.page-1;
		if(settings.page==0){
			settings.page=settings.page+1;
		}
		console.log("Previous to page: "+settings.page);
		refreshData();
	}
	//refresh table with data
	function refreshData(){
		var myTable=$('#'+settings.table_id);
		myTable.empty();
		myTable.addClass('table');
		myTable.addClass('table-bordered');
		myTable.addClass('table-hover');
		//add head table
		var head=$("<thead></thead>");
		var tr='<tr>';
		for(var i=0;i<settings.table_colums.length;i++){
			tr+='<th class="header" title="'+settings.table_colums[i]+'"><a href="#">'+settings.table_colums[i]+'</a><span class="glyphicon glyphicon-sort-by-attributes-alt"></span></th>';
		}
		tr+='</tr>';
		head.append(tr);
		myTable.append(head);
		//add head row
		var body=$('<tbody></tbody>');
		var rows=[];
		var start=0;
		var end=settings.table_data.length;
		if(settings.paging){
			start=(settings.page-1)*settings.page_items;
			end=start+settings.page_items;
			if(end>settings.table_data.length){
				end=settings.table_data.length;
			}
		}
		for(var i=start;i<end;i++){
			var row_data=settings.table_data[i];
			var tr='<tr>';
			for(var j=0;j<row_data.length;j++){
				//format columns				
				if(settings.columns_format[j]=='number'){
					tr+='<td>'+accounting.formatNumber(row_data[j])+'</td>';
				}else
				if(settings.columns_format[j]=='money'){
					tr+='<td>'+accounting.formatMoney(row_data[j])+'</td>';
				}else{
					tr+='<td>'+row_data[j]+'</td>';
				}
				
			}
			tr+='</tr>';
			rows.push(tr);
		}
		body.append(rows.join(''));
		myTable.append(body);	
		
		//add class sort
		if(settings.sort_by!=''){
			var headArray=myTable.find("thead tr th.header[title='"+settings.sort_by+"']").addClass('sort');
		}
		//add sort event
		if(settings.sortable){
			myTable.find("thead tr th.header").click(function(){
				settings.sort_by=$(this).attr('title');
				sort($(this).attr('title'));
			});
		}
		//Add onClick Event
		myTable.find("tbody tr").click(function(){
			var tr=$(this);
			var row=[];
			tr.find("td").each(function(){
				row.push($(this).html());
			});
			
			settings.onClickRow(row);
		});
	}
	//sort table by column id
	function toogleSort(){
		if(settings.sort_type=='desc'){
			settings.sort_type='asc';
		 }else{
			 settings.sort_type='desc';
		 }
	}
	function sort(columnName){
		//get column index
		
		var columnIndex=0;
		$.each(settings.table_colums,function(index,value){
			if(columnName==value){
				columnIndex=index;
			}
		});
		function Comparator(a,b){
			 var first=a[columnIndex];
			 var second=b[columnIndex];
			 var compairType='string';
			 if(IsNumeric(first)){
				 first=parseFloat(a[columnIndex]);
				 second=parseFloat(b[columnIndex]);
				 compairType='number';
			 }
			 	 
			 var result=first > second?1:-1;
			 if(settings.sort_type=='desc'){
				 result=first < second?1:-1;
			 }
//			 console.log(first+" and "+second+" is "+ result+" Comapair type: "+compairType);
			 return result;
		}
		console.log("Sort by column: "+columnName+" "+columnIndex);
		settings.table_data = settings.table_data.sort(Comparator);
		settings.page=1;
		toogleSort();
		refreshData();
	}
}

function disabledEventPropagation(event)
{
	event.stopPropagation();
}

function IsNumeric(input){
    var RE = /^-{0,1}\d*\.{0,1}\d+$/;
    return (RE.test(input));
}

// ajax cache manager
var myAjaxStore=new ajaxStore();
function ajaxStore(){
	var expireTime=20;
	var store=[];
	this.add=add;
	this.get=get;
	this.registe=registe;
	this.isLoading=isLoading;
	function add(url,data){
		var isInStore=false;
		var indexData=-1;
		$.each(store,function(index,item){
			if(item.url==url){
				isInStore=true;
				indexData=index;
				store[index].data=data;
			}
		});
		if(!isInStore){
			var row={
					url: url,
					data: data,
					dateTime: new Date()
			};
			
		}
		console.log('Push data to ajax store: '+url);
		store.push(row);
	}
	function get(url){
		var isInStore=false;
		var result=null;
		$.each(store,function(index,value){
			if(value.url==url){
				isInStore=true;
				result=value.data;
				console.log("Got data: "+url);
				console.log("Time expire: "+(new Date()-value.dateTime));
				console.log("Data: "+value.data);
			}
		});
		return result;
	}
	function registe(url){
		var isInStore=false;
		var indexData=-1;
		$.each(store,function(index,item){
			if(item.url==url){
				isInStore=true;
				indexData=index;
				store[index].data='isLoading';
			}
		});
		if(!isInStore){
			var row={
					url: url,
					data: 'isLoading',
					dateTime: new Date()
			};
			store.push(row);
		}
	}
	function isLoading(url){
		var isInStore=false;
		var indexData=-1;
		var isLoading=false;
		$.each(store,function(index,item){
			if(item.url==url){
				isInStore=true;
				indexData=index;
				if(item.data=='isLoading'){
					isLoading=true;
				}
			}
		});
		return isLoading;
	}
};

