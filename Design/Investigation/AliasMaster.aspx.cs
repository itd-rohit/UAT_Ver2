using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Web.Services;

public partial class Design_Lab_BillChargeReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            if (!IsPostBack)
            {
                if (Request["InvID"] != null)
                {
                    lblInvestigationName.Text = MySqlHelper.ExecuteScalar(con, CommandType.Text, "select TypeName from f_itemmaster where ItemId= @InvID",
                        new MySqlParameter("@InvID", Request["InvID"].ToString())).ToString();
                    hdnInvId.Value = Request["InvID"].ToString();
                }
                else
                {
                    Response.Redirect("ManageInvestigation.aspx");
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    public static string BindAlias(string ItemId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text,
                "SELECT ID,Alias,EnteredByName,DATE_FORMAT(dtEntry,'%d-%b-%y') AS CreatedOn,CASE WHEN Active=0 THEN 'InActive' ELSE 'Active' END AS STATUS FROM f_itemmaster_alias WHERE ItemId=@ItemId ", new MySqlParameter("@ItemId", ItemId)).Tables[0])
            {
                string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                return rtrn;
            }
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
    public static string CheckAliasName(string Alias)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM (SELECT Id FROM f_itemmaster_alias WHERE Alias=@Alias UNION ALL SELECT Id FROM `f_itemmaster` WHERE typeName=@Alias) t",
                new MySqlParameter("@Alias", Alias)));
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
    public static string Add(string ItemId, string Alias)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "INSERT INTO f_itemmaster_alias(Alias,itemid,EnteredBy,EnteredByName) VALUES(@Alias,@ItemId,@ID,@Name)",
                new MySqlParameter("@Alias", Alias),
                new MySqlParameter("@ItemId", ItemId),
                new MySqlParameter("@ID", UserInfo.ID),
                new MySqlParameter("@Name", UserInfo.LoginName));
            Tnx.Commit();
            return "1";
        }
        catch
        {
            Tnx.Rollback();
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
            Tnx.Dispose();
        }
    }

    [WebMethod]
    public static string MarkActiveInActive(string AliasId, string Status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            string str = string.Empty;
            if (Status == "InActive")
                str = "UPDATE f_itemmaster_alias SET Active=0 WHERE Id in (@AliasId)";
            else if (Status == "Active")
                str = "UPDATE f_itemmaster_alias SET Active=1 WHERE Id in (@AliasId)";
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, str.ToString(),
                new MySqlParameter("@AliasId", AliasId));
            Tnx.Commit();
            return "1";
        }
        catch
        {
            Tnx.Rollback();
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
            Tnx.Dispose();
        }


    }
}