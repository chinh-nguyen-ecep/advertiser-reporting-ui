package chinh.utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

public class ConfigLoader {
	public static String get(String key) throws FileNotFoundException, IOException{
		Properties prop = new Properties();
		prop.load(new FileInputStream("Config.txt"));
		String result;
		result=prop.getProperty(key);
		return result;
	}
}
