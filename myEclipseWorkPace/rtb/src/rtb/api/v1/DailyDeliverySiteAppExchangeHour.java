package rtb.api.v1;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import rtb.bean.ApiInfo;
import rtb.bean.ApiResponseResultSetInfo;
import rtb.core.MainApi;


public class DailyDeliverySiteAppExchangeHour extends MainApi{
	
	public DailyDeliverySiteAppExchangeHour() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("rtb.vw_agg_delivery_rtb_site_app_exchange_hour");
		this.setDefaultDimensions(new String[]{"eastern_date"});
		this.setDefaultMeasures(new String[]{"adcel_paid_amount"});
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
		info.addDimension(new String[] { "eastern_date", "", "date" });
		info.addDimension(new String[] { "eastern_hour", "", "integer" });
		info.addDimension(new String[] { "utc_datetime", "", "timestamp without time zone" });
		info.addDimension(new String[] { "utc_epoch_timestamp", "", "double" });
		info.addDimension(new String[] { "exchange", "", "string" });
		info.addDimension(new String[] { "rtbm_adm_flight_id", "", "integer" });
		info.addDimension(new String[] { "rtb_flight_id", "", "integer" });
		info.addDimension(new String[] { "src_id", "", "string" });
		info.addDimension(new String[] { "adcel_exchange", "", "string" });
		info.addDimension(new String[] { "adcel_hour24_of_day", "", "integer" });
		info.addDimension(new String[] { "adcel_rtb_flight_id", "", "interger" });
		info.addDimension(new String[] { "adcel_src_id", "", "string" });
		info.addDimension(new String[] { "winnotice_exchange", "", "string" });
		info.addDimension(new String[] { "winnotice_hour24_of_day", "", "interger" });
		info.addDimension(new String[] { "winnotice_rtb_flight_id", "", "interger" });
		info.addDimension(new String[] { "winnotice_src_id", "", "string" });
		// add measures
		info.addMeasures(new String[] { "adcel_total_requests", "", "integer" });
		info.addMeasures(new String[] { "adcel_filled_requests", "", "integer" });
		info.addMeasures(new String[] { "adcel_unfilled_requests", "", "integer"});
		info.addMeasures(new String[] { "adcel_event_adimpinternal", "", "integer" });
		info.addMeasures(new String[] { "adcel_event_click", "", "integer" });
		info.addMeasures(new String[] { "adcel_paid_amount", "", "double" });
		info.addMeasures(new String[] { "winnotice_win_cnt", "", "integer" });
		info.addMeasures(new String[] { "winnotice_paid_amount", "", "double" });
		
		// add constraint
		info.addConstraint(new String[] { "eastern_date", "date",currentDateExample });
		info.addConstraint(new String[] { "eastern_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "eastern_hour.in", "integer","1,2,3,4,5" });
		info.addConstraint(new String[] { "eastern_hour", "integer","4" });
		info.addConstraint(new String[] { "exchange.in", "string","mopub,flurry,rubicon,pubmatic,nexage" });
		info.addConstraint(new String[] { "exchange", "string","nexage" });

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=eastern_date");
		info.addSelectExample("GET " + rootUrl + "?select=eastern_date|exchange");
		// add by example
		info.addByExample("GET " + rootUrl + "?by=adcel_filled_requests");
		info.addByExample("GET " + rootUrl + "?by=adcel_paid_amount");
		info.addByExample("GET " + rootUrl + "?by=winnotice_win_cnt");
		info.addByExample("GET " + rootUrl + "?by=adcel_event_click|winnotice_win_cnt|adcel_paid_amount");
		info.addByExample("GET " + rootUrl + "?select=eastern_date|exchange&by=winnotice_win_cnt");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[eastern_date]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[eastern_date.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[eastern_date]="	+ currentDateExample + "&where[exchange.in]=nexage,mopub");
		info.addWhereExample("GET " + rootUrl + "?select=eastern_date&by=winnotice_win_cnt&where[eastern_date]="	+ currentDateExample);
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=eastern_date.desc");
		info.addOrderExample("GET " + rootUrl + "?select=eastern_date&by=winnotice_win_cnt&where[eastern_date]="	+ currentDateExample + "&order=eastern_date.desc");
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
