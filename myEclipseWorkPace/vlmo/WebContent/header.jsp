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
	        <a class="navbar-brand" href="#" style="color: white;font-size: 15pt;">VLMO Dashboard</a>
	        <form class="navbar-form navbar-right" action="api/v1/overview" role="search">
            <div class="form-group">
               <div class="btn-group" style="float: right;margin-right: 0px">
						  <button class="btn btn-warning btn-xs dropdown-toggle" type="button" data-toggle="dropdown">
						    <%=user %> <span class="caret"></span>
						  </button>
						  <a class="dropdown-toggle" data-toggle="dropdown" href=""></a>
						  <ul class="dropdown-menu">
						   <li><a href="logout.jsp">Logout</a></li>
						  </ul>
				</div> 
				<span style="float: right;margin-right: 5px; color: white;">Welcome back</span>
            </div>
            <button type="submit" class="btn btn-xs btn-success">Api Access</button>
          </form>  
			    
   	 		    
	        </div><!--/.nav-collapse -->
	      </div>	  
	  </div>
    </div>
    </div>
    <div class="container theme-showcase" id="page-tab" style="margin-top: 110px;">
       	<ul class="nav nav-tabs">
       	
		  <li title="overview"><a href="#" onclick="changePage('overview')">Dashboard Overview</a></li>
		  <li title="Running Revenue"><a href="#" onclick="changePage('runningRevenue')">Running Revenue</a></li>
		  
		</ul>   
    </div>
    <script>
    loginUser='<%=user %>';
    </script>