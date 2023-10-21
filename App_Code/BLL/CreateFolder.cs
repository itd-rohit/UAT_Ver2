using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
/// <summary>
/// Summary description for CreateFolder
/// </summary>
public class CreateFolder
{
	public CreateFolder()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public void CreateNewFolder(string _Data, string FolderName, string subFolderName="")
    {
        FileStream fs;
        StreamWriter sw;
        string RootDir = string.Concat(Util.getApp("ClientImagePath"), "\\BookingAPI\\" + FolderName + "\\");
        if(subFolderName!=string.Empty)
            RootDir = string.Concat(RootDir, FolderName, "\\", subFolderName, "\\");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        string filepath = string.Concat(RootDir, System.DateTime.Now.ToString("yyyy-MMM-dd"), "\\");
        if (!Directory.Exists(filepath))
            Directory.CreateDirectory(filepath);
        if (subFolderName == string.Empty)
        {
            if (System.IO.File.Exists(string.Concat(filepath, FolderName, ".txt")))
            {
                sw = System.IO.File.AppendText(string.Concat(filepath, FolderName, ".txt"));
                sw.WriteLine("\n");
                sw.WriteLine("  **********************************************************  ");
                sw.WriteLine(_Data);
                sw.Close();
            }
            else
            {
                System.IO.Directory.CreateDirectory(filepath);
                fs = System.IO.File.Create(string.Concat(filepath, FolderName, ".txt"));
                sw = new System.IO.StreamWriter(fs);
                sw.WriteLine("  **********************************************************  ");
                sw.WriteLine(_Data);
                sw.Close();
                fs.Close();
            }
        }
        else
        {
            if (System.IO.File.Exists(string.Concat(filepath, subFolderName, ".txt")))
            {
                sw = System.IO.File.AppendText(string.Concat(filepath, subFolderName, ".txt"));
                sw.WriteLine("\n");
                sw.WriteLine("  **********************************************************  ");
                sw.WriteLine(_Data);
                sw.Close();
            }
            else
            {
                System.IO.Directory.CreateDirectory(filepath);
                fs = System.IO.File.Create(string.Concat(filepath, subFolderName, ".txt"));
                sw = new System.IO.StreamWriter(fs);
                sw.WriteLine("  **********************************************************  ");
                sw.WriteLine(_Data);
                sw.Close();
                fs.Close();
            }
        }
       
       
       
    }
}