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
    public static string BindGroup()
    {


        DataTable dt = StockReports.GetDataTable(" SELECT GroupID,GroupName,IsActive FROM CutomerCare_Group_Master ORDER BY GroupID DESC ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return null;
    }

    [WebMethod(EnableSession = true)]
    public static string SaveGroup(string GroupName, string Id, string status)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Id == "")
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM CutomerCare_Group_Master WHERE GroupName='" + GroupName + "'"));
                if (count > 0)
                {
                    return "2";
                }
                else
                {
                    sb.Append(" INSERT INTO CutomerCare_Group_Master(GroupName,IsActive,CreatedBy,CreatedID,CreatedDate)  VALUES('" + GroupName + "','" + status + "','" + UserInfo.LoginName + "','" + UserInfo.ID + "',Now())");
                }
            }
            else
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM CutomerCare_Group_Master WHERE GroupName='" + GroupName + "' and  GroupID<>'" + Id + "'"));
                if (count > 0)
                {
                    return "2";
                }
                else
                {
                    sb.Append("update CutomerCare_Group_Master set IsActive='" + status + "',GroupName='" + GroupName + "', UpdatedBy='" + UserInfo.LoginName + "',UpdatedID='" + UserInfo.ID + "',UpdatedDate=Now() ");
                    sb.Append(" Where  GroupID='" + Id + "' ");
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