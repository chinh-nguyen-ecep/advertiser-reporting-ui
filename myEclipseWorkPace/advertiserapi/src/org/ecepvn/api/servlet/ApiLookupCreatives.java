package org.ecepvn.api.servlet;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.ecepvn.api.LookupCreatives;
import org.ecepvn.api.LookupFlights;
import org.ecepvn.api.QueryApi;
import org.ecepvn.bean.ApiResponseResultSet;
import org.ecepvn.bean.ApiResponseResultSetInfo;
import org.json.JSONException;

/**
 * Servlet implementation class ApiLookupCreatives
 */
public class ApiLookupCreatives extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ApiLookupCreatives() {
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
		
		//get export format
		String format=request.getParameter("format");
		if(format==null){
			format="json";
		}else{
			format="csv";
		}

		ApiResponseResultSet apiResponse=new ApiResponseResultSet();
		api=new LookupCreatives();
		//get info param
		String info=request.getParameter("info");
		if(info!=null){
			//just load api information
			ApiResponseResultSetInfo infoResult=api.getInfo(request);
			pw.println(infoResult.toString());
		}else{
			apiResponse=api.processApiRequest(request);
			//Json format
			if(format.equals("json")){
				try {
					pw.println(apiResponse.toJson());
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					pw.println(e.getMessage());
				}
			}else{//csv format
				pw.println(apiResponse.toCsv());
			}			
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
