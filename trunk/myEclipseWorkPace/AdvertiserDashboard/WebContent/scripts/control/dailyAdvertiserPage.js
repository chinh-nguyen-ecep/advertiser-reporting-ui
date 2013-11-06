/**
 * 
 */
// 
var selectStartDate=thirtyDayBefore;
var selectEndDate=yesterday;

$(document).ready(function(){ 
	setTabActive('dailyAdvertiser');
	generateDateRange({
		stargetId:"date_range_dailyAdvertiser",
		start_date: selectStartDate,
		end_date: selectEndDate,
		callback: function(start_date,end_date,value){
			selectStartDate=start_date;
			selectEndDate=end_date;
			loadChart();
		}
	});
	 //$("#e2").select2();
	 loadChart();

});
	//function load chart
	var chart;
	function loadChart(){
		var dateRange_value=$("#date_range_dailyAdvertiser input").val();
		var measureValue=$("#e2").val();
		var url=apiRootUrl+'/AdvertiserByHour?select=date|hour&limit=1000&'+dateRange_value+"&"+measureValue;
		if(chart !=null){
			chart.showLoading();
		}
		$.ajax({
			  dataType: "json",
			  url: url,
			   xhrFields: {
				      withCredentials: true
				   },
			  success: function(json){
				  	var categories=[-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23];				  	
				  	var series=[];
				  	var title="Advertiser "+measureValue.replace("by\=","")+" By Date";
				  	var subtitle="From "+selectStartDate.format("yyyy-mm-dd")+" to "+selectEndDate.format("yyyy-mm-dd");
				  	var responseStatus=json.responseStatus;
				  	var page=json.page;
				  	if(responseStatus=='OK' && page==1){
				  		data=json.data;
				  		var name='';
				  		for(var i=0;i<data.length;i++){				  			
				  			var row=data[i];
				  			var newName=row[0];
				  			if(newName!=name){
				  				console.log("Add serie: "+newName);
				  				var row={name: newName,data:[]};
				  				series.push(row);
				  				name=newName;
				  			}

				  		}
				  		
				  		//add value
				  		for(var i=0;i<data.length;i++){
				  			var row=data[i];
				  			var newName=row[0];
				  			var value=row[2];
				  			for(var j=0;j<series.length;j++){
					  			var item=series[j];	
					  			if(item.name==newName){
					  				series[j].data.push(parseFloat(value));
					  			}
					  		}
				  		}
				  		
				  	}else{
				  		return;
				  	}
				  	
				  	if(chart){
				  		chart.hideLoading();
				  	}
				  	drawChart(categories,series,title,subtitle);
				  	

			  }
			});
	}

	//function generate chart 
	function drawChart(categories,series,title,subtitle){
		for(var i=0;i<series.length;i++){
			var row=series[i];
			console.log("Row "+i+": "+row.name);
			console.log("Data: "+row.data.length+" - "+row.data.join());
		}
		console.log('Draw chart');
		
		 $('#container').highcharts({
			 chart: {
				 type: 'spline'
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
	                        this.series.name +': '+ this.y +'<br/>'+
	                        'Total: '+ this.point.stackTotal;
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
		 chart=$('#container').highcharts();
		
	}