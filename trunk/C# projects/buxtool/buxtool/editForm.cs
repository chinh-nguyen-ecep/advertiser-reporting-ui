using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace buxtool
{
    public partial class EditForm : Form
    {
        private ListView _listView;
        public EditForm(ListView listView, buxscript.buxscript[] listSites)
        {
            InitializeComponent();
            _listView = listView;
            //Add value for Site combobox
            string site = _listView.SelectedItems[0].SubItems[0].Text;
            int selectIndex=0;
            int i = 0;
            foreach (buxscript.buxscript script in listSites)
            {
                SiteCbx.Items.Add(script.address());
                if(script.address().Equals(site)){selectIndex=i;}
                i++;
            }
            SiteCbx.SelectedIndex= selectIndex;

            //Set value form
            ListViewItem item = _listView.SelectedItems[0];
            userNameTbx.Text = item.SubItems[1].Text;
            passwordTbx.Text = item.SubItems[2].Text;
            proxyTbx.Text = item.SubItems[3].Text;
            portTbx.Text = item.SubItems[4].Text;
        }

        private void updateBtn_Click(object sender, EventArgs e)
        {
            string site = SiteCbx.Text;
            string userName = userNameTbx.Text;
            string password = passwordTbx.Text;
            string proxy = proxyTbx.Text;
            string port = portTbx.Text;
            if (userName.Equals("") || password.Equals(""))
            {
                MessageBox.Show("Must enter Username and Password", "Notice!");
                return;
            }
            else if (!proxy.Equals(""))
            {

            }
            ListViewItem item = _listView.SelectedItems[0];
            string oldSite = item.SubItems[0].Text;
            string oldUserName = item.SubItems[1].Text;
            
            Boolean result= RunSitesControl.editSiteInstance(oldSite,oldUserName,site,userName,password,proxy,port);
            if(result){
                Close();
            }
            
        }
    }
}
