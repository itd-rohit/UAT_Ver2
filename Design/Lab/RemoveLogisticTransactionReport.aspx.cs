using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_Lab_RemoveLogisticTransactionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");          
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
            bindCentreMaster();
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    private void bindCentreMaster()
    {
        DataTable dt = StockReports.GetDataTable("SELECT centreID,Centre FROM  centre_master WHERE IsActive=1 AND TagProcessingLabID='" + UserInfo.Centre + "'");
        if (dt.Rows.Count > 0)
        {
            chlCentres.DataSource = dt;
            chlCentres.DataTextField = "Centre";
            chlCentres.DataValueField = "centreID";
            chlCentres.DataBind();            
        }
    }
   
    protected void btnPDFReport_Click(object sender, EventArgs e)
    {
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        if (Centres.Trim() == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        sb.Append(" SELECT CONCAT(pm.`Title`,' ',pm.`PName`)NAME,pm.`Gender`,pm.`Age`,cm.`Centre`, plo.`BarcodeNo`,GROUP_CONCAT(plo.`ItemName`)ItemName  , ");
        sb.Append(" DATE_FORMAT(slr.`dtRemove`,'%d-%m-%Y')dtRemove,RemovedBy EmployeeName ");
        sb.Append(" FROM `patient_labinvestigation_opd` plo ");
        sb.Append(" INNER JOIN sample_logistic_Remove slr ON slr.`BarcodeNo`=plo.`BarcodeNo` ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=plo.`Patient_ID` ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=plo.`CentreID`");
       // sb.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=slr.`RemoveByID` ");
        sb.Append(" AND plo.CentreID in(" + Centres.Trim() + ")   ");
        sb.Append(" AND slr.`dtRemove`>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'  ");
        sb.Append(" AND slr.`dtRemove`<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
        sb.Append("  GROUP BY plo.`BarcodeNo` ");
        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            DataSet ds = new DataSet();
            ds.Tables.Add(dt.Copy());
         //   ds.WriteXmlSchema(@"C:\RemoveLogisticTransactionReport.xml"); 
            Session["ds"] = ds;
            Session["ReportName"] = "RemoveLogisticTransactionReport";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Record not found";
        }
    }

}