using MySql.Data.MySqlClient;
using System;
using System.Data;

public partial class Design_HomeCollection_HomeCollectionLog : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                grd.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT currentstatus 'Status' ,DATE_FORMAT(currentstatusdate,'%d-%b-%Y %h:%i %p') 'StatusDate',entrybyname DoneBy  FROM " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking_status where PreBookingID=@PreBookingID ORDER BY id ",
                   new MySqlParameter("@PreBookingID", Util.GetString(Request.QueryString["prebookingid"])));
                grd.DataBind();
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
    }
}