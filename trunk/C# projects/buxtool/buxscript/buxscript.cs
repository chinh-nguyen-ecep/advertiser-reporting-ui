using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Windows.Forms;

namespace buxscript
{
    public abstract class buxscript: Form
    {
        public string userName;
        public string password;
        public string proxy;
        public MyBrowser webBrowserForm;
        public string port;
        public Boolean isRuning = false;
        public ListViewItem listViewItem; // a line from list view to update status of process

        public abstract string name();
        public abstract string dllFileName();
        public abstract string address();
        public abstract void start();
        public abstract void stop();
        delegate void SetStatusCallback(string text);

        public static buxscript loadObjectFromDll(string dllFileName) {
            buxscript result = null;
            string startupPath = System.IO.Directory.GetCurrentDirectory();
            Assembly assembly = Assembly.LoadFrom(startupPath + "\\scripts\\" + dllFileName + ".dll");
            string fullTypeName = dllFileName.ToLower() + "." + dllFileName.ToLower();
            result = (buxscript)assembly.CreateInstance(fullTypeName);
            return result;
        }

        public void setStatus(string status) { 
            this.listViewItem.SubItems[3].Text = status;
        }
       
    }
    
}
