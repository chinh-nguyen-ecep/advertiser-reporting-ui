using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace AutoCliker2014
{
    public partial class SettingForm : Form
    {
        private MainForm mainForm;
        public SettingForm(MainForm form1)
        {
            InitializeComponent();
            mainForm = form1;
            ConfigureControl.loadConfig();
            ConfigureInfo config = ConfigureControl.configureInfo;

            textBox1.Text = config.neoBuxUserName;
            textBox2.Text = config.neoBuxPassword;
            cb_neobuxActive.Checked = config.neoBuxActive;

            textBox3.Text = config.buxToUserName;
            textBox4.Text = config.buxToPassword;
            cb_buxActive.Checked = config.buxToActive;
            
        }

        private void button2_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Boolean ok = true;
            if(cb_neobuxActive.Checked){
                if (textBox1.Text.Equals("") || textBox2.Text.Equals(""))
                {
                    MessageBox.Show("Please enter username and password!");
                    ok = false;
                }
            }
            if(cb_buxActive.Checked){
                if(textBox3.Text.Equals("")||textBox4.Text.Equals("")){
                    MessageBox.Show("Please enter username and password!");
                    ok = false;
                }
            }

            if(ok){
                ConfigureControl.configureInfo.neoBuxActive = cb_neobuxActive.Checked;
                ConfigureControl.configureInfo.neoBuxUserName = textBox1.Text;
                ConfigureControl.configureInfo.neoBuxPassword = textBox2.Text;
                ConfigureControl.configureInfo.buxToActive = cb_buxActive.Checked;
                ConfigureControl.configureInfo.buxToUserName = textBox3.Text;
                ConfigureControl.configureInfo.buxToPassword = textBox4.Text;
                ConfigureControl.saveConfig();
                mainForm.loadConfigure();
                this.Close();
            }
            
        }

     
    }
}
