package chinh.utils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.SocketAddress;
import java.net.URL;
import java.net.URLConnection;


public class ProxyMat{

public static boolean checkproxies(String ip,int port){
	boolean result=false;
	try{
		SocketAddress addr = new InetSocketAddress(ip, 8080);
		Proxy proxy = new Proxy(Proxy.Type.HTTP, addr);
		URL url = new URL("http://google.com");
		URLConnection conn = url.openConnection(proxy);
		System.out.println(conn.getContentType());
		result= true;
		
    }catch(Exception ex){
    	ex.printStackTrace();
    }
	return result;
}


public static void main(String[] args){
    System.out.println(ProxyMat.checkproxies("65.182.107.32", 3128));
}
}
