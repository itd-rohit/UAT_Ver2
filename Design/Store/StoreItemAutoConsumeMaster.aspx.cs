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

public partial class Design_Store_StoreItemAutoConsumeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlstoreitem.DataSource = StockReports.GetDataTable("select itemid,typename from st_itemmaster where isactive=1 order by typename ");
            ddlstoreitem.DataValueField = "itemid";
            ddlstoreitem.DataTextField = "typename";
            ddlstoreitem.DataBind();
            ddlstoreitem.Items.Insert(0, new ListItem("Select", "0"));

            ddleventtype.DataSource = StockReports.GetDataTable("SELECT id,event FROM `st_bom_eventmaster` order by id ");
            ddleventtype.DataValueField = "id";
            ddleventtype.DataTextField = "event";
            ddleventtype.DataBind();
            ddleventtype.Items.Insert(0, new ListItem("Select", "0"));


            ddlconsumetype.DataSource = StockReports.GetDataTable("SELECT id,consumetype FROM `st_bom_consumetype` order by id ");
            ddlconsumetype.DataValueField = "id";
            ddlconsumetype.DataTextField = "consumetype";
            ddlconsumetype.DataBind();
            ddlconsumetype.Items.Insert(0, new ListItem("Select", "0"));

        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string bindalldata(string type)
    {
        if (type == "1")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT investigation_id id,NAME `name` FROM investigation_master WHERE autoconsumeoption=1"));
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT lom.`LabObservation_ID` id,NAME `name` FROM labobservation_investigation loi INNER JOIN labobservation_master lom ON loi.labObservation_ID=lom.labObservation_ID
 WHERE isautoconsume=1"));
        }
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savealldata(string storeitemid,string storeitemname,string labitemtype,string labitemtypename,string labitemid,string labitemname,string consumetype,string consumetypename,string eventtype,string eventtypename,string storeitemqty,string storeinvmaxqty)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO st_itemmaster_autoconsume(Itemid,ItemName,LabitemTypeID,LabitemTypeName,LabItemId,LabItemName,ConsumetypeID,");
            sb.Append(" ConsumetypeName,EventtypeID,EventtypeName,StoreItemQty,InvMaxQty,EntryBy,EntryByName,EntryDate)");
            sb.Append(" VALUES (@Itemid,@ItemName,@LabitemTypeID,@LabitemTypeName,@LabItemId,@LabItemName,@ConsumetypeID,");
            sb.Append(" @ConsumetypeName,@EventtypeID,@EventtypeName,@StoreItemQty,@InvMaxQty,@EntryBy,@EntryByName,now()) ");



            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@Itemid", storeitemid),
                               new MySqlParameter("@ItemName", storeitemname),
                               new MySqlParameter("@LabitemTypeID", labitemtype),
                               new MySqlParameter("@LabitemTypeName", labitemtypename),
                               new MySqlParameter("@LabItemId", labitemid),
                               new MySqlParameter("@LabItemName", labitemname),
                               new MySqlParameter("@ConsumetypeID", consumetype),
                               new MySqlParameter("@ConsumetypeName", consumetypename),
                               new MySqlParameter("@EventtypeID", eventtype),
                               new MySqlParameter("@EventtypeName", eventtypename),
                               new MySqlParameter("@StoreItemQty", storeitemqty),
                               new MySqlParameter("@InvMaxQty", storeinvmaxqty),
                               new MySqlParameter("@EntryBy", Util.GetString(UserInfo.ID)),
                               new MySqlParameter("@EntryByName", Util.GetString(UserInfo.LoginName))
                               
                               );


            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return  Util.GetString(ex.GetBaseException());
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

       
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string updatealldata(string storeitemid, string storeitemname, string labitemtype, string labitemtypename, string labitemid, string labitemname, string consumetype, string consumetypename, string eventtype, string eventtypename, string storeitemqty, string storeinvmaxqty, string id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" update  st_itemmaster_autoconsume set Itemid=@Itemid,ItemName=@ItemName,LabitemTypeID=@LabitemTypeID,LabitemTypeName=@LabitemTypeName,");
            sb.Append(" LabItemId=@LabItemId,LabItemName=@LabItemName,ConsumetypeID=@ConsumetypeID,");
            sb.Append(" ConsumetypeName=@ConsumetypeName,EventtypeID=@EventtypeID,EventtypeName=@EventtypeName,StoreItemQty=@StoreItemQty,");
            sb.Append(" InvMaxQty=@InvMaxQty,UpdateBy=@UpdateBy,UpdateByName=@UpdateByName,UpdateDate=now() where id=@id");
           



            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@Itemid", storeitemid),
                               new MySqlParameter("@ItemName", storeitemname),
                               new MySqlParameter("@LabitemTypeID", labitemtype),
                               new MySqlParameter("@LabitemTypeName", labitemtypename),
                               new MySqlParameter("@LabItemId", labitemid),
                               new MySqlParameter("@LabItemName", labitemname),
                               new MySqlParameter("@ConsumetypeID", consumetype),
                               new MySqlParameter("@ConsumetypeName", consumetypename),
                               new MySqlParameter("@EventtypeID", eventtype),
                               new MySqlParameter("@EventtypeName", eventtypename),
                               new MySqlParameter("@StoreItemQty", storeitemqty),
                               new MySqlParameter("@InvMaxQty", storeinvmaxqty),
                               new MySqlParameter("@UpdateBy", Util.GetString(UserInfo.ID)),
                               new MySqlParameter("@UpdateByName", Util.GetString(UserInfo.LoginName)),
                               new MySqlParameter("@id", id)

                               );


            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string storeitemid )
    {
        if (storeitemid == "0")
        {

            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT id,Itemid,ItemName,LabitemTypeID,LabitemTypeName,LabItemId,LabItemName,ConsumetypeID,
ConsumetypeName,EventtypeID,EventtypeName,StoreItemQty,InvMaxQty,EntryBy,EntryByName,DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate
FROM st_itemmaster_autoconsume order by id"));
        }
        else
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT id,Itemid,ItemName,LabitemTypeID,LabitemTypeName,LabItemId,LabItemName,ConsumetypeID,
ConsumetypeName,EventtypeID,EventtypeName,StoreItemQty,InvMaxQty,EntryBy,EntryByName,DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate
FROM st_itemmaster_autoconsume where itemid='" + storeitemid + "' order by id"));
        }
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string DeleteData(string id)
    {
        StockReports.ExecuteDML("delete from st_itemmaster_autoconsume where id='" + id + "'");
        return "1";
    }

    
}