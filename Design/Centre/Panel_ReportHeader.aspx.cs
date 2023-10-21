using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;

public partial class Design_Centre_Panel_ReportHeader : System.Web.UI.Page
{
    public DataTable dt =new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindcentre();
            bindPanel();
            GetHeader();
          
        }
        bindColumName();
    }
    private void bindcentre()
    {
        string mystr = "SELECT CentreID,Centre FROM centre_master  where isActive='1' order by centre";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(mystr);
        ddlCentre.DataSource = dt;
        ddlCentre.DataTextField = "Centre";
        ddlCentre.DataValueField = "CentreID";
        ddlCentre.DataBind();
        ddlCentre.SelectedIndex = ddlCentre.Items.IndexOf(ddlCentre.Items.FindByValue(UserInfo.Centre.ToString()));
    }
    private void bindPanel()
    {
        string BindPanel = "SELECT pm.Company_Name,pm.Panel_ID FROM f_panel_master pm INNER JOIN centre_panel cp ON pm.panel_ID=cp.panelId WHERE cp.centreid=" + ddlCentre.SelectedValue + "  ORDER BY Company_Name";

        DataTable mydt = StockReports.GetDataTable(BindPanel);
        ddlPanel.DataSource = mydt;
        ddlPanel.DataTextField = "Company_Name";
        ddlPanel.DataValueField = "Panel_ID";
        ddlPanel.DataBind();
        //ddlPanel.Items.Insert(0, "ALL");
    }
    protected void ddlCentre_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindPanel();
    }
    protected void ddlPanel_SelectedIndexChanged(object sender, EventArgs e)
    {
        GetHeader();
      
    }

    private void GetHeader()
    {
        DataTable dtdata = new DataTable();
        string str = "";

        str = "select ReportHeader,LeftMargin,TopMargin from centre_panel WHERE Centreid='" + ddlCentre.SelectedValue + "' AND PanelId='" + ddlPanel.SelectedValue + "' ";
            
           

             
          //if (ddlPanel.SelectedIndex > 0)
          //    {
                //str += " AND PanelId='" + ddlPanel.SelectedValue + "' ";
               //}
             dtdata = StockReports.GetDataTable(str);

             if (dtdata != null && dtdata.Rows.Count > 0)
             {
                 txtLimit.Text = Server.HtmlDecode( dtdata.Rows[0]["ReportHeader"].ToString());
                 txtLeftMargin.Text = dtdata.Rows[0]["LeftMargin"].ToString();
                 txtTopMargin.Text = dtdata.Rows[0]["TopMargin"].ToString();
             }
        
    }

    public void bindColumName()
    {
        dt = StockReports.GetDataTable("call GetPatientReport()");


    }
    protected void btnSave_Click(object sender, EventArgs e)
    {

        string Header = "";
        Header = txtLimit.Text;
        Header = Header.Replace("\'", "");
        Header = Header.Replace("–", "-");
        Header = Header.Replace("'", "");
        Header = Header.Replace("µ", "&micro;");
        Header = Header.Replace("ᴼ", "&deg;");
        Header = Header.Replace("#aaaaaa 1px dashed", "none");
        Header = Header.Replace("dashed", "none");
        
            
         Header=   Server.HtmlEncode(Header);
       
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
       
        try
        {
            string strupdt = "UPDATE  centre_panel SET ReportHeader='" + Header + "',TopMargin='" + txtTopMargin.Text + "',LeftMargin='" + txtLeftMargin.Text + "' WHERE Centreid='" + ddlCentre.SelectedValue + "' ";

            if (chkAll.Checked==false)
                   strupdt += "AND PanelId='" + ddlPanel.SelectedValue + "' ";

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, strupdt);

            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            lblMsg.Text = "Recored Saved Successfully";
            ddlPanel.Enabled = true;
            chkAll.Checked = false;


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
           lblMsg.Text = "Try Again....";
        }

    }
    protected void chkAll_CheckedChanged(object sender, EventArgs e)
    {
        if (chkAll.Checked==true)
        {
            ddlPanel.Enabled = false;
        }
        else
            ddlPanel.Enabled = true;

    }
}
