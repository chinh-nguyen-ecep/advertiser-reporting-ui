package rtb.core;

import javax.servlet.http.HttpServletRequest;

import rtb.bean.ApiInfo;
import rtb.bean.ApiResponseResultSet;
import rtb.bean.ApiResponseResultSetInfo;

public interface QueryApi {
	public ApiResponseResultSet processApiRequest(HttpServletRequest request);
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request);
	public ApiInfo getApiInfo();
}
