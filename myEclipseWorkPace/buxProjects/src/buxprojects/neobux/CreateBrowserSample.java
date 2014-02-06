package buxprojects.neobux;


import com.jniwrapper.win32.ie.Browser;

import javax.swing.*;
import java.awt.*;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

/**
 * This sample creates browser added to a Swing container.
 */
public class CreateBrowserSample {
    public static void main(String[] args) throws Exception {
        final Browser browser = new Browser();

        JFrame frame = new JFrame("JExplorer - Create Browser Sample");
        frame.setSize(700, 500);
        frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        frame.addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                browser.close();
            }
        });
        frame.setLocationRelativeTo(null);
        frame.getContentPane().add(browser, BorderLayout.CENTER);
        frame.setVisible(true);

        browser.navigate("http://www.google.com");
    }
}