using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Master_DiscountReason : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblMsg.Text = "";
            txtName.Text = "";
            bindName();
            BtnSaveName.Text = "Save";
        }
    }

    private bool CheckDuplicate()
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM f_discountreason WHERE DiscReason='" + txtName.Text.Trim() + "'"));
        if (count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    protected void BtnSaveName_Click(object sender, EventArgs e)
    {
        if (txtName.Text == "")
        {
            lblMsg.Text = "Reason can't be empty";
            return;
        }
        if (BtnSaveName.Text == "Update")
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();

            string str = "update f_discountreason set IsActive='" + ddlActive.SelectedValue + "',DiscReason='" + txtName.Text + "',UpdatedBy='" + Session["LoginName"] + "',UpdatedByID='" + Session["ID"] + "',UpdatedOn=NOW()  where ID='" + txtID.Text + "'";
            MySqlCommand cmd = new MySqlCommand(str, con);
            cmd.ExecuteNonQuery();
            con.Close();
            lblMsg.Text = "Updated";
            bindName();
            BtnSaveName.Text = "Save";
            txtName.Text = "";
        }
        else
        {
            if (CheckDuplicate())
            {
                lblMsg.Text = "Reason already Exist....";
                return;
            }
            else
            {
                string instCentre = "insert into f_discountreason (DiscReason,IsActive,CreatedByID,CreatedBy,CreatedOn) values('" + txtName.Text + "','" + ddlActive.SelectedValue + "','" + Session["ID"] + "','" + Session["LoginName"] + "',NOW())";
                StockReports.ExecuteScalar(instCentre);
                lblMsg.Text = "Saved";
                txtName.Text = "";

                bindName();
            }
        }
    }

    private void bindName()
    {
        string mystr = "SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,DiscReason FROM f_discountreason";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(mystr);
        GrdCentres.DataSource = dt;
        GrdCentres.DataBind();
    }

    protected void GrdCentres_SelectedIndexChanged(object sender, EventArgs e)
    {
        BtnSaveName.Text = "Update";

        string ID = ((Label)GrdCentres.SelectedRow.FindControl("local_ID")).Text;

        txtID.Text = ID;

        DataTable dt = StockReports.GetDataTable("SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,DiscReason FROM f_discountreason where ID=" + ID);
        if (dt.Rows.Count > 0)
        {
            txtName.Text = dt.Rows[0]["DiscReason"].ToString();
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