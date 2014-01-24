package buxprojects.utils;

import java.awt.BorderLayout;
import java.awt.FlowLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;

import javax.swing.AbstractAction;
import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;



import com.DeathByCaptcha.AccessDeniedException;
import com.DeathByCaptcha.Captcha;
import com.DeathByCaptcha.Client;
import com.DeathByCaptcha.Exception;
import com.DeathByCaptcha.SocketClient;

public class CheckCaptchar {
	private JFrame captchaFrame;
	private JTextField textField;
	
	public CheckCaptchar() {
		super();
	}
	public static void report(Captcha a){
		Client client = (Client)new SocketClient("chinhbot", "mylove230988");
		try {
			client.report(a);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	public static Captcha getValue(String image){
		Captcha result=null;
		 Client client = (Client)new SocketClient("chinhbot", "mylove230988");
		    try {
		        double balance = client.getBalance();

		        /* Put your CAPTCHA file name, or file object, or arbitrary input stream,
		           or an array of bytes, and optional solving timeout (in seconds) here: */
		        Captcha captcha = client.decode(image, 15);
		        if (null != captcha) {
		            /* The CAPTCHA was solved; captcha.id property holds its numeric ID,
		               and captcha.text holds its text. */
		            System.out.println("CAPTCHA " + captcha.id + " solved: " + captcha.text);
		            result=captcha;
//
//		            if ( /* check if the CAPTCHA was incorrectly solved */) {
//		                client.report(captcha);
//		            }
		        }
		    } catch (AccessDeniedException e) {
		        /* Access to DBC API denied, check your credentials and/or balance */
		    	System.out.println(e.getMessage());
		    } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		return result;
	}

	public static void main(String[] args) {
	}
}
