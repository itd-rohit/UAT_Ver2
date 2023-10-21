using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Web.Services;

public partial class Design_HomeCollection_PhelboChargeMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    public static string savedata(string chargeid, string chargename, string chargeamt)
    {
        MySqlConnection conhc = Util.GetMySqlCon();
        conhc.Open();
        MySqlTransaction tnxhc = conhc.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (chargeid == string.Empty)
            {
                MySqlHelper.ExecuteNonQuery(tnxhc, CommandType.Text, "insert into " + Util.getApp("HomeCollectionDB") + ".hc_PhelboChargeMaster(ChargeName,ChargeAmount,EntryByID,EntryByName,EntryDate) values (@ChargeName,@ChargeAmount,@EntryByID,@EntryByName,@EntryDate)",
                    new MySqlParameter("@ChargeName", chargename),
                    new MySqlParameter("@ChargeAmount", chargeamt),
                    new MySqlParameter("@EntryByID", UserInfo.ID),
                    new MySqlParameter("@EntryByName", UserInfo.LoginName),
                    new MySqlParameter("@EntryDate", DateTime.Now));
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnxhc, CommandType.Text, "update  " + Util.getApp("HomeCollectionDB") + ".hc_PhelboChargeMaster set ChargeName=@ChargeName,ChargeAmount=@ChargeAmount,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName,UpdateDate=@UpdateDate where id=@id",
                    new MySqlParameter("@ChargeName", chargename),
                    new MySqlParameter("@ChargeAmount", chargeamt),
                    new MySqlParameter("@UpdateByID", UserInfo.ID),
                    new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                    new MySqlParameter("@UpdateDate", DateTime.Now),
                    new MySqlParameter("@@id", chargeid));
            }
            tnxhc.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnxhc.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());
        }
        finally
        {
            tnxhc.Dispose();
            conhc.Close();
            conhc.Dispose();
        }
    }

    [WebMethod]
    public static string getdata()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT ID,ChargeName,ChargeAmount, EntryByName, date_format(entrydate,'%d-%b-%Y %h:%i %p') entrydate FROM  " + Util.getApp("HomeCollectionDB") + ".hc_PhelboChargeMaster "));
    }
}