using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Lab_ChangePanel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCentre();
            AllLoad_Data.bindPanel(ddlPanelsearch, "");
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }

    private void BindCentre()
    {
        StringBuilder sb = new StringBuilder();

        string str = " select distinct cm.CentreID,cm.Centre Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.centrecode,cm.Centre  ";
        DataTable dt = StockReports.GetDataTable(str);
        ddlcentre.DataSource = dt;
        ddlcentre.DataTextField = "Centre";
        ddlcentre.DataValueField = "CentreID";
        ddlcentre.DataBind();
        ddlcentre.Items.Insert(0, new ListItem(" ", " "));
    }

    [WebMethod(EnableSession = true)]
    public static string BindPanel(string centreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(pn.Panel_ID,'#',pn.ReferenceCodeOPD) panel_id,pn.company_name  FROM Centre_Panel cp ");
        sb.Append(" INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id WHERE cp.CentreId='" + centreID + "'  AND cp.isActive=1 AND pn.isActive=1 ");

        sb.Append(" order by pn.company_name  ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string SearchPanel(ChangePanel searchdata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        StringBuilder sb = new StringBuilder();
        try
        {
          //  if (Util.GetString(searchdata.LabNo) != "" && Util.GetString(HttpContext.Current.Session["RoleID"]) = "9")
            {
                //if (Util.GetInt((StockReports.ExecuteScalar("SELECT  TIMESTAMPDIFF(MINUTE,DATE,NOW())  FROM f_ledgertransaction WHERE ledgertransactionno='" + Util.GetString(searchdata.LabNo) + "'"))) > 30)
                {
                 //  return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "You can change panel within 30 minutes of Billing !!" });
               }
            }
            sb.Append(" SELECT lt.LedgerTransactionNo,plo.ItemName,plo.Amount, ");
            if (Util.GetString(searchdata.LabNo) != "")
                sb.Append(" ifnull(r.Rate,0) - DiscountAmt NewAmount,plo.Rate Rate,ifnull(r.Rate,0) NewRate,plo.DiscountAmt DiscountAmt , ");
            else
                sb.Append(" sum(ifnull(r.Rate,0) - DiscountAmt) NewAmount,sum(plo.Rate)Rate,sum(ifnull(r.Rate,0)) NewRate,sum(plo.DiscountAmt)DiscountAmt , ");
            sb.Append(" lt.PName,lt.Age,lt.Gender, ");
            sb.Append(" pm.Company_Name OldPanel,concat(pm.Panel_ID,'#',pm.ReferenceCodeOPD) OldPanelID,pm2.Company_Name NewPanel,concat(pm2.Panel_ID,'#',pm2.ReferenceCodeOPD) NewPanelID ");
            sb.Append("  FROM f_ledgertransaction lt ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionID=lt.LedgerTransactionID   AND  IF(isPackage=1,`SubCategoryID`=15,`SubCategoryID`!=15)  ");
            if (Util.GetString(searchdata.LabNo) == "" && Util.GetString(searchdata.OldPanelID) != "")
                sb.Append(" AND lt.Panel_ID=@Panelsearch AND lt.date>=@FromDate  AND lt.date<=@ToDate ");

            sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID ");
            sb.Append(" INNER JOIN  f_panel_master pm2 ON pm2.Panel_ID=@PanelID ");
            sb.Append(" LEFT JOIN f_ratelist r ON r.ItemID=plo.ItemID AND r.Panel_ID=@PanelRate ");
            if (Util.GetString(searchdata.LabNo) != "")
            {
                sb.Append("  WHERE (lt.LedgerTransactionNo=@LabNo or plo.BarcodeNo=@LabNo)");
            }
            else
            {
                sb.Append(" GROUP BY lt.LedgerTransactionNo ");
            }
            using (DataTable dtpanel = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@Panelsearch", searchdata.OldPanelID.Split('#')[0].ToString()),
                  new MySqlParameter("@FromDate", Util.GetDateTime(searchdata.FromDate).ToString("yyyy-MM-dd") + " 00:00:00"),
                  new MySqlParameter("@ToDate", Util.GetDateTime(searchdata.ToDate).ToString("yyyy-MM-dd") + " 23:59:59"),
                  new MySqlParameter("@PanelID", searchdata.PanelID.Split('#')[0].ToString()),
                  new MySqlParameter("@PanelRate", searchdata.PanelID.Split('#')[1].ToString()),
                  new MySqlParameter("@LabNo", Util.GetString(searchdata.LabNo))).Tables[0])

                return Newtonsoft.Json.JsonConvert.SerializeObject(dtpanel);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "No Record Found...!" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveNewPanelRates(List<ChangePanel> getData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            foreach (ChangePanel aa in getData)
            {
                double NetAmountOld = Util.GetDouble(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, " SELECT NetAmount from f_ledgertransaction where LedgerTransactionNo=@LedgerTransactionNo ",
                    new MySqlParameter("@LedgerTransactionNo", Util.GetString(aa.LabNo))));

                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE f_ledgertransaction lt ");
                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionID=lt.LedgerTransactionID and plo.ispackage=0 ");
                sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID ");
                sb.Append(" Left JOIN f_ratelist r ON r.ItemID=plo.ItemID AND r.Panel_ID=@mrpPanel_ID ");
                sb.Append(" INNER JOIN  f_panel_master pm2 ON pm2.Panel_ID=@NewPanelID ");
                sb.Append(" SET lt.iscredit=IF(pm2.Payment_mode='Credit','1','0'),lt.Panel_ID=pm2.Panel_ID,lt.PanelName=pm2.Company_Name, ");
                sb.Append(" plo.Amount = IFNULL((r.Rate - DiscountAmt),0),plo.Rate=IFNULL(r.Rate,0),lt.ipaddress=@ipaddress WHERE lt.LedgerTransactionNo=@LedgerTransactionNo ; ");

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@mrpPanel_ID", aa.NewPanelID.Split('#')[1].ToString().Trim()),
                    new MySqlParameter("@NewPanelID", aa.NewPanelID.Split('#')[0].ToString().Trim()),
                    new MySqlParameter("@ipaddress", StockReports.getip()),
                    new MySqlParameter("@LedgerTransactionNo", Util.GetString(aa.LabNo)));


                //package case

                sb.Append(" UPDATE f_ledgertransaction lt ");
                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionID=lt.LedgerTransactionID and plo.ispackage=1 and plo.investigation_Id=0 ");
                sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID ");
                sb.Append(" Left JOIN f_ratelist r ON r.ItemID=plo.ItemID AND r.Panel_ID=@mrpPanel_ID ");
                sb.Append(" INNER JOIN  f_panel_master pm2 ON pm2.Panel_ID=@NewPanelID ");
                sb.Append(" SET lt.iscredit=IF(pm2.Payment_mode='Credit','1','0'),lt.Panel_ID=pm2.Panel_ID,lt.PanelName=pm2.Company_Name, ");
                sb.Append(" plo.Amount = IFNULL((r.Rate - DiscountAmt),0),plo.Rate=IFNULL(r.Rate,0),lt.ipaddress=@ipaddress WHERE lt.LedgerTransactionNo=@LedgerTransactionNo ; ");

                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@mrpPanel_ID", aa.NewPanelID.Split('#')[1].ToString().Trim()),
                    new MySqlParameter("@NewPanelID", aa.NewPanelID.Split('#')[0].ToString().Trim()),
                    new MySqlParameter("@ipaddress", StockReports.getip()),
                    new MySqlParameter("@LedgerTransactionNo", Util.GetString(aa.LabNo)));



                StringBuilder sb1 = new StringBuilder();
                sb1.Append(" UPDATE f_ledgertransaction lt ");
                sb1.Append(" SET lt.PName=Concat(lt.PName,'.'),lt.NetAmount=(SELECT SUM(plo.Amount) FROM patient_labinvestigation_opd plo ");
                sb1.Append(" WHERE LedgerTransactionNo=@LedgerTransactionNo), ");
                sb1.Append(" lt.GrossAmount=(SELECT SUM(plo.Rate) FROM patient_labinvestigation_opd plo ");
                sb1.Append(" WHERE LedgerTransactionNo=@LedgerTransactionNo), ");

                sb1.Append(" lt.DiscountOnTotal=(SELECT SUM(plo.Rate-plo.Amount) FROM patient_labinvestigation_opd plo ");
                sb1.Append(" WHERE LedgerTransactionNo=@LedgerTransactionNo) ");
                sb1.Append(" ,lt.ipaddress=@ipaddress WHERE lt.LedgerTransactionNo=@LedgerTransactionNo ");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb1.ToString(),
                    new MySqlParameter("@LedgerTransactionNo", Util.GetString(aa.LabNo)),
                    new MySqlParameter("@ipaddress", StockReports.getip()));

                int IsCredit = Util.GetInt(MySqlHelper.ExecuteScalar(tranX, CommandType.Text, " SELECT iscredit from f_ledgertransaction where LedgerTransactionNo=@LedgerTransactionNo ",
                   new MySqlParameter("@LedgerTransactionNo", Util.GetString(aa.LabNo))));
                if (IsCredit == 1)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO f_receipt(ReceiptNo,LedgerNoCr,LedgerTransactionNo,LedgerTransactionID,PayBy,Amount,BankName,CardNo, ");
                    sb.Append(" CardDate,CreatedDate,Patient_ID,IsCancel,Cancel_UserID,CancelDate,CancelReason,Narration,Panel_ID,CentreID,ipaddress, ");
                    sb.Append(" PaymentMode,PaymentModeID,S_Amount,S_CountryID,S_Currency,S_Notation,C_Factor,Currency_RoundOff,CreatedByID,");
                    sb.Append(" CreatedBy,CurrencyRoundDigit,Converson_ID,refundAgainstReceiptNo,IsAdvance,BulkSettlementID,UpdateID,UpdateName,");
                    sb.Append(" Updatedate,UpdateRemarks,IsPUPAdvance,bulkSettleID,AppointmentID,BalanceAmount,SettleAgainstReceiptNo,TransactionID) ");
                    sb.Append(" Select ReceiptNo,LedgerNoCr,LedgerTransactionNo,LedgerTransactionID,PayBy,Amount*-1,BankName,CardNo, ");
                    sb.Append(" CardDate,CreatedDate,Patient_ID,IsCancel,Cancel_UserID,CancelDate,CancelReason,Narration,Panel_ID,CentreID,ipaddress, ");
                    sb.Append(" PaymentMode,PaymentModeID,S_Amount*-1,S_CountryID,S_Currency,S_Notation,C_Factor,Currency_RoundOff,CreatedByID,");
                    sb.Append(" CreatedBy,CurrencyRoundDigit,Converson_ID,refundAgainstReceiptNo,IsAdvance,BulkSettlementID,UpdateID,UpdateName,");
                    sb.Append(" Updatedate,UpdateRemarks,IsPUPAdvance,bulkSettleID,AppointmentID,BalanceAmount,SettleAgainstReceiptNo,TransactionID ");
                    sb.Append(" FROM f_receipt WHERE LedgerTransactionNo=@LedgerTransactionNo ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb1.ToString(),
                        new MySqlParameter("@LedgerTransactionNo", Util.GetString(aa.LabNo)));

                    sb = new StringBuilder();
                    sb.Append(" UPDATE f_ledgertransaction lt ");
                    sb.Append(" SET lt.adjustment=0 ");
                    sb.Append(" WHERE lt.LedgerTransactionNo=@LedgerTransactionNo ");
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@LedgerTransactionNo", Util.GetString(aa.LabNo)));
                }

            }

            tranX.Commit();
            return JsonConvert.SerializeObject(new { status = true });
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error...!" });
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class ChangePanel
    {
        public string LabNo { get; set; }
        public string OldPanelID { get; set; }
        public string NewPanelID { get; set; }
        public string PanelID { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
    }
}