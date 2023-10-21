using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public partial class Design_HomeCollection_HCDelayCheckInScreen : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lb.Text = "";
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                StringBuilder sb = new StringBuilder();

                sb.Append(" SELECT hc.prebookingid, patient_id UHID,PatientName,MobileNO, DATE_FORMAT(appdatetime,'%d-%b-%Y %h:%i %p')AppointmentDate,");
                sb.Append("  TIMESTAMPDIFF(MINUTE, appdatetime,NOW()) DelayedInMinutes, ");
                sb.Append("  pm.`Name` Phlebotomist,pm.`Mobile` PhlebotomistMobile, ");
                sb.Append(" cm.`Centre` DropLocationName ");

                sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc   ");
                sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` pm ON hc.`PhlebotomistID`=pm.PhlebotomistID  ");
                sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".hc_delayincheck_sendedsms  hcm ON hcm.`prebookingid`=hc.`prebookingid`    ");
                sb.Append(" and hcm.employee_id=@employee_id");
                sb.Append(" and hcm.levelid=@levelid ");
                sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=hc.`CentreID`");
                sb.Append(" WHERE currentstatus='Pending'  ");
                sb.Append(" AND appdatetime<NOW() AND Iscancel=0  ");
                sb.Append(" AND AppDateTime>=CONCAT(CURRENT_DATE,' 00:00:00') ");

                grd.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@employee_id", Request.QueryString["empidandlevelid"].Split('^')[0]),
                   new MySqlParameter("@levelid", Request.QueryString["empidandlevelid"].Split('^')[1])).Tables[0];
                grd.DataBind();
                if (grd.Rows.Count == 0)
                {
                    lb.Text = "No Delayed Pending Homecollection Found";
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                if (con.State == ConnectionState.Open)
                {
                    con.Close();
                    con.Dispose();
                }
            }
        }
    }
}