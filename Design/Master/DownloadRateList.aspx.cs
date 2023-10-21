using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class DayWiseDiscountReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string CheckLedgerPassword(string LedgerPassword)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT COUNT(1) FROM f_panel_master fpm ");
            sb.Append(" INNER JOIN centre_Master cm ON cm.`CentreID`=fpm.`CentreID` ");
            sb.Append(" WHERE cm.`CentreID`='" + UserInfo.Centre + "' AND fpm.`LedgerReportPassword`='" + LedgerPassword + "' ");
            //sb.Append(" WHERE cm.`CentreID`='" + UserInfo.Centre + "' AND cm.`OnlinePassword`='" + LedgerPassword + "' ");
            int a = Util.GetInt(StockReports.ExecuteScalar(sb.ToString()));
            if (a > 0)
            {
                sb = new StringBuilder();

                if (HttpContext.Current.Session["CentreType"].ToString() == "CC")
                {
                    sb.Append(" SELECT sc.`Name` DeptName, im.ItemID,im.testcode,im.typeName ItemName,IFNULL(r1.Rate,0)MRP  ,IFNULL(r.Rate,0)PatientRate , ");
                    sb.Append(" IFNULL(r2.Rate,0)ClientRate  ");
                    sb.Append(" FROM f_itemmaster im   ");
                    sb.Append(" INNER JOIN f_ratelist r ON r.itemid=im.ItemID AND im.IsActive=1  AND r.`Rate` > 0 ");
                    sb.Append(" INNER JOIN f_panel_master pm ON r.panel_id=pm.`ReferenceCodeOPD` AND pm.CentreId='" + UserInfo.Centre + "'  ");
                    sb.Append(" AND pm.`PanelType`='Centre'  ");
                    sb.Append(" INNER JOIN f_ratelist r1 ON r1.itemid=im.ItemID AND r1.Panel_id=pm.PanelID_MRP  AND r1.`Rate` > 0 ");
                    sb.Append(" INNER JOIN f_ratelist r2 ON r2.itemid=im.ItemID AND r2.Panel_id=pm.`PanelShareID`  AND r2.`Rate` > 0    ");
                    sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubCategoryID` ");
                    sb.Append(" ORDER BY im.typeName ");
                }
                else
                {
                    sb.Append("   SELECT sc.`Name` DeptName, im.ItemID,im.testcode,im.typeName ItemName,IFNULL(r1.Rate,0)MRP  ,IFNULL(r.Rate,0)PatientRate  ");
                    sb.Append(" FROM f_itemmaster im   ");
                    sb.Append(" INNER JOIN f_ratelist r ON r.itemid=im.ItemID AND im.IsActive=1  AND r.`Rate` > 0 ");
                    sb.Append(" INNER JOIN f_panel_master pm ON r.panel_id=pm.`ReferenceCodeOPD` AND pm.CentreId='" + UserInfo.Centre + "'   ");
                    sb.Append(" AND pm.`PanelType`='Centre'  ");
                    sb.Append(" INNER JOIN f_ratelist r1 ON r1.itemid=im.ItemID AND r1.Panel_id=pm.PanelID_MRP  AND r1.`Rate` > 0 ");
                    sb.Append(" INNER JOIN `f_subcategorymaster` sc ON sc.`SubCategoryID`=im.`SubCategoryID` ");
                    sb.Append(" ORDER BY im.typeName ");
                }

                DataTable dt = StockReports.GetDataTable(sb.ToString());
                if (dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    //HttpContext.Current.Session["ReportName"] = "Download Rate List";
                    //HttpContext.Current.Session["Period"] = "";
                    //return "1";
                    return "1";

                }
                else
                {
                    return "2";
                }

            }
            else
            {
                return "0";
            }
        }
        catch
        {
            return "-1";
        }
    }

}