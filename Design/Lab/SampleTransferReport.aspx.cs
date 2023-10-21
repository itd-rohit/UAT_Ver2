using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Data;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_SampleTransferReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindCentreMaster();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    private void bindCentreMaster()
    {
        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                chlCentres.DataSource = dt;
                chlCentres.DataTextField = "Centre";
                chlCentres.DataValueField = "centreID";
                chlCentres.DataBind();
            }
        }
    }
    public static string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;
        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += string.Format(",{0}", li.Value);
                else
                    str = string.Format("{0}", li.Value);
            }
        }
        return str;
    }
    protected void btnExcelReport_Click(object sender, EventArgs e)
    {
        string Centres = GetSelection(chlCentres);
        if (Centres.Trim() == "")
        {
            // lblMsg.Text = "Please Select Centre";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "showMsg();", true);
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sm.`DispatchCode` BatchNo,sm.BarcodeNo,plo.LedgerTransactionNo VisitNo,sm.`PickUpFieldBoy`,sm.`CourierDetail`,sm.`CourierDocketNo`,lt.`Patient_ID` UHID,lt.`PName` PatientName,lt.`Age` Age,plo.`ItemCode` TestCode,plo.`ItemName` TestName,cm.Centre RegistrationLab, ");
        sb.Append(" cm1.`Centre` FromCentre,cm2.`Centre` ToCentre,date_format(sm.`dtEntry`,'%d-%b-%y %h:%i %p') TransferDateTime,sm.`EntryBy` TranferedByID, ");
        sb.Append(" (SELECT em.Name FROM employee_master em WHERE em.Employee_ID=sm.EntryBy LIMIT 1)  TransferredByName ");
        sb.Append(" FROM `patient_labinvestigation_opd` plo ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt");
        sb.Append(" ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`");        
        sb.Append(" INNER JOIN `sample_logistic` sm ");
        sb.Append(" ON sm.`testid`=plo.`Test_ID` AND sm.`IsActive`=1 ");
        sb.Append(" AND sm.`DispatchCode` <>'' AND sm.`FromCentreID`<>sm.`ToCentreID` ");
        sb.Append(" AND sm.`FromCentreID` IN ({0}) ");
        sb.Append(" AND sm.`dtEntry` >=@FromDate  AND sm.`dtEntry` <=@ToDate ");

        sb.Append(" INNER JOIN centre_master cm ");
        sb.Append(" ON cm.`CentreID`=lt.`CentreID` ");
        sb.Append(" INNER JOIN centre_master cm1 ");
        sb.Append(" ON  cm1.`CentreID`=sm.`FromCentreID` ");
        sb.Append(" INNER JOIN centre_master cm2 ");
        sb.Append(" ON  cm2.`CentreID`=sm.`ToCentreID` ");

        string Period = string.Concat("From : ", Util.GetDateTime(txtFromDate.Text).ToString("dd-MMM-yyyy"), " To : ", Util.GetDateTime(txtToDate.Text).ToString("dd-MMM-yyyy"));


        NameValueCollection collections = new NameValueCollection();
        collections.Add("ReportDisplayName", Common.EncryptRijndael("Sample Transfer Report"));
        collections.Add("FromCentreID#1", Common.EncryptRijndael(Centres));
        collections.Add("FromDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd"), " ", "00:00:00")));
        collections.Add("ToDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), " ", "23:59:59")));
        collections.Add("Query", Common.EncryptRijndael(sb.ToString()));
        collections.Add("Period", Common.EncryptRijndael(Period));

        AllLoad_Data.ExpoportToExcelEncrypt(collections, 2, this.Page);

    }
}