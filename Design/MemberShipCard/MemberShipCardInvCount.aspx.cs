using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_MemberShipCard_MemberShipCardInvCount : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Util.getApp("MemberShipCard") == "N")
        {
            Response.Redirect("../../Store/UnAuthorized.aspx");
        }
        if (!IsPostBack)
        {
            LoadMembershipCards();
        }
    }

    private void LoadMembershipCards()
    {
        string str = "SELECT id,concat(name,' # ',amount,' ~ ',DiscountInPercentage,'%') name FROM membership_card_master WHERE IsActive = 1 ORDER BY NAME";

        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);
        ddlMembershipCard.DataSource = dt;
        ddlMembershipCard.DataTextField = "Name";
        ddlMembershipCard.DataValueField = "ID";
        ddlMembershipCard.DataBind();
        ddlMembershipCard.Items.Insert(0, new ListItem("Select", "0"));

       
    }

    protected void ddlLoginType_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadmemebrshipcardinv();
    }

    private void loadmemebrshipcardinv()
    {
        lblmsg.Text = "";
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ItemName invname,ItemID,invcount,sc.name deptname FROM  ");
        sb.Append("  Membershipcard_Tests ir INNER JOIN f_subcategorymaster sc  ON sc.Subcategoryid=ir.Subcategoryid ");
        sb.Append(" and ir.CardID='" + ddlMembershipCard.SelectedValue + "' order by Name ");

        DataTable dt = new DataTable();
        dt=StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            grv.DataSource = dt;
            grv.DataBind();
        }
        else
        {
            grv.DataSource = "";
            grv.DataBind();
            lblmsg.Text = "Please Add Investigation in this Card..!";
        }
   }


    protected void save_Click(object sender, EventArgs e)
    {
        foreach (GridViewRow drw in grv.Rows)
        {
            CheckBox ch = (CheckBox)drw.FindControl("ch");
            Label lbinv = (Label)drw.FindControl("lbinv");
            TextBox txtcount = (TextBox)drw.FindControl("txtcount");
            if (ch.Checked)
            {
                if (txtcount.Text != "")
                {
                    bool a = StockReports.ExecuteDML("UPDATE  Membershipcard_Tests SET invcount='" + txtcount.Text + "' WHERE cardid='" + ddlMembershipCard.SelectedValue + "' AND investigation_id='" + lbinv.Text + "' ");
                    if (a == true)
                    {
                        lblmsg.Text = "Record Saved..!";

                    }
                }
                else
                {
                    txtcount.Focus();
                    lblmsg.Text = "Please Enter Count..!";
                }
               
            }
        }
    
    }
}