using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;
/// <summary>
/// Summary description for Store_ReportQuery
/// </summary>
public class Store_ReportQuery
{

    public static DataTable StockStatusReport(string ItemID, string ManufactureID, string MacID, string LocationID, string IsAutoIncrement = "0")
    {
        ItemID = Common.DecryptRijndael(ItemID);
//System.IO.File.WriteAllText(@"D:\Shat\aa.txt",Util.GetString( ItemID));
        ManufactureID = Common.DecryptRijndael(ManufactureID);
        MacID = Common.DecryptRijndael(MacID);
        LocationID = Common.DecryptRijndael(LocationID);
        string SessionLocationID = Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT st.stockid, st.barcodeno,(SELECT location FROM st_locationmaster WHERE locationid=st.LocationID)StoreLocation, ");
            sb.Append(" cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemTypeName,(SELECT itemnamegroup FROM st_itemmaster_group  ");
            sb.Append("    WHERE itemidgroup=im.itemidgroup ) `ItemName`, ");
            sb.Append("(select name from  st_manufacture_master mmmm where mmmm.MAnufactureID=st.ManufactureID)Manufacture,");
            sb.Append("(select name from  macmaster mmmm where mmmm.id=st.macid)Machine,im.packsize,st.barcodeno,");
            sb.Append(" st.`BatchNumber`,IF(st.`ExpiryDate`='0001-01-01','',DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate, ");
            sb.Append(" ROUND(st.`Rate`,2) Rate ,ROUND(st.`UnitPrice`,2) UnitPrice , ");
            sb.Append(" ROUND(st.`DiscountAmount`,2) DiscountAmount,ROUND(st.`TaxAmount`,2)TaxAmount, ");
            sb.Append(" ROUND(st.`InitialCount`,2)InitialQty, ROUND(st.`ReleasedCount`,2)ReleasedQty, ROUND(st.`PendingQty`,2) InTransitQty, ");
            sb.Append(" ROUND((st.`InitialCount`-st.`ReleasedCount`-st.`PendingQty`),2) StockInHandQty, ");
            sb.Append(" ROUND((st.UnitPrice*(st.InitialCount-st.ReleasedCount-st.`PendingQty`)),2) StockAmount, ");
            sb.Append(" ROUND((st.UnitPrice*(ROUND(st.`PendingQty`,2))),2) InTransitAmount, ");
            sb.Append("  st.`MajorUnit` PurchaseUnit,st.`MinorUnit` ConsumeUnit,");
            sb.Append(" DATE_FORMAT(StockDate,'%d-%b-%Y') StockDate ");
            sb.Append(" FROM st_nmstock st  ");
            sb.Append(" INNER JOIN st_itemmaster im ON im.`ItemID`=st.`ItemID` ");
            if (ItemID.Trim() != string.Empty)
            {
                sb.Append(" AND st.itemid IN ({0})");
            }
            sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=im.CategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=im.SubCategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=im.SubCategoryID ");
            sb.Append(" WHERE  (st.`InitialCount`-st.`ReleasedCount`)>0 AND ispost=1 ");
            sb.Append(" AND st.locationID in ({1}) ");
            if (LocationID.Trim() != string.Empty)
            {
                sb.Append(" AND st.LocationID in ({2})");
            }
            if (ManufactureID.Trim() != "0")
            {
                sb.Append(" and st.ManufactureID=@ManufactureID");
            }
            if (MacID.Trim() != "0")
            {
                sb.Append(" and st.MacID =@MacID");
            }
            sb.Append(" ORDER BY StoreLocation,CategoryTypeName,SubCategoryTypeName,itemTypeName,ItemName,Manufacture,Machine,packsize  ");

          //  System.IO.File.WriteAllText(@"D:\Shat\aa.txt",Util.GetString(sb.ToString()));

            List<string> strItemID = new List<string>();
            strItemID = ItemID.Split(',').ToList<string>();

            List<string> strSessionLocationID = new List<string>();
            strSessionLocationID = SessionLocationID.Split(',').ToList<string>();

            List<string> strLocationID = new List<string>();
            strLocationID = LocationID.Split(',').ToList<string>();

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), string.Join(",", strItemID),
                string.Join(",", strSessionLocationID), string.Join(",", strLocationID)), con))
            {
                for (int i = 0; i < strItemID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), strItemID[i]);
                }
                for (int i = 0; i < strSessionLocationID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@b", i), strSessionLocationID[i]);
                }
                for (int i = 0; i < strLocationID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@c", i), strLocationID[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@ManufactureID", ManufactureID);
                da.SelectCommand.Parameters.AddWithValue("@MacID", MacID);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                   da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        if (IsAutoIncrement == "1")
                        {
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


                        }
                    }
                    strItemID.Clear();
                    strLocationID.Clear();
                    return dt;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable StockUnConsumeReport(string ItemID, string MachineID, string LocationID, string Type, string CategoryTypeID, string SubCategoryTypeID, string SubCategoryID, string FromDate, string ToDate, string IsAutoIncrement)
    {
        ItemID = Common.DecryptRijndael(ItemID);
       
        MachineID = Common.DecryptRijndael(MachineID);
        LocationID = Common.DecryptRijndael(LocationID);
        Type = Common.DecryptRijndael(Type);
        CategoryTypeID = Common.DecryptRijndael(CategoryTypeID);
        SubCategoryTypeID = Common.DecryptRijndael(SubCategoryTypeID);
        SubCategoryID = Common.DecryptRijndael(SubCategoryID);
        FromDate = Common.DecryptRijndael(FromDate);
        ToDate = Common.DecryptRijndael(ToDate);
     
        IsAutoIncrement = Common.DecryptRijndael(IsAutoIncrement);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Type.Trim() == "0")
            {
                sb.Append(" SELECT salesno TransactionNo,Location ConsumeLocation,stm.State,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
                sb.Append(" stn.itemid,stn.itemname,stn.barcodeno,sm.MachineName, snd.Quantity ConsumeQuantity ,stn.unitprice*snd.Quantity ConsumeAmt, stn.minorunit ConsumeUnit, ");
                sb.Append(" DATE_FORMAT(DATETIME,'%d-%b-%Y') ConsumeDate,snd.Naration Remarks,(SELECT NAME FROM employee_master WHERE employee_id=snd.UserID) UserName,DATE_FORMAT(stn.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,stn.BatchNumber ");
                sb.Append("  FROM `st_nmsalesdetails` snd ");
                sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");
                sb.Append(" and slm.locationID IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
                if (LocationID.Trim() != string.Empty)
                {
                    sb.Append(" AND slm.locationid IN (" + LocationID + ")");
                }
                sb.Append(" INNER JOIN state_master stm ON stm.`id`=slm.`StateID` ");
                sb.Append(" INNER JOIN st_nmstock stn ON stn.stockid=snd.stockid ");
                sb.Append(" AND (`InitialCount` - `ReleasedCount` - `PendingQty`) > 0 ");
                sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
                if (ItemID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.itemid IN (" + ItemID + ")");
                }
                if (MachineID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.MachineID IN (" + MachineID + ")");
                }
                sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
                if (CategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND cat.CategoryTypeID IN (" + CategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
                if (SubCategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND subcat.SubCategoryTypeID IN (" + SubCategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
                if (SubCategoryID.Trim() != string.Empty)
                {
                    sb.Append(" AND itemcat.SubCategoryID IN (" + SubCategoryID + ")");
                }
                //sb.Append(" WHERE TrasactionTypeID=1  ");
                sb.Append(" AND snd.DATETIME>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
				System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\consume0.txt",sb.ToString());          
            }

            else if (Type.Trim() == "1")
            {
                sb = new StringBuilder();
                sb.Append(" SELECT salesno TransactionNo,Location ConsumeLocation,stm.State,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
                sb.Append(" stn.itemid,stn.itemname,stn.barcodeno,sm.MachineName, sum(snd.Quantity) ConsumeQuantity ,sum(stn.unitprice*snd.Quantity) ConsumeAmt,stn.minorunit ConsumeUnit,DATE_FORMAT(stn.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,stn.BatchNumber ");
                sb.Append("  FROM `st_nmsalesdetails` snd ");
                sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");
                sb.Append(" and slm.locationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
                if (LocationID.Trim() != string.Empty)
                {
                    sb.Append(" AND slm.locationid IN (" + LocationID + ")");
                }
                sb.Append(" INNER JOIN state_master stm ON stm.`id`=slm.`StateID` ");
                sb.Append(" INNER JOIN st_nmstock stn ON stn.stockid=snd.stockid ");
                sb.Append(" AND (`InitialCount` - `ReleasedCount` - `PendingQty`) > 0 ");
                sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
                if (ItemID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.itemid IN (" + ItemID + ")");
                }
                if (MachineID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.MachineID IN (" + MachineID + ")");
                }
                sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
                if (CategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND cat.CategoryTypeID IN (" + CategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
                if (SubCategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND subcat.SubCategoryTypeID IN (" + SubCategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
                if (SubCategoryID.Trim() != string.Empty)
                {
                    sb.Append(" AND itemcat.SubCategoryID IN (" + SubCategoryID + ")");
                }
                //sb.Append(" WHERE TrasactionTypeID=1  ");
                sb.Append(" AND snd.DATETIME>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
                sb.Append(" GROUP BY snd.fromlocationid,sm.itemid ");
				System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\consume1.txt",sb.ToString());          
            }
            else
            {
                sb = new StringBuilder();
                sb.Append(" SELECT salesno TransactionNo,Location ConsumeLocation,stm.State,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
                sb.Append(" stn.itemid,stn.itemname,stn.barcodeno,sm.MachineName,sum(snd.Quantity) ConsumeQuantity,SUM(stn.Unitprice*snd.Quantity) ConsumeAmount ,stn.minorunit ConsumeUnit,DATE_FORMAT(stn.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,stn.BatchNumber ");

                sb.Append("  FROM `st_nmsalesdetails` snd ");
                sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");
                sb.Append(" and slm.locationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
                if (LocationID.Trim() != string.Empty)
                {
                    sb.Append(" and slm.locationid IN (" + LocationID + ")");
                }
                sb.Append(" INNER JOIN state_master stm ON stm.`id`=slm.`StateID` ");
                sb.Append(" INNER JOIN st_nmstock stn ON stn.stockid=snd.stockid ");
                sb.Append(" AND (`InitialCount` - `ReleasedCount` - `PendingQty`) > 0 ");
                sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
                if (ItemID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.itemid IN (" + ItemID + ")");
                }
                if (MachineID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.MachineID IN (" + MachineID + ")");
                }
                sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
                if (CategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND cat.CategoryTypeID IN (" + CategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
                if (SubCategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND subcat.SubCategoryTypeID IN (" + SubCategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
                if (SubCategoryID.Trim() != string.Empty)
                {
                    sb.Append(" AND itemcat.SubCategoryID IN (" + SubCategoryID + ")");
                }
                //sb.Append(" WHERE TrasactionTypeID=1  ");
                sb.Append(" AND snd.DATETIME>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
                sb.Append(" GROUP BY snd.fromlocationid,sm.itemid ");
				System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\consume2.txt",Util.GetString(sb.ToString()));          
            } 
			System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\consume.txt",Util.GetString(sb.ToString()));          
            using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
            {
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (IsAutoIncrement == "1")
                    {
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
                    }
                    return dt;
                }          
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    public static DataTable StockConsumeReport(string ItemID, string MachineID, string LocationID, string Type, string CategoryTypeID, string SubCategoryTypeID, string SubCategoryID, string FromDate, string ToDate, string IsAutoIncrement)
    {
        ItemID = Common.DecryptRijndael(ItemID);

        MachineID = Common.DecryptRijndael(MachineID);
        LocationID = Common.DecryptRijndael(LocationID);
        Type = Common.DecryptRijndael(Type);
        CategoryTypeID = Common.DecryptRijndael(CategoryTypeID);
        SubCategoryTypeID = Common.DecryptRijndael(SubCategoryTypeID);
        SubCategoryID = Common.DecryptRijndael(SubCategoryID);
        FromDate = Common.DecryptRijndael(FromDate);
        ToDate = Common.DecryptRijndael(ToDate);

        IsAutoIncrement = Common.DecryptRijndael(IsAutoIncrement);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Type.Trim() == "0")
            {
                sb.Append(" SELECT salesno TransactionNo,Location ConsumeLocation,stm.State,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
                sb.Append(" stn.itemid,stn.itemname,stn.barcodeno,sm.MachineName, snd.Quantity ConsumeQuantity ,stn.unitprice*snd.Quantity ConsumeAmt, stn.minorunit ConsumeUnit, ");
                sb.Append(" DATE_FORMAT(DATETIME,'%d-%b-%Y') ConsumeDate,snd.Naration Remarks,(SELECT NAME FROM employee_master WHERE employee_id=snd.UserID) UserName,DATE_FORMAT(stn.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,stn.BatchNumber ");
                sb.Append("  FROM `st_nmsalesdetails` snd ");
                sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");
                sb.Append(" and slm.locationID IN ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
                if (LocationID.Trim() != string.Empty)
                {
                    sb.Append(" AND slm.locationid IN (" + LocationID + ")");
                }
                sb.Append(" INNER JOIN state_master stm ON stm.`id`=slm.`StateID` ");
                sb.Append(" INNER JOIN st_nmstock stn ON stn.stockid=snd.stockid ");
                sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
                if (ItemID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.itemid IN (" + ItemID + ")");
                }
                if (MachineID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.MachineID IN (" + MachineID + ")");
                }
                sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
                if (CategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND cat.CategoryTypeID IN (" + CategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
                if (SubCategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND subcat.SubCategoryTypeID IN (" + SubCategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
                if (SubCategoryID.Trim() != string.Empty)
                {
                    sb.Append(" AND itemcat.SubCategoryID IN (" + SubCategoryID + ")");
                }
                //sb.Append(" WHERE TrasactionTypeID=1  ");
                sb.Append(" AND snd.DATETIME>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
                System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\consume0.txt", sb.ToString());
            }

            else if (Type.Trim() == "1")
            {
                sb = new StringBuilder();
                sb.Append(" SELECT salesno TransactionNo,Location ConsumeLocation,stm.State,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
                sb.Append(" stn.itemid,stn.itemname,stn.barcodeno,sm.MachineName, sum(snd.Quantity) ConsumeQuantity ,sum(stn.unitprice*snd.Quantity) ConsumeAmt,stn.minorunit ConsumeUnit,DATE_FORMAT(stn.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,stn.BatchNumber ");
                sb.Append("  FROM `st_nmsalesdetails` snd ");
                sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");
                sb.Append(" and slm.locationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
                if (LocationID.Trim() != string.Empty)
                {
                    sb.Append(" AND slm.locationid IN (" + LocationID + ")");
                }
                sb.Append(" INNER JOIN state_master stm ON stm.`id`=slm.`StateID` ");
                sb.Append(" INNER JOIN st_nmstock stn ON stn.stockid=snd.stockid ");
                sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
                if (ItemID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.itemid IN (" + ItemID + ")");
                }
                if (MachineID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.MachineID IN (" + MachineID + ")");
                }
                sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
                if (CategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND cat.CategoryTypeID IN (" + CategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
                if (SubCategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND subcat.SubCategoryTypeID IN (" + SubCategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
                if (SubCategoryID.Trim() != string.Empty)
                {
                    sb.Append(" AND itemcat.SubCategoryID IN (" + SubCategoryID + ")");
                }
                //sb.Append(" WHERE TrasactionTypeID=1  ");
                sb.Append(" AND snd.DATETIME>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
                sb.Append(" GROUP BY snd.fromlocationid,sm.itemid ");
                System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\consume1.txt", sb.ToString());
            }
            else
            {
                sb = new StringBuilder();
                sb.Append(" SELECT salesno TransactionNo,Location ConsumeLocation,stm.State,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
                sb.Append(" stn.itemid,stn.itemname,stn.barcodeno,sm.MachineName,sum(snd.Quantity) ConsumeQuantity,SUM(stn.Unitprice*snd.Quantity) ConsumeAmount ,stn.minorunit ConsumeUnit,DATE_FORMAT(stn.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,stn.BatchNumber ");

                sb.Append("  FROM `st_nmsalesdetails` snd ");
                sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");
                sb.Append(" and slm.locationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
                if (LocationID.Trim() != string.Empty)
                {
                    sb.Append(" and slm.locationid IN (" + LocationID + ")");
                }
                sb.Append(" INNER JOIN state_master stm ON stm.`id`=slm.`StateID` ");
                sb.Append(" INNER JOIN st_nmstock stn ON stn.stockid=snd.stockid ");
                sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
                if (ItemID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.itemid IN (" + ItemID + ")");
                }
                if (MachineID.Trim() != string.Empty)
                {
                    sb.Append(" AND sm.MachineID IN (" + MachineID + ")");
                }
                sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
                if (CategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND cat.CategoryTypeID IN (" + CategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
                if (SubCategoryTypeID.Trim() != string.Empty)
                {
                    sb.Append(" AND subcat.SubCategoryTypeID IN (" + SubCategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
                if (SubCategoryID.Trim() != string.Empty)
                {
                    sb.Append(" AND itemcat.SubCategoryID IN (" + SubCategoryID + ")");
                }
                //sb.Append(" WHERE TrasactionTypeID=1  ");
                sb.Append(" AND snd.DATETIME>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
                sb.Append(" GROUP BY snd.fromlocationid,sm.itemid ");
                System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\consume2.txt", Util.GetString(sb.ToString()));
            }
            System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\consume.txt", Util.GetString(sb.ToString()));
            using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
            {
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (IsAutoIncrement == "1")
                    {
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
                    }
                    return dt;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    public static DataTable StockIssueReport(string Type, string FromDate, string ToDate, string CategoryTypeID, string SubCategoryTypeID, string SubCategoryID, string ItemID, string LocationID, string MachineID, string DateOption, string IssueType, string IndentNo, string IsAutoIncrement)
    {
        ItemID = Common.DecryptRijndael(ItemID);
        MachineID = Common.DecryptRijndael(MachineID);
        LocationID = Common.DecryptRijndael(LocationID);
        Type = Common.DecryptRijndael(Type);
        CategoryTypeID = Common.DecryptRijndael(CategoryTypeID);
        SubCategoryTypeID = Common.DecryptRijndael(SubCategoryTypeID);
        SubCategoryID = Common.DecryptRijndael(SubCategoryID);
        FromDate = Common.DecryptRijndael(FromDate);
        ToDate = Common.DecryptRijndael(ToDate);
        DateOption = Common.DecryptRijndael(DateOption);
        IssueType = Common.DecryptRijndael(IssueType);
        IndentNo = Common.DecryptRijndael(IndentNo);
        string SessionLocationID = Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','");
        IsAutoIncrement = Common.DecryptRijndael(IsAutoIncrement);

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (DateOption.Trim() == "1")
            {
                sb.Append(" SELECT salesno TransactionNo,snd.IndentNo,slm.Location FromLocation,sm12.state FromLocationState,slm1.location ToLocation ,sm121.state ToLocationState,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
                sb.Append(" sm.typename itemname,sm.HsnCode,stn.barcodeno,sm.MachineName,sm.ManufactureName,sm.packsize");
                sb.Append(" ,DATE_FORMAT(stn.`ExpiryDate`,'%d-%b-%Y')ExpiryDate,stn.BatchNumber,");
                sb.Append(" (SELECT group_concat(DISTINCT issueinvoiceno) FROM st_indentissuedetail WHERE stockid=snd.stockid and indentno=snd.indentno)Issueinvoiceno,");
                sb.Append(" snd.Quantity ReceiveQuantity , (stn.rate*snd.Quantity)Rate,ROUND((stn.DiscountAmount*snd.Quantity),2) DiscountAmt,stn.taxper, (stn.unitprice*snd.Quantity) ReceiveAmt,stn.minorunit ReceiveUnit,");
                sb.Append("  (stn.taxamount*snd.Quantity) TaxAmount,");
                sb.Append("  if(sm12.state=sm121.state,0,(stn.taxamount*snd.Quantity)) TaxAmtIGST,");
                sb.Append("  if(sm12.state<>sm121.state,0,(stn.taxamount*snd.Quantity)/2) TaxAmtCGST,");
                sb.Append("  if(sm12.state<>sm121.state,0,(stn.taxamount*snd.Quantity)/2)  TaxAmtSGST,");
                sb.Append(" snd.IssueType,");
                sb.Append(" DATE_FORMAT(DATETIME,'%b-%Y') ReceiveMonth, ");
                sb.Append(" DATE_FORMAT(DATETIME,'%d-%b-%Y') ReceiveDate,snd.Naration Remarks,(SELECT NAME FROM employee_master WHERE employee_id=snd.UserID) UserName ");
                sb.Append("  FROM `st_nmsalesdetails` snd ");
                sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");
                //sb.Append(" and slm.locationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
                if (LocationID.Trim() != "")
                {
                    sb.Append(" and slm.locationid in (" + LocationID + ")");
                }
                sb.Append(" INNER JOIN st_locationmaster slm1 ON slm1.locationid=snd.tolocationid ");
                sb.Append("  inner join state_master sm12 on   sm12.id=slm.StateID ");
                sb.Append("  inner join state_master sm121 on   sm121.id=slm1.StateID ");
                sb.Append(" INNER JOIN st_nmstock stn ON stn.stockid=snd.stockid ");
                sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
                if (ItemID.Trim() != "")
                {
                    sb.Append(" and sm.itemid in (" + ItemID + ")");
                }
                if (MachineID.Trim() != "")
                {
                    sb.Append(" and sm.MachineID in (" + MachineID + ")");
                }
                sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
                if (CategoryTypeID.Trim() != "")
                {
                    sb.Append(" and cat.CategoryTypeID in (" + CategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
                if (SubCategoryTypeID.Trim() != "")
                {
                    sb.Append(" and subcat.SubCategoryTypeID in (" + SubCategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
                if (SubCategoryTypeID.Trim() != "")
                {
                    sb.Append(" and itemcat.SubCategoryTypeID in (" + SubCategoryTypeID + ")");

                }
                sb.Append(" WHERE TrasactionTypeID=2  ");
                if (IssueType.Trim() != "0")
                {
                    sb.Append(" and snd.IssueType='" + IssueType + "' ");
                }
                if (IndentNo.Trim() == "")
                {
                    sb.Append(" AND snd.DATETIME>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
                }
                else
                {
                    sb.Append(" and snd.indentno='" + IndentNo.Trim() + "' ");
                }

            }
            else
            {
                sb.Append(" SELECT sid.id, sid.indentno,sid.issueinvoiceno, ");
                sb.Append(" sm12.state FromState, ");
                sb.Append(" sl1.location FromLocation ,");
                sb.Append(" sm121.state toState, ");
                sb.Append(" sl2.location ToLocation,");
                sb.Append(" cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName,TypeName ItemName,im.hsncode,");
                sb.Append(" barcodeno,");
                sb.Append(" (SELECT DATE_FORMAT(`ExpiryDate`,'%d-%b-%Y') FROM st_nmstock WHERE stockid=sid.stockid)ExpiryDate,");
                sb.Append(" (SELECT BatchNumber FROM st_nmstock WHERE stockid=sid.stockid)BatchNumber,");
                sb.Append(" sendqty IssueQty,sendqty*(SELECT unitprice FROM st_nmstock WHERE stockid=sid.stockid) IssueAmount,");
                sb.Append(" (sid.receiveqty)ReceiveQty, ");
                sb.Append(" (sid.receiveqty)*(SELECT unitprice FROM st_nmstock WHERE stockid=sid.stockid) ReceiveAmount,");
                sb.Append(" (sid.consumeqty)ConsumeqtyFromPending, ");
                sb.Append(" (sid.consumeqty)*(SELECT unitprice FROM st_nmstock WHERE stockid=sid.stockid) ConsumeAmountFromPending,");
                sb.Append(" (sid.stockinqty)StockInQty, ");
                sb.Append(" (sid.stockinqty)*(SELECT unitprice FROM st_nmstock WHERE stockid=sid.stockid) StockInAmount,");
                sb.Append(" (sendqty-(sid.receiveqty+consumeqty+stockinqty)) InTransitQty,");
                sb.Append(" (sendqty-(sid.receiveqty+consumeqty+stockinqty))*(SELECT unitprice FROM st_nmstock WHERE stockid=sid.stockid) InTransitAmount,");
                sb.Append(" DATE_FORMAT(sid.datetime,'%b-%Y') IssueMonth, ");
                sb.Append(" DATE_FORMAT(sid.datetime,'%d-%m-%Y') IssueDateTime, pendingremarks,");
                sb.Append(" DATE_FORMAT(sid.dispatchdate,'%d-%m-%Y') DispatchDate,dispatchbyusername DispatchBy,");
                sb.Append(" DATE_FORMAT(sid.ReceiveDate,'%d-%m-%Y') BatchReceiveDate,ReceiveByUserName BatchReceiveBy ");
                sb.Append(" FROM st_indentissuedetail sid ");
                sb.Append(" INNER JOIN (SELECT indentno,tolocationid,fromlocationid FROM st_indent_detail sttd  GROUP BY indentno ) sttd ON sttd.indentno=sid.indentno ");
                sb.Append(" INNER JOIN st_locationmaster sl1 ON sl1.locationid=sttd.tolocationid ");
                //sb.Append(" and sl1.locationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
                if (LocationID.Trim() != "")
                {
                    sb.Append(" and sl1.locationid in (" + LocationID + ")");
                }
                sb.Append(" INNER JOIN st_locationmaster sl2 ON sl2.locationid=sttd.fromlocationid ");
                sb.Append("  inner join state_master sm12 on   sm12.id=sl1.StateID ");
                sb.Append("  inner join state_master sm121 on   sm121.id=sl2.StateID ");
                sb.Append(" INNER JOIN st_itemmaster im ON sid.itemid=im.itemid ");
                if (ItemID.Trim() != "")
                {
                    sb.Append(" and im.itemid in (" + ItemID + ")");
                }
                if (MachineID.Trim() != "")
                {
                    sb.Append(" and im.MachineID in (" + MachineID + ")");
                }
                sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=im.CategoryTypeID  ");
                if (CategoryTypeID.Trim() != "")
                {
                    sb.Append(" and cat.CategoryTypeID in (" + CategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=im.SubCategoryTypeID  ");
                if (SubCategoryTypeID.Trim() != "")
                {
                    sb.Append(" and subcat.SubCategoryTypeID in (" + SubCategoryTypeID + ")");
                }
                sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=im.SubCategoryID   ");
                if (SubCategoryID.Trim() != "")
                {
                    sb.Append(" and itemcat.SubCategoryTypeID in (" + SubCategoryID + ")");
                }
                if (IndentNo.Trim() == "")
                {
                    sb.Append(" where sid.datetime>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND sid.datetime<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
                }
                else
                {
                    sb.Append(" where sid.indentno='" + IndentNo.Trim() + "' ");
                }
                sb.Append(" ORDER BY id ");
            }
			System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\issue.txt",sb.ToString());
            using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
            {
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                  if (dt.Rows.Count > 0)
                    {
                    if (IsAutoIncrement == "1")
                    {
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
                    }
                  }

                    return dt;
                }
            }
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
public static DataTable PurchaseOrderReport(string fromdate, string todate, string type, string type1)
    {
        DataTable dt = new DataTable();
        string FromDate = Common.DecryptRijndael(fromdate);
        string ToDate = Common.DecryptRijndael(todate);
        string Type = Common.DecryptRijndael(type);
        string Type1 = Common.DecryptRijndael(type1);
        try
        {
            if (Type1 == "1")
            {
                StringBuilder sb = new StringBuilder();

                sb.Append("   SELECT (SELECT location FROM st_locationmaster WHERE locationid=pom.locationid)DeliveryLocation,  ");
                sb.Append("   DATE_FORMAT(pom.CreatedDate,'%d-%b-%Y')PODate,IFNULL(CreatedByName,'') POCreatedBY, ");
                sb.Append("   pom.PurchaseOrderNo,VendorName,  ");
                sb.Append("  IFNULL(IndentNo,'')PIIndentNo,  ");

                sb.Append("  sum( Rate*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty))) GrossTotal, ");
                sb.Append("  sum( DiscountAmount*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty))) TotalDiscount, ");
                sb.Append("  sum( pod.TaxAmount*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty))) Totaltax,");
                sb.Append("  sum( UnitPrice*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) ) NetTotal  ");
                sb.Append("   ,IF(IsDirectPO=0,'PO From PI','Direct PO') POType , ");
                sb.Append("   DATE_FORMAT(pom.CheckedDate,'%d-%b-%Y')CheckedDate, CheckedByName, ");
                sb.Append("   DATE_FORMAT(pom.ApprovedDate,'%d-%b-%Y')ApprovedDate,  AppprovedByName ");
                sb.Append("   FROM `st_purchaseorder` pom ");
                sb.Append("   INNER JOIN st_purchaseorder_details pod ON pod.PurchaseOrderID=pom.PurchaseOrderID ");
                //sb.Append(" and pom.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
                sb.Append("   AND pod.`IsActive`=1 ");
                if (Type != "")
                {
                    sb.Append("   AND pom.IsDirectPO='" + Type + "' ");
                }
                sb.Append("  where pom.`CreatedDate`>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append("  AND pom.`CreatedDate`<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                sb.Append("   group by pom.PurchaseOrderID ORDER BY DeliveryLocation,CreatedDate");
				System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\App_Code\BLL\poreport1.txt",sb.ToString());
                dt = StockReports.GetDataTable(sb.ToString());
              
            }
            else
            {
                StringBuilder sb = new StringBuilder();

                sb.Append("   SELECT (SELECT location FROM st_locationmaster WHERE locationid=pom.locationid)DeliveryLocation,  ");
                sb.Append("   DATE_FORMAT(pom.CreatedDate,'%d-%b-%Y')PODate,IFNULL(CreatedByName,'') POCreatedBY, ");
                sb.Append("   pom.PurchaseOrderNo,VendorName, IFNULL(IndentNo,'')PIIndentNo,  ");
                sb.Append("   IFNULL((SELECT DATE_FORMAT(`dtEntry`,'%d-%b-%Y') FROM `st_indent_detail` sid WHERE sid.`IndentNo`=pom.IndentNo LIMIT 1 ),'') IndentDate,    ");
                sb.Append("   IF(IsDirectPO=0,'PO From PI','Direct PO') POType ,ssm1.CategoryTypeName CategoryType, sm1.SubCategoryTypeName SubCategoryType,ssm.Name ItemType,");
                sb.Append("   itg.`ItemNameGroup` `ItemName`, ");
                sb.Append("   sm.`ManufactureName`,sm.`MachineName`,sm.`PackSize`,sm.catalogno,sm.hsncode,pod.`OrderedQty` OrderedQty,  ");
                sb.Append("   pod.`CheckedQty` CheckedQty,pod.`ApprovedQty` ApprovedQty, ");

                sb.Append("   Rate*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) GrossTotal, ");
                sb.Append("   DiscountAmount*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) TotalDiscount, ");
                sb.Append("   pod.TaxAmount*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) Totaltax,");
                sb.Append("   UnitPrice*(IF(ApprovedQty=0,IF(CheckedQty=0,OrderedQty,CheckedQty),ApprovedQty)) NetTotal , ");
                sb.Append("   IF(pod.`IsFree`=1,'Free','') IsFree, ");
                sb.Append("   pod.`Rate` Rate, ");
                sb.Append("   pod.DiscountPercentage,");
                sb.Append("   (SELECT SUM( `Percentage` ) FROM  `st_purchaseorder_tax` st WHERE st.purchaseorderid=pod.purchaseorderid AND st.itemid=pod.itemid ) TaxPercentage,");
                sb.Append("   pod.`TaxAmount` TaxAmount,pod.`UnitPrice` UnitPrice, ");
                sb.Append("   DATE_FORMAT(pom.CheckedDate,'%d-%b-%Y')CheckedDate, CheckedByName, ");
                sb.Append("   DATE_FORMAT(pom.ApprovedDate,'%d-%b-%Y')ApprovedDate,  AppprovedByName ");
                sb.Append("   FROM `st_purchaseorder` pom ");
                sb.Append("   INNER JOIN st_purchaseorder_details pod ON pod.PurchaseOrderID=pom.PurchaseOrderID ");
                sb.Append("   and pom.locationid in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
                sb.Append("   INNER JOIN st_itemmaster sm ON sm.`ItemID`=pod.`ItemID` ");
                sb.Append("   INNER JOIN `st_itemmaster_group` itg ON itg.`ItemIDGroup`=sm.`ItemIDGroup` ");
                sb.Append("   INNER JOIN `st_categorytypemaster` ssm1 ON ssm1.CategoryTypeID=sm.CategoryTypeID  ");
                sb.Append("   INNER JOIN `st_subcategorymaster` ssm ON ssm.SubCategoryID=sm.SubCategoryID  ");
                sb.Append("   INNER JOIN `st_subcategorytypemaster` sm1 ON sm1.SubCategoryTypeID=sm.SubCategoryTypeID  ");

                sb.Append("   AND pod.`IsActive`=1 AND pom.status=2 ");
                if (Type != "")
                {
                    sb.Append("   AND pom.IsDirectPO='" + Type + "' ");
                }

                sb.Append("  AND pom.`CreatedDate`>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                sb.Append("  AND pom.`CreatedDate`<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                sb.Append("  ORDER BY DeliveryLocation,CreatedDate,Itemname");
				System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\App_Code\BLL\poreport2.txt",sb.ToString());
                dt = StockReports.GetDataTable(sb.ToString());
                
            }
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
        }
    }
    public static DataTable GRNReport(string fromdate, string todate, string locationid, string apptype, string type1, string datefilter, string status)
    {
        DataTable dt = new DataTable();
        string FromDate = Common.DecryptRijndael(fromdate);
        string ToDate = Common.DecryptRijndael(todate);
        string Type = Common.DecryptRijndael(type1);
        string AppType = Common.DecryptRijndael(apptype);
        string DateFilter = Common.DecryptRijndael(datefilter);
        string Status = Common.DecryptRijndael(status);
        string LocationID = Common.DecryptRijndael(locationid);
        try
        {
            if (Type == "1")
            {
                StringBuilder sb = new StringBuilder();

                sb.Append("  SELECT if(1="+AppType+",'Direct GRN','GRN From PO') GRNType,   ");
                sb.Append("  lt.`LedgerTransactionNo` GRNNo,(SELECT SupplierName FROM st_vendormaster WHERE SupplierID=lt.vendorid) SupplierName,");
                sb.Append(" (select state from st_supplier_gstn where supplierid=lt.vendorid limit 1) SupplierState,");
                sb.Append("  sl.location Location,  ");
                sb.Append(" sm1.state  LocationState,");
                sb.Append(" sum(ROUND(snm.`Rate`*snm.InitialCount,2)) GrossAmount, sum(Round(snm.`DiscountAmount`*snm.InitialCount,2)) DiscountOnTotal,sum(ROUND(snm.`TaxAmount`*snm.InitialCount,2)) TaxAmount,sum(ROUND(snm.InitialCount*snm.UnitPrice,2)) NetAmount,lt.`InvoiceNo`,lt.`PurchaseOrderNo`  ");
                sb.Append(" ,SUM(ROUND(((snm.`Rate`*snm.InitialCount)-snm.DiscountAmount)*IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=snm.stockid  AND taxname='IGST' LIMIT 1) ,'0')*0.01,2))TaxAmtIGST, ");
                sb.Append(" SUM(ROUND(((snm.`Rate`*snm.InitialCount)-snm.DiscountAmount)*IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=snm.stockid   AND taxname='CGST' LIMIT 1) ,'0')*0.01,2)) TaxAmtCGST, ");
                sb.Append(" SUM(ROUND(((snm.`Rate`*snm.InitialCount)-snm.DiscountAmount)*IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=snm.stockid   AND taxname='SGST' LIMIT 1) ,'0')*0.01,2)) TaxAmtSGST ");
                sb.Append("  ,DATE_FORMAT(lt.`DateTime`,'%d-%b-%Y')GRNDate,(SELECT NAME FROM employee_master WHERE employee_id=lt.Creator_UserID)GRNBYUser,IF(lt.`IsPODGenerate`=1,lt.`PODnumber`,'') PODnumber ");

                sb.Append(" , (CASE  IFNULL(spd.`Is_payment`,'') WHEN 1 THEN 'Yes' WHEN '' THEN '' ELSE 'No' END ) 'Is Payment'  ");
                sb.Append(" , (CASE  IFNULL(spd.`Is_forwarded`,'') WHEN 1 THEN 'Yes' WHEN '' THEN '' ELSE 'No' END ) 'Is Forwarded'  ");
                sb.Append(" , (CASE  IFNULL(spd.`IsPOD_Accept`,'') WHEN 1 THEN 'Yes' WHEN '' THEN '' ELSE 'No' END ) 'Is POD Accept'  ");
                sb.Append(" , (CASE  IFNULL(spd.`IsPOD_transfer`,'') WHEN 1 THEN 'Yes' WHEN '' THEN '' ELSE 'No' END ) 'Is POD Transfer'  ");
                sb.Append(" , snm.ItemId ");
                sb.Append("  FROM `st_ledgertransaction` lt  ");
                sb.Append(" left join st_pod_details spd on spd.podnumber=lt.PODnumber ");
                sb.Append(" inner join st_locationmaster sl on sl.locationid=lt.locationid");

                if (Status == "Payment")
                {
                    sb.Append(" And spd.`Is_payment`=1");
                }
                if (Status == "Forwarded")
                {
                    sb.Append(" And spd.`Is_forwarded`=1");
                }
                if (Status == "Accept")
                {
                    sb.Append(" And spd.`IsPOD_Accept`=1");
                }
                if (Status == "Transfer")
                {
                    sb.Append(" And spd.`IsPOD_transfer`=1");
                }


                sb.Append("  inner join state_master sm1 on   sm1.id=sl.StateID ");

                sb.Append("  INNER JOIN st_nmstock snm ON lt.`LedgerTransactionID`=snm.`LedgerTransactionID`  ");
                
                if(LocationID!=""){
                sb.Append(" and lt.locationid in (" + LocationID + ")");
				}
              
                sb.Append("  WHERE lt.`IsCancel`=0 AND  typeoftnx='Purchase' AND ifnull(vendorid,0)<>0  ");
                if (DateFilter == "1")
                {
                    sb.Append("  AND lt.`DateTime`>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append("  AND lt.`DateTime`<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                }
                else if (DateFilter == "2")
                {
                    sb.Append("  AND snm.PostDate >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append("  AND snm.PostDate <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                    sb.Append(" AND snm.IsPost=1 ");
                }
                if (AppType != "")
                {
                    sb.Append(" and IsDirectGRN=" + AppType + "");
                }
                sb.Append(" group by lt.`LedgerTransactionID` ORDER BY lt.locationid, lt.`LedgerTransactionID`  ");
                System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\grn1.txt",sb.ToString());
				dt = StockReports.GetDataTable(sb.ToString());

            }
            else
            {

                StringBuilder sb = new StringBuilder();

                sb.Append("  SELECT if(1= "+AppType+",'Direct GRN','GRN From PO') GRNType,   ");
                sb.Append("  lt.`LedgerTransactionNo` GRNNo,vm.SupplierName ,");
                sb.Append(" (select state from st_supplier_gstn where supplierid=lt.vendorid limit 1) SupplierState,");
                sb.Append("  sl.location Location,  ");
                sb.Append("  sm12.state  LocationState,");
                sb.Append("  lt.`InvoiceNo`,lt.`PurchaseOrderNo`,  ");

                sb.Append("   ssm1.CategoryTypeName CategoryType, sm1.SubCategoryTypeName SubCategoryType,ssm.Name ItemType,");
                sb.Append("   itg.`ItemNameGroup` `ItemName`, ");
                sb.Append("   sm.`ManufactureName`,sm.`MachineName`,sm.`PackSize`,sm.catalogno,sm.hsncode, ");


                sb.Append("  snm.`BarcodeNo`,if(snm.IsBarcodePrinted='1','Yes','No')IsBarcodePrinted,snm.batchnumber,DATE_FORMAT(snm.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,  ");
                sb.Append("  (snm.`InitialCount`/snm.converter) GRNQty,snm.`Rate` as 'Gross Total(Rate)',snm.DiscountPer,snm.`DiscountAmount` DiscountAmount,snm.TaxPer,snm.`TaxAmount` TaxAmount,  ");


                sb.Append("  ((snm.rate-snm.DiscountAmount)*IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=snm.stockid  AND taxname='IGST' LIMIT 1) ,'0')*0.01)TaxAmtIGST,");
                sb.Append(" ((snm.rate-snm.DiscountAmount)*IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=snm.stockid   AND taxname='CGST' LIMIT 1) ,'0')*0.01) TaxAmtCGST,");
                sb.Append(" ((snm.rate-snm.DiscountAmount)*IFNULL((SELECT percentage FROM st_taxchargedlist WHERE `stockid`=snm.stockid   AND taxname='SGST' LIMIT 1) ,'0')*0.01) TaxAmtSGST,");

                sb.Append(" snm.`UnitPrice` as 'Net Total(UnitPrice)',InitialCount*UnitPrice Stockvalue, if(snm.`IsFree`=1,'Yes','')IsFree,");
                sb.Append("  snm.`IsPost`,DATE_FORMAT(lt.`DateTime`,'%d-%b-%Y')GRNDate,DATE_FORMAT(lt.`DateTime`,'%b-%Y')GRNMonth,(SELECT NAME FROM employee_master WHERE employee_id=lt.Creator_UserID)GRNBYUser,  ");
                sb.Append("  DATE_FORMAT(snm.`PostDate`,'%d-%b-%Y') PostDate,(SELECT NAME FROM employee_master WHERE employee_id=snm.`PostUserID`)PostByUeser,IF(lt.`IsPODGenerate`=1,lt.`PODnumber`,'') PODnumber   ");
                sb.Append(" , (CASE  IFNULL(spd.`Is_payment`,'') WHEN 1 THEN 'Yes' WHEN '' THEN '' ELSE 'No' END ) 'Is Payment'  ");
                sb.Append(" , (CASE  IFNULL(spd.`Is_forwarded`,'') WHEN 1 THEN 'Yes' WHEN '' THEN '' ELSE 'No' END ) 'Is Forwarded'  ");
                sb.Append(" , (CASE  IFNULL(spd.`IsPOD_Accept`,'') WHEN 1 THEN 'Yes' WHEN '' THEN '' ELSE 'No' END ) 'Is POD Accept'  ");
                sb.Append(" , (CASE  IFNULL(spd.`IsPOD_transfer`,'') WHEN 1 THEN 'Yes' WHEN '' THEN '' ELSE 'No' END ) 'Is POD Transfer'  ");
                sb.Append(" , snm.ItemId ");
                sb.Append("  FROM `st_ledgertransaction` lt  ");
                sb.Append(" left join st_pod_details spd on spd.podnumber=lt.PODnumber ");
                sb.Append("  INNER JOIN st_nmstock snm ON lt.`LedgerTransactionID`=snm.`LedgerTransactionID`  ");

                sb.Append("   INNER JOIN st_itemmaster sm ON sm.`ItemID`=snm.`ItemID` ");
                sb.Append("   INNER JOIN `st_itemmaster_group` itg ON itg.`ItemIDGroup`=sm.`ItemIDGroup` ");
                sb.Append("   INNER JOIN `st_categorytypemaster` ssm1 ON ssm1.CategoryTypeID=sm.CategoryTypeID  ");
                sb.Append("   INNER JOIN `st_subcategorymaster` ssm ON ssm.SubCategoryID=sm.SubCategoryID  ");
                sb.Append("   INNER JOIN `st_subcategorytypemaster` sm1 ON sm1.SubCategoryTypeID=sm.SubCategoryTypeID  ");




                sb.Append(" inner join st_locationmaster sl on sl.locationid=lt.locationid");
               
                if (LocationID != "")
                {
                    sb.Append(" and sl.locationid in (" + LocationID + ")");
                }

                sb.Append("  inner join state_master sm12 on   sm12.id=sl.StateID ");
                sb.Append("  left join st_vendormaster vm on vm.SupplierID=lt.vendorid ");

                sb.Append("  WHERE lt.`IsCancel`=0 AND  typeoftnx='Purchase' AND vendorid<>0  ");
                if (DateFilter == "1")
                {
                    sb.Append("  AND lt.`DateTime`>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append("  AND lt.`DateTime`<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                }
                else if (DateFilter == "2")
                {
                    sb.Append("  AND snm.PostDate >='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
                    sb.Append("  AND snm.PostDate <='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'  ");
                    sb.Append(" AND snm.IsPost=1 ");
                }

                if (AppType != "")
                {
                    sb.Append(" and IsDirectGRN=" + AppType + "");
                }
                sb.Append(" ORDER BY lt.locationid, lt.`LedgerTransactionID`,snm.`ItemName`  ");
				System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\grn2.txt",sb.ToString());
                dt = StockReports.GetDataTable(sb.ToString());

            }
            return dt;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
        }

    }
    
	
	 public static DataTable IndentReport(string fromdate, string todate, string type, string ch, string locationid, string indentno)
    {
        string FromDate = Common.DecryptRijndael(fromdate);
        string ToDate = Common.DecryptRijndael(todate);
        string Type = Common.DecryptRijndael(type);
        string Ch = Common.DecryptRijndael(ch);
        string LocationID = Common.DecryptRijndael(locationid);
		string IndentNo = Common.DecryptRijndael(indentno);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" select * from (");
            sb.Append("  SELECT ");
            sb.Append(" st.IndentType,stn.minorunit ConsumeUnit,DATE_FORMAT(stn.Expirydate , '%d-%b-%Y')Expirydate,IFNULL(stn.barcodeno,'')barcodeno,");
            sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid=st.FromLocationID) FromLocation,");
            sb.Append(" (SELECT location FROM st_locationmaster WHERE locationid=st.ToLocationID) ToLocation,");
            sb.Append(" DATE_FORMAT(dtEntry,'%d-%b-%Y') IndentDate,st.IndentNo,cat.CategoryTypeName,subcat.SubCategoryTypeName,");
            sb.Append(" itg.`ItemNameGroup` ItemName,");
            sb.Append(" sm.ManufactureName Manufacture,sm.MachineName Machine,sm.PackSize,");
            sb.Append(" trimzero(ReqQty)ReqQty,trimzero(CheckedQty)CheckedQty,trimzero(if(ApprovedQty=0,if(CheckedQty=0,ReqQty,CheckedQty),ApprovedQty)) ApprovedQty,");
            sb.Append(" (SELECT SUM(sendqty) FROM   `st_indentissuedetail` ss where ss.itemid=st.itemid and ss.indentno=st.indentno) IssueQty, ");
            sb.Append(" trimzero(st.Rate)Rate,trimzero(st.DiscountPer)DiscountPer,trimzero(TaxPerIGST)TaxPerIGST, ");
            sb.Append(" trimzero(TaxPerCGST)TaxPerCGST,trimzero(TaxPerSGST)TaxPerSGST, ");
            sb.Append(" trimzero(TaxPerCGST+TaxPerSGST+TaxPerIGST) TotalTaxPer,");
            sb.Append(" trimzero(st.UnitPrice)UnitPrice,");
            sb.Append(" UserName MakedBy,DATE_FORMAT(st.CheckedDate,'%d-%b-%Y')CheckedDate");
            sb.Append(" ,st.CheckedUserName CheckedBy,DATE_FORMAT(st.ApprovedDate,'%d-%b-%Y')ApprovedDate ,st.ApprovedUserName ApprovedBy");
            sb.Append(" FROM st_indent_detail st");
            sb.Append(" Left JOIN st_itemmaster sm ON st.itemid = sm.itemid ");
            sb.Append(" Left JOIN `st_itemmaster_group` itg ON itg.`ItemIDGroup`=sm.`ItemIDGroup` INNER JOIN st_categorytypemaster cat  ON cat.CategoryTypeID = sm.CategoryTypeID INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID = sm.SubCategoryTypeID  INNER JOIN st_nmstock  stn ON  stn.`ItemID`=st.`ItemId` ");
            sb.Append(" WHERE st.isactive=1 ");
            sb.Append(" AND indenttype='"+Type+"'");
            
            if (LocationID != "")
            {
                sb.Append(" and st.FromLocationID in (" + LocationID + ") ");
                
            }
			 if (IndentNo.Trim() == "")
			 {
				sb.Append("  AND st.`dtEntry`>= '" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' ");
				sb.Append("  AND st.`dtEntry`<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 00:00:00'");
			 }
			 else
			 {
				  sb.Append(" and st.indentno='" + IndentNo.Trim() + "' ");
			 }
            sb.Append("  GROUP BY IndentNo ORDER BY fromlocation,IndentNo,Itemname) t");
            if (Ch == "1")
            {
                sb.Append(" where t.IssueQty=0 ");
            }
            List<string> strLocationID = new List<string>();
            strLocationID = LocationID.Split(',').ToList<string>();


			System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\indentd.txt",sb.ToString());

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), string.Join(",", strLocationID)), con))
            {
                for (int i = 0; i < strLocationID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), strLocationID[i]);
                }

                da.SelectCommand.Parameters.AddWithValue("@FromDate", Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00'");
                da.SelectCommand.Parameters.AddWithValue("@ToDate", Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 23:59:59'");
                da.SelectCommand.Parameters.AddWithValue("@Type", Type);

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    strLocationID.Clear();
                    return dt;
                };

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
	
	
    public static DataTable LowStockReport(string categorytypeid, string subcategorytypeid, string subcategoryid, string itemid, string locationid, string machineid, string apptype)
    {
        string ItemID = Common.DecryptRijndael(itemid);
        string CategoryTypeId = Common.DecryptRijndael(categorytypeid);
        string SubCategoryTypeId = Common.DecryptRijndael(subcategorytypeid);
        string SubCategoryId = Common.DecryptRijndael(subcategoryid);
        string LocationID = Common.DecryptRijndael(locationid);
        string MachineID = Common.DecryptRijndael(machineid);
        string Apptype = Common.DecryptRijndael(apptype);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select '" + Apptype + "' ReportFrom,locationid, ItemID,Location,CategoryTypeName,SubCategoryTypeName,itemgroupName,itemname,barcodeno,MachineName,ManufactureName,packsize,ConsumeUnit,batchnumber,Expirydate,");
            sb.Append(" MinLevel,RecorderLevel,sum(InhandQty)InhandQty from (");
            sb.Append("  SELECT slm.locationid, stn.ItemID, Location ,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
            sb.Append(" (select itemnamegroup from st_itemmaster_group where itemidgroup=sm.itemidgroup)  itemname,ifnull(snt.barcodeno,'')barcodeno,sm.MachineName,sm.ManufactureName,sm.packsize,snt.minorunit ConsumeUnit, ");
            sb.Append(" ifnull(snt.batchnumber,'')batchnumber,ifnull(DATE_FORMAT(snt.expirydate,'%d-%b-%y'),'') Expirydate,MinLevel,RecorderLevel,ifnull((`InitialCount` - `ReleasedCount`-pendingqty),0) InhandQty ");
            sb.Append("  FROM `st_mappingitemmaster` stn ");
			sb.Append(" INNER JOIN st_nmsalesdetails sn	ON stn.ItemId=sn.itemid ");
            sb.Append(" INNER JOIN `st_locationmaster` slm ON stn.locationid=slm.locationid ");
            //sb.Append(" and slm.locationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            if (LocationID != "")
            {
                sb.Append(" and slm.locationid in  ("+LocationID+")");
            }

            sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
            if (ItemID != "")
            {
                sb.Append(" and sm.itemid in  ("+ItemID+")");
            }
            if (MachineID != "")
            {
                sb.Append(" and sm.MachineID in  ("+MachineID+")");
            }
            sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
            if (CategoryTypeId != "")
            {
                sb.Append(" and cat.CategoryTypeID in  ("+CategoryTypeId+")");
            }
            sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
            if (SubCategoryTypeId != "")
            {
                sb.Append(" and subcat.SubCategoryTypeID in  ("+SubCategoryTypeId+")");
            }
            sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
            if (SubCategoryId != "")
            {
                sb.Append(" and itemcat.SubCategoryID in  ("+SubCategoryId+")");
            }
            sb.Append(" inner join st_nmstock snt ON snt.stockid = sn.stockid  and snt.locationid=stn.locationid and snt.ispost=1 ) tb");

            sb.Append(" GROUP BY locationid,ItemID HAVING SUM(InhandQty) <= " + Apptype + " order by location,itemname");

            List<string> strLocationID = new List<string>();
            strLocationID = LocationID.Split(',').ToList<string>();

            List<string> strItemID = new List<string>();
            strItemID = ItemID.Split(',').ToList<string>();

            List<string> strMachineID = new List<string>();
            strMachineID = MachineID.Split(',').ToList<string>();

            List<string> strCategoryTypeID = new List<string>();
            strCategoryTypeID = CategoryTypeId.Split(',').ToList<string>();

            List<string> strSubCategoryTypeId = new List<string>();
            strSubCategoryTypeId = SubCategoryTypeId.Split(',').ToList<string>();

            List<string> strSubCategoryId = new List<string>();
            strSubCategoryId = SubCategoryId.Split(',').ToList<string>();

			System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\low1.txt",sb.ToString());
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), string.Join(",", strLocationID), string.Join(",", strItemID),
                string.Join(",", strMachineID), string.Join(",", strCategoryTypeID), string.Join(",", strSubCategoryTypeId), string.Join(",", strSubCategoryId)), con))
            {
                for (int i = 0; i < strLocationID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), strLocationID[i]);
                }
                for (int i = 0; i < strItemID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@b", i), strItemID[i]);
                }
                for (int i = 0; i < strMachineID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@c", i), strMachineID[i]);
                }
                for (int i = 0; i < strCategoryTypeID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@d", i), strCategoryTypeID[i]);
                }
                for (int i = 0; i < strSubCategoryTypeId.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@e", i), strSubCategoryTypeId[i]);
                }
                for (int i = 0; i < strSubCategoryId.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@f", i), strSubCategoryId[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);

                    strItemID.Clear();
                    strLocationID.Clear();
                    strCategoryTypeID.Clear();
                    strMachineID.Clear();
                    strSubCategoryTypeId.Clear();
                    strSubCategoryId.Clear();
                    return dt;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable StockExpiryReport(string fromdate, string todate, string categorytypeid, string subcategorytypeid, string subcategoryid, string itemid, string locationid, string machineid)
    {
        string ItemID = Common.DecryptRijndael(itemid);
        string CategoryTypeId = Common.DecryptRijndael(categorytypeid);
        string SubCategoryTypeId = Common.DecryptRijndael(subcategorytypeid);
        string SubCategoryId = Common.DecryptRijndael(subcategoryid);
        string LocationID = Common.DecryptRijndael(locationid);
        string MachineID = Common.DecryptRijndael(machineid);
        string FromDate = Common.DecryptRijndael(fromdate);
        string ToDate = Common.DecryptRijndael(todate);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT Location ,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
            sb.Append(" stn.itemname,stn.barcodeno,sm.MachineName,stn.minorunit ConsumeUnit, ");
            sb.Append(" stn.batchnumber,DATE_FORMAT(stn.expirydate,'%d-%b-%y') Expirydate,(`InitialCount` - `ReleasedCount`-pendingqty) InhandQty,ifnull(sm.expdatecutoff,0)expdatecutoff  ");
            sb.Append("  FROM `st_nmstock` stn ");
            sb.Append(" INNER JOIN `st_locationmaster` slm ON stn.locationid=slm.locationid ");
            //sb.Append(" and slm.locationID in ('" + Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','") + "') ");
            if (LocationID != "")
            {
                sb.Append(" and slm.locationid in ("+LocationID+")");
            }

            sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
            if (ItemID != "")
            {
                sb.Append(" and sm.itemid in ("+ItemID+")");
            }
            if (MachineID != "")
            {
                sb.Append(" and sm.MachineID in ("+MachineID+")");
            }
            sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
            if (CategoryTypeId != "")
            {
                sb.Append(" and cat.CategoryTypeID in ("+CategoryTypeId+")");
            }
            sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
            if (SubCategoryTypeId != "")
            {
                sb.Append(" and subcat.SubCategoryTypeID in ("+SubCategoryTypeId+")");
            }
            sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
            if (SubCategoryId != "")
            {
                sb.Append(" and itemcat.SubCategoryID in ("+SubCategoryId+")");
            }
            sb.Append(" WHERE stn.ispost=1  ");
            sb.Append(" and (`InitialCount` - `ReleasedCount`-pendingqty) >0 ");
            sb.Append(" AND stn.expirydate >=@FromDate  ");
            sb.Append(" AND stn.expirydate<=@ToDate ");
            sb.Append(" order by stn.expirydate");

            List<string> strLocationID = new List<string>();
            strLocationID = LocationID.Split(',').ToList<string>();

            List<string> strItemID = new List<string>();
            strItemID = ItemID.Split(',').ToList<string>();

            List<string> strMachineID = new List<string>();
            strMachineID = MachineID.Split(',').ToList<string>();

            List<string> strCategoryTypeID = new List<string>();
            strCategoryTypeID = CategoryTypeId.Split(',').ToList<string>();

            List<string> strSubCategoryTypeId = new List<string>();
            strSubCategoryTypeId = SubCategoryTypeId.Split(',').ToList<string>();

            List<string> strSubCategoryId = new List<string>();
            strSubCategoryId = SubCategoryId.Split(',').ToList<string>();
			System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\expiry.txt",sb.ToString());

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), string.Join(",", strLocationID), string.Join(",", strItemID),
                string.Join(",", strMachineID), string.Join(",", strCategoryTypeID), string.Join(",", strSubCategoryTypeId), string.Join(",", strSubCategoryId)), con))
            {
                for (int i = 0; i < strLocationID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), strLocationID[i]);
                }
                for (int i = 0; i < strItemID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@b", i), strItemID[i]);
                }
                for (int i = 0; i < strMachineID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@c", i), strMachineID[i]);
                }
                for (int i = 0; i < strCategoryTypeID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@d", i), strCategoryTypeID[i]);
                }
                for (int i = 0; i < strSubCategoryTypeId.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@e", i), strSubCategoryTypeId[i]);
                }
                for (int i = 0; i < strSubCategoryId.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@f", i), strSubCategoryId[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@FromDate", Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"));
                da.SelectCommand.Parameters.AddWithValue("@ToDate", Util.GetDateTime(FromDate).AddDays(Util.GetDouble(ToDate)).ToString("yyyy-MM-dd"));
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);

                    strItemID.Clear();
                    strLocationID.Clear();
                    strCategoryTypeID.Clear();
                    strMachineID.Clear();
                    strSubCategoryTypeId.Clear();
                    strSubCategoryId.Clear();
                    return dt;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable StockStatusReport(string ItemID, string ManufactureID, string MacID, string LocationID)
    {
        ItemID = Common.DecryptRijndael(ItemID);
        ManufactureID = Common.DecryptRijndael(ManufactureID);
        MacID = Common.DecryptRijndael(MacID);
        LocationID = Common.DecryptRijndael(LocationID);
        string SessionLocationID = Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT st.stockid, st.barcodeno,(SELECT location FROM st_locationmaster WHERE locationid=st.LocationID)StoreLocation, ");
            sb.Append(" cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemTypeName,(SELECT itemnamegroup FROM st_itemmaster_group  ");
            sb.Append("    WHERE itemidgroup=im.itemidgroup ) `ItemName`, ");
            sb.Append("(select name from  st_manufacture_master mmmm where mmmm.MAnufactureID=st.ManufactureID)Manufacture,");
            sb.Append("(select name from  macmaster mmmm where mmmm.id=st.macid)Machine,im.packsize,st.barcodeno,");
            sb.Append(" st.`BatchNumber`,IF(st.`ExpiryDate`='0001-01-01','',DATE_FORMAT(expirydate,'%d-%b-%Y')) ExpiryDate, ");
            sb.Append(" ROUND(st.`Rate`,2) Rate ,ROUND(st.`UnitPrice`,2) UnitPrice , ");
            sb.Append(" ROUND(st.`DiscountAmount`,2) DiscountAmount,ROUND(st.`TaxAmount`,2)TaxAmount, ");
            sb.Append(" ROUND(st.`InitialCount`,2)InitialQty, ROUND(st.`ReleasedCount`,2)ReleasedQty, ROUND(st.`PendingQty`,2) InTransitQty, ");
            sb.Append(" ROUND((st.`InitialCount`-st.`ReleasedCount`-st.`PendingQty`),2) StockInHandQty, ");
            sb.Append(" ROUND((st.UnitPrice*(st.InitialCount-st.ReleasedCount-st.`PendingQty`)),2) StockAmount, ");
            sb.Append(" ROUND((st.UnitPrice*(ROUND(st.`PendingQty`,2))),2) InTransitAmount, ");
            sb.Append("  st.`MajorUnit` PurchaseUnit,st.`MinorUnit` ConsumeUnit,");
            sb.Append(" DATE_FORMAT(StockDate,'%d-%b-%Y') StockDate ");
            sb.Append(" FROM st_nmstock st  ");
            sb.Append(" INNER JOIN st_itemmaster im ON im.`ItemID`=st.`ItemID` ");
            if (ItemID.Trim() != string.Empty)
            {
                sb.Append(" AND st.itemid IN ({0})");
            }
            sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=im.CategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=im.SubCategoryTypeID  ");
            sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=im.SubCategoryID ");
            sb.Append(" WHERE  (st.`InitialCount`-st.`ReleasedCount`)>0 AND ispost=1 ");
            //sb.Append(" AND st.locationID in ({1}) ");
            if (LocationID != string.Empty)
            {
                sb.Append(" AND st.LocationID in ({2})");
            }
            if (ManufactureID != "0")
            {
                sb.Append(" and st.ManufactureID=@ManufactureID");
            }
            if (MacID != "0")
            {
                sb.Append(" and st.MacID =@MacID");
            }
            sb.Append(" ORDER BY StoreLocation,CategoryTypeName,SubCategoryTypeName,itemTypeName,ItemName,Manufacture,Machine,packsize  ");



            List<string> strItemID = new List<string>();
            strItemID = ItemID.Split(',').ToList<string>();

            List<string> strSessionLocationID = new List<string>();
            strSessionLocationID = SessionLocationID.Split(',').ToList<string>();

            List<string> strLocationID = new List<string>();
            strLocationID = LocationID.Split(',').ToList<string>();

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), string.Join(",", strItemID),
                string.Join(",", strSessionLocationID), string.Join(",", strLocationID)), con))
            {
                for (int i = 0; i < strItemID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), strItemID[i]);
                }
                for (int i = 0; i < strSessionLocationID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@b", i), strSessionLocationID[i]);
                }
                for (int i = 0; i < strLocationID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@c", i), strLocationID[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@ManufactureID", ManufactureID);
                da.SelectCommand.Parameters.AddWithValue("@MacID", MacID);
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);

                    strItemID.Clear();
                    strLocationID.Clear();
                    return dt;
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable StockConsumeReport(string ItemID, string ManufactureID, string MachineID, string LocationID, string Type, string CategoryTypeID, string SubCategoryTypeID, string SubCategoryID, string FromDate, string ToDate, string IsAutoIncrement = "0")
    {
        ItemID = Common.DecryptRijndael(ItemID);
        //ManufactureID = Common.DecryptRijndael(ManufactureID);
        MachineID = Common.DecryptRijndael(MachineID);
        LocationID = Common.DecryptRijndael(LocationID);
        Type = Common.DecryptRijndael(Type);
        CategoryTypeID = Common.DecryptRijndael(CategoryTypeID);
        SubCategoryTypeID = Common.DecryptRijndael(SubCategoryTypeID);
        SubCategoryID = Common.DecryptRijndael(SubCategoryID);
        FromDate = Common.DecryptRijndael(FromDate);
        ToDate = Common.DecryptRijndael(ToDate);
        string SessionLocationID = Util.GetString(UserInfo.AccessStoreLocation).Replace(",", "','");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Type == "0")
            {
                sb.Append(" SELECT salesno TransactionNo,Location ConsumeLocation,stm.State,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
                sb.Append(" stn.itemid,stn.itemname,sm.ApolloItemCode ItemCode,stn.barcodeno,sm.MachineName, snd.Quantity ConsumeQuantity ,stn.unitprice*snd.Quantity ConsumeAmt, stn.minorunit ConsumeUnit, ");
                sb.Append(" DATE_FORMAT(DATETIME,'%d-%b-%Y') ConsumeDate,snd.Naration Remarks,(SELECT NAME FROM employee_master WHERE employee_id=snd.UserID) UserName,DATE_FORMAT(stn.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,stn.BatchNumber ");
                sb.Append("  FROM `st_nmsalesdetails` snd ");
                sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");
               
                // if (LocationID != string.Empty)
                // {
                    // sb.Append(" AND slm.locationid IN ("+LocationID+")");
                // }
                // else
                // {
                    // sb.Append(" AND slm.locationID IN ({0}) ");
                // }
                sb.Append(" INNER JOIN state_master stm ON stm.`id`=slm.`StateID` ");
                sb.Append(" INNER JOIN st_nmstock stn ON stn.stockid=snd.stockid ");
                sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
                if (ItemID != string.Empty)
                {
                    sb.Append(" AND sm.itemid IN ("+ItemID+")");
                }
                if (MachineID != string.Empty)
                {
                    sb.Append(" AND sm.MachineID IN ("+MachineID+")");
                }
                sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
                if (CategoryTypeID != string.Empty)
                {
                    sb.Append(" AND cat.CategoryTypeID IN ("+CategoryTypeID+")");
                }
                sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
                if (SubCategoryTypeID != string.Empty)
                {
                    sb.Append(" AND subcat.SubCategoryTypeID IN ("+SubCategoryTypeID+")");
                }
                sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
                if (SubCategoryID != string.Empty)
                {
                    sb.Append(" AND itemcat.SubCategoryID IN ("+SubCategoryID+")");
                }
                sb.Append(" WHERE TrasactionTypeID=1  ");
                sb.Append(" And snd.DATETIME>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 00:00:00'");
				System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\type0.txt",sb.ToString());
            }

            else if (Type == "1")
            {
                sb = new StringBuilder();
                sb.Append(" SELECT salesno TransactionNo,Location ConsumeLocation,stm.State,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
                sb.Append(" stn.itemid,stn.itemname,stn.barcodeno,sm.MachineName, sum(snd.Quantity) ConsumeQuantity ,sum(stn.unitprice*snd.Quantity) ConsumeAmt,stn.minorunit ConsumeUnit,DATE_FORMAT(stn.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,stn.BatchNumber, ");
                sb.Append("DATE_FORMAT(DATETIME, '%d-%b-%Y') ConsumeDate,(SELECT NAME FROM employee_master WHERE employee_id = snd.UserID) UserName");
				sb.Append("  FROM `st_nmsalesdetails` snd ");
                sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");

                // if (LocationID != string.Empty)
                // {
                    // sb.Append(" AND slm.locationid in ("+LocationID+")");
                // }
                // else
                // {
                    // sb.Append(" AND slm.locationID IN ({0}) ");
                // }
                sb.Append(" INNER JOIN state_master stm ON stm.`id`=slm.`StateID` ");
                sb.Append(" INNER JOIN st_nmstock stn ON stn.stockid=snd.stockid ");
                sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
                if (ItemID != string.Empty)
                {
                    sb.Append(" AND sm.itemid IN ("+ItemID+")");
                }
                if (MachineID != string.Empty)
                {
                    sb.Append(" AND sm.MachineID IN ("+MachineID+")");
                }
                sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
                if (CategoryTypeID != string.Empty)
                {
                    sb.Append(" AND cat.CategoryTypeID IN ("+CategoryTypeID+")");
                }
                sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
                if (SubCategoryTypeID != string.Empty)
                {
                    sb.Append(" AND subcat.SubCategoryTypeID IN ("+SubCategoryTypeID+")");
                }
                sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
                if (SubCategoryID != string.Empty)
                {
                    sb.Append(" AND itemcat.SubCategoryID IN ("+SubCategoryID+")");
                }
                sb.Append(" WHERE TrasactionTypeID=1  ");
                sb.Append(" And snd.DATETIME>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 00:00:00'");
                sb.Append(" GROUP BY snd.fromlocationid,sm.itemid ");
//System.IO.File.WriteAllText(@"C:\itdose\Livecode\Droplet_Live_New\Droplet\App_Code\BLL\type1.txt",sb.ToString());
            }
            else
            {
                sb = new StringBuilder();
                sb.Append(" SELECT salesno TransactionNo,Location ConsumeLocation,stm.State,cat.CategoryTypeName,subcat.SubCategoryTypeName,itemcat.Name itemgroupName, ");
                sb.Append(" stn.itemid,stn.itemname,stn.barcodeno,sm.MachineName,sum(snd.Quantity) ConsumeQuantity,SUM(stn.Unitprice*snd.Quantity) ConsumeAmt ,stn.minorunit ConsumeUnit,DATE_FORMAT(stn.`ExpiryDate`,'%d-%b-%Y') ExpiryDate,stn.BatchNumber, ");
				sb.Append("DATE_FORMAT(DATETIME, '%d-%b-%Y') ConsumeDate,(SELECT NAME FROM employee_master WHERE employee_id = snd.UserID) UserName");
                sb.Append("  FROM `st_nmsalesdetails` snd ");
                sb.Append(" INNER JOIN `st_locationmaster` slm ON snd.fromlocationid=slm.locationid ");
                
                // if (LocationID != string.Empty)
                // {
                    // sb.Append(" and slm.locationid IN ("+LocationID+")");
                // }
                // else
                // {
                    // sb.Append(" and slm.locationID in ({0}) ");
                // }
                sb.Append(" INNER JOIN state_master stm ON stm.`id`=slm.`StateID` ");
                sb.Append(" INNER JOIN st_nmstock stn ON stn.stockid=snd.stockid ");
                sb.Append(" INNER JOIN st_itemmaster sm ON sm.itemid=stn.itemid ");
                if (ItemID != string.Empty)
                {
                    sb.Append(" AND sm.itemid IN ("+ItemID+")");
                }
                if (MachineID != string.Empty)
                {
                    sb.Append(" AND sm.MachineID IN ("+MachineID+")");
                }
                sb.Append(" INNER JOIN st_categorytypemaster cat ON cat.CategoryTypeID=sm.CategoryTypeID  ");
                if (CategoryTypeID != string.Empty)
                {
                    sb.Append(" AND cat.CategoryTypeID IN ("+CategoryTypeID+")");
                }
                sb.Append(" INNER JOIN st_subcategorytypemaster subcat ON subcat.SubCategoryTypeID=sm.SubCategoryTypeID  ");
                if (SubCategoryTypeID != string.Empty)
                {
                    sb.Append(" AND subcat.SubCategoryTypeID IN ("+SubCategoryTypeID+")");
                }
                sb.Append(" INNER JOIN st_subcategorymaster itemcat ON itemcat.SubCategoryID=sm.SubCategoryID   ");
                if (SubCategoryID != string.Empty)
                {
                    sb.Append(" AND itemcat.SubCategoryID IN ("+SubCategoryID+")");
                }
                sb.Append(" WHERE TrasactionTypeID=1  ");
                sb.Append(" And snd.DATETIME>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND snd.DATETIME<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " 00:00:00'");
                sb.Append(" GROUP BY snd.fromlocationid,sm.itemid ");

            }
			System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\type0.txt",sb.ToString());
            List<string> strSessLocationID = new List<string>();
            strSessLocationID = SessionLocationID.Split(',').ToList<string>();

            List<string> strLocationID = new List<string>();
            strLocationID = LocationID.Split(',').ToList<string>();

            List<string> strItemID = new List<string>();
            strItemID = ItemID.Split(',').ToList<string>();

            List<string> strMachineID = new List<string>();
            strMachineID = MachineID.Split(',').ToList<string>();

            List<string> strCategoryTypeID = new List<string>();
            strCategoryTypeID = CategoryTypeID.Split(',').ToList<string>();

            List<string> strSubCategoryTypeID = new List<string>();
            strSubCategoryTypeID = SubCategoryTypeID.Split(',').ToList<string>();


            List<string> strSubCategoryID = new List<string>();
            strSubCategoryID = SubCategoryID.Split(',').ToList<string>();

            
System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\Design\Store\consume.txt",sb.ToString());          
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), string.Join(",", strSessLocationID),
                string.Join(",", strLocationID), string.Join(",", strItemID),
                string.Join(",", strMachineID), string.Join(",", strCategoryTypeID),
                string.Join(",", strSubCategoryTypeID), string.Join(",", strSubCategoryID)), con))
            {
                for (int i = 0; i < strSessLocationID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), strSessLocationID[i]);
                }

                for (int i = 0; i < strLocationID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@b", i), strLocationID[i]);
                }
                for (int i = 0; i < strItemID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@c", i), strItemID[i]);
                }
                for (int i = 0; i < strMachineID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@d", i), strMachineID[i]);
                }
                for (int i = 0; i < strCategoryTypeID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@e", i), strCategoryTypeID[i]);
                }
                for (int i = 0; i < strSubCategoryTypeID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@f", i), strSubCategoryTypeID[i]);
                }
                for (int i = 0; i < strSubCategoryID.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@g", i), strSubCategoryID[i]);
                }
               
                da.SelectCommand.Parameters.AddWithValue("@FromDate", string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                da.SelectCommand.Parameters.AddWithValue("@ToDate", string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " ", "23:59:59"));

                

                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (IsAutoIncrement == "1")
                    {
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


                    }

                    strSessLocationID.Clear();
                    strLocationID.Clear();
                    strItemID.Clear();
                    strMachineID.Clear();
                    strCategoryTypeID.Clear();
                    strSubCategoryTypeID.Clear();
                    strSubCategoryID.Clear();
                    return dt;
                }
            }


        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}