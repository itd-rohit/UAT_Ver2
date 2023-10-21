using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_DashBoardNew_SRAToApprove : System.Web.UI.Page
{
    string txtDate = "";
    string CentreID = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        txtDate = Util.GetString(Request.QueryString["txtDate"]);
        CentreID = Util.GetString(Request.QueryString["CentreID"]);
        labDetail(txtDate, CentreID);

    }

    public void labDetail(string date, string Centreid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string CentreID = "";
        try
        {
            if (Centreid == "")
            {
                CentreID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT GROUP_CONCAT(DISTINCT fl.centreid) FROM f_login fl INNER JOIN centre_master cm ON cm.`CentreID`=fl.`CentreID` AND cm.`type1` NOT IN ('PCC','DDC') WHERE employeeid=" + UserInfo.ID + ""));
            }
            else
            {
                CentreID = Centreid;
            }
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT  ");
            sb.Append("  plo.LedgerTransactionNo,plo.BarcodeNo,plo.SubCategorymasterName ");
            sb.Append("  FROM patient_labinvestigation_opd plo   ");
            sb.Append("  inner join sample_logistic sl on sl.barcodeno=plo.barcodeno and sl.testid=plo.test_id AND sl.IsActive=1 ");
            sb.Append(" WHERE  plo.Result_Flag=1   ");
            sb.Append(" AND plo.date>='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 00:00:00") + "'  ");
            sb.Append(" AND plo.date<='" + string.Concat(Util.GetDateTime(date).ToString("yyyy-MM-dd"), " 23:59:59") + "' ");
            sb.Append(" AND plo.SubcategoryID in (1,2,6,9,12) ");
            sb.Append(" and TIMEDIFF(plo.ApprovedDate,sl.ReceivedDate)< '02:45:00' AND plo.`centreid`IN(" + CentreID + ") ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count == 0)
            {
                lblerrmsg.Text = "No Data Found";
            }

            grd.DataSource = dt;
            grd.DataBind();


        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblerrmsg.Text= JsonConvert.SerializeObject(new { status = false });
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