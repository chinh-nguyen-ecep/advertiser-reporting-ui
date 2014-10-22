/**
 * 
 */
var globalTimeout;
var currentSession=0;
var ajaxRequestTimeout=20000; // the timeout for a ajax request
var loadingCallback=5000; // The time to call back function when got a loading event
var loginUser;
var today=new Date();
var yesterday=new Date(new Date().setDate(new Date().getDate()-1));
var rollBackSevenDay=new Date(new Date().setDate(new Date().getDate()-7));
var thirtyDayBefore=new Date(new Date().setDate(new Date().getDate()-30));
//var apiRootUrl=window.location.protocol+'//'+window.location.hostname+':'+window.location.port +'/vlmoApi';
var apiRootUrl=window.location.protocol+'//'+window.location.hostname+':'+window.location.port +'/rtb/api/v1';
var rootUrl=window.location.protocol+'//'+window.location.hostname+':'+window.location.port +'/rtb';
function setTabActive(tab_title){
		$('#page-tab ul li').removeClass('active');
		$('#page-tab ul li[title=\''+tab_title+'\']').attr('class','active');
}

function generateDateRange(settings){
	settings=$.extend({},{stargetId: '',start_date: thirtyDayBefore,end_date: yesterday,callback: function(start_date,end_date,value){}},settings);
 	//function generate date range
		var html=settings.start_date.format('yyyy-mm-dd') + '..' + settings.end_date.format('yyyy-mm-dd');
		 $('#'+settings.stargetId+' span').html(html);
		 $('#'+settings.stargetId+' input').val('where[date.between]='+html);
			console.log('Unable date range input');		
 	 		$('#'+settings.stargetId).daterangepicker({
 			      ranges: {
// 				         'Today': [moment(), moment()],
 			         'Yesterday': [moment().subtract('days', 1), moment().subtract('days', 1)],
 			         'Last 7 Days': [moment().subtract('days', 6), moment()],
 			         'Last 30 Days': [moment().subtract('days', 29), moment()],
 			         'This Month': [moment().startOf('month'), moment().endOf('month')],
 			         'Last Month': [moment().subtract('month', 1).startOf('month'), moment().subtract('month', 1).endOf('month')]
 			      },
 			      startDate: moment(settings.start_date.format('yyyy-mm-dd'),'YYYY-MM-DD'),
 			      endDate: moment(settings.end_date.format('yyyy-mm-dd'),'YYYY-MM-DD'),
 			      format: 'YYYY-MM-DD',
 			      dateLimit: 31
 			    },
 			    function(start, end) {
 			    	var html=start.format('YYYY-MM-DD') + '..' + end.format('YYYY-MM-DD');
 			    	console.log(html);
 			        $('#'+settings.stargetId+' span').html(html);
 			        $('#'+settings.stargetId+' input').val('where[date.between]='+html);
 			        var startDate=verveDateConvert(start.format('YYYY-MM-DD'));
 			        var endDate=verveDateConvert(end.format('YYYY-MM-DD'));
 			        settings.callback(startDate, endDate,html);
 			    });				
		this.disable=disable;
 		this.unable=unable;
 		this.getValue=getValue;
 		//disable dom
		var disableDom=$('<div></div>');
		disableDom.addClass('loadingDots');
		disableDom.css('width','100px');
		disableDom.css('height','30px');
		disableDom.hide();
		$('#'+settings.stargetId).before(disableDom);
 		function disable(){
 			console.log('Disable date range input ');
 			$('#'+settings.stargetId).hide();
 			disableDom.show();

 		}
 		function unable(){
 			$('#'+settings.stargetId).show();
 			disableDom.hide();
 		}
 		function getValue(){
 			return $('#'+settings.stargetId+' input').val();
 		}
}
//
// function generate list of exchange
//
function generateSelectListOfExchange(settings){
	settings=$.extend({},{	
		domSelectId: '',
		placeholder: 'Select Exchange',
		success: function(){
			
		},
		change: function(){
			
		}
	},settings);
	$.ajax({
		dataType: "json",
		url: apiRootUrl+"/DailyExchangeCostAnalysis?select=exchange&order=exchange&limit=100",
		timeout: 10000,
		xhrFields: {
			withCredentials: true
		},
		success: function(json){
			generate(json);
			
			settings.success();
		},
		error: function(xhr,status,error){
			alert("Error loading list of exchange! "+status+" "+error);
		},
		complete: function(){
			
		}
		  
		});	
	function generate(json){
		var dom=$("#"+settings.domSelectId);
		if(dom!=null){
			dom.html("");
			var data=json.data;
			var rows=[];
			var row='<option value="All Exchanges">All Exchanges</option>';
			rows.push(row);
			$.each(data,function(index,item){
				row='<option value="'+item[0]+'">'+item[0]+"</option>";
				rows.push(row);
			});
			dom.html(rows.join(''));
			//echanger filter 
			dom.select2({
			    placeholder: settings.placeholder,
			    allowClear: true
			});
			dom.change(function(){
				settings.change();		
			});
		}
	}
}
function drawTableFromArray(settings){
	settings=$.extend({},{
		paging: false,
		page: 1,
		page_items: 10,
		table_id: 'myTable',
		table_columns: ['Date','values'],
		columns_format:[],
		table_data: [['2013-01-01',10],['2013-01-01',13],['2013-01-01',12]],
		sort_by: '',
		sortable: false,
		sort_type: 'desc',
		onClickRow: function(rowArray){
			
		}
	},settings);
	
	if(settings.sortable && settings.sort_by==''){
		settings.sort_by=settings.table_columns[0];
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
	this.refresh=refreshData;
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
		myTable.addClass('table-striped');
		myTable.addClass('table-hover');
		//add head table
		var head=$("<thead></thead>");
		head.append('<tr>				<th class="buttons" colspan="12"></th>				</tr>');
		var tr='<tr>';
		for(var i=0;i<settings.table_columns.length;i++){
			tr+='<th class="header" title="'+settings.table_columns[i]+'"><a href="#">'+settings.table_columns[i]+'</a><i style="float: right"></i></th>';
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
					tr+='<td align="right">'+accounting.formatNumber(row_data[j])+'</td>';
				}else
				if(settings.columns_format[j]=='%'){
					tr+='<td align="right">'+accounting.formatNumber(row_data[j]*100,2)+'%</td>';
				}else
				if(settings.columns_format[j]=='money'){
					tr+='<td align="right">'+accounting.formatMoney(row_data[j])+'</td>';
				}else
				if(settings.columns_format[j]=='short date'){
						tr+='<td align="left">'+verveDateConvert(row_data[j]).format('mmm dd')+'</td>';
				}else
				if(settings.columns_format[j]=='date'){
						tr+='<td align="left">'+verveDateConvert(row_data[j]).format('yyyy-mm-dd')+'</td>';
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
			if(settings.sort_type=='asc'){
				myTable.find("thead tr th.header i").removeClass();
				myTable.find("thead tr th.header[title='"+settings.sort_by+"'] i").addClass('fa fa-sort-alpha-asc');
			}else{
				myTable.find("thead tr th.header i").removeClass();
				myTable.find("thead tr th.header[title='"+settings.sort_by+"'] i").addClass('fa fa-sort-alpha-desc');
			}
			
			
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
		//
		$('a').click(function(event){
			console.log();
			if($(this).attr('href')=='#'){
				event.preventDefault();
			}
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
		$.each(settings.table_columns,function(index,value){
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
			 
			 if(first == second){
				 result=0;
			 }
//			 console.log(first+" and "+second+" is "+ result+" Comapair type: "+compairType);
			 return result;
		}
		console.log("Sort by column: "+columnName+" "+columnIndex);
		settings.table_data = settings.table_data.sort(Comparator);
		settings.page=1;
		
		refreshData();
		toogleSort();
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
//myAjaxStore.add(url,data);
//myAjaxStore.registe(url);
//myAjaxStore.isLoading(url);
//myAjaxStore.get(url);
var myAjaxStore=new ajaxStore();
function ajaxStore(){
	var expireTime=3600000000000;//5min
	var store=[];
	this.add=add;
	this.get=get;
	this.registe=registe;
	this.isLoading=isLoading;
	this.openDialogIsLoading=openDialogIsLoading;
	this.remove=remove;
	function add(url,data){
		var isInStore=false;
		var indexData=-1;
		$.each(store,function(index,item){
			if(item.url==url){
				isInStore=true;
				indexData=index;
				store[index].data=data;
				store[index].dateTime=new Date();
			}
		});
		if(!isInStore){
			var row={
					url: url,
					data: data,
					dateTime: new Date()
			};
			console.log('Push data to ajax store: '+row.url);
			store.push(row);
		}

	}
	function remove(url){
		$.each(store,function(index,item){
			if(item.url==url){
				store.splice(index, 1);
			}
		});
	}
	function get(url){
		var isInStore=false;
		var result=null;
		$.each(store,function(index,value){
			if(value.url==url){
				if((new Date()-value.dateTime)<expireTime){
					isInStore=true;
					result=value.data;
				}else{
					
				}
				console.log("Got data from ajaxStore center: "+url);
				console.log("Time expire: "+(new Date()-value.dateTime));
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
				store[index].dateTime=new Date();
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
	function openDialogIsLoading(){
		var myDialog=new contentDialog();
		myDialog.setTitle("Your request is being processed!");
		myDialog.setContent("Server is processing your request. Please select again later 30s.");
		myDialog.open();
	}
};

function contentDialog(){
	var div=$('<div class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"><div class="modal-dialog">  <div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h4 class="modal-title">Modal title</h4></div><div class="modal-body" style="padding-bottom: 0px;"></div><div class="modal-footer" ><button type="button" class="btn btn-default" data-dismiss="modal">Close</button></div></div></div></div>');
	$('body').append(div);
	this.open=open;
	this.hide=hide;
	this.setContent=setContent;
	this.setTitle=setTitle;
	this.setWidth=setWidth;
	this.addDom=addDom;
	this.addButton=addButton;
	//function add button
	// example: addButton({name: 'abc',btnClass:'btn-default',action: function(){}});
	function addButton(btn){
		var name=btn.name;
		var btnClass=btn.btnClass;		
		var myBtn=$('<button type="button" class="btn btn-default" >'+name+'</button>');
		myBtn.removeClass("btn-default");
		myBtn.addClass(btnClass);
		myBtn.click(function(){
			btn.action();			
		});
		div.find('.modal-footer').append(myBtn);
	}

	function addDom(dom){
		div.find('div.modal-body').first().append(dom);		
	}
	function setWidth(width){
		div.find('div.modal-dialog').css('width',width+'px');
	}
	function setTitle(title){
		div.find('h4.modal-title').first().html(title);
	}
	function setContent(newContent){
		div.find('div.modal-body').first().html(newContent);
	}
	function open(){
		div.modal({
			  keyboard: false,
			  backdrop: 'static'
		});
	}
	function hide(){
		div.modal('hide');
	}
}


function delayTimeout(second_time,func){
	if(globalTimeout != null) clearTimeout(globalTimeout); 
	globalTimeout =setTimeout(function(){func();},second_time);
}
var urlMaster=new urlMaster();
function urlMaster(){
	var local=0;
	this.clear=clear;
	this.addParam=addParam;
	this.getParam=getParam;
	this.replaceParam=replaceParam;
	function clear(){
		window.history.replaceState('local '+local, 'Title '+local, rootUrl+"/?f=1");
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

function capitalise(string) {
    return string.charAt(0).toUpperCase() + string.slice(1).toLowerCase();
}

function verveDateConvert(full_date){
	var value = full_date;
	var array=value.split("-");
	var year=parseInt(array[0]);
	var month=parseInt(array[1])-1;
	var day=parseInt(array[2]);
	var date = new Date(year,month,day);
	return date;
}

/**
 * Sand-Signika theme for Highcharts JS
 * @author Torstein Honsi
 */

// Load the fonts
Highcharts.createElement('link', {
   href: 'http://fonts.googleapis.com/css?family=Signika:400,700',
   rel: 'stylesheet',
   type: 'text/css'
}, null, document.getElementsByTagName('head')[0]);

// Add the background image to the container
Highcharts.wrap(Highcharts.Chart.prototype, 'getContainer', function (proceed) {
   proceed.call(this);
   this.container.style.background = 'url(http://www.highcharts.com/samples/graphics/sand.png)';
});


Highcharts.theme = {
   colors: ["#f45b5b", "#8085e9", "#8d4654", "#7798BF", "#aaeeee", "#ff0066", "#eeaaee",
      "#55BF3B", "#DF5353", "#7798BF", "#aaeeee"],
   chart: {
      backgroundColor: null,
      style: {
         fontFamily: "Signika, serif"
      }
   },
   title: {
      style: {
         color: 'black',
         fontSize: '16px',
         fontWeight: 'bold'
      }
   },
   subtitle: {
      style: {
         color: 'black'
      }
   },
   tooltip: {
      borderWidth: 0
   },
   legend: {
      itemStyle: {
         fontWeight: 'bold',
         fontSize: '13px'
      }
   },
   xAxis: {
      labels: {
         style: {
            color: '#6e6e70'
         }
      }
   },
   yAxis: {
      labels: {
         style: {
            color: '#6e6e70'
         }
      }
   },
   plotOptions: {
      series: {
         shadow: true
      },
      candlestick: {
         lineColor: '#404048'
      },
      map: {
         shadow: false
      }
   },

   // Highstock specific
   navigator: {
      xAxis: {
         gridLineColor: '#D0D0D8'
      }
   },
   rangeSelector: {
      buttonTheme: {
         fill: 'white',
         stroke: '#C0C0C8',
         'stroke-width': 1,
         states: {
            select: {
               fill: '#D0D0D8'
            }
         }
      }
   },
   scrollbar: {
      trackBorderColor: '#C0C0C8'
   },

   // General
   background2: '#E0E0E8'
   
};

// Apply the theme
Highcharts.setOptions(Highcharts.theme);

// List time zone
var timeZoneArray=["Africa/Abidjan","Africa/Accra","Africa/Addis_Ababa","Africa/Algiers","Africa/Asmara","Africa/Asmera","Africa/Bamako","Africa/Bangui","Africa/Banjul","Africa/Bissau","Africa/Blantyre","Africa/Brazzaville","Africa/Bujumbura","Africa/Cairo","Africa/Casablanca","Africa/Ceuta","Africa/Conakry","Africa/Dakar","Africa/Dar_es_Salaam","Africa/Djibouti","Africa/Douala","Africa/El_Aaiun","Africa/Freetown","Africa/Gaborone","Africa/Harare","Africa/Johannesburg","Africa/Juba","Africa/Kampala","Africa/Khartoum","Africa/Kigali","Africa/Kinshasa","Africa/Lagos","Africa/Libreville","Africa/Lome","Africa/Luanda","Africa/Lubumbashi","Africa/Lusaka","Africa/Malabo","Africa/Maputo","Africa/Maseru","Africa/Mbabane","Africa/Mogadishu","Africa/Monrovia","Africa/Nairobi","Africa/Ndjamena","Africa/Niamey","Africa/Nouakchott","Africa/Ouagadougou","Africa/Porto-Novo","Africa/Sao_Tome","Africa/Timbuktu","Africa/Tripoli","Africa/Tunis","Africa/Windhoek","America/Adak","America/Anchorage","America/Anguilla","America/Antigua","America/Araguaina","America/Argentina/Buenos_Aires","America/Argentina/Catamarca","America/Argentina/ComodRivadavia","America/Argentina/Cordoba","America/Argentina/Jujuy","America/Argentina/La_Rioja","America/Argentina/Mendoza","America/Argentina/Rio_Gallegos","America/Argentina/Salta","America/Argentina/San_Juan","America/Argentina/San_Luis","America/Argentina/Tucuman","America/Argentina/Ushuaia","America/Aruba","America/Asuncion","America/Atikokan","America/Atka","America/Bahia","America/Bahia_Banderas","America/Barbados","America/Belem","America/Belize","America/Blanc-Sablon","America/Boa_Vista","America/Bogota","America/Boise","America/Buenos_Aires","America/Cambridge_Bay","America/Campo_Grande","America/Cancun","America/Caracas","America/Catamarca","America/Cayenne","America/Cayman","America/Chicago","America/Chihuahua","America/Coral_Harbour","America/Cordoba","America/Costa_Rica","America/Creston","America/Cuiaba","America/Curacao","America/Danmarkshavn","America/Dawson","America/Dawson_Creek","America/Denver","America/Detroit","America/Dominica","America/Edmonton","America/Eirunepe","America/El_Salvador","America/Ensenada","America/Fort_Wayne","America/Fortaleza","America/Glace_Bay","America/Godthab","America/Goose_Bay","America/Grand_Turk","America/Grenada","America/Guadeloupe","America/Guatemala","America/Guayaquil","America/Guyana","America/Halifax","America/Havana","America/Hermosillo","America/Indiana/Indianapolis","America/Indiana/Knox","America/Indiana/Marengo","America/Indiana/Petersburg","America/Indiana/Tell_City","America/Indiana/Valparaiso","America/Indiana/Vevay","America/Indiana/Vincennes","America/Indiana/Winamac","America/Indianapolis","America/Inuvik","America/Iqaluit","America/Jamaica","America/Jujuy","America/Juneau","America/Kentucky/Louisville","America/Kentucky/Monticello","America/Knox_IN","America/Kralendijk","America/La_Paz","America/Lima","America/Los_Angeles","America/Louisville","America/Lower_Princes","America/Maceio","America/Managua","America/Manaus","America/Marigot","America/Martinique","America/Matamoros","America/Mazatlan","America/Mendoza","America/Menominee","America/Merida","America/Metlakatla","America/Mexico_City","America/Miquelon","America/Moncton","America/Monterrey","America/Montevideo","America/Montreal","America/Montserrat","America/Nassau","America/New_York","America/Nipigon","America/Nome","America/Noronha","America/North_Dakota/Beulah","America/North_Dakota/Center","America/North_Dakota/New_Salem","America/Ojinaga","America/Panama","America/Pangnirtung","America/Paramaribo","America/Phoenix","America/Port_of_Spain","America/Port-au-Prince","America/Porto_Acre","America/Porto_Velho","America/Puerto_Rico","America/Rainy_River","America/Rankin_Inlet","America/Recife","America/Regina","America/Resolute","America/Rio_Branco","America/Rosario","America/Santa_Isabel","America/Santarem","America/Santiago","America/Santo_Domingo","America/Sao_Paulo","America/Scoresbysund","America/Shiprock","America/Sitka","America/St_Barthelemy","America/St_Johns","America/St_Kitts","America/St_Lucia","America/St_Thomas","America/St_Vincent","America/Swift_Current","America/Tegucigalpa","America/Thule","America/Thunder_Bay","America/Tijuana","America/Toronto","America/Tortola","America/Vancouver","America/Virgin","America/Whitehorse","America/Winnipeg","America/Yakutat","America/Yellowknife","Antarctica/Casey","Antarctica/Davis","Antarctica/DumontDUrville","Antarctica/Macquarie","Antarctica/Mawson","Antarctica/McMurdo","Antarctica/Palmer","Antarctica/Rothera","Antarctica/South_Pole","Antarctica/Syowa","Antarctica/Troll","Antarctica/Vostok","Arctic/Longyearbyen","Asia/Aden","Asia/Almaty","Asia/Amman","Asia/Anadyr","Asia/Aqtau","Asia/Aqtobe","Asia/Ashgabat","Asia/Ashkhabad","Asia/Baghdad","Asia/Bahrain","Asia/Baku","Asia/Bangkok","Asia/Beirut","Asia/Bishkek","Asia/Brunei","Asia/Calcutta","Asia/Choibalsan","Asia/Chongqing","Asia/Chungking","Asia/Colombo","Asia/Dacca","Asia/Damascus","Asia/Dhaka","Asia/Dili","Asia/Dubai","Asia/Dushanbe","Asia/Gaza","Asia/Harbin","Asia/Hebron","Asia/Ho_Chi_Minh","Asia/Hong_Kong","Asia/Hovd","Asia/Irkutsk","Asia/Istanbul","Asia/Jakarta","Asia/Jayapura","Asia/Jerusalem","Asia/Kabul","Asia/Kamchatka","Asia/Karachi","Asia/Kashgar","Asia/Kathmandu","Asia/Katmandu","Asia/Khandyga","Asia/Kolkata","Asia/Krasnoyarsk","Asia/Kuala_Lumpur","Asia/Kuching","Asia/Kuwait","Asia/Macao","Asia/Macau","Asia/Magadan","Asia/Makassar","Asia/Manila","Asia/Muscat","Asia/Nicosia","Asia/Novokuznetsk","Asia/Novosibirsk","Asia/Omsk","Asia/Oral","Asia/Phnom_Penh","Asia/Pontianak","Asia/Pyongyang","Asia/Qatar","Asia/Qyzylorda","Asia/Rangoon","Asia/Riyadh","Asia/Saigon","Asia/Sakhalin","Asia/Samarkand","Asia/Seoul","Asia/Shanghai","Asia/Singapore","Asia/Taipei","Asia/Tashkent","Asia/Tbilisi","Asia/Tehran","Asia/Tel_Aviv","Asia/Thimbu","Asia/Thimphu","Asia/Tokyo","Asia/Ujung_Pandang","Asia/Ulaanbaatar","Asia/Ulan_Bator","Asia/Urumqi","Asia/Ust-Nera","Asia/Vientiane","Asia/Vladivostok","Asia/Yakutsk","Asia/Yekaterinburg","Asia/Yerevan","Atlantic/Azores","Atlantic/Bermuda","Atlantic/Canary","Atlantic/Cape_Verde","Atlantic/Faeroe","Atlantic/Faroe","Atlantic/Jan_Mayen","Atlantic/Madeira","Atlantic/Reykjavik","Atlantic/South_Georgia","Atlantic/St_Helena","Atlantic/Stanley","Australia/ACT","Australia/Adelaide","Australia/Brisbane","Australia/Broken_Hill","Australia/Canberra","Australia/Currie","Australia/Darwin","Australia/Eucla","Australia/Hobart","Australia/LHI","Australia/Lindeman","Australia/Lord_Howe","Australia/Melbourne","Australia/North","Australia/NSW","Australia/Perth","Australia/Queensland","Australia/South","Australia/Sydney","Australia/Tasmania","Australia/Victoria","Australia/West","Australia/Yancowinna","Brazil/Acre","Brazil/DeNoronha","Brazil/East","Brazil/West","Canada/Atlantic","Canada/Central","Canada/Eastern","Canada/East-Saskatchewan","Canada/Mountain","Canada/Newfoundland","Canada/Pacific","Canada/Saskatchewan","Canada/Yukon","Chile/Continental","Chile/EasterIsland","Cuba","Egypt","Eire","Etc/GMT","Etc/GMT+0","Etc/UCT","Etc/Universal","Etc/UTC","Etc/Zulu","Europe/Amsterdam","Europe/Andorra","Europe/Athens","Europe/Belfast","Europe/Belgrade","Europe/Berlin","Europe/Bratislava","Europe/Brussels","Europe/Bucharest","Europe/Budapest","Europe/Busingen","Europe/Chisinau","Europe/Copenhagen","Europe/Dublin","Europe/Gibraltar","Europe/Guernsey","Europe/Helsinki","Europe/Isle_of_Man","Europe/Istanbul","Europe/Jersey","Europe/Kaliningrad","Europe/Kiev","Europe/Lisbon","Europe/Ljubljana","Europe/London","Europe/Luxembourg","Europe/Madrid","Europe/Malta","Europe/Mariehamn","Europe/Minsk","Europe/Monaco","Europe/Moscow","Europe/Nicosia","Europe/Oslo","Europe/Paris","Europe/Podgorica","Europe/Prague","Europe/Riga","Europe/Rome","Europe/Samara","Europe/San_Marino","Europe/Sarajevo","Europe/Simferopol","Europe/Skopje","Europe/Sofia","Europe/Stockholm","Europe/Tallinn","Europe/Tirane","Europe/Tiraspol","Europe/Uzhgorod","Europe/Vaduz","Europe/Vatican","Europe/Vienna","Europe/Vilnius","Europe/Volgograd","Europe/Warsaw","Europe/Zagreb","Europe/Zaporozhye","Europe/Zurich","GB","GB-Eire","GMT","GMT+0","GMT0","GMT-0","Greenwich","Hongkong","Iceland","Indian/Antananarivo","Indian/Chagos","Indian/Christmas","Indian/Cocos","Indian/Comoro","Indian/Kerguelen","Indian/Mahe","Indian/Maldives","Indian/Mauritius","Indian/Mayotte","Indian/Reunion","Iran","Israel","Jamaica","Japan","Kwajalein","Libya","Mexico/BajaNorte","Mexico/BajaSur","Mexico/General","Navajo","NZ","NZ-CHAT","Pacific/Apia","Pacific/Auckland","Pacific/Chatham","Pacific/Chuuk","Pacific/Easter","Pacific/Efate","Pacific/Enderbury","Pacific/Fakaofo","Pacific/Fiji","Pacific/Funafuti","Pacific/Galapagos","Pacific/Gambier","Pacific/Guadalcanal","Pacific/Guam","Pacific/Honolulu","Pacific/Johnston","Pacific/Kiritimati","Pacific/Kosrae","Pacific/Kwajalein","Pacific/Majuro","Pacific/Marquesas","Pacific/Midway","Pacific/Nauru","Pacific/Niue","Pacific/Norfolk","Pacific/Noumea","Pacific/Pago_Pago","Pacific/Palau","Pacific/Pitcairn","Pacific/Pohnpei","Pacific/Ponape","Pacific/Port_Moresby","Pacific/Rarotonga","Pacific/Saipan","Pacific/Samoa","Pacific/Tahiti","Pacific/Tarawa","Pacific/Tongatapu","Pacific/Truk","Pacific/Wake","Pacific/Wallis","Pacific/Yap","Poland","Portugal","PRC","ROC","ROK","Singapore","Turkey","UCT","Universal","US/Alaska","US/Aleutian","US/Arizona","US/Central","US/Eastern","US/East-Indiana","US/Hawaii","US/Indiana-Starke","US/Michigan","US/Mountain","US/Pacific","US/Samoa","UTC","W-SU","Zulu"];

function generateSelectListOfTimezone(settings){
	settings=$.extend({},{	
		domSelectId: '',
		timeZode_df: 'UTC',
		placeholder: 'Select TimeZone',
		change: function(){
			
		}
	},settings);
	generate();
	function generate(){
		var dom=$("#"+settings.domSelectId);
		if(dom!=null){
			dom.html("");
			var data=timeZoneArray;
			var rows=[];
			$.each(data,function(index,item){
				row='<option value="'+item+'">'+item+"</option>";
				if(item==settings.timeZode_df){
					row='<option selected=selected value="'+item+'">'+item+"</option>";
				}				
				rows.push(row);
			});
			dom.html(rows.join(''));
			//echanger filter 
			dom.select2({
			    placeholder: settings.placeholder,
			    allowClear: true
			});
			dom.change(function(){
				settings.change();		
			});
		}
	}
}