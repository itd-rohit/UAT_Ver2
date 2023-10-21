﻿using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
public partial class Design_PaymentGateWay_OnlinePayment : System.Web.UI.Page
{
    public string UserId = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            Bindpanel();
        }

    }
    private void Bindpanel()
    {
        
		StringBuilder sb = new StringBuilder();
        /*sb.Append("  SELECT CONCAT(IFNULL(pm.Panel_code,''),'-',pm.Company_Name) Company_Name  ,pm.Panel_ID  ");
        sb.Append("  FROM f_panel_master pm   ");
        sb.Append("  INNER JOIN `centre_panel` cp ON pm.`Panel_ID`=cp.`PanelId`   ");
        sb.Append("  INNER JOIN f_login fl ON  cp.`CentreId`=fl.`CentreID`   ");
        sb.Append("  WHERE fl.employeeID='"+HttpContext.Current.Session["ID"].ToString() +"'    ");
        sb.Append("  AND fl.RoleID='" + HttpContext.Current.Session["RoleID"].ToString() + "'   ");
        sb.Append("  AND pm.isActive=1 AND pm.Payment_Mode='Credit' and pm.Panel_Id=pm.InvoicePanelID   ");
        sb.Append("  GROUP BY pm.`Panel_ID` ORDER BY pm.Company_Name");*/

       // DataTable dt = StockReports.GetDataTable("SELECT concat(Panel_code,' ~ ',Company_Name) Company_Name,CONCAT(Panel_ID,'#',ReferenceCodeOPD)PanelID,Panel_ID FROM f_panel_master pm;");
string qry = "SELECT concat(Panel_code,' ~ ',Company_Name) Company_Name,CONCAT(Panel_ID,'#',ReferenceCodeOPD)PanelID,Panel_ID,PanelType FROM f_panel_master pm ";
        if (UserInfo.RoleID == 211) {
            qry += "where panel_id=" + Util.GetInt(Session["ID"].ToString()) + " ";
        }
        DataTable dt = StockReports.GetDataTable(qry);
       
         ddlpanel.DataSource = dt;
        ddlpanel.DataTextField = "Company_Name";
        ddlpanel.DataValueField = "Panel_ID";
        ddlpanel.DataBind();
       // ddlpanel.Items.Insert(0, new ListItem("-- Select Panel --", "0"));
		
    }
    [WebMethod]
    public static string ValidateLabnumber(string labnumber)
    {
        try
        {
            string result = StockReports.ExecuteScalar("SELECT Count(1) FROM Patient_Labinvestigation_OPD  where LedgertransactionNo ='" + Util.GetString(labnumber) + "' LIMIT 1 ");
            if (result == "0")
                return "0";
            else
                return "1";
        }
        catch (Exception)
        { 
            return "0";
        }
    }
  
    protected void submit_Click1(object sender, EventArgs e)
    {
        try
        {
            string Name = string.Empty;
            string Email = string.Empty;
            string Mobile = string.Empty;
            string PanelID = string.Empty;
            string TrnxId = string.Empty;
            string PanelCode = string.Empty;
            string url = "ccavRequestHandler.aspx";
            string OrderId = string.Empty;
            string UserName="";
            string labnumber = LabNumber.Text;
            DataTable dt1 = new DataTable();
            string hash_string = string.Empty;//
            TrnxId = GettrnxNo();
            if (Session["ID"] != null && Session["ID"].ToString() != "")
            {
                if (Util.GetInt(amount.Text) < 1)
                {
                    lblMsg.Text = "Minimum amount should be Rs. 1";
                    return;
                }
                PanelID = ddlpanel.SelectedValue;
                UserId = Util.GetString(Session["ID"]);
                if (PanelID != "")
                {
                    dt1 = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, "SELECT `Company_Name`,`Panel_ID`,`Panel_Code`,`EmailID`,`Phone`,`Mobile` FROM `f_panel_master` WHERE IsActive=1 And  `Panel_ID`=@PanelId",
                      new MySqlParameter("@PanelId", Util.GetInt(PanelID))).Tables[0];
                    if (dt1.Rows.Count > 0)
                    {   UserName=HttpContext.Current.Session["ID"].ToString()+"|"+HttpContext.Current.Session["LoginName"].ToString();
                        Name = Util.GetString(dt1.Rows[0]["Company_Name"]);
                        Email = Util.GetString(dt1.Rows[0]["EmailID"]);
                        Mobile = Util.GetString(dt1.Rows[0]["Mobile"]);
                        PanelID = Util.GetString(PanelID);
                        PanelCode = Util.GetString(dt1.Rows[0]["Panel_Code"]);
                    //  start code for generate transactionId                        
                        a:
                        OrderId = getUniqueNumber();
                        int chkno = Convert.ToInt16(StockReports.ExecuteScalar("SELECT Count(1) FROM `panel_paymentprev_details` WHERE OrderId='" + OrderId + "'"));
                        if (chkno > 0)
                        {
                            goto a;
                        }
                        string sql1 = "INSERT INTO panel_paymentprev_details (Name,EntryDate,Amount,Panel_id,Panel_Code,Remark,LabNumber,Emailid,MobileNo,TransactionNo,OrderId) VALUES('" + Name + "',now()," + Util.GetInt(amount.Text) + ",'" + PanelID + "','" + PanelCode + "','" + Remark.Text + "','" + LabNumber.Text + "','" + Email + "','" + Mobile + "','" + TrnxId + "','" + OrderId + "')";
                        bool a = StockReports.ExecuteDML(sql1);
                        if (a)// code to check  prev info saved
                        {
                            System.Collections.Hashtable data = new System.Collections.Hashtable(); // adding values in gash table for data post
                            data.Add("tid", OrderId);
                            data.Add("merchant_id", "764429");
                            data.Add("order_id", OrderId);
                            string AmountForm = Convert.ToDecimal(amount.Text.Trim()).ToString("g29");// eliminating trailing zeros                    
                            data.Add("amount", Util.GetFloat(AmountForm));
                            data.Add("currency", "INR");
                            data.Add("redirect_url", "http://itd-saas.cl-srv.ondgni.com//uat_ver1/Design/PG_CCAv/PaymentResponse.aspx");
                            data.Add("cancel_url",  "http://itd-saas.cl-srv.ondgni.com//uat_ver1/Design/PG_CCAv/PaymentResponse.aspx");
                            data.Add("billing_name", Name);
                            data.Add("billing_address", "");
                            data.Add("billing_city", "");
                            data.Add("billing_state", "");
                            data.Add("billing_zip", "");
                            data.Add("billing_country", "India");
                            data.Add("billing_tel", Mobile);
                            data.Add("billing_email", Email);
                            data.Add("merchant_param1", ddlpanel.SelectedValue.ToString());
                            data.Add("merchant_param2", UserName);
                            data.Add("merchant_param3", Session["Centre"]);
                            data.Add("merchant_param4", labnumber);
                            data.Add("merchant_param5", Remark.Text);
                            string strForm = PreparePOSTForm(url, data);
                            Page.Controls.Add(new LiteralControl(strForm));

                        }// End save previnfo save --

                    }
                    else
                    {
                        lblMsg.Text = " Error Code:#001, Payment Can't Proceed,  Please  contact admin ";//#001 for panel id not valid
                    }

                }
                else
                {

                    lblMsg.Text = " Payment Can't be  Proceed your panel code blank please contact admin ";//#001 for panel id not valid

                }// end check panel plank

            }
            else
            {
                Response.Redirect("~/Design/Default.aspx");

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Error" + ex.Message.ToString();//#001 for panel id not valid
        }
    }
    private string PreparePOSTForm(string url, System.Collections.Hashtable data)      // post form
    {
        //Set a name for the form
        string formID = "customerData";
        //Build the form using the specified data to be posted.
        StringBuilder strForm = new StringBuilder();
        strForm.Append("<form id=\"" + formID + "\" name=\"" +
                       formID + "\" action=\"" + url +
                       "\" method=\"POST\" target=\"_blank\">");
        foreach (System.Collections.DictionaryEntry key in data)
        {
            strForm.Append("<input type=\"hidden\" name=\"" + key.Key +
                           "\" value=\"" + key.Value + "\">");
        }
        strForm.Append("</form>");
        //Build the JavaScript which will do the Posting operation.
        StringBuilder strScript = new StringBuilder();
        strScript.Append("<script language='javascript'>");
        strScript.Append("var v" + formID + " = document." +
                         formID + ";");
        strScript.Append("v" + formID + ".submit();");
        strScript.Append("</script>");
        //ystem.IO.File.WriteAllText(@"D:\aa.txt", strForm.ToString() + strScript.ToString());
        return strForm.ToString() + strScript.ToString();
    }
    protected void ddlpanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        LabNumber.Text = "";
        LabNumber.Enabled = false;
        RequiredFieldLabNumber.Enabled = false;
        if (Session["UserName"] == null)
            Response.Redirect("~/Design/Default.aspx");
        else
        {
            string result = StockReports.ExecuteScalar("select Payment_Mode from f_Panel_Master where Panel_ID=" + Util.GetInt(ddlpanel.SelectedValue) + " ");
            if (result.ToLower() == "credit")
            {
                RequiredFieldLabNumber.Enabled = false;
                LabNumber.Enabled = false;

            }
        }
    }

    private string getUniqueNumber()
    {
        Random random = new Random();
        string r = "";
        int i;
        for (i = 1; i < 11; i++)
        {
            r += random.Next(0, 9).ToString();
        }
        return r;
    }
    private string GettrnxNo()
    {
        Random rnd = new Random();
        string strHash = Generatehash512(rnd.ToString() + DateTime.Now);
        return strHash.ToString().Substring(0, 20);
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

}