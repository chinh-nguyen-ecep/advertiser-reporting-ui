package vlmoui.api.v1;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import vlmoui.bean.ApiResponseResultSetInfo;
import vlmoui.core.MainApi;
import vlmoui.utils.Configure;


public class RunningRevenueOverview extends MainApi{

	public RunningRevenueOverview() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("vlmo_dw.daily_agg_running_revenue");
		this.setDefaultDimensions(new String[]{"full_date","network_title"});
		this.setDefaultMeasures(new String[]{"booked_imps","adimpinternals","imps","clicks","remaining_imps","billable_imps"});
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
		info.addDimension(new String[] { "full_date", "", "date" });
		info.addDimension(new String[] { "calendar_year_month", "", "string" });
		info.addDimension(new String[] { "month_since_2005", "", "integer" });
		info.addDimension(new String[] { "network_id", "", "integer" });
		info.addDimension(new String[] { "network_title", "", "string" });
		info.addDimension(new String[] { "publisher_id", "", "integer" });
		info.addDimension(new String[] { "merchant_id", "", "integer" });
		info.addDimension(new String[] { "merchant_name", "", "string" });
		info.addDimension(new String[] { "external_id", "", "integer" });
		info.addDimension(new String[] { "offer_id", "", "integer" });
		info.addDimension(new String[] { "offer_title", "", "string" });
		info.addDimension(new String[] { "campaign_id", "", "integer" });
		info.addDimension(new String[] { "campaign_title", "", "string" });
		
		// add measures
		info.addMeasures(new String[] { "adimpinternals", "", "integer"});
		info.addMeasures(new String[] { "imps", "", "integer" });
		info.addMeasures(new String[] { "clicks", "", "integer" });
		info.addMeasures(new String[] { "cta_any", "", "integer" });

		// add constraint
		info.addConstraint(new String[] { "full_date", "date",currentDateExample });
		info.addConstraint(new String[] { "full_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "calendar_year_month", "string","2014-Jan" });
		info.addConstraint(new String[] { "calendar_year_month.in", "string","2014-Jan,2014-Feb" });		
		info.addConstraint(new String[] { "month_since_2005", "integer","109" });
		info.addConstraint(new String[] { "publisher_id", "integer","1" });
		info.addConstraint(new String[] { "publisher_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "merchant_id", "integer","1" });
		info.addConstraint(new String[] { "merchant_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "merchant_name", "string","Blossom Park Dental Care" });
		info.addConstraint(new String[] { "merchant_name.in", "string","Blossom Park Dental Care,We Take the Cake" });

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=full_date");
		info.addSelectExample("GET " + rootUrl + "?select=full_date|merchant_name");
		// add by example
		info.addByExample("GET " + rootUrl + "?by=imps");
		info.addByExample("GET " + rootUrl + "?by=imps|clicks");
		info.addByExample("GET " + rootUrl + "?select=full_date|merchant_name&by=imps");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="	+ currentDateExample + "&where[merchant_id.in]=1,2,3");
		info.addWhereExample("GET " + rootUrl + "?select=full_date&by=imps&where[full_date]="	+ currentDateExample);
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=full_date.desc");
		info.addOrderExample("GET " + rootUrl + "?select=full_date&by=imps&where[full_date]="	+ currentDateExample + "&order=full_date.desc");
		return info;
	}

}
