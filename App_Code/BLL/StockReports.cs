using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Web;
using System;
using System.Web.UI.WebControls;
/// <summary>
/// Helper Class for Stock Related Data
/// </summary>
public class StockReports
{

    #region GetDataTable

    public static DataTable GetDataTable(string strQuery)
    {
        if (strQuery.Contains("delete") && strQuery.Contains("rand"))
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.GeneralLog(string.Format("{0} : {1}", getip(), strQuery));
            return null;
        }

        MySqlConnection conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
            conn.Open();
        DataTable dt = new DataTable();

        dt = MySqlHelper.ExecuteDataset(conn, CommandType.Text, strQuery).Tables[0];
        using (dt as IDisposable)
        {
            if (conn.State == ConnectionState.Open)
                conn.Close();
            if (conn != null)
            {
                conn.Dispose();
                conn = null;
            }
            return dt;
        }

    }

    #endregion GetDataTable

    #region ExecuteDML

    public static bool ExecuteDML(string strQuery)
    {
        if (strQuery.Contains("delete") && strQuery.Contains("rand"))
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.GeneralLog(string.Format("{0} : {1}", getip(), strQuery));
            return false;
        }
        MySqlConnection conn = Util.GetMySqlCon();
        MySqlTransaction tnx;
        if (conn.State == ConnectionState.Closed)
        {
            conn.Open();
        }
        tnx = conn.BeginTransaction();

        int result = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strQuery);

        if (result > 0)
        {
            tnx.Commit();
            tnx.Dispose();

            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
                conn.Dispose();
            }
            return true;
        }
        else
        {
            tnx.Rollback();
            tnx.Dispose();

            if (conn.State == ConnectionState.Open)
            {
                conn.Close();
                conn.Dispose();
            }
            return false;
        }
    }

    #endregion ExecuteDML

    #region ExecuteScalar

    public static string ExecuteScalar(string strQuery)
    {
        if (strQuery.Contains("delete") && strQuery.Contains("rand"))
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.GeneralLog(string.Format("{0} : {1}", getip(), strQuery));
            return null;
        }

        MySqlConnection conn = Util.GetMySqlCon();
        if (conn.State == ConnectionState.Closed)
            conn.Open();

        string Result = Util.GetStringWithoutReplace(MySqlHelper.ExecuteScalar(conn, CommandType.Text, strQuery));
        if (conn.State == ConnectionState.Open)
            conn.Close();
        if (conn != null)
        {
            conn.Dispose();
            conn = null;
        }
        return Result;
    }

    #endregion ExecuteScalar
    public static string GetListSelection(ListBox cbl)
    {
        string str = string.Empty;
        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }
        return str;
    }
    public static string getip()
    {
        try
        {
            string myIP = "";
            if (HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
            {
                myIP = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];
            }
            else if (HttpContext.Current.Request.UserHostAddress.Length != 0)
            {
               myIP = HttpContext.Current.Request.UserHostAddress;

            }
            return myIP;
        }
        catch
        {
            return string.Empty;
        }
    }
