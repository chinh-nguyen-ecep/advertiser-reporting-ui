package org.ecepvn.api;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import org.ecepvn.bean.ApiResponseResultSetInfo;
import utils.Configure;


public class DailyExchangerCostAnalysis extends MainApi{

	public DailyExchangerCostAnalysis() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("rtb.daily_agg_exchanger_cost_analysis_v1");
		this.setDefaultDimensions(new String[]{"full_date"});
		this.setDefaultMeasures(new String[]{"paid_amount","avg_paid_price","avg_bid_price"});
		this.setDataSourceJNDIConn("verveReportConnection");
	}
	@Override
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request) {
		ApiResponseResultSetInfo info = new ApiResponseResultSetInfo();
		String hosting=Configure.getConfig("hosting");
		String appName=Configure.getConfig("appName");
		String apiUrl = Configure.getConfig("dailyExchangerPayoutAPIUrl");
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
		info.addDimension(new String[] { "calendar_year_month", "", "string" });
		info.addDimension(new String[] { "exchanger", "", "string" });
		// add measures
		info.addMeasures(new String[] { "avg_paid_price", "", "double"});
		info.addMeasures(new String[] { "avg_bid_price", "", "double" });
		info.addMeasures(new String[] { "imp_cnt", "", "integer" });
		info.addMeasures(new String[] { "paid_amount", "", "integer" });

		// add constraint
		info.addConstraint(new String[] { "exchanger.in", "integer","nexage,mopub" });
		info.addConstraint(new String[] { "exchanger", "string","nexage" });
		info.addConstraint(new String[] { "full_date", "date",currentDateExample });
		info.addConstraint(new String[] { "full_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "calendar_year_month", "string","2014-Jan" });
		info.addConstraint(new String[] { "calendar_year_month.in", "string","2014-Jan,2014-Feb" });

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=full_date");
		info.addSelectExample("GET " + rootUrl + "?select=full_date|exchanger");
		// add by example
		info.addByExample("GET " + rootUrl + "?by=avg_paid_price");
		info.addByExample("GET " + rootUrl + "?by=avg_paid_price|avg_bid_price");
		info.addByExample("GET " + rootUrl + "?select=full_date|exchanger&by=avg_paid_price");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="	+ currentDateExample + "&where[exchanger.in]=nexage,mopub");
		info.addWhereExample("GET " + rootUrl + "?select=full_date&by=avg_paid_price&where[full_date]="	+ currentDateExample);
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=full_date.desc");
		info.addOrderExample("GET " + rootUrl + "?select=full_date&by=avg_paid_price&where[full_date]="	+ currentDateExample + "&order=full_date.desc");
		return info;
	}

}
