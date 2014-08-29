<%@page import="rtb.core.QueryApi"%>
<%@page import="rtb.utils.ClassesfromPackage"%>
<%@page import="java.util.List"%>
<%@page import="java.io.IOException"%>
<%
	ClassesfromPackage cs = new ClassesfromPackage();
	String packageName ="rtb.api.v1";
	try {
		List<Class> iterable=(List<Class>) cs.getClasses(packageName);
		for(int i=0;i<iterable.size();i++){
			Class class1=iterable.get(i);
			
			System.out.println(class1.getSimpleName());
		}
	} catch (ClassNotFoundException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	} catch (IOException e) {
	    // TODO Auto-generated catch block
	    e.printStackTrace();
	}
%>
<jsp:include page="../../ApiHeader.jsp" />
<div id="index_container" class='container' style="margin-top: 100px;">
	<div class='content'>
		<nav>
			<ul class='breadcrumb'>
				<li class='active'>API Overview</li>
			</ul>
		</nav>
		<table class='table table-bordered'>
			<tr>
				<th colspan='2'>RTB Reports</th>
			</tr>
		<%
			cs = new ClassesfromPackage();
			packageName ="rtb.api.v1";
			try {
				List<Class> iterable=(List<Class>) cs.getClasses(packageName);
				for(int i=0;i<iterable.size();i++){
					Class class1=iterable.get(i);
					String name=class1.getSimpleName();
					QueryApi a=(QueryApi)class1.newInstance();
					if(a.getApiInfo().isActive==true){
					%>
					<tr>
						<td><a href="apiDetail?api=<%=name%>"><%=name%></a></td>
						<td><%=a.getApiInfo().group %></td>
					</tr>
					<%
					}
				}
			} catch (ClassNotFoundException e) {
			    // TODO Auto-generated catch block
			    e.printStackTrace();
			} catch (IOException e) {
			    // TODO Auto-generated catch block
			    e.printStackTrace();
			}
		%>			

		</table>
		<nav>
			<ul class='breadcrumb'>
				<li class='active'>Dimension Lookup</li>
			</ul>
		</nav>
		<table class='table table-bordered'>
		<%
			cs = new ClassesfromPackage();
			packageName ="rtb.api.lookup";
			try {
				List<Class> iterable=(List<Class>) cs.getClasses(packageName);
				for(int i=0;i<iterable.size();i++){
					Class class1=iterable.get(i);
					String name=class1.getSimpleName();
					%>
					<tr>
						<td><a href="apiDetail?api=<%=name%>&type=lookup"><%=name%></a></td>
						<td></td>
					</tr>
					<%
				}
			} catch (ClassNotFoundException e) {
			    // TODO Auto-generated catch block
			    e.printStackTrace();
			} catch (IOException e) {
			    // TODO Auto-generated catch block
			    e.printStackTrace();
			}
		%>
			
		</table> 
	</div>

</div>
<jsp:include page="/footer.jsp" />
<script src="../../scripts/bootstrap-3.0.0/js/bootstrap.min.js"></script>
</body>
</html>


