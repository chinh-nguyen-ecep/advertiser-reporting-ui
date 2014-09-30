package vlmoui.api.v1;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import vlmoui.bean.ApiResponseResultSetInfo;
import vlmoui.core.MainApi;
import vlmoui.utils.Configure;

public class OffersEvent extends MainApi {
	public OffersEvent() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("vlmo_dw.vw_vlmo_fct_offer");
		this.setDefaultDimensions(new String[]{"full_date"});
		this.setDefaultMeasures(new String[]{"imp_cnt","click_cnt"});
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
		Date reportDate7 = new Date(date.getTime() - 8 * 24 * 60 * 60 * 1000);
		Date reportDate = new Date(date.getTime() - 2 * 24 * 60 * 60 * 1000);

		String reportDateExample = dateFormat.format(reportDate7);
		String currentDateExample = dateFormat.format(reportDate);

		// add dimensions
		info.addDimension(new String[] { "full_date", "", "date" });
		info.addDimension(new String[] { "network_id", "", "integer" });
		info.addDimension(new String[] { "network_title", "", "string" });
		info.addDimension(new String[] { "merchant_id", "", "integer" });
		info.addDimension(new String[] { "merchant_name", "", "string" });
		info.addDimension(new String[] { "campaign_id", "", "integer" });
		info.addDimension(new String[] { "campaign_title", "", "string" });
		info.addDimension(new String[] { "offer_id", "", "integer" });
		info.addDimension(new String[] { "offer_title", "", "string" });
		
		// add measures
		info.addMeasures(new String[] { "imp_cnt", "", "integer"});
		info.addMeasures(new String[] { "click_cnt", "", "integer" });
		info.addMeasures(new String[] { "refresh_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_tap_refresh_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_map_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_lp_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_call_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_cal_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_video_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_face_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_twit_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_email_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_swipe_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_save_coupon_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_click_to_save_coupon_cnt", "", "integer" });
		info.addMeasures(new String[] { "cta_click_to_send_coupon_cnt", "", "integer" });
		info.addMeasures(new String[] { "duration_cnt", "", "integer" });
		info.addMeasures(new String[] { "videonotrack_cnt", "", "integer" });
		info.addMeasures(new String[] { "video0_cnt", "", "integer" });
		info.addMeasures(new String[] { "video25_cnt", "", "integer" });
		info.addMeasures(new String[] { "video50_cnt", "", "integer" });
		info.addMeasures(new String[] { "video75_cnt", "", "integer" });
		info.addMeasures(new String[] { "video100_cnt", "", "integer" });

		// add constraint
		info.addConstraint(new String[] { "full_date", "date",currentDateExample });
		info.addConstraint(new String[] { "full_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "network_id", "integer","1" });
		info.addConstraint(new String[] { "network_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "network_title", "string","Yahoo" });
		info.addConstraint(new String[] { "network_title.in", "string","Shooger,Yahoo" });
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

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=full_date");
		info.addSelectExample("GET " + rootUrl + "?select=full_date|account_id|offer_id");
		
		// add by example
		info.addByExample("GET " + rootUrl + "?by=click_cnt");
		info.addByExample("GET " + rootUrl + "?by=imp_cnt|click_cnt");
		info.addByExample("GET " + rootUrl + "?select=full_date|account_id|offer_id&by=click_cnt");
		
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="	+ currentDateExample + "&where[network_id.in]=1,2,3");
		info.addWhereExample("GET " + rootUrl + "?select=full_date&by=click_cnt&where[full_date]="	+ currentDateExample);
		
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=full_date.desc");
		info.addOrderExample("GET " + rootUrl + "?select=full_date&by=click_cnt&where[full_date]="	+ currentDateExample + "&order=full_date.desc");
		return info;
	}

}
