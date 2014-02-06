package buxprojects.neobux;

import java.text.NumberFormat;
import java.text.ParseException;












import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.w3c.dom.html.HTMLElement;

import com.jniwrapper.win32.ie.dom.DOMUtils;
import com.sun.org.apache.bcel.internal.generic.ALOAD;

import buxprojects.abstractClass.MainBux;
import buxprojects.utils.ConfigLoader;


public class NeoBuxBrowser extends MainBux{

	public void login(){
		browser.navigate("https://www.neobux.com/m/l/");
		browser.waitReady();
		//check user logined or no login
		System.out.println("Checking login");
		HTMLElement a_login=(HTMLElement) browser.getDocument().getElementById("t_conta");
		System.out.println(a_login);
		if(a_login==null){
			//get login form
			Element userNameInput=(Element) browser.getDocument().getElementsByTagName("input").item(1);
			userNameInput.setAttribute("value", userName);
			Element passwordInput=(Element) browser.getDocument().getElementsByTagName("input").item(2);
			passwordInput.setAttribute("value", password);			
			HTMLElement submit=(HTMLElement) browser.getDocument().getElementById("botao_login");
			DOMUtils.click(submit);
			browser.waitReady();
			int wait=10;
			while(a_login==null && wait>0){
				wait--;
				browser.pause(2000);
				a_login=(HTMLElement) browser.getDocument().getElementById("t_conta");
				System.out.println(wait);
			}
		}
		
		if(a_login==null){
			this.showMessageDialog("Login Fail");
			this.close();
		}else{
			System.out.println("Login Successful...");
		}
		

	}
	public static void main(String[] args) {
		MainBux.clearCache();
		NeoBuxBrowser neoBuxBrowser=new NeoBuxBrowser();
		try {
			String proxy=ConfigLoader.get("proxy");
			String proxyPort=ConfigLoader.get("port");
			int port=8080;
			if(proxyPort.equals("")){
			}else{
				try
				 {
				      NumberFormat.getInstance().parse(proxyPort);
				      port=Integer.parseInt(proxyPort);
				 }
				 catch(ParseException e)
				 {
				     //Not a number.
				 }
			}
			neoBuxBrowser.setUserName("chinhnguyenvn");
			neoBuxBrowser.setPassword("adminsanchikaro");
			neoBuxBrowser.init();
			neoBuxBrowser.login();
			neoBuxBrowser.viewAds();
			neoBuxBrowser.logout();
			neoBuxBrowser.close();
		} catch (Exception e) {
			// TODO: handle exception
		}

	}
	@Override
	public void logout() {
		// TODO Auto-generated method stub
		browser.navigate("http://www.neobux.com");
		browser.waitReady();
		HTMLElement a_login=(HTMLElement) browser.getDocument().getElementById("t_conta");
		DOMUtils.click(a_login);
	}
	@Override
	public void viewAds() {
		// TODO Auto-generated method stub
		
	}
}
