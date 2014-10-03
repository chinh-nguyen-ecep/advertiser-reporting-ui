package advertiser.utils;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import advertiser.database.JNDIConnection;




import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.JRCsvExporter;
import net.sf.jasperreports.engine.export.JRCsvExporterParameter;
import net.sf.jasperreports.engine.export.JRHtmlExporter;
import net.sf.jasperreports.engine.export.JRHtmlExporterParameter;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.j2ee.servlets.ImageServlet;


public class JasperExporter {

	/**
	 * @param args
	 */
	private String dirPath="";
	private String mainJasperFileName ="";
	private String exportPath="";
	private String exportFormat="pdf";
	private String exportFileName="";
	private String connJNDIString="defaultJNDI";
	private HashMap params=new HashMap();
	
	public JasperExporter() {
		super();
	}

	public void setExportFileName(String exportFileName) {
		this.exportFileName = exportFileName;
	}

	public void setMainJasperFileName(String mainJasperFileName) {
		this.mainJasperFileName = mainJasperFileName;
	}

	public void setParams(HashMap<Object, Object> params) {
		this.params = params;
	}

	@SuppressWarnings("unchecked")
	public void addParams(Object key,Object value) {
		this.params.put(key, value);
	}

	public String getDirPath() {
		return dirPath;
	}

	public void setDirPath(String dirPath) {
		this.dirPath = dirPath;
	}

	public String getMainJasperFileName() {
		return mainJasperFileName;
	}

	public String getExportPath() {
		return exportPath;
	}

	public String getExportFormat() {
		return exportFormat;
	}

	public String getExportFileName() {
		return exportFileName;
	}

	public void setExportPath(String exportPath) {
		this.exportPath = exportPath;
	}

	
	public void setExportFormat(String exportFormat) {
		this.exportFormat = exportFormat;
	}
	
	public void setConnJNDIString(String connJNDIString) {
		this.connJNDIString = connJNDIString;
	}

	private Connection getConnection(){
		return JNDIConnection.getConnection(this.connJNDIString);
	}
	public void reportGenerator () throws IOException, JRException{
		JasperReport jasperReport = null;
		JasperPrint jasperPrint = null;
		// compile jasper report files
		System.setProperty( "jasper.reports.compiler.class", "net.sf.jasperreports.compilers.JRGroovyCompiler" );
		//JasperCompileManager.compileReportToFile( this.dirPath+"//"+this.mainJasperFileName+".jrxml",this.dirPath+"//"+this.mainJasperFileName+".jasper" );
		jasperReport =JasperCompileManager.compileReport(this.dirPath+"//"+this.mainJasperFileName+".jrxml");
		
		//get connection
		Connection conn=this.getConnection();
		
		// Generate jasper print
		
		
		jasperPrint = JasperFillManager.fillReport(jasperReport, this.params, conn);
		
		//Check if export path do not exit
		File file = new File(this.exportPath);
		if(file.exists()){
		    //System.out.println("File Exists");
		}else{
		    boolean wasDirecotyMade = file.mkdirs();
		    if(wasDirecotyMade)System.out.println("Direcoty Created");
		    else System.out.println("Sorry could not create directory");
		}
		
		if(this.exportFileName.equals("")){
			this.exportFileName=this.mainJasperFileName;
		}
		
		// 1 - Export csv
		if(this.exportFormat.toLowerCase().equals("csv")){
			JRCsvExporter exporterCsv=new JRCsvExporter();
			exporterCsv.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporterCsv.setParameter(JRExporterParameter.OUTPUT_FILE_NAME,  this.exportPath+"//"+this.exportFileName+".csv" );	
			exporterCsv.exportReport();
		}

		// 2- export to Excel sheet
		else if(this.exportFormat.toLowerCase().equals("xls")){
			JRXlsExporter exporter = new JRXlsExporter();
			exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME,  this.exportPath+"//"+this.exportFileName+".xls" );
			exporter.exportReport();
		}else{
			// 3- Export pdf file
			JRPdfExporter exporterPdf=new JRPdfExporter();
			exporterPdf.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporterPdf.setParameter(JRExporterParameter.OUTPUT_FILE_NAME,  this.exportPath+"//"+this.exportFileName+".pdf" );	
			exporterPdf.exportReport();
		}
		
