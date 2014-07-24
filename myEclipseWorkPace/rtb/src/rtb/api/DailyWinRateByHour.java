package rtb.api;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import rtb.bean.ApiResponseResultSetInfo;
import rtb.utils.Configure;


public class DailyWinRateByHour extends MainApi{

	public DailyWinRateByHour() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("rtb.daily_agg_winrate_by_hour");
		this.setDefaultDimensions(new String[]{"full_date"});
		this.setDefaultMeasures(new String[]{"bid_price"});
		this.setDataSourceJNDIConn("verveReportConnection");
	}
	@Override
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request) {
		ApiResponseResultSetInfo info = new ApiResponseResultSetInfo();
		String hosting=Configure.getConfig("hosting");
		String appName=Configure.getConfig("appName");
		String apiUrl = Configure.getConfig("dailyWinRateByHourAPIUrl");
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
		info.addDimension(new String[] { "month_since_2005", "", "integer" });
		info.addDimension(new String[] { "hour24_of_day", "", "integer" });
		info.addDimension(new String[] { "exchanger", "", "string" });
		info.addDimension(new String[] { "pub_id", "", "string" });
		info.addDimension(new String[] { "pub_name", "", "string" });
		info.addDimension(new String[] { "src_id", "", "string" });
		info.addDimension(new String[] { "src_name", "", "string" });
		info.addDimension(new String[] { "src_type", "", "string" });
		info.addDimension(new String[] { "is_active", "", "boolean" });
		info.addDimension(new String[] { "dt_lastchange", "", "timestamp" });

		// add measures
		info.addMeasures(new String[] { "bid_price", "", "double"});
		info.addMeasures(new String[] { "bid_cnt", "", "integer" });
		info.addMeasures(new String[] { "src_cnt", "", "integer" });
		info.addMeasures(new String[] { "imp_cnt", "", "integer" });
		info.addMeasures(new String[] { "bid_winrate", "", "double" });
		info.addMeasures(new String[] { "src_winrate", "", "double" });

		// add constraint
		info.addConstraint(new String[] { "exchanger.in", "string","nexage,mopub" });
		info.addConstraint(new String[] { "exchanger", "string","nexage" });
		info.addConstraint(new String[] { "full_date", "date",currentDateExample });
		info.addConstraint(new String[] { "full_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "calendar_year_month", "string","2014-Jan" });
		info.addConstraint(new String[] { "calendar_year_month.in", "string","2014-Jan,2014-Feb" });
		info.addConstraint(new String[] { "pub_id.in", "string","agltb3B1Yi1pbmNyEAsSB0FjY291bnQY-afzEgw,agltb3B1Yi1pbmNyEAsSB0FjY291bnQYrpTsEQw" });
		info.addConstraint(new String[] { "pub_id", "string","agltb3B1Yi1pbmNyEAsSB0FjY291bnQY-afzEgw" });
		info.addConstraint(new String[] { "src_id.in", "string","1,2,3" });
		info.addConstraint(new String[] { "src_name", "string","1" });
		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=full_date");
		info.addSelectExample("GET " + rootUrl + "?select=full_date|hour24_of_day|exchanger");
		// add by example
		info.addByExample("GET " + rootUrl + "?by=bid_price");
		info.addByExample("GET " + rootUrl + "?by=bid_price|bid_winrate");
		info.addByExample("GET " + rootUrl + "?by=bid_price.avg|bid_winrate.avg");
		info.addByExample("GET " + rootUrl + "?select=full_date|exchanger&by=bid_price");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="	+ currentDateExample + "&where[exchanger.in]=nexage,mopub");
		info.addWhereExample("GET " + rootUrl + "?select=full_date&by=bid_price&where[full_date]="	+ currentDateExample);
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=full_date.desc");
		info.addOrderExample("GET " + rootUrl + "?select=full_date&by=bid_price&where[full_date]="	+ currentDateExample + "&order=full_date.desc");
		return info;
	}

}
