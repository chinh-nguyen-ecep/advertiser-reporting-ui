package vlmoui.api;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import vlmoui.bean.ApiResponseResultSetInfo;
import vlmoui.utils.Configure;


public class LookupNetworks extends MainApiLookup{

	public LookupNetworks() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("vlmo_dw.vlmo_dim_networks");
		this.setDefaultDimensions(new String[]{"network_id","title"});
		this.setDataSourceJNDIConn("verveReportConnection");
	}
	@Override
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request) {
		ApiResponseResultSetInfo info = new ApiResponseResultSetInfo();
		String hosting=Configure.getConfig("hosting");
		String appName=Configure.getConfig("appName");
		String apiUrl = Configure.getConfig("lookupNetworksUrl");
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
		info.addDimension(new String[] { "network_id", "", "integer" });
		info.addDimension(new String[] { "title", "", "string" });
		info.addDimension(new String[] { "created_at", "", "date" });
		info.addDimension(new String[] { "updated_at", "", "date" });
		info.addDimension(new String[] { "publisher_id", "", "integer" });
		info.addDimension(new String[] { "status", "", "string" });
		info.addDimension(new String[] { "active_at", "", "date" });
		info.addDimension(new String[] { "runtime_minutes", "", "string" });
		info.addDimension(new String[] { "burnrate_multiple", "", "string" });
		info.addDimension(new String[] { "data_file_id", "", "integer" });
		info.addDimension(new String[] { "dt_effective", "", "date" });
		info.addDimension(new String[] { "dt_expire", "", "date" });
		// add measures

		// add constraint
		info.addConstraint(new String[] { "network_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "created_at", "date",currentDateExample });
		info.addConstraint(new String[] { "created_at.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "end_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "publisher_id.in", "integer", "4,8,9" });

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=network_id");
		info.addSelectExample("GET " + rootUrl + "?select=network_id|publisher_id");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[created_at]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[created_at.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[network_id.in]=1,2,3,4");
		info.addWhereExample("GET " + rootUrl + "?where[adm_order_name.like]=House");
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=network_id.desc");
		info.addOrderExample("GET " + rootUrl + "?order=network_id.desc|publisher_id");
		return info;
	}

}
