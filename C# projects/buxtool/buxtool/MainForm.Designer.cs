namespace buxtool
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MainForm));
            this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.menuStrip1 = new System.Windows.Forms.MenuStrip();
            this.fileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.newToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.openProfileToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator4 = new System.Windows.Forms.ToolStripSeparator();
            this.addSiteToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.saveAsToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator2 = new System.Windows.Forms.ToolStripSeparator();
            this.exitToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.helpToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.checkUpdateToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStripSeparator3 = new System.Windows.Forms.ToolStripSeparator();
            this.aboutToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.toolStrip1 = new System.Windows.Forms.ToolStrip();
            this.toolStripLoadProfileBtn = new System.Windows.Forms.ToolStripButton();
            this.toolStripSaveBtn = new System.Windows.Forms.ToolStripButton();
            this.toolStripAddSiteBtn = new System.Windows.Forms.ToolStripButton();
            this.toolStripEditSiteBtn = new System.Windows.Forms.ToolStripButton();
            this.toolStripRemoveSiteBtn = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator1 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripRunAllBtn = new System.Windows.Forms.ToolStripButton();
            this.toolStripRunBtn = new System.Windows.Forms.ToolStripButton();
            this.toolStripStopBtn = new System.Windows.Forms.ToolStripButton();
            this.toolStripSeparator5 = new System.Windows.Forms.ToolStripSeparator();
            this.toolStripMonitorBtn = new System.Windows.Forms.ToolStripButton();
            this.toolStripExitBtn = new System.Windows.Forms.ToolStripButton();
            this.statusStrip1 = new System.Windows.Forms.StatusStrip();
            this.toolStripStatusIP = new System.Windows.Forms.ToolStripStatusLabel();
            this.toolStripStatusFileProfile = new System.Windows.Forms.ToolStripStatusLabel();
            this.listView1 = new System.Windows.Forms.ListView();
            this.site = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.userName = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.password = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.status = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.amount = ((System.Windows.Forms.ColumnHeader)(new System.Windows.Forms.ColumnHeader()));
            this.saveFileAsDialog = new System.Windows.Forms.SaveFileDialog();
            this.openFileDialog1 = new System.Windows.Forms.OpenFileDialog();
            this.newProfileFileDialog = new System.Windows.Forms.SaveFileDialog();
            this.menuStrip1.SuspendLayout();
            this.toolStrip1.SuspendLayout();
            this.statusStrip1.SuspendLayout();
            this.SuspendLayout();
            // 
            // contextMenuStrip1
            // 
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Size = new System.Drawing.Size(61, 4);
            // 
            // menuStrip1
            // 
            this.menuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.fileToolStripMenuItem,
            this.helpToolStripMenuItem});
            this.menuStrip1.Location = new System.Drawing.Point(0, 0);
            this.menuStrip1.Name = "menuStrip1";
            this.menuStrip1.Size = new System.Drawing.Size(393, 24);
            this.menuStrip1.TabIndex = 1;
            this.menuStrip1.Text = "menuStrip1";
            // 
            // fileToolStripMenuItem
            // 
            this.fileToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.newToolStripMenuItem,
            this.openProfileToolStripMenuItem,
            this.toolStripSeparator4,
            this.addSiteToolStripMenuItem,
            this.saveToolStripMenuItem,
            this.saveAsToolStripMenuItem,
            this.toolStripSeparator2,
            this.exitToolStripMenuItem});
            this.fileToolStripMenuItem.Name = "fileToolStripMenuItem";
            this.fileToolStripMenuItem.Size = new System.Drawing.Size(37, 20);
            this.fileToolStripMenuItem.Text = "File";
            // 
            // newToolStripMenuItem
            // 
            this.newToolStripMenuItem.Image = ((System.Drawing.Image)(resources.GetObject("newToolStripMenuItem.Image")));
            this.newToolStripMenuItem.Name = "newToolStripMenuItem";
            this.newToolStripMenuItem.Size = new System.Drawing.Size(140, 22);
            this.newToolStripMenuItem.Text = "New Profile";
            this.newToolStripMenuItem.Click += new System.EventHandler(this.newToolStripMenuItem_Click);
            // 
            // openProfileToolStripMenuItem
            // 
            this.openProfileToolStripMenuItem.Image = ((System.Drawing.Image)(resources.GetObject("openProfileToolStripMenuItem.Image")));
            this.openProfileToolStripMenuItem.Name = "openProfileToolStripMenuItem";
            this.openProfileToolStripMenuItem.Size = new System.Drawing.Size(140, 22);
            this.openProfileToolStripMenuItem.Text = "Open Profile";
            this.openProfileToolStripMenuItem.Click += new System.EventHandler(this.openProfileToolStripMenuItem_Click);
            // 
            // toolStripSeparator4
            // 
            this.toolStripSeparator4.Name = "toolStripSeparator4";
            this.toolStripSeparator4.Size = new System.Drawing.Size(137, 6);
            // 
            // addSiteToolStripMenuItem
            // 
            this.addSiteToolStripMenuItem.Image = ((System.Drawing.Image)(resources.GetObject("addSiteToolStripMenuItem.Image")));
            this.addSiteToolStripMenuItem.Name = "addSiteToolStripMenuItem";
            this.addSiteToolStripMenuItem.Size = new System.Drawing.Size(140, 22);
            this.addSiteToolStripMenuItem.Text = "Add Site";
            this.addSiteToolStripMenuItem.Click += new System.EventHandler(this.addSiteToolStripMenuItem_Click);
            // 
            // saveToolStripMenuItem
            // 
            this.saveToolStripMenuItem.Image = ((System.Drawing.Image)(resources.GetObject("saveToolStripMenuItem.Image")));
            this.saveToolStripMenuItem.Name = "saveToolStripMenuItem";
            this.saveToolStripMenuItem.Size = new System.Drawing.Size(140, 22);
            this.saveToolStripMenuItem.Text = "Save";
            this.saveToolStripMenuItem.Click += new System.EventHandler(this.saveToolStripMenuItem_Click);
            // 
            // saveAsToolStripMenuItem
            // 
            this.saveAsToolStripMenuItem.Name = "saveAsToolStripMenuItem";
            this.saveAsToolStripMenuItem.Size = new System.Drawing.Size(140, 22);
            this.saveAsToolStripMenuItem.Text = "Save As";
            this.saveAsToolStripMenuItem.Click += new System.EventHandler(this.saveAsToolStripMenuItem_Click);
            // 
            // toolStripSeparator2
            // 
            this.toolStripSeparator2.Name = "toolStripSeparator2";
            this.toolStripSeparator2.Size = new System.Drawing.Size(137, 6);
            // 
            // exitToolStripMenuItem
            // 
            this.exitToolStripMenuItem.Image = ((System.Drawing.Image)(resources.GetObject("exitToolStripMenuItem.Image")));
            this.exitToolStripMenuItem.Name = "exitToolStripMenuItem";
            this.exitToolStripMenuItem.Size = new System.Drawing.Size(140, 22);
            this.exitToolStripMenuItem.Text = "Exit";
            this.exitToolStripMenuItem.Click += new System.EventHandler(this.exitToolStripMenuItem_Click);
            // 
            // helpToolStripMenuItem
            // 
            this.helpToolStripMenuItem.DropDownItems.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.checkUpdateToolStripMenuItem,
            this.toolStripSeparator3,
            this.aboutToolStripMenuItem});
            this.helpToolStripMenuItem.Name = "helpToolStripMenuItem";
            this.helpToolStripMenuItem.Size = new System.Drawing.Size(44, 20);
            this.helpToolStripMenuItem.Text = "Help";
            // 
            // checkUpdateToolStripMenuItem
            // 
            this.checkUpdateToolStripMenuItem.Name = "checkUpdateToolStripMenuItem";
            this.checkUpdateToolStripMenuItem.Size = new System.Drawing.Size(148, 22);
            this.checkUpdateToolStripMenuItem.Text = "Check Update";
            // 
            // toolStripSeparator3
            // 
            this.toolStripSeparator3.Name = "toolStripSeparator3";
            this.toolStripSeparator3.Size = new System.Drawing.Size(145, 6);
            // 
            // aboutToolStripMenuItem
            // 
            this.aboutToolStripMenuItem.Image = ((System.Drawing.Image)(resources.GetObject("aboutToolStripMenuItem.Image")));
            this.aboutToolStripMenuItem.Name = "aboutToolStripMenuItem";
            this.aboutToolStripMenuItem.Size = new System.Drawing.Size(148, 22);
            this.aboutToolStripMenuItem.Text = "About";
            // 
            // toolStrip1
            // 
            this.toolStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripLoadProfileBtn,
            this.toolStripSaveBtn,
            this.toolStripAddSiteBtn,
            this.toolStripEditSiteBtn,
            this.toolStripRemoveSiteBtn,
            this.toolStripSeparator1,
            this.toolStripRunAllBtn,
            this.toolStripRunBtn,
            this.toolStripStopBtn,
            this.toolStripSeparator5,
            this.toolStripMonitorBtn,
            this.toolStripExitBtn});
            this.toolStrip1.Location = new System.Drawing.Point(0, 24);
            this.toolStrip1.Name = "toolStrip1";
            this.toolStrip1.Size = new System.Drawing.Size(393, 25);
            this.toolStrip1.TabIndex = 2;
            this.toolStrip1.Text = "IP 192.16.1.234";
            // 
            // toolStripLoadProfileBtn
            // 
            this.toolStripLoadProfileBtn.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripLoadProfileBtn.Image = ((System.Drawing.Image)(resources.GetObject("toolStripLoadProfileBtn.Image")));
            this.toolStripLoadProfileBtn.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripLoadProfileBtn.Name = "toolStripLoadProfileBtn";
            this.toolStripLoadProfileBtn.Size = new System.Drawing.Size(23, 22);
            this.toolStripLoadProfileBtn.Text = "Open Profile";
            this.toolStripLoadProfileBtn.Click += new System.EventHandler(this.toolStripLoadProfileBtn_Click);
            // 
            // toolStripSaveBtn
            // 
            this.toolStripSaveBtn.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripSaveBtn.Image = ((System.Drawing.Image)(resources.GetObject("toolStripSaveBtn.Image")));
            this.toolStripSaveBtn.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripSaveBtn.Name = "toolStripSaveBtn";
            this.toolStripSaveBtn.Size = new System.Drawing.Size(23, 22);
            this.toolStripSaveBtn.Text = "Save Profile";
            this.toolStripSaveBtn.Click += new System.EventHandler(this.toolStripSaveBtn_Click);
            // 
            // toolStripAddSiteBtn
            // 
            this.toolStripAddSiteBtn.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripAddSiteBtn.Image = ((System.Drawing.Image)(resources.GetObject("toolStripAddSiteBtn.Image")));
            this.toolStripAddSiteBtn.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripAddSiteBtn.Name = "toolStripAddSiteBtn";
            this.toolStripAddSiteBtn.Size = new System.Drawing.Size(23, 22);
            this.toolStripAddSiteBtn.Text = "Add Site";
            this.toolStripAddSiteBtn.Click += new System.EventHandler(this.toolStripAddSiteBtn_Click);
            // 
            // toolStripEditSiteBtn
            // 
            this.toolStripEditSiteBtn.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripEditSiteBtn.Image = ((System.Drawing.Image)(resources.GetObject("toolStripEditSiteBtn.Image")));
            this.toolStripEditSiteBtn.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripEditSiteBtn.Name = "toolStripEditSiteBtn";
            this.toolStripEditSiteBtn.Size = new System.Drawing.Size(23, 22);
            this.toolStripEditSiteBtn.Text = "Edit site";
            this.toolStripEditSiteBtn.Click += new System.EventHandler(this.toolStripEditSiteBtn_Click);
            // 
            // toolStripRemoveSiteBtn
            // 
            this.toolStripRemoveSiteBtn.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripRemoveSiteBtn.Image = ((System.Drawing.Image)(resources.GetObject("toolStripRemoveSiteBtn.Image")));
            this.toolStripRemoveSiteBtn.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripRemoveSiteBtn.Name = "toolStripRemoveSiteBtn";
            this.toolStripRemoveSiteBtn.Size = new System.Drawing.Size(23, 22);
            this.toolStripRemoveSiteBtn.Text = "Remove Site";
            this.toolStripRemoveSiteBtn.Click += new System.EventHandler(this.toolStripRemoveSiteBtn_Click);
            // 
            // toolStripSeparator1
            // 
            this.toolStripSeparator1.Name = "toolStripSeparator1";
            this.toolStripSeparator1.Size = new System.Drawing.Size(6, 25);
            // 
            // toolStripRunAllBtn
            // 
            this.toolStripRunAllBtn.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripRunAllBtn.Image = ((System.Drawing.Image)(resources.GetObject("toolStripRunAllBtn.Image")));
            this.toolStripRunAllBtn.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripRunAllBtn.Name = "toolStripRunAllBtn";
            this.toolStripRunAllBtn.Size = new System.Drawing.Size(23, 22);
            this.toolStripRunAllBtn.Text = "Run All";
            this.toolStripRunAllBtn.Click += new System.EventHandler(this.toolStripRunAllBtn_Click);
            // 
            // toolStripRunBtn
            // 
            this.toolStripRunBtn.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripRunBtn.Image = ((System.Drawing.Image)(resources.GetObject("toolStripRunBtn.Image")));
            this.toolStripRunBtn.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripRunBtn.Name = "toolStripRunBtn";
            this.toolStripRunBtn.Size = new System.Drawing.Size(23, 22);
            this.toolStripRunBtn.Text = "Run";
            this.toolStripRunBtn.Click += new System.EventHandler(this.toolStripRunBtn_Click);
            // 
            // toolStripStopBtn
            // 
            this.toolStripStopBtn.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripStopBtn.Image = ((System.Drawing.Image)(resources.GetObject("toolStripStopBtn.Image")));
            this.toolStripStopBtn.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripStopBtn.Name = "toolStripStopBtn";
            this.toolStripStopBtn.Size = new System.Drawing.Size(23, 22);
            this.toolStripStopBtn.Text = "Stop";
            this.toolStripStopBtn.Click += new System.EventHandler(this.toolStripStopBtn_Click);
            // 
            // toolStripSeparator5
            // 
            this.toolStripSeparator5.Name = "toolStripSeparator5";
            this.toolStripSeparator5.Size = new System.Drawing.Size(6, 25);
            // 
            // toolStripMonitorBtn
            // 
            this.toolStripMonitorBtn.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripMonitorBtn.Image = ((System.Drawing.Image)(resources.GetObject("toolStripMonitorBtn.Image")));
            this.toolStripMonitorBtn.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripMonitorBtn.Name = "toolStripMonitorBtn";
            this.toolStripMonitorBtn.Size = new System.Drawing.Size(23, 22);
            this.toolStripMonitorBtn.Text = "Monitor";
            this.toolStripMonitorBtn.Click += new System.EventHandler(this.toolStripButton1_Click);
            // 
            // toolStripExitBtn
            // 
            this.toolStripExitBtn.DisplayStyle = System.Windows.Forms.ToolStripItemDisplayStyle.Image;
            this.toolStripExitBtn.Image = ((System.Drawing.Image)(resources.GetObject("toolStripExitBtn.Image")));
            this.toolStripExitBtn.ImageTransparentColor = System.Drawing.Color.Magenta;
            this.toolStripExitBtn.Name = "toolStripExitBtn";
            this.toolStripExitBtn.Size = new System.Drawing.Size(23, 22);
            this.toolStripExitBtn.Text = "Exit";
            this.toolStripExitBtn.Click += new System.EventHandler(this.toolStripExitBtn_Click);
            // 
            // statusStrip1
            // 
            this.statusStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.toolStripStatusIP,
            this.toolStripStatusFileProfile});
            this.statusStrip1.Location = new System.Drawing.Point(0, 153);
            this.statusStrip1.Name = "statusStrip1";
            this.statusStrip1.Size = new System.Drawing.Size(393, 22);
            this.statusStrip1.TabIndex = 3;
            this.statusStrip1.Text = "statusStrip1";
            // 
            // toolStripStatusIP
            // 
            this.toolStripStatusIP.Name = "toolStripStatusIP";
            this.toolStripStatusIP.Size = new System.Drawing.Size(83, 17);
            this.toolStripStatusIP.Text = "IP 192.14.34.68";
            this.toolStripStatusIP.Click += new System.EventHandler(this.toolStripStatusLabel1_Click);
            // 
            // toolStripStatusFileProfile
            // 
            this.toolStripStatusFileProfile.Name = "toolStripStatusFileProfile";
            this.toolStripStatusFileProfile.Size = new System.Drawing.Size(118, 17);
            this.toolStripStatusFileProfile.Text = "toolStripStatusLabel2";
            // 
            // listView1
            // 
            this.listView1.AllowColumnReorder = true;
            this.listView1.Columns.AddRange(new System.Windows.Forms.ColumnHeader[] {
            this.site,
            this.userName,
            this.password,
            this.status,
            this.amount});
            this.listView1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.listView1.FullRowSelect = true;
            this.listView1.GridLines = true;
            this.listView1.HeaderStyle = System.Windows.Forms.ColumnHeaderStyle.Nonclickable;
            this.listView1.HideSelection = false;
            this.listView1.Location = new System.Drawing.Point(0, 49);
            this.listView1.Name = "listView1";
            this.listView1.Size = new System.Drawing.Size(393, 104);
            this.listView1.TabIndex = 6;
            this.listView1.UseCompatibleStateImageBehavior = false;
            this.listView1.View = System.Windows.Forms.View.Details;
            // 
            // site
            // 
            this.site.Text = "Site";
            this.site.Width = 150;
            // 
            // userName
            // 
            this.userName.Text = "User";
            this.userName.Width = 150;
            // 
            // password
            // 
            this.password.DisplayIndex = 4;
            this.password.Text = "Password";
            this.password.Width = 0;
            // 
            // status
            // 
            this.status.DisplayIndex = 2;
            this.status.Text = "Status";
            this.status.Width = 88;
            // 
            // amount
            // 
            this.amount.DisplayIndex = 3;
            this.amount.Text = "Estimate Amount";
            this.amount.Width = 0;
            // 
            // saveFileAsDialog
            // 
            this.saveFileAsDialog.Filter = "Buxtool Profile|*.btp";
            // 
            // openFileDialog1
            // 
            this.openFileDialog1.Filter = "Buxtoo Profile File|*.btp";
            // 
            // newProfileFileDialog
            // 
            this.newProfileFileDialog.Filter = "Buxtool Profile|*.btp";
            // 
            // MainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(393, 175);
            this.Controls.Add(this.listView1);
            this.Controls.Add(this.statusStrip1);
            this.Controls.Add(this.toolStrip1);
            this.Controls.Add(this.menuStrip1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.MainMenuStrip = this.menuStrip1;
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "MainForm";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Buxtool 2014";
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.MainForm_FormClosed);
            this.menuStrip1.ResumeLayout(false);
            this.menuStrip1.PerformLayout();
            this.toolStrip1.ResumeLayout(false);
            this.toolStrip1.PerformLayout();
            this.statusStrip1.ResumeLayout(false);
            this.statusStrip1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();
            

        }

        #endregion

        private System.Windows.Forms.ContextMenuStrip contextMenuStrip1;
        private System.Windows.Forms.MenuStrip menuStrip1;
        private System.Windows.Forms.ToolStripMenuItem helpToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem checkUpdateToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem aboutToolStripMenuItem;
        private System.Windows.Forms.ToolStrip toolStrip1;
        private System.Windows.Forms.StatusStrip statusStrip1;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusIP;
        private System.Windows.Forms.ToolStripMenuItem fileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem newToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem openProfileToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem exitToolStripMenuItem;
        private System.Windows.Forms.ToolStripButton toolStripRunBtn;
        private System.Windows.Forms.ToolStripButton toolStripStopBtn;
        private System.Windows.Forms.ToolStripMenuItem saveToolStripMenuItem;
        private System.Windows.Forms.ToolStripMenuItem saveAsToolStripMenuItem;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator2;
        private System.Windows.Forms.ToolStripButton toolStripLoadProfileBtn;
        private System.Windows.Forms.ToolStripButton toolStripSaveBtn;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator1;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator3;
        private System.Windows.Forms.ColumnHeader site;
        private System.Windows.Forms.ColumnHeader userName;
        private System.Windows.Forms.ColumnHeader status;
        private System.Windows.Forms.ColumnHeader amount;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator4;
        private System.Windows.Forms.ToolStripMenuItem addSiteToolStripMenuItem;
        private System.Windows.Forms.ToolStripButton toolStripAddSiteBtn;
        private System.Windows.Forms.ToolStripButton toolStripRemoveSiteBtn;
        private System.Windows.Forms.ColumnHeader password;
        private System.Windows.Forms.ToolStripButton toolStripRunAllBtn;
        private System.Windows.Forms.ToolStripSeparator toolStripSeparator5;
        private System.Windows.Forms.ToolStripButton toolStripExitBtn;
        private System.Windows.Forms.ToolStripButton toolStripEditSiteBtn;
        private System.Windows.Forms.ToolStripStatusLabel toolStripStatusFileProfile;
        private System.Windows.Forms.SaveFileDialog saveFileAsDialog;
        private System.Windows.Forms.OpenFileDialog openFileDialog1;
        private System.Windows.Forms.SaveFileDialog newProfileFileDialog;
        private System.Windows.Forms.ToolStripButton toolStripMonitorBtn;
        public System.Windows.Forms.ListView listView1;

       // public System.EventHandler listView1_SelectedIndexChanged { get; set; }


        public object MainForm_Closing { get; set; }
    }
}

