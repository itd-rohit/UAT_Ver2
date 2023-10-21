using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_InvestigationConcernForm : System.Web.UI.Page
{
    public static string InvID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            InvID = Request.QueryString["InvID"].ToString();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch1", "document.getElementById('masterheaderid');", true);
            ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch12", "document.getElementById('mastertopcorner');", true);
            if (!IsPostBack)
            {

                lb.Text = MySqlHelper.ExecuteScalar(con, CommandType.Text, "select name from investigation_master where Investigation_Id=@InvID", new MySqlParameter("@InvID", InvID)).ToString();

                bindform();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    void bindform()
    {
        DataTable dt = StockReports.GetDataTable("Select icc.concentformname,filename from investigation_concentform icc ");
        if (dt != null && dt.Rows.Count > 0)
        {
            grd.DataSource = dt;
            grd.DataBind();
        }
    }
    protected void grd_SelectedIndexChanged(object sender, EventArgs e)
    {
        string filename = ((Label)grd.SelectedRow.FindControl("Label2")).Text;

        if (File.Exists(Server.MapPath("~/Design/ConcentForm") + "/" + filename) == false)
        {
            lblMsg.Text = "File Not Found!";
            return;
        }
        string mmc = Convert.ToBase64String(File.ReadAllBytes(Server.MapPath("~/Design/ConcentForm") + "/" + filename));
        string ext = System.IO.Path.GetExtension((Server.MapPath("~/Design/ConcentForm") + "/" + filename));
        if (ext.Replace(".", "").ToUpper() != "PDF")
        {
            img.Visible = true;
            img.Attributes["src"] = @"data:image/" + ext.Replace(".", "") + ";base64," + mmc;
        }
        else
        {
            string srcfilw = "../ConcentForm"+ "/" + filename;
            frm.Src = srcfilw;

            img.Visible = false;
          //  img.Attributes["src"] = @"data:application/pdf;base64," + mmc;
        }


        modelopdpatient.Show();
    }
    protected void btnsaveall_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int a = 0;
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from investigation_ConcernForm where investigationid=@InvID", new MySqlParameter("@InvID", InvID));
            foreach (GridViewRow grow in grd.Rows)
            {
                string name = ((Label)grow.FindControl("Label1")).Text;
                CheckBox ckk = (CheckBox)grow.FindControl("chk");
                if (ckk.Checked)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into investigation_ConcernForm (investigationid,ConcernForm,createdate,createbyuser) values (@InvID,@name,now(),@ID)",
                        new MySqlParameter("@InvID", InvID), new MySqlParameter("@name", name), new MySqlParameter("@ID", UserInfo.ID));
                    a++;
                }
            }
            tnx.Commit();
            if (a == 0)
            {
                lblMsg.Text = "Please Select Concern Form To Save";
            }
            else
            {
                lblMsg.Text = "Record Saved Sucessfully";
            }

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void grd_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                CheckBox ck = (CheckBox)e.Row.FindControl("chk");
                string mapid = ((Label)e.Row.FindControl("Label1")).Text;

                string cc = MySqlHelper.ExecuteScalar(con, CommandType.Text, "select count(*) from investigation_ConcernForm where ConcernForm=@mapid  and investigationid=@InvID"
                    , new MySqlParameter("@mapid", mapid), new MySqlParameter("@InvID", InvID)).ToString();
                if (cc == "1")
                {
                    ck.Checked = true;
                }
                else
                {
                    ck.Checked = false;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    protected void btn_Click(object sender, EventArgs e)
    {
        Response.Redirect("ConcentFormMaster.aspx");
    }
}