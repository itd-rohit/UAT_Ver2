using HiQPdf;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_QualityIndicatorDelayTAT : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {




            ddlDeparment.DataSource = StockReports.GetDataTable(@" SELECT `SubcategoryID`,NAME  FROM `f_subcategorymaster` WHERE `Active`=1 ORDER BY NAME ");
            ddlDeparment.DataValueField = "SubcategoryID";
            ddlDeparment.DataTextField = "NAME";
            ddlDeparment.DataBind();
            ddlDeparment.Items.Insert(0, new ListItem("Department", "0"));
            ddlyear.SelectedValue = DateTime.Now.Year.ToString();
            ddlfrommonth.SelectedValue = DateTime.Now.Month.ToString();
            ddlTomonth.SelectedValue = DateTime.Now.Month.ToString();

            reportaccess();

        }
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(26));
        if (response.status == true)
        {
            //if (response.DurationInDay > 0)
            //{
            //    DateTime date = Util.GetDateTime(txtFromDate.Text).AddDays(response.DurationInDay);
            //    if (date < DateTime.Now.Date)
            //    {
            //        lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
            //        return false;
            //    }
            //}
            //if (response.ShowPdf == 1 && response.ShowExcel == 0)
            //{
            //    rblreportformat.Items[0].Enabled = true;
            //    rblreportformat.Items[1].Enabled = false;
            //    rblreportformat.Items[0].Selected = true;
            //}
            //else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            //{
            //    rblreportformat.Items[1].Enabled = true;
            //    rblreportformat.Items[0].Enabled = false;
            //    rblreportformat.Items[1].Selected = true;
            //}
            //else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            //{
            //    rblreportformat.Visible = false;
            //    lblMsg.Text = "Report format not allowed contect to admin";
            //    return false;
            //}
            ////else
            ////{
            ////    rdoReportFormat.Items[0].Selected = true;
            ////}
        }
        else
        {
            div1.Visible = false;
            div2.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }


    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre FROM centre_master   WHERE Type1Id =" + TypeId + " and centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY centre"));


    }


    [WebMethod]
    public static string Getsummaryreport1(string Deparment, string FromMonth, string ToMonth, string Year)
    {
        StringBuilder sb = new StringBuilder();

       sb.Append("   SELECT t.Month,t.DelayedSample,t.ToatalSample,((t.DelayedSample/t.ToatalSample)* 100) AS 'Delayed_Per' FROM  (SELECT  MONTHNAME(pli.date) AS 'Month', SUM(IF(IF(pli.`Approved` =0, NOW(),pli.`ApprovedDate`) > pli.`DeliveryDate`&& pli.`DeliveryDate` != '0001-01-01 00:00:00' && pli.`DeliveryDate` IS NOT NULL , 1,0)) AS 'DelayedSample' , SUM(1) AS 'ToatalSample' ");
       sb.Append(" FROM `patient_labinvestigation_opd` pli WHERE pli.SubcategoryID=" + Deparment + " and  pli.`Date`>='" + Year + "-" + FromMonth + "-01 00:00:00' AND pli.`Date`<='" + Year + "-" + ToMonth + "-31 23:59:59' ");
 sb.Append(" GROUP BY MONTH(pli.`Date`)) t  ");

      


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "ILCSummaryReport";
            return "true";
        }
        else
        {
            return "false";
        }
    }

  }