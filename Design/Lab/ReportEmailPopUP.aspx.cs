using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;

public partial class Design_Lab_ReportEmailPopUP : System.Web.UI.Page
{
    public string FromPUPPortal = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            FromPUPPortal = Util.GetString(Request.QueryString["FromPUPPortal"]);
            txtVisitNo.Text = Util.GetString(Request.QueryString["VisitNo"]);

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {

                int discountnotapp = Util.GetInt(MySqlHelper.ExecuteScalar(con,CommandType.Text,"SELECT COUNT(1) FROM `f_ledgertransaction` WHERE discountID=0 AND DiscountApprovedByID<>0 AND `IsDiscountApproved`=0 AND `DiscountOnTotal`>0 AND `LedgerTransactionNo`=@LedgerTransactionNo ",
                   new MySqlParameter("@LedgerTransactionNo", txtVisitNo.Text)));


                if (discountnotapp > 0)
                {
                    lblApproved.Text = "Discount is not validated ";
                    hdnIsDue.Value = "1";
                    ScriptManager.RegisterStartupScript(this, GetType(), "", "DisableSend();", true);
                    return;
                }

                StringBuilder sbPanleLock = new StringBuilder();


                sbPanleLock.Append(" SELECT COUNT(1) FROM  ");
                sbPanleLock.Append("  `f_ledgertransaction` lt  where  `LedgerTransactionNo`=@LedgerTransactionNo AND IF(lt.IsCredit='0' AND lt.OutstandingStatus=0,IF(round(Adjustment)  >= round(NetAmount) ,'1','0'),'1' )=0 ");
                int PanelLock = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sbPanleLock.ToString(),
                    new MySqlParameter("@LedgerTransactionNo", txtVisitNo.Text)));


                if (PanelLock > 0)
                {
                    lblApproved.Text = "Payment is Due ";
                    hdnIsDue.Value = "1";
                    ScriptManager.RegisterStartupScript(this, GetType(), "", "DisableSend();", true);
                }
                else
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" SELECT pm.`Email` PatientEmail,fpm.`EmailIDReport` ClientEmailID,dr.`Email` DoctorEmail,  ");
                    sb.Append(" (SELECT COUNT(*) FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNo`=@LedgerTransactionNo AND approved=1 LIMIT 1)ReportApprovedQty,fpm.`PanelType` FROM patient_master pm ");
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID` AND lt.`LedgerTransactionNo`=@LedgerTransactionNo ");
                    sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` ");
                    sb.Append(" INNER JOIN `doctor_referal` dr ON dr.`Doctor_ID`=lt.`Doctor_ID` ");
                    using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@LedgerTransactionNo", txtVisitNo.Text)).Tables[0])
                    {
                        if (dt.Rows.Count > 0)
                        {
                            txtPatientEmailID.Text = Util.GetString(dt.Rows[0]["PatientEmail"]);
                            txtEmailID.Text = Util.GetString(dt.Rows[0]["PatientEmail"]);
                            txtDoctorEmailID.Text = Util.GetString(dt.Rows[0]["DoctorEmail"]);
                            txtClientEmailID.Text = Util.GetString(dt.Rows[0]["ClientEmailID"]);
                            txtReportApprovedQty.Text = Util.GetString(dt.Rows[0]["ReportApprovedQty"]);
                            if (FromPUPPortal.Trim() != "1")
                            {
                                txtPanelType.Text = Util.GetString(dt.Rows[0]["PanelType"]);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ClassLog CL = new ClassLog();
                CL.errLog(ex);
               
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string sendMail(string VisitNo, string EmailID, string Cc, string Bcc, string MailedTo, string FromPUPPortal)
    {
        string IsSend = "-1";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT IF(fpm.`PanelType`='PUP','PUP',cm.`type1`)PanelType,lt.LedgerTransactionID,lt.`IsCredit`,lt.`NetAmount`,lt.`Adjustment`, ");
            sb.Append("  IF(ROUND(lt.`NetAmount`)>ROUND(lt.`Adjustment`) AND lt.`IsCredit`=0,'1','0')IsDue,  ");
            sb.Append("   GROUP_CONCAT(Test_id)Test_id, lt.`LedgerTransactionNo`,cm.`Centre`,CONCAT(pm.title,'',pm.Pname)PName,lt.Patient_ID UHID,   ");
            sb.Append("  lt.Username_web UserID, lt.`Password_web` `Password`");
            sb.Append(" ,(SELECT SUBJECT FROM Email_configuration WHERE ID=2 AND IsActive=1) EmailSubject,(SELECT Template FROM Email_configuration WHERE ID=2 AND IsActive=1) EmailBody");
            sb.Append(" FROM patient_master pm  ");
            sb.Append("  INNER JOIN f_ledgertransaction lt ON lt.`Patient_ID`=pm.`Patient_ID` AND lt.LedgerTransactionno=@LedgerTransactionNo   ");
            sb.Append("  INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append("  AND plo.`Approved`=1 AND plo.`IsReporting`=1  ");
            sb.Append("  INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`  ");
            sb.Append("  INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=lt.`Panel_ID` ");
            sb.Append("   GROUP BY plo.LedgerTransactionID; ");

            using (DataTable dtEmailData = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@LedgerTransactionNo", VisitNo)).Tables[0])
            {
                if (dtEmailData.Rows.Count > 0)
                {

                    if (Util.GetString(dtEmailData.Rows[0]["IsDue"]) == "0")
                    {
                        try
                        {
                            ReportEmailClass RMail = new ReportEmailClass();
                            StringBuilder EmailBody = new StringBuilder();
                            string EmailSubject = Util.GetString(dtEmailData.Rows[0]["EmailSubject"]);

                            EmailBody.Append(Util.GetString(dtEmailData.Rows[0]["EmailBody"]));
                            EmailBody.Replace("{PName}", Util.GetString(dtEmailData.Rows[0]["PName"])).Replace("{LabNo}", Util.GetString(dtEmailData.Rows[0]["LedgerTransactionNo"]));
                            EmailSubject = EmailSubject.Replace("{PName}", Util.GetString(dtEmailData.Rows[0]["PName"])).Replace("{LabNo}", Util.GetString(dtEmailData.Rows[0]["LedgerTransactionNo"]));
                            if (EmailBody.ToString().Trim() != "" && EmailSubject.Trim() != "")
                                IsSend = RMail.sendEmail(EmailID.Trim(), EmailSubject.Trim(), EmailBody.ToString(), Cc.Trim(), Bcc.Trim(), Util.GetString(dtEmailData.Rows[0]["LedgerTransactionNo"]), Util.GetString(dtEmailData.Rows[0]["Test_id"]), "PDF Report", "0", "PDF Report Email", MailedTo.Trim(), FromPUPPortal.Trim());
                        }
                        catch (Exception ex)
                        {
                            IsSend = "-1";
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
                        }
                    }
                }
            }
            return IsSend;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return IsSend;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string EmailStatusData(string VisitNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT erp.MailedTo,erp.LedgerTransactionNo,erp.`EmailID`,erp.`Cc`,erp.`Bcc`,DATE_FORMAT(erp.`dtEntry`,'%d-%b-%y %h:%i %p')dtEntry,");
            sb.Append(" IF(erp.`IsAutoMail`=1,'Auto','Manual')MailType,lt.`PName`,em.`Name` UserName,IF(erp.`IsSend`=1,'Sent','Failed')IsSend ");
            sb.Append(" FROM `email_record_patient`  erp ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=erp.`LedgerTransactionID` ");
            sb.Append(" AND erp.`LedgerTransactionNo`=@LedgerTransactionNo ");
            sb.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=erp.`UserID` ORDER BY erp.`dtEntry` DESC ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@LedgerTransactionNo", VisitNo)).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

}
