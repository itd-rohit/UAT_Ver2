using System;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_Sales_FinancialVerification : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            lblIsFinancial.Text = Common.Encrypt("Financial");
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod]
    public static string bindFinancialEnrolment(string fromDate, string toDate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sm.ID,sm.Company_Name,sm.CreatedBy,DATE_FORMAT(sm.CreatedDate,'%d-%b-%Y')CreatedDate,sm.Mobile,if(IsSalesApproved=0,'No','Yes')SalesApproved, ");
        sb.Append(" CONCAT(em.Title,' ', em.Name)Name,sm.TypeName,if(IsFinancialApproved=0,'No','Yes')FinancialApproved,   ");
        sb.Append(" CASE WHEN IsSalesApproved=0 THEN 0 WHEN IsSalesApproved=1 AND IsFinancialApproved=0 THEN '1' WHEN IsFinancialApproved=1 THEN '0'  END ShowButton");
        sb.Append(" FROM sales_enrolment_master sm INNER JOIN employee_master em ON sm.SalesEmployeeID=em.Employee_ID ");
        sb.Append(" AND sm.ISEnroll=0 AND sm.IsApproved=1  ");
        sb.Append(" WHERE sm.CreatedDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND sm.CreatedDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    
    [WebMethod]
    public static string checkFinancialEnrolment(string ID)
    {
        int count= Util.GetInt(StockReports.ExecuteScalar(string.Format("SELECT COUNT(*) FROM sales_enrolment_master WHERE ID='{0}' AND IsFinancialApproved=1", ID)));
        if (count > 0)
            return "1";
        else
            return Common.Encrypt(ID);     
    }
}