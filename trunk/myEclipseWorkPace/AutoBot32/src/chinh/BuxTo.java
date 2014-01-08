package chinh;


import org.watij.webspec.dsl.Tag;
import org.watij.webspec.dsl.WebSpec;

import chinh.gui.MainWindow;
import chinh.utils.CheckCaptchar;

import com.DeathByCaptcha.Captcha;
import com.jniwrapper.win32.bu;

public class BuxTo {
	private Captcha myCaptcha;
	private WebSpec spec;
	private int startAds=1;
	private int maxAds=1;
	private boolean loginSuccess=false;
	public BuxTo(String proxy,int port) {
		super();
		// TODO Auto-generated constructor stub
		spec=new WebSpec();
		spec.silent_mode(false);
		if(proxy==null ){
			
		}else if(proxy.equals("")){
			
		}else{
			spec.http_proxy(proxy);
			spec.http_proxy_port(port);
		}
		spec.show_navigation_bar(true);
		spec.ie();
//		spec.hide();
//		initUI();
		login("chinhnguyen","adminsanchikaro");
//		int start=1;
//		int end=32;
//		for(int i=start;i<=end;i++){
//			viewAds(i);
//		}
	}
	public void show(){
		spec.show();
	}
	public void hide(){
		spec.hide();
	}
	
	public void login(String userName,String pass){
		spec.open("http://bux.to/login.php"); 
		spec.pauseUntilReady();
		spec.findWithId("name").set(userName);
		spec.findWithId("email").set(pass);
		spec.snapBuxToCapChart("capchar.png");
		CheckCaptchar.getCaptchaManual("capchar.png",spec);
		spec.findWithId("send").click(true);
		String urlAfterLogin=spec.url();
		if(urlAfterLogin.equals("http://bux.to/login.php")){
			System.err.println("Login Failed");
			login(userName,pass);			
		}else{
			loginSuccess=true;
			System.out.println("Login successful");
			logout();			
		}
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
			System.err.println(e.getMessage());
			spec.pause(2000);
			viewAds(adID);
		}

	}
	
	public boolean isLoginSuccess() {
		return loginSuccess;
	}
	public void logout(){
		spec.open("http://bux.to/logout.php");
		spec.pauseUntilReady();
		System.exit(0);
	}
	public final void initUI(){
		MainWindow main=new MainWindow();
		
	}
	public static void main(String[] args) {
			BuxTo buxTo=new BuxTo("", 0);
			buxTo.login("chinhnguyen", "adminsanchikaro");
	    }
}
