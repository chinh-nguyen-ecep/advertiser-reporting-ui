/**
 * 
 */
//
	
	// config var for this page
	var selectStartDate=thirtyDayBefore;
	var selectEndDate=yesterday;
	if(urlMaster.getParam('where[date.between]')==''){
		var dateRange=selectStartDate.format('yyyy-mm-dd')+'..'+selectEndDate.format('yyyy-mm-dd');
		urlMaster.replaceParam('where[date.between]',dateRange);
	}else{
		var dateRange=urlMaster.getParam('where[date.between]');
		var dateRangeArray=dateRange.split("..");
		selectStartDate=new Date(dateRangeArray[0]);
		selectEndDate=new Date(dateRangeArray[1]);
	}

//var selectStartDate=new Date('2013-10-01');
//var selectEndDate=new Date('2013-10-07');
var chart;// chart object
var subtitle; // subtitle of chart
var title; // titile of chart
var categories=[-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];	 //hour category of chart
var categories_date=['2013-10-01','2013-10-02','2013-10-03'];// date category of chart
var chart_date_data=[{
		name:'Impressions',
		color: '#4572A7',
		type: 'areaspline',
		yAxis: 1,
		data:[100,120,340]
	},
    {
		name:'Cta map',
		type: 'spline',
        color: '#AA4643',
        yAxis: 2,
		data:[45,23,134],
		marker: {
            enabled: false
        }
	},
	{
		name:'Clicks',
		color: '#89A54E',
        type: 'spline',
		data:[10,12,34]
	}];
var series_clicks=[]; // click data
var series_impressions=[]; // impression data
var series_cta=[]; // cta data
var table_data=[]; // data to show by table
var myTable; // table object
var myDateRangeInput; // Date rang input object
var breakBy='hour'; // The value status of break by hour or break by date

