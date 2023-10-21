using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_WorkSheet : System.Web.UI.Page
{
    #region Event Handling

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtLabNo.Focus();
            BindDepartment();
            BindPanel();
           
            try
            {
                Machine();
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            Bindcenter();
            BindDepartment();
            
        }
        dtFrom.Attributes.Add("readOnly", "readOnly");
        dtTo.Attributes.Add("readOnly", "readOnly");
    }

    private void Machine()
    {
        ddlmachine.DataSource = StockReports.GetDataTable("SELECT machineID,MachineNAme FROM `" + AllGlobalFunction.MachineDB + "`.`mac_machinemaster` where CentreID="+UserInfo.Centre+"");
        ddlmachine.DataTextField = "MachineNAme";
        ddlmachine.DataValueField = "machineID";
        ddlmachine.DataBind();
        ddlmachine.Items.Insert(0, "");
    }

    private void BindPanel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pn.Company_Name,concat(pn.Panel_ID,'#',pn.ReferenceCodeOPD)PanelID  FROM Centre_Panel cp ");
        sb.Append(" INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id WHERE cp.CentreId='" + UserInfo.Centre + "' AND cp.isActive=1 order by pn.Company_Name ");
        DataTable dtPanel = StockReports.GetDataTable(sb.ToString());
        if (dtPanel != null && dtPanel.Rows.Count > 0)
        {
            ddlPanel.DataSource = dtPanel;
            ddlPanel.DataTextField = "Company_Name";
            ddlPanel.DataValueField = "PanelID";
            ddlPanel.DataBind();
            ddlPanel.Items.Insert(0, "");
            // ddlPanel.SelectedIndex = ddlPanel.Items.IndexOf(ddlPanel.Items.FindByValue("78#78"));
        }
        else
        {
            ddlPanel.Items.Clear();
            ddlPanel.Items.Add("-");
        }

        //Centre.bindPanel(ddlPanel);
    }

    private void Bindcenter()
    {
        chlCentre.DataSource = AllLoad_Data.getCentreByLogin();
        chlCentre.DataTextField = "Centre";
        chlCentre.DataValueField = "CentreID";
        chlCentre.DataBind();
        // chlCentre.Items.Add(new ListItem("All", "All"));
    }
    [WebMethod]
    public static string BindInvestigations(string DeptId)
    {
        if (DeptId != "")
        {
            string str = "select TypeName,ItemId from f_itemmaster Where SubCategoryId in (" + DeptId + ") order by TypeName";
            using (DataTable dt = StockReports.GetDataTable(str))
            {
                string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                return rtrn;
            }
        }
        else
        {
            return "0";
        }
    }
    private void BindDepartment()
    {
        using (DataTable dt = AllLoad_Data.getDepartment())
        {
            if (dt.Rows.Count > 0)
            {
                ddlDepartment.DataSource = dt;
                ddlDepartment.DataTextField = "NAME";
                ddlDepartment.DataValueField = "SubCategoryID";
                ddlDepartment.DataBind();
                //  ddlDepartment.Items.Insert(0, "");
            }
        }
    }



    #endregion Event Handling

}