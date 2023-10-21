using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_Package_Inclusion_Report : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    public static string getReport(string PackageID)
    {
        string retValue = "0";
        PackageID = PackageID.TrimEnd(',');
        string PackId = "-1,";
        string ProId ="-1,";
        string[] Ids = PackageID.Split(',');
        for (int i = 0; i < Ids.Length; i++)
        {
            if (Ids[i].Split('#')[1] == "Package")
            {
                PackId = PackId + Ids[i].Split('#')[0] + ",";
            }
            else if (Ids[i].Split('#')[1] == "Profile")
            {
                ProId = ProId + Ids[i].Split('#')[0] + ",";
            }
        }

        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT (SELECT Testcode FROM f_itemmaster WHERE type_id=pld.`PlabID` LIMIT 1) PackageCode,plm.`Name` PackageName,   inv.`TestCode`,inv.`Name` Investigation FROM `package_labdetail` pld  ");
        //sb.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=pld.`InvestigationID`");
        //sb.Append(" LEFT JOIN  packagelab_master plm ON plm.`PlabID`=pld.`PlabID` ");
        //sb.Append(" LEFT JOIN f_itemmaster itm ON itm.`ItemID`=inv.`Investigation_Id` ");
        //sb.Append(" WHERE pld.`PlabID` in(" + PackageID + ")   ORDER BY plm.`Name` ");


        sb.Append("  SELECT * FROM( SELECT (SELECT Testcode FROM f_itemmaster WHERE type_id=pld.`PlabID` LIMIT 1) `Package/Profile Code`,plm.`Name` `Package/Profile`,   inv.`TestCode`,inv.`Name` Investigation,'Package' TYPE FROM `package_labdetail` pld   ");
        sb.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=pld.`InvestigationID` ");
        sb.Append(" LEFT JOIN  packagelab_master plm ON plm.`PlabID`=pld.`PlabID`  ");
        sb.Append(" LEFT JOIN f_itemmaster itm ON itm.`ItemID`=inv.`Investigation_Id`  ");
        sb.Append(" WHERE pld.`PlabID` IN(" + PackId.TrimEnd(',') + ")   ");
        sb.Append(" ORDER BY plm.`Name` )A ");
        sb.Append(" UNION ");
        sb.Append(" SELECT * FROM ( ");
        sb.Append(" SELECT IM.TestCode AS `Package/Profile Code`,IM.`Name` `Package/Profile`,IM.TestCode, lom.Name Investigation,'Profile' TYPE  ");
        sb.Append(" FROM investigation_master  IM ");
        sb.Append(" INNER JOIN  `labobservation_investigation` loi ON IM.`Investigation_Id`=loi.`Investigation_Id` ");
        sb.Append(" INNER JOIN `labobservation_master` lom ON lom.`LabObservation_ID`=loi.`labObservation_ID` ");
        sb.Append(" WHERE IM.invType='Profile'  ");
        sb.Append("  AND IM.Investigation_Id IN (" + ProId.TrimEnd(',') + ") ");
        sb.Append(" ORDER BY IM.`Name` )B ORDER BY TYPE,`Package/Profile` ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
       // return Util.getJson(dt);
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Package_Inclusion_Report";
            return "1";
        }
        else
        {
            return "0";
        }

       // return Util.getJson(new { Query = sb.ToString(), ReportName = "Package Inclusion Report", Period = "" });

    }
    [WebMethod]
    public static string bindPackage()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT * FROM (SELECT plm.NAME,CONCAT(plm.PlabID,'#','Package') PlabID ,'Package' TYPE ");
        sb.Append("   FROM f_itemmaster im  ");
        sb.Append("  INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` AND scm.`CategoryID`='LSHHI44' AND im.`IsActive`=1  ");
        sb.Append("  INNER JOIN packagelab_master plm ON plm.`PlabID`=im.`Type_ID`  ");
        sb.Append("  LEFT JOIN employee_master em ON em.`Employee_ID`=plm.`CreaterID` ");
        sb.Append("  LEFT JOIN f_ratelist r ON r.`ItemID`=im.`ItemID` AND r.`Panel_ID`=78  ");
        sb.Append("  ORDER BY plm.Name)t ");
        sb.Append("  UNION  ");
        sb.Append("  SELECT NAME,CONCAT(Investigation_Id,'#','Profile') PlabID,'Test' TYPE FROM investigation_master WHERE invType='Profile'    ");
        sb.Append("  ORDER BY TYPE  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Util.getJson(dt);
    }
}