using System;
using System.Data;
using System.IO;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Lab_GetAllReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lb.Text = Util.getApp("LabReportPath") + @"LabReports\" + DateTime.Now.Year + @"\" + DateTime.Now.Month + @"\" + DateTime.Now.Day + @"\";
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ddlpanel.DataSource = StockReports.GetDataTable("select panel_id,company_name from f_panel_master where isactive=1 order by company_name");
            ddlpanel.DataValueField = "panel_id";
            ddlpanel.DataTextField = "company_name";
            ddlpanel.DataBind();

            ddlpanel.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchRecords(string panelid, string fromdate, string todate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT lt.patient_id,pname,age,lt.gender,DATE_FORMAT(lt.date,'%d-%b-%Y') bookingdate,panel_id,panelname ,lt.LedgerTransactionID,lt.LedgerTransactionno, ");
        sb.Append(" (SELECT centre FROM centre_master WHERE centreid=lt.centreid)centre, ");
        sb.Append(" GROUP_CONCAT(itemname ORDER BY itemname)Testname,GROUP_CONCAT(test_id) testid ");
        sb.Append(" FROM `f_ledgertransaction` lt  ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.LedgerTransactionID=lt.LedgerTransactionID AND plo.approved=1 ");
        sb.Append(" WHERE iscancel=0 ");
        sb.Append(" and panel_id='" + panelid + "'");
        sb.Append(" and lt.date>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" and lt.date<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");
        sb.Append("  GROUP BY lt.LedgerTransactionID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string ExportData(string labid)
    {
        try
        {
            labid = "'" + labid.Trim(',') + "'";
            labid = labid.Replace(",", "','");
            DataTable dt = StockReports.GetDataTable("select LedgerTransactionno,GROUP_CONCAT(test_id)test_id from `patient_labinvestigation_opd` where LedgerTransactionID in (" + labid + ") and approved=1 group by LedgerTransactionID  ");

            foreach (DataRow dw in dt.Rows)
            {
                string testid = dw["test_id"].ToString() + ",";
                string LedgerTransactionno = dw["LedgerTransactionno"].ToString();
                string url = HttpContext.Current.Request.Url.Scheme + "://" + HttpContext.Current.Request.Url.Host + ":" + HttpContext.Current.Request.Url.Port + "/" + HttpContext.Current.Request.Url.AbsolutePath.Split('/')[1] + "/Design/Lab/labreportnew.aspx?GetReportBase64=1&LabNo=" + LedgerTransactionno + "&testid=" + testid;

                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                HttpWebResponse response = (HttpWebResponse)request.GetResponse();

                response.Close();
            }

            return "1";
        }
        catch (Exception ex)
        {
            return ex.Message.ToString();
        }
    }

    public static void CopyStream(Stream input, Stream output)
    {
        byte[] buffer = new byte[8 * 1024];
        int len;
        while ((len = input.Read(buffer, 0, buffer.Length)) > 0)
        {
            output.Write(buffer, 0, len);
        }
    }

    //private static  ConvertToStream(string fileUrl)
    //{
    //    HttpWebRequest request = (HttpWebRequest)WebRequest.Create(fileUrl);

    //}
}