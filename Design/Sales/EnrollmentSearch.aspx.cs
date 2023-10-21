using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Sales_EnrollmentSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            lblView.Text = Common.Encrypt("1");
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod]
    public static string searchEnrollment(string fromDate, string toDate, int searchType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.ID EnrollID, Company_Name,em.TypeName,em.add1,em.payment_mode,em.MinBusinessCommitment, ec.IsVerified,em.InvoiceBillingCycle,em.CreatedBy, ");
        sb.Append(" CASE WHEN em.IsApproved=1 THEN 1 WHEN ec.IsVerified=1 AND ec.IsDirectApprove=1  THEN 0  WHEN ec.IsVerified=1 AND ec.IsDirectApprove=0  THEN 1  ");
        sb.Append(" ELSE 0 END CanApprove , ");
        sb.Append(" DATE_FORMAT(em.CreatedDate,'%d-%b-%Y') CreatedDate, ");
        sb.Append(" ec.EmployeeID ApprovalPendingByID,em.isEnroll,ec.IsVerified empApprove,ec.IsVerified empVerified, em.IsActive, ");
        sb.Append(" em.IsSalesApproved,em.IsFinancialApproved,ec.IsDirectApprove,em.IsApproved ");
        sb.Append(" FROM sales_enrolment_master em INNER JOIN sales_employee_centre ec ON em.ID=ec.EnrollID AND ec.EmployeeID='" + UserInfo.ID + "'");

        sb.Append(" WHERE em.CreatedDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND em.CreatedDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (searchType == 1)
        {
            sb.Append(" AND ec.IsVerified=0 AND ec.IsApproved=0 ");
        }
        else if (searchType == 2)
        {
            sb.Append(" AND ec.IsVerified=1 ");
        }
        else if (searchType == 3)
        {
            sb.Append(" AND em.IsApproved=1 ");
        }
        else if (searchType == 4)
        {
            sb.Append(" AND em.IsSalesApproved=1 ");
        }
        else if (searchType == 5)
        {
            sb.Append(" AND em.IsFinancialApproved=1 ");
        }
        else if (searchType == 6)
        {
            sb.Append(" AND em.isEnroll=1 ");

        }
        else if (searchType == 7)
        {
            sb.Append(" AND em.IsActive=0 ");
        }

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }
    [WebMethod]
    public static string encryptEnroll(string EnrollID, string ApprovalPendingByID, string Status)
    {

        List<string> addEncrypt = new List<string>();
        if (Status == "IsEnroll")
        {
            int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) from sales_enrolment_master WHERE  IsApproved=1 AND ID='" + EnrollID + "'"));
            if (count > 0)
            {
                addEncrypt.Add("1");
                return JsonConvert.SerializeObject(addEncrypt);
            }
        }

        addEncrypt.Add(Common.Encrypt(EnrollID));
        addEncrypt.Add(Common.Encrypt(ApprovalPendingByID));

        return JsonConvert.SerializeObject(addEncrypt);
    }
    [WebMethod]
    public static string HLMReport(int ID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT IsHLMOP,IsHLMIP,IsHLMICU,HLMOPHikeInMRP,HLMIPHikeInMRP,HLMICUHikeInMRP,HLMOPClientShare,HLMIPClientShare,HLMICUClientShare,TagProcessingLabID FROM sales_enrolment_master WHERE ID='" + ID + "' ");
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT im.TypeName ItemName, rat.Rate MRP,ROUND(rat.Rate+ ((rat.Rate*" + Util.GetDecimal(dt.Rows[0]["HLMOPHikeInMRP"].ToString()) + ")/100))OPMRP ");
        if (dt.Rows[0]["IsHLMIP"].ToString() == "1")
            sb.Append("  ,ROUND(rat.Rate+ ((rat.Rate*" + Util.GetDecimal(dt.Rows[0]["HLMIPHikeInMRP"].ToString()) + ")/100))IPMRP ");
        if (dt.Rows[0]["IsHLMICU"].ToString() == "1")
            sb.Append("  ,ROUND(rat.Rate+ ((rat.Rate*" + Util.GetDecimal(dt.Rows[0]["HLMICUHikeInMRP"].ToString()) + ")/100))ICUMRP ");
        sb.Append("  FROM  f_ratelist rat");
        sb.Append("  INNER JOIN f_panel_master pm ON pm.Panel_ID=rat.Panel_ID  ");
        sb.Append("  AND rat.Panel_ID=( SELECT ReferenceCode FROM f_panel_master WHERE CentreID='" + dt.Rows[0]["TagProcessingLabID"].ToString() + "' AND IsActive=1 AND PanelType='Centre'  LIMIT 1 )  ");
        sb.Append("  INNER JOIN f_itemMaster im ON im.ItemID=rat.ItemID  ");
        sb.Append(" LEFT JOIN sales_specialtest_enrolment se ON rat.itemid=se.SpecialTestID AND se.EnrollID='" + ID + "'  ");
        sb.Append("  AND se.IsActive=1  AND  HLMPrice='Gross' ");
        sb.Append(" WHERE se.ID IS NULL ");
        sb.Append(" UNION ALL ");
        sb.Append(" SELECT  im.TypeName ItemName, se.SpecialTestRate MRP,se.SpecialTestRate OPMRP ");
        if (dt.Rows[0]["IsHLMIP"].ToString() == "1")
            sb.Append(" ,se.SpecialTestRate IPMRP");
        if (dt.Rows[0]["IsHLMICU"].ToString() == "1")
            sb.Append(" ,se.SpecialTestRate ICUMRP");
        sb.Append(" FROM  sales_specialtest_enrolment se INNER JOIN f_itemMaster im ON im.ItemID=se.SpecialTestID  ");
        sb.Append(" WHERE se.EnrollID='" + ID + "' AND se.SpecialTestRate<>0 AND se.IsActive=1 AND  HLMPrice='Gross' ");
        sb.Append(" ");
        sb.Append(" ");





        DataTable dt1 = StockReports.GetDataTable(sb.ToString());

        if (dt1.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt1;
            HttpContext.Current.Session["ReportName"] = " HLM MRP Report";
            return "1";
        }
        else
            return null;

    }
}