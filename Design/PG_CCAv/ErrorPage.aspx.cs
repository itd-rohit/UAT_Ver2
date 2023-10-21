using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_PaymentGateWay_ErrorPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string code = Util.GetString(Request.QueryString["C"]);
        if (code == "1")
        {
            ErrorCode.Text = "Error code Is : PG-001#AMT";
        }
        if (code == "2")
        {
            ErrorCode.Text = "Error code Is : PG-002#ORD";
        }
        if (code == "3")
        {
            ErrorCode.Text = "Error code Is : PG-003#PNL";
        }
        if (code == "4")
        {
            ErrorCode.Text = "Error code Is : PG-004#MRCH";
        }

    }
}