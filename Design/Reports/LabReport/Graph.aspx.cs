using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Dashboard_Graph : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           // DateTime dt = DateTime.Now;
            //txtFormDate.Text = dt.ToString("dd-MMM-yyyy");
            //txtToDate.Text = dt.ToString("dd-MMM-yyyy");
            reportaccess();
        }
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(33));
        if (response.status == true)
        {
            //if (response.DurationInDay > 0)
            //{
            //    DateTime date = Util.GetDateTime(txtFormDate.Text).AddDays(response.DurationInDay);
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
            //else
            //{
            //    rdoReportFormat.Items[0].Selected = true;
            //}
        }
        else
        {
             SearchFilteres.Style.Add("display", "none");
            div2.Style.Add("display", "none");
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    [WebMethod]
    public static string GetChartData(string FromDate, string ToDate) 
    {

        if (FromDate == "")
        {
            FromDate = DateTime.Now.ToString("yyyy-MM-dd");
        }
        if (ToDate == "")
        {
            ToDate = DateTime.Now.ToString("yyyy-MM-dd");
        }
        DataSet ds = new DataSet();
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            //      -- Query for Departmentwise Patient
            sb = new StringBuilder();
            sb.Append(" SELECT    (CASE WHEN pli.`SubCategoryID`=1 THEN 'SPECIAL BIOCHEMISTRY'  ");
            sb.Append("  WHEN pli.`SubCategoryID`=10 THEN 'HAEMATOLOGY'  ");
            sb.Append("  WHEN pli.`SubCategoryID`=11 THEN 'HAEMATOLOGY(SPECIALISED)'  ");
            sb.Append("  WHEN pli.`SubCategoryID`=20 THEN 'SEROLOGY'  ");
            sb.Append("  WHEN pli.`SubCategoryID`=21 THEN 'IMMUNOHISTOCHEMISTRY'  ");
            sb.Append("  WHEN pli.`SubCategoryID`=13 THEN 'HISTOPATHOLOGY'  ");
            sb.Append("  WHEN pli.`SubCategoryID`=16 THEN 'MICROBIOLOGY'  ");
            sb.Append(" WHEN pli.`SubCategoryID`=17 THEN 'MISCELLANEOUS'   ");
            sb.Append("  WHEN pli.`SubCategoryID`=2 THEN 'BIOCHEMISTRY AND IMMUNOASSAY'   ");
            sb.Append("  WHEN pli.`SubCategoryID`=3 THEN 'CLINICAL PATHOLOGY'   ");
            sb.Append("  WHEN pli.`SubCategoryID`=4 THEN 'FISH & CYTOGENETICS'   ");
            sb.Append(" WHEN pli.`SubCategoryID`=5 THEN 'CYTOLOGY'    ");
            sb.Append("  WHEN pli.`SubCategoryID`=14 THEN 'IMMUNOASSAY'    ");
            sb.Append("  WHEN pli.`SubCategoryID`=15 THEN 'OPD-PACKAGE'    ");
            sb.Append("  WHEN pli.`SubCategoryID`=8 THEN 'FLOW CYTOMETRY'    ");
            sb.Append("  WHEN pli.`SubCategoryID`=18 THEN 'MOLECULAR DIAGNOSTICS'  ELSE 'Other' END)  ");


            sb.Append("   as label,COUNT(1) y FROM `patient_labinvestigation_opd`  pli ");
            sb.Append("  where pli.date >= @fromddate ");
            sb.Append(" AND pli.date <= @todate ");
            sb.Append(" GROUP BY pli.`SubCategoryID` ");

            DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@fromddate", string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " 00:00:00")),
                 new MySqlParameter("@todate", string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " 23:23:59"))).Tables[0];

            sb.Clear();
            // -- Query for status wise patient 
            sb = new StringBuilder();
            sb.Append(" SELECT label,COUNT(1) y FROM (  ");
            sb.Append(" SELECT CASE WHEN pli.IsSampleCollected='R' THEN 'Sample Rejected' ");//Sample Rejected
            sb.Append("  WHEN  pli.Approved='1' AND pli.isPrint='1' THEN 'Printed'  "); //Printed
            sb.Append("  WHEN   pli.Approved='1'  THEN 'Approved' "); //Approved
            sb.Append("  WHEN pli.isHold='1' THEN 'Hold' "); //Hold
            sb.Append("  WHEN pli.Result_Flag='1' AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R'  THEN 'Tested'  "); //Tested
            sb.Append("  WHEN pli.Result_Flag='1' AND pli.isHold='0' AND pli.isForward='1' THEN '#3399FF' ");
            sb.Append("  WHEN pli.Result_Flag='0' AND pli.isrerun='1' THEN 'Rerun'   ");
            sb.Append("  WHEN pli.Result_Flag='0' AND (SELECT COUNT(*) FROM mac_data mac WHERE mac.LedgerTransactionNO=pli.LedgerTransactionNO  ");
            sb.Append("  AND mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 THEN 'Mac Data' ");
            sb.Append("  WHEN pli.IsSampleCollected='N' or pli.IsSampleCollected='S' THEN 'New'  ");//New 
            sb.Append("  WHEN pli.Result_Flag=0 and pli.isSampleCollected='Y' THEN 'Department Receive' "); //Department Receive
            sb.Append("  else 'Other' ");
            sb.Append("    END AS label ");
            sb.Append("  FROM `patient_labinvestigation_opd` pli  ");
            sb.Append("   WHERE   pli.date >= @fromddate AND pli.date <= @todate )t GROUP BY label ORDER BY  label ");

            DataTable dt2 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@fromddate", string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " 00:00:00")),
               new MySqlParameter("@todate", string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " 23:23:59"))).Tables[0];
            sb.Clear();

            // -- location Wise count patient
            sb = new StringBuilder();
            sb.Append(" SELECT cm.`centre` as  label,COUNT(PLI.`Patient_ID`) y FROM `patient_labinvestigation_opd`  pli  ");
            sb.Append(" INNER JOIN `centre_master` cm ON cm.centreid=pli.`centreid` ");
            sb.Append("  Where pli.date >= @fromddate ");
            sb.Append(" AND pli.date <= @todate ");
            sb.Append(" GROUP BY pli.`centreid` ");
            DataTable dt3 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@fromddate", string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " 00:00:00")),
              new MySqlParameter("@todate", string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " 23:23:59"))).Tables[0];
            sb.Clear();

            // Test wise 
            sb = new StringBuilder();
            sb.Append(" SELECT pli.ItemName as  label,COUNT(*) y FROM `patient_labinvestigation_opd`  pli  ");
            sb.Append("  where pli.date >=@fromddate ");
            sb.Append(" AND pli.date <=@todate ");
            sb.Append(" GROUP BY pli.`ItemId` order by pli.date desc   ");
            DataTable dt4 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@fromddate", string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " 00:00:00")),
            new MySqlParameter("@todate", string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " 23:23:59"))).Tables[0];
            sb.Clear();

            dt1.TableName = "Departmentwise";
            dt2.TableName = "Status";
            dt3.TableName = "Location";
            dt4.TableName = "Test";

            ds.Tables.Add(dt1.Copy());
            ds.Tables.Add(dt2.Copy());
            ds.Tables.Add(dt3.Copy());
            ds.Tables.Add(dt4.Copy());
            Newtonsoft.Json.JsonConvert.SerializeObject(dt2);

        }
        catch (Exception)
        {

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(ds);
    }
}