using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_StockLedgerReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            txtfromdate.Text = "1-"+DateTime.Now.ToString("MMM-yyyy");
            txttodate.Text = DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month) + "-" + DateTime.Now.ToString("MMM-yyyy");
            bindalldata();
        }
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();
            //ddllocation.Items.Insert(0, new ListItem("Select Location", "0"));
        }

    }
    [WebMethod(EnableSession = true)]
    public static string getstockstatusreportpdf(string location, string Items, string manu, string machine, string fromdate, string todate)
    {
        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                FromDate = Common.EncryptRijndael(fromdate),
                ToDate = Common.EncryptRijndael(todate),
                ItemID = Common.EncryptRijndael(Util.GetString(Items)),
                Manu = Common.EncryptRijndael(Util.GetString(manu)),
                LocationID = Common.EncryptRijndael(Util.GetString(location)),
                MachineID = Common.EncryptRijndael(Util.GetString(machine)),
                ReportPath = "StockLedgerReportPDF.aspx"
            });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false

            });
        }
    }
    [WebMethod(EnableSession = true)]
    public static string getstockstatusreportexcel(string location, string Items, string manu, string machine, string fromdate, string todate)
    {

        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                FromDate = Common.EncryptRijndael(fromdate),
                ToDate = Common.EncryptRijndael(todate),
                ItemID = Common.EncryptRijndael(Util.GetString(Items)),
                Manu = Common.EncryptRijndael(Util.GetString(manu)),
                LocationID = Common.EncryptRijndael(Util.GetString(location)),
                MachineID = Common.EncryptRijndael(Util.GetString(machine)),
                ReportType = Common.EncryptRijndael("StockLedgerReport"),
                ReportPath = "../Common/ExportToExcelEncrypt.aspx"
            });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false

            });
        }

    }
    
}