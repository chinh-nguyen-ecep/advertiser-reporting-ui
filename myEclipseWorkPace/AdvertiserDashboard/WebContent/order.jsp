	<nav class="navbar" role="navigation" style="margin-top: 10px;">
		<div class="navbar-header">
			    <form class="navbar-form navbar-left" role="export" style="padding-left: 0px;">			     
	 			    <div class="form-group">			    	
		       			<input type="text" value="2013/10/01 - 2013/10/07" class="form-control input-sm " style="width: 263px;" id="date_range" placeholder="">
		      		</div>
			    </form>
		</div>
		<div class="collapse navbar-collapse navbar-ex1-collapse">
			  <!--   <form class="navbar-form navbar-right" role="export">			    		   			     
			    	<button type="button" class="btn btn-success"><span class="glyphicon glyphicon-share"></span>Build Report</button>
			     	<button type="button" class="btn btn-warning"><span class="glyphicon glyphicon-download-alt"></span>XLS Export</button>			      		   
			     	<button type="button" class="btn btn-info"><span class="glyphicon glyphicon-download-alt"></span>CSV Export</button>
			    </form> -->
		</div>
	</nav>
	<div class="row">
	  <div class="col-md-3">
			    <form class="" role="form">	
				  <div class="form-group">
				 		<label for="order_id">Order name</label>
					    <input class="input-xlarge" id="selectbox-order" type="hidden" name="order_id" data-placeholder="All Order..." style="width: 100%"/>
				  </div>
				  <div class="form-group">
				 		<label for="flight_id">Flight name</label>
						<input disabled="disabled" class="input-xlarge" id="selectbox-flight" type="hidden" name="flight_id" data-placeholder="All Flight..." style="width: 100%"/>
				  </div>
  				  <div class="form-group">
  				  		<label for="creative-id">Creative name</label>
					    <input disabled="disabled" class="input-xlarge" id="selectbox-creative" type="hidden" name="creative-id" data-placeholder="All Creative..." style="width: 100%"/>
				  </div>
				  <button onclick="updateReport();" type="button" class="btn btn-info" style="float: right"><span class="glyphicon glyphicon-upload"></span>Update</button>
			    </form>	  	
	  </div>
	  <div class="col-md-6">
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
	<div class="col-md-10">

 	 </div>
	  <div class="col-md-2">
 		<div id="exportBt" class="btn-group btn-group-sm" style="float: right;margin-bottom: 10px;">
		  <button type="button" class="btn btn-warning dropdown-toggle" data-toggle="dropdown">
		    Export Data<span class="caret"></span>
		  </button>
		  <ul class="dropdown-menu" role="menu">
		   <li><a href="#" onclick="reviewExportData();">Review</a></li>
		    <li><a href="#" onclick="exportReport('xls')">xls</a></li>
		    <li><a href="#" onclick="exportReport('csv')">csv</a></li>
		    <li><a href="#" onclick="exportReport('pdf')">pdf</a></li>
		  </ul>
		</div> 	
	  </div>
	</div>
	<div class="row">
	  <div class="col-md-12">
	  <div class="panel panel-default">
		  <div class="panel-body" style="padding: 0px;">
  			<table class="table table-bordered table-hover dataTable" id="mainDataTable">
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
	<script src="scripts/control/orderNames.js"></script>
	<script>

	</script>