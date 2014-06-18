package advertiserui.servlets;

import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import advertiserui.utils.JasperExporter;

import net.sf.jasperreports.engine.JRException;


/**
 * Servlet implementation class GenerateJasperReport
 */
public class GenerateJasperReport extends HttpServlet {
	private static final long serialVersionUID = 1L;

    /**
     * Default constructor. 
     */
    public GenerateJasperReport() {
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String rootPath=getServletContext().getRealPath("jasperReports");
		String path=request.getParameter("path");
		String jrxml_file_name=request.getParameter("jrxml");
		String export_type=request.getParameter("export_type");
		if(export_type==null){
			export_type="html";
		}
		JasperExporter jasper=new JasperExporter();	
		jasper.setConnJNDIString("verveReportConnection");
		jasper.setDirPath(rootPath+"/"+path);
		jasper.setMainJasperFileName(jrxml_file_name);
		
		//add parameter
		@SuppressWarnings("unchecked")
		Map<String, String[]> parameters = request.getParameterMap();
		for (Map.Entry<String, String[]> entry : parameters.entrySet()) {
			jasper.addParams(entry.getKey(), entry.getValue()[0]);
		}
		
		jasper.setExportFormat(export_type);
		
		try {
			byte[] output;
			
			if(export_type.equals("html")){
				output=jasper.reportGeneratorHTML(request);
				response.setContentType("text/html");
				response.setHeader("Content-disposition", "inline");
			}else{
				output=jasper.reportGeneratorToByteArray();
				response.setContentType("application/"+export_type);
				response.setHeader("Content-Disposition", "attachment; filename=\""+jrxml_file_name+"."+export_type+"\"");
			}
			response.setContentLength(output.length);
			ServletOutputStream ouputStream;
			ouputStream = response.getOutputStream();
			ouputStream.write(output);
			ouputStream.flush();
			ouputStream.close();
		} catch (JRException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			response.getWriter().write(e.getMessage());
			response.getWriter().flush();
			response.getWriter().close();
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

}
