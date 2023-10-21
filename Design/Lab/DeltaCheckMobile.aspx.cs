using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Lab_DeltaCheckMobile : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["RoleID"] == null)
            {
                //  Response.Redirect("~/Design/Default.aspx");
            }

            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindAccessCentre();
        }
    }

    public void bindAccessCentre()
    {
        ddlCentreAccess.DataSource = StockReports.GetDataTable(" select distinct cm.CentreID,cm.Centre from centre_master cm where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' and AccessType=1 ) or cm.CentreID = '" + UserInfo.Centre + "') and cm.isActive=1 order by cm.Centre ");
        ddlCentreAccess.DataTextField = "Centre";
        ddlCentreAccess.DataValueField = "CentreID";
        ddlCentreAccess.DataBind();
        ddlCentreAccess.Items.Insert(0, new ListItem("All Centres", "ALL"));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchPatientParamterDetail(string LabNo)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append("   SELECT plo.`LedgerTransactionNo` LabNo,inv.`Name` Investigation,ploo.`LabObservationName` ParamterName, ");
        sbQuery.Append("  ploo.`Value` Reading,ploo.`MinValue`,ploo.`MaxValue`,ploo.`ReadingFormat` Unit    ");
        sbQuery.Append("   FROM `patient_labinvestigation_opd` plo   ");
        sbQuery.Append("   INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID`  ");
        sbQuery.Append("   INNER JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID` ");
        sbQuery.Append("  WHERE plo.`Approved`=1 AND ploo.`Value`<>'' ");
        if (LabNo.Trim() != "")
        {
            sbQuery.Append(" and plo.LedgerTransactionNo='" + LabNo.Trim() + "' ");
        }

        sbQuery.Append(" ORDER BY inv.name,ploo.`Priorty`;");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        return makejsonoftable(dt, makejson.e_without_square_brackets);

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchPatientInvestigation(string LabNo)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT lt.LedgerTransactionID,plo.`LedgerTransactionNo`,inv.`Name` AS Investigation,plo.`BarcodeNo`,plo.Test_ID, ");
        sbQuery.Append(" IF(plo.`Approved`=1,'Yes','No') Approved,");
        sbQuery.Append(" CASE WHEN  plo.Approved='1' AND plo.isPrint='1'  THEN '#00FFFF'  WHEN  plo.Approved='1'   THEN '#90EE90' WHEN plo.Result_Flag='1'AND plo.isHold='0' AND plo.isForward='0' AND isPartial_Result='0' AND  plo.IsSampleCollected<>'R'   THEN '#FFC0CB' WHEN plo.Result_Flag='0' THEN '#E2680A' WHEN plo.isHold='1' THEN '#FFFF00' WHEN plo.IsSampleCollected='N'  OR plo.IsSampleCollected='S' THEN '#CC99FF' WHEN plo.IsSampleCollected='R' THEN '#B0C4DE' ELSE '#FFFFFF' END rowColor ");
        sbQuery.Append(" FROM `patient_labinvestigation_opd` plo ");
        sbQuery.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID`");
        sbQuery.Append(" INNER JOIN  `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
        if (LabNo.Trim() != "")
        {
            sbQuery.Append(" where plo.LedgerTransactionNo='" + LabNo.Trim() + "' ");
        }
        sbQuery.Append(" ORDER BY inv.name;");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        return makejsonoftable(dt, makejson.e_without_square_brackets);

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchPatientDetail(string PatientID)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT IF(plo.`Approved`=1,'Yes','No') Approved,lt.LedgerTransactionID,cm.Centre,pm.`Mobile`,pm.`Email`,DATE_FORMAT(lt.`Date`,'%d-%b-%y') RegDate,lt.`LedgerTransactionNo` LabNo, ");
        sbQuery.Append(" CONCAT(pm.`Title`,' ',pm.`PName`) PName,CONCAT(pm.`Age`,'/',LEFT(pm.`Gender`,1)) Age,  ");
        sbQuery.Append(" CASE  WHEN (ROUND(lt.NetAmount)-lt.Adjustment)<=0  AND lt.IsCredit=0 THEN '#00FA9A' ");
        sbQuery.Append(" WHEN (lt.IsCredit >0) THEN '#F0FFF0' WHEN  (ROUND(lt.NetAmount)-lt.Adjustment)>0   AND lt.IsCredit=0 THEN '#FFC0CB' END  rowColor  ,   ");
        sbQuery.Append(" ROUND((lt.`NetAmount`-lt.`Adjustment`),2) BalAmount, ");
        sbQuery.Append(" IFNULL((SELECT BarcodeNo FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNo`=lt.`LedgerTransactionNo` AND BarcodeNo<>'' LIMIT 1),'') BarcodeNo  ");
        sbQuery.Append(" FROM patient_master pm ");
        sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID`   ");
        sbQuery.Append("inner join centre_master cm on cm.CentreID=lt.`CentreID`  ");
        sbQuery.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
        sbQuery.Append("   ");
        if (PatientID.Trim() != "")
        {
            sbQuery.Append(" WHERE pm.`Patient_ID`='" + PatientID.Trim() + "' ");
        }
        sbQuery.Append(" GROUP BY lt.`LedgerTransactionNo` ORDER BY lt.`LedgerTransactionNo` ");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        return makejsonoftable(dt, makejson.e_without_square_brackets);

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchPatientDetailVisitID(string VisitID)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT IF(plo.`Approved`=1,'Yes','No') Approved,lt.LedgerTransactionID,cm.Centre,pm.`Mobile`,pm.`Email`,DATE_FORMAT(lt.`Date`,'%d-%b-%y') RegDate,lt.`LedgerTransactionNo` LabNo, ");
        sbQuery.Append(" CONCAT(pm.`Title`,' ',pm.`PName`) PName,CONCAT(pm.`Age`,'/',LEFT(pm.`Gender`,1)) Age,  ");
        sbQuery.Append(" CASE   ");
        sbQuery.Append(" WHEN (lt.NetAmount-lt.Adjustment)=0  AND lt.IsCredit=0 THEN '#00FA9A'  ");
        sbQuery.Append(" WHEN (lt.IsCredit >0) THEN '#F0FFF0'  ");
        sbQuery.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 and lt.Adjustment>0  and lt.IsCredit=0 THEN 'FFC0CB'  ");
        sbQuery.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 and lt.Adjustment=0  and lt.IsCredit=0 THEN '#DDA0DD'  END  rowColor  ,   ");
        sbQuery.Append(" ROUND((lt.`NetAmount`-lt.`Adjustment`),2) BalAmount, ");
        sbQuery.Append(" IFNULL((SELECT BarcodeNo FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNo`=lt.`LedgerTransactionNo` AND BarcodeNo<>'' LIMIT 1),'') BarcodeNo  ");
        sbQuery.Append(" FROM patient_master pm ");
        sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID`   ");
        sbQuery.Append("inner join centre_master cm on cm.CentreID=lt.`CentreID`  ");
        sbQuery.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  ");
        sbQuery.Append("   ");
        if (VisitID.Trim() != "")
        {
            sbQuery.Append(" WHERE lt.`LedgerTransactionNo`='" + VisitID.Trim() + "' ");
        }
        sbQuery.Append(" GROUP BY lt.`LedgerTransactionNo` ORDER BY lt.`LedgerTransactionNo` ");
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        return makejsonoftable(dt, makejson.e_without_square_brackets);

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchDetail(string SearchType, string SearchValue, string FromDate, string ToDate, string CentreID, string CallBy)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT '' MinDate,'' MaxDate,pm.`Patient_ID`,pm.`PName`,pm.`Mobile`");
        sbQuery.Append(" FROM patient_master pm   ");
        sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
        sbQuery.Append(" WHERE pm.`Mobile`<>'0000000000'    AND pm.`Mobile`<>''  ");
        if (CallBy == "Patient")
        {
            if (SearchValue.Trim() != "")
            {
                if (SearchType.Trim() == "lt.LedgertransactionNo")
                {
                    sbQuery.Append(" and pm.`Patient_ID` = '" + SearchValue.Trim() + "' ");
                }
                else
                {
                    sbQuery.Append(" and " + SearchType.Trim() + " = '" + SearchValue.Trim() + "' ");
                }
            }
            else
            {
                sbQuery.Append("  AND lt.date >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sbQuery.Append("  AND lt.date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
            }
        }
        if (CallBy != "Patient")
        {
            sbQuery.Append("  AND lt.date >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sbQuery.Append("  AND  lt.date <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }
        if (CallBy == "Doctor")
        {
            sbQuery.Append(" and lt.`Doctor_ID`='" + SearchValue + "'");
        }
        if (CallBy == "PUP")
        {
            sbQuery.Append(" AND lt.`Panel_ID`='" + SearchValue + "'");
        }
        if (CallBy == "PCC")
        {
            sbQuery.Append(" and lt.CentreID='" + SearchValue + "'");
        }
        if (CentreID != "" && CentreID != "ALL")
        {
            sbQuery.Append(" and lt.CentreID=" + CentreID + " ");
        }
        if (SearchType.Trim() != "lt.LedgertransactionNo")
        {
            sbQuery.Append(" GROUP BY pm.`Patient_ID`  ORDER BY pm.`Patient_ID` ");
        }
        if (CallBy == "Patient")
        {
            sbQuery.Append(" GROUP BY pm.`Patient_ID`  ORDER BY pm.`Patient_ID` ");
        }
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        string rtrn = makejsonoftable(dt, makejson.e_without_square_brackets);
        return rtrn;
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetRemarks()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" SELECT RemarksValue,Remarks FROM Call_Centre_Remarks WHERE IsActive='1'");
            string rtrn = makejsonoftable(dt, makejson.e_without_square_brackets);
            return rtrn;
        }
        catch (Exception ex)
        {
            return "";
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchDetail1(string SearchType, string SearchValue, string FromDate, string ToDate, string CentreID)
    {
        try
        {
            string checkSession = UserInfo.Centre.ToString();
        }
        catch
        {
            return "-1";
        }
        StringBuilder sbQuery = new StringBuilder();
        sbQuery.Append(" SELECT '' MinDate,'' MaxDate,pm.`Patient_ID`,pm.`PName`,pm.`Mobile`");
        sbQuery.Append(" FROM patient_master pm   ");
        sbQuery.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
        sbQuery.Append(" WHERE pm.`Mobile`<>'0000000000'    AND pm.`Mobile`<>'' ");
        if (SearchValue.Trim() != "")
        {
            if (SearchType.Trim() == "PM.PName")
            {
                sbQuery.Append(" and " + SearchType.Trim() + " LIKE '" + SearchValue.Trim() + "%' ");
            }
            else
            {
                sbQuery.Append(" and " + SearchType.Trim() + " = '" + SearchValue.Trim() + "' ");
            }
        }
        else
        {
            sbQuery.Append("  AND DATE(lt.date) >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' ");
            sbQuery.Append(" AND DATE(lt.date) <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "' ");
        }
        if (CentreID != "" && CentreID != "ALL")
        {
            sbQuery.Append(" and lt.CentreID=" + CentreID + " ");
        }
        else if (CentreID == "ALL")
        {
            sbQuery.Append(" and (lt.CentreID in ( SELECT DISTINCT `CentreAccess` FROM `centre_access` WHERE `CentreID`='" + UserInfo.Centre + "'  ) or lt.CentreID=" + UserInfo.Centre + " ) ");
        }
        else
        {
            sbQuery.Append(" and lt.CentreID=" + UserInfo.Centre + " ");
        }

        if (SearchType.Trim() != "lt.LedgertransactionNo")
        {
            sbQuery.Append(" GROUP BY pm.`Patient_ID`  ORDER BY pm.`Patient_ID` ");
        }
        DataTable dt = StockReports.GetDataTable(sbQuery.ToString());
        string rtrn = makejsonoftable(dt, makejson.e_without_square_brackets);
        return rtrn;
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

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SaveNewLabReportLog(string MobileNo, string CallBy, string CallByID, string CallType, string Remarks, string Name)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string ID = "";
            Patient_Estimate_Log pelObj = new Patient_Estimate_Log(tnx);
            pelObj.Mobile = MobileNo;
            pelObj.Call_By = CallBy;
            pelObj.Call_By_ID = CallByID;
            pelObj.Call_Type = CallType;
            pelObj.UserName = UserInfo.LoginName;
            pelObj.UserID = UserInfo.ID;
            pelObj.Remarks = Remarks;
            pelObj.Name = Name;
            pelObj.CentreID = "0";
            ID = pelObj.Insert();

            if (ID == string.Empty)
            {
                tnx.Rollback();
                return string.Empty;
            }
            else
            {
                tnx.Commit();
                return "1";
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.GetBaseException());
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string EmailStatusData(string VisitNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT erp.LedgerTransactionNo,erp.`EmailID`,erp.`Cc`,erp.`Bcc`,DATE_FORMAT(erp.`dtEntry`,'%d-%b-%y %h:%i %p')dtEntry,");
        sb.Append(" IF(erp.`IsAutoMail`=1,'Auto','Manual')MailType,lt.`PName`,em.`Name` UserName,IF(erp.`IsSend`=1,'Sent','Failed')IsSend ");
        sb.Append(" FROM `email_record_patient`  erp ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=erp.`LedgerTransactionID` ");
        sb.Append(" AND erp.`LedgerTransactionNo`='" + VisitNo + "' ");
        sb.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=erp.`UserID` ORDER BY erp.`ID` ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}