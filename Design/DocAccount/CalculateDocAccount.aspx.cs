using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_DocAccount_CalculateDocAccount : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            bindCentre();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
    }

    private void bindCentre()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT CONCAT(CentreCode,' ~ ',Centre)Centre,CentreID FROM centre_master WHERE Category='Lab' AND IsActive=1"))
        {
            if (dt.Rows.Count > 0)
            {
                lstCentre.DataSource = dt;
                lstCentre.DataTextField = "Centre";
                lstCentre.DataValueField = "CentreID";
                lstCentre.DataBind();
            }
        }
        using (DataTable dt = StockReports.GetDataTable("select Name,SubcategoryID from f_subcategorymaster"))
        {
            if (dt.Rows.Count > 0)
            {
                lstDepartment.DataSource = dt;
                lstDepartment.DataTextField = "Name";
                lstDepartment.DataValueField = "SubcategoryID";
                lstDepartment.DataBind();
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindDoctor(int Status)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Doctor_ID,Name DoctorName FROM doctor_referal ");
        if (Status != 2)
            sb.Append(" where IsActive = " + Status + "");
        sb.Append("  order by name ");
        sb.Append(" ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return Util.getJson(dt);
    }

    [WebMethod(EnableSession = true)]
    public static string getReport(string CentreID, string fromDate, string toDate, string DepartmentID, string DoctorID, string ReportType, string ChkCredit)
    {
        try
        {
            return JsonConvert.SerializeObject(new { CentreID = CentreID, fromDate = fromDate, toDate = toDate, DepartmentID = DepartmentID, DoctorID = DoctorID, ReportType = ReportType, ChkCredit = ChkCredit });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
}