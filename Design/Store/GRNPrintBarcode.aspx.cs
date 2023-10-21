using System;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_GRNPrintBarcode : System.Web.UI.Page
{
   
    protected void Page_Load(object sender, EventArgs e)
    {
        
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string labno)
    {


        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT LedgerTransactionID,LedgerTransactionNo,itemname,stockid,IFNULL(BatchNumber,'')batchnumber, ");
        sb.Append(" IF(ExpiryDate='0001-01-01','',DATE_FORMAT(ExpiryDate,'%d-%b-%Y'))ExpiryDate, ");
        sb.Append(" `TrimZero`((`InitialCount` - `ReleasedCount` - `PendingQty` )) InhandQty,MinorUnit,BarcodeNo,IF(Isfree=1,'Free','') IsFree ");
        sb.Append("  FROM st_nmstock WHERE `LedgerTransactionID`=" + Util.GetString(labno) + " ");

//System.IO.File.WriteAllText (@"F:\barcodegrn.txt", sb.ToString());


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

}