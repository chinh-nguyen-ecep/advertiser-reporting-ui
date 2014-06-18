using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using CefSharp;
using CefSharp.WinForms;

namespace AutoCliker2014
{
    public abstract class BuxScript
    {
        public string userName;
        public string password;
        public Boolean isRuning = false;
        public WebView webView;
        public abstract void start();
        public abstract Boolean isActive();
        public abstract void stop();
    }
}
