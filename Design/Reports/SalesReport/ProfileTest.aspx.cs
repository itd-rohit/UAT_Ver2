using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;

public partial class Design_SalesDiagnostic_ProfileTest : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets

    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Util.GetString(Session["RoleID"]) == "")
            {
                Response.Redirect("~/Design/Default.aspx");
            } 

        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchInvestigation(string PackageID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT IFNULL( (SELECT IFNULL(GROUP_CONCAT(IF(li.Child_Flag='1',CONCAT('<b>',lm.Name,'</b>'),lm.Name ) ORDER BY li.printOrder SEPARATOR '#' ),'-NA-')  ");
        sb.Append(" FROM  labobservation_investigation li        ");
        sb.Append(" INNER JOIN labobservation_master lm ON lm.LabObservation_ID=li.labObservation_ID  ");
        sb.Append(" WHERE  li.Investigation_Id=inv.Investigation_Id      ");
        sb.Append(" GROUP BY li.Investigation_Id ) ");
        sb.Append(" ,'') ParameterName, PlabId,PrintSeprate,CONCAT(inv.`Name`,'-',IFNULL(ios.SampleTypeName,''))Investigation,inv.`Investigation_Id`,'' SampleDefinedPackage,inv.TestCode,rl.Rate FROM `package_labdetail` pld ");
        sb.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=pld.`InvestigationID` ");
        sb.Append(" INNER JOIN `f_itemmaster` im ON inv.`Investigation_Id`=im.`Type_ID`  ");
        sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` AND scm.`CategoryID`='LSHHI3' AND im.`IsActive`=1 ");
        sb.Append(" INNER JOIN `f_ratelist` rl ON rl.ItemID=im.`ItemID` AND rl.panel_id=78 ");
        sb.Append(" LEFT JOIN `investigations_sampletype` ios ON ios.`Investigation_ID`=inv.`Investigation_Id` ");
        sb.Append(" WHERE pld.`PlabID`='" + PackageID + "' ORDER BY Priority+1;  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return makejsonoftable(dt, makejson.e_without_square_brackets);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchObservation(string InvID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT lm.Name Parameter,lm.`LabObservation_ID`,inv.`Investigation_Id` ");
        sb.Append("  FROM  labobservation_investigation li     ");
        sb.Append("  INNER JOIN labobservation_master lm ON lm.LabObservation_ID=li.labObservation_ID ");
        sb.Append("  INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=li.`Investigation_Id` ");
        sb.Append("   WHERE inv.`Investigation_Id`='" + InvID + "'   GROUP BY lm.Name order by lm.Name  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return makejsonoftable(dt, makejson.e_without_square_brackets);
    }
    [WebMethod]
    public static string GetInvestigationList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT inv.`Investigation_Id`,CONCAT(typeName,' ',IF(ios.`SampleTypeName`='NA','',CONCAT('(',IFNULL(ios.`SampleTypeName`,''),')'))) NAME,inv.TestCode,rl.Rate FROM f_itemmaster im ");
        sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` AND scm.`CategoryID`='LSHHI3' AND im.`IsActive`=1 ");
        sb.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=im.`Type_ID`  ");
        sb.Append(" INNER JOIN `f_ratelist` rl ON rl.ItemID=im.`ItemID` AND rl.panel_id=78 ");
        sb.Append(" LEFT JOIN `investigations_sampletype` ios ON ios.`Investigation_ID`=im.Type_ID");
        sb.Append(" ORDER BY TRIM(inv.`Name`) ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return makejsonoftable(dt, makejson.e_without_square_brackets);
    }
    [WebMethod]
    public static string GetPackageList()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT im.Bill_Category, plm.NAME,plm.ShowInReport,IFNULL(r.Rate,0) BaseRate,im.ItemID,plm.PlabID,im.TestCode,IFNULL(r.rate,'0') Rate,im.IsActive,0 FromAge,70000 ToAge,'Both' Gender, ");
        sb.Append(" IFNULL(em.Name,'') CreatedBy,DATE_FORMAT(plm.`Creater_date`,'%d-%b-%Y %I:%i %p') CreatedOn,im.`Inv_ShortName` ");
        sb.Append(" FROM f_itemmaster im ");
        sb.Append(" INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` AND scm.`CategoryID`='LSHHI44' AND im.`IsActive`=1 ");
        sb.Append(" INNER JOIN packagelab_master plm ON plm.`PlabID`=im.`Type_ID` ");
        sb.Append(" LEFT JOIN employee_master em ON em.`Employee_ID`=plm.`CreaterID`");
        sb.Append(" LEFT JOIN f_ratelist r ON r.`ItemID`=im.`ItemID` AND r.`Panel_ID`=78 ");
        sb.Append(" ORDER BY priority+1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return makejsonoftable(dt, makejson.e_without_square_brackets);
    }
    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue));
            }
            sb.Append(sb2.ToString());
            sb.Append("}");
        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    } 
}