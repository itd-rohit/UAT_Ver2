using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
public partial class Design_Store_CenterIndentRight : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }



    [WebMethod(EnableSession = true)]
    public static string bindlocation(string centreid, string StateID, string TypeId, string ZoneId, string cityId)
    {
        
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT LocationID,Location FROM st_locationmaster lm  ");

        sb.Append(" INNER JOIN f_panel_master pm on pm.`panel_id`=lm.`panel_id`  ");
        sb.Append(" INNER join centre_master cm on   cm.`CentreID`=CASE WHEN pm.`PanelType` ='Centre' then pm.`CentreID` else pm.tagprocessinglabid END AND pm.`PanelType`in('Centre','PUP')   and cm.IsActive=1");
        if (ZoneId != "")
            sb.Append(" AND cm.BusinessZoneID IN(" + ZoneId + ")");

        if (StateID != "")
            sb.Append("  AND cm.StateID IN(" + StateID + ")");

        if (cityId != "")
            sb.Append(" AND cm.cityid IN(" + cityId + ")");

        if (TypeId != "")
            sb.Append("  AND cm.Type1Id IN(" + TypeId + ")");

        if (centreid != "")
            sb.Append("  AND  pm.`panel_id` IN(" + centreid + ")");

        sb.Append(" WHERE lm.IsActive=1 ORDER BY lm.Location");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SubmitData( string fcenterID, string tcenterID, string IndentType)
    {

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
        string[] fcenter_id = fcenterID.Split(',');
        string[] tcenter_id = tcenterID.Split(',');
        string rtn = string.Empty;



        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "delete from st_centerindentright where FromLoationID in (" + string.Join(",", fcenterID) + ") and ToLoationID in (" + string.Join(",", tcenter_id) + ") and IndentType='" + IndentType + "'");



            foreach (string i in fcenter_id)
            {
                foreach (string j in tcenter_id)
                {
                    if (j != "")
                    {
                        string str = " Insert into st_centerindentright (FromLoationID,ToLoationID,IndentType) values ";
                        str += "('" + i + "','" + j + "','" + IndentType + "');";

                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString().Trim().TrimEnd(','));


                      


                    }

                }
            }

            Tranx.Commit();
            return "True";
           
        }
         catch (Exception ex)
        {
            Tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.Message;
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string SearchData(string fcenterID, string tcenterID, string IndentType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID, FromLoationID FromCenterID,(SELECT location FROM st_locationmaster WHERE LocationID=FromLoationID ) FromCenter,ToLoationID ToCenterID,(SELECT location FROM st_locationmaster WHERE LocationID=ToLoationID ) ToCenter,IndentType FROM st_centerindentright  where 1=1  ");
        if (fcenterID != "")
            sb.Append(" and FromLoationID in (" + fcenterID + ") ");
        if (tcenterID != "")
            sb.Append(" and ToLoationID in (" + tcenterID + ") ");

        if(IndentType!="")
            sb.Append(" and indenttype ='" + IndentType + "' ");

        sb.Append(" ORDER BY FromCenter,indenttype ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod(EnableSession = true)]
    public static string ExportToExcel(string fromCentre)
    {


        string sb = " SELECT IndentType,(sELECT location FROM st_locationmaster WHERE LocationID=FromLoationID) FromLocation,(SELECT location FROM st_locationmaster WHERE LocationID=ToLoationID ) ToLocation FROM st_centerindentright  where 1=1 ";

            if (fromCentre != "")
                sb += " and FromLoationID in (" + fromCentre + ") ";

            sb += " order by FromLocation,indenttype";
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
                HttpContext.Current.Session["ReportName"] = "LocationIndentRightMapping";
                return "true";
            }
            return "false";

       

    }



    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string RemoveData(string Id)
    {
        string str1 = " Delete from st_centerindentright where  ID in (" + Id + ")";
        string rtn = Util.GetString(StockReports.ExecuteDML(str1.ToString()));
        return "1";
    }

}