package vlmoui.servlets;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import vlmoui.api.DailyAggDemandByOffer;
import vlmoui.api.QueryApi;
import vlmoui.bean.ApiResponseResultSet;
import vlmoui.bean.ApiResponseResultSetInfo;

/**
 * Servlet implementation class ApiAdvertiserCreativesByHour
 */
@SuppressWarnings("serial")
public class ApiDailyAggDemandByOffer extends HttpServlet {
	
    public ApiDailyAggDemandByOffer() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
		QueryApi api=null;
		response.setContentType("text/plain");
		PrintWriter pw=response.getWriter();
		
		ApiResponseResultSet apiResponse=new ApiResponseResultSet();
		api=new DailyAggDemandByOffer();
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