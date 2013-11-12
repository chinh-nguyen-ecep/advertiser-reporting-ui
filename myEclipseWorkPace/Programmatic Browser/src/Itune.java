import java.io.IOException;

import org.xml.sax.SAXException;

import com.meterware.httpunit.Button;
import com.meterware.httpunit.HttpUnitOptions;
import com.meterware.httpunit.SubmitButton;
import com.meterware.httpunit.TableCell;
import com.meterware.httpunit.WebConversation;
import com.meterware.httpunit.WebForm;
import com.meterware.httpunit.WebLink;
import com.meterware.httpunit.WebResponse;
import com.meterware.httpunit.WebTable;
import com.meterware.httpunit.javascript.JavaScript.Form;


public class Itune {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		// Don't through exceptions when JavaScript errors occur
				HttpUnitOptions.setExceptionsThrownOnScriptError(false);
				
				// Here's the browser
				WebConversation wc = new WebConversation();

				try {
					// Login
					WebResponse response = wc.getResponse("https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa");
					
					// Get the link with the text "Contact"
					WebForm form=response.getFormWithName("appleConnectForm");
					form.setParameter("theAccountName", "brent@vervewireless.com");
					form.setParameter("theAccountPW", "Password1");
					
					SubmitButton[] buton=form.getSubmitButtons();
					
					for(int i=0;i<buton.length;i++){
						Button a=buton[i];
					}
					response=form.submit(buton[0]);
					//check login sucess full
					WebLink signoutLink=response.getLinkWith("Sign Out");
					System.out.println(signoutLink.getText());
					if(!signoutLink.getText().equals("Sign Out")){
						System.err.println("Login Faile!");
					}else{
						//login success full
						System.out.println("Login sucess full");
						// Go to https://iad.apple.com/itcportal/#app_homepage
						String pageName="app_homepage";
						String dashboardType="publisher";
						String publisherId="588960";
						String dateRange="customDateRange";
						String fromDate="08/01/13";
						String toDate="08/01/13";
						String dataType="byName";
						String reportUrl="https://iad.apple.com/itcportal/generatecsv?pageName="+pageName+
								"&dashboardType="+dashboardType+"&publisherId="+publisherId+"&dateRange="+dateRange+
								"&searchTerms=Search%20Apps&adminFlag=false&fromDate="+fromDate+"&toDate="+toDate+"&dataType="+dataType;
						System.out.println("Download report with url:\n"+reportUrl);
						response = wc.getResponse(reportUrl);
						System.out.println(response.getText());
					}
					
					
				} catch (IOException e) {
					e.printStackTrace();
				} catch (SAXException e) {
					e.printStackTrace();
				}		
			
	}

}
