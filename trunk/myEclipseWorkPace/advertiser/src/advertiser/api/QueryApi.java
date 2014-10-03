package advertiser.api;

import javax.servlet.http.HttpServletRequest;

import advertiser.bean.ApiResponseResultSet;
import advertiser.bean.ApiResponseResultSetInfo;


public interface QueryApi {
	public ApiResponseResultSet processApiRequest(HttpServletRequest request);
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request);
}
