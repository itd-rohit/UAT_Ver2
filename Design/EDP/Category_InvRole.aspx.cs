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

public partial class Design_EDP_Category_InvRole : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadRole();
        }
    }

    private void LoadRole()
    {
        string str = "Select RoleName,ID from f_rolemaster Where Active=1 order by RoleName";

        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(str);
        ddlLoginType.DataSource = dt;
        ddlLoginType.DataTextField = "RoleName";
        ddlLoginType.DataValueField = "ID";
        ddlLoginType.DataBind();

        if (ddlLoginType.Items != null && ddlLoginType.Items.Count > 0)
            LoadObservationTypes();
    }

    private void LoadObservationTypes()
    {
       
      StringBuilder sb= new StringBuilder();
      sb.Append(" SELECT om.Name,om.ObservationType_Id,IF(cr.ObservationType_Id IS NULL ,'false','true')isExist FROM  ");
      sb.Append(" observationtype_master om  ");
      sb.Append(" LEFT  JOIN  ");
      sb.Append(" (SELECT io.ObservationType_Id FROM f_investigation_role  ir  ");
      sb.Append(" INNER JOIN investigation_observationtype io ON ir.Investigation_ID=io.Investigation_ID ");
      sb.Append(" WHERE RoleID='"+ddlLoginType.SelectedValue+"' GROUP BY io.ObservationType_Id ) cr ON om.ObservationType_ID=cr.ObservationType_Id order by om.name");

        DataTable dt = new DataTable();

        dt = StockReports.GetDataTable(sb.ToString());
        chkObservationType.DataSource = dt;
        chkObservationType.DataTextField = "Name";
        chkObservationType.DataValueField = "ObservationType_ID";
        chkObservationType.DataBind();

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                foreach (ListItem li in chkObservationType.Items)
                {
                    if (dr["ObservationType_ID"].ToString() == li.Value)
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
            if (ddlLoginType.SelectedIndex != -1)
            {
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, "Delete from f_investigation_role where RoleID='" + ddlLoginType.SelectedItem.Value + "'");

                foreach (ListItem li in chlInvList.Items)
                {
                    if (li.Selected)
                    {
                        sb = "Insert into f_investigation_role (Investigation_Id,RoleID,RoleName)";
                        sb += "values('" + li.Value + "'," + ddlLoginType.SelectedValue + ",";
                        sb += "'" + ddlLoginType.SelectedItem.Text + "')";
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
        sb.Append(" SELECT inv.Name,inv.Investigation_Id,IF(ir.Investigation_ID IS NULL,'false','true')isExist FROM investigation_master inv ");
        sb.Append(" INNER JOIN  investigation_observationtype io ON io.Investigation_ID=inv.Investigation_Id  AND io.ObservationType_Id IN (" + Dept + ") ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.Type_ID=inv.Investigation_Id  and isactive=1 ");
        sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.SubCategoryID=im.SubCategoryID AND sc.CategoryID='LSHHI3' ");
        sb.Append(" LEFT JOIN f_investigation_role ir ON ir.Investigation_ID=inv.Investigation_Id ");
        sb.Append(" and RoleID='" + ddlLoginType.SelectedValue + "' GROUP BY inv.Investigation_Id order by inv.Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        chlInvList.DataSource = dt;
        chlInvList.DataTextField = "Name";
        chlInvList.DataValueField = "Investigation_Id";
        chlInvList.DataBind();

        if (dt != null && dt.Rows.Count > 0)
        {
            foreach (DataRow dr in dt.Rows)
            {
                foreach (ListItem li in chlInvList.Items)
                {
                    if (dr["Investigation_Id"].ToString() == li.Value)
                    {
                        li.Selected = Util.GetBoolean(dr["isExist"]);
                        break;
                    }
                }
            }
        }

    }
}
