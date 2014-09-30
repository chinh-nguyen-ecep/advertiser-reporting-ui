package rtb.api.v1;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import rtb.bean.ApiInfo;
import rtb.bean.ApiResponseResultSetInfo;
import rtb.core.MainApi;
import rtb.utils.Configure;


public class DailyDeliveryPubSrc extends MainApi{
	
	public DailyDeliveryPubSrc() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("rtb.daily_agg_delivery_rtb_pub_src");
		this.setDefaultDimensions(new String[]{"full_date"});
		this.setDefaultMeasures(new String[]{"filled_requests"});
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
		info.addDimension(new String[] { "publisher_id", "", "integer" });
		info.addDimension(new String[] { "publisher_name", "", "string" });
		info.addDimension(new String[] { "property_id", "", "integer" });
		info.addDimension(new String[] { "property_name", "", "string" });
		info.addDimension(new String[] { "partner_id", "", "integer" });
		info.addDimension(new String[] { "partner_name", "", "string" });
		info.addDimension(new String[] { "partner_keyword", "", "string" });
		info.addDimension(new String[] { "rtbm_adm_flight_id", "", "integer" });
		info.addDimension(new String[] { "rtb_flight_id", "", "integer" });
		info.addDimension(new String[] { "pub_id", "", "string" });
		info.addDimension(new String[] { "src_id", "", "string" });
		info.addDimension(new String[] { "src_name", "", "string" });
		info.addDimension(new String[] { "bid_price", "", "double" });
		info.addDimension(new String[] { "won_price", "", "double" });
		
		// add measures
		info.addMeasures(new String[] { "total_requests", "", "integer" });
		info.addMeasures(new String[] { "filled_requests", "", "integer" });
		info.addMeasures(new String[] { "unfilled_requests", "", "integer"});
		info.addMeasures(new String[] { "event_imp", "", "integer" });
		info.addMeasures(new String[] { "event_adimpinternal", "", "integer" });
		info.addMeasures(new String[] { "event_click", "", "integer" });
		info.addMeasures(new String[] { "bid_amount", "", "double" });
		info.addMeasures(new String[] { "paid_amount", "", "double" });
		
		// add constraint
		info.addConstraint(new String[] { "full_date", "date",currentDateExample });
		info.addConstraint(new String[] { "full_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "publisher_name.in", "string","MoPub 119,NexageRTB,MopubRTB,PubmaticRTB" });
		info.addConstraint(new String[] { "publisher_name", "string","nexage" });
		info.addConstraint(new String[] { "partner_name.in", "string","MoPub 119,NexageRTB,MopubRTB,PubmaticRTB" });
		info.addConstraint(new String[] { "partner_name", "string","nexage" });

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=full_date");
		info.addSelectExample("GET " + rootUrl + "?select=full_date|partner_name");
		// add by example
		info.addByExample("GET " + rootUrl + "?by=event_imp");
		info.addByExample("GET " + rootUrl + "?by=paid_amount");
		info.addByExample("GET " + rootUrl + "?by=bid_amount");
		info.addByExample("GET " + rootUrl + "?by=event_imp|bid_amount|paid_amount");
		info.addByExample("GET " + rootUrl + "?select=full_date|partner_name&by=bid_amount");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="	+ currentDateExample + "&where[partner_name.in]=NexageRTB,MopubRTB,PubmaticRTB");
		info.addWhereExample("GET " + rootUrl + "?select=full_date&by=bid_amount&where[full_date]="	+ currentDateExample);
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=full_date.desc");
		info.addOrderExample("GET " + rootUrl + "?select=full_date&by=bid_amount&where[full_date]="	+ currentDateExample + "&order=full_date.desc");
		return info;
	}
	@Override
	public ApiInfo getApiInfo() {
		// TODO Auto-generated method stub
		ApiInfo apiInfo=new ApiInfo();
		apiInfo.group="";
		apiInfo.isActive=true;
		return apiInfo;
	}
}
