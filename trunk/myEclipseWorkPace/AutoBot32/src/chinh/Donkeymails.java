package chinh;


import org.watij.webspec.dsl.Tag;
import org.watij.webspec.dsl.WebSpec;

import com.DeathByCaptcha.Captcha;

public class Donkeymails {
	private Captcha myCaptcha;
	private WebSpec spec;
	private int nullCount=0;
	private int totalClickAdd=0;
	private String currentUrl="";
	public Donkeymails() {
		super();
		// TODO Auto-generated constructor stub
		myCaptcha=null;
		spec = new WebSpec().ie();	
		this.login();
    	spec.pauseUntilDone();
    	this.viewAds();
    	System.out.println("Total Click Add: "+this.totalClickAdd);
	}
	private void login(){
		spec.open("http://www.donkeymails.com/pages/enter.php"); 
		spec.pauseUntilReady();
//		spec.find("input").with("name", "username").set("duychinhnguyenvn@gmail.com");
//		spec.find("input").with("name", "password").set("adminsanchikaro");
		spec.pauseUntilDone();
	}
	private void viewAds(){
		spec.open("http://www.donkeymails.com/pages/ptc.php");
		String url;
		
		Tag a=spec.find("a").with("target", "_ptc");
		url=a.get("href");
		if(url==null){
			this.nullCount++;
		}else{
			if(!url.equals(currentUrl)){
				this.currentUrl=url;
				this.totalClickAdd++;
				this.nullCount=0;
			}else{
				System.out.println("Please enter the Captchar.....");
				this.nullCount++;
			}
		}
		System.out.println(url);
		spec.browser(1).open(url);
		spec.browser(0).pause(15000);
		if(this.nullCount>10){
			spec.closeAll();
		}else{
			viewAds();
		}
	}
	public static void main(String[] args) {
		Donkeymails buxTo=new Donkeymails();

	    }
}
