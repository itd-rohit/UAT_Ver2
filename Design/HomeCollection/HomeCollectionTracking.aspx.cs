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

public partial class Design_HomeCollection_HomeCollectionTracking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindState(ddlstate);
            ddlstate.Items.Insert(0, new ListItem("Select", "0"));
        }
    }



    [WebMethod(EnableSession = true)]
    public static string track(string stateid, string cityid, string routeid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT hd.`PhlebotomistID` ,CONCAT('Phlebotomist Name:-',hp.`Name`,'\nMobile:- ',hp.mobile,'\nLast Seen Time:- ',DATE_FORMAT(LoginDateTime,'%d-%b-%Y %h:%i %p'),'\nBattery:- ',BatteryPercentage,'%') Title,Latitude,Longitude,hd.Status FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomist_logindetail` hd ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp ON hp.`PhlebotomistID`=hd.`PhlebotomistID` ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phleboworklocation` hm ON hm.PhlebotomistID=hp.PhlebotomistID ");
            if (stateid != "0")
            {
                sb.Append(" AND hm.stateid=@stateid");
            }
            if (cityid != "0")
            {
                sb.Append(" AND hm.cityid=@cityid");
            }

            sb.Append(" WHERE logindatetime>=concat(CURRENT_DATE,' 00:00:00')  ");
            sb.Append(" ORDER BY hp.PhlebotomistID asc,hd.id DESC");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                               new MySqlParameter("@stateid", stateid),
                                               new MySqlParameter("@cityid", cityid)).Tables[0];

            dt = dt.AsEnumerable().GroupBy(r => r.Field<int>("PhlebotomistID")).Select(g => g.First()).CopyToDataTable();
            return JsonConvert.SerializeObject(dt);

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
}