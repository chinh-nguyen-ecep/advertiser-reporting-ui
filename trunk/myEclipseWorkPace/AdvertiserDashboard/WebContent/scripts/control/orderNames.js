/**
 * 
 */
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
	var myDateRangeInput; // Date rang input object
	var start_date='2013/10/01';
	var end_date='2013/10/07';
	$(document).ready(function(){ 
			leftbar();
	 		myDateRangeInput=new generateDateRange({
	 			stargetId:"date_range",
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
			setTabActive("order");
	 		var categories=['2013/10/01', '2013/10/02', '2013/10/03', '2013/10/04', '2013/10/05', '2013/10/06', '2013/10/07'];
	 		var revenueData=[75210.53, 60458.54, 59711.42, 48817.37, 77542.50, 75413.57, 76140.97];
	 		var impressionsData=[49077790, 69571356, 60724855, 73158140, 53020304, 81620436, 74791664];
	 		getChart(categories,revenueData,impressionsData);
    });
	//function generate left select dimention
	function leftbar(){		 
		 $('#selectbox-order').select2({
			    minimumInputLength: 4,
			    ajax: {
			      url: apiRootUrl+"/LookupOrders?select=adm_order_id|adm_order_name&limit=20&order=adm_order_name",
			      quietMillis: 1000,
			      dataType: 'json',
			      data: function (term, page) {
			        return {
			          'where[adm_order_name.like]': term,
			          page: page,
			          'where[dfp_version]': 2
			        };
			      },
			      results: function (data, page) {
			    	  var resultData=data.data;
			    	  var myData= [];
			    	  var more=false;
			    	  if(resultData.length==20){
			    		  more=true;
			    	  }
			    	  $.each(resultData,function(index,item){
			    		  var row={
			    			id: item[0],
			    			text: item[0]+' - '+item[1]
			    		  };
			    		  myData.push(row);
			    	  });
			        return { results: myData ,  more: more};
			      }
			    }
			  }).change(function(e){
				 $('#selectbox-flight').select2('data',{id: 0,text: 'All Flights'});
				 $('#selectbox-creative').select2('data',{id: 0,text: 'All Creatives'});
				  $('#selectbox-creative').select2('enable', false);
				  $('#selectbox-flight').select2('enable', true);
			  });
		 // flight select
		 $('#selectbox-flight').select2({
			    minimumInputLength: 1,
			    ajax: {
			      url: apiRootUrl+"/LookupFlights?select=adm_flight_id|adm_flight_name&limit=20&order=adm_flight_name",
			      quietMillis: 1000,
			      dataType: 'json',
			      data: function (term, page) {
			        return {
			          'where[adm_flight_name.like]': term,
			          page: page,
			          'where[adm_order_id]':  $('#selectbox-order').select2('val'),
			          'where[dfp_version]': 2
			        };
			      },
			      results: function (data, page) {
			    	  var resultData=data.data;
			    	  var myData= [];
			    	  var more=false;
			    	  if(resultData.length==20){
			    		  more=true;
			    	  }
			    	  $.each(resultData,function(index,item){
			    		  var row={
			    			id: item[0],
			    			text: item[0]+' - '+item[1]
			    		  };
			    		  myData.push(row);
			    	  });
			        return { results: myData,more: more };
			      }
			    }
			  }).change(function(e){
				  $('#selectbox-creative').select2('enable', true);
				  $('#selectbox-creative').select2('data',{id: 0,text: 'All Creatives'});
			  });
		 // creative select
		 $('#selectbox-creative').select2({
			    minimumInputLength: 1,
			    ajax: {
			      url: apiRootUrl+"/LookupCreatives?select=adm_creative_id|adm_creative_name&limit=20&order=adm_creative_name",
			      quietMillis: 1000,
			      dataType: 'json',
			      data: function (term, page) {
			        return {
			          'where[adm_creative_name.like]': term,
			          page: page,
			          'where[adm_flight_id]': $('#selectbox-flight').select2('val'),
			          'where[dfp_version]':2
			        };
			      },
			      results: function (data, page) {
			    	  var resultData=data.data;
			    	  var myData= [];
			    	  var more=false;
			    	  if(resultData.length==20){
			    		  more=true;
			    	  }
			    	  $.each(resultData,function(index,item){
			    		  var row={
			    			id: item[0],
			    			text: item[0]+' - '+item[1]
			    		  };
			    		  myData.push(row);
			    	  });
			        return { results: myData, more:more };
			      }
			    }
			  });
		 $('#selectbox-order').select2('data',{id: 0,text: 'All Orders'});
		 $('#selectbox-flight').select2('data',{id: 0,text: 'All Flights'});
		 $('#selectbox-creative').select2('data',{id: 0,text: 'All Creatives'});
		 
	}
	// function update report
	function updateReport(){
		var orderID= $('#selectbox-order').select2('val');
		var flightID= $('#selectbox-flight').select2('val');
		var creativeID= $('#selectbox-creative').select2('val');
		alert(orderID+' - '+flightID+' - '+creativeID);
	}
 	//function generate chart 
 	function getChart(categories,revenueData,impressionsData){
 		$('#container').highcharts({
            chart: {
                zoomType: 'xy'
            },
            title: {
                text: 'Chart name (Summary)'
            },
            subtitle: {
                text: 'From '+start_date+' To '+end_date
            },
            xAxis: [{
                categories: categories,
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
                    //format: '{value} $',
                    style: {
                        color: '#89A54E'
                    },
                    formatter: function() {
                    	var value=this.value;                    	
                        return accounting.formatMoney(value);
                    }
                },
                title: {
                    text: 'Revenue',
                    style: {
                        color: '#89A54E'
                    }
                }
            }, { // Secondary yAxis
                title: {
                    text: 'Impressions',
                    style: {
                        color: '#4572A7'
                    }
                },
                labels: {
                    //format: '{value} ',
                    style: {
                        color: '#4572A7'
                    },
                    formatter: function() {
                    	var value=this.value;                    	
                        return accounting.formatNumber(value);
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
            series: [{
                name: 'Impressions',
                color: '#4572A7',
                type: 'areaspline',
                yAxis: 1,
                data: impressionsData,
                tooltip: {
                    valueSuffix: ' '
                }
    
            }, {
                name: 'Revenue',
                color: '#89A54E',
                type: 'areaspline',
                data: revenueData,
                tooltip: {
                    valueSuffix: '$'
                }
            }]
        }); 
 	}