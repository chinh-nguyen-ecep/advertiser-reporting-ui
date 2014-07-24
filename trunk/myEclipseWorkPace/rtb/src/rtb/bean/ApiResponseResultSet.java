package rtb.bean;

import java.util.ArrayList;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * @author ChinhNguyen
 *
 */
public class ApiResponseResultSet {
	/**
	 * @param args
	 */
	private String responseStatus;
	private int page;
	private int totalPage;
	private int unitsPerPage;
	private String errorMessage;
	private String query;
	private String formatOutput="json";
	private ArrayList<String> columnName;
	private ArrayList<String> columnType;
	private ArrayList<String[]> data;
	
	public ApiResponseResultSet() {
		super();
		page=1;
		responseStatus="";
		totalPage=0;
		unitsPerPage=100;
		errorMessage="";
		columnName=new ArrayList<String>();
		columnType=new ArrayList<String>();
		data=new ArrayList<String[]>();
	}

	public String getResponseStatus() {
		return responseStatus;
	}

	public String getFormatOutput() {
		return formatOutput;
	}

	public void setFormatOutput(String formatOutput) {
		this.formatOutput = formatOutput;
	}

	public void setResponseStatus(String responseStatus) {
		this.responseStatus = responseStatus;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}

	public int getUnitsPerPage() {
		return unitsPerPage;
	}

	public void setUnitsPerPage(int unitsPerPage) {
		this.unitsPerPage = unitsPerPage;
	}

	public String getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(String errorMessage) {
		this.errorMessage = errorMessage;
	}

	public ArrayList<String> getColumnName() {
		return columnName;
	}

	public void setColumnName(ArrayList<String> columnName) {
		this.columnName = columnName;
	}

	public ArrayList<String> getColumnType() {
		return columnType;
	}

	public void setColumnType(ArrayList<String> columnType) {
		this.columnType = columnType;
	}

	public ArrayList<String[]> getData() {
		return data;
	}

	public void setData(ArrayList<String[]> data) {
		this.data = data;
	}
	
	public void setQuery(String query) {
		this.query = query;
	}

	public String toString(){
		String result="";
		if(formatOutput==null){
			formatOutput="json";
		}else if(formatOutput.equals("csv")){
			formatOutput="csv";
		}else{
			formatOutput="json";
		}
		
		if(formatOutput.equals("json")){
			try {
				result=toJson().toString();
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		if(formatOutput.equals("csv")){
			result=toCsv();
		}
		return result;
	}
	
	public JSONObject toJson() throws JSONException{	
		
		JSONObject jsonResult=new JSONObject();
		jsonResult.put("errorMessage", errorMessage);
		jsonResult.put("responseStatus", responseStatus);
		jsonResult.put("page", page);
		jsonResult.put("columnName", columnName);
		jsonResult.put("columnType", columnType);
		jsonResult.put("data", data);
		jsonResult.put("totalPage", totalPage);
		jsonResult.put("unitsPerPage", unitsPerPage);
		jsonResult.put("sqlQuery", this.query);
		return jsonResult;
	}
	public String toCsv(){
		String csv="";
		//Add header column
		for(int i=0;i<this.columnName.size();i++){
			if(i>0){
				csv+="|";
			}
			csv+="\""+this.columnName.get(i)+"\"";
		}		
		//Add csv data
		for(int i=0;i<this.data.size();i++){
			String[] lineArray=this.data.get(i);
			csv+="\n";
			for(int k=0;k<lineArray.length;k++){
				if(k>0){
					csv+="|";
				}
				csv+="\""+lineArray[k]+"\"";
			}
		}
		return csv;
	}
	public static void main(String[] args) throws JSONException {
		// TODO Auto-generated method stub
		ApiResponseResultSet response=new ApiResponseResultSet();
		response.setPage(1);
		response.setResponseStatus("OK");
		response.setTotalPage(100);
		response.setUnitsPerPage(100);
		response.setErrorMessage("");
		
		ArrayList<String> columnName=new ArrayList<String>();
		ArrayList<String> columnType=new ArrayList<String>();
		ArrayList<String[]> data=new ArrayList<String[]>();
		
		columnName.add("A");
		columnName.add("B");
		columnName.add("C");
		
		columnType.add("int");
		columnType.add("int");
		columnType.add("int");
		
		String[] dataItem=new String[3];
		dataItem[0]="1";
		dataItem[1]="2";
		dataItem[2]="3";
		
		data.add(dataItem);
		
		dataItem=new String[3];
		dataItem[0]="4";
		dataItem[1]="5";
		dataItem[2]="6";
		
		data.add(dataItem);
		
		response.setColumnName(columnName);
		response.setColumnType(columnType);
		response.setData(data);
		
		JSONObject a=response.toJson();
		
		System.out.println(a.toString());
	}

}
