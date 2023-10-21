using System;
using System.Data;
using System.Text;
using System.Web.UI;
using MySql.Data.MySqlClient;

public partial class Design_EDP_UserAuthorization : System.Web.UI.Page
{
	

	protected void Page_Load(object sender, EventArgs e)
	{
		lblmsg.Text=Request.QueryString["msg"].ToString();
		if (!IsPostBack)
		{
			//BindRole();
		//	BindEmployee();
		//	BindAuthorityType();
			//ViewState["UserID"] = Session["ID"].ToString();
			//ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "DisplayMsg('MM02','" + lblMsg.ClientID + "');", true);
			//ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('hiii')", true);
			//Response.Write(Request.QueryString["msg"].ToString());
			lblmsg.Text=Request.QueryString["msg"].ToString();
		}
	}
	protected void btnPreview_Click(object sender, EventArgs e)
	{
		ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "window.location ='../Welcome.aspx';", true);
	}
}