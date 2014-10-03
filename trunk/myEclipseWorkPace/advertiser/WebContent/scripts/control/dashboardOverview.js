/**
 * 
 */
	
	// config var for this page
	var selectStartDate=rollBackSevenDay;
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

	var chart;// chart object
	var subtitle; // subtitle of chart
	var title; // titile of chart
	var categories=['2013/10/01', '2013/10/02', '2013/10/03', '2013/10/04', '2013/10/05', '2013/10/06', '2013/10/07'];
	var clicksData=[75210.53, 60458.54, 59711.42, 48817.37, 77542.50, 75413.57, 76140.97];
	var impressionsData=[49077790, 69571356, 60724855, 73158140, 53020304, 81620436, 74791664];
	var ctaMapData=[49077790, 69571356, 0, 73158140, 53020304, 81620436, 74791664];
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
 				urlMaster.replaceParam('where[date.between]', dateRange);
 				loadChart();
 			}
 		});
 		setTabActive("overview");
 		loadChart();
 	});
 	//function loadChart
 	function loadChart(){
 		console.log('Load overview chart group by Date');
 		myDateRangeInput.disable();
 		var dateRange_value='where[date.between]='+urlMaster.getParam('where[date.between]');
 		var url=apiRootUrl+'/AdvertiserByDate?select=date&limit=2000&'+dateRange_value+"&by=impressions|clicks|cta_maps";
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
					  loadDataForByHour();
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
							location.reload(false);
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
			  	table_data=json.data;
		
			  	myTable=new drawTableFromArray({
			  		table_id: 'dashboard-overview-dataTable',
			  		table_colums: ['Date','Impressions','Clicks','Cta maps'],
			  		columns_format:['','number','number','number'],
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
				clicksData=[];
				impressionsData=[];
				ctaMapData=[];
			  	var temp_data=table_data;
			  	temp_data.reverse();
			  	$.each(temp_data,function(index,row){
			  		var category_value=row[0];
			  		categories.push(category_value);
			  		var click_value=parseFloat(row[2]);
			  		var imp_value=parseFloat(row[1]);
			  		var cta_value=parseFloat(row[3]);
			  		clicksData.push(click_value);
			  		impressionsData.push(imp_value);
			  		ctaMapData.push(cta_value);
			  	});
			  	// draw chart
			  	if(chart){
			  		chart.hideLoading();
			  	}
			  	rawChart();
			  	
			  	//Caculate Average Values
			  	var temp_data=table_data;
			  	temp_data.reverse();
			  	var total_click_value=0;
			  	var total_imp_value=0;
			  	var total_cta_value=0;
			  	$.each(temp_data,function(index,row){
			  		var click_value=row[2];
			  		var imp_value=row[1];
			  		var cta_value=row[3];
			  		total_click_value=total_click_value+parseFloat(click_value);
			  		total_imp_value=total_imp_value+parseFloat(imp_value);
			  		total_cta_value=total_cta_value+parseFloat(cta_value);
			  	});
			  		//Set average value
			  		$('span.av-cli').html(''+accounting.formatNumber(total_click_value/temp_data.length));
			  		$('span.av-imp').html(''+accounting.formatNumber(total_imp_value/temp_data.length));
			  		$('span.av-cta').html(''+accounting.formatNumber(total_cta_value/temp_data.length));
			}
		  	//unable date range input
		  	myDateRangeInput.unable();
		}
 	}
 	//function generate chart 
 	function rawChart(){
 		$('#container').highcharts({
            chart: {
                zoomType: 'xy'
            },
            title: {
                text: 'Advertiser Overview'
            },
            subtitle: {
                text: 'From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd')
            },
            credits:{
            	href: 'http://vervemobile.com',
            	text: 'vervemobile.com'
            },
            xAxis: [{
                categories: categories,
                tickmarkPlacement: 'on',
                title: {
                    enabled: false
                },
                gridLineWidth: 1,
                labels: {
                    rotation: -45,
                    formatter: function() {
                    	var value=this.value;
                    	var now=new Date(value);
                        return now.format("mmm d");
                    }
                }
            }],
            yAxis: [{ // Primary yAxis
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
            tooltip: {
                shared: true
            },
            legend: {
               // layout: 'vertical',
                //align: 'left',
               // x: 100,
               // verticalAlign: 'top',
                //y: 20,
               // floating: true,
                backgroundColor: '#FFFFFF'
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
            series: [{
                name: 'Impressions',
                color: '#4572A7',
                type: 'areaspline',
                yAxis: 1,
                data: impressionsData
                
    
            }, {
                name: 'Clicks',
                color: '#89A54E',
                type: 'spline',
                data: clicksData
               
            }, {
                name: 'Cta map',
                color: '#AA4643',
                type: 'spline',
                data: ctaMapData,
                yAxis: 2
                
            }]
        });
 		chart=$('#container').highcharts();
 	}
 	//function load data for hour level
 	function loadDataForByHour(){
 		var dateRange_value='where[date.between]='+urlMaster.getParam('where[date.between]');
 		var url=apiRootUrl+'/AdvertiserByHour?select=date|hour&limit=2000&'+dateRange_value+"&by=impressions|clicks|cta_maps";
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
		mydialog.setTitle('Daily Advertiser by Date Hour From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd'));
		var randomID=new Date().valueOf();
		mydialog.setContent('<div title="'+randomID+'" class="loadingDots" style=""></div>');
		mydialog.setWidth(700);
		mydialog.open();
		
		mydialog.setTitle('Daily Advertiser by Date From '+selectStartDate.format('yyyy-mm-dd')+' To '+selectEndDate.format('yyyy-mm-dd'));
		var	loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type=html&jrxml=daily_advertiser_report&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=dailyAdvertiser';
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
		var	loadingUrl=rootUrl+'/GenerateJasperReport'+'?export_type='+exportType+'&jrxml=daily_advertiser_report&p_end_date='+selectEndDate.format('yyyy-mm-dd')+'&p_start_date='+selectStartDate.format('yyyy-mm-dd')+'&path=dailyAdvertiser';
		window.open(loadingUrl);
	}