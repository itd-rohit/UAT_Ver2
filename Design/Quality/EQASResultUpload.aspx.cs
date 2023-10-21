using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_EQASResultUpload : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlprocessinglab.DataSource = StockReports.GetDataTable(" select centre,centreid from centre_master where centreid=" + Util.GetInt(Request.QueryString["labid"]) + "");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();

            ddleqasprogram.DataSource = StockReports.GetDataTable(" select ProgramID,ProgramName  from qc_eqasprogrammaster where ProgramID=" + Util.GetInt(Request.QueryString["programid"]) + " limit 1");
            ddleqasprogram.DataValueField = "ProgramID";
            ddleqasprogram.DataTextField = "ProgramName";
            ddleqasprogram.DataBind();



            ddleqasprovider.DataSource = StockReports.GetDataTable(@" SELECT qe.EQASProviderID,`EqasProviderName` FROM `qc_eqasprovidermaster` qe  
        INNER JOIN qc_eqasprogrammaster qeq ON qe.EQASProviderID=qeq.EQASProviderID WHERE qeq.programid=" + Util.GetInt(Request.QueryString["programid"]) + " LIMIT 1");
            ddleqasprovider.DataValueField = "EQASProviderID";
            ddleqasprovider.DataTextField = "EqasProviderName";
            ddleqasprovider.DataBind();


            System.Globalization.DateTimeFormatInfo mfi = new System.Globalization.DateTimeFormatInfo();
            string strMonthName = mfi.GetMonthName(Util.GetInt(Request.QueryString["currentmonth"])).ToString();


            ddlcurrentmonth.Items.Add(new ListItem(strMonthName, Util.GetString(Request.QueryString["currentmonth"])));

            txtcurrentyear.Text = Util.GetString(Request.QueryString["curentyear"]);

            binddetail();
        }
    }


    protected void btnSave_Click(object sender, EventArgs e)
    {
        string dt = StockReports.ExecuteScalar("SELECT count(1) FROM qc_approvalright WHERE apprightfor='EQAS' and typeid=7 AND active=1 AND employeeid='" + UserInfo.ID + "' ");
        if (dt == "0")
        {
            lb.Text = "Dear User You Did not Have Right to Upload EQAS Result";
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
            sb.Append("insert into qc_eqasresultfile(CentreId,ProviderID,EntryMonth,EntryYear,ProgramID,FileName,EntryDate,EntryBy,EntryByName)");
            sb.Append(" values (" + ddlprocessinglab.SelectedValue + "," + ddleqasprovider.SelectedValue + "," + ddlcurrentmonth.SelectedValue + ", ");
            sb.Append(" " + txtcurrentyear.Text + "," + ddleqasprogram.SelectedValue + ",'" + filename + "',now()," + UserInfo.ID + ",'" + UserInfo.LoginName + "')");

            MySqlHelper.ExecuteNonQuery(tnx,CommandType.Text,sb.ToString());

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set EQASDone=1,EQASDoneBy=" + UserInfo.ID + ",EQASDoneDate=now(),EQASDoneName='" + UserInfo.LoginName + "' ,EQASResultFileName='" + filename + "' where CentreID=" + ddlprocessinglab.SelectedValue + " AND EntryMonth=" + ddlcurrentmonth.SelectedValue + " AND EntryYear=" + txtcurrentyear.Text + " AND ProgramID=" + ddleqasprogram.SelectedValue + " ");
           
            tnx.Commit();
            fu_Upload.SaveAs(Server.MapPath("~/Design/Quality/EQASResult/") + filename);
            lb.Text = "EQAS Result Uploaded..!";
            binddetail();

        }


        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lb.Text= Util.GetString(ex.Message);

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
        grd.DataSource = StockReports.GetDataTable("SELECT id, filename,DATE_FORMAT(entrydate,'%d-%b-%Y') EntryDate,EntryByName FROM qc_eqasresultfile WHERE isactive=1 and CentreId="+ddlprocessinglab.SelectedValue+" and ProgramID="+ddleqasprogram.SelectedValue+" and ProviderID="+ddleqasprovider.SelectedValue+" and EntryMonth="+ddlcurrentmonth.SelectedValue+" and EntryYear="+txtcurrentyear.Text+" ");
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

        string dt = StockReports.ExecuteScalar("SELECT count(1) FROM qc_approvalright WHERE apprightfor='EQAS' and typeid=7 AND active=1 AND employeeid='" + UserInfo.ID + "' ");
        if (dt == "0")
        {
            lb.Text = "Dear User You Did not Have Right to Remove EQAS Result";
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
                sb.Append(" update  qc_eqasresultfile set isactive=0,UpdateDate=now(),UpdateBy=" + UserInfo.ID + ",UpdateByname='"+UserInfo.LoginName+"'");
                sb.Append(" where id="+Util.GetInt(e.CommandArgument)+" ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set EQASDone=0 where CentreID=" + ddlprocessinglab.SelectedValue + " AND EntryMonth=" + ddlcurrentmonth.SelectedValue + " AND EntryYear=" + txtcurrentyear.Text + " AND ProgramID=" + ddleqasprogram.SelectedValue + " ");

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