using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_OutSourceSampleReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    [WebMethod]
    public static string getReport(string dtFrom, string dtTo, string CentreID, string OutSourceLabID)
    {
        string retValue = "0";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            string[] CentreIDTags = CentreID.Split(',');
            string[] CentreIDParamNames = CentreIDTags.Select((s, i) => "@tag" + i).ToArray();
            string CentreIDClause = string.Join(", ", CentreIDParamNames);

            string[] OutSourceLabIDTags = OutSourceLabID.Split(',');
            string[] OutSourceLabIDParamNames = OutSourceLabIDTags.Select((s, i) => "@tag_" + i).ToArray();
            string OutSourceLabIDClause = string.Join(", ", OutSourceLabIDParamNames);

            OutSourceLabID = OutSourceLabID.TrimEnd(',');
            OutSourceLabID = "'" + OutSourceLabID + "'";
            OutSourceLabID = OutSourceLabID.Replace(",", "','");

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cm.`Centre` BookingCentre, DATE_FORMAT(lt.`Date`,'%d-%b-%y %h:%i %p') BookingDate,DATE_FORMAT(plo.`LabOutSrcDate`,'%d-%b-%y %h:%i %p') OutSourceDate, ");
            sb.Append(" plo.`LabOutsrcName`,lt.`LedgerTransactionNo` VisitNo,lt.`Patient_ID` UHID,lt.`PName`,lt.`Gender`,lt.`Age`, ");
            sb.Append(" plo.ItemCode `TestCode`,plo.`BarcodeNo`,plo.ItemName `InvestigationName` ,plo.`Rate` GrossAmount,plo.`Amount` NetAmount,IFNULL(ioc.`OutsourceRate`,0)OutsourceAmount ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
            sb.Append("  AND plo.`LabOutsrcID` IN(" + OutSourceLabID + ") AND plo.IsActive=1 ");
            if (CentreID.Trim() != "All")
                sb.Append(" AND lt.`CentreID` IN({1})  ");
            sb.Append(" AND lt.`Date`>=@FromDate AND lt.`Date`<=@ToDate ");
            sb.Append(" LEFT JOIN investigations_outsrclab ioc ON ioc.`Investigation_ID`=plo.`Investigation_ID` ");
            sb.Append(" AND ioc.`CentreID`=plo.`TestCentreID`   ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), OutSourceLabIDClause, CentreIDClause), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@FromDate", string.Concat(Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                da.SelectCommand.Parameters.AddWithValue("@ToDate", string.Concat(Util.GetDateTime(dtTo).ToString("yyyy-MM-dd"), " ", "23:59:59"));

                for (int i = 0; i < OutSourceLabIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(OutSourceLabIDParamNames[i], OutSourceLabIDTags[i]);
                }

                if (CentreID.Trim() != "All")
                {
                    for (int i = 0; i < CentreIDParamNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(CentreIDParamNames[i], CentreIDTags[i]);
                    }
                }

                
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    sb = new StringBuilder();
                    if (dt.Rows.Count > 0)
                    {
                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "OutSource Sample Report";
                        HttpContext.Current.Session["Period"] = string.Concat("From Date :", Util.GetDateTime(dtFrom).ToString("dd-MMM-yyyy"), "  To Date :", Util.GetDateTime(dtTo).ToString("dd-MMM-yyyy"));
                        retValue = "1";
                    }
                    else
                    {
                        retValue = "0";
                    }
                }
            }
            return retValue;

        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "-1";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindOutSourceLab()
    {
        return Util.getJson(StockReports.GetDataTable(" SELECT om.ID,om.`Name` FROM `outsourcelabmaster` om WHERE om.`Active`=1 ORDER BY om.`Name` "));
    }
    [WebMethod]
    public static string BindCentre()
    {
        return Util.getJson(StockReports.GetDataTable("  SELECT CentreID,Centre FROM centre_master where IsActive=1 ORDER BY centre  "));
    }


}