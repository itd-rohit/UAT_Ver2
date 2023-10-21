using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Store_StoreApprovalRightMatrix : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    public static string exportToExcel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT em.name `EmployeeName`,em.House_no EmployeeCode,st.TypeName `AuthorityType`,st.AppRightFor AccessLabel,");
        sb.Append(" IF(apprightfor='PI' || apprightfor='SI',IF(showrate='0','No','Yes'),'') ShowRate,");
        sb.Append(" if(apprightfor='PO' and TypeName='Approval',ifnull(trimzero(POAppLimitPerPO),''),'')POAppLimitPerPO,");
        sb.Append(" if(apprightfor='PO' and TypeName='Approval',ifnull(trimzero(POAppLimitPerMonth),''),'')POAppLimitPerMonth,");
        sb.Append(" st.CreatedBy,DATE_FORMAT(st.CreatedDate,'%d-%b-%Y')CreatedDate  ");
        // sb.Append(" st.UpdatedBy,DATE_FORMAT(st.UpdatedDate,'%d-%b-%Y')UpdatedDate ");
        sb.Append(" FROM st_approvalright st INNER JOIN employee_master em ON em.employee_id=st.employeeid WHERE st.Active=1 ");
        sb.Append("ORDER BY st.CreatedBy,st.AppRightFor,st.TypeName ");
        sb.Append("");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt != null && dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "StoreApprovalRightMatrix";
                return "1";
            }
            else
                return "0";
        }
    }
}