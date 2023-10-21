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

public partial class Design_HomeCollection_SMSEmailLogreport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtfromdate.Attributes.Add("readOnly", "readOnly");
        txttodate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod]
    public static string SummaryReport(string fromdate, string todate, string logtype)
    {

        MySqlConnection con = Util.GetMySqlCon();
        StringBuilder sb = new StringBuilder();
        con.Open();
        try
        {

            if (logtype == "SMS")
            {
                sb.Append(" SELECT mobile_no,sms_type,SMS_Text,DATE_FORMAT(entdate,'%d-%b-%Y %h:%i %p') EntryDateTime,IF(issend=1,'Send','Fail') SendingStatus ");

                sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".sms ");
                sb.Append(" where entdate>=@fromdate ");
                sb.Append(" and entdate<=@todate ");
                sb.Append(" order by sms_id ");
            }
            else if (logtype == "Email")
            {
                sb.Append(" SELECT PreBookingID, EmailID,`Subject`,EmailType,EmailBody Email_Text,EmailReceiver EmailSendTo,DATE_FORMAT(EntryDateTime,'%d-%b-%Y %h:%i %p') EntryDateTime,");
                sb.Append(" IF(issend=1,'Send','Fail') SendingStatus FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_email_sender` ");
                sb.Append(" where EntryDateTime>=@fromdate ");
                sb.Append(" and EntryDateTime<=@todate ");
                sb.Append(" ORDER BY id  ");

            }
            else if (logtype == "Notification")
            {
                sb.Append(" SELECT PreBookingID,hp.Name PhelboName, title,Body Notification_Text,DATE_FORMAT(EntryDate,'%d-%b-%Y %h:%i %p') EntryDateTime,");
                sb.Append(" IF(isSend=1,'Send','Fail') SendingStatus FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_fcm_notification` hcf");
                sb.Append(" INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp ON hcf.`PhelbotomistID`=hp.`PhlebotomistID`");
                sb.Append(" where EntryDate>=@fromdate ");
                sb.Append(" and EntryDate<=@todate ");
                sb.Append(" ORDER BY id ");


            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@fromdate", Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00"),
                    new MySqlParameter("@todate", Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0])
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
                    HttpContext.Current.Session["ReportName"] = logtype + "LogReport";
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
            return "false";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}