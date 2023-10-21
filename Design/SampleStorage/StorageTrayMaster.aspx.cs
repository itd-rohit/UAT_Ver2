using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_SampleStorage_StorageTrayMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindSample();
            txtdeptname.Focus();

            BindGrid("");
            btnUpdate.Visible = false;
        }
    }
    private void BindSample()
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            
            sb.Append("SELECT id,samplename FROM sampletype_master WHERE isactive=1 ORDER BY samplename");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
            {
                ddlsampletype.DataValueField = "id";
                ddlsampletype.DataTextField = "samplename";
                ddlsampletype.DataSource = dt;
                ddlsampletype.DataBind();
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
    private void BindGrid(string testname)
    {
        txtdeptname.Text = "";
        chkActive.Checked = true;
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("SELECT id ID,TrayName NAME,SampleTypeID,Capacity1,Capacity2,ExpiryUnit,ExpiryType,SampleTypeName,concat(Capacity1,' X ',Capacity2) Capacity,concat(ExpiryUnit,' ',ExpiryType) Expiry, IsActive, IF(IsActive=1,'Active','Deactive') STATUS,CreatedBy ,date_format(CreatedOn,'%d-%b-%y %h:%i %p') CreatedOn FROM ss_StorageTrayMaster  ");
            if (testname != "")
            {
                sb.Append(" where TrayName like @testname");
            }
            sb.Append(" order by TrayName");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@testname", string.Format("%{0}%", testname))).Tables[0])
            {
                GridView1.DataSource = dt;
                GridView1.DataBind();
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

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string status = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label3")).Text;
        string ID = ((Label)GridView1.Rows[e.RowIndex].FindControl("Label1")).Text;
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try {
            if (status == "1")
            {
                sb.Append("update  ss_StorageTrayMaster set isactive='0' where ID=@id ");
            }
            else
            {
                sb.Append("update  ss_StorageTrayMaster set isactive='1' where ID=@id ");
            }
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@id", ID));
            lblMsg.Text = "Record Updated..!";
            BindGrid("");
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

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            string status = ((Label)e.Row.FindControl("Label3")).Text;
            string Name = ((Label)e.Row.FindControl("Label2")).Text;
            LinkButton lb = (LinkButton)e.Row.FindControl("LinkButton2");
            if (lb != null)
            {
                lb.Attributes.Add("onclick", "return ConfirmOnDelete('" + Name + "','" + status + "');");
            }

            if (status == "1")
            {
                lb.Text = "Deactive";
            }
            else
            {
                lb.Text = "Active";
            }
        }
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        clearform();
        string ID = ((Label)GridView1.SelectedRow.FindControl("Label1")).Text;
        string Name = ((Label)GridView1.SelectedRow.FindControl("Label2")).Text;
        string Status = ((Label)GridView1.SelectedRow.FindControl("Label3")).Text;

        string sampletypeid = ((Label)GridView1.SelectedRow.FindControl("lbsampletypeid")).Text;
        string c1 = ((Label)GridView1.SelectedRow.FindControl("lbcap1")).Text;
        string c2 = ((Label)GridView1.SelectedRow.FindControl("lbcap2")).Text;
        string e1 = ((Label)GridView1.SelectedRow.FindControl("lbexpunit")).Text;
        string e2 = ((Label)GridView1.SelectedRow.FindControl("lbexptype")).Text;

        txtdeptname.Text = Name;
        txtcap1.Text = c1;
        txtcap2.Text = c2;
        txtexpiry.Text = e1;


        if (sampletypeid != "")
        {
            foreach (string s in sampletypeid.Split(','))
            {
                foreach (ListItem li in ddlsampletype.Items)
                {
                    if (li.Value == s)
                    {
                        li.Selected = true;
                    }
                }
            }

        }

        ddlexpiry.SelectedValue = e2;

        txtId.Text = ID;
        if (Status == "1")
        {
            chkActive.Checked = true;
        }
        else
        {
            chkActive.Checked = false;
        }
        btnSave.Visible = false;
        btnUpdate.Visible = true;
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        BindGrid(txtsearch.Text);
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string sample = GetSelection(ddlsampletype);
        string samplename = GetSelection1(ddlsampletype);
        if (sample == "")
        {
            lblMsg.Text = "Please Select Sample Type";
            return;
        }
        int st = chkActive.Checked ? 1 : 0;

        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("  insert into ss_StorageTrayMaster (TrayName,SampleTypeID,SampleTypeName,Capacity1,Capacity2,ExpiryUnit,ExpiryType,");
            sb.Append("  IsActive, CreatedByID, CreatedBy, CreatedOn)");
            sb.Append("  values (@txtdeptname,@sample,@samplename,");
            sb.Append(" @txtcap1,@txtcap2,@txtexpiry,@ddlexpiry,");
            sb.Append("@st,@id,@LoginName,now() )");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@txtdeptname", txtdeptname.Text.ToUpper().ToString()),
            new MySqlParameter("@sample", sample),
            new MySqlParameter("@samplename", samplename),
            new MySqlParameter("@txtcap1", txtcap1.Text),
            new MySqlParameter("@txtcap2", txtcap2.Text),
            new MySqlParameter("@txtexpiry", txtexpiry.Text),
            new MySqlParameter("@ddlexpiry", ddlexpiry.Text),
            new MySqlParameter("@st", st),
            new MySqlParameter("@id", UserInfo.ID),
            new MySqlParameter("@LoginName", UserInfo.LoginName));

            lblMsg.Text = "Record Saved";
            BindGrid("");
            clearform();
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

    private void clearform()
    {
        txtdeptname.Text = "";
        txtcap1.Text = "";
        txtcap2.Text = "";
        txtexpiry.Text = "";
        ddlexpiry.SelectedIndex = 0;


        foreach (ListItem li in ddlsampletype.Items)
        {
            
                li.Selected = false;
            
        }
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        string sample = GetSelection(ddlsampletype);
        string samplename = GetSelection1(ddlsampletype);
        if (sample == "")
        {
            lblMsg.Text = "Please Select Sample Type";
            return;
        }
        string id = txtId.Text;

        int st = chkActive.Checked ? 1 : 0;

        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append("update ss_StorageTrayMaster set TrayName=@TrayName ");
            sb.Append(" ,SampleTypeID=@SampleTypeID ");
            sb.Append(",SampleTypeName=@samplename ");
            sb.Append(", Capacity1=@Capacity1");
            sb.Append(", Capacity2=@Capacity2 ");
            sb.Append(", ExpiryUnit=@ExpiryUnit ");
            sb.Append(", ExpiryType=@ExpiryType ");
            sb.Append(",IsActive=@st,UpdatedOn=now(),UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy ");

            sb.Append(" where id=@id");

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@TrayName", txtdeptname.Text.ToUpper()),
            new MySqlParameter("@SampleTypeID", sample),
            new MySqlParameter("@samplename", samplename),
            new MySqlParameter("@Capacity1", txtcap1.Text.ToUpper()),
            new MySqlParameter("@Capacity2", txtcap2.Text.ToUpper()),
            new MySqlParameter("@ExpiryUnit", txtexpiry.Text.ToUpper()),
            new MySqlParameter("@ExpiryType", ddlexpiry.SelectedValue),
            new MySqlParameter("@st", st),
            new MySqlParameter("@UpdatedByID", UserInfo.ID),
            new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
            new MySqlParameter("@id", id)
            );

            lblMsg.Text = "Record Updated";
            btnUpdate.Visible = false;
            btnSave.Visible = true;

            txtId.Text = "";
            BindGrid("");
            txtdeptname.Focus();
            clearform();
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

    protected void chkdocument_DataBound(object sender, EventArgs e)
    {
        CheckBoxList chkList = (CheckBoxList)(sender);
        foreach (ListItem item in chkList.Items)
        {
            item.Attributes.Add("id", item.Value);
            item.Attributes.Add("chk_text", item.Text);
        }
    }

    private string GetSelection(CheckBoxList cbl)
    {
        string str = string.Empty;

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += "," + li.Value + "";
                else
                    str = "" + li.Value + "";
            }
        }

        return "," + str + ","; 
    }
    private string GetSelection1(CheckBoxList cbl)
    {
        string str = string.Empty;

        foreach (ListItem li in cbl.Items)
        {
            if (li.Selected)
            {
                if (str != string.Empty)
                    str += "," + li.Text + "";
                else
                    str = "" + li.Text + "";
            }
        }

        return str;
    }
}