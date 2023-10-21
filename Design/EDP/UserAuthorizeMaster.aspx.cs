using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Web;
using System.Web.Services;
using System.Xml.Serialization;
using Newtonsoft.Json;
public partial class Design_EDP_UserAuthorizeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
          //  BindLoginType();
            BindUser();
        }
    }
    private void BindLoginType()
    {
        string str = "select ID,RoleName from f_rolemaster where active=1 order by RoleName";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlLoginType.DataSource = dt;
            ddlLoginType.DataTextField = "RoleName";
            ddlLoginType.DataValueField = "ID";
            ddlLoginType.DataBind();
        }
    }
    private void BindUser()
    {
        string str = "SELECT Employee_ID,Name FROM employee_master WHERE isactive='1' order by name ";
        DataTable dtuser = StockReports.GetDataTable(str);
        if (dtuser != null && dtuser.Rows.Count > 0)
        {
            ddlUser.DataSource = dtuser;
            ddlUser.DataTextField = "Name";
            ddlUser.DataValueField = "Employee_ID";
            ddlUser.DataBind();
			ddlUser.Items.Insert(0, "");
        }
		
    }
	 [WebMethod(EnableSession = true)]
	public static string BindRoleUserWise(string UserID)
    {
        string str = "SELECT DISTINCT RoleId,RoleName FROM f_login fl INNER JOIN f_rolemaster fr ON fl.RoleID=fr.ID AND employeeID='"+ UserID +"' order by RoleName ";
        DataTable dtuser = StockReports.GetDataTable(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(dtuser);
	}
}