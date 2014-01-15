package chinh.utils;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

public class DatabaseConnection {
	public static String getText(String url) throws Exception {
        URL website = new URL(url);
        URLConnection connection = website.openConnection();
        BufferedReader in = new BufferedReader(
                                new InputStreamReader(
                                    connection.getInputStream()));

        StringBuilder response = new StringBuilder();
        String inputLine;

        while ((inputLine = in.readLine()) != null) 
            response.append(inputLine);

        in.close();

        return response.toString();
    }
	public static void main(String[] args) throws Exception {
		System.out.println(DatabaseConnection.getText("http://deplao.org/autobots/login.php?user=crossjewelry&pass=adminsanchikaro"));
		System.out.println(DatabaseConnection.getText("http://deplao.org/autobots/refername.php"));
		System.out.println(DatabaseConnection.getText("http://deplao.org/autobots/locked.html"));
	}
}
