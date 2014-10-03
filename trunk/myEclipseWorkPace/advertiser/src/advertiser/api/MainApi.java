package advertiser.api;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import advertiser.bean.ApiResponseResultSet;
import advertiser.bean.ApiResponseResultSetInfo;
import advertiser.core.ConnectionUtils;
import advertiser.core.RequestProcessing;
import advertiser.database.JNDIConnection;
import advertiser.utils.AddableHttpRequest;
import advertiser.utils.Configure;


public class MainApi implements QueryApi{

	private String dataSourceTableName;
	private String dataSourceJNDIConn;
	private	String[] defaultDimensions;
	private String[] defaultMeasures;
	private String defaultUnitsPerPage="10";
	private String defaultPage="1";
	public String getDataSourceTableName() {
		return dataSourceTableName;
	}

	public MainApi() {
		super();
		this.dataSourceTableName = null;
		this.defaultDimensions=null;
		this.defaultMeasures=null;
		this.dataSourceJNDIConn=null;
	}

	public String getDataSourceJNDIConn() {
		return dataSourceJNDIConn;
	}

	public void setDataSourceJNDIConn(String dataSourceJNDIConn) {
		this.dataSourceJNDIConn = dataSourceJNDIConn;
	}

	public String[] getDefaultDimensions() {
		return defaultDimensions;
	}

	public void setDefaultDimensions(String[] defaultDimensions) {
		this.defaultDimensions = defaultDimensions;
	}

	public String[] getDefaultMeasures() {
		return defaultMeasures;
	}

	public void setDefaultMeasures(String[] defaultMeasures) {
		this.defaultMeasures = defaultMeasures;
	}


	public String getDefaultUnitsPerPage() {
		return defaultUnitsPerPage;
	}

	public void setDefaultUnitsPerPage(String defaultUnitsPerPage) {
		this.defaultUnitsPerPage = defaultUnitsPerPage;
	}

	public String getDefaultPage() {
		return defaultPage;
	}

	public void setDefaultPage(String defaultPage) {
		this.defaultPage = defaultPage;
	}

	public void setDataSourceTableName(String dataSourceTableName) {
		this.dataSourceTableName = dataSourceTableName;
	}

	@SuppressWarnings("unused")
	@Override
	public ApiResponseResultSet processApiRequest(HttpServletRequest request) {
		// TODO Auto-generated method stub
		AddableHttpRequest myRequest=new AddableHttpRequest(request);
		ApiResponseResultSet apiResult = new ApiResponseResultSet();
		boolean isException = false;
		String exceptionMessage = "";

		String dimensions = RequestProcessing.processDimensionsInput(request);// a,b
		String measures = RequestProcessing.processMeasuresInput(request);// SUM(c) as c,SUM(d) as d
		String orders = RequestProcessing.processOrderInput(request); // ORDER BY a desc,b asc
		String wheres = RequestProcessing.processWhereInput(request);// WHERE a='abc' AND b BETWEEN '2013-06-07' AND '2013-06-02'
		String unitsPerPage = request.getParameter("limit");// 100
		String page = request.getParameter("page");// 1
		String getQuery=request.getParameter("getQuery");
		//Set default value dimensions
		if(dimensions.equals("")&&this.defaultDimensions!=null){
			myRequest.addParameter("select", this.defaultDimensions);
			dimensions = RequestProcessing.processDimensionsInput(myRequest);
		}
		//Set default value measures
		if(measures.equals("")&&this.defaultMeasures!=null){
			myRequest.addParameter("by", this.defaultMeasures);
			measures = RequestProcessing.processMeasuresInput(myRequest);
		}
		//Set default value unitsPerPage
		if(unitsPerPage==null){
			unitsPerPage=this.defaultUnitsPerPage;
		}
		//Set default value page
		if(page==null){
			page=this.defaultPage;
		}
		try {
			Connection connectionDB ;
			if(this.dataSourceJNDIConn!=null){
				connectionDB = JNDIConnection.getConnection(this.dataSourceJNDIConn);
			}else{
				connectionDB = JNDIConnection.getConnection(Configure.getConfig("defaultJNDI"));
			}
			 
			int totalPageNumber = 0;
			if (Integer.parseInt(page) == 1) {
				totalPageNumber = ConnectionUtils.getTotalPageNumber(connectionDB, dataSourceTableName, dimensions,	measures, wheres, orders,Integer.parseInt(unitsPerPage));
			} else {
				totalPageNumber = -1;
			}

			ResultSet resultSet = ConnectionUtils.queryTable(connectionDB,dataSourceTableName, dimensions, measures, wheres, orders,Integer.parseInt(unitsPerPage), Integer.parseInt(page));
			String query=ConnectionUtils.getQuery(dataSourceTableName, dimensions, measures, wheres, orders,Integer.parseInt(unitsPerPage), Integer.parseInt(page));
			ArrayList<String> columnNameArray = new ArrayList<String>();
			ArrayList<String> columnTypeArray = new ArrayList<String>();
			ArrayList<String[]> data = new ArrayList<String[]>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int columnCount = resultSetMetaData.getColumnCount();
			for (int i = 1; i <= columnCount; i++) {
				String columnName = resultSetMetaData.getColumnName(i);
				String columnType = resultSetMetaData.getColumnTypeName(i);
				columnNameArray.add(columnName);
				columnTypeArray.add(columnType);
			}

			while (resultSet.next()) {
				String[] item = new String[columnCount];

				for (int i = 1; i <= columnCount; i++) {
					item[i - 1] = resultSet.getString(i);
				}
				data.add(item);
			}

			apiResult.setColumnName(columnNameArray);
			apiResult.setColumnType(columnTypeArray);
			apiResult.setData(data);
			apiResult.setErrorMessage("");
			apiResult.setResponseStatus("OK");
			apiResult.setTotalPage(totalPageNumber);
			System.out.println(totalPageNumber);
			apiResult.setUnitsPerPage(Integer.parseInt(unitsPerPage));
			apiResult.setPage(Integer.parseInt(page));
			if(getQuery!=null){
				apiResult.setQuery(query);
			}
			
			resultSet.close();
			connectionDB.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			isException = true;
			exceptionMessage = e.getMessage();
		} catch (NullPointerException e) {
			// TODO: handle exception
			e.printStackTrace();
			isException = true;
			exceptionMessage = e.getMessage();
		}
		if (isException == true) {
			apiResult.setErrorMessage(exceptionMessage);
			apiResult.setResponseStatus("ERROR");
		}
		apiResult.setFormatOutput(AddableHttpRequest.returnFormat(myRequest));
		return apiResult;
	}

