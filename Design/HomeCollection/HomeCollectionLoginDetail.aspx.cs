using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_HomeCollectionLoginDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoad_Data.bindState(ddlstate);
            ddlstate.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    [WebMethod(EnableSession = true)]
    public static string getdata(string fromdate, string todate, string stateId, string cityid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT sm.`state`,cm.`City`, pl.Phlebotomistid,hp.name,hp.`Mobile`,pl.`SelfieImage`,pl.`BikeImage`,pl.`BagImage`,pl.TempImage,pl.TempValue, ");
            sb.Append("  DATE_FORMAT(pl.`EntryDate`,'%d-%b-%Y %h:%i %p') LoginDate ,DATE_FORMAT(pl.`EntryDate`,'%Y%m%d') foldername ");
            sb.Append("  FROM " + Util.getApp("HomeCollectionDB") + ".hc_phelbotomistloginupdate pl ");
            sb.Append("  INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp ON hp.PhlebotomistID=pl.Phlebotomistid ");
            sb.Append("  INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phleboworklocation` hw ON hw.`PhlebotomistID`=pl.Phlebotomistid ");
            sb.Append("  INNER JOIN state_master sm ON sm.`id`=hw.`StateId` ");
            if (stateId != "0")
            {
                sb.Append(" and sm.id=@stateId");
            }
            sb.Append("  INNER JOIN city_master cm ON cm.`ID`=hw.`CityId` ");
            if (cityid != "0" && cityid != "null" && cityid != string.Empty)
            {
                sb.Append(" and cm.id=@cityid");
            }


            sb.Append(" WHERE ");
            sb.Append(" pl.`EntryDate`>=@fromdate ");
            sb.Append(" and pl.`EntryDate`<=@todate ");
            sb.Append(" order by sm.`id`,cm.`ID` ");
			//System.IO.File.WriteAllText(@"D:\Live_MediBird\Live_Code\Medibird\ErrorLog\poi.txt",sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                             new MySqlParameter("@stateId", stateId),
                                             new MySqlParameter("@cityid", cityid),
                                             new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                             new MySqlParameter("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])

                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();

			con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindDetail(string fromdate, string todate, string phelbo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
			            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT DATE_FORMAT(LoginDateTime,'%d-%b-%Y %h:%i %p') endate,`BatteryPercentage`,STATUS,");

            sb.Append(" IFNULL(`PreBookingID`,'')PreBookingID");
            sb.Append("  FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomist_logindetail` WHERE PhlebotomistID=@PhlebotomistID AND STATUS<>'LocationTracker' ");
            sb.Append(" and LoginDateTime>=@fromdate and LoginDateTime<=@todate ");
            sb.Append("  ORDER BY id ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@PhlebotomistID", phelbo),
                                              new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                              new MySqlParameter("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }




    [WebMethod]
    public static string GetUrl(string phelboid, string foldername, string imgname)
    {
        return "http://59.99.112.130/ClientImages/HomeCollection%20LoginUpdate/" + phelboid  +"/" +foldername +"/" +imgname;
    }

}