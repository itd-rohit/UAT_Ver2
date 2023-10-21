using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;
using System.IO;

/// <summary>
/// Summary description for PatientDocuments
/// </summary>
public static class PatientDocument
{
    



    public static void SaveDocument(object patientDocuments, string patientID)
    {
        try
        {
            if (string.IsNullOrEmpty(patientID))
                return;


            List<PatientDocuments> patientDocumentsDetails = new JavaScriptSerializer().ConvertToType<List<PatientDocuments>>(patientDocuments);
            if (patientDocumentsDetails.Count > 0)
            {
                var directoryPath = new System.IO.DirectoryInfo(string.Concat(Resources.Resource.DocumentPath, "\\PatientDocument\\", patientID.Replace("/", "_")));


                if (directoryPath.Exists == false)
                    directoryPath.Create();

                

                patientDocumentsDetails.ForEach(i =>
                {
                    string url = System.IO.Path.Combine(directoryPath + "\\" + i.name.Replace('/', '-') + ".jpeg");
                    if (File.Exists(url))
                    {
                        var files = Directory.GetFiles(directoryPath.ToString(), i.name.Replace('/', '-') + "*");
                        File.Move(url, System.IO.Path.Combine(directoryPath + "\\" + i.name.Replace('/', '-') + files.Length + ".jpeg"));
                    }
                    var strImage = i.data.Replace(i.data.Split(',')[0] + ",", "");
                    System.IO.File.WriteAllBytes(url, Convert.FromBase64String(strImage));

                });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }

}