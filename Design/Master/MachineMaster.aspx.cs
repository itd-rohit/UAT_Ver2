using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Master_MachineMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblMsg.Text = string.Empty;
            TxtCName.Text = "";

            bindcolour();
            BtnSaveCentre.Text = "Save";
            bindgrid();
        }
    }

    private void bindgrid()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,Name,Colour FROM macmaster where `IsActive`=1");
        GrdCentres.DataSource = dt;
        GrdCentres.DataBind();
    }

    private bool CheckDuplicate()
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM macmaster WHERE Name='" + TxtCName.Text.Trim() + "'"));
        if (count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    private void bindcolour()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ColorName FROM colormaster");
        ddlColour.DataSource = dt;
        ddlColour.DataTextField = "ColorName";
        ddlColour.DataValueField = "ColorName";
        ddlColour.DataBind();
        ddlColour.Items.Insert(0, new ListItem("", ""));
    }

    protected void BtnSaveCentre_Click(object sender, EventArgs e)
    {
        if (BtnSaveCentre.Text == "Update")
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();

            string str = "update macmaster set Name='" + TxtCName.Text + "',Colour='" + ddlColour.SelectedValue + "',IsActive='" + ddlActive.SelectedValue + "',UpdatedByName='" + Session["LoginName"] + "',UpdatedByID='" + Session["ID"] + "',UpdatedDate=NOW()  where ID='" + txtID.Text + "'";
            MySqlCommand cmd = new MySqlCommand(str, con);
            cmd.ExecuteNonQuery();
            con.Close();
            lblMsg.Text = "Updated";

            bindcolour();
            BtnSaveCentre.Text = "Save";
            bindgrid();
        }
        else
        {
            if (CheckDuplicate())
            {
                lblMsg.Text = "Machine Name already Exist....";
                return;
            }
            else
            {
                string instCentre = "insert into macmaster (Name,IsActive,UpdatedByName,UpdatedByID,CreatedDate,Colour) values('" + TxtCName.Text + "','" + ddlActive.SelectedValue + "','" + Session["LoginName"] + "','" + Session["ID"] + "',NOW(),'" + ddlColour.SelectedValue + "')";
                StockReports.ExecuteScalar(instCentre);
                lblMsg.Text = "Saved";
                TxtCName.Text = "";

                bindgrid();
                bindcolour();
            }
        }
    }

    protected void GrdCentres_SelectedIndexChanged(object sender, EventArgs e)
    {
        BtnSaveCentre.Text = "Update";

        string ID = ((Label)GrdCentres.SelectedRow.FindControl("local_ID")).Text;

        txtID.Text = ID;
        //DataTable dt = StockReports.GetDataTable("select * from centre_master where centreid=" + CentreId);

        DataTable dt = StockReports.GetDataTable("SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,Name,Colour FROM macmaster where ID=" + ID);
        if (dt.Rows.Count > 0)
        {
            TxtCName.Text = dt.Rows[0]["Name"].ToString();
            if (dt.Rows[0]["Active"].ToString() == "No")
            {
                ddlActive.SelectedIndex = 0;
            }
            else
            {
                ddlActive.SelectedIndex = 1;
            }
            if (dt.Rows[0]["Colour"].ToString() != "")
            {
                ddlColour.SelectedValue = dt.Rows[0]["Colour"].ToString();
            }
        }
    }
}