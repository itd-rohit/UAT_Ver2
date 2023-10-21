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

public partial class Design_Lab_RateListReport : System.Web.UI.Page
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
    public static string getReport(string CentreIDs, string PUP, string IsMultipleCentre)
    {
        string retValue = "0";
        CentreIDs = CentreIDs.TrimEnd(',').Trim();
        if (IsMultipleCentre.Trim() == "1")
        {
            if (PUP.Trim() == "1")
            {
                return "-2";
            }
            StringBuilder sbCPPanel = new StringBuilder();
            sbCPPanel.Append("  SELECT fpm.Centreid,cm.`Centre`,fpm.Panel_ID,fpm.ReferenceCode,fpm.Company_Name,fpm.paneltype  ");
            sbCPPanel.Append("  FROM f_panel_master fpm ");
            sbCPPanel.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=fpm.`CentreID` ");
            sbCPPanel.Append("  WHERE fpm.CentreID IN(" + CentreIDs + ") AND fpm.IsActive=1 AND cm.`isActive`=1 AND fpm.`PanelType`='Centre' ");
            DataTable dtCPanel = StockReports.GetDataTable(sbCPPanel.ToString());

            if (dtCPanel.Rows.Count > 0)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT im.`TestCode`,im.ItemID,sc.Name DepartmentName,im.typeName InvestigationName ");

                int r = 2;
                StringBuilder sbTemp1 = new StringBuilder();
                StringBuilder sbTemp2 = new StringBuilder();
                foreach (DataRow drCtemp in dtCPanel.Rows)
                {
                    sbTemp1.Append(" ,ifnull(r" + r + ".Rate,0) '" + Util.GetString(drCtemp["Centre"]) + "'  ");
                    sbTemp2.Append(" LEFT OUTER JOIN f_ratelist r" + r + " ON r" + r + ".itemid=im.ItemID AND r" + r + ".panel_id='" + Util.GetString(drCtemp["ReferenceCode"]) + "' ");
                    r += 1;
                }
                sb.Append(sbTemp1.ToString());
                sb.Append(" FROM f_itemmaster im   ");
                sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ");
                sb.Append(sbTemp2.ToString());
                sb.Append(" WHERE im.IsActive=1   ");
                sb.Append(" ORDER BY sc.name,im.TypeName ");
                DataTable dt = StockReports.GetDataTable(sb.ToString());

                if (dt != null && dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "Rate List Report";
                    HttpContext.Current.Session["Period"] = "";
                    retValue = "1";
                }
               
                
            }
        }
        else
        {
            StringBuilder sbCPPanel = new StringBuilder();
            sbCPPanel.Append(" Select (SELECT Centre FROM centre_master cm WHERE cm.CentreID='" + CentreIDs + "')Centre, ");
            sbCPPanel.Append(" Panel_ID,Company_Name,ReferenceCode,Centreid,paneltype FROM f_panel_master WHERE CentreID='" + CentreIDs + "' AND IsActive=1 ");
            DataTable dtCPanel = StockReports.GetDataTable(sbCPPanel.ToString());

            string CentreName = string.Empty;
            string CentreID = CentreIDs;

            string MainCentrePanelID = string.Empty;

            if (dtCPanel.Rows.Count > 0)
            {

                StringBuilder sbNew = new StringBuilder();
                sbNew.Append("  DROP TABLE IF EXISTS  _ratelist; ");
                sbNew.Append("  CREATE TABLE _ratelist ");
                sbNew.Append("  SELECT im.`TestCode`,im.ItemID,sc.Name DepartmentName,im.typeName InvestigationName ");
                sbNew.Append("  FROM f_itemmaster im ");
                sbNew.Append("  INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ");
                sbNew.Append("  WHERE im.IsActive=1  ");
                sbNew.Append("  ORDER BY sc.name,im.TypeName; ");
                sbNew.Append("  ALTER TABLE _ratelist ADD KEY aaItemID(ItemID); ");


                CentreName = Util.GetString(dtCPanel.Rows[0]["Centre"]);
                int r = 2;

                //StringBuilder sbCentre1 = new StringBuilder();
                //StringBuilder sbCentre2 = new StringBuilder();

                foreach (DataRow drCtemp in dtCPanel.Rows)
                {

                    sbNew.Append(" ALTER TABLE _ratelist ADD COLUMN " + Util.GetString(drCtemp["Company_Name"]).Replace(" ", "_").Replace("-", "_").Replace(",", "").Replace("&", "").Replace(".", "").Replace("(", "").Replace(")", "") + "_Rate VARCHAR(5) DEFAULT '0'; ");
                    sbNew.Append(" UPDATE _ratelist rt INNER JOIN f_ratelist r ON rt.ItemID=r.ItemID AND r.panel_id='" + Util.GetString(drCtemp["ReferenceCode"]) + "' ");
                    sbNew.Append(" SET rt." + Util.GetString(drCtemp["Company_Name"]).Replace(" ", "_").Replace("-", "_").Replace(",", "").Replace("&", "").Replace(".", "").Replace("(", "").Replace(")", "") + "_Rate = r.Rate; ");



                    //sbCentre1.Append(" ,ifnull(r" + r + ".Rate,0) '" + Util.GetString(drCtemp["Company_Name"]) + "'  ");
                    //sbCentre2.Append(" LEFT OUTER JOIN f_ratelist r" + r + " ON r" + r + ".itemid=im.ItemID AND r" + r + ".panel_id='" + Util.GetString(drCtemp["ReferenceCode"]) + "' ");
                    //r += 1;
                }



                //StringBuilder sb = new StringBuilder();
                //StringBuilder sbPUP1 = new StringBuilder();
                //StringBuilder sbPUP2 = new StringBuilder();

               // sb.Append(" SELECT im.`TestCode`,im.ItemID,sc.Name DepartmentName,im.typeName InvestigationName ");

                if (PUP == "1")
                {
                    DataTable dtPUP = StockReports.GetDataTable(" SELECT Panel_ID,Company_Name,ReferenceCode,Centreid,paneltype FROM f_panel_master WHERE tagprocessinglabid='" + CentreID + "' and paneltype='PUP' and IsActive=1 ");

                    foreach (DataRow drTemp in dtPUP.Rows)
                    {

                        sbNew.Append(" ALTER TABLE _ratelist ADD COLUMN " + Util.GetString(drTemp["Company_Name"]).Replace(" ", "_").Replace("-", "_").Replace(",", "").Replace("&", "").Replace(".", "").Replace("(", "").Replace(")", "") + "_Rate VARCHAR(5) DEFAULT '0'; ");
                        sbNew.Append("  UPDATE _ratelist rt INNER JOIN f_ratelist r ON rt.ItemID=r.ItemID AND r.panel_id='" + Util.GetString(drTemp["ReferenceCode"]) + "' ");
                        sbNew.Append("  SET rt." + Util.GetString(drTemp["Company_Name"]).Replace(" ", "_").Replace("-", "_").Replace(",", "").Replace("&", "").Replace(".", "").Replace("(", "").Replace(")", "") + "_Rate = r.Rate; ");

                        //sbPUP1.Append(" ,ifnull(r" + r + ".Rate,0) '" + Util.GetString(drTemp["Company_Name"]) + "'  ");
                        //sbPUP2.Append(" LEFT OUTER JOIN f_ratelist r" + r + " ON r" + r + ".itemid=im.ItemID AND r" + r + ".panel_id='" + Util.GetString(drTemp["ReferenceCode"]) + "' ");
                        //r += 1;
                    }
                }

                //sb.Append(sbCentre1.ToString());
                //sb.Append(sbPUP1.ToString());
                //sb.Append(" FROM f_itemmaster im   ");
                //sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID ");
                //sb.Append(sbCentre2.ToString());
                //sb.Append(sbPUP2.ToString());
                //sb.Append(" WHERE im.IsActive=1   ");
                //sb.Append(" ORDER BY sc.name,im.TypeName ");
                //DataTable dt = StockReports.GetDataTable(sb.ToString());

                sbNew.Append("select * from _ratelist;");
               // File.WriteAllText(@"F:\salek.txt", sbNew.ToString());
                DataTable dt = StockReports.GetDataTable(sbNew.ToString());

                if (dt != null && dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "Rate List Report" + CentreName;
                    HttpContext.Current.Session["Period"] = "";
                    retValue = "1";
                }

            }
        }
        return retValue;
    }
}