	@Override
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request) {
		// TODO Auto-generated method stub
		ApiResponseResultSetInfo info = new ApiResponseResultSetInfo();
		String apiUrl = Configure.getConfig("adcelAPIUrl");//advertiserCreativeByHourAPIUrl
		info.setRootUrl("Get " + apiUrl);
		// get date example
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		Date reportDate7 = new Date(date.getTime() - 6 * 24 * 60 * 60 * 1000);
		Date reportDate = new Date(date.getTime() - 2 * 24 * 60 * 60 * 1000);

		String reportDateExample = dateFormat.format(reportDate7);
		String currentDateExample = dateFormat.format(reportDate);

		// add dimensions
		info.addDimension(new String[] { "full_date", "", "date" });
		info.addDimension(new String[] { "ad_network_id", "", "integer" });
		info.addDimension(new String[] { "ad_network_name", "", "string" });
		info.addDimension(new String[] { "partner_id", "", "integer" });
		info.addDimension(new String[] { "partner_name", "", "string" });
		info.addDimension(new String[] { "partner_description", "", "string" });
		info.addDimension(new String[] { "portal_id", "", "integer" });
		info.addDimension(new String[] { "portal_name", "", "string" });

		// add measures
		info.addMeasures(new String[] { "fullfilled_code_count", "", "integer" });
		info.addMeasures(new String[] { "fullfilled_code_y", "", "integer" });
		info.addMeasures(new String[] { "fullfilled_code_n", "", "integer" });
		info.addMeasures(new String[] { "fullfilled_code_e", "", "integer" });
		info.addMeasures(new String[] { "fullfilled_code_t", "", "integer" });

		// add constraint

		info.addConstraint(new String[] { "full_date", "date",
				currentDateExample });
		info.addConstraint(new String[] { "full_date.between", "date",
				reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "ad_network_id.in", "integer",
				"1,2,3" });
		info.addConstraint(new String[] { "partner_id.in", "integer", "4,8,9" });
		info.addConstraint(new String[] { "portal_id.in", "integer", "3,7,2" });

		// add select example
		info.addSelectExample("GET " + apiUrl + "?select=full_date");
		info.addSelectExample("GET " + apiUrl
				+ "?select=full_date|ad_network_id|ad_network_name");
		// add by example
		info.addByExample("GET " + apiUrl + "?by=fullfilled_code_count");
		info.addByExample("GET " + apiUrl
				+ "?by=fullfilled_code_count|fullfilled_code_n");
		// add where example
		info.addWhereExample("GET " + apiUrl + "?where[full_date]="
				+ currentDateExample);
		info.addWhereExample("GET " + apiUrl + "?where[full_date.between]="
				+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + apiUrl
				+ "?where[ad_network_id.in]=1,2,3,4");
		info.addWhereExample("GET " + apiUrl + "?where[ad_network_name]=DFP");
		info.addWhereExample("GET " + apiUrl + "?where[full_date]="
				+ currentDateExample + "&where[ad_network_name]=DFP");
		// add order example
		info.addOrderExample("GET " + apiUrl + "?order=full_date.desc");
		info.addOrderExample("GET " + apiUrl
				+ "?order=full_date.desc|ad_network_name");
		return info;
	}

}
