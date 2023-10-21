using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_ABHA_AbhaHIUDataRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = txtToDate.Text = txtConFrom.Text = txtConTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            txtConsentExpiry.Text = System.DateTime.Now.AddDays(1).ToString("dd-MMM-yyyy");
            CalToDate.EndDate = System.DateTime.Now;
            CalConsentExp.StartDate = System.DateTime.Now.AddDays(1);
        }

        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
        txtConsentExpiry.Attributes.Add("readOnly", "readOnly");

        txtConTo.Attributes.Add("readOnly", "readOnly");
        txtConFrom.Attributes.Add("readOnly", "readOnly");
    }
}