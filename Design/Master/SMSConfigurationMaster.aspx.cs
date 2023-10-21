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

public partial class Design_Master_SMSConfigurationMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


        }
    }
    public static DataTable bindCentreType()
    {
        return StockReports.GetDataTable("SELECT ID,type1 FROM centre_type1master WHERE IsActive=1");
    }
    [WebMethod]
    public static string bindClientType()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ct.ID,ct.type1,IFNULL(sms.`ID`,'')IsActivate ");
        sb.Append(" FROM centre_type1master ct LEFT JOIN sms_configuration_client sms ON ct.ID=sms.Type1ID ");
        sb.Append(" AND sms.`IsActivate`=1 WHERE ct.IsActive=1 "); sb.Append("");
        return JsonConvert.SerializeObject(new
        {
            status = true,
            CentreType = StockReports.GetDataTable(sb.ToString())
        });
    }

    public static DataTable bindDiscardedClient(MySqlConnection con, int CentreType1ID, int SmsConfigurationID)
    {
        StringBuilder sb1 = new StringBuilder();
        sb1.Append(" SELECT sms.ID,fpm.Panel_ID,fpm.Company_Name FROM f_panel_master fpm ");
        sb1.Append(" INNER JOIN sms_configuration_client sms ON fpm.`Panel_ID`=sms.`Panel_ID` AND IsDiscard=1  ");
        sb1.Append(" WHERE CentreType1ID=@CentreType1ID AND fpm.IsActive=1 AND SmsConfigurationID=@SmsConfigurationID ");

        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString(),
            new MySqlParameter("@CentreType1ID", CentreType1ID),
            new MySqlParameter("@SmsConfigurationID", SmsConfigurationID)).Tables[0];
    }
    public static DataTable bindActivatedClient(MySqlConnection con, int CentreType1ID, int SmsConfigurationID)
    {
        StringBuilder sb1 = new StringBuilder();
        sb1.Append(" SELECT sms.ID,fpm.Panel_ID,fpm.Company_Name FROM f_panel_master fpm ");
        sb1.Append(" INNER JOIN sms_configuration_client sms ON fpm.`Panel_ID`=sms.`Panel_ID` AND IsActivate=1  ");
        sb1.Append(" WHERE CentreType1ID=@CentreType1ID AND fpm.IsActive=1 AND SmsConfigurationID=@SmsConfigurationID ");

        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb1.ToString(),
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
            int isActivatedTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM sms_configuration_client WHERE type1ID=@type1ID AND IsActivate=1 AND Panel_ID=0",
               new MySqlParameter("@type1ID", CentreType1ID)));
            if (isActivatedTypeID > 0)
            {
                sb.Append(" SELECT fpm.Panel_ID,fpm.Company_Name FROM f_panel_master fpm ");
                sb.Append("LEFT JOIN sms_configuration_client sms ON fpm.`Panel_ID`=sms.`Panel_ID` AND IsDiscard=1 AND sms.SmsConfigurationID=@SmsConfigurationID  ");
                sb.Append("WHERE CentreType1ID=@CentreType1ID AND fpm.IsActive=1  AND sms.`ID` IS  NULL");

                ClientActDis = bindDiscardedClient(con, CentreType1ID, SmsConfigurationID);


            }
            else
            {
                sb.Append(" SELECT fpm.Panel_ID,fpm.Company_Name FROM f_panel_master fpm ");
                sb.Append(" LEFT JOIN sms_configuration_client sms ON fpm.`Panel_ID`=sms.`Panel_ID` AND IsActivate=1 AND SmsConfigurationID=@SmsConfigurationID ");
                sb.Append(" WHERE CentreType1ID=@CentreType1ID AND fpm.IsActive=1  AND sms.`ID` IS  NULL");



                ClientActDis = bindActivatedClient(con, CentreType1ID, SmsConfigurationID);
            }
            return JsonConvert.SerializeObject(new
            {
                status = true,
                client = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@CentreType1ID", CentreType1ID),
               new MySqlParameter("@SmsConfigurationID", SmsConfigurationID)).Tables[0],
                isActivatedTypeID = isActivatedTypeID,
                bindClient = ClientActDis,

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
    public static string bindModule()
    {
        return JsonConvert.SerializeObject(new
        {
            status = true,
            response = Util.getJson(StockReports.GetDataTable("SELECT ID,Module,Screen,SMSTrigger,ToWhom1,ToWhom2,ToWhom3,SMSType,IsActive FROM sms_configuration ")),
            CentreType = bindCentreType()
        });

    }
    [WebMethod]
    public static string bindSMSTemplate(int ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Template,ActiveColumns,SQLQuery FROM sms_configuration WHERE ID=@ID",
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
        if (UserInfo.ID != 1)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Yuou donot have access to write SqlQuery" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE sms_configuration SET Template=@Template,SQLQuery=@SQLQuery WHERE ID=@ID",
               new MySqlParameter("@Template", Template),
               new MySqlParameter("@SQLQuery", SQLQuery), new MySqlParameter("@ID", ID));
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
                   SmsConfigurationID,
                   TagTypeID.Split(',')[s],
                   string.Empty,
                   0,
                   0,
                   1,
                    UserInfo.LoginName,
                     UserInfo.ID
                   ));
            }
            sCommand.Append(string.Join(",", Rows));
            sCommand.Append(";");
            using (MySqlCommand myCmd = new MySqlCommand(sCommand.ToString(), con, tnx))
            {
                myCmd.CommandType = CommandType.Text;
                myCmd.ExecuteNonQuery();
            }

            //for (int i = 0; i < TagTypeID.Split(',').Length; i++)
            //{
            //    sb = new StringBuilder();
            //    sb.Append("INSERT INTO sms_configuration_client(SmsConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate)");
            //    sb.Append(" VALUES(@SmsConfigurationID,@type1ID,'',0,0,1)");
            //    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
            //       new MySqlParameter("@SmsConfigurationID", SmsConfigurationID),
            //       new MySqlParameter("@type1ID", TagTypeID.Split(',')[i]));


            //}
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
                   SmsConfigurationID,
                   CentreType1ID,
                   string.Empty,
                   ClientID.Split(',')[s],
                   IsDiscard,
                   IsActivate,
                    UserInfo.LoginName,
                     UserInfo.ID
                   ));
            }
            sCommand.Append(string.Join(",", Rows));
            sCommand.Append(";");
            using (MySqlCommand myCmd = new MySqlCommand(sCommand.ToString(), con, tnx))
            {
                myCmd.CommandType = CommandType.Text;
                myCmd.ExecuteNonQuery();
            }

            //for (int i = 0; i < ClientID.Split(',').Length; i++)
            //{
            //    sb = new StringBuilder();
            //    sb.Append("INSERT INTO sms_configuration_client(SmsConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedBy,CreatedByID)");
            //    sb.Append(" VALUES(@SmsConfigurationID,@type1ID,'',@Panel_ID,@IsDiscard,@IsActivate)");
            //    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
            //       new MySqlParameter("@SmsConfigurationID", SmsConfigurationID),
            //       new MySqlParameter("@Panel_ID", ClientID.Split(',')[i]),
            //       new MySqlParameter("@type1ID", CentreType1ID),
            //       new MySqlParameter("@IsDiscard", IsDiscard),
            //       new MySqlParameter("@IsActivate", IsActivate));


            //}
            tnx.Commit();
            DataTable ClientActDis = new DataTable();
            if (SavingType == "Discard Client")
            {
                ClientActDis = bindActivatedClient(con, CentreType1ID, SmsConfigurationID);
            }
            else
            {
                ClientActDis = bindDiscardedClient(con, CentreType1ID, SmsConfigurationID);
            }
            return JsonConvert.SerializeObject(new { status = true, response = msg, bindClientActDis = ClientActDis });
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
    public static string removeClient(string ClientID, int CentreType1ID, string SavingType, int SmsConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO sms_configuration_client_log(SmsConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedByID,CreatedBy,CreatedDate,UpdatedByID,UpdatedBy) SELECT SmsConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedByID,CreatedBy,CreatedDate,@UpdatedByID,@UpdatedBy FROM sms_configuration_client WHERE Panel_ID=@ClientID AND SmsConfigurationID=@SmsConfigurationID",
                 new MySqlParameter("@ClientID", ClientID),
                 new MySqlParameter("@SmsConfigurationID", SmsConfigurationID),
                 new MySqlParameter("@UpdatedByID", UserInfo.ID),
                 new MySqlParameter("@UpdatedBy", UserInfo.LoginName));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM sms_configuration_client WHERE Panel_ID=@ClientID AND SmsConfigurationID=@SmsConfigurationID",
               new MySqlParameter("@ClientID", ClientID),
               new MySqlParameter("@SmsConfigurationID", SmsConfigurationID));

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
    public static string activeDeactiveSMS(int Active, int SmsConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE sms_configuration SET IsActive=@IsActive WHERE ID=@SmsConfigurationID",
               new MySqlParameter("@SmsConfigurationID", SmsConfigurationID),
               new MySqlParameter("@IsActive", Active));

            return JsonConvert.SerializeObject(new { status = true, response = "Updated Successfully" });

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