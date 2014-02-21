using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace neobux
{
    public class neobux:buxscript.buxscript
    {
        
        public override string address()
        {
            return "http://neobux.com";
        }
        public override string dllFileName()
        {
            return "neobux";
        }
        public override string name()
        {
            return "Neobux";
        }
        public override void start()
        {
            this.listViewItem.SubItems[5].Text = "Starting";
            return;
        }
        public override void stop()
        {
            this.listViewItem.SubItems[5].Text = "Stopped";
        }
    }
}
