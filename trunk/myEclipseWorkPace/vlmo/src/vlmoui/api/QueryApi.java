package vlmoui.api;

import javax.servlet.http.HttpServletRequest;

import vlmoui.bean.ApiResponseResultSet;
import vlmoui.bean.ApiResponseResultSetInfo;

public interface QueryApi {
	public ApiResponseResultSet processApiRequest(HttpServletRequest request);
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request);
}
