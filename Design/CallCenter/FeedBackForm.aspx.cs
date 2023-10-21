using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_FeedBackForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetFeedBackData(string callType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,CallType,Question,Category,Type,TypeName,IsActive FROM call_centre_question WHERE CallType='" + callType + "' AND IsActive='1' ");
        DataTable dtdoctor = StockReports.GetDataTable(sb.ToString());
        string retrn = Newtonsoft.Json.JsonConvert.SerializeObject(dtdoctor);
        return retrn;
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveFeedBack(string pName, string pMobile, string pID, string pEmail, string pDob, string pAddress, object data, object data1)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            var item = new System.Web.Script.Serialization.JavaScriptSerializer().ConvertToType<List<TypeName>>(data);
            var item1 = new System.Web.Script.Serialization.JavaScriptSerializer().ConvertToType<List<TypeName1>>(data1);
           // DataTable dt1 = StockReports.GetDataTable("SELECT OrderID+1 OrderID FROM call_centre_FeedBkAnswer ORDER BY ID DESC LIMIT 1");
            int dt1 = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT IFNULL(MAX(OrderID),0)+1 OrderID FROM call_centre_FeedBkAnswer "));
            int orderid = Convert.ToInt32(dt1);
            foreach (var sr in item)
            {
                foreach (var sr1 in item1)
                {
                    if (sr.FeedbkID == sr1.FeedbkID)
                    {
                        string query = "INSERT INTO call_centre_FeedBkAnswer (Question,Answer,FeedBackID,Name,Email,DOB,Address,CreatedDate,UserName,UserID,IsActive,QuestionID,Mobile,OrderID) VALUES('" + sr1.FeedbkAnswer + "','" + sr.FeedbkName + "','" + pID + "','" + pName + "','" + pEmail + "','" + Convert.ToDateTime(pDob).ToString("yyyy-MM-dd") + "','" + pAddress + "',Now(),'" + UserInfo.LoginName + "','" + UserInfo.ID + "','1','" + sr.FeedbkID + "','" + pMobile + "','" + orderid + "')";
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query.ToString());
                    }
                }
            }
            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            return "0";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindFeedBack(string ID)
    {
        try
        {
            DataTable dt = StockReports.GetDataTable("SELECT OrderID,ID,NAME,Email,DATE_FORMAT(DOB,'%d-%b-%Y')DOB,Mobile,Address,DATE_FORMAT(CreatedDate,'%d-%b-%Y')CreatedDate FROM call_centre_FeedBkAnswer WHERE FeedBackID = '" + ID + "' and IsActive='1'  GROUP BY OrderID order by FeedBackID ");
            string retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return retr;
        }
        catch (Exception ex)
        {
            return "";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveNewFeedBackLog(string MobileNo, string CallBy, string CallByID, string CallType, string Remarks, string Name, string CentreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string ID = "";
            Patient_Estimate_Log pelObj = new Patient_Estimate_Log(tnx);
            pelObj.Mobile = MobileNo;
            pelObj.Call_By = CallBy;
            pelObj.Call_By_ID = CallByID;
            pelObj.Call_Type = CallType;
            pelObj.UserName = UserInfo.LoginName;
            pelObj.UserID = UserInfo.ID;
            pelObj.Remarks = Remarks;
            pelObj.Name = Name;
            if (CentreID == "") {
                pelObj.CentreID = "0";
            }
            else
            {
                pelObj.CentreID = CentreID;
            }
            ID = pelObj.Insert();

            if (ID == string.Empty)
            {
                tnx.Rollback();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return string.Empty;
            }
            else
            {
                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return "1";
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());
        }
        finally { }
    }
    protected void btnExcel_Click(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,NAME,Email,DATE_FORMAT(DOB,'%d-%b-%Y')DOB,Mobile,Address,DATE_FORMAT(CreatedDate,'%d-%b-%Y')CreatedDate,Question, Answer FROM call_centre_FeedBkAnswer where IsActive='1' order by FeedBackID ");
        if (dt.Rows.Count > 0)
        {
            Session["ReportName"] = "FeedBack and Suggestion";
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record Not Found..";
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string DeleteFeedBack(int ID)
    {
        string retr = "";
        try
        {
            bool result = StockReports.ExecuteDML("delete from call_centre_FeedBkAnswer where OrderID='" + ID + "' ");
            if (result == true)
            {
                retr = "1";
            }
            else
            {
                retr = "0";
            }
            return retr;
        }
        catch (Exception ex)
        {
            return retr = "2";
        }
    }
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
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
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue));


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
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetRemarks()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT RemarksValue,Remarks FROM Call_Centre_Remarks WHERE IsActive='1'");
            string rtrn = makejsonoftable(dt, makejson.e_without_square_brackets);
            return rtrn;
        }
        catch (Exception ex)
        {
            return "";
        }
    }
}
public class TypeName
{
    public string FeedbkAnswer { get; set; }
    public string FeedbkName { get; set; }
    public string FeedbkID { get; set; }
}
public class TypeName1
{
    public string FeedbkAnswer { get; set; }
    public string FeedbkID { get; set; }
}