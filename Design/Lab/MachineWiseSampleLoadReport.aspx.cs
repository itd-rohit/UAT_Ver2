using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_Lab_MachineWiseSampleLoadReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindCentreMaster();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    private void bindCentreMaster()
    {
        DataTable dt = AllLoad_Data.getCentreByLogin();
        if (dt.Rows.Count > 0)
        {
            chlCentres.DataSource = dt;
            chlCentres.DataTextField = "Centre";
            chlCentres.DataValueField = "centreID";
            chlCentres.DataBind();
        }
    }

    protected void btnExcelReport_Click(object sender, EventArgs e)
    {
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        if (Centres.Trim() == "")
        {
            lblMsg.Text = "Please Select Centre";
            return;
        }
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT t.machine_id `Machine Name`,mcp.`Machine_Param` `Parameter Name`,COUNT(t.machine_paramid)COUNT,  ");
        sb.Append(" cm.`Centre`,cm.`BusinessZoneName`,cm.`State`,ct.`City`,lc.`NAME` Locality ");
        sb.Append("  FROM ( ");
        sb.Append(" SELECT machine_id,machine_paramid FROM `machost_atulya`.`mac_observation` ");
        sb.Append(" where dtEntry>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'  AND dtEntry <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append("  UNION ALL ");
        sb.Append(" SELECT machine_id,machine_paramid FROM `machost_atulya`.mac_observation  ");
        sb.Append(" where dtEntry>='" + Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd") + " 00:00:00'  AND dtEntry <='" + Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" ) AS  t  ");
        sb.Append(" INNER JOIN `machost_atulya`.`mac_machinemaster` mcm ON mcm.`MACHINEID`=t.Machine_Id   ");
        sb.Append(" INNER JOIN `atulya_live`.centre_master cm ON mcm.`CentreID`=cm.`CentreID`  ");
        sb.Append(" and cm.CentreID in("+Centres+") ");
        sb.Append(" AND cm.`isActive`=1 ");
        sb.Append(" INNER JOIN `atulya_live`.`f_locality` lc  ");
        sb.Append(" ON cm.`LocalityID`=lc.`ID` ");
        sb.Append(" INNER JOIN `atulya_live`.city_master ct ON ct.Id=cm.`CityID` ");
        sb.Append(" INNER JOIN `machost_atulya`.`mac_machineparam` mcp ");
        sb.Append(" ON t.machine_paramid=mcp.`Machine_ParamID` ");
        sb.Append(" GROUP BY t.Machine_ID,t.machine_paramid ");
       

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "Machine Wise Sample Load Report";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../common/ExportToExcel.aspx');", true);
            lblMsg.Text = dt.Rows.Count + " Records Found ";
        }
        else
        {
            lblMsg.Text = "Record Not found";
        }


    }
}