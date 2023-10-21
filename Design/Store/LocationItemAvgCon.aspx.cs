using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_LocationItemAvgCon : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        
            var months = CultureInfo.CurrentCulture.DateTimeFormat.MonthNames;
            for (int i = 0; i < months.Length - 1; i++)
            {
                lstmonth.Items.Add(new ListItem(months[i], (i + 1).ToString()));
            }
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindlocation()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select locationid LocationID,location Location from st_locationmaster where locationid not in (select distinct locationid from st_itemlocationindentmaster)"));
    }
    
    [WebMethod(EnableSession = true)]
    public static string Getdata(string location)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT sl.location,ifnull(slm.month,'')month,ifnull(`BufferPercentage`,'')BufferPercentage,ifnull(`WastagePercentage`,'')WastagePercentage");
        sb.Append("  FROM st_locationmaster sl  left JOIN `st_itemlocationindentmaster` slm ON slm.locationid=sl.locationid ");
        if (location != "")
        {
            sb.Append(" where sl.locationid in (" + location + ") and sl.isactive=1");
        }
        sb.Append(" ORDER BY location,slm.month");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        DataTable mydt = new DataTable();
        mydt.Columns.Add("Location");
     
        for (int i = 1; i <=12; i++)
        {
            mydt.Columns.Add(i.ToString());
          
        }

        mydt.Columns.Add("Wastage");
        if (dt.Rows.Count > 0)
        {

            DataView dv = dt.DefaultView.ToTable(true, "location").DefaultView;
            dv.Sort = "location asc";
            DataTable loc = dv.ToTable();

            foreach (DataRow dwrr in loc.Rows)
            {
                DataRow dwr = mydt.NewRow();
                dwr["Location"] = dwrr["location"].ToString();
                DataRow[] dwme = dt.Select("location='" + dwrr["location"].ToString() + "'");
                foreach (DataRow dwm in dwme)
                {
                    if (dwm["month"].ToString() != "")
                    {
                        dwr[dwm["month"].ToString()] = dwm["BufferPercentage"].ToString();
                    }
                  
                }
               
                dwr["Wastage"] = dt.Select("location='" + dwrr["location"].ToString() + "'")[0]["WastagePercentage"];
                mydt.Rows.Add(dwr);

            }

        }
        

        return Newtonsoft.Json.JsonConvert.SerializeObject(mydt);
    }

    [WebMethod(EnableSession = true)]
    public static string savedata(string locationid, string month, string buffer, string wastage)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string[] location = locationid.Split(',');
            string[] months = month.Split(',');
            foreach (string loc in location)
            {
                foreach (string mon in months)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from st_itemlocationindentmaster  where LocationID='" + loc + "' and Month='" + mon + "' ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into st_itemlocationindentmaster  (LocationID,Month,BufferPercentage,WastagePercentage,EntryDate,EntryByUser) values ('" + loc + "','" + mon + "','" + buffer + "','" + wastage + "',now(),'" + UserInfo.LoginName + "')");
                }
            }
            tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
    
}