using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Sales_SetSalesTargetMonthWise : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string url = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/ExceUploadApp/SetSalesTarget.aspx?UserID=" + Util.GetString(Session["ID"]);

        my.Attributes["src"] = url; 
    }
}