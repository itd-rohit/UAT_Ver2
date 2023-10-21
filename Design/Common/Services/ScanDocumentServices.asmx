<%@ WebService Language="C#" Class="ScanDocumentServices" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using Newtonsoft.Json;
using System.Data;
using System.Linq;
using System.Collections.Generic;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class ScanDocumentServices : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    public string GetShareScanners()
    {
        try
        {
            ScanDocument scanDocument = new ScanDocument();
            return JsonConvert.SerializeObject(new { status = true, data = scanDocument.GetScanners() });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }

    }

    [WebMethod]
    public string Scan(string deviceID)
    {
        try
        {
            ScanDocument scanDocument = new ScanDocument();
            var path = "D:\\";
            var fileName = "abc";
            var response = scanDocument.ScanDoc(deviceID, "abc", "D:\\");
            if (response == "ok")
            {
                var fileData = System.IO.File.ReadAllBytes(path + "\\" + fileName + ".jpeg");
                return JsonConvert.SerializeObject(new { status = true, data = Convert.ToBase64String(fileData) });
            }
            else
                return JsonConvert.SerializeObject(new { status = false, data = response });

        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }

    }


    [WebMethod]
    public string GetMasterDocuments(string patientID)
    {
        try
        {
            var patientDocumentMasters = StockReports.GetDataTable("SELECT dm.ID,dm.Name FROM document_master dm WHERE isActive=1 ORDER BY Name").AsEnumerable().Select(i => new
            {
                ID = i.Field<int>("ID"),
                Name = i.Field<string>("Name")
            }).ToList();



            var directoryPath = new System.IO.DirectoryInfo(string.Concat(Resources.Resource.DocumentPath, "\\UploadedDocument\\", patientID.Replace("/", "_")));
            if (directoryPath.Exists == false)
                directoryPath.Create();
            List<object> patientDocuments = new List<object>();
            patientDocumentMasters.ForEach(i =>
            {
                var files = System.IO.Directory.GetFiles(directoryPath.ToString(), i.Name.Replace('/', '-') + "*");
                var document = new { Name = i.Name, ID = i.ID, ExitsCount = files.Length };
                patientDocuments.Add(document);
            });
            return JsonConvert.SerializeObject(new { status = true, patientDocumentMasters = patientDocuments });

        }
        catch (Exception ex)
        {

            return JsonConvert.SerializeObject(new { status = false, response = "Please Create " + Resources.Resource.DocumentDriveName + " Drive", errorMessage = ex.Message });
        }
    }

    [WebMethod]
    public string GetDocument(string patientId, string documentName)
    {
        try
        {

            var directoryPath = new System.IO.DirectoryInfo(string.Concat(Resources.Resource.DocumentPath, "\\PatientDocument\\", patientId.Replace("/", "_")));


            if (directoryPath.Exists == false)
                directoryPath.Create();



            string Url = System.IO.Path.Combine(directoryPath + "\\" + documentName.Replace('/', '-') + ".jpeg");

            var fileData = System.IO.File.ReadAllBytes(Url);
            return JsonConvert.SerializeObject(new { status = true, data = string.Format("data:image/jpeg;base64,{0}", Convert.ToBase64String(fileData)) });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }

    }

    [WebMethod]
    public string GetPanelDocument(string panelID, string documentName)
    {
        try
        {

            var directoryPath = new System.IO.DirectoryInfo(string.Concat(Resources.Resource.DocumentPath, "\\PanelUploadedFiles\\", panelID.Replace("/", "_")));


            if (directoryPath.Exists == false)
                directoryPath.Create();



            string Url = System.IO.Path.Combine(directoryPath + "\\" + documentName.Replace('/', '-') + ".jpeg");

            var fileData = System.IO.File.ReadAllBytes(Url);
            return JsonConvert.SerializeObject(new { status = true, data = string.Format("data:image/jpeg;base64,{0}", Convert.ToBase64String(fileData)) });
        }
        catch (Exception ex)
        {
            return JsonConvert.SerializeObject(new { status = false, message = ex.Message });
        }

    }
    

    [WebMethod]
    public bool SaveScanFile(string ID, string patientID, string documentID, string documentName, string documentFileType, string base64Document, string savePath)
    {
        try
        {
            System.IO.File.WriteAllBytes(savePath, Convert.FromBase64String(base64Document));
            return true;
        }
        catch (Exception)
        {

            return false;
        }

    }


}