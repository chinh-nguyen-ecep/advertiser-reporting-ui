	<nav class="navbar" role="navigation" style="margin-top: 10px;">
		<div class="navbar-header">
			    <form class="navbar-form navbar-left" role="export">			     
	 			    <div class="form-group">			    	
<!-- 		       			<input type="text" value="2013/10/01..2013/10/07" class="form-control input-sm " style="width: 200px;" id="date_range_dailyAdvertiser" placeholder=""></input> -->
		      		</div>
 			  	  <div class="form-group">			    	
		       			<div id="date_range_dailyAdvertiser" class="form-control input-sm">
					    <i class="icon-calendar icon-large"></i>
					    <span></span> <b class="caret"></b>
						<input type="hidden" value="" />
						</div>
		      		</div>
				  <div class="form-group">
						<div class="btn-group btn-group-sm">
						  <button type="button" class="btn btn-default" onclick="drawChart(categories,series_clicks,'Advertiser Clicks By Date',subtitle);">Clicks</button>
						  <button type="button" class="btn btn-default" onclick="drawChart(categories,series_impressions,'Advertiser Impressions By Date',subtitle);">Impressions</button>
						  <button type="button" class="btn btn-default" onclick="drawChart(categories,series_cta,'Advertiser Cta maps By Date',subtitle);">Cta maps</button>
						</div>
				  </div>
		      		 <button type="button" onclick="loadChart()" class="btn btn-primary btn-sm"><span class="glyphicon glyphicon-upload"></span>Update</button>
			    </form>
		</div>
		<div class="collapse navbar-collapse navbar-ex1-collapse">
			    <form class="navbar-form navbar-right" role="export">			    		   			     
			      <button type="button" class="btn btn-warning"><span class="glyphicon glyphicon-download-alt"></span>XLS Export</button>			      		   
			      <button type="button" class="btn btn-info"><span class="glyphicon glyphicon-download-alt"></span>CSV Export</button>
			    </form>
		</div>
	</nav>
	<div class="panel panel-default">
	  <div class="panel-body" >
	    <div id="container" style="min-width: 310px; height: 350px; margin: 0 auto" class="loading"></div>
	  </div>
	</div>
	<div class="panel panel-default">
		  <div class="panel-body" style="padding: 0px;">
   			<table  id="mainDataTable">
	        
	      </table>
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
	<!--  control scripts -->
	<script type="text/javascript" src="scripts/control/dailyAdvertiserPage.js"></script>	


