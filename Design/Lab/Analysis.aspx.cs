using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
public partial class Design_Machine_Analysis : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFrom.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtTo.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";


            chkMachineList.DataSource = StockReports.GetDataTable("SELECT machineid,machinename FROM machost_atulya.mac_machinemaster ");
            chkMachineList.DataTextField = "machinename";
            chkMachineList.DataValueField = "machineid";
            chkMachineList.DataBind();
        }
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT mo.Machine_Id,mo.Machine_ParamID,mo.LabNo,mo.dtEntry,(SELECT Machine_Param FROM machost_atulya.mac_machineparam WHERE Machine_ParamID=mo.Machine_ParamID) AS Alias ");
        sb.Append(" FROM machost_atulya.mac_observation mo  ");
        sb.Append(" WHERE mo.dtEntry>='" + txtFrom.Text + " " + txtFromTime.Text + "' and mo.dtEntry<='" + txtTo.Text + " " + txtToTime.Text + "' ");

        string MachineID = "";

        if (MachineID != "")
            sb.Append(" and mo.Machine_Id in (" + MachineID + ") ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {


            if (dt.Rows.Count > 0)
            {
                lblMsg.Text = "Total " + dt.Rows.Count + " Record(s) Found";
                DataColumn dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From : " + txtFrom.Text + " " + txtFromTime.Text + " To : " + txtTo.Text + " " + txtToTime.Text;
                dt.Columns.Add(dc);

                //dc = new DataColumn();
                //dc.ColumnName = "CentreName";
                //dc.DefaultValue = GetSelection(chkCentreList);
                //dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "PrintBy";
                dc.DefaultValue = Session["LoginName"].ToString();
                dt.Columns.Add(dc);

                //dc = new DataColumn();
                //dc.ColumnName = "ReportHeadName";
                //dc.DefaultValue = "Centre Wise Collection Summary";
                //dt.Columns.Add(dc);

                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());

                Session["ds"] = ds;
                Session["ReportName"] = "MachineAnalysis";
                //ds.WriteXmlSchema(@"D:\MachineAnalysis.xml");

                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/CommonReport.aspx');", true);

            }
            else
                lblMsg.Text = "No Record found";
        }


    }
}