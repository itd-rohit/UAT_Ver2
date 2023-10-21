using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web;
using System.Web.Services;
using System.Text;
using System.Data;

public partial class Design_Store_PanelLocationDepartmentMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    [WebMethod(EnableSession = true)]
    public static string BindPanel()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT Panel_ID,Company_Name FROM f_panel_master WHERE Isactive=1 and paneltype='Centre' and centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY Company_Name"));
    }

    [WebMethod(EnableSession = true)]
    public static string Bindlocation(string PanelID)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT LocationID,Location FROM st_locationmaster WHERE Panel_ID='" + PanelID + "' ORDER BY Location"));
    }

    [WebMethod(EnableSession = true)]
    public static string BindDepartment()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT SubcategoryID,Name FROM f_subcategorymaster WHERE active=1 AND categoryid='LSHHI3' ORDER BY NAME"));
    }

    [WebMethod(EnableSession = true)]
    public static string BindData(string PanelID, string LocationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT scm.SubcategoryID,scm.Name,fpm.Company_Name,fpm.Panel_ID,loc.Location,loc.LocationID ");
        sb.Append(" FROM st_locationmaster_subcategoryid sls  ");
        sb.Append(" INNER JOIN f_subcategorymaster scm ON sls.SubCategoryID=scm.SubCategoryID ");
        sb.Append(" INNER JOIN st_locationmaster loc ON loc.LocationID=sls.LocationID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=sls.Panel_ID ");
        sb.Append(" where sls.Panel_ID='" + Util.GetInt(PanelID) + "' ");
        if (LocationID!="0")
        sb.Append(" and sls.LocationID='" + Util.GetInt(LocationID) + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string saveData(List<string> Searchdata)
    {
        try
        {
            if (Searchdata[0] != "0" && Searchdata[1] != "0" && Searchdata[2] != "0")
            {
                int chkdept = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(1) FROM st_locationmaster_subcategoryID WHERE SubCategoryID='" + Util.GetInt(Searchdata[2]) + "' and Panel_ID='" + Util.GetInt(Searchdata[0]) + "'"));
                if (chkdept == 0)
                {
                    StockReports.ExecuteDML("INSERT INTO st_locationmaster_subcategoryID(Panel_ID,LocationID,SubCategoryID,CreatedBy) VALUES('" + Util.GetInt(Searchdata[0]) + "','" + Util.GetInt(Searchdata[1]) + "','" + Util.GetInt(Searchdata[2]) + "','" + UserInfo.ID + "')");
                }
                else
                {
                    return "Department already mapped";
                }
            }
            else
            {
                return "Please select Panel,Location and Department";
            }
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objeror = new ClassLog();
            objeror.errLog(ex);
            return "Contact to itdose";
        }
    }

    [WebMethod(EnableSession = true)]
    public static string Remove(string DeptID, string Panelid)
    {
        try
        {
            StockReports.ExecuteDML("DELETE FROM st_locationmaster_subcategoryid WHERE SubCategoryID='" + DeptID + "' and Panel_ID='" + Panelid + "'");
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objeror = new ClassLog();
            objeror.errLog(ex);
            return "0";
        }
    }

    [WebMethod]
    public static string GetReport()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT fpm.Panel_ID,fpm.Company_Name PName,loc.LocationID,loc.Location, scm.SubcategoryID DeptID,scm.Name DeptName ");
        sb.Append(" FROM st_locationmaster_subcategoryid sls  ");
        sb.Append(" INNER JOIN f_subcategorymaster scm ON sls.SubCategoryID=scm.SubCategoryID ");
        sb.Append(" INNER JOIN st_locationmaster loc ON loc.LocationID=sls.LocationID ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=sls.Panel_ID ");
        sb.Append(" Order By Company_Name,Location,Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "Panel_Location_Department_Mapping";
            return "true";
        }
        else
        {
            return "false";
        }

    }
}
