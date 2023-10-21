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
using System.Collections.Specialized;
using System.Web.Services;
using Newtonsoft.Json;

public partial class Design_OPD_LabObservationAnalysisReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            string _Query = @"SELECT scm.`SubCategoryID`,scm.`Name` FROM f_subcategorymaster scm
                              INNER JOIN f_itemmaster im ON im.`SubCategoryID`=scm.`SubCategoryID` 
                              AND scm.`CategoryID`='LSHHI3' AND im.`IsActive`=1 AND scm.`Active`=1
                              INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=im.`Type_ID`
                              WHERE inv.`ReportType`=1 GROUP BY scm.`SubCategoryID` ORDER BY scm.`Name`; ";
            lstDepartment.DataSource = StockReports.GetDataTable(_Query);
            lstDepartment.DataTextField = "Name";
            lstDepartment.DataValueField = "SubCategoryID";
            lstDepartment.DataBind();

            lstCentre.DataSource = AllLoad_Data.getCentreByLogin();
            lstCentre.DataTextField = "Centre";
            lstCentre.DataValueField = "CentreID";
            lstCentre.DataBind();

            lstTestCentre.DataSource = AllLoad_Data.getCentreByLogin();
            lstTestCentre.DataTextField = "Centre";
            lstTestCentre.DataValueField = "CentreID";
            lstTestCentre.DataBind(); 

            lstMac.DataSource = StockReports.GetDataTable("select MachineID from " + Util.getApp("MachineDB") + ".mac_machinemaster order by  MachineID;");
            lstMac.DataTextField = "MachineID";
            lstMac.DataValueField = "MachineID";
            lstMac.DataBind();

        }
    }
    [WebMethod]
    public static string GetReport(string FromDate, string ToDate, string CentreId,string TestCentreID, string ReportFromat, string Parameter, string Machine, string Reporttype)
    {
        string frdate = Util.GetDateTime(FromDate).ToString("yyyy-MM-dd");
        string tdate = Util.GetDateTime(ToDate).ToString("yyyy-MM-dd");
        try
        {
            return JsonConvert.SerializeObject(new { CentreID = CentreId, TestCentreID = TestCentreID, fromDate = frdate, toDate = tdate, ReportFormat = ReportFromat, ParameterID = Parameter, MachineID = Machine, reporttype = Reporttype });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }

    [WebMethod]
    public static string bindParameter(string DeptID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lom.labObservation_ID,lom.Name FROM f_subcategorymaster scm ");
        sb.Append(" INNER JOIN f_itemmaster im ON im.`SubCategoryID`=scm.`SubCategoryID` ");
        if (DeptID != "")
        {
            sb.Append(" and scm.`SubCategoryID` IN (" + DeptID + ") ");
        }
        sb.Append(" AND scm.`CategoryID`='LSHHI3' AND im.`IsActive`=1 AND scm.`Active`=1 ");
        sb.Append(" INNER JOIN `investigation_master` inv ON inv.`Investigation_Id`=im.`Type_ID` ");
        sb.Append(" INNER JOIN `labobservation_investigation` loi ON loi.`Investigation_Id`=inv.`Investigation_Id` ");
        sb.Append(" INNER JOIN `labobservation_master` lom ON lom.`LabObservation_ID`=loi.`labObservation_ID`");
        sb.Append(" WHERE inv.`ReportType`=1 AND lom.showflag=1 GROUP BY lom.`labObservation_ID` ORDER BY lom.Name; ");
		//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Reports\LabReport\parametes.txt",sb.ToString());
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return JsonConvert.SerializeObject(dt);
    }
}
