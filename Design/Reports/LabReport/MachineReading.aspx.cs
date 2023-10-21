using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using System.Collections.Specialized;
using Newtonsoft.Json;

public partial class Design_Machine_MachineReading : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtfromdate, txttodate);
            ddlMachine.DataSource = StockReports.GetDataTable("SELECT MachineID,Machinename FROM " + AllGlobalFunction.MachineDB + ".`mac_machinemaster`");
            ddlMachine.DataValueField = "MachineID";
            ddlMachine.DataTextField = "MachineName";
            ddlMachine.DataBind();
            ddlMachine.Items.Insert(0, new ListItem("", ""));
            reportaccess();
            bindCenterDDL();
            bindCenterTest();
        }
    }

    public void bindCenterDDL()
    {

        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                ddlcenter.DataSource = dt;
                ddlcenter.DataTextField = "Centre";
                ddlcenter.DataValueField = "CentreID";
                ddlcenter.DataBind();
                //ddlcenter.SelectedIndex = ddlcenter.Items.IndexOf(ddlcenter.Items.FindByValue(UserInfo.Centre.ToString()));
            }
        }
    }
    public void bindCenterTest()
    {

        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                lstCentre.DataSource = dt;
                lstCentre.DataTextField = "Centre";
                lstCentre.DataValueField = "CentreID";
                lstCentre.DataBind();
                // lstCentre.SelectedIndex = ddlcenter.Items.IndexOf(ddlcenter.Items.FindByValue(UserInfo.Centre.ToString()));
            }
        }
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(32));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(txtfromdate.Text).AddDays(response.DurationInDay);
                if (date < DateTime.Now.Date)
                {
                    lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
                    return false;
                }
            }
            if (response.ShowPdf == 1 && response.ShowExcel == 0)
            {
                rblreporttype.Items[0].Enabled = true;
                rblreporttype.Items[1].Enabled = false;
                rblreporttype.Items[0].Selected = true;
            }
            else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            {
                rblreporttype.Items[1].Enabled = true;
                rblreporttype.Items[0].Enabled = false;
                rblreporttype.Items[1].Selected = true;
            }
            else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            {
                rblreporttype.Visible = false;
                lblMsg.Text = "Report format not allowed contect to admin";
                return false;
            }
            //else
            //{
            //    rdoReportFormat.Items[0].Selected = true;
            //}
        }
        else
        {
            div1.Visible = false;
            div2.Visible = false;
            div3.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdSearch.PageIndex = 0;
        lblMsg.Text = "";
        Search();
    }

    private void Search()
    {
        //lblMsg.Text = "";
        //if (hdnCentre.Value == string.Empty)
        //{
        //    lblMsg.Text = "Please select Booking Centre";
        //    return;
        //}
        //if (hdnCentre1.Value == string.Empty)
        //{
        //    lblMsg.Text = "Please select Test Centre";
        //    return;
        //}
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            StringBuilder sb2 = new StringBuilder();
            sb.Append("  select a1.* From (  ");
            sb.Append(" SELECT mo.LabNo,mo.Reading,mo.MACHINE_ID,mo.Machine_ParamID,(select machine_param from " + AllGlobalFunction.MachineDB + ".mac_machineparam where machine_ParamID=mo.Machine_ParamID) as machine_param,DATE_FORMAT(mo.dtEntry,'%d-%b-%Y %h:%i%p') dtEntry,ifnull(mo.isSync,0) isSync  FROM " + AllGlobalFunction.MachineDB + ".mac_observation mo ");
            if (chkNotRegistred.Checked == true)
            {
                sb.Append("   LEFT JOIN  (SELECT * FROM mac_data  GROUP BY labno ) md ON md.labno = mo.labno  WHERE  md.LabNo IS NULL ");
                sb.Append(" And mo.MacDate>=@fromdate and  mo.MacDate<= @todate ");
            }
            else
            {
                sb.Append(" where mo.dtEntry>= @fromdate and  mo.dtEntry<= @todate  ");
            }
            if (ddlType.SelectedIndex > 0)
            {
                sb.Append(" and  ifnull(mo.isSync,0) =@isSync ");
            }
            if (ddlMachine.SelectedIndex > 0)
            {
                sb.Append(" and  mo.MACHINE_ID =@MACHINE_ID ");
            }
            if (txtSampleID.Text.Trim() != string.Empty)
            {
                sb.Append(" and  mo.LabNo =@LabNo ");
            }
            if (ddlPageSize.SelectedIndex < ddlPageSize.Items.Count - 1)
            {
                grdSearch.AllowPaging = true;
                grdSearch.PageSize = Util.GetInt(ddlPageSize.SelectedValue);
            }
            else
                grdSearch.AllowPaging = false;

            sb.Append("   )a1 ");
            sb.Append(" ORDER BY a1.dtEntry desc ");
            //grdSearch.AutoGenerateColumns = false;
            DataTable dtRecord = new DataTable();
            using ( dtRecord = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd"), " 00:00:00")),
                           new MySqlParameter("@todate", string.Concat(Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd"), " 23:59:59")),
                           new MySqlParameter("@isSync", ddlType.SelectedValue),
                           new MySqlParameter("@MACHINE_ID", ddlMachine.SelectedValue),
                           new MySqlParameter("@LabNo", txtSampleID.Text.Trim())).Tables[0])
                grdSearch.DataSource = dtRecord;
            grdSearch.DataBind();
            lblMsg.Text = "Total Record : " + dtRecord.Rows.Count.ToString();
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
    protected void grdSearch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (((Label)e.Row.FindControl("lblSync")).Text == "1")
                e.Row.BackColor = System.Drawing.Color.LightGreen;
            else
                e.Row.BackColor = System.Drawing.Color.White;


            if (Session["RoleID"].ToString() == "6")
            {
                //lblMACHINE_ID  lblMachine_ParamID
                e.Row.Attributes.Add("ondblclick", "getMachineParam('" + ((Label)e.Row.FindControl("lblMACHINE_ID")).Text + "','" + ((Label)e.Row.FindControl("lblMachine_ParamID")).Text + "');");
            }

        }
    }

    protected void grdSearch_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        grdSearch.PageIndex = e.NewPageIndex;
        Search();
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        if (hdnCentre.Value == string.Empty)
        {
            lblMsg.Text = "Please select Booking Centre";
            return;
        }
        if (hdnCentre1.Value == string.Empty)
        {
            lblMsg.Text = "Please select Test Centre";
            return;
        }
        try
        {            

                NameValueCollection collections = new NameValueCollection();
                collections.Add("fromDate", string.Concat(Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd"), " 00:00:00"));
                collections.Add("toDate", string.Concat(Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd"), " 23:59:59"));
                collections.Add("Machine", ddlMachine.SelectedValue);               
                collections.Add("ReportFormat", rblreporttype.SelectedValue);
                AllLoad_Data.POSTForm(collections, "Design/Reports/LabReport/MachineReadingPdf.aspx", this.Page);
           
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

    }
}