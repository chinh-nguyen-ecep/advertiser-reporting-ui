package chinh;


import org.watij.webspec.dsl.Tag;
import org.watij.webspec.dsl.WebSpec;

import com.DeathByCaptcha.Captcha;

public class Hello {
	public static void main(String[] args) {
		Captcha myCaptcha=null;
		WebSpec spec = new WebSpec().ie();
//		spec.http_proxy("109.207.61.152");
//		spec.http_proxy_port(8090);
		spec.open("http://bux.to/login.php"); 
		spec.pauseUntilReady();
		spec.findWithId("name").set("chinhnguyen");
		spec.findWithId("email").set("adminsanchikaro");
		
		spec.pauseUntilReady();
		spec.snapCapChart("capchar.png");
		myCaptcha=CheckCaptchar.getValue();
		    
	    Tag input=spec.find("input").with("name", "verify");
	    input.set("value",myCaptcha.text.toUpperCase());
	    spec.findWithId("send").click();
	    String loginUrl="";
	    if(loginUrl.equals("http://bux.to/login.php")){
	    	CheckCaptchar.report(myCaptcha);
	    	System.out.println("Login faile");
	    }else{
	    	System.out.println("Login successful");
	    	int start=18;
	    	int end=26;
	    	for(int i=start;i<=end;i++){
			    spec.open("http://bux.to/ads.php");
			    spec.pauseUntilReady();
				spec.pauseUntilReady();
				String url=spec.find("span").with("id", "da"+i+"c").child("a").get("href");
				spec.open(url);	 
				spec.pauseUntilReady();
				spec.pauseUntilReady(true);
				System.out.println("Waiting for view ads ID:"+i);
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
						processBarWidth=0;
					}
					j++;
					if(processBarWidth==0 && j>120){
						break;
					}
				}
				System.out.println(i+". Ads loaded");
				spec.open("http://bux.to/ads.php");	    		
	    	}

	    }
	    

		
		
	}
}
