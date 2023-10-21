using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Sales_SalesEmailStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            AllLoad_Data.bindDropDown(ddlEmailTypeID, "All", "SELECT EmailTypeID ID,EmailTypeName Text FROM sales_email_record_master Where IsActive=1 ORDER BY SequenceNo+0 ");
        }
    }
    [WebMethod]
    public static string SalesEmail(string fromDate, string toDate, int con, int EmailTypeID, string EmailTo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID,se.EmailTypeID,ser.EmailTypeName,IF(EmailStatus=1,'Send','NotSend')EmailStatus,EmailStatus IsSend,CreatedBy,DATE_FORMAT(CreatedDate,'%d-%b-%Y')CreatedDate,EmailContent,EmailTo,EmailCC, ");
        sb.Append(" EmailBCC,EmailSubject,IF(EmailStatus='1',DATE_FORMAT(SendDateTime,'%d-%b-%Y'),'')SendDateTime FROM sales_email_record se INNER JOIN sales_email_record_master ser ON ser.EmailTypeID=se.EmailTypeID ");
        sb.Append(" WHERE se.CreatedDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND se.CreatedDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (con != 2)
            sb.Append(" AND se.EmailStatus='" + con + "' ");
        if (EmailTypeID != 0)
            sb.Append(" AND se.EmailTypeID='" + EmailTypeID + "' ");
        if (EmailTo.Trim() != string.Empty)
            sb.Append(" AND se.EmailTo LIKE '%" + EmailTo + "%' ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return null;
        }
    }
    [WebMethod]
    public static string resendMail(int ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT IFNULL(EmailContent,'')EmailContent,IFNULL(EmailTo,'')EmailTo,IFNULL(EmailCC,'')EmailCC,IFNULL(EmailBCC,'')EmailBCC,IFNULL(EmailSubject,'')EmailSubject,IsAttachment,IFNULL(AttachmentPath,'')AttachmentPath,EmailTypeID,IDType2ID FROM sales_email_record WHERE ID=@ID",
               new MySqlParameter("ID", ID)).Tables[0])
            {

                ReportEmailClass re = new ReportEmailClass();
                if (dt.Rows[0]["EmailTypeID"].ToString() == "10")
                {
                    byte[] byteArray = Sales.PUPSalesRateList(con, Util.GetInt(dt.Rows[0]["IDType2ID"].ToString()));
                    return re.sendPanelInvoice(dt.Rows[0]["EmailTo"].ToString(), dt.Rows[0]["EmailSubject"].ToString(), dt.Rows[0]["EmailContent"].ToString(), byteArray, dt.Rows[0]["EmailCC"].ToString(), dt.Rows[0]["EmailBCC"].ToString(), null, dt.Rows[0]["EmailSubject"].ToString(), Util.GetString(DateTime.Now));
                }
                else
                {
                    string IsSend = re.SalesEnrolmentEmail(dt.Rows[0]["EmailTo"].ToString(), dt.Rows[0]["EmailSubject"].ToString(), dt.Rows[0]["EmailContent"].ToString(), dt.Rows[0]["EmailCC"].ToString(), dt.Rows[0]["EmailBCC"].ToString());

                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE sales_email_record SET EmailStatus=@EmailStatus WHERE ID=@ID",
                       new MySqlParameter("@EmailStatus", IsSend), new MySqlParameter("@ID", ID));
                    return IsSend;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
}