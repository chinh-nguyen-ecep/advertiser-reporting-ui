package rtb.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class Configure {
	public static String getConfig(String param,String defaultValue) {
		String result=null;
		Properties properties = new Properties();
		try {
			properties.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("config.properties"));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		result=properties.getProperty(param,defaultValue);
		return result;
	}
	public static String getConfig(String param) {
		String result=null;
		Properties properties = new Properties();
		try {
			ClassLoader loader = Configure.class.getClassLoader();			
			properties.load(loader.getResourceAsStream("rtb/utils/config.properties"));
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		result=properties.getProperty(param);
		return result;
	}
	public static Properties getProperties(){
		Properties properties = new Properties();
		try {
			ClassLoader loader = Configure.class.getClassLoader();	
			InputStream is=loader.getResourceAsStream("rtb/utils/config.properties");
			properties.load(is);
			is.close();
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return properties;		
	}
}
