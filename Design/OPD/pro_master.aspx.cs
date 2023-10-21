using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI;

public partial class Design_OPD_pro_master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            cmbTitle.DataSource = AllGlobalFunction.NameTitle;
            cmbTitle.DataBind();
            calDOB.EndDate = DateTime.Now;
        }
    }

    protected void btnSaveDoc_Click(object sender, EventArgs e)
    {
        if (txtproName.Text.Trim() == string.Empty)
        {
            lblerrmsg.Text = "Name Cant Be Blank";
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int isactive = 0, iscreditlimit = 0;
            pro_master objpro = new pro_master(Tranx);
            objpro.Title = cmbTitle.SelectedItem.Text;
            objpro.PROName = txtproName.Text;
            objpro.DateOfBirth = Util.GetDateTime(txtDOB.Text);
            objpro.Gender = ddlgender.SelectedItem.Value;
            objpro.Designation = txtdesignation.Text;
            objpro.Phone1 = txtphone1.Text;
            objpro.Phone2 = txtphn2.Text;
            objpro.Phone3 = txtphone3.Text;
            objpro.Email = txtEmail.Text;
            objpro.State = txtstate.Text;
            objpro.Address = txtresidenceaddress.Text;
            objpro.Mobile = TxtMobileNo.Text;
            objpro.UserName = txtusername.Text;
            objpro.Password = txtpassword.Text;
            if (cbactive.Checked)
                isactive = 1;
            objpro.IsActive = isactive;
            if (cbcredit.Checked)
            {
                iscreditlimit = 1;
                objpro.IsCreditLimit = iscreditlimit;
                objpro.CreditLimit = Util.GetFloat(txtcredit.Text.ToString().Trim());
            }
            else
            {
                iscreditlimit = 0;
                objpro.IsCreditLimit = iscreditlimit;
            }
            objpro.Insert();
            Tranx.Commit();
            lblerrmsg.Text = "Record Saved Successfully";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully');location.href='pro_master.aspx';", true);
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblerrmsg.Text = "Record Not Saved ";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}