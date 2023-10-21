using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_HomeCollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           // AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindFieldBoy();
            bindcentre();
           

        }
    }


    void bindcentre()
    {
        ddlcentre.DataSource = StockReports.GetDataTable("SELECT centreid,centre FROM centre_master WHERE  isactive=1 ORDER BY centre");
        ddlcentre.DataTextField = "centre";
        ddlcentre.DataValueField = "centreid";
        ddlcentre.DataBind();
       
    }
    void bindFieldBoy()
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT fm.Name ,fm.FeildboyID Id FROM feildboy_master fm ");
        // sb.Append("  INNER JOIN `feildboy_master_zone` fmz ON fmz.`FeildboyID`=fm.`FeildboyID`  ");
        sb.Append("  INNER JOIN `fieldboy_zonedetail` fmz ON fmz.`FieldBoyID`=fm.`FeildboyID` ");
        sb.Append("  AND fmz.`ZoneID` = ( SELECT `BusinessZoneID` FROM  `centre_master` cm WHERE cm.`CentreID`='" + Session["Centre"].ToString() + "') ");
        sb.Append("  WHERE fm.isactive=1 ORDER BY NAME ");

        ddlFieldBoy.DataSource = StockReports.GetDataTable(sb.ToString());
        ddlFieldBoy.DataTextField = "Name";
        ddlFieldBoy.DataValueField = "Id";
        ddlFieldBoy.DataBind();
        
    }


    public string Search()
    {

        string fromdate = Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + " 00:00:00";
        string todate = Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd") + " 23:59:59";
        StringBuilder sb;
        sb = new StringBuilder();
        sb.Append("   SELECT FM.Name,cm.CentreCode, CM.Centre,pnl.Panel_Code,pnl.Company_name PanelName, plo.ItemName,plo.Rate,plo.DiscountAmt ,plo.Amount, ");
        sb.Append(" lt.PName Patient,lt.Age,lt.Gender ,DATE_FORMAT(lt.Date,'%d-%b-%Y %I:%i %p') AS BookingDate , ");
        sb.Append("  DATE_FORMAT(max(plo.SampleCollectionDate),'%d-%b-%Y %I:%i %p') AS SampleCollectionDate  ");
sb.Append("    ,(lt.`NetAmount`-lt.`Adjustment`) BalanceAmount,pm.`Mobile`,CONCAT(IFNULL(pm.`House_No`,''),' ',IFNULL(pm.`Street_Name`,''),' ',IFNULL(pm.`Locality`,''),' ',IFNULL(pm.City,''),' ',IFNULL(pm.`State`,'')) Address ");
        sb.Append(" FROM feildboy_master FM ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.HomeVisitBoyId=FM.FeildBoyId ");
        sb.Append(" INNER JOIN Patient_labInvestigation_OPD plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
        sb.Append(" INNER JOIN Centre_Master CM ON Cm.CentreId=lt.CentreId ");
        sb.Append(" INNER JOIN f_panel_master pnl on pnl.Panel_ID=lt.Panel_ID ");
	sb.Append(" INNER JOIN patient_master pm ON lt.`Patient_ID`=pm.`Patient_ID` ");
        sb.Append(" where lt.`IsCancel`=0 AND lt.`VisitType`='Home Collection' /* AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) */ ");
        if (hdnCentreId.Value != "")
            sb.Append(" AND lt.`CentreID` in (" + hdnCentreId.Value + ") ");
        if (hdnFieldBoyId.Value != "")
            sb.Append(" AND lt.HomeVisitBoyId in (" + hdnFieldBoyId.Value + ") ");
        sb.Append(" AND lt.DATE >= '" + fromdate + "' AND  lt.DATE <= '" + todate + "' ");
        sb.Append(" group by plo.LedgerTransactionID,plo.ItemID ORDER BY FM.Name ");

       ///  DataTable dt = StockReports.GetDataTable(sb.ToString());
        //return dt;
        return sb.ToString();

    }

    protected void btnExport_Click(object sender, EventArgs e)
    {

         //DataTable dt = Search();
        string sb = Search();
        //if (dt.Rows.Count > 0)
        //{
        //    Session["dtExport2Excel"] = dt;
        //    Session["ReportName"] = "HomeCollectionReport_" + DateTime.Now.ToString();
        //    ScriptManager.RegisterStartupScript(this, GetType(), "", "window.open('../common/ExportToExcel.aspx');", true);

        //}
        //else
        //{
        //    lblMsg.Text = "No Record Found !";
        //}
        AllLoad_Data.exportToExcel(sb, "HomeCollectionReport", "", "1", this.Page);

    }



}