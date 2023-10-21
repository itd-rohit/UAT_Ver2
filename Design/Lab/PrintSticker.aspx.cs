using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_PrintSticker : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtLabNo.Focus();
            BindDepartment();
            BindPanel();
            bindAccessCentre();
        }
       
    }

    private void BindPanel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pn.Company_Name,concat(pn.Panel_ID,'#',pn.ReferenceCodeOPD)PanelID  FROM Centre_Panel cp ");
        sb.Append(" INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id WHERE cp.CentreId='" +UserInfo.Centre + "' AND cp.isActive=1 order by pn.Company_Name ");
        DataTable dtPanel = StockReports.GetDataTable(sb.ToString());
        if (dtPanel != null && dtPanel.Rows.Count > 0)
        {
            ddlPanel.DataSource = dtPanel;
            ddlPanel.DataTextField = "Company_Name";
            ddlPanel.DataValueField = "PanelID";
            ddlPanel.DataBind();
            ddlPanel.Items.Insert(0, new ListItem("ALL", "ALL"));
          

        }
        else
        {
            ddlPanel.Items.Clear();
            ddlPanel.Items.Add("-");

        }
    }
    private void bindAccessCentre()
    {
        ddlCentreAccess.DataSource = StockReports.GetDataTable("SELECT  cm.CentreID,cm.Centre Centre FROM centre_master cm where cm.centreid='"+UserInfo.Centre+"'  ");
        ddlCentreAccess.DataTextField = "Centre";
        ddlCentreAccess.DataValueField = "CentreID";
        ddlCentreAccess.DataBind();
        // ddlCentreAccess.Items.Insert(0, new ListItem("--Select--", ""));

       // ddlCentreAccess.Items.Insert(0, new ListItem("ALL", "ALL"));

    }
    protected void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT `subcategoryid`,NAME FROM f_subcategorymaster WHERE active=1 AND `Description`='RADIOLOGY' ORDER BY NAME");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataValueField = "subcategoryid";
            ddlDepartment.DataTextField = "Name";

            ddlDepartment.DataBind();
            ListItem list = new ListItem("ALL", "ALL");
            ddlDepartment.Items.Insert(0, list);
        }
    }


    protected void print_Click(object sender, EventArgs e)
    {
        if (grdshowdata.Rows.Count == 0)
        {
            lblMsg.Text = "Please Search data ..!";
            return;
        }
        DataTable dtstiker = createtable();
        DataTable dtstikerDuoble = createtable();
        foreach (GridViewRow dwr in grdshowdata.Rows)
        {
            CheckBox ck = (CheckBox)dwr.FindControl("chk");
            if (ck.Checked)
            {
                DataRow dw = dtstiker.NewRow();
                dw["date"] = dwr.Cells[0].Text;
                dw["labno"] = dwr.Cells[1].Text;
                dw["MRNO"] = dwr.Cells[2].Text;
                dw["PName"] = dwr.Cells[3].Text;
                dw["AGEGENDER"] = dwr.Cells[4].Text;
                dw["DisplayName"] = dwr.Cells[5].Text;
                dw["itemname"] = dwr.Cells[6].Text;
                dw["center"] = UserInfo.CentreName;
                dtstiker.Rows.Add(dw);
                
            }
        }

      
            for (int a = 0; a <= (Util.GetInt(ddl.SelectedItem.Text)) - 2; a++)
            {
                DataRow dw = dtstiker.NewRow();
                dw["date"] = "";
                dw["labno"] = "";
                dw["pname"] = "";
               
                dw["itemname"] = "";
                dw["center"] = "";
                dw["AGEGENDER"] = "";
                dw["MRNO"] = "";
                dw["DisplayName"] = "";
                
                dtstiker.Rows.InsertAt(dw, 0);
                dtstiker.AcceptChanges();
            }
        
        try
        {

           
            for (int i = 0; i < dtstiker.Rows.Count; i++)
            {
                DataRow sr = dtstikerDuoble.NewRow();

                sr["date"] = Util.GetString(dtstiker.Rows[i]["date"]);
                sr["labno"] = Util.GetString(dtstiker.Rows[i]["labno"]);
                sr["MRNO"] = Util.GetString(dtstiker.Rows[i]["MRNO"]);
                sr["PName"] = Util.GetString(dtstiker.Rows[i]["PName"]);
                sr["AGEGENDER"] = Util.GetString(dtstiker.Rows[i]["AGEGENDER"]);
               
                sr["itemname"] = Util.GetString(dtstiker.Rows[i]["itemname"]);
                sr["center"] = Util.GetString(dtstiker.Rows[i]["center"]);
                sr["DisplayName"] = Util.GetString(dtstiker.Rows[i]["DisplayName"]);

                dtstikerDuoble.Rows.Add(sr);

            }
        }
        catch
        {
        }


        if (dtstikerDuoble.Rows.Count > 0)
        {
            Session["stdata"] = dtstikerDuoble;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key", "window.open('../../Design/Lab/sticker.aspx');", true);
        }
        else
        {
            lblMsg.Text = "Please Select Data To Print..!";
        }
    }
    protected void print0_Click(object sender, EventArgs e)
    {
         grdshowdata.DataSource = search();
         grdshowdata.DataBind();
    }


    DataTable createtable()
    {
        DataTable dtstiker = new DataTable();
        dtstiker.Columns.Add("date");
        dtstiker.Columns.Add("labno");
        dtstiker.Columns.Add("MRNO");
        dtstiker.Columns.Add("PName");
        dtstiker.Columns.Add("AGEGENDER");
        dtstiker.Columns.Add("center");
        dtstiker.Columns.Add("itemname");
        dtstiker.Columns.Add("DisplayName");
        return dtstiker;
    }
    private DataTable search()
    {   
        
        StringBuilder sb=new StringBuilder();
        sb.Append("");
        sb.Append("SELECT lt.`LedgerTransactionNo` as labno,lt.Patient_ID as MRNO,lt.`PName`,CONCAT(lt.`Age`,'/',lt.`Gender`) AGEGENDER,DATE_FORMAT(lt.date,'%d-%b-%Y') DATE,GROUP_CONCAT(plo.ItemName) itemname,GROUP_CONCAT(DISTINCT sm.`DisplayName`) DisplayName  FROM f_ledgertransaction lt ");
        sb.Append("INNER JOIN  `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID`");
        sb.Append("INNER JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=plo.SubCategoryID WHERE sm.`Description`='RADIOLOGY' AND lt.iscancel=0");
        sb.Append(" and date(lt.date)>='" + Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + "' ");
        sb.Append(" and date(lt.date)<='" + Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + "' ");

        if (txtfromlabno.Text != "")
            sb.Append(" and lt.LedgerTransactionNo>='" + txtfromlabno.Text + "' ");


        if (txttolabno.Text != "")
            sb.Append(" and lt.LedgerTransactionNo<='" + txttolabno.Text + "' ");


        if (txtLabNo.Text != "")
            sb.Append(" and lt.LedgerTransactionNo='" + txtLabNo.Text + "' ");

        if (ddlCentreAccess.SelectedValue != "ALL")
            sb.Append(" and lt.CentreID='" + ddlCentreAccess.SelectedValue + "' ");

        if (ddlDepartment.SelectedValue != "ALL")
            sb.Append(" and plo.SubCategoryID='" + ddlDepartment.SelectedValue + "' ");

        if (ddlPanel.SelectedValue != "ALL")
            sb.Append(" and lt.panel_id='" + ddlPanel.SelectedValue + "' ");



        sb.Append(" GROUP BY lt.`LedgerTransactionNo` ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return dt;
    }
}