using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Invoicing_AdvanceAmountPayment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ServicePointManager.SecurityProtocol = (SecurityProtocolType)768 | (SecurityProtocolType)3072;
            BindPanel();
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtCheckDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoad_Data.bindBank(ddlBankName, "Select");
            ce_dtfrom.StartDate = DateTime.Now;
        }
        dtFrom.Attributes.Add("readOnly", "true");
        txtCheckDate.Attributes.Add("readOnly", "true");
    }



    private void BindPanel()
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = new DataTable();
         /*   if (Util.GetInt(Session["IsSalesTeamMember"].ToString()) == 1)
            {
                lblHeader.Text = "Sales Collection Form(SCF)";

                string SalesTeamMembers = "";// AllLoad_Data.getSalesChildNode(con, UserInfo.ID);

                RadioButtonList rad = (RadioButtonList)rblSearchType.FindControl("rblSearchType");
                dt = bindSalesPanel(SalesTeamMembers, Util.GetInt(rad.SelectedItem.Value), con);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script2", "hideSearchCriteria();", true);
                if (Session["RoleID"].ToString() == "1")
                    lblHeader.Text = "Sales Collection Form(SCF)";
                else*/
                    lblHeader.Text = "Advance Payment for Client";
            //    dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Company_Name,CONCAT(Panel_ID,'#',cm.Type1,'#',fpm.Payment_Mode,'#',cm.CentreID,'#',fpm.Add1,'#',fpm.EmailID,'#',fpm.Mobile)Panel_ID,cm.Type1,fpm.Panel_ID PanelID,fpm.Payment_Mode FROM f_panel_master fpm INNER JOIN Centre_master cm ON fpm.CentreID=cm.CentreID  WHERE fpm.PanelType ='Centre' AND ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID =@CentreID ) OR cm.CentreID =@CentreID ) AND fpm.Panel_ID=fpm.InvoiceTo AND fpm.IsPermanentClose=0",
                 //   new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0];
            //}
                    RadioButtonList rad = (RadioButtonList)rblSearchType.FindControl("rblSearchType");
                    dt = bindSalesPanel("", Util.GetInt(rad.SelectedItem.Value), con);
            if (dt.Rows.Count > 0)
            {
                ddl_panel.DataSource = dt;
                ddl_panel.DataTextField = "Company_Name";
                ddl_panel.DataValueField = "Panel_ID";
                ddl_panel.DataBind();
            //    ddl_panel.Items.Insert(0, new ListItem("Select", "0"));
                if (dt.Rows[0]["Type1"].ToString() == "PUP")
                // if ((dt.Rows[0]["Type1"].ToString() == "HLM") || (dt.Rows[0]["Type1"].ToString() == "PUP" && dt.Rows[0]["Payment_Mode"].ToString() == "Credit"))
                {
                    //DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(ID,'#',ShareAmt,'#',InvoiceDate)ID,InvoiceNo,ShareAmt FROM invoiceMaster Where PanelID=@PanelID AND IsCancel=0 AND IsClose=0",
                    //    new MySqlParameter("@PanelID", dt.Rows[0]["PanelID"].ToString())).Tables[0]; 

                    DataTable dt1 = bindInvoiceData(Util.GetInt(dt.Rows[0]["PanelID"].ToString()), con);

                    if (dt1.Rows.Count > 0)
                    {
                        ddlInvoiceNo.DataSource = dt1;
                        ddlInvoiceNo.DataTextField = "InvoiceNo";
                        ddlInvoiceNo.DataValueField = "ID";
                        ddlInvoiceNo.DataBind();

                        lblInvoiceAmt.Text = dt1.Rows[0]["ShareAmt"].ToString();

                        lblPendingInvoiceAmt.Text = (Util.GetDecimal(dt1.Rows[0]["ShareAmt"].ToString()) - Util.GetDecimal(pendindAmount(dt1.Rows[0]["InvoiceNo"].ToString(),con))).ToString();
                        ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "totalOutstanding();", true);
                    }
                }
            }
            else
            {
                ddl_panel.Items.Clear();
            }
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key111", "showPayment();", true);
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

    public static decimal pendindAmount(string InvoiceNo, MySqlConnection con)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT SUM(ReceivedAmt)ReceivedAmt FROM ( ");
           // sb.Append("SELECT SUM(ReceivedAmt)ReceivedAmt FROM Invoicemaster_Payment WHERE ValidateStatus=0 AND IsCancel=0 AND invoiceNo=@invoiceNo ");
         //   sb.Append(" UNION ALL");
            sb.Append(" SELECT SUM(ReceivedAmt)ReceivedAmt FROM invoicemaster_onaccount WHERE IsCancel=0 AND ValidateStatus=1 AND invoiceNo=@invoiceNo )t");
            return Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@invoiceNo", InvoiceNo)));
        }
        catch (Exception ex)
        {
            throw ex;
        }
        finally
        {

        }
    }

    [WebMethod]
    public static string InvoicePendingAmt(string InvoiceNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(new { status = true, data = pendindAmount(InvoiceNo, con) });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, data = ex.GetBaseException() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod]
    public static string SearchPrevAdvPayment(int con, string PanelID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT ivac.`ID`,fpm.Panel_Code,ivac.imagefile, fpm.`Company_Name`,ivac.`ReceivedAmt` `ReceivedAmt`,ivac.EntryByName EntryBy, ");
        sb.Append("  DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y') AdvanceAmtDate ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i %p') EntryDate,ValidateStatus, ");
        sb.Append("  remarks,if(IsCancel=1,CancelReason,'')RejectReason,IsCancel,PaymentMode,IFNULL(ChequeNo,'')ChequeNo,IF(ivac.ChequeDate='0001-01-01','',DATE_FORMAT(ivac.ChequeDate,'%d-%b-%Y'))ChequeDate  FROM `Invoicemaster_Payment` ivac  ");
        sb.Append("  INNER JOIN `f_panel_master` fpm ON ivac.`Panel_id` = fpm.`Panel_ID` WHERE ivac.panel_id = '" + PanelID + "'  ");
        if (con == 1)
            sb.Append(" AND  ivac.ValidateStatus=1  AND IsCancel=0 ");
        else if (con == 2)
            sb.Append("  AND ivac.ValidateStatus=0  AND IsCancel=0 ");
        else if (con == 3)
            sb.Append("  AND ivac.IsCancel=1  ");

        sb.Append("      ORDER BY ivac.`receiveddate` DESC limit 100  ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Util.getJson(dt);
        }
    }



    [WebMethod(EnableSession = true)]
    public static string RejectPrevAdvPayment(string ID, string Remarks)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update Invoicemaster_Payment set `IsCancel`=1,CancelReason=@CancelReason,`CancelUserID`=@CancelUserID,`CancelUserName`=@CancelUserName,`CancelDateTime`=NOW() where id=@id",
               new MySqlParameter("@CancelReason", Remarks), new MySqlParameter("@CancelUserID", HttpContext.Current.Session["ID"]),
               new MySqlParameter("@CancelUserName", HttpContext.Current.Session["LoginName"]), new MySqlParameter("@id", ID));
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();

        }
    }
    public class PanelAdvanceAmount
    {
        public string PanelName { get; set; }
        public int PanelID { get; set; }
        public DateTime DepositeDate { get; set; }
        public int AdvAmount { get; set; }
        public string InvoiceNo { get; set; }
        public float? InvoiceAmount { get; set; }
        public int CancellationAmount { get; set; }
        public int TDSAmount { get; set; }
        public int ElectricityAmount { get; set; }
        public int WaterAmount { get; set; }
        public int OtherAmount { get; set; }
        public string PaymentMode { get; set; }
        public string BankName { get; set; }

        public int BankID { get; set; }
        public string DraftNo { get; set; }
        public DateTime? DraftDate { get; set; }
        public string Remarks { get; set; }
        public string TypeOfPayment { get; set; }
        public string EntryType { get; set; }
        public int IsMainPayment { get; set; }
        public string PanelPaymentMode { get; set; }
        public DateTime? InvoiceDate { get; set; }
        public int CentreID { get; set; }
        public string OnlinePaymentTransactionNo { get; set; }
    }
    [WebMethod(EnableSession = true)]
    public static string SaveAdvPayment(object PanelAdvanceAmount, string InvoiceNo)
    {
        List<PanelAdvanceAmount> AdvAmount = new JavaScriptSerializer().ConvertToType<List<PanelAdvanceAmount>>(PanelAdvanceAmount);
	
        if (AdvAmount[0].PaymentMode.Trim() == string.Empty)
        {
            return "Please Select Payment Mode";
        }

        if (AdvAmount[0].PanelID == 0)
        {
            return "Please Select Client";
        }

        if (AdvAmount[0].AdvAmount == 0)
        {
            return "Please Enter Amount for Advance Payment";
        }
        if (AdvAmount[0].EntryType.ToUpper() == "HLM" || (AdvAmount[0].EntryType.ToUpper() == "PUP" && AdvAmount[0].PanelPaymentMode == "Credit"))
        {
            if (Util.GetDateTime(AdvAmount[0].DepositeDate) < Util.GetDateTime(AdvAmount[0].InvoiceDate))
            {
                return "You can not submit the amount before Invoice Date.Invoice Date " + Util.GetDateTime(AdvAmount[0].InvoiceDate).ToString("dd-MM-yyyy");
            }

            if (Util.GetDecimal(AdvAmount[0].AdvAmount) > 200000 && AdvAmount[0].PaymentMode.Trim() == "Cash")
            {
                return "Cash cannot be accepted more than 200000";
            }

        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            string PrevAdvdate = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT IFNULL(MAX(ReceivedDate),'0001-01-01') FROM `invoicemaster_onaccount` WHERE  isCancel=0 AND panel_id=@panel_id",
                new MySqlParameter("@panel_id", AdvAmount[0].PanelID)
                ));
            DateTime dtPre = Convert.ToDateTime(PrevAdvdate);
            DateTime dtAd = Convert.ToDateTime(AdvAmount[0].DepositeDate);
            TimeSpan difference = dtPre.Date - dtAd.Date;
            int days = (int)difference.TotalDays;
		

            if (Util.GetDateTime(AdvAmount[0].DepositeDate) > DateTime.Today)
            {
                return "You can not submit the amount in advance date";
            }


               string receiptno = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT get_receiptno_invoice(@typeOfPayment,@PanelID,@dtAdv)",
               new MySqlParameter("@typeOfPayment", Util.GetInt(AdvAmount[0].TypeOfPayment)), new MySqlParameter("@PanelID", Util.GetInt(AdvAmount[0].PanelID)),
               new MySqlParameter("@dtAdv", Util.GetDateTime(AdvAmount[0].DepositeDate).ToString("yyyy-MM-dd"))));

            StringBuilder sb = new StringBuilder();

            for (int i = 0; i < AdvAmount.Count; i++)
            {
                string PayId = "0";
                sb = new StringBuilder();
                sb.Append(" INSERT INTO Invoicemaster_Payment(S_Amount,ReceivedAmt,EntryDate,EntryBy,Panel_id,PaymentMode ,`Type`,`Bank`,BankID,ChequeDate ,ChequeNo,ReceiptNo, ");
                sb.Append(" TDS,WriteOff,Remarks , EntryByName, receivedDate, CreditNote,InvoiceNo,InvoiceAmount,IsMainPayment,EntryType,OnlinePaymentTransactionNo,ValidateStatus,ValidateBy,ValidateByID,ValidateDate) ");
                sb.Append(" VALUES (@S_Amount,@AdvAmt,now() ,@EntryBy,@PanelID,@PaymentMode, 'ON ACCOUNT',@BankName,@BankID,@ChequeDate,@ChequeNo,@receiptNo,0,0, ");
                sb.Append(" @Remarks, @LoginName,@dtAdv ,@typeOfPayment,@InvoiceNo,@InvoiceAmount,@IsMainPayment,@EntryType,@OnlinePaymentTransactionNo,0,@LoginName,@EntryBy,now() ) ");

                using (MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tranx))
                {

                    cmd.Parameters.AddWithValue("@S_Amount", Util.GetDouble(AdvAmount[i].AdvAmount));
                    cmd.Parameters.AddWithValue("@AdvAmt", Util.GetDouble(AdvAmount[i].AdvAmount));
                    cmd.Parameters.AddWithValue("@EntryBy", HttpContext.Current.Session["ID"]);
                    cmd.Parameters.AddWithValue("@PanelID", AdvAmount[0].PanelID);
                    cmd.Parameters.AddWithValue("@PaymentMode", AdvAmount[i].PaymentMode.Trim());
                    if (i == 0)
                    {
                        cmd.Parameters.AddWithValue("@IsMainPayment", 1);
                        cmd.Parameters.AddWithValue("@BankName", AdvAmount[0].BankName);
                        cmd.Parameters.AddWithValue("@BankID", AdvAmount[0].BankID);
                        cmd.Parameters.AddWithValue("@ChequeDate", Util.GetDateTime(AdvAmount[0].DraftDate).ToString("yyyy-MM-dd"));
                        cmd.Parameters.AddWithValue("@ChequeNo", AdvAmount[0].DraftNo.Trim());
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@IsMainPayment", 0);
                        cmd.Parameters.AddWithValue("@BankName", string.Empty);
                        cmd.Parameters.AddWithValue("@BankID", 0);
                        cmd.Parameters.AddWithValue("@ChequeDate", "0001-01-01");
                        cmd.Parameters.AddWithValue("@ChequeNo", string.Empty);
                    }
                    cmd.Parameters.AddWithValue("@receiptNo", receiptno);
                    cmd.Parameters.AddWithValue("@Remarks", AdvAmount[0].Remarks);
                    cmd.Parameters.AddWithValue("@LoginName", HttpContext.Current.Session["LoginName"]);
                    cmd.Parameters.AddWithValue("@dtAdv", Util.GetDateTime(AdvAmount[0].DepositeDate).ToString("yyyy-MM-dd"));
                    cmd.Parameters.AddWithValue("@typeOfPayment", Util.GetInt(AdvAmount[0].TypeOfPayment));
                    cmd.Parameters.AddWithValue("@InvoiceNo", InvoiceNo);
                    cmd.Parameters.AddWithValue("@InvoiceAmount", Util.GetInt(AdvAmount[0].InvoiceAmount));
                    cmd.Parameters.AddWithValue("@EntryType", AdvAmount[0].EntryType);
                    cmd.Parameters.AddWithValue("@OnlinePaymentTransactionNo", AdvAmount[0].OnlinePaymentTransactionNo);

                    cmd.ExecuteNonQuery();

                    PayId =Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT LAST_INSERT_ID();"));

                    cmd.Dispose();
                  

                }

                //----------Apurva Code for Online Payment Auto Verify : 18-12-2018---------
                //RazorPay Payment
               // if (AdvAmount[i].PaymentMode.Trim().ToUpper() == "ONLINE PAYMENT")
                if (AdvAmount[i].PaymentMode.Trim().ToUpper() == "RAZORPAY PAYMENT")
                {
                  //  System.IO.File.AppendAllText(@"f:/Apurva/AdvAmount.txt", AdvAmount[0].OnlinePaymentTransactionNo);
                    //sb = new StringBuilder();
                    //sb.Append(" INSERT INTO invoicemaster_onaccount(S_Amount,S_Currency,ReceivedAmt ,PaymentMode,Type, ");
                    //sb.Append(" EntryDate,EntryBy,ReceivedDate,Remarks,Panel_id,AdvanceAmtDate,EntryByName,ReceiptNo,");
                    //sb.Append("EntryType,ValidateStatus,InvoiceNo) ");
                    //sb.Append(" VALUES (@S_Amount,'INR',@AdvAmt,@PaymentMode,'ON ACCOUNT',now() ,@EntryBy ,now(), @Remarks,@PanelID,now(),@LoginName ,@receiptNo, ");
                    //sb.Append("@EntryType,0,@InvoiceNo )  ");
                    //using (MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tranx))
                    //{
                    //    cmd.Parameters.AddWithValue("@S_Amount", Util.GetDouble(AdvAmount[i].AdvAmount));
                    //    cmd.Parameters.AddWithValue("@AdvAmt", Util.GetDouble(AdvAmount[i].AdvAmount));
                    //    cmd.Parameters.AddWithValue("@PaymentMode", AdvAmount[i].PaymentMode.Trim());
                    //    cmd.Parameters.AddWithValue("@EntryBy", HttpContext.Current.Session["ID"]);
                    //    cmd.Parameters.AddWithValue("@PanelID", AdvAmount[0].PanelID);
                    //    cmd.Parameters.AddWithValue("@receiptNo", receiptno);
                    //    cmd.Parameters.AddWithValue("@Remarks", AdvAmount[0].Remarks);
                    //    cmd.Parameters.AddWithValue("@LoginName", HttpContext.Current.Session["LoginName"]);
                    //    cmd.Parameters.AddWithValue("@EntryType", AdvAmount[0].EntryType);
                    //    cmd.Parameters.AddWithValue("@InvoiceNo", InvoiceNo);

                    //    cmd.ExecuteNonQuery();
                    //    cmd.Dispose();
                    //}

              
                  
                }
                //--------------------------------------------------------------------------
            }
            if (AdvAmount[0].EntryType.ToUpper() == "BTC" || AdvAmount[0].EntryType.ToUpper() == "DRL" || AdvAmount[0].EntryType.ToUpper() == "CSH" || (AdvAmount[0].EntryType.ToUpper() == "PUP" && AdvAmount[0].PanelPaymentMode == "Credit"))
            {
                int CentreID = 0;
                if (AdvAmount[0].EntryType.ToUpper() == "BTC")
                    CentreID = AdvAmount[0].CentreID;
                else
                    CentreID = AdvAmount[0].PanelID;
                decimal TotalOutstanding = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, "CALL get_balance_amount('" + AdvAmount[0].EntryType + "','" + CentreID + "')"));

                if (Util.GetDecimal(TotalOutstanding) < 0 && Util.GetDecimal(AdvAmount[0].AdvAmount) >= Util.GetDecimal(TotalOutstanding) * (-1))
                {
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE f_panel_master SET  MaxExpiry='" + DateTime.Now.AddHours(24).ToString("yyyy-MM-dd HH:mm:ss") + "' where Panel_ID='" + AdvAmount[0].PanelID + "' ");
                }


            }


               




                    string advPayment = "1";
                    ReportEmailClass rec = new ReportEmailClass();
                    DataTable dt = new DataTable();
            
                   //  if (AdvAmount[0].InvoiceNo == "")
                         dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT EmaiID FROM sales_email_master WHERE EmailCondtion='AdvancePayment' AND IsActive=1").Tables[0];

                     if (dt.Rows.Count > 0)
                     {
                         //sb = new StringBuilder();
                         //sb.Append("<div> Dear All, </div>");
                         //sb.Append("<br/>");
                         //sb.Append(" <b>" + AdvAmount[0].PanelName + "</b> has updated a payment of amount <b> " + AdvAmount[0].AdvAmount + " </b> as " + AdvAmount[0].PaymentMode + " and the following are the payment details kindly check.");
                         //sb.Append(" <br/>");
                         //sb.Append(" 1. Deposit Date : " + Util.GetDateTime(AdvAmount[0].DepositeDate).ToString("dd-MMM-yyyy") + " <br/>");
                         //sb.Append(" 2. Payment Mode : " + AdvAmount[0].PaymentMode + " <br/>");
                         //sb.Append(" 3. Amount       :  " + AdvAmount[0].AdvAmount + " <br/>");
                         //sb.Append(" 4. Entry Date   :  " + DateTime.Now.ToString("dd-MMM-yyyy") + " <br/>");
                         //sb.Append(" 5. Entry By     :  " + UserInfo.LoginName + " <br/>");
                         //sb.Append(" 6. Remarks      :  " + AdvAmount[0].Remarks + " <br/>");

                         //Sales_Email_Record ser = new Sales_Email_Record(Tranx);
                         //ser.EmailTypeID = 8;
                         //ser.EmailTo = Util.GetString(dt.Rows[0]["EmaiID"].ToString());
                         //ser.EmailSubject = string.Concat("Advance Payment ", AdvAmount[0].PanelName);
                         //ser.EmailContent = sb.ToString();
                         //ser.CreatedBy = UserInfo.LoginName;
                         //ser.CreatedByID = UserInfo.ID;
                         //ser.IDType1 = "EnrollID";
                         //ser.IDType1ID = Util.GetInt(0);
                         //ser.IDType2 = "Panel_ID";
                         //ser.IDType2ID = Util.GetInt(AdvAmount[0].PanelID);
                         //ser.IDType3ID = 0;
                         //ser.IDType3 = string.Empty;
                         //ser.IsAttachment = 0;
                         //ser.Insert();

                
                     }
                     else
                     {

                         /*  dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT EmaiID FROM sales_email_master WHERE EmailCondtion='InvoicePayment' AND IsActive=1").Tables[0];

                           DataTable EmailCC = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CAST(GROUP_CONCAT(em.Email  SEPARATOR ',')AS CHAR)EmailCC FROM employee_master_sales ems INNER JOIN `employee_master` em ON ems.`Employee_ID`=em.`Employee_ID` AND ems.`Panel_ID`='" + AdvAmount[0].PanelID + "' AND IFNULL(em.`Email`,'')<>'' AND ems.DesignationID NOT IN(5,6) ").Tables[0];
                           if (dt.Rows.Count > 0)
                           {
                               sb = new StringBuilder();
                               sb.Append("<div> Dear Accounts Team, </div>");
                               sb.Append("<br/>");
                               sb.Append(" Please find the details of <b>" + AdvAmount[0].PanelName + "</b> has cleared an amount of Rs. <b> " + AdvAmount[0].AdvAmount + " </b> against Invoice No. <b> " + AdvAmount[0].InvoiceNo + " </b>");
                               sb.Append("<br/>");
                               sb.Append("Kindly cheque and confirm.");
                               sb.Append("<br/>");
                               sb.Append("<br/>");
                               sb.Append("<br/>");
                               sb.Append("Regards,");
                               sb.Append("" + UserInfo.LoginName + "");


                               Sales_Email_Record ser = new Sales_Email_Record(Tranx);
                               ser.EmailTypeID = 9;
                               ser.EmailTo = Util.GetString(dt.Rows[0]["EmaiID"].ToString());
                               ser.EmailCC = Util.GetString(EmailCC.Rows[0]["EmailCC"].ToString());
                               ser.EmailSubject = string.Concat("Sales Collection Payment ", AdvAmount[0].PanelName);
                               ser.EmailContent = sb.ToString();
                               ser.CreatedBy = UserInfo.LoginName;
                               ser.CreatedByID = UserInfo.ID;
                               ser.IDType1 = "EnrollID";
                               ser.IDType1ID = Util.GetInt(0);
                               ser.IDType2 = "Panel_ID";
                               ser.IDType2ID = Util.GetInt(AdvAmount[0].PanelID);
                               ser.IDType3ID = 0;
                               ser.IDType3 = string.Empty;
                               ser.IsAttachment = 0;
                               ser.Insert();  
                           }*/
                     }

        
            if (advPayment == "1")
            {
                Tranx.Commit();
                return "1";
            }
            else
            {
                Tranx.Rollback();
                return "0";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            return "Error Occurred";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]




    public static DataTable bindInvoiceData(int PanelID, MySqlConnection con)
    {
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(ID,'#',ShareAmt,'#',InvoiceDate)ID,InvoiceNo,ShareAmt FROM invoiceMaster Where PanelID=@PanelID AND IsCancel=0 AND IsClose=0",
                         new MySqlParameter("@PanelID", PanelID)).Tables[0])
        {
            return dt;
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindInvoice(int PanelID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            return Util.getJson(bindInvoiceData(PanelID, con));
        }

        finally
        {
            con.Dispose();
            con.Close();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string totalOutstanding(string PanelID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT SUM(InvoiceAmt-IFNULL(ReceivedAmt,0))Outstanding FROM ( ");
         //   sb.Append("   SELECT ReceivedAmt,0 InvoiceAmt FROM Invoicemaster_Payment WHERE ValidateStatus=0  AND IsCancel=0 AND Panel_ID=@Panel_ID ");
           // sb.Append(" UNION ALL");
            sb.Append("  SELECT ReceivedAmt,0 InvoiceAmt  FROM invoicemaster_onaccount WHERE IsCancel=0 AND ValidateStatus=1 AND Panel_ID=@Panel_ID ");
            sb.Append(" UNION ALL");
            sb.Append("  SELECT 0 ReceivedAmt ,shareAmt InvoiceAmt FROM `invoiceMaster` WHERE PanelID=@Panel_ID AND IsCancel=0 )t");

            return JsonConvert.SerializeObject(new
            {
                status = true,
                data = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(), new MySqlParameter("@Panel_ID", PanelID)))
            });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false,
                ErrorMsg = ex.GetBaseException()
            });

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindClient(int SearchType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            string SalesTeamMembers = "";// AllLoad_Data.getSalesChildNode(con, UserInfo.ID);
            return Util.getJson(bindSalesPanel(SalesTeamMembers, SearchType, con));
        }
        finally
        {
            con.Dispose();
            con.Close();
        }
    }

	[WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetTaggedBusinessLabID(string ClientPanelId)
    {
        string str = "SELECT tagBusinessLabId FROM f_panel_master WHERE Panel_Id='"+ClientPanelId+"' ";
        string rtrn = ClientPanelId;//Util.GetString(StockReports.ExecuteScalar(str));
        return rtrn;
        
    }

    public static DataTable bindSalesPanel(string SalesTeamMembers, int SearchType, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        HttpContext ctx = HttpContext.Current;
        string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
      //  if (SearchType != 2 )
      //  {
            sb.Append(" SELECT Company_Name,CONCAT(fpm.Panel_ID,'#',cm.Type1,'#',fpm.Payment_Mode,'#',cm.CentreID,'#',fpm.Add1,'#',fpm.EmailID,'#',fpm.Mobile)Panel_ID,cm.Type1,fpm.Panel_ID PanelID,fpm.Payment_Mode   ");
            sb.Append(" FROM f_panel_master fpm  ");
            sb.Append(" INNER JOIN Centre_master cm ON fpm.CentreID=cm.CentreID  ");
     
            sb.Append(" WHERE fpm.PanelType ='Centre' AND fpm.Panel_ID=fpm.InvoiceTo AND fpm.IsInvoice=1  AND fpm.IsPermanentClose=0 AND cm.type1ID='2'  and fpm.centreid='"+UserInfo.Centre+"' ");
            if (Util.GetString(ctx.Session["LoginType"]) == "PCC")
            {
                sb.Append(" and fpm.InvoiceTo =" + InvoicePanelID + " ");
            }
            sb.Append(" UNION ALL ");
            sb.Append(" SELECT Company_Name,CONCAT(fpm.Panel_ID,'#','PUP','#',fpm.Payment_Mode,'#',0,'#',fpm.Add1,'#',fpm.EmailID,'#',fpm.Mobile)Panel_ID,'PUP' Type1,fpm.Panel_ID PanelID,fpm.Payment_Mode  ");
            sb.Append(" FROM f_panel_master fpm                    ");
            //  sb.Append(" WHERE fpm.PanelType ='PUP' AND fpm.Panel_ID=fpm.InvoiceTo AND fpm.IsInvoice=1  AND fpm.SalesManager IN (" + SalesTeamMembers + ") AND fpm.payment_mode='Credit' AND fpm.IsPermanentClose=0");
            sb.Append(" WHERE fpm.PanelType ='PUP' AND fpm.Panel_ID=fpm.InvoiceTo AND fpm.IsInvoice=1   AND fpm.payment_mode='Credit' AND fpm.IsPermanentClose=0   AND fpm.`TagProcessingLabID`=" + UserInfo.Centre + " ");
            if (Util.GetString(ctx.Session["LoginType"]) == "PCC")
            {
                sb.Append(" and fpm.InvoiceTo =" + InvoicePanelID + " ");
            }
            if (UserInfo.RoleID == 211)
            {
                sb.Append(" AND fpm.`Panel_ID`='" + HttpContext.Current.Session["OnlinePanelID"].ToString() + "' ");
            }
          
      /*  }
        else if (SearchType ==2)
        {
            sb.Append(" SELECT Company_Name,CONCAT(fpm.Panel_ID,'#','PUP','#',fpm.Payment_Mode,'#',0)Panel_ID,'PUP' Type1,fpm.Panel_ID PanelID,fpm.Payment_Mode  ");
            sb.Append(" FROM f_panel_master fpm                    ");
          //  sb.Append(" WHERE fpm.PanelType ='PUP' AND fpm.Panel_ID=fpm.InvoiceTo AND fpm.IsInvoice=1  AND fpm.SalesManager IN (" + SalesTeamMembers + ") AND fpm.payment_mode='Credit' AND fpm.IsPermanentClose=0");
            sb.Append(" WHERE fpm.PanelType ='PUP' AND fpm.Panel_ID=fpm.InvoiceTo AND fpm.IsInvoice=1   AND fpm.payment_mode='Credit' AND fpm.IsPermanentClose=0   AND fpm.`TagProcessingLabID`=" + UserInfo.Centre + " ");
            if (UserInfo.RoleID == 211)
            {
                sb.Append(" AND fpm.`Panel_ID`='" + HttpContext.Current.Session["OnlinePanelID"].ToString() + "' ");
            }
        } */
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string CheckSession()
    {
        int UserId = 0;
        try
        {
            UserId = UserInfo.ID;
            if (UserId > 0)
            {
                return "1";
            }
            else {
                return "0";
            
            }
        }
        catch {
            return "0";
        
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string WriteNotePad(string data)
    {
         FileStream fs;
        StreamWriter sw;

        if (System.IO.File.Exists("D:/ITDOSE/razorpaycode/OnlinePayment_Log.txt"))
        {
            sw = File.AppendText("D:/ITDOSE/razorpaycode/OnlinePayment_Log.txt");
            sw.WriteLine("  **********************************************  ");
            sw.WriteLine(" Date Time                : {0}", System.DateTime.Now.ToString());
            sw.WriteLine(" Message                  : {0}",data);
            sw.Close();
        }
        else
        {
            fs = File.Create("D:/ITDOSE/razorpaycode/OnlinePayment_Log.txt");
            sw = new StreamWriter(fs);
            sw.WriteLine("  **********************************************  ");
            sw.WriteLine(" Date Time                : {0}", System.DateTime.Now.ToString());
            sw.WriteLine(" Message                  : {0}", data);
            sw.Close();
            fs.Close();
        }
        return "0";
    }




    [WebMethod(EnableSession = true)]
    public static string OrderNow(string LIS_Ricept, string Amount,string Panel_Id)
    {
        string orderid = StockReports.ExecuteScalar(" SELECT Razorpay_Order_ID FROM razorpay_integration WHERE LIS_Reciept_ID='" + LIS_Ricept + "' limit 1 ");
        if (orderid == "")
        {


            //sunil


            string userName = Util.getApp("RazorpayAPIAUTHUSER");
            string passWord = Util.getApp("RazorpayAPIAUTHKEY");

            object JSONdata1 = new
            {
                Order_generated_in_LIS_System = LIS_Ricept.Split('_')[0].ToString(),

            };

            object JSONdata = new
            {
                amount = Amount,
                currency = "INR",
                receipt = LIS_Ricept,
                payment_capture = 1,
                notes = JSONdata1,
            };


            string jsonrequest = JsonConvert.SerializeObject(JSONdata);
            try
            {
                using (WebClient wc = new WebClientWithTimeout())
                {
                    wc.Headers.Add(HttpRequestHeader.ContentType, "application/json");

                    string credentials = Convert.ToBase64String(Encoding.ASCII.GetBytes(userName + ":" + passWord));
                    wc.Headers[HttpRequestHeader.Authorization] = "Basic " + credentials;
                    string URL = "https://api.razorpay.com/v1/orders";
                    var request = wc.UploadString(URL, "POST", jsonrequest);
                    var response = Newtonsoft.Json.Linq.JObject.Parse(request);
                    var returnmsge = Newtonsoft.Json.JsonConvert.DeserializeObject<_responseDetail>(response.ToString());
                    wc.Dispose();

                    string sql = "INSERT INTO razorpay_integration (merchantTransactionId,LIS_Reciept_ID,Razorpay_Order_ID,Panel_Id,Amount) VALUES('" + LIS_Ricept.Split('_')[0].ToString() + "','" + LIS_Ricept + "','" + returnmsge.id + "','" + Panel_Id + "','" + Amount + "')";

                    bool res = StockReports.ExecuteDML(sql);
                    return returnmsge.id;

                }

            }
            catch (Exception ex)
            {
                return ex.ToString();
            }


            //sunil


        }
        else
        {
            return orderid;
        }


    }
    public MemoryStream ConvertToStreamFile(string fileUrl)
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(fileUrl);
        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        MemoryStream result;
        try
        {
            MemoryStream mem = this.CopyStream(response.GetResponseStream());
            result = mem;
        }
        finally
        {
            response.Close();
        }
        return result;
    }
    public MemoryStream CopyStream(Stream input)
    {
        MemoryStream output = new MemoryStream();
        byte[] buffer = new byte[16384];
        int read;
        while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
        {
            output.Write(buffer, 0, read);
        }
        return output;
    }

    public class WebClientWithTimeout : WebClient
    {
        protected override WebRequest GetWebRequest(Uri address)
        {
            WebRequest wr = base.GetWebRequest(address);
            wr.Timeout = 100000; // timeout in milliseconds
            return wr;
        }
    }

    public class HeaderResponse
    {
        public string Authorization { get; set; }
    }


    public class Card
    {
        public string id { get; set; }
        public string entity { get; set; }
        public string name { get; set; }
        public string last4 { get; set; }
        public string network { get; set; }
        public string type { get; set; }
        public string issuer { get; set; }
        public bool international { get; set; }
        public bool emi { get; set; }
    }

    public class Notes
    {
        public string Paymentdone { get; set; }
    }

    public class _responseDetail
    {
        public string id { get; set; }
        public string entity { get; set; }
        public int amount { get; set; }
        public string currency { get; set; }
        public string status { get; set; }
        public object order_id { get; set; }
        public object invoice_id { get; set; }
        public bool international { get; set; }
        public string method { get; set; }
        public int amount_refunded { get; set; }
        public object refund_status { get; set; }
        public bool captured { get; set; }
        public string description { get; set; }
        public string card_id { get; set; }
        public Card card { get; set; }
        public object bank { get; set; }
        public object wallet { get; set; }
        public object vpa { get; set; }
        public string email { get; set; }
        public string contact { get; set; }
        public Notes notes { get; set; }
        public int fee { get; set; }
        public int tax { get; set; }
        public object error_code { get; set; }
        public object error_description { get; set; }
        public object error_source { get; set; }
        public object error_step { get; set; }
        public object error_reason { get; set; }
        public int created_at { get; set; }
    }
   
}