$(document).ready(function(){ 
	setTabActive('dailyAdvertiser');
	myDateRangeInput=new generateDateRange({
		stargetId:"date_range_dailyAdvertiser",
		start_date: selectStartDate,
		end_date: selectEndDate,
		callback: function(start_date,end_date,value){
			selectStartDate=start_date;
			selectEndDate=end_date;
			var dateRange=selectStartDate.format('yyyy-mm-dd')+'..'+selectEndDate.format('yyyy-mm-dd');
			urlMaster.replaceParam('where[date.between]', dateRange);
			loadChart();
		}
	});
	loadChart();
});

	//function load chart
	function loadChart(){
		myDateRangeInput.disable();
		series_clicks=[];
		series_impressions=[];
		series_cta=[];
		var dateRange_value='where[date.between]='+urlMaster.getParam('where[date.between]');
		var measureValue=$("#e2").val();
		var url=apiRootUrl+'/AdvertiserByHour?select=date|hour&limit=2000&'+dateRange_value+"&by=clicks|impressions|cta_maps";
		if(myAjaxStore.isLoading(url)){
			console.log('Your request is loading...');
			console.log('Callback after 30s...');
			delayTimeout(loadingCallback,function(){
				loadChart();
			});
			return;
		}
		if(chart !=null){
			chart.showLoading();
		}

		var ajaxData=myAjaxStore.get(url);
		if(ajaxData==null){
			myAjaxStore.registe(url);
			$.ajax({
				dataType: "json",
				url: url,
				timeout: ajaxRequestTimeout,
				xhrFields: {
					      withCredentials: true
		   		},
				success: function(json){
					  myAjaxStore.add(url,json);
					  loadChart();
				},
				error: function(xhr,status,error){
					myAjaxStore.remove(url);
					console.log('Request url error: '+url);
					console.log('Status:  '+status);
					console.log('Error:  '+error);
					console.log('Reload chart!');
					if(error=='timeout'){
						loadChart();
					}else{
						location.reload();
					}
				},
				complete: function(){
					
				}
				});			
		}else{
			processData(ajaxData);
		}

		function processData(json){			
		  	title="Advertiser Clicks By Date Hour";
		  	subtitle="From "+selectStartDate.format("yyyy-mm-dd")+" to "+selectEndDate.format("yyyy-mm-dd");
		  	var responseStatus=json.responseStatus;
		  	var page=json.page;
		  	if(responseStatus=='OK' && page==1){
		  		data=json.data;
		  		var name='';
		  		//this loop add date to series
		  		for(var i=0;i<data.length;i++){				  			
		  			var row=data[i];
		  			var newName=row[0];
		  			if(newName!=name){
//		  				console.log("Add serie: "+newName);
		  				var row={name: newName,data:[]};
		  				var row2={name: newName,data:[]};
		  				var row3={name: newName,data:[]};
		  				series_clicks.push(row);
		  				series_impressions.push(row2);
		  				series_cta.push(row3);
		  				name=newName;
		  			}

		  		}
		  		
		  		//add value
		  		for(var i=0;i<data.length;i++){
		  			var row=data[i];
		  			var newName=row[0];
		  			var value=row[2];
		  			var value_imp=row[3];
		  			var value_cta=row[4];
//		  			console.log("Add Value: "+newName+" ckl "+value+" im "+value_imp+" cta "+value_cta);
		  			for(var j=0;j<series_clicks.length;j++){
			  			var item=series_clicks[j];	
			  			if(item.name==newName){
			  				series_clicks[j].data.push(parseFloat(value));
			  				series_impressions[j].data.push(parseFloat(value_imp));
			  				series_cta[j].data.push(parseFloat(value_cta));
			  			}
			  		}
		  		}
		  		
		  	}else{
		  		return;
		  	}

		  	//generate table data
		  	table_data=json.data;
		  	if(breakBy=='date'){
		  		var items = {}, base, key;
			  	$.each(table_data, function(index, val) {
			  	    key = [val[0]];
			  	    if (!items[key]) {
			  	        items[key] = [0,0,0];
			  	    }
			  	    items[key][0]+=parseFloat(val[2]);
			  	    items[key][1]+=parseFloat(val[3]);
			  	    items[key][2]+=parseFloat(val[4]);
			  	});

			  	table_data = [];
			  	$.each(items, function(key, val) {
			  	    var a=[];
			  	    a=a.concat(key,["All"],val);
			  	    table_data.push(a);
			  	});
		  	}
		  	
		  	//generate table
		  	myTable=new drawTableFromArray({
		  		table_id: 'daily-advertiser-dataTable',
		  		table_colums: ['Date','Hour','Clicks','Impressions','Cta maps'],
		  		columns_format:['','','number','number','number'],
		  		table_data: table_data,
		  		page_items: 25,
		  		paging: true,
		  		sort_by: 'Date',
		  		sortable: true,
		  		onClickRow: function(row){
		  			//alert(row[0]);
		  		}
		  	});
		  	//generate chart data break by date
		  	//add category
		  	categories_date=[];
		  	chart_date_data[0].data=[];
		  	chart_date_data[1].data=[];
		  	chart_date_data[2].data=[];
		  	var temp_data=table_data;
		  	temp_data.reverse();
		  	$.each(temp_data,function(index,row){
		  		var category_value=row[0];
		  		categories_date.push(category_value);
		  		var click_value=row[2];
		  		var imp_value=row[3];
		  		var cta_value=row[4];
		  		chart_date_data[2].data.push(click_value);
		  		chart_date_data[0].data.push(imp_value);
			  	chart_date_data[1].data.push(cta_value);
		  	});
		  	
		  	// draw chart
		  	if(chart){
		  		chart.hideLoading();
		  	}
		  	if(breakBy=='hour'){
		  		drawChart(categories,series_clicks,title,subtitle);
		  	}else{
		  		drawDateChart(categories_date,chart_date_data,'Advertiser By Date',subtitle);
		  	}		  	
		  	//unable date range input
		  	myDateRangeInput.unable();
		};
	}

	//function generate chart . When options are changed, run this function to redraw the chart
	function drawChart(categories,series,title,subtitle){

		console.log('Draw chart');
		
		 $('#daily-advertiser-chart-container').highcharts({
			 	chart: {
				 type: 'spline'
	            },
	            exporting: {
	                enabled: true
	            },
	            title: {
	                text: title,
	                x: -20 //center
	            },
	            subtitle: {
	                text: subtitle,
	                x: -20
	            },
	            credits:{
	            	href: 'http://vervemobile.com',
	            	text: 'vervemobile.com'
	            },
	            xAxis: {
	                categories: categories,
	                tickmarkPlacement: 'on',
	                title: {
	                    enabled: false
	                },
	                gridLineWidth: 1
	            },
	            yAxis: {
	                title: {
	                    text: 'Count'
	                },
	                gridLineWidth: 1
	            },
	            legend: {
	                layout: 'vertical',
	                align: 'right',
	                verticalAlign: 'middle',
	                borderWidth: 0
	            },
	            tooltip: {
	                formatter: function() {
	                    return '<b>'+ this.x +'</b><br/>'+
	                        this.series.name +': '+  accounting.formatNumber(this.y)+'<br/>'
	                }
	            },
	            plotOptions: {
	            	spline: {
	            		lineWidth: 1,
	            		 states: {
	                         hover: {
	                             lineWidth: 2
	                         }
	                     },
	            		marker: {
	                        enabled: false
	                    }
	            	}
	            },
	            series: series
	        });
		 chart=$('#daily-advertiser-chart-container').highcharts();
	}
	//function generate chart . When options are changed, run this function to redraw the chart
	function drawDateChart(categories,series,title,subtitle){
		console.log('Draw chart by date');
		
		 $('#daily-advertiser-chart-container').highcharts({
			 	chart: {
			 		zoomType: 'xy'
	            },
	            exporting: {
	                enabled: true
	            },
	            title: {
	                text: title,
	                x: -20 //center
	            },
	            subtitle: {
	                text: subtitle,
	                x: -20
	            },
	            credits:{
	            	href: 'http://vervemobile.com',
	            	text: 'vervemobile.com'
	            },
	            xAxis: {
	                categories: categories,
	                tickmarkPlacement: 'on',
	                title: {
	                    enabled: false
	                },
	                gridLineWidth: 1,
	                labels:{
	                	formatter: function(){
	                		return new Date(this.value).format('mmm-dd');
	                	},
	                	rotation: -45
	                }
	            },
	            yAxis:[{ // Primary yAxis
	                labels: {
	                    formatter: function() {
	                        return accounting.formatNumber(this.value);
	                    },
	                    style: {
	                        color: '#89A54E'
	                    }
	                },
	                title: {
	                    text: 'Clicks',
	                    style: {
	                        color: '#89A54E'
	                    }
	                },
	                opposite: true
	    
	            }, { // Secondary yAxis
	                gridLineWidth: 0,
	                title: {
	                    text: 'Impressions',
	                    style: {
	                        color: '#4572A7'
	                    }
	                },
	                labels: {
	                    formatter: function() {
	                        return accounting.formatNumber(this.value) ;
	                    },
	                    style: {
	                        color: '#4572A7'
	                    }
	                }
	    
	            }, { // Tertiary yAxis
	                gridLineWidth: 0,
	                title: {
	                    text: 'Cta map',
	                    style: {
	                        color: '#AA4643'
	                    }
	                },
	                labels: {
	                    formatter: function() {
	                        return accounting.formatNumber(this.value) ;
	                    },
	                    style: {
	                        color: '#AA4643'
	                    }
	                },
	                opposite: true
	            }],
	            legend: {
	                layout: 'vertical',
	                align: 'left',
	                x: 120,
	                verticalAlign: 'top',
	                y: 10,
	                floating: true,
	                backgroundColor: '#FFFFFF'
	            },
	            tooltip: {
	                shared: true
	            },
	            plotOptions: {
	            	spline: {
	            		lineWidth: 2,
	            		 states: {
	                         hover: {
	                             lineWidth: 3
	                         }
	                     },
	            		marker: {
	                        enabled: false
	                    }
	            	},
	            	areaspline: {
	            		lineWidth: 1,
	            		 states: {
	                         hover: {
	                             lineWidth: 2
	                         }
	                     },
	            		marker: {
	                        enabled: false
	                    }
	            	}
	            },
	            series: series
	        });
		 chart=$('#daily-advertiser-chart-container').highcharts();
	}

	function breakChart(by){
		if(by=='date'){
			$('#measuresBt button').prop('disabled', true);
			$('#breakBt button').html('by date<span class="caret"></span>');
		}else{
			$('#measuresBt button').prop('disabled', false);
			$('#breakBt button').html('by hour<span class="caret"></span>');
		}
		breakBy=by;
		loadChart();
	}
	
	function reviewExportData(){
		var mydialog=new contentDialog();
		mydialog.setTitle('Daily Advertiser by Date Hour From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd'));
		var randomID=new Date().valueOf();
		mydialog.setContent('<div title="'+randomID+'" class="loadingDots" style=""></div>');
		mydialog.setWidth(700);
		mydialog.open();
		
		var loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type=html&jrxml=daily_advertiser_report_by_hour&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=dailyAdvertiser';
		if(breakBy=='date'){
			mydialog.setTitle('Daily Advertiser by Date From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd'));
			loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type=html&jrxml=daily_advertiser_report&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=dailyAdvertiser';
		}
		var htmlResult;
		
		if(myAjaxStore.isLoading(loadingUrl)){
			mydialog.setContent('Your request is being processed. Please come back later 30s!');
		}else{
			htmlResult=myAjaxStore.get(loadingUrl);
			if(htmlResult==null){
				myAjaxStore.registe(loadingUrl);
				$.ajax({
					url: loadingUrl,
					dataType : 'html',
					success: function(data){
						myAjaxStore.add(loadingUrl,data);
						mydialog.setContent(data);
					},
					error: function(xhr,status,error){
						myAjaxStore.remove(loadingUrl);
						console.log('Generate report fail! ');
						console.log('Url: '+loadingUrl);
					},
					complete: function(jqXHR,textStatus){
						
					}
				});
			}else{
				console.log('Set content for div id title='+randomID);
				mydialog.setContent(htmlResult);
			}
		}
	}
	
	function exportReport(exportType){
		var loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type='+exportType+'&jrxml=daily_advertiser_report_by_hour&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=dailyAdvertiser';
		if(breakBy=='date'){
			loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type='+exportType+'&jrxml=daily_advertiser_report&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=dailyAdvertiser';
		}	
		window.open(loadingUrl);
	}