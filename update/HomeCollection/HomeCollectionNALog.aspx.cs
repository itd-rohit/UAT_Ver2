using MySql.Data.MySqlClient;
using System;
using System.Data;

public partial class Design_HomeCollection_HomeCollectionNALog : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lb.Text = string.Empty;
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                grd.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, @" SELECT DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate, Reason,Remark,Name,IF(sechduledate='0001-01-01 00:00:00','',DATE_FORMAT(sechduledate,'%d-%b-%Y'))NextDate,if(photofilename='','',concat('https://hc.apollodiagnostics.in/ApolloImages/HomeCollection NotAvailable/',DATE_FORMAT(entrydate,'%Y%m%d'),'/',prebookingid,'/',photofilename))photofilename,if(signaturefilename='','',concat('https://hc.apollodiagnostics.in/ApolloImages/HomeCollection NotAvailable/',DATE_FORMAT(entrydate,'%Y%m%d'),'/',prebookingid,'/',signaturefilename))signaturefilename
 FROM " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionnotavilable`  where PreBookingID=@PreBookingID ORDER BY id ",
       new MySqlParameter("@PreBookingID", Util.GetString(Request.QueryString["prebookingid"]))).Tables[0];
                grd.DataBind();

                if (grd.Rows.Count == 0)
                {
                    lb.Text = "No Data Found";
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lb.Text = "Error";
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
    }
}