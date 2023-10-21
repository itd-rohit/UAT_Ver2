using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_StorePageAccessControl : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
        }
    }


    [WebMethod]
    public static string savedata(List<st_pageaccess> datatosave)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string location =string.Join(",", datatosave.Select(x => x.LocationID).Distinct().ToArray());
            int year = datatosave[0].EntryYear;

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_pageaccess set IsActive=0,UpdateDate=now(),UpdateByID=" + UserInfo.ID + ",UpdateByName='"+UserInfo.LoginName+"' where EntryYear=" + year + " and LocationID in (" + location + ")");

            foreach (st_pageaccess st in datatosave)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into st_pageaccess(LocationID,EntryYear,EntryMonth,EntryMonthName,FromDate,ToDate,EntryDatetime,EntryByID,EntryByName) values (" + st.LocationID + "," + st.EntryYear + "," + st.EntryMonth + ",'" + st.EntryMonthName + "','" + Util.GetDateTime(st.FromDate).ToString("yyyy-MM-dd") + "','" + Util.GetDateTime(st.ToDate).ToString("yyyy-MM-dd") + "',now(),"+UserInfo.ID+",'"+UserInfo.LoginName+"')");
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


    [WebMethod]
    public static string getdata(int year, int locationid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT entryyear,entrymonth,DATE_FORMAT(fromdate,'%d-%b-%Y')fromdate,DATE_FORMAT(todate,'%d-%b-%Y')todate ,entrymonthname");
        sb.Append(" FROM st_pageaccess WHERE entryyear=" + year + " AND locationid=" + locationid + " AND isactive=1 ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public static string getdataexcel(string locationid, string year)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sl.`LocationID`,sl.`Location`, entryyear `Year`,entrymonth `Month`,entrymonthname `MonthName` ");
        sb.Append(",DATE_FORMAT(fromdate,'%d-%b-%Y')FromDate,DATE_FORMAT(todate,'%d-%b-%Y')ToDate, ");
        sb.Append("sp.`EntryByName`,DATE_FORMAT(sp.`EntryDatetime`,'%d-%b-%Y') EntryDateTime ");
        sb.Append(" FROM st_pageaccess sp ");
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.locationid=sp.`LocationID` ");
        sb.Append(" WHERE entryyear=" + year + " AND sp.locationid in ("+locationid+") AND sl.isactive=1 AND sp.`IsActive`=1 ");
        sb.Append(" ORDER BY location,YEAR,MONTH ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
        {


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





            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "StorePageAccessControl_of_year_" + year;
            return "1";
        }
        else
        {
            return "No Record Found";
        }

    }
}

public class st_pageaccess
{
    public int LocationID { get; set; }
    public int EntryYear { get; set; }
    public int EntryMonth { get; set; }
    public string EntryMonthName { get; set; }
    public string FromDate { get; set; }
    public string ToDate { get; set; }
  
}