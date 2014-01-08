package chinh;


import org.watij.webspec.dsl.WebSpec;

import chinh.gui.MainWindow;

import com.DeathByCaptcha.Captcha;

public class BuxTo {
	private Captcha myCaptcha;
	private WebSpec spec;
	
	public BuxTo(String proxy,int port) {
		super();
		// TODO Auto-generated constructor stub
		spec=new WebSpec();
		spec.silent_mode(false);
		if(proxy!=null || !proxy.equals("")){
			spec.http_proxy(proxy);
			spec.http_proxy_port(port);			
		}
		spec.show_navigation_bar(false);
		spec.ie();
//		spec.hide();
//		initUI();
//		login();
	}
	public void show(){
		spec.show();
	}
	public void hide(){
		spec.hide();
	}
	
	public boolean login(String userName,String pass){
		boolean result=false;
		spec.open("http://bux.to/login.php"); 
		spec.pauseUntilReady();
		spec.findWithId("name").set(userName);
		spec.findWithId("email").set(pass);
//		spec.pauseUntilReady();
//		spec.snapBuxToCapChart("capchar.png");
//		myCaptcha=CheckCaptchar.getValue("capchar.png");
//		Tag input=spec.find("input").with("name", "verify");
//	    input.set("value",myCaptcha.text.toUpperCase());
		spec.pauseUntilDone();
	    System.out.println("Login successful");
	    return result;
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
	
	public final void initUI(){
		MainWindow main=new MainWindow();
		
	}
	public static void main(String[] args) {
		
	    }
}
