using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_ABHA_AbhaRegistration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           txtSearchModelFromDate.Text = txtSerachModelToDate.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            calExdTxtSerachModelToDate.EndDate = calExdTxtSearchModelFromDate.EndDate = System.DateTime.Now;
        }

        txtSearchModelFromDate.Attributes.Add("readOnly", "readOnly");
        txtSerachModelToDate.Attributes.Add("readOnly", "readOnly");

    }
}