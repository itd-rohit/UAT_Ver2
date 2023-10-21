<%@ WebService Language="C#" Class="CallCenter" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.IO;
using System.Text;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
 [System.Web.Script.Services.ScriptService]
public class CallCenter  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }
    [WebMethod]
    public string BindGroup()
    {
        return Util.getJson(StockReports.GetDataTable("  SELECT GroupID,GroupName FROM `cutomercare_Group_master` WHERE IsActive=1 ORDER BY GroupName "));

    }
    [WebMethod]
    public string BindCategory(string GroupID)
    {
        return Util.getJson(StockReports.GetDataTable("  SELECT ID,CategoryName FROM `cutomercare_category_master` WHERE IsActive=1 and GroupID='" + GroupID + "' ORDER BY CategoryName "));

    }
    [WebMethod]
    public string BindSubCategory(int CategoryID)
    {
        return Util.getJson(StockReports.GetDataTable("  SELECT ID,SubCategoryName FROM `cutomercare_subcategory_master` WHERE IsActive=1 AND CategoryID='" + CategoryID + "' ORDER BY SubCategoryName "));

    }
    [WebMethod]
    public string BindPredefinedQueries(int GroupID, int CategoryID, int SubCategoryID)
    {
        return Util.getJson(StockReports.GetDataTable("  SELECT ID,Subject FROM `Inquiry_Master` WHERE IsActive=1 AND Type='Query' AND GroupID='" + GroupID + "' AND CategoryID='" + CategoryID + "' AND SubCategoryID='" + SubCategoryID + "' ORDER BY Subject "));

    }
      [WebMethod(EnableSession=true)]
    public string UploadImage(string imageData, string FileName)
    { 
 imageData=imageData.Replace("data:image/octet-stream;base64,","");
        string RootDir = Server.MapPath("~/CallCenterDocument");
        
        string FilePath = FileName + ".png";
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        RootDir = RootDir + @"\" + DateTime.Now.ToString("yyyyMMdd");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);        
        try
        {
            StringBuilder sb = new StringBuilder();          
            sb.Append(" INSERT INTO  support_uploadedfile (TicketId,ReplyID,TempID,CreatedByID,CreatedBy,filename,FileExt,FilePath) VALUES ( ");
            sb.Append(" '0', '0' ,'" + FileName + "','" + UserInfo.ID + "','" + UserInfo.LoginName + " ','" + FileName + "','.png','" + FilePath + "') ");

            StockReports.ExecuteDML(sb.ToString());

            string fileNameWitPath = RootDir+ @"\"+ FileName + ".png";
            using (System.IO.FileStream fs = new System.IO.FileStream(fileNameWitPath, System.IO.FileMode.Create))
            {
                using (System.IO.BinaryWriter bw = new System.IO.BinaryWriter(fs))
                {
                    byte[] data = Convert.FromBase64String(imageData);
                   // bw.Write(data);
bw.Write(data,0,data.Length);
                    bw.Close();
bw.Dispose();
                }
            }
            return "1";
        }
        catch (Exception ex)
        {
ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        
       
    }
      [WebMethod(EnableSession=true)]
    public string DeleteImage(string FileName)
    {
         try
        {
        string RootDir = Server.MapPath("~/CallCenterDocument");
        string FilePath = FileName + ".png";
        if (Directory.Exists(RootDir))
        { 
            RootDir = RootDir + @"\" + DateTime.Now.ToString("yyyyMMdd");
            if (Directory.Exists(RootDir))
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("delete from support_uploadedfile where filename='" + FileName + "' and CreatedByID='" + UserInfo.ID + "' and FilePath='" + FilePath + "' and FileExt='.png'  ");
               StockReports.ExecuteDML(sb.ToString());
                string fileNameWitPath = RootDir + @"\" + FileName + ".png";
               System.IO.File.Delete(fileNameWitPath);
                return "1";
            }
            else
                return "0";
        }
        else
            return "0";  
        }
        catch (Exception ex)
        {
ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    [WebMethod]
    public string BindDepartment()
    {
        return Util.getJson(StockReports.GetDataTable("  SELECT DepartmentID,DepartmentName FROM `cutomercare_department_master` WHERE IsActive=1   ORDER BY DepartmentName "));
    }
}