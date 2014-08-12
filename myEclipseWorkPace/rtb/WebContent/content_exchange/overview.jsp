	<nav class="navbar" role="navigation" style="margin-top: 10px;">
		<div class="collapse navbar-collapse navbar-ex1-collapse">
		<div class="navbar-form navbar-left" role="export">
			<!-- div class="btn-group" >
			  <button type="button" class="btn btn-default active" onclick="rawChart();" id="amount_chart_mode_bt">Amount</button>
			  <button type="button" class="btn btn-default " onclick="rawChart2();" id="avg_chart_mode_bt">Ave. Price</button>
			</div-->
		</div>
			    <form class="navbar-form navbar-right" role="export">	
			    <div class="form-group">
				    <select style="width:150px" id="exchange_filter" >
	    				<option value="All Exchanges">All exchanges</option>
				        <option value="mopub">mopub</option>
				        <option value="nexage">nexage</option>
				        <option value="pubmatic">pubmatic</option>						        
				    </select>
			    </div>
 			  	  <div class="form-group">
		       			<div id="overview-date_range" class="form-control input-sm">
					    <i class="icon-calendar icon-large"></i>
					    <span></span> <b class="caret"></b>
						<input type="hidden" value="" />
						</div>
		      		</div>
<!--		      		 <button type="button" class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-upload"></span>Update</button>-->
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
<!-- 	  		<p>The average values </p> -->
	  		<ul class="list-group">
	  			<li class="list-group-item">Wins/Day<span class="badge av-impression">0</span></li>
	  			<li class="list-group-item">Paid Amount/Day<span class="badge av-paid-amount">0</span></li>
	  			<li class="list-group-item">Ave. Win price/Day<span class="badge av-paid-price">0</span></li>
			  	<li class="list-group-item">Ave. Bid Price/Day<span class="badge av-bid-price">0</span></li>
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
   			<table  id="dashboard-overview-dataTable" class="dataTable"></table>
		  </div>		  
		</div>

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
	
	<script src="scripts/control/exchangeCostAnalysisOverview.js"></script>
	<script>

	</script>