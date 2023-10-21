using MySql.Data.MySqlClient;
using System;
using CCA.Util;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_PaymentGateWay_PaymentResponse : System.Web.UI.Page
{
    string orderid = "", order_status = "", Receipt_No = "", type = "", Labnumber = "", trakingid = "", panelid = "", bank_ref_no = "", payment_mode = "", tid = "", amount, billingName, Remark = "", netbal, panel = "", PanelCode = "", CentreId = "", UserName = "";
    string trn_date;
    string dt = "", SucessDate = "";

    string merc_hash_string = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {

        string workingKey = "ED0EF0FB9C96C4F9D29D73B7FAE1D431";//put in the 32bit alpha numeric key in the quotes provided here
        CCACrypto ccaCrypto = new CCACrypto();
        string encResponse = ccaCrypto.Decrypt(Request.Form["encResp"], workingKey);
        NameValueCollection Params = new NameValueCollection();
        string[] segments = encResponse.Split('&');
        foreach (string seg in segments)
        {
            string[] parts = seg.Split('=');
            if (parts.Length > 0)
            {
                string Key = parts[0].Trim();
                string Value = parts[1].Trim();
                Params.Add(Key, Value);
            }
        }
        if (!IsPostBack)
        {

            for (int i = 0; i < Params.Count; i++)
            {

                if (Params.Keys[i] == "order_id")
                {
                    orderid = Convert.ToString(Params[i]);
                }
                if (Params.Keys[i] == "order_status")
                {
                    order_status = Convert.ToString(Params[i]);
                }
                if (Params.Keys[i] == "merchant_param1")
                {
                    type = Convert.ToString(Params[i]);
                    type = type.ToLower();
                }
                if (Params.Keys[i] == "tracking_id")
                {
                    trakingid = Convert.ToString(Params[i]);
                }
                if (Params.Keys[i] == "bank_ref_no")
                {
                    bank_ref_no = Convert.ToString(Params[i]);
                }
                if (Params.Keys[i] == "payment_mode")
                {
                    payment_mode = Convert.ToString(Params[i]);
                }
                if (Params.Keys[i] == "trans_date")
                {
                    SucessDate = DateTime.Now.ToString(Params[i]);
                    trn_date = DateTime.Now.ToString(Params[i]);
                }
                if (Params.Keys[i] == "amount")
                {
                    amount = Convert.ToString(Params[i]);
                }
                if (Params.Keys[i] == "delivery_name")
                {
                    billingName = Convert.ToString(Params[i]);
                }
                if (Params.Keys[i] == "merchant_param1")
                {
                    panelid = Convert.ToString(Params[i]);
                }
                if (Params.Keys[i] == "merchant_param2")
                {
                    UserName = Convert.ToString(Params[i]);
                }

                if (Params.Keys[i] == "merchant_param3") ;
                {
                    CentreId = Convert.ToString(Params[i]);
                }
                if (Params.Keys[i] == "merchant_param4")
                {
                    Labnumber = Convert.ToString(Params[i]);
                }
                if (Params.Keys[i] == "merchant_param5")
                {
                    Remark = Convert.ToString(Params[i]);
                }
            }
            lblOrderStatus.Text = order_status;
            lblOrderId.Text = orderid;
            lbltransactionamount.Text = amount;
            lbltransactionDate.Text = DateTime.Now.ToString(); ;
            string UserId = UserName.Split('|')[0];
            string Depostited = UserName.Split('|')[0];

            if (order_status != "Success")
            {
                lblMsg.Text = "Cancellation Payment";
                string sql1 = "INSERT INTO payumoney_integration (tracking_id,`bank_ref_no`,`Status`,`paymentMode`,Updatedate,paymentId,Amount,Panel_ID,Panel_Code,PaymentNote,LabNumber) VALUES('" + trakingid + "','" + bank_ref_no + "','" + order_status + "','" + payment_mode + "',NOW(),'" + orderid + "','" + amount + "','" + panelid + "','" + PanelCode + "','" + Remark + "','" + Labnumber + "')";
                StockReports.ExecuteDML(sql1);
                string sql3 = "UPDATE panel_paymentprev_details SET  payUTransactionID='" + bank_ref_no + "',payUTracking_id='" + trakingid + "',Status='" + order_status + "',payUAmount='" + amount + "',IsSuccess=-1,OrderStatus='Success',payUTransactionDate=Now()  Where OrderId= '" + orderid + "' and IsSuccess=0 ";
                StockReports.ExecuteDML(sql3);

            }
            else
            {

                // PanelAdvanceAmount obj = new PanelAdvanceAmount();
                CCAvPaymentResponse obj = new CCAvPaymentResponse();
                //string PanelID, string dtAdv, string AdvAmount, string PaymentMode, string typeOfPayment, string ISOnlinePayment, string OnlinePaymentRemark
                if (Util.GetInt(StockReports.ExecuteScalar("select count(*) from payumoney_integration where tracking_id='" + trakingid + "'")) > 0)
                {
                    lblMsg.Text = "This Payment of Rs." + amount + " already  added to your account.";
                    return;
                }

              string cc= obj.SavePaymentResponse(panelid, trn_date, amount, payment_mode, "0", Depostited, UserId, Remark, "HDFC_ONLINE", CentreId);
                string sql1 = "INSERT INTO payumoney_integration (tracking_id,`bank_ref_no`,`Status`,`paymentMode`,Updatedate,paymentId,Amount,Panel_ID,Panel_Code,PaymentNote,LabNumber) VALUES('" + trakingid + "','" + bank_ref_no + "','" + order_status + "','" + payment_mode + "',NOW(),'" + orderid + "','" + amount + "','" + panelid + "','" + PanelCode + "','" + Remark + "','" + Labnumber + "')";
                StockReports.ExecuteDML(sql1);
                string sql3 = "UPDATE panel_paymentprev_details SET  payUTransactionID='" + bank_ref_no + "',payUTracking_id='" + trakingid + "',Status='" + order_status + "',payUAmount='" + amount + "',IsSuccess=1,OrderStatus='Success',payUTransactionDate=Now()  Where OrderId= '" + orderid + "' and IsSuccess=0 ";
                StockReports.ExecuteDML(sql3);
                lblMsg.Text = "Payment of Rs." + amount + " received, and added to your account.";


            }
        }
    }

    // if (order_status != "Success")
    // {
    // lblMsg.Text = "Cancellation Payment";
    // string sql1 = "INSERT INTO payumoney_integration (tracking_id,`bank_ref_no`,`Status`,`paymentMode`,Updatedate,paymentId,Amount,Panel_ID,Panel_Code,PaymentNote,LabNumber) VALUES('" + trakingid + "','" + bank_ref_no + "','" + order_status + "','" + payment_mode + "',NOW(),'" + orderid + "','" + amount + "','" + panelid + "','" + PanelCode + "','" + Remark + "','" + Labnumber + "')";
    // StockReports.ExecuteDML(sql1);
    // string sql3 = "UPDATE panel_paymentprev_details SET  payUTransactionID='" + bank_ref_no + "',payUTracking_id='" + trakingid + "',Status='" + order_status + "',payUAmount='" + amount + "',IsSuccess=-1,OrderStatus='Success',payUTransactionDate=Now()  Where OrderId= '" + orderid + "' and IsSuccess=0 ";
    // StockReports.ExecuteDML(sql3);

    // }
    // else
    // {

    // PanelAdvanceAmount objInvoice = new PanelAdvanceAmount();
    // //string PanelID, string dtAdv, string AdvAmount, string PaymentMode, string typeOfPayment, string ISOnlinePayment, string OnlinePaymentRemark
    // if (Util.GetInt(StockReports.ExecuteScalar("select count(*) from payumoney_integration where tracking_id='" + trakingid + "'")) > 0)
    // {
    // lblMsg.Text = "This Payment of Rs." + amount + " already  added to your account.";
    // return;
    // }

    // objInvoice.SavePaymentResponse(string PanelID,DateTime DepositeDate, string dtAdv, string AdvAmount, string PaymentMode, string TypeOfPayment,string UserName, string UserId, string Remark, string BankName, string CentreID);
    // string sql1 = "INSERT INTO payumoney_integration (tracking_id,`bank_ref_no`,`Status`,`paymentMode`,Updatedate,paymentId,Amount,Panel_ID,Panel_Code,PaymentNote,LabNumber) VALUES('" + trakingid + "','" + bank_ref_no + "','" + order_status + "','" + payment_mode + "',NOW(),'" + orderid + "','" + amount + "','" + panelid + "','" + PanelCode + "','" + Remark + "','" + Labnumber + "')";
    // StockReports.ExecuteDML(sql1);
    // string sql3 = "UPDATE panel_paymentprev_details SET  payUTransactionID='" + bank_ref_no + "',payUTracking_id='" + trakingid + "',Status='" + order_status + "',payUAmount='" + amount + "',IsSuccess=1,OrderStatus='Success',payUTransactionDate=Now()  Where OrderId= '" + orderid + "' and IsSuccess=0 ";
    // StockReports.ExecuteDML(sql3);
    // lblMsg.Text = "Payment of Rs." + amount + " received, and added to your account.";


    // }
    // }
    // }

    private void InsertReceiptDetails(string Labnumber)
    {
        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            
            string PatientID = StockReports.ExecuteScalar("select patient_Id from f_ledgertransaction WHERE  `LedgertransactionNo`= '" + Labnumber + "' LImit 1 ");
           // Receipt objRecipt = new Receipt(Tranx);
           // objRecipt.LedgerNoCr = "HOSP0005";
           // objRecipt.LedgerNoDr = "HOSP0001";
           // objRecipt.AmountPaid = Util.GetDouble(amount);
           // objRecipt.AmtCheque = Util.GetDouble(amount);
           // objRecipt.ChequeBankName = "Online";//Bank;
           // objRecipt.ChequeNo = "";//CreditCardNo;
           //// objRecipt.Cheque_DDdate = Convert.ToDateTime(trn_date);
           // objRecipt.AsainstLedgerTnxNo = Labnumber;
           // objRecipt.Date = DateTime.Now;
           // objRecipt.Time = Convert.ToDateTime(StockReports.ExecuteScalar("SELECT now() "));
           // objRecipt.IsCheque_Draft = payment_mode;
           // objRecipt.Hospital_ID = "";
           // objRecipt.Reciever = "EMP001";
           // objRecipt.Depositor = PatientID;
           // objRecipt.Naration = Remark;
           // objRecipt.IsActual = 1;
           // objRecipt.UniqueHash = "";
           // //objRecipt.ipaddress = StockReports.getip();
           // objRecipt.UpdateID = "EMP001";
           // objRecipt.UpdateName = "Online";
           // objRecipt.UpdateRemarks = "Settlement";
           // // objRecipt.centreID = "1";
           // objRecipt.Updatedate = System.DateTime.Now;
           // Receipt_No = objRecipt.Insert();




            Receipt objRC = new Receipt(Tranx);
              objRC.LedgerNoCr = "HOSP0005";
              //  objRC.LedgerNoDr ="HOSP0001";
                objRC.Amount = Util.GetDecimal(amount) ;
               //objRC.AmtCheque=Util.GetDouble(amount);
                objRC.BankName="ONLINE";
                objRC.CardNo="";
                objRC.CardDate = DateTime.Now;
                objRC.Narration = Remark;
            //    objRC.AsainstLedgerTnxNo=Labnumber;
            
            //objRC.IsCheque_Draft=payment_mode;
            //    objRC.Hospital_ID = "";
            //     objRC.Reciever="EMP001";
            //    objRC.Depositor=PatientID;
                
               
               
            //objRC.IsActual=1;
            //objRC.UniqueHash="";
                Receipt_No = objRC.Insert();
            
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update f_ledgertransaction set Adjustment=Adjustment+" + Util.GetDouble(amount) + ",AdjustmentDate=now(),ipaddress='" + StockReports.getip() + "',UpdateID='" + HttpContext.Current.Session["ID"].ToString() + "',UpdateName='" + HttpContext.Current.Session["LoginName"].ToString() + "',UpdateRemarks='Settlement',UpdateDate=now() where LedgertransactionNo='" + Labnumber + "' ");
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
        catch (Exception ex)
        {


            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            con.Close();
            con.Dispose();
        }
    }

    public string Generatehash512(string text)
    {

        byte[] message = Encoding.UTF8.GetBytes(text);

        UnicodeEncoding UE = new UnicodeEncoding();
        byte[] hashValue;
        SHA512Managed hashString = new SHA512Managed();
        string hex = "";
        hashValue = hashString.ComputeHash(message);
        foreach (byte x in hashValue)
        {
            hex += String.Format("{0:x2}", x);
        }
        return hex;

    }
    protected void btnHome_Click(object sender, EventArgs e)
    {
        //if (((Button)sender).CommandName == "Home")
        //    Response.Redirect("../welcome.aspx");  //comment by HEMANT on 27-9-2019

        //else
        //    Response.Redirect("../invoicing/AdvacePayment.aspx");
    }
}