using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Investigation_InvTemplate : System.Web.UI.Page
{
    public string InvestigationID = "0";

    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["invID"]))
                InvestigationID = Request.QueryString["invID"].ToString();
            AllLoad_Data.bindSubCategory(ddlDepartment);
            BindInvestigation();
            btnSave.Visible = true;
           // BindLabObs();
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindLabObs()
    {
        try
        {
            DataTable dt = StockReports.GetDataTable(" Select LabObservation_ID,Name from labobservation_master ");
            string retr = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return retr;
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }

    }
    //private void BindLabObs()
    //{
    //    DataTable dt = StockReports.GetDataTable(" Select LabObservation_ID,Name from labobservation_master ");
    //    ddlLabObservation.DataSource = dt;
    //    ddlLabObservation.DataTextField = "Name";
    //    ddlLabObservation.DataValueField = "LabObservation_ID";
    //    ddlLabObservation.DataBind();
    //}
    private void BindInvestigation()
    {
        string str = "SELECT CONCAT(im.Name,' - ',im.TestCode) as Name,im.Investigation_ID FROM  investigation_master im " +
        "   INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID AND it.IsActive=1 " +
        "   INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = it.SubCategoryID  " +
        "   INNER JOIN f_configrelation co ON co.CategoryID = sc.CategoryID AND co.ConfigRelationID=3 " +
        "   INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID";
        if (InvestigationID == "0")
        {
            str = str + "  where sc.SubCategoryID='" + ddlDepartment.SelectedValue + "'";
        }

        if (Util.GetString(Session["RoleID"]) == "11")
            str = str + " and im.ReportType in (3) ";
        else if (Util.GetString(Session["RoleID"]) == "15")
            str = str + " and im.ReportType in (5) ";
        else
            str = str + " and im.ReportType in (3,5)";
        str = str + "   ORDER BY im.Name";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlInvestigation.DataSource = dt;
            ddlInvestigation.DataTextField = "Name";
            ddlInvestigation.DataValueField = "Investigation_Id";
            ddlInvestigation.DataBind();
            if (InvestigationID != "0")
            {
                ddlDepartment.Visible = false;
                ddlInvestigation.Items.FindByValue(InvestigationID).Selected = true;
                ddlInvestigation.Enabled = false;
                LoadTemplate();
                dtDept.Visible = false;
            }
            else
                ddlInvestigation.SelectedIndex = 0;
        }
        else
        {
            ddlInvestigation.Items.Clear();
        }

        LoadTemplate();
    }

    private void LoadTemplate()
    {
        if (ddlInvestigation.SelectedIndex != -1)
        {
            string str = "Select Template_ID,Investigation_ID,Temp_Head,Template_Desc,(Select Name from " +
                  "Investigation_master where Investigation_ID='" + ddlInvestigation.SelectedValue + "')Investigation " +
                  "from investigation_template where Investigation_ID='" + ddlInvestigation.SelectedValue + "'";

            DataTable dt = StockReports.GetDataTable(str);

            if (dt != null && dt.Rows.Count > 0)
            {
                grdTemplate.DataSource = dt;
                grdTemplate.DataBind();
            }
            else
            {
                grdTemplate.DataSource = null;
                grdTemplate.DataBind();
            }
        }
    }

    protected void ddlInvestigation_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadTemplate();
    }

    public bool validation()
    {
        if (ddlInvestigation.SelectedIndex == -1)
        {
            lblMsg.Text = "Please Select Investigation..!";
            return false;
        }
        if (txtTemplate.Text == "")
        {
            lblMsg.Text = "Please Enter Template Name..!";
            return false;
        }
        if (txtLimit.Text == "")
        {
            lblMsg.Text = "Please Enter Template Text..!";
            return false;
        }
        return true;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (validation() == true)
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            string header = "";
            header = txtLimit.Text;
            header = header.Replace("\'", "");
            header = header.Replace("–", "-");
            header = header.Replace("'", "");
            header = header.Replace("µ", "&micro;");
            header = header.Replace("ᴼ", "&deg;");
            header = header.Replace("#aaaaaa 1px dashed", "none");
            header = header.Replace("dashed", "none");

            try
            {
                if (chkDefault.Checked)
                {
                    string UpdateInves_Description = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update investigation_master set LabInves_Description='" + Util.GetString(header).Replace("'", "") + "' where Investigation_Id='" + ddlInvestigation.SelectedValue + "'"));
                }

                if (btnSave.Text != "Update")
                {
                    string Head = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into investigation_template (Investigation_ID,Temp_Head,Template_Desc,Gender) values( '" + ddlInvestigation.SelectedValue + "','" + txtTemplate.Text.Trim() + "','" + header + "','"+rblgender.SelectedValue+"')"));
                    lblMsg.Text = "Saved Successfully.";
                }
                else
                {
                    string Head = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update investigation_template set Temp_Head = '" + txtTemplate.Text.Trim() + "',Template_Desc='" + header + "',Gender='" + rblgender.SelectedValue + "' Where Template_ID =" + ViewState["Template_ID"].ToString()));
                    ViewState["Template_ID"] = "";
                    lblMsg.Text = "Updated Successfully.";
                }

                tnx.Commit();
               

                btnSave.Text = "Save";
                txtLimit.Text = "";
                txtTemplate.Text = "";
                chkDefault.Checked = false;
                LoadTemplate();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lblMsg.Text = ex.Message;
                tnx.Rollback();
                
            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void grdTemplate_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Reject")
        {
            string Template_ID = e.CommandArgument.ToString();
            StockReports.ExecuteDML("Delete from investigation_template where Template_ID =" + Template_ID);
            lblMsg.Text = "Deleted Successfully";
            txtLimit.Text = "";
            txtTemplate.Text = "";
            LoadTemplate();
        }
        else if (e.CommandName == "vEdit")
        {
            string Template_ID = e.CommandArgument.ToString();

            DataTable dt = StockReports.GetDataTable("Select * from investigation_template where Template_ID =" + Template_ID);

            if (dt != null && dt.Rows.Count > 0)
            {
                txtTemplate.Text = dt.Rows[0]["Temp_Head"].ToString();
                txtLimit.Text = Server.HtmlDecode(Util.GetString(dt.Rows[0]["Template_Desc"]));
                rblgender.SelectedValue = dt.Rows[0]["gender"].ToString();
                btnSave.Text = "Update";
                ViewState["Template_ID"] = Template_ID;
            }
        }
    }

    protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindInvestigation();
    }
}