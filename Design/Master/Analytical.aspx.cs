using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.Services;

public partial class Design_Master_Analytical : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblCentreID.Text = Common.Decrypt(Request.QueryString["centreID"]);
        if (!IsPostBack)
        {
            DataTable dt = StockReports.GetDataTable("select centre,PreRegToSample,PreSampToSampSend,PreSampSendToLab from centre_master where centreid='" + lblCentreID.Text + "'  ");
            lblCentreName.Text = dt.Rows[0]["centre"].ToString();

            txtRegSample.Text = dt.Rows[0]["PreRegToSample"].ToString();
            txtSamColl.Text = dt.Rows[0]["PreSampToSampSend"].ToString();
            txtSamSend.Text = dt.Rows[0]["PreSampSendToLab"].ToString();
        }
    }

    [WebMethod]
    public static string saveAnalytical(string PreRegToSample, string PreSampToSampSend, string PreSampSendToLab, string CentreID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();
        try
        {
            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "update centre_master set PreRegToSample='" + PreRegToSample + "',PreSampToSampSend='" + PreSampToSampSend + "',PreSampSendToLab='" + PreSampSendToLab + "' where centreid='" + CentreID + "' ");
            tranX.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranX.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}