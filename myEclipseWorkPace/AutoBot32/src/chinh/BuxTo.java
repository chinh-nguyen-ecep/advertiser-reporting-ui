package chinh;


import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Random;




import org.watij.webspec.dsl.WebSpec;

import chinh.utils.CheckCaptchar;
import chinh.utils.ConfigLoader;
//import com.DeathByCaptcha.Captcha;

public class BuxTo {
//	private Captcha myCaptcha;
	private WebSpec spec;
	private boolean loginSuccess=false;
	private String userName="";
	private String password="";
	private String proxy="";
	private int port=0;
	
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public void setProxy(String proxy) {
		this.proxy = proxy;
	}
	public void setPort(int port) {
		this.port = port;
	}
	public BuxTo() {
		super();
		// TODO Auto-generated constructor stub
	}


	public void initConfig() throws FileNotFoundException, IOException{
		spec=new WebSpec();
		if(!proxy.equals("")){
			spec.http_proxy(proxy);
			spec.http_proxy_port(port);	
		}
		saveConfig();
		spec.ie();		
	}
	private void saveConfig() throws FileNotFoundException, IOException{
		ConfigLoader.save("username", userName);
		ConfigLoader.save("pass", password);
		ConfigLoader.save("proxy", proxy);
		ConfigLoader.save("port", ""+port);
		
	}
	public void login() throws FileNotFoundException, IOException{
		initConfig();
		spec.open("http://whatismyipaddress.com/"); 
		spec.pauseUntilDone();
		try {
			spec.open("http://bux.to/login.php"); 
			spec.pauseUntilReady();
//			spec.findWithId("name").set("disabled","true");
//			spec.findWithId("email").set("disabled","true");
			spec.findWithId("name").set("value",userName);
			spec.findWithId("email").set("value",password);
//			spec.snapBuxToCapChart("capchar.png");
//			CheckCaptchar captchartChecker=new CheckCaptchar(spec);
//			captchartChecker.getCaptchaManual("capchar.png");
//			spec.findWithId("send").click(true);
			spec.pauseUntilDone();
			String urlAfterLogin=spec.url();
			if(urlAfterLogin.equals("http://bux.to/login.php")){
				System.err.println("Login Failed");
				login();			
			}else{
				loginSuccess=true;
				System.out.println("Login successful");
				spec.show();
				viewAds();
				spec.open("http://bux.to/ads.php");
				logout();			
			}			
		} catch (Exception e) {
			// TODO: handle exception
			System.err.println(e.getMessage());
		}

	}
	private void viewAds(){
		spec.open("http://bux.to/ads.php");
		spec.pauseUntilReady();
		int start=1;
		int end=1;
		try {
			start=Integer.parseInt(spec.execute("$('s').length"))+1;
			end=Integer.parseInt(spec.execute("$('a[href^=cks.php]').length"));
		} catch (Exception e) {
			// TODO: handle exception
			System.err.println(e.getMessage());
			spec.pause(5000);
			viewAds();
		}
		System.out.println("View ads from : "+start+" to "+end);
		ArrayList<Integer> list=new ArrayList<Integer>();
		for(int i=start;i<=end;i++){
			list.add(i);
		}
//		Collections.shuffle(list);
		for(int i=0;i<list.size();i++){
			viewAd(list.get(i));
		}
	}
	private void viewAd(int adID){
		try {
		    spec.open("http://bux.to/ads.php");
		    spec.pauseUntilReady();
			String url=spec.find("span").with("id", "da"+adID+"c").child("a").get("href");
			spec.open(url);	 
			spec.pauseUntilReady();
			System.out.println("Waiting for view ads ID:"+adID);
			int processBarWidth=0;
			int j=0;
			while(processBarWidth<120){
				spec.pause(1000);
				try {
					String getexe=spec.execute("document.getElementById('progress').offsetWidth");
					System.out.println("Get ProcessBar: "+getexe);
					processBarWidth=Integer.parseInt(getexe);
				} catch (java.lang.NumberFormatException e) {
					// TODO: handle exception
					processBarWidth=-1;
				}
				j++;
				if(processBarWidth==-1 && j>60){
					break;
				}
				if(processBarWidth==0 && j>180){
					break;
				}
			}
			
			Random rand = new Random(); 
			int pickedNumber = rand.nextInt(3000) + 5000; 
			System.out.println(adID+" - Ads loaded "+pickedNumber);
			spec.pause(pickedNumber);			
			
		} catch (Exception e) {
			// TODO: handle exception
			System.err.println(e.getMessage());
			spec.pause(2000);
			viewAd(adID);
		}

	}
	
	public boolean isLoginSuccess() {
		return loginSuccess;
	}
	public void logout(){
		spec.open("http://bux.to/logout.php");
		spec.pauseUntilReady();
		spec.closeAll();
		System.exit(0);
	}
	  // Implementing Fisher–Yates shuffle
	  static void shuffleArray(int[] ar)
	  {
	    Random rnd = new Random();
	    for (int i = ar.length - 1; i > 0; i--)
	    {
	      int index = rnd.nextInt(i + 1);
	      // Simple swap
	      int a = ar[index];
	      ar[index] = ar[i];
	      ar[i] = a;
	    }
	  }
	public static void main(String[] args) throws IOException {
			BuxTo buxTo=new BuxTo();
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
				buxTo.setUserName(ConfigLoader.get("username"));
				buxTo.setPassword(ConfigLoader.get("pass"));
				buxTo.setProxy(proxy);
				buxTo.setPort(port);
				try {
					buxTo.saveConfig();
				} catch (FileNotFoundException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				buxTo.login();
	    }
}
