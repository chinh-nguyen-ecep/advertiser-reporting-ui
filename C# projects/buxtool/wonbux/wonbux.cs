using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace wonbux
{
    public class wonbux:buxscript.buxscript
    {
     
        public override string address()
        {
            return "http://wonbux.com";
        }
        public override string name()
        {
            return "Wonbux";
        }
        public override string dllFileName()
        {
            return "wonbux";
        }
        public override void start()
        {
            listViewItem.SubItems[5].Text = "Running :)";
        }
        public override void stop()
        {
            listViewItem.SubItems[5].Text = "Stopped :)";
        }
    }
}
