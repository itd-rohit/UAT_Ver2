<%@ WebService Language="C#" Class="PathcareAppAPI" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using System.IO;

[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class PathcareAppAPI : System.Web.Services.WebService
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }

    public class PROAcces
    {
        public string Login(string UserName, string Password)
        {
            try
            {
                string CentreID = "";
                int InvalidPassword = 0;
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                InvalidPassword = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select InvalidPassword from f_login where UserName=@UserName and InvalidPassword>=3",
                    new MySqlParameter("@UserName", UserName.Trim())));
                con.Close();
                con.Dispose();
                if (InvalidPassword >= 3)
                {
                    return "0" + "#" + "You have exceeded the number of allowed login attempts.\\nYou will be redirect to verify your login.";
                }
                StringBuilder sb = new StringBuilder();
                sb.Append("select (select datediff(now(), ifnull(max(f2.CurLoginTime),now())) LastLogin from f_login f2 where f2.EmployeeID = em.Employee_ID)LastLogin  ,(SELECT DATEDIFF(NOW(), IFNULL(MAX(f2.lastpass_dt),NOW())) Lastpassin FROM f_login f2 WHERE f2.EmployeeID = em.Employee_ID)Lastpassin  ,cm.Centre,fl.EmployeeID,fl.UserName,fl.IsTPassword,fl.TPassword,em.name EmpName,em.AccessDepartment,fl.RoleID,rm.RoleName,(SELECT COUNT(*) FROM `f_panel_master` WHERE employeeID=fl.`EmployeeID`) PanelLogin,fl.InvalidPassword,fl.CentreID,rm.PrintFlag ,ifnull(em.ipfrom,0) ipfrom,ifnull(em.ipto,0) ipto");
                sb.Append("   from f_login fl inner join employee_master em on fl.EmployeeID = em.Employee_ID ");
                sb.Append("  INNER JOIN centre_master cm ON cm.CentreID=fl.CentreID INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID  where fl.Active = 1 and em.IsActive=1 ");
                sb.Append(" and PASSWORD(LOWER(fl.UserName)) = PASSWORD(LOWER(@Username)) and PASSWORD(LOWER(fl.Password)) = PASSWORD(LOWER(@Password))   ORDER BY fl.isDefault desc");
                DataTable dt = new DataTable();
                dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
                new MySql.Data.MySqlClient.MySqlParameter("@Username", UserName.Trim()),
                new MySql.Data.MySqlClient.MySqlParameter("@Password", Password.Trim())).Tables[0];
                int days = 0;
                if (dt.Rows.Count > 0)
                {
                    
                        CentreID = Util.GetString(dt.Rows[0]["CentreID"]);
                        days = Util.GetInt(dt.Rows[0]["Lastpassin"].ToString());
                        HttpContext.Current.Session["LoginType"] = Util.GetString(dt.Rows[0]["RoleName"]);
                        HttpContext.Current.Session["UserName"] = UserName.Trim();
                        string ID = Util.GetString(dt.Rows[0]["EmployeeID"]);
                        HttpContext.Current.Session["LoginName"] = Util.GetString(dt.Rows[0]["EmpName"]);
                        HttpContext.Current.Session["CentreName"] = Util.GetString(dt.Rows[0]["Centre"]);
                        string ConcatInfo = ID + "@" + Util.GetString(dt.Rows[0]["EmpName"]) + "@" + UserName.Trim() + "@" + Util.GetString(dt.Rows[0]["Centre"]) + "@" + CentreID;
                        return "1" + "#" + ID + "#" + ConcatInfo;
                   
                }
                else
                {
                    return "0" + "#" + "Wrong UserID/Password";
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return "-1" + "#" + "There are techinal Error";
            }
        }

    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string chkLogin(string _UserId, string _Password)
    {
        string result = "0";
        PROAcces pro = new PROAcces();
        try
        {
            result = pro.Login(_UserId, _Password);
            if (result.Split('#')[0].ToString() == "1")
            {
                return @"[{'result':'" + result.Split('#')[0].ToString() + "','message':'Success','ID':'" + result.Split('#')[1].ToString() + "','Info':'" + result.Split('#')[2].ToString() + "'}]";
            }
            else
            {
                return @"[{'result':'" + result.Split('#')[0].ToString() + "','message':'" + result.Split('#')[1].ToString() + "'}]";
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return @"[{'result':'0','message':'" + ex.Message + "'}]";
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetPatientDetails(string BarcodeNo)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT CONCAT(pm.`Title`,'',pm.`PName`) PatientName, pm.`Age`,LPAD(pm.`Gender`,1,1) Gender,lt.`LedgerTransactionNo` RegNo,
                         DATE_FORMAT(lt.`Date`,'%d-%b-%y') `date`, group_concat(im.`Name`) TestName,
                         fpm.`Company_Name` PccName, fpm.`Panel_Code` PccCode FROM patient_Labinvestigation_OPD plo 
                         INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo`
                         INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`
                         INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID`
                         INNER JOIN investigation_master im ON im.`Investigation_Id`=plo.`Investigation_ID`
                         WHERE plo.`barcodeNo`='" + BarcodeNo + "' group by  lt.LedgerTransactionNo");

            DataTable _dtPRODetails = StockReports.GetDataTable(sb.ToString());
            if (_dtPRODetails.Rows.Count > 0)
            {
                return makejsonoftable(_dtPRODetails, makejson.e_with_square_brackets);
            }
            else
            {
                string result = @"[]";
                return result;
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            string result = @"[]";
            return result;
        }
    }
	[WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetDocument(string BarcodeNo)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT ID,NAME FROM document_master WHERE isactive=1");

            DataTable _dtPRODetails = StockReports.GetDataTable(sb.ToString());
            if (_dtPRODetails.Rows.Count > 0)
            {
                return makejsonoftable(_dtPRODetails, makejson.e_with_square_brackets);
            }
            else
            {
                string result = @"[]";
                return result;
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            string result = @"[]";
            return result;
        }
    }





    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string GetImageDetails(string LabNo)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT id,CONCAT('http://itd-saas.cl-srv.ondgni.com/UAT_Ver1/Uploaded%20Document','/',DATE_FORMAT(DATE,'%Y%m%d'),'/',filename) fileurl,createdbyid UploadedBy,DATE_FORMAT(DATE,'%d-%b-%y  %r')  dtEntry,DocumentName ");
            if (LabNo == "")
            {
                sb.Append(" FROM document_detail WHERE labno='' ");
            }
            else
            {
                sb.Append(" FROM document_detail WHERE labno='" + LabNo + "' ");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                return makejsonoftable(dt, makejson.e_with_square_brackets);
            }
            else
            {
                string result = @"[]";
                return result;
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            string result = @"[]";
            return result;
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string DeleteImages(string Id, string fileurl, string LabNo)
    {
        try
        {

            string RootDir = Server.MapPath("~/Uploaded Document");
            if (File.Exists(RootDir + fileurl))
            {
                File.Delete(RootDir + fileurl);
            }
            StockReports.ExecuteDML("delete from document_detail where id='" + Id + "'");
            return @"[{'result':'1','message':'Delete Successfully'}]";
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return @"[{'result':'0','message':'" + ex.Message + "'}]";
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public string InsertImages(string ddldoctypeID, string ddldoctypeText, string labno, string images, string Info)
    {
        if (ddldoctypeID == "0")
        {
            return "Please Select Doc Type";

        }


        string RootDir = "";
        RootDir = Server.MapPath("~/Uploaded Document");
        // RootDir =  @"D:\Test";
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);



        RootDir = RootDir + @"\" + DateTime.Now.ToString("yyyyMMdd");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        //string fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);
        //string FileName = Filename;

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string[] Len = images.Split(',');

            for (int i = 0; i < Len.Length; i++)
            {
                string Filename = "";

                Filename = labno + "_" + DateTime.Now.ToString("yyyyMMddhhmmss") + "_" + i.ToString() + ".jpg";

                StringBuilder sb = new StringBuilder();
                if (labno == "")
                {
                    sb.Append(" INSERT INTO  document_detail (IsMobileUpload,documentid,documentname,labno,patientid,CreatedByID,createdDATE,date,filename,isactive,isdefault) VALUES ");
                    sb.Append(" (1,'" + ddldoctypeID + "','" + ddldoctypeText + "','','','" + Info.Split('@')[1] + " ',now(),now(),'" + Filename + "' ,'1','1') ");
                }
                else
                {
                    string PatientID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select Patient_Id from f_ledgertransaction where LedgerTransactionNo='" + labno + "'"));
                    sb.Append(" INSERT INTO  document_detail (IsMobileUpload,documentid,documentname,labno,patientid,CreatedByID,createdDATE,date,filename,isactive,isdefault) VALUES ");
                    sb.Append(" (1,'" + ddldoctypeID + "','" + ddldoctypeText + "','" + labno + "','" + PatientID + "','" + Info.Split('@')[1] + " ',now(),now(),'" + Filename + "' ,'1','1') ");
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                byte[] photo = Convert.FromBase64String(images.Split(',')[i].Replace(" ", "+"));
                FileStream fs = new FileStream(RootDir + @"\" + Filename, FileMode.OpenOrCreate, FileAccess.Write);
                BinaryWriter br = new BinaryWriter(fs);
                br.Write(photo);
                br.Flush();
                br.Close();
                fs.Close();
            }


            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();

            return @"[{'result':'1','message':'Uploaded Successfully'}]";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return @"[{'result':'0','message':'" + ex + "'}]";
        }
    }


    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("\"{0}\":\"{1}\"", fieldname, fieldvalue.Replace("\n", "<br/>").Replace("\r", "<br/>")));


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    }
}