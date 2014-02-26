using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace buxtool
{
    class ConfigureControl
    {
        public static ConfigureInfo configureInfo;
        private static string path = System.IO.Directory.GetCurrentDirectory()+"\\config.dat";

        public static void saveConfig() {
            FileUtils.SerializeObject(configureInfo, path);
        }
        public static void saveNewConfig()
        {
            configureInfo = new ConfigureInfo();
            FileUtils.SerializeObject(configureInfo, path);
        }
        public static void loadConfig() {
            if(!System.IO.File.Exists(path)){
                saveNewConfig();
            }
            configureInfo = FileUtils.DeSerializeObject<ConfigureInfo>(path);
        }
    }
    [Serializable()] 
    class ConfigureInfo
    {
        public string lastFileProfile;
        public ConfigureInfo() {
            lastFileProfile = "";
        }
    }
}
