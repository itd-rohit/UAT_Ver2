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
using System.Text;

public partial class Design_OPD_PROMappingReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
            BindPRO();
            //if (AllGlobalFunction.PROType == "P")
            //{
            //    rblPROType.SelectedValue = "Panel";
            //}
            //else
            //{
            //    rblPROType.SelectedValue = "Doctor";
            //}
        }
    }
    public void BindPRO()
    {
        string str = "SELECT  PROID,PRONAME FROM pro_master WHERE PRONAMe<>'' AND IsActive=1 ORDER BY PROname";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chklstPRO.DataSource = dt;
        chklstPRO.DataTextField = "PRONAME";
        chklstPRO.DataValueField = "PROID";
        chklstPRO.DataBind();
        //  chklstCenter. = ddlCentreAccess.Items.IndexOf(ddlCentreAccess.Items.FindByValue(Centre.Id));
    }
    public string GetData()
    {
        string PROData = StockReports.GetSelection(chklstPRO);
        if (PROData == "")
        {
            lblMsg.Text = "!!! Please Select PRO !!!";
            return "";
        }
        StringBuilder sb = new StringBuilder();
        if (rblPROType.SelectedValue == "Panel")
        {
            sb.Append(" SELECT pro.`Proid`,pro.`ProName`, ");
            sb.Append(" GROUP_CONCAT(fpm.`Company_Name`) AS Panel FROM");
            sb.Append(" pro_master pro ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`PROID`=pro.`PROID` ");
            sb.Append(" WHERE pro.`PROName`<>'' AND pro.PROID IN (" + PROData + ") GROUP BY pro.PROID ");
        }
        else
        {
            sb.Append(" SELECT pro.`PROID`,pro.`PROName`, ");
            sb.Append(" GROUP_CONCAT(dr.`Name`) AS Doctor FROM");
            sb.Append(" pro_master pro ");
            sb.Append(" INNER JOIN doctor_referal dr ON dr.`PROID`=pro.`PROID` ");
            sb.Append(" WHERE pro.`PROName`<>'' AND pro.PROID IN (" + PROData + ") GROUP BY pro.PROID ");
        }
        
        return sb.ToString();
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        DataTable dt = StockReports.GetDataTable(GetData());
        //DataTable dt = GetData();
        if (dt.Rows.Count > 0)
        {
                   
                Session["ReportName"] = "PRO Mapping Report";
                Session["Period"] = "";
                Session["dtExport2Excel"] = dt;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Finanace/ExportToExcel.aspx');", true);
           
        }
        else
        {
            lblMsg.Text = "No Data found...";
            return;
        }
       
    }
}
