package buxprojects.neobux;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Container;
import java.awt.Dimension;
import java.awt.FlowLayout;
import java.awt.GridLayout;
import java.text.NumberFormat;
import java.text.ParseException;

import javax.swing.JFrame;
import javax.swing.JPanel;
import javax.swing.border.EmptyBorder;


import buxprojects.utils.ConfigLoader;

import com.jniwrapper.win32.ie.Browser;
import com.jniwrapper.win32.ie.proxy.ProxyConfiguration;

public class NeoBuxBrowser {
	private Browser browser;
	private Browser adsBrowser;
	private String userName="";
	private String password="";
	private String proxy="";
	private int port=0;
	private String activeStatus="NA";
	private String loginUser="N/A";
	private int version=1;	
	
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public void setProxy(String proxy) {
		this.proxy = proxy;
	}
	public void setPort(int port) {
		this.port = port;
	}
	
	private void initUI(){
        JFrame frame = new JFrame("Neobux auto clicker 2014 - Sanbot2");
        Container contentPane = frame.getContentPane();
        contentPane.setLayout(new BorderLayout());
        
        contentPane.add(adsBrowser);
        
        frame.setSize(1200, 800);
        frame.setLocationRelativeTo(null);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        frame.setVisible(true);
	}
	public void init(){
		browser=new Browser();
		adsBrowser=new Browser();
		//init ui
		this.initUI();
        //config proxy
        if(this.proxy.equals("")){
            ProxyConfiguration configuration = browser.getProxy();
            configuration.setConnectionType(ProxyConfiguration.ConnectionType.PROXY);
            configuration.setProxy(this.proxy+":"+this.port, ProxyConfiguration.ServerType.HTTP);
            browser.setProxy(configuration); 
            adsBrowser.setProxy(configuration);
        }
        //Checking the ip
        browser.navigate("http://whatismyipaddress.com/");
        browser.waitReady();
        browser.navigate("https://www.neobux.com/m/l/");
        browser.waitReady();
        adsBrowser.navigate("http://deplao.org");
	}
	public static void main(String[] args) {
		NeoBuxBrowser neoBuxBrowser=new NeoBuxBrowser();
		try {
			String proxy=ConfigLoader.get("proxy");
			String proxyPort=ConfigLoader.get("port");
			int port=8080;
			if(proxyPort.equals("")){
			}else{
				try
				 {
				      NumberFormat.getInstance().parse(proxyPort);
				      port=Integer.parseInt(proxyPort);
				 }
				 catch(ParseException e)
				 {
				     //Not a number.
				 }
			}
			neoBuxBrowser.setUserName(ConfigLoader.get("username"));
			neoBuxBrowser.setPassword(ConfigLoader.get("pass"));
			neoBuxBrowser.setProxy(proxy);
			neoBuxBrowser.setPort(port);	
			neoBuxBrowser.init();
			
		} catch (Exception e) {
			// TODO: handle exception
		}

	}
}
