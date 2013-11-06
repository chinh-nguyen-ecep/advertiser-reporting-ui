	<nav class="navbar" role="navigation" style="margin-top: 10px;">
		<div class="navbar-header">
			    <form class="navbar-form navbar-left" role="export">			     
	 			    <div class="form-group">			    	
		       			<input type="text" value="2013/10/01 - 2013/10/07" class="form-control input-sm " style="width: 200px;" id="date_range" placeholder="">
		      		</div>
		      		 <button type="button" class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-upload"></span>Update</button>
			    </form>
		</div>
		<div class="collapse navbar-collapse navbar-ex1-collapse">
			    <form class="navbar-form navbar-right" role="export">			    		   			     
			      <button type="button" class="btn btn-warning"><span class="glyphicon glyphicon-download-alt"></span>XLS Export</button>			      		   
			      <button type="button" class="btn btn-info"><span class="glyphicon glyphicon-download-alt"></span>CSV Export</button>
			    </form>
		</div>
	</nav>
	<div class="row">
	  <div class="col-md-9">
	  	<div id="container" style="min-width: 310px; height: 350px; margin: 0 auto"></div>
	  </div>
	  <div class="col-md-3">
	  	<div class="well well-sm summary_well" >
	  		<h2 style="margin-top: 0px;">Summary</h2>
	  		<p>Infomation from Joel. Write something about summary section....</p>
	  		<ul class="list-group">
			  <li class="list-group-item">Average CTR<span class="badge">45</span></li>
			  <li class="list-group-item">Average Impressions/Day<span class="badge">670</span></li>
			  <li class="list-group-item">Average Clicks/Day<span class="badge">99</span></li>
			</ul>
	  	</div>
	  </div>	 
	</div>
	<div class="row">
	  <div class="col-md-12">
	  <div class="panel panel-default">
		  <div class="panel-body" style="padding: 0px;">
   			<table class="table table-bordered table-hover " id="mainDataTable">
	        <thead>
	          <tr>
	            <th class="header sort"><a href="#">Date</a><span class="glyphicon glyphicon-sort-by-attributes-alt"></span></th>
	            <th class="header"><a href="#">Clicks</a><span class="glyphicon glyphicon-sort"></span></th>
	            <th class="header"><a href="#">Impressions</a><span class="glyphicon glyphicon-sort"></span></th>
	            <th class="header"><a href="#">Revenue</a><span class="glyphicon glyphicon-sort"></span></th>
	          </tr>
	        </thead>
	        <tbody>   
   	          	 <tr>
		            <td>2013-10-07</td>
		            <td class="right">450</td>
		            <td class="right">74,791,664</td>
		            <td class="right">$76,140.97</td>
	          	</tr>	
	         	 <tr>
		            <td>2013-10-06</td>
		            <td class="right">567</td>
		            <td class="right">81,620,436</td>
		            <td class="right">$75,413.57</td>
	          	</tr>	
	          	<tr>
		            <td>2013-10-05</td>
		            <td class="right">139</td>
		            <td class="right">53,020,304</td>
		            <td class="right">$77,542.50</td>
	         	 </tr>	 
	        	<tr>
		            <td>2013-10-04</td>
		            <td class="right">128</td>
		            <td class="right">73,158,140</td>
		            <td class="right">$48,817.37</td>
	          	</tr>	
	         	 <tr>
		            <td>2013-10-03</td>
		            <td class="right">735</td>
		            <td class="right">60,724,855</td>
		            <td class="right">$59,711.42</td>
	          	</tr>	
	          	<tr>
		            <td>2013-10-02</td>
		            <td class="right">812</td>
		            <td class="right">69,571,356</td>
		            <td class="right">$60,458.54</td>
	         	 </tr>	
	        	<tr>
		            <td>2013-10-01</td>
		            <td class="right">565</td>
		            <td class="right">49,077,790</td>
		            <td class="right">$75,210.53</td>
	          	</tr>	         	           	          	         	          	          	
	          </tbody>
	      </table>
		  </div>		  
		</div>

	  </div>	 
	</div>
	<div class="row">
		<div class="col-md-10">
	  	
	 	 </div>
	  <div class="col-md-2">
			<ul class="pager">
			  <li><a href="#">Previous</a></li>
			  <li><a href="#">Next</a></li>
			</ul>	  	
	  </div>
	</div>
	<div class="row">
		<div class="col-md-12">
	  	<p><a href="http://wiki.vervewireless.com/confluence/pages/viewpage.action?pageId=30475846">Why are these numbers different than I expect?</a></p>
	  	<p>NOTE</p>
	  	<ul>
		<li>Today's data is not included.</li>
		<li>Figures shown are preliminary and subject to review and audit. Your reconciled net earnings will appear on your monthly statements.</li>
		<li>Data is updated at approximately noon EST every day.</li>
		</ul>
	 	</div>	 
	</div>
	<p>Copyright Verve 2012. All rights reserved.</p>
	<script>
	var start_date='2013/10/01';
	var end_date='2013/10/07';
 	$( document ).ready(function() {
 		var categories=['2013/10/01', '2013/10/02', '2013/10/03', '2013/10/04', '2013/10/05', '2013/10/06', '2013/10/07'];
 		var revenueData=[75210.53, 60458.54, 59711.42, 48817.37, 77542.50, 75413.57, 76140.97];
 		var impressionsData=[49077790, 69571356, 60724855, 73158140, 53020304, 81620436, 74791664];
 		getChart(categories,revenueData,impressionsData);
 		generateDateRange("date_range");
 		setTabActive("overview");
 	});

 	//function generate chart 
 	function getChart(categories,revenueData,impressionsData){
 		$('#container').highcharts({
            chart: {
                zoomType: 'xy'
            },
            title: {
                text: 'Daily Revenue And Impressions'
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
	</script>