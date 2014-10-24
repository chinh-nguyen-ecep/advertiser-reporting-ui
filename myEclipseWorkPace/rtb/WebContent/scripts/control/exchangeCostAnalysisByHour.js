/**
 * 
 */
//
	
	// config var for this page
	var selectStartDate=rollBackSevenDay;
	var selectEndDate=yesterday;
	if(urlMaster.getParam('where[full_date.between]')==''){
		var dateRange=selectStartDate.format('yyyy-mm-dd')+'..'+selectEndDate.format('yyyy-mm-dd');
		urlMaster.replaceParam('where[full_date.between]',dateRange);
	}else{
		var dateRange=urlMaster.getParam('where[full_date.between]');
		var dateRangeArray=dateRange.split("..");
		selectStartDate=verveDateConvert(dateRangeArray[0]);
		selectEndDate=verveDateConvert(dateRangeArray[1]);
	}

//var selectStartDate=new Date('2013-10-01');
//var selectEndDate=new Date('2013-10-07');
var chart;// chart object
var subtitle; // subtitle of chart
var timeZone="America/New_York";
var utcStartDate_epoch=0;
var utcEndDate_epoch=0;
var title; // titile of chart
var categories=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];	 //hour category of chart
var p_dma_ids=[];// array content list of dma ids user selected
var series_1=[]; // Wins data
var series_2=[]; // pay amount data
var series_3=[]; // Ave. Won Price data
var series_4=[]; // Ave. Bid Price
var table_data=[]; // data to show by table
var myTable; // table object
var myTableSummary;
var myDateRangeInput; // Date rang input object
var breakBy='hour'; // The value status of break by hour or break by date
var measure='Wins'; // The value of measure value
$(document).ready(function(){ 
	setTabActive('dailyExchangePayoutByHour');
	myDateRangeInput=new generateDateRange({
		stargetId:"date_range_selector",
		start_date: selectStartDate,
		end_date: selectEndDate,
		callback: function(start_date,end_date,value){
			selectStartDate=start_date;
			selectEndDate=end_date;
			var dateRange=selectStartDate.format('yyyy-mm-dd')+'..'+selectEndDate.format('yyyy-mm-dd');
			urlMaster.replaceParam('where[full_date.between]', dateRange);
			loadChart();
		}
	});
	generateSelectListOfTimezone({
		domSelectId:'timeZone',
		timeZode_df: timeZone, 
		change: function(){
			timeZone=$('#timeZone').val();
			loadChart();
		}
	});
	generateSelectListOfExchange({
			domSelectId:'exchange_filter',
			success: function(){
				loadChart();
			},
			change: function(){
				loadChart();
			}
		});
});

	//function load chart
	function loadChart(){
		myDateRangeInput.disable();
		//convert time zone
		var startDate=selectStartDate.format('yyyy-mm-dd');
		var endDate=selectEndDate.format('yyyy-mm-dd');
		utcStartDate_epoch=moment.tz(startDate+" 00:00:00", timeZone).tz("UTC").unix();
		utcEndDate_epoch=moment.tz(endDate+" 23:00:00", timeZone).tz("UTC").unix();
		// end convert time zone
		
		series_1=[];
		series_2=[];
		series_3=[];
		series_4=[];
		var dateRange_value='where[epoch_hour.between]='+utcStartDate_epoch+'..'+utcEndDate_epoch;
		var where_value='';
		if($('#exchange_filter').val()!='All Exchanges'){
 			where_value="&where[exchange]="+$('#exchange_filter').val(); 			
 		}
		
//		var url=apiRootUrl+'/dailyExchangeCostAnalysisByHour?select=full_date|hour24_of_day&limit=9999&'+dateRange_value+"&by=wins|paid_amount|ave_won_price.avg|ave_bid_price.avg&order=full_date|hour24_of_day"+where_value;
		var url=apiRootUrl+'/dailyExchangeCostAnalysisByHour?select=full_date|epoch_hour&limit=9999&'+dateRange_value+"&by=wins|paid_amount|ave_won_price.avg|ave_bid_price.avg&order=epoch_hour"+where_value;
		if(myAjaxStore.isLoading(url)){
			console.log('Your request is loading...');
			console.log('Callback after '+loadingCallback+'s...');
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
						//Convert data to current timezone
				  		var tempData=[];
				  		$.each(json.data,function(index,row){
				  			console.log(row);
				  			var epoch_hour=row[1];
				  			var day = moment.unix(epoch_hour).tz(timeZone);
				  			var date=day.format('YYYY-MM-DD');
				  			var hour=day.format('H');
				  			row[0]=date;
				  			row[1]=hour;
				  			tempData.push(row);
				  		});
				  		json.data=tempData;
				  		
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
						delayTimeout(2000,function(){
							//location.reload(false);
						});
					}
				},
				complete: function(){
					
				}
				});			
		}else{			
			processData(ajaxData);
			if(ajaxData.data.length==0){
				var mydialog=new contentDialog();
				mydialog.setTitle("Daily Exchange Payout Message!");
				mydialog.setContent("Your data from "+selectStartDate.format('yyyy-mm-dd')+" to "+selectEndDate.format('yyyy-mm-dd')+" is not available.");
				mydialog.open();
			}
		}

		function processData(json){			
		  	title="Exchange Payout Paid By Date Hour";
		  	subtitle="From "+selectStartDate.format("yyyy-mm-dd")+" to "+selectEndDate.format("yyyy-mm-dd");
		  	var responseStatus=json.responseStatus;
		  	var page=json.page;
		  	if(responseStatus=='OK' && page==1){
		  		data=json.data;
		  		var currentDate='';
		  		//this loop add date to series
		  		for(var i=0;i<data.length;i++){				  			
		  			var row=data[i];
		  			var loopDate=row[0];
		  			
		  			if(loopDate!=currentDate){
		  				console.log("currentDate: "+currentDate);
			  			console.log("loopDate: "+loopDate);
		  				var row={name: loopDate,data:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]};
		  				var row2={name: loopDate,data:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]};
		  				var row3={name: loopDate,data:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]};
		  				var row4={name: loopDate,data:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]};
		  				series_1.push(row);
		  				series_2.push(row2);
		  				series_3.push(row3);
		  				series_4.push(row4);
		  				currentDate=loopDate;
		  			}
		  		}
		  		console.log("series_1: "+series_1.length);
		  		
		  		//add value
		  		for(var i=0;i<data.length;i++){
		  			var row=data[i];
		  			var date=row[0];
		  			var hour=row[1];
		  			var first_value=row[2];
		  			var second_value=row[3];
		  			var third_value=row[4];
		  			var fourth_value=row[5];
		  			for(var j=0;j<series_1.length;j++){
			  			var item=series_1[j];	
			  			if(item.name==date){
			  				series_1[j].data[hour]=parseFloat(first_value);
			  				series_2[j].data[hour]=parseFloat(second_value);
			  				series_3[j].data[hour]=parseFloat(third_value);
			  				series_4[j].data[hour]=parseFloat(fourth_value);
			  			}
			  		}
		  		}
		  		
		  	}else{
		  		return;
		  	}

		  	//generate table data
		  	table_data=json.data;		  	
		  	table_data.reverse();
		  	//generate table
		  	myTable=new drawTableFromArray({
		  		table_id: 'daily-advertiser-dataTable',
		  		table_columns: ['Date','Hour','Wins','Paid Amount','Ave. Won Price','Ave. Bid Price'],
		  		columns_format:['','','number','money','money','money'],
		  		table_data: table_data,
		  		page_items: 24,
		  		paging: true,
		  		//sort_by: 'Date',
		  		sortable: false,
		  		onClickRow: function(row){
		  			//alert(row[0]);
		  		}
		  	});
		  			  	
		  	// draw chart
		  	if(chart){
		  		chart.hideLoading();
		  	}
		  	if(breakBy=='hour'){
		  		var measureActive=$('#measuresBt button[class*=active]').get();
		  		if(measureActive.length==0){
		  			combineAllValues();
			  		
		  		}else{
		  			changeMeasure(measureActive);
		  		}
		  			
		  		
		  		
		  	}	
		  	
		  	//unable date range input
		  	myDateRangeInput.unable();
		};
	}

	//function generate chart . When options are changed, run this function to redraw the chart
	function drawChart(categories,series,title,subtitle,format){
		console.log('Draw chart');
		
		$('#combineBt').removeClass('btn-info');
		$('#combineBt').addClass('btn-default');
		
		console.log(JSON.stringify(series));
		 $('#chart-container').highcharts({
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
	                categories: categories,
	                //tickmarkPlacement: 'on',
	                title: {
	                    enabled: false
	                },
	                //gridLineWidth: 1,
	                labels: {
	                    rotation: 0,
	                    formatter: function() {	                    	
	                        return this.value+'h';
	                    }
	                }
	            },
	            yAxis: {
	            	labels: {
	                    formatter: function() {
	                    	var s='';
		                	if(format=='money'){
		                		s="$ "+this.value;
		                	}else if(format=='number'){
		                		s=accounting.formatNumber(this.value);
		                	}else{
		                		s=this.value;
		                	}
	                        return s;
	                    }
	                },
	                title: null,
	                gridLineWidth: 1
	            },
	            legend: {
	                //layout: 'vertical',
	                //align: 'right',
	                //verticalAlign: 'middle',
	                borderWidth: 0
	            },
	            tooltip: {
	                formatter: function() {
	                	var s='';
	                	if(format=='money'){
	                		s='<b>'+ this.series.name +'</b><br/>'+ this.x +'h:'+ accounting.formatMoney(this.y)+'<br/>';
	                	}else if(format=='number'){
	                		s='<b>'+ this.series.name +'</b><br/>'+ this.x +'h:'+ accounting.formatNumber(this.y)+'<br/>';
	                	}else{
	                		s='<b>'+ this.series.name +'</b><br/>'+ this.x +'h:'+ this.y+'<br/>';
	                	}
	                    return s;
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
		 chart=$('#chart-container').highcharts();
	}

	function breakChart(by){
		//hide dma filter button
		$("#dmaFilterBtn").hide();
		$('#measuresBt button').prop('disabled', false);		
		if(by=='date'){
			$('#measuresBt button').prop('disabled', true);
			$('#breakBt button').html('by date<span class="caret"></span>');
		}else if(by=='distance'){
			
			$('#breakBt button').html('by distance<span class="caret"></span>');
		}else if(by=='dma'){
			$("#dmaFilterBtn").show();
			$('#breakBt button').html('by dma<span class="caret"></span>');
		}else{			
			$('#breakBt button').html('by hour<span class="caret"></span>');
		}
		breakBy=by;
		loadChart();
	}
	function changeMeasure(button){
		jqueryButon=$(button);
		measure=jqueryButon.text();
		var _categories;
		var _format='money';
		title="Exchange ";
		var series;
		//
		$('#measuresBt button').removeClass('active');
		jqueryButon.addClass('active');
		if(measure=='Wins'){
			series=series_1; 
			title+=" Wins ";
			_format='number';
		}else if(measure=='Paid Amount'){
			series=series_2;
			title+=" Paid Amount ";
		}else if(measure=='Ave. Won Price'){
			series=series_3;
			title+=" Ave. Won Price ";
		}else if(measure=='Ave. Bid Price'){
			series=series_4;
			title+=" Ave. Bid Price ";
		}
		
		if(breakBy=='hour'){
			_categories=categories;
			title+=" by Hour";
		}
		title+=" ("+timeZone+")";
		
		drawChart(_categories,series,title,subtitle,_format);
		myTable.refresh();
	}
	
	function reviewExportData(){
		var mydialog=new contentDialog();
		mydialog.setTitle('Exchange by Hour From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd')+" ("+timeZone+")");
		var randomID=new Date().valueOf();
		mydialog.setContent('<div title="'+randomID+'" class="loadingDots" style=""></div>');
		mydialog.setWidth(700);
		mydialog.open();
		var exchanger=$('#exchange_filter').val();
		var loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type=html&jrxml=daily_exchange_payout_by_hour&p_timeZone='+timeZone+'&p_start_epoch='+utcStartDate_epoch+'&p_end_epoch='+utcEndDate_epoch+'&path=exchangePayout'+"&p_exchange="+exchanger;
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
		var exchanger=$('#exchange_filter').val();
		var loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type='+exportType+'&jrxml=daily_exchange_payout_by_hour&p_timeZone='+timeZone+'&p_start_epoch='+utcStartDate_epoch+'&p_end_epoch='+utcEndDate_epoch+'&path=exchangePayout'+"&p_exchange="+exchanger;
		window.open(loadingUrl);
	}
	
	////////////////////////////////
	// Combine values
	////////////////////////////////
	function combineAllValues(){
		//
		$('#measuresBt button').removeClass('active');
		$('#combineBt').removeClass('btn-default');
		$('#combineBt').addClass('btn-info');
		
		var combine_series=[
		            {name: 'Paid Amount',data:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]},
		            {name: 'Paid Amount',data:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]},
		            {name: 'Ave. Won Price',data:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]},
		            {name: 'Ave. Bid Price',data:[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]}
		];
		var tableData=[];
		// summary Wins
		for(var i=0;i<combine_series[0].data.length;i++){
			var total_imp=0;
			var total_amount=0;
			var total_paid_price=0;
			var total_bid_price=0;
			
			for (var j=0;j<series_1.length;j++){
				total_imp+=series_1[j].data[i];
				total_amount+=series_2[j].data[i];
				total_paid_price+=series_3[j].data[i];
				total_bid_price+=series_4[j].data[i];
			}
			combine_series[0].data[i]=total_imp;
			combine_series[1].data[i]=total_amount;
			combine_series[2].data[i]=total_paid_price/series_1.length;
			combine_series[3].data[i]=total_bid_price/series_1.length;
			
			row=[i,total_imp,total_amount,total_paid_price/series_1.length,total_bid_price/series_1.length];
			tableData.push(row);
		}
		console.log(combine_series);
		//draw table
		//generate table
	  	myTableSummary=new drawTableFromArray({
	  		table_id: 'daily-advertiser-dataTable',
	  		table_columns: ['Hour','Wins','Paid Amount','Ave. Won Price','Ave. Bid Price'],
	  		columns_format:['','number','money','money','money'],
	  		table_data: tableData,
	  		page_items: 24,
	  		paging: true,
	  		//sort_by: 'Date',
	  		sortable: false,
	  		onClickRow: function(row){
	  			//alert(row[0]);
	  		}
	  	});
	  	rawChart();
	 	//function generate chart 
	 	function rawChart(){
	 		
	 		var chart_title="Combined Exchange Cost ("+timeZone+")";
	 		var exchange=$('#exchange_filter').val();
	 		if(exchange !="All Exchanges"){
	 			chart_title+=" by "+capitalise(exchange);
	 		}
	 		$('#chart-container').highcharts({
	            chart: {
	                zoomType: 'xy'
	            },
	            title: {
	                text: chart_title
	            },
	            subtitle: {
	                text: 'From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd')
	            },
	            credits:{
	            	href: 'http://www.vervemobile.com',
	            	text: 'vervemobile.com'
	            },
	            xAxis: [{
	                categories: categories,
	                //tickmarkPlacement: 'on',
	                title: {
	                    enabled: false
	                },
	                //gridLineWidth: 1,
	                labels: {
	                    rotation: -45,
	                    formatter: function() {	                    	
	                        return this.value+'h';
	                    }
	                }
	            }],
	            yAxis: [{ // Primary
	                labels: {
	                    formatter: function() {
	                        return "$" +accounting.formatNumber(this.value);
	                    },
	                    style: {
	                        color: '#DBA901 '
	                    }
	                },
	                title: {
	                    text: 'Paid Amount',
	                    style: {
	                        color: '#DBA901'
	                    }
	                },
	                opposite: true
	    
	            },
	            { //Second
	                labels: {  
	                	formatter: function() {
	                        return accounting.formatMoney(this.value) ;
	                    },
	                    style: {
	                        color: '#151515'
	                    }
	                },
	                title: {
	                    text: 'Ave. Bid/Won Price',
	                    style: {
	                        color: '#151515'
	                    }
	                }, minorTickInterval: 0.1            
	            },
	            { // Tertiary
	                labels: {
	                    formatter: function() {
	                        return accounting.formatNumber(this.value) ;
	                    },
	                    style: {
	                        color: '#6E6E6E'
	                    }
	                },
	                title: {
	                    text: 'Wins',
	                    style: {
	                        color: '#6E6E6E'
	                    }
	                },   
	                opposite: true
	            }],
	            tooltip: {
	                shared: true,
	                formatter: function() {
	                	var date_Value=this.x;
	                	var s = '<b>'+ date_Value +'h</b>';                    
	                    $.each(this.points, function(i, point) {
	                    	if(point.series.name=='Wins'){
	                    		s += '<br/><font style="color: #6E6E6E;">'+ point.series.name +': '+
	                            accounting.formatNumber(point.y)+'</font>';                    		
	                    	}else if(point.series.name=='Paid Amount'){
	                    		s += '<br/><font style="color: #DBA901;">'+ point.series.name +': '+
	                            accounting.formatMoney(point.y)+'</font>';                    		
	                    	}else if(point.series.name=='Avg Bid Price'){
	                    		s += '<br/><font style="color: #0489B1;">'+ point.series.name +': '+
	                            accounting.formatMoney(point.y)+'</font>';                    		
	                    	}else if(point.series.name=='Avg Won Price'){
	                    		s += '<br/><font style="color: #FA5858;">'+ point.series.name +': '+
	                            accounting.formatMoney(point.y)+'</font>';                    		
	                    	}else{
	                    		s += '<br/>'+ point.series.name +': '+
	                            accounting.formatMoney(point.y);
	                    	}
	                        
	                    });
	                    return s;                    
	                }
	            },
	            legend: {
//	               layout: 'vertical',
//	               align: 'left',
//	               x: 100,
//	               verticalAlign: 'top',
//	               y: 0,
//	               floating: true,
	                backgroundColor: '#FFFFFF'
	            },            
	            series: [{
	                name: 'Paid Amount',
	                color: '#DBA901',
	                type: 'areaspline',                
	                data: combine_series[1].data                  
	            },{
	                name: 'Wins',
	                color: '#6E6E6E',
	                type: 'column',   
	                yAxis: 2,
	                data: combine_series[0].data    
	            }, {
	                name: 'Ave. Bid Price',
	                color: '#0489B1',
	                type: 'line', 
	                yAxis: 1,
	                data: combine_series[3].data
	            },{
	                name: 'Ave. Won Price',
	                color: '#FA5858',
	                type: 'line',
	                yAxis: 1,
	                data: combine_series[2].data    
	            }]
	        });
	 		chart=$('#chart-container').highcharts();
	 	}
	}
	
	
	