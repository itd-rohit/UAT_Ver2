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
using MySql.Data.MySqlClient;
using System.Text;
using System.Web.Services;
using System.Web.Script.Services;
using Newtonsoft.Json;

public partial class Design_DocAccount_CentreShareMaster : System.Web.UI.Page
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
            bindDepartment();
            bindBusinessUnit();
        }

    }
    private void bindDepartment()
    {

        string str = " SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3' ORDER BY NAME ";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataTextField = "NAME";
            ddlDepartment.DataValueField = "SubCategoryID";
            ddlDepartment.DataBind();
        }
        ddlDepartment.Items.Insert(0, new ListItem("", ""));
        ddlDepartment.Items.Insert(1, new ListItem("ALL", "ALL"));
    }

    private void bindBusinessUnit()
    {

        string sql = " SELECT CentreId,Concat(Centre,' [',CentreID,']') Centre FROM centre_master WHERE isactive=1 order by Centre   ";
        DataTable dt = StockReports.GetDataTable(sql);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlbusinessunit.DataSource = dt;
            ddlbusinessunit.DataTextField = "Centre";
            ddlbusinessunit.DataValueField = "CentreId";
            ddlbusinessunit.DataBind();
        }
        ddlbusinessunit.Items.Insert(0, new ListItem("", ""));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetItems(string Department, string BusinessUnit, string TestType)
    {
        StringBuilder sb = new StringBuilder();
        //  if (TestType == "All" || TestType == "OutSource")
        // {
        sb.Append(" SELECT (SELECT cm.Centre FROM centre_master cm WHERE cm.CentreID='" + BusinessUnit + "')BusinessUnit,");
        sb.Append(" im.ItemID,im.TypeName ItemName,im.SubCategoryID,");
        sb.Append("  scm.NAME  Department,");
        sb.Append("   IFNULL(psi.PerShare, '0') PerShare,IFNULL(psi.AmountShare, '0') AmountShare,");
        sb.Append(" '" + Department + "' DepartmentID   ");
        sb.Append(" FROM f_itemmaster im LEFT JOIN centre_master_sharing psi  ON im.ItemID=psi.ItemID AND psi.CentreID='" + BusinessUnit + "'");
        sb.Append("  INNER JOIN f_subcategorymaster scm ON scm.`SubCategoryID`=im.`SubCategoryID` ");
        if (TestType == "OutHouse")
        {
            sb.Append(" INNER JOIN test_centre_mapping tcm ON tcm.`Investigation_ID`=im.`Type_ID` AND tcm.`Booking_Centre`='" + BusinessUnit + "' ");
            sb.Append(" AND tcm.`Test_Centre`<> '" + BusinessUnit + "' AND im.`IsTrigger`=0 ");
        }
        if (TestType == "InHouse")
        {
            sb.Append(" left JOIN test_centre_mapping tcm ON tcm.`Investigation_ID`=im.`Type_ID` AND tcm.`Booking_Centre`='" + BusinessUnit + "' ");
            sb.Append(" AND tcm.`Test_Centre`<> '" + BusinessUnit + "' AND im.`IsTrigger`=0 ");
        }
        sb.Append(" where im.SubcategoryID='" + Department + "' AND scm.`CategoryID`='LSHHI3' ");
        if (TestType == "OutSource")
        {
            sb.Append(" and im.istrigger=1 ");
        }
        if (TestType == "InHouse")
        {
            sb.Append(" and tcm.`Investigation_ID` is null AND im.`IsTrigger`=0 ");
        }

        sb.Append("    ORDER BY im.TypeName");
        if (Util.GetString(HttpContext.Current.Session["ID"]) == "EMP001")
        {
           // System.IO.File.WriteAllText("C:\\CentreShareMaster.txt", sb.ToString());
        }
        DataTable dtItem = StockReports.GetDataTable(sb.ToString());
        return JsonConvert.SerializeObject(dtItem);
       // return Util.getJson(dtItem);
        //string retrn = makejsonoftable(dtItem, makejson.e_without_square_brackets);
        //return retrn;
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveAll(string Department, string BusinessUnit, string Shareper, string ShareAmt)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string qstr = "DELETE FROM centre_master_sharing WHERE CentreId='" + BusinessUnit + "'";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, qstr);
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO centre_master_sharing(CentreID,ItemID,PerShare,AmountShare,UserID,dtEntry)");
            sb.Append(" select '" + BusinessUnit + "',ItemID,'" + Shareper + "','" + ShareAmt + "',  ");
            sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "',now()  from f_itemmaster");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            throw (ex);
        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Save(string count, string str, string Department, string BusinessUnit)
    {
        string ItemID = "", SharePer = "", temp = "", ShareAmt = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            for (int i = 0; i < Util.GetInt(count); i++) //str- ItemID + '#' + DefaultDocShare + '#' + DefaultDocShareAmt +  '$'
            {
                temp = str.Split('$')[i].ToString();
                ItemID = temp.Split('#')[0].ToString();
                SharePer = temp.Split('#')[1].ToString();
                ShareAmt = temp.Split('#')[2].ToString();
                string qstr = "DELETE FROM centre_master_sharing WHERE CentreId='" + BusinessUnit + "' and ItemID='" + ItemID + "' ";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, qstr);
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO centre_master_sharing(CentreID,ItemID,PerShare,AmountShare,UserID,dtEntry,UpdatedByID,Updatedate)");
                sb.Append(" values( '" + BusinessUnit + "','" + ItemID + "','" + SharePer + "','" + ShareAmt + "',  ");
                sb.Append(" '" + HttpContext.Current.Session["ID"].ToString() + "',now(),'" + HttpContext.Current.Session["ID"].ToString() + "',now())");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString());

            }
            Tranx.Commit();
            Tranx.Dispose();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            con.Close();
            con.Dispose();
            throw (ex);
        }
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