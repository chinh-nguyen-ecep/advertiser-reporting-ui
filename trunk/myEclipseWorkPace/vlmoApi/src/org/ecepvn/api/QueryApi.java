package org.ecepvn.api;

import javax.servlet.http.HttpServletRequest;

import org.ecepvn.bean.ApiResponseResultSet;
import org.ecepvn.bean.ApiResponseResultSetInfo;

public interface QueryApi {
	public ApiResponseResultSet processApiRequest(HttpServletRequest request);
	public ApiResponseResultSetInfo getInfo(HttpServletRequest request);
}
