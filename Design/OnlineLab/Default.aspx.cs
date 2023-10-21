using System;
using System.Data;
using System.Web;
using System.Web.UI;

public partial class Design_Online_Lab_Default : System.Web.UI.Page
{
    private string usertype = "";
    private string Labno = "";
    protected void Page_Load(object sender, EventArgs e)
    {
		Session["ID"] = txtUserName.Text.Trim();
        try
        {
            if (Request.QueryString["Username"] != null && Request.QueryString["Password"] != null)
            {
                txtUserName.Text = Request.QueryString["Username"];
                txtPassword.Text = Request.QueryString["Password"];
                ddlLoginType.SelectedValue = "Patient";
                btnLogin_Click(sender,e);
            }
        }
        catch
        {
        }

    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string s = string.Empty;
     //   if (Request.QueryString["Username"] != "" && Request.QueryString["Password"] != "")
      //  {
       //     return;
     //   }
        if (txtUserName.Text.Trim() == string.Empty)
        {
            lblError.Visible = true;
            lblError.Text = "Please Enter Username";
            txtUserName.Focus();
            return;
        }
        if (txtPassword.Text.Trim() == string.Empty)
        {
            lblError.Visible = true;
            lblError.Text = "Please Enter Password";
            txtPassword.Focus();
            return;
        }
        usertype = ddlLoginType.SelectedItem.Value;

        if (usertype == "Patient")
        {
            //s = "select LedgerTransactionNo,patient_id from f_ledgertransaction  where  Patient_ID=@Username and LedgerTransactionNo=@Password ";
            s = " SELECT LedgerTransactionNo,patient_id FROM f_ledgertransaction  WHERE  `Username_web`=@Username AND `Password_web`=@Password";

        }
        else if (usertype == "Doctor")
        {
            s = "select * from  doctor_referal  where  UserName=@Username and PASSWORD=@Password";
        }
        else if (usertype == "Panel")
        {
            s = "select PanelUserID, PanelPassword,IsActive   from f_panel_master  where  PanelUserID=@Username and PanelPassword=@Password  AND IsActive=1";
        }
        else
        {
            lblError.Text = "Select User Type";
        }
        DataTable dt = new DataTable();
        if (usertype == "Patient")
        {
            string uid = txtUserName.Text.Trim();
            dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, s,
                        new MySql.Data.MySqlClient.MySqlParameter("@Username", uid),
                        new MySql.Data.MySqlClient.MySqlParameter("@Password", txtPassword.Text.Trim())).Tables[0];
        }
        else if (usertype == "Doctor" || usertype == "Panel")
        {
            dt = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, s,
                        new MySql.Data.MySqlClient.MySqlParameter("@Username", txtUserName.Text.Trim()),
                        new MySql.Data.MySqlClient.MySqlParameter("@Password", txtPassword.Text.Trim())).Tables[0];
        }

        if (dt.Rows.Count == 0)
        {
            lblError.Text = "Invalid User ID Password";
            txtUserName.Text = "";

            lblError.Visible = true;
        }
        else
        {
           
            if (usertype == "Patient")
            {
                Labno = dt.Rows[0]["LedgerTransactionNo"].ToString();
                string LedgerTransactionNo = "";
                if (AllGlobalFunction.LockDueReport == "Y")
                {
                    string QUER = "SELECT LedgerTransactionNo FROM f_ledgertransaction  WHERE  LedgerTransactionNo=@LedgerTransactionNo ";
                    LedgerTransactionNo = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, QUER,
                    new MySql.Data.MySqlClient.MySqlParameter("@LedgerTransactionNo",Labno.Trim())));

                    string strdue = "";

                    strdue = "select (NetAmount - Adjustment )DueAmt from f_ledgertransaction where LedgerTransactionNo=@LedgerTransactionNo and AmtCredit=0 and NetAmount > Adjustment";

                    DataTable da = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, strdue,
                   new MySql.Data.MySqlClient.MySqlParameter("@LedgerTransactionNo", Labno.Trim())).Tables[0];

                    if (da != null && da.Rows.Count > 0)
                    {
                        string d = da.Rows[0]["DueAmt"].ToString();
                        lblError.Text = "Kindly pay due Amount Rs." + d;
                        lblError.Visible = true;
                        return;
                    }
                }
                lblError.Text = "valid";
                Session["isLogin"] = "true";
                string OnlinePanelID="1";
          //       Response.Redirect(string.Format("ViewLabReportPanel.aspx?UserType={0}&OnlinePanelID={1}", HttpUtility.UrlEncode(Common.Encrypt(usertype.Trim())), HttpUtility.UrlEncode(Common.Encrypt(OnlinePanelID.Trim()))));
                Response.Redirect(string.Format("ViewLabReportPanel.aspx?PID={0}&LedgerTransactionNo={1}&UserType={2}&OnlinePanelID={3}", HttpUtility.UrlEncode(Common.Encrypt(txtUserName.Text.Trim())), HttpUtility.UrlEncode(Common.Encrypt(Labno.Trim())), HttpUtility.UrlEncode(Common.Encrypt(usertype.Trim())), HttpUtility.UrlEncode(Common.Encrypt(OnlinePanelID.Trim()))));
              //   Response.Redirect("ViewLabReportPanel.aspx?PID=" + txtUserName.Text + "&LedgerTransactionNo=" + txtPassword.Text + "&UserType=" + usertype + "");
                lblError.Visible = true;
            }
            else if (usertype == "Doctor")
            {
                string str = "SELECT Doctor_ID FROM doctor_referal WHERE UserName=@Username AND Password=@Password ";

                string OnlineDocID = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, str,
                new MySql.Data.MySqlClient.MySqlParameter("@Username", txtUserName.Text.Trim()),
                new MySql.Data.MySqlClient.MySqlParameter("@Password", txtPassword.Text.Trim())));
                Session["isLogin"] = "true";
                Response.Redirect("ViewLabReportsNew.aspx?PID=" + "&LedgerTransactionNo=" + "&UserType=" + usertype + "&OnlineDocID=" + OnlineDocID + "&OnlinePanelID=");
            }
            else if (usertype == "Panel")
            {
                string isActive = dt.Rows[0]["IsActive"].ToString();
                if (isActive == "0")
                {
                    lblError.Text = "Your Account has been deactivated ,kindly contact account department !!";
                    lblError.Visible = true;
                    return;
                }

                string str = "SELECT pm.Panel_ID FROM f_panel_master pm WHERE pm.PanelUserID=@Username AND pm.PanelPassword=@Password";
                string OnlinePanelID = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, str,
                new MySql.Data.MySqlClient.MySqlParameter("@Username", txtUserName.Text.Trim()),
                    new MySql.Data.MySqlClient.MySqlParameter("@Password", txtPassword.Text.Trim())));
                Session["isLogin"] = "true";

                Response.Redirect(string.Format("ViewLabReportPanel.aspx?UserType={0}&OnlinePanelID={1}", HttpUtility.UrlEncode(Common.Encrypt(usertype.Trim())), HttpUtility.UrlEncode(Common.Encrypt(OnlinePanelID.Trim()))));

                // Response.Redirect("ViewLabReportPanel.aspx?PID=" + "&LedgerTransactionNo=" + "&UserType=" + usertype + "&OnlineDocID=&OnlinePanelID=" + OnlinePanelID + "");
            }
        }
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
    }

    protected void btnAdobeReader_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(Page, typeof(Page), "OpenWindow", "window.open('http://get.adobe.com/reader/');", true);
        // Response.Redirect("http://get.adobe.com/reader/");
    }

    private bool SearchDue(string strPro)
    {
        lblError.Text = "";

        DataTable dtpro = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, strPro,
            new MySql.Data.MySqlClient.MySqlParameter("@Username", txtUserName.Text.Trim()),
            new MySql.Data.MySqlClient.MySqlParameter("@Password", txtPassword.Text.Trim())).Tables[0];

        if (dtpro.Rows[0]["IsCreditLimit"].ToString() == "1")
        {
            double CreditLimitAmt = Util.GetDouble(dtpro.Rows[0]["CreditLimit"]);
            double Amt = Util.GetDouble(StockReports.ExecuteScalar("select get_pro_outstanding('" + dtpro.Rows[0]["PROID"].ToString() + "')"));
            double CreditBal = CreditLimitAmt - Amt;
            if (CreditBal < 0)
            {
                lblError.Visible = true;
                lblError.Text = dtpro.Rows[0]["PROName"].ToString() + " (PRO)  Credit Limit Exceeds By Rs." + CreditBal.ToString().Replace("-", "");
                return true;
            }
        }

        return false;
    }
}