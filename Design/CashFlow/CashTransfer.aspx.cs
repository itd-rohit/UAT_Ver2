using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_CashFlow_CashTransfer : System.Web.UI.Page
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

    public static string getTransferAccess()
    {
        return "";
    }

    [WebMethod(EnableSession = true)]
    public static string bindSearchType(int SearchType)
    {
        DataTable dt = new DataTable();

        if (SearchType == 1)
            dt = StockReports.GetDataTable("SELECT em.Employee_Id ID,em.Name `Name`,'' Mobile FROM employee_master em INNER JOIN f_login fl ON em.`Employee_ID`=fl.`EmployeeID` AND fl.`Centreid`='" + UserInfo.Centre + "'  WHERE em.IsActive=1 AND em.Employee_Id<>'" + UserInfo.ID + "'  GROUP BY fl.EmployeeId ORDER BY em.name");
        else if (SearchType == 2)
            dt = StockReports.GetDataTable("SELECT `Name`,`ID` ID,Mobile FROM (SELECT fm.Name ,fm.FeildboyID id,IFNULL(fm.Mobile,'')Mobile FROM feildboy_master fm  INNER JOIN `fieldboy_zonedetail` fmz ON fmz.`FieldBoyID`=fm.`FeildboyID` AND fmz.`ZoneID` = ( SELECT `BusinessZoneID` FROM  `centre_master` cm WHERE cm.`CentreID`='" + UserInfo.Centre + "') WHERE fm.isactive=1 ORDER BY NAME )t ");
        else if (SearchType == 3)
            dt = StockReports.GetDataTable("SELECT Bank_ID ID,BankName `Name`,'' Mobile FROM f_bank_master bm  ");
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    public static DataTable getTransferDetail(StringBuilder sb1, MySqlConnection con)
    {
        sb1.Append(" SELECT IFNULL((SELECT SUM(Amount) FROM f_receipt rec WHERE CreatedByID=@CreatedByID AND IsCancel=0 AND PaymentModeID=1 AND CreatedDate>=@EntryDateTime  GROUP BY rec.CreatedByID ),0) ReceivedAmt, ");        
        sb1.Append(" IFNULL((SELECT SUM(Amount) FROM f_receipt_onaccount WHERE Employee_ID_By=@Employee_ID_By AND IsCancel=0 AND IsReceive=1 AND ReceiveDateTime>=@EntryDateTime),0)TransferAmt,");
        sb1.Append(" IFNULL((SELECT SUM(Amount) FROM f_receipt_onaccount WHERE Employee_ID_By=@Employee_ID_ByID AND IsCancel=0 AND IsReceive=0 AND ReceiveDateTime>=@EntryDateTime),0)TransferPendingAmt, ");
        sb1.Append("  '' Employee_ID_To ,'' EmployeeName_To,0 Amount,'' CreatedDate ");

        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString(),
            new MySqlParameter("@EntryDateTime", Util.GetDateTime(Resources.Resource.CashFlowStartDate).ToString("yyyy-MM-dd HH:mm:ss")), new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@Employee_ID_To", UserInfo.ID),
             new MySqlParameter("@Employee_ID_By", UserInfo.ID), new MySqlParameter("@Employee_ID_ByID", UserInfo.ID)).Tables[0];
    }

    [WebMethod(EnableSession = true)]
    public static string SearchData(string SearchType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb1 = new StringBuilder();

            using (DataTable dt = getTransferDetail(sb1, con))
            {
                sb1 = new StringBuilder();
                sb1.Append(" SELECT Employee_ID_To Employee_ID_To,EmployeeName_To EmployeeName_To,ABS(Amount)Amount,DATE_FORMAT(CreatedDate,'%d-%b-%Y %h:%i %p')CreatedDate FROM f_receipt_onaccount ");
                sb1.Append(" WHERE Employee_ID_By=@Employee_ID_By  AND IsCancel=0 AND savingType='Deposit' ORDER BY CreatedDate DESC LIMIT 1 ");
                using (DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString(),
                   new MySqlParameter("@Employee_ID_By", UserInfo.ID)).Tables[0])
                {
                    if (dt1.Rows.Count > 0)
                    {
                        foreach (DataRow row in dt.Rows)
                        {
                            row["Employee_ID_To"] = Util.GetString(dt1.Rows[0]["Employee_ID_To"].ToString());
                            row["EmployeeName_To"] = Util.GetString(dt1.Rows[0]["EmployeeName_To"].ToString());
                            row["Amount"] = Util.GetDecimal(dt1.Rows[0]["Amount"].ToString());
                            row["CreatedDate"] = Util.GetString(dt1.Rows[0]["CreatedDate"].ToString());
                        }
                    }
                    dt.AcceptChanges();
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveCashDeposit(int Employee_ID_To, string EmployeeName_To, int TypeID, string DepositAmount, string TypeName, string ShortDepositRejectReason, string FieldBoyMobileNo, string OldFieldBoyMobileNo)
    {
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    StringBuilder sb = new StringBuilder();
                    int count = 0;

                    if (TypeID == 2)
                        count = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(1) FROM cash_transfer_master WHERE  Employee_ID_By=@Employee_ID_By AND IsActive=1 AND TypeID=@TypeID",
                                 new MySqlParameter("@Employee_ID_By", Employee_ID_To), new MySqlParameter("@TypeID", TypeID)));
                    else if (TypeID == 3)
                        count = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(1) FROM cash_transfer_master WHERE IsActive=1 AND TypeID=3"));

                    if (count == 0 && TypeID != 1)
                        return "2";

                    sb = new StringBuilder();
                    using (DataTable dt = getTransferDetail(sb, con))
                    {
if (TypeID == 1)
if (Util.GetDecimal(Util.GetDecimal(dt.Rows[0]["ReceivedAmt"].ToString()) + Util.GetDecimal(Util.GetDecimal(dt.Rows[0]["TransferAmt"].ToString()) + Util.GetDecimal(dt.Rows[0]["TransferPendingAmt"].ToString()))) < Util.GetDecimal(DepositAmount))
                        //if (Util.GetDecimal(Util.GetDecimal(dt.Rows[0]["ReceivedAmt"].ToString()) - Util.GetDecimal(Util.GetDecimal(dt.Rows[0]["TransferAmt"].ToString()) - Util.GetDecimal(dt.Rows[0]["TransferPendingAmt"].ToString()))) < Util.GetDecimal(DepositAmount))
                        {
                            return "3";
                        }
                    }

                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO f_receipt_onaccount(Employee_ID_To,EmployeeName_To,TypeID,Amount,CreatedBy,CreatedByID,Employee_ID_By,EmployeeName_By,SavingType,TypeName,CentreID,ShortDepositRejectReason,FieldBoyMobileNo)");
                    sb.Append(" VALUES(@Employee_ID_To,@EmployeeName_To,@TypeID,@Amount,@CreatedBy,@CreatedByID,@Employee_ID_By,@EmployeeName_By,'Deposit',@TypeName,@CentreID,@ShortDepositRejectReason,@FieldBoyMobileNo)");

                    MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@Employee_ID_To", Employee_ID_To), new MySqlParameter("@EmployeeName_To", EmployeeName_To), new MySqlParameter("@TypeID", TypeID),
                       new MySqlParameter("@Amount", Util.GetDecimal(DepositAmount) * (-1)), new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID),
                       new MySqlParameter("@Employee_ID_By", UserInfo.ID), new MySqlParameter("@EmployeeName_By", UserInfo.LoginName),
                       new MySqlParameter("@TypeName", TypeName), new MySqlParameter("@CentreID", UserInfo.Centre),
                       new MySqlParameter("@ShortDepositRejectReason", ShortDepositRejectReason), new MySqlParameter("@FieldBoyMobileNo", FieldBoyMobileNo));

                    if (TypeID == 2 && FieldBoyMobileNo != OldFieldBoyMobileNo)
                    {
                        MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "UPDATE feildboy_master SET Mobile=@Mobile WHERE FeildboyID=@FeildboyID",
                           new MySqlParameter("@Mobile", FieldBoyMobileNo), new MySqlParameter("@FeildboyID", Employee_ID_To));
                    }
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
                    con.Dispose();
                    Tnx.Dispose();
                }
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string exportCashDeposit(string FromDate, string ToDate, int con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT EmployeeName_By TransferBy,EmployeeName_To TransferTo,ABS(Amount)Amount,DATE_FORMAT(CreatedDate,'%d-%b-%Y %h:%i %p')TransferDateTime,TypeName,IF(IsReceive=1,'Yes','No')IsReceive , ");
        sb.Append(" IF(IsCancel=1,'Yes','No')IsReject,IFNULL(RejectReason,'')RejectReason ");
        sb.Append(" FROM f_receipt_onaccount WHERE Employee_ID_By='" + UserInfo.ID + "'  AND savingType='Deposit' ");
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