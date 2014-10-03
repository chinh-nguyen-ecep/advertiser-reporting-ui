package advertiser.core;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

public class outputConvert {

	/**
	 * @param args
	 * @throws SQLException 
	 * @throws JSONException 
	 */
	public static JSONObject jsonConvert(ResultSet resultSet) throws SQLException, JSONException{
		JSONObject result=new JSONObject();
		ArrayList<String> columnNameArray=new ArrayList<String>();
		ArrayList<String> columnTypeArray=new ArrayList<String>();
		
		ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
		int columnCount=resultSetMetaData.getColumnCount();
		for(int i=1;i<=columnCount;i++){
			String columnName=resultSetMetaData.getColumnName(i);
			String columnType=resultSetMetaData.getColumnTypeName(i);
			columnNameArray.add(columnName);
			columnTypeArray.add(columnType);
		}
		result.put("columnName", columnNameArray);
		result.put("columnType", columnTypeArray);
		
		ArrayList<String[]> queryResult=new ArrayList<String[]>();
		
		while(resultSet.next()){
			String[] item=new String[columnCount];
			
			for(int i=1;i<=columnCount;i++){
				item[i-1]=resultSet.getString(i);
			}
			
			queryResult.add(item);
		}
		result.put("queryResult", queryResult);
		return result;
	}
	public static String csvConvert(ResultSet resultSet) throws SQLException{
		String csv="";
		ArrayList<String> columnNameArray=new ArrayList<String>();
		ArrayList<String> columnTypeArray=new ArrayList<String>();
		
		ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
		int columnCount=resultSetMetaData.getColumnCount();
		for(int i=1;i<=columnCount;i++){
			String columnName=resultSetMetaData.getColumnName(i);
			String columnType=resultSetMetaData.getColumnTypeName(i);
			columnNameArray.add(columnName);
			columnTypeArray.add(columnType);
		}
		
		ArrayList<String[]> queryResult=new ArrayList<String[]>();
		
		while(resultSet.next()){
			String[] item=new String[columnCount];
			
			for(int i=1;i<=columnCount;i++){
				item[i-1]=resultSet.getString(i);
			}
			
			queryResult.add(item);
		}
		
		//Add header column
		for(int i=0;i<columnNameArray.size();i++){
			if(i>0){
				csv+="|";
			}
			csv+="\""+columnNameArray.get(i)+"\"";
		}		
		
		//Add csv data
		for(int i=0;i<queryResult.size();i++){
			String[] lineArray=queryResult.get(i);
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
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
