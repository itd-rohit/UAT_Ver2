using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Web.Services;

public partial class Design_Investigation_EditObservationDetail : System.Web.UI.Page
{
    public string ObsId = "";
    public string InvId = "";
    

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            ObsId = Request.QueryString["ObsId"].ToString();
            InvId = Request.QueryString["InvId"].ToString();
            BindMachine();
            BindCentre();
        }
    }

    private void BindMachine()
    {
        DataTable dt = StockReports.GetDataTable("SELECT NAME,ID FROM macmaster WHERE isActive=1 ORDER BY Name ");
        ddlMac.DataSource = dt;
        ddlMac.DataTextField = "NAME";
        ddlMac.DataValueField = "ID";
        ddlMac.DataBind();
    }


    private void BindCentre()
    {
        DataTable dt = StockReports.GetDataTable("SELECT centreID,Centre FROM centre_master  WHERE isActive=1 ORDER BY centre ");
        ddlCentre.DataSource = dt;
        ddlCentre.DataTextField = "Centre";
        ddlCentre.DataValueField = "centreID";
        ddlCentre.DataBind();
    }

    [WebMethod]
    public static string CheckCritical(string LabObservationID)
    {
        var count = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1) FROM `labobservation_investigation` WHERE labObservation_ID='" + LabObservationID + "'  AND iscritical=1 "));
        if (count > 0)
            return "1";
        else
            return "0";
    }
}
