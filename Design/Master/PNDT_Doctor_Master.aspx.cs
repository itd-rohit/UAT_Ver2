using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Master_PNDT_Doctor_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblMsg.Text = "";
            TxtCName.Text = "";
            bindMaster();
            BtnSaveCentre.Text = "Save";
        }
    }
    private bool CheckDuplicate()
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM pndt_doctor WHERE NAME='" + TxtCName.Text.Trim() + "'"));
        if (count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    protected void BtnSaveCentre_Click(object sender, EventArgs e)
    {


        if (TxtCName.Text == "")
        {
            lblMsg.Text = "PNDT Doctor can't be empty";
            return;
        }
        if (BtnSaveCentre.Text == "Update")
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();

            string str = "update pndt_doctor set Active='" + ddlActive.SelectedValue + "',name='" + TxtCName.Text + "',UpdatedBy='" + Session["LoginName"] + "',UpdatedByID='" + Session["ID"] + "',UpdatedOn=NOW()  where ID='" + txtID.Text + "'";
            MySqlCommand cmd = new MySqlCommand(str, con);
            cmd.ExecuteNonQuery();
            con.Close();
            lblMsg.Text = "Updated";
            bindMaster();
            BtnSaveCentre.Text = "Save";
            TxtCName.Text = "";

        }
        else
        {
            if (CheckDuplicate())
            {
                lblMsg.Text = "PNDT Doctor already Exist....";
                return;
            }
            else
            {

                string instCentre = "insert into pndt_doctor (name,active,CreatedByID,CreatedBy,CreatedOn) values('" + TxtCName.Text + "','" + ddlActive.SelectedValue + "','" + Session["ID"] + "','" + Session["LoginName"] + "',NOW())";
                StockReports.ExecuteScalar(instCentre);
                lblMsg.Text = "Saved";
                TxtCName.Text = "";

                bindMaster();
            }


        }
    }

    private void bindMaster()
    {
        string mystr = "SELECT ID,IF(Active=0 OR Active IS NULL,'No','Yes')Active,NAME FROM pndt_doctor";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(mystr);
        GrdCentres.DataSource = dt;
        GrdCentres.DataBind();
    }
    protected void GrdCentres_SelectedIndexChanged(object sender, EventArgs e)
    {

        BtnSaveCentre.Text = "Update";

        string ID = ((Label)GrdCentres.SelectedRow.FindControl("local_ID")).Text;

        txtID.Text = ID;
        //DataTable dt = StockReports.GetDataTable("select * from centre_master where centreid=" + CentreId);


        DataTable dt = StockReports.GetDataTable("SELECT ID,IF(Active=0 OR Active IS NULL,'No','Yes')Active,name FROM pndt_doctor where ID=" + ID);
        if (dt.Rows.Count > 0)
        {
            TxtCName.Text = dt.Rows[0]["name"].ToString();
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