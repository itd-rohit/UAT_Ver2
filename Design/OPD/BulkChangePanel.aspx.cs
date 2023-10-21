using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_BulkChangePanel : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["RoleID"] == null)
        {
            Response.Redirect("~/Design/Default.aspx");
        }

        txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

        string str = "select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' and AccessType=2 ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.Centre  ";

        DataTable dt = StockReports.GetDataTable(str);
        ddlCentreAccess.DataSource = dt;
        ddlCentreAccess.DataTextField = "Centre";
        ddlCentreAccess.DataValueField = "CentreID";
        ddlCentreAccess.DataBind();
        ddlCentreAccess.Items.Insert(0, "Centre");

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT concat(ifnull(pn.Panel_Code,''),' ',pn.Company_Name) Company_Name,concat(pn.Panel_ID,'#',pn.ReferenceCodeOPD,'#',pn.Payment_Mode,'#', IF(UPPER(pn.payment_mode)='ADVANCE',0+pn.creditlimit-0, 0))PanelID  FROM   f_panel_master pn   order by pn.Panel_code,pn.Company_Name ");
        DataTable dtPanel = StockReports.GetDataTable(sb.ToString());
        if (dtPanel != null && dtPanel.Rows.Count > 0)
        {
            ddlSourcePanel.DataSource = dtPanel;
            ddlSourcePanel.DataTextField = "Company_Name";
            ddlSourcePanel.DataValueField = "PanelID";
            ddlSourcePanel.DataBind();
            ddlSourcePanel.Items.Insert(0, "Source Panel");

            ddlTargetPanel.DataSource = dtPanel;
            ddlTargetPanel.DataTextField = "Company_Name";
            ddlTargetPanel.DataValueField = "PanelID";
            ddlTargetPanel.DataBind();
            ddlTargetPanel.Items.Insert(0, "Target Panel");

        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string ValidateUser()
    {
        return "1";
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string PatientSearch(string FromDate, string ToDate, string SearchType, string FromLabNo, string ToLabNo, string CentreID, string PanelID)
    {

        try
        {
            int checkSession = UserInfo.Centre;
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "" });
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y') RegDate, ");
        sbQuery.Append(" CONCAT(pm.Title,' ',pm.PName) PName,CONCAT(pm.Age,' ',LEFT(pm.Gender,1)) AgeGender,");
        sbQuery.Append(" lt.LedgerTransactionNo LabNo,plo.BarcodeNo,");
        sbQuery.Append(" ROUND(lt.GrossAmount,2) GrossAmt,ROUND(lt.DiscountOnTotal,2) DiscAmt,ROUND(lt.NetAmount,2) NetAmt,ROUND(lt.Adjustment,2) RecAmt,");
        sbQuery.Append(" ROUND(lt.NetAmount-lt.Adjustment,2) BalAmt,");
        sbQuery.Append(" (SELECT Centre FROM centre_master cm WHERE cm.CentreID=lt.CentreID) CentreName,");
        sbQuery.Append(" (SELECT company_name FROM f_panel_master fpm WHERE fpm.Panel_Id=lt.Panel_ID ) PanelName,lt.Panel_ID PanelID ");
        sbQuery.Append(" FROM f_ledgertransaction lt");
        sbQuery.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=lt.LedgerTransactionNo");
        if (CentreID != "")
        {
            sbQuery.Append(" AND lt.CentreID=" + CentreID + "");
        }
        if (PanelID != "")
        {
            sbQuery.Append(" AND lt.Panel_ID=" + PanelID.Split('#')[0].ToString() + " ");
        }
        if (FromLabNo.Trim() != "" && ToLabNo.Trim() != "")
        {
            sbQuery.Append(" and " + SearchType + ">='" + FromLabNo + "' and " + SearchType + "<='" + ToLabNo + "'");
        }
        if (FromLabNo.Trim() != "" && ToLabNo.Trim() == "")
        {
            sbQuery.Append(" and " + SearchType + "='" + FromLabNo + "' ");
        }
        sbQuery.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID");
        sbQuery.Append(" WHERE  lt.InvoiceNo=''");
        sbQuery.Append(" and date(lt.Date)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' and date(lt.date)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'");


        sbQuery.Append(" GROUP BY lt.LedgerTransactionNo");
        sbQuery.Append(" ORDER BY lt.LedgerTransactionNo");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        return JsonConvert.SerializeObject(new { status = true, response = dt });
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchItemDetail(string LabNo, string PanelID)
    {
        try
        {
            int checkSession = UserInfo.Centre;
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "" });
        }
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT lt.LedgerTransactionNo,plo.ItemName,plo.Amount, ");
            sb.Append(" (ifnull(r.Rate,0) * (100-0)*0.01) NewAmount, ");
            sb.Append("  plo.Rate,IF(IFNULL(rs.Rate,0)=0, ifnull(r.Rate,0),IFNULL(rs.Rate,0)) NewRate,0 DiscountPercentage,plo.Quantity, ");
            sb.Append(" pm.Company_Name OldPanel,concat(pm.Panel_ID,'#',pm.ReferenceCodeOPD,'#',pm.Payment_Mode,'#', IF(UPPER(pm.payment_mode)='ADVANCE',0+pm.creditlimit-0, 0)) OldPanelID,pm2.Company_Name NewPanel,concat(pm2.Panel_ID,'#',pm2.ReferenceCodeOPD,'#',pm2.Payment_Mode,'#', IF(UPPER(pm2.payment_mode)='ADVANCE',0+pm2.creditlimit-0, 0)) NewPanelID ");
            sb.Append("  FROM f_ledgertransaction lt ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=lt.LedgerTransactionNo ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID ");
            sb.Append("  INNER JOIN  f_panel_master pm2 ON pm2.Panel_ID='" + PanelID.Split('#')[0].ToString() + "' ");
            sb.Append("   LEFT JOIN f_ratelist r ON r.ItemID=plo.ItemID AND r.Panel_ID='" + PanelID.Split('#')[1].ToString() + "' ");
            sb.Append("  LEFT JOIN f_ratelist_schedule rs ON rs.ItemID=plo.ItemID AND rs.Panel_ID='" + PanelID.Split('#')[1].ToString() + "' AND  CURRENT_DATE() BETWEEN rs.FromDate AND rs.ToDate AND rs.isActive=1");
            sb.Append("  WHERE lt.LedgerTransactionNo='" + LabNo + "'; ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return JsonConvert.SerializeObject(new { status = true, response = dt });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.GeneralLog("BulkChangePanel : " + ex.GetBaseException().ToString());
            return "0";
        }

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveNewPanelRates(string FromDate, string ToDate, string CentreID, string SourcePanelID, string TargetPanelID)
    {
        try
        {
            int checkSession = UserInfo.Centre;
        }
        catch
        {
            return "-1";
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction();

        try
        {
            string RateListPanelID = TargetPanelID.Split('#')[1];
            string PayMode = TargetPanelID.Split('#')[2];
            TargetPanelID = TargetPanelID.Split('#')[0];
            SourcePanelID = SourcePanelID.Split('#')[0];
            
            StringBuilder sbCheck = new StringBuilder();
            sbCheck.Append(" SELECT IFNULL(GROUP_CONCAT(im.TypeName),'') ItemName  ");
            sbCheck.Append(" FROM  f_ledgertransaction lt ");
            sbCheck.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.LedgerTransactionNo=lt.LedgerTransactionNo   ");
            sbCheck.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plo.ItemID ");
            sbCheck.Append(" LEFT JOIN f_ratelist r ON r.ItemID=plo.ItemID AND r.Panel_ID='" + RateListPanelID + "'  ");
            sbCheck.Append(" WHERE lt.InvoiceNo='' AND lt.CentreID='" + CentreID + "' AND lt.Panel_ID='" + SourcePanelID + "'  ");
            sbCheck.Append(" AND DATE(lt.Date)>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "'  ");
            sbCheck.Append(" AND DATE(lt.Date)<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' AND r.itemid IS NULL ");
            string strCheckResult = StockReports.ExecuteScalar(sbCheck.ToString());
            if (strCheckResult != "")
            {
                return strCheckResult;
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE f_ledgertransaction lt ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=lt.LedgerTransactionNo ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=lt.Panel_ID ");
            sb.Append(" INNER JOIN  f_panel_master pm2 ON pm2.Panel_ID='" + TargetPanelID + "' ");
            sb.Append(" Left JOIN f_ratelist r ON r.ItemID=plo.ItemID AND r.Panel_ID='" + RateListPanelID + "' ");
            sb.Append("  LEFT JOIN f_ratelist_schedule rs ON rs.ItemID=plo.ItemID AND rs.Panel_ID='" + RateListPanelID + "' AND  CURRENT_DATE() BETWEEN rs.FromDate AND rs.ToDate AND rs.isActive=1");
            sb.Append(" SET lt.Panel_ID=pm2.Panel_ID, ");
            sb.Append(" plo.Amount = IFNULL((IF(IFNULL(rs.Rate,0)=0, ifnull(r.Rate,0),IFNULL(rs.Rate,0)) * (100-0)*0.01),0),");
            sb.Append(" plo.Rate=IF(IFNULL(rs.Rate,0)=0, ifnull(r.Rate,0),IFNULL(rs.Rate,0)),lt.ipaddress='" + StockReports.getip() + "' ");
            sb.Append(" WHERE lt.InvoiceNo='' and lt.CentreID='" + CentreID + "' and lt.Panel_ID='" + SourcePanelID + "' ");
            sb.Append(" and lt.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" and lt.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'; ");

            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb.ToString());
             
            if (PayMode.ToUpper() == "CREDIT")
            {
                StringBuilder sb1 = new StringBuilder();
                sb1.Append(" UPDATE f_receipt r  ");
                sb1.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=r.LedgerTransactionNo ");
                sb1.Append(" SET r.IsCancel=1,r.CancelReason='Bulk Change Panel',r.CancelDate=NOW(),r.Cancel_UserID='" + HttpContext.Current.Session["ID"].ToString() + "', ");
                sb1.Append(" r.Updatedate=NOW(),r.UpdateID='" + HttpContext.Current.Session["ID"].ToString() + "' ");
                sb1.Append(" WHERE lt.InvoiceNo='' and r.LedgerNoCr='OPD003' AND lt.CentreID='" + CentreID + "' AND lt.Panel_ID='" + TargetPanelID + "' ");
                sb1.Append(" and lt.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb1.Append(" and lt.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ; "); 
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb1.ToString());

                sb1 = new StringBuilder();
                sb1.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,Status,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDID,NEWID)");
                sb1.Append(" SELECT lt.LedgerTransactionNo,'Bulk Change Panel','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "',");
                sb1.Append(" NOW(),'" + StockReports.getip() + "','" + UserInfo.Centre+ "','" + HttpContext.Current.Session["RoleID"].ToString() + "',lt.Panel_ID,'" + TargetPanelID + "' FROM f_ledgertransaction lt ");
                sb1.Append(" WHERE  lt.InvoiceNo='' and  lt.CentreID='" + CentreID + "' AND lt.Panel_ID='" + TargetPanelID + "' ");
                sb1.Append(" and lt.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb1.Append(" and lt.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ; ");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb1.ToString());

                sb1 = new StringBuilder();
                sb1.Append(" UPDATE f_ledgertransaction lt ");
                sb1.Append(" SET lt.NetAmount=(SELECT SUM(Amount) FROM patient_labinvestigation_opd plo  WHERE lt.LedgerTransactionNo=plo.LedgerTransactionNo And plo.IsActive=1 GROUP BY plo.LedgerTransactionNo ),");
                sb1.Append(" lt.GrossAmount=(SELECT SUM(Amount) FROM patient_labinvestigation_opd plo  WHERE lt.LedgerTransactionNo=plo.LedgerTransactionNo And plo.IsActive=1 GROUP BY plo.LedgerTransactionNo ),");
                sb1.Append(" lt.DiscountOnTotal=(SELECT SUM(Rate-Amount) FROM patient_labinvestigation_opd plo  WHERE lt.LedgerTransactionNo=plo.LedgerTransactionNo And plo.IsActive=1 GROUP BY plo.LedgerTransactionNo ),");
                sb1.Append(" lt.Adjustment=ifnull((SELECT SUM(Amount) FROM f_receipt r WHERE  r.LedgerNoCr<>'OPD003'  AND r.IsCancel=0  AND r.LedgerTransactionNo=lt.LedgerTransactionNo GROUP BY r.LedgerTransactionNo),0) ");
              //  sb1.Append(" lt.AmtCredit=(SELECT SUM(Amount) FROM patient_labinvestigation_opd plo  WHERE lt.LedgerTransactionNo=plo.LedgerTransactionNo And plo.IsActive=1 GROUP BY plo.LedgerTransactionNo )");
                sb1.Append(" WHERE lt.InvoiceNo='' and  IFNULL(lt.InvoiceNo,'')='' and lt.CentreID='" + CentreID + "' and lt.Panel_ID='" + TargetPanelID + "' ");
                sb1.Append(" and lt.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb1.Append(" and lt.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ; ");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb1.ToString()); 
            }
            else
            {
                StringBuilder sb2 = new StringBuilder();
               
                sb2.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,Status,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDID,NEWID)");
                sb2.Append(" SELECT lt.LedgerTransactionNo,'Bulk Change Panel','" + HttpContext.Current.Session["ID"].ToString() + "','" + HttpContext.Current.Session["LoginName"].ToString() + "',");
                sb2.Append(" NOW(),'" + StockReports.getip() + "','" + UserInfo.Centre+ "','" + HttpContext.Current.Session["RoleID"].ToString() + "',lt.Panel_ID,'" + TargetPanelID + "' FROM f_ledgertransaction lt ");
                sb2.Append(" WHERE   lt.InvoiceNo='' and  lt.CentreID='" + CentreID + "' AND lt.Panel_ID='" + TargetPanelID + "' ");
                sb2.Append(" and lt.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb2.Append(" and lt.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ; ");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb2.ToString());

                // Update Lt Amount for Non-Credit Patient
                sb2 = new StringBuilder();
                sb2.Append(" UPDATE f_ledgertransaction lt ");
                sb2.Append(" SET lt.NetAmount=(SELECT SUM(Amount) FROM patient_labinvestigation_opd plo  WHERE lt.LedgerTransactionNo=plo.LedgerTransactionNo And plo.IsActive=1 GROUP BY plo.LedgerTransactionNo ),");
                sb2.Append(" lt.GrossAmount=(SELECT SUM(Amount) FROM patient_labinvestigation_opd plo  WHERE lt.LedgerTransactionNo=plo.LedgerTransactionNo And plo.IsActive=1 GROUP BY plo.LedgerTransactionNo ),");
                sb2.Append(" lt.DiscountOnTotal=(SELECT SUM(Rate-Amount) FROM patient_labinvestigation_opd plo  WHERE lt.LedgerTransactionNo=plo.LedgerTransactionNo And plo.IsActive=1 GROUP BY plo.LedgerTransactionNo )");
                sb2.Append(" WHERE  IFNULL(lt.InvoiceNo,'')='' and lt.CentreID='" + CentreID + "' and lt.Panel_ID='" + TargetPanelID + "' ");
                sb2.Append(" and lt.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb2.Append(" and lt.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ; ");
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb2.ToString());

            }


            //StringBuilder sb3 = new StringBuilder();
            //sb3.Append(" UPDATE f_patientaccount pa INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNO=pa.LedgerTransactionNo ");
            //sb3.Append(" SET pa.Amount=((-1)* lt.NetAmount ) ");
            //// sb2.Append(" WHERE lt.LedgerTransactionNo='" + LabNo + "' AND pa.IsAdvanceAmt=0 AND pa.Type='CREDIT' AND pa.Active=1 ");
            //sb3.Append(" WHERE pa.IsAdvanceAmt=0 AND pa.Type='CREDIT' AND pa.Active=1 and lt.InvoiceNo='' and lt.CentreID='" + CentreID + "' and lt.Panel_ID='" + TargetPanelID + "' and  lt.IsCancel=0 ");
            //sb3.Append(" and lt.Date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            //sb3.Append(" and lt.Date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ; ");
            //MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb3.ToString());
            tranX.Commit();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch(Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tranX.Rollback();
            con.Close();
            con.Dispose();
            return "0";
        }
    }

    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue));


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();


    }
}