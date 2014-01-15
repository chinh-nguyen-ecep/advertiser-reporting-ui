package chinh.utils;

import org.watij.webspec.dsl.WebSpec;

public class ProxyBrowser {
	private WebSpec spec;
	private String ipProxy=null;
	private String typeProxy="HTTP";
	private String proxyUserName="";
	private String proxyPassword="";
	private int port=80;
	
	
public void setIpProxy(String ipProxy) {
		this.ipProxy = ipProxy;
	}


	public void setProxyUserName(String proxyUserName) {
		this.proxyUserName = proxyUserName;
	}


	public void setProxyPassword(String proxyPassword) {
		this.proxyPassword = proxyPassword;
	}


	public void setPort(int port) {
		this.port = port;
	}


public ProxyBrowser() {
		super();
		// TODO Auto-generated constructor stub
		
		spec=new WebSpec();
		
	}

public void open(){
	if(ipProxy!=null){
		WebSpec.http_proxy=ipProxy;
		WebSpec.http_proxy_port=port;
	}
	spec.open("http://google.com");
};


public static void main(String[] args) {
	ProxyBrowser a =new ProxyBrowser();
	a.setIpProxy("180.180.121.245");
	a.setPort(8080);
	
	a.open();
}
}
