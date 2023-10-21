using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_CashFlow_CashTransferMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    [WebMethod]
    public static string SearchEmployee(string query)
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT Employee_ID as value,NAME AS label FROM `employee_master` WHERE IsActive=1  AND NAME LIKE '%" + query + "%'"))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string bindBusinessZoneWiseFieldBoy(string BusinessZoneID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT fm.FeildboyID ID,fm.Name  FROM feildboy_master fm  INNER JOIN `fieldboy_zonedetail` fmz ON fmz.`FieldBoyID`=fm.`FeildboyID` ");
        sb.Append(" AND fmz.`ZoneID` IN (" + BusinessZoneID + ") WHERE fm.isactive=1 ORDER BY NAME ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    public class CashTransfer
    {
        public int Employee_ID_To { get; set; }
        public string EmployeeName_To { get; set; }
        public int Employee_ID_By { get; set; }
        public string EmployeeName_By { get; set; }
        public string TypeName { get; set; }
        public int TypeID { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveCashTransfer(object dataCashTransfer)
    {
        List<CashTransfer> CashTransferData = new JavaScriptSerializer().ConvertToType<List<CashTransfer>>(dataCashTransfer);
        using (MySqlConnection con = Util.GetMySqlCon())
        {
            con.Open();
            bool RecordExist = false;
            using (MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable))
            {
                try
                {
                    StringBuilder sb = new StringBuilder();

                    for (int i = 0; i < CashTransferData.Count; i++)
                    {
                        int count = 0;
                        if (CashTransferData[0].TypeID == 2)
                            count = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(1) FROM cash_transfer_master WHERE Employee_ID_To=@Employee_ID_To AND Employee_ID_By=@Employee_ID_By AND IsActive=1 AND TypeID=2 ",
                                new MySqlParameter("@Employee_ID_To", CashTransferData[0].Employee_ID_To), new MySqlParameter("@Employee_ID_By", CashTransferData[i].Employee_ID_By)));
                        else
                            count = Util.GetInt(MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(1) FROM cash_transfer_master WHERE Employee_ID_To=@Employee_ID_To AND IsActive=1 AND TypeID=3",
                                new MySqlParameter("@Employee_ID_To", CashTransferData[0].Employee_ID_To)));

                        if (count == 0)
                        {
                            sb = new StringBuilder();

                            sb.Append(" INSERT INTO cash_transfer_master(Employee_ID_To,EmployeeName_To,TypeID,TypeName,CreatedBy,CreatedByID,Employee_ID_By,EmployeeName_By)");
                            sb.Append(" VALUES(@Employee_ID_To,@EmployeeName_To,@TypeID,@TypeName,@CreatedBy,@CreatedByID,@Employee_ID_By,@EmployeeName_By)");

                            MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@Employee_ID_To", CashTransferData[0].Employee_ID_To), new MySqlParameter("@EmployeeName_To", CashTransferData[0].EmployeeName_To),
                               new MySqlParameter("@TypeID", CashTransferData[0].TypeID), new MySqlParameter("@TypeName", CashTransferData[0].TypeName),
                               new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID),
                               new MySqlParameter("@Employee_ID_By", CashTransferData[i].Employee_ID_By), new MySqlParameter("@EmployeeName_By", CashTransferData[i].EmployeeName_By)
                               );
                        }
                        else
                        {
                            RecordExist = true;
                        }
                    }
                    Tnx.Commit();
                    if (RecordExist)
                        return "0";
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
                    con.Close();
                    con.Dispose();
                    Tnx.Dispose();
                }
            }
        }
    }

    [WebMethod]
    public static string SearchData()
    {
        string str = "SELECT Id,TypeName,EmployeeName_To,EmployeeName_By,CreatedBy,DATE_FORMAT(CreatedDate,'%d-%b-%Y %h:%i %p')CreatedOn FROM cash_transfer_master WHERE IsActive=1 ORDER BY Id DESC ";
        using (DataTable dt = StockReports.GetDataTable(str))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
    }

    [WebMethod(EnableSession = true)]
    public static string Deactivate(string Id)
    {
        try
        {
            string str = "UPDATE cash_transfer_master SET IsActive=0 ,DeactivatedById='" + UserInfo.ID + "',DeactivatedByName='" + UserInfo.LoginName + "',Deactivated_DateTime=NOW() WHERE Id='" + Id + "' ";
            StockReports.ExecuteDML(str);
            return "1";
        }
        catch
        {
            return "0";
        }
    }
}