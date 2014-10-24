package vlmo.core;

import javax.servlet.http.HttpServletRequest;

import vlmo.bean.ApiResponseResultSet;
import vlmo.bean.ApiResponseResultSetInfo;

public interface QueryApi {
	public ApiResponseResultSet processApiRequest(HttpServletRequest request);
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request);
}
