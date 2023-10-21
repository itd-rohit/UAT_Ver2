using System;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;



public partial class Design_Store_IndentIssue : System.Web.UI.Page
{

    public string CanClose = "0";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");


            string dt1 = StockReports.ExecuteScalar("SELECT count(*) FROM st_approvalright WHERE apprightfor='SI' and active=1 AND employeeid='" + UserInfo.ID + "' and typeid=12 ");
            if (dt1 != "0")
            {
                CanClose = "1";


            }

            bindalldata();
            //rdoIndentType.SelectedValue = "SI";
           // rdoIndentType.Enabled = checkIndentTypeRights();
            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM st_approvalright WHERE apprightfor='IS' AND active=1 AND employeeid='" + UserInfo.ID + "' ");
            if (dt == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';toast('Error','Dear User You Did not Have Right To Issue Item','');", true);
                return; 
            }




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

            ddllocationfrom.Items.Insert(0, new ListItem("Select Issue To Location", "0"));
        }

    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindindentfromlocation(string tolocation,  string TypeId, string ZoneId, string StateID,string IndentType = "SI")
    {
        StringBuilder sb = new StringBuilder();
        if (IndentType.Trim() == "SI")
        {

            sb.Append("  SELECT locationid locationid,location FROM st_locationmaster sl ");
            sb.Append("  INNER JOIN st_centerindentright    sc ON sl.locationid=sc.fromloationID AND sc.toLoationID=" + tolocation + " ");
            sb.Append("  AND IndentType='SI' AND  sl.isactive=1  ");

            sb.Append(" inner join f_panel_master pm on pm.panel_id=sl.panel_id INNER JOIN centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP')   and pm.IsActive=1 ");
            if (ZoneId != "")
                sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

            if (StateID != "")
                sb.Append(" AND cm.StateID IN(" + StateID + ")");


            if (TypeId != "")
                sb.Append(" AND cm.Type1Id IN(" + TypeId + ")");

         

            
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
    public static string SearchData(string tolocation, string fromdate, string todate, string fromlocation, string indentno, string indenttype,string ActionType, string IsSIIndentType = "SI")
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select * from (");
        sb.Append("   SELECT ifnull( (select  group_concat(distinct IssueInvoiceNo) from st_indentissuedetail where IndentNo=std.IndentNo),'')IssueInvoiceNo, ActionType,tolocationid,indentno,(SELECT location FROM st_locationmaster WHERE locationid=tolocationid)ToLocation, ");
        sb.Append("  (SELECT location FROM st_locationmaster WHERE locationid=fromlocationid)FromLocation,rejectreason,");
        sb.Append("  DATE_FORMAT(dtentry,'%d-%b-%Y') IndentDate,Username,");


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
        sb.Append(" WHEN SUM(if(ApprovedQty=0,ReqQty,ApprovedQty))=SUM(RejectQty) THEN 'Reject' else 'Partial Issue'  END ) `Status` ");


        sb.Append(" ,Narration,IF(DATE_FORMAT(ExpectedDate,'%d-%b-%Y')='01-Jan-2001'  || DATE_FORMAT(ExpectedDate,'%d-%b-%Y')='01-Jan-0001' ,'',DATE_FORMAT(ExpectedDate,'%d-%b-%Y')) ExpectedDate");

        sb.Append("  FROM st_indent_detail std where isactive=1 ");
        if (indentno == "")
        {
            sb.Append(" and dtentry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
            sb.Append(" and dtentry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        }
        if (tolocation != "0")
        {
            sb.Append(" AND tolocationid='" + tolocation + "'");
            // sb.Append(" AND tolocationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
        }
        if (fromlocation != "0")
        {
            sb.Append(" AND fromlocationid='" + fromlocation + "'");
        }
        if (ActionType != "")
        {
            sb.Append(" AND ActionType='" + ActionType + "'");
        }
        if (indentno != "")
        {
            sb.Append(" AND indentno='" + indentno + "'");
        }
        sb.Append(" AND IndentType='" + IsSIIndentType + "' and isactive=1");
        sb.Append("  GROUP BY indentno ORDER BY IndentNo)t");

        if (indenttype != "All" && indentno == "")
            sb.Append(" where t.Status='" + indenttype + "'");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindItemDetail(string IndentNo, string locationid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT std.minorunitname, id,itemid,itemname,ApprovedQty, ReqQty,ReceiveQty,RejectQty,PendingQty,");




        sb.Append("  (CASE WHEN RejectQty=0 and pendingqty=0 and receiveqty=0 THEN 'bisque'   ");
        sb.Append("  WHEN (ApprovedQty-pendingqty-RejectQty)>0 and receiveqty=0 THEN 'yellow'   ");
        sb.Append(" WHEN ApprovedQty=pendingqty+RejectQty and receiveqty=0 and RejectQty=0 THEN 'white'     ");
        sb.Append(" When  (pendingqty-RejectQty)>receiveqty and receiveqty>0 Then 'lightgray' ");
        sb.Append(" When  ApprovedQty=receiveqty+RejectQty  Then '#90EE90' ");
        sb.Append(" WHEN if(ApprovedQty=0,ReqQty,ApprovedQty)=RejectQty THEN 'Pink'  else  'white'  END ) `Rowcolor` ,");




        sb.Append("  (CASE WHEN RejectQty=0 and pendingqty=0 and receiveqty=0 THEN 'New'   ");
        sb.Append("  WHEN (ApprovedQty-pendingqty-RejectQty)>0 and receiveqty=0 THEN 'Partial Issue'   ");
        sb.Append(" WHEN ApprovedQty=pendingqty+RejectQty and receiveqty=0 and RejectQty=0 THEN 'Issued'     ");
        sb.Append(" When  (pendingqty-RejectQty)>receiveqty and receiveqty>0 Then 'Partial Receive' ");
        
        sb.Append(" When  ApprovedQty=receiveqty+RejectQty Then 'Close' ");
        sb.Append(" WHEN if(ApprovedQty=0,ReqQty,ApprovedQty)=RejectQty THEN 'Reject'  else  'Issued'  END ) `Status`, ");




        sb.Append(" (select  sum(`InitialCount` - `ReleasedCount` - `PendingQty` ) from st_nmstock st where st.itemid=std.itemid and st.locationid='" + locationid + "' and ispost=1)AblQty ");

        sb.Append("  FROM st_indent_detail std where indentno='" + IndentNo + "'  and isactive=1");



        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string RejectIndent(string IndentNo, string Reason)
    {
        StockReports.ExecuteDML("update st_indent_detail set RejectQty=(ApprovedQty-receiveqty-RejectQty),RejectReason='" + Reason + "', RejectBy='" + UserInfo.ID + "', dtReject=now(), CancelUserId='" + UserInfo.ID + "', CancelReason='" + Reason + "', dtCancel=now() where indentno='" + IndentNo + "'");
        return "1";
    }


}