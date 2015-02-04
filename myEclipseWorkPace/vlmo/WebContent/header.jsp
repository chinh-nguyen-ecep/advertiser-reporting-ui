<%@page import="java.util.Enumeration"%>
<%@page import="java.security.MessageDigest"%>
<%
	String user = request.getRemoteUser();
	MessageDigest md = MessageDigest.getInstance("MD5");
	String imgCode = "";
	md.update(user.getBytes());
	byte byteData[] = md.digest();
	//convert the byte to hex format method 1
	StringBuffer sb = new StringBuffer();
	for (int i = 0; i < byteData.length; i++) {
		sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16)
				.substring(1));
	}
	imgCode = sb.toString();
%>
<div class="navbar navbar-inverse navbar-fixed-top"
	style="border: none;">
	<div class="navbar-inner"
		style="background-image: url('images/reports_back-fb.png'); height: 90px; padding-top: 10px;">
		<div class="container">
			<div class="navbar-header">
				<button type="button" class="navbar-toggle" data-toggle="collapse"
					data-target=".navbar-collapse">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<img alt="Verve logo" src="images/verve-logo.png">

			</div>
			<div class="navbar-collapse collapse">
				<a class="navbar-brand" href="#"
					style="color: white; font-size: 15pt;">VLMO DashBoard</a>
				<form class="navbar-form navbar-right" action="api/v1/overview"
					role="search">
					<div class="form-group">
						<div class="btn-group" style="float: right; margin-right: 0px">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#"
								style="color: white; margin-left: 10px; margin-right: 10px;">
								<img class="gravatar"
								src="https://secure.gravatar.com/avatar/<%=imgCode%>.png?s=20" />
								<%=user%> <span class="caret"
								style="border-top: 4px solid #FFF;"></span>
							</a>
							<ul class="dropdown-menu">
								<li><a href="http://gravatar.com" target="_blank"><i
										class="fa fa-user"></i> Change Avatar </a></li>
								<li><a href="logout.jsp"><i class="fa fa-sign-out"></i>Logout</a></li>
							</ul>
						</div>

						<span style="float: right; margin-right: 5px; color: white;">Welcome
							back</span>

					</div>
					<button type="submit" class="btn btn-xs btn-success">API
						Access</button>
				</form>

			</div>
			<!--/.nav-collapse -->
		</div>
	</div>
	<!-- <div class="subbar-inner">
		<div class="container">
			<div class="nav-collapse collapse">
				<ul class="nav">
					<li class="dropdown">
						<a class="dropdown-toggle" data-toggle="dropdown" href="#">
						Workbook
						<b class="caret"></b>
						</a>
						<ul class="dropdown-menu">
						<li class="">
						<a href="#" onclick="changePage('overview','exchange');">Exchange</a>
						</li>
						<li class="">
						<a href="#" onclick="changePage('overview','winrate')">Winrate</a>
						</li>
						</ul>
					</li>
				</ul>

			</div>
		</div>
	</div> -->
</div>

<div class="container theme-showcase" id="page-tab"
	style="padding-top: 110px;">
       	<ul class="nav nav-tabs">       	
		  <li title="overview"><a href="#" onclick="changePage('overview')">Dashboard Overview</a></li>
		  <li title="Running Revenue"><a href="#" onclick="changePage('runningRevenue')">Running Revenue</a></li>
		  <li title="Network Overview"><a href="#" onclick="changePage('networkOverview')">Network Overview</a></li>
		</ul>   
</div>
<script>
    loginUser='<%=user%>';
</script>