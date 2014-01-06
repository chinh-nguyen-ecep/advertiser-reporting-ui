package chinh;


import org.watij.webspec.dsl.Tag;
import org.watij.webspec.dsl.WebSpec;

import com.DeathByCaptcha.Captcha;

public class BuxTo {
	private Captcha myCaptcha;
	private WebSpec spec;
	
	public BuxTo() {
		super();
		// TODO Auto-generated constructor stub
		myCaptcha=null;
		spec = new WebSpec().ie();	
		this.login();
    	int start=1;
    	int end=33;
    	for(int i=start;i<=end;i++){
    		this.viewAds(i);
    	}
	}
	private void login(){
		spec.open("http://bux.to/login.php"); 
		spec.pauseUntilReady();
		spec.findWithId("name").set("crossjewelry");
		spec.findWithId("email").set("adminsanchikaro");
//		spec.pauseUntilReady();
//		spec.snapBuxToCapChart("capchar.png");
//		myCaptcha=CheckCaptchar.getValue("capchar.png");
//		Tag input=spec.find("input").with("name", "verify");
//	    input.set("value",myCaptcha.text.toUpperCase());
		spec.pauseUntilDone();
	    System.out.println("Login successful");
	}
	private void viewAds(int adID){
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
			System.out.println(adID+". Ads loaded");
			spec.pause(5000);			
		} catch (Exception e) {
			// TODO: handle exception
			viewAds(adID);
		}

	}
	public static void main(String[] args) {
		BuxTo buxTo=new BuxTo();
		

	    }
}
