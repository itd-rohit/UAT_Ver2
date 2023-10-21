using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CashFlow_CashBalanceReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            AllLoad_Data.bindDropDown(ddlType, "", "SELECT ID,Type1 Text FROM centre_type1master Where IsActive=1 ORDER BY Type1 ");
            ddlType.Items.Insert(0, new ListItem("Select", "0"));

            txtDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtTime.Text = DateTime.Now.ToString("HH:mm:ss");
            calDate.StartDate = Util.GetDateTime(Resources.Resource.CashFlowStartDate);
            calDate.EndDate = DateTime.Now;
        }
        txtDate.Attributes.Add("readOnly", "true");
    }
    [WebMethod(EnableSession = true)]
    public static string getDate(string Date)
    {
        if (Util.GetDateTime(Date).ToString("dd-MMM-yyyy") != System.DateTime.Now.ToString("dd-MMM-yyyy"))
        {
            return "23:59:59";
        }
        else if (Util.GetDateTime(Date).ToString("dd-MMM-yyyy") == System.DateTime.Now.ToString("dd-MMM-yyyy"))
        {
            return System.DateTime.Now.ToString("HH:mm:ss");
        }
        else
        {
            return "";
        }
    }
    [WebMethod]
    public static string bindCentre(int typeID, int BusinessZoneID, int StateID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(cm.CentreCode,' ~ ',cm.Centre)Centre,cm.CentreID FROM centre_master cm ");
        sb.Append(" WHERE cm.BusinessZoneID='" + BusinessZoneID + "' AND cm.type1ID='" + typeID + "'");
        if (StateID != -1)
            sb.Append(" AND cm.StateID='" + StateID + "' ");
        sb.Append("");
        sb.Append("AND cm.isActive=1 ");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod(EnableSession = true)]
    public static string bindSearchType(string[] CentreID)
    {
        string Centre = string.Join(",", CentreID);
        DataTable dt = new DataTable();
        using (dt as IDisposable)
        {

            dt = StockReports.GetDataTable("SELECT em.Employee_Id ID,em.Name `Name` FROM employee_master em INNER JOIN f_login fl ON em.`Employee_ID`=fl.`EmployeeID` AND fl.`Centreid` IN(" + Centre + ")  WHERE em.IsActive=1   GROUP BY fl.EmployeeId ORDER BY em.name");

            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return null;
        }
    }
    [WebMethod(EnableSession = true)]
    public static string bindSearchReport(string[] EmployeeID, string[] Centre_ID, string Date, string Time)
    {
        string EmpID = string.Join(",", EmployeeID);
        string CentreID = string.Join(",", Centre_ID);

        string fromDate = string.Concat(Util.GetDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd"), " ", "00:00:00");
        string toDate = string.Concat(Util.GetDateTime(Util.GetDateTime(Date)).ToString("yyyy-MM-dd"), " ", Util.GetDateTime(Time).ToString("HH:mm:ss"));

        StringBuilder sb1 = new StringBuilder();
        sb1.Append(" SELECT t1.Centre,t1.Employee_ID,t1.Name UserName,t1.Mobile,t1.Opening,t1.CashCollection,t1.CashReceive,t1.CashTransfer,t1.ClosingBalance from ( ");
        sb1.Append("  SELECT cm.Centre,em.Employee_ID, CONCAT(em.Title,' ',em.Name)`Name`,em.Mobile,SUM(Opening)Opening,SUM(CashCollection)CashCollection,ABS(SUM(CashReceive))CashReceive,SUM(CashTransfer)CashTransfer, ");
        sb1.Append("  SUM(Opening)+SUM(CashCollection)+ABS(SUM(CashReceive))-SUM(CashTransfer)ClosingBalance ");
        sb1.Append(" FROM ( ");
        //Opening
        sb1.Append("        SELECT CreatedByID UserID, SUM(Amount)Opening,0 CashCollection,0 CashReceive,0 CashTransfer,0 ClosingBalance,CentreID ");
        sb1.Append("        FROM f_receipt rec  ");
        sb1.Append("        WHERE  IsCancel=0 "); 
        if (EmpID != string.Empty)
            sb1.Append("    AND  CreatedByID IN (" + EmpID + ") ");
        if (CentreID != string.Empty)
            sb1.Append("    AND  CentreID IN (" + CentreID + ") ");
        sb1.Append("        AND PaymentModeID=1   ");
        sb1.Append("        AND CreatedDate<'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd HH:mm:ss") + "'  ");
        sb1.Append("        AND CreatedDate>='" + Util.GetDateTime(Resources.Resource.CashFlowStartDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
        sb1.Append(" GROUP BY rec.CreatedByID,rec.CentreID   ");

        sb1.Append("    UNION ALL  ");
        sb1.Append("        SELECT  rec.Employee_ID_By UserID,SUM(rec.Amount) Opening,0 CashCollection, 0 CashReceive, 0 CashTransfer,0 ClosingBalance,rec.CentreID   ");
        sb1.Append("        FROM f_receipt_onaccount rec ");
        sb1.Append("        WHERE rec.IsCancel=0  AND rec.IsReceive=1 ");
        if (EmpID != string.Empty)
            sb1.Append("    AND rec.Employee_ID_By IN (" + EmpID + ")  ");
        if (CentreID != string.Empty)
            sb1.Append("    AND  CentreID IN (" + CentreID + ") ");
        sb1.Append("        AND rec.ReceiveDateTime<'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd HH:mm:ss") + "'  ");
        sb1.Append("        AND rec.ReceiveDateTime>='" + Util.GetDateTime(Resources.Resource.CashFlowStartDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
        sb1.Append("        GROUP BY rec.Employee_ID_To,rec.CentreID  ");

        sb1.Append("    UNION ALL ");
        sb1.Append("        SELECT rec.Employee_ID_By UserID,SUM(rec.Amount) Opening,0 CashCollection,  0 CashReceive,0 CashTransfer,0 ClosingBalance,rec.CentreID  ");
        sb1.Append("        FROM f_receipt_onaccount rec ");
        sb1.Append("        WHERE rec.IsCancel=0 AND rec.IsReceive=0 ");
        if (EmpID != string.Empty)
            sb1.Append("    AND Employee_ID_By IN (" + EmpID + ")  ");
        if (CentreID != string.Empty)
            sb1.Append("    AND  CentreID IN (" + CentreID + ") ");
        sb1.Append("        AND rec.ReceiveDateTime<'" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd HH:mm:ss") + "'  ");
        sb1.Append("        AND rec.ReceiveDateTime>='" + Util.GetDateTime(Resources.Resource.CashFlowStartDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
        sb1.Append("        GROUP BY rec.Employee_ID_By,rec.CentreID ");


        //CashCollection
        sb1.Append("    UNION ALL  ");
        sb1.Append("        SELECT CreatedByID UserID,0 Opening, SUM(rec.Amount)CashCollection,0 CashReceive,0 CashTransfer,0 ClosingBalance,rec.CentreID ");
        sb1.Append("        FROM f_receipt rec  ");
        sb1.Append("        WHERE  rec.IsCancel=0 ");
        if (EmpID != string.Empty)
            sb1.Append("    AND  rec.CreatedByID IN (" + EmpID + ") ");
        if (CentreID != string.Empty)
            sb1.Append("    AND  CentreID IN (" + CentreID + ") ");
        sb1.Append("        AND rec.PaymentModeID=1   ");
        sb1.Append("        AND rec.CreatedDate>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd HH:mm:ss") + "' AND  rec.CreatedDate<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
        sb1.Append(" GROUP BY rec.CreatedByID,rec.CentreID   ");


        //CashReceive
        sb1.Append("    UNION ALL  ");
        sb1.Append("        SELECT  rec.Employee_ID_By UserID,0 Opening,0 CashCollection,  SUM(rec.Amount) CashReceive, 0 CashTransfer,0 ClosingBalance,rec.CentreID   ");
        sb1.Append("        FROM f_receipt_onaccount rec ");
        sb1.Append("        WHERE rec.IsCancel=0  AND rec.IsReceive=1 ");
        if (EmpID != string.Empty)
            sb1.Append("    AND rec.Employee_ID_By IN (" + EmpID + ")  ");
        if (CentreID != string.Empty)
            sb1.Append("    AND  CentreID IN (" + CentreID + ") ");
        sb1.Append("        AND rec.ReceiveDateTime>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd HH:mm:ss") + "' AND  rec.ReceiveDateTime<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
        sb1.Append("        GROUP BY rec.Employee_ID_To,rec.CentreID  ");

        //CashTransfer
        sb1.Append("    UNION ALL ");
        sb1.Append("        SELECT rec.Employee_ID_By UserID,0 Opening,0 CashCollection,  0 CashReceive, SUM(rec.Amount) CashTransfer,0 ClosingBalance,rec.CentreID  ");
        sb1.Append("        FROM f_receipt_onaccount rec ");
        sb1.Append("        WHERE rec.IsCancel=0 AND rec.IsReceive=0 ");
        if (EmpID != string.Empty)
            sb1.Append("    AND Employee_ID_By IN (" + EmpID + ")  ");
        if (CentreID != string.Empty)
            sb1.Append("    AND  CentreID IN (" + CentreID + ") ");
        sb1.Append("        AND rec.ReceiveDateTime>='" + Util.GetDateTime(fromDate).ToString("yyyy-MM-dd HH:mm:ss") + "' AND  rec.ReceiveDateTime<='" + Util.GetDateTime(toDate).ToString("yyyy-MM-dd HH:mm:ss") + "' ");
        sb1.Append("        GROUP BY rec.Employee_ID_By,rec.CentreID ");

        sb1.Append(" )t  ");
        sb1.Append(" INNER JOIN employee_master em ON em.Employee_ID=t.UserID ");
        sb1.Append(" INNER JOIN centre_master cm ON cm.CentreID=t.CentreID ");
        sb1.Append(" GROUP BY t.UserID,t.CentreID ");
        sb1.Append(" )t1 ");
        sb1.Append(" WHERE (t1.Opening>0 OR  t1.CashCollection>0 OR t1.CashReceive>0 OR t1.CashTransfer>0) ORDER By Centre,UserName ");
        using (DataTable dt = StockReports.GetDataTable(sb1.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Cash Balance Report";
                return "1";
            }
            else
                return null;
        }
    }
}