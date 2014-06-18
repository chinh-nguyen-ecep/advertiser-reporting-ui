using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using CefSharp;
using CefSharp.WinForms;
namespace AutoCliker2014
{
    public partial class MainForm : Form
    {
        private ConfigureInfo config;
        private Timer mainTimer = new Timer();
        private WebView neobuxWebView;
        private WebView buxWebView;        
        private WebView advertiserWebView;
        private List<BuxScript> listBuxScripts = new List<BuxScript>();
        public MainForm()
        {
            InitializeComponent();
            //load configure
            loadConfigure();
            //install Webview
            var settings = new CefSharp.Settings
            {
                PackLoadingDisabled = true,
                
            };
            if (CEF.Initialize(settings))
            {
                //neobux
                neobuxWebView = new WebView("http://neobux.com", new CefSharp.BrowserSettings());                
                neobuxWebView.Dock = DockStyle.Fill;
                NeoBux neoBux = new NeoBux();
                neoBux.userName = config.neoBuxUserName;
                neoBux.password = config.neoBuxPassword;
                neoBux.webView = neobuxWebView;
                listBuxScripts.Add(neoBux);
                //bux to 
                buxWebView = new WebView("http://bux.to", new CefSharp.BrowserSettings());
                //buxWebView.Size = new System.Drawing.Size(100, 100);
                buxWebView.Dock = DockStyle.Fill;
                BuxTo buxTo=new BuxTo();
                buxTo.userName = config.buxToUserName;
                buxTo.password = config.neoBuxPassword;
                buxTo.webView = buxWebView;
                listBuxScripts.Add(buxTo);           
                //advertiser
                advertiserWebView = new WebView("http://google.com", new CefSharp.BrowserSettings());
                advertiserWebView.Dock = DockStyle.Fill;

                toolStripContainer.ContentPanel.Controls.Add(advertiserWebView);
                toolStripContainer.ContentPanel.Controls.Add(neobuxWebView);
                toolStripContainer.ContentPanel.Controls.Add(buxWebView);
                
            }
           // neobuxWebView.Visible = false;
           // buxWebView.Visible = false;
            //check webinstalled
            mainTimer.Interval = 3000;
            mainTimer.Tick += new EventHandler(checkWebViewInstanled);
            mainTimer.Enabled = true;
            mainTimer.Start();
        }

        private void toolStripButton3_Click(object sender, EventArgs e)
        {
            foreach(BuxScript item in listBuxScripts)
            {
                if (item.isActive())
                {
                    item.start();
                }
            }
            
        }

        private void toolStripButton1_Click(object sender, EventArgs e)
        {
            SettingForm a = new SettingForm(this);
            a.ShowDialog(this);
        }

        private void toolStripButton2_Click(object sender, EventArgs e)
        {

        }

        private void tabControl_Selected(object sender, TabControlEventArgs e)
        {
            string selectedTabname=tabControl.SelectedTab.Text;
            neobuxWebView.Visible = false;
            advertiserWebView.Visible = false;
            buxWebView.Visible = false;
            if (selectedTabname.Equals(tabPage1.Text)) {
                neobuxWebView.Visible = true;
  
            }
            if(selectedTabname.Equals(tabPage2.Text)){
                buxWebView.Visible = true;
            }
            if(selectedTabname.Equals(tabPage4.Text)){
                advertiserWebView.Visible = true;
            }
            Console.WriteLine(selectedTabname);
        }

        private void checkWebViewInstanled(object sender, EventArgs e)
        {
            Boolean ok = true;

            foreach(BuxScript item in  listBuxScripts){
                if (!item.webView.IsBrowserInitialized) {
                    ok = false;
                }
            }
            Console.WriteLine(ok);
            if (ok) {
                toolStripButton3.Enabled = true;
                mainTimer.Tick -= new EventHandler(checkWebViewInstanled);
                mainTimer.Stop();
            }
        }


        public void loadConfigure() {
            ConfigureControl.loadConfig();
            config = ConfigureControl.configureInfo;
            tabControl.Controls.Remove(tabPage1);
            tabControl.Controls.Remove(tabPage2);
            //hide neobux if not active
            if (config.neoBuxActive)
            {
                tabControl.Controls.Add(tabPage1);
            }
            //hide bux.to if not active
            if (config.buxToActive)
            {
                tabControl.Controls.Add(tabPage2);
            }
        }



       

       
    }
}
