using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Lab_PrePrintedBarcode : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindCentre();
        }
    }

    private void BindCentre()
    {
        string str = "select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.Centre  ";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        ddlCentreAccess.DataSource = dt;
        ddlCentreAccess.DataTextField = "Centre";
        ddlCentreAccess.DataValueField = "CentreID";
        ddlCentreAccess.DataBind();

        ddlCentreAccess.Items.Insert(0, new ListItem("ALL Centre", "ALL"));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string FromDate, string ToDate, string Centre, string Type)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT sm.`Name` Department,SUM(plo.`Rate`) NetAmount FROM f_ledgertransaction lt ");
        sb.Append(" INNER JOIN Patient_labInvestigation_OPD plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
        sb.Append(" WHERE 0=0 ");
        if (FromDate != string.Empty)
            sb.Append(" AND lt.Date >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        if (ToDate != string.Empty)
            sb.Append(" AND lt.Date <= '" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
        if (Centre != "ALL")
            sb.Append(" AND lt.`CentreID`='" + Centre + "' ");

        sb.Append(" GROUP BY plo.`SubCategoryID`  ORDER BY sm.`Name` ");
        var Flag = "0";
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                if (Type == "1")
                {
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    HttpContext.Current.Session["ds"] = ds;
                    HttpContext.Current.Session["ReportName"] = "DepartmentWiseSalesReport";
                    //ds.WriteXml("h:/DepartmentWiseSalesReport.xml");
                    Flag = "1";
                }
                else if (Type == "2")
                {
                    HttpContext.Current.Session["ReportName"] = "DepartmentWiseSalesReport";
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    Flag = "2";
                }
            }
            return Flag;
        }
    }
}