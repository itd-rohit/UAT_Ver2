using MySql.Data.MySqlClient;
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


public partial class Design_Store_CreateSalesIndent : System.Web.UI.Page
{
    public string IndentNo = "";
    public string IndentData = "";   
    public string ActionType = "";
    public static string ApplyFormula = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlcategorytype.DataSource =  StockReports.GetDataTable("SELECT `CategoryTypeID` ID,`CategoryTypeName` Name FROM st_categorytypemaster where active=1 ORDER BY CategoryTypeName desc");
            ddlcategorytype.DataValueField = "ID";
            ddlcategorytype.DataTextField = "Name";
            ddlcategorytype.DataBind();
            
            ApplyFormula = "0";//1 For Apply 0 For Not Apply
            bindalldata();
           // rdoIndentType.SelectedValue = "SI";
           // rdoIndentType.Enabled = checkIndentTypeRights();
            checkIndentTypeRights();
            setIndentData();
        }
    }

    void checkIndentTypeRights()
    {

      
        DataTable dt;
        StringBuilder sb;
        //isSIorPI For Maker
        if (Util.GetString(Request.QueryString["IndentNo"]).Trim() == "")
        {
            ActionType = "Maker";
            sb = new StringBuilder();
            sb.Append(" SELECT AppRightFor,TypeName  FROM st_approvalright ");
            sb.Append(" WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 AND AppRightFor IN('PI','SI') AND TypeName='Maker' ");
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {

              
                int IsSI = 0;
                int IsPI = 0;
                if (dt.Select("AppRightFor='SI'").Length > 0)
                {
                    IsSI = 1;

                 
                }
                if (dt.Select("AppRightFor='PI'").Length > 0)
                {
                    IsPI = 1;
                }
                if (IsSI == 0 && IsPI==0)
                {
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Any Right To Make SI or PI');", true);
                    return;                
                }
                else if (IsSI == 1 && IsPI == 1)
                {                    
                    rdoIndentType.SelectedValue = "SI";
                    rdoIndentType.Enabled = true;
                }
                else if (IsSI == 1 && IsPI == 0)
                {
                    rdoIndentType.SelectedValue = "SI";
                    rdoIndentType.Enabled = false;
                }
                else if (IsSI == 0 && IsPI == 1)
                {
                    rdoIndentType.SelectedValue = "PI";
                    rdoIndentType.Enabled = false;
                }
                
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Any Right To Make SI or PI');", true);
                return;
            }
        }
        else //isSIorPI For Checker Or Approval For Edit Only
        {
            ActionType =Util.GetString(Request.QueryString["ActionType"]).Trim();
            sb = new StringBuilder();
            sb.Append(" SELECT AppRightFor,TypeName  FROM st_approvalright ");
            sb.Append(" WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 AND AppRightFor IN('PI','SI') AND TypeName in('Maker','Checker','Approval','Access Amount Approval'); ");
            dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count == 0)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Any Right To Make Or Check Or Approve SI or PI');", true);
                return;
            }
            
        } 
    }

    void setIndentData()
    {
        IndentNo = Util.GetString(Request.QueryString["IndentNo"]);
        if (IndentNo.Trim() == "")
        {            
            IndentData = "[]";          
            return;
        }        
        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT IndentNo,ItemId ,ItemName ,FromLocationID ,FromPanelId ,ToLocationID , ");
        //sb.Append(" ToPanelID, ReqQty , MinorUnitID ,MinorUnitName ,DATE_FORMAT(ExpectedDate,'%d-%b-%y %h:%i %p')ExpectedDate,if(DATE_FORMAT(ExpectedDate,'%d-%b-%Y')='01-Jan-0001','',DATE_FORMAT(ExpectedDate,'%d-%b-%Y'))ExpectedDateToShow, Narration,IndentType ");
        //sb.Append(" ,(SELECT GROUP_CONCAT(TypeName)TypeName FROM st_approvalright WHERE `EmployeeID`='"+UserInfo.ID+"' AND Active=1 AND AppRightFor='PI' )TotalRigthsPI,ActionType ");
        //sb.Append(" ,(SELECT GROUP_CONCAT(TypeName)TypeName FROM st_approvalright WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 AND AppRightFor='SI' )TotalRigthsSI ");
        //sb.Append(" FROM st_indent_detail ");       
        //sb.Append(" where IndentNo='" + IndentNo.Trim() + "' AND receiveqty=0 AND rejectqty=0 and IsActive='1' order by id");
        sb.Append(" SELECT ifnull(checkercomment,'')checkercomment,sm11.categorytypeID, sd.checkedQty, sd.ApprovedQty,si.HsnCode,sm.name itemgroup,si.itemid,sm11.categorytypename,typename, IFNULL(apolloitemcode, '') apolloitemcode,si.ManufactureID, ");
        sb.Append(" si.MachineID,si.MajorUnitId,si.MajorUnitName,si.PackSize,si.IssueMultiplier,if(indenttype='SI',MinorUnitInDecimal,MajorUnitInDecimal)isdecimalallowed, ");
        sb.Append("   ifnull((select  sum(`InitialCount` - `ReleasedCount` - `PendingQty` ) from st_nmstock st where st.itemid=sd.itemid and st.locationid=sd.fromlocationid and ispost=1),0)   InhandQty, ");
        sb.Append(" sd.IndentNo,sd.ItemId ,sd.ItemName ,sd.FromLocationID ,sd.FromPanelId ,sd.ToLocationID , ");
        sb.Append(" sd.ToPanelID, sd.ReqQty , sd.MinorUnitID MinorUnitId ,sd.MinorUnitName , ");
        sb.Append(" DATE_FORMAT(sd.ExpectedDate,'%d-%b-%y %h:%i %p')ExpectedDate ");
        sb.Append(" ,ifnull(sd.Rate,0) Rate,ifnull(sd.DiscountPer,0) DiscountPer,ifnull(sd.TaxPerIGST,0)TaxPerIGST, ifnull(sd.TaxPerCGST,0)TaxPerCGST,ifnull(sd.TaxPerSGST,0)TaxPerSGST,");
        sb.Append(" sd.vendorid,sd.VendorStateId,ifnull(sd.VednorStateGstnno,'') VednorStateGstnno,");
        sb.Append(" IF(DATE_FORMAT(sd.ExpectedDate,'%d-%b-%Y')='01-Jan-2001' || DATE_FORMAT(sd.ExpectedDate,'%d-%b-%Y')='01-Jan-0001','',DATE_FORMAT(sd.ExpectedDate,'%d-%b-%Y'))ExpectedDateToShow, sd.Narration,sd.IndentType ");
        sb.Append(" ,(SELECT GROUP_CONCAT(TypeName)TypeName FROM st_approvalright WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 AND AppRightFor='PI' )TotalRigthsPI,ActionType  ");
        sb.Append(" ,(SELECT GROUP_CONCAT(TypeName)TypeName FROM st_approvalright WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 AND AppRightFor='SI' )TotalRigthsSI,  ");
      
        sb.Append(" ifnull(( SELECT SUM(pod.`ApprovedQty` - (pod.`GRNQty`+pod.`RejectQty`+pod.rejectqtybyuser+pod.`RejectQtyByVendor`)) FROM `st_purchaseorder` po  ");
        sb.Append(" INNER JOIN  `st_purchaseorder_details` pod ON po.`PurchaseOrderID`=pod.`PurchaseOrderID` ");
        sb.Append(" WHERE po.`LocationID`=sd.fromlocationid  AND pod.ItemID=sd.itemid ");
        sb.Append(" AND pod.`ApprovedQty` > (pod.`GRNQty`+pod.`RejectQty`+pod.rejectqtybyuser+pod.`RejectQtyByVendor`)),0) LastPendingQty ");
        sb.Append(" ,ifnull((SELECT GROUP_CONCAT( CONCAT('<b>',itemname,'</b>  [Qty- ',TrimZero(reqqty),']'))  FROM st_indent_detail WHERE indentno='" + IndentNo.Trim() + "' AND isactive=0),'')deactiveitem ");


        sb.Append(" FROM st_indent_detail sd  ");
        sb.Append(" INNER JOIN st_itemmaster si ON si.`ItemID`=sd.`ItemId`  ");
        sb.Append(" INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID   ");
        sb.Append(" INNER JOIN st_categorytypemaster sm11 ON sm11.categorytypeID=si.categorytypeID   ");
        sb.Append(" WHERE sd.`IndentNo`='" + IndentNo.Trim() + "' AND sd.`IsActive`='1' ");
        sb.Append(" AND sd.receiveqty=0 AND sd.rejectqty=0  ORDER BY Rate desc ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            IndentData = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else {
            IndentData = "[]";
        }
    }

    bool checkIndentTypeRightsOld()
    {
        if (Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(1) FROM st_approvalright WHERE `EmployeeID`='"+UserInfo.ID+"' AND Active=1 AND AppRightFor='PI' AND TypeName='Maker'")) > 0)
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
            sb.Append("  SELECT concat(locationid,'#',panel_id) locationid,location FROM st_locationmaster WHERE isactive=1   ");
            sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
            ddlfromlocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddlfromlocation.DataTextField = "location";
            ddlfromlocation.DataValueField = "locationid";
            ddlfromlocation.DataBind();
          
            if (ddlfromlocation.Items.Count > 1)
            {
                ddlfromlocation.Items.Insert(0, new ListItem("Select Location", "0"));
            }
            ddltolocation.Items.Insert(0, new ListItem("Select To Location", "0"));
        }

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string checkshowrate(string IndentType = "SI", string ActionType = "Maker")
    {
       return StockReports.ExecuteScalar("select ShowRate from st_approvalright where AppRightFor='" + IndentType + "' and employeeID='" + UserInfo.ID + "' and typename='"+ActionType+"' and active=1");
    }
    
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindindenttolocation(string fromlocation,  string myindentno,string IndentType = "SI")
    {
        StringBuilder sb = new StringBuilder();        
        if (IndentType.Trim() == "SI")
        {
            sb.Append("  SELECT CONCAT(locationid,'#',panel_id) locationid,location FROM st_locationmaster sl ");
            sb.Append("  INNER JOIN st_centerindentright    sc ON sl.locationid=sc.ToLoationID AND sc.FromLoationID=" + fromlocation.Split('#')[0] + " ");
            sb.Append("  AND IndentType='SI' AND  sl.isactive=1  ");
        }
        else
        {


            if (Util.GetString(myindentno).Trim() == "")
            {


                sb.Append("  SELECT CONCAT(locationid,'#',panel_id) locationid,location,ifnull((SELECT BudgetAmount FROM st_budget_master WHERE locationid=" + fromlocation.Split('#')[0] + " AND MONTH(BudgetDate)=MONTH(NOW()) AND YEAR(BudgetDate)=YEAR(NOW()) ),0) BudgetAmount,(SELECT IFNULL(SUM(netamount),0) FROM `st_indent_detail` WHERE FromLocationID=" + fromlocation.Split('#')[0] + " AND IndentType='PI' AND reqqty<>rejectqty and isactive=1 and MONTH(dtEntry)=MONTH(NOW()) AND YEAR(dtEntry)=YEAR(NOW()) and indenttype='PI') MonthIndentAmount,(SELECT IFNULL(SUM(netamount),0) FROM `st_indent_detail` WHERE FromLocationID=" + fromlocation.Split('#')[0] + " and isactive=1 AND IndentType='PI' AND reqqty<>rejectqty and MONTH(dtEntry)=MONTH(NOW()) AND YEAR(dtEntry)=YEAR(NOW()) and indenttype='SI') MonthIndentAmountSI FROM st_locationmaster sl ");
                sb.Append("  Where sl.locationid='1' AND  sl.isactive=1  ");
            }
            else
            {
                string month = StockReports.ExecuteScalar("select MONTH(dtEntry) from st_indent_detail where indentno='" + myindentno + "' limit 1");
                string year = StockReports.ExecuteScalar("select YEAR(dtEntry) from st_indent_detail where indentno='" + myindentno + "' limit 1");


                sb.Append("  SELECT CONCAT(locationid,'#',panel_id) locationid,location,ifnull((SELECT BudgetAmount FROM st_budget_master WHERE locationid=" + fromlocation.Split('#')[0] + " AND MONTH(BudgetDate)=" + month + " AND YEAR(BudgetDate)=" + year + " ),0) BudgetAmount,(SELECT IFNULL(SUM(netamount),0) FROM `st_indent_detail` WHERE FromLocationID=" + fromlocation.Split('#')[0] + " AND IndentType='PI' AND reqqty<>rejectqty and isactive=1 and MONTH(dtEntry)=" + month + " AND YEAR(dtEntry)=" + year + " and indenttype='PI') MonthIndentAmount,(SELECT IFNULL(SUM(netamount),0) FROM `st_indent_detail` WHERE FromLocationID=" + fromlocation.Split('#')[0] + " and isactive=1 AND IndentType='PI' AND reqqty<>rejectqty and MONTH(dtEntry)=" + month + " AND YEAR(dtEntry)=" + year + " and indenttype='SI') MonthIndentAmountSI FROM st_locationmaster sl ");
                sb.Append("  Where sl.locationid='1' AND  sl.isactive=1  ");


            }
        }
        
        sb.Append("  ORDER BY location  ");
            //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\indent.txt",sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchItem(string itemname, string locationidfrom, string locationidto,string itemcate, string IndentType = "SI", string searchoption="0")
    {
        StringBuilder sb = new StringBuilder();
        if (IndentType.Trim() == "SI")
        {
            sb.Append(" SELECT si.`ItemIDGroup`,sig.`ItemNameGroup`,si.`IssueMultiplier` ");
            sb.Append(" FROM st_itemmaster si     ");
            sb.Append(" INNER JOIN `st_itemmaster_group` sig ON sig.`ItemIDGroup`=si.`ItemIDGroup` ");
            sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`    ");
            sb.Append(" AND smm.`LocationId` IN (" + locationidfrom.Split('#')[0] + ")  ");
            //sb.Append(" AND smm.`IsPIItem`<>1 ");
            sb.Append(" and si.categorytypeid='" + itemcate + "' ");
            if (searchoption == "0")
            {
                sb.Append(" AND typename LIKE '" + itemname + "%'  ");
            }
            else if (searchoption == "1")
            {
                sb.Append(" AND typename LIKE '%" + itemname + "%'  ");
            }
            sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2 GROUP BY sig.`ItemIDGroup` ORDER BY sig.`ItemNameGroup` LIMIT 20   ");
        }
        else
        {
            sb.Append(" SELECT si.`ItemIDGroup`,sig.`ItemNameGroup`,si.`IssueMultiplier`   ");
            sb.Append(" FROM st_itemmaster si     ");
            sb.Append(" INNER JOIN `st_itemmaster_group` sig ON sig.`ItemIDGroup`=si.`ItemIDGroup` ");
            sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`  ");
            sb.Append(" AND smm.`LocationId` = " + locationidfrom.Split('#')[0] + "  ");
           // sb.Append(" AND smm.`IsPIItem`=1 ");
            sb.Append(" and si.categorytypeid='" + itemcate + "' ");
            if (searchoption == "0")
            {
                sb.Append(" AND typename LIKE '" + itemname + "%'  ");
            }
            else if (searchoption == "1")
            {
                sb.Append(" AND typename LIKE '%" + itemname + "%'  ");
            }
            sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2 GROUP BY sig.`ItemIDGroup` ORDER BY sig.`ItemNameGroup` LIMIT 20  ");
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string showoldindentdata(string itemid, string curlocation, string IndentType="SI")
    {
        StringBuilder sb = new StringBuilder();
        if (IndentType == "SI")
        {
        sb.Append(" SELECT IndentNo,ItemName, ");
        sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid= ToLocationID)IndentToLoccation,ReqQty,MinorUnitName, ");
        sb.Append(" ReceiveQty,RejectQty,UserName IndentSendBy, ");
        sb.Append(" IF(ExpectedDate='0001-01-01 00:00:00','',DATE_FORMAT(ExpectedDate,'%d-%b-%Y')) ExpectedDate, ");
        sb.Append(" DATE_FORMAT(dtEntry,'%d-%b-%Y') IndentDate ");
        sb.Append(" FROM `st_indent_detail` WHERE fromlocationid=" + curlocation.Split('#')[0] + " and IndentType='" + IndentType + "' AND itemid=" + itemid + " AND receiveqty=0 AND rejectqty=0 and IsActive='1' ");
        }
        else
        {
        sb = new StringBuilder();
        sb.Append(" SELECT IndentNo,ItemName, ");
            sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid= ToLocationID)IndentToLoccation,ReqQty,MinorUnitName, ");
            sb.Append(" ReceiveQty,RejectQty,UserName IndentSendBy, ");
            sb.Append(" IF(ExpectedDate='0001-01-01 00:00:00','',DATE_FORMAT(ExpectedDate,'%d-%b-%Y')) ExpectedDate, ");
            sb.Append(" DATE_FORMAT(dtEntry,'%d-%b-%Y') IndentDate ");
            sb.Append(" FROM `st_indent_detail` WHERE fromlocationid=" + curlocation.Split('#')[0] + " and IndentType='" + IndentType + "' AND itemid=" + itemid + " AND POQty=0 AND rejectqty=0 and IsActive='1' ");
        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchItemDetail(string itemid, string curlocation, string IndentType = "SI")
    {
        if (IndentType.Trim() == "SI")
        {
            int lastindent = Util.GetInt(StockReports.ExecuteScalar("SELECT count(*) FROM `st_indent_detail` WHERE IndentType='" + IndentType + "' and fromlocationid=" + curlocation.Split('#')[0] + " AND itemid=" + itemid + " AND approvedqty>receiveqty+rejectqty and IsActive='1' "));
            if (lastindent >= 2)
            {
                return "-1";
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT '' ExpectedDateToShow, si.HsnCode,sm.name itemgroup,si.itemid,sm11.categorytypename,typename,   IFNULL(apolloitemcode, '') apolloitemcode,si.ManufactureID, ");
           
            sb.Append("  si.MachineID,si.MajorUnitId,si.MajorUnitName,si.PackSize,si.MinorUnitId,si.MinorUnitName,si.IssueMultiplier,MinorUnitInDecimal isdecimalallowed");
           
            sb.Append(" ,ifnull((SELECT SUM(`InitialCount` - `ReleasedCount` - `PendingQty` ) FROM st_nmstock WHERE itemid='" + itemid + "' AND  locationid=" + curlocation.Split('#')[0] + " AND ispost=1),0) InhandQty ");
            sb.Append(" ,ifnull(qut.Rate,0) Rate,ifnull(qut.DiscountPer,0) DiscountPer,ifnull(qut.TaxPer,0)TaxPerIGST,0 TaxPerCGST,0 TaxPerSGST, '' deactiveitem,");
            sb.Append(" '0' vendorid,'0' VendorStateId, '' VednorStateGstnno, si.IssueMultiplier ");
            //sb.Append(" ,ifnull(sil.BufferPercentage,0) BufferPercentage,ifnull(sil.AverageConsumption,0) AverageConsumption,ifnull(sil.WastagePercentage,0) WastagePercentage,");
            //sb.Append(" (select sum(reqqty-receiveqty+rejectqty) from st_indent_detail WHERE IndentType='" + IndentType + "' and fromlocationid=" + curlocation.Split('#')[0] + " AND itemid=" + itemid + ")LastPendingQty");
            sb.Append("  FROM st_itemmaster si    ");
            sb.Append("  INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID   ");
            sb.Append(" INNER JOIN st_categorytypemaster sm11 ON sm11.categorytypeID=si.categorytypeID   ");
            sb.Append(" left join (select Rate,DiscountPer, TaxPer,itemid from st_nmstock where  itemid='" + itemid + "' AND  locationid=" + curlocation.Split('#')[0] + " AND ispost=1 and isfree=0 ORDER BY postdate DESC LIMIT 1 ) qut on qut.itemid=si.itemid ");
           // sb.Append(" left join st_itemlocationindentmaster sil on sil.itemid=si.itemid AND  locationid=" + locationidfrom.Split('#')[0] + " ");
            sb.Append("  WHERE si.itemid='" + itemid + "' and si.isactive=1 AND si.approvalstatus=2   ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
        }
        else
        {
            string department = StockReports.ExecuteScalar("select SubCategoryId from st_itemmaster where itemid=" + itemid + "");
            if (department != "57")
            {

                int lastindent = Util.GetInt(StockReports.ExecuteScalar("SELECT count(*) FROM `st_indent_detail` WHERE IndentType='" + IndentType + "' and fromlocationid=" + curlocation.Split('#')[0] + " AND itemid=" + itemid + " AND poqty=0 AND rejectqty=0 and IsActive='1' "));
                if (lastindent >= 2)
                {
                   return "-2";
                }

                int lastindent1 = Util.GetInt(StockReports.ExecuteScalar(@"SELECT COUNT(*) FROM `st_purchaseorder` po INNER JOIN 
`st_purchaseorder_details` pod ON po.`PurchaseOrderID`=pod.`PurchaseOrderID` AND po.`IndentNo`<>'' and po.status not in('4','5')
AND pod.`ItemID`=" + itemid + " AND pod.`ApprovedQty` > (pod.`GRNQty`+pod.`RejectQty`+pod.`RejectQtyByUser`+pod.`RejectQtyByVendor`) AND po.`LocationID`=" + curlocation.Split('#')[0] + " "));
                if (lastindent1 >= 2)
                {
                   // return "-3";
                }
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT '' ExpectedDateToShow, si.HsnCode,sm.name itemgroup,si.itemid,sm11.categorytypename,typename,apolloitemcode,si.ManufactureID, ");
            sb.Append("  si.MachineID,si.MajorUnitId,si.MajorUnitName,si.PackSize,si.MajorUnitId MinorUnitId,si.MajorUnitName MinorUnitName,si.IssueMultiplier,MajorUnitInDecimal isdecimalallowed ");
            sb.Append(" ,ifnull((SELECT SUM(`InitialCount` - `ReleasedCount` - `PendingQty` ) FROM st_nmstock WHERE itemid='" + itemid + "' AND  locationid=" + curlocation.Split('#')[0] + " AND ispost=1),0) InhandQty ");
            sb.Append(" ,ifnull(qut.Rate,0) Rate,ifnull(qut.DiscountPer,0) DiscountPer,ifnull(qut.IGSTPer,0)TaxPerIGST,ifnull(qut.CGSTPer,0)TaxPerCGST,ifnull(qut.SGSTPer,0)TaxPerSGST,");
            sb.Append(" qut.vendorid,qut.VendorStateId,qut.VednorStateGstnno, '' deactiveitem, si.IssueMultiplier ");
            sb.Append("  FROM st_itemmaster si    ");
            sb.Append("  INNER JOIN st_subcategorymaster sm ON sm.SubCategoryID=si.SubCategoryID   ");
            sb.Append(" INNER JOIN st_categorytypemaster sm11 ON sm11.categorytypeID=si.categorytypeID   ");
            sb.Append(" left join (select Rate,DiscountPer,IGSTPer,SGSTPer,CGSTPer,itemid,vendorid,VendorStateId,VednorStateGstnno from st_vendorqutation where    itemid='" + itemid + "' and ComparisonStatus=1 and IsActive=1 and ApprovalStatus=2 and EntryDateTo>=current_date() order by id desc limit 1) qut on qut.itemid=si.itemid ");
			//sb.Append(" left join (select Rate,DiscountPer,IGSTPer,SGSTPer,CGSTPer,itemid,vendorid,VendorStateId,VednorStateGstnno,ExpectedDay from st_vendorqutation where   DeliveryLocationID='" + curlocation.Split('#')[0] + "' and itemid='" + itemid + "' and ComparisonStatus=1 and IsActive=1 and ApprovalStatus=2 and EntryDateTo>=current_date() order by id desc limit 1) qut on qut.itemid=si.itemid ");
            sb.Append("  WHERE si.itemid='" + itemid + "' and si.isactive=1 AND si.approvalstatus=2   ");
			
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
			
        }
        
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveindent(List<StoreSalesIndent> store_SaveIndentdetail)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (store_SaveIndentdetail.Count > 0 && store_SaveIndentdetail[0].IndentNo == "")
            {
                // Cheking Rights For Maker
                StringBuilder sbRigths = new StringBuilder();
                sbRigths.Append(" SELECT AppRightFor,TypeName  FROM st_approvalright ");
                sbRigths.Append(" WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 ");
                sbRigths.Append(" AND AppRightFor='" + store_SaveIndentdetail[0].IndentType + "' AND TypeName='Maker' ");
                DataTable dtRigths = StockReports.GetDataTable(sbRigths.ToString());
                if (dtRigths.Rows.Count == 0)
                {
                    Exception ex = new System.Exception("Dear User You Did not Have Any Right To Make " + store_SaveIndentdetail[0].IndentType);
                    throw ex;
                }
                string indentno = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_get_indent_no('" + store_SaveIndentdetail[0].IndentType + "')").ToString();
                if (indentno == "")
                {
                    tnx.Rollback();
                    return "0#Error";
                }
                foreach (StoreSalesIndent ssi in store_SaveIndentdetail)
                {
                    if (ApplyFormula == "1")
                    {
                       string ischeck= CheckQty(ssi.ItemId, ssi.FromLocationID, ssi.ReqQty, ssi.IndentType);
                       if (ischeck != "1")
                       {
                           tnx.Rollback();
                           return "0#" + ischeck;
                       }
                    }

                    StoreSalesIndent objindent = new StoreSalesIndent(tnx);
                    objindent.IndentNo = indentno;
                    objindent.ItemId = ssi.ItemId;
                    objindent.ItemName = ssi.ItemName;
                    objindent.FromLocationID = ssi.FromLocationID;
                    objindent.FromPanelId = ssi.FromPanelId;
                    objindent.ToLocationID = ssi.ToLocationID;
                    objindent.ToPanelID = ssi.ToPanelID;
                    objindent.ReqQty = ssi.ReqQty;
                    objindent.MinorUnitID = ssi.MinorUnitID;
                    objindent.MinorUnitName = ssi.MinorUnitName;
                    objindent.ExpectedDate = Util.GetDateTime(ssi.ExpectedDate);
                    objindent.Narration = ssi.Narration;
                    objindent.IndentType = ssi.IndentType;
                    objindent.Rate = ssi.Rate;
                    objindent.DiscountPer = ssi.DiscountPer;
                    objindent.TaxPerIGST = ssi.TaxPerIGST;
                    objindent.TaxPerCGST = ssi.TaxPerCGST;
                    objindent.TaxPerSGST = ssi.TaxPerSGST;
                    objindent.FromRights = "Maker";
                    objindent.NetAmount = ssi.NetAmount;
                    objindent.UnitPrice = ssi.UnitPrice;
                    objindent.Vendorid=ssi.Vendorid;
                    objindent.VendorStateId=ssi.VendorStateId;
                    objindent.VednorStateGstnno=ssi.VednorStateGstnno;

                    objindent.MaxQty = ssi.MaxQty;



                    string a = objindent.Insert();
                    if (a == string.Empty)
                    {
                        tnx.Rollback();
                        return "0#Error";
                    }
                }
              

                //Send Email To Checkers
                Store_AllLoadData sa = new Store_AllLoadData();
                string EmailID = sa.getApprovalRightEnail(tnx, "1", store_SaveIndentdetail[0].IndentType);
            
                if (EmailID != string.Empty)
                {

                    StringBuilder sb = new StringBuilder();
                    sb.Append("<div> Dear All , </div>");
                    sb.Append("<br/>");
                    sb.AppendFormat(" Greetings from {0}", Resources.Resource.EmailSignature);
                    sb.Append("<br/>"); sb.Append("<br/>");
                    sb.Append("Please check Indent No <b>" + indentno + "</b>");
                    sb.Append("<br/><br/><br/><br/>"); 
                    
                    sb.Append("Thanks & Regards,"); 
                    sb.Append("<br/>");
                    sb.AppendFormat("{0}", Resources.Resource.EmailSignature);
                    sb.Append("<br/>");

                    ReportEmailClass REmail = new ReportEmailClass();
                    string IsSend="0";
                    // IsSend = REmail.sendstoreemail(EmailID, store_SaveIndentdetail[0].IndentType + " Indent", sb.ToString(), null, "", "", null, "", DateTime.Now.ToString("yyyy-MM-dd"));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO st_emailrecord(TransactionID,UserID,IsSend,Remarks,EmailID,MailedTo)VALUES(@TransactionID,@UserID,@IsSend,@Remarks,@EmailID,@MailedTo)",
                     new MySqlParameter("@TransactionID", indentno), 
                     new MySqlParameter("@UserID", UserInfo.ID), 
                     new MySqlParameter("@IsSend", IsSend),
                     new MySqlParameter("@Remarks", "Indent Checker"), 
                     new MySqlParameter("@EmailID", EmailID), 
                     new MySqlParameter("@MailedTo", "Indent"));

                }

                tnx.Commit();
                return "1#" + indentno;
            }
            else
            {
                string SIndentData = string.Empty;
                StringBuilder sb1 = new StringBuilder();
                sb1.Append(" SELECT sd.checkedQty, sd.ApprovedQty,sd.itemid,sd.itemname typename, ");
                sb1.Append(" '0' isdecimalallowed, ");
                sb1.Append(" ''InhandQty, ");
                sb1.Append(" sd.IndentNo,sd.ItemId ,sd.ItemName ,sd.FromLocationID ,sd.FromPanelId ,sd.ToLocationID , ");
                sb1.Append(" sd.ToPanelID, sd.ReqQty , sd.MinorUnitID MinorUnitId ,sd.MinorUnitName , ");
                sb1.Append(" DATE_FORMAT(sd.ExpectedDate,'%d-%b-%y %h:%i %p')ExpectedDate ");
                sb1.Append(" ,ifnull(sd.Rate,0) Rate,ifnull(sd.DiscountPer,0) DiscountPer,ifnull(sd.TaxPerIGST,0)TaxPerIGST, ifnull(sd.TaxPerCGST,0)TaxPerCGST,ifnull(sd.TaxPerSGST,0)TaxPerSGST,");
                sb1.Append(" sd.vendorid,sd.VendorStateId,ifnull(sd.VednorStateGstnno,'') VednorStateGstnno,");
                sb1.Append(" IF(DATE_FORMAT(sd.ExpectedDate,'%d-%b-%Y')='01-Jan-2001' || DATE_FORMAT(sd.ExpectedDate,'%d-%b-%Y')='01-Jan-0001','',DATE_FORMAT(sd.ExpectedDate,'%d-%b-%Y'))ExpectedDateToShow, sd.Narration,sd.IndentType ");
                sb1.Append(" ,(SELECT GROUP_CONCAT(TypeName)TypeName FROM st_approvalright WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 AND AppRightFor='PI' )TotalRigthsPI,ActionType  ");
                sb1.Append(" ,(SELECT GROUP_CONCAT(TypeName)TypeName FROM st_approvalright WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 AND AppRightFor='SI' )TotalRigthsSI  ");
                sb1.Append(" FROM st_indent_detail sd  ");
               
                sb1.Append(" WHERE sd.`IndentNo`='" + store_SaveIndentdetail[0].IndentNo + "' AND sd.`IsActive`='1' ");
                sb1.Append(" AND sd.receiveqty=0 AND sd.rejectqty=0  ORDER BY sd.id ");

                DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb1.ToString()).Tables[0];
                SIndentData = Newtonsoft.Json.JsonConvert.SerializeObject(dt);


                // Cheking Rights For Maker Or Checker
                StringBuilder sbRigths = new StringBuilder();
                sbRigths.Append(" SELECT AppRightFor,TypeName  FROM st_approvalright ");
                sbRigths.Append(" WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 ");
                sbRigths.Append(" AND AppRightFor='" + store_SaveIndentdetail[0].IndentType + "' AND TypeName in('Maker','Checker','Approval','Access Amount Approval') ");
                DataTable dtRigths = StockReports.GetDataTable(sbRigths.ToString());
                if (dtRigths.Rows.Count == 0)
                {
                    Exception ex = new System.Exception("Dear User You Did not Have Any Right To Make Or Check " + store_SaveIndentdetail[0].IndentType);
                    throw ex;
                }
                if (SIndentData.Trim() != "")
                {                   
                    List<StoreSalesIndent> ExistIndentData = (List<StoreSalesIndent>)Newtonsoft.Json.JsonConvert.DeserializeObject(SIndentData, typeof(List<StoreSalesIndent>));
                    string ExistIndentDataItemID = string.Join(",", ExistIndentData.OrderBy(zz => zz.ItemId).Select(x => x.ItemId)).Trim();
                    string CurrentIndentDataItemID = string.Join(",", store_SaveIndentdetail.OrderBy(zz => zz.ItemId).Select(x => x.ItemId)).Trim();
                    string ExistIndentDataItemQty = string.Join(",", ExistIndentData.OrderBy(zz => zz.ItemId).Select(x => x.ReqQty)).Trim();
                    string CurrentIndentDataItemQty = string.Join(",", store_SaveIndentdetail.OrderBy(zz => zz.ItemId).Select(x => x.ReqQty)).Trim();
                    if (ExistIndentDataItemID != CurrentIndentDataItemID || ExistIndentDataItemQty != CurrentIndentDataItemQty)
                    {
                        foreach (StoreSalesIndent ssi in ExistIndentData) // st_indent_detail_changes ( origional data backup table )
                        {
                            if (Util.GetInt(store_SaveIndentdetail.Count(xx => xx.ItemId == ssi.ItemId && xx.ReqQty == ssi.ReqQty)) == 0)
                            {

                                StringBuilder sb = new StringBuilder();
                                sb.Append(" UPDATE st_indent_detail SET FromRights=@FromRights  ");
                                sb.Append(" WHERE IndentNo=@IndentNo AND ItemId=@ItemId ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@IndentNo", ssi.IndentNo),
                                    new MySqlParameter("@FromRights", (Util.GetString(store_SaveIndentdetail[0].FromRights).Trim() == "") ? "Maker" : store_SaveIndentdetail[0].FromRights),
                                    new MySqlParameter("@ItemId", ssi.ItemId));
                              
                            }
                            // To DeActive Items
                            if ( Util.GetInt(store_SaveIndentdetail.Count(xx => xx.ItemId == ssi.ItemId)) == 0)
                            {
                                StringBuilder sb = new StringBuilder();
                                sb.Append(" UPDATE st_indent_detail SET IsActive=@IsActive,dtUpdate=@dtUpdate,UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID,Narration=@Narration,FromRights=@FromRights  ");
                                sb.Append(" WHERE IndentNo=@IndentNo AND ItemId=@ItemId ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@IsActive", "0"),
                                    new MySqlParameter("@dtUpdate", DateTime.Now),
                                    new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                                    new MySqlParameter("@UpdatedByID", UserInfo.ID),
                                    new MySqlParameter("@IndentNo", ssi.IndentNo),
                                    new MySqlParameter("@Narration", ssi.Narration),
                                    new MySqlParameter("@FromRights", (Util.GetString(store_SaveIndentdetail[0].FromRights).Trim() == "") ? "Maker" : store_SaveIndentdetail[0].FromRights),
                                    new MySqlParameter("@ItemId", ssi.ItemId));
                            }
                        }
                        foreach (StoreSalesIndent ssi in store_SaveIndentdetail) // st_indent_detail
                        {                            
                            if (Util.GetInt(ExistIndentData.Count(x => x.ItemId == ssi.ItemId)) > 0)
                            {
                                StringBuilder sb = new StringBuilder();
                                sb.Append(" UPDATE st_indent_detail SET ReqQty=@ReqQty,dtUpdate=@dtUpdate,UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID,Narration=@Narration  ");
                                sb.Append(" WHERE IndentNo=@IndentNo AND ItemId=@ItemId ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@ReqQty", ssi.ReqQty),
                                    new MySqlParameter("@dtUpdate", DateTime.Now),
                                    new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                                    new MySqlParameter("@UpdatedByID", UserInfo.ID),
                                    new MySqlParameter("@IndentNo", ssi.IndentNo),
                                    new MySqlParameter("@Narration", ssi.Narration),
                                    new MySqlParameter("@ItemId", ssi.ItemId));
                            }
                            else
                            {
                                StoreSalesIndent objindent = new StoreSalesIndent(tnx);
                                objindent.IndentNo = ssi.IndentNo;
                                objindent.ItemId = ssi.ItemId;
                                objindent.ItemName = ssi.ItemName;
                                objindent.FromLocationID = ssi.FromLocationID;
                                objindent.FromPanelId = ssi.FromPanelId;
                                objindent.ToLocationID = ssi.ToLocationID;
                                objindent.ToPanelID = ssi.ToPanelID;
                                objindent.ReqQty = ssi.ReqQty;
                                objindent.MinorUnitID = ssi.MinorUnitID;
                                objindent.MinorUnitName = ssi.MinorUnitName;
                                objindent.ExpectedDate = Util.GetDateTime(ssi.ExpectedDate);
                                objindent.Narration = ssi.Narration;
                                objindent.IndentType = ssi.IndentType;
                                objindent.Rate = ssi.Rate;
                                objindent.DiscountPer = ssi.DiscountPer;
                                objindent.TaxPerIGST = ssi.TaxPerIGST;
                                objindent.TaxPerCGST = ssi.TaxPerCGST;
                                objindent.TaxPerSGST = ssi.TaxPerSGST;
                                objindent.FromRights = (Util.GetString(ssi.FromRights).Trim() == "") ? "Maker" : ssi.FromRights;
                                objindent.NetAmount = ssi.NetAmount;
                                objindent.UnitPrice = ssi.UnitPrice;
                                objindent.Vendorid = ssi.Vendorid;
                                objindent.VendorStateId = ssi.VendorStateId;
                                objindent.VednorStateGstnno = ssi.VednorStateGstnno;
                                string a = objindent.Insert();
                                if (a == string.Empty)
                                {
                                    tnx.Rollback();
                                    return "0#Error";
                                }
                            }
                        }
                    }
                    else if ((ExistIndentData[0].Narration != store_SaveIndentdetail[0].Narration) || (ExistIndentData[0].ExpectedDate != store_SaveIndentdetail[0].ExpectedDate))
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE st_indent_detail SET Narration=@Narration,ExpectedDate=@ExpectedDate WHERE IndentNo=@IndentNo ",
                            new MySqlParameter("@IndentNo", store_SaveIndentdetail[0].IndentNo),
                            new MySqlParameter("@ExpectedDate", store_SaveIndentdetail[0].ExpectedDate),
                            new MySqlParameter("@Narration", store_SaveIndentdetail[0].Narration));                         
                    }                     
                    else
                    {
                        Exception ex = new Exception("Please Make Some Changes And Then Click On Save...!");
                        throw (ex);
                    }
                    tnx.Commit();                    
                }
                return "1#" + store_SaveIndentdetail[0].IndentNo;
            }
            
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.Message);

        }
        finally
        {
          //  SIndentData = SIndentData;
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindManufacturer(string locationidfrom,string ItemIDGroup,string IndentType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT si.`ManufactureID`,si.`ManufactureName`   ");
        sb.Append("  FROM st_itemmaster si      ");        
        sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`   ");
        sb.Append("  AND smm.`LocationId` = " + locationidfrom.Split('#')[0] + "   ");
        //if(IndentType.Trim()=="PI")
        //sb.Append(" AND smm.`IsPIItem`=1  ");
        sb.Append(" AND si.`ItemIDGroup`  = '"+ItemIDGroup+"' ");
        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2  ");
        sb.Append(" GROUP BY si.`ManufactureID` ");
        sb.Append(" ORDER BY si.`ManufactureName` ; ");
     
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindMachine(string locationidfrom, string ItemIDGroup, string ManufactureID, string IndentType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT si.`MachineID`,si.`MachineName`     ");
        sb.Append(" FROM st_itemmaster si       ");  
        sb.Append(" INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` = " + locationidfrom.Split('#')[0] + "    ");
       // if (IndentType.Trim() == "PI")
        //sb.Append(" AND smm.`IsPIItem`=1   ");
        sb.Append(" AND si.`ItemIDGroup`  = '"+ItemIDGroup+"' AND `ManufactureID`='"+ManufactureID+"'  ");
        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2   ");
        sb.Append("  GROUP BY si.`MachineID`  ");
        sb.Append("  ORDER BY si.`MachineName` ;  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindPackSize(string locationidfrom, string ItemIDGroup, string ManufactureID, string MachineID, string IndentType)
    {
        StringBuilder sb = new StringBuilder();
        if (IndentType == "SI")
        {
            sb.Append("  SELECT si.`PackSize`, concat(si.`IssueMultiplier`,'#',si.`MinorUnitName`,'#',si.`ItemID`,'#',MinorUnitInDecimal)PackValue  ");
        }
        else
        {
            sb.Append("  SELECT si.`PackSize`, concat(si.`IssueMultiplier`,'#',si.`MajorUnitName`,'#',si.`ItemID`,'#',MajorUnitInDecimal)PackValue  ");
        }
        sb.Append(" FROM st_itemmaster si       ");
        sb.Append("  INNER JOIN st_mappingitemmaster smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` = " + locationidfrom.Split('#')[0] + "    ");
       // if (IndentType.Trim() == "PI")
       // sb.Append(" AND smm.`IsPIItem`=1   ");
        sb.Append(" AND si.`ItemIDGroup`  = '" + ItemIDGroup + "' AND `ManufactureID`='" + ManufactureID + "' AND si.`MachineID`='" + MachineID + "'  ");

     


        sb.Append(" WHERE si.isactive=1 AND si.approvalstatus=2   ");
        sb.Append(" GROUP BY si.`PackSize`  ");
        sb.Append(" ORDER BY si.`PackSize` ;  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string MakeAction(List<StoreSalesIndent> store_SaveIndentdetail, string ButtonActionType, string RejectionReason, string checkercomment)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string SIndentData = string.Empty;
            StringBuilder sb1 = new StringBuilder();
            sb1.Append(" SELECT sd.checkedQty, sd.ApprovedQty,sd.itemid,sd.itemname typename, ");
            sb1.Append(" '0' isdecimalallowed, ");
            sb1.Append(" ''InhandQty, ");
            sb1.Append(" sd.IndentNo,sd.ItemId ,sd.ItemName ,sd.FromLocationID ,sd.FromPanelId ,sd.ToLocationID , ");
            sb1.Append(" sd.ToPanelID, sd.ReqQty , sd.MinorUnitID MinorUnitId ,sd.MinorUnitName , ");
            sb1.Append(" DATE_FORMAT(sd.ExpectedDate,'%d-%b-%y %h:%i %p')ExpectedDate ");
            sb1.Append(" ,ifnull(sd.Rate,0) Rate,ifnull(sd.DiscountPer,0) DiscountPer,ifnull(sd.TaxPerIGST,0)TaxPerIGST, ifnull(sd.TaxPerCGST,0)TaxPerCGST,ifnull(sd.TaxPerSGST,0)TaxPerSGST,");
            sb1.Append(" sd.vendorid,sd.VendorStateId,ifnull(sd.VednorStateGstnno,'') VednorStateGstnno,");
            sb1.Append(" IF(DATE_FORMAT(sd.ExpectedDate,'%d-%b-%Y')='01-Jan-2001' || DATE_FORMAT(sd.ExpectedDate,'%d-%b-%Y')='01-Jan-0001','',DATE_FORMAT(sd.ExpectedDate,'%d-%b-%Y'))ExpectedDateToShow, sd.Narration,sd.IndentType ");
            sb1.Append(" ,(SELECT GROUP_CONCAT(TypeName)TypeName FROM st_approvalright WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 AND AppRightFor='PI' )TotalRigthsPI,ActionType  ");
            sb1.Append(" ,(SELECT GROUP_CONCAT(TypeName)TypeName FROM st_approvalright WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 AND AppRightFor='SI' )TotalRigthsSI  ");
            sb1.Append(" FROM st_indent_detail sd  ");

            sb1.Append(" WHERE sd.`IndentNo`='" + store_SaveIndentdetail[0].IndentNo + "' AND sd.`IsActive`='1' ");
            sb1.Append(" AND sd.receiveqty=0 AND sd.rejectqty=0  ORDER BY sd.id ");
            SIndentData = Newtonsoft.Json.JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb1.ToString()).Tables[0]);
            // Cheking Rights For Maker Or Checker
            StringBuilder sbRigths = new StringBuilder();
            sbRigths.Append(" SELECT AppRightFor,TypeName  FROM st_approvalright ");
            sbRigths.Append(" WHERE `EmployeeID`='" + UserInfo.ID + "' AND Active=1 ");
            sbRigths.Append(" AND AppRightFor='" + store_SaveIndentdetail[0].IndentType + "' ");
            if (ButtonActionType.Trim() == "Check")
            {
                sbRigths.Append(" AND TypeName='Checker' ");
            }
            else
            {
                sbRigths.Append(" AND TypeName in('Approval','Access Amount Approval') ");
            }
            DataTable dtRigths = StockReports.GetDataTable(sbRigths.ToString());
            if (dtRigths.Rows.Count == 0)
            {
                Exception ex = new System.Exception("Dear User You Did not Have Any Right To Make Or Check " + store_SaveIndentdetail[0].IndentType);
                throw ex;
            }
            List<StoreSalesIndent> ExistIndentData = (List<StoreSalesIndent>)Newtonsoft.Json.JsonConvert.DeserializeObject(SIndentData, typeof(List<StoreSalesIndent>));
            if (ButtonActionType.Trim() == "Check" || ButtonActionType.Trim() == "Approve")
            {
                string ExistIndentDataItemID = string.Join(",", ExistIndentData.OrderBy(zz => zz.ItemId).Select(x => x.ItemId)).Trim();
                string CurrentIndentDataItemID = string.Join(",", store_SaveIndentdetail.OrderBy(zz => zz.ItemId).Select(x => x.ItemId)).Trim();
                string ExistIndentDataItemQty = string.Join(",", ExistIndentData.OrderBy(zz => zz.ItemId).Select(x => x.ReqQty)).Trim();
                string CurrentIndentDataItemQty = string.Join(",", store_SaveIndentdetail.OrderBy(zz => zz.ItemId).Select(x => x.ReqQty)).Trim();
                if (ExistIndentDataItemID != CurrentIndentDataItemID || ExistIndentDataItemQty != CurrentIndentDataItemQty)
                {

                    
                        foreach (StoreSalesIndent ssi in ExistIndentData) // st_indent_detail_changes ( origional data backup table )
                        {
                            if (Util.GetInt(store_SaveIndentdetail.Count(xx => xx.ItemId == ssi.ItemId && xx.ReqQty == ssi.ReqQty)) == 0)
                            {

                                StringBuilder sb = new StringBuilder();
                                sb.Append(" UPDATE st_indent_detail SET FromRights=@FromRights  ");
                                sb.Append(" WHERE IndentNo=@IndentNo AND ItemId=@ItemId ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@IndentNo", ssi.IndentNo),
                                    new MySqlParameter("@FromRights", (Util.GetString(store_SaveIndentdetail[0].FromRights).Trim() == "") ? "Maker" : store_SaveIndentdetail[0].FromRights),
                                    new MySqlParameter("@ItemId", ssi.ItemId));
                              
                            }
                            // To DeActive Items
                            if ( Util.GetInt(store_SaveIndentdetail.Count(xx => xx.ItemId == ssi.ItemId)) == 0)
                            {
                                StringBuilder sb = new StringBuilder();
                                sb.Append(" UPDATE st_indent_detail SET IsActive=@IsActive,dtUpdate=@dtUpdate,UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID,Narration=@Narration,FromRights=@FromRights  ");
                                sb.Append(" WHERE IndentNo=@IndentNo AND ItemId=@ItemId ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@IsActive", "0"),
                                    new MySqlParameter("@dtUpdate", DateTime.Now),
                                    new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                                    new MySqlParameter("@UpdatedByID", UserInfo.ID),
                                    new MySqlParameter("@IndentNo", ssi.IndentNo),
                                    new MySqlParameter("@Narration", ssi.Narration),
                                    new MySqlParameter("@FromRights", (Util.GetString(store_SaveIndentdetail[0].FromRights).Trim() == "") ? "Maker" : store_SaveIndentdetail[0].FromRights),
                                    new MySqlParameter("@ItemId", ssi.ItemId));
                            }
                        }
                        foreach (StoreSalesIndent ssi in store_SaveIndentdetail) // st_indent_detail
                        {                            
                            if (Util.GetInt(ExistIndentData.Count(x => x.ItemId == ssi.ItemId)) > 0)
                            {
                                StringBuilder sb = new StringBuilder();
                                sb.Append(" UPDATE st_indent_detail SET ReqQty=@ReqQty,dtUpdate=@dtUpdate,UpdatedBy=@UpdatedBy,UpdatedByID=@UpdatedByID,Narration=@Narration  ");
                                sb.Append(" WHERE IndentNo=@IndentNo AND ItemId=@ItemId ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@ReqQty", ssi.ReqQty),
                                    new MySqlParameter("@dtUpdate", DateTime.Now),
                                    new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                                    new MySqlParameter("@UpdatedByID", UserInfo.ID),
                                    new MySqlParameter("@IndentNo", ssi.IndentNo),
                                    new MySqlParameter("@Narration", ssi.Narration),
                                    new MySqlParameter("@ItemId", ssi.ItemId));
                            }
                            else
                            {
                                StoreSalesIndent objindent = new StoreSalesIndent(tnx);
                                objindent.IndentNo = ssi.IndentNo;
                                objindent.ItemId = ssi.ItemId;
                                objindent.ItemName = ssi.ItemName;
                                objindent.FromLocationID = ssi.FromLocationID;
                                objindent.FromPanelId = ssi.FromPanelId;
                                objindent.ToLocationID = ssi.ToLocationID;
                                objindent.ToPanelID = ssi.ToPanelID;
                                objindent.ReqQty = ssi.ReqQty;
                                objindent.MinorUnitID = ssi.MinorUnitID;
                                objindent.MinorUnitName = ssi.MinorUnitName;
                                objindent.ExpectedDate = Util.GetDateTime(ssi.ExpectedDate);
                                objindent.Narration = ssi.Narration;
                                objindent.IndentType = ssi.IndentType;
                                objindent.Rate = ssi.Rate;
                                objindent.DiscountPer = ssi.DiscountPer;
                                objindent.TaxPerIGST = ssi.TaxPerIGST;
                                objindent.TaxPerCGST = ssi.TaxPerCGST;
                                objindent.TaxPerSGST = ssi.TaxPerSGST;
                                objindent.FromRights = (Util.GetString(ssi.FromRights).Trim() == "") ? "Maker" : ssi.FromRights;
                                objindent.NetAmount = ssi.NetAmount;
                                objindent.UnitPrice = ssi.UnitPrice;
                                objindent.Vendorid = ssi.Vendorid;
                                objindent.VendorStateId = ssi.VendorStateId;
                                objindent.VednorStateGstnno = ssi.VednorStateGstnno;
                                string a = objindent.Insert();
                                if (a == string.Empty)
                                {
                                    tnx.Rollback();
                                    return "0#Error";
                                }
                            }
                        }
                    
                   
                    //Exception ex = new Exception("Please Save First Then Click On " + ButtonActionType.Trim());
                    //throw (ex);
                }
            }
            if (ButtonActionType.Trim() == "Check")
            {
             
                foreach (StoreSalesIndent ssi in store_SaveIndentdetail) // st_indent_detail
                {

                    var rate = ssi.Rate;
                    var discper = ssi.DiscountPer;
                    var IGST = ssi.TaxPerIGST;
                    var CGST = ssi.TaxPerCGST;
                    var SGST = ssi.TaxPerSGST;

                    var Tax = IGST == 0 ? (CGST + SGST) : IGST;

                    var discountAmout = rate * discper * 0.01;
                    var ratedisc = rate - discountAmout;
                    var tax = ratedisc * Tax * 0.01;
                    var ratetaxincludetax = ratedisc + tax;

                    var NetAmount = ratetaxincludetax * Util.GetFloat(ssi.CheckedQty);

                    StringBuilder sb = new StringBuilder();
                    sb.Append(" UPDATE st_indent_detail SET ActionType=@ActionType,Narration=@Narration,ExpectedDate=@ExpectedDate,  ");
                    sb.Append(" CheckedQty=@CheckedQty,CheckedDate=@CheckedDate,CheckedUserID=@CheckedUserID,CheckedUserName=@CheckedUserName,CheckerComment=@CheckerComment,NetAmount=@NetAmount,UnitPrice=@UnitPrice ");
                    sb.Append(" WHERE IndentNo=@IndentNo and IsActive=@IsActive  and ItemId=@ItemId");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@ActionType", "Checker"),
                        new MySqlParameter("@IsActive", "1"),
                        new MySqlParameter("@ItemId", ssi.ItemId),
                        new MySqlParameter("@CheckedQty", Util.GetFloat(ssi.CheckedQty)),
                        new MySqlParameter("@CheckedDate", Util.GetDateTime(DateTime.Now)),
                        new MySqlParameter("@CheckedUserName", UserInfo.LoginName),
                        new MySqlParameter("@CheckedUserID", UserInfo.ID),
                        new MySqlParameter("@ExpectedDate", Util.GetDateTime(ExistIndentData[0].ExpectedDate)),
                        new MySqlParameter("@IndentNo", store_SaveIndentdetail[0].IndentNo),
                        new MySqlParameter("@Narration", store_SaveIndentdetail[0].Narration),
                        new MySqlParameter("@CheckerComment", checkercomment),
                        new MySqlParameter("@NetAmount", NetAmount),
                        new MySqlParameter("@UnitPrice", ratetaxincludetax));
                }


                //Send Email To Approval
                Store_AllLoadData sa = new Store_AllLoadData();
                string EmailID = sa.getApprovalRightEnail(tnx, "2", store_SaveIndentdetail[0].IndentType);
            
                if (EmailID != string.Empty)
                {

                    StringBuilder sb = new StringBuilder();
                    sb.Append("<div> Dear All , </div>");
                    sb.Append("<br/>");
                    sb.AppendFormat(" Greetings from {0}", Resources.Resource.EmailSignature);
                    sb.Append("<br/>"); sb.Append("<br/>");
                    sb.Append("Please Approve Indent No <b>" + store_SaveIndentdetail[0].IndentNo + "</b>");
                    sb.Append("<br/><br/><br/><br/>");

                    sb.Append("Thanks & Regards,");
                    sb.Append("<br/>");
                    sb.AppendFormat("{0}", Resources.Resource.EmailSignature);
                    sb.Append("<br/>");

                    ReportEmailClass REmail = new ReportEmailClass();
string IsSend ="0";
                    // IsSend = REmail.sendstoreemail(EmailID, store_SaveIndentdetail[0].IndentType + " Indent", sb.ToString(), null, "", "", null, "", DateTime.Now.ToString("yyyy-MM-dd"));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO st_emailrecord(TransactionID,UserID,IsSend,Remarks,EmailID,MailedTo)VALUES(@TransactionID,@UserID,@IsSend,@Remarks,@EmailID,@MailedTo)",
                     new MySqlParameter("@TransactionID", store_SaveIndentdetail[0].IndentNo),
                     new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@IsSend", IsSend),
                     new MySqlParameter("@Remarks", "Indent Approve"),
                     new MySqlParameter("@EmailID", EmailID),
                     new MySqlParameter("@MailedTo", "Indent"));

                }
 

            }
            else if (ButtonActionType.Trim() == "Approve")
            {
                foreach (StoreSalesIndent ssi in store_SaveIndentdetail) // st_indent_detail
                {
                    var rate = ssi.Rate;
                    var discper = ssi.DiscountPer;
                    var IGST = ssi.TaxPerIGST;
                    var CGST = ssi.TaxPerCGST;
                    var SGST = ssi.TaxPerSGST;

                    var Tax = IGST == 0 ? (CGST + SGST) : IGST;

                    var discountAmout = rate * discper * 0.01;
                    var ratedisc = rate - discountAmout;
                    var tax = ratedisc * Tax * 0.01;
                    var ratetaxincludetax = ratedisc + tax;

                    var NetAmount = ratetaxincludetax * Util.GetFloat(ssi.ApprovedQty);



                    StringBuilder sb = new StringBuilder();
                    sb.Append(" UPDATE st_indent_detail SET ActionType=@ActionType,Narration=@Narration,ExpectedDate=@ExpectedDate,  ");
                    sb.Append(" ApprovedQty=@ApprovedQty,ApprovedDate=@ApprovedDate,ApprovedUserID=@ApprovedUserID,ApprovedUserName=@ApprovedUserName,NetAmount=@NetAmount,UnitPrice=@UnitPrice ");
                    sb.Append(" WHERE IndentNo=@IndentNo and ItemId=@ItemId and IsActive=@IsActive ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@ActionType", "Approval"),
                        new MySqlParameter("@IsActive", "1"),
                        new MySqlParameter("@ItemId", ssi.ItemId),
                        new MySqlParameter("@ApprovedQty", Util.GetFloat(ssi.ApprovedQty)),
                        new MySqlParameter("@ApprovedDate", Util.GetDateTime(DateTime.Now)),
                        new MySqlParameter("@ApprovedUserName", UserInfo.LoginName),
                        new MySqlParameter("@ApprovedUserID", UserInfo.ID),
                        new MySqlParameter("@ExpectedDate", Util.GetDateTime(ExistIndentData[0].ExpectedDate)),
                        new MySqlParameter("@IndentNo", store_SaveIndentdetail[0].IndentNo),
                        new MySqlParameter("@Narration", store_SaveIndentdetail[0].Narration),
                        new MySqlParameter("@NetAmount", NetAmount), 
                        new MySqlParameter("@UnitPrice", ratetaxincludetax));
                }
                if (store_SaveIndentdetail[0].IndentType == "PI")
                {
                    //Access Amount Approval Not Given
                    if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT count(*) FROM st_approvalright WHERE typeid=7 AND employeeid=" + UserInfo.ID + " AND AppRightFor='PI' and active=1")) == 0)
                    {
                        float BugetAmount = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT BudgetAmount FROM st_budget_master WHERE locationid=" + store_SaveIndentdetail[0].FromLocationID + " AND MONTH(BudgetDate)=MONTH(NOW()) AND YEAR(BudgetDate)=YEAR(NOW())"));

                        float MonthAmount = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT IFNULL(SUM(netamount),0) FROM `st_indent_detail` WHERE FromLocationID=" + store_SaveIndentdetail[0].FromLocationID + " AND IndentType='PI' AND reqqty<>rejectqty and MONTH(dtEntry)=MONTH(NOW()) AND YEAR(dtEntry)=YEAR(NOW())"));

                        if (MonthAmount > BugetAmount)
                        {
                            return "You Can Not Approve Access Amount";
                        }

                    }

                    //Send Email To Purchase Order Creater
                    Store_AllLoadData sa = new Store_AllLoadData();
                    string EmailID = sa.getApprovalRightEnail(tnx, "1", "PO");
                 
                    if (EmailID != string.Empty)
                    {

                        StringBuilder sb = new StringBuilder();
                        sb.Append("<div> Dear All , </div>");
                        sb.Append("<br/>");
                        sb.AppendFormat(" Greetings from {0}", Resources.Resource.EmailSignature);
                        sb.Append("<br/>"); sb.Append("<br/>");
                        sb.Append("Please Make Purchase Order Against Indent No <b>" + store_SaveIndentdetail[0].IndentNo + "</b>");
                        sb.Append("<br/><br/><br/><br/>");

                        sb.Append("Thanks & Regards,");
                        sb.Append("<br/>");
                        sb.AppendFormat("{0}", Resources.Resource.EmailSignature);
                        sb.Append("<br/>");

                        ReportEmailClass REmail = new ReportEmailClass();
string IsSend="0";
                        // IsSend = REmail.sendstoreemail(EmailID, store_SaveIndentdetail[0].IndentType + " Indent", sb.ToString(), null, "", "", null, "", DateTime.Now.ToString("yyyy-MM-dd"));
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO st_emailrecord(TransactionID,UserID,IsSend,Remarks,EmailID,MailedTo)VALUES(@TransactionID,@UserID,@IsSend,@Remarks,@EmailID,@MailedTo)",
                         new MySqlParameter("@TransactionID", store_SaveIndentdetail[0].IndentNo),
                         new MySqlParameter("@UserID", UserInfo.ID),
                         new MySqlParameter("@IsSend", IsSend),
                         new MySqlParameter("@Remarks", "PO Against Indent"),
                         new MySqlParameter("@EmailID", EmailID),
                         new MySqlParameter("@MailedTo", "PO Maker"));

                    }


                }

            }
            else if (ButtonActionType.Trim() == "Reject")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE st_indent_detail SET RejectQty=ReqQty,RejectReason=@RejectReason,RejectBy=@RejectBy,dtReject=@dtReject  ");
                sb.Append(" WHERE IndentNo=@IndentNo and IsActive=@IsActive");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@RejectReason", RejectionReason),
                    new MySqlParameter("@RejectBy", UserInfo.LoginName),
                    new MySqlParameter("@dtReject", DateTime.Now),
                    new MySqlParameter("@IsActive", "1"),
                    new MySqlParameter("@IndentNo", store_SaveIndentdetail[0].IndentNo));



                 // Send Email 


                DataTable EmailID = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, @"SELECT sl.`Location`,cm.`Email` FROM st_locationmaster sl INNER JOIN f_panel_master pm ON pm.`panel_id`=sl.`panel_id` and sl.LocationID='" + store_SaveIndentdetail[0].FromLocationID + "' INNER JOIN centre_master cm ON cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' THEN pm.`CentreID` ELSE pm.tagprocessinglabid END AND pm.`PanelType` IN('Centre','PUP') AND cm.isactive=1 ").Tables[0];
                if (EmailID.Rows.Count > 0)
                {
                    if (EmailID.Rows[0]["Email"].ToString() != string.Empty)
                    {

                        sb = new StringBuilder();
                        sb.Append("<div> Dear Centre Manager of <b>" + EmailID.Rows[0]["Location"].ToString() + "</b> </div>");
                        sb.Append("<br/>");
                        sb.AppendFormat(" Greetings from {0}", Resources.Resource.EmailSignature);
                        sb.Append("<br/>"); sb.Append("<br/>");
                        sb.Append(" Indent No: <b>" + store_SaveIndentdetail[0].IndentNo + "</b> is Rejected By " + UserInfo.LoginName + " at " + DateTime.Now.ToString("dd-MM-yyyy hh:mm"));
                        sb.Append("<br/><br/><br/><br/>");

                        sb.Append("Thanks & Regards,");
                        sb.Append("<br/>");
                        sb.AppendFormat("{0}", Resources.Resource.EmailSignature);
                        sb.Append("<br/>");

                        // ReportEmailClass REmail = new ReportEmailClass();
                        // string IsSend = "0";
                      // //  IsSend = REmail.sendstoreemail(EmailID.Rows[0]["Email"].ToString(), store_SaveIndentdetail[0].IndentType + " Indent Rejected", sb.ToString(), null, "", "", null, "", DateTime.Now.ToString("yyyy-MM-dd"));
                        // MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO st_emailrecord(TransactionID,UserID,IsSend,Remarks,EmailID,MailedTo)VALUES(@TransactionID,@UserID,@IsSend,@Remarks,@EmailID,@MailedTo)",
                         // new MySqlParameter("@TransactionID", store_SaveIndentdetail[0].IndentNo),
                         // new MySqlParameter("@UserID", UserInfo.ID),
                         // new MySqlParameter("@IsSend", IsSend),
                         // new MySqlParameter("@Remarks", "Indent Reject"),
                         // new MySqlParameter("@EmailID", EmailID.Rows[0]["Email"].ToString()),
                         // new MySqlParameter("@MailedTo", "Centre Manager"));

                    }
                }


            }  
            tnx.Commit();
            return "success";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);            
            return  Util.GetString(ex.Message);
        }
        finally
        {
           // SIndentData = SIndentData;
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindoldindentdata(string itemid, string locationid, string IndentType)
    {
        if (IndentType == "SI")
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" ifnull((SELECT SUM(`InitialCount` - `ReleasedCount` ) FROM st_nmstock WHERE itemid='" + itemid + "' AND  locationid=" + locationid + " AND ispost=1),0) InhandQty ");
            sb.Append(" ,ifnull(sil.BufferPercentage,0) BufferPercentage,0 AverageConsumption,ifnull(sil.WastagePercentage,0) WastagePercentage,");
            sb.Append(" ifnull((select sum((case when ApprovedQty>0 then ApprovedQty when CheckedQty >0 then CheckedQty else  reqqty end)-(rejectqty)) from st_indent_detail WHERE IndentType='" + IndentType + "' and fromlocationid=" + locationid + " AND itemid=" + itemid + " group by itemid),0)LastPendingQty");
            sb.Append("  FROM st_itemmaster si    ");

            sb.Append("  left join st_itemlocationindentmaster sil on   locationid=" + locationid + " and sil.month=MONTH(NOW()) ");
            sb.Append("  WHERE si.itemid='" + itemid + "' and si.isactive=1 AND si.approvalstatus=2   ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
        }
        else
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" ifnull((SELECT SUM(`InitialCount` - `ReleasedCount` )/Converter FROM st_nmstock WHERE itemid=" + itemid + " AND  locationid=" + locationid + " AND ispost=1),0) InhandQty ");
            sb.Append(" ,ifnull(sil.BufferPercentage,0) BufferPercentage,0 AverageConsumption,ifnull(sil.WastagePercentage,0) WastagePercentage,");
            sb.Append(" (ifnull((select SUM(ApprovedQty-poqty-`RejectQty`) from st_indent_detail WHERE IndentType='" + IndentType + "' and fromlocationid=" + locationid + " AND itemid=" + itemid + " and (ApprovedQty-poqty-`RejectQty`)>0 group by itemid),0) + ");

            sb.Append(" ifnull(( SELECT SUM(pod.`ApprovedQty` - (pod.`GRNQty`+pod.`RejectQty`+pod.rejectqtybyuser+pod.`RejectQtyByVendor`)) FROM `st_purchaseorder` po  ");
            sb.Append(" INNER JOIN  `st_purchaseorder_details` pod ON po.`PurchaseOrderID`=pod.`PurchaseOrderID` ");
            sb.Append(" WHERE po.`LocationID`=" + locationid + "  AND pod.ItemID=" + itemid + " ");
            sb.Append(" AND pod.`ApprovedQty` > (pod.`GRNQty`+pod.`RejectQty`+pod.rejectqtybyuser+pod.`RejectQtyByVendor`)),0) ) LastPendingQty ");



            sb.Append("  FROM st_itemmaster si    ");

            sb.Append("  left join st_itemlocationindentmaster sil on   locationid=" + locationid + " and sil.month=MONTH(NOW()) ");
            sb.Append("  WHERE si.itemid='" + itemid + "' and si.isactive=1 AND si.approvalstatus=2   ");
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
        }
      
    }

    public static string CheckQty(int itemid, int locationid, float qty, string indenttype)
    {

        if (indenttype == "SI")
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" ifnull((SELECT SUM(`InitialCount` - `ReleasedCount` ) FROM st_nmstock WHERE itemid=" + itemid + " AND  locationid=" + locationid + " AND ispost=1),0) InhandQty ");
            sb.Append(" ,ifnull(sil.BufferPercentage,0) BufferPercentage,ifnull(sil.AverageConsumption,0) AverageConsumption,ifnull(sil.WastagePercentage,0) WastagePercentage,");
            sb.Append(" ifnull((select sum((case when ApprovedQty>0 then ApprovedQty when CheckedQty >0 then CheckedQty else  reqqty end)-(rejectqty))  from st_indent_detail WHERE IndentType='" + indenttype + "' and fromlocationid=" + locationid + " AND itemid=" + itemid + " group by itemid),0)LastPendingQty");
            sb.Append("  FROM st_itemmaster si    ");

            sb.Append("  left join st_itemlocationindentmaster sil on sil.itemid=si.itemid AND  locationid=" + locationid + " ");
            sb.Append("  WHERE si.itemid='" + itemid + "' and si.isactive=1 AND si.approvalstatus=2   ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count == 0)
            {
                return "1";
            }

            var InhandQty = Util.GetFloat(dt.Rows[0]["InhandQty"]);
            var BufferPercentage = Util.GetFloat(dt.Rows[0]["BufferPercentage"]);
            var AverageConsumption = Util.GetFloat(dt.Rows[0]["AverageConsumption"]);
            var WastagePercentage = Util.GetFloat(dt.Rows[0]["WastagePercentage"]);
            var LastPendingQty = Util.GetFloat(dt.Rows[0]["LastPendingQty"]);
            var ReqQty = qty;


            var bufferamt = (Util.GetFloat(AverageConsumption) * Util.GetFloat(BufferPercentage)) / 100;
            var wastamt = (Util.GetFloat(AverageConsumption) * Util.GetFloat(WastagePercentage)) / 100;

            var totalplus = Util.GetFloat(AverageConsumption) + Util.GetFloat(bufferamt) + Util.GetFloat(wastamt);
            var totalminus = Util.GetFloat(InhandQty) + Util.GetFloat(LastPendingQty);

            var calculatedqty = Util.GetFloat(totalplus) - Util.GetFloat(totalminus);

            if (calculatedqty == 0)
            {
                return "1";
            }

            if (Util.GetFloat(ReqQty) > Util.GetFloat(calculatedqty))
            {
                return "Maximum Order Qty Should Be :- " + calculatedqty;

            }

            return "1";
        }
        else
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ");
            sb.Append(" ifnull((SELECT SUM(`InitialCount` - `ReleasedCount` )/Converter FROM st_nmstock WHERE itemid=" + itemid + " AND  locationid=" + locationid + " AND ispost=1),0) InhandQty ");
            sb.Append(" ,ifnull(sil.BufferPercentage,0) BufferPercentage,ifnull(sil.AverageConsumption,0) AverageConsumption,ifnull(sil.WastagePercentage,0) WastagePercentage,");
            sb.Append(" ifnull((select sum((case when ApprovedQty>0 then ApprovedQty when CheckedQty >0 then CheckedQty else  reqqty end)-(rejectqty))  from st_indent_detail WHERE IndentType='" + indenttype + "' and fromlocationid=" + locationid + " AND itemid=" + itemid + " group by itemid),0)LastPendingQty");
            sb.Append("  FROM st_itemmaster si    ");

            sb.Append("  left join st_itemlocationindentmaster sil on sil.itemid=si.itemid AND  locationid=" + locationid + " ");
            sb.Append("  WHERE si.itemid='" + itemid + "' and si.isactive=1 AND si.approvalstatus=2   ");

            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count == 0)
            {
                return "1";
            }

            var InhandQty = Util.GetFloat(dt.Rows[0]["InhandQty"]);
            var BufferPercentage = Util.GetFloat(dt.Rows[0]["BufferPercentage"]);
            var AverageConsumption = Util.GetFloat(dt.Rows[0]["AverageConsumption"]);
            var WastagePercentage = Util.GetFloat(dt.Rows[0]["WastagePercentage"]);
            var LastPendingQty = Util.GetFloat(dt.Rows[0]["LastPendingQty"]);
            var ReqQty = qty;


            var bufferamt = (Util.GetFloat(AverageConsumption) * Util.GetFloat(BufferPercentage)) / 100;
            var wastamt = (Util.GetFloat(AverageConsumption) * Util.GetFloat(WastagePercentage)) / 100;

            var totalplus = Util.GetFloat(AverageConsumption) + Util.GetFloat(bufferamt) + Util.GetFloat(wastamt);
            var totalminus = Util.GetFloat(InhandQty) + Util.GetFloat(LastPendingQty);

            var calculatedqty = Util.GetFloat(totalplus) - Util.GetFloat(totalminus);

            if (calculatedqty == 0)
            {
                return "1";
            }

            if (Util.GetFloat(ReqQty) > Util.GetFloat(calculatedqty))
            {
                return "Maximum Order Qty Should Be :- " + calculatedqty;

            }
            return "1";
        }

        

    }
    
}