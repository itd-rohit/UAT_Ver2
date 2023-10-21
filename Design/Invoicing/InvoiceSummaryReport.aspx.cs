using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Invoicing_InvoiceSummaryReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1).ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            RadioButtonList radioList = (RadioButtonList)rblSearchType.FindControl("rblSearchType");
            radioList.Items.Add(new ListItem("All", "0"));
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchInvoice(string dtFrom, string dtTo, string InvoiceNo, string SearchType, int DispatchStatus, int CancelStatus)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT `InvoiceNo`,im.`PanelID`,DATE_FORMAT(`InvoiceDate`,'%d-%b-%Y')InvoiceDate,DATE_FORMAT(im.`FromDate`,'%d-%b-%Y')FromDate, ");
            sb.Append(" DATE_FORMAT(im.`ToDate`,'%d-%b-%Y')ToDate,im.`ShareAmt`,im.`InvoiceType`,fpm.Company_Name PanelName,fpm.Panel_Code,if(im.IsCancel=1,'Yes','No')IsCancel,if(im.IsDispatch=1,'Yes','No')IsDispatch ");

            sb.Append(" FROM invoiceMaster im INNER JOIN f_panel_master fpm ON im.PanelID=fpm.Panel_ID  WHERE im.InvoiceNo<>'' ");
            if (InvoiceNo == string.Empty)
            {
                sb.Append(" AND im.`InvoiceDate`>=@dtFrom ");
                sb.Append(" AND im.`InvoiceDate`<=@dtTo");
            }
            if (DispatchStatus != 2 && InvoiceNo == string.Empty)
            {
                sb.Append(" AND IsDispatch =@DispatchStatus ");
            }
            if (CancelStatus != 2 && InvoiceNo == string.Empty)
            {
                sb.Append(" AND IsCancel =@CancelStatus ");
            }
            if (InvoiceNo != string.Empty)
            {
                sb.Append(" AND im.InvoiceNo=@InvoiceNo ");
            }
            if (SearchType.ToUpper() != "ALL")
            {
                sb.Append(" AND im.InvoiceType=@InvoiceType ");
            }
            sb.Append(" ORDER BY im.ID ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@InvoiceNo", InvoiceNo),
               new MySqlParameter("@InvoiceType", SearchType),
               new MySqlParameter("@CancelStatus", CancelStatus),
               new MySqlParameter("@DispatchStatus", DispatchStatus),
               new MySqlParameter("@dtFrom", string.Concat(Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd"), " ", "00:00:00")),
               new MySqlParameter("@dtTo", string.Concat(Util.GetDateTime(dtTo).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return Util.getJson(dt);
                else
                    return null;
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}