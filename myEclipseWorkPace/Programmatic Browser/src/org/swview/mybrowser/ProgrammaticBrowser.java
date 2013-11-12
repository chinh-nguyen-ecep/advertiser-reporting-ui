package org.swview.mybrowser;

import java.io.IOException;

import org.xml.sax.SAXException;

import com.meterware.httpunit.HttpUnitOptions;
import com.meterware.httpunit.TableCell;
import com.meterware.httpunit.WebConversation;
import com.meterware.httpunit.WebLink;
import com.meterware.httpunit.WebResponse;
import com.meterware.httpunit.WebTable;

public class ProgrammaticBrowser {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// Don't through exceptions when JavaScript errors occur
		HttpUnitOptions.setExceptionsThrownOnScriptError(false);
		
		// Here's the browser
		WebConversation wc = new WebConversation();

		try {
			// Fetch a page
			WebResponse response = wc.getResponse("http://www.swview.org/");
			
			// Get the link with the text "Contact"
			WebLink link = response.getLinkWith("Contact");
			
			// Click on the link and get the next response
			response = link.click();
			
			// Get all tables
			WebTable[] tables = response.getTables();
			
			// Get the first table
			WebTable firstTable = tables[0];
			
			TableCell emailCell = firstTable.getTableCell(0, 1);
			
			// Print the content as text
			System.out.println(emailCell.getText());
			
		} catch (IOException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		}		
	}
}
