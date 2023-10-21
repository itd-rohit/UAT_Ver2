using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Linq;

public partial class Design_OPD_BulkSettelment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindPanel();
            dtFrom.Text = dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
    }


    private void BindPanel()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT concat(Panel_code,' ~ ',Company_Name) Company_Name,CONCAT(Panel_ID,'#',ReferenceCodeOPD)PanelID,Panel_ID FROM f_panel_master pm ");
            sb.Append(" where  Panel_ID in(select distinct PanelId from centre_panel where centreID in(" + UserInfo.Centre + ")) AND pm.Payment_mode='CASH' ");
            sb.Append("  ORDER BY pm.company_name ");
            DataTable dtPanel = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
             new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0];
            if (dtPanel != null && dtPanel.Rows.Count > 0)
            {
                ddlPanel.DataSource = dtPanel;
                ddlPanel.DataTextField = "Company_Name";
                ddlPanel.DataValueField = "Panel_ID";
                ddlPanel.DataBind();
                ddlPanel.Items.Insert(0, new ListItem("", "0"));
            }
            else
            {
                ddlPanel.DataSource = null;
                ddlPanel.DataBind();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string getClientAdvanceAmt(int Panel_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Amount-BalanceAmount RemAmt,ReceiptNo,DATE_FORMAT(CreatedDate,'%d-%b-%Y')CreatedDate,PaymentMode,CreatedBy FROM f_receipt WHERE Panel_ID =@Panel_ID  AND IsCancel=0 AND Amount-BalanceAmount>0 AND PayBy='C' ORDER BY ID+0",
                            new MySqlParameter("@Panel_ID", Panel_ID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = string.Empty });

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string SearchForBulkPayment(Bulksettelment searchdata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y') BillDate,lt.Patient_ID PatientID,   ");
            sb.Append(" lt.LedgerTransactionNo Transaction_ID,lt.LedgerTransactionId, ROUND(lt.NetAmount,2) NetAmount,lt.Adjustment PaidAmt,  lt.LedgerTransactionNo,lt.Panel_ID, lt.CentreID ");
            sb.Append(" FROM f_ledgertransaction lt  Where  lt.Panel_ID=@Panel_ID    ");

            if (searchdata.OnlyBalPatient == 1)
                sb.Append(" AND ROUND(lt.NetAmount,2)<>lt.Adjustment ");

            if (Util.GetString(searchdata.dtFrom) != string.Empty)
                sb.Append(" and lt.Date >=@FromDate");

            if (Util.GetString(searchdata.dtTo) != string.Empty)
                sb.Append(" and lt.Date <=@ToDate");

            sb.Append(" order by lt.Date ");
            using (DataTable dtSearch = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Panel_ID", searchdata.PanelID),
                new MySqlParameter("@FromDate", Util.GetDateTime(searchdata.dtFrom).ToString("yyyy-MM-dd") + " 00:00:00"),
                new MySqlParameter("@ToDate", Util.GetDateTime(searchdata.dtTo).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0])
                return Newtonsoft.Json.JsonConvert.SerializeObject(dtSearch);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveBulkPayment(List<Receipt> ReceiptData, List<Bulksettelment> LtData, decimal totalPaidAmt, int AdvanceAmtID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int BulkSettlementID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_Tran_id(@bulkSettleID)",
                new MySqlParameter("@bulkSettleID", "bulkSettleID")));
            if (BulkSettlementID == 0)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error in Generate BulkSettleID" });
            }
            decimal advAmt = 0;
            decimal totalPaidAmount = ReceiptData.Select(s => s.Amount).Sum();
            decimal TDSAmt = ReceiptData.Select(s => (decimal?)s.TDSAmount).Sum() ?? default(decimal);
            decimal WriteOffAmt = ReceiptData.Select(s => (decimal?)s.WriteOffAmount).Sum() ?? default(decimal);
            if ((TDSAmt > 0 || WriteOffAmt > 0) && (TDSAmt + WriteOffAmt > totalPaidAmount))
            {
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "TDS Plus WriteOff Amount not greater then balance Amount" });
            }

            if (AdvanceAmtID != 0)
            {
                advAmt = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT (Amount-BalanceAmount) RemAmt FROM f_receipt WHERE ID =@ID  ",
                   new MySqlParameter("@ID", AdvanceAmtID)));
                if (advAmt < totalPaidAmount)
                {
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Please Reopen Page Advance Amount changed" });
                }
            }
            DataTable advanceAmtDetail = new DataTable();
            if (AdvanceAmtID != 0)
            {
                advanceAmtDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ReceiptNo,IFNULL(BankName,'')BankName,IFNULL(CardNo,'')CardNo,IFNULL(CardDate,'')CardDate,S_CountryID,S_Currency,S_Notation,C_Factor,Currency_RoundOff,CurrencyRoundDigit,Converson_ID,Amount-BalanceAmount RemAmt FROM f_receipt WHERE ID =@ID  ",
                     new MySqlParameter("@ID", AdvanceAmtID)).Tables[0];

            }

            decimal totalAmt = 0;
            for (int i = 0; i < ReceiptData.Count; i++)
            {

                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM f_ledgertransaction WHERE LedgerTransactionID=@LedgerTransactionID AND ROUND(IFNULL(Adjustment,0))=ROUND(NetAmount)",
                   new MySqlParameter("@PaidAmount", Util.GetDecimal(LtData[i].PaidAmount)),
                   new MySqlParameter("@LedgerTransactionID", Util.GetString(LtData[i].LabID))));
                if (count > 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Lab No. already settled" });
                }

                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE f_ledgertransaction set Adjustment=Adjustment+@Adjustment ,AdjustmentDate=now(),UpdateID=@UpdateID");
                sb.Append(", UpdateName=@UpdateName,UpdateRemarks='Settelment' WHERE LedgerTransactionID=@LedgerTransactionID ");
                int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Adjustment", Util.GetDecimal(LtData[i].Amount)),
                    new MySqlParameter("@UpdateID", UserInfo.ID),
                    new MySqlParameter("@UpdateName", UserInfo.LoginName),
                    new MySqlParameter("@LedgerTransactionID", LtData[i].LabID));

                if (a == 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error in Update LT" });
                }
                //-----------------------------

               

                Dictionary<string, decimal> SettleType = new Dictionary<string, decimal>();
                if (ReceiptData[i].Amount > 0)
                    SettleType.Add("IsMain", ReceiptData[i].Amount);
                if (ReceiptData[i].TDSAmount > 0)
                    SettleType.Add("IsTDS", ReceiptData[i].TDSAmount);
                if (ReceiptData[i].WriteOffAmount > 0)
                    SettleType.Add("IsWriteOff", ReceiptData[i].WriteOffAmount);

                foreach (KeyValuePair<string, decimal> Type in SettleType)
                {
                    Receipt objRC = new Receipt(tnx);
                    objRC.LedgerNoCr = "HOSP0005";
                    objRC.LedgerTransactionID = ReceiptData[i].LedgerTransactionID;
                    objRC.LedgerTransactionNo = ReceiptData[i].LedgerTransactionNo;
                    objRC.CreatedByID = UserInfo.ID;
                    objRC.CreatedBy = UserInfo.LoginName;
                    objRC.Patient_ID = ReceiptData[i].Patient_ID;
                    objRC.PayBy = "P";
                    if (Type.Key == "IsMain")
                    {

                        objRC.Amount = ReceiptData[i].Amount;
                        objRC.S_Amount = ReceiptData[i].S_Amount;
                    }
                    else if (Type.Key == "IsTDS")
                    {
                        objRC.PaymentMode = "TDS";
                        objRC.PaymentModeID = 11;
                        objRC.Amount = Type.Value;
                        objRC.S_Amount = Type.Value;
                    }
                    else if (Type.Key == "IsWriteOff")
                    {
                        objRC.PaymentMode = "WriteOff";
                        objRC.PaymentModeID = 12;
                        objRC.Amount = Type.Value;
                        objRC.S_Amount = Type.Value;
                    }

                    objRC.IsCancel = 0;
                    objRC.CentreID = ReceiptData[i].CentreID;
                    objRC.IsAdvance = 1;
                    objRC.BulkSettlementID = BulkSettlementID;
                    objRC.Panel_ID = ReceiptData[i].Panel_ID;
                    objRC.CreatedDate = DateTime.Now;

                    if (AdvanceAmtID == 0)
                    {
                        if (Type.Key == "IsMain")
                        {
                            objRC.PaymentMode = ReceiptData[i].PaymentMode;
                            objRC.PaymentModeID = ReceiptData[i].PaymentModeID;
                        }
                        objRC.BankName = ReceiptData[i].BankName;
                        objRC.CardNo = ReceiptData[i].CardNo;
                        objRC.S_CountryID = ReceiptData[i].S_CountryID;
                        objRC.S_Currency = ReceiptData[i].S_Currency;
                        objRC.S_Notation = ReceiptData[i].S_Notation;
                        objRC.C_Factor = ReceiptData[i].C_Factor;
                        objRC.Currency_RoundOff = ReceiptData[i].Currency_RoundOff;
                        objRC.CurrencyRoundDigit = ReceiptData[i].CurrencyRoundDigit;
                        objRC.Converson_ID = ReceiptData[i].Converson_ID;
                        objRC.CardDate = ReceiptData[i].CardDate;
                    }
                    else
                    {
                        if (Type.Key == "IsMain")
                        {
                            objRC.PaymentMode = "AdvSettlement";
                            objRC.PaymentModeID = 13;
                            objRC.SettleAgainstReceiptNo = Util.GetString(advanceAmtDetail.Rows[0]["ReceiptNo"].ToString());
                        }
                        
                        objRC.BankName = advanceAmtDetail.Rows[0]["BankName"].ToString();
                        objRC.CardNo = advanceAmtDetail.Rows[0]["CardNo"].ToString();
                        objRC.S_CountryID = Util.GetInt(advanceAmtDetail.Rows[0]["S_CountryID"]);
                        objRC.S_Currency = advanceAmtDetail.Rows[0]["S_Currency"].ToString();
                        objRC.S_Notation = advanceAmtDetail.Rows[0]["S_Notation"].ToString();
                        objRC.C_Factor = Util.GetDecimal(advanceAmtDetail.Rows[0]["C_Factor"]);
                        objRC.Currency_RoundOff = Util.GetDecimal(advanceAmtDetail.Rows[0]["Currency_RoundOff"]);
                        objRC.CurrencyRoundDigit = Util.GetByte(advanceAmtDetail.Rows[0]["CurrencyRoundDigit"]);
                        objRC.Converson_ID = Util.GetInt(advanceAmtDetail.Rows[0]["Converson_ID"]);
                        objRC.CardDate = Util.GetDateTime(advanceAmtDetail.Rows[0]["CardDate"]);
                        
                    }
                    objRC.Narration = ReceiptData[i].Narration;


                    string ReceiptNo = objRC.Insert();

                    if (ReceiptNo == string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error in RC" });
                    }

                }
                totalAmt += Util.GetDecimal(ReceiptData[i].Amount);
                sb = new StringBuilder();
                sb.Append(" SELECT COUNT(1) ");
                sb.Append("   FROM (SELECT lt.LedgerTransactionID,lt.NetAmount, ");
                sb.Append("          (SELECT SUM(re.Amount) FROM f_receipt  re  ");
                sb.Append("    WHERE re.IsCancel=0 AND re.LedgerTransactionID = lt.LedgerTransactionID AND re.LedgerTransactionID=@LedgerTransactionID) AS totalPaidAmt ");
                sb.Append(" FROM f_ledgertransaction lt WHERE lt.LedgerTransactionID=@LedgerTransactionID");
                sb.Append(" )t1 ");
                sb.Append(" WHERE t1.totalPaidAmt > t1.NetAmount ");

                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@LedgerTransactionID", Util.GetString(LtData[i].LabID))));
                if (count > 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Lab. No. already settled" });
                }
            }
            decimal TotalOutstanding = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "CALL get_balance_amount(@type,@CentreID)",
                new MySqlParameter("@type", "CSH"),
                new MySqlParameter("@CentreID", ReceiptData[0].CentreID)));

            if (Util.GetDecimal(TotalOutstanding) < 0 && Util.GetDecimal(totalAmt) >= Util.GetDecimal(TotalOutstanding) * (-1))
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET  MaxExpiry=@MaxExpiry where Panel_ID=@Panel_ID ",
                    new MySqlParameter("@MaxExpiry", DateTime.Now.AddHours(24).ToString("yyyy-MM-dd HH:mm:ss")),
                    new MySqlParameter("@Panel_ID", LtData[0].PanelID));
            }
            if (Util.GetDecimal(totalPaidAmt) > Util.GetDecimal(totalAmt) && AdvanceAmtID == 0)
            {
                Receipt objRC = new Receipt(tnx);
                objRC.LedgerNoCr = "HOSP0005";
                objRC.LedgerTransactionID = 0;
                objRC.LedgerTransactionNo = string.Empty;
                objRC.CreatedByID = UserInfo.ID;
                objRC.CreatedBy = UserInfo.LoginName;
                objRC.Patient_ID = string.Empty;
                objRC.PayBy = "C";
                objRC.PaymentMode = ReceiptData[0].PaymentMode;
                objRC.PaymentModeID = ReceiptData[0].PaymentModeID;
                objRC.Amount = Util.GetDecimal(totalPaidAmt) - Util.GetDecimal(totalAmt);
                objRC.S_Amount = Util.GetDecimal(totalPaidAmt) - Util.GetDecimal(totalAmt);

                objRC.BankName = ReceiptData[0].BankName;
                objRC.CardNo = ReceiptData[0].CardNo;
                objRC.IsCancel = 0;
                objRC.CentreID = ReceiptData[0].CentreID;


                objRC.IsAdvance = 1;
                objRC.BulkSettlementID = BulkSettlementID;
                objRC.Panel_ID = ReceiptData[0].Panel_ID;
                objRC.CreatedDate = DateTime.Now;

                objRC.S_CountryID = ReceiptData[0].S_CountryID;
                objRC.S_Currency = ReceiptData[0].S_Currency;
                objRC.S_Notation = ReceiptData[0].S_Notation;
                objRC.C_Factor = ReceiptData[0].C_Factor;
                objRC.Currency_RoundOff = ReceiptData[0].Currency_RoundOff;
                objRC.CurrencyRoundDigit = ReceiptData[0].CurrencyRoundDigit;
                objRC.Converson_ID = ReceiptData[0].Converson_ID;
                objRC.CardDate = ReceiptData[0].CardDate;
                objRC.Narration = ReceiptData[0].Narration;

                string AdvReceiptNo = objRC.Insert();

                if (AdvReceiptNo == string.Empty)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error in RC" });
                }
                //OPD_Advance adv = new OPD_Advance(tnx)
                //{
                //    Patient_ID = string.Empty,
                //    LedgerTransactionID = 0,
                //    LedgerTransactionNo = string.Empty,
                //    AdvanceAmount = Util.GetDecimal(totalPaidAmt) - Util.GetDecimal(totalAmt),
                //    ReceiptNo = AdvReceiptNo,
                //    CreatedBy = UserInfo.LoginName,
                //    CreatedByID = UserInfo.ID,
                //    CentreID = ReceiptData[0].CentreID,
                //    Panel_ID = LtData[0].PanelID,
                //    PaymentModeID = ReceiptData[0].PaymentModeID,
                //    PaymentMode = ReceiptData[0].PaymentMode,
                //    CreatedDate = DateTime.Now,
                //    AdvanceType = "Client",

                //    S_Amount = Util.GetDecimal(totalPaidAmt) - Util.GetDecimal(totalAmt),
                //    S_CountryID = ReceiptData[0].S_CountryID,
                //    S_Currency = ReceiptData[0].S_Currency,
                //    S_Notation = ReceiptData[0].S_Notation,
                //    C_Factor = ReceiptData[0].C_Factor,
                //    Currency_RoundOff = ReceiptData[0].Currency_RoundOff,
                //    CurrencyRoundDigit = ReceiptData[0].CurrencyRoundDigit,
                //    Converson_ID = ReceiptData[0].Converson_ID

                //};
                //int advID = adv.Insert();
                //if (advID == 0)
                //{
                //    tnx.Rollback();
                //    return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = "Error In OPD Advance" });
                //}
            }
            if (AdvanceAmtID != 0)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update f_receipt SET BalanceAmount =BalanceAmount+@BalanceAmount WHERE ID =@ID ",
                                                                    new MySqlParameter("@BalanceAmount", Util.GetDecimal(totalAmt)),
                                                                    new MySqlParameter("@ID", AdvanceAmtID));

                OPD_Advance_Detail adv = new OPD_Advance_Detail(tnx)
                {
                    PaidAmount = Util.GetDecimal(totalAmt),
                    Patient_ID = string.Empty,
                    LedgerTransactionID = 0,
                    LedgerTransactionNo = string.Empty,
                    ReceiptNo = string.Empty,
                    CentreID = ReceiptData[0].CentreID,
                    Panel_ID = LtData[0].PanelID,
                    CreatedBy = UserInfo.LoginName,
                    CreatedByID = UserInfo.ID,
                    AdvanceID = AdvanceAmtID,
                    ReceiptNoAgainst = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ReceiptNo FROM f_receipt WHERE ID =@ID",
                     new MySqlParameter("@ID", AdvanceAmtID))),
                    AdvanceType = "Client"


                };
            }
            int isallow = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1)  FROM sms_configuration WHERE id=21 AND IsClient=1"));
            if (isallow == 1)
            {
                DataTable dtclient = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Company_Name,Mobile,CentreType1ID FROM f_panel_master WHERE Panel_ID=@Panel_ID",
                  new MySqlParameter("@Panel_ID", LtData[0].PanelID)).Tables[0];
                SMSDetail sd = new SMSDetail();
                List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>  
                        {  
                            new SMSDetailListRegistration {
                                                LabNo= Util.GetString(LtData[0].PanelID),
                                                PName = Util.GetString(dtclient.Rows[0]["Company_Name"]),
                                                PaidAmout=Util.GetString(totalPaidAmount)
                                                                       
                                               }   
                        };
                if (Util.GetString(dtclient.Rows[0]["Mobile"]) != string.Empty)
                {
                    JSONResponse SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(21, Util.GetInt(LtData[0].PanelID), Util.GetInt(dtclient.Rows[0]["CentreType1ID"]), "Client", Util.GetString(dtclient.Rows[0]["Mobile"]), Util.GetInt(LtData[0].PanelID), con, tnx, SMSDetail));

                    if (SMSResponse.status == false)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                    }
                }

                SMSDetail.Clear();
            }

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class Bulksettelment
    {
        public string LabNo { get; set; }
        public int LabID { get; set; }
        public string RegNo { get; set; }
        public string PName { get; set; }
        public int PanelID { get; set; }
        public DateTime dtFrom { get; set; }
        public DateTime dtTo { get; set; }
        public string Dept { get; set; }
        public string ReferDoctor { get; set; }
        public int CentreID { get; set; }
        public decimal PaidAmount { get; set; }
        public decimal Amount { get; set; }
        public int OnlyBalPatient { get; set; }
    }
}