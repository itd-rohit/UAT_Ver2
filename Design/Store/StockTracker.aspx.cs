using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_StockTracker : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }



    [WebMethod]
    public static string GetStockData(string barcodeno)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DATE_FORMAT(stockdate,'%d-%b-%Y') EntryDate, ");
        sb.Append(" IFNULL(lt.`TypeOfTnx`,st.`Remarks`) TnxType,");
        sb.Append(" IF(IFNULL(lt.`TypeOfTnx`,'')='Purchase',lt.`LedgerTransactionNo`,'')GRNNo,");
        sb.Append(" st.indentno,");
        sb.Append(" sl.location,stockid,itemid,itemname,batchnumber,DATE_FORMAT(Expirydate,'%d-%b-%Y')Expirydate,");
        sb.Append(" rate,discountper,discountamount,taxper,st.taxamount ,");
        sb.Append(" unitprice,`InitialCount`,`ReleasedCount`,PendingQty,");
        sb.Append(" (`InitialCount`-`ReleasedCount`-PendingQty)InHandQty");
        sb.Append(" FROM st_nmstock st");
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.locationid=st.`LocationID`");
        sb.Append(" LEFT JOIN `st_ledgertransaction` lt ON lt.`LedgerTransactionID`=st.`LedgerTransactionID`");
        sb.Append(" WHERE barcodeno='" + barcodeno + "' AND IsPost=1 ");
        sb.Append(" ORDER BY stockdate");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public static string BindItemDetail(string Stockid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" ");

        sb.Append(" SELECT salesid, StockID,DATE_FORMAT(DATETIME,'%d-%b-%Y') EntryDate, ");
        sb.Append(" sl.`Location` FromLocation,sl1.`Location` ToLocation,sd.`Quantity`,sd.`TrasactionType`, ");
        sb.Append("  em.`Name` UserName  ");
        sb.Append(" FROM st_nmsalesdetails  sd ");
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.`LocationID`= sd.`FromLocationID` ");
        sb.Append(" INNER JOIN st_locationmaster sl1 ON sl1.`LocationID`= sd.`toLocationID` ");
        sb.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=sd.`UserID` ");
        sb.Append(" WHERE stockid=" + Stockid + " ORDER BY DATETIME ");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    
}