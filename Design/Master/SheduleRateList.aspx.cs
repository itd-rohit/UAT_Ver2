using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_EDP_SheduleRateList : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Session["LoginName"] == null)
            {
                Response.Redirect("~/Design/Default.aspx");
            }
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            bindType();
        }
    }

    private void bindType()
    {
       using(DataTable dt = StockReports.GetDataTable(" SELECT ID,Type1 FROM `centre_type1master` WHERE IsActive=1 "))
        ddlType.DataSource = dt;
        ddlType.DataTextField = "Type1";
        ddlType.DataValueField = "ID";
        ddlType.DataBind();
        ddlType.Items.Insert(0, new ListItem("All", "All"));
    }

    private void BindDepartment()
    {
       using(DataTable dt = StockReports.GetDataTable("Select DISTINCT sc.Displayname FROM f_subcategorymaster sc WHERE  active=1 order by Displayname"))
        ddlDepartment0.DataSource = dt;
        ddlDepartment0.DataTextField = "Displayname";
        ddlDepartment0.DataValueField = "Displayname";
        ddlDepartment0.DataBind();
    }

    [WebMethod]
    public static string bindPanel(int BusinessZoneID, string StateID, string TypeOfCentre, int RateType)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("SELECT Concat(Panel_code,' # ', fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#',ifnull(cm.Type1,''),'#',fpm.ReferenceCodeOPD,'#',fpm.PanelShareID)Panel_ID FROM f_panel_master fpm LEFT JOIN  centre_master cm ON cm.CentreID=fpm.CentreID ");
        //if (StateID == "0")
        //{
        //    sb.Append(" WHERE  cm.BusinessZoneID=@BusinessZoneID");
        //}
        //else
        //{
        //    sb.Append(" WHERE  cm.BusinessZoneID=@BusinessZoneID AND cm.StateID=@StateID");
        //}

        sb.Append(" AND cm.IsActive=1 ");
        if (RateType == 1)
            sb.Append(" AND fpm.`Panel_ID`=fpm.`ReferenceCode` ");
       
        if (TypeOfCentre.Trim() != "All")
        {
            sb.Append(" AND cm.Type1=@Type1 ");
        }
        else
        {
            sb.Append(" AND cm.Type1!='CC' ");
        }             

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
           new MySqlParameter("@BusinessZoneID", BusinessZoneID),
           new MySqlParameter("@StateID", StateID),
           new MySqlParameter("@Type1", TypeOfCentre.Trim())).Tables[0])
                if (dt.Rows.Count > 0)
                    return Util.getJson(dt);
                else
                    return "";
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindState(int BusinessZoneID = 0)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,State FROM state_master WHERE BusinessZoneID=@BusinessZoneID AND IsActive=1 ORDER BY state",
           new MySqlParameter("@BusinessZoneID", BusinessZoneID)).Tables[0])
        if (dt.Rows.Count > 0)
            return Util.getJson(dt);
        else
            return "";
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetRateList(string ItemID, string PanelID, int RateType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int RateApplicableForAll = 0;
            if (RateType == 1)
            {
                RateApplicableForAll = 1;
            }

            PanelID = PanelID.TrimEnd(',');
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT rt.ID,pnl.Panel_ID AS PanelID,rt.ItemID AS ItemID,pnl.Company_Name AS PanelName,pnl.Panel_Code AS PanelCode, ");
            sb.Append(" IFNULL(rt.Rate, 0) Rate, IFNULL(rt.FromDate, '') FromDate, IFNULL(rt.ToDate, '') ToDate, IFNULL(item.TestCode, '') TestCode , ");
            sb.Append(" IFNULL(item.TypeName, '') ItemName FROM (SELECT ID, ItemID,Panel_ID,Rate,DATE_FORMAT(FromDate,'%d-%b-%Y')FromDate,DATE_FORMAT(ToDate,'%d-%b-%Y')ToDate FROM f_ratelist_schedule  ");
            sb.Append(" where Panel_ID in(" + PanelID.Split('#')[0] + ")  ");
            sb.Append(" AND  RateApplicableForAll = @RateApplicableForAll ");

            sb.Append(" and IsActive=1 ) rt ");
            sb.Append(" INNER JOIN (SELECT RTRIM(LTRIM(Company_Name)) AS Company_Name,Panel_ID,Panel_Code FROM f_panel_master WHERE Panel_ID in( " + PanelID.Split('#')[0] + ")) AS pnl ON rt.Panel_ID =pnl.panel_ID ");
            sb.Append(" INNER JOIN (SELECT ItemID,TestCode,TypeName FROM f_itemmaster ) item ON item.ItemID=rt.ItemID  ORDER BY FromDate");
           using(DataTable dt =MySqlHelper.ExecuteDataset(con,CommandType.Text,sb.ToString(),
               new MySqlParameter("@RateApplicableForAll",RateApplicableForAll),
               new MySqlParameter("@ItemID", ItemID.Trim())).Tables[0])
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string saveRate(string ItemData, string PanelID, int RateType)
    {
        PanelID = PanelID.TrimEnd(',');

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        int RateApplicableForAll = 0;
        if (RateType == 1)
        {
            RateApplicableForAll = 1;
        }

        try
        {
            int Plenght = Util.GetInt(PanelID.Split(',').Length);
            string[] PanelData = new string[Plenght];
            PanelData = PanelID.Split(',');
            for (int p = 0; p < Plenght; p++)
            {
                ItemData = ItemData.TrimEnd('#');
                int len = Util.GetInt(ItemData.Split('#').Length);
                string[] Item = new string[len];
                Item = ItemData.Split('#');

                string itemID = Util.GetString(Item[0].Split('|')[0].Trim());
                string panelID = PanelData[p].Split('#')[0]; //Util.GetString(Item[0].Split('|')[1].Trim());
                double rate = Util.GetDouble(Item[0].Split('|')[2].Trim());
                string startDate = Util.GetDateTime(Item[0].Split('|')[3].Trim()).ToString("yyyy-MM-dd");
                string endDate = Util.GetDateTime(Item[0].Split('|')[4].Trim()).ToString("yyyy-MM-dd");
                double ClientRate = Util.GetDouble(Item[0].Split('|')[5].Trim());
                string sqlstr = "SELECT Count(1) FROM f_ratelist_schedule WHERE (('" + startDate + "' BETWEEN FromDate AND ToDate) OR ('" + endDate + "' BETWEEN FromDate AND ToDate)) AND ItemID=@ItemID AND Panel_ID=@Panel_ID AND IsActive=1 and RateApplicableForAll = @RateApplicableForAll";
                int Active = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sqlstr,
                    new MySqlParameter("@ItemID",itemID),
                    new MySqlParameter("@Panel_ID", panelID),
                    new MySqlParameter("@RateApplicableForAll", RateApplicableForAll)));
                if (Active > 0)
                {
                    return "2";
                }
                StringBuilder sb = new StringBuilder();

                int s = 0;
                if (PanelData[p].Split('#')[1] == "CC")
                {
                    s = 1;
                }

                for (int j = 0; j <= s; j++)
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO f_ratelist_schedule(Rate,FromDate,ToDate,ItemID,Panel_ID,CreatedBy,CreatedByID,CreatedDate,ReferenceCodeOPD,RateApplicableForAll)");
                    sb.Append(" VALUES(@Rate,@FromDate,@ToDate,@ItemID,@Panel_ID,@CreatedBy,@CreatedByID,@CreatedDate,@ReferenceCodeOPD,@RateApplicableForAll)");
                    MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);

                    cmd.Parameters.AddWithValue("@FromDate", Util.GetDateTime(startDate));
                    cmd.Parameters.AddWithValue("@ToDate", Util.GetDateTime(endDate));
                    cmd.Parameters.AddWithValue("@ItemID", itemID);
                    cmd.Parameters.AddWithValue("@Panel_ID", panelID);
                    cmd.Parameters.AddWithValue("@CreatedBy", UserInfo.UserName);
                    cmd.Parameters.AddWithValue("@CreatedByID", UserInfo.ID);
                    cmd.Parameters.AddWithValue("@CreatedDate", System.DateTime.Now);
                    cmd.Parameters.AddWithValue("@RateApplicableForAll", RateApplicableForAll);

                    if (PanelData[p].Split('#')[1] == "CC")
                    {
                        if (j == 0)
                        {
                            cmd.Parameters.AddWithValue("@ReferenceCodeOPD", PanelData[p].Split('#')[2]);
                            cmd.Parameters.AddWithValue("@Rate", rate);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@ReferenceCodeOPD", PanelData[p].Split('#')[3]);
                            cmd.Parameters.AddWithValue("@Rate", ClientRate);
                        }
                    }
                    else
                    {
                        cmd.Parameters.AddWithValue("@ReferenceCodeOPD", PanelData[p].Split('#')[2]);
                        cmd.Parameters.AddWithValue("@Rate", rate);
                    }
                    cmd.ExecuteNonQuery();
                }
            }

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
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
    public static string getPanelItemRate(string ItemID, string PanelID)
    {
        try
        {
            string Panelname = Util.GetString(StockReports.ExecuteScalar("SELECT concat(Panel_ID,'#',Company_Name) FROM f_panel_master WHERE Panel_ID IN(SELECT ReferenceCodeOpd FROM f_panel_master WHERE Panel_ID='" + PanelID + "')"));
            string Rate = StockReports.ExecuteScalar("select  Round(Rate) from f_ratelist where ItemID='"+ ItemID +"' and Panel_ID='"+ PanelID.Split('#')[0] +"'");
            return Rate +" # "+ Panelname.Split('#')[1] ;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
    }
    [WebMethod]
    public static string updateRate(string ItemID, string PanelID, string UpdateRemarks, string FromDate, string ToDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb_1 = new StringBuilder();
            sb_1.Append(" SELECT *   FROM f_ratelist_schedule where Panel_ID='" + PanelID + "' and ItemID='" + ItemID + "' and FromDate='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' and ToDate='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");
            DataTable dt_LTD_1 = StockReports.GetDataTable(sb_1.ToString());


            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE f_ratelist_schedule SET IsActive=0, UpdateRemarks=@UpdateRemarks,UpdateDate=@UpdateDate,UpdatedID=@UpdateByID,UpdateBy=@UpdateBy where Panel_ID=@Panel_ID and ItemID=@ItemID and FromDate=@FromDate and ToDate=@ToDate");
            MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);
            cmd.Parameters.AddWithValue("@UpdateRemarks", UpdateRemarks);
            cmd.Parameters.AddWithValue("@FromDate", Util.GetDateTime(FromDate));
            cmd.Parameters.AddWithValue("@ToDate", Util.GetDateTime(ToDate));
            cmd.Parameters.AddWithValue("@UpdateDate", System.DateTime.Now);
            cmd.Parameters.AddWithValue("@Panel_ID", PanelID);
            cmd.Parameters.AddWithValue("@ItemID", ItemID);
            cmd.Parameters.AddWithValue("@UpdateByID", UserInfo.ID);
            cmd.Parameters.AddWithValue("@UpdateBy", UserInfo.UserName);
            cmd.ExecuteNonQuery();



            sb_1 = new StringBuilder();
            sb_1.Append(" SELECT *   FROM f_ratelist_schedule where Panel_ID='" + PanelID + "' and ItemID='" + ItemID + "' and FromDate='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + "' and ToDate='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + "'  ");
            //sb_1.Append(" from f_ratelist_PackageDetails fpm left join f_panel_share_items_category psc on psc.Panel_ID=fpm.Panel_ID where fpm.Panel_ID ='" + panelMasterData[0].Panel_ID + "';");

            DataTable dt_LTD_2 = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb_1.ToString()).Tables[0];

            string companyName = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Company_Name  FROM f_panel_master  WHERE Panel_ID='" + PanelID + "' "));
                  

            for (int j = 0; j < dt_LTD_1.Rows.Count; j++)
            {


                for (int i = 0; i < dt_LTD_1.Columns.Count; i++)
                {
                    string _ColumnName = dt_LTD_1.Columns[i].ColumnName;
                    if ((Util.GetString(dt_LTD_1.Rows[j][i]) != Util.GetString(dt_LTD_2.Rows[j][i])))
                    {
                        sb_1 = new StringBuilder();
                        sb_1.Append("  INSERT INTO `patient_labinvestigation_opd_update_status`(`Status`,OLDNAME,`NEWNAME`,UserID,UserName,dtEntry,RoleID,CentreID,Remarks,IpAddress,statusID) ");
                        sb_1.Append("  values('" + companyName + " SheduleRateList Update','" + Util.GetString(dt_LTD_1.Rows[j][i]) + "','" + Util.GetString(dt_LTD_2.Rows[j][i]) + "','" + Util.GetString(HttpContext.Current.Session["ID"]) + "','" + Util.GetString(HttpContext.Current.Session["LoginName"]) + "',NOW(),'" + Util.GetString(HttpContext.Current.Session["RoleID"]) + "','" + Util.GetString(UserInfo.Centre) + "','Change " + dt_LTD_2.Rows[j][i] + " " + _ColumnName + " from " + Util.GetString(dt_LTD_1.Rows[j][i]) + " to " + Util.GetString(dt_LTD_2.Rows[j][i]) + "','" + StockReports.getip() + "','11');  ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb_1.ToString());
                    }
                }
            }


            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
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
    public static string ExportToExcel(string chkall,string PanelID)
    {
        StringBuilder sb=new StringBuilder();
        
            sb.Append(@"SELECT pm.`Panel_Code` ClientCode,pm.`Company_Name` ClientName,
im.`TestCode`,im.`ItemID`,im.`TypeName` ItemName, r.`Rate`,
DATE_FORMAT(r.`FromDate`,'%d-%b-%Y')FromDate,DATE_FORMAT(r.`ToDate`,'%d-%b-%Y')`ToDate`,
(CASE
WHEN r.IsActive=0 THEN 'DeActive'
WHEN r.todate < CURRENT_DATE AND r.IsActive=1 THEN 'Expired'
WHEN r.FromDate > CURRENT_DATE AND r.IsActive=1 THEN CONCAT('Applicable after ',DATEDIFF( r.FromDate,CURRENT_DATE),' Days')
WHEN  r.todate >= CURRENT_DATE  AND r.FromDate <= CURRENT_DATE AND r.IsActive=1 THEN 'Current Applicable'
ELSE '' END )`Status`

FROM `f_ratelist_schedule` r
INNER JOIN f_itemmaster im ON im.`ItemID`=r.`ItemID`
INNER JOIN f_panel_master pm ON pm.`Panel_ID`=r.`Panel_ID` ");
            if (chkall == "0") sb.Append(" and pm.Panel_ID in("+ PanelID.Split('#')[0] +")");
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
            HttpContext.Current.Session["ReportName"] = " ItemWiseRateList";
            return "1";
        }
        else
        {
            return "No Record Found";
        }
    }
}