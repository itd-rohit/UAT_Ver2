using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Coupon_PCCCouponShareSetAll : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


            ddldepartment.DataSource = StockReports.GetDataTable("SELECT subcategoryid,NAME FROM `f_subcategorymaster` WHERE active=1 ORDER BY NAME  ");
            ddldepartment.DataValueField = "subcategoryid";
            ddldepartment.DataTextField = "NAME";
            ddldepartment.DataBind();
            ddldepartment.Items.Insert(0, new ListItem("Select Department", "0"));
            ddlcoupon.DataSource = StockReports.GetDataTable("SELECT  CONCAT(cm.coupanid,'#0#',cm.type)coupanid,cm.coupanname FROM coupan_master cm WHERE cm.isactive=1 ORDER BY cm.`CoupanId`");
            ddlcoupon.DataValueField = "coupanid";
            ddlcoupon.DataTextField = "coupanname";
            ddlcoupon.DataBind();
            ddlcoupon.Items.Insert(0, new ListItem("Select Coupon", "0"));
        }
    }

    [WebMethod]
    public static string bindpanel(string coupanid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT cp.panel_id,CONCAT(pm.Panel_Code,' ~ ',pm.Company_Name)Company_Name FROM `coupan_applicable_panel` cp  ");
            sb.Append("   INNER JOIN f_panel_master pm ON pm.panel_id=cp.panel_id  ");
            sb.Append("   ");
            sb.Append("  WHERE coupanid=@couponid ");
            sb.Append("  AND pm.Centretype1ID IN(8,9)  and pm.`COCO_FOCO`='FOFO' ");//
            sb.Append("   ORDER BY Company_Name ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@couponid", coupanid.Split('#')[0])).Tables[0])
                if (dt.Rows.Count > 0)
                    return Util.getJson(dt);
                else
                    return null;
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
    public static string bindtestALL(string departmentid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT im.TypeName ItemName,im.TestCode,im.ItemID,");
            sb.Append(" '' SharePer,'' ShareAmt");
            sb.Append("   from f_ItemMaster im ");
            sb.Append("   WHERE im.IsActive=1 and im.subcategoryid=@departmentid and im.booking=1  ");
            sb.Append("   ORDER BY testcode asc ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@departmentid", departmentid)).Tables[0])
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
    public static string bindcoutest(string couponid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT im.TypeName ItemName,im.TestCode,im.ItemID,");
            sb.Append(" '' SharePer,'' ShareAmt");
            sb.Append("   FROM  coupan_testwise st INNER JOIN f_ItemMaster im ON im.ItemID=st.ItemID and st.coupanid=@couponid and im.IsActive=1 and im.booking=1  ");
            sb.Append("   ORDER BY testcode asc  ");
             using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                               new MySqlParameter("@couponid", couponid)).Tables[0])
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
    public static string savealldata(List<string> data, List<string> panelid, string defaultshare, string couponid)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            foreach (string panelid_id in panelid)
            {

                if (Util.GetFloat(defaultshare) > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_share_items_coupon set DeleteDateTime=now(),DeleteByUser=@DeleteByUser where panel_id=@panel_id and coupanid=@coupanid and itemid=0",
                        new MySqlParameter("@DeleteByUser", UserInfo.ID),
                        new MySqlParameter("@panel_id", panelid_id),
                        new MySqlParameter("@coupanid", couponid));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE from f_panel_share_items_coupon where itemid=0 and panel_id=@panel_id and coupanid=@coupanid",
                                new MySqlParameter("@panel_id", panelid_id),
                                new MySqlParameter("@coupanid", couponid));


                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT into  f_panel_share_items_coupon(itemid,panel_id,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,CreatedDate,EntryType,coupanid,defaultshare) values(@itemid,@panel_id,@SharePer,@ShareAmt,@IsActive,@CreatedByID,@CreatedBy,now(),@EntryType,@coupanid,@defaultshare)", new MySqlParameter("@itemid", "0"),
                                 new MySqlParameter("@panel_id", panelid_id),
                                 new MySqlParameter("@SharePer", "0"),
                                 new MySqlParameter("@ShareAmt", "0"),
                                 new MySqlParameter("@IsActive", "1"),
                                 new MySqlParameter("@CreatedByID", UserInfo.ID),
                                 new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                                 new MySqlParameter("@EntryType", "PCC"),
                                 new MySqlParameter("@coupanid", couponid),
                                 new MySqlParameter("@defaultshare", defaultshare));
                }

                if (data.Count > 0)
                {
                    foreach (string indata in data)
                    {
                        var itemid = indata.Split('#')[0];
                        var discper = indata.Split('#')[1];
                        var discamt = indata.Split('#')[2];


                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_share_items_coupon set DeleteDateTime=now(),DeleteByUser=@DeleteByUser where panel_id=@panel_id and coupanid=@couponid and itemid=@itemid",
                                    new MySqlParameter("@DeleteByUser", UserInfo.ID),
                                    new MySqlParameter("@panel_id", panelid_id),
                                    new MySqlParameter("@couponid", couponid),
                                    new MySqlParameter("@itemid", itemid));
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE from f_panel_share_items_coupon where itemid=@itemid and panel_id=@panel_id and coupanid=@coupanid",
                                    new MySqlParameter("@itemid", itemid),
                                    new MySqlParameter("@panel_id", panelid_id),
                                    new MySqlParameter("@coupanid", couponid));

                        if (discper != "0" || discamt != "0")
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT into  f_panel_share_items_coupon(itemid,panel_id,SharePer,ShareAmt,IsActive,CreatedByID,CreatedBy,CreatedDate,EntryType,coupanid,defaultshare) values(@itemid,@panel_id,@SharePer,@ShareAmt,@IsActive,@CreatedByID,@CreatedBy,now(),@EntryType,@coupanid,0)", 
                                        new MySqlParameter("@itemid", itemid),
                                        new MySqlParameter("@panel_id", panelid_id),
                                        new MySqlParameter("@SharePer", discper),
                                        new MySqlParameter("@ShareAmt", discamt),
                                        new MySqlParameter("@IsActive", "1"),
                                        new MySqlParameter("@CreatedByID", UserInfo.ID),
                                        new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                                        new MySqlParameter("@EntryType", "PCC"),
                                        new MySqlParameter("@coupanid", couponid));
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
    public static string getoldsharedata(string couponid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT CONCAT(pm.`Panel_Code`,'~',pm.`Company_Name`)panelname,'Default Share' itemname,fc.ItemID,  ");
            sb.Append(" 0 shareper,0 shareamt,defaultshare  ");
            sb.Append(" FROM `f_panel_share_items_coupon` fc  ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=fc.`Panel_ID`  ");
            sb.Append(" WHERE fc.coupanid=@couponid AND fc.`IsActive`=1 AND fc.`ItemID`=0  ");
            sb.Append(" UNION ALL  ");
            sb.Append(" SELECT CONCAT(pm.`Panel_Code`,'~',pm.`Company_Name`)panelname,CONCAT(im.`TestCode`,'~',im.`TypeName`) itemname,fc.ItemID,  ");
            sb.Append(" shareper,shareamt,defaultshare  ");
            sb.Append(" FROM `f_panel_share_items_coupon` fc  ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=fc.`Panel_ID`  ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=fc.`ItemID`  ");
            sb.Append(" WHERE fc.coupanid=@couponid AND fc.`IsActive`=1  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@couponid", couponid)).Tables[0])
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
    public static string exportdatatoexcel(string couponid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT cp.CoupanName,cp.CoupanType,cp.CoupanCategory,cp.IssueType,if(cp.type=1,'Total Bill','Item Wise') BillType,  ");
            sb.Append(" CONCAT(pm.`Panel_Code`,'~',pm.`Company_Name`)panelname,'Default Share' itemname,fc.ItemID,  ");
            sb.Append(" 0 shareper,0 shareamt,defaultshare  ");
            sb.Append(" FROM `f_panel_share_items_coupon` fc  ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=fc.`Panel_ID`  ");
            sb.Append(" INNER JOIN coupan_master cp ON cp.`CoupanId`=fc.`coupanid`  ");
            sb.Append(" WHERE fc.coupanid=@couponid AND fc.`IsActive`=1 AND fc.`ItemID`=0  ");
            sb.Append(" UNION ALL  ");
            sb.Append(" SELECT cp.CoupanName,cp.CoupanType,cp.CoupanCategory,cp.IssueType,if(cp.type=1,'Total Bill','Item Wise') BillType,  ");
            sb.Append(" CONCAT(pm.`Panel_Code`,'~',pm.`Company_Name`)panelname,CONCAT(im.`TestCode`,'~',im.`TypeName`) itemname,fc.ItemID,  ");
            sb.Append(" shareper,shareamt,defaultshare  ");
            sb.Append(" FROM `f_panel_share_items_coupon` fc  ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=fc.`Panel_ID`  ");
            sb.Append(" INNER JOIN coupan_master cp ON cp.`CoupanId`=fc.`coupanid`  ");
            sb.Append(" INNER JOIN f_itemmaster im ON im.`ItemID`=fc.`ItemID`  ");
            sb.Append(" WHERE fc.coupanid=@couponid AND fc.`IsActive`=1  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@couponid", couponid)).Tables[0])
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
                if (dt.Rows.Count > 0)
                {

                    ExcelDownload excel = new ExcelDownload();
                    byte[] data = excel.DownloadExcel(dt);
                    if (data != null)
                    {
                        return JsonConvert.SerializeObject(new { status = true, data = new { filename = "CouponShareReport.xlsx", blob = data } });
                    }
                    return JsonConvert.SerializeObject(new { status = false, data = "No Data Found" });
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, data = "No Data Found" });
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, data = "Error" });

        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }


}