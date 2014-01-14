package chinh.gui;

import java.io.IOException;
import java.text.NumberFormat;
import java.text.ParseException;

import org.watij.webspec.dsl.Tag;
import org.watij.webspec.dsl.WebSpec;

import chinh.utils.ConfigLoader;

public class BuxToRegister {
	public static void main(String[] args) throws IOException {
		WebSpec spec=new WebSpec();
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
		//load referralName from server
		String referralName="chinhnguyen";
		try {
			spec.open("http://whatismyipaddress.com");
			spec.pause(5000);
			spec.open("http://bux.to/register.php");
			spec.pauseUntilReady();
			spec.findWithId("username").set(ConfigLoader.get("username"));
			spec.findWithId("password").set(ConfigLoader.get("pass"));
			spec.findWithId("cpassword").set(ConfigLoader.get("pass"));
			spec.findWithId("email").set(ConfigLoader.get("email"));
			spec.findWithId("alertpay").set(ConfigLoader.get("email"));
			Tag referral=spec.findWithId("referral");
			referral.set(referralName);
			spec.eval("document.getElementById(\"referral\").style.display=\'none\'");
			spec.pauseUntilDone();			
		} catch (Exception e) {
			// TODO: handle exception
			System.err.println(e.getMessage());
		}

		spec.closeAll();
		System.exit(0);
	}
}
