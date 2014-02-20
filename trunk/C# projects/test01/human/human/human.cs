using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;

namespace human
{
    public abstract class human
    {
        string _language = "";
        public human()
        {
            _language = "";
        }

        public human(string language)
        {
            _language = language;
        }

        public abstract string hello();

        public abstract string goodbye();
        public static human loadDLL(string dllName) {
            human result=null;
            string startupPath = System.IO.Directory.GetCurrentDirectory();
            Assembly assembly = Assembly.LoadFrom(startupPath + "\\lib\\" + dllName + ".dll");
            string fullTypeName = dllName+"."+dllName;
            result = (human)assembly.CreateInstance(fullTypeName);
            return result;
        }
    }
}
