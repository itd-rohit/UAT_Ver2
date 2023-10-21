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


public partial class Design_Lab_DeptWisePendingList : System.Web.UI.Page
{
    public string AccessDepartment = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            AccessDepartment = StockReports.ExecuteScalar("SELECT AccessDepartment FROM employee_master WHERE Employee_ID='" + UserInfo.ID + "'");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
        bindCentreMaster();
        BindDepartment();
    }

    private void bindCentreMaster()
    {
        ddlCentre.DataSource = StockReports.GetDataTable("SELECT DISTINCT cm.centreid,centre FROM centre_master cm INNER JOIN f_login fl ON cm.`CentreID`=fl.`CentreID` AND fl.`EmployeeID`='" + UserInfo.ID + "' AND fl.Active=1 AND cm.isActive=1 ORDER BY centre ");
        ddlCentre.DataTextField = "centre";
        ddlCentre.DataValueField = "centreid";
        ddlCentre.DataBind();
        ListItem selectedListItem = ddlCentre.Items.FindByValue(UserInfo.Centre.ToString());

        if (selectedListItem != null)
        {
            selectedListItem.Selected = true;
        }
    }

    private void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");
        if (AccessDepartment.Trim() != "")
        {
            sb.Append("  and  SubCategoryID in (" + AccessDepartment + ") ");
        }
        sb.Append(" ORDER BY NAME");
        ddldept.DataSource = StockReports.GetDataTable(sb.ToString());
        ddldept.DataTextField = "NAME";
        ddldept.DataValueField = "SubCategoryID";
        ddldept.DataBind();
    }


    [WebMethod]
    public static string getReport(string dtFrom, string dtTo, string CentreID, string deptid, string centrename, string TimeFrom, string TimeTo, string AccessDepartmentEmpWise, string ItemID, string ReportType)
    {

        DateTime dateFrom = Convert.ToDateTime(dtFrom);
        DateTime dateTo = Convert.ToDateTime(dtTo);
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT ");
        sb.Append("  '" + centrename + "' TestCentre,plo.`LedgerTransactionNo` VisitID ");
        sb.Append(" ,plo.`BarcodeNo` SINNo,lt.`PName`, ");
        sb.Append("  GROUP_CONCAT(plo.`InvestigationName`)TestName,  ");
        if (ReportType == "Excel")
        {
            sb.Append("  DATE_FORMAT(sl.`ReceivedDate`,'%d-%m-%Y %h:%i%p') SRADateTime, ");
        }
        else
        {
            sb.Append("  DATE_FORMAT(sl.`ReceivedDate`,'%d-%m-%Y %h:%i%p') LogisticReceiveDate, "); // Here LogisticReceiveDate Used For SRADateTime            
        }
        sb.Append("  CASE When plo.issamplecollected='Y' THEN 'Dept. Received'   ");
        sb.Append("  ELSE 'SRA Done' End CurrentStatus  ");
        sb.Append(" FROM `patient_labinvestigation_opd` plo ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");
        sb.Append(" INNER JOIN investigation_observationtype iot ON plo.investigation_ID=iot.investigation_ID ");
        sb.Append(" inner join observationtype_master ot on ot.ObservationType_ID=iot.ObservationType_ID");
        if (deptid != "")
        {
            sb.Append(" and ot.ObservationType_ID in (" + deptid + ")");
        }
        else if (AccessDepartmentEmpWise.Trim() != "")
        {
            sb.Append("   and ot.ObservationType_ID  in (" + AccessDepartmentEmpWise + ") ");
        }
        sb.Append(" INNER JOIN `sample_logistic` sl ON sl.`BarcodeNo`=plo.`BarcodeNo` and sl.tocentreid='" + CentreID + "'  ");
        sb.Append(" AND sl.`Status`='Received' AND plo.`IsSampleCollected` IN('S','Y') AND plo.`Result_Flag`=0 AND plo.IsRefund=0 ");
        sb.Append("  INNER JOIN `patient_labinvestigation_opd_techniciandate` plot ON plot.Test_ID=plo.Test_ID  ");
        if (ItemID.Trim() != "" && ItemID.Trim() != "All")
            sb.Append(" and plo.Itemid='" + ItemID.Trim() + "'");
        sb.Append("  where  ");
        sb.Append(" plot.TechnicianDate>='" + Util.GetDateTime(dateFrom).ToString("yyyy-MM-dd") + " " + TimeFrom.Trim() + "' AND plot.TechnicianDate<='" + Util.GetDateTime(dateTo).ToString("yyyy-MM-dd") + " " + TimeTo.Trim() + "'  ");
        sb.Append("  Group by plo.Barcodeno ORDER BY sl.`ReceivedDate`,plo.`LedgerTransactionNo`,ot.Name,plo.`ItemName` ");
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {

            if (dt != null && dt.Rows.Count > 0)
            {
                if (ReportType == "Excel")
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "Pending report " + Util.GetDateTime(dateFrom).ToString("dd-MM-yyyy") + " from time " + TimeFrom.Trim() + " to time " + TimeTo.Trim() + "";
                    HttpContext.Current.Session["Period"] = "";
                }
                else
                {
                    DataColumn dc1 = new DataColumn();
                    dc1.ColumnName = "ReportHeading";
                    dc1.DefaultValue = "Pending report " + Util.GetDateTime(dateFrom).ToString("dd-MM-yyyy") + " from time " + TimeFrom.Trim() + " to time " + TimeTo.Trim() + "";
                    dt.Columns.Add(dc1);
                    DataColumn dc2 = new DataColumn();
                    dc2.ColumnName = "PrintedByID";
                    dc2.DefaultValue = Util.GetString(UserInfo.ID);
                    dt.Columns.Add(dc2);
                    DataColumn dc3 = new DataColumn();
                    dc3.ColumnName = "PrintedByName";
                    dc3.DefaultValue = UserInfo.LoginName;
                    dt.Columns.Add(dc3);

                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                    ds.Tables[0].TableName = "Table";
                    // ds.WriteXmlSchema(@"D://DeptPendingList.xml");
                    HttpContext.Current.Session["ds"] = ds;
                    HttpContext.Current.Session["ReportName"] = "TechnicianPendingReport";
                }
                return "1";
            }
            else
            {
                return "0";
            }
        }



    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetDepartmentWiseItem(string SubCategoryID, string AccessDepartmentEmp)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ItemID,CONCAT(TestCode,' ~ ',TypeName)TypeName FROM f_itemmaster WHERE IsActive=1 ");
        if (SubCategoryID.Trim() != "")
        {
            sb.Append(" AND SubcategoryID in(" + SubCategoryID + ") ");
        }
        else if (AccessDepartmentEmp.Trim() != "")
        {
            sb.Append(" AND SubcategoryID in(" + AccessDepartmentEmp + ") ");
        }
        sb.Append(" ORDER BY TypeName;");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }
}