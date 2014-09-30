package vlmoui.servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import vlmoui.bean.ApiResponseResultSet;
import vlmoui.bean.ApiResponseResultSetInfo;
import vlmoui.core.QueryApi;

/**
 * Servlet implementation class ApiV1
 */
public class ApiV1 extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ApiV1() {
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
		String url=request.getRequestURL().toString();
		
		String apiClass=getApiName(url);
		ApiResponseResultSet apiResponse=new ApiResponseResultSet();
		
		Class<?> c;
		Constructor<?> cons;
		QueryApi object = null;
		try {
			c = Class.forName("vlmoui.api.v1."+apiClass);
			cons = c.getConstructor();
			object = (QueryApi) cons.newInstance();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InstantiationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println(object);
		api= object;
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
	
	private String getApiName(String url){
		String result=null;
		String[] array=url.split("/");
		String last=array[array.length-1];
		result=last.split("\\?")[0];
		String firstLetter=result.substring(0, 1);
		result=result.substring(1);
		result=firstLetter.toUpperCase()+result;
		return result;
	}
}
