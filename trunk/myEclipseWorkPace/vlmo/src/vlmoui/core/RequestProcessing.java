package vlmoui.core;

import java.util.ArrayList;
import java.util.Map;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

public class RequestProcessing {

	/**
	 * @param args
	 */
	public static String processDimensionsInput(HttpServletRequest request){
		String result="";
		Object dimension=request.getParameterValues("select");
		if(dimension==null) return result; 
		if(dimension instanceof String[]){
			String[] temp=(String[]) dimension;
			for(int i=0;i<temp.length;i++){
				if(i>0){
					result+=",";
				}		
				if(temp[i].indexOf("|")>-1){
					StringTokenizer stringTokenizer=new StringTokenizer(temp[i],"|");
					int k=0;
					while(stringTokenizer.hasMoreTokens()){
						if(k>0){
							result+=",";
						}
						result+=stringTokenizer.nextToken();
						k++;
					}
				}else{
					result+=temp[i];
				}				
			}			
		}else{
			result=(String) dimension;
			StringTokenizer stringTokenizer=new StringTokenizer(result,"|");
			int i=0;
			while(stringTokenizer.hasMoreTokens()){
				if(i>0){
					result+=",";
				}
				result+=stringTokenizer.nextToken();
				i++;
			}
		}
		
		return result;
	}
	public static String processMeasuresInput(HttpServletRequest request){
		String result="";
		Object measures=request.getParameterValues("by");
		if(measures == null) return result;
		if(measures instanceof String[]){
			String[] temp=(String[]) measures;
			for(int i=0;i<temp.length;i++){
				if(i>0){
					result+=",";
				}	
				if(temp[i].indexOf("|")>-1){
					StringTokenizer stringTokenizer=new StringTokenizer(temp[i],"|");
					int k=0;
					while(stringTokenizer.hasMoreTokens()){
						if(k>0){
							result+=",";
						}
						String temp2=stringTokenizer.nextToken();
						result+="SUM("+temp2+") AS "+temp2+" ";
						k++;
					}
				}else{
					result+="SUM("+temp[i]+") AS "+temp[i]+" ";
				}				
			}			
		}else{
			result=(String) measures;
			StringTokenizer stringTokenizer=new StringTokenizer(result,"|");
			int i=0;
			while(stringTokenizer.hasMoreTokens()){
				if(i>0){
					result+=",";
				}
				String temp=stringTokenizer.nextToken();
				result+="SUM("+temp+") AS "+temp+" ";
				i++;
			}
		}
		return result;
	}
	
	public static String processOrderInput(HttpServletRequest request){
		String result="";
		String[] orders=request.getParameterValues("order");
		if(orders==null){
			return result;
		}
		if(orders.length==1 && orders[0].indexOf("|")>-1){
			orders=orders[0].split("\\|", -1);
		}
		for(int i=0;i<orders.length;i++){
			String[] item=orders[i].split("\\.",-1);
			String orderBy=item[0];
			String order="desc";
			if(item.length==1){
				order="asc";
			}else{
				order=item[1];
			}
			
			if(i>0){
				result+=",";
			}
			
			result+=orderBy+" "+order;
		}
		if(!result.equals("")){
			result=" ORDER BY "+result;
		}
		return result;
	}
	public static String processWhereInput(HttpServletRequest request){
		String result="";
		@SuppressWarnings("unchecked")
		Map<String, String[]> map=request.getParameterMap();
		ArrayList<String[]> wheres=new ArrayList<String[]>();
		for (Map.Entry<String, String[]> entry : map.entrySet()) {
			String key=entry.getKey();
			String value=entry.getValue()[0];
			//Just get where condition
			if(key.indexOf("where[")>-1){
				String[] temp=new String[2];
				int bigin=key.indexOf("[");
				int end=key.indexOf("]");		
				temp[0]=key.substring(bigin+1, end);
				temp[1]=value;
				wheres.add(temp);
			}
			
		}
		
		for(int i=0;i<wheres.size();i++){
			String[] item=wheres.get(i);
			String key=item[0];
			String value=item[1];	
			
			//Get operator
			String[] array=key.split("\\.",-1);
			String operator="equal";
			String dimension=array[0];
			if(array.length>1){
				operator=array[1];
			}
			
			if(i>0){
				result+=" AND ";
			}
			if(operator.equals("equal")){
				result+=dimension+"="+"'"+value+"'";
			}else if(operator.equals("in")){
				result+=dimension +" IN "+"("+inValueTrueType(value)+")";
			}else if(operator.equals("like")){
				result+="LOWER("+dimension +") LIKE "+"'%"+value.toLowerCase().replaceAll(" ", "%")+"%'";
			}else if(operator.equals("between")){
				String[] values=value.split("\\..", -1);
				if(values.length!=2){
					values[0]="9999-12-31";
					values[1]="9999-12-31";
				}
				result+=dimension+" BETWEEN '"+values[0]+"' AND '"+values[1]+"' ";
			}
		}
		
			if(!result.equals("")){
				result=" WHERE "+result;
			}
			
		
		return result;
	}
	// process input value for IN 
	// example value=1,2,3,4 => A IN (1,2,3,4)
	// example value=a,b,c => A IN ('a','b','c');
	
	private static String inValueTrueType(String inValue){
		String result=inValue;
		boolean isStringInput=false;
		@SuppressWarnings("unused")
		int itemValue=0;
		String[] values=inValue.split("\\,", -1);
		for(int i=0;i<values.length;i++){
			try{
				itemValue=Integer.valueOf(values[i]);
			}catch(Exception e){
				isStringInput=true;
				break;
			}
		}
		if(isStringInput){
			result="'"+inValue.replaceAll("\\,","'\\,'")+"'";
			
		}else{
			
		}
		return result;
	}
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String a="date..desc";
		String[] temp=a.split("\\..",-1);
		System.out.println(temp.length);
		System.out.println(temp[0]);
		System.out.println(temp[1]);
	}

}
