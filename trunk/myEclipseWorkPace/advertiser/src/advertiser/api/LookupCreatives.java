package advertiser.api;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import advertiser.bean.ApiResponseResultSetInfo;
import advertiser.utils.Configure;


public class LookupCreatives extends MainApiLookup{

	public LookupCreatives() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("dim_creatives");
		this.setDefaultDimensions(new String[]{"dfp_creative_id"});
	}
	@Override
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request) {
		ApiResponseResultSetInfo info = new ApiResponseResultSetInfo();
		String hosting=Configure.getConfig("hosting");
		String appName=Configure.getConfig("appName");
		String apiUrl = Configure.getConfig("lookupCreativesUrl");
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
		info.addDimension(new String[] { "dfp_creative_id", "", "int" });
		info.addDimension(new String[] { "adm_creative_id", "", "int" });
		info.addDimension(new String[] { "adm_flight_id", "", "int" });
		info.addDimension(new String[] { "adm_creative_name", "", "string" });
		info.addDimension(new String[] { "dfp_version", "", "int" });
		// add measures

		// add constraint
		info.addConstraint(new String[] { "dfp_creative_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "adm_creative_id.in", "integer", "4,8,9" });
		info.addConstraint(new String[] { "adm_flight_id.in", "integer", "3,7,2" });
		info.addConstraint(new String[] { "adm_creative_name", "string", "abc" });
		info.addConstraint(new String[] { "adm_creative_name.like", "string", "abc" });

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=dfp_creative_id");
		info.addSelectExample("GET " + rootUrl + "?select=dfp_creative_id|adm_creative_id|adm_flight_id");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[adm_creative_name]="+"abc");
		info.addWhereExample("GET " + rootUrl + "?where[dfp_creative_id.in]=1,2,3,4");
		info.addWhereExample("GET " + rootUrl + "?where[adm_creative_name.like]="+"abc");
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=adm_creative_name.desc");
		info.addOrderExample("GET " + rootUrl + "?order=dfp_creative_id.desc|adm_creative_name");
		return info;
	}

}
