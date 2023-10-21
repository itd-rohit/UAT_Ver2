using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_Master_Centre_Panel : System.Web.UI.Page
{
    protected void Page_Load()
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["centreID"] != null)
            {
                lblCentreID.Text = Common.Decrypt(Request.QueryString["centreID"].Replace(" ","+"));
                string centre = StockReports.ExecuteScalar(string.Format("select Centre from centre_master where centreID='{0}'  ", lblCentreID.Text));
                lblHeder.Text = string.Concat("Panel Mapping With Centre :", centre);
            }
        }
    }

    [WebMethod]
    public static string bindPanel(int CentreID)
    {
        return Util.getJson(StockReports.GetDataTable(string.Format("SELECT CONCAT(panel_code,' ',Company_name)Company_Name,Panel_ID FROM f_panel_master WHERE IsActive=1 and panel_Id not in(SELECT PanelId FROM centre_panel WHERE IsActive=1 AND CentreId='{0}' ) ORDER BY Company_Name", CentreID)));
    }

    [WebMethod]
    public static string bindCentrePanel(int CentreID)
    {
        return Util.getJson(StockReports.GetDataTable(string.Format("SELECT CentreId,PanelId FROM centre_panel WHERE IsActive=1 AND CentreId='{0}' ", CentreID)));
    }

    [WebMethod(EnableSession = true)]
    public static string saveCentrePanel(int CentreID, string ItemData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            ItemData = ItemData.TrimEnd('#');
            int len = Util.GetInt(ItemData.Split('#').Length);
            string[] Item = new string[len];
            Item = ItemData.Split('#');
         //   MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "DELETE FROM centre_panel WHERE CentreId=@CentreId ",
           //     new MySqlParameter("@CentreId", CentreID));
            for (int i = 0; i < len; i++)
            {
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "INSERT INTO centre_panel(CentreId,PanelId,UserId)VALUES(@CentreId,@PanelId,@UserId)",
                     new MySqlParameter("@CentreId", CentreID),
                     new MySqlParameter("@PanelId", Item[i]),
                     new MySqlParameter("@UserId", UserInfo.ID));

            }
            Tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string removeClient(int ID, int centreID, int panelid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE centre_panel SET IsActive=0,UpdateDate=NOW() WHERE ID=@ID and CentreID=@CentreID and PanelID=@PanelID",
                new MySqlParameter("@ID", ID), new MySqlParameter("@CentreID", centreID)
                , new MySqlParameter("@PanelID", panelid));

            return JsonConvert.SerializeObject(new
            {
                status = true,
                responseDetail = Util.getJson(bindDetail(centreID,"", con))
            });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new
            {
                status = false

            });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    public static DataTable bindDetail(int centreID,string Panel, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT fpm.Panel_Code,fpm.Company_Name,cp.ID,fpm.panel_id FROM centre_panel cp ");
        sb.Append(" INNER JOIN `f_panel_master` fpm ON cp.panelid=fpm.panel_id where ");
        sb.Append(" cp.centreID=@centreID and cp.`isActive`=1 and fpm.`IsActive`=1 ");
        if (Panel != "")
        {
            sb.Append(" and (fpm.panel_code like '%" + Panel + "%' or fpm.Company_Name like '%" + Panel + "%')");
        }
        sb.Append(" ORDER BY cp.isDefault+0");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
           new MySqlParameter("@centreID", centreID)).Tables[0];
    }

    [WebMethod]
    public static string bindCentrePanelDetail(int centreID, string Panel)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            return Util.getJson(bindDetail(centreID,Panel, con));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string UpdateClientSNo(List<dataClient> ClientData, int centreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            for (int i = 0; i < ClientData.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " UPDATE centre_panel SET isDefault=@isDefault,UpdateDate=NOW() WHERE ID=@ID ",
                   new MySqlParameter("@isDefault", ClientData[i].SNo), new MySqlParameter("@ID", ClientData[i].ID));
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new
            {
                status = true,
                responseDetail = Util.getJson(bindDetail(centreID,"", con))
            });
        }

        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return JsonConvert.SerializeObject(new
            {
                status = false

            });
        }
        finally
        {
            tnx.Dispose();
            con.Dispose();
            con.Close();
        }
    }
    public class dataClient
    {
        public int ID { get; set; }
        public int SNo { get; set; }
    }
}