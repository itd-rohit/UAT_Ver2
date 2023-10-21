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

public partial class Design_Master_SMSConfigurationMasterNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindCentreType();
            chkClient_22_date.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            chkClient_23_date.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }

    }
    public void bindCentreType()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT ID,type1 FROM centre_type1master WHERE IsActive=1 ORDER BY ID+0"))
        {
            if (dt.Rows.Count > 0)
            {

                lstTagType_1.DataSource = dt;
                lstTagType_1.DataTextField = "type1";
                lstTagType_1.DataValueField = "ID";
                lstTagType_1.DataBind();

                lstTagType_2.DataSource = dt;
                lstTagType_2.DataTextField = "type1";
                lstTagType_2.DataValueField = "ID";
                lstTagType_2.DataBind();

                lstTagType_3.DataSource = dt;
                lstTagType_3.DataTextField = "type1";
                lstTagType_3.DataValueField = "ID";
                lstTagType_3.DataBind();

                lstTagType_4.DataSource = dt;
                lstTagType_4.DataTextField = "type1";
                lstTagType_4.DataValueField = "ID";
                lstTagType_4.DataBind();

                lstTagType_5.DataSource = dt;
                lstTagType_5.DataTextField = "type1";
                lstTagType_5.DataValueField = "ID";
                lstTagType_5.DataBind();

                lstTagType_6.DataSource = dt;
                lstTagType_6.DataTextField = "type1";
                lstTagType_6.DataValueField = "ID";
                lstTagType_6.DataBind();

                lstTagType_7.DataSource = dt;
                lstTagType_7.DataTextField = "type1";
                lstTagType_7.DataValueField = "ID";
                lstTagType_7.DataBind();

                lstTagType_8.DataSource = dt;
                lstTagType_8.DataTextField = "type1";
                lstTagType_8.DataValueField = "ID";
                lstTagType_8.DataBind();

                lstTagType_9.DataSource = dt;
                lstTagType_9.DataTextField = "type1";
                lstTagType_9.DataValueField = "ID";
                lstTagType_9.DataBind();

                lstTagType_10.DataSource = dt;
                lstTagType_10.DataTextField = "type1";
                lstTagType_10.DataValueField = "ID";
                lstTagType_10.DataBind();

                lstTagType_11.DataSource = dt;
                lstTagType_11.DataTextField = "type1";
                lstTagType_11.DataValueField = "ID";
                lstTagType_11.DataBind();

                lstTagType_12.DataSource = dt;
                lstTagType_12.DataTextField = "type1";
                lstTagType_12.DataValueField = "ID";
                lstTagType_12.DataBind();

                lstTagType_13.DataSource = dt;
                lstTagType_13.DataTextField = "type1";
                lstTagType_13.DataValueField = "ID";
                lstTagType_13.DataBind();

                lstTagType_14.DataSource = dt;
                lstTagType_14.DataTextField = "type1";
                lstTagType_14.DataValueField = "ID";
                lstTagType_14.DataBind();

                lstTagType_15.DataSource = dt;
                lstTagType_15.DataTextField = "type1";
                lstTagType_15.DataValueField = "ID";
                lstTagType_15.DataBind();

                lstTagType_16.DataSource = dt;
                lstTagType_16.DataTextField = "type1";
                lstTagType_16.DataValueField = "ID";
                lstTagType_16.DataBind();

                lstTagType_17.DataSource = dt;
                lstTagType_17.DataTextField = "type1";
                lstTagType_17.DataValueField = "ID";
                lstTagType_17.DataBind();

                lstTagType_18.DataSource = dt;
                lstTagType_18.DataTextField = "type1";
                lstTagType_18.DataValueField = "ID";
                lstTagType_18.DataBind();

                lstTagType_19.DataSource = dt;
                lstTagType_19.DataTextField = "type1";
                lstTagType_19.DataValueField = "ID";
                lstTagType_19.DataBind();

                lstTagType_20.DataSource = dt;
                lstTagType_20.DataTextField = "type1";
                lstTagType_20.DataValueField = "ID";
                lstTagType_20.DataBind();

                lstTagType_21.DataSource = dt;
                lstTagType_21.DataTextField = "type1";
                lstTagType_21.DataValueField = "ID";
                lstTagType_21.DataBind();

                //lstTagType_22.DataSource = dt;
                //lstTagType_22.DataTextField = "type1";
                //lstTagType_22.DataValueField = "ID";
                //lstTagType_22.DataBind();

                lstTagType_23.DataSource = dt;
                lstTagType_23.DataTextField = "type1";
                lstTagType_23.DataValueField = "ID";
                lstTagType_23.DataBind();

                lstTagType_24.DataSource = dt;
                lstTagType_24.DataTextField = "type1";
                lstTagType_24.DataValueField = "ID";
                lstTagType_24.DataBind();

                lstTagType_25.DataSource = dt;
                lstTagType_25.DataTextField = "type1";
                lstTagType_25.DataValueField = "ID";
                lstTagType_25.DataBind();
            }
        }
    }
    [WebMethod]
    public static string activeDeactiveToWhom(string Active, string SmsConfigurationID, string savingType,string Phone)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO sms_configuration_log (IsActive,Template,ActiveColumns,SQLQuery,IsPatient,IsDoctor,IsEmployee,IsClient,UpdatedByID,UpdatedBy)  ");
            sb.Append(" SELECT IsActive,Template,ActiveColumns,SQLQuery,IsPatient,IsDoctor,IsEmployee,IsClient,@UpdatedByID,@UpdatedBy FROM sms_configuration WHERE ID=@SmsConfigurationID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@SmsConfigurationID", SmsConfigurationID),
                  new MySqlParameter("@UpdatedByID", UserInfo.ID),
                  new MySqlParameter("@UpdatedBy", UserInfo.LoginName)
                  );

            sb = new StringBuilder();
            sb.Append("UPDATE sms_configuration SET ");
            if (savingType == "Patient")
                sb.Append(" IsPatient ");
            else if (savingType == "Doctor")
                sb.Append(" IsDoctor");
            else if (savingType == "Client")
                sb.Append(" IsClient");
            else if (savingType == "Employee")
                sb.Append(" IsEmployee");
            sb.Append(" =@Active,Phone=@Phone WHERE ID=@SmsConfigurationID");
            if (SmsConfigurationID != "22")
                Phone = null;
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@Active", Active),
                  new MySqlParameter("@SmsConfigurationID", SmsConfigurationID),
                  new MySqlParameter("@Phone", Phone));
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string saveTagType(string TagTypeID, string SmsConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO sms_configuration_client_log (SmsConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedByID,CreatedBy,CreatedDate,UpdatedByID,UpdatedBy)  ");
            sb.Append(" SELECT SmsConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedByID,CreatedBy,CreatedDate,@UpdatedByID,@UpdatedBy FROM sms_configuration_client WHERE SmsConfigurationID=@SmsConfigurationID AND type1ID IN (@ID0 ");
            for (int s = 1; s < TagTypeID.Split(',').Length; s++)
            {
                sb.AppendFormat(string.Concat(", @ID", s));
            }
            sb.Append(" );");
            using (MySqlCommand m = new MySqlCommand(sb.ToString(), con, tnx))
            {
                for (int s = 0; s < TagTypeID.Split(',').Length; s++)
                {
                    m.Parameters.Add(new MySqlParameter(string.Concat("@ID", s), TagTypeID.Split(',')[s]));
                }
                m.Parameters.AddWithValue("@SmsConfigurationID", SmsConfigurationID);
                m.Parameters.AddWithValue("@UpdatedByID", UserInfo.ID);
                m.Parameters.AddWithValue("@UpdatedBy", UserInfo.LoginName);
                m.ExecuteNonQuery();
            }
            sb = new StringBuilder();
            sb.Append(" DELETE FROM sms_configuration_client  WHERE SmsConfigurationID=@SmsConfigurationID AND type1ID IN (@ID0 ");
            for (int s = 1; s < TagTypeID.Split(',').Length; s++)
            {
                sb.AppendFormat(string.Concat(", @ID", s));
            }
            sb.Append(" );");
            using (MySqlCommand m = new MySqlCommand(sb.ToString(), con, tnx))
            {
                for (int s = 0; s < TagTypeID.Split(',').Length; s++)
                {
                    m.Parameters.Add(new MySqlParameter(string.Concat("@ID", s), TagTypeID.Split(',')[s]));
                }
                m.Parameters.AddWithValue("@SmsConfigurationID", SmsConfigurationID);
                m.ExecuteNonQuery();
            }
            StringBuilder sCommand = new StringBuilder("INSERT INTO sms_configuration_client (SmsConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedBy,CreatedByID) VALUES ");
            List<string> Rows = new List<string>();
            for (int s = 0; s < TagTypeID.Split(',').Length; s++)
            {
                Rows.Add(string.Format("({0},{1},'{2}',{3},{4},{5},'{6}',{7})",
                   SmsConfigurationID, TagTypeID.Split(',')[s], string.Empty, 0, 0, 1, UserInfo.LoginName, UserInfo.ID
                   ));
            }
            sCommand.Append(string.Join(",", Rows));
            sCommand.Append(";");
            using (MySqlCommand myCmd = new MySqlCommand(sCommand.ToString(), con, tnx))
            {
                myCmd.CommandType = CommandType.Text;
                myCmd.ExecuteNonQuery();
            }
            tnx.Commit();
            Rows.Clear();
            return JsonConvert.SerializeObject(new { status = true, response = "Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string activeDeactiveSMS(int Active, int SmsConfigurationID,DateTime chkClient_22_date, DateTime chkClient_23_date)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            string query = "";
            sb.Append("INSERT INTO sms_configuration_log (IsActive,Template,ActiveColumns,SQLQuery,IsPatient,IsDoctor,IsEmployee,IsClient,UpdatedByID,UpdatedBy)  ");
            sb.Append(" SELECT IsActive,Template,ActiveColumns,SQLQuery,IsPatient,IsDoctor,IsEmployee,IsClient,@UpdatedByID,@UpdatedBy FROM sms_configuration WHERE ID=@SmsConfigurationID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@SmsConfigurationID", SmsConfigurationID),
                  new MySqlParameter("@UpdatedByID", UserInfo.ID),
                  new MySqlParameter("@UpdatedBy", UserInfo.LoginName));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE sms_configuration SET IsActive=@IsActive WHERE ID=@SmsConfigurationID",
               new MySqlParameter("@SmsConfigurationID", SmsConfigurationID),
               new MySqlParameter("@IsActive", Active)
               );
            //For Event Scheduler By Rees
            if (SmsConfigurationID == 22)
            {
                if (Active == 1) {
                    query = @" 
                               CREATE DEFINER=`root`@`localhost` EVENT `dailyCollectionSample` ON SCHEDULE EVERY 1 DAY STARTS @date ON COMPLETION NOT PRESERVE ENABLE DO BEGIN CALL Insert_collection_sms();
                               END
                               ;";
                }else{
                    query = "DROP EVENT dailyCollectionSample";
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query,
                  new MySqlParameter("@SmsConfigurationID", SmsConfigurationID),
                  new MySqlParameter("@IsActive", Active),
                  new MySqlParameter("@date", chkClient_22_date.ToString("yyyy-MM-dd"))
                  
                  );
            }
            if (SmsConfigurationID == 23)
            {
                if (Active == 1)
                {
                    query = @" 
                               CREATE DEFINER=`root`@`localhost` EVENT `dailyCollectionSample` ON SCHEDULE EVERY 1 DAY STARTS @date ON COMPLETION NOT PRESERVE ENABLE DO BEGIN CALL Insert_collection_sms();
                               END
                               ;";
                }
                else
                {
                    query = "DROP EVENT dailyCollectionSample";
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, query,
                  new MySqlParameter("@SmsConfigurationID", SmsConfigurationID),
                  new MySqlParameter("@IsActive", Active),
                  new MySqlParameter("@date", chkClient_23_date.ToString("yyyy-MM-dd"))
                  );
            }

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable bindDiscardedClient(MySqlConnection con, int CentreType1ID, int SmsConfigurationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sms.ID,fpm.Panel_ID,CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name FROM f_panel_master fpm ");
        sb.Append(" INNER JOIN sms_configuration_client sms ON fpm.`Panel_ID`=sms.`Panel_ID` AND IsDiscard=1  ");
        sb.Append(" WHERE CentreType1ID=@CentreType1ID AND fpm.IsActive=1 AND SmsConfigurationID=@SmsConfigurationID ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@CentreType1ID", CentreType1ID),
            new MySqlParameter("@SmsConfigurationID", SmsConfigurationID)).Tables[0];
    }
    [WebMethod]
    public static string bindClientType(int SmsConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT Distinct ct.PanelGroupId ID,ct.PanelGroup type1,IFNULL(sms.`ID`,'')IsActivate ");
            sb.Append(" FROM f_panelGroup ct LEFT JOIN sms_configuration_client sms ON ct.PanelGroupId=sms.Type1ID AND sms.SmsConfigurationID=@SmsConfigurationID");
            sb.Append(" AND sms.`IsActivate`=1 WHERE ct.Active=1 Group by ct.PanelGroupID ORDER BY ct.panelGroupID+0");
            return JsonConvert.SerializeObject(new
            {
                status = true,
                CentreType = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@SmsConfigurationID", SmsConfigurationID)).Tables[0]
            });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable bindActivatedClient(MySqlConnection con, int CentreType1ID, int SmsConfigurationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT sms.ID,fpm.Panel_ID,CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name FROM f_panel_master fpm ");
        sb.Append(" INNER JOIN sms_configuration_client sms ON fpm.`Panel_ID`=sms.`Panel_ID` AND IsActivate=1  ");
        sb.Append(" WHERE CentreType1ID=@CentreType1ID AND fpm.IsActive=1 AND SmsConfigurationID=@SmsConfigurationID ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@CentreType1ID", CentreType1ID),
            new MySqlParameter("@SmsConfigurationID", SmsConfigurationID)).Tables[0];
    }
    [WebMethod]
    public static string bindClient(int CentreType1ID, int SmsConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            DataTable ClientActDis = new DataTable();
            using (ClientActDis as IDisposable)
            {
                int isActivatedTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM sms_configuration_client WHERE type1ID=@type1ID AND SmsConfigurationID=@SmsConfigurationID AND IsActivate=1 AND Panel_ID=0",
                   new MySqlParameter("@type1ID", CentreType1ID),
                   new MySqlParameter("@SmsConfigurationID", SmsConfigurationID)));
                if (isActivatedTypeID > 0)
                {
                    sb.Append(" SELECT fpm.Panel_ID,CONCAT(IFNULL(fpm.Panel_Code,''),' ~ ',fpm.Company_Name)Company_Name FROM f_panel_master fpm ");
                    sb.Append("LEFT JOIN sms_configuration_client sms ON fpm.`Panel_ID`=sms.`Panel_ID` AND IsDiscard=1 AND sms.SmsConfigurationID=@SmsConfigurationID  ");
                    sb.Append("WHERE PanelGroupId=@CentreType1ID AND fpm.IsActive=1  AND sms.`ID` IS  NULL");
                    ClientActDis = bindDiscardedClient(con, CentreType1ID, SmsConfigurationID);
                }
                else
                {
                    sb.Append(" SELECT fpm.Panel_ID,CONCAT(IFNULL(fpm.Panel_Code,''),' ~ ',fpm.Company_Name)Company_Name FROM f_panel_master fpm ");
                    sb.Append(" LEFT JOIN sms_configuration_client sms ON fpm.`Panel_ID`=sms.`Panel_ID` AND IsActivate=1 AND SmsConfigurationID=@SmsConfigurationID ");
                    sb.Append(" WHERE PanelGroupId=@CentreType1ID AND fpm.IsActive=1  AND sms.`ID` IS  NULL");
                    ClientActDis = bindActivatedClient(con, CentreType1ID, SmsConfigurationID);
                }
                return JsonConvert.SerializeObject(new
                {
                    status = true,
                    client = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@CentreType1ID", CentreType1ID),
                   new MySqlParameter("@SmsConfigurationID", SmsConfigurationID)).Tables[0],
                    isActivatedTypeID = isActivatedTypeID,
                    bindClient = Util.getJson(ClientActDis),
                });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string saveClient(string ClientID, int CentreType1ID, string SavingType, int SmsConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            byte IsDiscard = 0;
            byte IsActivate = 0; string msg = string.Empty;
            if (SavingType == "Discard Client")
            {
                //int isActivatedTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM sms_configuration_client WHERE type1ID=@type1ID AND IsActivate=1 AND Panel_ID=0",
                //  new MySqlParameter("@type1ID", CentreType1ID)));
                //if (isActivatedTypeID > 0)
                //{

                //}
                IsDiscard = 1;
                msg = "Client Discarded Successfully";
            }
            else
            {
                //int isDiscardTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM sms_configuration_client WHERE type1ID=@type1ID AND IsDiscard=1",
                // new MySqlParameter("@type1ID", CentreType1ID)));
                //if (isDiscardTypeID > 0)
                //{

                //}
                IsActivate = 1;
                msg = "Client Activated Successfully";
            }
            StringBuilder sb = new StringBuilder();


            StringBuilder sCommand = new StringBuilder("INSERT INTO sms_configuration_client (SmsConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedBy,CreatedByID) VALUES ");
            List<string> Rows = new List<string>();
            for (int s = 0; s < ClientID.Split(',').Length; s++)
            {
                Rows.Add(string.Format("({0},{1},'{2}',{3},{4},{5},'{6}',{7})",
                   SmsConfigurationID, CentreType1ID, string.Empty, ClientID.Split(',')[s], IsDiscard, IsActivate, UserInfo.LoginName, UserInfo.ID
                   ));
            }
            sCommand.Append(string.Join(",", Rows));
            sCommand.Append(";");
            using (MySqlCommand myCmd = new MySqlCommand(sCommand.ToString(), con, tnx))
            {
                myCmd.CommandType = CommandType.Text;
                myCmd.ExecuteNonQuery();
            }
            tnx.Commit();
            DataTable ClientActDis = new DataTable();
            using (ClientActDis as IDisposable)
            {
                if (SavingType == "Discard Client")
                {
                    ClientActDis = bindDiscardedClient(con, CentreType1ID, SmsConfigurationID);
                }
                else
                {
                    ClientActDis = bindActivatedClient(con, CentreType1ID, SmsConfigurationID);
                }
                return JsonConvert.SerializeObject(new { status = true, response = msg, bindClientActDis = Util.getJson(ClientActDis) });
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable bindType()
    {
        return StockReports.GetDataTable("SELECT ID,type1 FROM centre_type1master WHERE IsActive=1 ORDER BY ID+0");
    }
    public static DataTable bindActiveSMSClient()
    {
        return StockReports.GetDataTable("SELECT `SmsConfigurationID`,`type1ID` FROM sms_configuration_client WHERE Panel_ID=0 ");
    }
    [WebMethod]
    public static string bindModule()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(new
            {
                status = true,
                response = Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Module,Screen,SMSTrigger,SMSType,IsActive,IsPatient,IsDoctor,IsClient,IsEmployee,Phone FROM sms_configuration ").Tables[0]),
                CentreType = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,type1 FROM centre_type1master WHERE IsActive=1 ORDER BY ID+0").Tables[0],
                ActiveSMSClient = Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT `SmsConfigurationID`,`type1ID` FROM sms_configuration_client WHERE Panel_ID=0 ").Tables[0])
            });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string removeClient(string ClientID, int CentreType1ID, string SavingType, int SmsConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO sms_configuration_client_log (SmsConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedByID,CreatedBy,CreatedDate,UpdatedByID,UpdatedBy)  ");
            sb.Append(" SELECT SmsConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedByID,CreatedBy,CreatedDate,@UpdatedByID,@UpdatedBy FROM sms_configuration_client WHERE SmsConfigurationID=@SmsConfigurationID AND Panel_ID IN (@ID0 ");
            for (int s = 1; s < ClientID.Split(',').Length; s++)
            {
                sb.AppendFormat(string.Concat(", @ID", s));
            }
            sb.Append(" );");
            using (MySqlCommand m = new MySqlCommand(sb.ToString(), con, tnx))
            {
                for (int s = 0; s < ClientID.Split(',').Length; s++)
                {
                    m.Parameters.Add(new MySqlParameter(string.Concat("@ID", s), ClientID.Split(',')[s]));
                }
                m.Parameters.AddWithValue("@SmsConfigurationID", SmsConfigurationID);
                m.Parameters.AddWithValue("@UpdatedByID", UserInfo.ID);
                m.Parameters.AddWithValue("@UpdatedBy", UserInfo.LoginName);
                m.ExecuteNonQuery();
            }
            sb = new StringBuilder();
            sb.Append(" DELETE FROM sms_configuration_client  WHERE SmsConfigurationID=@SmsConfigurationID AND Panel_ID IN (@ID0 ");
            for (int s = 1; s < ClientID.Split(',').Length; s++)
            {
                sb.AppendFormat(string.Concat(", @ID", s));
            }
            sb.Append(" );");
            using (MySqlCommand m = new MySqlCommand(sb.ToString(), con, tnx))
            {
                for (int s = 0; s < ClientID.Split(',').Length; s++)
                {
                    m.Parameters.Add(new MySqlParameter(string.Concat("@ID", s), ClientID.Split(',')[s]));
                }
                m.Parameters.AddWithValue("@SmsConfigurationID", SmsConfigurationID);
                m.ExecuteNonQuery();
            }
            tnx.Commit();
            DataTable ClientActDis = new DataTable();
            using (ClientActDis as IDisposable)
            {
                if (SavingType == "Remove Discard")
                    ClientActDis = bindDiscardedClient(con, CentreType1ID, SmsConfigurationID);
                else
                    ClientActDis = bindActivatedClient(con, CentreType1ID, SmsConfigurationID);
                return JsonConvert.SerializeObject(new { status = true, response = "Updated Successfully", bindClientActDis = Util.getJson(ClientActDis) });
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindSMSTemplate(int ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Template,ActiveColumns,SQLQuery,SMSTrigger FROM sms_configuration WHERE ID=@ID",
               new MySqlParameter("@ID", ID)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string saveSMSTemplate(int ID, string Template, string SQLQuery)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (UserInfo.ID == 1)
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE sms_configuration SET Template=@Template,SQLQuery=@SQLQuery WHERE ID=@ID",
                    new MySqlParameter("@Template", Template),
                    new MySqlParameter("@SQLQuery", SQLQuery), new MySqlParameter("@ID", ID));
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE sms_configuration SET Template=@Template WHERE ID=@ID",
                    new MySqlParameter("@Template", Template),
                    new MySqlParameter("@SQLQuery", SQLQuery), new MySqlParameter("@ID", ID));
            }
            return JsonConvert.SerializeObject(new { status = true, response = "Record Updated" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}