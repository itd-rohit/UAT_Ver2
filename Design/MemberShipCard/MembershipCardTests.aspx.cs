using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;
using MySql.Data.MySqlClient;

public partial class MembershipCardTests : System.Web.UI.Page
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

        if (ddlMembershipCard.Items != null && ddlMembershipCard.Items.Count > 0)
            LoadObservationTypes();
    }

    private void LoadObservationTypes()
    {
       
      StringBuilder sb= new StringBuilder();
      sb.Append("  SELECT id,NAME ,IF(cr.subcategoryid IS NULL ,'false','true')isExist FROM `f_subcategorymaster` sm");
      sb.Append(" left join (select subcategoryid from  Membershipcard_Tests where cardid=" + ddlMembershipCard.SelectedValue + " group by subcategoryid) cr ");
      sb.Append(" on cr.subcategoryid=sm.subcategoryid ");
      sb.Append(" where id not in (15,18,19,27) order by name");

     

        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(sb.ToString());
        chkObservationType.DataSource = dt;
        chkObservationType.DataTextField = "Name";
        chkObservationType.DataValueField = "id";
        chkObservationType.DataBind();

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                foreach (ListItem li in chkObservationType.Items)
                {
                    if (dr["id"].ToString() == li.Value)
                    {
                        li.Selected = Util.GetBoolean(dr["isExist"]);
                        break;
                    }
                }
            }
            LoadInv(); 
        }
    }





    protected void btnSave_Click(object sender, EventArgs e)
    {
        string sb = "";

        string InvList = StockReports.GetSelection(chlInvList);

        if (InvList == "")
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Kindly Select a Investigation...');", true);
            return;
        }


        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (ddlMembershipCard.SelectedIndex != -1)
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from Membershipcard_Tests where CardID='" + ddlMembershipCard.SelectedItem.Value + "'");



                foreach (ListItem li in chlInvList.Items)
                {
                   
                  

                        if (li.Selected)
                        {
                            sb = "Insert into Membershipcard_Tests (Subcategoryid,ItemID,CardID,ItemName,CardName,invcount)";
                            sb += "values(" + li.Value.Split('#')[1] + "," + li.Value.Split('#')[0] + "," + ddlMembershipCard.SelectedValue + ",";
                            sb += "'" + li.Text + "','" + ddlMembershipCard.SelectedItem.Text + "','1')";
                            MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, sb);
                        }
                  

                   
                }

                tranX.Commit();
                con.Close();
                con.Dispose();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Record Saved Successfully...');", true);
            }

        }
        catch (Exception ex)
        {
            tranX.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = "Record Not Saved ....";
        }
    }

	
    

    protected void ddlLoginType_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadObservationTypes();
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadInv();       
    }

    private void LoadInv()
    {
        string Dept = StockReports.GetSelection(chkObservationType);

        if (Dept == "")
        {
            chlInvList.Items.Clear();  
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "alert('Kindly Select a Department...');", true);
            return;
        }


        StringBuilder sb = new StringBuilder();
        sb.Append(" select concat(im.itemid,'#',im.SubCategoryID) itemid,im.typename,if(mt.itemid IS NULL,'false','true')  isExist from f_itemmaster im ");
        sb.Append(" left join membershipcard_tests mt on mt.ItemID=im.ItemID and mt.cardid=" + ddlMembershipCard.SelectedValue + " ");
        sb.Append(" where im.SubCategoryID in ("+Dept+") order by typename");

		 

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        chlInvList.DataSource = dt;
        chlInvList.DataTextField = "typename";
        chlInvList.DataValueField = "itemid";
        chlInvList.DataBind();

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                foreach (ListItem li in chlInvList.Items)
                {
                    if (dr["itemid"].ToString() == li.Value)
                    {
                       li.Selected = Util.GetBoolean(dr["isExist"]);
                        break;
                    }
                }
            }
        }

    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSelectAll.Checked)
        {
            foreach (ListItem li in chkObservationType.Items)
            {
                li.Selected = true;
            }
        }
        else
        {
            foreach (ListItem li in chkObservationType.Items)
            {
                li.Selected = false;
            }
        }
    }
    protected void chkAllInv_CheckedChanged(object sender, EventArgs e)
    {
        if (chkAllInv.Checked)
        {
            foreach (ListItem li in chlInvList.Items)
            {
                li.Selected = true;
            }
        }
        else
        {
            foreach (ListItem li in chlInvList.Items)
            {
                li.Selected = false;
            }
        }
    }
}
