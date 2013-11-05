package org.ecepvn.api;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import org.ecepvn.api.core.ConnectionJNDI;
import org.ecepvn.api.core.ConnectionUtils;
import org.ecepvn.api.core.RequestProcessing;
import org.ecepvn.bean.ApiResponseResultSet;
import org.ecepvn.bean.ApiResponseResultSetInfo;

import utils.Configure;
import database.JNDIConnection;

public class AdcelApi implements QueryApi {
	final private String dataSourceTableName = "adstraffic.daily_ad_serving_stats";

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		String[] test = new String[2];
		test[0] = "hello";
		test[1] = "sdfsdf";

	}

	@Override
	public ApiResponseResultSet processApiRequest(HttpServletRequest request) {
		// TODO Auto-generated method stub
		ApiResponseResultSet apiResult = new ApiResponseResultSet();
		boolean isException = false;
		String exceptionMessage = "";

		String dimensions = RequestProcessing.processDimensionsInput(request);// a,b
		String measures = RequestProcessing.processMeasuresInput(request);// SUM(c) as c,SUM(d) as d
		String orders = RequestProcessing.processOrderInput(request); // ORDER BY a desc,b asc
		String wheres = RequestProcessing.processWhereInput(request);// WHERE a='abc' AND b BETWEEN '2013-06-07' AND '2013-06-02'
		String unitsPerPage = request.getParameter("limit");// 100
		String page = request.getParameter("page");// 1
		// Set default values
		
		if (dimensions.equals("")) {
			dimensions = "full_date,ad_network_id,ad_network_name,partner_id,partner_name,partner_description,portal_id,portal_name";
		}
		if (measures.equals("")) {
			measures = "SUM(fullfilled_code_count) as fullfilled_code_count,SUM(fullfilled_code_n) as fullfilled_code_n,SUM(fullfilled_code_e) as fullfilled_code_e,SUM(fullfilled_code_t) as fullfilled_code_t";
		}
		if (wheres.equals("")) {
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
			Date date = new Date();
			Date reportDate = new Date(date.getTime() - 1 * 24 * 60 * 60 * 1000);
			wheres = "WHERE full_date='" + dateFormat.format(reportDate)
					+ "' AND is_active=true";
		} else {
			wheres += " AND is_active=true";
		}
		if (unitsPerPage == null) {
			unitsPerPage = "" + apiResult.getUnitsPerPage();
		}
		if (page == null) {
			page = "" + apiResult.getPage();
		}

		try {
			Connection connectionDB = JNDIConnection.getConnection(Configure.getConfig("adcelJNDIConnect"));
			int totalPageNumber = 0;
			if (Integer.parseInt(page) == 1) {
				totalPageNumber = ConnectionUtils.getTotalPageNumber(
						connectionDB, dataSourceTableName, dimensions,
						measures, wheres, orders,
						Integer.parseInt(unitsPerPage));
			} else {
				totalPageNumber = -1;
			}

			ResultSet resultSet = ConnectionUtils.queryTable(connectionDB,
					dataSourceTableName, dimensions, measures, wheres, orders,
					Integer.parseInt(unitsPerPage), Integer.parseInt(page));

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
			apiResult.setUnitsPerPage(Integer.parseInt(unitsPerPage));

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
		return apiResult;
	}

	@Override
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request) {
		// TODO Auto-generated method stub
		ApiResponseResultSetInfo info = new ApiResponseResultSetInfo();
		String hosting=Configure.getConfig("hosting");
		String appName=Configure.getConfig("appName");
		String apiUrl = Configure.getConfig("adcelAPIUrl");
		String rootUrl=hosting+"/"+appName+apiUrl;
		info.setRootUrl("Get " + rootUrl);

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
		info.addSelectExample("GET " + rootUrl + "?select=full_date");
		info.addSelectExample("GET " + rootUrl
				+ "?select=full_date|ad_network_id|ad_network_name");
		// add by example
		info.addByExample("GET " + rootUrl + "?by=fullfilled_code_count");
		info.addByExample("GET " + rootUrl
				+ "?by=fullfilled_code_count|fullfilled_code_n");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="
				+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date.between]="
				+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl
				+ "?where[ad_network_id.in]=1,2,3,4");
		info.addWhereExample("GET " + rootUrl + "?where[ad_network_name]=DFP");
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="
				+ currentDateExample + "&where[ad_network_name]=DFP");
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=full_date.desc");
		info.addOrderExample("GET " + rootUrl
				+ "?order=full_date.desc|ad_network_name");

		return info;
	}

}
