using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Services;

public partial class Design_Master_CoPaymentMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string bindpanel()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(panel_code,' ~ ',company_name) panelname, panel_id FROM f_panel_master WHERE isactive=1 and CoPaymentApplicable=1").Tables[0])
                return JsonConvert.SerializeObject(dt);
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

    [WebMethod]
    public static string binddepartment(string panel_id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (panel_id == "null" || panel_id == "0")
            {
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT '0' savedid,'0' panelid,'' CoPaymentPercentage, subcategoryid,NAME FROM `f_subcategorymaster` WHERE active=1 ORDER BY NAME  ").Tables[0])
                    return JsonConvert.SerializeObject(dt);
            }
            else
            {
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ifnull(fp.id,0) savedid,@panelid panelid,ifnull(CoPaymentPercentage,'')CoPaymentPercentage,sm.subcategoryid,NAME FROM `f_subcategorymaster` sm LEFT JOIN  f_panel_copaymentmaster  fp ON fp.`SubCategoryID`=sm.`SubCategoryID` AND fp.`ItemID`=0 AND fp.`IsActive`=1 AND fp.`Panel_ID`=@panelid WHERE active=1 ORDER BY NAME  ", new MySqlParameter("@panelid", panel_id)).Tables[0])
                    return JsonConvert.SerializeObject(dt);
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

    [WebMethod]
    public static string bindtest(int deptid, int panelid, string deptname)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT im.Subcategoryid,im.itemid,im.testcode,im.typename,@deptname deptname,@panelid panelid,ifnull(pc.CoPaymentPercentage,'')CoPaymentPercentage,ifnull(pc.id,'0') savedid FROM f_itemmaster im left join f_panel_copaymentmaster pc on pc.itemid=im.itemid and pc.panel_id=@panelid and pc.isactive=@isactive WHERE im.`Subcategoryid`=@Subcategoryid AND im.isactive=@isactive ORDER BY typename ",
                new MySqlParameter("@Subcategoryid", deptid),
                new MySqlParameter("@isactive", "1"),
                new MySqlParameter("@deptname", deptname),
                new MySqlParameter("@panelid", panelid)).Tables[0])
                return JsonConvert.SerializeObject(dt);
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

    [WebMethod]
    public static string binddefault(int panelid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string data = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CoPaymentPercentage FROM `f_panel_copaymentmaster` WHERE isactive=@isactive and panel_id=@panel_id and itemid=@itemid and  SubcategoryID=@SubcategoryID",
                new MySqlParameter("@isactive", "1"),
                new MySqlParameter("@panel_id", panelid),
                new MySqlParameter("@itemid", "0"),
                new MySqlParameter("@SubcategoryID", "0")));
            return data;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string savealldata(List<string> dataitem, List<string> datadept, int defaultshare, int panelid,int type)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            if (dataitem.Count > 0)
            {

                if (Util.GetInt(dataitem[0].Split('#')[0]) != panelid)
                {
                    Exception ex = new Exception("Data Mismatch In Item List Please Check Panel");
                    throw (ex);
                }
            }
            if (datadept.Count > 0)
            {

                if (Util.GetInt(datadept[0].Split('#')[0]) != panelid)
                {
                    Exception ex = new Exception("Data Mismatch In Department Please Check Panel");
                    throw (ex);
                }
            }
            if (type==1)
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update f_panel_copaymentmaster set IsActive=@IsActive,UpdateDate=@UpdateDate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where Panel_ID=@Panel_ID and itemid=@itemid and SubcategoryID=@SubcategoryID",
                    new MySqlParameter("@IsActive", "0"),
                    new MySqlParameter("@UpdateDate", DateTime.Now),
                    new MySqlParameter("@UpdateByID", UserInfo.ID),
                    new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                    new MySqlParameter("@Panel_ID", panelid),
                    new MySqlParameter("@itemid", "0"),
                    new MySqlParameter("@SubcategoryID", "0"));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into  f_panel_copaymentmaster(Panel_ID,SubcategoryID,ItemID,CoPaymentPercentage,EntryDate,EntryByID,EntryByName) values(@Panel_ID,@SubcategoryID,@ItemID,@CoPaymentPercentage,@EntryDate,@EntryByID,@EntryByName)",
                             new MySqlParameter("@Panel_ID", panelid),
                             new MySqlParameter("@SubcategoryID", "0"),
                             new MySqlParameter("@ItemID", "0"),
                             new MySqlParameter("@CoPaymentPercentage", defaultshare),
                             new MySqlParameter("@EntryDate", DateTime.Now),
                             new MySqlParameter("@EntryByID", UserInfo.ID),
                             new MySqlParameter("@EntryByName", UserInfo.LoginName));
            }
            else if(type == 2)
            {
                if (datadept.Count > 0)
                {
                    foreach (string indata in datadept)
                    {
                       
                        var Subcategoryid = indata.Split('#')[1];
                        var panel_id = indata.Split('#')[0];
                        var percentage = indata.Split('#')[2];
                        if (Util.GetInt(panel_id) != panelid)
                        {
                            Exception ex = new Exception("Data Mismatch In Department List Please Check Panel");
                            throw (ex);
                        }
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update f_panel_copaymentmaster set IsActive=@IsActive,UpdateDate=@UpdateDate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where Panel_ID=@Panel_ID and SubcategoryID=@SubcategoryID",
                           new MySqlParameter("@IsActive", "0"),
                           new MySqlParameter("@UpdateDate", DateTime.Now),
                           new MySqlParameter("@UpdateByID", UserInfo.ID),
                           new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                           new MySqlParameter("@Panel_ID", panel_id),
                           new MySqlParameter("@SubcategoryID", Subcategoryid));

                        if (Util.GetInt(percentage) > 0)
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into  f_panel_copaymentmaster(Panel_ID,SubcategoryID,ItemID,CoPaymentPercentage,EntryDate,EntryByID,EntryByName) values(@Panel_ID,@SubcategoryID,@ItemID,@CoPaymentPercentage,@EntryDate,@EntryByID,@EntryByName)",
                                 new MySqlParameter("@Panel_ID", panelid),
                                 new MySqlParameter("@SubcategoryID", Subcategoryid),
                                 new MySqlParameter("@ItemID", "0"),
                                 new MySqlParameter("@CoPaymentPercentage", percentage),
                                 new MySqlParameter("@EntryDate", DateTime.Now),
                                 new MySqlParameter("@EntryByID", UserInfo.ID),
                                 new MySqlParameter("@EntryByName", UserInfo.LoginName));
                        }

                    }
                }
            }
            else if (type == 3)
            {
                if (dataitem.Count > 0)
                {
                    foreach (string indata in dataitem)
                    {
                        var itemid = indata.Split('#')[2];
                        var Subcategoryid = indata.Split('#')[1];
                        var panel_id = indata.Split('#')[0];
                        var percentage = indata.Split('#')[3];
                        if (Util.GetInt(panel_id) != panelid)
                        {
                            Exception ex = new Exception("Data Mismatch In Item List Please Check Panel");
                            throw (ex);
                        }
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update f_panel_copaymentmaster set IsActive=@IsActive,UpdateDate=@UpdateDate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where Panel_ID=@Panel_ID and itemid=@itemid",
                           new MySqlParameter("@IsActive", "0"),
                           new MySqlParameter("@UpdateDate", DateTime.Now),
                           new MySqlParameter("@UpdateByID", UserInfo.ID),
                           new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                           new MySqlParameter("@Panel_ID", panel_id),
                           new MySqlParameter("@itemid", itemid));

                        if (Util.GetInt(percentage) > 0)
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into  f_panel_copaymentmaster(Panel_ID,SubcategoryID,ItemID,CoPaymentPercentage,EntryDate,EntryByID,EntryByName) values(@Panel_ID,@SubcategoryID,@ItemID,@CoPaymentPercentage,@EntryDate,@EntryByID,@EntryByName)",
                                 new MySqlParameter("@Panel_ID", panelid),
                                 new MySqlParameter("@SubcategoryID", Subcategoryid),
                                 new MySqlParameter("@ItemID", itemid),
                                 new MySqlParameter("@CoPaymentPercentage", percentage),
                                 new MySqlParameter("@EntryDate", DateTime.Now),
                                 new MySqlParameter("@EntryByID", UserInfo.ID),
                                 new MySqlParameter("@EntryByName", UserInfo.LoginName));
                        }

                    }
                }
            }
           
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            tnx.Rollback();
            return ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string deletesingledata(int id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update f_panel_copaymentmaster set IsActive=@IsActive,UpdateDate=@UpdateDate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where id=@id",
                 new MySqlParameter("@IsActive", "0"),
                 new MySqlParameter("@UpdateDate", DateTime.Now),
                 new MySqlParameter("@UpdateByID", UserInfo.ID), 
                 new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                 new MySqlParameter("@id", id));

            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}