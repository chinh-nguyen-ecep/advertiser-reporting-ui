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
    public partial class EditSiteForm : Form
    {
        private ListView _listView;
        
        public EditSiteForm(ListView listView,buxscript.buxscript[] listSites)
        {
            InitializeComponent();
            _listView = listView;
            //Add value for Site combobox
            foreach (buxscript.buxscript site in listSites)
            {
                SiteCbx.Items.Add(site.address());
            }
           
            SiteCbx.SelectedIndex = 0;
        }

 

        private void addBtn_Click(object sender, EventArgs e)
        {
            
            string site = SiteCbx.Text;
            string userName = userNameTbx.Text;
            string password = passwordTbx.Text;
            string proxy = proxyTbx.Text;
            string port = portTbx.Text;
            if(userName.Equals("") || password.Equals("") ){
                MessageBox.Show("Must enter Username and Password", "Notice!");
                return;
            }else if(!proxy.Equals("")){

            }
            Boolean result=RunSitesControl.addSiteInstance(site,userName,password,proxy,port);
            if (result) {
                Close();
            }
           
        }

        private void cancelBtn_Click(object sender, EventArgs e)
        {
            Close();
        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }

        private void statusStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }

        private void label1_Click(object sender, EventArgs e)
        {

        }

        private void SiteCbx_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        private void groupBox2_Enter(object sender, EventArgs e)
        {

        }



    }
}
