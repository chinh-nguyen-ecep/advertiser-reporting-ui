using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace neobux
{
    public class neobux:buxscript.buxscript
    {
        
        public override string address()
        {
            return "http://neobux.com";
        }
        public override string dllFileName()
        {
            return "neobux";
        }
        public override string name()
        {
            return "Neobux";
        }
        public override void start()
        {
            this.isRuning = true;
            setStatus("Runing");
            webBrowser = new buxscript.MyBrowser();
            webBrowser.Show();
            webBrowser.getWebBrowser().Navigate(address());
        }
        public override void stop()
        {
            webBrowser.Close();
            setStatus("Stooped");
            isRuning = false;
        }
    }
}
