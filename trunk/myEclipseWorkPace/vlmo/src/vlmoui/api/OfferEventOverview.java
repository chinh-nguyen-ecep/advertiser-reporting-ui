package vlmoui.api;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import vlmoui.bean.ApiResponseResultSetInfo;
import vlmoui.utils.Configure;

public class OfferEventOverview extends MainApi {
	public OfferEventOverview() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("vlmo_dw.vw_vlmo_fct_event");
		this.setDefaultDimensions(new String[]{"full_date","offer_id", "event_name"});
		this.setDefaultMeasures(new String[]{"raw_count","unique_count"});
		this.setDataSourceJNDIConn("verveReportConnection");
	}
	
	@Override
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request) {
		ApiResponseResultSetInfo info = new ApiResponseResultSetInfo();
		String hosting = Configure.getConfig("hosting");
		String appName = Configure.getConfig("appName");
		String apiUrl  = Configure.getConfig("offerEventOverviewUrl");
		String rootUrl = hosting + "/" + appName + apiUrl;
		
		info.setRootUrl("Get " + rootUrl);
		
		// get date example
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		Date reportDate7 = new Date(date.getTime() - 8 * 24 * 60 * 60 * 1000);
		Date reportDate = new Date(date.getTime() - 2 * 24 * 60 * 60 * 1000);

		String reportDateExample = dateFormat.format(reportDate7);
		String currentDateExample = dateFormat.format(reportDate);

		// add dimensions
		info.addDimension(new String[] { "full_date", "", "date" });
		info.addDimension(new String[] { "network_id", "", "integer" });
		info.addDimension(new String[] { "network_title", "", "string" });
		info.addDimension(new String[] { "account_id", "", "integer" });
		info.addDimension(new String[] { "merchant_id", "", "integer" });
		info.addDimension(new String[] { "merchant_name", "", "string" });
		info.addDimension(new String[] { "campaign_id", "", "integer" });
		info.addDimension(new String[] { "campaign_title", "", "string" });
		info.addDimension(new String[] { "offer_id", "", "integer" });
		info.addDimension(new String[] { "offer_title", "", "string" });
		info.addDimension(new String[] { "event_name", "", "string" });
		
		// add measures
		info.addMeasures(new String[] { "raw_count", "", "integer"});
		info.addMeasures(new String[] { "unique_count", "", "integer" });

		// add constraint
		info.addConstraint(new String[] { "full_date", "date",currentDateExample });
		info.addConstraint(new String[] { "full_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "network_id", "integer","1" });
		info.addConstraint(new String[] { "network_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "network_title", "string","Yahoo" });
		info.addConstraint(new String[] { "network_title.in", "string","Shooger,Yahoo" });
		info.addConstraint(new String[] { "account_id", "integer","1" });
		info.addConstraint(new String[] { "account_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "merchant_id", "integer","1" });
		info.addConstraint(new String[] { "merchant_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "merchant_name", "string","Blossom Park Dental Care" });
		info.addConstraint(new String[] { "merchant_name.in", "string","Blossom Park Dental Care,We Take the Cake" });
		info.addConstraint(new String[] { "campaign_id", "integer","1" });
		info.addConstraint(new String[] { "campaign_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "campaign_title", "string","Oil Change Special!" });
		info.addConstraint(new String[] { "campaign_title.in", "string","Oil Change Special!,July through September" });
		info.addConstraint(new String[] { "offer_id", "integer","1" });
		info.addConstraint(new String[] { "offer_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "offer_title", "string","Soothe your skin after summer sun!" });
		info.addConstraint(new String[] { "offer_title.in", "string","Soothe your skin after summer sun!,Massage Envy - AUG 2014" });
		info.addConstraint(new String[] { "event_name", "string","imp" });
		info.addConstraint(new String[] { "event_name.in", "string","imp,click,cta_map" });

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=full_date");
		info.addSelectExample("GET " + rootUrl + "?select=full_date|account_id|offer_id");
		
		// add by example
		info.addByExample("GET " + rootUrl + "?by=unique_count");
		info.addByExample("GET " + rootUrl + "?by=raw_count|unique_count");
		info.addByExample("GET " + rootUrl + "?select=full_date|account_id|offer_id|event_name&by=unique_count");
		
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="	+ currentDateExample + "&where[network_id.in]=1,2,3");
		info.addWhereExample("GET " + rootUrl + "?select=full_date&by=unique_count&where[full_date]="	+ currentDateExample);
		
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=full_date.desc");
		info.addOrderExample("GET " + rootUrl + "?select=full_date&by=unique_count&where[full_date]="	+ currentDateExample + "&order=full_date.desc");
		return info;
	}

}
