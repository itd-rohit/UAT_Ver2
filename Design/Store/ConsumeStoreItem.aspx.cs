using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;


public partial class Design_Store_ConsumeStoreItem : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindalldata();
        }
    }

    void bindalldata()
    {               
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT concat(locationid,'#',Panel_ID) locationid,location FROM st_locationmaster WHERE isactive=1   ");
            //sb.Append(" AND locationid IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");


            sb.Append(" ORDER BY location ");
			//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\uncon.txt",sb.ToString());
            ddllocation.DataSource = StockReports.GetDataTable(sb.ToString());
            ddllocation.DataTextField = "location";
            ddllocation.DataValueField = "locationid";
            ddllocation.DataBind();
            if (ddllocation.Items.Count > 1)
            {
                ddllocation.Items.Insert(0, new ListItem("Select Location", "0"));
            }
        

    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string locationid, string barcodeno,string itemid)
    {
        StringBuilder sb = new StringBuilder();


        sb.Append(" SELECT MinorUnitInDecimal, barcodeno,itemid, stockid,itemname,DATE_FORMAT(stockdate,'%d-%b-%Y') stockdate,batchnumber,IsExpirable,IF(expirydate='0001-01-01','', DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate ");
        sb.Append(" ,(`InitialCount` - `ReleasedCount` - `PendingQty` ) InHandQty,minorunit,locationid,panel_id ");
        sb.Append(" FROM st_nmstock WHERE locationid=" + locationid.Split('#')[0] + " AND (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 ");
        if (barcodeno != "")
        {
            sb.Append(" and BarcodeNo='" + barcodeno + "'");
        }
        if (itemid != "")
        {
            sb.Append(" and itemid='"+itemid+"'");
        }
        sb.Append(" ORDER BY stockdate ");

		//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\cstore.txt",sb.ToString());



        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveconsume(List<string[]> mydataadj)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string[] ss in mydataadj)
            {

                if (ss[6] == "1")
                {
                    string expirydate=Util.GetDateTime(ss[7]).ToString("yyyy-MM-dd");
                    string expirydatenow = DateTime.Now.ToString("yyyy-MM-dd");
                    if (Util.GetDateTime(ss[7]).Date < DateTime.Now.Date)
                    {
                        return "Item Expired";
                    }

                    DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select barcodeno, itemname,batchnumber,IF(expirydate='0001-01-01','', DATE_FORMAT(expirydate,'%d-%b-%Y'))  expirydate  from st_nmstock where expirydate<>'0001-01-01' and stockid <>'" + ss[2] + "' and expirydate<'" + expirydate + "' and expirydate>='" + expirydatenow + "' and locationid='" + Util.GetInt(ss[0]) + "' and itemid='" + Util.GetInt(ss[4]) + "' and  (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 order by expirydate asc").Tables[0];

                    if (dt.Rows.Count > 0)
                    {
                        string redata = "ItemName: " + dt.Rows[0]["itemname"].ToString() + " <br/>BatchNumber: " + dt.Rows[0]["batchnumber"].ToString() + " <br/>ExpiryDate: " + dt.Rows[0]["expirydate"].ToString() + "<br/>BarcodeNo: " + dt.Rows[0]["barcodeno"].ToString();
                        return "1";
						//return "Please Consume <br/>" + redata;
                    }
                }

               


                
                int SalesNo = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select store_getsalesno(1)"));
                StoreSalesDetail objnssaled = new StoreSalesDetail(tnx);
                objnssaled.FromLocationID = Util.GetInt(ss[0]);
                objnssaled.ToLocationID = Util.GetInt(ss[0]);
                objnssaled.StockID = Util.GetInt(ss[2]);
                objnssaled.Quantity = Util.GetFloat(ss[3]);
                objnssaled.TrasactionTypeID = 1;
                objnssaled.TrasactionType = "Consume";
                objnssaled.ItemID = Util.GetInt(ss[4]);

                objnssaled.IndentNo = "";
                objnssaled.Naration = Util.GetString(ss[5]);
                objnssaled.SalesNo = SalesNo;
                string saledid = objnssaled.Insert();
                if (saledid == string.Empty)
                {
                    tnx.Rollback();
                    return "Sales Not Saved";
                }

                //Check If Stock is Available 
                string sql = "select if(InitialCount < (ReleasedCount+PendingQty+" + Util.GetFloat(ss[3]) + "),0,1)CHK from st_nmstock where stockID='" + ss[2] + "'";
                if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql)) <= 0)
                {
                    tnx.Rollback();

                    return "Stock Unavailable";
                }

                string strUpdateStock = "update st_nmstock set ReleasedCount = ReleasedCount + " + Util.GetFloat(ss[3]) + " where StockID = '" + ss[2] + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock);
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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchItem(string itemname, string locationidfrom)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT si.`ItemIDGroup`,sig.`ItemNameGroup` ");
        sb.Append(" FROM st_itemmaster si     ");
        sb.Append(" INNER JOIN `st_itemmaster_group` sig ON sig.`ItemIDGroup`=si.`ItemIDGroup` ");
        sb.Append(" INNER JOIN st_nmstock smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` IN (" + locationidfrom.Split('#')[0] + ")  ");
        sb.Append(" AND typename LIKE '" + itemname + "%'  ");
        sb.Append(" WHERE (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 and  si.approvalstatus=2 GROUP BY sig.`ItemIDGroup` ORDER BY sig.`ItemNameGroup` LIMIT 20   ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindManufacturer(string locationidfrom, string ItemIDGroup)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT si.`ManufactureID`,si.`ManufactureName`   ");
        sb.Append("  FROM st_itemmaster si      ");
        sb.Append(" INNER JOIN st_nmstock smm ON smm.`ItemId`=si.`ItemID`   ");
        sb.Append("  AND smm.`LocationId` = " + locationidfrom.Split('#')[0] + "   ");

        sb.Append(" AND si.`ItemIDGroup`  = '" + ItemIDGroup + "' ");
        sb.Append(" WHERE (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 and si.approvalstatus=2  ");
        sb.Append(" GROUP BY si.`ManufactureID` ");
        sb.Append(" ORDER BY si.`ManufactureName` ; ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindMachine(string locationidfrom, string ItemIDGroup, string ManufactureID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("    SELECT si.`MachineID`,si.`MachineName`     ");
        sb.Append(" FROM st_itemmaster si       ");
        sb.Append(" INNER JOIN st_nmstock smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` = " + locationidfrom.Split('#')[0] + "    ");

        sb.Append(" AND si.`ItemIDGroup`  = '" + ItemIDGroup + "' AND smm.`ManufactureID`='" + ManufactureID + "'  ");
        sb.Append(" WHERE (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 and si.approvalstatus=2  ");
        sb.Append("  GROUP BY si.`MachineID`  ");
        sb.Append("  ORDER BY si.`MachineName` ;  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindPackSize(string locationidfrom, string ItemIDGroup, string ManufactureID, string MachineID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT si.`PackSize`, concat(si.`IssueMultiplier`,'#',si.`MinorUnitName`,'#',si.`ItemID`)PackValue  ");
        sb.Append(" FROM st_itemmaster si       ");
        sb.Append("  INNER JOIN st_nmstock smm ON smm.`ItemId`=si.`ItemID`    ");
        sb.Append(" AND smm.`LocationId` = " + locationidfrom.Split('#')[0] + "    ");

        sb.Append(" AND si.`ItemIDGroup`  = '" + ItemIDGroup + "' AND smm.`ManufactureID`='" + ManufactureID + "' AND si.`MachineID`='" + MachineID + "'  ");
        sb.Append(" WHERE (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1 and si.approvalstatus=2  ");
        sb.Append(" GROUP BY si.`PackSize`  ");
        sb.Append(" ORDER BY si.`PackSize` ;  ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    
}