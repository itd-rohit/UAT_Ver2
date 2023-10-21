using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Master_DiscountApproval : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblMsg.Text = "";
            txtDiscountApproval.Text = "";
            bindDiscountApproval();
            BtnSaveDiscountApproval.Text = "Save";
        }
    }

    private bool CheckDuplicate()
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_discountapproval WHERE ApprovalType='" + txtDiscountApproval.Text.Trim() + "'"));
        if (count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    protected void BtnSaveDiscountApproval_Click(object sender, EventArgs e)
    {
        if (txtDiscountApproval.Text == "")
        {
            lblMsg.Text = "Discount Approval Name can't be empty";
            return;
        }
        if (BtnSaveDiscountApproval.Text == "Update")
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();

            string str = "update f_discountapproval set IsActive='" + ddlActive.SelectedValue + "',ApprovalType='" + txtDiscountApproval.Text + "' ,UpdatedBy='" + Session["LoginName"] + "',UpdatedByID='" + Session["ID"] + "',UpdatedOn=NOW()  where ID='" + txtID.Text + "'";
            MySqlCommand cmd = new MySqlCommand(str, con);
            cmd.ExecuteNonQuery();
            con.Close();
            lblMsg.Text = "Updated";
            bindDiscountApproval();
            BtnSaveDiscountApproval.Text = "Save";
            txtDiscountApproval.Text = "";
        }
        else
        {
            if (CheckDuplicate())
            {
                lblMsg.Text = "Discount Approval Person already Exist....";
                return;
            }
            else
            {
                string instCentre = "insert into f_discountapproval (ApprovalType,IsActive,CreatedByID,CreatedBy,CreatedOn) values(UCASE('" + txtDiscountApproval.Text + "'),'" + ddlActive.SelectedValue + "','" + Session["ID"] + "','" + Session["LoginName"] + "',NOW())";
                StockReports.ExecuteScalar(instCentre);
                lblMsg.Text = "Saved";
                txtDiscountApproval.Text = "";

                bindDiscountApproval();
            }
        }
    }

    private void bindDiscountApproval()
    {
        string mystr = "SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,ApprovalType FROM f_discountapproval";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(mystr);
        GrdCentres.DataSource = dt;
        GrdCentres.DataBind();
    }

    protected void GrdCentres_SelectedIndexChanged(object sender, EventArgs e)
    {
        BtnSaveDiscountApproval.Text = "Update";

        string ID = ((Label)GrdCentres.SelectedRow.FindControl("local_ID")).Text;

        txtID.Text = ID;

        DataTable dt = StockReports.GetDataTable("SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,ApprovalType FROM f_discountapproval where ID=" + ID);
        if (dt.Rows.Count > 0)
        {
            txtDiscountApproval.Text = dt.Rows[0]["ApprovalType"].ToString();
            if (dt.Rows[0]["Active"].ToString() == "No")
            {
                ddlActive.SelectedIndex = 0;
            }
            else
            {
                ddlActive.SelectedIndex = 1;
            }
        }
    }
}