using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            bindcentre();

        }
    }
    void bindcentre()
    {
        ddlcentre.DataSource = StockReports.GetDataTable("SELECT centreid,centre FROM centre_master WHERE  isactive=1 AND  Type1 IN ('SL','RRL','NRL') ORDER BY centre");
        ddlcentre.DataTextField = "centre";
        ddlcentre.DataValueField = "centreid";
        ddlcentre.DataBind();
        ddlcentre.Items.Insert(0, new ListItem("Select", "0"));
    }


    protected void btnsearch_Click(object sender, EventArgs e)
    {
        DataTable dt = Search();

        if (dt.Rows.Count > 0)
        {
            lblMsg.Text = "";
            grd.DataSource = dt;
            grd.DataBind();
        }
        else
        {
            grd.DataSource = "";
            grd.DataBind();
            lblMsg.Text = "No Record Found..!";
            return;
        }

    }


    public DataTable Search()
    {

        string fromdate = Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + " 00:00:00";
        string todate = Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd") + " 23:59:59";
        StringBuilder sb;
        sb = new StringBuilder();

        sb.Append(" SELECT DATE_FORMAT(lt.Date,'%d-%b-%Y %h:%i %p') AS BillingDate, lt.LedgerTransactionNo AS VisitNo,cm.CentreCode,cm.Centre,pnl.Panel_Code,pnl.Company_Name as Panel, lt.PName AS PatientName,lt.Age,lt.Gender, ");
        sb.Append(" plo.ItemName, IF(plo.Formalin=0,'Without Formalin','With Formalin') AS Formalin FROM f_Ledgertransaction lt ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.LedgertransactionId=lt.LedgertransactionId ");
        sb.Append(" INNER JOIN centre_master cm ON cm.CentreId=plo.TestCentreId ");
        sb.Append(" INNER JOIN f_Panel_master pnl ON pnl.Panel_Id=lt.Panel_Id ");
        sb.Append(" WHERE plo.SubcategoryId=7 AND lt.IsCancel=0   ");

        if (ddlcentre.SelectedValue != "0")
            sb.Append(" AND plo.`TestCentreID`='" + ddlcentre.SelectedValue + "' ");
        if (ddlFormalin.SelectedValue != "-1")
            sb.Append(" AND plo.Formalin='" + ddlFormalin.SelectedValue + "' ");
        sb.Append(" AND lt.DATE >= '" + fromdate + "' AND  lt.DATE <= '" + todate + "' ");
        sb.Append(" ORDER BY lt.Date ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return dt;

    }

    protected void btnExport_Click(object sender, EventArgs e)
    {

        DataTable dt = Search();
        if (dt.Rows.Count > 0)
        {
            Session["dtExport2Excel"] = dt;
            Session["ReportName"] = "BiposyReport_Formalin_" + DateTime.Now.ToString();
            ScriptManager.RegisterStartupScript(this, GetType(), "", "window.open('../common/ExportToExcel.aspx');", true);

        }
        else
        {
            lblMsg.Text = "No Record Found !";
        }

    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        /* Confirms that an HtmlForm control is rendered for the specified ASP.NET
           server control at run time. */
    }

}