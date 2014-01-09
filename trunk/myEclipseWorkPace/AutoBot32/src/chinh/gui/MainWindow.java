package chinh.gui;

import java.awt.BorderLayout;
import java.awt.HeadlessException;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.NumberFormat;
import java.text.ParseException;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.SpringLayout;

import chinh.BuxTo;
import chinh.utils.ConfigLoader;

public class MainWindow{
	private JPanel messagePanel = new JPanel();
	private JTextField usernameTxt = new JTextField(25);
	private JTextField proxyTxt = new JTextField(25);
	private JTextField proxyportTxt = new JTextField(25);
	private JPasswordField passwordTxt = new JPasswordField(25);  
	private BuxTo buxTo=new BuxTo();
	public MainWindow() throws HeadlessException {
		super();
		JFrame mainFrame=new JFrame("Autobox");
		// TODO Auto-generated constructor stub
		mainFrame.setTitle("Bux.to autobot");
		mainFrame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		JMenuBar menubar = new JMenuBar();
		ImageIcon icon = new ImageIcon(getClass().getResource("").getPath()+"exit.png");
		ImageIcon about_icon = new ImageIcon(getClass().getResource("").getPath()+"about.jpg");
		//menu file
		JMenu file = new JMenu("File");
        file.setMnemonic(KeyEvent.VK_F);
        JMenuItem eMenuItem = new JMenuItem("Exit", icon);
        eMenuItem.setMnemonic(KeyEvent.VK_E);
        eMenuItem.setToolTipText("Exit application");
        eMenuItem.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
            	System.out.println("sdfsdfsdf");
                System.exit(0);
            }
        });

        file.add(eMenuItem);
        menubar.add(file);
        //menu about
        JMenu help = new JMenu("Help");
        help.setMnemonic(KeyEvent.VK_H);
        JMenuItem aboutMenuItem = new JMenuItem("About", about_icon);
        aboutMenuItem.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent arg0) {
				// TODO Auto-generated method stub
				System.out.println("sdfsdfsdf");
			}
		});
        help.add(aboutMenuItem);
        menubar.add(help);
        mainFrame.setJMenuBar(menubar);
        //end menubar
        
        //Login pannel
        JPanel mainPanel = new JPanel();  
        
        JLabel usernameLbl = new JLabel("Username: ");  
        JLabel passwordLbl = new JLabel("Password: ");  
        JLabel proxyLbl = new JLabel("Proxy: ");  
        JLabel portLbl = new JLabel("Port: ");
        JButton loginButton = new JButton("Start bot");  
        loginButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent arg0) {
				// TODO Auto-generated method stub
				String proxy=proxyTxt.getText();
				String proxyPort=proxyportTxt.getText();
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
					buxTo.setUserName(usernameTxt.getText());
					buxTo.setPassword(passwordTxt.getText());
					buxTo.setProxy(proxy);
					buxTo.setPort(port);
					try {
						buxTo.login();
					} catch (FileNotFoundException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
			}
		});  
        mainPanel.setLayout(new SpringLayout());   
        mainPanel.add(usernameLbl);    
        mainPanel.add(usernameTxt); 
        mainPanel.add(passwordLbl); 
        mainPanel.add(passwordTxt);
        mainPanel.add(proxyLbl);
        mainPanel.add(proxyTxt);
        mainPanel.add(portLbl);
        mainPanel.add(proxyportTxt);
        
        //set value
        try {
			usernameTxt.setText(ConfigLoader.get("username"));
			passwordTxt.setText(ConfigLoader.get("pass"));
			proxyTxt.setText(ConfigLoader.get("proxy"));
			proxyportTxt.setText(ConfigLoader.get("port"));
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		mainFrame.getContentPane().add(BorderLayout.CENTER,mainPanel);
		mainFrame.getContentPane().add(BorderLayout.SOUTH,loginButton);
        
        SpringUtilities.makeCompactGrid(mainPanel,4,2,6,6,6,6);
        mainFrame.pack();
        mainFrame.setResizable(false);
        mainFrame.setLocationRelativeTo(null);
        mainFrame.setVisible(true);
	}
	public void showMessage(String type,String message){
		if(type.equals("Warning")){
			JOptionPane.showMessageDialog(messagePanel, message,"Warning", JOptionPane.WARNING_MESSAGE);
		}else if(type.equals("Error")){
			 JOptionPane.showMessageDialog(messagePanel, "Could not open file","Error", JOptionPane.ERROR_MESSAGE);
		}else if(type.equals("Information")){
			JOptionPane.showMessageDialog(messagePanel, "Download completed","Question", JOptionPane.INFORMATION_MESSAGE);
		}
	}
	public static void main(String[] args) {	
		MainWindow mainWindow=new MainWindow();
		
	}
}
