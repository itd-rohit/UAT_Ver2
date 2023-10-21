using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Net;

using System.Diagnostics;
using System.Drawing.Printing;

public partial class Design_Lab_labreportnew_ShortSMS : System.Web.UI.Page
{
    public string LabNo = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LabNo = Util.GetString(Request.QueryString["LabNo"]);
            if (LabNo != "")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT `Password_web`,Username_web FROM f_ledgertransaction  WHERE LedgerTransactionNo=@LedgerTransactionNo  ");//and Password_Web=@Password_Web
                DataTable dtTemp = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
                new MySql.Data.MySqlClient.MySqlParameter("@LedgerTransactionNo", LabNo)).Tables[0];

                //  new MySql.Data.MySqlClient.MySqlParameter("@Password_Web", Common.Decrypt(HttpUtility.UrlDecode(LabNo).Trim()))).Tables[0];

                if (dtTemp.Rows.Count > 0)
                {
                    Response.Redirect("~/Design/OnlineLab/Login.aspx?LabNo=" + Util.GetString(dtTemp.Rows[0]["Username_web"]) + "&WebPassword=" + Util.GetString(dtTemp.Rows[0]["Password_web"]) + "&IsTinySMS=1&IsNew=1");
                }
                else
                {
                    lblMsg.Text = "Kindly Contact To  Client";
                }
            }
            else
            {
                lblMsg.Text = "Kindly Contact To Client";
            }
        }
    }
}