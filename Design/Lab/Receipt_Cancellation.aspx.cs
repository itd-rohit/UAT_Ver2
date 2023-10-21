using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Collections.Generic;
using System.Web.Script.Serialization;
using System.Linq;
public partial class Design_Lab_Receipt_Cancellation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFormDate, txtToDate);
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            BindCentre();
        }
    }
    private void BindCentre()
    {
        
        StringBuilder sb=new StringBuilder();
        sb.Append("select distinct cm.CentreID,CONCAT(cm.CentreCode,'-',cm.Centre) as Centre from centre_master cm where   cm.isActive=1 ");
        //sb.Append(" and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' and AccessType=2 ) or cm.CentreID = '" + UserInfo.Centre + "')");
        sb.Append(" order by cm.CentreCode  ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            ddlCentreAccess.DataSource = dt;
            ddlCentreAccess.DataTextField = "Centre";
            ddlCentreAccess.DataValueField = "CentreID";
            ddlCentreAccess.DataBind();
            if (UserInfo.RoleID.ToString() == "6")
                ddlCentreAccess.Items.Insert(0, new ListItem("ALL Centre", "ALL"));
        }
    }
    public class receiptSearchType
    {
        public string SearchType { get; set; }
    }
    public static List<receiptSearchType> SearchType()
    {
        List<receiptSearchType> receiptSearchType = new List<receiptSearchType>();
        receiptSearchType.Add(new receiptSearchType() { SearchType = "lt.LedgertransactionNo" });
        receiptSearchType.Add(new receiptSearchType() { SearchType = "plo.BarcodeNo" });
        receiptSearchType.Add(new receiptSearchType() { SearchType = "PM.PName" });
        receiptSearchType.Add(new receiptSearchType() { SearchType = "pm.Mobile" });

        return receiptSearchType;
    }
    [WebMethod(EnableSession = true)]
    public static string SearchReceiptData(object searchData)
    {

        List<ReceiptCancelation> receiptSearch = new JavaScriptSerializer().ConvertToType<List<ReceiptCancelation>>(searchData);
        HashSet<string> SearchTypes = new HashSet<string>(receiptSearch.Select(s => s.SearchType));
        if (SearchType().Where(m => SearchTypes.Contains(m.SearchType)).Count() == 0)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Invalid Data Found" });
        }      
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string LabNo = string.Empty;
            if (Util.GetString(receiptSearch[0].SearchType) == "plo.BarcodeNo")
            {
                LabNo = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT LedgerTransactionNo FROM `patient_labinvestigation_opd` WHERE barcodeNo=@barcodeNo",
                    new MySqlParameter("@barcodeNo", Util.GetString(receiptSearch[0].LabNo))));
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT '' CancelReason,'' CancelDate, lt.LedgerTransactionNo,lt.LedgerTransactionID,lt.`PName`,CONCAT(lt.`Age`,'/',left(lt.gender,1)) Pinfo ,lt.NetAmount, lt.`Adjustment` PaidAmt ,");
            sb.Append(" IF(lt.IsCredit=1,'Credit','Cash')PaymentMode, DATE_FORMAT(lt.Date,'%d-%b-%Y')DATE , ");
            sb.Append(" CONCAT(r.ReceiptNo,'#Lab') ID,lt.`LedgerTransactionID`, ");
            sb.Append(" lt.GrossAmount GrossAmt,lt.DiscountOnTotal DiscAmt,'Main' SlipType   ");
            sb.Append(" FROM f_ledgertransaction lt     ");
            sb.Append(" INNER JOIN f_receipt r  ON lt.LedgerTransactionID = r.LedgerTransactionID AND r.LedgerNoCr='OPD003' and r.iscancel=0 ");
            sb.Append(" INNER JOIN patient_master pm on pm.patient_id=lt.patient_id ");
            sb.Append(" WHERE lt.date>=@FromDate AND lt.date<=@ToDate ");
            if (Util.GetString(receiptSearch[0].Centre) != "ALL")
                sb.Append(" AND  lt.centreid=@centreID");
            if (Util.GetString(receiptSearch[0].LabNo) != string.Empty)
            {
                if (Util.GetString(receiptSearch[0].SearchType) == "PM.PName")
                    sb.AppendFormat(" AND {0}=LIKE @LikeLabNo ", receiptSearch[0].SearchType);
                else
                {
                    if (Util.GetString(receiptSearch[0].SearchType) == "plo.BarcodeNo")
                        sb.Append(" AND  lt.LedgerTransactionNo=@LedgerTransactionNo");
                    else
                        sb.AppendFormat(" AND {0}=@LabNo ", receiptSearch[0].SearchType);
                }
            }
            sb.Append("   UNION ALL ");
            sb.Append("   SELECT r.CancelReason,date_format(r.CancelDate,'%d-%b-%Y') CancelDate, r.LedgerTransactionNo LedgerTransactionNo,r.LedgerTransactionID,lt.PName,CONCAT(lt.`Age`,'/',left(lt.gender,1)) Pinfo,r.Amount NetAmount,  ");
            sb.Append(" r.Amount PaidAmt ,r.PaymentMode PaymentMode, ");
            sb.Append(" DATE_FORMAT(r.CreatedDate,'%d-%b-%Y')DATE ,CONCAT(r.ReceiptNo,'#ADV') ID,r.LedgerTransactionID, ");
            sb.Append(" 0 GrossAmt ,0 DiscAmt,'Settlement' SlipType   ");
            sb.Append("  FROM f_receipt r INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionID = r.LedgerTransactionID   AND r.LedgerNoCr<>'OPD003'    ");
            sb.Append(" INNER JOIN patient_master pm on pm.patient_id=lt.patient_id ");
            sb.Append(" WHERE r.CreatedDate>=@FromDate AND r.CreatedDate<=@ToDate and r.iscancel=0 ");

            if (Util.GetString(receiptSearch[0].Centre) != "ALL")
                sb.Append(" AND  lt.centreid=@centreID");
            if (Util.GetString(receiptSearch[0].LabNo) != "")
            {
                if (Util.GetString(receiptSearch[0].SearchType) == "PM.PName")
                {

                    sb.AppendFormat(" AND {0}=LIKE @LikeLabNo ", receiptSearch[0].SearchType);       

                  
                }
                else
                {
                    if (Util.GetString(receiptSearch[0].SearchType) == "plo.BarcodeNo")
                    {
                        sb.Append(" AND  lt.LedgerTransactionNo=@LedgerTransactionNo");
                    }
                    else
                    {
                        sb.AppendFormat(" AND {0}=@LabNo ", receiptSearch[0].SearchType);     

                        
                    }
                }
            }
            sb.Append(" ORDER BY LedgerTransactionNo ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@FromDate", Util.GetDateTime(receiptSearch[0].FromDate).ToString("yyyy-MM-dd") + " 00:00:00"),
                new MySqlParameter("@ToDate", Util.GetDateTime(receiptSearch[0].ToDate).ToString("yyyy-MM-dd") + " 23:59:59"),
                new MySqlParameter("@centreID", Util.GetString(receiptSearch[0].Centre)),
                new MySqlParameter("@LikeLabNo", Util.GetString(receiptSearch[0].LabNo) + "%"),
               // new MySqlParameter("@LabNo", Util.GetString(receiptSearch[0].LabNo)),
                new MySqlParameter("@LedgerTransactionNo", LabNo.Trim()),
                new MySqlParameter("@LabNo", Util.GetString(receiptSearch[0].LabNo))).Tables[0])
            {
                receiptSearch.Clear();
                return JsonConvert.SerializeObject(new { status = true, response = dt });

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }  
    [WebMethod(EnableSession = true)]
    public static string CancelReceipt(ReceiptCancelation savedata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string ID = savedata.ID;
            StringBuilder sb = new StringBuilder();
         //   if (ID.Split('#')[1].ToUpper() == "LAB")
          //  {
                int IsSRADone = 0;
                IsSRADone = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT COUNT(1)  FROM Sample_Logistic sl INNER JOIN   `patient_labinvestigation_opd` plo on sl.TestId = plo.Test_id  WHERE plo.LedgertransactionNo=@LedgertransactionNo AND sl.STATUS='Received'",
                    new MySqlParameter("@LedgertransactionNo", ID.Split('#')[0])));
                if (IsSRADone > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Cannot cancel this receipt because SRA done" });
                }

                //int InvoiceCount = 0;
                //InvoiceCount = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT COUNT(*) FROM f_ledgertransaction WHERE LedgertransactionNo=@LedgertransactionNo AND InvoiceNo<>''",
                //    new MySqlParameter("@LedgertransactionNo", ID.Split('#')[0])));
                //if (InvoiceCount > 0)
                //{
                //    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Cannot delete this receipt because Invoice is generated" });
                //}
                // Check Main settlement and main receipt Condition *******  Date : 20-Mar-2016  *******
                //int ReceiptCount = 0;
                //ReceiptCount = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT COUNT(*) FROM f_reciept WHERE LedgertransactionNo=@LedgertransactionNo AND IsCancel=0 AND LedgerNoCr<>'OPD003' LIMIT 1; ",
                //    new MySqlParameter("@LedgertransactionNo", ID.Split('#')[0])));
                //if (ReceiptCount > 0)
                //{
                //    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Please cancel the settlement Receipt before cancel the main receipt" });
                //}
                // Check Result Done Condition *******  Date : 19-Mar-2016  *******
                int ResultCount = 0;
                string strQuery = "SELECT Result_flag FROM patient_labinvestigation_opd WHERE `LedgerTransactionNo`=@LedgerTransactionNo  AND Result_flag=1 LIMIT 1;";
                ResultCount = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, strQuery,
                    new MySqlParameter("@LedgerTransactionNo", ID.Split('#')[0])));
                if (ResultCount > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Cannot delete this receipt because result is generated" });
                }
                string roleid = UserInfo.RoleID.ToString();
                if (roleid == "211" || roleid == "11" || roleid == "9")
                {
                    //   int ResultCount = 0;
                    string strQuery1 = "SELECT Result_flag FROM patient_labinvestigation_opd WHERE `LedgerTransactionNo`=@LedgerTransactionNo  AND IsSampleCollected IN('S','Y') LIMIT 1;";
                    ResultCount = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, strQuery1,
                        new MySqlParameter("@LedgerTransactionNo", ID.Split('#')[0])));
                    if (ResultCount > 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Cannot delete this receipt because Sample Collected " });
                    }
                }

                //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update patient_labinvestigation_opd set LedgerTransactionID=0, LedgerTransactionNo='', LedgerTransactionNoOLD =@LedgerTransactionNoOLD where LedgerTransactionNo=@LedgerTransactionNo ",
                //    new MySqlParameter("@LedgerTransactionNoOLD", ID.Split('#')[0]),
                //    new MySqlParameter("@LedgerTransactionNo", ID.Split('#')[0]));

                //string sql = " call ReceiptCancelLab(@ID,'LAB',@LoginID,@Cancelreason,@getip)";
                //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sql,
                //    new MySqlParameter("@ID", ID.Split('#')[0]),
                //    new MySqlParameter("@LoginID", Util.GetInt(HttpContext.Current.Session["ID"])),
                //    new MySqlParameter("@Cancelreason", savedata.Cancelreason),
                //    new MySqlParameter("@getip", StockReports.getip()));


        //    }
          //  else
          //  {
                //string sql = " call ReceiptCancelLab(@ID,'ADV',@LoginID,@Cancelreason,@getip)";
                //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sql,
                //    new MySqlParameter("@ID", ID.Split('#')[0]),
                //    new MySqlParameter("@LoginID", Util.GetInt(HttpContext.Current.Session["ID"])),
                //    new MySqlParameter("@Cancelreason", savedata.Cancelreason),
                //    new MySqlParameter("@getip", StockReports.getip()));
           // }

         //     DataTable receiptData = MySqlHelper.ExecuteDataset(Tranx, CommandType.Text, "SELECT ledgertransactionID,LedgerTransactionno, LedgerNoCr,PayBy,ReceiptNo,PaymentModeID,PaymentMode,Amount,BankName,CardNo,CardDate,Patient_ID,CentreID,S_Amount,S_CountryID,S_Currency,S_Notation,C_Factor,Currency_RoundOff,Panel_ID,CurrencyRoundDigit,Converson_ID FROM f_receipt WHERE receiptNo=@receiptNo",
         //        new MySqlParameter("@receiptNo", savedata.ID.Split('#')[0])).Tables[0];
         //
         // Receipt objRC = new Receipt(Tranx)
         // {
         //     LedgerNoCr = receiptData.Rows[0]["LedgerNoCr"].ToString(),
         //     LedgerTransactionID = Util.GetInt(receiptData.Rows[0]["LedgerTransactionID"]),
         //     LedgerTransactionNo = Util.GetString(receiptData.Rows[0]["LedgerTransactionno"]),
         //     CreatedByID = UserInfo.ID,
         //     Patient_ID = receiptData.Rows[0]["Patient_ID"].ToString(),
         //     PayBy = receiptData.Rows[0]["PayBy"].ToString(),
         //     PaymentMode = receiptData.Rows[0]["PaymentMode"].ToString(),
         //     PaymentModeID = Util.GetInt(receiptData.Rows[0]["PaymentModeID"].ToString()),
         //     Amount = Util.GetDecimal(receiptData.Rows[0]["Amount"].ToString()) * -1,
         //     BankName = receiptData.Rows[0]["BankName"].ToString(),
         //     CardNo = receiptData.Rows[0]["CardNo"].ToString(),
         //     CardDate = Util.GetDateTime(receiptData.Rows[0]["CardDate"].ToString()),
         //     IsCancel = 0,
         //     Narration = savedata.Cancelreason,
         //     CentreID = Util.GetInt(receiptData.Rows[0]["CentreID"].ToString()),
         //     Panel_ID = Util.GetInt(receiptData.Rows[0]["Panel_ID"].ToString()),
         //     CreatedDate = DateTime.Now,
         //     S_Amount = Util.GetDecimal(receiptData.Rows[0]["S_Amount"].ToString()) * -1,
         //     S_CountryID = Util.GetInt(receiptData.Rows[0]["S_CountryID"].ToString()),
         //     S_Currency = receiptData.Rows[0]["S_Currency"].ToString(),
         //     S_Notation = receiptData.Rows[0]["S_Notation"].ToString(),
         //     C_Factor = Util.GetDecimal(receiptData.Rows[0]["C_Factor"].ToString()),
         //     Currency_RoundOff = Util.GetDecimal(receiptData.Rows[0]["Currency_RoundOff"].ToString())* -1,
         //     CurrencyRoundDigit = Util.GetByte(receiptData.Rows[0]["CurrencyRoundDigit"].ToString()),
         //     CreatedBy = UserInfo.LoginName,
         //     Converson_ID = Util.GetInt(receiptData.Rows[0]["Converson_ID"].ToString()),
         //     refundAgainstReceiptNo = receiptData.Rows[0]["ReceiptNo"].ToString()
         // };
         // string ReceiptNo = objRC.Insert();
         // if (ReceiptNo == string.Empty)
         // {
         //     Tranx.Rollback();
         //     return JsonConvert.SerializeObject(new { status = false, response = "Receipt Error" });
         // }
            sb = new StringBuilder();
            sb.Append(" update f_receipt set iscancel=1,cancel_userID=@UserID,Canceldate=Now(),cancelReason=@Reason where receiptNo=@receiptNo ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@Reason", savedata.Cancelreason)
               , new MySqlParameter("@receiptNo", savedata.ID.Split('#')[0]));
            sb = new StringBuilder();
            sb.Append("");
            sb.Append("  UPDATE f_ledgertransaction ");
            sb.Append(" SET Adjustment = ifnull((SELECT SUM(`Amount`) FROM `f_receipt` WHERE LedgerTransactionno=@LedgerTransactionID and iscancel=0),0) ");
            sb.Append(" WHERE LedgerTransactionno = @LedgerTransactionID;");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@LedgerTransactionID", savedata.LabNo));

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,Remarks)VALUES(@LedgertransactionNo,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,now(),@DispatchCode,@Remarks) ",
                                                         new MySqlParameter("@LedgertransactionNo", savedata.LabNo),
                                                         new MySqlParameter("@Remarks", savedata.Cancelreason),
                                                         new MySqlParameter("@Status", "Receipt Cancel"), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                                                         new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty));

            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true });
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class ReceiptCancelation
    {
        public string SearchType { get; set; }
        public string LabNo { get; set; }
        public string Centre { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public string Cancelreason { get; set; }
        public string ID { get; set; }
        public int LedgerTransactionID { get; set; }
        public string ReceiptNo { get; set; }
    }
}