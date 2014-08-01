/**
 * 
 */
	
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

	var chart;// chart object
	var subtitle; // subtitle of chart
	var title; // titile of chart
	var categories=['2013/10/01', '2013/10/02', '2013/10/03', '2013/10/04', '2013/10/05', '2013/10/06', '2013/10/07'];
	var firstData=[75210.53, 60458.54, 59711.42, 48817.37, 77542.50, 75413.57, 76140.97];
	var secondData=[49077790, 69571356, 60724855, 73158140, 53020304, 81620436, 74791664];
	var thirdData=[49077790, 69571356, 0, 73158140, 53020304, 81620436, 74791664];
	var fourData=[49077790, 69571356, 0, 73158140, 53020304, 81620436, 74791664];
	var table_data=[]; // data to show by table
	var myTable; // table object
	var myDateRangeInput; // Date rang input object
 	$( document ).ready(function() {
 		myDateRangeInput=new generateDateRange({
 			stargetId:"overview-date_range",
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
 		setTabActive("overview");
 		loadChart();
 	});
 	//
 	//function loadChart
 	//
 	function loadChart(){
 		console.log('Load overview chart group by Date');
 		myDateRangeInput.disable();
 		var dateRange_value='where[full_date.between]='+urlMaster.getParam('where[full_date.between]');
 		var where_value='';
 		
 		if($('#exchange_filter').val()!='All Exchanges'){
 			where_value="&where[exchange]="+$('#exchange_filter').val(); 			
 		}
 		var url=apiRootUrl+'/dailyExchangeCostAnalysis?select=full_date&limit=99999&'+dateRange_value+"&by=wins|paid_amount|ave_paid_price.avg|ave_bid_price.avg|adcel_filled_imps|event_imps|event_clicks|bids"+where_value;
 		console.log('Url: '+url);
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
				timeout: 10000,
				xhrFields: {
					      withCredentials: true
				},
				success: function(json){					  
					  myAjaxStore.add(url,json);
					  console.log('Load ajax request successfull with url: '+url);
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
				mydialog.setTitle("Dashboard Overview Message!");
				mydialog.setContent("Your data from "+selectStartDate.format('yyyy-mm-dd')+" to "+selectEndDate.format('yyyy-mm-dd')+" is not available.");
				mydialog.open();
			}
		}
		function processData(json){
			var responseStatus=json.responseStatus;
			var page=json.page;
			if(responseStatus=='OK' && page==1){
				data=json.data;
			  	//generate table data
				table_data=[];
				var temp_data=json.data;
				for(var i=0;i<temp_data.length;i++){
					var row=temp_data[i];
					var ctr=parseFloat(row[6]) == 0 ? 0 : parseFloat(row[7])/parseFloat(row[6]);
					var bids=parseFloat(row[8]);
					var winrate= bids == 0 ? 0 : parseFloat(row[1])/bids;
					var adcel_filled_rate=parseFloat(row[1]) == 0 ? 0: parseFloat(row[5])/parseFloat(row[1]);
					console.log(ctr);
					table_data.push([row[0],row[1],row[2],row[3],row[4],bids,winrate,row[5],adcel_filled_rate,row[6],row[7],ctr]);
				}
			  	console.log(table_data);
			  	myTable=new drawTableFromArray({
			  		table_id: 'dashboard-overview-dataTable',
			  		table_columns: ['Date&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;','Wins','Paid Amount','Ave. Paid Price','Ave. Bid Price','Bids','Winrate %','AdCel - Filled Imps','(AdCel - Filled Imps/ Wins) %','Event - Imps','Event - Clicks','Event - CTR'],
			  		columns_format:['date','number','money','money','money','number','%','number','%','number','number','%'],
			  		table_data: table_data,
			  		page_items: 31,
			  		paging: true,
			  		sort_by: 'Date',
			  		sortable: true,
			  		onClickRow: function(row){
			  			//alert(row[0]);
			  		}
			  	});
			  	
			  	//generate data for chart
			  	categories=[];
				firstData=[];
				secondData=[];
				thirdData=[];
				fourData=[];
			  	var temp_data=table_data;
			  	temp_data.reverse();
			  	$.each(temp_data,function(index,row){
			  		var category_value=row[0];
			  		categories.push(category_value);
			  		var first_value=parseFloat(row[1]);
			  		var second_value=parseFloat(row[2]);
			  		var third_value=parseFloat(row[3]);
			  		var four_value=parseFloat(row[4]);
			  		firstData.push(first_value);
			  		secondData.push(second_value);
			  		thirdData.push(third_value);
			  		fourData.push(four_value);
			  	});
			  	// draw chart
			  	if(chart){
			  		chart.hideLoading();
			  	}
			  	rawChart();
			  	
			  	//Caculate Average Values
			  	var temp_data=table_data;
			  	temp_data.reverse();
			  	var total_first_value=0;
			  	var total_second_value=0;
			  	var total_third_value=0;
			  	var total_four_value=0;
			  	$.each(temp_data,function(index,row){
			  		var first_value=row[1];
			  		var second_value=row[2];
			  		var third_value=row[3];
			  		var four_value=row[4];
			  		total_first_value=total_first_value+parseFloat(first_value);
			  		total_second_value=total_second_value+parseFloat(second_value);
			  		total_third_value=total_third_value+parseFloat(third_value);
			  		total_four_value=total_four_value+parseFloat(four_value);
			  	});
			  		//Set average value
			  		$('span.av-impression').html(''+accounting.formatNumber(total_first_value/temp_data.length));
			  		$('span.av-paid-amount').html(''+accounting.formatMoney(total_second_value/temp_data.length));
			  		$('span.av-paid-price').html(''+accounting.formatMoney(total_third_value/temp_data.length));
			  		$('span.av-bid-price').html(''+accounting.formatMoney(total_four_value/temp_data.length));
			  		
			}
		  	//unable date range input
		  	myDateRangeInput.unable();
		}
 	}
 	//function generate chart 
 	function rawChart(){
 		$("#amount_chart_mode_bt").removeClass("active");
 		$("#avg_chart_mode_bt").removeClass("active");
 		$("#amount_chart_mode_bt").addClass("active");
 		var exchange=$('#exchange_filter').val();
 		var chart_title="Exchange Cost Analysis";
 		if(exchange !="All Exchanges"){
 			chart_title+=" by "+capitalise(exchange);
 		}
 		$('#container').highcharts({
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
                    	var value=this.value;
                    	var now=verveDateConvert(value);
                        return now.format("mmm dd");
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
                    text: 'Ave. Bids,Paid Price',
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
                	var date_Value=verveDateConvert(this.x);
                	var s = '<b>'+ date_Value.format('mmm d, yyyy') +'</b>';                    
                    $.each(this.points, function(i, point) {
                    	if(point.series.name=='Wins'){
                    		s += '<br/><font style="color: #6E6E6E;">'+ point.series.name +': '+
                            accounting.formatNumber(point.y)+'</font>';                    		
                    	}else if(point.series.name=='Paid Amount'){
                    		s += '<br/><font style="color: #DBA901;">'+ point.series.name +': '+
                            accounting.formatMoney(point.y)+'</font>';                    		
                    	}else if(point.series.name=='Ave. Bid Price'){
                    		s += '<br/><font style="color: #0489B1;">'+ point.series.name +': '+
                            accounting.formatMoney(point.y)+'</font>';                    		
                    	}else if(point.series.name=='Ave. Paid Price'){
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
//               layout: 'vertical',
//               align: 'left',
//               x: 100,
//               verticalAlign: 'top',
//               y: 0,
//               floating: true,
                backgroundColor: '#FFFFFF'
            },            
            series: [{
                name: 'Paid Amount',
                color: '#DBA901',
                type: 'areaspline',                
                data: secondData                
            },{
                name: 'Wins',
                color: '#6E6E6E',
                type: 'column',   
                yAxis: 2,
                data: firstData    
            }, {
                name: 'Ave. Bid Price',
                color: '#0489B1',
                type: 'line', 
                yAxis: 1,
                data: fourData
            },{
                name: 'Ave. Paid Price',
                color: '#FA5858',
                type: 'line',
                yAxis: 1,
                data: thirdData    
            }]
        });
 		chart=$('#container').highcharts();
 	}
 	
 	//function load data for hour level
 	function loadDataForByHour(){
 		var dateRange_value='where[full_date.between]='+urlMaster.getParam('where[full_date.between]');
 		var url=apiRootUrl+'/revenueByHour?select=full_date|hour24_of_day&limit=2000&'+dateRange_value+"&by=pais|pid";
 		if(myAjaxStore.isLoading(url)){
			return;
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
				},
				error: function(xhr,status,error){
					myAjaxStore.remove(url);
				},
				complete: function(){
					
				}
				  
				});			
		}else{
		}
 	}
	function reviewExportData(){
		var mydialog=new contentDialog();
		var randomID=new Date().valueOf();
		mydialog.setContent('<div title="'+randomID+'" class="loadingDots" style=""></div>');
		mydialog.setWidth(1300);
		mydialog.open();
		
		mydialog.setTitle('Exchange Cost Analysis From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd'));
		var exchanger=$('#exchange_filter').val();
		var	loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type=html&jrxml=daily_exchanger_payout&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=exchangePayout'+"&p_exchange="+exchanger;
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
		var	loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type='+exportType+'&jrxml=daily_exchanger_payout&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=exchangePayout'+"&p_exchange="+exchanger;
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
	