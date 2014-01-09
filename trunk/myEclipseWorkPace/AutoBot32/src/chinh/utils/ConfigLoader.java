package chinh.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Writer;
import java.util.Properties;

public class ConfigLoader {
	public static String get(String key) throws IOException{
		Properties prop = new Properties();
		File configFile=new File("Config.txt");
		if(configFile.exists()){
			prop.load(new FileInputStream(configFile));
		}else{
			configFile.createNewFile();
			prop.setProperty("username", "default");
			prop.setProperty("pass", "123");
			prop.setProperty("proxy", "");
			prop.setProperty("port", "");
			prop.store(new FileWriter(configFile), "");
		}
		
		String result;
		result=prop.getProperty(key);
		return result;
	}
	public static void save(String key,String value) throws FileNotFoundException, IOException{
		Properties prop = new Properties();
		File configFile=new File("Config.txt");
		if(configFile.exists()){
				prop.load(new FileInputStream(configFile));
		}else{
			configFile.createNewFile();
		}
		prop.setProperty(key, value);
		prop.store(new FileWriter(configFile), "");
		
	}
	public static void main(String[] args) throws IOException {
		System.out.println(ConfigLoader.get("username"));
		ConfigLoader.save("username", "chinhnguyen");
		System.out.println(ConfigLoader.get("username"));
	}
}
