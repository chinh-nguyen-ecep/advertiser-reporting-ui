package vlmo.bean;

import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

public class ApiResponseResultSetInfo {
	private String apiUrl;
	private ArrayList<String[]> dimensions;
	private ArrayList<String[]> measures;
	private ArrayList<String[]> contraints;
	private ArrayList<String>	whereExample;
	private ArrayList<String>	selectExample;
	private ArrayList<String>	byExample;
	private ArrayList<String>	orderExample;
	/**
	 * @param args
	 */
	
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}
	public ApiResponseResultSetInfo() {
		super();
		apiUrl="";
		dimensions=new ArrayList<String[]>();
		measures=new ArrayList<String[]>();
		contraints=new ArrayList<String[]>();
		selectExample=new ArrayList<String>();
		whereExample=new ArrayList<String>();
		byExample=new ArrayList<String>();
		orderExample=new ArrayList<String>();
	}
	
	public void addDimension(String[] dimension){
		dimensions.add(dimension);
	}
	public void addMeasures(String[] measure){
		measures.add(measure);
	}
	public void addConstraint(String[] contraint){
		contraints.add(contraint);
	}
	public void addWhereExample(String example){
		whereExample.add(example);
	}
	public void addSelectExample(String example){
		selectExample.add(example);
	}
	public void addByExample(String example){
		byExample.add(example);
	}
	public void addOrderExample(String example){
		orderExample.add(example);
	}
	public void setRootUrl(String rootUrl) {
		this.apiUrl = rootUrl;
	}
	public String toString(){
		JSONObject json=new JSONObject();
		try {
			json.put("apiUrl", apiUrl);
			json.put("selectExample", selectExample);
			json.put("whereExample", whereExample);
			json.put("byExample", byExample);
			json.put("orderExample", orderExample);
			json.put("dimensions", dimensions);
			json.put("measures", measures);
			json.put("contraints", contraints);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return json.toString();
		
	}

}
