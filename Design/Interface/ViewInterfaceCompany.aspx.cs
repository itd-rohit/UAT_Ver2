using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Master_ViewInterfaceCompany : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCompany();
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
    private void BindCompany()
    {
        ddlCompany.DataSource = StockReports.GetDataTable("SELECT CompanyName FROM  f_interface_company_master WHERE IsActive=1 ORDER BY CompanyName");
        ddlCompany.DataTextField = "CompanyName";
        ddlCompany.DataValueField = "CompanyName";
        ddlCompany.DataBind();
        ddlCompany.Items.Insert(0, new ListItem("", "0"));
    }


    [WebMethod]
    public static string Search(string CompanyName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT IC.ID,IC.`CompanyName`,IC.`APIUserName`,IC.`APIPassword`,IC.`IsWorkOrderIDCreate`,IC.`IsPatientIDCreate`,IC.`AllowPrint`,IC.IsLetterHead,IC.IsBarcodeRequired,IC.ItemID_AsItdose ");
            sb.Append(" ,CMI.ID `CMID`,CM.BusinessZoneName,CM.Centre,CMI.`CentreID`,pnl.Company_Name,CMI.`CentreId_interface`,CMI.`CentreCode_interface`,CM.`BusinessZoneID`,CM.Type1Id ");
            sb.Append(" FROM  f_interface_company_master IC ");
            sb.Append(" LEFT JOIN Centre_master_interface CMI ON IC.`CompanyName`=CMI.`Interface_companyName`  ");
            sb.Append(" LEFT JOIN Centre_Master CM ON CMI.`CentreID`=CM.`CentreID` ");
            sb.Append(" LEFT JOIN F_panel_master pnl ON pnl.Panel_Id=CMI.Panel_Id ");

            sb.Append(" WHERE IC.IsActive=1 AND  IC.`CompanyName`=@CompanyName ORDER BY IC.CompanyName ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CompanyName", CompanyName)).Tables[0])
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
    public static string Update(int IsWorkOrderIDCreate, int IsPatientIDCreate, int AllowPrint, int ID, int IsLetterHead, int IsBarcodeRequired, int ItemID_AsItdose)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "Update f_interface_company_master SET IsWorkOrderIDCreate = @IsWorkOrderIDCreate,IsPatientIDCreate = @IsPatientIDCreate,AllowPrint = @AllowPrint,IsLetterHead=@IsLetterHead,IsBarcodeRequired=@IsBarcodeRequired,ItemID_AsItdose=@ItemID_AsItdose WHERE ID=@ID",
               new MySqlParameter("@IsWorkOrderIDCreate", IsWorkOrderIDCreate),
               new MySqlParameter("@IsPatientIDCreate", IsPatientIDCreate),
               new MySqlParameter("@AllowPrint", AllowPrint),
               new MySqlParameter("@ID", ID),
               new MySqlParameter("@IsLetterHead", IsLetterHead),
               new MySqlParameter("@IsBarcodeRequired", IsBarcodeRequired),
               new MySqlParameter("@ItemID_AsItdose", ItemID_AsItdose));
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
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string RemoveTagging(int ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "DELETE FROM Centre_master_interface WHERE ID=@ID",
               new MySqlParameter("@ID", ID));
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
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    public static string Remove(int ID, string CompanyName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int TotalCount = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(1) TotalCount FROM f_ledgertransaction WHERE Interface_CompanyName=@Interface_CompanyName AND `IsCancel`=0",
               new MySqlParameter("@Interface_CompanyName", CompanyName)));
            if (TotalCount > 0)
            {
                return "-1";
            }
            StringBuilder sb = new StringBuilder();
            sb.Append(" DELETE CMI.*  FROM Centre_master_interface CMI ");
            sb.Append(" INNER JOIN f_interface_company_master IC  ON IC.`CompanyName`=CMI.`Interface_companyName` AND IC.`APIUserName`=CMI.`Interface_CentreName` ");
            sb.Append(" WHERE IC.`ID`=@ID AND IC.`CompanyName`=@CompanyName ");
            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ID", ID),
                new MySqlParameter("@CompanyName", CompanyName));

            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, "DELETE FROM f_interface_company_master WHERE ID=@ID",
               new MySqlParameter("@ID", ID));
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
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
  
    [WebMethod]
    public static string ViewCredentials(string ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT CMI.`CentreID_interface`,IC.CompanyName `Interface_CentreName`,IC.`APIUserName`,IC.`APIPassword` FROM Centre_master_interface CMI ");
            sb.Append(" INNER JOIN  f_interface_company_master IC ON CMI.`Interface_companyName`=IC.`CompanyName` ");
            sb.Append(" WHERE CMI.ID=@ID");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@ID", ID)).Tables[0])
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
  
}
public class InterfaceCompanyMaster1
{

    public string CompanyName { get; set; }
    public string APIUserName { get; set; }
    public string APIPassword { get; set; }
    public Byte IsWorkOrderIDCreate { get; set; }
    public Byte IsPatientIDCreate { get; set; }
    public int AllowPrint { get; set; }
    public int CentreId { get; set; }
    public int CentreId_Interface { get; set; }
    public string CentreCode_Interface { get; set; }
    public int Panel_Id { get; set; }
    public int CompanyID { get; set; }
    public Byte IsLetterHead { get; set; }
    public Byte IsBarCodeRequired { get; set; }
    public Byte ItemIDAsItdose { get; set; }

}