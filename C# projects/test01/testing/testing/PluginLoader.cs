using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.IO;

namespace testing
{
    class PluginLoader
    {
        public static human.human[] load() {
            human.human[] result=null;
            //Load dll
            string startupPath = System.IO.Directory.GetCurrentDirectory();
            string[] filePaths = Directory.GetFiles(startupPath + "\\lib", "*.dll");
            result=new human.human[filePaths.Length];
            int i = 0;
            foreach (string file in filePaths)
            {
                FileInfo fi = new FileInfo(file);
                string dllName = fi.Name.Split('.')[0];
                //MessageBox.Show(dllName);
                human.human a = human.human.loadDLL(dllName);
                result[i]=a;
                i++;
            }
            return result;
        }
    }
}
