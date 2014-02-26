using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
namespace wonbux
{
    public class wonbux:buxscript.buxscript
    {
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
            webBrowser = new buxscript.MyBrowser();
            webBrowser.Show();
            webBrowser.getWebBrowser().Navigate(address());
        }

        public override void stop()
        {
            this.isRuning = false;
            setStatus("Stopped");
            webBrowser.Close();
        }
    }
}
