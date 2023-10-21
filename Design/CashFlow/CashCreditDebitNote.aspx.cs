using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CashFlow_CashCreditDebitNote : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = string.Empty;

        if (cmd == "GetEmpList")
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(GetEmpList());
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(rtrn);
            Response.End();

            return;
        }
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            var startDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).ToString("dd-MMM-yyyy");
            txtFromDate.Text = startDate.ToString();
        }
    }
    [WebMethod]
    private DataTable GetEmpList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Employee_ID as value,CONCAT(House_No,'~', CONCAT(Title,' ', NAME)) AS label,Name EmployeeName FROM `employee_master` WHERE IsActive=1 AND Employee_ID !='" + UserInfo.ID + "' AND NAME LIKE '" + Request.QueryString["EmpName"].ToString() + "%' ");
        return StockReports.GetDataTable(sb.ToString());
    }

    [WebMethod(EnableSession = true)]
    public static string CreditDepitNoteSave(int Employee_ID_To, string EmployeeName_To, int TypeOfPayment, decimal Amount, string Remarks, string NoteType)
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                   
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO f_receipt_onaccount(Employee_ID_To,EmployeeName_To,TypeID,Amount,CreatedBy,CreatedByID,Employee_ID_By,EmployeeName_By,SavingType,TypeName,CentreID,Remarks,NoteType)");
                    sb.Append(" VALUES(@Employee_ID_To,@EmployeeName_To,1,@Amount,@CreatedBy,@CreatedByID,@Employee_ID_By,@EmployeeName_By,'Deposit',@TypeName,@CentreID,@Remarks,@NoteType)");

                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@Employee_ID_To", Employee_ID_To), new MySqlParameter("@EmployeeName_To", EmployeeName_To),
                       new MySqlParameter("@Amount", Util.GetDecimal(Amount) * (TypeOfPayment)), new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID),
                       new MySqlParameter("@Employee_ID_By", UserInfo.ID), new MySqlParameter("@EmployeeName_By", UserInfo.LoginName),
                       new MySqlParameter("@TypeName", "User"), new MySqlParameter("@CentreID", UserInfo.Centre),
                       new MySqlParameter("@Remarks", Remarks), new MySqlParameter("@NoteType", NoteType.Substring(0, 1).ToUpper()));




                    Tnx.Commit();
                    return "1";
                }
                catch (Exception ex)
                {
                    Tnx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return "0";
                }
                finally
                {
                    con.Close();
                }
            }

        }
    }
    [WebMethod(EnableSession = true)]
    public static string exportCreditDebitNote(string FromDate, string ToDate, int con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT EmployeeName_By TransferBy,EmployeeName_To TransferTo,ABS(Amount)Amount,DATE_FORMAT(CreatedDate,'%d-%b-%Y %h:%i %p')TransferDateTime,TypeName,IF(IsReceive=1,'Yes','No')IsReceive , ");
        sb.Append(" IF(IsCancel=1,'Yes','No')IsReject,IFNULL(RejectReason,'')RejectReason,Remarks,NoteType ");
        sb.Append(" FROM f_receipt_onaccount WHERE Employee_ID_By='" + UserInfo.ID + "'  AND savingType='Deposit' AND NoteType<>'' ");
        sb.Append(" AND CreatedDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND CreatedDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                if (con == 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = UserInfo.LoginName + " Cash Transfer Report";
                    return "1";
                }
                else
                {
                    return Util.getJson(dt);
                }
            }
            else
                return "0";
        }
    }
}