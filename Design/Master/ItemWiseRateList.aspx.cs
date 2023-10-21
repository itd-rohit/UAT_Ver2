using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_EDP_ItemWiseRateList : System.Web.UI.Page
{
    public string ItemName = string.Empty;
    public string regid = string.Empty;

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchItemWithCode(string TestCode)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT itm.ItemID,itm.TypeName,itm.testcode,itm.SubCategoryID,sm.Name FROM f_itemmaster itm ");
            sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.SubCategoryID=itm.SubCategoryID ");
            sb.Append(" AND itm.testcode=@Testcode ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@Testcode", TestCode.Trim())).Tables[0];
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            if (Util.GetString(Request.QueryString["InvID"]) != string.Empty)
            {
                regid = Util.GetString(Request.QueryString["InvID"]);
                ddlDepartment.Enabled = false;
                ddlDepartment0.Enabled = false;
                dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ItemID,CONCAT(TestCode,' ~ ',TypeName)TypeName  FROM f_itemmaster WHERE type_id=@InvID AND IsActive=1 ORDER BY TypeName",
                    new MySqlParameter("@InvID", Util.GetString(Request.QueryString["InvID"]))).Tables[0];
                ddlItem.DataSource = dt;
                ddlItem.DataValueField = "ItemID";
                ddlItem.DataTextField = "TypeName";
                ddlItem.DataBind();
            }

            if (!IsPostBack)
            {
                ItemName = ddlItem.SelectedValue;
                if (Session["LoginName"] == null)
                {
                    Response.Redirect("~/Design/Default.aspx");
                }
            }
            ItemName = ddlItem.SelectedValue;
            bindbillingCategory();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void BindDepartment()
    {
        DataTable dt = StockReports.GetDataTable("Select DISTINCT sc.Displayname FROM f_subcategorymaster sc WHERE  active=1 order by Displayname");
        ddlDepartment0.DataSource = dt;
        ddlDepartment0.DataTextField = "Displayname";
        ddlDepartment0.DataValueField = "Displayname";
        ddlDepartment0.DataBind();
    }

    protected void btnExcelExport_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            //ItemName = ddlItem.SelectedValue.ToString();
            sb.Append(" SELECT pnl.Panel_ID,Company_Name AS PanelName, IFNULL(rt.Rate,0) Rate FROM ");
            sb.Append(" (SELECT RTRIM(LTRIM(Company_Name)) AS Company_Name,Panel_ID,ReferenceCode, ");
            sb.Append(" ReferenceCodeOPD FROM f_panel_master WHERE Panel_ID IN (SELECT  ");
            sb.Append(" DISTINCT(ReferenceCodeOPD) FROM f_panel_master)) pnl ");
            sb.Append(" LEFT JOIN (SELECT * FROM f_ratelist WHERE ItemID =@ItemName)rt ON pnl.panel_ID = rt.Panel_ID; ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@ItemName", ItemName)).Tables[0];
            Session["ReportName"] = ddlItem.SelectedValue + "Panel Rate";
            Session["Period"] = "";
            Session["dtExport2Excel"] = dt;

            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string setexcelreport(string itemid, string itemname)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT pnl.Panel_ID,Company_Name AS PanelName, IFNULL(rt.Rate,0) Rate,ifnull(mrp_rate,0)MrpRate FROM ");
            sb.Append(" (SELECT RTRIM(LTRIM(Company_Name)) AS Company_Name,Panel_ID,ReferenceCode, ");
            sb.Append(" ReferenceCodeOPD FROM f_panel_master WHERE Panel_ID IN (SELECT  ");
            sb.Append(" DISTINCT(ReferenceCodeOPD) FROM f_panel_master)) pnl ");
            sb.Append(" LEFT JOIN (SELECT * FROM f_ratelist WHERE ItemID =@itemid)rt ON pnl.panel_ID = rt.Panel_ID; ");

            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@itemid", itemid)).Tables[0];
            HttpContext.Current.Session["ReportName"] = itemname + " Panel Rate";
            HttpContext.Current.Session["Period"] = "";
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void bindbillingCategory()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,Name FROM billingCategory_master where IsActive=1 ORDER BY Name ");
        ddlbillcategory.DataSource = dt;
        ddlbillcategory.DataTextField = "Name";
        ddlbillcategory.DataValueField = "ID";
        ddlbillcategory.DataBind();
        ddlbillcategory.Items.Insert(0, new ListItem("Select", "0"));
    }
}