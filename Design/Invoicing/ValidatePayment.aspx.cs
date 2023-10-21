using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using System.Web.Services;
using MySql.Data.MySqlClient;
using System.Web.Script.Services;
using System.Web.Script.Serialization;
using System.Linq;
using Newtonsoft.Json;

public partial class Design_Invoicing_ValidatePayment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindPanelAndPaymentMode();
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
        }
    }
    private void bindPanelAndPaymentMode()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {

            using (DataTable dtPaymentMode = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT PaymentModeID,PaymentMode FROM paymentmode_master WHERE Active=1 AND PaymentModeID NOT  IN (4,9) ORDER BY Sequence+0 ").Tables[0])
            {
                if (dtPaymentMode.Rows.Count > 0)
                {
                    ddlSearchPaymentMode.DataSource = dtPaymentMode;
                    ddlSearchPaymentMode.DataValueField = "PaymentModeID";
                    ddlSearchPaymentMode.DataTextField = "PaymentMode";
                    ddlSearchPaymentMode.DataBind();

                }
                else
                {
                    ddlSearchPaymentMode.DataSource = null;
                    ddlSearchPaymentMode.DataBind();
                }
                ddlSearchPaymentMode.Items.Insert(0, new ListItem("All", "All"));
            }
            using (dt as IDisposable)
            {
                if (UserInfo.Centre == 1)
                {
                    dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Company_Name,Panel_ID FROM f_panel_master WHERE IsActive=1  AND Panel_ID=InvoiceTo AND PanelType<>'RateType' AND `InvoiceCreatedOn`=2 ORDER BY Company_Name").Tables[0];
                }
                else
                {
                    dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT pm.Company_Name,pm.Panel_ID FROM f_panel_master pm WHERE pm.IsActive=1  AND pm.Panel_ID=pm.InvoiceTo AND ( pm.`TagBusinessLabID` = @CentreID OR pm.CentreId = @CentreID ) AND PanelType<>'RateType' AND `InvoiceCreatedOn`=2  ORDER BY pm.Company_Name ",
                        new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0];
                }

                if (dt.Rows.Count > 0)
                {
                    ddlPanel.DataSource = dt;
                    ddlPanel.DataTextField = "Company_Name";
                    ddlPanel.DataValueField = "Panel_ID";
                    ddlPanel.DataBind();
                    ddlPanel.Items.Insert(0, new ListItem("Select", "0"));
                }
                else
                {
                    ddlPanel.Items.Clear();
                }
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
    public class PaySearchType
    {
        public string SearchType { get; set; }
    }

    public static List<PaySearchType> SearchDateType()
    {
        List<PaySearchType> dateSearchType = new List<PaySearchType>();
        dateSearchType.Add(new PaySearchType() { SearchType = "ivac.ReceivedDate" });
        dateSearchType.Add(new PaySearchType() { SearchType = "ivac.EntryDate" });
        dateSearchType.Add(new PaySearchType() { SearchType = "ivac.ApprovedOnDate" });
        return dateSearchType;
    }
    [WebMethod(EnableSession = true)]
    public static string SearchPendingValidation(string PanelID, string FromDate, string ToDate, string Status, string Paymentmode, string Type)
    {
        if (SearchDateType().Where(m => Type.Contains(m.SearchType)).Count() == 0)
        {
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Invalid Date Type" });
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Status == "0")
            {
                sb.Append(" SELECT TransactionID,S_CountryID, PaymentModeID,  IFNULL(ivac.invoiceNo,'') invoiceNo ,IFNULL(ivac.InvoiceAmount,'') InvoiceAmount, ivac.PaymentMode,");
                sb.Append(" ivac.BankName, ivac.CardNo, IF(ivac.CardNo='','',DATE_FORMAT(ivac.CardDate,'%d-%M-%y')) CardDate, ivac.S_Currency, ivac.S_Amount, ");
                sb.Append(" ivac.C_Factor,     fpm.MonthlyInvoiceType, fpm.Payment_Mode AdvType, ivac.`ID`, fpm.`Company_Name`,fpm.panel_id,");
                sb.Append(" ivac.`ReceivedAmt` `ReceivedAmt`,ivac.EntryByName EntryBy,ivac.`PaymentMode`,ivac.ValidateStatus,ivac.IsCancel, ivac.ReceiptNo,ivac.EntryType, ");
                sb.Append(" DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y %I:%i%p') AdvanceAmtDate ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i%p') EntryDate,ivac.EntryType, ");
                sb.Append(" fpm.Payment_Mode,fpm.CentreID,IFNULL(ivac.ChequeNo,'')ChequeNo,IFNULL(ivac.Bank,'')Bank, ");
                sb.Append(" IF( (SELECT MAX(EntryDate)   FROM `invoicemaster_payment`   WHERE  isCancel=0  AND  IFNULL(invoiceNo, '') <> '') > ivac.`EntryDate`,0,1)`AllowCancel`, ");
                sb.Append(" remarks,IsMainPayment  FROM `invoicemaster_payment` ivac  ");
                sb.Append("  INNER JOIN `f_panel_master` fpm ON ivac.`Panel_id` = fpm.`Panel_ID` WHERE isCancel = 0 AND fpm.InvoiceCreatedOn=2  ");
                if (UserInfo.Centre != 1)
                {
                    sb.Append("  AND ( fpm.`TagBusinessLabID` = @CentreID  OR fpm.CentreId = @CentreID) ");
                }
                if (PanelID != "0")
                {
                    sb.Append(" AND ivac.panel_id = @PanelID ");
                }

                sb.Append(" AND ivac.ValidateStatus=0    AND ivac.TYPE='ON ACCOUNT' ");
                if (Paymentmode.ToUpper() != "ALL")
                    sb.Append(" AND ivac.PaymentModeID =@PaymentModeID ");
                sb.Append("     ORDER BY ivac.`receiveddate` DESC  ");
            }
            else
            {
                sb.Append(" SELECT IFNULL(ivac.invoiceNo,'') invoiceNo ,0 InvoiceAmount, fpm.Payment_Mode AdvType, ivac.PaymentMode, ivac.BankName, ivac.CardNo,");
                sb.Append(" IF(ivac.CardNo='','',ivac.CardDate) CardDate, ivac.S_Currency, ivac.S_Amount, ivac.C_Factor, fpm.MonthlyInvoiceType, ivac.`ID`,");
                sb.Append(" fpm.`Company_Name`,fpm.panel_id,ivac.`ReceivedAmt` `ReceivedAmt`,ivac.EntryByName EntryBy,ivac.`PaymentMode`,ivac.ValidateStatus,");
                sb.Append(" ivac.IsCancel, ivac.ReceiptNo,ivac.EntryType, ");
                sb.Append(" DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y %I:%i%p') AdvanceAmtDate ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i%p') EntryDate,");
                sb.Append(" ivac.EntryType,fpm.Payment_Mode,fpm.CentreID,IFNULL(ivac.ChequeNo,'')ChequeNo,IFNULL(ivac.Bank,'')Bank, ");
                sb.Append(" IF( (SELECT MAX(EntryDate)   FROM `invoicemaster_onaccount`   WHERE panel_id = @PanelID and isCancel=0  AND  IFNULL(invoiceNo, '') <> '') > ivac.`EntryDate`,0,1)`AllowCancel`,");
                sb.Append("  remarks,1 IsMainPayment  FROM `invoicemaster_onaccount` ivac  ");
                sb.Append("  INNER JOIN `f_panel_master` fpm ON ivac.`Panel_id` = fpm.`Panel_ID` WHERE isCancel = 0 AND fpm.InvoiceCreatedOn=2 AND ivac.ValidateStatus=1  AND ivac.TYPE='ON ACCOUNT'  ");

                if (Paymentmode.ToUpper() != "ALL")
                {
                    sb.Append(" AND ivac.PaymentModeID = @PaymentModeID ");
                }
                if (UserInfo.Centre != 1)
                {
                    sb.Append("  AND ( fpm.`TagBusinessLabID` =@CentreID OR fpm.CentreId =@CentreID ) ");
                }
                if (PanelID != "0")
                {
                    sb.Append(" AND ivac.panel_id =@PanelID ");
                }
                sb.AppendFormat(" AND {0}>=@FromDate AND {0}<=@ToDate", Type);
                sb.Append(" ORDER BY ivac.`receivedDate` DESC  ");
            }
            string fromDate = string.Empty;
            string toDate = string.Empty;

            if (Type != "ivac.ReceivedDate")
            {
                fromDate = string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " ", "00:00:00");
                toDate = string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " ", "23:59:59");


            }
            else
            {
                fromDate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
                toDate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");
            }

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CentreID", UserInfo.Centre),
                new MySqlParameter("@PanelID", PanelID.Trim()),
                new MySqlParameter("@PaymentModeID", Paymentmode),
                new MySqlParameter("@FromDate", fromDate),
                new MySqlParameter("@ToDate", toDate)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, data = dt });
                else
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "No Record Found" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = ex.GetBaseException() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string bindHLMPaymentMode(int ID, string ReceiptNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ivac.`ID`,ivac.`InvoiceNo`,ivac.`InvoiceAmount`, ivac.`ReceivedAmt` `ReceivedAmt`,ivac.EntryByName EntryBy,ivac.`PaymentMode`,ivac.ValidateStatus,ivac.IsCancel ");
            sb.Append("  ,DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y %I:%i%p') AdvanceAmtDate ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i%p') EntryDate ");
            sb.Append(" FROM `invoicemaster_payment` ivac  WHERE isCancel = 0 AND ivac.ValidateStatus=0 AND ivac.TYPE='ON ACCOUNT' ");
            sb.Append("  AND ReceiptNo=@ReceiptNo ORDER BY ivac.ID+0   ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@ReceiptNo", ReceiptNo)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, data = dt });
                else
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "No Record Found" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = ex.GetBaseException() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string finalValidate(string data, string InvoiceNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string[] arra = data.Split('|');
            string ID = arra[2];

            int amountValidate = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT COUNT(1) FROM Invoicemaster_Payment WHERE ID=@ID AND ValidateStatus!=0",
                                   new MySqlParameter("@ID", ID)));
            if (amountValidate > 0)
            {
                Tranx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Payment Already Validate or Cancel,Please Reopen Page" });
            }

            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO invoicemaster_onaccount(InvoiceNo,ReceivedAmt ,Type,Bank,CreditCardNo,DraftNo,DraftDate,ChequeNo,ChequeDate, ");
            sb.Append(" EntryDate,EntryBy,ReceivedDate,Remarks,Panel_id,AdvanceAmtDate,EntryByName,ReceiptNo,UpdateDate,UpdateUserID,CreditNote,ApprovedBy,ApprovedByID,");
            sb.Append(" ApprovedOnDate,ValidateStatus,BankID,EntryType,invoicemaster_payment_id,PayBy,  PaymentMode,BankName, CardNo, ");
            sb.Append(" CardDate, Narration, PaymentModeID, S_Amount, S_CountryID, S_Currency, S_Notation, C_Factor, Currency_RoundOff, CurrencyRoundDigit, Converson_ID,IsMainPayment,MainPaymentID) ");
            sb.Append(" SELECT InvoiceNo,ReceivedAmt ,Type,Bank,CreditCardNo,DraftNo,DraftDate,ChequeNo,ChequeDate, ");
            sb.Append(" EntryDate,EntryBy,ReceivedDate,Remarks,Panel_id,AdvanceAmtDate,EntryByName,ReceiptNo,UpdateDate,UpdateUserID,CreditNote,@LoginName,@UpdateUserID, ");
            sb.Append(" Now(),1,BankID,EntryType,ID,PayBy,  PaymentMode, BankName, CardNo, ");
            sb.Append(" CardDate, Narration, PaymentModeID, S_Amount, S_CountryID, S_Currency, S_Notation, C_Factor, Currency_RoundOff, CurrencyRoundDigit, Converson_ID,IsMainPayment,MainPaymentID ");
            sb.Append(" FROM invoicemaster_payment  WHERE ID=@ID");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ID", ID),
                new MySqlParameter("@LoginName", UserInfo.LoginName),
                new MySqlParameter("@UpdateUserID", UserInfo.ID));

            int invoicemaster_onaccount_ID = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT @@identity"));

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "Update invoicemaster_payment SET ValidateStatus=1,ValidateBy=@ValidateBy,ValidateByID=@ValidateByID,ValidateDate=NOW(),invoicemaster_onaccount_ID=@invoicemaster_onaccount_ID WHERE ID=@ID",
                new MySqlParameter("@ID", ID),
                new MySqlParameter("@ValidateBy", UserInfo.LoginName),
                new MySqlParameter("@ValidateByID", UserInfo.ID),
                new MySqlParameter("@invoicemaster_onaccount_ID", invoicemaster_onaccount_ID));

            //if (arra[3].ToUpper() == "PCC" || (arra[3].ToUpper() == "PUP" && arra[4] == "Credit"))
            //{
            //    int CentreID = 0;
            //    if (arra[3].ToUpper() == "PCC")
            //        CentreID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CentreID FROM f_panel_master WHERE Panel_ID=@Panel_ID AND PanelType='Centre' ",
            //            new MySqlParameter("@Panel_ID", arra[0])));
            //    else
            //        CentreID = Util.GetInt(arra[0]);
            //    decimal TotalOutstanding = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, "CALL Get_balance_amount(@type,@CentreID)",
            //        new MySqlParameter("@type", arra[3].ToUpper()),
            //        new MySqlParameter("@CentreID", CentreID)));

            //    decimal AdvAmount = 0;

            //    if (Util.GetDecimal(TotalOutstanding) < 0 && Util.GetDecimal(AdvAmount) >= Util.GetDecimal(TotalOutstanding) * (-1))
            //    {
            //        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE f_panel_master SET  MaxExpiry=@MaxExpiry where Panel_ID=@Panel_ID ",
            //            new MySqlParameter("@MaxExpiry", DateTime.Now.AddHours(24).ToString("yyyy-MM-dd HH:mm:ss")),
            //            new MySqlParameter("@Panel_ID", arra[0]));
            //    }
            //}
            if (InvoiceNo != string.Empty)
            {
                decimal InvoiceAmt = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SUM(ShareAmt)ShareAmt FROM   invoiceMaster WHERE IsCancel=0 AND InvoiceNo=@InvoiceNo",
                        new MySqlParameter("@InvoiceNo", InvoiceNo)));
                decimal ReceivedAmt = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT SUM(ReceivedAmt)ReceivedAmt FROM  Invoicemaster_Payment WHERE IsCancel=0 AND InvoiceNo=@InvoiceNo",
                        new MySqlParameter("@InvoiceNo", InvoiceNo)));

                if (Util.GetDecimal(InvoiceAmt) == Util.GetDecimal(ReceivedAmt))
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE invoiceMaster SET IsClose=1 WHERE InvoiceNo=@InvoiceNo",
                        new MySqlParameter("@InvoiceNo", InvoiceNo));
                }
            }
            //sms
            int isallow = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1)  FROM sms_configuration WHERE id=17 AND IsClient=1"));
            if (isallow == 1)
            {
                string ShareAmt = "";
                
                    ShareAmt = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Round(ReceivedAmt)  FROM invoicemaster_payment WHERE ID=@ID",
                        new MySqlParameter("@ID", ID)));
              
                DataTable dtclient = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Company_Name,Mobile,CentreType1ID FROM f_panel_master WHERE Panel_ID=@Panel_ID",
                    new MySqlParameter("@Panel_ID", arra[0])).Tables[0];
                SMSDetail sd = new SMSDetail();
                JSONResponse SMSResponse = new JSONResponse();

                List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>{  
                                                             new SMSDetailListRegistration {
                                                                 LabNo=Util.GetString(arra[0]), 
                                                                 PName = Util.GetString(dtclient.Rows[0]["Company_Name"]), 
                                                                 NetAmount=Util.GetString(ShareAmt),
                                                               GrossAmount=Util.GetString(ShareAmt)}};

                if (Util.GetString(dtclient.Rows[0]["Mobile"]) != string.Empty)
                {
                    SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(17, Util.GetInt(arra[0]), Util.GetInt(dtclient.Rows[0]["CentreType1ID"]), "Client", Util.GetString(dtclient.Rows[0]["Mobile"]), Util.GetInt(arra[0]), con, Tranx, SMSDetail));
                    if (SMSResponse.status == false)
                    {
                        Tranx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                    }
                }
                SMSDetail.Clear();
            }

            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Amount Confirmed Successfully" });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }

        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string CancelAmountSubmission(string data, string CancelReason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string[] arra = data.Split('|');
            string ID = arra[2];
            StringBuilder sb = new StringBuilder();

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE invoicemaster_payment SET ValidateStatus=2,IsCancel=1,CancelUserID=@CancelUserID,CancelUserName=@CancelUserName,CancelDateTime=Now(),CancelReason=@CancelReason where ID=@ID",
                new MySqlParameter("@CancelUserID", UserInfo.ID),
                new MySqlParameter("@CancelUserName", UserInfo.LoginName),
                new MySqlParameter("@ID", ID),
                new MySqlParameter("@CancelReason", CancelReason));


            if (arra[3].ToUpper() == "PCC" || (arra[3].ToUpper() == "PUP" && arra[4] == "Credit"))
            {
                int CentreID = 0;
                if (arra[3].ToUpper().ToUpper() == "PCC")
                    CentreID = Util.GetInt(arra[5]);
                else
                    CentreID = Util.GetInt(arra[0]);
                decimal TotalOutstanding = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, "CALL get_balance_amount(@type,@CentreID)",
                    new MySqlParameter("@type", arra[3].ToUpper()),
                    new MySqlParameter("@CentreID", CentreID)));

                if (Util.GetDecimal(TotalOutstanding) < 0)
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE f_panel_master SET  MaxExpiry=@MaxExpiry WHERE Panel_ID=@Panel_ID ",
                        new MySqlParameter("@MaxExpiry", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")),
                        new MySqlParameter("Panel_ID", arra[0]));
                }
            }
            //sms
            int isallow = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1)  FROM sms_configuration WHERE id=18 AND IsClient=1"));
            if (isallow == 1)
            {
                string ShareAmt = "";

                ShareAmt = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Round(ReceivedAmt)  FROM invoicemaster_payment WHERE ID=@ID",
                    new MySqlParameter("@ID", ID)));

                DataTable dtclient = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Company_Name,Mobile,CentreType1ID FROM f_panel_master WHERE Panel_ID=@Panel_ID",
                    new MySqlParameter("@Panel_ID", arra[0])).Tables[0];
                SMSDetail sd = new SMSDetail();
                JSONResponse SMSResponse = new JSONResponse();

                List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>{  
                                                             new SMSDetailListRegistration {
                                                                 LabNo=Util.GetString(arra[0]), 
                                                                 PName = Util.GetString(dtclient.Rows[0]["Company_Name"]), 
                                                                 NetAmount=Util.GetString(ShareAmt),
                                                               GrossAmount=Util.GetString(ShareAmt)}};

                if (Util.GetString(dtclient.Rows[0]["Mobile"]) != string.Empty)
                {
                    SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(18, Util.GetInt(arra[0]), Util.GetInt(dtclient.Rows[0]["CentreType1ID"]), "Client", Util.GetString(dtclient.Rows[0]["Mobile"]), Util.GetInt(arra[0]), con, Tranx, SMSDetail));
                    if (SMSResponse.status == false)
                    {
                        Tranx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                    }
                }
                SMSDetail.Clear();
            }
            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = ex.GetBaseException() });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateAdvPayment(PanelAdvanceAmount1 PanelAdvanceAmount, string ID, int IsMainPayment, string PaymentUpdateRemark)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            int amountValidate = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT COUNT(1) FROM Invoicemaster_Payment WHERE ID=@ID AND ValidateStatus=1",
               new MySqlParameter("@ID", ID)));
            if (amountValidate > 0)
            {
                Tranx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Payment Already Validate" });
            }
            DataTable InvoiceDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT IFNULL(InvoiceNo,'')InvoiceNo,IsMainPayment,MainPaymentID  FROM Invoicemaster_Payment WHERE ID=@ID ",
                  new MySqlParameter("@ID", ID)).Tables[0];
            if (InvoiceDetail.Rows[0]["InvoiceNo"].ToString() != string.Empty)
            {

                decimal InvoiceAmt = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, " SELECT shareAmt FROM `invoicemaster` WHERE InvoiceNo=@InvoiceNo",
                   new MySqlParameter("@InvoiceNo", InvoiceDetail.Rows[0]["InvoiceNo"].ToString())));

                sb = new StringBuilder();
                // if (Util.GetInt(InvoiceDetail.Rows[0]["MainPaymentID"].ToString()) != 0)
                // {
                //     sb.Append(" SELECT SUM(ReceivedAmt)ReceivedAmt FROM Invoicemaster_Payment WHERE MainPaymentID!=@ID AND InvoiceNo=@InvoiceNo");
                // }
                // else
                // {
                sb.Append(" SELECT SUM(ReceivedAmt)ReceivedAmt FROM Invoicemaster_Payment WHERE ID!=@ID  AND InvoiceNo=@InvoiceNo");
                // }


                decimal totalReceiveAmt = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@ID", ID),
                    new MySqlParameter("@InvoiceNo", InvoiceDetail.Rows[0]["InvoiceNo"].ToString())));

                decimal totalPaidAmt = Util.GetDecimal(PanelAdvanceAmount.AdvAmount) + Util.GetDecimal(totalReceiveAmt);
                if (totalPaidAmt > InvoiceAmt)
                {
                    Tranx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = "Total Paid Amount cannot greater then Invoice Amount" });

                }
            }

            sb = new StringBuilder();
            sb.Append(" Update  Invoicemaster_Payment SET ReceivedAmt=@AdvAmt,UpdateDate=NOW(),UpdateUserID=@UpdateUserID,");
            if (Util.GetInt(InvoiceDetail.Rows[0]["IsMainPayment"].ToString()) == 1)
            {
                sb.Append(" PaymentMode=@PaymentMode,PaymentModeID=@PaymentModeID,BankName=@BankName, CardNo=@CardNo, CardDate=@CardDate, ");
                sb.Append(" S_CountryID=@S_CountryID, S_Currency=@S_Currency,S_Notation=@S_Notation, C_Factor=@C_Factor, Currency_RoundOff=@Currency_RoundOff,");
                sb.Append("  CurrencyRoundDigit=@CurrencyRoundDigit,Converson_ID=@Converson_ID, ");
            }
            else
            {

            }
            sb.Append(" S_Amount=@S_Amount,PaymentUpdateRemark=@PaymentUpdateRemark ");
            sb.Append(" WHERE ID=@ID");

            using (MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tranx))
            {
                cmd.Parameters.AddWithValue("@ID", ID);
                cmd.Parameters.AddWithValue("@UpdateUserID", UserInfo.ID);

                if (Util.GetInt(InvoiceDetail.Rows[0]["IsMainPayment"].ToString()) == 1)
                {

                    cmd.Parameters.AddWithValue("@AdvAmt", Util.GetDecimal(PanelAdvanceAmount.AdvAmount));
                    cmd.Parameters.AddWithValue("@PaymentMode", PanelAdvanceAmount.PaymentMode.Trim());

                    cmd.Parameters.AddWithValue("@BankName", PanelAdvanceAmount.BankName);
                    cmd.Parameters.AddWithValue("@CardNo", PanelAdvanceAmount.CardNo);
                    cmd.Parameters.AddWithValue("@CardDate", PanelAdvanceAmount.CardDate);
                    cmd.Parameters.AddWithValue("@Narration", PanelAdvanceAmount.Narration);
                    cmd.Parameters.AddWithValue("@PaymentModeID", PanelAdvanceAmount.PaymentModeID);
                    cmd.Parameters.AddWithValue("@S_Amount", PanelAdvanceAmount.S_Amount);
                    cmd.Parameters.AddWithValue("@S_CountryID", PanelAdvanceAmount.S_CountryID);
                    cmd.Parameters.AddWithValue("@S_Currency", PanelAdvanceAmount.S_Currency);
                    cmd.Parameters.AddWithValue("@S_Notation", PanelAdvanceAmount.S_Notation);
                    cmd.Parameters.AddWithValue("@C_Factor", PanelAdvanceAmount.C_Factor);
                    cmd.Parameters.AddWithValue("@Currency_RoundOff", PanelAdvanceAmount.Currency_RoundOff);
                    cmd.Parameters.AddWithValue("@CurrencyRoundDigit", PanelAdvanceAmount.CurrencyRoundDigit);
                    cmd.Parameters.AddWithValue("@Converson_ID", PanelAdvanceAmount.Converson_ID);
                }
                else
                {
                    cmd.Parameters.AddWithValue("@AdvAmt", Util.GetDecimal(PanelAdvanceAmount.AdvAmount));
                    cmd.Parameters.AddWithValue("@S_Amount", PanelAdvanceAmount.AdvAmount);

                }
                cmd.Parameters.AddWithValue("@PaymentUpdateRemark", PaymentUpdateRemark);

                cmd.ExecuteNonQuery();
                cmd.Dispose();
            }
            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Amount Details Updated" });
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = ex.GetBaseException() });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public class PanelAdvanceAmount1
    {
        public decimal AdvAmount { get; set; }
        public string BankName { get; set; }
        public string PaymentMode { get; set; }
        public int PaymentModeID { get; set; }
        public string CardNo { get; set; }
        public DateTime CardDate { get; set; }
        public string Narration { get; set; }
        public decimal S_Amount { get; set; }
        public int S_CountryID { get; set; }
        public string S_Currency { get; set; }
        public string S_Notation { get; set; }
        public decimal C_Factor { get; set; }
        public decimal Currency_RoundOff { get; set; }
        public byte CurrencyRoundDigit { get; set; }
        public int Converson_ID { get; set; }
    }
}
