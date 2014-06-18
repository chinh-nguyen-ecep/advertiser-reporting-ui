using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.ComponentModel;

namespace AutoCliker2014
{
    class BuxTo:BuxScript
    {
        public override void start()
        {
            isRuning = true;
            userName = ConfigureControl.configureInfo.buxToUserName;
            password = ConfigureControl.configureInfo.buxToPassword;
            webView.Load("http://bux.to/login.php");
            webView.PropertyChanged += new PropertyChangedEventHandler(this.checkWhenLoginPageLoadCompleted);
        }
        private void checkWhenLoginPageLoadCompleted(object sender, PropertyChangedEventArgs e)
        {
            if (e.PropertyName.Equals("IsLoading") && !webView.IsLoading ) {
                webView.PropertyChanged -= new PropertyChangedEventHandler(this.checkWhenLoginPageLoadCompleted);
                webView.ExecuteScript("alert('dfsdfsdfsdfs')");
                webView.ExecuteScript("document.getElementById('name').value='"+userName+"'");
                webView.ExecuteScript("document.getElementById('email').value='" +password+ "'");
                Console.WriteLine("asdasd");
            }
        }
        public override void stop()
        {
            isRuning = false;
        }

        public override Boolean isActive()
        {
            return ConfigureControl.configureInfo.buxToActive;
        }
    }
}
