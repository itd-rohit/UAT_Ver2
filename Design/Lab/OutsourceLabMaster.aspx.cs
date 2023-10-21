using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_Lab_OutsourceLabMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BtnCancel.Visible = false;
            BtnSave.Text = "Save";
            BindOutsourceLab();
            ViewState["UserID"] = Session["ID"].ToString();
            ViewState["UserName"] = Session["UserName"].ToString();
            lblUpdateRemark.Visible = false;
            txtUpdateRemark.Visible = false;
        }
    }

    private void BindOutsourceLab()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT EmailID,ID,Name,Address,Phone,Mobile,IF(Active=1,'Yes','No') Active,ContactPerson,IFNULL(UpdateRemark,'')UpdateRemark FROM outsourcelabMaster"))
        {
            GrdOutsourceLab.DataSource = dt;
            GrdOutsourceLab.DataBind();
        }
    }

    protected void BtnSave_Click(object sender, EventArgs e)
    {
        if (txtLabName.Text.Trim() == string.Empty)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Error','Please Enter Lab Name');", true);
            txtLabName.Focus();
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (BtnSave.Text == "Update")
            {
                if (txtUpdateRemark.Text.Trim() == string.Empty)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Error','Please Enter Remarks');", true);
                    txtUpdateRemark.Focus();
                    return;
                }
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " UPDATE outsourcelabMaster SET NAME=@NAME,Address=@Address,Phone=@Phone,Mobile=@Mobile,Active=@Active, UpdatedByID=@UpdatedByID,UpdatedBy= @UpdatedBy,ContactPerson= @ContactPerson,UpdateRemark=@UpdateRemark,UpdatedDate=Now(),EmailID= @EmailID WHERE ID= @ID ",
                    new MySqlParameter("@NAME", txtLabName.Text.Trim()),
                    new MySqlParameter("@Address", txtAddress.Text.Trim()),
                    new MySqlParameter("@Phone", txtPhone.Text.Trim()),
                    new MySqlParameter("@Mobile", txtMobile.Text.Trim()),
                    new MySqlParameter("@Active", ddlActive.SelectedValue),
                    new MySqlParameter("@UpdatedByID", ViewState["UserID"].ToString()),
                    new MySqlParameter("@UpdatedBy", ViewState["UserName"].ToString()),
                    new MySqlParameter("@ContactPerson", txtContactPerson.Text.Trim()),
                    new MySqlParameter("@UpdateRemark", txtUpdateRemark.Text.Trim()),
                    new MySqlParameter("@EmailID", txtemail.Text.Trim()),
                    new MySqlParameter("@ID", ViewState["ID"].ToString()));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Success','Record Updated Successfully');", true);
                BindOutsourceLab();
                BtnSave.Text = "Save";
                BtnCancel.Visible = false;
                clear();
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " INSERT INTO outsourcelabMaster (NAME,address,phone,mobile,Active,CreatedByID,CreatedBy,ContactPerson,EmailID) VALUES(@NAME,@Address,@Phone,@Mobile,@Active,@CreatedByID,@CreatedBy,@ContactPerson,@EmailID)",
                    new MySqlParameter("@NAME", txtLabName.Text.Trim()),
                     new MySqlParameter("@Address", txtAddress.Text.Trim()),
                     new MySqlParameter("@Phone", txtPhone.Text.Trim()),
                     new MySqlParameter("@Mobile", txtMobile.Text.Trim()),
                     new MySqlParameter("@Active", ddlActive.SelectedValue),
                     new MySqlParameter("@CreatedByID", ViewState["UserID"].ToString()),
                     new MySqlParameter("@CreatedBy", ViewState["UserName"].ToString()),
                     new MySqlParameter("@ContactPerson", txtContactPerson.Text.Trim()),
                     new MySqlParameter("@UpdateRemark", txtUpdateRemark.Text.Trim()),
                     new MySqlParameter("@EmailID", txtemail.Text.Trim()));
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Success','Record Saved Successfully');", true);
                txtLabName.Text = string.Empty;
                BindOutsourceLab();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Error','Error');", true);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void GrdOutsourceLab_SelectedIndexChanged(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            BtnSave.Text = "Update";
            BtnCancel.Visible = true;
            string ID = ((Label)GrdOutsourceLab.SelectedRow.FindControl("lblOutsourceLabName")).Text;
            ViewState["ID"] = ID;
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT EmailID,ID,Name,Address,Phone,Mobile,Active,ContactPerson FROM outsourcelabMaster where ID=@ID",
              new MySqlParameter("@ID", ViewState["ID"].ToString())).Tables[0])
                if (dt.Rows.Count > 0)
                {
                    txtLabName.Text = dt.Rows[0]["Name"].ToString();
                    txtAddress.Text = dt.Rows[0]["Address"].ToString();
                    txtPhone.Text = dt.Rows[0]["Phone"].ToString();
                    txtMobile.Text = dt.Rows[0]["Mobile"].ToString();
                    txtContactPerson.Text = dt.Rows[0]["ContactPerson"].ToString();

                    if (dt.Rows[0]["Active"].ToString() == "1")
                    {
                        ddlActive.SelectedIndex = 1;
                    }
                    else
                    {
                        ddlActive.SelectedIndex = 0;
                    }
                    txtemail.Text = dt.Rows[0]["EmailID"].ToString();
                    lblUpdateRemark.Visible = true;
                    spnUpdateRemark.Visible = true;
                    txtUpdateRemark.Visible = true;
                }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "toast('Error','Error');", true);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    protected void BtnCancel_Click(object sender, EventArgs e)
    {
        BtnSave.Text = "Save";
        BtnCancel.Visible = false;
        clear();
    }
    public void clear()
    {
        txtLabName.Text = string.Empty;
        txtAddress.Text = string.Empty;
        txtPhone.Text = string.Empty;
        txtMobile.Text = string.Empty;
        txtContactPerson.Text = string.Empty;
        txtemail.Text = string.Empty;
        ddlActive.SelectedIndex = 1;
        lblUpdateRemark.Visible = false;
        spnUpdateRemark.Visible = false;
        txtUpdateRemark.Visible = false;
        txtUpdateRemark.Text = string.Empty;
    }
}