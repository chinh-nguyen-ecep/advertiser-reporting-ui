using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using System.IO;
using Microsoft.Win32;

namespace buxtool
{
    public partial class MainForm : Form
    {
        private Form advertiserForm;
        delegate void SetStatusCallback(string site,string text);

        private List<buxscript.buxscript> listBuxScriptsRuning = new List<buxscript.buxscript>();
        public MainForm()
        {
            InitializeComponent();
           
            advertiserForm = new AdvertiserForm();
           
            //Loading configure
            ConfigureControl.loadConfig();
            //Open the last profile
            string lastFile = ConfigureControl.configureInfo.lastFileProfile;
            if (lastFile.Equals("")) { lastFile = ProfileControl.profilePathDefault; }
            ProfileControl.listView = listView1;
            ProfileControl.loadProfile(lastFile);
            toolStripStatusFileProfile.Text = ProfileControl.profilePathDefault;
            toolStrip1.Refresh();
            //
            RunSitesControl.Initialize(listView1);
            //
           

        }
       
        private void exitToolStripMenuItem_Click(object sender, EventArgs e)
        {
            Close();
        }


        private void toolStripAddSiteBtn_Click(object sender, EventArgs e)
        {
            EditSiteForm addSiteForm = new EditSiteForm(listView1, RunSitesControl.scripts);
            addSiteForm.ShowDialog(this);
        }

        private void addSiteToolStripMenuItem_Click(object sender, EventArgs e)
        {

            EditSiteForm addSiteForm = new EditSiteForm(listView1, RunSitesControl.scripts);
            addSiteForm.ShowDialog(this);
        }

        private void toolStripRunBtn_Click(object sender, EventArgs e)
        {

            RunSitesControl.runSelectedSite();
        }

        private void toolStripRemoveSiteBtn_Click(object sender, EventArgs e)
        {
            RunSitesControl.removeSeletedSite();

           
        }

        private void toolStripRunAllBtn_Click(object sender, EventArgs e)
        {
            RunSitesControl.runAllSites();
        }

        private void toolStripStopBtn_Click(object sender, EventArgs e)
        {
            RunSitesControl.stopSelectedSites();
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
                ListViewItem listViewItem=listView1.SelectedItems[0];
                string site=listViewItem.SubItems[0].Text;
                string userName=listViewItem.SubItems[1].Text;
                buxscript.buxscript instance = RunSitesControl.getScriptIntance(site, userName);
                if (instance.isRuning)
                {
                    MessageBox.Show("Can't edit site when it is runing!", "Notice");
                }else{
                    EditForm editForm = new EditForm(listView1, RunSitesControl.scripts);
                    editForm.ShowDialog(this);
                }


            }
            else {
                MessageBox.Show("Please select a site!","Notice");
            }
        }



        private void toolStripSaveBtn_Click(object sender, EventArgs e)
        {
            ProfileControl.save();
        }

        private void MainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            ProfileControl.save();
            ConfigureControl.saveConfig();
        }

        private void toolStripStatusLabel1_Click(object sender, EventArgs e)
        {

        }

        private void saveAsToolStripMenuItem_Click(object sender, EventArgs e)
        {
            saveFileAsDialog.InitialDirectory=System.IO.Directory.GetCurrentDirectory();
            saveFileAsDialog.ShowDialog(this);
            string fileName = saveFileAsDialog.FileName;
            if(!fileName.Equals("")){
                ProfileControl.saveAs(fileName);
                toolStripStatusFileProfile.Text = fileName;
            }
            
        }

        private void saveToolStripMenuItem_Click(object sender, EventArgs e)
        {
            ProfileControl.save();
        }

        private void toolStripLoadProfileBtn_Click(object sender, EventArgs e)
        {
            openProfile();
        }

        private void openProfile() {
            openFileDialog1.Title = "Open Profile";
            openFileDialog1.InitialDirectory = System.IO.Directory.GetCurrentDirectory();
            openFileDialog1.ShowDialog(this);
            string fileName = openFileDialog1.FileName;
            if (!fileName.Equals("")) {
                ProfileControl.save();
                ProfileControl.loadProfile(fileName);
                toolStripStatusFileProfile.Text = ConfigureControl.configureInfo.lastFileProfile;
            }
        }

        private void openProfileToolStripMenuItem_Click(object sender, EventArgs e)
        {
            openProfile();
        }

        private void newToolStripMenuItem_Click(object sender, EventArgs e)
        {
            newProfileFileDialog.InitialDirectory = System.IO.Directory.GetCurrentDirectory();
            newProfileFileDialog.Title = "New Profile";
            newProfileFileDialog.ShowDialog(this);
            string fileName = newProfileFileDialog.FileName;
            if (!fileName.Equals("")) {
                ProfileControl.newProfile(fileName);
                toolStripStatusFileProfile.Text = fileName;
            }
        }

        private void toolStripButton1_Click(object sender, EventArgs e)
        {
            RunSitesControl.monitorProcess();
        }

        



    }
}
