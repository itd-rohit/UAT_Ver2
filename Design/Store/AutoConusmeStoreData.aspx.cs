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

public partial class Design_Store_AutoConusmeStoreData : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Redirect("AutoConusmeStoreData_New.aspx");
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            bindalldata();
           ddlmachine.DataSource= StockReports.GetDataTable("SELECT ID, NAME FROM macmaster ORDER BY Name");
           ddlmachine.DataValueField = "ID";
           ddlmachine.DataTextField = "NAME";
           ddlmachine.DataBind();
           ddlmachine.Items.Insert(0, new ListItem("Select","0"));
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    void bindalldata()
    {
        if (UserInfo.AccessStoreLocation != "")
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT concat(locationid,'#',Panel_ID) locationid,location FROM st_locationmaster WHERE isactive=1 and ConsumeType=1  ");
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
    public static string SearchData(string locationid, string fromdate, string todate, string macid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  st.MinorUnitInDecimal, barcodeno,st.itemid, stockid,itemname,DATE_FORMAT(stockdate,'%d-%b-%Y') stockdate,st.batchnumber,st.IsExpirable,IF(expirydate='0001-01-01','', DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate,autocon.TotalUsedQty,autocon.barcodelist,autocon.EventtypeName,autocon.id conid ");
        sb.Append(" ,(`InitialCount` - `ReleasedCount` - `PendingQty` ) InHandQty,MinorUnitName minorunit,locationid,panel_id ");
        sb.Append(" FROM st_nmstock st  ");
        sb.Append(" inner join ( ");

        sb.Append(" SELECT GROUP_CONCAT(sp.id) id, im.itemid,sp.`EventtypeName`,GROUP_CONCAT(DISTINCT CONCAT('<span title=ClickToViewDetail onclick=viewbarcodedetail(this) style=\"cursor:pointer; color:blue;\">' ,sp.barcodeno,'</span>')) barcodelist, ");
        sb.Append(" SUM(im.storeitemqty) TotalUsedQty");
        sb.Append(" FROM `st_patienttransaction` sp ");
        sb.Append(" INNER JOIN st_itemmaster_autoconsume im ON (im.labitemid=sp.investigationid OR im.labitemid=sp.LabObservation_ID) AND sp.eventtypeid=im.eventtypeid  and sp.isautoconsume=0");
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.panel_id=sp.panelid AND sl.ConsumeType=1 ");
        sb.Append(" and sl.locationid='" + locationid.Split('#')[0] + "' ");
        sb.Append("  WHERE sp.entrydate>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00'  ");
        sb.Append(" AND sp.entrydate<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' ");
        sb.Append(" GROUP BY sl.locationid,im.`Itemid` ) autocon on autocon.itemid=st.itemid ");

        sb.Append(" inner join st_itemmaster imm on imm.itemid=st.itemid ");
        if (macid != "0")
        {
            sb.Append(" and imm.MachineID='"+macid+"'");
        }
        sb.Append(" WHERE locationid=" + locationid.Split('#')[0] + " AND (`InitialCount` - `ReleasedCount` - `PendingQty` )>0 AND ispost=1");


        sb.Append(" ORDER BY itemname,expirydate ");

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
                        return "Please Consume <br/>" + redata;
                    }
                }

                //Check If Stock is Available 
                string sql = "select if(InitialCount < (ReleasedCount+PendingQty+" + Util.GetFloat(ss[3]) + "),0,1)CHK from st_nmstock where stockID='" + ss[2] + "'";
                if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sql)) <= 0)
                {
                    tnx.Rollback();

                    return "Stock Unavailable";
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
                objnssaled.TrasactionType = "Consume";
                objnssaled.Naration = "Auto Consume";
                objnssaled.SalesNo = SalesNo;
                string saledid = objnssaled.Insert();
                if (saledid == string.Empty)
                {
                    tnx.Rollback();
                    return "Sales Not Saved";
                }

                string strUpdateStock = "update st_nmstock set ReleasedCount = ReleasedCount + " + Util.GetFloat(ss[3]) + " where StockID = '" + ss[2] + "'";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock);

                string strUpdateStock1 = "update st_patienttransaction set isautoconsume = 1 where id in  (" + ss[8] + ")";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, strUpdateStock1);
                
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
    public static string getdetail(string ID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append("");

        sb.Append(" SELECT CONCAT(cm.`CentreCode`,' ~ ',cm.`Centre`)BookingCentre, ");
        sb.Append(" lt.Ledgertransactionno visitid,lt.patient_id, lt.pname,lt.age,lt.gender,CONCAT(im.testcode,' ~ ',im.name) InvName, ");
        sb.Append(" IF(im.autoconsumeoption=1,'Investigation','Observation')LabConsumeType, ");
        sb.Append(" sp.`EventtypeName`, date_format(sp.EntryDate,'%d-%b-%Y %h:%m %p')EntryDate  ");
        sb.Append(" FROM `st_patienttransaction` sp  ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgertransactionID=sp.LedgertransactionID ");
        sb.Append(" INNER JOIN investigation_master im ON im.investigation_id=sp.InvestigationID AND im.autoconsumeoption>0 ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sb.Append(" WHERE sp.id in ("+ID+") ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }
}