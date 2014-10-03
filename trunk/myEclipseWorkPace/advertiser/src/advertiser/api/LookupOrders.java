package advertiser.api;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import advertiser.bean.ApiResponseResultSetInfo;
import advertiser.utils.Configure;


public class LookupOrders extends MainApiLookup{

	public LookupOrders() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("dim_orders");
		this.setDefaultDimensions(new String[]{"adm_order_id"});
	}
	@Override
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request) {
		ApiResponseResultSetInfo info = new ApiResponseResultSetInfo();
		String hosting=Configure.getConfig("hosting");
		String appName=Configure.getConfig("appName");
		String apiUrl = Configure.getConfig("lookupOrdersUrl");
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
		info.addDimension(new String[] { "adm_order_id", "", "int" });
		info.addDimension(new String[] { "adm_organization_id", "", "int" });
		info.addDimension(new String[] { "adm_order_name", "", "string" });
		info.addDimension(new String[] { "start_date", "", "date" });
		info.addDimension(new String[] { "end_date", "", "date" });
		info.addDimension(new String[] { "dfp_version", "", "int" });
		// add measures

		// add constraint
		info.addConstraint(new String[] { "adm_order_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "start_date", "date",currentDateExample });
		info.addConstraint(new String[] { "start_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "end_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "adm_organization_id.in", "integer", "4,8,9" });
		info.addConstraint(new String[] { "creative_id.in", "integer", "3,7,2" });
		info.addConstraint(new String[] { "adm_order_name", "string", "abc" });
		info.addConstraint(new String[] { "adm_order_name.like", "string", "abc" });

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=adm_order_id");
		info.addSelectExample("GET " + rootUrl + "?select=adm_order_id|adm_organization_id|adm_order_name");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[start_date]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[start_date.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[adm_order_id.in]=1,2,3,4");
		info.addWhereExample("GET " + rootUrl + "?where[adm_order_name.like]=House");
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=adm_order_id.desc");
		info.addOrderExample("GET " + rootUrl + "?order=adm_order_id.desc|adm_organization_id");
		return info;
	}

}
