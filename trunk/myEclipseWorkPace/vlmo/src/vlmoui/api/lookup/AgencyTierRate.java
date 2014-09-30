package vlmoui.api.lookup;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import vlmoui.bean.ApiResponseResultSetInfo;
import vlmoui.core.MainApiLookup;
import vlmoui.utils.Configure;


public class AgencyTierRate extends MainApiLookup{

	public AgencyTierRate() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("billing.ba_vlmo_tiers_rate");
		this.setDefaultDimensions(new String[]{"account_id","account_name"});
		this.setDataSourceJNDIConn("verveReportConnection");
	}
	@Override
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request) {
		ApiResponseResultSetInfo info = new ApiResponseResultSetInfo();
		String rootUrl=request.getRequestURL().toString().split("\\?")[0];
		info.setRootUrl("Get " + rootUrl);
		// get date example
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		Date reportDate7 = new Date(date.getTime() - 6 * 24 * 60 * 60 * 1000);
		Date reportDate = new Date(date.getTime() - 2 * 24 * 60 * 60 * 1000);

		String reportDateExample = dateFormat.format(reportDate7);
		String currentDateExample = dateFormat.format(reportDate);

		// add dimensions
		info.addDimension(new String[] { "account_id", "", "integer" });
		info.addDimension(new String[] { "account_name", "", "string" });
		info.addDimension(new String[] { "is_tier", "", "boolean" });
		info.addDimension(new String[] { "standard_rate", "", "double" });
		info.addDimension(new String[] { "imps_text", "", "string" });
		info.addDimension(new String[] { "min_imps", "", "integer" });
		info.addDimension(new String[] { "max_imps", "", "integer" });
		info.addDimension(new String[] { "tier_rate", "", "double" });
		info.addDimension(new String[] { "created_at", "", "date" });
		info.addDimension(new String[] { "updated_at", "", "date" });
		info.addDimension(new String[] { "is_active", "", "boolean" });
		info.addDimension(new String[] { "is_display", "", "boolean" });
		// add measures

		// add constraint
//		info.addConstraint(new String[] { "network_id.in", "integer","1,2,3" });
//		info.addConstraint(new String[] { "created_at", "date",currentDateExample });
//		info.addConstraint(new String[] { "created_at.between", "date",reportDateExample + ".." + currentDateExample });
//		info.addConstraint(new String[] { "end_date.between", "date",reportDateExample + ".." + currentDateExample });
//		info.addConstraint(new String[] { "publisher_id.in", "integer", "4,8,9" });

		// add select example
//		info.addSelectExample("GET " + rootUrl + "?select=network_id");
//		info.addSelectExample("GET " + rootUrl + "?select=network_id|publisher_id");
		// add where example
//		info.addWhereExample("GET " + rootUrl + "?where[created_at]="+ currentDateExample);
//		info.addWhereExample("GET " + rootUrl + "?where[created_at.between]="+ reportDateExample + ".." + currentDateExample);
//		info.addWhereExample("GET " + rootUrl + "?where[network_id.in]=1,2,3,4");
//		info.addWhereExample("GET " + rootUrl + "?where[adm_order_name.like]=House");
		// add order example
//		info.addOrderExample("GET " + rootUrl + "?order=network_id.desc");
//		info.addOrderExample("GET " + rootUrl + "?order=network_id.desc|publisher_id");
		return info;
	}

}
