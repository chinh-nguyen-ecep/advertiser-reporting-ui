using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
namespace buxtool
{
    class ProfileControl
    {
        public static ListView listView;
        public static string profilePathDefault = System.IO.Directory.GetCurrentDirectory()+"\\profile.btp";
        //public string profilePath = "d:\\profile.xml";

        public static void loadProfile(string path) {
            if (!System.IO.File.Exists(path))
            {
                path = profilePathDefault;
                saveAs(path);
            }
            listView.Items.Clear();
            List<string[]> array = FileUtils.DeSerializeObject<List<string[]>>(path);
            arrayToListView(array);
            profilePathDefault = path;

            ConfigureControl.configureInfo.lastFileProfile = profilePathDefault;
        }
        public static void save() {
            FileUtils.SerializeObject(listViewToArray(listView), profilePathDefault);
            
        }
        public static void saveAs(string path) {            
            FileUtils.SerializeObject(listViewToArray(listView), path);
            loadProfile(path);
        }
        public static void newProfile(string path) {
            save();
            listView.Items.Clear();
            saveAs(path);
            ConfigureControl.configureInfo.lastFileProfile = path;
        }
        private static List<string[]> listViewToArray(ListView listView) {
            List<string[]> array = new List<string[]>();
            foreach (ListViewItem item in listView.Items)
            {
                string[] subItems = new string[item.SubItems.Count];
                for (int i = 0; i < subItems.Length; i++)
                {
                    subItems[i] = item.SubItems[i].Text;
                }
                array.Add(subItems);
            }
            return array;
        }
        private static void arrayToListView(List<string[]> array) {
            string[][] myArray = array.ToArray();
            foreach (string[] item in myArray)
            {
                item[5] = "";
                ListViewItem listViewItem = new ListViewItem(item);
                
                listView.Items.Add(listViewItem);
            }
        }

    }
}