public static string GetIPAddress()
{

System.Web.HttpContext context = System.Web.HttpContext.Current;
string sIPAddress = context.Request.ServerVariables["HTTP_X_FORWARDED_FOR"];

if (string.IsNullOrEmpty(sIPAddress))
{
return context.Request.ServerVariables["REMOTE_ADDR"];
}
else
{
string[] ipArray = sIPAddress.Split(new Char[] { ',' });
return ipArray[0];
}

}
    public static void GenerateMenuData(string strLoginType)
    {


        StringBuilder sbMenu = new StringBuilder();
        sbMenu.Append("select distinct(mm.ID),mm.MenuName,mm.image,mm.Description from f_filemaster fm inner join f_file_role fr on fm.ID = fr.UrlID");
        sbMenu.Append(" inner join f_rolemaster rm on fr.RoleID = rm.ID AND rm.Active=1 inner join f_menumaster mm on fm.MenuID = mm.ID");
        sbMenu.Append(" LEFT JOIN f_role_menu_Sno rsm ON rsm.MenuID=fm.MenuID AND rsm.RoleID=rm.ID ");
        sbMenu.AppendFormat(" where fm.Active = 1 and fr.Active = 1 and mm.Active = 1 and rm.RoleName = '{0}' order by rsm.SNo,mm.MenuName ", strLoginType);

        DataSet ds = new DataSet();
        using (ds as IDisposable)
        {
            DataTable dtMenu = new DataTable();
            using (dtMenu as IDisposable)
            {
                dtMenu = GetDataTable(sbMenu.ToString());
                if (dtMenu.Rows.Count > 0)
                {
                    StringBuilder sbItems = new StringBuilder();
                    sbItems.Append("select URLName,DispName,MenuID from f_filemaster fm inner join f_file_role fr on fm.ID = fr.UrlID");
                    sbItems.AppendFormat(" inner join f_rolemaster rm on fr.RoleID = rm.ID AND rm.Active=1 where fm.Active = 1 and fr.Active = 1 and rm.RoleName = '{0}' order by SNo", strLoginType);

                    DataTable dtItems = new DataTable();
                    using (dtItems as IDisposable)
                    {
                        dtItems = GetDataTable(sbItems.ToString());

                        ds.Tables.Add(dtMenu.Copy());
                        ds.Tables[0].TableName = "Menu";

                        ds.Tables.Add(dtItems.Copy());
                        ds.Tables[1].TableName = "Items";

                        DataRelation mi = new DataRelation("Menu_Items", ds.Tables[0].Columns["ID"], ds.Tables[1].Columns["MenuID"]) { Nested = true };
                        ds.Relations.Add(mi);
                    }
                }
                try
                {
                    ds.WriteXml(HttpContext.Current.Server.MapPath(string.Format(@"~/Design/MenuData/{0}.xml", strLoginType)));
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
            }
        }
    }

    public static string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;
        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += ",'" + li.Value + "'";
                else
                    str = "'" + li.Value + "'";
            }
        }
        return str;
    }
private static String[] units = { "Zero", "One", "Two", "Three",  
    "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven",  
    "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen",  
    "Seventeen", "Eighteen", "Nineteen" };
    private static String[] tens = { "", "", "Twenty", "Thirty", "Forty",  
    "Fifty", "Sixty", "Seventy", "Eighty", "Ninety" };

    public static String ConvertAmountinword(double amount)
    {
        try
        {
            Int64 amount_int = (Int64)amount;
            Int64 amount_dec = (Int64)Math.Round((amount - (double)(amount_int)) * 100);
            if (amount_dec == 0)
            {
                return Convert(amount_int) + " Only.";
            }
            else
            {
                return Convert(amount_int) + " Point " + Convert(amount_dec) + " Only.";
            }
        }
        catch (Exception e)
        {
            // TODO: handle exception  
        }
        return "";
    }

    public static String Convert(Int64 i)
    {
        if (i < 20)
        {
            return units[i];
        }
        if (i < 100)
        {
            return tens[i / 10] + ((i % 10 > 0) ? " " + Convert(i % 10) : "");
        }
        if (i < 1000)
        {
            return units[i / 100] + " Hundred"
                    + ((i % 100 > 0) ? " And " + Convert(i % 100) : "");
        }
        if (i < 100000)
        {
            return Convert(i / 1000) + " Thousand "
            + ((i % 1000 > 0) ? " " + Convert(i % 1000) : "");
        }
        if (i < 10000000)
        {
            return Convert(i / 100000) + " Lakh "
                    + ((i % 100000 > 0) ? " " + Convert(i % 100000) : "");
        }
        if (i < 1000000000)
        {
            return Convert(i / 10000000) + " Crore "
                    + ((i % 10000000 > 0) ? " " + Convert(i % 10000000) : "");
        }
        return Convert(i / 1000000000) + " Arab "
                + ((i % 1000000000 > 0) ? " " + Convert(i % 1000000000) : "");
    }
}