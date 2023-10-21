using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_CallCenter_InqueryCategory_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    [WebMethod(EnableSession = true)]
    public static string BindDepartment()
    {


        DataTable dt = StockReports.GetDataTable(" SELECT DepartmentID,DepartmentName,IsActive,IsLabDepartment FROM CutomerCare_Department_Master ORDER BY DepartmentID DESC ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return null;
    }

    [WebMethod(EnableSession = true)]
    public static string SaveDepartment(string DepartmentName, string DepartmentID, string status)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (DepartmentID == "")
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM CutomerCare_Department_Master WHERE DepartmentName='" + DepartmentName + "'"));
                if (count > 0)
                {
                    return "2";
                }
                else
                {
                    sb.Append(" INSERT INTO CutomerCare_Department_Master(DepartmentName,IsActive,CreatedBy,CreatedID,CreatedDate)  VALUES('" + DepartmentName + "','" + status + "','" + UserInfo.LoginName + "','" + UserInfo.ID + "',Now())");
                }
            }
            else
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM CutomerCare_Department_Master WHERE DepartmentName='" + DepartmentName + "' and  DepartmentID<>'" + DepartmentID + "'"));
                if (count > 0)
                {
                    return "2";
                }
                else
                {
                    sb.Append("update CutomerCare_Department_Master set IsActive='" + status + "',DepartmentName='" + DepartmentName + "', UpdatedBy='" + UserInfo.LoginName + "',UpdatedID='" + UserInfo.ID + "',UpdatedDate=Now() ");
                    sb.Append(" Where  DepartmentID='" + DepartmentID + "' ");
                }
            }
            StockReports.ExecuteDML(sb.ToString());
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
}