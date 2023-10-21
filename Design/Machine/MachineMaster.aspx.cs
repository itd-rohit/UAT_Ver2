using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;

public partial class Design_Machine_MachineMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindMachine();
            Centre();
            MachineGroup();
            Clearform();
    }
       
    }
    private void Clearform()
    {
        btsave.Text = "Save";
        ddlcentre.SelectedIndex = 0;
        ddlbacheequest.SelectedIndex = 0;
        ddlmachine.SelectedIndex = 0;
        txtMachineID.Text = "";
        txtMachineName.Text = "";
        txtMachineName.Enabled = true;
        txtMachineID.Enabled = true;
    }
    protected void btsave_Click(object sender, EventArgs e)
    {
        try
        {
            lblMsg.Text = "";
            if (txtMachineID.Text.Trim() == "")
            {
                lblMsg.Text = "Please Enter the MachineID";
                return;
            }
            if (txtMachineName.Text.Trim() == "")
            {
                lblMsg.Text = "Please Enter the Machine Name";
                return;
            }
            if (ddlcentre.SelectedValue == "Select Centre")
            {
                lblMsg.Text = "Please Select Centre";
                return;
            }
            if (ddlmachine.SelectedValue == "Select Machine")
            {
                lblMsg.Text = "Please Select machine";
                return;
            }
            if (Util.GetInt(StockReports.ExecuteScalar("Select Count(*) from " + AllGlobalFunction.MachineDB + ".mac_machinemaster where MachineID='" + txtMachineID.Text.Trim() + "'")) == 0)
            {
                StockReports.ExecuteDML("insert into " + AllGlobalFunction.MachineDB + ".mac_machinemaster(MachineID,MachineName,Centreid,GroupId,BatchRequest) value('" + txtMachineID.Text.Trim() + "','" + txtMachineName.Text.Trim() + "'," + ddlcentre.SelectedValue.Trim() + ",'" + ddlmachine.SelectedValue.Trim() + "'," + ddlbacheequest.SelectedValue.Trim() + ")");
                lblMsg.Text = "Record Saved...";
            }
            else
            {
                StockReports.ExecuteDML("Update " + AllGlobalFunction.MachineDB + ".mac_machinemaster set Centreid=" + ddlcentre.SelectedValue.Trim() + ",GroupId='" + ddlmachine.SelectedValue.Trim() + "',BatchRequest=" + ddlbacheequest.SelectedValue.Trim() + " where MachineID='"+ txtMachineID.Text.Trim() +"'");
                lblMsg.Text = "Record Saved...";
            }
            

            Clearform();
            bindMachine();
        }
        catch (Exception ex) { lblMsg.Text = ex.Message; }

    }
    private void bindMachine()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT MachineID,MachineName,cm.Centre Centreid,if (BatchRequest='0','No','Yes')BatchRequest, mm.Name GroupId  FROM " + AllGlobalFunction.MachineDB + ".mac_machinemaster");
        sb.Append(" mcmm INNER JOIN macmaster mm ON mcmm.GroupId=mm.ID INNER JOIN centre_master cm ON cm.CentreID=mcmm.Centreid");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        GridView1.DataSource = dt;
        GridView1.DataBind();

    }
    private void Centre()
    {
        string str = "select CentreID,Centre from centre_master";
        DataTable dt = StockReports.GetDataTable(str);
        ddlcentre.DataSource = dt;
        ddlcentre.DataValueField = "CentreID";
        ddlcentre.DataTextField = "Centre";
        ddlcentre.DataBind();
        ddlcentre.Items.Insert(0, "Select Centre");

    }
    private void MachineGroup()
    {
        string str = "SELECT ID,NAME FROM macmaster";
        DataTable dt = StockReports.GetDataTable(str);
        ddlmachine.DataSource = dt;
        ddlmachine.DataValueField = "ID";
        ddlmachine.DataTextField = "NAME";
        ddlmachine.DataBind();
        ddlmachine.Items.Insert(0, "Select Machine");

    }
    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        bindMachine();
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)GridView1.SelectedRow.FindControl("MachineID")).Text;
        string str = "SELECT MachineID,MachineName,Centreid,BatchRequest,GroupId FROM " + AllGlobalFunction.MachineDB + ".mac_machinemaster where MachineID='" + ID + "'";
        DataTable dt = StockReports.GetDataTable(str);
        if (dt.Rows.Count > 0)
        {
            txtMachineID.Text = dt.Rows[0]["MachineID"].ToString();
            txtMachineName.Text = dt.Rows[0]["MachineName"].ToString();
            ddlcentre.SelectedValue = dt.Rows[0]["Centreid"].ToString();
            ddlmachine.SelectedValue = dt.Rows[0]["GroupId"].ToString();
            ddlbacheequest.SelectedValue = dt.Rows[0]["BatchRequest"].ToString();
            txtMachineName.Enabled = false;
            txtMachineID.Enabled = false;
            btsave.Text = "Update";

        }

       
    }
}