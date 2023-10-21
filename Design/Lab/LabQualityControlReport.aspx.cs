using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;

public partial class Design_Lab_LabQualityControlReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["LoginName"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }
            lblMsg.Text = "";
            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindCenterDDL();
            BindDepartment();

        }
    }


    void bindCenterDDL()
    {
        DataTable dt = StockReports.GetDataTable(" select distinct cm.CentreID,cm.Centre Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.centrecode,cm.Centre ");



        ddlcentre.DataSource = dt;
        ddlcentre.DataValueField = "CentreID";
        ddlcentre.DataTextField = "Centre";
        ddlcentre.DataBind();


        ListItem selectedListItem = ddlcentre.Items.FindByValue(UserInfo.Centre.ToString());

        if (selectedListItem != null)
        {
            selectedListItem.Selected = true;
        }

        ddlcentre.Items.Add(new ListItem("ALL","0"));


    }

    private void BindDepartment()
    {
        using (DataTable dt = AllLoad_Data.getDepartment())
        {
            if (dt.Rows.Count > 0)
            {
                chkDept.DataSource = dt;
                chkDept.DataTextField = "NAME";
                chkDept.DataValueField = "SubCategoryID";
                chkDept.DataBind();
            }
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (rbtnSelect.SelectedItem.Value == "1")
        {
            RerunReport();
        }
        else if (rbtnSelect.SelectedItem.Value == "2")
        {
            AmendmentReport();
        }
        else if (rbtnSelect.SelectedItem.Value == "3")
        {
            AbnormalValueReport();
        }
        else if (rbtnSelect.SelectedItem.Value == "4")
        {
            CriticalValueReport();
        }
        
    }

    void RerunReport()
    {
        var dept = AllLoad_Data.GetSelection(chkDept);
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT (SELECT centre FROM centre_master WHERE centreid = lt.CentreID) BookingCentre,DATE_FORMAT(lt.date,'%d-%b-%y %h:%m %p') BookingDate, ");
            sb.Append("   (select centre from centre_master where centreid=pli.testCentreID) TestCentre ,lt.`LedgerTransactionNo` VisitNo,pli.`BarcodeNo` SinNo,lt.`Patient_ID` UHID,lt.`PName`,pm.`Mobile`,CONCAT(lt.`Age`,'/',LEFT(lt.`Gender`,1)) Age, ");
            sb.Append("lt.DoctorName,pli.testcode TestCode, pli.`InvestigationName` TestName,lm.name LabObservationName,plo.Value OldValue,plo1.value NewValue ,Reason ReRunReason,");
            sb.Append(" date_format(plo.dtentry,'%d-%b-%y %h:%m %p')ReRunDate,(select name from employee_master where employee_id=plo.userid limit 1) ReRunBy ,pli.`ApprovedName`,DATE_FORMAT(pli.ApprovedDate,'%d-%b-%y %h:%m %p') ApprovedDate");
           
           
        
           
            sb.Append(" FROM `patient_labinvestigation_opd` pli ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID` ");
            if (txtLabNo.Text.Trim() != "")
            {
                sb.Append(" AND pli.LedgerTransactionNo = '" + txtLabNo.Text.Trim() + "' ");
            }
            else if(ddlcentre.SelectedValue !="0")
            {
                sb.Append(" AND lt.CentreID = '" + ddlcentre.SelectedItem.Value + "' ");
            }
            else if (dept != "")
            {
                sb.Append(" AND pli.SubCategoryID IN (" + dept + ") ");
            }


            sb.Append(" INNER JOIN `patient_labobservation_opd_rerun` plo ON plo.`Test_ID`=pli.`Test_ID`  ");
            sb.Append(" INNER JOIN `patient_labobservation_opd` plo1 ON plo1.`Test_ID`=plo.`Test_ID` and plo1.`LabObservation_ID`=plo.`LabObservation_ID` ");
            sb.Append(" INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=plo.`LabObservation_ID` ");
            sb.Append("  INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`");
            sb.Append(" WHERE DATE(plo.dtentry) >= '" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + "' and  DATE(plo.dtentry) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");

            sb.Append(" ORDER BY visitno,InvestigationName,lm.`Name` ");





            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["ReportName"] = " ReRun Report";

                Session["dtExport2Excel"] = dt;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMsg.Text = " No data Found";

            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();
           
        }

       
    }

    void AmendmentReport()
    {
        var dept = AllLoad_Data.GetSelection(chkDept);
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT (select centre from centre_master where centreid=pli.testCentreID) TestCentre, lt.`LedgerTransactionNo` VisitNo,pli.`BarcodeNo` SinNo,lt.`PName`,CONCAT(lt.`Age`,'/',LEFT(lt.`Gender`,1)) Age, ");
            sb.Append(" pli.`InvestigationName` TestName ,date_format(ru.UnapproveDate,'%d-%b-%y %h:%m %p')UnapproveDate,ru.UnapproveBy,ru.comments UnApproveReason, date_format(pli.ApprovedDate,'%d-%b-%y %h:%m %p') ApproveDate,pli.ApprovedName ApproveBy");
            sb.Append(" FROM `patient_labinvestigation_opd` pli ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID` ");
            
            if (txtLabNo.Text.Trim() != "")
            {
                sb.Append(" AND pli.LedgerTransactionNo = '" + txtLabNo.Text.Trim() + "' ");
            }
            else if (ddlcentre.SelectedValue != "0")
            {
                sb.Append(" AND pli.CentreID = '" + ddlcentre.SelectedItem.Value + "' ");
            }
             if (dept != "")
            {
                sb.Append(" AND pli.SubCategoryID IN (" + dept + ") ");
            }



            sb.Append(" INNER JOIN `report_unapprove` ru ON ru.`Test_ID`=pli.`Test_ID`  ");

            sb.Append(" WHERE DATE(ru.unapprovedate) >= '" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + "' and  DATE(ru.unapprovedate) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");

            sb.Append(" ORDER BY visitno,InvestigationName");





            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["ReportName"] = "Amendment Report";

                Session["dtExport2Excel"] = dt;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMsg.Text = " No data Found";

            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();

        }

    }

    void AbnormalValueReport()
    {
        var dept = AllLoad_Data.GetSelection(chkDept);
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT (select centre from centre_master where centreid=pli.testCentreID) TestCentre ,lt.`LedgerTransactionNo` VisitNo,pli.`BarcodeNo` SinNo,lt.`PName`,CONCAT(lt.`Age`,'/',LEFT(lt.`Gender`,1)) Age, ");
            sb.Append(" pli.`InvestigationName` TestName,lm.name LabObservationName,plo.Value,ROUND(plo.minvalue,2) Minvalue,ROUND(plo.`maxvalue`,2) `Maxvalue`,");
            sb.Append(" date_format(pli.ResultEnteredDate,'%d-%b-%y %h:%m %p')ResultEntryDate,pli.ResultEnteredName ResultEnteredBy");
            sb.Append(" FROM `patient_labinvestigation_opd` pli ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID` ");
            if (txtLabNo.Text.Trim() != "")
            {
                sb.Append(" AND pli.LedgerTransactionNo = '" + txtLabNo.Text.Trim() + "' ");
            }
            else if (ddlcentre.SelectedValue != "0")
            {
                sb.Append(" AND lt.CentreID = '" + ddlcentre.SelectedItem.Value + "' ");
            }

            else if (dept != "")
            {
                sb.Append(" AND pli.SubCategoryID IN (" + dept + ") ");
            }

           
            sb.Append(" INNER JOIN `patient_labobservation_opd` plo ON pli.`Test_ID`=plo.`Test_ID`  ");
            sb.Append(" INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=plo.`LabObservation_ID` ");
            sb.Append(" WHERE DATE(pli.ResultEnteredDate) >= '" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + "' and  DATE(pli.ResultEnteredDate) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");

            sb.Append("   AND ROUND(plo.minvalue)>0 AND ROUND(plo.maxvalue)>0 AND IsNumeric(plo.value)=1  AND  ((plo.value*1)<(plo.minvalue*1 ) OR (plo.value*1)>(plo.maxvalue*1 ) )   ");

            sb.Append(" ORDER BY visitno,InvestigationName,lm.`Name` ");





            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["ReportName"] = "Abnormal Value Report";

                Session["dtExport2Excel"] = dt;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMsg.Text = " No data Found";

            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();

        }

    }

    void CriticalValueReport()
    {
        var dept = AllLoad_Data.GetSelection(chkDept);
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT (select centre from centre_master where centreid=pli.testCentreID) TestCentre ,lt.`LedgerTransactionNo` VisitNo,pli.`BarcodeNo` SinNo,lt.`PName`,CONCAT(lt.`Age`,'/',LEFT(lt.`Gender`,1)) Age, ");
            sb.Append(" pli.`InvestigationName` TestName,lm.name LabObservationName,plo.Value,ROUND(plo.MinCritical,2) MinCritical,ROUND(plo.`MaxCritical`,2) `MaxCritical`,");
            sb.Append(" date_format(pli.ResultEnteredDate,'%d-%b-%y %h:%m %p')ResultEntryDate,pli.ResultEnteredName ResultEnteredBy");
            sb.Append(" FROM `patient_labinvestigation_opd` pli ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID` ");
            if (txtLabNo.Text.Trim() != "")
            {
                sb.Append(" AND pli.LedgerTransactionNo = '" + txtLabNo.Text.Trim() + "' ");
            }
            else if (ddlcentre.SelectedValue != "0")
            {
                sb.Append(" AND lt.CentreID = '" + ddlcentre.SelectedItem.Value + "' ");
            }

            else if (dept != "")
            {
                sb.Append(" AND pli.SubCategoryID IN (" + dept + ") ");
            }


            sb.Append(" INNER JOIN `patient_labobservation_opd` plo ON pli.`Test_ID`=plo.`Test_ID`  and plo.IsCritical=1");
            sb.Append(" INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=plo.`LabObservation_ID` ");
            sb.Append(" INNER JOIN labobservation_investigation loi ON pli.Investigation_Id=loi.Investigation_Id and loi.labobservation_id=plo.`LabObservation_ID`  and loi.IsCritical=1   ");

           
            sb.Append(" WHERE DATE(pli.ResultEnteredDate) >= '" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + "' and  DATE(pli.ResultEnteredDate) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");

            sb.Append("   AND ROUND(plo.MinCritical)>0 AND ROUND(plo.MaxCritical)>0 AND IsNumeric(plo.value)=1  AND  ((plo.value*1)<(plo.MinCritical*1 ) OR (plo.value*1)>(plo.MaxCritical*1 ) )   ");

            sb.Append(" ORDER BY visitno,InvestigationName,lm.`Name` ");





            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["ReportName"] = "Critical Value Report";

                Session["dtExport2Excel"] = dt;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMsg.Text = " No data Found";

            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();

        }

    }
}