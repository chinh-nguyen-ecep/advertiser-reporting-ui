using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using System.Reflection;
using System.IO;

namespace testing
{
    static class Program
    {

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            //Application.Run(new Form1());
           
            human.human[] listOfHuman=PluginLoader.load();
            foreach(human.human a in listOfHuman){
                MessageBox.Show("" + a.hello() + "");
            }
            

        }

    }
}
