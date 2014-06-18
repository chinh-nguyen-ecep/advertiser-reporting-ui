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
		selectStartDate=new Date(dateRangeArray[0]);
		selectEndDate=new Date(dateRangeArray[1]);
	}

//var selectStartDate=new Date('2013-10-01');
//var selectEndDate=new Date('2013-10-07');
var chart;// chart object
var subtitle; // subtitle of chart
var title; // titile of chart
var categories=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];	 //hour category of chart
var p_dma_ids=[];// array content list of dma ids user selected
var series_1=[]; // impressions data
var series_2=[]; // pay amount data
var series_3=[]; // avg paid price data
var series_4=[]; // avg bid price
var table_data=[]; // data to show by table
var myTable; // table object
var myDateRangeInput; // Date rang input object
var breakBy='hour'; // The value status of break by hour or break by date
var measure='Impressions'; // The value of measure value
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
	loadChart();
});

	//function load chart
	function loadChart(){
		myDateRangeInput.disable();
		series_1=[];
		series_2=[];
		series_3=[];
		series_4=[];
		var dateRange_value='where[full_date.between]='+urlMaster.getParam('where[full_date.between]');
		var where_value='';
		if($('#exchange_filter').val()!='All Exchanges'){
 			where_value="&where[exchanger]="+$('#exchange_filter').val(); 			
 		}
		
		var url=apiRootUrl+'/dailyExchangeCostAnalysisByHour?select=full_date|hour24_of_day&limit=2000&'+dateRange_value+"&by=imp_cnt|paid_amount|avg_bid_price|avg_paid_price&order=full_date|hour24_of_day"+where_value;
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
				mydialog.setTitle("Daily Exchanger Payout Message!");
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
		  		table_colums: ['Date','Hour','Impressions','Paid Amount','Avg Paid Price','Avg Bid Price'],
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
		  		changeMeasure(measureActive);		  		
		  	}	
		  	
		  	//unable date range input
		  	myDateRangeInput.unable();
		};
	}

	//function generate chart . When options are changed, run this function to redraw the chart
	function drawChart(categories,series,title,subtitle,format){
		console.log('Draw chart');
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
	                title: {
	                    text: 'Count'
	                },
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
		if(measure=='Impressions'){
			series=series_1; 
			title+=" Impressions ";
			_format='number';
		}else if(measure=='Paid Amount'){
			series=series_2;
			title+=" Paid Amount ";
		}else if(measure=='Avg Paid Price'){
			series=series_3;
			title+=" Avg Paid Price ";
		}else if(measure=='Avg Bid Price'){
			series=series_4;
			title+=" Avg Bid Price ";
		}
		
		if(breakBy=='hour'){
			_categories=categories;
			title+=" by Hour";
		}
		
		
		drawChart(_categories,series,title,subtitle,_format);
	}
	
	function reviewExportData(){
		var mydialog=new contentDialog();
		mydialog.setTitle('Exchange by Hour From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd'));
		var randomID=new Date().valueOf();
		mydialog.setContent('<div title="'+randomID+'" class="loadingDots" style=""></div>');
		mydialog.setWidth(700);
		mydialog.open();
		var exchanger=$('#exchange_filter').val();
		var loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type=html&jrxml=daily_exchange_payout_by_hour&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=exchangePayout'+"&p_exchange="+exchanger;
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
		var loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type='+exportType+'&jrxml=daily_exchange_payout_by_hour&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=exchangePayout'+"&p_exchange="+exchanger;
		window.open(loadingUrl);
	}
	
	//echanger filter 
	$("#exchange_filter").select2({
	    placeholder: "Select Exchange",
	    allowClear: true
	});
	$("#exchange_filter").change(function(){
		loadChart();		
	});