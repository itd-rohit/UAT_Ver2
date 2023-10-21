using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Master_DiscountMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            calFromDate.StartDate = DateTime.Now;
            calToDate.StartDate = DateTime.Now;
            BindZone();
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            Search();
            ddlname.DataSource = StockReports.GetDataTable("SELECT discountID,discountname FROM discount_master WHERE isactive=1 GROUP BY discountID ORDER BY discountname ");
            ddlname.DataValueField = "discountID";
            ddlname.DataTextField = "discountname";
            ddlname.DataBind();
            ddlname.Items.Insert(0, new ListItem("Select", "0"));
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    private void BindZone()
    {
        DataTable dt = AllLoad_Data.loadBusinessZone();
        if (dt.Rows.Count > 0)
        {
            ddlBusinessZone.DataSource = dt;
            ddlBusinessZone.DataTextField = "BusinessZoneName";
            ddlBusinessZone.DataValueField = "BusinessZoneID";
            ddlBusinessZone.DataBind();

            ddlcentretype.DataSource = StockReports.GetDataTable("select ID,Type1 from centre_type1master Where IsActive=1 order by Type1 ");
            ddlcentretype.DataTextField = "Type1";
            ddlcentretype.DataValueField = "ID";
            ddlcentretype.DataBind();
        }
    }

    [WebMethod]
    public static string bindstate(string BusinessZoneID)
    {
        if (BusinessZoneID == "")
            return "";
        DataTable dt = StockReports.GetDataTable("SELECT id,state FROM state_master WHERE IsActive=1 AND BusinessZoneID in (" + BusinessZoneID + ")");
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else

            return "";
    }

    [WebMethod]
    public static string bindCentreMaster(string StateID, string typeID)
    {
        if (StateID == "")
            return "";

        string query = "SELECT CentreID,Centre FROM centre_master WHERE IsActive=1 AND StateID in (" + StateID + ")";
        if (typeID != "")
        {
            query += " and type1ID in (" + typeID + ") ";
        }

        DataTable dt = StockReports.GetDataTable(query);
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return "";
    }

    [WebMethod]
    public static string bindpanel(string CenterID)
    {
        if (CenterID == "")
            return "";

        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT Company_Name, Panel_ID FROM f_panel_master ");
        sb.Append(" WHERE CentreID in (" + CenterID + ") ");
        sb.Append(" AND IsActive=1 ");
        sb.Append(" ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return "";
        }
    }

    [WebMethod]
    public static string saveDiscount(string Record, string Panel)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        Discount obj = new Discount();
        obj = JsonConvert.DeserializeObject<Discount>(Record);
        if (obj.Id == string.Empty)
        {
            int ab =Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(1) FROM discount_master WHERE IsActive=1 AND DiscountName =@DiscountName",
               new MySqlParameter("@DiscountName", obj.DiscountName)));
            if (ab > 0)
            {
                return "3";
            }
        }
        else
        {
            int ab = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(1) FROM discount_master WHERE IsActive=1 AND DiscountName =@DiscountName AND DiscountID<>@DiscountID",
                new MySqlParameter("@DiscountName", obj.DiscountName), new MySqlParameter("@DiscountID", obj.DiscountID)));
            if (ab > 0)
            {
                return "3";
            }
        }
        try
        {
            if (obj.Id == string.Empty)
            {
                var MaxDiscountId = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT MAX(MaxID+1) FROM id_master WHERE GroupName='discount_master'");

                if (Panel == string.Empty)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO discount_master(DiscountName,DiscountPercentage,FromDate,ToDate,FromAge,ToAge,Gender,PanelId,CreatedBy,CreatedByID,CreatedDate,discountID,DiscShareType)VALUES(@DiscountName,@DiscountPer,@FromDate,@ToDate,@FromAge,@ToAge,@Gender,'0',@LoginName,@ID,now(),@MaxDiscountId,@DiscShareType)",
                      new MySqlParameter("@DiscountName", obj.DiscountName), new MySqlParameter("@DiscountPer", obj.DiscountPer),
                      new MySqlParameter("@FromDate", Util.GetDateTime(obj.FromDate).ToString("yyyy-MM-dd")), new MySqlParameter("@ToDate", Util.GetDateTime(obj.ToDate).ToString("yyyy-MM-dd")),
                      new MySqlParameter("@FromAge", obj.FromAge), new MySqlParameter("@ToAge", obj.ToAge),
                      new MySqlParameter("@Gender", obj.Gender), new MySqlParameter("@LoginName", UserInfo.LoginName),
                      new MySqlParameter("@ID", UserInfo.ID), new MySqlParameter("@MaxDiscountId", MaxDiscountId),
                      new MySqlParameter("@DiscShareType", obj.DiscShareType));
                }
                else
                {
                    string[] word = Panel.Split(',');
                    for (int i = 0; i < word.Count(); i++)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO discount_master(DiscountName,DiscountPercentage,FromDate,ToDate,FromAge,ToAge,Gender,PanelId,CreatedBy,CreatedByID,CreatedDate,discountID,DiscShareType)VALUES(@DiscountName,@DiscountPer,@FromDate,@ToDate,@FromAge,@ToAge,@Gender,@PanelId,@LoginName,@ID,now(),@MaxDiscountId,@DiscShareType)",
                           new MySqlParameter("@DiscountName", obj.DiscountName), new MySqlParameter("@DiscountPer", obj.DiscountPer),
                           new MySqlParameter("@FromDate", Util.GetDateTime(obj.FromDate).ToString("yyyy-MM-dd")), new MySqlParameter("@ToDate", Util.GetDateTime(obj.ToDate).ToString("yyyy-MM-dd")),
                           new MySqlParameter("@FromAge", obj.FromAge), new MySqlParameter("@ToAge", obj.ToAge),
                           new MySqlParameter("@Gender", obj.Gender), new MySqlParameter("@LoginName", UserInfo.LoginName),
                           new MySqlParameter("@ID", UserInfo.ID), new MySqlParameter("@MaxDiscountId", MaxDiscountId),
                           new MySqlParameter("@PanelId", word[i]), new MySqlParameter("@DiscShareType", obj.DiscShareType));
                    }
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update  id_master set MaxID=@MaxDiscountId where GroupName='discount_master'",
                   new MySqlParameter("@MaxDiscountId", MaxDiscountId));
                tnx.Commit();
                return "1";
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE  discount_master SET isActive=0, DiscountName=@DiscountName,DiscountPercentage=@DiscountPer,FromDate=@FromDate,ToDate=@ToDate,FromAge=@FromAge,ToAge=@ToAge,Gender=@Gender, UpdateID=@ID, UpDateName=@LoginName, UpDateDate=now(),DiscShareType=@DiscShareType where DiscountID=@DiscountID ");
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT PanelID ,DiscountID FROM discount_master where DiscountID=@DiscountID",
                    new MySqlParameter("@DiscountID", obj.DiscountID)).Tables[0])
                {
                    string[] word = Panel.Split(',');

                    if (Panel == string.Empty)
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update  discount_master set isActive=1, DiscountName='" + obj.DiscountName + "',DiscountPercentage='" + obj.DiscountPer + "',FromDate='" + Util.GetDateTime(obj.FromDate).ToString("yyyy-MM-dd") + "',ToDate='" + Util.GetDateTime(obj.ToDate).ToString("yyyy-MM-dd") + "',FromAge='" + obj.FromAge + "',ToAge='" + obj.ToAge + "',Gender='" + obj.Gender + "',PanelId='0' , UpdateID='" + UserInfo.ID + "', UpDateName='" + UserInfo.LoginName + "', UpDateDate=now() ,DiscShareType='" + obj.DiscShareType + "'where  DiscountID='" + obj.DiscountID + "' ",
                             new MySqlParameter("@DiscountName", obj.DiscountName), new MySqlParameter("@DiscountPer", obj.DiscountPer),
                               new MySqlParameter("@FromDate", Util.GetDateTime(obj.FromDate).ToString("yyyy-MM-dd")), new MySqlParameter("@ToDate", Util.GetDateTime(obj.ToDate).ToString("yyyy-MM-dd")),
                               new MySqlParameter("@FromAge", obj.FromAge), new MySqlParameter("@ToAge", obj.ToAge),
                               new MySqlParameter("@Gender", obj.Gender), new MySqlParameter("@LoginName", UserInfo.LoginName),
                               new MySqlParameter("@ID", UserInfo.ID),
                               new MySqlParameter("@DiscountID", obj.DiscountID), new MySqlParameter("@DiscShareType", obj.DiscShareType));
                    }
                    else
                    {
                        for (int i = 0; i < word.Count(); i++)
                        {
                            DataRow[] count = dt.Select("PanelID = '" + word[i] + "' AND DiscountID='" + obj.DiscountID + "'");

                            if (count.Length != 0)
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update  discount_master set isActive=1, DiscountName=@DiscountName,DiscountPercentage=@DiscountPer,FromDate=@FromDate,ToDate=@ToDate,FromAge=@FromAge,ToAge=@ToAge,Gender=@Gender,PanelId=@PanelId , UpdateID=@ID, UpDateName=@LoginName, UpDateDate=now() ,DiscShareType=@DiscShareType where PanelID = @PanelId AND DiscountID=@DiscountID ",
                                     new MySqlParameter("@DiscountName", obj.DiscountName), new MySqlParameter("@DiscountPer", obj.DiscountPer),
                                 new MySqlParameter("@FromDate", Util.GetDateTime(obj.FromDate).ToString("yyyy-MM-dd")), new MySqlParameter("@ToDate", Util.GetDateTime(obj.ToDate).ToString("yyyy-MM-dd")),
                                 new MySqlParameter("@FromAge", obj.FromAge), new MySqlParameter("@ToAge", obj.ToAge),
                                 new MySqlParameter("@Gender", obj.Gender), new MySqlParameter("@LoginName", UserInfo.LoginName),
                                 new MySqlParameter("@ID", UserInfo.ID), new MySqlParameter("@DiscountID", obj.DiscountID),
                                 new MySqlParameter("@PanelId", word[i]), new MySqlParameter("@DiscShareType", obj.DiscShareType));
                            }
                            else
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO discount_master(DiscountName,DiscountPercentage,FromDate,ToDate,FromAge,ToAge,Gender,PanelId,CreatedBy,CreatedByID,CreatedDate,DiscountId,DiscShareType)VALUES(@DiscountName,@DiscountPer,@FromDate,@ToAge@FromAge,@ToAge,@Gender,@PanelId,@LoginName,@ID,now(),@DiscountID,@DiscShareType)",
                                 new MySqlParameter("@DiscountName", obj.DiscountName), new MySqlParameter("@DiscountPer", obj.DiscountPer),
                                 new MySqlParameter("@FromDate", Util.GetDateTime(obj.FromDate).ToString("yyyy-MM-dd")), new MySqlParameter("@ToDate", Util.GetDateTime(obj.ToDate).ToString("yyyy-MM-dd")),
                                 new MySqlParameter("@FromAge", obj.FromAge), new MySqlParameter("@ToAge", obj.ToAge),
                                 new MySqlParameter("@Gender", obj.Gender), new MySqlParameter("@LoginName", UserInfo.LoginName),
                                 new MySqlParameter("@ID", UserInfo.ID), new MySqlParameter("@DiscountID", obj.DiscountID),
                                 new MySqlParameter("@PanelId", word[i]), new MySqlParameter("@DiscShareType", obj.DiscShareType));
                            }
                        }
                    }
                }

                tnx.Commit();
                return "1";
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string Search()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT if(DiscShareType='0','Client Share','Lab Share')DiscShareType , dm.DiscountID, dm.DiscountName as DiscountName,dm.DiscountPercentage as DiscountPercentage,DATE_FORMAT(dm.FromDate,'%d-%b-%Y')FromDate,DATE_FORMAT(dm.ToDate,'%d-%b-%Y')ToDate,");
        sb.Append(" dm.FromAge,dm.ToAge,  dm.Gender ,createdby,DATE_FORMAT(createddate,'%d-%b-%y %h:%i %p')createddate,(select Updatename from discount_master  where DiscountID=dm.DiscountID and ifnull(Updatename,'')<>'' limit 1) Updatename, (select DATE_FORMAT(Updatedate,'%d-%b-%y %h:%i %p') from discount_master  where DiscountID=dm.DiscountID and ifnull(Updatename,'')<>'' limit 1) Updatedate");
        sb.Append("   FROM discount_master dm  where dm.IsActive=1 ");
        DataTable dt = StockReports.GetDataTable(sb.ToString());
      
            return Util.getJson(dt);
        
    }

    [WebMethod]
    public static string Remove(string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE discount_master SET IsActive=0, UpdateID=@ID, UpdateName=@LoginName,UpdateDate=Now() where DiscountID=@DiscountID",
               new MySqlParameter("@ID", UserInfo.ID), new MySqlParameter("@LoginName", UserInfo.LoginName), new MySqlParameter("@DiscountID", ID));
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

    [WebMethod]
    public static string viewSampleData(string DiscountID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT dm.ID Id,dm.DiscountID,IFNULL(zm.BusinessZoneName,'ALL')BusinessZoneName ");
            sb.Append(" ,IFNULL(sm.state,'ALL')state,IFNULL( pm.Panel_Code,'ALL')Panel_Code,IFNULL(pm.Company_Name,'ALL') AS Company_Name,dm.PanelId,IFNULL(cm.centre,'ALL') AS Centre,IFNULL(cm1.type1,'ALL') AS CentreType    ");
            sb.Append("      FROM discount_master dm   ");
            sb.Append("     LEFT JOIN f_panel_master pm ON pm.Panel_ID=dm.PanelId  ");
            sb.Append("     LEFT JOIN centre_master cm ON pm.CentreID=cm.CentreID  ");
            sb.Append("     LEFT JOIN centre_type1master cm1 ON cm1.id = cm.type1id ");
            sb.Append("     LEFT JOIN state_master sm ON sm.id=cm.stateid  ");
            sb.Append("     LEFT JOIN BusinessZone_master zm ON zm.BusinessZoneID=cm.BusinessZoneID  ");
            sb.Append("   WHERE dm.IsActive=1 AND dm.DiscountID= @DiscountID  ");
            sb.Append("   GROUP BY pm.Panel_ID ORDER BY zm.BusinessZoneName, sm.state,CentreType,Centre , pm.Company_Name  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@DiscountID", DiscountID)).Tables[0])
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

    [WebMethod(EnableSession = true)]
    public static string ShowDetail(string DiscountID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DiscShareType,DiscountID,ifnull(GROUP_CONCAT(DISTINCT pm.Panel_ID),'0') AS PanelID,GROUP_CONCAT(DISTINCT cm.`BusinessZoneID`) AS BusinessZoneID,GROUP_CONCAT(DISTINCT cm.`StateID`) AS StateID, GROUP_CONCAT(DISTINCT cm.CentreID) AS CentreID, GROUP_CONCAT(DISTINCT cm1.id) AS Type1ID, ");
            sb.Append(" dm.Id Id,DiscountName,DiscountPercentage,DATE_FORMAT(FromDate, '%d-%b-%Y') FromDate,DATE_FORMAT(ToDate, '%d-%b-%Y') ToDate, ");
            sb.Append(" FromAge,ToAge,Gender FROM discount_master dm left JOIN f_panel_master pm ON pm.Panel_ID = dm.PanelId ");
            sb.Append(" LEFT JOIN centre_master cm ON pm.CentreID = cm.CentreID ");
            sb.Append(" LEFT JOIN centre_type1master cm1 ON cm1.id = cm.type1id ");
            sb.Append(" LEFT JOIN BusinessZone_master zm ON zm.BusinessZoneID = cm.BusinessZoneID  ");
            sb.Append(" LEFT JOIN state_master sm ON sm.id = cm.stateid WHERE DiscountID =@DiscountID and dm.IsActive=1 GROUP BY DiscountID ");
            sb.Append(" ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@DiscountID", DiscountID)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindDepartment()
    {
        return Util.getJson(StockReports.GetDataTable("SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1  ORDER BY NAME"));
    }

    [WebMethod]
    public static string binditems(string SubCategoryId)
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT ItemID ,TypeName AS ItemName ,TestCode FROM f_itemmaster WHERE subcategoryID='" + SubCategoryId + "'"))
            return Util.getJson(dt);
    }

    [WebMethod]
    public static string GetDiscountItems(string DiscountID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ds.DiscountID,ds.ItemID,item.TypeName AS ItemName ,item.TestCode, dsm.DiscountName,dp.Name AS Department FROM discount_master_item ds");
            sb.Append(" INNER JOIN f_itemmaster item ON item.ItemID=ds.ItemID ");
            sb.Append(" INNER JOIN f_subcategorymaster dp ON dp.SubCategoryID=item.SubCategoryID");
            sb.Append(" INNER JOIN discount_master dsm ON ds.DiscountID=dsm.DiscountID WHERE ds.isActive=1 and ds.DiscountID= @DiscountID GROUP BY ds.itemid order by dp.Name, item.TypeName ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@DiscountID", DiscountID)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string saveItem(string ItemDetail, string DepartmentID, string DiscountID)
    {
        List<ItemData> result = new List<ItemData>();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (DepartmentID == "0")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE discount_master_item SET isActive=1,CreatedByID=@ID,Createdby=@LoginName ");
                sb.Append(" WHERE DiscountID=@DiscountID  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@ID", UserInfo.ID), new MySqlParameter("@LoginName", UserInfo.LoginName),
                  new MySqlParameter("@DiscountID", DiscountID));
                sb = new StringBuilder();
                sb.Append(" INSERT INTO discount_master_item(DiscountID,ItemID,CreatedByID,Createdby) ");
                sb.Append(" SELECT @DiscountID AS DiscountID,im.ItemID,@ID CreatedByID ,@LoginName Createdby  FROM f_itemmaster im  ");
                sb.Append(" LEFT JOIN discount_master_item di ON di.ItemID=im.ItemID AND di.DiscountID=@DiscountID");
                sb.Append(" WHERE im.isactive=1 AND di.ItemID IS NULL;");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@DiscountID", DiscountID), new MySqlParameter("@ID", UserInfo.ID),
                   new MySqlParameter("@LoginName", UserInfo.LoginName), new MySqlParameter("@DiscountID", DiscountID));
                tnx.Commit();
                return "1";
            }
            else
            {
                result = JsonConvert.DeserializeObject<List<ItemData>>(ItemDetail);
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DiscountID, ItemID,IsActive FROM discount_master_item where DiscountID = @DiscountID",
                    new MySqlParameter("@DiscountID", DiscountID)).Tables[0])
                {
                    StringBuilder sb = new StringBuilder();
                    for (int k = 0; k < result.Count; k++)
                    {
                        DataRow[] Active = dt.Select("DiscountID = '" + result[k].DiscountID + "' AND ItemID='" + result[k].ItemID + "' and IsActive=1");

                        if (Active.Length != 0)
                            continue;

                        DataRow[] InActive = dt.Select("DiscountID = '" + result[k].DiscountID + "' AND ItemID='" + result[k].ItemID + "' and IsActive=0");
                        if (InActive.Length != 0)
                        {
                            sb = new StringBuilder();
                            sb.Append(" update discount_master_item set isActive=1,CreatedByID=@ID,Createdby=@LoginName where DiscountID=@DiscountID AND ItemID=@ItemID");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@ID", UserInfo.ID), new MySqlParameter("@LoginName", UserInfo.LoginName),
                                new MySqlParameter("@DiscountID", result[k].DiscountID), new MySqlParameter("@ItemID", result[k].ItemID));
                        }
                        else
                        {
                            sb = new StringBuilder();
                            sb.Append(" INSERT INTO discount_master_item(DiscountID,ItemID,CreatedByID,Createdby) ");
                            sb.Append(" VALUES(@DiscountID,@ItemID,@ID,@LoginName)");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@DiscountID", result[k].DiscountID),
                               new MySqlParameter("@ItemID", result[k].ItemID), new MySqlParameter("@ID", UserInfo.ID),
                               new MySqlParameter("@LoginName", UserInfo.LoginName));
                        }
                    }
                }

                tnx.Commit();
                result.Clear();
                return "1";
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.ToString();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string RemoveItem(string DiscountID, string ItemID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " DELETE FROM  discount_master_item  where DiscountID=@DiscountID AND ItemID=@ItemID",
               new MySqlParameter("@DiscountID", DiscountID), new MySqlParameter("@ItemID", ItemID));
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string RemoveItemAll(string DiscountID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM  discount_master_item  where DiscountID=@DiscountID",
               new MySqlParameter("@DiscountID", DiscountID));
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string RemovePanel(string DiscountID, string PanelID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "DELETE FROM discount_master  where DiscountID=@DiscountID and PanelId=@PanelID",
                 new MySqlParameter("@DiscountID", DiscountID), new MySqlParameter("@PanelID", PanelID));
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

    [WebMethod]
    public static string getcompletedata(string DicountID, string type)
    {
        DataTable dt = new DataTable();
        if (type == "1")
        {
            dt = StockReports.GetDataTable(@"SELECT dm.DiscountID,dm.`DiscountName`,if(DiscShareType='0','Client Share','Lab Share')DiscShareType, dm.`DiscountPercentage`,
          dm.`Gender`,dm.`FromAge`,dm.`ToAge`,DATE_FORMAT(dm.`FromDate`,'%d-%b-%y')FromDate,
          DATE_FORMAT(dm.`ToDate`,'%d-%b-%y')ToDate,IFNULL(zm.BusinessZoneName,'ALL')BusinessZoneName
         ,IFNULL(sm.state,'ALL')State,  IFNULL(cm1.type1,'ALL') AS CentreType,
         IFNULL(cm.centre,'ALL') AS Centre,
         IFNULL( pm.Panel_Code,'ALL')RateTypeCode,
         IFNULL(pm.Company_Name,'ALL') AS RateType
         FROM discount_master dm
         LEFT JOIN f_panel_master pm ON pm.Panel_ID=dm.PanelId
         LEFT JOIN centre_master cm ON pm.CentreID=cm.CentreID
         LEFT JOIN centre_type1master cm1 ON cm1.id = cm.type1id
         LEFT JOIN state_master sm ON sm.id=cm.stateid
         LEFT JOIN BusinessZone_master zm ON zm.BusinessZoneID=cm.BusinessZoneID
         WHERE dm.IsActive=1 AND dm.DiscountID= '" + DicountID + "' GROUP BY pm.Panel_ID ORDER BY zm.BusinessZoneName, sm.state,CentreType,Centre ,pm.Company_Name");
        }
        else
        {
            dt = StockReports.GetDataTable(@"SELECT dsm.DiscountID,dsm.`DiscountName`,if(DiscShareType='0','Client Share','Lab Share')DiscShareType,dsm.`DiscountPercentage`,
dsm.`Gender`,dsm.`FromAge`,dsm.`ToAge`,DATE_FORMAT(dsm.`FromDate`,'%d-%b-%y')FromDate,
DATE_FORMAT(dsm.`ToDate`,'%d-%b-%y')ToDate,
dp.Name AS Department ,
item.TestCode,item.TypeName AS ItemName  FROM discount_master_item ds
INNER JOIN f_itemmaster item ON item.ItemID=ds.ItemID
INNER JOIN f_subcategorymaster dp ON dp.SubCategoryID=item.SubCategoryID
INNER JOIN discount_master dsm ON ds.DiscountID=dsm.DiscountID
         WHERE dsm.IsActive=1 AND dsm.DiscountID= '" + DicountID + "' GROUP BY ds.itemid ORDER BY dp.Name, item.TypeName ");
        }

        if (dt.Rows.Count > 0)
        {
            HttpContext.Current.Session["dtExport2Excel"] = dt;
            if (type == "1")
            {
                HttpContext.Current.Session["ReportName"] = "Discount Centre List";
            }
            else
            {
                HttpContext.Current.Session["ReportName"] = "Discount Test List";
            }
            return "1";
        }
        else
        {
            return "0";
        }
    }

    public class Discount
    {
        public string Id { get; set; }
        public string DiscountID { get; set; }
        public string DiscountName { get; set; }
        public float DiscountPer { get; set; }
        public DateTime FromDate { get; set; }
        public DateTime ToDate { get; set; }
        public int FromAge { get; set; }
        public int ToAge { get; set; }
        public string Gender { get; set; }
        public string DiscShareType { get; set; }
    }

    public class ItemData
    {
        public string ID { get; set; }
        public string ItemID { get; set; }
        public string DiscountID { get; set; }
    }
}