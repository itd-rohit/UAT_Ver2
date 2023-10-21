using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_Sales_EnrolmentSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    [WebMethod]
    public static string bindEnrolment(string fromDate, string toDate)
    {
         StringBuilder sb = new StringBuilder();
         sb.Append(" SELECT sm.ID,sm.Company_Name,sm.CreatedBy,DATE_FORMAT(sm.CreatedDate,'%d-%b-%Y')CreatedDate, ");
         sb.Append(" sm.Mobile,CONCAT(em.Title,' ', em.Name)Name,sm.TypeName,ISEnroll FROM sales_enrolment_master sm ");
         sb.Append(" INNER JOIN employee_master em ON sm.SalesEmployeeID=em.Employee_ID ");
         sb.Append(" WHERE  IsSalesApproved=1 AND IsFinancialApproved=1 ");
         sb.Append(" AND sm.CreatedDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
         sb.Append(" AND sm.CreatedDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    
    [WebMethod]
    public static string checkEnrolment(string ID)
    {
     
        int count = Util.GetInt(StockReports.ExecuteScalar(string.Format("SELECT COUNT(*) FROM sales_enrolment_master WHERE ID='{0}' AND isEnroll=1", ID)));
        if (count > 0)
            return "1";
        else
           return Common.Encrypt(ID);      
    }
}