using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_OPD_ProMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            cmbTitle.DataSource = AllGlobalFunction.NameTitle;
            cmbTitle.DataBind();
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        //if (txtProName1.Text.Trim() == string.Empty)
        //{
        //    lblMsg.Text = "Enter PRO Name";
        //    return;
        //}
        //else
        //{
            BindInvestigation();
        //}
    }

    private void BindInvestigation()
    {
        DataTable dt = Search();

        if (dt != null && dt.Rows.Count > 0)
        {
            grdInv.DataSource = dt;
            grdInv.DataBind();
            lblMsg.Text = dt.Rows.Count + " Record Found";
        }
        else
        {
            grdInv.DataSource = null;
            grdInv.DataBind();
            lblMsg.Text = grdInv.Rows.Count + "Record Not Found";
        }
    }

    protected void grdInv_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        DataTable dt = Search();
        grdInv.PageIndex = e.NewPageIndex;
        grdInv.DataSource = dt;
        grdInv.DataBind();
    }

    protected void grdInv_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ProName = ((Label)grdInv.SelectedRow.FindControl("lblname")).Text.ToString();
        txtproName.Text = ProName;
        cmbTitle.SelectedIndex = cmbTitle.Items.IndexOf(cmbTitle.Items.FindByText(((Label)grdInv.SelectedRow.FindControl("lblTitle")).Text.ToString()));
        txtDob.Text = ((Label)grdInv.SelectedRow.FindControl("lblDateOfBirth")).Text;
        ddlgender.SelectedIndex = ddlgender.Items.IndexOf(ddlgender.Items.FindByValue(((Label)grdInv.SelectedRow.FindControl("lblGender")).Text.ToString()));
        txtdesignation.Text = ((Label)grdInv.SelectedRow.FindControl("lblDesignation")).Text.ToString();
        txtphone1.Text = ((Label)grdInv.SelectedRow.FindControl("lblPhone")).Text.ToString();
        txtusername.Text = ((Label)grdInv.SelectedRow.FindControl("lblusername")).Text.ToString();
        txtpassword.Text = ((Label)grdInv.SelectedRow.FindControl("lblpassword")).Text.ToString();
        txtphn2.Text = ((Label)grdInv.SelectedRow.FindControl("lblPhone2")).Text.ToString();
        txtphone3.Text = ((Label)grdInv.SelectedRow.FindControl("lblPhone3")).Text.ToString();
        TxtMobileNo.Text = ((Label)grdInv.SelectedRow.FindControl("lblmobile")).Text.ToString();
        txtstate.Text = ((Label)grdInv.SelectedRow.FindControl("lblState")).Text.ToString();
        txtEmail.Text = ((Label)grdInv.SelectedRow.FindControl("lblEmail")).Text.ToString();
        txtresidenceaddress.Text = ((Label)grdInv.SelectedRow.FindControl("LblAddress")).Text.ToString();
        ViewState["PROID"] = ((Label)grdInv.SelectedRow.FindControl("lblPROID")).Text.ToString().Trim();
        if (((Label)grdInv.SelectedRow.FindControl("lblIsCreditLimit")).Text.ToString().Trim() == "1")
        {
            cbcredit.Checked = true;
            txtcredit.Text = ((Label)grdInv.SelectedRow.FindControl("lblCreditLimit")).Text.ToString().Trim();
        }
        else
        {
            cbcredit.Checked = false;
        }
        if (((Label)grdInv.SelectedRow.FindControl("lblIsActive")).Text.ToString().Trim() == "1")
            cbactive.Checked = true;
        else
            cbactive.Checked = false;
        MpeUpdate.Show();
    }

    private DataTable Search()
    {
        //StringBuilder sb = new StringBuilder();
        //if (txtProName1.Text.Trim() != string.Empty)
        //    sb.Append("SELECT Title,PROID,PROName,Designation,Phone1,Phone2,Phone3,Mobile,IsCreditLimit,CreditLimit,Address,AreaName,State,City,Pincode,Gender,Email,IsActive,date_format(DateOfBirth,'%d-%b-%Y')DateOfBirth from pro_master WHERE PROName like '%" + txtProName1.Text.Trim() + "%'");
        //sb.Append(" order by PROName");
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Title,UserName,Password, PROID, PROName, Designation, Phone1, Phone2, Phone3, Mobile, IsCreditLimit, CreditLimit, Address, AreaName, State, City, Pincode, Gender, Email, IsActive, DATE_FORMAT(DateOfBirth, '%d-%b-%Y') AS DateOfBirth ");
        sb.Append("FROM pro_master ");

        if (!string.IsNullOrEmpty(txtProName1.Text.Trim()))
        {
            sb.Append("WHERE PROName LIKE '%" + txtProName1.Text.Trim() + "%' ");
        }

        sb.Append("ORDER BY PROName");
        return StockReports.GetDataTable(sb.ToString());
    }

    protected void btnUpdatePRO_Click(object sender, EventArgs e)
    {
        
        string dob = Util.GetDateTime(txtDob.Text.Trim()).ToString("yyyy-MM-dd");
        if (dob == "")
        {
            dob = "1950-01-01";
        }
        int IsAct = 0;
        if (cbactive.Checked)
            IsAct = 1;
        int IsCredt = 0;
        string CLimit = "";
        if (cbcredit.Checked)
        {
            IsCredt = 1;
            CLimit = txtcredit.Text.ToString().Trim();
        }

        StringBuilder Upd = new StringBuilder();
        Upd.Append("update pro_master set ");
        Upd.Append(" Title='" + cmbTitle.SelectedItem.Text.ToString() + "',");
        Upd.Append(" PROName='" + txtproName.Text.ToString().Trim().Replace("'", "") + "',");
        Upd.Append(" DateOfBirth='" + dob + "',");
        Upd.Append(" Gender='" + ddlgender.SelectedItem.Value.ToString() + "',");
        Upd.Append(" Designation='" + txtdesignation.Text.ToString().Trim() + "',");
        Upd.Append(" UserName='" + txtusername.Text.ToString().Trim() + "',");
        Upd.Append(" Password='" + txtpassword.Text.ToString().Trim() + "',");
        Upd.Append(" Phone1='" + txtphone1.Text.ToString().Trim() + "',");
        Upd.Append(" Phone2='" + txtphn2.Text.ToString().Trim() + "',");
        Upd.Append(" Phone3='" + txtphone3.Text.ToString().Trim() + "',");
        Upd.Append(" Mobile='" + TxtMobileNo.Text.ToString().Trim() + "',");
        Upd.Append(" State='" + txtstate.Text.ToString().Trim() + "',");
        Upd.Append(" Email='" + txtEmail.Text.ToString().Trim() + "',");
        Upd.Append(" Address='" + txtresidenceaddress.Text.ToString().Trim().Replace("'", "") + "',");

        if (IsCredt == 1)
            Upd.Append(" CreditLimit=" + CLimit + ",");

        Upd.Append(" IsActive=" + IsAct + ",");
        Upd.Append(" IsCreditLimit=" + IsCredt + "");
        Upd.Append(" where PROID='" + ViewState["PROID"].ToString() + "'");
        try
        {
            StockReports.ExecuteDML(Upd.ToString());
            lblMsg.Text = "Record Updated";
            BindInvestigation();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Record Not Updated";
        }
    }
}