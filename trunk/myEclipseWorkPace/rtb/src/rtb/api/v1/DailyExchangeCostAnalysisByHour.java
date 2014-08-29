package rtb.api.v1;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import rtb.bean.ApiInfo;
import rtb.bean.ApiResponseResultSetInfo;
import rtb.core.MainApi;
import rtb.utils.Configure;


public class DailyExchangeCostAnalysisByHour extends MainApi{

	public DailyExchangeCostAnalysisByHour() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("rtb.vw_agg_exchange_cost_analysis_by_hour");
		this.setDefaultDimensions(new String[]{"full_date"});
		this.setDefaultMeasures(new String[]{"paid_amount"});
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
		info.addDimension(new String[] { "hour24_of_day", "", "integer" });
		info.addDimension(new String[] { "exchange", "", "string" });
		// add measures
		info.addMeasures(new String[] { "wins", "", "integer" });
		info.addMeasures(new String[] { "ave_won_price", "", "double"});
		info.addMeasures(new String[] { "ave_bid_price", "", "double" });
		info.addMeasures(new String[] { "paid_amount", "", "double" });
		// add constraint
		info.addConstraint(new String[] { "full_date", "date",currentDateExample });
		info.addConstraint(new String[] { "full_date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "hour24_of_day", "integer","1" });
		info.addConstraint(new String[] { "hour24_of_day.between", "integer","0..23" });
		info.addConstraint(new String[] { "exchange.in", "string","nexage,mopub" });
		info.addConstraint(new String[] { "exchange", "string","nexage" });

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=full_date");
		info.addSelectExample("GET " + rootUrl + "?select=full_date|hour24_of_day");
		info.addSelectExample("GET " + rootUrl + "?select=full_date|exchange");
		// add by example
		info.addByExample("GET " + rootUrl + "?by=paid_amount");
		info.addByExample("GET " + rootUrl + "?by=ave_won_price.avg");
		info.addByExample("GET " + rootUrl + "?by=ave_won_price.avg|ave_bid_price.avg");
		info.addByExample("GET " + rootUrl + "?select=full_date|exchange&by=ave_won_price.avg");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[full_date]="	+ currentDateExample + "&where[exchange.in]=nexage,mopub");
		info.addWhereExample("GET " + rootUrl + "?select=full_date&by=ave_won_price.avg&where[full_date]="	+ currentDateExample);
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=full_date.desc");
		info.addOrderExample("GET " + rootUrl + "?select=full_date&by=ave_won_price.avg&where[full_date]="	+ currentDateExample + "&order=full_date.desc");
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
