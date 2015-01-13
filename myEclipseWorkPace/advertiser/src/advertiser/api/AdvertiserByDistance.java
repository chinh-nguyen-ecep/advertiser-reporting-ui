package advertiser.api;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import advertiser.bean.ApiResponseResultSetInfo;
import advertiser.utils.Configure;

public class AdvertiserByDistance extends MainApi {
	public AdvertiserByDistance() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("agg_creatives_by_distance");
		this.setDefaultDimensions(new String[]{"date"});
		this.setDefaultMeasures(new String[]{"clicks","impressions","cta_maps"});
	}
	@Override
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request) {
		ApiResponseResultSetInfo info = new ApiResponseResultSetInfo();
		String hosting=Configure.getConfig("hosting");
		String appName=Configure.getConfig("appName");
		String apiUrl = Configure.getConfig("advertiserByDistanceAPIUrl");
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
		info.addDimension(new String[] { "period", "", "int" });
		info.addDimension(new String[] { "date", "", "date" });
		info.addDimension(new String[] { "distance", "", "VarChar(255)" });
		info.addDimension(new String[] { "flight_id", "", "integer" });
		info.addDimension(new String[] { "creative_id", "", "integer" });

		// add measures
		info.addMeasures(new String[] { "clicks", "", "integer"});
		info.addMeasures(new String[] { "impressions", "", "integer" });
		info.addMeasures(new String[] { "cta_maps", "", "integer" });

		// add constraint
		info.addConstraint(new String[] { "period.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "date", "date",currentDateExample });
		info.addConstraint(new String[] { "date.between", "date",reportDateExample + ".." + currentDateExample });
		info.addConstraint(new String[] { "distance.in", "VarChar(255)","00-01m,01-02m,02-03m" });
		info.addConstraint(new String[] { "flight_id.in", "integer", "4,8,9" });
		info.addConstraint(new String[] { "creative_id.in", "integer", "3,7,2" });

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=date");
		info.addSelectExample("GET " + rootUrl + "?select=date|distance|flight_id");
		// add by example
		info.addByExample("GET " + rootUrl + "?by=clicks");
		info.addByExample("GET " + rootUrl + "?by=clicks|impressions");
		// add where example
		info.addWhereExample("GET " + rootUrl + "?where[date]="+ currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[date.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[distance.in]=00-01m,01-02m,02-03m");
		info.addWhereExample("GET " + rootUrl + "?where[date]="	+ currentDateExample + "&where[distance.in]=00-01m,01-02m,02-03m");
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=date.desc");
		info.addOrderExample("GET " + rootUrl + "?order=date.desc|distance");
		return info;
	}

}