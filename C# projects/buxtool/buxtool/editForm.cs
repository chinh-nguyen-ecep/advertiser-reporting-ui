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
            foreach (buxscript.buxscript site in listSites)
            {
                SiteCbx.Items.Add(site.address());
            }

            SiteCbx.SelectedIndex = _listView.SelectedItems[0].Index;

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
            item.SubItems[0].Text = site;
            item.SubItems[1].Text = userName;
            item.SubItems[2].Text = password;
            item.SubItems[3].Text = proxy;
            item.SubItems[4].Text = port;
            Close();
        }
    }
}
