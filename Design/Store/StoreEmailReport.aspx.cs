using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_StoreEmailReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
           
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetReport(string fromdate, string todate)
    {

        StringBuilder sb = new StringBuilder();
      


        sb.Append(" SELECT TransactionID EmailRefrenceID,remarks EMailType,MailedTo,EmailID,Cc,Bcc, ");
        sb.Append(" DATE_FORMAT(DtEntry,'%d-%b-%Y') SendDate, ");
        sb.Append(" (SELECT NAME FROM employee_master em WHERE em.employee_id=UserID)SendBy ");
        sb.Append(" FROM st_emailrecord ");

        sb.Append(" where DtEntry >='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'");
        sb.Append(" and DtEntry <='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'");

        sb.Append(" order by remarks,DtEntry");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
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
            HttpContext.Current.Session["ReportName"] = "StoreEmailReport";
            return "true";
        }
        else
        {
            return "false";
        }
    }
}