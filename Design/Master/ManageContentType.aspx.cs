using MySql.Data.MySqlClient;
using System;
using System.Data;

public partial class Design_Default2 : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        if (!IsPostBack)
        {
            BindTypes();
            BindContentValue(sender, e);
        }
    }

    private void BindTypes()
    {
        DataTable ContentTye = StockReports.GetDataTable("SELECT `Type`,`Id` FROM `cms_content`");
        ddlContentType.DataSource = ContentTye;
        ddlContentType.DataTextField = "Type";
        ddlContentType.DataValueField = "Id";
        ddlContentType.DataBind();
        txtContentType.Visible = false;
        lblMessage.Visible = false;
    }

    protected void BindContentValue(object sender, EventArgs e)
    {
        ckeContentValue.Text = Util.GetStringWithoutReplace(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(),
            CommandType.Text, "SELECT `Content` FROM `cms_content` WHERE `Id`=@id",
            new MySqlParameter("@id", ddlContentType.SelectedValue)));
    }

    protected void SaveContent(object sender, EventArgs e)
    {
        try
        {
            lblMessage.Text = "";
            if (txtContentType.Visible == true)
            {
                MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text,
                    "INSERT INTO `cms_content`(`Type`,`Content`,`dtEntry`,`UpdatedById`,`UpdatedByName`,`UpdatedAt`) VALUE(@Type,@Content,@dtEntry,@UpdatedById,@UpdatedByName,@UpdatedAt)",
                    new MySqlParameter("@Type", Util.GetString(txtContentType.Text)),
                    new MySqlParameter("@Content", Util.GetStringWithoutReplace(ckeContentValue.Text)),
                        new MySqlParameter("@dtEntry", Util.GetDateTime(DateTime.Now)),
                        new MySqlParameter("@UpdatedById", Util.GetString(Session["ID"])),
                        new MySqlParameter("@UpdatedByName", Util.GetString(Session["UserName"])),
                        new MySqlParameter("@UpdatedAt", Util.GetDateTime(DateTime.Now)));
                txtContentType.Visible = false;
                BindTypes();
                ddlContentType.Visible = true;
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(Util.GetMySqlCon(), CommandType.Text,
                                    "UPDATE `cms_content` SET `Content`=@Content,`UpdatedById`=@UpdatedById,`UpdatedByName`=@UpdatedByName,`UpdatedAt`=@UpdatedAt WHERE Id=@ID",
                                    new MySqlParameter("@ID", Util.GetString(ddlContentType.SelectedValue)),
                                    new MySqlParameter("@Content", Util.GetStringWithoutReplace(ckeContentValue.Text)),
                                        new MySqlParameter("@UpdatedById", Util.GetString(Session["ID"])),
                                        new MySqlParameter("@UpdatedByName", Util.GetString(Session["UserName"])),
                                        new MySqlParameter("@UpdatedAt", Util.GetDateTime(DateTime.Now)));
            }
            ckeContentValue.Text = "";
            lblMessage.Text = "Sucessfully Saved";
            lblMessage.Visible = true;
        }
        catch (Exception ex)
        {
            lblMessage.Text = "Contact to Itdose Team";
            lblMessage.Visible = true;
        }
    }

    protected void AddNewType(object sender, EventArgs e)
    {
        txtContentType.Visible = true;
        ddlContentType.Visible = false;
        ckeContentValue.Text = "";
        txtContentType.Focus();
    }

    protected void Cancel(object sender, EventArgs e)
    {
        txtContentType.Visible = false;
        ddlContentType.Visible = true;
    }
}