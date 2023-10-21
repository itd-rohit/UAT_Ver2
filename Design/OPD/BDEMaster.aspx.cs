using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_OPD_BDEMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnSave_Click1(object sender, EventArgs e)
    {
        string active = "";
        try
        {
            if (txtName.Text.Trim() == string.Empty)
            {
                lblmsg.Text = "Name Field cannot be blank.";
            }
            else
            {
                if (chkActive.Checked == true)
                    active = "1";
                else
                    active = "0";
                string str = "insert into bde_master(bdename,Phone,IsActive)values('" + txtName.Text + "','" + txtPhone1.Text + "','" + active + "')";
                StockReports.ExecuteScalar(str);
                lblmsg.Text = "Record Saved.";
                Clear();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = "error...";
        }
    }

    protected void btnSearch_Click1(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable("select * from bde_master where bdename like '" + txtSearch.Text + "%'");
        if (dt.Rows.Count > 0)
        {
            grdShare.DataSource = dt;
            grdShare.DataBind();
        }
        else
        {
            lblmsg.Text = "No Records Found";
        }
    }

    public void Clear()
    {
        txtName.Text = string.Empty;
        txtPhone1.Text = string.Empty;
    }

    protected void grdShare_SelectedIndexChanged(object sender, EventArgs e)
    {
        string active;
        string[] s = ((Label)grdShare.SelectedRow.FindControl("lblrecord")).Text.Split('#');
        ViewState["Id"] = s[0].ToString();
        Label1.Text = s[0].ToString();
        txtName.Text = s[1].ToString();
        // txtAge.Text = s[2].ToString();
        //TxtMobileNo.Text = s[3].ToString();
        txtPhone1.Text = s[2].ToString();
        // txtAdd.Text = s[5].ToString();
        // txtDOB.Text = s[6].ToString();
        //if (s[6].ToString() == "1/1/0001 12:00:00 AM")
        //{
        //    txtDOB.Text = "";
        //}
        active = s[3].ToString();
        if (active == "True")
            chkActive.Checked = true;
        else
            chkActive.Checked = false;
        btnUpdate.Visible = true;
        btnSave.Visible = false;
        lblmsg.Text = string.Empty;
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        string active;
        try
        {
            if (txtName.Text == "")
            {
                lblmsg.Text = "Name Field cannot be blank.";
            }
            else
            {
                if (chkActive.Checked == true)
                    active = "1";
                else
                    active = "0";
                string str = "update bde_master set bdename='" + txtName.Text + "',Phone='" + txtPhone1.Text + "',IsActive = '" + active + "' where ID='" + Label1.Text + "' ";
                StockReports.ExecuteDML(str);
                lblmsg.Text = "Record Updated.";
                Clear();
                btnUpdate.Visible = false;
                btnSave.Visible = true;
                DataTable dt = StockReports.GetDataTable("select * from bde_master where bdename like '" + txtSearch.Text + "%'");
                if (dt.Rows.Count > 0)
                {
                    grdShare.DataSource = dt;
                    grdShare.DataBind();
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblmsg.Text = "error...";
        }
    }
}