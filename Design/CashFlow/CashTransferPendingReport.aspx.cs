using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_CashFlow_CashTransferPendingReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod(EnableSession = true)]
    public static string bindCentre()
    {
        return Util.getJson(StockReports.GetDataTable("SELECT CentreID,CONCAT(CentreCode,' ~ ',Centre)Centre FROM centre_master WHERE IsActive=1  "));
    }

    [WebMethod(EnableSession = true)]
    public static string bindSearchType(int SearchType, string[] CentreID)
    {
        string Centre = string.Join(",", CentreID);
        DataTable dt = new DataTable();

        if (SearchType == 1)
            dt = StockReports.GetDataTable("SELECT em.Employee_Id ID,em.Name `Name` FROM employee_master em INNER JOIN f_login fl ON em.`Employee_ID`=fl.`EmployeeID` AND fl.`Centreid` IN(" + Centre + ")  WHERE em.IsActive=1   GROUP BY fl.EmployeeId ORDER BY em.name");
        else if (SearchType == 2)
            dt = StockReports.GetDataTable("SELECT `Name`,`ID` ID FROM (SELECT fm.Name ,fm.FeildboyID id FROM feildboy_master fm  INNER JOIN `fieldboy_zonedetail` fmz ON fmz.`FieldBoyID`=fm.`FeildboyID` AND fmz.`ZoneID` = ( SELECT `BusinessZoneID` FROM  `centre_master` cm WHERE cm.`CentreID` IN(" + Centre + ") LIMIT 1) WHERE fm.isactive=1 ORDER BY NAME )t ");
        else if (SearchType == 3)
            dt = StockReports.GetDataTable("SELECT Bank_ID ID,BankName `Name` FROM f_bank_master bm  ");
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return null;
    }

    [WebMethod(EnableSession = true)]
    public static string bindSearchReport(int SearchType, string[] EmployeeID)
    {
        string EmpID = string.Join(",", EmployeeID);

        StringBuilder sb1 = new StringBuilder();
        if (SearchType == 1)
        {
            sb1.Append(" SELECT em.Name,SUM(aa.ReceivedAmt)+SUM(ReceivedTransferAmt)+SUM(aa.TransferPendingAmt) TotalInHandcash, ABS(SUM(aa.TransferPendingAmt)) TransferdAmtPendingforReceive FROM ");
            sb1.Append(" ( ");
            sb1.Append("        SELECT CreatedByID UserID, SUM(Amount)ReceivedAmt,0 ReceivedTransferAmt,0 TransferPendingAmt ");
            sb1.Append("        FROM f_receipt rec  ");
            sb1.Append("        WHERE  IsCancel=0 ");
            if (EmpID != string.Empty)
                sb1.Append("      AND  CreatedByID IN (" + EmpID + ") ");
            sb1.Append("        AND PaymentModeID=1 AND CreatedDate>='" + Util.GetDateTime(Resources.Resource.CashFlowStartDate).ToString("yyyy-MM-dd HH:mm:ss") + "'  GROUP BY rec.CreatedByID  ");
            sb1.Append("    UNION ALL  ");
            sb1.Append("        SELECT  Employee_ID_By UserID,0 ReceivedAmt,  SUM(Amount) ReceivedTransferAmt, 0 TransferPendingAmt   ");
            sb1.Append("        FROM f_receipt_onaccount ");
            sb1.Append("        WHERE IsCancel=0  AND IsReceive=1 ");
            if (EmpID != string.Empty)
                sb1.Append("        AND Employee_ID_By IN (" + EmpID + ")  ");
            sb1.Append("        GROUP BY Employee_ID_To  ");
            sb1.Append("    UNION ALL ");
            sb1.Append("        SELECT Employee_ID_By UserID,0 ReceivedAmt,  0 ReceivedTransferAmt, SUM(Amount) TransferPendingAmt  ");
            sb1.Append("        FROM f_receipt_onaccount ");
            sb1.Append("        WHERE IsCancel=0 AND IsReceive=0 ");
            if (EmpID != string.Empty)
                sb1.Append("        AND Employee_ID_By IN (" + EmpID + ")  ");
            sb1.Append("        GROUP BY Employee_ID_By ");
            sb1.Append("  ) aa ");
            sb1.Append(" INNER JOIN employee_master em ON em.employee_id=aa.UserID ");
            sb1.Append(" GROUP BY aa.UserID ");
            sb1.Append(" ");
        }
        else if (SearchType == 2)
        {
            sb1.Append(" SELECT EmployeeName_To NAME,SUM(ABS(Amount))TotalInHandCash,0 TransferdAmtPendingforReceive FROM f_receipt_onaccount WHERE typeID=2  ");
            sb1.Append(" AND IsCancel=0  AND IsReceive=1 GROUP BY Employee_ID_TO");
            sb1.Append("  ");
            sb1.Append(" UNION ALL  ");
            sb1.Append(" SELECT EmployeeName_To NAME,0 TotalInHandCash,SUM(ABS(Amount))TransferdAmtPendingforReceive FROM f_receipt_onaccount WHERE typeID=2  ");
            sb1.Append(" AND IsCancel=0  AND IsReceive=0 GROUP BY Employee_ID_TO");
            sb1.Append("  ");
        }
        else if (SearchType == 3)
        {
            sb1.Append(" SELECT EmployeeName_To NAME,SUM(ABS(Amount))TotalInHandCash,0 TransferdAmtPendingforReceive FROM f_receipt_onaccount WHERE typeID=3  ");
            sb1.Append(" AND IsCancel=0  AND IsReceive=1 GROUP BY Employee_ID_TO");
            sb1.Append("  ");
            sb1.Append(" UNION ALL  ");
            sb1.Append(" SELECT EmployeeName_To NAME,0 TotalInHandCash,SUM(ABS(Amount))TransferdAmtPendingforReceive FROM f_receipt_onaccount WHERE typeID=3  ");
            sb1.Append(" AND IsCancel=0  AND IsReceive=0 GROUP BY Employee_ID_TO");
            sb1.Append("  ");
        }

        using (DataTable dt = StockReports.GetDataTable(sb1.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Cash Transfer Pending Report";
                return "1";
            }
            else
                return null;
        }
    }
}