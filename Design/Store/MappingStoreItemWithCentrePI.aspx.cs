using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Store_MappingStoreItemWithCentrePI : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    [WebMethod(EnableSession = true)]
    public static string bindcattype()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT distinct st_categorytypemaster.CategoryTypeID,st_categorytypemaster.CategoryTypeName FROM st_categorytypemaster inner join st_itemmaster st on st.CategoryTypeID=st_categorytypemaster.CategoryTypeID where active=1 ORDER BY CategoryTypeName"));

    }
    [WebMethod(EnableSession = true)]
    public static string bindSubcattype(string CategoryTypeID = "0")
    {
        if (CategoryTypeID == "OnLoad")
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT distinct st_Subcategorytypemaster.SubCategoryTypeID,st_Subcategorytypemaster.SubCategoryTypeName FROM st_Subcategorytypemaster inner join st_itemmaster st on st.SubCategoryTypeID=st_Subcategorytypemaster.SubCategoryTypeID where active=1 ORDER BY SubCategoryTypeName "));
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT distinct st_Subcategorytypemaster.SubCategoryTypeID,st_Subcategorytypemaster.SubCategoryTypeName FROM st_Subcategorytypemaster inner join st_itemmaster st on st.SubCategoryTypeID=st_Subcategorytypemaster.SubCategoryTypeID where active=1 and st_Subcategorytypemaster.CategoryTypeMasterID in(" + CategoryTypeID + ") ORDER BY SubCategoryTypeName "));

    }
    [WebMethod]
    public static string BindSubCategory(string SubCategoryTypeMasterId = "0")
    {
        if (SubCategoryTypeMasterId == "OnLoad")
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT distinct st_subcategorymaster.SubCategoryID,st_subcategorymaster.Name FROM `st_subcategorymaster` inner join st_itemmaster st on st.ItemGroupId=st_subcategorymaster.ItemTypeid WHERE `Active`=1  ORDER BY `Name`"));
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT distinct st_subcategorymaster.SubCategoryID,st_subcategorymaster.Name FROM `st_subcategorymaster` inner join st_itemmaster st on st.ItemGroupId=st_subcategorymaster.ItemTypeid WHERE `Active`=1 and st_subcategorymaster.SubCategoryID in(" + SubCategoryTypeMasterId + ") ORDER BY `Name`"));
    }

    [WebMethod(EnableSession = true)]
    public static string binditem(string CategoryTypeId, string SubCategoryTypeId, string CategoryId)
    {
        StringBuilder sb = new StringBuilder();
        if (CategoryTypeId != "")
            sb.Append(" SELECT ItemId,typename ItemName FROM st_itemmaster WHERE CategoryTypeID IN(" + CategoryTypeId + ") ");
        if (SubCategoryTypeId != "")
            sb.Append(" AND SubCategoryTypeID IN(" + SubCategoryTypeId + ") ");
        if (CategoryId != "")
            sb.Append(" AND SubCategoryID IN(" + CategoryId + ") ");
        sb.Append(" order by typename ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }

    [WebMethod(EnableSession = true)]
    public static string bindcentertype()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select ID,Type1 from centre_type1master Where IsActive=1 order by Type1 "));
    }

    [WebMethod(EnableSession = true)]
    public static string bindState(string BusinessZoneID)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ID,State FROM state_master WHERE BusinessZoneID IN(" + BusinessZoneID + ") AND IsActive=1 ORDER BY State"));

    }


    [WebMethod(EnableSession = true)]
    public static string bindlocation(string centreid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT LocationID,Location FROM st_locationmaster cm  ");
        if (centreid != "")
        {
            sb.Append("inner join f_panel_master pm on pm.panel_id=cm.panel_id and pm.centreid in (" + centreid + ")");
        }

        sb.Append(" WHERE cm.IsActive=1 ORDER BY cm.Location");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId, string ZoneId, string StateID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CentreID,Centre FROM centre_master cm  WHERE cm.IsActive=1");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append(" AND cm.StateID IN(" + StateID + ")");

        sb.Append(" AND cm.Type1Id IN(" + TypeId + ")");
        sb.Append(" ORDER BY cm.Centre");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }

    [WebMethod(EnableSession = true)]
    public static string SaveData(string[] Items, string[] Centres)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {

            StringBuilder Command = new StringBuilder();
            Command.Append("INSERT INTO st_mappingitemmasterpicentre (LocationId,CreatedDate,ItemId,CreatedBy,IsActive,PIorSiType) VALUES ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "delete from st_mappingitemmasterpicentre where LocationId in (" + string.Join(",", Centres) + ") and ItemId in(" + string.Join(",", Items) + ")");

            for (int i = 0; i < Centres.Length; i++)
            {
                for (int j = 0; j < Items.Length; j++)
                {

                    Command.Append(" (");
                    Command.Append("'" + Centres[i] + "',");
                    Command.Append("'" + Util.GetDateTime(DateTime.Now).ToString("yyyy-MM-dd") + "',");
                    Command.Append("'" + Items[j] + "',");
                    Command.Append("'" + UserInfo.ID + "',");
                    Command.Append(" '1','PI'");
                    Command.Append(" ),");

                }
            }
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Command.ToString().Trim().TrimEnd(','));
            Tranx.Commit();
            return "1";

        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string DeleteRows(string Id)
    {
        StockReports.ExecuteScalar("delete from  st_mappingitemmasterpicentre where Id in(" + Id + ")");
        return "1";

    }

    [WebMethod(EnableSession = true)]
   public static string SearchData(string Items, string location)
    {

        Items = Items.Replace("\"", "").Replace("[", "").Replace("]", "");
        location = location.Replace("\"", "").Replace("[", "").Replace("]", "");


        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT id mapid, ");
        sb.Append(" (SELECT centre FROM centre_master WHERE centreid=pm.centreid) Centre,");
        sb.Append(" st.LocationId LocationID,sl.`Location`,");
        sb.Append(" st.itemid,im.typename ItemName  FROM st_mappingitemmasterpicentre st ");
        sb.Append(" INNER JOIN st_itemmaster im ON im.`ItemID`=st.`ItemId` ");
        if (Items != "")
        {
            sb.Append(" and st.itemid in (" + Items + ")");
        }
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.`LocationID`=st.`LocationId` ");

        if (location != "")
        {
            sb.Append(" and sl.`LocationID` in (" + location + ")");
        }
        sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=sl.`panel_id` ");
        sb.Append(" ORDER BY location,itemname ");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }

    [WebMethod(EnableSession = true)]
    public static string ExportToExcel(string Items, string location)
    {
       Items = Items.Replace("\"", "").Replace("[", "").Replace("]", "");
        location = location.Replace("\"", "").Replace("[", "").Replace("]", "");


        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT id mapid, ");
        sb.Append(" (SELECT centre FROM centre_master WHERE centreid=pm.centreid) Centre,");
        sb.Append(" st.LocationId LocationID,sl.`Location`,");
        sb.Append(" st.itemid,im.typename ItemName  FROM st_mappingitemmasterpicentre st ");
        sb.Append(" INNER JOIN st_itemmaster im ON im.`ItemID`=st.`ItemId` ");
        if (Items != "")
        {
            sb.Append(" and st.itemid in (" + Items + ")");
        }
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.`LocationID`=st.`LocationId` ");

        if (location != "")
        {
            sb.Append(" and sl.`LocationID` in (" + location + ")");
        }
        sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=sl.`panel_id` ");
        sb.Append(" ORDER BY location,itemname ");

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
                HttpContext.Current.Session["ReportName"] = "MappedCentrewithItemForPI";
                return "1";
            }
            return "0";

       

    }


}