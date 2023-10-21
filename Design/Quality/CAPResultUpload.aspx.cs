using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_CAPResultUpload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlprocessinglab.DataSource = StockReports.GetDataTable(" select centre,centreid from centre_master where centreid=" + Util.GetInt(Request.QueryString["labid"]) + "");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();

            ddlcapprogrm.DataSource = StockReports.GetDataTable(" select ProgramID,ProgramName  from qc_capprogrammaster where ProgramID=" + Util.GetInt(Request.QueryString["programid"]) + " limit 1");
            ddlcapprogrm.DataValueField = "ProgramID";
            ddlcapprogrm.DataTextField = "ProgramName";
            ddlcapprogrm.DataBind();

            ddlshipmentno.Items.Add(new ListItem(Util.GetString(Request.QueryString["shipmentno"]), Util.GetString(Request.QueryString["shipmentno"])));

            binddetail();
        }
    }


    protected void btnSave_Click(object sender, EventArgs e)
    {
        string dt = StockReports.ExecuteScalar("SELECT count(1) FROM qc_approvalright WHERE apprightfor='CAP' and typeid=12 AND active=1 AND employeeid='" + UserInfo.ID + "' ");
        if (dt == "0")
        {
            lb.Text = "Dear User You Did not Have Right to Upload CAP Result";
            return;
        }



        string fileext = System.IO.Path.GetExtension(fu_Upload.FileName);
        string filename = Guid.NewGuid().ToString() + fileext;



        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("insert into qc_capresultfile(CentreId,ShipmentNo,ProgramID,FileName,EntryDate,EntryBy,EntryByName)");
            sb.Append(" values (" + ddlprocessinglab.SelectedValue + ",'" + ddlshipmentno.SelectedValue + "'," + ddlcapprogrm.SelectedValue + " ");
            sb.Append(",'" + filename + "',now()," + UserInfo.ID + ",'" + UserInfo.LoginName + "')");

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_capregistration set CAPResultFileName='" + filename + "' where   CentreID=" + ddlprocessinglab.SelectedValue + "  AND ProgramID=" + ddlcapprogrm.SelectedValue + " and ShipmentNo='" + ddlshipmentno.SelectedValue + "'");

            tnx.Commit();
            fu_Upload.SaveAs(Server.MapPath("~/Design/Quality/CAPResult/") + filename);
            lb.Text = "CAP Result Uploaded..!";
            binddetail();

        }


        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lb.Text = Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    void binddetail()
    {
        grd.DataSource = StockReports.GetDataTable("SELECT id, filename,DATE_FORMAT(entrydate,'%d-%b-%Y') EntryDate,EntryByName FROM qc_capresultfile WHERE isactive=1 and CentreId=" + ddlprocessinglab.SelectedValue + " and ProgramID=" + ddlcapprogrm.SelectedValue + " and ShipmentNo='" + ddlshipmentno.SelectedValue + "' ");
        grd.DataBind();

        if (grd.Rows.Count > 0)
        {
            btnSave.Visible = false;
        }
        else
        {
            btnSave.Visible = true;
        }


    }
    protected void grd_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        string dt = StockReports.ExecuteScalar("SELECT count(1) FROM qc_approvalright WHERE apprightfor='CAP' and typeid=12 AND active=1 AND employeeid='" + UserInfo.ID + "' ");
        if (dt == "0")
        {
            lb.Text = "Dear User You Did not Have Right to Remove CAP Result";
            return;
        }


        if (e.CommandName == "Remove")
        {


            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" update  qc_capresultfile set isactive=0,UpdateDate=now(),UpdateBy=" + UserInfo.ID + ",UpdateByname='" + UserInfo.LoginName + "'");
                sb.Append(" where id=" + Util.GetInt(e.CommandArgument) + " ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_capregistration set CAPResultFileName='' where CentreID=" + ddlprocessinglab.SelectedValue + "  AND ProgramID=" + ddlcapprogrm.SelectedValue + " and ShipmentNo='" + ddlshipmentno.SelectedValue + "'  ");

                tnx.Commit();

                lb.Text = "EQAS Result Removed..!";
                binddetail();

            }


            catch (Exception ex)
            {

                tnx.Rollback();

                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                lb.Text = Util.GetString(ex.Message);

            }
            finally
            {
                tnx.Dispose();
                con.Close();
                con.Dispose();
            }

        }
        binddetail();
    }
}