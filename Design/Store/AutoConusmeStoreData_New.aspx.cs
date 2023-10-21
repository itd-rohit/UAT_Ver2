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

public partial class Design_Store_AutoConusmeStoreData_New : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindalldata();
            ddlmachine.DataSource = StockReports.GetDataTable("SELECT ID, NAME FROM macmaster ORDER BY Name");
            ddlmachine.DataValueField = "ID";
            ddlmachine.DataTextField = "Name";
            ddlmachine.DataBind();
            ddlmachine.Items.Insert(0, new ListItem("Select", "0"));
           calFromDate.StartDate = Util.GetDateTime("2019-11-18");
           calToDate.StartDate = Util.GetDateTime("2019-11-18");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT concat(locationid,'#',Panel_ID) locationid,location FROM st_locationmaster WHERE isactive=1  AND ConsumeType=1 ");
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
        }

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string locationid, string fromdate, string todate, string macid, string SearchType)
    {
        StringBuilder sb = new StringBuilder();
        DataTable dt = new DataTable();
        using (dt as IDisposable)
        {
            if (SearchType == "Machine")
                dt = StockReports.GetDataTable("call Store_AutoConsume(" + macid + ",'" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00','" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'," + locationid.Split('#')[0] + ") ");
            else if (SearchType == "Patient")
                dt = StockReports.GetDataTable("call Store_AutoConsume_Patient(" + macid + ",'" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00','" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59'," + locationid.Split('#')[0] + ") ");

            //sb.Append(" SELECT  barcodeno,st.itemid, GROUP_CONCAT(stockid)stockid,itemname,GROUP_CONCAT(st.batchnumber)batchnumber,autocon.TotalUsedQty,autocon.barcodelist,autocon.EventtypeName,autocon.id conid ");
            //sb.Append(" ,SUM((`InitialCount` - `ReleasedCount` - `PendingQty` )) InHandQty,minorUnitName minorunit,st.locationid");
            //sb.Append(" FROM st_nmstock st ");
            //sb.Append(" INNER JOIN ( ");
            ////sb.Append(" -- For Investigation with Machine");
            //sb.Append(" SELECT GROUP_CONCAT(mac.EntryID)id, im.itemid,lm.locationid,'' EventtypeName,GROUP_CONCAT(DISTINCT CONCAT(mac.`LabNo`)) barcodelist, ");
            //sb.Append(" SUM(im.storeitemqty) TotalUsedQty");
            //sb.Append(" FROM `mac_data_AutoConsumption` mac ");
            //sb.Append(" INNER JOIN investigation_master immm ON immm.investigation_id=mac.`investigation_id` AND immm.autoconsumeoption=1");
            //sb.Append(" AND mac.`dtEntry`>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'");
            //sb.Append(" AND mac.`dtEntry`<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' and mac.isautoconsume=0");
            //sb.Append(" INNER JOIN st_itemmaster_autoconsume im ON im.labitemid=mac.`investigation_id` AND im.`LabitemTypeID`=1  ");
            //sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=im.itemid AND sm.machineid=mac.`machineid`");
            //if (macid != "0")
            //    sb.Append(" and sm.MachineID='" + macid + "'");

            //sb.Append(" INNER JOIN f_itemmaster fim ON fim.type_ID=mac.`investigation_id`");
            //sb.Append(" INNER JOIN `f_panel_master` pm ON pm.`CentreID`=mac.`centreid` AND pm.`PanelType`='Centre'");
            //sb.Append(" INNER JOIN `st_locationmaster` lm ON lm.`Panel_ID`=pm.`Panel_ID`  AND lm.locationid=" + locationid.Split('#')[0] + "");
            //sb.Append(" INNER JOIN st_locationmaster_subcategoryid sls  ON sls.`SubCategoryID`=fim.SubCategoryID ");
            //sb.Append(" AND sls.`LocationID`=lm.`LocationID` AND mac.`EntryStatus`='Machine'");
            //sb.Append(" GROUP BY im.`Itemid` ,mac.`machineid`,mac.`RecordNO`");
            //sb.Append(" UNION ALL");
            ////sb.Append(" -- -- For Investigation with out Machine");
            //sb.Append(" SELECT GROUP_CONCAT(mac.EntryID)id, im.itemid,lm.locationid,'' EventtypeName,GROUP_CONCAT(DISTINCT CONCAT(mac.`LabNo`)) barcodelist, ");
            //sb.Append(" SUM(im.storeitemqty) TotalUsedQty");
            //sb.Append(" FROM `mac_data_AutoConsumption` mac ");
            //sb.Append(" INNER JOIN investigation_master immm ON immm.investigation_id=mac.`investigation_id` AND immm.autoconsumeoption=1");
            //sb.Append(" AND mac.`dtEntry`>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'");
            //sb.Append(" AND mac.`dtEntry`<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' and mac.isautoconsume=0");
            //sb.Append(" INNER JOIN st_itemmaster_autoconsume im ON im.labitemid=mac.`investigation_id` AND im.`LabitemTypeID`=1  ");
            //sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=im.itemid AND sm.machineid=1");
            //if (macid != "0")
            //    sb.Append(" and sm.MachineID='" + macid + "'");

            //sb.Append(" INNER JOIN f_itemmaster fim ON fim.type_ID=mac.`investigation_id`");
            //sb.Append(" INNER JOIN `f_panel_master` pm ON pm.`CentreID`=mac.`centreid` AND pm.`PanelType`='Centre'");
            //sb.Append(" INNER JOIN `st_locationmaster` lm ON lm.`Panel_ID`=pm.`Panel_ID`  AND lm.locationid=" + locationid.Split('#')[0] + "");
            //sb.Append(" INNER JOIN st_locationmaster_subcategoryid sls  ON sls.`SubCategoryID`=fim.SubCategoryID ");
            //sb.Append(" AND sls.`LocationID`=lm.`LocationID` AND mac.`EntryStatus`='Machine'");
            //sb.Append(" GROUP BY im.`Itemid` ,mac.`machineid`,mac.`RecordNO`");
            //sb.Append(" UNION ALL ");
            ////sb.Append(" -- For Observation with Machine");
            //sb.Append(" SELECT GROUP_CONCAT(mac.EntryID)id, im.itemid,lm.locationid,'' EventtypeName,GROUP_CONCAT(DISTINCT CONCAT(mac.`LabNo`)) barcodelist, SUM(im.storeitemqty) TotalUsedQty");
            //sb.Append(" FROM `mac_data_AutoConsumption` mac ");
            //sb.Append(" INNER JOIN investigation_master immm ON immm.investigation_id=mac.`investigation_id` AND immm.autoconsumeoption=2");
            //sb.Append(" INNER JOIN `labobservation_investigation` loi ON loi.`Investigation_Id`=mac.`Investigation_Id` AND loi.`labObservation_ID`=mac.`LabObservation_ID` AND loi.isautoconsume=1");
            //sb.Append(" AND mac.`dtEntry`>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'");
            //sb.Append(" AND mac.`dtEntry`<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' and mac.isautoconsume=0");
            //sb.Append(" INNER JOIN st_itemmaster_autoconsume im ON im.labitemid=mac.`labObservation_ID` AND im.`LabitemTypeID`=2  ");
            //sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=im.itemid AND sm.machineid=mac.`machineid`");
            //if (macid != "0")
            //    sb.Append(" and sm.MachineID='" + macid + "'");

            //sb.Append(" INNER JOIN f_itemmaster fim ON fim.type_ID=mac.`investigation_id`");
            //sb.Append(" INNER JOIN `f_panel_master` pm ON pm.`CentreID`=mac.`centreid` AND pm.`PanelType`='Centre'");
            //sb.Append(" INNER JOIN `st_locationmaster` lm ON lm.`Panel_ID`=pm.`Panel_ID`  AND lm.locationid=" + locationid.Split('#')[0] + "");
            //sb.Append(" INNER JOIN st_locationmaster_subcategoryid sls  ON sls.`SubCategoryID`=fim.SubCategoryID ");
            //sb.Append(" AND sls.`LocationID`=lm.`LocationID` AND mac.`EntryStatus`='Machine'");
            //sb.Append(" GROUP BY im.`Itemid` ,mac.`machineid`,mac.`RecordNO` ");
            //sb.Append(" UNION ALL");
            ////sb.Append(" -- For Observation with-out Machine");
            //sb.Append(" SELECT GROUP_CONCAT(mac.EntryID)id, im.itemid,lm.locationid,'' EventtypeName,GROUP_CONCAT(DISTINCT CONCAT(mac.`LabNo`)) barcodelist, SUM(im.storeitemqty) TotalUsedQty");
            //sb.Append(" FROM `mac_data_AutoConsumption` mac ");
            //sb.Append(" INNER JOIN investigation_master immm ON immm.investigation_id=mac.`investigation_id` AND immm.autoconsumeoption=2");
            //sb.Append(" INNER JOIN `labobservation_investigation` loi ON loi.`Investigation_Id`=mac.`Investigation_Id` AND loi.`labObservation_ID`=mac.`LabObservation_ID` AND loi.isautoconsume=1");
            //sb.Append(" AND mac.`dtEntry`>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'");
            //sb.Append(" AND mac.`dtEntry`<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' and mac.isautoconsume=0");
            //sb.Append(" INNER JOIN st_itemmaster_autoconsume im ON im.labitemid=mac.`labObservation_ID` AND im.`LabitemTypeID`=2  ");
            //sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=im.itemid AND sm.machineid=1");
            //if (macid != "0")
            //    sb.Append(" and sm.MachineID='" + macid + "'");

            //sb.Append(" INNER JOIN f_itemmaster fim ON fim.type_ID=mac.`investigation_id`");
            //sb.Append(" INNER JOIN `f_panel_master` pm ON pm.`CentreID`=mac.`centreid` AND pm.`PanelType`='Centre'");
            //sb.Append(" INNER JOIN `st_locationmaster` lm ON lm.`Panel_ID`=pm.`Panel_ID`  AND lm.locationid=" + locationid.Split('#')[0] + "");
            //sb.Append(" INNER JOIN st_locationmaster_subcategoryid sls  ON sls.`SubCategoryID`=fim.SubCategoryID ");
            //sb.Append(" AND sls.`LocationID`=lm.`LocationID` AND mac.`EntryStatus`='Machine'");
            //sb.Append(" GROUP BY im.`Itemid` ,mac.`machineid`,mac.`RecordNO` ");
            //sb.Append(" ) ");
            //sb.Append(" autocon ON autocon.itemid=st.itemid AND st.`LocationID`=autocon.locationid ");
            //sb.Append(" INNER JOIN st_itemmaster imm ON imm.itemid=st.itemid WHERE (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 ");
            //sb.Append(" GROUP BY st.`ItemID` order by itemname");


            //ClassLog ab = new ClassLog();
            //ab.GeneralLog(sb.ToString());
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }
    [WebMethod]
    public static string BindItemDetail(int ItemID, int locationid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  st.MinorUnitInDecimal, barcodeno,st.itemid, stockid,itemname,DATE_FORMAT(stockdate,'%d-%b-%Y') stockdate,st.batchnumber,st.IsExpirable,IF(expirydate='0001-01-01','', ");
        sb.Append(" DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate");
        sb.Append(" ,(`InitialCount` - `ReleasedCount` - `PendingQty` ) InHandQty,st.`MinorUnit` minorunit,st.locationid,panel_id ");
        sb.Append(" FROM st_nmstock st WHERE (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1");
        sb.Append(" AND st.`ItemID`=" + ItemID + " AND st.`LocationID`=" + locationid + " ORDER BY IF(st.`IsExpirable`=1,st.`ExpiryDate`,st.`PostDate`) ASC");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession=true)]
    public static string saveconsume(List<string[]> mydataadj)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string[] ss in mydataadj)
            {
                //Check If Stock is Available 
                String SearchType = ss[9].ToString();
                StringBuilder sb = new StringBuilder();

                sb.Append(" SELECT  st.MinorUnitInDecimal, barcodeno,st.itemid, stockid,itemname,DATE_FORMAT(stockdate,'%d-%b-%Y') stockdate,st.batchnumber,st.IsExpirable,IF(expirydate='0001-01-01','', ");
                sb.Append(" DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate");
                sb.Append(" ,(`InitialCount` - `ReleasedCount` - `PendingQty` ) InHandQty,st.`MinorUnit` minorunit,st.locationid,panel_id ");
                sb.Append(" FROM st_nmstock st WHERE (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1");
                sb.Append(" AND st.`ItemID`=" + ss[4] + " AND st.`LocationID`=" + ss[0] + " ORDER BY IF(st.`IsExpirable`=1,st.`ExpiryDate`,st.`PostDate`) ASC");

                using (DataTable dtStock = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString()).Tables[0])
                {

                    if (dtStock.Rows.Count > 0)
                    {
                        float ConsumedQty = Util.GetFloat(ss[3]);

                        foreach (DataRow dr in dtStock.Rows)
                        {
                            if (ConsumedQty > 0)
                            {
                                if (dr["IsExpirable"] == "1")
                                {
                                    string expirydate = Util.GetDateTime(dr["ExpiryDate"]).ToString("yyyy-MM-dd");
                                    string expirydatenow = DateTime.Now.ToString("yyyy-MM-dd");
                                    if (Util.GetDateTime(expirydate).Date < DateTime.Now.Date)
                                        return "Item Expired";
                                }
                                float InHandQty = Util.GetFloat(dr["InHandQty"]);
                                float ConsumptionQty;
                                //Check the Consume Qty
                                if (InHandQty >= ConsumedQty)
                                {
                                    ConsumptionQty = ConsumedQty;
                                    ConsumedQty = ConsumedQty - ConsumedQty;
                                }
                                else
                                {
                                    ConsumptionQty = InHandQty;
                                    ConsumedQty = ConsumedQty - InHandQty;
                                }
                                string sql = "select if(InitialCount < (ReleasedCount+PendingQty+" + Util.GetFloat(ConsumptionQty) + "),0,1)CHK from st_nmstock where stockID=" + Util.GetInt(dr["stockid"]) + "";
                                if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql)) <= 0)
                                {
                                    tnx.Rollback();
                                    return "Stock Unavailable" + dr["stockid"];
                                }

                                string strSales = "select max(salesno) from st_nmsalesdetails where TrasactionTypeID = 1";
                                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, strSales)) + 1;

                                StoreSalesDetail objnssaled = new StoreSalesDetail(tnx);
                                objnssaled.FromLocationID = Util.GetInt(ss[0]);
                                objnssaled.ToLocationID = Util.GetInt(ss[0]);
                                objnssaled.StockID = Util.GetInt(dr["stockid"]);
                                objnssaled.Quantity = ConsumptionQty;
                                objnssaled.TrasactionTypeID = 1;
                                // objnssaled.TrasactionType = "Consume";
                                objnssaled.ItemID = Util.GetInt(ss[4]);

                                objnssaled.IndentNo = "";
                                // objnssaled.TrasactionType = "Consume";
                                objnssaled.Naration = "Auto Consume";
                                objnssaled.SalesNo = SalesNo;
                                string saledid = objnssaled.Insert();
                                if (saledid == string.Empty)
                                {
                                    tnx.Rollback();
                                    return "Sales Not Saved";
                                }

                                string strUpdateStock = "update st_nmstock set ReleasedCount = ReleasedCount + " + ConsumptionQty + ",Naration='Auto Consumption' where StockID = '" + Util.GetInt(dr["stockid"]) + "'";
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock);
                                if (SearchType == "Patient")
                                {
                                    string strUpdateStockPatient = "UPDATE st_AutoConsumption_PatientWise SET IsConsume = 1 WHERE ID in  (" + ss[8] + ")";
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStockPatient);
                                }
                                else
                                {
                                    string strUpdateStock1 = "UPDATE mac_data_AutoConsumption SET isautoconsume = 1 WHERE EntryID in  (" + ss[8] + ")";
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock1);

                                }
                                if (ConsumedQty == 0)
                                    break;
                            }
                        }
                    }
                    else
                        return "No Record Found..";
                }
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
    [WebMethod]
    public static string getdetail(string ID, string EventtypeName,string StoreItemID,string autoconsumeID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("");
        if (EventtypeName == "Patient")
        {
            sb.Append(" SELECT CONCAT(cm.`CentreCode`,' ~ ',cm.`Centre`)BookingCentre,  ");
            sb.Append(" lt.Ledgertransactionno visitid,lt.patient_id, lt.pname,lt.age,lt.gender,CONCAT(im.testcode,' ~ ',im.name) InvName,  ");
            sb.Append("  'Investigation' LabConsumeType,  ");
            sb.Append(" 'Patient' `EventtypeName`, DATE_FORMAT(mac.CreatedDate,'%d-%b-%Y %h:%m %p')EntryDate   ");
            sb.Append(" FROM `st_AutoConsumption_PatientWise` mac   ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionNO=mac.LedgerTransactionNO ");
            sb.Append(" INNER JOIN investigation_master im ON im.investigation_id=mac.investigation_id ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
            sb.Append(" WHERE mac.ID IN (" + ID + ") ");
        }
        else
        {
            sb.Append(" SELECT * FROM ( ");
            sb.Append(" SELECT CONCAT(cm.`CentreCode`,' ~ ',cm.`Centre`)BookingCentre, ");
            sb.Append(" lt.Ledgertransactionno visitid,lt.patient_id, lt.pname,lt.age,lt.gender,CONCAT(im.testcode,' ~ ',im.name) InvName,'' ObservationName,  ");
            sb.Append(" 'Investigation' LabConsumeType,'Machine' `EventtypeName`, DATE_FORMAT(mac.dtEntry,'%d-%b-%Y %h:%m %p')EntryDate,mac.IsRerun ");

            sb.Append(" FROM `mac_data_AutoConsumption` mac 	 ");
	    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionNO=mac.LedgerTransactionNO ");
	    sb.Append(" iNNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`		 ");
	    sb.Append(" INNER JOIN investigation_master im ON im.investigation_id=mac.`investigation_id` 	 ");	
	    sb.Append(" INNER JOIN st_itemmaster_autoconsume sim ON sim.labitemid=mac.`investigation_id` AND im.investigation_id=sim.labitemid AND sim.`LabitemTypeID`=1  AND sim.ConsumetypeID=4	 ");
            sb.Append(" AND mac.`EntryStatus`='Machine' ");
            sb.Append(" AND sim.ItemID='"+ StoreItemID +"' ");
          //  sb.Append("  AND sim.ID='"+ autoconsumeID +"' ");
            sb.Append(" AND mac.EntryID in (" + ID + ") AND mac.isautoconsume=0 ");

            sb.Append(" UNION ALL ");
	
	
	    sb.Append("  SELECT  CONCAT(cm.`CentreCode`,' ~ ',cm.`Centre`)BookingCentre,  ");
	    sb.Append(" lt.Ledgertransactionno visitid,lt.patient_id, lt.pname,lt.age,lt.gender,'' InvName,  mac.LabObservationName ObservationName,  ");
	    sb.Append(" 'Observation' LabConsumeType,'Machine' `EventtypeName`, DATE_FORMAT(mac.dtEntry,'%d-%b-%Y %h:%m %p')EntryDate,mac.IsRerun ");	
	    sb.Append(" FROM `mac_data_AutoConsumption` mac 	 ");
	    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionNO=mac.LedgerTransactionNO");
	    sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID`");
	    sb.Append(" INNER JOIN st_itemmaster_autoconsume sim ON sim.labitemid=mac.`labObservation_ID` AND sim.`LabitemTypeID`=2  AND sim.ConsumetypeID=4");
	    sb.Append(" AND sim.ItemID='"+ StoreItemID +"'  ");	
            // sb.Append(" AND sim.ID='"+ autoconsumeID +"' ");
	    sb.Append(" AND mac.`EntryStatus`='Machine'  ");
            sb.Append(" AND mac.EntryID in (" + ID + ") AND mac.isautoconsume=0 ");



            sb.Append(" UNION ALL ");




            sb.Append("  SELECT  CONCAT(cm.`CentreCode`,' ~ ',cm.`Centre`)BookingCentre,  ");
            sb.Append(" ''  visitid,'' patient_id, 'QC' pname,'' age,'' gender,'' InvName,  mac.LabObservationName ObservationName,  ");
            sb.Append(" 'Observation' LabConsumeType,'Machine' `EventtypeName`, DATE_FORMAT(mac.dtEntry,'%d-%b-%Y %h:%m %p')EntryDate,mac.IsRerun ");
            sb.Append(" FROM `mac_data_AutoConsumption` mac 	 ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=mac.`CentreID`");
            sb.Append(" INNER JOIN st_itemmaster_autoconsume sim ON sim.labitemid=mac.`labObservation_ID` AND sim.`LabitemTypeID`=2  AND sim.ConsumetypeID=4");
            sb.Append(" AND sim.ItemID='" + StoreItemID + "'  ");
            // sb.Append(" AND sim.ID='"+ autoconsumeID +"' ");
            sb.Append(" AND mac.`EntryStatus`='Machine'  ");
            sb.Append(" AND mac.EntryID in (" + ID + ") AND mac.isautoconsume=0 and  mac.isrerun=2 ");

           sb.Append(" )t ");
           sb.Append(" ORDER BY t.visitid ");

           
        }
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }
}