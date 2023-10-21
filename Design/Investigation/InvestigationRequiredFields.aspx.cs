using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Investigation_InvestigationRequiredFields : System.Web.UI.Page
{
    string InvID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        InvID = Request.QueryString["InvID"].ToString();
        if (!IsPostBack)
        {

            lb.Text = StockReports.ExecuteScalar("select name from investigation_master where Investigation_Id='" + InvID + "'");
            bindinv();
        }
    }

    void bindinv()
    {
        DataTable dt = StockReports.GetDataTable("select id,fieldname from requiredfield_master");
        
        grd.DataSource = dt;
        grd.DataBind();
      
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "delete from investigation_requiredfield where investigationid=@InvID ", new MySqlParameter("@InvID", InvID));
            foreach (GridViewRow grdrow in grd.Rows)
            {
                CheckBox ck = (CheckBox)grdrow.FindControl("chk");
                CheckBox ck1 = (CheckBox)grdrow.FindControl("chk1");
                string mapid = ((Label)grdrow.FindControl("Label2")).Text;
                string mapname = ((Label)grdrow.FindControl("Label1")).Text;
                if (ck.Checked || ck1.Checked)
                {
                    int a1 = 0;
                    int a2 = 0;

                    if (ck.Checked)
                        a1 = 1;

                    if (ck1.Checked)
                        a2 = 1;
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "insert into investigation_requiredfield (investigationid,fieldid,fieldname,createdate,createbyuser,ShowOnBooking,ShowOnSampleCollection) values(@InvID,@mapid,@mapname,now(),@Name,@ShowOnBooking,@ShowOnSampleCollection)",
                        new MySqlParameter("@InvID", InvID), new MySqlParameter("@mapid", mapid),
                        new MySqlParameter("@mapname", mapname), new MySqlParameter("@Name", Util.GetString(Session["LoginName"])),
                        new MySqlParameter("@ShowOnBooking", a1), new MySqlParameter("@ShowOnSampleCollection", a2));
                }
            }


            lblMsg.Text = "Data Sucessfully..!";
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

    protected void grd_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                CheckBox ck = (CheckBox)e.Row.FindControl("chk");
                string mapid = ((Label)e.Row.FindControl("Label2")).Text;

                string cc = MySqlHelper.ExecuteScalar(con, CommandType.Text, "select count(*) from investigation_requiredfield where investigationid=@InvID and fieldid=@mapid and ShowOnBooking=1",
                    new MySqlParameter("@InvID", InvID), new MySqlParameter("@mapid", mapid)).ToString();
                if (cc == "1")
                {
                    ck.Checked = true;
                }
                else
                {
                    ck.Checked = false;
                }

                CheckBox ck1 = (CheckBox)e.Row.FindControl("chk1");

                string cc1 = MySqlHelper.ExecuteScalar(con, CommandType.Text, "select count(*) from investigation_requiredfield where investigationid=@InvID and fieldid=@mapid and ShowOnSampleCollection=1",
                     new MySqlParameter("@InvID", InvID), new MySqlParameter("@mapid", mapid)).ToString();
                if (cc1 == "1")
                {
                    ck1.Checked = true;
                }
                else
                {
                    ck1.Checked = false;
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

    
}