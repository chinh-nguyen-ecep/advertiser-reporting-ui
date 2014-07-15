package vlmoui.core;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.NamingException;




import database.JNDIConnection;

public class ConnectionJNDI {

	/**
	 * @param args
	 * @throws SQLException 
	 * @throws NamingException 
	 * @throws IOException 
	 */
	
	public static Connection getConnection() {
		Connection result=null;
	
			result=JNDIConnection.getConnection("verveReportConnection");
		
		return result;
	}
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
