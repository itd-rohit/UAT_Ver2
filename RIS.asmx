<%@ WebService Language="C#" Class="RIS" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.IO;
using System.Data.Odbc;
using System.Text;
using MySql.Data.MySqlClient;

using cfg = System.Configuration.ConfigurationManager;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class RIS  : System.Web.Services.WebService {

    [WebMethod]
    public string HelloWorld() {
        return "Hello World";
    }

    [WebMethod]
    public DataSet dtPatientInfo(string Test_ID,string Investigation_ID,string LabNo,string AuthID,string Type)
    {
        DataSet ds = new DataSet();
        DataTable dt;
        DataRow dr;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            //select all available approval doctor list
            dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            sb.Append(@"SELECT DISTINCT em.Name NAME, fa.EmployeeID Employee_ID FROM f_approval_labemployee fa INNER JOIN employee_master em ON em.Employee_ID=fa.EmployeeID   
                       AND IF(fa.`TechnicalId`='',fa.`EmployeeID`,fa.`TechnicalId`)=@EmployeeID WHERE fa.Approval IN (5,4)  
                       ORDER BY fa.isDefault DESC,em.Name ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@EmployeeID", AuthID)).Tables[0];
            dt.TableName = "approval";
            dr = dt.NewRow();
            dt.Rows.InsertAt(dr, 0);

            ds.Tables.Add(dt.Copy());

            //load Patient Reports


            dt = new DataTable();
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "CALL sp_ReportData(@Test_ID)",
                new MySqlParameter("@Test_ID", Test_ID)).Tables[0];
            dt.TableName = "TestData";

            string filePath = cfg.AppSettings["WordReportPath"] + @"Reports\" + dt.Rows[0]["UploadPath"].ToString();
            if (!Directory.Exists(filePath))
                Directory.CreateDirectory(filePath);


            filePath += @"\" + Test_ID + ".doc";

            if (!File.Exists(filePath))
            {
                string Template_File = cfg.AppSettings["WordReportPath"] + @"Template\" + dt.Rows[0]["Investigation_ID"].ToString() + ".doc";

                if (File.Exists(Template_File))
                    File.Copy(Template_File, filePath, true);
                else
                    File.Copy(cfg.AppSettings["WordReportPath"] + @"Reports\Sample.doc", filePath, true);
            }
            if (dt.Rows.Count == 1)
            {
                dt.Columns.Add("ReportData", System.Type.GetType("System.Byte[]"));
                dt.Rows[0]["ReportData"] = GetBitmapBytes(filePath);

                dt.Columns.Add("HeaderImg", System.Type.GetType("System.Byte[]"));
                dt.Rows[0]["HeaderImg"] = GetBitmapBytes(cfg.AppSettings["WordReportPath"] + "Header.png");

                if (dt.Rows[0]["isApproved"].ToString() == "true")
                {
                    bool ApprovalRights = Util.GetBoolean(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IF(COUNT(*)>0,'True','False')ApprovalRight FROM `f_approval_labemployee` fl WHERE  fl.`EmployeeID`=@EmployeeID and fl.Approval=5",
                        new MySqlParameter("@EmployeeID", AuthID)));
                    if (ApprovalRights)
                    {
                        dt.Rows[0]["btnSave"] = "0";
                        dt.Rows[0]["btnApprove"] = "1";
                    }
                    else
                    { 
                        dt.Rows[0]["btnSave"] = "0"; 
                        dt.Rows[0]["btnApprove"] = "1"; 
                    }
                }
                else if (dt.Rows[0]["IsResult"].ToString() == "true")
                {
                    bool ApprovalRights = Util.GetBoolean(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IF(COUNT(*)>0,'True','False')ApprovalRight FROM `f_approval_labemployee` fl WHERE  fl.`EmployeeID`=@EmployeeID and fl.Approval=4",
                        new MySqlParameter("@EmployeeID", AuthID)));

                    if (ApprovalRights)
                    {
                        dt.Rows[0]["btnSave"] = "0";
                        dt.Rows[0]["btnApprove"] = "1";
                    }
                    else
                    { 
                        dt.Rows[0]["btnSave"] = "1";
                        dt.Rows[0]["btnApprove"] = "0";
                    }
                }
                else
                {
                    dt.Rows[0]["btnSave"] = "1";
                    dt.Rows[0]["btnApprove"] = "0";
                }
            }
            ds.Tables.Add(dt.Copy());
            //select report header and footer detail
            dt = new DataTable();
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT * FROM word_report_header  ORDER BY RowID").Tables[0];
            dt.TableName = "Report_Structure";
            ds.Tables.Add(dt.Copy());

            //select all available template list

            dt = new DataTable();
             string Gender = "Male";
             dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Template_ID,Temp_Head FROM `investigation_template_radiology` where Investigation_ID='" + Investigation_ID + "' and Gender in ('Both','" + Gender + "') order by Temp_Head").Tables[0];
          //  dt.Rows.Clear();
            dt.TableName = "templates";
            dr = dt.NewRow();
            dt.Rows.InsertAt(dr, 0);

            ds.Tables.Add(dt.Copy());
            return ds;
        }
        catch (Exception ex)
        {
 ClassLog cl = new ClassLog();
            cl.errLog(ex);
            //get Error Detail in Datatable
            dt = new DataTable();
            dt.Columns.Add("Error");
            dt.TableName = "tbError";
            dr = dt.NewRow();
            dt.Rows.InsertAt(dr, 0);
            dr["Error"] = ex.GetBaseException().ToString();

            ds.Tables.Add(dt.Copy());
            return ds;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }                  
    }

    [WebMethod]
    public DataTable Investigation_List()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT im.Investigation_Id,im.Name FROM investigation_master im WHERE ReportType=11 ORDER BY im.Name").Tables[0];

            DataRow dr = dt.NewRow();
            dt.Rows.InsertAt(dr, 0);
            dt.AcceptChanges();
            return dt;
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    public DataTable Inv_Templates(string Investigation_ID)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT it.Template_ID,it.Temp_Head,it.Gender,it.isDefault fROM investigation_template_radiology it WHERE it.Investigation_ID=@Investigation_ID order by isDefault desc,Temp_Head asc ",
                new MySqlParameter("@Investigation_ID", Investigation_ID)).Tables[0];

        if (dt.Rows.Count == 0)
        {
            DataRow dr = dt.NewRow();
            dr["Template_ID"] = "0";
            dt.Rows.Add(dr);
            dt.AcceptChanges();
        }
        
        if (dt.Rows.Count > 0)
        {
            string filePath = cfg.AppSettings["WordReportPath"] + @"Template\" + dt.Rows[0]["Template_ID"] + ".doc";
            if (filePath=="")
              filePath=  cfg.AppSettings["WordReportPath"] + @"Template\Sample.doc";            
            dt.Columns.Add("ReportData", System.Type.GetType("System.Byte[]"));
            dt.Rows[0]["ReportData"] = GetBitmapBytes(filePath);
        }
        return dt;
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    
    [WebMethod]
    public DataTable get_Template(string Template_ID)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
        string filePath = cfg.AppSettings["WordReportPath"] + @"Template\Sample.doc";

        DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT it.Template_ID,it.Temp_Head,it.Gender FROM investigation_template_radiology it WHERE it.Template_ID=@Template_ID",
            new MySqlParameter("@Template_ID", Template_ID)).Tables[0];
        if (dt.Rows.Count > 0)
            filePath = cfg.AppSettings["WordReportPath"] + @"Template\" + dt.Rows[0]["Template_ID"] + ".doc";

        if (!File.Exists(filePath))
            File.Copy(cfg.AppSettings["WordReportPath"] + @"Template\Sample.doc", filePath, true);
      
        dt.TableName = "Table1";
        dt.Columns.Add("ReportData", System.Type.GetType("System.Byte[]"));
        DataRow dr = dt.NewRow();
        dt.Rows.InsertAt(dr, 0);

        dt.Rows[0]["ReportData"] = GetBitmapBytes(filePath);
        dt.AcceptChanges();
      
        return dt;
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public bool Approve_Report(byte[] buffer, string UserName, string User_ID, string Test_ID, string Doctor_ID, string Doctor_Name)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string filePath = cfg.AppSettings["WordReportPath"] + @"Reports\" + StockReports.ExecuteScalar(@"SELECT concat(DATE_FORMAT(DATE,'%Y\%M\%d'),'/',Test_ID) FROM `patient_labinvestigation_opd` WHERE Test_ID='" + Test_ID + "'");
            if (!Directory.Exists(filePath))
                Directory.CreateDirectory(filePath);

            System.IO.File.WriteAllBytes(filePath + @"\" + Test_ID + ".doc", buffer);

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update Patient_LabInvestigation_opd set Approved=1,ApprovedBy=@ApprovedBy,ApprovedName=@ApprovedName,ApprovedDate=now() where Test_ID=@Test_ID ",
                new MySqlParameter("@ApprovedBy", Util.GetInt(Doctor_ID)),
                    new MySqlParameter("@ApprovedName", Doctor_Name),
                        new MySqlParameter("@Test_ID", Test_ID));

            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public DataTable get_Doctor_Signature(string Doctor_ID,string Investigation)
    {

        string filePath = Server.MapPath("~/Design/OPD/Signature/" + Doctor_ID + ".jpg");
        if (!File.Exists(filePath))
            File.Copy(Server.MapPath("~/Design/OPD/Signature/Sample.jpg"), filePath, true);

        DataTable dt = new DataTable();
        dt.TableName = "Table1";
        dt.Columns.Add("ReportData", System.Type.GetType("System.Byte[]"));
        dt.Columns.Add("FooterLine");

        DataRow dr = dt.NewRow();
        dt.Rows.InsertAt(dr, 0);

        dt.Rows[0]["ReportData"] = GetBitmapBytes(filePath);
        dt.AcceptChanges();
        return dt;
    }
    [WebMethod]
    public bool SaveReport(byte[] buffer,string UserName,string User_ID,string Test_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        
        string NewStatus = "";
        if(User_ID.Split('#').Length>1)
        {
            NewStatus = User_ID.Split('#')[1].ToLower();
            User_ID = User_ID.Split('#')[0];
        }
        try
        {
            string filePath = cfg.AppSettings["WordReportPath"] + @"Reports\" + StockReports.ExecuteScalar(@"SELECT concat(DATE_FORMAT(DATE,'%Y\%M\%d'),'/',Test_ID) FROM `patient_labinvestigation_opd` WHERE Test_ID='" + Test_ID + "'");
            if (!Directory.Exists(filePath))
                Directory.CreateDirectory(filePath);

            System.IO.File.WriteAllBytes(filePath + @"\" + Test_ID + ".doc", buffer);           

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update Patient_LabInvestigation_opd set Result_Flag=1,ResultEnteredDate=now(),ResultEnteredBy=@ResultEnteredBy,ResultEnteredName=@ResultEnteredName where Test_ID=@Test_ID ",
               new MySqlParameter("@ResultEnteredBy", User_ID),
                   new MySqlParameter("@ResultEnteredName", UserName.Replace("%20"," ")),
                       new MySqlParameter("@Test_ID", Test_ID));        
            return true;
            
        }
        catch (Exception ex)
        {
            throw (ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public bool SaveTemplates(byte[] buffer, string Investigation_ID, string Template_ID,string Template_Head,string User_ID, string Gender,string isDefault)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (Template_ID == "0")
            {
                string str = "insert into investigation_template_radiology(Investigation_ID,Temp_Head,Gender,isDefault,Employee_ID)  values(@Investigation_ID,@Temp_Head,@Gender,@isDefault,@Employee_ID)";
                MySqlHelper.ExecuteNonQuery(con,CommandType.Text,str,
                    new MySqlParameter("@Investigation_ID",Investigation_ID),
                        new MySqlParameter("@Temp_Head",Template_Head),
                        new MySqlParameter("@Gender",Gender),
                        new MySqlParameter("@isDefault",isDefault),
                        new MySqlParameter("@Employee_ID",User_ID));
                
               

                Template_ID = StockReports.ExecuteScalar("SELECT MAX(Template_ID) FROM investigation_template_radiology");
            }
            string filename = cfg.AppSettings["WordReportPath"] + @"Template\" + Template_ID + ".doc";

            if (!File.Exists(filename))
                File.Copy(cfg.AppSettings["WordReportPath"] + @"Template\Sample.doc", filename, true);

            System.IO.File.WriteAllBytes(filename, buffer);

            if (isDefault == "1")
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update investigation_template_radiology set isDefault='0' where Investigation_ID=@Investigation_ID",
               new MySqlParameter("@Investigation_ID", Investigation_ID));

            
            MySqlHelper.ExecuteNonQuery(con,CommandType.Text,"update investigation_template_radiology set Investigation_ID=@Investigation_ID,Temp_Head=@Temp_Head,Gender=@Gender,isDefault=@isDefault,Employee_ID=@Employee_ID,dtUpdate=now() where Template_ID=@Template_ID",
                new MySqlParameter("@Investigation_ID",Investigation_ID),
                new MySqlParameter("@Temp_Head",Template_Head),
                new MySqlParameter("@Gender",Gender),
                new MySqlParameter("@isDefault",isDefault),
                new MySqlParameter("@Employee_ID",User_ID),
                new MySqlParameter("@Template_ID",Template_ID));
         
            return true;
        }
        catch (Exception ex)
        {
            throw (ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    private static byte[] GetBitmapBytes(string Path)
    {
        byte[] bytes = System.IO.File.ReadAllBytes(Path);
        return bytes;
    }                               
}