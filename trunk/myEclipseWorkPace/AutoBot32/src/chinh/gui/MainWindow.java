package chinh.gui;

import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.awt.HeadlessException;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.io.FileNotFoundException;
import java.io.IOException;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JPanel;
import javax.swing.JPasswordField;
import javax.swing.JTextField;
import javax.swing.SpringLayout;

import chinh.BuxTo;
import chinh.utils.ConfigLoader;

public class MainWindow extends JFrame {
	private BuxTo buxTo;
	public MainWindow() throws HeadlessException {
		super();
		// TODO Auto-generated constructor stub
		setTitle("Bux.to autobot");
		setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
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
        setJMenuBar(menubar);
        //end menubar
        
        //Login pannel
        JPanel mainPanel = new JPanel();  
        
        JTextField usernameTxt = new JTextField(25);  
        final JTextField proxyTxt = new JTextField(25);     
        final JTextField proxyportTxt = new JTextField(25);     
        JPasswordField passwordTxt = new JPasswordField(25);  
        JLabel usernameLbl = new JLabel("Username: ");  
        JLabel passwordLbl = new JLabel("Password: ");  
        JLabel proxyLbl = new JLabel("Proxy: ");  
        JLabel portLbl = new JLabel("Port: ");
        JButton loginButton = new JButton("Start bot");  
        loginButton.addActionListener(new ActionListener() {
			
			@Override
			public void actionPerformed(ActionEvent arg0) {
				// TODO Auto-generated method stub
				String proxy=proxyTxt.getText();
				String proxyPort=proxyportTxt.getText();
				int port=0;
				if(!proxyPort.equals("")){
					port=Integer.parseInt(proxyPort);
				}
				if(buxTo==null){
					buxTo=new BuxTo(proxy,port);
				}else{
					buxTo.show();
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
			usernameTxt.disable();
			passwordTxt.setText(ConfigLoader.get("pass"));
			passwordTxt.disable();
			proxyTxt.setText(ConfigLoader.get("proxy"));
			proxyTxt.disable();
			proxyportTxt.setText(ConfigLoader.get("port"));
			proxyportTxt.disable();
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
        getContentPane().add(BorderLayout.CENTER,mainPanel);
        getContentPane().add(BorderLayout.SOUTH,loginButton);
        
        SpringUtilities.makeCompactGrid(mainPanel,4,2,6,6,6,6);
        pack();
        setResizable(false);
        setLocationRelativeTo(null);
		setVisible(true);
	}
	public static void main(String[] args) {
		MainWindow a=new MainWindow();
	}
}
