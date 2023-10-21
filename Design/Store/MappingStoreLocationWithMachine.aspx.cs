using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Store_MappingStoreLocationWithMachine : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string bindmachine()
    {

        DataTable dt = StockReports.GetDataTable("SELECT ID, NAME FROM macmaster where id<>1 ORDER BY Name");
        string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        return rtrn;
    }


    [WebMethod(EnableSession = true)]
    public static string SaveData(string[] Machines, string[] Centres)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {

            string Command = "INSERT INTO st_centretomachinemapping (LocationId,MachineId,CreatedBy,IsActive) VALUES (@CentreId,@MachineId,@CreatedBy,@IsActive);";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "delete from st_centretomachinemapping where LocationId in (" + string.Join(",", Centres) + ") and MachineId in(" + string.Join(",", Machines) + ")");
            using (MySqlCommand myCmd = new MySqlCommand(Command, con, Tranx))
            {
                myCmd.CommandType = CommandType.Text;
                for (int i = 0; i < Centres.Length; i++)
                {
                    for (int j = 0; j < Machines.Length; j++)
                    {

                        myCmd.Parameters.Clear();
                        myCmd.Parameters.AddWithValue("@CentreId", Centres[i]);
                        myCmd.Parameters.AddWithValue("@MachineId", Machines[j]);
                        myCmd.Parameters.AddWithValue("@CreatedBy", UserInfo.ID);
                        myCmd.Parameters.AddWithValue("@IsActive", "1");
                        myCmd.ExecuteNonQuery();

                    }
                }
                Tranx.Commit();
            }
            return "1";

        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod(EnableSession = true)]
    public static string DeleteRows(string Id)
    {
        StockReports.ExecuteScalar("delete from st_centretomachinemapping  where Id in(" + Id + ")");
        return "1";

    }


    [WebMethod(EnableSession = true)]
    public static string SearchData(string Machine, string location)
    {


        Machine = Machine.Replace("\"", "").Replace("[", "").Replace("]", "");
        location = location.Replace("\"", "").Replace("[", "").Replace("]", "");

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT st.id mapid, ");
        sb.Append(" (SELECT centre FROM centre_master WHERE centreid=pm.centreid) Centre,");
        sb.Append(" st.LocationId LocationID,sl.`Location`,");
        sb.Append(" st.`MachineId`,im.Name MachineName  FROM st_centretomachinemapping st ");
        sb.Append(" INNER JOIN macmaster im ON im.`ID`=st.`MachineId` ");
        if (Machine != "")
        {
            sb.Append(" and st.MachineId in (" + Machine + ")");
        }
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.`LocationID`=st.`LocationId` ");

        if (location != "")
        {
            sb.Append(" and sl.`LocationID` in (" + location + ")");
        }
        sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=sl.`panel_id` ");
        sb.Append(" ORDER BY location,MachineName ");


        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));


    }


    [WebMethod(EnableSession = true)]
    public static string ExportToExcel(string Machine, string location)
    {
        Machine = Machine.Replace("\"", "").Replace("[", "").Replace("]", "");
        location = location.Replace("\"", "").Replace("[", "").Replace("]", "");

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT st.id mapid, ");
        sb.Append(" (SELECT centre FROM centre_master WHERE centreid=pm.centreid) Centre,");
        sb.Append(" st.LocationId LocationID,sl.`Location`,");
        sb.Append(" st.`MachineId`,im.Name MachineName  FROM st_centretomachinemapping st ");
        sb.Append(" INNER JOIN macmaster im ON im.`ID`=st.`MachineId` ");
        if (Machine != "")
        {
            sb.Append(" and st.MachineId in (" + Machine + ")");
        }
        sb.Append(" INNER JOIN st_locationmaster sl ON sl.`LocationID`=st.`LocationId` ");

        if (location != "")
        {
            sb.Append(" and sl.`LocationID` in (" + location + ")");
        }
        sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=sl.`panel_id` ");
        sb.Append(" ORDER BY location,MachineName ");

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
            HttpContext.Current.Session["ReportName"] = "MappedLocationwithMachine";
            return "1";
        }
        return "0";


    }

}