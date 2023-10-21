using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Coupon_PCCCouponShare : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");

            ddldepartment.DataSource = StockReports.GetDataTable("SELECT subcategoryid,NAME FROM `f_subcategorymaster` WHERE active=1 ORDER BY NAME  ");
            ddldepartment.DataValueField = "subcategoryid";
            ddldepartment.DataTextField = "NAME";
            ddldepartment.DataBind();
            ddldepartment.Items.Insert(0, new ListItem("Select Department", "0"));
        }
    }


    [WebMethod]
    public static string bindPanel(int BusinessZoneID, int StateID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,concat(fpm.Panel_ID,'#0#',fpm.DiscPercent,'#',fpm.PanelID_MRP,'#',ReferenceCode,'#',Centretype1ID,'#',Centretype1)Panel_ID FROM  f_panel_master fpm  ");
            sb.Append(" WHERE  fpm.BusinessZoneID=@BusinessZoneID AND COCO_FOCO='FOFO' ");
            if (StateID != -1)
                sb.Append("  AND fpm.StateID=@StateID ");
            sb.Append(" AND fpm.Centretype1ID in(8,9) ");
            sb.Append(" ORDER BY fpm.Company_Name");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                         new MySqlParameter("@BusinessZoneID", BusinessZoneID),
                                         new MySqlParameter("@StateID", StateID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return Util.getJson(dt);
                else
                    return null;
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindspecialtest(string panelid, string mrppanelid, string refercode, string couponid, string EntryTypeID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT im.TypeName ItemName,im.TestCode,im.ItemID,st.Rate netshare,ifnull(rl.rate,0) mrp,@panel_id panelid ,@coupanid couponid,");
            sb.Append(" ifnull(fpc.SharePer,'')SharePer,ifnull(fpc.ShareAmt,'')ShareAmt,ifnull(fpc.CreatedBy,'')CreatedBy,if(ifnull(fpc.CreatedDate,'')<>'',date_format(fpc.CreatedDate,'%d-%b-%y %h:%i %p'),'')CreatedDate,ifnull(fpc.ID,'0')  savedid");
            sb.Append(" FROM  f_panel_master_specialtest st INNER JOIN f_ItemMaster im ON im.ItemID=st.ItemID AND st.panel_id=@panel_id AND im.IsActive=1 AND im.booking=1  ");
            sb.Append(" LEFT JOIN f_ratelist rl on rl.itemid=im.itemid AND rl.panel_id=@refercode");
            sb.Append(" LEFT JOIN f_panel_share_items_coupon fpc on fpc.panel_id=@panel_id AND fpc.itemid=im.itemid AND fpc.EntryTypeID=@EntryTypeID AND coupanid=@coupanid");
            sb.Append(" WHERE st.IsActive=1 AND st.EntryTypeID=@EntryTypeID AND st.isverified=1 ORDER BY ifnull(fpc.ID,'0') desc,testcode asc  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                       new MySqlParameter("@panel_id", panelid),
                                       new MySqlParameter("@coupanid", couponid),
                                       new MySqlParameter("@EntryTypeID", EntryTypeID),
                                       new MySqlParameter("@refercode", refercode)).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindcoutest(string panelid, string mrppanelid, string refercode, string couponid, string EntryTypeID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT im.TypeName ItemName,im.TestCode,im.ItemID,if(ifnull(st1.itemid,0)<>0,if(st1.shareper>0,concat(st1.shareper,' %'),st1.shareamt),0) netshare,ifnull(rl.rate,0) mrp,@panel_id panelid ,@coupanid couponid");
            sb.Append(" , ifnull(fpc.SharePer,'')SharePer,ifnull(fpc.ShareAmt,'')ShareAmt,ifnull(fpc.CreatedBy,'')CreatedBy,if(ifnull(fpc.CreatedDate,'')<>'',date_format(fpc.CreatedDate,'%d-%b-%y %h:%i %p'),'')CreatedDate,ifnull(fpc.ID,'0')  savedid");
            sb.Append("   FROM  coupan_testwise st INNER JOIN f_ItemMaster im ON im.ItemID=st.ItemID AND st.coupanid=@coupanid AND im.IsActive=1 AND im.booking=1  ");
            sb.Append("   LEFT JOIN f_ratelist rl on rl.itemid=im.itemid AND rl.panel_id=@refercode");
            sb.Append("   LEFT JOIN f_panel_share_items st1  ON im.ItemID=st1.ItemID AND st1.panel_id=@panel_id AND st1.EntryTypeID=@EntryTypeID AND im.booking=1 ");
            sb.Append("   LEFT JOIN f_panel_share_items_coupon fpc on fpc.panel_id=@panel_id AND fpc.itemid=im.itemid and fpc.EntryTypeID=@EntryTypeID AND fpc.coupanid=@coupanid");
            sb.Append("   ORDER BY ifnull(fpc.ID,'0') desc,testcode asc  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                       new MySqlParameter("@panel_id", panelid),
                                       new MySqlParameter("@coupanid", couponid),
                                       new MySqlParameter("@EntryTypeID", EntryTypeID),
                                       new MySqlParameter("@refercode", refercode)).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindgrouptest(string panelid, string mrppanelid, string refercode, string couponid, string EntryTypeID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT im.TypeName ItemName,im.TestCode,im.ItemID,if(st.shareper>0,concat(st.shareper,' %'),st.shareamt) netshare,ifnull(rl.rate,0) mrp,@panel_id panelid ,@coupanid couponid,");
            sb.Append("ifnull(fpc.SharePer,'')SharePer,ifnull(fpc.ShareAmt,'')ShareAmt,ifnull(fpc.CreatedBy,'')CreatedBy,if(ifnull(fpc.CreatedDate,'')<>'',date_format(fpc.CreatedDate,'%d-%b-%y %h:%i %p'),'')CreatedDate,ifnull(fpc.ID,'0')  savedid");
            sb.Append(" FROM  f_panel_share_items st INNER JOIN f_ItemMaster im ON im.ItemID=st.ItemID AND st.panel_id=@panel_id  AND im.IsActive=1 AND im.booking=1 ");
            sb.Append(" LEFT JOIN f_ratelist rl on rl.itemid=im.itemid and rl.panel_id=@refercode");
            sb.Append(" LEFT JOIN f_panel_share_items_coupon fpc on fpc.panel_id=@panel_id AND fpc.itemid=im.itemid AND fpc.EntryTypeID=@EntryTypeID AND coupanid=@coupanid");
            sb.Append("   WHERE st.IsActive=1 AND st.EntryTypeID=@EntryTypeID and ifnull(pccgroupid,0)<>0  ORDER BY ifnull(fpc.ID,'0') desc,testcode asc  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@panel_id", panelid),
                                              new MySqlParameter("@coupanid", couponid),
                                              new MySqlParameter("@EntryTypeID", EntryTypeID),
                                              new MySqlParameter("@refercode", refercode)).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    public static string bindtestALL(string panelid, string mrppanelid, string departmentid, string refercode, string couponid, string EntryTypeID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT im.TypeName ItemName,im.TestCode,im.ItemID,if(ifnull(st.itemid,0)<>0,if(st.shareper>0,concat(st.shareper,' %'),st.shareamt),0) netshare,ifnull(rl.rate,0) mrp ,@panel_id panelid,@coupanid couponid");
            sb.Append(" , ifnull(fpc.SharePer,'')SharePer,ifnull(fpc.ShareAmt,'')ShareAmt,ifnull(fpc.CreatedBy,'')CreatedBy,if(ifnull(fpc.CreatedDate,'')<>'',date_format(fpc.CreatedDate,'%d-%b-%y %h:%i %p'),'')CreatedDate,ifnull(fpc.ID,'0')  savedid");
            sb.Append("   from f_ItemMaster im ");
            sb.Append("   left join   f_panel_share_items st  ON im.ItemID=st.ItemID AND st.panel_id=@panel_id AND EntryTypeID=@EntryTypeID AND im.booking=1 ");
            sb.Append("   inner join f_ratelist rl on rl.itemid=im.itemid AND rl.panel_id=@refercode");
            sb.Append("   left join f_panel_share_items_coupon fpc on fpc.panel_id=@panel_id AND fpc.itemid=im.itemid AND fpc.EntryTypeID=@EntryTypeID AND coupanid=@coupanid");
            sb.Append("   WHERE im.IsActive=1 and im.subcategoryid='" + departmentid + "'   ");
            sb.Append("   and im.itemid not in (select st.itemid from f_panel_master_specialtest st where  st.panel_id=@panel_id)");
            sb.Append("   and im.itemid not in (select st1.itemid from f_panel_share_items st1 where  st1.panel_id=@panel_id and st1.EntryTypeID=@EntryTypeID and ifnull(st1.pccgroupid,0)<>0)");
            sb.Append("   ORDER BY ifnull(fpc.ID,'0') desc,testcode asc ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@panel_id", panelid),
                                              new MySqlParameter("@coupanid", couponid),
                                              new MySqlParameter("@EntryTypeID", EntryTypeID),
                                              new MySqlParameter("@refercode", refercode)).Tables[0])
                return Util.getJson(dt);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string savealldata(List<string> data, string panelid, string defaultshare, string coupon, string EntryTypeID, string EntryType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (data.Count > 0)
            {
                if (data[0].Split('#')[1] != panelid)
                {
                    Exception ex = new Exception("Data Mismatch Please Try Again");
                    throw (ex);
                }
                if (data[0].Split('#')[4] != coupon)
                {
                    Exception ex = new Exception("Data Mismatch Please Try Again");
                    throw (ex);
                }
            }
            if (Util.GetFloat(defaultshare) > 0)
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_share_items_coupon set DeleteDateTime=now(),DeleteByUser=@DeleteByUser where panel_id=@panelid and coupanid=@coupanid and itemid=0",
                            new MySqlParameter("@panelid", panelid),
                            new MySqlParameter("@DeleteByUser", UserInfo.ID),
                            new MySqlParameter("@coupanid", coupon));
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE from f_panel_share_items_coupon where itemid=0 and panel_id=@panel_id and coupanid=@coupanid",
                            new MySqlParameter("@panel_id", panelid),
                            new MySqlParameter("@coupanid", coupon));


                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT into  f_panel_share_items_coupon(itemid,panel_id,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,CreatedDate,EntryType,EntryTypeID,coupanid,defaultshare) values(@itemid,@panel_id,@SharePer,@ShareAmt,@IsActive,@CreatedByID,@CreatedBy,now(),@EntryType,@EntryTypeID,@coupanid,@defaultshare)",
                             new MySqlParameter("@itemid", "0"),
                             new MySqlParameter("@panel_id", panelid),
                             new MySqlParameter("@SharePer", "0"),
                             new MySqlParameter("@ShareAmt", "0"),
                             new MySqlParameter("@IsActive", "1"),
                             new MySqlParameter("@CreatedByID", UserInfo.ID),
                             new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                             new MySqlParameter("@EntryType", EntryType),
                             new MySqlParameter("@EntryTypeID", EntryTypeID),
                             new MySqlParameter("@coupanid", coupon),
                             new MySqlParameter("@defaultshare", defaultshare));
            }
            if (data.Count > 0)
            {
                foreach (string indata in data)
                {
                    var itemid = indata.Split('#')[0];
                    var discper = indata.Split('#')[2];
                    var discamt = indata.Split('#')[3];
                    var panel_id = indata.Split('#')[1];
                    var couponid = indata.Split('#')[4];
                    if (panel_id != panelid)
                    {
                        Exception ex = new Exception("Data Mismatch Please Try Again");
                        throw (ex);
                    }

                    if (couponid != coupon)
                    {
                        Exception ex = new Exception("Data Mismatch Please Try Again");
                        throw (ex);
                    }
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_share_items_coupon set DeleteDateTime=now(),DeleteByUser=@DeleteByUser where panel_id=@panelid and coupanid=@coupanid and itemid=@itemid",
                                new MySqlParameter("@panelid", panelid),
                                new MySqlParameter("@DeleteByUser", UserInfo.ID),
                                new MySqlParameter("@coupanid", coupon),
                                new MySqlParameter("@itemid", itemid));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE from f_panel_share_items_coupon where itemid=@itemid and panel_id=@panel_id and coupanid=@coupanid",
                                new MySqlParameter("@itemid", itemid),
                                new MySqlParameter("@panel_id", panel_id),
                                new MySqlParameter("@coupanid", couponid));

                    if (discper != "0" || discamt != "0")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT into  f_panel_share_items_coupon(itemid,panel_id,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,CreatedDate,EntryType,EntryTypeID,coupanid,defaultshare) values(@itemid,@panel_id,@SharePer,@ShareAmt,@IsActive,@CreatedByID,@CreatedBy,now(),@EntryType,@EntryTypeID,@coupanid,0)",
                                    new MySqlParameter("@itemid", itemid),
                                    new MySqlParameter("@panel_id", panel_id),
                                    new MySqlParameter("@SharePer", discper),
                                    new MySqlParameter("@ShareAmt", discamt),
                                    new MySqlParameter("@IsActive", "1"),
                                    new MySqlParameter("@CreatedByID", UserInfo.ID),
                                    new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                                    new MySqlParameter("@EntryType", EntryType),
                                    new MySqlParameter("@EntryTypeID", EntryTypeID),
                                    new MySqlParameter("@coupanid", couponid));
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
    public static string bindcoupon(string panelid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT  CONCAT(cm.coupanid,'#',ROUND(IFNULL(fp.defaultshare,0)),'#',cm.type)coupanid,cm.coupanname FROM coupan_master cm INNER JOIN `coupan_applicable_panel` cap ON cap.`CoupanId`=cm.`CoupanId` AND cap.`Panel_id`=@panelid LEFT JOIN `f_panel_share_items_coupon` fp ON fp.`coupanid`=cm.`CoupanId` AND fp.`ItemID`=0 AND fp.`Panel_ID`=@panelid WHERE cm.isactive=1 ORDER BY cm.`CoupanId` ",
                                            new MySqlParameter("@panelid", panelid)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return null;

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


}