		System.out.println("Jasper exported "+this.exportFormat+ " - Done");
		
	}
	
	public byte[] reportGeneratorToByteArray() throws JRException, IOException{
		byte[] result;
		JasperReport jasperReport = null;
		JasperPrint jasperPrint = null;
		this.addParams("SUBREPORT_DIR", this.dirPath+"//");
		// compile jasper report files
		System.setProperty( "jasper.reports.compiler.class", "net.sf.jasperreports.compilers.JRGroovyCompiler" );
		//JasperCompileManager.compileReportToFile( this.dirPath+"//"+this.mainJasperFileName+".jrxml",this.dirPath+"//"+this.mainJasperFileName+".jasper" );
		jasperReport =JasperCompileManager.compileReport(this.dirPath+"//"+this.mainJasperFileName+".jrxml");
		jasperReport.setProperty("net.sf.jasperreports.export.xls.exclude.origin.band.1", "pageHeader");
		jasperReport.setProperty("net.sf.jasperreports.export.xls.exclude.origin.band.2", "pageFooter");
		jasperReport.setProperty("net.sf.jasperreports.export.xls.exclude.origin.band.3", "groupHeader");
		jasperReport.setProperty("net.sf.jasperreports.export.csv.exclude.origin.band.4", "title");
		jasperReport.setProperty("net.sf.jasperreports.export.csv.exclude.origin.band.1", "pageHeader");
		jasperReport.setProperty("net.sf.jasperreports.export.csv.exclude.origin.band.2", "pageFooter");
		jasperReport.setProperty("net.sf.jasperreports.export.csv.exclude.origin.band.3", "groupHeader");
		jasperReport.setProperty("net.sf.jasperreports.export.html.exclude.origin.band.1", "pageHeader");
		jasperReport.setProperty("net.sf.jasperreports.export.html.exclude.origin.band.2", "pageFooter");
		jasperReport.setProperty("net.sf.jasperreports.export.html.exclude.origin.band.3", "groupHeader");
		//get connection
		Connection conn=this.getConnection();
		JRExporter exporter;
		
		if(this.exportFormat.toLowerCase().equals("csv")){
			//csv
			exporter=new JRCsvExporter();
			this.addParams(JRParameter.IS_IGNORE_PAGINATION, true);
		}else if(this.exportFormat.toLowerCase().equals("xls")){
			//xls
			exporter = new JRXlsExporter();
			exporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
			this.addParams(JRParameter.IS_IGNORE_PAGINATION, true);
		}else if(this.exportFormat.toLowerCase().equals("pdf")){
			//pdf
			exporter=new JRPdfExporter();
		}else{
			//html
			exporter = new JRHtmlExporter();
			exporter.setParameter(JRHtmlExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
	        exporter.setParameter(JRHtmlExporterParameter.CHARACTER_ENCODING, "ISO-8859-1");
			exporter.setParameter(JRHtmlExporterParameter.IMAGES_MAP, new HashMap());
			exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "image?image=");
			this.addParams(JRParameter.IS_IGNORE_PAGINATION, true);
		}		
		exporter.setParameter(JRExporterParameter.IGNORE_PAGE_MARGINS,Boolean.TRUE);
		// Generate jasper print
		jasperPrint = JasperFillManager.fillReport(jasperReport, this.params, conn);
		result=exportReportToBytes(jasperPrint, exporter);
		return result;
	}
	public byte[] reportGeneratorHTML(HttpServletRequest request) throws JRException, IOException{
		byte[] result;
		JasperReport jasperReport = null;
		JasperPrint jasperPrint = null;
		this.addParams("SUBREPORT_DIR", this.dirPath+"//");
		// compile jasper report files
		System.setProperty( "jasper.reports.compiler.class", "net.sf.jasperreports.compilers.JRGroovyCompiler" );
		//JasperCompileManager.compileReportToFile( this.dirPath+"//"+this.mainJasperFileName+".jrxml",this.dirPath+"//"+this.mainJasperFileName+".jasper" );
		jasperReport =JasperCompileManager.compileReport(this.dirPath+"//"+this.mainJasperFileName+".jrxml");
		jasperReport.setProperty("net.sf.jasperreports.export.html.exclude.origin.band.1", "pageHeader");
		jasperReport.setProperty("net.sf.jasperreports.export.html.exclude.origin.band.2", "pageFooter");
		jasperReport.setProperty("net.sf.jasperreports.export.html.exclude.origin.band.3", "groupHeader");
		//get connection
		Connection conn=this.getConnection();
		JRExporter exporter;

			//html
			exporter = new JRHtmlExporter();
			exporter.setParameter(JRHtmlExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
	        exporter.setParameter(JRHtmlExporterParameter.CHARACTER_ENCODING, "ISO-8859-1");
			exporter.setParameter(JRHtmlExporterParameter.IMAGES_MAP, new HashMap());
			exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "image?image=");
			this.addParams(JRParameter.IS_IGNORE_PAGINATION, true);
		exporter.setParameter(JRExporterParameter.IGNORE_PAGE_MARGINS,Boolean.TRUE);
		// Generate jasper print
		jasperPrint = JasperFillManager.fillReport(jasperReport, this.params, conn);
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE,jasperPrint);
		result=exportReportToBytes(jasperPrint, exporter);
		return result;
	}
    /**
     * Run a Jasper report to CSV format and put the results in a byte array
     * @param jasperPrint The Print object to render as CSV
     * @param exporter The exporter to use to export the report
     * @return A CSV formatted report
     * @throws JRException If there is a problem running the report
     */
    private byte[] exportReportToBytes(JasperPrint jasperPrint, JRExporter exporter) throws JRException {
        byte[] output;
        ByteArrayOutputStream  baos = new ByteArrayOutputStream();

        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, baos);
        exporter.exportReport();

        output = baos.toByteArray();
        return output;
    }
	public static void main(String[] args) throws IOException, JRException {
		// TODO Auto-generated method stub
		JasperExporter jasper=new JasperExporter();		
		jasper.setDirPath("D:\\Ecep\\Document-Tailieu\\Pentaho\\biserver-ce-3.5\\pentaho-solutions\\Adcel reports\\jaspers\\daily_ad_serving_statistics_summary");
		jasper.setMainJasperFileName("daily_ad_serving_statistics_summary");
		jasper.setExportPath("D:\\testReport");
		jasper.addParams("eastern_date_sk", "3080");
		jasper.setExportFormat("xls");
		jasper.setExportFileName("daily_ad_serving_statistics_summary.2013-06-09");
		
		jasper.reportGenerator();
		
	}

}
