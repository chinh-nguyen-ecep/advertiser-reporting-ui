using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
namespace wonbux
{
    public class wonbux:buxscript.buxscript
    {
        private string loginPage = "http://wonbux.com/login";
        private Stack<HtmlElement> adsUrls = new Stack<HtmlElement>();
        private Timer timer = new Timer();
        public wonbux() {
        }
        public override string address()
        {
            return "http://wonbux.com";
        }


        public override string name()
        {
            return "Wonbux";
        }

        public override string dllFileName()
        {
            return "wonbux";
        }

        public override void start()
        {
            this.isRuning = true;
            setStatus("Runing");
            webBrowserForm = new buxscript.MyBrowser();
            webBrowserForm.Show();
            webBrowserForm.go(loginPage);
            webBrowserForm.getWebBrowser().DocumentCompleted += new WebBrowserDocumentCompletedEventHandler(login);
            Console.WriteLine("Web browser version: " + webBrowserForm.getWebBrowser().Version.ToString());
          
            
        }

        public override void stop()
        {
            this.isRuning = false;
            setStatus("Stopped");
            webBrowserForm.Close();
        }
        // Action call when login page loaded
        private void login(object sender, WebBrowserDocumentCompletedEventArgs e)
        {
            Console.WriteLine("Begin enter form");
            WebBrowser webBrowser = webBrowserForm.getWebBrowser();
            webBrowser.Document.GetElementsByTagName("input")[4].SetAttribute("value",userName);
            webBrowser.Document.GetElementsByTagName("input")[5].SetAttribute("value", password);
            webBrowser.Document.GetElementsByTagName("form")[1].GetElementsByTagName("a")[0].InvokeMember("click");
            webBrowserForm.getWebBrowser().DocumentCompleted += new WebBrowserDocumentCompletedEventHandler(afterLoginSubmit);
            webBrowserForm.getWebBrowser().DocumentCompleted -= new WebBrowserDocumentCompletedEventHandler(login);
            
        }
        // action when submit login form completed
        private void afterLoginSubmit(object sender, WebBrowserDocumentCompletedEventArgs e)
        {
            Console.WriteLine("Checking login");
            timer.Tick += new EventHandler(checkingLogin);
            timer.Interval = (2000) * (1);  
            timer.Enabled = true;  
            timer.Start();
            webBrowserForm.getWebBrowser().DocumentCompleted -= new WebBrowserDocumentCompletedEventHandler(afterLoginSubmit);
            //MessageBox.Show("Submited");
        }
        // check when login completed
        private void checkingLogin(object sender, EventArgs e)
        {
            
            Boolean isLogined = false;
            WebBrowser webBrowser = webBrowserForm.getWebBrowser();
            string afterLoginUrl=webBrowser.Url.AbsolutePath;
            Console.WriteLine("Current Url:"+afterLoginUrl);

            if (afterLoginUrl.Equals("/account"))
            {
                isLogined=true;
            }

            if (!isLogined)
            {
                //timer.Tick += new EventHandler(checkingLogin);
                Console.WriteLine("Checking...");
            }
            else {
                Console.WriteLine("Login Successful!");
                timer.Tick -= new EventHandler(checkingLogin);
                timer.Stop();
                timer.Dispose();
                webBrowser.Navigate("http://wonbux.com/ptc-ads");
                webBrowserForm.getWebBrowser().DocumentCompleted += new WebBrowserDocumentCompletedEventHandler(getListAdsUrl);
            }
        }
        private void getListAdsUrl(object sender, EventArgs e) {
            Console.WriteLine("Get List Ads Urls");
            WebBrowser webBrowser = webBrowserForm.getWebBrowser();
            HtmlElementCollection col = webBrowser.Document.GetElementsByTagName("a");
            foreach (HtmlElement element in col) { 
                string id=element.GetAttribute("id");
                string url=element.GetAttribute("href");
                if(id.IndexOf("z_id")==0){
                    adsUrls.Push(element);
                    Console.WriteLine("Ads link: "+url);
                }
            }
            readAds();
            webBrowserForm.getWebBrowser().DocumentCompleted -= new WebBrowserDocumentCompletedEventHandler(getListAdsUrl);
        
        }

        private void readAds() {
            WebBrowser webBrowser = webBrowserForm.getWebBrowser();
            HtmlElement element = adsUrls.Pop();
            string url = element.GetAttribute("href");
            Console.WriteLine("Navigate to ads: "+url);
            //element.InvokeMember("click");
            webBrowser.Navigate(url);
            webBrowserForm.getWebBrowser().DocumentCompleted += new WebBrowserDocumentCompletedEventHandler(checkReadedAds);
        }
        private void checkReadedAds(object sender, EventArgs e) {
            Console.WriteLine("Checking read ads");
            webBrowserForm.getWebBrowser().DocumentCompleted -= new WebBrowserDocumentCompletedEventHandler(checkReadedAds);
            WebBrowser webBrowser = webBrowserForm.getWebBrowser();
            HtmlElement processBar = webBrowser.Document.GetElementById("progressbar");
            string completed = processBar.GetAttribute("aria-valuenow");
            Console.WriteLine("Completed: "+completed);
            if (completed.Equals("100"))
            {
                HtmlElement nextBtn = webBrowser.Document.GetElementById("gonextnocaptcha");
                string displayValue=nextBtn.Style;
                Console.WriteLine("display: "+displayValue);
            }
            timer.Tick -= new EventHandler(checkReadedAds);
            timer.Start();
        }


    }
}
