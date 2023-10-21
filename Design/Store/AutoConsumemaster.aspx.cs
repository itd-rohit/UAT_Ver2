using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Linq;
using System.Web.Services;

[System.Runtime.InteropServices.GuidAttribute("F0CC349D-50A0-48BC-A947-E213BF5BB32A")]
public partial class Design_Store_AutoConsumemaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    [WebMethod(EnableSession = true)]
    public static string bindalldata(string type)
    {
        if (type == "1")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT investigation_id id,concat(NAME,' #Investigation') `name` FROM investigation_master "));
        }
        else if (type == "2")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT lom.`LabObservation_ID` id,concat(NAME,' #Observation') `name` FROM labobservation_investigation loi INNER JOIN labobservation_master lom ON loi.labObservation_ID=lom.labObservation_ID
 "));
        }

        else if (type == "3")
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT investigation_id id,concat(NAME,' #Investigation') `name` FROM investigation_master  union all SELECT lom.`LabObservation_ID` id,concat(NAME,' #Observation') `name` FROM labobservation_investigation loi INNER JOIN labobservation_master lom ON loi.labObservation_ID=lom.labObservation_ID
 "));
        }
        else
        {
            return "";
        }
    }


    [WebMethod(EnableSession = true)]
    public static string binditem(string CategoryTypeId, string SubCategoryTypeId, string CategoryId, string machineid, string manufacture)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT ItemId,typename ItemName FROM st_itemmaster WHERE isactive=1");

        if (CategoryTypeId != "")
            sb.Append(" and CategoryTypeID IN(" + CategoryTypeId + ")  ");

        if (SubCategoryTypeId != "")
            sb.Append(" AND SubCategoryTypeID IN(" + SubCategoryTypeId + ") ");

        if (CategoryId != "")
            sb.Append(" AND SubCategoryID IN(" + CategoryId + ") ");

        if (machineid != "")
            sb.Append(" AND machineid IN(" + machineid + ") ");

        if (manufacture != "")
            sb.Append(" AND manufactureid IN(" + manufacture + ") ");

        sb.Append("  and approvalstatus=2 order by typename ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }
    [WebMethod(EnableSession = true)]
    public static string Addme(string Items)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ifnull(sia.id,0) mapid, cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name ItemType, ");
        sb.Append(" sm.itemid,typename,machineid,machinename,manufactureid,manufacturename,packsize,MinorUnitId,MinorUnitName,MinorUnitInDecimal ");
        sb.Append(" ,ifnull(sia.ConsumetypeID,0)ConsumetypeID,ifnull(sia.EventtypeID,0)EventtypeID,ifnull(sia.StoreItemQty,'')StoreItemQty,ifnull(sia.labdata,'') labdata ");
        sb.Append(" FROM `st_itemmaster` sm INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID ");
        sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID ");
        sb.Append(" left join (select itemid, id,ConsumetypeID,EventtypeID,StoreItemQty,GROUP_CONCAT(CONCAT(labitemtypename,'#',labitemid,'#',labitemname) SEPARATOR '^') labdata ");
        sb.Append(" from st_itemmaster_autoconsume where itemid in (" + Items + ") group by itemid) sia on sia.Itemid=sm.itemid ");
        sb.Append(" where sm.itemid in (" + Items + ")");
        sb.Append(" ORDER BY mapid desc, CategoryTypeName ,SubCategoryTypeName ,ItemType ,typename   ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

 
    }
    [WebMethod(EnableSession = true)]
    public static string SaveData(List<AutoConsumeData> data)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            var DistinctItems = data.GroupBy(x => x.Itemid).Select(y => y.First());

            foreach (var item in DistinctItems)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from st_itemmaster_autoconsume where itemid=@itemid",
                    new MySqlParameter("@Itemid", item.Itemid));
               
            }
            foreach (AutoConsumeData newdata in data)
            {

                
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO st_itemmaster_autoconsume(Itemid,ItemName,LabitemTypeID,LabitemTypeName,LabItemId,LabItemName,ConsumetypeID,");
                sb.Append(" ConsumetypeName,EventtypeID,EventtypeName,StoreItemQty,InvMaxQty,EntryBy,EntryByName,EntryDate)");
                sb.Append(" VALUES (@Itemid,@ItemName,@LabitemTypeID,@LabitemTypeName,@LabItemId,@LabItemName,@ConsumetypeID,");
                sb.Append(" @ConsumetypeName,@EventtypeID,@EventtypeName,@StoreItemQty,@InvMaxQty,@EntryBy,@EntryByName,now()) ");



                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                   new MySqlParameter("@Itemid", newdata.Itemid),
                                   new MySqlParameter("@ItemName", newdata.ItemName),
                                   new MySqlParameter("@LabitemTypeID", newdata.LabitemTypeID),
                                   new MySqlParameter("@LabitemTypeName", newdata.LabitemTypeName),
                                   new MySqlParameter("@LabItemId", newdata.LabItemId),
                                   new MySqlParameter("@LabItemName", newdata.LabItemName),
                                   new MySqlParameter("@ConsumetypeID", newdata.ConsumetypeID),
                                   new MySqlParameter("@ConsumetypeName", newdata.ConsumetypeName),
                                   new MySqlParameter("@EventtypeID", newdata.EventtypeID),
                                   new MySqlParameter("@EventtypeName", newdata.EventtypeName),
                                   new MySqlParameter("@StoreItemQty", newdata.StoreItemQty),
                                   new MySqlParameter("@InvMaxQty", newdata.StoreItemQty),
                                   new MySqlParameter("@EntryBy", Util.GetString(UserInfo.ID)),
                                   new MySqlParameter("@EntryByName", Util.GetString(UserInfo.LoginName))

                                   );
            }


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
    
    
}

public class AutoConsumeData
{
    public string Itemid { get; set; }
    public string ItemName { get; set; }

    public string ConsumetypeID { get; set; }
    public string ConsumetypeName { get; set; }
    public string EventtypeID { get; set; }
    public string EventtypeName { get; set; }
    public string StoreItemQty { get; set; }
    public string InvMaxQty { get; set; }

    public string LabitemTypeID { get; set; }
    public string LabitemTypeName { get; set; }
    public string LabItemId { get; set; }
    public string LabItemName { get; set; }


}