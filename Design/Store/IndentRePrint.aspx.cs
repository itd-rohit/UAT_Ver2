using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_IndentRePrint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            bindalldata();
            rdoIndentType.SelectedValue = "SI";
            rdoIndentType.Enabled = checkIndentTypeRights();  

        }
    }
    bool checkIndentTypeRights()
    {
        if (Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(1) FROM st_approvalright WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 AND AppRightFor='PI' AND TypeName='Maker'")) > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT locationid locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();

            if (ddllocation.Items.Count > 1)
            {
                ddllocation.Items.Insert(0, new ListItem("Select Location", "0"));
            }
           
            ddllocationfrom.Items.Insert(0, new ListItem("Select From Location", "0"));
        }

    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindindentfromlocation(string tolocation, string IndentType = "SI")
    {
        StringBuilder sb = new StringBuilder();
        if (IndentType.Trim() == "SI")
        {
            sb.Append("  SELECT locationid locationid,location FROM st_locationmaster sl ");
            sb.Append("  INNER JOIN st_centerindentright    sc ON sl.locationid=sc.ToLoationID AND sc.FromLoationID=" + tolocation + " ");
            sb.Append("  AND IndentType='SI' AND  sl.isactive=1  ");
        }
        else
        {
            sb.Append("  SELECT locationid locationid,location FROM st_locationmaster sl ");
            sb.Append("  Where sl.locationid='2561' AND  sl.isactive=1  ");
        }

        sb.Append("  ORDER BY location  ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
       
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string tolocation, string fromdate, string todate, string fromlocation, string indentno, string indenttype, string ActionType, string IsSIIndentType = "SI")
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select * from (");
        sb.Append("   SELECT  '' IssueInvoiceNo, ActionType,tolocationid,indentno,(SELECT location FROM st_locationmaster WHERE locationid=tolocationid)ToLocation, ");
        sb.Append("  (SELECT location FROM st_locationmaster WHERE locationid=fromlocationid)FromLocation,");
        sb.Append("  DATE_FORMAT(dtentry,'%d-%b-%Y') IndentDate,Username,rejectreason, ");
        sb.Append("  ifnull(ApprovedUserName,'')ApprovedUserName,ifnull(DATE_FORMAT(ApprovedDate,'%d-%b-%Y'),'') ApprovedDate,ifnull( CheckedUserName,'')CheckedUserName, ifnull(DATE_FORMAT(CheckedDate,'%d-%b-%Y'),'') CheckedDate, ");
       

        sb.Append("  (CASE WHEN SUM(RejectQty)=0 and sum(pendingqty)=0 and sum(receiveqty)=0 THEN 'bisque'   ");
        sb.Append("  WHEN (SUM(ApprovedQty)-SUM(pendingqty)-SUM(RejectQty))>0 and sum(receiveqty)=0 THEN 'yellow'   ");
        sb.Append(" WHEN SUM(ApprovedQty)=sum(pendingqty)+SUM(RejectQty) and SUM(receiveqty)=0 and SUM(RejectQty)=0 THEN 'White'     ");
        sb.Append(" When  (sum(pendingqty)-SUM(RejectQty))>sum(receiveqty) and sum(receiveqty)>0 Then 'lightgray' ");
        sb.Append(" When  SUM(ApprovedQty)=sum(receiveqty)+SUM(RejectQty)   Then '#90EE90' ");
        sb.Append(" WHEN SUM(if(ApprovedQty=0,ReqQty,ApprovedQty))=SUM(RejectQty) THEN 'Pink' else  'yellow' END ) `Rowcolor` ,");


        sb.Append("  (CASE WHEN SUM(RejectQty)=0 and sum(pendingqty)=0 and sum(receiveqty)=0 THEN 'New'   ");
        sb.Append("  WHEN (SUM(ApprovedQty)-SUM(pendingqty)-SUM(RejectQty))>0 and sum(receiveqty)=0 THEN 'Partial Issue'   ");
        sb.Append(" WHEN SUM(ApprovedQty)=sum(pendingqty)+SUM(RejectQty) and SUM(receiveqty)=0 and SUM(RejectQty)=0 THEN 'Issued'     ");
        sb.Append(" When  (sum(pendingqty)-SUM(RejectQty))>sum(receiveqty) and sum(receiveqty)>0 Then 'Partial Receive' ");
      
        sb.Append(" When SUM(ApprovedQty)=sum(receiveqty)+SUM(RejectQty)  Then 'Close' ");
        sb.Append(" WHEN SUM(if(ApprovedQty=0,ReqQty,ApprovedQty))=SUM(RejectQty) THEN 'Reject' else 'Reject'  END ) `Status` ");


        sb.Append(" ,Narration,IF(DATE_FORMAT(ExpectedDate,'%d-%b-%Y')='01-Jan-2001'  || DATE_FORMAT(ExpectedDate,'%d-%b-%Y')='01-Jan-0001' ,'',DATE_FORMAT(ExpectedDate,'%d-%b-%Y')) ExpectedDate,(case when SUM(POQty)=0 then 'Pending' when SUM(POQty)=SUM(ApprovedQty) then 'PO Created' else 'In Progress' end )   POStatus");


        sb.Append(" ,ifnull(if(IndentType='SI','',(SELECT GROUP_CONCAT(`PurchaseOrderID`) FROM `st_purchaseorder` WHERE  `ActionType`='Approval' AND indentno=sid.indentno  )),'')ponumbers");
        sb.Append("  FROM st_indent_detail sid where isactive='1' ");

        sb.Append(" and dtentry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and dtentry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (tolocation != "0")
        {
            sb.Append(" AND tolocationid='" + tolocation + "'");
           // sb.Append(" AND tolocationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        }        
        if (fromlocation != "0")
        {
            sb.Append(" AND fromlocationid='" + fromlocation + "'");
        }
          else
        {
            sb.Append(" AND fromlocationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        }
        if (indentno != "")
        {
            sb.Append(" AND indentno='" + indentno + "'");
        }

        if (ActionType != "")
        {
            sb.Append(" AND ActionType='" + ActionType + "'");
        }
        sb.Append(" AND IndentType='" + IsSIIndentType + "' and isactive=1");
        sb.Append("  GROUP BY indentno ORDER BY IndentNo)t");
        if (indenttype != "All")
            sb.Append(" where t.Status='" + indenttype + "'");
	//System.IO.File.WriteAllText(@"D:\mac.txt",sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string IndentNo, string locationid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT std.minorunitname, id,std.itemid,itemname,ApprovedQty, ReqQty,ReceiveQty,RejectQty,PendingQty,sim.MinorUnitInDecimal,");




        sb.Append("  (CASE WHEN RejectQty=0 and pendingqty=0 and receiveqty=0 THEN 'bisque'   ");
        sb.Append("  WHEN (ApprovedQty-pendingqty-RejectQty)>0 and receiveqty=0 THEN 'yellow'   ");
        sb.Append(" WHEN ApprovedQty=pendingqty+RejectQty and receiveqty=0 and RejectQty=0 THEN 'white'     ");
        sb.Append(" When  (pendingqty-RejectQty)>receiveqty and receiveqty>0 Then 'lightgray' ");
        sb.Append(" When  ApprovedQty=receiveqty+RejectQty  Then '#90EE90' ");
        sb.Append(" WHEN if(ApprovedQty=0,ReqQty,ApprovedQty)=RejectQty THEN 'Pink' WHEN (ApprovedQty-pendingqty-RejectQty)>0  THEN 'yellow' else  'white'  END ) `Rowcolor` ,");




        sb.Append("  (CASE WHEN RejectQty=0 and pendingqty=0 and receiveqty=0 THEN 'New'   ");
        sb.Append("  WHEN (ApprovedQty-pendingqty-RejectQty)>0 and receiveqty=0 THEN 'Partial Issue'   ");
        sb.Append(" WHEN ApprovedQty=pendingqty+RejectQty and receiveqty=0 and RejectQty=0 THEN 'Issued'     ");
        sb.Append(" When  (pendingqty-RejectQty)>receiveqty and receiveqty>0 Then 'Partial Receive' ");
        
        sb.Append(" When  ApprovedQty=receiveqty+RejectQty Then 'Close' ");
        sb.Append(" WHEN if(ApprovedQty=0,ReqQty,ApprovedQty)=RejectQty THEN 'Reject' WHEN (ApprovedQty-pendingqty-RejectQty)>0  THEN 'Partial Issue' else  'Issued'  END ) `Status`, ");

        sb.Append(" (select  sum(`InitialCount` - `ReleasedCount` - `PendingQty` ) from st_nmstock st where st.itemid=std.itemid and st.locationid=std.fromlocationid and ispost=1)StockINHand, ");


        sb.Append(" (select  sum(`InitialCount` - `ReleasedCount` - `PendingQty` ) from st_nmstock st where st.itemid=std.itemid and st.locationid='" + locationid + "' and ispost=1)AblQty ");
       
        sb.Append("  FROM st_indent_detail std ");
        sb.Append(" inner join st_itemmaster sim on sim.itemid=std.itemid ");
        sb.Append(" where indentno='" + IndentNo + "' and std.isactive=1 ");



        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string RejectIndent(string IndentNo, string Reason)
    {
        StockReports.ExecuteDML("update st_indent_detail set RejectQty=ApprovedQty,RejectReason='" + Reason + "', RejectBy='" + UserInfo.ID + "', dtReject=now(), CancelUserId='" + UserInfo.ID + "', CancelReason='" + Reason + "', dtCancel=now(), IndentStatus='Reject' where indentno='" + IndentNo + "'");
        return "1";
    }




    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Excel(string tolocation, string fromdate, string todate, string fromlocation, string indentno, string indenttype)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("   SELECT IndentType, (SELECT location FROM st_locationmaster WHERE locationid=fromlocationid)FromLocation, ");
        sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid=tolocationid)ToLocation,IndentNo,");
        sb.Append("  DATE_FORMAT(dtentry,'%d-%b-%Y') IndentDate,");
        sb.Append(" Itemname,ReqQty,UserName CreatedUserName,CheckedQty,CheckedUserName,ApprovedQty, ApprovedUserName");

        if (indenttype == "PI")
        {
            sb.Append(",(select SupplierName from st_vendormaster where SupplierID=vendorid)SupplierName,Rate,DiscountPer,TaxPerIGST, ");
            sb.Append(" TaxPerCGST,TaxPerSGST,UnitPrice,NetAmount ");
        }



        sb.Append(" ,Narration,IF(DATE_FORMAT(ExpectedDate,'%d-%b-%Y')='01-Jan-2001'  || DATE_FORMAT(ExpectedDate,'%d-%b-%Y')='01-Jan-0001' ,'',DATE_FORMAT(ExpectedDate,'%d-%b-%Y')) ExpectedDate");

        sb.Append("  FROM st_indent_detail where isactive='1' ");

        sb.Append(" and dtentry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" and dtentry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (tolocation != "0")
        {
            sb.Append(" AND tolocationid='" + tolocation + "'");
        
        }
        if (fromlocation != "0")
        {
            sb.Append(" AND fromlocationid='" + fromlocation + "'");
        }

        if (indentno != "")
        {
            sb.Append(" AND indentno='" + indentno + "'");
        }


        sb.Append(" AND IndentType='" + indenttype + "' and isactive=1");
        sb.Append("   ORDER BY IndentNo,itemname");


        DataTable dt = StockReports.GetDataTable(sb.ToString());
        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = indenttype+" Indent";
            return "true";
        }
        else
        {
            return "false";
        }
    }


    [WebMethod]
    public static string encryptPurchaseOrderID(string ImageToPrint, string PurchaseOrderID)
    {
        List<string> addEncrypt = new List<string>();
        addEncrypt.Add(Common.Encrypt(ImageToPrint));
        addEncrypt.Add(Common.Encrypt(PurchaseOrderID));
        return JsonConvert.SerializeObject(addEncrypt);
    }
}