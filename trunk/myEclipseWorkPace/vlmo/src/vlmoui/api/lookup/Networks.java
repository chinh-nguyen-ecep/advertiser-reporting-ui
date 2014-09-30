package vlmoui.api.lookup;


import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

import vlmoui.bean.ApiResponseResultSetInfo;
import vlmoui.core.MainApiLookup;
import vlmoui.utils.Configure;


public class Networks extends MainApiLookup{

	public Networks() {
		super();
		// TODO Auto-generated constructor stub
		this.setDataSourceTableName("vlmo_dw.vw_vlmo_dim_networks");
		this.setDefaultDimensions(new String[]{"network_id","title"});
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
		info.addDimension(new String[] { "network_id", "", "integer" });
		info.addDimension(new String[] { "title", "", "string" });
		info.addDimension(new String[] { "account_id", "", "integer" });
		// add measures

		// add constraint
		info.addConstraint(new String[] { "network_id.in", "integer","1,2,3" });
		info.addConstraint(new String[] { "title", "string","Agency" });
		info.addConstraint(new String[] { "account_id.in", "integer", "4,8,9" });

		// add select example
		info.addSelectExample("GET " + rootUrl + "?select=network_id");
		info.addSelectExample("GET " + rootUrl + "?select=network_id|account_id");
		
		// add where example
		//info.addWhereExample("GET " + rootUrl + "?where[created_at]="+ currentDateExample);
		//info.addWhereExample("GET " + rootUrl + "?where[created_at.between]="+ reportDateExample + ".." + currentDateExample);
		info.addWhereExample("GET " + rootUrl + "?where[network_id.in]=1,2,3,4");
		info.addWhereExample("GET " + rootUrl + "?where[title.like]=Agency");
		
		// add order example
		info.addOrderExample("GET " + rootUrl + "?order=network_id.desc");
		info.addOrderExample("GET " + rootUrl + "?order=network_id.desc|account_id");
		return info;
	}

}
