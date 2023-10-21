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
using System.Text;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;

public partial class Reports_Forms_LabAbnormalReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) { 
            fillData();
        reportaccess();
        bindCentreMaster();
        bindAccessTestCentre();
        }
    }
    private void bindCentreMaster()
    {
        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {
            if (dt.Rows.Count > 0)
            {
                chlCentres.DataSource = dt;
                chlCentres.DataTextField = "Centre";
                chlCentres.DataValueField = "centreID";
                chlCentres.DataBind();
                
            }
        }
    }
    private void bindAccessTestCentre()
    {

        using (DataTable dt = AllLoad_Data.loadCentre())
            if (dt != null && dt.Rows.Count > 0)
            {
                chlTestCentres.DataSource = dt;
                chlTestCentres.DataTextField = "Centre";
                chlTestCentres.DataValueField = "CentreID";
                chlTestCentres.DataBind();
            }
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(31));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(txtFromDate.Text).AddDays(response.DurationInDay);
                if (date < DateTime.Now.Date)
                {
                    lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
                    return false;
                }
            }
            if (response.ShowPdf == 1 && response.ShowExcel == 0)
            {
                rblreportformat.Items[0].Enabled = true;
                rblreportformat.Items[1].Enabled = false;
                rblreportformat.Items[0].Selected = true;
            }
            else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            {
                rblreportformat.Items[1].Enabled = true;
                rblreportformat.Items[0].Enabled = false;
                rblreportformat.Items[1].Selected = true;
            }
            else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            {
                rblreportformat.Visible = false;
                lblMsg.Text = "Report format not allowed contect to admin";
                return false;
            }
            //else
            //{
            //    rdoReportFormat.Items[0].Selected = true;
            //}
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
    private void fillData()
    {
        txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        string TestCentres = AllLoad_Data.GetSelection(chlTestCentres);
        if (Centres.Trim() == "")
        {
            lblMsg.Text = "Please Select Booking Centre";
            return;
        }
        if (TestCentres.Trim() == "")
        {
            lblMsg.Text = "Please Select Test Centre";
            return;
        }
         MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {

                    StringBuilder sb = new StringBuilder();
                    if (rdbAbCriReport.SelectedIndex == 0)
                    {
                        sb.Append(" SELECT pm.Patient_ID PID,pm.PName,pm.Age,pm.Gender,plo.Date,plo.LedgerTransactionNo LabNo,'Abnormal' ReportType, ");
                        sb.Append("  plo.`ItemName` Investigation,ploc.LabObservationName,ploc.Value,ploc.MinValue,ploc.MaxValue,");
                        sb.Append(" IF(ploc.Value IN ('POSITIVE','REACTIVE','WEAKLY REACTIVE','WEAKLY POSITIVE'),'',ploc.DisplayReading)DisplayReading, ");
                        sb.Append(" ploc.ReadingFormat FROM patient_labinvestigation_opd plo INNER JOIN patient_labobservation_opd ploc ON ");
                        sb.Append(" plo.Test_ID = ploc.Test_ID AND plo.Date >=@fromdate ");
                        sb.Append(" AND plo.Date <=@todate AND plo.Result_Flag=1 ");
                        sb.Append(" AND ploc.Value <>'' ");
                        sb.Append(" AND IF(ploc.Value IN ('POSITIVE','REACTIVE','WEAKLY REACTIVE','WEAKLY POSITIVE'),ploc.MinValue='',ploc.MinValue <> '') ");
                        sb.Append(" AND IF(ploc.Value IN ('POSITIVE','REACTIVE','WEAKLY REACTIVE','WEAKLY POSITIVE'),ploc.MaxValue='',ploc.MaxValue <> '') ");
                        sb.Append(" AND ((CAST(ploc.Value AS DECIMAL) NOT BETWEEN CAST(ploc.MinValue AS DECIMAL) AND CAST(ploc.MaxValue AS DECIMAL)) ");
                        sb.Append(" OR UCASE(ploc.VALUE) IN ('POSITIVE','REACTIVE','WEAKLY REACTIVE','WEAKLY POSITIVE'))");
                        
                        if (txtLabNo.Text.Trim() != "")
                        {
                            sb.Append(" AND plo.LedgertransactionNo =@LabNo ");
                        }
                        if (Centres.Trim() != "")
                        {
                            sb.Append("AND plo.`CentreID` in  (" + Centres + ")");
                        }
                        if (TestCentres.Trim() != "")
                        {
                            sb.Append("AND plo.`TestCentreID` in  ("+TestCentres+")");
                        }
                        sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID = plo.Patient_ID ");
                        if (txtPID.Text.Trim() != "")
                            sb.Append(" AND plo.Patient_ID =@Patient_ID ");
                        sb.Append(" ORDER BY plo.Test_ID ");
                    }
                    else
                    {
                        sb.Append(" SELECT DISTINCT pm.Patient_ID PID,pm.PName,pm.Age,pm.Gender,plo.Date,plo.LedgerTransactionNo LabNo,'Critical' ReportType,   ");
                        sb.Append("  plo.`ItemName` Investigation,ploc.LabObservationName,ploc.Value,ploc.MinValue,ploc.MaxValue,  ");
                        sb.Append(" IF(ploc.Value IN ('POSITIVE','REACTIVE','WEAKLY REACTIVE','WEAKLY POSITIVE'),'',ploc.DisplayReading)DisplayReading,  ploc.ReadingFormat , ");
                        sb.Append(" ploc.MinCritical,ploc.MaxCritical,CONCAT(ploc.MinCritical,'-',ploc.MaxCritical,' ',ploc.ReadingFormat) AS CriticalRange ");
                        sb.Append(" FROM patient_labinvestigation_opd plo  ");
                        sb.Append(" INNER JOIN patient_labobservation_opd ploc ON  plo.Test_ID = ploc.Test_ID  ");
                        sb.Append(" AND plo.Date >=@fromdate  ");
                        sb.Append(" AND DATE(plo.Date) <=@todate   AND ploc.Value <>'' AND plo.Result_Flag=1  AND (ploc.MinCritical<>0  OR ploc.MaxCritical<>0)   ");
                        sb.Append(" AND IF(ploc.Value IN ('POSITIVE','REACTIVE','WEAKLY REACTIVE','WEAKLY POSITIVE'),ploc.MinCritical='',ploc.MinCritical <> '')   ");
                        sb.Append(" AND IF(ploc.Value IN ('POSITIVE','REACTIVE','WEAKLY REACTIVE','WEAKLY POSITIVE'),ploc.MaxCritical='',ploc.MaxCritical <> '')  ");
                        sb.Append(" AND ((CAST(ploc.Value AS DECIMAL) NOT BETWEEN CAST(ploc.MinCritical AS DECIMAL) AND CAST(ploc.MaxCritical AS DECIMAL))  ");
                        sb.Append(" OR UCASE(ploc.VALUE) IN ('POSITIVE','REACTIVE','WEAKLY REACTIVE','WEAKLY POSITIVE'))   ");
                        sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID = plo.Patient_ID ");
                        sb.Append("  WHERE ploc.Value NOT IN ('POSITIVE','REACTIVE','WEAKLY REACTIVE','WEAKLY POSITIVE') ");
                        if (Centres.Trim() != "")
                        {
                            sb.Append("AND plo.`CentreID` in  (" + Centres + ")");
                        }
                             if (TestCentres.Trim() != "")
                        {
                            sb.Append("AND plo.`TestCentreID` in  (" + TestCentres + ")");
                        }
                       sb.Append(" ORDER BY plo.Test_ID ");
                    }                    

                    using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd"), " 00:00:00")),
                        new MySqlParameter("@todate", string.Concat(Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), " 23:59:59")),
                        new MySqlParameter("@LabNo", txtLabNo.Text.Trim()),
                        new MySqlParameter("@Patient_ID", txtPID.Text.Trim())).Tables[0])

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            DataColumn dc = new DataColumn();
                            dc.ColumnName = "User";
                            dc.DefaultValue = Convert.ToString(Session["ID"]);
                            dt.Columns.Add(dc);

                            dc = new DataColumn();
                            dc.ColumnName = "Period";
                            dc.DefaultValue = "Period From : " + txtFromDate.Text + " To : " + txtToDate.Text;
                            dt.Columns.Add(dc);

                            if (rblreportformat.SelectedValue == "2")
                            {
                                DataSet ds = new DataSet();
                                ds.Tables.Add(dt.Copy());
                                // dt.WriteXmlSchema(@"d:\LabAbnormal.xml");
                                Session["ds"] = ds;
                                Session["ReportName"] = rdbAbCriReport.SelectedItem.Text;
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
                            }
                            else
                            {
                                HttpContext.Current.Session["dtAbnormalReport"] = dt;
                                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('LabAbnormalReportPdf.aspx');", true);
                            }

                        }
                        else
                            lblMsg.Text = "No Record Found..!";

                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
                finally
                {
                    con.Close();
                    con.Dispose();
                }
    }
}
