using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Store_SetItemsLevel : System.Web.UI.Page
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
            sb.Append(" AND ItemGroupId IN(" + CategoryId + ") ");
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
    public static string SearchDataNew(string AllItems = "", string AllCenter = "")
    {
        AllCenter = AllCenter.Replace("\"", "").Replace("[", "").Replace("]", "");
        AllItems = AllItems.Replace("\"", "").Replace("[", "").Replace("]", "");
        StringBuilder sb = new StringBuilder();
        sb.Append(" select im.ApolloItemCode ApolloItemCode, mapt.Id, mapt.CreatedDate,mm.Centre,im.TypeName ItemName,sm.Name Category,mm.Zone,mm.State,mm.type1,mapt.MinLevel,mapt.RecorderLevel ReorderLevel FROM st_mappingitemmaster mapt");
        sb.Append(" inner join `centre_master` mm ON mm.`CentreID`=mapt.`CentreId` ");
        sb.Append(" inner join `st_itemmaster` im ON im.itemId=mapt.`ItemId` ");
        sb.Append(" inner join `st_subcategorymaster` sm ON sm.`SubCategoryID`=im.`itemgroupid` where 1=1 ");
        try
        {
            if (AllItems != "")
            {
              
                sb.Append(" and mapt.ItemId in (" + AllItems + ")");
            }
           
            if (AllCenter != "")
            {
               
                sb.Append(" and mapt.CentreId in(" + AllCenter + ")");
            }

            sb.Append(" and mapt.IsActive='1' order by Category,itemname,Centre");

            DataTable dt1 = StockReports.GetDataTable(sb.ToString());
           
             return Newtonsoft.Json.JsonConvert.SerializeObject(dt1);

        }

        catch (Exception ex)
        {
            return "";
        }
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateLevels(string Id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string ss in  Id.Split(','))
            {

                string str = "Update st_mappingitemmaster SET MinLevel = '" + ss.Split('#')[1] + "',RecorderLevel = '" + ss.Split('#')[2] + "' WHERE id='" + ss.Split('#')[0] + "'";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString());
            }
            Tranx.Commit();
            con.Close();
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
    public static string ExportToExcel(string AllItems = "", string AllCenter = "")
    {
        AllCenter = AllCenter.Replace("\"", "").Replace("[", "").Replace("]", "");
        AllItems = AllItems.Replace("\"", "").Replace("[", "").Replace("]", "");
        StringBuilder sb = new StringBuilder();
        sb.Append(" select mapt.Id,ifnull(im.ApolloItemCode,'') ApolloItemCode,im.TypeName ItemName,sm.Name Category,mm.type1 CentreType,mm.Centre,mapt.MinLevel,mapt.RecorderLevel ReorderLevel FROM st_mappingitemmaster mapt");
        sb.Append(" inner join `centre_master` mm ON mm.`CentreID`=mapt.`CentreId` ");
        sb.Append(" inner join `st_itemmaster` im ON im.itemId=mapt.`ItemId` ");
        sb.Append(" inner join `st_subcategorymaster` sm ON sm.`SubCategoryID`=im.`itemgroupid` where 1=1 ");
        try
        {
            if (AllItems != "")
            {
              
                sb.Append(" and mapt.ItemId in (" + AllItems + ")");
            }
          
            if (AllCenter != "")
            {
            
                sb.Append(" and mapt.CentreId in(" + AllCenter + ")");
            }
           
            sb.Append(" and mapt.IsActive='1' order by Category,itemname,Centre");
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {

                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "ItemMin-MaxLevel";
                return "true";
            }
            return "false";

        }

        catch (Exception ex)
        {
            return "";
        }

    }
}