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
using MySql.Data.MySqlClient;



public partial class Design_EDP_LogReport : System.Web.UI.Page
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
            txtDate.SetCurrentDate();
            txtDate0.SetCurrentDate();
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
           ddlcenter.DataSource= MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT cm.centreID,Centre FROM centre_master cm INNER JOIN f_login fl ON cm.`CentreID`=fl.`CentreID` AND fl.`EmployeeID`=@EmployeeID AND fl.Active=1 AND cm.isActive=1 ORDER BY Centre ",
  new MySqlParameter("@EmployeeID", UserInfo.ID)); // StockReports.GetDataTable(Util.GetCentreAccessQuery());
            ddlcenter.DataTextField = "Centre";
            ddlcenter.DataValueField = "CentreID";
            ddlcenter.DataBind();
            con.Close();
            ListItem li = new ListItem();
            li.Text = "ALL";
            li.Value = "ALL";
            ddlcenter.Items.Add(li);
           // ddlcenter.SelectedIndex = ddlcenter.Items.IndexOf(ddlcenter.Items.FindByValue(Session["CentreId"].ToString()));

        }
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        TimeSpan ts = System.DateTime.Now - Util.GetDateTime(txtDate.GetDateForDisplay());
        if (rbtnSelect.SelectedItem.Value == "0")
        {
            ChangePanel();
        }
        else if (rbtnSelect.SelectedItem.Value == "1")
        {
            ChangeDoctor();
        }
        else if (rbtnSelect.SelectedItem.Value == "2")
        {
            ChangeDemographic();
        }
        else if (rbtnSelect.SelectedItem.Value == "3")
        {
            SettlementData();
        }
        else if (rbtnSelect.SelectedItem.Value == "4")
        {

            SMSData();
        }
        else if (rbtnSelect.SelectedItem.Value == "5")
        {

            PathologyData();
        }
        else if (rbtnSelect.SelectedItem.Value == "7")
        {

            printlabreportlog();
        }
        else if (rbtnSelect.SelectedItem.Value == "8")
        {
            ChangeBarcode();
        }
        else if (rbtnSelect.SelectedItem.Value == "9")
        {
            AutoEmailSummary();
        }
        else if (rbtnSelect.SelectedItem.Value == "10")
        {
            RateChangeLog();
        }
        else if (rbtnSelect.SelectedItem.Value == "11")
        {

            ResampleBooking();
        }
        else if (rbtnSelect.SelectedItem.Value == "12")
        {
            ChequeTransactionDetail();
        }
        else if (rbtnSelect.SelectedValue == "13")
        {
            ChangeStatus();
        }
        else if (rbtnSelect.SelectedValue == "14")
        {
            LockInterpretation();
        }
        else if (rbtnSelect.SelectedValue == "15")
        {
            ReferangeReport();
        }
        else if (rbtnSelect.SelectedValue == "16")
        {
            SampleBooking();
        }
        else if (rbtnSelect.SelectedValue == "17")
        {
            LockUnlockClient();
        }
        else if (rbtnSelect.SelectedValue == "18")
        {
            Doctor_Master();
        }
        else if (rbtnSelect.SelectedValue == "19")
        {
            Panel_Master();
        }
        else if (rbtnSelect.SelectedValue == "20")
        {
            Employee_Master();
        }
        else if (rbtnSelect.SelectedValue == "21")
        {
            Investigation_Master();
        }
        else if (rbtnSelect.SelectedValue == "23")
        {
            AccessionRemarkLogreport();
        }
    }

    private string ChangeDemographic()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lt.`LedgerTransactionNo` LabNo,CONCAT(pm.`Title`,' ',pm.`PName`) PName,");
        sb.Append(" plous.`status` Status,plous.`OLDNAME`,plous.`NEWNAME`,cm.`Centre`,rm.`RoleName`,plous.`UserName` ActionBy,");
        sb.Append(" DATE_FORMAT(plous.`dtEntry`,'%d-%b-%Y %r') ActionDate, ");
        sb.Append(" (SELECT `Name` FROM Employee_master WHERE Employee_ID=lt.Creator_UserID) Registration_By,DATE_FORMAT(lt.`Date`,'%d-%b-%Y %H:%i %p') Ragistration_Date  ");
        sb.Append(" FROM patient_labinvestigation_opd_update_status plous");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo`");
       // sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.`Transaction_ID`=lt.`Transaction_ID`");
        sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`");
        sb.Append(" INNER JOIN f_rolemaster rm ON rm.`ID`=plous.`RoleID`");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=plous.`CentreID`");
        sb.Append(" WHERE IFNULL(plous.Test_ID,'')='' and plous.`dtEntry`>='" + txtDate.GetDateForDataBase() + " 00:00:00' AND plous.`dtEntry`<='" + txtDate0.GetDateForDataBase() + " 23:59:59'");
        if (txtLabNo.Text.ToString() != "")
        {
            sb.Append("  AND plous.LedgerTransactionNo='" + txtLabNo.Text.ToString() + "' ");
        }
        if (ddlcenter.SelectedItem.Value != "ALL")
        {
            sb.Append("  AND plous.CentreID='" + ddlcenter.SelectedItem.Value + "' ");
        }
        sb.Append("  AND plous.STATUS IN ('Change PName','Change Age','Change Gender','Change Mobile') ORDER BY plous.`dtEntry` desc ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "Log Report";
            Session["Period"] = "Period From : " + txtDate.GetDateForDisplay() + " To : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "!!! No data found ...";
        }
        return "1";
    }

    private void PanelMaster_Log()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(@" SELECT mus.MasterID,mus.MasterIDName,mus.Status ,mus.OLDName,mus.NewName,mus.UserName,
                     DATE_FORMAT(mus.dtEntry,'%d-%b-%Y %r') dtEntry,rm.RoleName,cm.`Centre`
                     FROM `master_update_status` mus
                     INNER JOIN f_rolemaster rm ON rm.ID=mus.`RoleID`
                     INNER JOIN Centre_master cm ON cm.`CentreID`=mus.`CentreID`
                     WHERE mus.MasterName='Panel Master' AND STATUS NOT IN ('Change UpdateName','Change UpdateRemarks','Change UpdateID','Change CentreID_Print')
                     AND mus.`dtEntry`>='" + txtDate.GetDateForDataBase() + " 00:00:00' AND mus.`dtEntry`<='" + txtDate0.GetDateForDataBase() + " 23:59:59' ");

        if (ddlcenter.SelectedItem.Text != "" && ddlcenter.SelectedItem.Text != "0" && ddlcenter.SelectedItem.Text != "ALL")
        {
            sb.Append(" AND cm.CentreID = '" + ddlcenter.SelectedItem.Value + "' ");
        }
        sb.Append(" ORDER BY dtEntry DESC ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "Panel Master Log Report";
            Session["Period"] = "From Date : " + txtDate.GetDateForDisplay() + ", To Date : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }

    }


    private void Investigation_Master()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT mum.`MasterID`,mum.MasterIDName,mum.`Status`,mum.`OLDName`,mum.`NewName`,mum.`UserName` ActionBy,  ");
        sb.Append("  DATE_FORMAT(mum.`dtEntry`,'%d-%b-%Y %I:%i%p') ActionDateTime,rm.`RoleName`,cm.`Centre`,mum.`IpAddress` FROM master_update_status mum  ");
        sb.Append("  INNER JOIN f_rolemaster rm ON rm.ID=mum.`RoleID`  ");
        if (Util.GetString(txtLabNo.Text).Trim() != "")
        {
            sb.Append(" and (mum.MasterID='" + txtLabNo.Text.Trim() + "' or mum.MasterIDName Like '" + txtLabNo.Text.Trim() + "') ");
        }
        sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=mum.`CentreID`  ");
        sb.Append("  WHERE mum.`Status` NOT LIKE '%UpdateDate%' AND mum.`MasterName`='Investigation Master'  ");
        sb.Append(" and mum.`dtEntry`>='" + txtDate.GetDateForDataBase() + " 00:00:00'  and mum.`dtEntry`<='" + txtDate0.GetDateForDataBase() + " 23:59:59' ");
        sb.Append("  ORDER BY mum.ID+1 DESC;  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = " Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "Investigation Master Report";
            Session["Period"] = "From Date : " + txtDate.GetDateForDisplay() + ", To Date : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
    }

    private void Employee_Master()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT mum.`MasterID`,mum.MasterIDName,mum.`Status`,mum.`OLDName`,mum.`NewName`,mum.`UserName` ActionBy,  ");
        sb.Append("  DATE_FORMAT(mum.`dtEntry`,'%d-%b-%Y %I:%i%p') ActionDateTime,rm.`RoleName`,cm.`Centre`,mum.`IpAddress` FROM master_update_status mum  ");
        sb.Append("  INNER JOIN f_rolemaster rm ON rm.ID=mum.`RoleID`  ");
        if (Util.GetString(txtLabNo.Text).Trim() != "")
        {
            sb.Append(" and (mum.MasterID='" + txtLabNo.Text.Trim() + "' or mum.MasterIDName Like '" + txtLabNo.Text.Trim() + "') ");
        }
        sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=mum.`CentreID`  ");
        sb.Append("  WHERE mum.`Status` NOT LIKE '%UpdateDate%' AND mum.`MasterName`='Employee Master' and mum.Status NOT IN ('Change DOB','Change StartDate','Change UpdateDate')  ");
        sb.Append(" and mum.`dtEntry`>='" + txtDate.GetDateForDataBase() + " 00:00:00'  and mum.`dtEntry`<='" + txtDate0.GetDateForDataBase() + " 23:59:59' ");
        sb.Append("  ORDER BY mum.ID+1 DESC;  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "Employee Master Report";
            Session["Period"] = "From Date : " + txtDate.GetDateForDisplay() + ", To Date : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
    }

    private void Panel_Master()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT mum.`MasterID`,mum.MasterIDName,mum.`Status`,mum.`OLDName`,mum.`NewName`,mum.`UserName` ActionBy,  ");
        sb.Append("  DATE_FORMAT(mum.`dtEntry`,'%d-%b-%Y %I:%i%p') ActionDateTime,rm.`RoleName`,cm.`Centre`,mum.`IpAddress` FROM master_update_status mum  ");
        sb.Append("  INNER JOIN f_rolemaster rm ON rm.ID=mum.`RoleID`  ");
        if (Util.GetString(txtLabNo.Text).Trim() != "")
        {
            sb.Append(" and (mum.MasterID='" + txtLabNo.Text.Trim() + "' or mum.MasterIDName Like '" + txtLabNo.Text.Trim() + "') ");
        }
        sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=mum.`CentreID`  ");
        sb.Append("  WHERE mum.`Status` NOT LIKE '%UpdateDate%' AND mum.`MasterName`='Panel Master'  ");
        sb.Append(" and mum.`dtEntry`>='" + txtDate.GetDateForDataBase() + " 00:00:00'  and mum.`dtEntry`<='" + txtDate0.GetDateForDataBase() + " 23:59:59' ");
        sb.Append("  ORDER BY mum.ID+1 DESC;  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = " Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "Panel Master Report";
            Session["Period"] = "From Date : " + txtDate.GetDateForDisplay() + ", To Date : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
    }

    private void Doctor_Master()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT mum.`MasterID`,mum.MasterIDName,mum.`Status`,mum.`OLDName`,mum.`NewName`,mum.`UserName` ActionBy,  ");
        sb.Append("  DATE_FORMAT(mum.`dtEntry`,'%d-%b-%Y %I:%i%p') ActionDateTime,rm.`RoleName`,cm.`Centre`,mum.`IpAddress` FROM master_update_status mum  ");
        sb.Append("  INNER JOIN f_rolemaster rm ON rm.ID=mum.`RoleID`  ");
        if (Util.GetString(txtLabNo.Text).Trim() != "")
        {
            sb.Append(" and (mum.MasterID='" + txtLabNo.Text.Trim() + "' or mum.MasterIDName Like '" + txtLabNo.Text.Trim() + "') ");
        }
        sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=mum.`CentreID`  ");
        sb.Append("  WHERE mum.`Status` NOT LIKE '%UpdateDate%' AND mum.`MasterName`='Doctor Master'  ");
        sb.Append(" and mum.`dtEntry`>='" + txtDate.GetDateForDataBase() + " 00:00:00'  and mum.`dtEntry`<='" + txtDate0.GetDateForDataBase() + " 23:59:59' ");
        sb.Append("  ORDER BY mum.ID+1 DESC;  ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "Doctor Master Report";
            Session["Period"] = "From Date : " + txtDate.GetDateForDisplay() + ", To Date : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
    }

    private string RateChangeLog()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.* FROM (SELECT ");
        sb.Append(" 'Current' STATUS,r1.`ItemID`,im.typename ItemName,r1.`Panel_ID`,fpm.company_name PanelName,r1.`Rate`, ");
        sb.Append(" r1.`UpdateBy` ActivityBy,  ");
        sb.Append(" r1.`UpdateDate` `ActivityDateTime` ");
        sb.Append(" FROM f_ratelist r1 ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=r1.`Panel_ID` ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.itemid=r1.itemid ");
        sb.Append(" INNER JOIN " + Util.getApp("LogDatabaseName") + ".`f_ratelist_before_delete` r2 ON r1.`ItemID`=r2.`ItemID` AND r1.`Panel_ID`=r2.`Panel_ID`  ");
        sb.Append(" WHERE r2.`DeleteDateTime`>='" + txtDate.GetDateForDataBase() + " 00:00:00' ");
        sb.Append(" and r2.`DeleteDateTime`<='" + txtDate0.GetDateForDataBase() + " 23:59:59' ");
        sb.Append(" GROUP BY r1.`ItemID`,r1.`Panel_ID` ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT  ");
        sb.Append(" 'OLD' STATUS,r2.`ItemID`,im.typename ItemName,r2.`Panel_ID`,fpm.company_name PanelName,r2.`Rate`, ");
        sb.Append(" r2.`DeletedBy` ActivityBy,  ");
        sb.Append(" r2.`DeleteDateTime` `ActivityDateTime` ");
        sb.Append(" FROM  " + Util.getApp("LogDatabaseName") + ".`f_ratelist_before_delete` r2 ");
        sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=r2.`Panel_ID` ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.itemid=r2.itemid ");
        sb.Append(" WHERE r2.`DeleteDateTime`>='" + txtDate.GetDateForDataBase() + " 00:00:00' ");
        sb.Append(" and r2.`DeleteDateTime`<='" + txtDate0.GetDateForDataBase() + " 23:59:59' ");
        sb.Append(" ) t ORDER BY t.ItemName,t.Status,t.PanelName; ");
        // System.IO.File.AppendAllText("C://abc.txt",sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "Rate Change Log Report";
            Session["Period"] = "From Date : " + txtDate.GetDateForDisplay() + ", To Date : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
        return "1";
    }
    private string SMSData()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Mobile_No AS MobileNo,SMS_Text AS SMS,IF(IsSend='0','No','Yes') STATUS,   ");
        sb.Append(" (SELECT CONCAT(Title,'',NAME) FROM employee_master WHERE Employee_ID=UserID) AS UserName,UserID,   ");
        sb.Append(" DATE_FORMAT(EntDate,'%d-%b-%y %I:%h %p') AS EntryDate   ");
        sb.Append(" FROM sms WHERE Mobile_No<>0 and EntDate>='" + txtDate.GetDateForDataBase() + " 00:00:00' and EntDate<='" + txtDate0.GetDateForDataBase() + " 23:59:59'   ");
        if (Util.GetString(txtLabNo.Text).Trim() != "")
        {
            sb.Append(" and MOBILE_NO='" + txtLabNo.Text.Trim() + "' ");
        }
        sb.Append(" ORDER BY SMS_ID DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = " SMS Log Report";
            Session["Period"] = "From Date : " + txtDate.GetDateForDisplay() + ", To Date : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
        return "1";
    }

    private string PathologyData()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(pm.title,' ',pm.pname) PName,plo.`LedgerTransactionNo` as LabNo,im.Name as Investigation,   ");
        sb.Append(" (SELECT CONCAT(em.Title,' ',em.Name) FROM employee_master em WHERE Employee_ID=er.EmployeeID) UserName,er.`EmployeeID` AS UserID,   ");
        sb.Append(" DATE_FORMAT(er.dtEntry,'%d-%b-%Y %I:%h %p') AS EntryDate,DATE_FORMAT(er.`dtSent`,'%d-%b-%Y %I:%h %p') AS SentDate,er.`EmailAddress` AS EmailID,  er.enterby SentBy,  ");

        sb.Append(" IF( amtcredit=0,IF(Adjustment  = NetAmount ,'Fully Paid',CONCAT('Due Amount is Rs ',(NetAmount - Adjustment))),'Credit Patient' )AS  Remarks, ");
        sb.Append(" IF(er.`isSent`=1,'Sent','Not Sent') STATUS FROM `email_record` er    ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`Test_ID`=er.`Test_ID`   ");

        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plo.LedgerTransactionNo    ");

        sb.Append(" INNER JOIN investigation_master im ON im.`Investigation_Id`=plo.`Investigation_ID` ");
        sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=plo.`Patient_ID` where ");
        sb.Append(" er.dtEntry>='" + txtDate.GetDateForDataBase() + " 00:00:00' and er.dtEntry<='" + txtDate0.GetDateForDataBase() + " 23:59:59'  ");


        if (txtLabNo.Text.Trim() != "")
        {
            sb.Append(" and plo.`LedgerTransactionNo`='" + txtLabNo.Text.Trim() + "' ");
        }
        if (ddlcenter.SelectedItem.Text != "" && ddlcenter.SelectedItem.Text != "ALL")
        {
            sb.Append(" AND lt.CentreID = '" + ddlcenter.SelectedItem.Value + "' ");
        }
        sb.Append("   order by er.dtEntry desc");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = " Pathology Emailing Log Report";
            Session["Period"] = "From Date : " + txtDate.GetDateForDisplay() + ", To Date : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
        return "1";

    }

    public string SettlementData()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT r.LedgerTransactionNo LabNo,IF(r.LedgerNoCr='OPD003',lt.NetAmount,'')NetAmount, r.ReceiptNo,(CASE WHEN  r.LedgerNoCr = 'OPD003' AND r.Amount >= 0  THEN 'Booikng' WHEN  r.LedgerNoCr != 'OPD003'  AND  r.Amount >= 0  THEN 'Settlement'     WHEN  r.Amount < 0  THEN 'Refund'   END) STATUS  , ");
        sb.Append("  r.Amount AmountPaid,r.Discount,DATE_FORMAT(CONCAT(r.Date ,' ',r.Time),'%d-%b-%y %h:%i:%s %p')EntryDate,IF(r.Reciever<>'',em2.Name,'')Reciever,r.IsCheque_Draft PaymentMode, ");
        sb.Append("  IF(r.IsCancel=1,'Cancelled','')IsCancel,IF(r.CancelDate='0001-01-01 00:00:00','',DATE_FORMAT(r.CancelDate,'%d-%b-%y %h:%i:%p'))CancelDate, ");
        sb.Append("  IF(r.Cancel_UserID<>'',em.Name,'')CancelBy,IFNULL(r.CancelReason,'')CancelReason, ");
        sb.Append("  IFNULL(r.UpdateRemarks,'')UpdateRemarks ");
        sb.Append("  FROM  f_receipt r  ");
        sb.Append("  INNER JOIN centre_master cm ON cm.CentreID=r.CentreID ");
        sb.Append("  INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=r.LedgerTransactionNo ");
        if (txtLabNo.Text.Trim() != "")
        {
            sb.Append(" AND lt.LedgertransactionNo = '" + txtLabNo.Text.Trim() + "' ");
        }
        if (ddlcenter.SelectedItem.Text != "" && ddlcenter.SelectedItem.Text != "ALL")
        {
            sb.Append(" AND lt.CentreID = '" + ddlcenter.SelectedItem.Value + "' ");
        }
        sb.Append("   AND DATE(r.Date)>='" + txtDate.GetDateForDataBase() + "' and  DATE(r.Date)<='" + txtDate0.GetDateForDataBase() + "' ");
        sb.Append("  LEFT JOIN employee_master em ON em.Employee_ID=r.Cancel_UserID ");
        sb.Append("  INNER JOIN employee_master em2 ON em2.Employee_ID=r.Reciever ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = " Transaction log Of Settlement Data ";
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "!!! No data found ...";
        }
        return "1";

    }



    public string printlabreportlog()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT  a.`LedgerTransactionNo` as LabNo,concat(pm.title,'' ,pm.pname) PatientName,a.`TestID`,`InvestigationName` as TestName,a.`PrintedByName` as PrintByUser,DATE_FORMAT(a.PrintedDate, '%d-%b-%Y %I:%i%p') PrintDateTime, a.`ipAddress`,'1' PrintCount,a.Remarks ");
        sb.Append("  FROM patientreport_printout a  ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo= a.`LedgerTransactionNo` ");
        sb.Append(" INNER JOIN patient_master pm ON pm.patient_id= lt.patient_id  ");
        sb.Append("  where PrintedDate>='" + txtDate.GetDateForDataBase() + " 00:00:00' AND PrintedDate<='" + txtDate0.GetDateForDataBase() + " 23:59:59' ");
        if (txtLabNo.Text.ToString() != "")
        {
            sb.Append("  AND a.`LedgerTransactionNo`='" + txtLabNo.Text.ToString() + "' ");
        }
        sb.Append("  ORDER BY   a.`LedgerTransactionNo` ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = " Print Lab Report Log ";
            Session["Period"] = "Period From : " + txtDate.GetDateForDisplay() + " To : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "!!! No data found ...";
        }
        return "1";

    }

    private string ChangeBarcode()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT LedgertransactionNo `Lab No`,OLDID `OLD Barcode`,NEWID `New Barcode`,UserName,DATE_FORMAT(dtEntry,'%d-%b-%Y %I:%i %p') `Date Time`,IpAddress FROM patient_labinvestigation_opd_update_status WHERE STATUS='Change Barcode'  ");
        sb.Append(" AND  dtEntry>='" + txtDate.GetDateForDataBase() + " 00:00:00' and dtEntry<='" + txtDate0.GetDateForDataBase() + " 23:59:59'  ");
        if (Util.GetString(txtLabNo.Text).Trim() != "")
        {
            sb.Append(" and LedgertransactionNo='" + txtLabNo.Text.Trim() + "' ");
        }
        sb.Append("   ORDER BY dtEntry DESC; ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = " Change Barcode";
            Session["Period"] = txtDate.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
        return "1";
    }

    private string AutoEmailSummary()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select DATE_format(dtEntry,'%d-%b-%Y') RequestDate, ");
        sb.Append(" sum(if(EnterBy='AutoMailSender','1','0')) `Requested`, ");
        sb.Append(" SUM(IF(isSent='1','1','0')) `Sent`, ");
        sb.Append(" SUM(IF(isSent='0','1','0')) `Not Sent`, ");
        sb.Append(" SUM(IF(isSent='-1','1','0')) `Failure`, ");
        sb.Append(" SUM(IF(isSent<>'-1' AND isSent<>'1' AND isSent<>'0','1','0')) `Unknown` ");
        sb.Append(" FROM email_record WHERE EnterBy='AutoMailSender' ");
        sb.Append(" AND  dtEntry>='" + txtDate.GetDateForDataBase() + " 00:00:00' and dtEntry<='" + txtDate0.GetDateForDataBase() + " 23:59:59'  ");
        sb.Append(" GROUP BY DATE(dtEntry) ORDER BY dtEntry DESC; ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = " Auto Email Summary";
            Session["Period"] = txtDate.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
        return "1";
    }

    private string ResampleBooking()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lt.`LedgerTransactionNo` Old_Lab_No,lt.AgainstPONo New_Lab_No, ");
        sb.Append(" (SELECT NAME FROM employee_master WHERE Employee_ID=lt.ReSampleBookingApprovedBy LIMIT 1) AS `Approved By`, ");
        sb.Append("  CONCAT(pm.Title, ' ', pm.PName) Patient_Name, CONCAT(pm.Age, LEFT(pm.Gender, 1)) Age_Gender, ");
        sb.Append(" im.`TypeName` ItemName,inv.`Name` Investigation  ");
        sb.Append(" FROM `f_ledgertransaction` lt  ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionNo` = lt.`LedgerTransactionNo`  ");
       // sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID = lt.Transaction_ID ");
        sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID = lt.Patient_ID ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID` = plo.`ItemID`  ");
        sb.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id` = plo.`Investigation_ID`  ");
        sb.Append(" WHERE lt.AgainstPONo<>'' ");

        if (txtLabNo.Text.Trim() != "")
        {
            sb.Append(" AND lt.LedgertransactionNo = '" + txtLabNo.Text.Trim() + "' ");
        }
        if (ddlcenter.SelectedItem.Text != "" && ddlcenter.SelectedItem.Value != "ALL")
        {
            sb.Append(" AND lt.CentreID = '" + ddlcenter.SelectedItem.Value + "' ");
        }
        sb.Append(" AND lt.Date>='" + txtDate.GetDateForDataBase() + " 00:00:00'     AND lt.Date>='" + txtDate0.GetDateForDataBase() + " 23:59:59' ");
        sb.Append("ORDER BY plo.`LedgerTransactionNo`; ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt != null && dt.Rows.Count > 0)
        {
            Session["ReportName"] = " Auto Email Summary";
            Session["ReportName"] = " Resample Booking";
            Session["Period"] = txtDate.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
        return "1";
    }

    private string ChequeTransactionDetail()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT r.`AsainstLedgerTnxNo` LabNo,r.`AmountPaid`,IF(r.`AmountPaid`>0,'Settlement','Refund') ReceiptType,");
        sb.Append("(SELECT CONCAT(Title,NAME) FROM employee_master em1 WHERE em1.employee_id=r.`Reciever`) UserName,DATE_FORMAT(r.`Date`,'%d-%b-%Y %I-%i %p') ReceiptDate,");
        sb.Append(" r.ChequebankName,r.ChequeNo, ");
        sb.Append("  IF(r.IsCancel=1,'In-Active','Active') Status,r.Naration,IFNULL(r.CancelReason,'') CancelReason,");
        sb.Append(" IFNULL((SELECT CONCAT(Title,NAME) FROM employee_master em1 WHERE em1.employee_id=r.Cancel_UserID ),'') CancelBy ");
        sb.Append(" FROM f_receipt r ");
        sb.Append(" WHERE r.AmtCheque<>0 and r.Date>= '" + txtDate.GetDateForDataBase() + "' and  r.Date<= '" + txtDate0.GetDateForDataBase() + "'");
        if (txtLabNo.Text.Trim() != "")
        {
            sb.Append("  and  r.`AsainstLedgerTnxNo`='" + txtLabNo.Text.Trim() + "' ");
        }
        sb.Append(" ORDER BY r.date");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            Session["ReportName"] = " Auto Email Summary";
            Session["ReportName"] = "Cheque Transaction Detail";
            Session["Period"] = "From Date " + txtDate.GetDateForDisplay() + "To Date :" + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
        return "1";
    }
    private string ChangePanel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lt.`LedgerTransactionNo` LabNo,CONCAT(pm.`Title`,' ',pm.`PName`) PName,");
        sb.Append(" plous.`status` Status,plous.`OLDID`,plous.`OLDNAME`,plous.`NEWID`,plous.`NEWNAME`,");
        sb.Append(" cm.`Centre`,rm.`RoleName`,plous.`UserName` ActionBy,");
        sb.Append(" DATE_FORMAT(plous.`dtEntry`,'%d-%b-%Y %r') ActionDate, ");
        sb.Append(" (SELECT `Name` FROM Employee_master WHERE Employee_ID=lt.Creator_UserID) Registration_By,DATE_FORMAT(lt.`Date`,'%d-%b-%Y %r') Registration_Date,plous.Remarks ");
        sb.Append(" FROM patient_labinvestigation_opd_update_status plous");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo` and plous.Status in ('Change Panel','Bulk Change Panel') ");
        //sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.`Transaction_ID`=lt.`Transaction_ID`");
        sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`");
        sb.Append(" INNER JOIN f_rolemaster rm ON rm.`ID`=plous.`RoleID`");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=plous.`CentreID`");
        sb.Append(" WHERE IFNULL(plous.Test_ID,'')='' and plous.`dtEntry`>='" + txtDate.GetDateForDataBase() + " 00:00:00' AND plous.`dtEntry`<='" + txtDate0.GetDateForDataBase() + " 23:59:59'");
        if (txtLabNo.Text.ToString() != "")
        {
            sb.Append("  AND plous.LedgerTransactionNo='" + txtLabNo.Text.ToString() + "' ");
        }
        if (ddlcenter.SelectedItem.Value != "ALL")
        {
            sb.Append("  AND plous.CentreID='" + ddlcenter.SelectedItem.Value + "' ");
        }
        sb.Append("  ORDER BY plous.`dtEntry` desc ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "Change Panel Log Report";
            Session["Period"] = "Period From : " + txtDate.GetDateForDisplay() + " To : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "!!! No data found ...";
        }
        return "1";
    }



    private string ChangeDoctor()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lt.`LedgerTransactionNo` LabNo,CONCAT(pm.`Title`,' ',pm.`PName`) PName,");
        sb.Append(" plous.`status` Status,plous.`OLDID`,plous.`OLDNAME`,plous.`NEWID`,plous.`NEWNAME`,");
        sb.Append(" cm.`Centre`,rm.`RoleName`,plous.`UserName` ActionBy,");
        sb.Append(" DATE_FORMAT(plous.`dtEntry`,'%d-%b-%Y %r') ActionDate, ");
        sb.Append(" (SELECT `Name` FROM Employee_master WHERE Employee_ID=lt.Creator_UserID) Registration_By,DATE_FORMAT(lt.`Date`,'%d-%b-%Y %r') Registration_Date  ");
        sb.Append(" FROM patient_labinvestigation_opd_update_status plous");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo` and plous.Status='Change ReferedBy' ");
       // sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.`Transaction_ID`=lt.`Transaction_ID`");
        sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`");
        sb.Append(" INNER JOIN f_rolemaster rm ON rm.`ID`=plous.`RoleID`");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=plous.`CentreID`");
        sb.Append(" WHERE IFNULL(plous.Test_ID,'')='' and plous.`dtEntry`>='" + txtDate.GetDateForDataBase() + " 00:00:00' AND plous.`dtEntry`<='" + txtDate0.GetDateForDataBase() + " 23:59:59'");
        if (txtLabNo.Text.ToString() != "")
        {
            sb.Append("  AND plous.LedgerTransactionNo='" + txtLabNo.Text.ToString() + "' ");
        }
        if (ddlcenter.SelectedItem.Value != "ALL")
        {
            sb.Append("  AND plous.CentreID='" + ddlcenter.SelectedItem.Value + "' ");
        }
        sb.Append("  ORDER BY plous.`dtEntry` desc ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "Change Doctor Log Report";
            Session["Period"] = "Period From : " + txtDate.GetDateForDisplay() + " To : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "!!! No data found ...";
        }
        return "1";
    }

    private string ChangeStatus()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lt.`LedgerTransactionNo` LabNo,CONCAT(pm.`Title`,' ',pm.`PName`) PName,");
        sb.Append(" plous.`status` Status,plous.`OLDNAME`,plous.`NEWNAME`,cm.`Centre`,rm.`RoleName`,plous.`UserName` ActionBy,");
        sb.Append(" DATE_FORMAT(plous.`dtEntry`,'%d-%b-%Y %r') ActionDate, ");
        sb.Append(" (SELECT `Name` FROM Employee_master WHERE Employee_ID=lt.Creator_UserID) Registration_By,DATE_FORMAT(lt.`Date`,'%d-%b-%Y %r') Registration_Date  ");
        sb.Append(" FROM patient_labinvestigation_opd_update_status plous");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plous.`LedgerTransactionNo`");
      //  sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.`Transaction_ID`=lt.`Transaction_ID`");
        sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`");
        sb.Append(" INNER JOIN f_rolemaster rm ON rm.`ID`=plous.`RoleID`");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=plous.`CentreID`");
        sb.Append(" WHERE IFNULL(plous.Test_ID,'')='' and plous.`dtEntry`>='" + txtDate.GetDateForDataBase() + " 00:00:00' AND plous.`dtEntry`<='" + txtDate0.GetDateForDataBase() + " 23:59:59'");
        if (txtLabNo.Text.ToString() != "")
        {
            sb.Append("  AND plous.LedgerTransactionNo='" + txtLabNo.Text.ToString() + "' ");
        }
        if (ddlcenter.SelectedItem.Value != "ALL")
        {
            sb.Append("  AND plous.CentreID='" + ddlcenter.SelectedItem.Value + "' ");
        }
        sb.Append("  AND plous.STATUS IN ('Change Panel','Bulk Change Panel') ");
        sb.Append(" ORDER BY plous.`dtEntry` desc ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "Log Report";
            Session["Period"] = "Period From : " + txtDate.GetDateForDisplay() + " To : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "!!! No data found ...";
        }
        return "1";
    }
    public string StripHTML(string source)
    {
        try
        {
            string result;

            // Remove HTML Development formatting
            // Replace line breaks with space
            // because browsers inserts space
            result = source.Replace("\r", " ");
            // Replace line breaks with space
            // because browsers inserts space
            result = result.Replace("\n", " ");
            // Remove step-formatting
            result = result.Replace("\t", string.Empty);
            // Remove repeating spaces because browsers ignore them
            result = System.Text.RegularExpressions.Regex.Replace(result,
                                                                  @"( )+", " ");

            // Remove the header (prepare first by clearing attributes)
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*head([^>])*>", "<head>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"(<( )*(/)( )*head( )*>)", "</head>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(<head>).*(</head>)", string.Empty,
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // remove all scripts (prepare first by clearing attributes)
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*script([^>])*>", "<script>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"(<( )*(/)( )*script( )*>)", "</script>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            //result = System.Text.RegularExpressions.Regex.Replace(result,
            //         @"(<script>)([^(<script>\.</script>)])*(</script>)",
            //         string.Empty,
            //         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"(<script>).*(</script>)", string.Empty,
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // remove all styles (prepare first by clearing attributes)
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*style([^>])*>", "<style>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"(<( )*(/)( )*style( )*>)", "</style>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(<style>).*(</style>)", string.Empty,
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // insert tabs in spaces of <td> tags
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*td([^>])*>", "\t",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // insert line breaks in places of <BR> and <LI> tags
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*br( )*>", "\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*li( )*>", "\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // insert line paragraphs (double line breaks) in place
            // if <P>, <DIV> and <TR> tags
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*div([^>])*>", "\r\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*tr([^>])*>", "\r\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*p([^>])*>", "\r\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // Remove remaining tags like <a>, links, images,
            // comments etc - anything that's enclosed inside < >
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<[^>]*>", string.Empty,
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // replace special characters:
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @" ", " ",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&bull;", " * ",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&lsaquo;", "<",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&rsaquo;", ">",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&trade;", "(tm)",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&frasl;", "/",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&lt;", "<",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&gt;", ">",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&copy;", "(c)",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&reg;", "(r)",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            // Remove all others. More can be added, see
            // http://hotwired.lycos.com/webmonkey/reference/special_characters/
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&(.{2,6});", string.Empty,
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // for testing
            //System.Text.RegularExpressions.Regex.Replace(result,
            //       this.txtRegex.Text,string.Empty,
            //       System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // make line breaking consistent
            result = result.Replace("\n", "\r");

            // Remove extra line breaks and tabs:
            // replace over 2 breaks with 2 and over 4 tabs with 4.
            // Prepare first to remove any whitespaces in between
            // the escaped characters and remove redundant tabs in between line breaks
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\r)( )+(\r)", "\r\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\t)( )+(\t)", "\t\t",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\t)( )+(\r)", "\t\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\r)( )+(\t)", "\r\t",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            // Remove redundant tabs
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\r)(\t)+(\r)", "\r\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            // Remove multiple tabs following a line break with just one tab
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\r)(\t)+", "\r\t",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            // Initial replacement target string for line breaks
            string breaks = "\r\r\r";
            // Initial replacement target string for tabs
            string tabs = "\t\t\t\t\t";
            for (int index = 0; index < result.Length; index++)
            {
                result = result.Replace(breaks, "\r\r");
                result = result.Replace(tabs, "\t\t\t\t");
                breaks = breaks + "\r";
                tabs = tabs + "\t";
            }

            // That's it.
            return result;
        }
        catch
        {
            return source;
        }
    }
    private string LockInterpretation()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT plous.`LedgerTransactionNo` ID,IFNULL(im.name,lom.name) AS 'Name',plous.`status` STATUS,plous.`OLDNAME`,plous.`NEWNAME`, plous.`CentreID`,cm.`Centre`, ");
        sb.Append(" plous.`RoleID`, rm.`RoleName`,plous.`UserID` ActionByID,plous.`UserName` ActionBy, ");
        sb.Append(" DATE_FORMAT(plous.`dtEntry`,'%d-%b-%Y %H:%i %p') ActionDate ");
        sb.Append(" FROM patient_labinvestigation_opd_update_status plous  ");
        sb.Append(" LEFT OUTER JOIN investigation_master im ON im.`Investigation_Id`=plous.`LedgerTransactionNo` LEFT OUTER JOIN labobservation_master lom ON lom.`LabObservation_ID`=plous.`LedgerTransactionNo`  ");


        sb.Append(" INNER JOIN f_rolemaster rm ON rm.`ID` = plous.`RoleID` INNER JOIN centre_master cm ON cm.`CentreID` = plous.`CentreID`  ");
        sb.Append(" WHERE IFNULL(plous.Test_ID,'')='' and plous.`dtEntry`>='" + txtDate.GetDateForDataBase() + " 00:00:00' AND plous.`dtEntry`<='" + txtDate0.GetDateForDataBase() + " 23:59:59'");
        if (txtLabNo.Text.ToString() != "")
        {
            sb.Append("  AND plous.LedgerTransactionNo='" + txtLabNo.Text.ToString() + "' ");
        }
        if (ddlcenter.SelectedItem.Value != "ALL")
        {
            sb.Append("  AND plous.CentreID='" + ddlcenter.SelectedItem.Value + "' ");
        }

        sb.Append("  AND (plous.STATUS=('Change Investigation_Interpretation') OR plous.STATUS=('Change Observation_Interpretation')) ");

        sb.Append(" ORDER BY plous.`dtEntry` desc ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            DataColumn dc4 = new DataColumn();
            DataColumn dc5 = new DataColumn();
            dc4.ColumnName = "OLDINTERPRETATION";
            dc5.ColumnName = "NEWINTERPRETATION";
            dt.Columns.Add(dc4);
            dt.Columns.Add(dc5);
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                dt.Rows[i]["OLDINTERPRETATION"] = StripHTML(Convert.ToString(dt.Rows[i]["OLDNAME"]));
                dt.Rows[i]["NEWINTERPRETATION"] = StripHTML(Convert.ToString(dt.Rows[i]["NEWNAME"]));
            }
            dt.Columns.Remove("OLDNAME");
            dt.Columns.Remove("NEWNAME");
            Session["ReportName"] = "Interpretation Log Report";
            Session["Period"] = "Period From : " + txtDate.GetDateForDisplay() + " To : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "!!! No data found ...";
        }
        return "1";
    }

    private string ReferangeReport()
    {
        //if (Session["LoginType"] == null)
        //{
        //    return;
        //}
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT 'Backup' STATUS, cm.Centre,mm.Name MacName,lm.LabObservation_ID,lm.Name LabObservationName, ");
        sb.Append(" lr2.Gender,lr2.FromAge,lr2.ToAge,lr2.MinReading,lr2.MaxReading, ");
        sb.Append(" lr2.DisplayReading,lr2.DefaultReading,lr2.MinCritical,lr2.MaxCritical,lr2.ReadingFormat, ");
        sb.Append(" lr2.DeleteDateTime UpdateDateTime,em.Name UpdateBy ");
        sb.Append(" FROM mdrc_live_log.labobservation_range_before_delete lr2 ");
        sb.Append(" INNER JOIN  employee_master em ON em.Employee_ID = lr2.DeleteBy ");
        sb.Append(" AND DATE(deletedatetime)>='" + txtDate.GetDateForDataBase() + " 00:00:00' AND  DATE(deletedatetime)<='" + txtDate0.GetDateForDataBase() + " 23:59:59' ");
        //  sb.Append(" INNER JOIN investigation_master inv ON inv.Investigation_Id=lr2.Investigation_ID ");
        sb.Append(" INNER JOIN labobservation_master lm ON lm.LabObservation_ID=lr2.LabObservation_ID ");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lr2.CentreID ");
        sb.Append(" INNER JOIN macmaster mm ON mm.id=lr2.macID ");
        sb.Append(" UNION ALL  ");
        sb.Append(" SELECT 'LIVE' STATUS, cm.Centre,mm.Name MacName,lm.LabObservation_ID,lm.Name LabObservationName, ");
        sb.Append(" lr.Gender,lr.FromAge,lr.ToAge,lr.MinReading,lr.MaxReading, ");
        sb.Append(" lr.DisplayReading,lr.DefaultReading,lr.MinCritical,lr.MaxCritical,lr.ReadingFormat, ");
        sb.Append(" lr.updatedate UpdateDateTime,lr.updatename UpdateBy ");
        sb.Append(" FROM ");
        sb.Append(" (SELECT * FROM  mdrc_live_log.labobservation_range_before_delete WHERE  ");
        sb.Append(" DATE(deletedatetime)>='" + txtDate.GetDateForDataBase() + " 00:00:00' AND  DATE(deletedatetime)<='" + txtDate0.GetDateForDataBase() + " 23:59:59' GROUP BY ");
        sb.Append(" CentreID,MacID,Investigation_ID) lr2  ");
        sb.Append(" INNER JOIN labobservation_range lr ON lr.CentreID=lr2.CentreID  ");
        sb.Append(" AND lr.MacID=lr2.MacID AND lr.Investigation_ID=lr2.Investigation_ID  ");
        //  sb.Append(" INNER JOIN investigation_master inv ON inv.Investigation_Id=lr.Investigation_ID ");
        sb.Append(" INNER JOIN labobservation_master lm ON lm.LabObservation_ID=lr.LabObservation_ID ");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lr.CentreID ");
        sb.Append(" INNER JOIN macmaster mm ON mm.id=lr.macID ");
        sb.Append(" ORDER BY STATUS,UpdateDateTime,Centre,MacName,LabObservationName, ");
        sb.Append(" Gender,FromAge,ToAge,MinReading,MaxReading ");

        //DataTable dt = new DataTable();
        //dt = StockReports.GetDataTable(sb.ToString());
        //if (dt != null)
        //{
        //    //dt.WriteXmlSchema(@"D:\LabPackageAnalysis.xml ");
        //    Session["dtExport2Excel"] = dt;
        //    Session["ReportName"] = "Referance Range";
        //}
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "Referance Range";
            Session["Period"] = "Period From : " + txtDate.GetDateForDisplay() + " To : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "!!! No data found ...";
        }
        return "1";

    }
    private string SampleBooking()
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT cm.centre,REPLACE(pm.Patient_ID,'LSHHI','')PatientID,CONCAT(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'/',pm.Gender)Age, ");
        sb.Append(" plo.ledgertransactionNo,IF(plo.Approved=1,'Approved','Not Approved')Approved,DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y %I:%i%p')ApprovedDate, IFNULL(plo.ApprovedName ,(SELECT CONCAT(title,' ', NAME)s  FROM employee_master WHERE employee_id=plo.Approvedby AND isactive=1) ) ApprovedBy,");
        sb.Append(" DATE_FORMAT(plo.ResultEnteredDate,'%d-%b-%Y %I:%i%p')ResultEnteredDate,plo.resultenteredName AS ResultEnteredBy,");
        sb.Append(" CONCAT(DATE_FORMAT(plo.Date,'%d-%b-%Y'),' ',DATE_FORMAT(plo.Time,'%I:%i%p'))RegDate,em.Name RegBy,DATE_FORMAT(plo.SampleDate,'%d-%b-%Y %h:%i %p')SampleDate,plo.SampleReceivedBy ,");
        sb.Append(" CONCAT(im.Name,' # ',OM.Name)Inv,plo.FOReceivedByName,DATE_FORMAT(plo.FOReceivedDate,'%d-%b-%Y %h:%i %p')FOReceivedDate,plo.DispatchedByName,DATE_FORMAT(plo.DispatchedDate,'%d-%b-%Y %h:%i %p')DispatchedDate,dm.Name `Referred BY` ");
        sb.Append(" FROM patient_labinvestigation_opd plo INNER JOIN f_ledgertransaction LT ON LT.LedgerTransactionNo = PLO.LedgerTransactionNo and isCancel=0 ");
        sb.Append(" inner join employee_master em on em.Employee_ID = lt.Creator_UserID ");
    //    sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=LT.Transaction_ID    ");
        sb.Append(" INNER JOIN `centre_master` cm ON cm.centreid=lt.centreid ");
        sb.Append(" INNER JOIN Patient_master pm ON pm.Patient_ID=lt.Patient_ID");
        sb.Append(" INNER JOIN investigation_master im ON");
        sb.Append(" plo.Investigation_ID=im.Investigation_Id");
        sb.Append(" INNER JOIN investigation_observationtype io ON IM.Investigation_Id = IO.Investigation_ID    INNER JOIN");
        sb.Append(" observationtype_master OM ON OM.ObservationType_ID = IO.ObservationType_Id");
        sb.Append("  INNER JOIN doctor_referal dm ON dm.Doctor_ID = pmh.ReferedBy ");

        //if (txtCRNo.Text != string.Empty)
        //    sb.Append(" and pm.Patient_ID='LSHHI" + txtCRNo.Text.Trim() + "'");

        //if (txtPName.Text != string.Empty)
        //    sb.Append(" and pm.PName like '" + txtPName.Text.Trim() + "%'");


        sb.Append(" and plo.Date >='" + txtDate.GetDateForDataBase() + "'");


        sb.Append(" and plo.Date <='" + txtDate0.GetDateForDataBase() + "'");

        if (txtLabNo.Text != string.Empty)
            sb.Append(" and plo.LedgerTransactionNo='" + txtLabNo.Text.Trim() + "'");

        if (ddlcenter.SelectedValue != "ALL")
        {
            sb.Append(" and lt.CentreID=" + ddlcenter.SelectedValue + " ");
        }


        sb.Append(" order by plo.ID ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "PatientTrace";
            Session["Period"] = "Period From : " + txtDate.GetDateForDisplay() + " To : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "!!! No data found ...";
        }
        return "1";
    }
    private string LockUnlockClient()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pm.`Company_Name` Client,pad.`EmployeeName`,pad.`DtEntry` Date,IF(pad.`State`=0,'Unlock','Lock') STATUS ");
        sb.Append(" FROM PCC_AuditDetails pad INNER JOIN f_panel_master pm ON pad.`Panel_ID`=pm.`Panel_ID` ");
        sb.Append(" and pad.`DtEntry` >='" + txtDate.GetDateForDataBase() + " 00:00:00' ");
        sb.Append(" and pad.`DtEntry` <='" + txtDate0.GetDateForDataBase() + " 23:59:59' ");
        sb.Append(" ORDER BY dtentry DESC ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt != null && dt.Rows.Count > 0)
        {
            lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) found";
            Session["ReportName"] = "LockUnlockClient";
            Session["Period"] = "Period From : " + txtDate.GetDateForDisplay() + " To : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
        }
        else
        {
            lblMsg.Text = "!!! No data found ...";
        }
        return "1";
    }
    private string AccessionRemarkLogreport()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" Select lt.`LedgerTransactionNo` AS LabNo,ar.`Remarks`,lt.`AccessionRemark`,pnm.`Company_Name` AS PanelName,lt.`NetAmount`, COUNT(lt.`AccessionRemarkID`)totalremark FROM f_ledgertransaction lt INNER JOIN accession_remarks ar ON ar.`id`=lt.`AccessionRemarkID` INNER JOIN f_panel_master pnm ON pnm.`Panel_ID`=lt.`Panel_ID` AND pnm.`IsActive`='1'  ");
        sb.Append(" AND  lt.Date>='" + txtDate.GetDateForDataBase() + " 00:00:00' and lt.Date<='" + txtDate0.GetDateForDataBase() + " 23:59:59'  ");
        if (Util.GetString(txtLabNo.Text).Trim() != "")
        {
            sb.Append(" and lt.LedgertransactionNo='" + txtLabNo.Text.Trim() + "' ");
        }
        sb.Append(" AND lt.`AccessionRemark`<> 'N/A'  GROUP BY lt.`AccessionRemarkID`,pnm.`Panel_ID`; ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataTable dtnew = new DataTable();
        DataColumn dc = new DataColumn();
        dc.ColumnName = "PanelName";
        dtnew.Columns.Add(dc);
        DataTable dtcolumn = StockReports.GetDataTable("select Remarks from accession_remarks");
        for (int i = 0; i < dtcolumn.Rows.Count; i++)
        {
            dc = new DataColumn();
            dc.ColumnName = "Remark - " + dtcolumn.Rows[i]["Remarks"].ToString();
            dtnew.Columns.Add(dc);
        }
        DataTable dtpanel = StockReports.GetDataTable("SELECT Company_Name FROM f_panel_master WHERE IsActive='1' order by Company_Name");
        for (int i = 0; i < dtpanel.Rows.Count; i++)
        {
            dtnew.Rows.Add(dtpanel.Rows[i]["Company_Name"]);
        }

        for (int k = 0; k < dtnew.Columns.Count; k++)
        {
            for (int i = 0; i < dtnew.Rows.Count; i++)
            {
                for (int j = 0; j < dt.Rows.Count; j++)
                {
                    if (("Remark - " + dt.Rows[j]["Remarks"].ToString()) == dtnew.Columns[k].ToString())
                    {
                        if (dtnew.Rows[i]["PanelName"].ToString() == dt.Rows[j]["PanelName"].ToString())
                        {
                            dtnew.Rows[i][dtnew.Columns[k].ToString()] = dt.Rows[j]["totalremark"].ToString();
                        }

                    }

                }
            }
        }
        int ccount = 0;

        foreach (DataRow orow in dtnew.Select())
        {
            foreach (DataColumn dc1 in dtnew.Columns)
            {
                string nn = dc1.ToString();
                if (dc1.ToString() != "PanelName")
                {
                    if (orow[dc1].ToString() == "")
                    {
                        ccount++;
                    }
                    if (orow[dc1].ToString() == "")
                    {
                        orow[dc1] = "0";
                    }
                }
            }
            if (ccount == dtnew.Columns.Count - 1)
            {
                dtnew.Rows.Remove(orow);
                //dtnew.AcceptChanges();
            }
            ccount = 0;
        }
        dtnew.AcceptChanges();
        if (dtnew != null && dtnew.Rows.Count > 0)
        {
            Session["ReportName"] = "Accession Remark Report";
            Session["Period"] = "Period From : " + txtDate.GetDateForDisplay() + " To : " + txtDate0.GetDateForDisplay();
            Session["dtExport2Excel"] = dtnew;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "!!! No data found ...";

        }
        return "1";
    }
}
