using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_HomeCollectionMissed : System.Web.UI.Page
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

    [WebMethod]
    public static string getdata(string fromdate, string todate, string stateId, string cityid, string areaid, string pincode)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT hm.id,CONCAT(pm.`Title`,pm.`PName`)Pname,hm.`MobileNo`,fl.`NAME` AreaName,cm.`City`,sm.`state`,hm.`Pincode`,hm.`Address`, ");
            sb.Append(" hm.`EntryByName` ,DATE_FORMAT(hm.`EntryDate`,'%d-%b-%Y %h:%i %p')EntryDate,hm.`Reason` ");
            sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".hc_homecollection_missed hm  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=hm.`Patient_ID` ");
            sb.Append(" INNER JOIN `f_locality` fl ON fl.id=hm.`localityid` ");
            if (areaid != "0" && areaid != null && areaid != string.Empty)
            {
                sb.Append(" and fl.id =@areaid");
            }
            sb.Append(" INNER JOIN city_master cm ON cm.`ID`=hm.`Cityid` ");
            if (cityid != "0" && cityid != null && cityid != string.Empty)
            {
                sb.Append(" and cm.id =@cityid");
            }
            sb.Append(" INNER JOIN state_master sm ON sm.`id`=hm.`Stateid`  ");
            if (stateId != "0")
            {
                sb.Append(" and sm.id =@stateId");
            }
            if (pincode != string.Empty)
            {
                sb.Append(" and hm.pincode=@pincode");
            }
            sb.Append(" WHERE hm.EntryDate>=@fromdate and hm.EntryDate<=@todate order by hm.id ");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con,CommandType.Text,sb.ToString(),
                                                           new MySqlParameter("@pincode",pincode),
                                                           new MySqlParameter("@stateId",stateId),
                                                           new MySqlParameter("@cityid",cityid),
                                                           new MySqlParameter("@areaid",areaid),
                                                           new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                                           new MySqlParameter("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"))
               ).Tables[0]);
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
    public static string getdataexcel(string fromdate, string todate, string stateId, string cityid, string areaid, string pincode)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT hm.id,CONCAT(pm.`Title`,pm.`PName`)Pname,hm.`MobileNo`,fl.`NAME` AreaName,cm.`City`,sm.`state`,hm.`Pincode`,hm.`Address`, ");
            sb.Append(" hm.`EntryByName` ,DATE_FORMAT(hm.`EntryDate`,'%d-%b-%Y %h:%i %p')EntryDate,hm.`Reason` ");
            sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".hc_homecollection_missed hm  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=hm.`Patient_ID` ");
            sb.Append(" INNER JOIN `f_locality` fl ON fl.id=hm.`localityid` ");
            if (areaid != "0" && areaid != null && areaid != string.Empty)
            {
                sb.Append(" and fl.id =@areaid");
            }
            sb.Append(" INNER JOIN city_master cm ON cm.`ID`=hm.`Cityid` ");
            if (cityid != "0" && cityid != null && cityid != string.Empty)
            {
                sb.Append(" and cm.id =@cityid");
            }
            sb.Append(" INNER JOIN state_master sm ON sm.`id`=hm.`Stateid`  ");
            if (stateId != "0")
            {
                sb.Append(" and sm.id =@stateId");
            }
            if (pincode != string.Empty)
            {
                sb.Append(" and hm.pincode=@pincode");
            }

            sb.Append(" WHERE hm.EntryDate>=@fromdate and hm.EntryDate<=@todate order by hm.id ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                         new MySqlParameter("@pincode", pincode),
                                         new MySqlParameter("@stateId", stateId),
                                         new MySqlParameter("@cityid", cityid),
                                         new MySqlParameter("@areaid", areaid),
                                         new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                         new MySqlParameter("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"))
                 ).Tables[0])
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
                if (dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "MissedHomeCollectionReport";
                    return "true";
                }
                else
                {
                    return "false";
                }
            }
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