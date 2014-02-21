using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.IO;

namespace buxtool
{
    public partial class MainForm : Form
    {
        private buxscript.buxscript[] listBuxScripts;
        private List<buxscript.buxscript> listBuxScriptsRuning = new List<buxscript.buxscript>();
        public MainForm()
        {
            InitializeComponent();
            //load list of buxScript
            string startupPath = System.IO.Directory.GetCurrentDirectory();
            string[] filePaths = Directory.GetFiles(startupPath + "\\scripts", "*.dll");
            listBuxScripts = new buxscript.buxscript[filePaths.Length];
            for (int i=0;i<filePaths.Length;i++) {
                FileInfo fi = new FileInfo(filePaths[i]);
                string dllName = fi.Name.Split('.')[0];
                buxscript.buxscript temp = buxscript.buxscript.loadObjectFromDll(dllName);
                listBuxScripts[i] = temp;
            }

        }

        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Close();
        }


        private void toolStripAddSiteBtn_Click(object sender, EventArgs e)
        {
            EditSiteForm addSiteForm = new EditSiteForm(listView1, listBuxScripts);
            addSiteForm.ShowDialog(this);
        }

        private void addSiteToolStripMenuItem_Click(object sender, EventArgs e)
        {

            EditSiteForm addSiteForm = new EditSiteForm(listView1, listBuxScripts);
            addSiteForm.ShowDialog(this);
        }

        private void toolStripRunBtn_Click(object sender, EventArgs e)
        {
            
            foreach (ListViewItem eachItem in listView1.SelectedItems)
            {
                string site = eachItem.SubItems[0].Text;
                string status = eachItem.SubItems[5].Text;
                string user = eachItem.SubItems[1].Text;
                string password = eachItem.SubItems[2].Text;
                string proxy = eachItem.SubItems[3].Text;
                string port = eachItem.SubItems[4].Text;

                if (status.Equals("Stopped") || status.Equals(""))
                {
                    buxscript.buxscript newInstanceScript = getRuningScript(site, user);
                    if (newInstanceScript == null)
                    {
                        newInstanceScript = getNewInstanceScript(site);
                        newInstanceScript.userName = user;
                        newInstanceScript.password = password;
                        newInstanceScript.proxy = proxy;
                        newInstanceScript.port = port;
                        newInstanceScript.listViewItem = eachItem;
                        listBuxScriptsRuning.Add(newInstanceScript);
                        newInstanceScript.start();

                    }
                    else
                    {

                        newInstanceScript.start();
                    }
                }
                else {
                    //MessageBox.Show("Site "+site+" with user "+user+" is running!", "Notice");
                    return;
                }

                
            }
                
            
            
        }

        private void toolStripRemoveSiteBtn_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("Really remove sites?", "Confirm remove", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                // a 'DialogResult.Yes' value was returned from the MessageBox
                // proceed with your deletion
                foreach (ListViewItem eachItem in listView1.SelectedItems)
                {
                    listView1.Items.Remove(eachItem);
                }
            }

           
        }

        private void toolStripRunAllBtn_Click(object sender, EventArgs e)
        {
            foreach (ListViewItem eachItem in listView1.Items)
            {
                string site = eachItem.SubItems[0].Text;
                string status = eachItem.SubItems[5].Text;
                string user = eachItem.SubItems[1].Text;
                string password = eachItem.SubItems[2].Text;
                string proxy = eachItem.SubItems[3].Text;
                string port = eachItem.SubItems[4].Text;

                if (status.Equals("Stopped") || status.Equals(""))
                {
                    buxscript.buxscript newInstanceScript = getRuningScript(site, user);
                    if (newInstanceScript == null)
                    {
                        newInstanceScript = getNewInstanceScript(site);
                        newInstanceScript.userName = user;
                        newInstanceScript.password = password;
                        newInstanceScript.proxy = proxy;
                        newInstanceScript.port = port;
                        newInstanceScript.listViewItem = eachItem;
                        listBuxScriptsRuning.Add(newInstanceScript);
                        newInstanceScript.start();

                    }
                    else
                    {

                        newInstanceScript.start();
                    }
                }
                else
                {
                    //MessageBox.Show("Site "+site+" with user "+user+" is running!", "Notice");
                    return;
                }
                
            }
        }

        private void toolStripStopBtn_Click(object sender, EventArgs e)
        {
            foreach (ListViewItem eachItem in listView1.SelectedItems)
            {
                string site = eachItem.SubItems[0].Text;
                string status = eachItem.SubItems[5].Text;
                string user = eachItem.SubItems[1].Text;
                string password = eachItem.SubItems[2].Text;
                string proxy = eachItem.SubItems[3].Text;
                string port = eachItem.SubItems[4].Text;
                buxscript.buxscript scriptIntance = getRuningScript(site, user);
                if(scriptIntance!=null){
                    scriptIntance.stop();
                }
                
            }
        }

        private void toolStripExitBtn_Click(object sender, EventArgs e)
        {
            
            if (MessageBox.Show("Really exit?", "Confirm exit", MessageBoxButtons.YesNo) == DialogResult.Yes)
            {
                // a 'DialogResult.Yes' value was returned from the MessageBox
                // proceed with your deletion
                Close();
            }
        }

        private void toolStripEditSiteBtn_Click(object sender, EventArgs e)
        {
            if (listView1.SelectedItems.Count == 1)
            {

                string status = listView1.SelectedItems[0].SubItems[4].Text;
                if (status.Equals("runing"))
                {
                    MessageBox.Show("Can't edit site when it is runing!", "Notice");
                }else{
                    EditForm editForm = new EditForm(listView1, listBuxScripts);
                    editForm.ShowDialog(this);
                }


            }
            else {
                MessageBox.Show("Please select a site!","Notice");
            }
        }

        private buxscript.buxscript getRuningScript(string site, string userName) {
            buxscript.buxscript result = null;
            foreach (buxscript.buxscript item in listBuxScriptsRuning) {
                if (item.userName.Equals(userName) && item.address().Equals(site)) {
                    result = item;
                    break;
                }
            }
            return result;
        }

        private buxscript.buxscript getNewInstanceScript(string site) {
            buxscript.buxscript result=null;
            foreach (buxscript.buxscript item in listBuxScripts) {
                if (item.address().Equals(site)) {
                    result = buxscript.buxscript.loadObjectFromDll(item.dllFileName());
                }
            }
            return result;

        }
       





    }
}
