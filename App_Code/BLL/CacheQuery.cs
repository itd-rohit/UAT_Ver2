using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.IO;
using System.Text;
using System.Web.Caching;
using MySql.Data.MySqlClient;
/// <summary>
/// Summary description for CacheQuery
/// Shatrughan 04-07-19
/// </summary>
public static class CacheQuery
{
    public static DataTable loadCurrency()
    {
        try
        {
            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                string CacheName = "Currency";
                if (HttpContext.Current.Cache[CacheName] != null)
                    dt = HttpContext.Current.Cache[CacheName] as DataTable;
                else
                {
                    dt = StockReports.GetDataTable("SELECT * FROM ( SELECT cm.CountryID,cm.NAME,cm.Currency,cm.Notation,cm.IsBaseCurrency,cn.B_CountryID,cn.B_Currency,cn.Round FROM country_master cm INNER JOIN Converson_Master cn ON cm.CountryID=cn.S_CountryID WHERE cm.IsActive=1 ORDER BY cn.ID DESC )a GROUP BY CountryID");
                   // File.Create(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))).Close();
                   //// File.WriteAllText(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName)), DateTime.Now.ToString());
                   // HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CityCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
                }
                return dt;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable loadCountry(MySqlConnection con = null)
    {
        try
        {
            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                string CacheName = "Country";
                if (HttpContext.Current.Cache[CacheName] != null)
                    dt = HttpContext.Current.Cache[CacheName] as DataTable;
                else
                {
                    string str = "SELECT CountryID,IsBaseCurrency,Name FROM country_master WHERE IsActive=1 ORDER By SeqNo,Name";
                    if (con != null)
                        dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str).Tables[0];
                    else
                        dt = StockReports.GetDataTable(str);

                   // File.Create(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))).Close();
                  //  File.WriteAllText(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName)), DateTime.Now.ToString());
                  //  HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CityCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
                }
                return dt;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }

    public static DataTable loadState(int countryID, MySqlConnection con = null)
    {
        try
        {
            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                string CacheName = "State";
                if (HttpContext.Current.Cache[CacheName] != null)
                    dt = HttpContext.Current.Cache[CacheName] as DataTable;
                else
                {
                    string str = "SELECT ID,State,CountryID FROM state_master WHERE IsActive=1 ORDER BY state";
                    if (con != null)
                        dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str).Tables[0];
                    else
                        dt = StockReports.GetDataTable(str);
                   // File.Create(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))).Close();
                   // File.WriteAllText(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName)), DateTime.Now.ToString());
                   // HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CityCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
                }
                var rows = dt.AsEnumerable().Where(s => s.Field<int>("CountryID") == countryID);
                if (rows.Count() > 0)
                    return rows.CopyToDataTable();
                else
                    return null;


            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable loadCity(int StateID, MySqlConnection con = null)
    {
        try
        {
            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                string CacheName = "City";
                if (HttpContext.Current.Cache[CacheName] != null)
                    dt = HttpContext.Current.Cache[CacheName] as DataTable;
                else
                {
                    string str = "SELECT City,ID,StateID FROM `city_master` WHERE IsActive=1  ORDER BY `City`";
                    if (con != null)
                        dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str).Tables[0];
                    else
                        dt = StockReports.GetDataTable(str);

                  //  File.Create(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))).Close();
                  ////  File.WriteAllText(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName)), DateTime.Now.ToString());
                   // HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CityCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
                }
                
                var rows = dt.AsEnumerable().Where(s => s.Field<int>("StateID") == StateID);
                if (rows.Count() > 0)
                    return rows.CopyToDataTable();
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable loadLoality(int StateID, int CityID, MySqlConnection con = null)
    {
        try
        {
            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                string CacheName = "Locality";
                if (HttpContext.Current.Cache[CacheName] != null)
                    dt = HttpContext.Current.Cache[CacheName] as DataTable;
                else
                {
                    string str = "SELECT ID,NAME Locality,CityID,StateID FROM f_locality WHERE Active=1  ORDER BY `name`";
                    if (con != null)
                        dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str).Tables[0];
                    else
                        dt = StockReports.GetDataTable(str);

                  //  File.Create(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))).Close();
                  //  File.WriteAllText(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName)), DateTime.Now.ToString());
                  //  HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CityCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
                }
                var rows = dt.AsEnumerable().Where(s => s.Field<int>("CityID") == CityID);
                if (rows.Count() > 0)
                    return rows.CopyToDataTable();
                else
                    return null;
               

            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static DataTable loadBank()
    {
        try
        {
            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                string CacheName = "Bank";
                if (HttpContext.Current.Cache[CacheName] != null)
                    dt = HttpContext.Current.Cache[CacheName] as DataTable;
                else
                {
                    dt = StockReports.GetDataTable(" SELECT Bank_ID,BankName,IsOnlineBank FROM f_bank_master ");
                //    File.Create(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))).Close();
                 //   File.WriteAllText(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName)), DateTime.Now.ToString());
                 //   HttpContext.Current.Cache.Insert(CacheName, dt, new System.Web.Caching.CacheDependency(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))), DateTime.Now.AddMinutes(Util.GetInt(Resources.Resource.CityCacheTimeOut)), System.Web.Caching.Cache.NoSlidingExpiration);
                }
                return dt;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    public static void dropCache(string CacheName)
    {
        if (File.Exists(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName))))
        {
            File.Delete(HttpContext.Current.Server.MapPath(string.Format("~/CacheDependency/{0}.txt", CacheName)));
        }
    }
    public static void dropAllCache()
    {
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/Currency.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/Currency.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/Country.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/Country.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/Locality.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/Locality.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/City.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/City.txt"));
        }
        if (File.Exists(HttpContext.Current.Server.MapPath("~/CacheDependency/Bank.txt")))
        {
            File.Delete(HttpContext.Current.Server.MapPath("~/CacheDependency/Bank.txt"));
        }
    }
    public static void loadAllDataonCache()
    {
        loadCountry();
        loadCurrency();
        loadBank();
    }
}

