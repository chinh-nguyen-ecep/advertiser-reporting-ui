package chinh.gui;

import java.io.IOException;
import java.text.NumberFormat;
import java.text.ParseException;

import org.watij.webspec.dsl.Tag;
import org.watij.webspec.dsl.WebSpec;

import chinh.utils.ConfigLoader;
import chinh.utils.DatabaseConnection;

public class BuxToRegister {
	private WebSpec spec=new WebSpec();
	
	public BuxToRegister() throws IOException {
		super();
		config();
	}
	private void config() throws IOException{
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
		if(!proxy.equals("")){
			spec.http_proxy(proxy);
			spec.http_proxy_port(port);	
		}
		spec.ie();
	}
	public void register() throws IOException{
		//load referralName from server
		String referralName="chinhnguyen";

		try {
			spec.open("http://whatismyipaddress.com");
			spec.pause(5000);
			spec.open("http://bux.to/register.php");
			spec.pauseUntilReady();
			String userName=ConfigLoader.get("username");
			String pass=ConfigLoader.get("pass");
			String email=ConfigLoader.get("email");
			String referralNameCF=ConfigLoader.get("referral");
			if(userName.equals("")||pass.equals("")||email.equals("")){
				spec.find("body").set("innerHTML", "<div style=\"margin: 20px;\">Please set Username,Password and Email values in Config.txt first! Then try again...</div>");
				spec.pause(10000);
			}else{
				spec.findWithId("username").set(userName);
				spec.findWithId("password").set(pass);
				spec.findWithId("cpassword").set(pass);
				spec.findWithId("email").set(email);
				spec.findWithId("alertpay").set(email);
				spec.findWithId("referral").set(referralNameCF);
				Tag submitButton=spec.find("input").at(8);			
				spec.eval("document.getElementsByTagName('input')[8].style.display=\'none\'");//hide submit button
				
				spec.pauseUntilDone();
				spec.eval("document.getElementById(\"referral\").style.display=\'none\'");
				try {
					referralName=DatabaseConnection.getText("http://deplao.org/autobots/refername.php");
				} catch (Exception e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				Tag referral=spec.findWithId("referral");
				if(referral.get("value")==null){
					referral.set(referralName);					
				}else{
					ConfigLoader.save("referral", referral.get("value"));
				}
				System.out.println(referral.get("value"));
				submitButton.click(true);
				spec.pause(5000);
			}
			spec.closeAll();
			System.exit(0);
		} catch (Exception e) {
			// TODO: handle exception
			System.err.println(e.getMessage());
			register();
		}		
	}
	public static void main(String[] args) throws IOException {
		BuxToRegister buxToRegister=new BuxToRegister();
		buxToRegister.register();
	}
}
