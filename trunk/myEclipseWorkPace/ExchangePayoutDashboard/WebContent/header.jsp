<%@page import="java.util.Enumeration"%>
<%
	String user=request.getRemoteUser();
  %>
  <div class="navbar navbar-default navbar-fixed-top">
	  <div class="navbar navbar-default navbar-fixed-top">
	  <div class="navbar-inner" style="background-image: url('images/reports_back-fb.png');height: 90px;padding-top: 10px;">
	      <div class="container">
	        <div class="navbar-header">
	          <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	            <span class="icon-bar"></span>
	          </button>
	          <img alt="Verve logo" src="images/verve-logo.png">
	          
	        </div>
	        <div class="navbar-collapse collapse">
	        <a class="navbar-brand" href="#" style="color: white;font-size: 15pt;">Exchange Cost Analysis</a>
	 		    <!-- form class="navbar-form navbar-right form-inline" role="form">
					<div class="form-group">
			   	     <select class="form-control">			        
				        <option>Advertiser</option>
				        <option>Order</option>
				      </select>
					</div>
			      <div class="form-group">
			        <input type="text" class="form-control" placeholder="">
			      </div>
			      <button type="submit" class="btn btn-primary">Filter</button>
			    </form-->  
			    <div class="row" >
			   
			    <div class="col-md-8" style="color: white;padding-top: 2px">
			    	 <div class="btn-group" style="float: right;margin-right: 0px">
						  <button class="btn btn-warning btn-xs dropdown-toggle" type="button" data-toggle="dropdown">
						    <%=user %> <span class="caret"></span>
						  </button>
						  <a class="dropdown-toggle" data-toggle="dropdown" href=""></a>
						  <ul class="dropdown-menu">
						   <li><a href="logout.jsp">Logout</a></li>
						  </ul>
					</div> 
					<span style="float: right;margin-right: 5px">Welcome back</span>
			    </div>
			    	 
			    </div>
			         
	        </div><!--/.nav-collapse -->
	      </div>	  
	  </div>
    </div>
    </div>
    <div class="container theme-showcase" id="page-tab">
       	<ul class="nav nav-tabs">
       	
		  <li title="overview"><a href="#" onclick="changePage('overview')">Dashboard Overview</a></li>
		  <li title="dailyExchangePayoutByHour"><a href="#" onclick="changePage('dailyExchangePayoutByHour')">Hour</a></li>
		  
		</ul>   
    </div>
    <script>
    loginUser='<%=user %>';
    </script>