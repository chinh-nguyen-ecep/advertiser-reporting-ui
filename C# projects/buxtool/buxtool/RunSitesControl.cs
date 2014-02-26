using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;
namespace buxtool
{
    class RunSitesControl
    {
        public static ListView listView=null;
        public static buxscript.buxscript[] scripts;
        public static List<buxscript.buxscript> scritpIntances=new List<buxscript.buxscript>();
        public static void Initialize(ListView _listView) {
            //load list of buxScript
            listView = _listView;
            string startupPath = System.IO.Directory.GetCurrentDirectory();
            string[] filePaths = Directory.GetFiles(startupPath + "\\scripts", "*.dll");
            scripts = new buxscript.buxscript[filePaths.Length];
            for (int i = 0; i < filePaths.Length; i++)
            {
                FileInfo fi = new FileInfo(filePaths[i]);
                string dllName = fi.Name.Split('.')[0];
                buxscript.buxscript temp = buxscript.buxscript.loadObjectFromDll(dllName);
                scripts[i] = temp;
            }

            //init instances from listView
            foreach(ListViewItem item in listView.Items) {
                string site = item.SubItems[0].Text;
                string userName = item.SubItems[1].Text;
                string password = item.SubItems[2].Text;
                string proxy = item.SubItems[3].Text;
                string port = item.SubItems[4].Text;
                buxscript.buxscript instance = getNewScriptInstance(site);
                instance.userName = userName;
                instance.password = password;
                instance.proxy = proxy;
                instance.port = port;
                instance.listViewItem = item;
                scritpIntances.Add(instance);  
            }
        }
        public static Boolean addSiteInstance(string site,string userName,string password,string proxy,string port) {
            Boolean result = true;
            buxscript.buxscript instance = getScriptIntance(site, userName);
            if(instance==null){
                string[] row = { site, userName, password, proxy, port, "", "" };
                var listViewItem = new ListViewItem(row);
                listView.Items.Add(listViewItem);
                instance = getNewScriptInstance(site);
                instance.userName = userName;
                instance.password = password;
                instance.proxy = proxy;
                instance.port = port;
                instance.listViewItem = listViewItem;
                scritpIntances.Add(instance);
            }else{
                MessageBox.Show("The site already exists. Please choose another site or enter another user name!","Notice!");
                result = false;
            }
            return result;
        }
        public static Boolean editSiteInstance(string oldSite,string oldUserName,string newSite,string newUserName,string password,string proxy,string port) {
            Boolean result = true;
            buxscript.buxscript oldInstance = getScriptIntance(oldSite, oldUserName);
            buxscript.buxscript newInstance = getScriptIntance(newSite, oldSite);
            if (!oldInstance.isRuning && newInstance == null)
            {
                removeInstance(oldInstance);
                addSiteInstance(newSite, newUserName, password, proxy, port);
            }
            else {
                result = false;
            }
            return result;
        }


        public static void runSelectedSite() {
            foreach (ListViewItem eachItem in listView.SelectedItems)
            {
                string site = eachItem.SubItems[0].Text;
                string status = eachItem.SubItems[5].Text;
                string user = eachItem.SubItems[1].Text;
                string password = eachItem.SubItems[2].Text;
                string proxy = eachItem.SubItems[3].Text;
                string port = eachItem.SubItems[4].Text;
                buxscript.buxscript newScriptInstance = getScriptIntance(site, user);
                if (!newScriptInstance.isRuning)
                {
                    newScriptInstance.start();
                }
                
            }
        }
        public static void runAllSites() {
            foreach (ListViewItem eachItem in listView.Items)
            {
                string site = eachItem.SubItems[0].Text;
                string status = eachItem.SubItems[5].Text;
                string user = eachItem.SubItems[1].Text;
                string password = eachItem.SubItems[2].Text;
                string proxy = eachItem.SubItems[3].Text;
                string port = eachItem.SubItems[4].Text;
                buxscript.buxscript newScriptInstance = getScriptIntance(site, user);
                if (!newScriptInstance.isRuning)
                {
                    newScriptInstance.start();
                }

            }
        }
        public static void stopSelectedSites() {
            foreach (ListViewItem eachItem in listView.SelectedItems)
            {
                string site = eachItem.SubItems[0].Text;
                string status = eachItem.SubItems[5].Text;
                string user = eachItem.SubItems[1].Text;
                string password = eachItem.SubItems[2].Text;
                string proxy = eachItem.SubItems[3].Text;
                string port = eachItem.SubItems[4].Text;
                buxscript.buxscript scriptIntance = getScriptIntance(site, user);
                if (scriptIntance != null)
                {
                    scriptIntance.stop();
                }

            }
        }
        public static void removeSeletedSite() {
            if (MessageBox.Show("Really remove sites?", "Confirm remove", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                // a 'DialogResult.Yes' value was returned from the MessageBox
                // proceed with your deletion
                foreach (ListViewItem eachItem in listView.SelectedItems)
                {
                    string site = eachItem.SubItems[0].Text;
                    string userName = eachItem.SubItems[1].Text;
                    buxscript.buxscript instance = getScriptIntance(site, userName);
                    if (instance != null && instance.isRuning)
                    {
                        MessageBox.Show("Site: " + site + " by user: " + userName + " is runing. Please stop it before remove!");
                    }
                    else {
                        listView.Items.Remove(eachItem);
                        removeInstance(instance);
                    }
                    
                    
                }
            }
        }
        public static buxscript.buxscript getScriptIntance(string site, string userName)
        {
            buxscript.buxscript result = null;
            foreach (buxscript.buxscript item in scritpIntances)
            {
                if (item.userName.Equals(userName) && item.address().Equals(site))
                {
                    result = item;
                    break;
                }
            }
            return result;
        }
        private static buxscript.buxscript getNewScriptInstance(string site)
        {
            buxscript.buxscript result = null;
            foreach (buxscript.buxscript item in scripts)
            {
                if (item.address().Equals(site))
                {
                    result = buxscript.buxscript.loadObjectFromDll(item.dllFileName());
                }
            }
            return result;

        }
        private static void removeInstance(buxscript.buxscript instance) {
            ListViewItem item = instance.listViewItem;
            listView.Items.Remove(item);
            scritpIntances.Remove(instance);
        }
        
    }
}
