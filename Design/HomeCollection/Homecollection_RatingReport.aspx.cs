
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

public partial class Design_HomeCollection_Homecollection_RatingReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoad_Data.bindState(ddlstate);
            ddlstate.Items.Insert(0, new ListItem("Select", "0"));



            if (UserInfo.RoleID != 212)
            {

                ddlcentre.Items.Insert(0, new ListItem(UserInfo.CentreName.ToString(), UserInfo.Centre.ToString()));
                more.Attributes.Add("style", "display:none");

                ddlphelbo.DataSource = StockReports.GetDataTable(@"SELECT hcp.`name`,hcp.PhlebotomistID FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hcp   INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_area_phlebotomist_mapping` hcr ON hcr. phlebotomistid =hcp.phlebotomistid INNER JOIN `f_locality` fl ON fl.ID=hcr.localityid AND fl.cityid IN (SELECT cmm.id FROM centre_master cm INNER JOIN city_master cmm ON cm.cityid=cmm.id and cm.centreid=" + UserInfo.Centre + ") group by hcp.PhlebotomistID");
                ddlphelbo.DataValueField = "PhlebotomistID";
                ddlphelbo.DataTextField = "name";
                ddlphelbo.DataBind();
                ddlphelbo.Items.Insert(0, new ListItem("Select Phelbo", "0"));

            }
        }


    }

    [WebMethod(EnableSession = true)]
    public static string bindcentre(string areaid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT droplocationid,centre FROM " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping hc INNER JOIN centre_master cm ON cm.centreid=hc.droplocationid WHERE hc.localityid=@areaid",
               new MySqlParameter("@areaid", areaid)).Tables[0]);

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
    public static string bindphelbo(string areaid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT hc.PhlebotomistID,`name` FROM " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping hc INNER JOIN " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster cm ON cm.PhlebotomistID=hc.PhlebotomistID WHERE hc.localityid=@areaid",
                new MySqlParameter("@areaid", areaid)).Tables[0]);
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
    public static string getdata(string fromdate, string todate, string stateId, string cityid, string areaid, string PatientRating, string centre, string phelbo, string mobileno, string pname, string status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT DATE_FORMAT(hc.appdatetime,'%d-%b-%Y %h:%i %p')appdate,hc.`MobileNo`,hc.`PatientName`,  ");
            sb.Append("  hc.`State`,hc.`City`,hc.`locality`,hc.`Pincode`,cm.`Centre`,phl.Mobile PMobile,phl.`Name` phleboname,ifnull(hc.`PatientRating`,'0')PatientRating,ifnull(hc.`PhelboRating`,'0')PhelboRating,ifnull(hc.`PatientFeedback`,'')PatientFeedback,ifnull(hc.`PhelboFeedback`,'')PhelboFeedback  ");
            sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc    ");
            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=hc.centreid  ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` phl ON phl.PhlebotomistID=hc.PhlebotomistID  ");

            sb.Append(" WHERE ");
            sb.Append(" hc.appdatetime>=@fromDate ");
            sb.Append(" and  hc.appdatetime<=@toDate ");

            sb.Append(" and hc.CurrentStatus in ('Completed','BookingCompleted') ");

            if (PatientRating != "0")
            {
                sb.Append(" and hc.`PatientRating`=@PatientRating ");
            }
            if (centre != "0" && centre != "null" && centre != string.Empty)
            {
                sb.Append(" and hc.centreid=@centreid ");
            }
            if (phelbo != "0" && phelbo != "null" && phelbo != string.Empty)
            {
                sb.Append(" and phl.PhlebotomistID=@PhlebotomistID ");
            }


            if (pname != string.Empty)
            {
                sb.Append(" and hc.`PatientName` like @pname ");
            }
            if (mobileno != string.Empty)
            {
                sb.Append(" and hc.`MobileNo`=@mobileno ");
            }



            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@PhlebotomistID", phelbo),
               new MySqlParameter("@mobileno", mobileno),
               new MySqlParameter("@PatientRating", PatientRating),
               new MySqlParameter("@centreid", centre),
               new MySqlParameter("@pname", string.Format("%{0}%", pname)),
               new MySqlParameter("@fromDate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00"),
                new MySqlParameter("@toDate", Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0]);
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
    public static string BindItemDetail(string prebookingid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT itemid,itemname,IF(subcategoryid=15,'Package','Test')itemtype,rate,discamt,netamt ,paymentmode ");
            sb.Append(" FROM patient_labinvestigation_opd_prebooking where prebookingid=@PhlebotomistID and iscancel=0  order by itemname");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@PhlebotomistID", prebookingid)).Tables[0]);
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
    public static string exporttoexcel(string fromdate, string todate, string stateId, string cityid, string areaid, string PatientRating, string centre, string phelbo, string mobileno, string pname)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT DATE_FORMAT(hc.appdatetime,'%d-%b-%Y %h:%i %p')appdate,hc.`MobileNo`,hc.`PatientName`,  ");
            sb.Append("  hc.`State`,hc.`City`,hc.`locality`,hc.`Pincode`,cm.`Centre`,phl.Mobile PMobile,phl.`Name` phleboname,ifnull(hc.`PhelboRating`,'0')PhelboRating,ifnull(hc.`PhelboFeedback`,'')PhelboFeedback,ifnull(hc.`PatientRating`,'0')PatientRating,ifnull(hc.`PatientFeedback`,'')PatientFeedback  ");
            sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc    ");
            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=hc.centreid  ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` phl ON phl.PhlebotomistID=hc.PhlebotomistID  ");

            sb.Append(" WHERE ");
            sb.Append(" hc.appdatetime>=@fromDate ");
            sb.Append(" and  hc.appdatetime<=@toDate ");

            sb.Append(" and hc.CurrentStatus in ('Completed','BookingCompleted') ");
            if (PatientRating != "0")
            {
                sb.Append(" and hc.`PatientRating`=@PatientRating ");
            }

            if (centre != "0" && centre != "null" && centre != string.Empty)
            {
                sb.Append(" and hc.centreid=@centreid ");
            }
            if (phelbo != "0" && phelbo != "null" && phelbo != string.Empty)
            {
                sb.Append(" and phl.PhlebotomistID=@PhlebotomistID ");
            }


            if (pname != string.Empty)
            {
                sb.Append(" and hc.`PatientName` like @pname ");
            }
            if (mobileno != string.Empty)
            {
                sb.Append(" and hc.`MobileNo`=@mobileno ");
            }

            DataTable dt =MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@PhlebotomistID", phelbo),
              new MySqlParameter("@mobileno", mobileno),
              new MySqlParameter("@PatientRating", PatientRating),
              new MySqlParameter("@centreid", centre),
              new MySqlParameter("@pname", string.Format("%{0}%", pname)),
              new MySqlParameter("@fromDate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00"),
              new MySqlParameter("@toDate", Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0];

            
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
                HttpContext.Current.Session["ReportName"] = "HomeCollectionRatingReport";
                return "true";
            }
            else
            {
                return "false";
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