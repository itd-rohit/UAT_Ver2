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

public partial class Design_Master_EmailConfigurationMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindCentreType();
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

             
            }
        }
    }
    [WebMethod]
    public static string activeDeactiveToWhom(string Active, string EmailConfigurationID, string savingType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO Email_configuration_log (IsActive,Template,ActiveColumns,SQLQuery,IsPatient,IsDoctor,IsEmployee,IsClient,UpdatedByID,UpdatedBy)  ");
            sb.Append(" SELECT IsActive,Template,ActiveColumns,SQLQuery,IsPatient,IsDoctor,IsEmployee,IsClient,@UpdatedByID,@UpdatedBy FROM Email_configuration WHERE ID=@EmailConfigurationID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@EmailConfigurationID", EmailConfigurationID),
                  new MySqlParameter("@UpdatedByID", UserInfo.ID),
                  new MySqlParameter("@UpdatedBy", UserInfo.LoginName));

            sb = new StringBuilder();
            sb.Append("UPDATE Email_configuration SET ");
            if (savingType == "Patient")
                sb.Append(" IsPatient ");
            else if (savingType == "Doctor")
                sb.Append(" IsDoctor");
            else if (savingType == "Client")
                sb.Append(" IsClient");
            else if (savingType == "Employee")
                sb.Append(" IsEmployee");
            sb.Append(" =@Active WHERE ID=@EmailConfigurationID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@Active", Active),
                  new MySqlParameter("@EmailConfigurationID", EmailConfigurationID));
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
    public static string saveTagType(string TagTypeID, string EmailConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO Email_configuration_client_log (EmailConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedByID,CreatedBy,CreatedDate,UpdatedByID,UpdatedBy)  ");
            sb.Append(" SELECT EmailConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedByID,CreatedBy,CreatedDate,@UpdatedByID,@UpdatedBy FROM Email_configuration_client WHERE EmailConfigurationID=@EmailConfigurationID AND type1ID IN (@ID0 ");
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
                m.Parameters.AddWithValue("@EmailConfigurationID", EmailConfigurationID);
                m.Parameters.AddWithValue("@UpdatedByID", UserInfo.ID);
                m.Parameters.AddWithValue("@UpdatedBy", UserInfo.LoginName);
                m.ExecuteNonQuery();
            }
            sb = new StringBuilder();
            sb.Append(" DELETE FROM Email_configuration_client  WHERE EmailConfigurationID=@EmailConfigurationID AND type1ID IN (@ID0 ");
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
                m.Parameters.AddWithValue("@EmailConfigurationID", EmailConfigurationID);
                m.ExecuteNonQuery();
            }
            StringBuilder sCommand = new StringBuilder("INSERT INTO Email_configuration_client (EmailConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedBy,CreatedByID) VALUES ");
            List<string> Rows = new List<string>();
            for (int s = 0; s < TagTypeID.Split(',').Length; s++)
            {
                Rows.Add(string.Format("({0},{1},'{2}',{3},{4},{5},'{6}',{7})",
                   EmailConfigurationID, TagTypeID.Split(',')[s], string.Empty, 0, 0, 1, UserInfo.LoginName, UserInfo.ID
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
    public static string activeDeactiveEmail(int Active, int EmailConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO Email_configuration_log (IsActive,Template,ActiveColumns,SQLQuery,IsPatient,IsDoctor,IsEmployee,IsClient,UpdatedByID,UpdatedBy)  ");
            sb.Append(" SELECT IsActive,Template,ActiveColumns,SQLQuery,IsPatient,IsDoctor,IsEmployee,IsClient,@UpdatedByID,@UpdatedBy FROM Email_configuration WHERE ID=@EmailConfigurationID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@EmailConfigurationID", EmailConfigurationID),
                  new MySqlParameter("@UpdatedByID", UserInfo.ID),
                  new MySqlParameter("@UpdatedBy", UserInfo.LoginName));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE Email_configuration SET IsActive=@IsActive WHERE ID=@EmailConfigurationID",
               new MySqlParameter("@EmailConfigurationID", EmailConfigurationID),
               new MySqlParameter("@IsActive", Active));
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
    public static DataTable bindDiscardedClient(MySqlConnection con, int CentreType1ID, int EmailConfigurationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Email.ID,fpm.Panel_ID,CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name FROM f_panel_master fpm ");
        sb.Append(" INNER JOIN Email_configuration_client Email ON fpm.`Panel_ID`=Email.`Panel_ID` AND IsDiscard=1  ");
        sb.Append(" WHERE CentreType1ID=@CentreType1ID AND fpm.IsActive=1 AND EmailConfigurationID=@EmailConfigurationID ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@CentreType1ID", CentreType1ID),
            new MySqlParameter("@EmailConfigurationID", EmailConfigurationID)).Tables[0];
    }
    [WebMethod]
    public static string bindClientType(int EmailConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT ct.ID,ct.type1,IFNULL(Email.`ID`,'')IsActivate ");
            sb.Append(" FROM centre_type1master ct LEFT JOIN Email_configuration_client Email ON ct.ID=Email.Type1ID AND Email.EmailConfigurationID=@EmailConfigurationID");
            sb.Append(" AND Email.`IsActivate`=1 WHERE ct.IsActive=1 ORDER BY ct.ID+0");
            return JsonConvert.SerializeObject(new
            {
                status = true,
                CentreType = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@EmailConfigurationID", EmailConfigurationID)).Tables[0]
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
    public static DataTable bindActivatedClient(MySqlConnection con, int CentreType1ID, int EmailConfigurationID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Email.ID,fpm.Panel_ID,CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name FROM f_panel_master fpm ");
        sb.Append(" INNER JOIN Email_configuration_client Email ON fpm.`Panel_ID`=Email.`Panel_ID` AND IsActivate=1  ");
        sb.Append(" WHERE CentreType1ID=@CentreType1ID AND fpm.IsActive=1 AND EmailConfigurationID=@EmailConfigurationID ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@CentreType1ID", CentreType1ID),
            new MySqlParameter("@EmailConfigurationID", EmailConfigurationID)).Tables[0];
    }
    [WebMethod]
    public static string bindClient(int CentreType1ID, int EmailConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            DataTable ClientActDis = new DataTable();
            using (ClientActDis as IDisposable)
            {
                int isActivatedTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM Email_configuration_client WHERE type1ID=@type1ID AND EmailConfigurationID=@EmailConfigurationID AND IsActivate=1 AND Panel_ID=0",
                   new MySqlParameter("@type1ID", CentreType1ID),
                   new MySqlParameter("@EmailConfigurationID", EmailConfigurationID)));
                if (isActivatedTypeID > 0)
                {
                    sb.Append(" SELECT fpm.Panel_ID,CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name FROM f_panel_master fpm ");
                    sb.Append("LEFT JOIN Email_configuration_client Email ON fpm.`Panel_ID`=Email.`Panel_ID` AND IsDiscard=1 AND Email.EmailConfigurationID=@EmailConfigurationID  ");
                    sb.Append("WHERE CentreType1ID=@CentreType1ID AND fpm.IsActive=1  AND Email.`ID` IS  NULL");
                    ClientActDis = bindDiscardedClient(con, CentreType1ID, EmailConfigurationID);
                }
                else
                {
                    sb.Append(" SELECT fpm.Panel_ID,CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name FROM f_panel_master fpm ");
                    sb.Append(" LEFT JOIN Email_configuration_client Email ON fpm.`Panel_ID`=Email.`Panel_ID` AND IsActivate=1 AND EmailConfigurationID=@EmailConfigurationID ");
                    sb.Append(" WHERE CentreType1ID=@CentreType1ID AND fpm.IsActive=1  AND Email.`ID` IS  NULL");
                    ClientActDis = bindActivatedClient(con, CentreType1ID, EmailConfigurationID);
                }
                return JsonConvert.SerializeObject(new
                {
                    status = true,
                    client = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@CentreType1ID", CentreType1ID),
                   new MySqlParameter("@EmailConfigurationID", EmailConfigurationID)).Tables[0],
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
    public static string saveClient(string ClientID, int CentreType1ID, string SavingType, int EmailConfigurationID)
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
                //int isActivatedTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM Email_configuration_client WHERE type1ID=@type1ID AND IsActivate=1 AND Panel_ID=0",
                //  new MySqlParameter("@type1ID", CentreType1ID)));
                //if (isActivatedTypeID > 0)
                //{

                //}
                IsDiscard = 1;
                msg = "Client Discarded Successfully";
            }
            else
            {
                //int isDiscardTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM Email_configuration_client WHERE type1ID=@type1ID AND IsDiscard=1",
                // new MySqlParameter("@type1ID", CentreType1ID)));
                //if (isDiscardTypeID > 0)
                //{

                //}
                IsActivate = 1;
                msg = "Client Activated Successfully";
            }
            StringBuilder sb = new StringBuilder();


            StringBuilder sCommand = new StringBuilder("INSERT INTO Email_configuration_client (EmailConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedBy,CreatedByID) VALUES ");
            List<string> Rows = new List<string>();
            for (int s = 0; s < ClientID.Split(',').Length; s++)
            {
                Rows.Add(string.Format("({0},{1},'{2}',{3},{4},{5},'{6}',{7})",
                   EmailConfigurationID, CentreType1ID, string.Empty, ClientID.Split(',')[s], IsDiscard, IsActivate, UserInfo.LoginName, UserInfo.ID
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
                    ClientActDis = bindDiscardedClient(con, CentreType1ID, EmailConfigurationID);
                }
                else
                {
                    ClientActDis = bindActivatedClient(con, CentreType1ID, EmailConfigurationID);
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
    public static DataTable bindActiveEmailClient()
    {
        return StockReports.GetDataTable("SELECT `EmailConfigurationID`,`type1ID` FROM Email_configuration_client WHERE Panel_ID=0 ");
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
                response = Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Module,Screen,EmailTrigger,EmailType,IsActive,IsPatient,IsDoctor,IsClient,IsEmployee FROM Email_configuration ").Tables[0]),
                CentreType = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,type1 FROM centre_type1master WHERE IsActive=1 ORDER BY ID+0").Tables[0],
                ActiveEmailClient = Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT `EmailConfigurationID`,`type1ID` FROM Email_configuration_client WHERE Panel_ID=0 ").Tables[0])
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
    public static string removeClient(string ClientID, int CentreType1ID, string SavingType, int EmailConfigurationID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO Email_configuration_client_log (EmailConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedByID,CreatedBy,CreatedDate,UpdatedByID,UpdatedBy)  ");
            sb.Append(" SELECT EmailConfigurationID,type1ID,type1,Panel_ID,IsDiscard,IsActivate,CreatedByID,CreatedBy,CreatedDate,@UpdatedByID,@UpdatedBy FROM Email_configuration_client WHERE EmailConfigurationID=@EmailConfigurationID AND Panel_ID IN (@ID0 ");
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
                m.Parameters.AddWithValue("@EmailConfigurationID", EmailConfigurationID);
                m.Parameters.AddWithValue("@UpdatedByID", UserInfo.ID);
                m.Parameters.AddWithValue("@UpdatedBy", UserInfo.LoginName);
                m.ExecuteNonQuery();
            }
            sb = new StringBuilder();
            sb.Append(" DELETE FROM Email_configuration_client  WHERE EmailConfigurationID=@EmailConfigurationID AND Panel_ID IN (@ID0 ");
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
                m.Parameters.AddWithValue("@EmailConfigurationID", EmailConfigurationID);
                m.ExecuteNonQuery();
            }
            tnx.Commit();
            DataTable ClientActDis = new DataTable();
            using (ClientActDis as IDisposable)
            {
                if (SavingType == "Remove Discard")
                    ClientActDis = bindDiscardedClient(con, CentreType1ID, EmailConfigurationID);
                else
                    ClientActDis = bindActivatedClient(con, CentreType1ID, EmailConfigurationID);
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
    public static string bindEmailTemplate(int ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Subject,Template,ActiveColumns,SQLQuery,EmailTrigger FROM Email_configuration WHERE ID=@ID",
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
    public static string saveEmailTemplate(int ID, string Template, string SQLQuery,string Subject)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (UserInfo.ID == 1)
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE Email_configuration SET Template=@Template,SQLQuery=@SQLQuery,Subject=@Subject WHERE ID=@ID",
                    new MySqlParameter("@Template", Template),
                    new MySqlParameter("@Subject", Subject),
                    new MySqlParameter("@SQLQuery", SQLQuery), new MySqlParameter("@ID", ID));
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE Email_configuration SET Template=@Template,Subject=@Subject  WHERE ID=@ID",
                    new MySqlParameter("@Template", Template), new MySqlParameter("@Subject", Subject),
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