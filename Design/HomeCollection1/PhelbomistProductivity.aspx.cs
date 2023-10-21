using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_PhelbomistProductivity : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ddlzone.DataSource = StockReports.GetDataTable("SELECT businesszoneid,businesszonename FROM `businesszone_master`");
            ddlzone.DataValueField = "businesszoneid";
            ddlzone.DataTextField = "businesszonename";
            ddlzone.DataBind();
            ddlzone.Items.Insert(0, new ListItem("Select Zone", "0"));
        }
    }

    [WebMethod]
    public static string bindstate(int zoneid)
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT id,state FROM state_master WHERE businesszoneid=" + zoneid + " order by state"));
    }
    [WebMethod]
    public static string bindcity(int stateid)
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT id,city FROM city_master WHERE stateid=" + stateid + " order by city"));
    }
    [WebMethod]
    public static string bindPhelbo(int cityid)
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT hp.`PhlebotomistID`,hp.`Name` FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phleboworklocation` hw ON hp.`PhlebotomistID`=hw.`PhlebotomistID` AND hp.`IsActive`=1 AND hw.`CityId`=" + cityid + " ORDER BY NAME "));
    }

    [WebMethod]
    public static string GetALlData(string Phelbotomist, string fromdate, string todate)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT pm.`PhlebotomistID`,pm.Name,ifnull(pm.`Age`,'')Age,GROUP_CONCAT(DISTINCT sm.state) state,GROUP_CONCAT(DISTINCT cm.city)city , SUM(IF(hcb.CurrentStatus='Rescheduled',1,0)) AS Rescheduled ");
        sb.Append(" , SUM(IF(hcb.CurrentStatus='Canceled',1,0)) AS Canceled ");
        sb.Append(" , SUM(IF((hcb.CurrentStatus='Completed' OR hcb.CurrentStatus='BookingCompleted' ),1,0)) AS Completed,ifnull(pp.`ProfilePics`,'')ProfilePics ");
        sb.Append(" ,IFNULL( TRUNCATE(SUM(IFNULL( hcb.phelboRating,0))/ SUM(IF(IFNULL( hcb.phelboRating,'')='',0,1)),2),'N/A') AS Rating ");
        sb.Append(" ,SUM(IF(IFNULL(BookedDate,'')='',0,IF(`Appenddatetime`>=BookedDate,1,0))) AS 'InTime' ");
        sb.Append(" ,SUM(IF(IFNULL(BookedDate,'')='',0,IF(`BookedDate`>Appenddatetime,1,0))) AS 'Devited' ");
        sb.Append("  FROM " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hcb ");
        sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` pm ON pm.`PhlebotomistID`=hcb.`PhlebotomistID` ");
        sb.Append(" and hcb.EntryDateTime>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and hcb.EntryDateTime<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (Phelbotomist != "")
        {
            sb.Append(" and hcb.`PhlebotomistID` in (" + Phelbotomist + ") ");
        }
        sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phleboworklocation` pw ON pw.`PhlebotomistID`=pm.`PhlebotomistID` ");
        sb.Append(" INNER JOIN `state_master` sm ON sm.id=pw.stateid ");
        sb.Append(" INNER JOIN `city_master` cm ON cm.id=pw.CityId ");
        sb.Append(" left JOIN " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster_profilepic pp ON pp.`PhlebotomistID`=pm.`PhlebotomistID` AND pp.`Approved`=1 AND pp.`Active`=1 ");
        sb.Append(" WHERE CurrentStatus IN('Completed','BookingCompleted','Rescheduled','Canceled') ");
        sb.Append(" GROUP BY pm.`PhlebotomistID` ");

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(sb.ToString());

        return JsonConvert.SerializeObject(dt);
    }
}