package chinh;


import org.watij.webspec.dsl.Tag;
import org.watij.webspec.dsl.WebSpec;

import com.DeathByCaptcha.Captcha;
import com.jniwrapper.win32.ie.br;
import com.sun.org.apache.bcel.internal.generic.ACONST_NULL;

public class BigTimeBux {
	private Captcha myCaptcha;
	private WebSpec spec;
	
	public BigTimeBux() {
		super();
		// TODO Auto-generated constructor stub
		myCaptcha=null;
		spec = new WebSpec().ie();	
		this.login();
    	int start=1;
    	int end=9;
    	for(int i=start;i<=end;i++){
//    		this.viewAds(i);
    	}
    	this.logout();
	}
	private void login(){
			spec.open("http://bigtimebux.com/login.php"); 
			spec.findWithId("login_username").set("chinhnguyen");
			spec.findWithId("pwd").set("adminsanchikaro");
			spec.snapBigtimebuxCapChart("capcharBig.png");
			myCaptcha=CheckCaptchar.getValue("capcharBig.png");
			Tag input=spec.findWithId("captcha");
		    input.set("value",myCaptcha.text.toUpperCase());
		    spec.find("input").with("name","Login2").click();
		    //check is loging success
		    System.out.println("Checking login");
		    spec.pauseUntilReady();
		    String accountText=spec.execute("document.getElementsByClassName('active')[0].innerHTML");
		    System.out.println(accountText+" dsfsdfs");
		    int i=0;
		    while(true){
		    	spec.pause(1000);
		    	i++;
		    	accountText=spec.findWithId("navigation").find("a").with("href", "acc.php").get("innerHTML");
		    	System.out.println(" Account text:"+accountText.toLowerCase());
		    	if(accountText.toLowerCase().equals("account")){
		    		break;
		    	}else{
		    		if(i>10){
			    		break;
			    	}
		    	}
		    	
		    }
		    if(accountText.toLowerCase().equals("account")){
		    	System.out.println("Login successful");
		    }else{
//		    	this.login();
		    }
	    
	}
	private void logout(){
//		spec.open("http://bigtimebux.com/login.php"); 
	}
	private void viewAds(int adID){
	    spec.open("http://bigtimebux.com/ads.php");
	    spec.pauseUntilReady();
		String url=spec.find("span").with("id", "da"+adID+"c").child("a").get("href");
		spec.open(url);	 
		spec.pauseUntilReady();
		System.out.println("Waiting for view ads ID:"+adID);
		int processBarWidth=0;
		int j=0;
		while(processBarWidth<200){
			spec.pause(1000);
			try {
				String getexe=spec.execute("parseInt(document.getElementById('progress').style.left)");
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
		spec.open("http://bigtimebux.com/ads.php");	 		
	}
	public static void main(String[] args) {
		BigTimeBux buxTo=new BigTimeBux();
		

	    }
}
