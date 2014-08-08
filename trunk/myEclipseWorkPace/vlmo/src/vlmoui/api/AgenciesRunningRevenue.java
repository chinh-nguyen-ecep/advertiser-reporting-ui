package vlmoui.api;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import vlmoui.bean.ApiResponseResultSetInfo;
import vlmoui.utils.Configure;


public class AgenciesRunningRevenue extends MainApi{

	public AgenciesRunningRevenue() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("vlmo_dw.vw_agg_running_revenue_agency");
		this.setDefaultDimensions(new String[]{"full_date","network_title"});
		this.setDefaultMeasures(new String[]{"billable_rate","billable_imps"});
		this.setDataSourceJNDIConn("verveReportConnection");
	}
	@Override
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request) {
		ApiResponseResultSetInfo info = new ApiResponseResultSetInfo();
		String hosting=Configure.getConfig("hosting");
		String appName=Configure.getConfig("appName");
		String apiUrl = Configure.getConfig("agenciesRunningRevenueUrl");
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
		info.addDimension(new String[] { "network_id", "", "integer" });
		info.addDimension(new String[] { "network_title", "", "string" });
		info.addDimension(new String[] { "network_id", "", "integer" });
		info.addDimension(new String[] { "publisher_id", "", "integer" });
		
		// add measures
		info.addMeasures(new String[] { "billable_rate", "", "double"});
		info.addMeasures(new String[] { "billable_imps", "", "integer" });
		info.addMeasures(new String[] { "gross_revenue", "", "double" });
		info.addMeasures(new String[] { "pub_net_revenue", "", "double" });
		info.addMeasures(new String[] { "profit_margin", "", "double" });

		// add constraint
		info.addConstraint(new String[] { "full_date", "date",currentDateExample });
		info.addConstraint(new String[] { "full_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "publisher_id", "integer","1" });
		info.addConstraint(new String[] { "publisher_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "network_id", "integer","1" });
		info.addConstraint(new String[] { "network_id.in", "integer","1,2,3" });
		
		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=full_date");
		info.addSelectExample("GET " + rootUrl + "?select=full_date|network_title");
		// add by example
		info.addByExample("GET " + rootUrl + "?by=billable_imps");
		info.addByExample("GET " + rootUrl + "?by=billable_imps|gross_revenue");
		info.addByExample("GET " + rootUrl + "?select=full_date|network_title&by=billable_imps");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="	+ currentDateExample + "&where[network_id.in]=1,2,3");
		info.addWhereExample("GET " + rootUrl + "?select=full_date&by=billable_imps&where[full_date]="	+ currentDateExample);
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=full_date.desc");
		info.addOrderExample("GET " + rootUrl + "?select=full_date&by=billable_imps&where[full_date]="	+ currentDateExample + "&order=full_date.desc");
		return info;
	}

}
