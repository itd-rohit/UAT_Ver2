using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Investigation_InvComments : System.Web.UI.Page
{
    public string InvestigationID = "0";
    
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["invID"]))
                InvestigationID = Request.QueryString["invID"].ToString();
            BindSubCategory();
            BindInvestigation();
            btnSave.Visible = true;
        }
    }

    protected void BindSubCategory()
    {
        string str = " SELECT DISTINCT sm.SubCategoryID,sm.Name FROM f_subCategorymaster sm  " +
                        " INNER JOIN f_categorymaster cm ON cm.CategoryID=sm.CategoryID " +
                        " INNER JOIN f_configrelation cr ON cr.CategoryID=cm.CategoryID " +
                        " INNER JOIN f_itemmaster im ON im.SubCategoryID=sm.SubCategoryID " +
                        " INNER JOIN investigation_master inv ON inv.Investigation_Id=im.Type_ID " +
                        " WHERE ConfigRelationID IN (3) AND inv.ReportType='1' ORDER BY sm.name ";
        ddlDepartment.DataSource = StockReports.GetDataTable(str);
        ddlDepartment.DataTextField = "Name";
        ddlDepartment.DataValueField = "SubCategoryID";
        ddlDepartment.DataBind();
    }

    private void BindInvestigation()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string str = "SELECT CONCAT(im.Name,' - ',im.TestCode) as Name,im.Investigation_ID FROM  investigation_master im " +
            "   INNER JOIN f_itemmaster it ON it.Type_ID = im.Investigation_ID AND it.IsActive=1 " +
            "   INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID = it.SubCategoryID  " +
            "   INNER JOIN f_configrelation co ON co.CategoryID = sc.CategoryID AND co.ConfigRelationID=3 " +
            "   INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = im.Investigation_ID ";
            if (InvestigationID == "0" || InvestigationID == "")
            {
                str = str + "   where sc.SubCategoryID=@dept";
            }

            str = str + " and im.ReportType =1 order by im.Name ";

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str, new MySqlParameter("@dept",ddlDepartment.SelectedValue)).Tables[0];
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlInvestigation.DataSource = dt;
                ddlInvestigation.DataTextField = "Name";
                ddlInvestigation.DataValueField = "Investigation_Id";
                ddlInvestigation.DataBind();

                if (InvestigationID != "0")
                {
                    ddlInvestigation.Items.FindByValue(InvestigationID).Selected = true;
                    ddlInvestigation.Enabled = false;

                    tdDep.Visible = false;
                    ddlDepartment.Visible = false;

                    // ddlInvestigation.
                }
                LoadComments(ddlInvestigation.SelectedValue);
                //else
                //ddlInvestigation.SelectedIndex = 0;
            }
            else
            {
                ddlInvestigation.Items.Clear();
            }

            LoadComments(ddlInvestigation.SelectedValue);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void LoadComments(string InvID)
    {
        if (ddlInvestigation.SelectedIndex != -1)
        {
            string str = " SELECT Comments_ID,Investigation_ID,Comments_Head,Comments,(SELECT NAME FROM " +
                          " Investigation_master WHERE Investigation_ID='" + InvID + "')Investigation " +
                          " FROM investigation_comments WHERE Investigation_ID='" + InvID + "'";

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
        btnSave.Text = "Save";
        LoadComments(ddlInvestigation.SelectedValue);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (txtCommentsName.Text == "" || txtLimit.Text == "")
            {
                lblMsg.Text = "Please enter the information ";
                return;
            }

            //if (chkDefault.Checked)
            //{
            //    string UpdateInves_Description = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update investigation_comments set Comments='" + Util.GetString(txtLimit.Text).Replace("'", "") + "' where Investigation_Id='" + ddlInvestigation.SelectedValue + "'"));
            //}

            string header = "";
            header = txtLimit.Text;
            header = header.Replace("\'", "");
            header = header.Replace("–", "-");
            header = header.Replace("'", "");
            header = header.Replace("µ", "&micro;");
            header = header.Replace("ᴼ", "&deg;");
            header = header.Replace("#aaaaaa 1px dashed", "none");
            header = header.Replace("dashed", "none");

            if (btnSave.Text != "Update")
            {
                string Head = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into investigation_comments (Investigation_ID,Comments_Head,Comments,CreatorUSER,CreatorDate) values( @Investigation_ID,@Comments_Head,@Comments,@ID,now())",
                    new MySqlParameter("@Investigation_ID",ddlInvestigation.SelectedValue),new MySqlParameter("@Comments_Head",txtCommentsName.Text.Trim()),
                    new MySqlParameter("@Comments", Util.GetString(header).Replace("'", "") ), new MySqlParameter("@ID", Session["ID"].ToString())));
                lblMsg.Text = "Saved Successfully.";
            }
            else
            {
                string Head = Util.GetString(MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update investigation_comments set Comments_Head = @Comments_Head,Comments=@Comments,UpdateBy=@ID, UpdateRemarks=@Name,UpdateDate=NOW() Where Comments_ID =@CommentID",
                    new MySqlParameter("@Comments_Head",txtCommentsName.Text.Trim()),
                    new MySqlParameter("@Comments", Util.GetString(header).Replace("'", "")), new MySqlParameter("@ID", Session["ID"].ToString()),
                    new MySqlParameter("@Name",Session["LoginName"].ToString()),new MySqlParameter("@CommentID", ViewState["Comments_ID"].ToString())));
                ViewState["Comments_ID"] = "";
                lblMsg.Text = "Updated Successfully.";
            }

            tnx.Commit();
           

            btnSave.Text = "Save";
            txtLimit.Text = "";
            txtCommentsName.Text = "";
            //chkDefault.Checked = false;
            LoadComments(ddlInvestigation.SelectedValue);
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

    protected void grdTemplate_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (e.CommandName == "Reject")
            {
                btnSave.Text = "Save";
                string Comments_ID = e.CommandArgument.ToString();
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Delete from investigation_comments where Comments_ID =@Comments_ID", new MySqlParameter("@Comments_ID", Comments_ID));
                lblMsg.Text = "Deleted Successfully";
                txtLimit.Text = "";
                txtCommentsName.Text = "";
                LoadComments(ddlInvestigation.SelectedValue);
            }
            else if (e.CommandName == "vEdit")
            {
                string Comments_ID = e.CommandArgument.ToString();

                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "Select * from investigation_comments where Comments_ID =@Comments_ID", new MySqlParameter("@Comments_ID", Comments_ID)).Tables[0];
                if (dt != null && dt.Rows.Count > 0)
                {
                    txtCommentsName.Text = dt.Rows[0]["Comments_Head"].ToString();
                    txtLimit.Text = Server.HtmlDecode(Util.GetString(dt.Rows[0]["Comments"]));
                    btnSave.Text = "Update";
                    ViewState["Comments_ID"] = Comments_ID;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void ddlDepartment_SelectedIndexChanged(object sender, EventArgs e)
    {
        btnSave.Text = "Save";
        BindInvestigation();
    }
}