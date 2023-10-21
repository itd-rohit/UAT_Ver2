using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_CallCenter_CallCenterRemark : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblMsg.Text = string.Empty;
            TxtCName.Text = string.Empty;
            bindRemark();
            BtnSaveCentre.Text = "Save";
        }
    }

    private bool CheckDuplicate()
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM call_centre_remarks WHERE Remarks='" + TxtCName.Text.Trim() + "'"));
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
        if (TxtCName.Text.Trim() == string.Empty)
        {
            lblMsg.Text = "Remark Name can't be empty";
            return;
        }
        if (BtnSaveCentre.Text == "Update")
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();

            string str = "update call_centre_remarks set RemarksValue='" + TxtCName.Text + "',Remarks='" + TxtCName.Text + "',IsActive='" + ddlActive.SelectedValue + "',UpdatedBy='" + Session["LoginName"] + "',UpdatedByID='" + Session["ID"] + "',UpdatedDate=NOW()  where ID='" + txtID.Text + "'";
            MySqlCommand cmd = new MySqlCommand(str, con);
            cmd.ExecuteNonQuery();
            con.Close();
            lblMsg.Text = "Updated";
            bindRemark();
            BtnSaveCentre.Text = "Save";
            TxtCName.Text = string.Empty;
        }
        else
        {
            if (CheckDuplicate())
            {
                lblMsg.Text = "Remark already Exist....";
                return;
            }
            else
            {
                string instCentre = "insert into call_centre_remarks (RemarksValue,Remarks,IsActive,UserName,UserID,CreatedDate) values('" + TxtCName.Text + "','" + TxtCName.Text + "','" + ddlActive.SelectedValue + "','" + Session["LoginName"] + "','" + Session["ID"] + "',NOW())";
                StockReports.ExecuteScalar(instCentre);
                lblMsg.Text = "Saved";
                TxtCName.Text = "";

                bindRemark();
            }
        }
    }

    private void bindRemark()
    {

        DataTable dt = StockReports.GetDataTable("SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,Remarks NAME FROM call_centre_remarks");
        GrdCentres.DataSource = dt;
        GrdCentres.DataBind();
    }

    protected void GrdCentres_SelectedIndexChanged(object sender, EventArgs e)
    {
        BtnSaveCentre.Text = "Update";

        string ID = ((Label)GrdCentres.SelectedRow.FindControl("local_ID")).Text;

        txtID.Text = ID;
        //DataTable dt = StockReports.GetDataTable("select * from centre_master where centreid=" + CentreId);

        DataTable dt = StockReports.GetDataTable("SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,Remarks name FROM call_centre_remarks where ID=" + ID);
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