using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_LabReportPrint : System.Web.UI.Page
{
    public string testid = "";
    public string labno = "";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            testid = Util.GetString(Request.QueryString["TestID"]);
            labno = Util.GetString(Request.QueryString["LabNo"]);
            bindcentre();
        }
    }
    void bindcentre()
    {
        string str = "select distinct cm.CentreID,concat(cm.CentreCode,'-',cm.Centre) as Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='1' and AccessType=2 ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 order by cm.CentreCode  ";

        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        ddlcentre.DataSource = dt;
        ddlcentre.DataTextField = "Centre";
        ddlcentre.DataValueField = "CentreID";
        ddlcentre.DataBind();

       // ddlcentre.Items.Insert(0, new ListItem("ALL Centre", "0"));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getdata(string fromdate, string todate, string labno, string searchop, string status, string centre, string dateoption)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT date_format(lt.date,'%d/%m/%y %h:%I %p') Bookat, cm.`Centre`,lt.panelname `Company_Name`,lt.doctorname `Name`, plo.`LedgerTransactionNo`,lt.`PName`, ");
        sb.Append(" lt.age,lt.gender  ");
        sb.Append(" ,CASE ");
        sb.Append(" WHEN COUNT(*)=SUM(plo.isPrint) THEN '#00FFFF' ");
        sb.Append(" WHEN COUNT(*)=SUM(plo.Approved) THEN '#90EE90' ");
        sb.Append(" WHEN COUNT(*)=SUM(plo.Result_Flag)  Then 'Pink' ");
        sb.Append("  WHEN COUNT(*)=SUM(IF(plo.isSampleCollected='N',1,0)) THEN  '#CC99FF' ");
        sb.Append("  WHEN COUNT(*)=SUM(IF(plo.isSampleCollected='Y',1,0)) THEN 'white' ");
        sb.Append("  ELSE 'white'  ");
        sb.Append("  END rowcolor ");
        sb.Append(" FROM  patient_labinvestigation_opd plo ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt on lt.LedgerTransactionid=plo.LedgerTransactionid ");
    
        sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
        if (centre != "0")
        {
            sb.Append("and cm.`CentreID`='"+centre+"'");
        }
        if (dateoption == "1")
        {
            sb.Append(" where plo.approveddate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'  ");
            sb.Append(" and plo.approveddate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }
        else
        {
            sb.Append(" where lt.date>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'  ");
            sb.Append(" and lt.date<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }
        if (labno != "")
        {
            sb.Append(" and " + searchop + "  like '%" + labno + "%' ");
        }
      
        sb.Append(" group by plo.LedgerTransactionNo");
         if (status == "Authenticated")
        {
            sb.Append(" HAVING COUNT(*)<> SUM(isPrint) and SUM(plo.Approved)<>0 ");
        }
        if (status == "Printed")
        {
            sb.Append(" HAVING COUNT(*) = SUM(isPrint) ");
        }
     


        sb.Append("  ORDER BY plo.`LedgerTransactionNo` ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getdetaildata(string labno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT im.ReportType, ");
        sb.Append(" plo.Test_ID,om.Name dept, im.name testname, ");
        sb.Append(" (CASE when plo.approved=1 and plo.isprint=1 then 'Approved & Print' WHEN plo.approved=1 and plo.isprint=0  THEN 'Approved'  ");
        sb.Append("       WHEN plo.approved=0 && plo.result_flag=1 THEN  'Result Done' ");
        sb.Append("      ELSE 'Result Not Done' END ) STATUS , ");
        sb.Append("        (CASE when plo.approved=1 and plo.isprint=1 then '#00FFFF'  WHEN plo.approved=1 and plo.isprint=0  THEN 'lightgreen'  ");
        sb.Append("        WHEN plo.approved=0 && plo.result_flag=1 THEN  'Pink' ");
        sb.Append("        ELSE 'white' END ) rowcolor  ");
        sb.Append("    FROM patient_labinvestigation_opd plo  ");
        sb.Append("         INNER JOIN investigation_master im ON im.Investigation_Id=plo.Investigation_ID AND im.ReportType IN(1,3,7)  ");
        sb.Append("          INNER JOIN investigation_observationtype io ON io.Investigation_ID=im.Investigation_Id  ");
        sb.Append("          INNER JOIN observationtype_master om ON om.ObservationType_ID=io.ObservationType_Id  ");
        sb.Append("            WHERE plo.LedgerTransactionNo='" + labno + "' ORDER BY om.name,im.name  ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

  
}