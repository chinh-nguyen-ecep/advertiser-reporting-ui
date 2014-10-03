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
				 		<label for="order_id">Campaign name</label>
					    <input class="input-xlarge" id="selectbox-campaign" type="hidden" name="campaign _id" data-placeholder="All Campaign..." style="width: 100%"/>
				  </div>
  				  <div class="form-group">
				 		<label for="io_line_id">Io line items</label>
						<input disabled="disabled" class="input-xlarge" id="selectbox-io-line" type="hidden" name="line_id" data-placeholder="All Io Line Items..." style="width: 100%"/>
				  </div>
				  <div class="form-group">
				 		<label for="flight_id">Flight name</label>
						<input disabled="disabled" class="input-xlarge" id="selectbox-flight" type="hidden" name="flight_id" data-placeholder="All Flight..." style="width: 100%"/>
				  </div>
  				  <div class="form-group">
  				  		<label for="creative-id">Creative name</label>
					    <input disabled="disabled" class="input-xlarge" id="selectbox-creative" type="hidden" name="creative-id" data-placeholder="All Creative..." style="width: 100%"/>
				  </div>
  				  <div class="form-group">
  				  		<label for="metrics">Metrics</label>
					        <select id="metrics" style="width: 100%">
						        <option value="impression">Impression</option>
						        <option value="clicks">Clicks</option>
						        <option value="cta_event">Cta events</option>
						        <option value="all">All</option>
						    </select>
				  </div>
  				  <div class="form-group">
  				  		<label for="primary-dimension">Primary dimension</label>
					        <select id="primary-dimension" style="width: 100%">
						        <option value="hour">Hour</option>
						        <option value="date">Date</option>
						        <option value="week">Week</option>
						        <option value="month">Month</option>
						    </select>
				  </div>
  				  <div class="form-group">
  				  		<label for="secondary-dimension">Secondary dimension</label>
					        <select id="secondary-dimension" style="width: 100%">
						        <option value="devices">Devices</option>
						        <option value="dma">DMA</option>
						    </select>
				  </div>
				  <button onclick="updateReport();" type="button" class="btn btn-info" style="float: right"><span class="glyphicon glyphicon-upload"></span>Update</button>
			    </form>	  	
	  </div>
	  <div class="col-md-9">
	  	
	  	<div class="well well-sm summary_well" >
	  		<h2 style="margin-top: 0px;">Summary</h2>
<!--	  		<p>Write something about summary section....</p>-->
	  		<ul class="list-group">
			  <li class="list-group-item">Imps/Day<span class="badge">34,456,45</span></li>
			  <li class="list-group-item">Clicks/Day<span class="badge">478</span></li>
			  <li class="list-group-item">Cta events/Day<span class="badge">3,495</span></li>
			</ul>
	  	</div>
	  	<div id="container" style="min-width: 310px; height: 295px; margin: 0 auto"></div>
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
	            <th class="header"><a href="#">DMA</a><span class="glyphicon glyphicon-sort-by-attributes-alt"></span></th>
	            <th class="header"><a href="#">Impressions</a><span class="glyphicon glyphicon-sort"></span></th>
	            <th class="header"><a href="#">Clicks</a><span class="glyphicon glyphicon-sort"></span></th>
	            <th class="header"><a href="#">Cta events</a><span class="glyphicon glyphicon-sort"></span></th>
	          </tr>
	        </thead>
	        <tbody>   
   	          	 <tr>
		            <td>2013-10-07</td>
		            <td>Portland-Auburn</td>
		            <td class="right">74,791,664</td>
		            <td class="right">450</td>
		            <td class="right">1,234</td>
	          	</tr>	
 				<tr>
		            <td>2013-10-06</td>
		            <td>New York </td>
		            <td class="right">60,691,064</td>
		            <td class="right">340</td>
		            <td class="right">4,534</td>
	          	</tr>	
 				<tr>
		            <td>2013-10-05</td>
		            <td>Boston</td>
		            <td class="right">34,191,764</td>
		            <td class="right">897</td>
		            <td class="right">5,534</td>
	          	</tr>
	          	<tr>
		            <td>2013-10-04</td>
		            <td>Philadelphia</td>
		            <td class="right">78,091,234</td>
		            <td class="right">567</td>
		            <td class="right">8,034</td>
	          	</tr>
	          	<tr>
		            <td>2013-10-03</td>
		            <td>Detroit</td>
		            <td class="right">57,897,234</td>
		            <td class="right">455</td>
		            <td class="right">8,034</td>
	          	</tr>   
     	 		<tr>
		            <td>2013-10-02</td>
		            <td>Binghamton</td>
		            <td class="right">67,786,345</td>
		            <td class="right">567</td>
		            <td class="right">7,012</td>
	          	</tr>   
	          	<tr>
		            <td>2013-10-01</td>
		            <td>Macon</td>
		            <td class="right">76,231,998</td>
		            <td class="right">657</td>
		            <td class="right">3,934</td>
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
	<script src="scripts/control/campaignNames.js"></script>
	<script>

	</script>