using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Store_MappingStoreItemWithCentre : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    [WebMethod(EnableSession = true)]
    public static string bindcattype()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT  st_categorytypemaster.CategoryTypeID,st_categorytypemaster.CategoryTypeName FROM st_categorytypemaster  where active=1 ORDER BY CategoryTypeName"));
      
    }
    [WebMethod(EnableSession = true)]
    public static string bindSubcattype(string CategoryTypeID = "0")
    {
        if (CategoryTypeID == "OnLoad")
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT  st_Subcategorytypemaster.SubCategoryTypeID,st_Subcategorytypemaster.SubCategoryTypeName FROM st_Subcategorytypemaster  where active=1 ORDER BY SubCategoryTypeName "));
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT  st_Subcategorytypemaster.SubCategoryTypeID,st_Subcategorytypemaster.SubCategoryTypeName FROM st_Subcategorytypemaster  where active=1 and st_Subcategorytypemaster.CategoryTypeID in(" + CategoryTypeID + ") ORDER BY SubCategoryTypeName "));

    }
    [WebMethod]
    public static string BindSubCategory(string SubCategoryTypeMasterId = "0")
    {
        if (SubCategoryTypeMasterId == "OnLoad")
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT  st_subcategorymaster.SubCategoryID,st_subcategorymaster.Name FROM `st_subcategorymaster`  WHERE `Active`=1  ORDER BY `Name`"));
        else
            return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT  st_subcategorymaster.SubCategoryID, NAME Name FROM `st_subcategorymaster` WHERE st_subcategorymaster.`Active`=1 and st_subcategorymaster.SubCategoryTypeID in(" + SubCategoryTypeMasterId + ") ORDER BY `Name`"));
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
        sb.Append("  and isactive=1 and approvalstatus=2 order by typename ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

    }

 

  

    [WebMethod(EnableSession = true)]
    public static string bindlocation(string centreid, string StateID, string TypeId, string ZoneId, string cityId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT LocationID,Location FROM st_locationmaster lm  ");
       
        sb.Append(" INNER JOIN f_panel_master pm on pm.`panel_id`=lm.`panel_id`  ");
        sb.Append(" inner join centre_master cm on cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType` in('Centre','PUP') and cm.isactive=1 ");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append("  AND cm.StateID IN(" + StateID + ")");

        if (cityId != "")
             sb.Append(" AND cm.cityid IN(" + cityId + ")");

        if (TypeId != "")
             sb.Append("  AND cm.Type1Id IN(" + TypeId + ")");

        if(centreid!="")
            sb.Append("  AND  pm.`panel_id` IN(" + centreid + ")");

        sb.Append(" WHERE lm.IsActive=1 ORDER BY lm.Location");
	//	System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\locb.txt",sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
	
	
	[WebMethod(EnableSession = true)]
    public static string bindindentlocation(string centreid, string StateID, string TypeId, string ZoneId, string cityId)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT LocationID,Location FROM st_locationmaster   ");
       
        
	//	System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\locb.txt",sb.ToString());
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
            Command.Append("INSERT INTO st_mappingitemmaster (LocationId,CreatedDate,ItemId,CreatedBy,IsActive) VALUES ");
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "delete from st_mappingitemmaster where LocationId in (" + string.Join(",", Centres) + ") and ItemId in(" + string.Join(",", Items) + ")");

            for (int i = 0; i < Centres.Length; i++)
            {
                for (int j = 0; j < Items.Length; j++)
                {

                    Command.Append(" (");
                    Command.Append("'" + Centres[i] + "',");
                    Command.Append("now(),");
                    Command.Append("'" + Items[j] + "',");
                    Command.Append("'" + UserInfo.ID + "',");
                    Command.Append(" '1'");
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
        StockReports.ExecuteDML("delete from  st_mappingitemmaster where Id in(" + Id + ")");
        return "1";

    }

    [WebMethod(EnableSession = true)]
    public static string PIItemMapping(string Id,string locationid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            //MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update st_mappingitemmaster set IsPIItem=0 where LocationId ='" + locationid + "'");

            foreach (string s in Id.Split(','))
            {

                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "update st_mappingitemmaster set  IsPIItem=" + s.Split('#')[1] + "  where Id='" + s.Split('#')[0] + "' ");
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
    public static string SearchData(string Items, string location)
    {


        Items = Items.Replace("\"", "").Replace("[", "").Replace("]", "");
        location = location.Replace("\"", "").Replace("[", "").Replace("]", "");

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT id mapid,IsPIItem,ifnull(PIItemType,'Both')PIItemType, ");
        sb.Append(" (SELECT centre FROM centre_master WHERE centreid=pm.centreid) Centre,");
        sb.Append(" st.LocationId LocationID,sl.`Location`,");
        sb.Append(" st.itemid,im.typename ItemName,minlevel MinLevel,st.`RecorderLevel` ReorderLevel  FROM st_mappingitemmaster st ");
        sb.Append(" INNER JOIN st_itemmaster im ON im.`ItemID`=st.`ItemId` ");
        if (Items != "")
        {
            sb.Append(" and st.itemid in ("+Items+")");
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
        sb.Append(" sl.`Location`,");
        sb.Append(" im.itemid,im.typename ItemName,im.ManufactureName,im.MachineName,im.PackSize,im.CatalogNo,im.HsnCode,minlevel MinLevel,st.`RecorderLevel` ReorderLevel  FROM st_mappingitemmaster st ");
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
            HttpContext.Current.Session["ReportName"] = "MappedLocationwithItem";
            return "1";
        }
        return "0";


    }


    [WebMethod]
    public static string UpdateLevels(string Id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string ss in Id.Split(','))
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



    [WebMethod]
    public static string UpdateLevelsonlyminorder(string Id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string ss in Id.Split(','))
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

}