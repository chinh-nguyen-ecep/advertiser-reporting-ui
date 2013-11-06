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
						<select id="e2" class="form-control input-sm" style="width:150px;">
					        <option value="by=clicks">Click</option>					       
					        <option value="by=impressions">impressions</option>
					        <option value="by=cta_maps">Cta_maps</option>
					    </select>
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
	<!--  control scripts -->
	<script type="text/javascript" src="scripts/control/dailyAdvertiserPage.js"></script>	


