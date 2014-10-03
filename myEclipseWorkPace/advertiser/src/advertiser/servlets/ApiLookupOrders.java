package advertiser.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import advertiser.api.LookupOrders;
import advertiser.api.QueryApi;
import advertiser.bean.ApiResponseResultSet;
import advertiser.bean.ApiResponseResultSetInfo;


/**
 * Servlet implementation class Api
 */
public class ApiLookupOrders extends HttpServlet {
	
    public ApiLookupOrders() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		QueryApi api=null;
		response.setContentType("text/plain");
		PrintWriter pw=response.getWriter();
		
		
		ApiResponseResultSet apiResponse=new ApiResponseResultSet();
		api=new LookupOrders();
		//get info param
		String info=request.getParameter("info");
		if(info!=null){
			//just load api information
			ApiResponseResultSetInfo infoResult=api.getInfo(request);
			pw.println(infoResult.toString());
		}else{
			apiResponse=api.processApiRequest(request);
			pw.println(apiResponse.toString());	
		}
			
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
