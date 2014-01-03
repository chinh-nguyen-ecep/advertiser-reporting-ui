package chinh;


import java.util.ArrayList;

import org.watij.webspec.dsl.All;
import org.watij.webspec.dsl.Tag;
import org.watij.webspec.dsl.WebSpec;

import com.DeathByCaptcha.Captcha;

public class Donkeymails {
	private Captcha myCaptcha;
	private WebSpec spec;
	private int nullCount=0;
	private ArrayList<String> urlsClicked=new ArrayList<String>();
	private int error=0;
	public Donkeymails() {
		super();
		// TODO Auto-generated constructor stub
		myCaptcha=null;
		spec = new WebSpec().ie();	
		this.login();
    	spec.pauseUntilDone();
    	this.viewAds();
    	System.out.println("Total Click Add: "+this.urlsClicked.size());
    	System.out.println("Total Click error: "+this.error);
    	System.out.println("Total Click null: "+this.nullCount);
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
		
		url=this.findTrueUrl();
		if(url==null){
			this.nullCount++;
		}else{
			if(urlsClicked.indexOf(url)<0){
				urlsClicked.add(url);
				this.nullCount=0;
			}else{
				System.out.println("Please enter the Captchar.....");
				this.error++;
			}
		}
		System.out.println(url);
		if(url.equals("http://www.donkeymails.com/pages/advertise.php")){
			
		}else{
			spec.browser(1).open(url);
		}
		
		spec.browser(0).pause(15000);
		if(this.nullCount>10){
			spec.closeAll();
		}if(this.error>2){
			spec.closeAll();
		}else{
			viewAds();
		}
	}
	
	private String findTrueUrl(){
		String url="";
		Tag a=spec.find("a").with("target", "_ptc");
		url=a.get("href");
		if(url==null){
			url="http://www.donkeymails.com/pages/ptc.php";
		}if(url.equals("http://www.donkeymails.com/pages/advertise.php")){
			a=spec.find("a").with("target", "_ptc").at(3);
			url=a.get("href");
			if(url==null){
				url="http://www.donkeymails.com/pages/ptc.php";
			}
		}else{
			
		}

		return url;
	}
	public static void main(String[] args) {
		Donkeymails buxTo=new Donkeymails();

	    }
}
