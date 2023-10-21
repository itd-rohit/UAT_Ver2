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
using System.Text;
using System.IO;

public partial class Design_Lab_InHouseOutHouseReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {            
        }

    }
    [WebMethod]
    public static string bindCentreLoadType(string BusinessZoneID, string StateID, string CityID, string TypeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CentreID,Centre FROM centre_master WHERE IsActive=1 ");
        if (BusinessZoneID != "0" && BusinessZoneID != "-1")
            sb.Append(" AND BusinessZoneID in(" + BusinessZoneID + ") ");
        if (StateID != "0" && StateID != "-1")
            sb.Append(" AND StateID in (" + StateID + ") ");
        if (CityID != "0" && CityID != "-1")
            sb.Append(" AND CityID in (" + CityID + " )");
        if (TypeID != "0" && TypeID != "-1")
            sb.Append(" AND type1ID in (" + TypeID + " )");
        sb.Append("  order by centre ");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public static string getReport(string CentreData, string PUP)
    {
        string retValue = "0";

        string CentreName = CentreData.Split('|')[0];
        string CentreID = CentreData.Split('|')[1];
        string Qry=" call get_test_list_with_processing_lab(" + CentreID + ");";

        return Util.getJson(new { Query = Qry, ReportName = "In House Out House Report", Period = "", ReportPath = AllLoad_Data.getHostDetail("Report") });
    }
}
