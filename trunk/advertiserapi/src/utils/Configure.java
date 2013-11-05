package utils;

import java.io.IOException;
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
			properties.load(loader.getResourceAsStream("utils/config.properties"));
			
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		result=properties.getProperty(param);
		return result;
	}
}
