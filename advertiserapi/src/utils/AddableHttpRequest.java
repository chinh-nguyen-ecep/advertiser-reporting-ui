package utils;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

public class AddableHttpRequest extends HttpServletRequestWrapper {
	 public AddableHttpRequest(HttpServletRequest request) {
		super(request);
		// TODO Auto-generated constructor stub
	}

	private Map<String,String[]> params = new HashMap();



	   public String getParameter(String name) {
	           // if we added one, return that one
	           if ( params.get( name ) != null ) {
	                 return params.get( name )[0];
	           }
	           // otherwise return what's in the original request
	           HttpServletRequest req = (HttpServletRequest) super.getRequest();
	           return req.getParameter( name );
	   }

	   public void addParameter( String name, String value ) {
	           params.put( name,new String[]{ value} );
	   }
	   public void addParameter( String name, String[] value ) {
           params.put( name,value);
   }
	   public String[] getParameterValues(String name){
		   return params.get(name);
	   }
	   public Map<String, String[]> getParameterMap(){
		   return params;
	   }
}
