﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using CrystalDecisions.CrystalReports.Engine;


public partial class Design_Machine_MachineReading : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            ddlMachine.DataSource = StockReports.GetDataTable("Select MACHINEID,MACHINENAME from " + Util.getApp("MachineDB") + ".mac_machinemaster order by MACHINENAME ");
            ddlMachine.DataValueField = "MachineID";
            ddlMachine.DataTextField = "MachineName";
            ddlMachine.DataBind();
            ddlMachine.Items.Insert(0, new ListItem("Select Machine",""));

        }
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        grdSearch.PageIndex = 0;
        lblMsg.Text = "";
        Search();
    }

    private void Search()
    {
        StringBuilder sb = new StringBuilder();
        StringBuilder sb2 = new StringBuilder();
        sb.Append("  select a1.* From (  ");
        sb.Append(" SELECT mo.LabNo,mo.Reading,mo.MACHINE_ID,mo.Machine_ParamID,(select machine_param from " + AllGlobalFunction.MachineDB + ".mac_machineparam where machine_ParamID=mo.Machine_ParamID) as machine_param,DATE_FORMAT(mo.dtEntry,'%d-%b-%Y %h:%i%p') dtEntry,ifnull(mo.isSync,0) isSync  FROM " + AllGlobalFunction.MachineDB + ".mac_observation mo ");
        if (chkNotRegistred.Checked == true)
        {
            sb.Append("   LEFT JOIN  (SELECT * FROM mac_data  GROUP BY labno ) md ON md.labno = mo.labno  WHERE  md.LabNo IS NULL ");
            sb.Append(" And mo.dtEntry>='" + Util.GetDateTime(txtentrydatefrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' and  mo.dtEntry<='" + Util.GetDateTime(txtentrydateto.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }
        else
        {
            sb.Append(" where  mo.dtEntry>='" + Util.GetDateTime(txtentrydatefrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' and  mo.dtEntry<='" + Util.GetDateTime(txtentrydateto.Text).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }


        // sb.Append(" union all SELECT mbk.LabNo,mbk.Reading,mbk.MACHINE_ID,mbk.Machine_ParamID,(select machine_param from " + AllGlobalFunction.MachineDB + ".mac_machineparam where machine_ParamID=mbk.Machine_ParamID) as machine_param,DATE_FORMAT(mbk.dtEntry,'%d-%b-%Y %h:%i%p') dtEntry,ifnull(mbk.isSync,0) isSync  FROM " + AllGlobalFunction.MachineDB + ".mac_observation_bk mbk  where date(mbk.dtEntry)>='" + dtFrom.GetDateForDataBase() + "' and  date(mbk.dtEntry)<='" + dtTo.GetDateForDataBase() + "' ");
        if (ddlType.SelectedIndex > 0)
        {

            sb.Append(" and  ifnull(mo.isSync,0) ='" + ddlType.SelectedValue + "' ");
        }
        if (ddlMachine.SelectedIndex > 0)
        {
            sb.Append(" and  mo.MACHINE_ID ='" + ddlMachine.SelectedValue + "' ");

        }
        if (txtSampleID.Text.Trim() != string.Empty)
        {
            sb.Append(" and  mo.LabNo  like '%" + txtSampleID.Text.Trim() + "%' ");
            //   sb2.Append(" and  m1.LabNo ='" + txtSampleID.Text.Trim() + "' ");
        }
         
        if (ddlPageSize.SelectedIndex < ddlPageSize.Items.Count - 1)
        {
            grdSearch.AllowPaging = true;
            grdSearch.PageSize = Util.GetInt(ddlPageSize.SelectedValue);
        }
        else
            grdSearch.AllowPaging = false;
        //    sb.Append("  union all  ");
        //  sb.Append(sb2.ToString());
        sb.Append("   )a1 ");
        sb.Append(" ORDER BY a1.LabNo ");
		//System.IO.File.WriteAllText(@"C:\Itdose\path\Dummy77.txt",sb.ToString());
        //grdSearch.AutoGenerateColumns = false;
        DataTable dtRecord = StockReports.GetDataTable(sb.ToString());
        grdSearch.DataSource = dtRecord;
        grdSearch.DataBind();
        lblMsg.Text = "Total Record : " + dtRecord.Rows.Count.ToString();
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
        StringBuilder sb = new StringBuilder();
        StringBuilder sb2 = new StringBuilder();
        sb.Append("  select a1.* From (  ");
        sb.Append(" SELECT mo.LabNo,mo.Reading,mo.MACHINE_ID,mo.Machine_ParamID,(select machine_param from " + AllGlobalFunction.MachineDB + ".mac_machineparam where machine_ParamID=mo.Machine_ParamID) as machine_param,DATE_FORMAT(mo.dtEntry,'%d-%b-%Y %h:%i%p') dtEntry,ifnull(mo.isSync,0) isSync  FROM " + AllGlobalFunction.MachineDB + ".mac_observation mo ");
        if (chkNotRegistred.Checked == true)
        {
            sb.Append("   LEFT JOIN  (SELECT * FROM mac_data  GROUP BY labno ) md ON md.labno = mo.labno  WHERE  md.LabNo IS NULL ");
            sb.Append(" And mo.dtEntry>='" + Util.GetDateTime(txtentrydatefrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' and  mo.dtEntry<='" + Util.GetDateTime(txtentrydateto.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
        }
        else
        {
            sb.Append(" where mo.dtEntry>='" + Util.GetDateTime(txtentrydatefrom.Text).ToString("yyyy-MM-dd") + " 00:00:00' and  mo.dtEntry<='" + Util.GetDateTime(txtentrydateto.Text).ToString("yyyy-MM-dd") + " 23:59:59'  ");
        }


        // sb.Append(" union all SELECT mbk.LabNo,mbk.Reading,mbk.MACHINE_ID,mbk.Machine_ParamID,(select machine_param from " + AllGlobalFunction.MachineDB + ".mac_machineparam where machine_ParamID=mbk.Machine_ParamID) as machine_param,DATE_FORMAT(mbk.dtEntry,'%d-%b-%Y %h:%i%p') dtEntry,ifnull(mbk.isSync,0) isSync  FROM " + AllGlobalFunction.MachineDB + ".mac_observation_bk mbk  where date(mbk.dtEntry)>='" + dtFrom.GetDateForDataBase() + "' and  date(mbk.dtEntry)<='" + dtTo.GetDateForDataBase() + "' ");
        if (ddlType.SelectedIndex > 0)
        {

            sb.Append(" and  ifnull(mo.isSync,0) ='" + ddlType.SelectedValue + "' ");
        }
        if (ddlMachine.SelectedIndex > 0)
        {
            sb.Append(" and  mo.MACHINE_ID ='" + ddlMachine.SelectedValue + "' ");

        }
        if (txtSampleID.Text.Trim() != string.Empty)
        {
            sb.Append(" and  mo.LabNo ='" + txtSampleID.Text.Trim() + "' ");
            //   sb2.Append(" and  m1.LabNo ='" + txtSampleID.Text.Trim() + "' ");
        }

        if (ddlPageSize.SelectedIndex < ddlPageSize.Items.Count - 1)
        {
            grdSearch.AllowPaging = true;
            grdSearch.PageSize = Util.GetInt(ddlPageSize.SelectedValue);
        }
        else
            grdSearch.AllowPaging = false;
        //    sb.Append("  union all  ");
        //  sb.Append(sb2.ToString());
        sb.Append("   )a1 ");
        sb.Append(" ORDER BY a1.dtEntry desc ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        ReportDocument rpt = new ReportDocument();
        DataSet ds = new DataSet();
        if (dt.Rows.Count > 0)
            {
                lblMsg.Text = "";
                DataColumn dc = new DataColumn();
                dc.ColumnName = "ForDate";
                dc.DefaultValue = "Period From : " + txtentrydatefrom.Text + " To : " + txtentrydateto.Text + " " + ddlMachine.SelectedValue;
                dt.Columns.Add(dc);

              
                ds.Tables.Add(dt.Copy());
                ds.Tables[0].TableName = "macdata";

                //ds.WriteXmlSchema("c:\\macdata.xml");

                Session["ds"] = ds;
                Session["ReportName"] = "MacData";
                lblMsg.Text = "Total Patient " + Util.GetString(dt.Rows.Count);
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
            }
            else
                lblMsg.Text = "No Details Found";

      


      
    }
}