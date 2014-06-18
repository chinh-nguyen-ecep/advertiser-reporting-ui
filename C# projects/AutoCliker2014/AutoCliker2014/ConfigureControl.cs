using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AutoCliker2014
{
    class ConfigureControl
    {
        public static ConfigureInfo configureInfo;
        private static string path = System.IO.Directory.GetCurrentDirectory() + "\\config.dat";

        public static void saveConfig()
        {
            FileUtils.SerializeObject(configureInfo, path);
        }
        public static void saveNewConfig()
        {
            configureInfo = new ConfigureInfo();
            FileUtils.SerializeObject(configureInfo, path);
        }
        public static void loadConfig()
        {
            if (!System.IO.File.Exists(path))
            {
                saveNewConfig();
            }
            configureInfo = FileUtils.DeSerializeObject<ConfigureInfo>(path);
        }
    }
    [Serializable()]
    class ConfigureInfo
    {
        public string neoBuxUserName="";
        public string neoBuxPassword="";
        public Boolean neoBuxActive=false;
        public string buxToUserName="";
        public string buxToPassword="";
        public Boolean buxToActive=false;
        public ConfigureInfo()
        {
            
        }
    }
}
