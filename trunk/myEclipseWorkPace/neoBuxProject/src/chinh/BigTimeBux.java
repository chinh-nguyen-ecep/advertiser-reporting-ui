package chinh;


import org.watij.webspec.dsl.WebSpec;

import com.DeathByCaptcha.Captcha;

public class BigTimeBux {
	private Captcha myCaptcha;
	private WebSpec spec;
	
	public BigTimeBux() {
		super();
		// TODO Auto-generated constructor stub
		myCaptcha=null;
		spec = new WebSpec().ie();	
		this.login();
    	int start=15;
    	int end=80;
    	for(int i=start;i<=end;i++){
    		this.viewAds(i);
    	}
    	this.logout();
	}
	private void login(){
			spec.open("http://bigtimebux.com/login.php"); 
			spec.findWithId("login_username").set("chinhnguyen");
			spec.findWithId("pwd").set("adminsanchikaro");
			spec.pauseUntilDone();
	    
	}
	private void logout(){
//		spec.open("http://bigtimebux.com/login.php"); 
	}
	private void viewAds(int adID){
	    spec.open("http://bigtimebux.com/ads.php");
	    spec.pauseUntilReady();
		String url=spec.find("span").with("id", "da"+adID+"c").child("a").get("href");
		spec.open(url);	 
		System.out.println("Waiting for view ads ID:"+adID);
		int processBarWidth=0;
		int j=0;
		while(processBarWidth<200){
			spec.pause(1000);
			try {
				String getexe=spec.execute("parseInt(document.getElementById('progress').style.left)");
				processBarWidth=Integer.parseInt(getexe);
			} catch (java.lang.NumberFormatException e) {
				// TODO: handle exception
				processBarWidth=-1;
			}
			j++;
			System.out.println("Get ProcessBar: "+processBarWidth);
			if(processBarWidth==-1 && j>60){
				break;
			}
			if(processBarWidth==0 && j>180){
				break;
			}
		}
		System.out.println(adID+". Ads loaded");
		spec.pause(5000);
		spec.open("http://bigtimebux.com/ads.php");	 		
	}
	public static void main(String[] args) {
		WebSpec spec=new WebSpec();
		spec.silent_mode(false);
		spec.http_proxy("219.150.204.30");
		spec.http_proxy_port(8080);
		spec.show_navigation_bar(true);
		spec.ie();
		spec.open("http://whatsmyip.net/");
	}
}
