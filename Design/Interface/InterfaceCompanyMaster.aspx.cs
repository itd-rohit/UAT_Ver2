using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Interface_InterfaceCompanyMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //AllLoad_Data.getCurrentDate(txtfromdate, txttodate);
            BindBusinessZone();
            BindCentreType();
        }
    }

    private void BindBusinessZone()
    {
        ddlBusinessZone.DataSource = StockReports.GetDataTable("SELECT BusinessZoneID,BusinessZoneName FROM BusinessZone_master WHERE IsActive=1 ORDER BY BusinessZoneName");
        ddlBusinessZone.DataTextField = "BusinessZoneName";
        ddlBusinessZone.DataValueField = "BusinessZoneID";
        ddlBusinessZone.DataBind();
        ddlBusinessZone.Items.Insert(0, new ListItem("", "0"));
    }

    private void BindCentreType()
    {
        ddlCentretype.DataSource = StockReports.GetDataTable("SELECT ID,Type1 FROM centre_Type1master  WHERE IsActive=1 ORDER BY Type1");
        ddlCentretype.DataTextField = "Type1";
        ddlCentretype.DataValueField = "ID";
        ddlCentretype.DataBind();
        ddlCentretype.Items.Insert(0, new ListItem("", "0"));
    }

    [WebMethod(EnableSession = true)]
    public static string Save(List<InterfaceCompanyMaster> data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int ctr = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(1) FROM f_interface_company_master WHERE CompanyName=@CompanyName  ",
                new MySqlParameter("@CompanyName", data[0].CompanyName)));
            if (ctr > 0)
            {
                return "-1";
            }
            StringBuilder sb = new StringBuilder();
            sb.Append("INSERT INTO f_interface_company_master(CompanyName,IsActive,APIUserName,APIPassword,IsWorkOrderIDCreate,`IsPatientIDCreate`,`AllowPrint`,CreatedByID,CreatedBy,IsLetterHead,IsBarCodeRequired,ItemID_AsItdose) ");
            sb.Append("VALUES (@CompanyName,1,@APIUserName,@APIPassword,@IsWorkOrderIDCreate,@IsPatientIDCreate,@AllowPrint,@CreatedByID,@CreatedBy,@IsLetterHead,@IsBarCodeRequired,@ItemID_AsItdose)");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@CompanyName", data[0].CompanyName),
               new MySqlParameter("@APIUserName", data[0].APIUserName),
               new MySqlParameter("@APIPassword", data[0].APIPassword),
               new MySqlParameter("@IsWorkOrderIDCreate", data[0].IsWorkOrderIDCreate),
               new MySqlParameter("@IsPatientIDCreate", data[0].IsPatientIDCreate),
               new MySqlParameter("@AllowPrint", data[0].AllowPrint),
               new MySqlParameter("@CreatedByID", UserInfo.ID),
               new MySqlParameter("@CreatedBy", UserInfo.LoginName),
               new MySqlParameter("@IsLetterHead", data[0].IsLetterHead),
               new MySqlParameter("@IsBarCodeRequired", data[0].IsBarCodeRequired),
               new MySqlParameter("@ItemID_AsItdose", data[0].ItemIDAsItdose));
            int Id = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));
            Tnx.Commit();
            return string.Concat("1#", Id);
        }
        catch
        {
            Tnx.Rollback();
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
    public static string BindState(string BusinessZoneID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT State, id StateId FROM State_master WHERE BusinessZoneId=@BusinessZoneID AND IsActive=1 ORDER BY State",
                new MySqlParameter("@BusinessZoneID", BusinessZoneID)).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindCentreType(string StateId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT Type1,Type1Id FROM centre_master WHERE StateId=@StateId AND IsActive=1 ORDER BY Type1",
               new MySqlParameter("@StateId", StateId)).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindCentre(string StateId, string CentreType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT Distinct pnl.company_name as Centre,CONCAT(cm.CentreId,'#',pnl.Panel_Id,'#',cm.CentreCode) CentreId FROM centre_master cm INNER JOIN f_Panel_master pnl ON pnl.CentreId=cm.CentreId  WHERE  cm.StateId=@StateId AND cm.ISActive=1  ");
            if (CentreType != "7")
            {
                sb.Append(" AND cm.Type1Id=@Type1Id");
            }
            sb.Append(" ORDER BY Centre");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@StateId", StateId),
               new MySqlParameter("@Type1Id", CentreType)).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindPUP(string CentreId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Panel_Id,Company_Name FROM f_panel_master WHERE  TagProcessingLabId=@TagProcessingLabId AND PanelType IN ('PUP','RateType') AND IsActive=1 ORDER BY Company_Name ",
               new MySqlParameter("@TagProcessingLabId", CentreId)).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string SaveMapping(List<InterfaceCompanyMaster> data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int ctr = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(1) FROM Centre_master_interface WHERE Panel_Id=@Panel_Id AND Interface_CompanyName=@CompanyName AND CentreId=@CentreId ",
                   new MySqlParameter("@Panel_Id", data[0].CentreId_Interface),
                   new MySqlParameter("@CompanyName", data[0].CompanyName),
                   new MySqlParameter("@CentreId", data[0].CentreId)));
            if (ctr > 0)
            {
                return "-1";
            }
            string PanelName = Util.GetString(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT Company_Name FROM F_Panel_master WHERE Panel_Id=@Panel_Id LIMIT 1 ",
                new MySqlParameter("@Panel_Id", data[0].CentreId_Interface)));
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO Centre_master_interface(CentreID,CentreId_Interface,Interface_CompanyID,Interface_CompanyName,Interface_CentreName,CentreCode_Interface,UpdateDate,Panel_Id) ");
            sb.Append(" VALUES (@CentreId,@CentreId_Interface,@Interface_CompanyID,@CompanyName,@PanelName,@CentreCode_Interface,NOW(),@Panel_Id); ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@CentreId", data[0].CentreId),
                        new MySqlParameter("@CentreId_Interface", data[0].CentreId_Interface),
                        new MySqlParameter("@Interface_CompanyID", data[0].CompanyID),                                
                        new MySqlParameter("@CompanyName", data[0].CompanyName),
                        new MySqlParameter("@PanelName", PanelName),
                        new MySqlParameter("@CentreCode_Interface", data[0].CentreCode_Interface),
                        new MySqlParameter("@Panel_Id", data[0].CentreId_Interface)
                 );

            Tnx.Commit();
            return "1";
        }
        catch
        {
            Tnx.Rollback();
            con.Close();
            return "0";
        }
        finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}

public class InterfaceCompanyMaster
{
    public string CompanyName { get; set; }
    public string APIUserName { get; set; }
    public string APIPassword { get; set; }
    public Byte IsWorkOrderIDCreate { get; set; }
    public Byte IsPatientIDCreate { get; set; }
    public Byte AllowPrint { get; set; }
    public int CentreId { get; set; }
    public int CentreId_Interface { get; set; }
    public string CentreCode_Interface { get; set; }
    public int Panel_Id { get; set; }
    public int CompanyID { get; set; }
    public Byte IsLetterHead { get; set; }
    public Byte IsBarCodeRequired { get; set; }
    public Byte ItemIDAsItdose { get; set; }
    
}