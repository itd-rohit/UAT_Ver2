using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_InqueryCategory_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindGroup();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindCategory()
    {


        DataTable dt = StockReports.GetDataTable(" SELECT cm.ID,cm.CategoryName,cm.IsActive,cgm.GroupID,cgm.GroupName FROM CutomerCare_Category_Master cm inner join CutomerCare_Group_Master cgm on cgm.GroupID=cm.GroupID  ORDER BY cm.ID DESC ");
        if (dt.Rows.Count > 0)
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        else
            return null;
    }

    [WebMethod(EnableSession = true)]
    public static string SaveCategory(string CategoryName, string Id, string status, string GroupID)
    {
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Id == "")
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM CutomerCare_Category_Master WHERE CategoryName='" + CategoryName + "'"));
                if (count > 0)
                {
                    return "2";
                }
                else
                {
                    sb.Append(" INSERT INTO CutomerCare_Category_Master(GroupID,CategoryName,IsActive,CreatedBy,CreatedID,CreatedDate)  VALUES('" + GroupID + "','" + CategoryName + "','" + status + "','" + UserInfo.LoginName + "','" + UserInfo.ID + "',Now())");
                }
            }
            else
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM CutomerCare_Category_Master WHERE CategoryName='" + CategoryName + "' and  ID<>'" + Id + "'"));
                if (count > 0)
                {
                    return "2";
                }
                else
                {
                    sb.Append("update CutomerCare_Category_Master set IsActive='" + status + "',GroupID='" + GroupID + "',CategoryName='" + CategoryName + "', UpdatedBy='" + UserInfo.LoginName + "',UpdatedID='" + UserInfo.ID + "',UpdatedDate=Now() ");
                    sb.Append(" Where  ID='" + Id + "' ");
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

    public void bindGroup()
    {
        DataTable dt = StockReports.GetDataTable("SELECT GroupID,GroupName FROM CutomerCare_Group_Master where IsActive=1 ORDER BY GroupName asc ");
        ddlgroup.DataSource = dt;
        ddlgroup.DataTextField = "GroupName";
        ddlgroup.DataValueField = "GroupID";
        ddlgroup.DataBind();
        ddlgroup.Items.Insert(0, new ListItem { Text = "-----Select-----", Value = "0" });
        
    }
}