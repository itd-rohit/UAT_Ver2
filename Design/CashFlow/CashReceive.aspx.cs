using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_CashFlow_CashReceive : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            var startDate = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).ToString("dd-MMM-yyyy");
            txtFromDate.Text = startDate.ToString();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchData(int TypeID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int count = 0;
            if (TypeID == 3)
                count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM cash_transfer_master WHERE IsActive=1 AND TypeID=3 AND Employee_ID_To=@Employee_ID_To",
                    new MySqlParameter("@Employee_ID_To", UserInfo.ID)));

            if (count == 0 && TypeID == 3)
                return "2";

            StringBuilder sb1 = new StringBuilder();

            sb1.Append(" SELECT  rec.ID,rec.Employee_ID_By EmpID,rec.EmployeeName_By `Name`,rec.Employee_ID_To EmpIDTo,rec.EmployeeName_To NameTo,ABS(rec.Amount)Amount, ");
            sb1.Append(" rec.TypeName,DATE_FORMAT(rec.CreatedDate,'%d-%b-%Y %h:%i %p')CreatedDate,rec.TypeName,rec.TypeID,IFNULL(rec.NoteType,'')NoteType  ");
            sb1.Append(" FROM f_receipt_onaccount rec ");
            sb1.Append(" ");
            if (TypeID == 1)
                sb1.Append(" WHERE rec.SavingType='Deposit' AND rec.IsCancel=0 AND rec.IsReceive=0  AND rec.Employee_ID_To=@Employee_ID_To AND rec.TypeID=1 ");
            else if (TypeID == 2)
                sb1.Append(" INNER JOIN cash_transfer_master ctm ON rec.Employee_ID_To=ctm.Employee_ID_By WHERE  ctm.Employee_ID_To=@Employee_ID_ToID AND rec.SavingType='Deposit' AND rec.IsCancel=0 AND rec.IsReceive=0 AND rec.TypeID=2 AND ctm.TypeID=2 AND ctm.IsActive=1 ");
            else if (TypeID == 3)
                sb1.Append(" WHERE rec.SavingType='Deposit' AND rec.IsCancel=0 AND rec.IsReceive=0  AND rec.TypeID=3 ");
            sb1.Append(" ORDER BY rec.CreatedDate DESC ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString(),
               new MySqlParameter("@Employee_ID_To", UserInfo.ID), new MySqlParameter("@Employee_ID_ToID", UserInfo.ID)).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public class CashReceive
    {
        public int ID { get; set; }
        public int EmpId { get; set; }
        public string EmpName { get; set; }
        public string TypeName { get; set; }
        public int TypeID { get; set; }
        public decimal Amount { get; set; }
        public string RejectReason { get; set; }
        public string NoteType { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveCashReceive(object dataCashReceive)
    {
        List<CashReceive> CashReceiveData = new JavaScriptSerializer().ConvertToType<List<CashReceive>>(dataCashReceive);
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    using (DataTable dt = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, "SELECT IsReceive,IsCancel,Amount,Employee_ID_To EmpIDTo,EmployeeName_To NameTo FROM f_receipt_onaccount WHERE ID=@ID ",
                          new MySqlParameter("@ID", CashReceiveData[0].ID)).Tables[0])
                    {
                        if (dt.Select("IsReceive = '1'").Any() || dt.Select("IsCancel = '1'").Any())
                            return "2";
                        else
                        {
                            if (Math.Abs(Util.GetDecimal(dt.Rows[0]["Amount"].ToString())) != Util.GetDecimal(CashReceiveData[0].Amount))
                            {
                                return "3";
                            }
                            StringBuilder sb = new StringBuilder();
                            if (CashReceiveData[0].TypeID != 3 && CashReceiveData[0].NoteType.Trim()==string.Empty )
                            {
                                int Employee_ID_To = 0;
                                string EmployeeName_To = string.Empty;
                                if (CashReceiveData[0].TypeID == 2)
                                {
                                    //           using (DataTable empTo = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, "SELECT rec.Employee_ID_To EmpIDTo,rec.EmployeeName_To NameTo FROM f_receipt_onaccount rec WHERE rec.ID=@ID ",
                                    //new MySqlParameter("@ID", CashReceiveData[0].ID)).Tables[0])
                                    //           {
                                    Employee_ID_To = Util.GetInt(dt.Rows[0]["EmpIDTo"].ToString());
                                    EmployeeName_To = dt.Rows[0]["NameTo"].ToString();
                                    // }
                                }
                                else
                                {
                                    Employee_ID_To = CashReceiveData[0].EmpId;
                                    EmployeeName_To = CashReceiveData[0].EmpName;
                                }
                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO f_receipt_onaccount(Employee_ID_To,EmployeeName_To,TypeID,Amount,CreatedBy,CreatedByID,Employee_ID_By,EmployeeName_By,SavingType,GroupID,TypeName,IsReceive,ReceiveByUserID,ReceiveByUserName,ReceiveDateTime,CentreID)");
                                sb.Append(" VALUES(@Employee_ID_To,@EmployeeName_To,@TypeID,@Amount,@CreatedBy,@CreatedByID,@Employee_ID_By,@EmployeeName_By,'Receive',@GroupID,@TypeName,1,@ReceiveByUserID,@ReceiveByUserName,NOW(),@CentreID)");

                                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                                   new MySqlParameter("@Employee_ID_To", Employee_ID_To), new MySqlParameter("@EmployeeName_To", EmployeeName_To), new MySqlParameter("@TypeID", CashReceiveData[0].TypeID),
                                   new MySqlParameter("@Amount", CashReceiveData[0].Amount), new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID),
                                   new MySqlParameter("@Employee_ID_By", UserInfo.ID), new MySqlParameter("@EmployeeName_By", UserInfo.LoginName), new MySqlParameter("@TypeName", CashReceiveData[0].TypeName),
                                   new MySqlParameter("@GroupID", CashReceiveData[0].ID), new MySqlParameter("@ReceiveByUserID", UserInfo.ID), new MySqlParameter("@ReceiveByUserName", UserInfo.LoginName), new MySqlParameter("@CentreID", UserInfo.Centre));
                            }
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_receipt_onaccount SET IsReceive=1,ReceiveByUserID=@ReceiveByUserID,ReceiveByUserName=@ReceiveByUserName,ReceiveDateTime=NOW() WHERE ID=@ID ",
                               new MySqlParameter("@ID", CashReceiveData[0].ID), new MySqlParameter("@ReceiveByUserID", UserInfo.ID), new MySqlParameter("@ReceiveByUserName", UserInfo.LoginName));

                            Tnx.Commit();
                            return "1";
                        }
                    }
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
    public static string RejectCashReceive(object dataCashReceive)
    {
       
        List<CashReceive> CashReceiveData = new JavaScriptSerializer().ConvertToType<List<CashReceive>>(dataCashReceive);
        if (CashReceiveData[0].RejectReason == string.Empty)
        {
            return "3";
        }
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    using (DataTable dt = MySqlHelper.ExecuteDataset(Tnx, CommandType.Text, "SELECT IsReceive,IsCancel FROM f_receipt_onaccount WHERE ID=@ID ",
                         new MySqlParameter("@ID", CashReceiveData[0].ID)).Tables[0])
                    {
                        if (dt.Select("IsReceive = '1'").Any() || dt.Select("IsCancel = '1'").Any())
                            return "2";
                        else
                        {
                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE f_receipt_onaccount SET IsCancel=1,CancelByID=@CancelByID,CancelBy=@CancelBy,CancelDate=NOW(),RejectReason=@RejectReason WHERE ID=@ID ",
                               new MySqlParameter("@ID", CashReceiveData[0].ID), new MySqlParameter("@CancelByID", UserInfo.ID), new MySqlParameter("@CancelBy", UserInfo.LoginName),
                               new MySqlParameter("@RejectReason", CashReceiveData[0].RejectReason));
                            Tnx.Commit();
                            return "1";
                        }
                    }
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
    public static string exportCashReceive(string FromDate, string ToDate, int con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT EmployeeName_By ReceiveBy,EmployeeName_To TransferBy,ABS(Amount)Amount,DATE_FORMAT(CreatedDate,'%d-%b-%Y %h:%i %p')TransferDateTime,TypeName ");
        sb.Append(" ");
        sb.Append(" FROM f_receipt_onaccount WHERE Employee_ID_By='" + UserInfo.ID + "'  AND savingType='Receive' AND IsCancel=0 ");
        sb.Append(" AND CreatedDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND CreatedDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                if (con == 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = UserInfo.LoginName + " Cash Receive Report";
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