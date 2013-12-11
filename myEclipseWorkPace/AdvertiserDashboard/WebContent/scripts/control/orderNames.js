/**
 * 
 */
/**
 * 
 */
	
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
		 $("#e1").select2({
			 placeholder: "Select Order",
			 allowClear: true
		 });
		 $("#e2").select2({
			 placeholder: "Select Flight",
			 allowClear: true
		 });
		 $("#e3").select2({
			 placeholder: "Select Creative",
			 allowClear: true
		 });
		 $("#e4").select2({
             tags:["CLick", "Impressions", "Revenue"],
             tokenSeparators: [",", " "],
             placeholder: "Select Metric(s)"
		 });
		 $("#e5").select2({
			 placeholder: "Primary Dimension",
			 allowClear: true
		 });
		 $("#e6").select2({
			 placeholder: "Secondary Dimension",
			 allowClear: true
		 });
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