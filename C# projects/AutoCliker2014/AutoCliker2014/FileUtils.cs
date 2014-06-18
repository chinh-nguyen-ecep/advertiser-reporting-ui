using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Serialization;
using System.IO;
using System.Windows.Forms;
using System.Runtime.Serialization.Formatters.Binary;

namespace AutoCliker2014
{
    class FileUtils
    {
        /// <summary>
        /// Serializes an object.
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="serializableObject"></param>
        /// <param name="fileName"></param>
        public static void SerializeObject<T>(T serializableObject, string fileName)
        {
            if (serializableObject == null) { return; }

            try
            {
                FileStream stream = File.Create(fileName);
                BinaryFormatter formatter = new BinaryFormatter();
                Console.WriteLine("Serializing vector");
                formatter.Serialize(stream, serializableObject);
                stream.Close();
            }
            catch (Exception ex)
            {
                //Log exception here
                MessageBox.Show(ex.Message, "Save file error!");
            }
        }


        /// <summary>
        /// Deserializes an xml file into an object list
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="fileName"></param>
        /// <returns></returns>
        public static T DeSerializeObject<T>(string fileName)
        {
            if (string.IsNullOrEmpty(fileName)) { return default(T); }

            T objectOut = default(T);

            try
            {
                FileStream stream = File.OpenRead(fileName);
                BinaryFormatter formatter = new BinaryFormatter();
                objectOut = (T)formatter.Deserialize(stream);
                stream.Close();
            }
            catch (Exception ex)
            {
                //Log exception here
                MessageBox.Show(ex.Message, "Load file error!");
            }

            return objectOut;
        }
    }
}
