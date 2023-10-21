using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_ModeWiseCollectionReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindCenter();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    public void BindCenter()
    {
        //string str = string.Empty;
        //if (UserInfo.Centre == 1)
        //{
        //    str = " SELECT cm.CentreID,cm.Centre FROM centre_master cm where cm.`isActive`=1 ";
        //}
        //else
        //{
        //    str = " SELECT DISTINCT cm.CentreID,cm.Centre FROM centre_master cm INNER JOIN f_login fl ON fl.`CentreID`=cm.`CentreID` AND fl.`EmployeeID`='" + UserInfo.ID + "' AND cm.`isActive`=1 ";
        //} 
        //DataTable dt = StockReports.GetDataTable(str);
        DataTable dt = AllLoad_Data.getCentreByTagBusinessLab();
         if (dt.Rows.Count > 0)
         {
             chlCentres.DataSource = dt;
             chlCentres.DataTextField = "Centre";
             chlCentres.DataValueField = "CentreID";
             chlCentres.DataBind();
         }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        if (Centres.Trim() == string.Empty)
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }

        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT lt.`Date`, lt.`LedgerTransactionNo` VisitNo,DATE_FORMAT(plo.`Date`,'%d-%b-%Y') BillDate,plo.`BillNo`,lt.`PName` CustomerName,cm.`Centre` PCC_Or_ClientName,lt.PanelName, ");
	    sb.Append(" fr.`PaymentMode`,fr.`Amount`,fr.Narration Naration,DATE_FORMAT(fr.`createdDate`,'%d-%b-%Y')  PaymentDate, em.Name UserName ");
        sb.Append(" FROM f_ledgertransaction lt  ");
        sb.Append(" INNER JOIN `f_receipt` fr ON fr.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionID=lt.LedgerTransactionID  ");
	    sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sb.Append(" INNER JOIN `employee_master` em ON em.`Employee_ID`=fr.`CreatedById` ");
        sb.Append(" WHERE   fr.`IsCancel`=0 ");
        sb.Append("  AND fr.createdDate>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'  ");
        sb.Append("  AND fr.createdDate<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
    	sb.Append("  AND fr.CentreID IN (" + Centres + " )");           
            if (txtBillNo.Text.Trim() != "")
                sb.Append("     AND plo.BillNo='" + txtBillNo.Text.Trim() + "'");
      

            sb.Append(" ORDER BY plo.Date ");
       


      
            string period = string.Concat("From : ", Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy"), " To : ", Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy"));
            AllLoad_Data.exportToExcel(sb.ToString(), "Mode Wise Collection Report", period, "1", this.Page);

       

    }
}