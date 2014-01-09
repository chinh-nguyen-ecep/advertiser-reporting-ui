package chinh.utils;

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

import org.watij.webspec.dsl.Tag;
import org.watij.webspec.dsl.WebSpec;

import com.DeathByCaptcha.AccessDeniedException;
import com.DeathByCaptcha.Captcha;
import com.DeathByCaptcha.Client;
import com.DeathByCaptcha.Exception;
import com.DeathByCaptcha.SocketClient;

public class CheckCaptchar {
	private JFrame captchaFrame;
	private WebSpec spec;
	private JTextField textField;
	
	public CheckCaptchar(WebSpec spec) {
		super();
		this.spec = spec;
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
	public void getCaptchaManual(String image){
		captchaFrame=new JFrame("Enter Captcha");
		JButton enterCaptcha=new JButton("Enter");
		JButton exit=new JButton("Exit");
		ImageIcon icon = new ImageIcon(image);
		JLabel label = new JLabel(icon);
		textField=new JTextField(10);
		JPanel mainJPanel=new JPanel();
		mainJPanel.setLayout(new FlowLayout());
		mainJPanel.add(label);
		mainJPanel.add(textField);
		mainJPanel.add(enterCaptcha);
		mainJPanel.add(exit);
		exit.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent arg0) {
				// TODO Auto-generated method stub
				System.exit(0);
			}
		});
		captchaFrame.getContentPane().add(BorderLayout.CENTER,mainJPanel);
        AbstractAction enterKey = new AbstractAction() {
            @Override
            public void actionPerformed(ActionEvent e) {
            	Tag input=spec.find("input").with("name", "verify");
			    input.set("value",textField.getText());
				captchaFrame.setVisible(false);
				spec.setDone(true);
            }
        };
		enterCaptcha.addActionListener(enterKey);
		enterCaptcha.getInputMap(javax.swing.JComponent.WHEN_IN_FOCUSED_WINDOW).put(javax.swing.KeyStroke.getKeyStroke(java.awt.event.KeyEvent.VK_ENTER,0), "ENTER_pressed");
		enterCaptcha.getActionMap().put("ENTER_pressed", enterKey);
		captchaFrame.pack();
		captchaFrame.setResizable(false);
		captchaFrame.setLocationRelativeTo(null);
		captchaFrame.setVisible(true);
		spec.pauseUntilDone();
	}
	public static void main(String[] args) {
		WebSpec spec=new WebSpec().ie();
		spec.open("google.com");
		CheckCaptchar checkCaptchar=new CheckCaptchar(spec);
		checkCaptchar.getCaptchaManual("capchar.png");
	}
}
