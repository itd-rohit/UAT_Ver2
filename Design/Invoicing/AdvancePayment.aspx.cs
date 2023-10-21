using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Linq;
public partial class Design_Invoicing_AdvancePayment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        dtFrom.Attributes.Add("readOnly", "true");
    }
    [WebMethod(EnableSession = true)]
    public static string getInvoice(string id, string Type)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("           SELECT io.ReceiptNo InvoiceNo,pm.Panel_id, pm.`Panel_Code`,pm.`Company_Name` PanelName,CONCAT(pm.add1,'Mobile:',pm.Mobile,',Email:',pm.EmailID) Address,io.`ReceivedAmt` BalAmt,CASE WHEN io.CreditNote=0 THEN 'Receipt' WHEN io.CreditNote=1 THEN 'Credit Note' ELSE 'Debit Note' END `Header`,   ");
        sb.Append("    (SELECT CONCAT(title,NAME) FROM `employee_master` WHERE Employee_ID=io.`EntryBy`)DepositBy , DATE_FORMAT(io.EntryDate,'%d-%b-%y')DepositDate , DATE_FORMAT(io.ReceivedDate,'%d-%b-%y')InvoiceDate , io.Remarks  Period,");
        if (Type.ToUpper() == "CREDIT NOTE" || Type.ToUpper() == "DEBIT NOTE")
        {
            sb.Append(" io.Remarks PaymentMode  ");
        }
        else
        {
            sb.Append(" IF(PaymentMode='CASH','CASH',IF(PaymentMode='CHEQUE',CONCAT('CHEQUE ',IF((Bank='' OR Bank='.'),'',CONCAT(',Bank : ',bank)),', ChequeNo : ',io.ChequeNo),IF(PaymentMode='NEFT','NEFT',''))) PaymentMode  ");
        }
        sb.Append("    FROM `invoicemaster_onaccount`  io INNER JOIN f_panel_master pm ON pm.`Panel_ID`=io.`Panel_id` and io.id='" + id + "' AND pm.`Panel_ID`=pm.`InvoiceTo`  ");

        DataTable dtInvoice = StockReports.GetDataTable(sb.ToString());
        if (dtInvoice.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dtInvoice.Copy());
            ds.Tables[0].TableName = "dtInvoice";
            HttpContext.Current.Session["ds"] = ds;
            if (Type.ToUpper() == "DEBIT NOTE")
            {
                HttpContext.Current.Session["ReportName"] = "Invoice_Cash_Debit";
            }
            else if (Type.ToUpper() == "CREDIT NOTE")
            {
                HttpContext.Current.Session["ReportName"] = "Invoice_Cash_Credit";
            }
            else
            {
                HttpContext.Current.Session["ReportName"] = "Invoice_Cash";
            }
        }

        return ((dtInvoice.Rows.Count > 0) ? "1" : "0");
    }
    public static DataTable PrevAdvPayment(string PanelID, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ivac.S_Currency, ivac.S_Amount, ivac.C_Factor, IFNULL(ivac.CardNo,'') CardNo, IF(IFNULL(ivac.CardNo,'')='','',DAte_Format(CardDate,'%d-%M-%y')) CardDate, ivac.`ID`,fpm.Panel_Code, fpm.`Company_Name`,ivac.`ReceivedAmt` `ReceivedAmt`,ivac.EntryByName EntryBy ");
        sb.Append(" , DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y') AdvanceAmtDate,(case when ivac.CreditNote='0' then 'Deposit' when ivac.CreditNote='1' then 'Credit Note' when ivac.CreditNote='2' then 'Debit Note' when ivac.CreditNote='3' then 'Cheque Bounce' else '' end )CreditNote ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i %p') EntryDate ");
        sb.Append(" ,IF((SELECT MAX(EntryDate) FROM `invoicemaster_onaccount`   WHERE panel_id = IF(@panel_id='',panel_id,@panel_id) AND isCancel=0  AND  IFNULL(invoiceNo, '') <> '' Limit 1) > ivac.`EntryDate`,0,1)`AllowCancel`         ");
        sb.Append(" , remarks,PaymentMode,IFNULL(ChequeNo,'')ChequeNo,IF(ivac.ChequeDate='0001-01-01','',DATE_FORMAT(ivac.ChequeDate,'%d-%b-%Y'))ChequeDate,(SELECT TransactionID FROM Invoicemaster_Payment WHERE invoicemaster_onaccount_ID =ivac.ID limit 1) TransactionID  FROM `invoicemaster_onaccount` ivac  ");
        sb.Append(" INNER JOIN `f_panel_master` fpm ON ivac.`Panel_id` = fpm.`Panel_ID` WHERE ivac.panel_id = if(@panel_id='',ivac.panel_id,@panel_id)  ");
        sb.Append(" AND isCancel = 0   ");//AND CreditNote=@CreditNote
        sb.Append(" ORDER BY ivac.`receivedDate` DESC limit 100  ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
             new MySqlParameter("@panel_id", PanelID)).Tables[0];
            // new MySqlParameter("@CreditNote", typeofPayment)).Tables[0];
    }
    [WebMethod]
    public static string SearchPrevAdvPayment(string PanelID)
    {
        //, int typeofPayment
        if (PanelID == string.Empty)
        {
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "No Record Found" });
        }
        else
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {

                using (DataTable dtresult = PrevAdvPayment(PanelID,  con))
                {
                    if (dtresult.Rows.Count > 0)
                        return JsonConvert.SerializeObject(new { status = true, data = dtresult });
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
    }

    [WebMethod(EnableSession = true)]
    public static string RejectPrevAdvPayment(string ID, string CancelReason, decimal? ChequeBounceAmt)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT COUNT(1) FROM invoicemaster_onaccount  WHERE IsCancel=1 AND ID=@ID ",
                   new MySqlParameter("@ID", ID)));
            if (count > 0)
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Payment Already Cancel" });

            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, " UPDATE invoicemaster_onaccount SET CancelReason=@CancelReason, ValidateStatus=2,`IsCancel`=1, `CancelUserID`=@CancelUserID,`CancelUserName`=@CancelUserName,`CancelDateTime`=NOW() WHERE id=@ID",
               new MySqlParameter("@CancelReason", CancelReason),
               new MySqlParameter("@CancelUserID", UserInfo.ID),
               new MySqlParameter("@CancelUserName", UserInfo.LoginName),
               new MySqlParameter("@ID", Util.GetString(ID.Trim())));

            int Invoicemaster_Payment_ID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Invoicemaster_Payment_ID FROM invoicemaster_onaccount WHERE ID=@ID ",
               new MySqlParameter("@ID", Util.GetString(ID.Trim()))));
            if (Invoicemaster_Payment_ID != 0)
            {
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, " UPDATE Invoicemaster_Payment SET CancelReason=@CancelReason, ValidateStatus=2,`IsCancel`=1, `CancelUserID`=@CancelUserID,`CancelUserName`=@CancelUserName,`CancelDateTime`=NOW() WHERE ID=@ID",
                   new MySqlParameter("@CancelReason", CancelReason),
                   new MySqlParameter("@CancelUserID", UserInfo.ID),
                   new MySqlParameter("@CancelUserName", UserInfo.LoginName),
                   new MySqlParameter("@ID", Invoicemaster_Payment_ID));
            }
            if (ChequeBounceAmt != null)
            {
                DataTable onaccount = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Panel_ID,Bank,BankID,ChequeNo,EntryType FROM invoicemaster_onaccount WHERE id=@ID",
               new MySqlParameter("@ID", ID.Trim())).Tables[0];

                ChequeBounceAmt = Util.GetDecimal(ChequeBounceAmt) * (-1);
                string receiptno = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT get_receiptno_invoice(@typeOfPayment,@PanelID,@dtAdv)",
                                 new MySqlParameter("@typeOfPayment", Util.GetInt(2)),
                                 new MySqlParameter("@PanelID", Util.GetInt(onaccount.Rows[0]["Panel_ID"].ToString())),
                                 new MySqlParameter("@dtAdv", Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd"))));

                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO invoicemaster_onaccount(ReceivedAmt,EntryDate,EntryBy,Panel_id,PaymentMode ,`Type`,`Bank`,ChequeDate ,ChequeNo ");
                sb.Append(" ,ReceiptNo,Remarks , EntryByName, receivedDate, CreditNote,BankID,EntryType,ValidateStatus,ApprovedBy,ApprovedByID,ApprovedOnDate) ");
                sb.Append(" VALUES (@ReceivedAmt,now() ,@EntryBy,@PanelID, @PaymentType, 'ON ACCOUNT',@Bank,@ChequeDate,@ChequeNo  ");
                sb.Append(",@ReceiptNo, @Remarks, @EntryByName,@receivedDate ,@typeOfPayment,@BankID,@EntryType,'1',@ApprovedBy,@ApprovedByID,NOW() ) ");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tranx);
                cmd.Parameters.AddWithValue("@ReceivedAmt", Util.GetDouble(ChequeBounceAmt));
                cmd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmd.Parameters.AddWithValue("@PanelID", Util.GetInt(onaccount.Rows[0]["Panel_ID"].ToString()));
                cmd.Parameters.AddWithValue("@PaymentType", "Cheque");
                cmd.Parameters.AddWithValue("@Bank", onaccount.Rows[0]["Bank"].ToString());
                cmd.Parameters.AddWithValue("@ChequeDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@ChequeNo", onaccount.Rows[0]["ChequeNo"].ToString());
                cmd.Parameters.AddWithValue("@ReceiptNo", receiptno);
                cmd.Parameters.AddWithValue("@Remarks", "Cheque Bounce");
                cmd.Parameters.AddWithValue("@EntryByName", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@receivedDate", DateTime.Now);
                cmd.Parameters.AddWithValue("@typeOfPayment", Util.GetInt(2));
                cmd.Parameters.AddWithValue("@BankID", onaccount.Rows[0]["BankID"].ToString());
                cmd.Parameters.AddWithValue("@EntryType", onaccount.Rows[0]["EntryType"].ToString());
                cmd.Parameters.AddWithValue("@ApprovedBy", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@ApprovedByID", UserInfo.ID);
                cmd.ExecuteNonQuery();
                cmd.Dispose();
            }
            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true, ErrorMsg = "" });
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
    public static string SaveAdvPayment(object PanelAdvanceAmount)
    {
        List<PanelAdvanceAmount> AdvAmount = new JavaScriptSerializer().ConvertToType<List<PanelAdvanceAmount>>(PanelAdvanceAmount);
        if (Util.GetInt(AdvAmount[0].TypeOfPayment) != 0 && AdvAmount.Count > 0)
        {
           // return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "TDS and WriteOff Amount only allow on Type Deposit" });
        }
        if (AdvAmount[0].PaymentMode.Trim() == string.Empty)
        {
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Please Select Payment Mode" });
        }

        if (AdvAmount[0].PanelID == 0)
        {
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Please Select Payment Mode" });
        }

        if (AdvAmount[0].AdvAmount == 0)
        {
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Please Enter Amount for Advance Payment" });
        }
        if (AdvAmount[0].IsAgainstinvoice == 1)
        {
            if (AdvAmount[0].InvoiceNo == string.Empty)
            {
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Please Select Invoice Amount" });
            }

            if (Util.GetDateTime(AdvAmount[0].DepositeDate) < Util.GetDateTime(AdvAmount[0].InvoiceDate))
            {
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = string.Concat("You can not submit the amount before Invoice Date.Invoice Date ", Util.GetDateTime(AdvAmount[0].InvoiceDate).ToString("dd-MM-yyyy")) });
            }

            if (Util.GetDecimal(AdvAmount[0].AdvAmount) > 200000 && AdvAmount[0].PaymentMode.Trim() == "Cash")
            {
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Cash cannot be accepted more than 200000" });
            }
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
            {
            int InvoiceCreatedOn = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT InvoiceCreatedOn FROM f_panel_master WHERE Panel_ID=@Panel_ID",
                new MySqlParameter("@Panel_ID", AdvAmount[0].PanelID)));
            if (InvoiceCreatedOn == 1 && Util.GetInt(AdvAmount[0].TypeOfPayment) == 0)
            {
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "For Patient Wise Client Deposit not Possible" });
            }

            if (AdvAmount[0].IsAgainstinvoice == 1)
            {
                DataTable invoiceDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ShareAmt,IsCancel FROM invoicemaster WHERE InvoiceNo=@InvoiceNo",
                   new MySqlParameter("@InvoiceNo", AdvAmount[0].InvoiceNo)).Tables[0];
                if (invoiceDetail.Rows[0]["IsCancel"].ToString() == "1")
                {
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Invoice already Cancel,Please Reopen Page" });
                }
                if (Util.GetDecimal(invoiceDetail.Rows[0]["ShareAmt"].ToString()) < Util.GetDecimal(AdvAmount.Select(s => s.AdvAmount).Sum()))
                {
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Please Enter Valid Amount,Payment already received" });
                }

                decimal receivedAmtDetail = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, " SELECT SUM(ReceivedAmt)ReceivedAmt FROM Invoicemaster_Payment WHERE  InvoiceNo=@InvoiceNo AND ValidateStatus!=2",
                   new MySqlParameter("@InvoiceNo", AdvAmount[0].InvoiceNo)));
                if (Util.GetDecimal(invoiceDetail.Rows[0]["ShareAmt"].ToString()) < Util.GetDecimal(receivedAmtDetail)  + Util.GetDecimal(AdvAmount.Select(s => s.AdvAmount).Sum()))
                {
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Please Enter Valid Amount,Payment already received" });
                }
            }


            string receiptno = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT get_receiptno_invoice(@typeOfPayment,@PanelID,@dtAdv)",
                                              new MySqlParameter("@typeOfPayment", Util.GetInt(AdvAmount[0].TypeOfPayment)),
                                              new MySqlParameter("@PanelID", Util.GetInt(AdvAmount[0].PanelID)),
                                              new MySqlParameter("@dtAdv", Util.GetDateTime(AdvAmount[0].DepositeDate).ToString("yyyy-MM-dd"))));
            int IsMainPayment = 1;
           // long MainPaymentIDOnAccount = 0;
           // long MainPaymentIDOnPayment = 0;
            DateTime EntryDate = DateTime.Now;
            //int MainPaymentIDOnAccount = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT get_Tran_id(@PaymentIDOnAccount)",
            //    new MySqlParameter("@PaymentIDOnAccount", "PaymentIDOnAccount")));
            //if (MainPaymentIDOnAccount == 0)
            //{
            //    Tranx.Rollback();
            //    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error in Generate PaymentIDOnAccount" });
            //}
            int MainPaymentIDOnPayment = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT get_Tran_id(@PaymentIDOnPayment)",
                new MySqlParameter("@PaymentIDOnPayment", "PaymentIDOnPayment")));
            if (MainPaymentIDOnPayment == 0)
             {
                Tranx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error in Generate PaymentIDOnPayment" });
            }
            decimal AdvAmt = 1;
            if (Util.GetInt(AdvAmount[0].TypeOfPayment) == 2 && Util.GetDouble(AdvAmt) > 0)
                AdvAmt = -1;
           else if (Util.GetInt(AdvAmount[0].TypeOfPayment) == 3 && Util.GetDouble(AdvAmt) > 0)
            {
               AdvAmt = -1;
            }
            for (int i = 0; i < AdvAmount.Count; i++)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO invoicemaster_onaccount(ReceivedAmt,EntryDate,EntryBy,Panel_id ,`Type`, ");
                sb.Append(" ReceiptNo,Remarks , EntryByName, receivedDate, CreditNote,EntryType,ValidateStatus,ApprovedBy,ApprovedByID,ApprovedOnDate,IsAccountPayment,CreditDebitNoteTypeID,CreditDebitNoteType, ");
                sb.Append(" PaymentMode, BankName, CardNo, CardDate, Narration, PaymentModeID, S_Amount, S_CountryID, S_Currency, ");
                sb.Append("   S_Notation, C_Factor, Currency_RoundOff, CurrencyRoundDigit, Converson_ID,InvoiceNo,IsMainPayment,MainPaymentID) ");
                sb.Append(" VALUES (@ReceivedAmt,@Entrydate,@EntryBy,@PanelID,'ON ACCOUNT', ");
                sb.Append(" @ReceiptNo, @Remarks, @EntryByName,@receivedDate ,@typeOfPayment,@EntryType,'1',@ApprovedBy,@ApprovedByID,@Entrydate,@IsAccountPayment,@CreditDebitNoteTypeID,@CreditDebitNoteType, ");
                sb.Append(" @PaymentMode, @BankName, @CardNo, @CardDate, @Narration, @PaymentModeID, @S_Amount, @S_CountryID, @S_Currency, ");
                sb.Append(" @S_Notation, @C_Factor, @Currency_RoundOff, @CurrencyRoundDigit, @Converson_ID,@InvoiceNo,@IsMainPayment,@MainPaymentID) ");
                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tranx);
                cmd.Parameters.AddWithValue("@ReceivedAmt", Util.GetDecimal(AdvAmount[i].AdvAmount) * AdvAmt);
                cmd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmd.Parameters.AddWithValue("@Entrydate", EntryDate);
                cmd.Parameters.AddWithValue("@PanelID", AdvAmount[0].PanelID);
                cmd.Parameters.AddWithValue("@ReceiptNo", receiptno);
                cmd.Parameters.AddWithValue("@Remarks", AdvAmount[0].Remarks);
                cmd.Parameters.AddWithValue("@EntryByName", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@receivedDate", Util.GetDateTime(AdvAmount[0].DepositeDate).ToString("yyyy-MM-dd"));
                cmd.Parameters.AddWithValue("@typeOfPayment", Util.GetInt(AdvAmount[0].TypeOfPayment));
                cmd.Parameters.AddWithValue("@ApprovedBy", UserInfo.LoginName);
                cmd.Parameters.AddWithValue("@ApprovedByID", UserInfo.ID);
                cmd.Parameters.AddWithValue("@IsAccountPayment", "1");
                cmd.Parameters.AddWithValue("@CreditDebitNoteTypeID", AdvAmount[0].CreditDebitNoteTypeID);
                cmd.Parameters.AddWithValue("@CreditDebitNoteType", AdvAmount[0].CreditDebitNoteType);
                cmd.Parameters.AddWithValue("@EntryType", AdvAmount[0].EntryType);


                if (i == 0)
                {
                    IsMainPayment = 1;
                    cmd.Parameters.AddWithValue("@IsMainPayment", 1);
                    cmd.Parameters.AddWithValue("@BankName", AdvAmount[0].BankName);
                    cmd.Parameters.AddWithValue("@CardNo", AdvAmount[0].CardNo);
                    cmd.Parameters.AddWithValue("@CardDate", AdvAmount[0].CardDate);
                    cmd.Parameters.AddWithValue("@S_Amount", AdvAmount[0].S_Amount * AdvAmt);
                    cmd.Parameters.AddWithValue("@S_CountryID", AdvAmount[0].S_CountryID);
                    cmd.Parameters.AddWithValue("@S_Currency", AdvAmount[0].S_Currency);
                    cmd.Parameters.AddWithValue("@S_Notation", AdvAmount[0].S_Notation);
                    cmd.Parameters.AddWithValue("@C_Factor", AdvAmount[0].C_Factor);
                    cmd.Parameters.AddWithValue("@Currency_RoundOff", AdvAmount[0].Currency_RoundOff);
                    cmd.Parameters.AddWithValue("@CurrencyRoundDigit", AdvAmount[0].CurrencyRoundDigit);
                    cmd.Parameters.AddWithValue("@Converson_ID", AdvAmount[0].Converson_ID);
                   
                }
                else
                {
                    IsMainPayment = 0;
                    cmd.Parameters.AddWithValue("@IsMainPayment", 0);
                    cmd.Parameters.AddWithValue("@BankName", string.Empty);
                    cmd.Parameters.AddWithValue("@CardNo", string.Empty);
                    cmd.Parameters.AddWithValue("@CardDate", "0001-01-01");
                    cmd.Parameters.AddWithValue("@S_Amount", Util.GetDecimal(AdvAmount[i].AdvAmount) * AdvAmt);
                    cmd.Parameters.AddWithValue("@S_CountryID", Resources.Resource.BaseCurrencyID);
                    cmd.Parameters.AddWithValue("@S_Currency", Resources.Resource.BaseCurrencyNotation);
                    cmd.Parameters.AddWithValue("@S_Notation", Resources.Resource.BaseCurrencyNotation);
                    cmd.Parameters.AddWithValue("@C_Factor", 1);
                    cmd.Parameters.AddWithValue("@Currency_RoundOff", 0);
                    cmd.Parameters.AddWithValue("@CurrencyRoundDigit", Resources.Resource.BaseCurrencyRound);
                    cmd.Parameters.AddWithValue("@Converson_ID", 0);
                    
                }
                cmd.Parameters.AddWithValue("@MainPaymentID", MainPaymentIDOnPayment);
                cmd.Parameters.AddWithValue("@PaymentMode", AdvAmount[i].PaymentMode.Trim());
                cmd.Parameters.AddWithValue("@Narration", AdvAmount[0].Narration ?? string.Empty);
                cmd.Parameters.AddWithValue("@PaymentModeID", AdvAmount[i].PaymentModeID);
                cmd.Parameters.AddWithValue("@InvoiceNo", AdvAmount[0].InvoiceNo);
                cmd.ExecuteNonQuery();
                long invoicemaster_onaccount_ID = cmd.LastInsertedId;

                cmd.Dispose();
                //if (i == 0)
                //{
                //    MainPaymentIDOnAccount = invoicemaster_onaccount_ID;
                //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE Invoicemaster_Payment SET MainPaymentID=@ID WHERE ID=@ID",
                //       new MySqlParameter("@ID", MainPaymentIDOnAccount));
                //}
               // if (Util.GetInt(AdvAmount[0].TypeOfPayment) == 0)
              //  {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO Invoicemaster_Payment(ReceivedAmt,EntryDate,EntryBy,Panel_id ,`Type`,ReceiptNo, ");
                    sb.Append(" TDS,WriteOff,Remarks,EntryByName, receivedDate, CreditNote,IsMainPayment,EntryType,ValidateStatus,ValidateBy,ValidateByID,ValidateDate,invoicemaster_onaccount_ID, ");
                    sb.Append(" PaymentMode, BankName, CardNo, CardDate, Narration, PaymentModeID, S_Amount, S_CountryID, S_Currency, ");
                    sb.Append(" S_Notation, C_Factor, Currency_RoundOff, CurrencyRoundDigit, Converson_ID,MainPaymentID,InvoiceNo,InvoiceAmount,TransactionID) ");
                    sb.Append(" VALUES (@AdvAmt,@Entrydate,@EntryBy,@PanelID, 'ON ACCOUNT',@receiptNo, ");
                    sb.Append(" 0,0,@Remarks, @LoginName,@dtAdv,@typeOfPayment,@IsMainPayment,@EntryType,'0',@ValidateBy,@ValidateByID,@Entrydate,@invoicemaster_onaccount_ID, ");
                    sb.Append(" @PaymentMode, @BankName, @CardNo, @CardDate, @Narration, @PaymentModeID, @S_Amount, @S_CountryID, @S_Currency, ");
                    sb.Append(" @S_Notation, @C_Factor, @Currency_RoundOff, @CurrencyRoundDigit, @Converson_ID,@MainPaymentID,@InvoiceNo,@InvoiceAmount,@TransactionID) ");

                    MySqlCommand cmd1 = new MySqlCommand(sb.ToString(), con, Tranx);

                    cmd1.Parameters.AddWithValue("@AdvAmt", Util.GetDecimal(AdvAmount[i].AdvAmount) * AdvAmt);
                    cmd1.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                    cmd1.Parameters.AddWithValue("@Entrydate", EntryDate);
                    cmd1.Parameters.AddWithValue("@PanelID", AdvAmount[0].PanelID);
                    cmd1.Parameters.AddWithValue("@Remarks", AdvAmount[0].Remarks);
                    cmd1.Parameters.AddWithValue("@LoginName", UserInfo.LoginName);
                    cmd1.Parameters.AddWithValue("@dtAdv", Util.GetDateTime(AdvAmount[0].DepositeDate).ToString("yyyy-MM-dd"));
                    cmd1.Parameters.AddWithValue("@typeOfPayment", Util.GetInt(AdvAmount[0].TypeOfPayment));
                    cmd1.Parameters.AddWithValue("@EntryType", AdvAmount[0].EntryType);
                    cmd1.Parameters.AddWithValue("@ValidateBy", UserInfo.LoginName);
                    cmd1.Parameters.AddWithValue("@ValidateByID", UserInfo.ID);
                    cmd1.Parameters.AddWithValue("@invoicemaster_onaccount_ID", invoicemaster_onaccount_ID);
                    cmd1.Parameters.AddWithValue("@PaymentMode", AdvAmount[i].PaymentMode.Trim());
                    cmd1.Parameters.AddWithValue("@PaymentModeID", AdvAmount[i].PaymentModeID);
                    cmd1.Parameters.AddWithValue("@InvoiceNo", AdvAmount[0].InvoiceNo);
                    cmd1.Parameters.AddWithValue("@ReceiptNo", receiptno);
                    if (i == 0)
                    {
                        IsMainPayment = 1;
                        cmd1.Parameters.AddWithValue("@IsMainPayment", 1);
                        cmd1.Parameters.AddWithValue("@BankName", AdvAmount[0].BankName);
                        cmd1.Parameters.AddWithValue("@CardNo", AdvAmount[0].CardNo);
                        cmd1.Parameters.AddWithValue("@CardDate", AdvAmount[0].CardDate);
                        cmd1.Parameters.AddWithValue("@S_Amount", AdvAmount[0].S_Amount* AdvAmt);
                        cmd1.Parameters.AddWithValue("@S_CountryID", AdvAmount[0].S_CountryID);
                        cmd1.Parameters.AddWithValue("@S_Currency", AdvAmount[0].S_Currency);
                        cmd1.Parameters.AddWithValue("@S_Notation", AdvAmount[0].S_Notation);

                        cmd1.Parameters.AddWithValue("@C_Factor", AdvAmount[0].C_Factor);
                        cmd1.Parameters.AddWithValue("@Currency_RoundOff", AdvAmount[0].Currency_RoundOff);
                        cmd1.Parameters.AddWithValue("@CurrencyRoundDigit", AdvAmount[0].CurrencyRoundDigit);
                        cmd1.Parameters.AddWithValue("@Converson_ID", AdvAmount[0].Converson_ID);
                        cmd1.Parameters.AddWithValue("@MainPaymentID", MainPaymentIDOnPayment);
                    }
                    else
                    {
                        IsMainPayment = 0;
                        cmd1.Parameters.AddWithValue("@IsMainPayment", 0);
                        cmd1.Parameters.AddWithValue("@BankName", string.Empty);
                        cmd1.Parameters.AddWithValue("@CardNo", string.Empty);
                        cmd1.Parameters.AddWithValue("@CardDate", "0001-01-01");
                        cmd1.Parameters.AddWithValue("@S_Amount", Util.GetDecimal(AdvAmount[i].AdvAmount)* AdvAmt);
                        cmd1.Parameters.AddWithValue("@S_CountryID", Resources.Resource.BaseCurrencyID);
                        cmd1.Parameters.AddWithValue("@S_Currency", Resources.Resource.BaseCurrencyNotation);
                        cmd1.Parameters.AddWithValue("@S_Notation", Resources.Resource.BaseCurrencyNotation);
                        cmd1.Parameters.AddWithValue("@C_Factor", 1);
                        cmd1.Parameters.AddWithValue("@Currency_RoundOff", 0);
                        cmd1.Parameters.AddWithValue("@CurrencyRoundDigit", Resources.Resource.BaseCurrencyRound);
                        cmd1.Parameters.AddWithValue("@Converson_ID", 0);
                        cmd1.Parameters.AddWithValue("@MainPaymentID", MainPaymentIDOnPayment);
                    }

                    cmd1.Parameters.AddWithValue("@Narration", AdvAmount[0].Narration ?? string.Empty);
                    cmd1.Parameters.AddWithValue("@InvoiceAmount", Util.GetDecimal(AdvAmount[0].InvoiceAmount));
                    cmd1.Parameters.AddWithValue("@TransactionID", Util.GetString(AdvAmount[0].TransactionID));
                    cmd1.ExecuteNonQuery();
                    long Invoicemaster_Payment_ID = cmd1.LastInsertedId;
                    cmd1.Dispose();

                    //if (i == 0)
                    //{
                    //    MainPaymentIDOnPayment = Invoicemaster_Payment_ID;
                    //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE Invoicemaster_Payment SET MainPaymentID=@MainPaymentIDOnPayment WHERE ID=@ID",
                    //       new MySqlParameter("@MainPaymentIDOnPayment", MainPaymentIDOnPayment),
                    //       new MySqlParameter("@ID", Invoicemaster_Payment_ID));
                    //}

                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE invoicemaster_onaccount SET Invoicemaster_Payment_ID=@Invoicemaster_Payment_ID WHERE ID=@ID",
                            new MySqlParameter("@Invoicemaster_Payment_ID", Invoicemaster_Payment_ID),
                            new MySqlParameter("@ID", invoicemaster_onaccount_ID));

              //  }


            }
            Tranx.Commit();
            // Util.GetInt(AdvAmount[0].TypeOfPayment),
            using (DataTable dtresult = PrevAdvPayment(Util.GetString(AdvAmount[0].PanelID), con))
            {
                return JsonConvert.SerializeObject(new { status = true, data = dtresult });
            }
            
           
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error" });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string bindCreditDebitNoteType()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT ID,TypeName FROM invoicemaster_creditDebit_master WHERE IsActive=1 "))
        {
            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return null;
        }
    }
    [WebMethod(EnableSession = true)]
    public static string saveCreditDebitNoteType(string CreditDebitNoteType)
    {
        int TypeID;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM invoicemaster_creditDebit_master WHERE TypeName=@TypeName",
               new MySqlParameter("@TypeName", CreditDebitNoteType.Trim())));
            if (count > 0)
            {
                Tranx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Credit/Debit NoteType Already Exist" });
            }
            else
            {
                MySqlCommand cmd = new MySqlCommand("INSERT INTO invoicemaster_creditDebit_master(TypeName,CreatedByID)VALUES(@TypeName,@CreatedByID)", con, Tranx);
                cmd.Parameters.AddWithValue("@TypeName", CreditDebitNoteType);
                cmd.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
                cmd.ExecuteNonQuery();
                TypeID = Convert.ToInt32(cmd.LastInsertedId);
                cmd.Dispose();
            }
            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true, TypeID = TypeID, TypeName = CreditDebitNoteType });
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
    [WebMethod]
    public static string bindPanel(int BusinessZoneID, int StateID, int SearchType,string PanelGroup)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            HttpContext ctx = HttpContext.Current;
            string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
            StringBuilder sb = new StringBuilder();
           
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#','','#','')Panel_ID,cm.Type1 FROM  f_panel_master fpm  ");
                sb.Append(" WHERE   fpm.IsInvoice=1  ");
                if (BusinessZoneID != 0)
                {
                    sb.Append("  AND cm.BusinessZoneID=@BusinessZoneID");
                }
                if (StateID > 0)
                {
                    sb.Append("  AND cm.StateID=@StateID");
                }
                if (Util.GetString(ctx.Session["LoginType"]) == "PCC")
                {
                    sb.Append(" and InvoiceTo =" + InvoicePanelID + " ORDER BY fpm.Employee_ID desc");
                }
                else if (Util.GetString(ctx.Session["LoginType"]).ToUpper() == "SUBPCC")
                {
                    sb.Append(" and employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ORDER BY fpm.Employee_ID desc");
                }
                else if (UserInfo.RoleID == 220)
                {
                    sb.Append(" and Panel_ID in(select PanelID from centre_panel where centreID= " + UserInfo.Centre + ") ORDER BY fpm.Company_Name desc");
                }
                else
                    sb.Append(" ORDER BY fpm.Company_Name");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                            new MySqlParameter("@BusinessZoneID", BusinessZoneID),
                                                            new MySqlParameter("@StateID", StateID),
                                                            new MySqlParameter("@SearchType", SearchType)).Tables[0])
            {

                if (dt.Rows.Count > 0)
                    return Util.getJson(dt);
                else
                    return null;
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
    public static string SearchdataExcelActive(string PanelID)
    {
        DataTable dt = new DataTable();
        if (PanelID.Trim() != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fpm.`BusinessUnit`,fpm.`Company_Name` ClientName,if( ivac.CreditNote='2',Concat('-',ivac.`ReceivedAmt`),ivac.`ReceivedAmt`) `ReceivedAmt`,DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y') ReceivedDate ");
			sb.Append(" ,ivac.PaymentMode  ");
			sb.Append(" ,(case when ivac.CreditNote='0' then 'Deposit' when ivac.CreditNote='1' then 'Credit Note' when ivac.CreditNote='2' then 'Debit Note' when ivac.CreditNote='3' then 'Cheque Bounce' else '' end )PaymentType");
            sb.Append(" ,ivac.EntryByName EntryBy , DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i%p') EntryDate");
            sb.Append("   FROM `invoicemaster_onaccount` ivac  ");
            sb.Append("  INNER JOIN `f_panel_master` fpm ON ivac.`Panel_id` = fpm.`Panel_ID` WHERE ivac.panel_id = '" + PanelID.Trim() + "'  ");
            sb.Append("  AND iscancel = 0 AND IFNULL(invoiceno, '') = '' AND ivac.`receiveddate`>'2018-03-31'  ORDER BY ivac.`receiveddate` DESC ; ");
             //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\sion.txt", sb.ToString());
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Active Amount Submission Report";
                // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
                return "true";
            }
            else
            {
                return "flase";

            }
        }
        return "false";

    }
    [WebMethod(EnableSession = true)]
    public static string SearchdataExcel(string PanelID)
    {
        DataTable dt = new DataTable();
        if (PanelID.Trim() != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fpm.`BusinessUnit`,fpm.`Company_Name` ClientName,if( ivac.CreditNote='2',Concat('-',ivac.`ReceivedAmt`),ivac.`ReceivedAmt`) `ReceivedAmt`,DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y') ReceivedDate ");
			sb.Append(" ,ivac.PaymentMode  ");
			sb.Append(" ,(case when ivac.CreditNote='0' then 'Deposit' when ivac.CreditNote='1' then 'Credit Note' when ivac.CreditNote='2' then 'Debit Note' when ivac.CreditNote='3' then 'Cheque Bounce' else '' end )PaymentType");
            sb.Append(" ,ivac.EntryByName EntryBy , DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i%p') EntryDate,IFNULL(ivac.CancelUserName,'')CancelUserName,IFNULL(DATE_FORMAT(ivac.CancelDateTime,'%d-%b-%Y %I:%i%p'),'') CancelDate ");
            sb.Append("   FROM `invoicemaster_onaccount` ivac  ");
            sb.Append("  INNER JOIN `f_panel_master` fpm ON ivac.`Panel_id` = fpm.`Panel_ID` WHERE ivac.panel_id = '" + PanelID.Trim() + "'  ");
            sb.Append("  AND iscancel = 1 AND IFNULL(invoiceno, '') = '' AND ivac.`receiveddate`>'2018-03-31'  ORDER BY ivac.`receiveddate` DESC ; ");
            // System.IO.File.WriteAllText("E:\\Submission.txt", sb.ToString());
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Cancel Amount Submission Report";
                // ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
                return "true";
            }
            else
            {
                return "flase";

            }
        }
        return "false";

    }
    [WebMethod]
    public static string bindPanelOld(int BusinessZoneID, int StateID, int SearchType,string PanelGroup)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (SearchType != 7)
            {
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',cm.Type1ID)Panel_ID,cm.Type1 FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID ");
                sb.Append(" WHERE   fpm.IsInvoice=1   AND ((fpm.Payment_Mode='Cash' AND fpm.COCO_FOCO='FOFO')  OR (fpm.Payment_Mode='Credit' AND fpm.MonthlyInvoiceType=2)) ");
                if (BusinessZoneID != 0)
                {
                    sb.Append("  AND cm.BusinessZoneID=@BusinessZoneID");
                }
                if (StateID > 0)
                {
                    sb.Append("  AND cm.StateID=@StateID");
                }
                sb.Append("   AND fpm.Panel_ID=fpm.InvoiceTo   ");
                sb.Append(" AND (cm.type1ID=@SearchType or fpm.PanelGroup='"+ PanelGroup +"')  ");
            }
            else
            {
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#','PUP','#','7')Panel_ID,'PUP' Type1 FROM f_panel_master fpm ");
                sb.Append(" WHERE  fpm.TagProcessingLabID IN (SELECT CentreID FROM centre_master WHERE  1=1 AND ");
                if (BusinessZoneID != 0)
                {
                    sb.Append("  AND cm.BusinessZoneID=@BusinessZoneID");
                }

                if (StateID > 0)
                    sb.Append("  AND StateID=@StateID");
                sb.Append(" )AND fpm.PanelType='PUP'  ");
            }
            sb.Append("   AND fpm.IsPermanentClose=0  ");
            sb.Append(" ORDER BY fpm.Company_Name");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                            new MySqlParameter("@BusinessZoneID", BusinessZoneID),
                                                            new MySqlParameter("@StateID", StateID),
                                                            new MySqlParameter("@SearchType", SearchType)).Tables[0])
            {

                if (dt.Rows.Count > 0)
                    return Util.getJson(dt);
                else
                    return null;
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
    public class PanelAdvanceAmount
    {
        public int PanelID { get; set; }
        public DateTime DepositeDate { get; set; }
        public decimal AdvAmount { get; set; }
        public string BankName { get; set; }
        public string Remarks { get; set; }
        public string EntryType { get; set; }
        public int CentreID { get; set; }
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
        public string CreditDebitNoteTypeID { get; set; }
        public string CreditDebitNoteType { get; set; }
        public int TypeOfPayment { get; set; }
        public int IsAgainstinvoice { get; set; }
        public DateTime? InvoiceDate { get; set; }
        public string InvoiceNo { get; set; }
        public decimal? InvoiceAmount { get; set; }
        public string TransactionID { get; set; }
    }

}
