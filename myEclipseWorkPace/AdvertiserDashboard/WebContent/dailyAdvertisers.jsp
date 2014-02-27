	<nav class="navbar" role="navigation" style="margin-top: 10px;">
		<div class="navbar-header">
			    <form class="navbar-form navbar-left" role="export">			     
	 			    <div class="form-group">			    	
<!-- 		       			<input type="text" value="2013/10/01..2013/10/07" class="form-control input-sm " style="width: 200px;" id="date_range_dailyAdvertiser" placeholder=""></input> -->
		      		</div>

				  <div class="form-group">
						<div id="measuresBt" class="btn-group btn-group-sm">
						  <button type="button" class="btn btn-default" onclick="changeMeasure('click');">Clicks</button>
						  <button type="button" class="btn btn-default" onclick="changeMeasure('imp');">Impressions</button>
						  <button type="button" class="btn btn-default" onclick="changeMeasure('cta');">Cta maps</button>
						</div>
				  </div>
				  <div class="form-group">
					<div id="breakBt" class="btn-group btn-group-sm">
					  <button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
					    by hour<span class="caret"></span>
					  </button>
					  <ul class="dropdown-menu" role="menu">
					    <li><a href="#" onclick="breakChart('hour')">Hour</a></li>
					    <li><a href="#" onclick="breakChart('date')">Date</a></li>
					    <li><a href="#" onclick="breakChart('distance')">Distance</a></li>
					    <li><a href="#" onclick="breakChart('dma')">Dma</a></li>
					  </ul>
					  	
					</div>
					<button id="dmaFilterBtn" style="margin-left: 5px;display:none;" type="button" class="btn btn-primary btn-sm">  <span class="glyphicon glyphicon-plus"></span> Dma Filter</button>	
				  </div>
<!--		      		 <button type="button" onclick="loadChart()" class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-upload"></span>Update</button>-->
			    </form>

		</div>
		<div class="collapse navbar-collapse navbar-ex1-collapse">
			    <!--<form class="navbar-form navbar-right" role="export">			    		   			     
			      <button type="button" class="btn btn-warning"><span class="glyphicon glyphicon-download-alt"></span>XLS Export</button>			      		   
			      <button type="button" class="btn btn-info"><span class="glyphicon glyphicon-download-alt"></span>CSV Export</button>
			    </form>
		-->
			    <form class="navbar-form navbar-right" role="export">
     			  	  <div class="form-group" style="float: right;">			    	
		       			<div id="date_range_dailyAdvertiser" class="form-control input-sm">
					    <i class="icon-calendar icon-large"></i>
					    <span></span> <b class="caret"></b>
						<input type="hidden" value="" />
						</div>
		      		</div>
			    </form>
		</div>
	</nav>
	<div class="panel panel-default">
	  <div class="panel-body" >
	    <div id="daily-advertiser-chart-container" style="min-width: 310px; height: 350px; margin: 0 auto" class="loading"></div>
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
	<div class="panel panel-default">
		  <div class="panel-body" style="padding: 0px;">
   			<table  id="daily-advertiser-dataTable" class="dataTable">
	        
	      </table>
		  </div>		  
		</div>
		<div class="row">
		<div class="col-md-10">
	  	
	 	 </div>
		  <div class="col-md-2">
				<ul class="pager">
				  <li><a href="#" onclick="disabledEventPropagation(event);myTable.previous();">Previous</a></li>
				  <li><a href="#" onclick="disabledEventPropagation(event);myTable.next();">Next</a></li>
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
		
	<!--  control scripts -->
	<script type="text/javascript" src="scripts/control/dailyAdvertiserPage.js"></script>	
	<script type="text/javascript" src="scripts/control/dailyAdvertiserPage_dma_control.js"></script>	
	<!--  control scripts -->

