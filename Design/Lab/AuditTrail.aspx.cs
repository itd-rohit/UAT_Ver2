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

public partial class Design_Lab_AuditTrail : System.Web.UI.Page
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
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (rbtnSelect.SelectedItem.Value == "1")
        {
            ShowPatientData();
        }
        else if (rbtnSelect.SelectedItem.Value == "2")
        {
            InvestigationData();
        }
        else if (rbtnSelect.SelectedItem.Value == "4")
        {
            ShowDoctorPanelData();
        }
        else if (rbtnSelect.SelectedItem.Value == "3")
        {
            LabData();
        }
        else if (rbtnSelect.SelectedItem.Value == "5")
        {
            ReportNotApprovalData();
        }
        else if (rbtnSelect.SelectedItem.Value == "6")
        {
            ObsRangeData();
        }
        else if (rbtnSelect.SelectedItem.Value == "7")
        {
            RateData();
        }
    }
    private string ShowPatientData()
    {
        try
        {
            // StringBuilder sb = new StringBuilder();
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT * FROM (  SELECT 'Current' STATUS,lt.LedgertransactionNo VisitNo, CONCAT(pm.title,pm.pname) Pname,pm.Age,date_format(pm.Dob, '%d-%b-%Y ') DOB,pm.Gender,pm.Mobile,pm.State,pm.City,pm.Locality Area, pm.updatename username,date_format(pm.updatedate, '%d-%b-%Y %h:%i %p') UpdateDate FROM patient_master pm ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON pm.patient_id=lt.patient_id ");
            if (txtLabNo.Text.Trim() != "")
            {
                sb.Append(" AND lt.LedgertransactionNo = '" + txtLabNo.Text.Trim() + "' ");
            }
            else
            {
                sb.Append(" and lt.centreid='" + ddlcentre.SelectedValue + "' ");
            }

            sb.Append(" INNER JOIN " + Util.getApp("LogDataBaseName") + ".`patient_master_before_update` pbm ON pbm.patient_id=pm.patient_id ");

            sb.Append("   where lt.Date>='" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'  and  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
            sb.Append(" UNION ALL  ");
            sb.Append(" SELECT 'Old' STATUS,lt.LedgertransactionNo VisitNo, CONCAT(pm.title,pm.pname) Pname,pm.Age,date_format(pm.Dob, '%d-%b-%Y ') DOB,pm.Gender,pm.Mobile,pm.State,pm.City,pm.Locality Area,(select name from employee_master where employee_id=UserID) username,date_format(pm.dtEntry, '%d-%b-%Y %h:%i %p') UpdateDate FROM " + Util.getApp("LogDataBaseName") + ".patient_master_before_update pm ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON pm.patient_id=lt.patient_id  where lt.Date>='" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'  and  lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            if (txtLabNo.Text.Trim() != "")
            {
                sb.Append(" AND lt.LedgertransactionNo = '" + txtLabNo.Text.Trim() + "' ");
            }
            else
            {
                sb.Append(" and lt.centreid='" + ddlcentre.SelectedValue + "' ");
            }
            sb.Append("  ) t ORDER BY `VisitNo`,Status ");
            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            {

                if (dt != null && dt.Rows.Count > 0)
                {
                    Session["ReportName"] = " Audit Trail Report Patient Demographic Data ";
                    Session["dtExport2Excel"] = dt;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

                }
                else
                {
                    lblMsg.Text = " No data Found";
                }

            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();
            return "Error";
        }

        return "1";

    }
    private string InvestigationData()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select Status,VisitNo,PName,Age,TestCode,TestName,Type,Packagename,Amount,UserName,UpdateDateTime from ( SELECT 'ADD' Status,plo.LedgerTransactionNo VisitNo,lt.PName, ");
        sb.Append(" CONCAT(lt.Age,'/',LEFT(lt.Gender,1)) Age,");

        sb.Append(" plo.itemname TestName,plo.itemid, plo.BookingEditByUser UserName,date_format(plo.BookingEditDate, '%d-%b-%Y %h:%i %p')  UpdateDateTime,");
        sb.Append(" if(plo.ispackage=1,'Package','Test') Type,plo.packagename,TestCode,plo.Amount");
        sb.Append(" FROM patient_labinvestigation_opd plo ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID=plo.LedgerTransactionID ");


        sb.Append(" WHERE DATE(plo.date) >= '" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + "' and  DATE(plo.date) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" AND plo.BookingEditByUser<>'' ");
        sb.Append(" AND plo.LedgerTransactionNo<>''");
        if (txtLabNo.Text.Trim() != "")
        {
            sb.Append(" AND plo.LedgerTransactionNo = '" + txtLabNo.Text.Trim() + "' ");
        }
        else
        {
            sb.Append(" AND lt.CentreID = '" + ddlcentre.SelectedItem.Value + "' ");
        }
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT  'Delete' Status,plo.LedgerTransactionNoOLD,lt1.PName,");
        sb.Append(" CONCAT(lt1.Age,'/',LEFT(lt1.Gender,1)) Age,");

        sb.Append(" plo.itemname AS TestName,plo.itemid,plo.BookingEditByUser AS UserName,date_format(plo.BookingEditDate, '%d-%b-%Y %h:%i %p') UpdateDateTime,");
        sb.Append(" if(plo.ispackage=1,'Package','Test') Type,plo.packagename,TestCode,plo.Amount");

        sb.Append(" FROM patient_labinvestigation_opd plo ");
        sb.Append(" INNER JOIN f_ledgertransaction lt1 ON lt1.LedgerTransactionNo=plo.LedgerTransactionNoOLD ");


        sb.Append(" WHERE DATE(plo.Updatedate) >= '" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + "' and DATE(plo.Updatedate) <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "'");
        sb.Append(" AND plo.LedgerTransactionNoOLD<>''  ");
        if (txtLabNo.Text.Trim() != "")
        {
            sb.Append(" AND plo.LedgerTransactionNoOLD = '" + txtLabNo.Text.Trim() + "' ");
        }
        else
        {
            sb.Append(" AND lt1.CentreID = '" + ddlcentre.SelectedItem.Value + "' ");
        }
        sb.Append(" )t group by VisitNo,itemid ORDER BY `VisitNo`,Status  ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["ReportName"] = " Audit Trail Report Booking Edit";

                Session["dtExport2Excel"] = dt;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMsg.Text = "!!! No data found ...";

            }
        }
        return "1";
    }



    private string ShowDoctorPanelData()
    {

        StringBuilder sb = new StringBuilder();




        sb.Append("  SELECT 'Current' Status, lt.LedgertransactionNo VisitNo,lt.PName,CONCAT(lt.Age,'/',LEFT(lt.Gender,1)) Age,  ");
        sb.Append("  lt.PanelName PanelName,   ");
        sb.Append("  lt.DoctorName DoctorName,   ");
        sb.Append("    ");
        sb.Append("  lt.UpdateName UserName,  ");
        sb.Append("  DATE_FORMAT(ltupdate.UpdateDate,'%d-%b-%Y %H:%i:%p') UpdateDateTime  FROM f_ledgertransaction lt  ");
        sb.Append("  INNER JOIN " + Util.getApp("LogDataBaseName") + ".f_ledgertransaction_before_update ltupdate ON ltupdate.LedgertransactionNo=lt.LedgertransactionNo   ");
        sb.Append("  where  lt.Date>='" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'     AND lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'   ");
        if (txtLabNo.Text.Trim() != "")
        {
            sb.Append(" AND lt.LedgertransactionNo = '" + txtLabNo.Text.Trim() + "' ");
        }
        else
        {
            sb.Append(" AND lt.CentreID = '" + ddlcentre.SelectedItem.Value + "' ");
        }


        sb.Append("  UNION ALL    ");

        sb.Append("  SELECT  'Old' Status,lt.LedgertransactionNo  VisitNo,lt.PName,CONCAT(lt.Age,'/',LEFT(lt.Gender,1)) Age,  ");
        sb.Append("  lt.PanelName PanelName,   ");
        sb.Append("  lt.DoctorName DoctorName,   ");
        sb.Append("  lt.UpdateName UserName,  ");
        sb.Append("  DATE_FORMAT(lt.UpdateDate,'%d-%b-%Y %H:%i:%p') UpdateDateTime  ");


        sb.Append("  FROM " + Util.getApp("LogDataBaseName") + ".f_ledgertransaction_before_update lt  where lt.Date>='" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'     AND lt.Date<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59'   ");
        if (txtLabNo.Text.Trim() != "")
        {
            sb.Append(" AND lt.LedgertransactionNo = '" + txtLabNo.Text.Trim() + "' ");
        }
        else
        {
            sb.Append(" AND lt.CentreID = '" + ddlcentre.SelectedItem.Value + "' ");
        }


        sb.Append("  ORDER BY VisitNo,UpdateDateTime   ");


        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["ReportName"] = " Audit Trail Report Doctor Edit";

                Session["dtExport2Excel"] = dt;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

            }
            else
            {
                lblMsg.Text = "!!! No data found ...";

            }


            return "1";
        }

    }


    private string LabData()
    {
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT lt.`LedgerTransactionNo` VisitNo,pli.`BarcodeNo` SinNo,lt.`PName`,CONCAT(lt.`Age`,'/',LEFT(lt.`Gender`,1)) Age, ");
            sb.Append(" pli.`InvestigationName`,IF(pli.`Approved`='1','Approved','') STATUS,lm.`Name` LabObservationName ,plo.`Value`, ");
            sb.Append(" DATE_FORMAT(plo.`ResultDateTime`,'%d-%b-%Y %h:%i %p') EntryDateTime,plo.`ResultEnterdByName` UserName ");
            sb.Append(" FROM `patient_labinvestigation_opd` pli ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID` ");
            if (txtLabNo.Text.Trim() != "")
            {
                sb.Append(" AND pli.LedgerTransactionNo = '" + txtLabNo.Text.Trim() + "' ");
            }
            else
            {
                sb.Append(" AND lt.CentreID = '" + ddlcentre.SelectedItem.Value + "' ");
            }



            sb.Append(" INNER JOIN `patient_labobservation_opd_audittrail` plo ON plo.`Test_ID`=pli.`Test_ID` and plo.oldvalue<>'' ");
            sb.Append(" INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=plo.`LabObservation_ID` ");
            sb.Append(" WHERE pli.ResultEnteredDate >= '" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' and  pli.ResultEnteredDate <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");

            sb.Append(" ORDER BY visitno,InvestigationName,lm.`Name`,plo.`ResultEnterdByName` ");





            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            {

                if (dt != null && dt.Rows.Count > 0)
                {
                    Session["ReportName"] = " Audit Trail Report Lab Data ";

                    Session["dtExport2Excel"] = dt;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);

                }
                else
                {
                    lblMsg.Text = " No data Found";

                }
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();
            return "Error";
        }

        return "1";
    }


    private string ReportNotApprovalData()
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT lt.`LedgerTransactionNo` VisitNo,pli.`BarcodeNo` SinNo,lt.`PName`,CONCAT(lt.`Age`,'/',LEFT(lt.`Gender`,1)) Age, ");
            sb.Append(" pli.`InvestigationName`,IF(pli.`Approved`='1','Approved','') CurrentStatus, ");
            sb.Append(" DATE_FORMAT(ru.`UnapproveDate`,'%d-%b-%Y %h:%i %p') NotApprvalDate,ru.Comments NotApprovalComment,ru.`Unapproveby` NotApprovedBy ");
            sb.Append(" FROM `patient_labinvestigation_opd` pli ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=pli.`LedgerTransactionID` ");
            if (txtLabNo.Text.Trim() != "")
            {
                sb.Append(" AND pli.LedgerTransactionNo = '" + txtLabNo.Text.Trim() + "' ");
            }
            else
            {
                sb.Append(" AND lt.CentreID = '" + ddlcentre.SelectedItem.Value + "' ");
            }
            sb.Append(" INNER JOIN `report_unapprove` ru ON ru.`Test_ID`=pli.`Test_ID` ");
            sb.Append(" WHERE ru.UnapproveDate >= '" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + " 00:00:00' and  ru.UnapproveDate <= '" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
            sb.Append(" ORDER BY visitno ");
            using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            {

                if (dt != null && dt.Rows.Count > 0)
                {
                    Session["ReportName"] = " Audit Trail Report Report Not Approved Data ";
                    Session["dtExport2Excel"] = dt;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
                }
                else
                {
                    lblMsg.Text = " No data Found";

                }
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message.ToString();
            return "Error";
        }

        return "1";

    }



    private string ObsRangeData()
    {

        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT  DATE_FORMAT(lr.EntryDateTime,'%d-%b-%Y')EntryDate,EntryBy, (SELECT centre FROM centre_master WHERE centreid=lr.centreid) CentreName, ");
            sb.Append(" (SELECT IF(NAME='----------','',NAME) FROM macmaster WHERE id=lr.`MacID`) Machine, ");
            sb.Append(" im.Name TestName,lm.`Name` ObservationName,lr.`FromAge`,lr.`ToAge`,lr.`Gender`,lr.`MinReading`,lr.`MaxReading`,lr.`ReadingFormat` ");
            sb.Append(" ,lr.`MinCritical`,lr.`MaxCritical`,lr.`AMRMin`,lr.`AMRMax`,lr.`reflexmin`,lr.`reflexmax`,lr.`MethodName` ");

            sb.Append("  FROM log_labobservation_range lr  ");
            sb.Append(" INNER JOIN investigation_master im ON lr.investigation_id=im.investigation_id ");
            sb.Append(" INNER JOIN `labobservation_master` lm ON lm.`LabObservation_ID`=lr.`LabObservation_ID` WHERE");
            sb.Append("  centreid='" + ddlcentre.SelectedItem.Value + "' AND DATE(lr.`EntryDateTime`)>='" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + "'");
            sb.Append("  AND DATE(lr.`EntryDateTime`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append("  ORDER BY lr.EntryDateTime,testname,observationname  ");





            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["ReportName"] = " Audit Trail Report LabObservation Range ";

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
            return "Error";
        }

        return "1";



    }


    private string RateData()
    {

        try
        {
            StringBuilder sb = new StringBuilder();


            sb.Append(" SELECT DATE_FORMAT(entrydatetime,'%d-%b-%Y')EntryDate, ");
            sb.Append(" (SELECT NAME FROM employee_master WHERE employee_id=entryby) UserName, ");
            sb.Append(" pm.company_name RateType,im.typename Testname,fr.Rate ");
            sb.Append(" FROM log_f_ratelist fr ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.itemid=fr.itemid ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.panel_id=fr.panel_id ");
            sb.Append(" INNER JOIN Centre_Panel cp ON cp.PanelId=pm.panel_id AND cp.CentreId='" + ddlcentre.SelectedItem.Value + "' ");
            sb.Append("  where DATE(fr.`entrydatetime`)>='" + Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd") + "'");
            sb.Append("  AND DATE(fr.`entrydatetime`)<='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + "' ");
            sb.Append(" ORDER BY entrydatetime,company_name ,typename ");






            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt != null && dt.Rows.Count > 0)
            {
                Session["ReportName"] = " Audit Trail Report Test Rate";

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
            return "Error";
        }

        return "1";



    }



}