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

public partial class Design_Store_ReOpenClosedPO : System.Web.UI.Page
{
    public string reopen = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='PO' AND employeeid='" + UserInfo.ID + "' and active=1 and typename='PO ReOpen' ");
            if (dt != "0")
            {
                if (dt.Contains("PO ReOpen"))
                {
                    reopen = "1";
                }
              
            }
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);


        }
    }

    [WebMethod]
    public static string SearchData(string location, string fromdate, string todate, string ZoneID, string StateID, string CentreType, string PONo, string CloseType, string VendorID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" ");
        sb.Append(" SELECT  loc.Location, po.DiscountOnTotal,po.TaxAmount, po.PurchaseOrderNo,po.PurchaseOrderID,   ");

        sb.Append(" po.VendorName SupplierName, ");
        sb.Append("  DATE_FORMAT(po.closeddate,'%d-%b-%y')ClosedDate,closedbyname,closedreason,po.POType,po.GrossTotal,po.NetTotal,po.VendorID,Po.Status POStatus, ");

        sb.Append("  (CASE  WHEN po.Status=5 THEN 'Closed by System' WHEN po.Status=4 THEN 'Closed By User' END) POStatusType, ");
        sb.Append("  (CASE  WHEN po.Status=5 THEN '#CC99FF' WHEN po.Status=4 THEN '#f5b738'  END) rowColor,po.IndentNo,po.IsDirectPO,IFNULL(po.ActionType,'')ActionType,po.RejectReason ");
        sb.Append("  FROM st_purchaseorder po   ");
        sb.Append("  INNER JOIN st_vendormaster ven ON ven.SupplierID=po.VendorID ");
        sb.Append(" INNER JOIN st_locationmaster loc ON loc.LocationID=po.LocationID ");

        if (location != "")
        {
            sb.Append(" and loc.LocationID in (" + location + ")");
        }


        sb.Append(" WHERE  ");



        sb.Append("  po.closeddate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append("  AND po.closeddate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");

        sb.Append(" and po.Status in (4,5)");

        if (PONo != string.Empty)
        {
            sb.Append(" AND po.PurchaseOrderNo ='" + PONo + "'");
        }


        if (CloseType != "0")
        {
            sb.Append(" AND po.STATUS ='" + CloseType + "'");
        }


        if (VendorID != string.Empty)
            sb.Append(" AND ven.SupplierID IN (" + VendorID + ")");


        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Util.getJson(dt);

    }

    [WebMethod]
    public static string bindPODetail(string PurchaseOrderID)
    {
        StringBuilder sb = new StringBuilder();
       

        sb.Append(" SELECT im.`TypeName` ItemName,pod.RejectQty `RejectQty`,");
        sb.Append(" pod.`OrderedQty`,pod.`CheckedQty`,pod.`ApprovedQty`,pod.`GRNQty` ");
        sb.Append(" FROM st_purchaseorder_details pod ");
       
        sb.Append(" INNER JOIN st_itemmaster im ON im.`ItemID`=pod.`Itemid`  ");
        sb.Append(" WHERE pod.`PurchaseOrderID`=" + PurchaseOrderID + "  and RejectQty>0 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Util.getJson(dt);
    }
    [WebMethod]
    public static string reopennow(List<string> mydata, string reopenreason)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            foreach (string poid in mydata)
            {
                string cutoff = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT concat(isautorejectpo,'#',IF(isautorejectpo=1,autorejectpoafterdays,60)) cutoff FROM st_vendormaster WHERE supplierid=(SELECT vendorid FROM `st_purchaseorder` WHERE `PurchaseOrderID`='" + poid + "')"));

                if (cutoff == "")
                {
                    cutoff = "0#60";
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_purchaseorder set STATUS=2,StatusName='Approval',ActionType='Approval',isAutoClose=0,ReOpenDate=now(),ReOpenById='" + UserInfo.ID + "',ReOpenByName='" + UserInfo.LoginName + "',ReopenReason='" + reopenreason + "',POExpiryDate=DATE_ADD(NOW(),INTERVAL " + cutoff.Split('#')[1] + " DAY),IsAutoExpirable=" + cutoff.Split('#')[0] + " where PurchaseOrderID=" + poid + "");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update st_purchaseorder_details set Rejectqty=0 where PurchaseOrderID=" + poid + " and Rejectqty>0");

             


            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


}