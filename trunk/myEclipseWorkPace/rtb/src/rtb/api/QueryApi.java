package rtb.api;

import javax.servlet.http.HttpServletRequest;

import rtb.bean.ApiResponseResultSet;
import rtb.bean.ApiResponseResultSetInfo;

public interface QueryApi {
	public ApiResponseResultSet processApiRequest(HttpServletRequest request);
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request);
}
