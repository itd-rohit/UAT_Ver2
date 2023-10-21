using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_CashFlow_CashTransferDetailReport : System.Web.UI.Page
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
        using (dt as IDisposable)
        {

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
    }

    [WebMethod(EnableSession = true)]
    public static string bindSearchReport(int SearchType, string[] EmployeeID)
    {
        string EmpID = string.Join(",", EmployeeID);

        StringBuilder sb1 = new StringBuilder();
        if (SearchType == 1)
        {
            sb1.Append("  SELECT  CONCAT(em.Title,' ',em.Name)TransferBy,CONCAT(em1.Title,' ',em1.Name)TransferTo,em1.Mobile  TransferToMobileNo,  ");
            sb1.Append("   ABS(rec.Amount) PendingAmount,DATE_FORMAT(rec.CreatedDate,'%d-%b-%Y %H:%i:%s')TransferDate    FROM f_receipt_onaccount rec ");
            sb1.Append("      INNER JOIN employee_master em ON em.employee_id=rec.Employee_ID_By ");
            sb1.Append("      INNER JOIN employee_master em1 ON em1.employee_id=rec.Employee_ID_To ");
            sb1.Append("       WHERE rec.IsCancel=0 AND rec.IsReceive=0 ");
            if (EmpID != string.Empty)
                sb1.Append("    AND rec.Employee_ID_To IN (" + EmpID + ")  ");
            if (UserInfo.RoleID != 1 && UserInfo.RoleID != 6 && UserInfo.RoleID != 177)
                sb1.Append("        AND rec.Employee_ID_By='" + UserInfo.ID + "' ");
            sb1.Append("        AND rec.CreatedDate>='" + Resources.Resource.CashFlowStartDate + "'  ");
            sb1.Append("         ");
        }
        else if (SearchType == 2)
        {

            sb1.Append(" SELECT EmployeeName_By TransferBy,EmployeeName_To TransferTo,(ABS(Amount))PendingAmt FROM f_receipt_onaccount,DATE_FORMAT(CreatedDate,'%d-%b-%Y %HH:%mm:%ss')TransferDate WHERE typeID=2  ");
            sb1.Append(" AND IsCancel=0  AND IsReceive=0 ");
            if (EmpID != string.Empty)
                sb1.Append("    AND rec.Employee_ID_To IN (" + EmpID + ")  ");
            if (UserInfo.RoleID != 1 && UserInfo.RoleID != 6 && UserInfo.RoleID != 177)
                sb1.Append("        AND rec.Employee_ID_By='" + UserInfo.ID + "' ");
            sb1.Append("        AND rec.CreatedDate>='" + Resources.Resource.CashFlowStartDate + "'  ");
        }
        else if (SearchType == 3)
        {

            sb1.Append(" SELECT EmployeeName_By TransferBy,EmployeeName_To TransferTo,(ABS(Amount))PendingAmt,DATE_FORMAT(CreatedDate,'%d-%b-%Y %HH:%mm:%ss')TransferDate FROM f_receipt_onaccount WHERE typeID=3  ");
            sb1.Append(" AND IsCancel=0  AND IsReceive=0 ");
            if (EmpID != string.Empty)
                sb1.Append("    AND rec.Employee_ID_To IN (" + EmpID + ")  ");
            if (UserInfo.RoleID != 1 && UserInfo.RoleID != 6 && UserInfo.RoleID != 177)
                sb1.Append("        AND rec.Employee_ID_By='" + UserInfo.ID + "' ");
            sb1.Append("        AND rec.CreatedDate>='" + Resources.Resource.CashFlowStartDate + "'  ");
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