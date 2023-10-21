using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_SigmaAnalysisMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddldepartment.DataSource = StockReports.GetDataTable("SELECT subcategoryid,NAME FROM `f_subcategorymaster` WHERE active=1 and subcategoryid NOT IN (15,18) ORDER BY NAME  ");
            ddldepartment.DataValueField = "subcategoryid";
            ddldepartment.DataTextField = "NAME";
            ddldepartment.DataBind();
            ddldepartment.Items.Insert(0, new ListItem("Select Department", "0"));
        }
    }

    [WebMethod]
    public static string bindtest(string department)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT type_id,CONCAT(testcode,' ~ ',typename) typename FROM f_itemmaster WHERE subcategoryid='" + department + "' AND isactive=1 ORDER BY typename ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public static string bindparameter(string test)
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT DISTINCT  im.`LabObservation_ID`,im.name `name`  FROM `labobservation_investigation` loi 
INNER JOIN labobservation_master im ON loi.`labObservation_ID`=im.`LabObservation_ID` AND im.`IsActive`=1 AND im.name<>'' and loi.child_flag=0
INNER JOIN investigation_master imi ON imi.investigation_id=loi.investigation_id AND imi.ReportType=1
WHERE loi.investigation_id IN (" + test + ") ORDER BY NAME");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string getalldata(string labobservationid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select labObservation_ID,name,ifnull(CLIA,'')CLIA,ifnull(qs.id,'0') savedid from labobservation_master lom ");
        sb.Append(" left join qc_sigmaanalysisclia qs on qs.LabObservationID=lom.labObservation_ID ");
        sb.Append(" where lom.labObservation_ID in ("+labobservationid+")");
        sb.Append(" order by name");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public static string SaveData(List<SigmaCLIA> SigmaData)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            foreach (SigmaCLIA ilc in SigmaData)
            {

                if (ilc.SavedID == "0")
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO qc_sigmaanalysisclia ");
                    sb.Append("  (LabObservationID,LabObservationName,CLIA,EntryDate,EntryByID,EntryByName) ");
                    sb.Append("  VALUES (@LabObservationID,@LabObservationName,@CLIA,@EntryDate,@EntryByID,@EntryByName) ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@LabObservationID", ilc.LabObservationID),
                       new MySqlParameter("@LabObservationName", ilc.LabObservationName),
                       new MySqlParameter("@CLIA", ilc.CLIA),
                       new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                       new MySqlParameter("@EntryByID", UserInfo.ID),
                       new MySqlParameter("@EntryByName", UserInfo.LoginName)
                       );
                }
                else
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" update qc_sigmaanalysisclia set CLIA=@CLIA,updatedate=@updatedate ");
                    sb.Append(" ,updatebyid=@updatebyid,updatebyname=@updatebyname where id=@id");

                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@CLIA", ilc.CLIA),
                     new MySqlParameter("@id", ilc.SavedID),
                     new MySqlParameter("@updatedate", Util.GetDateTime(DateTime.Now)),
                     new MySqlParameter("@updatebyid", UserInfo.ID),
                     new MySqlParameter("@updatebyname", UserInfo.LoginName)
                     );

                }

            }


            return "1";
        }
        catch (Exception ex)
        {





            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {

            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    [WebMethod]
    public static string deletedata(string id)
    {
        StockReports.ExecuteDML("delete from qc_sigmaanalysisclia where id="+id+"");
        return "1";
    }

    [WebMethod]
    public static string exporttoexcel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select labObservation_ID ParameterID,name ParameterName,ifnull(CLIA,'')CLIA  from labobservation_master lom ");
        sb.Append(" inner join qc_sigmaanalysisclia qs on qs.LabObservationID=lom.labObservation_ID ");
        sb.Append(" where lom.isactive=1");
        sb.Append(" order by name");

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
            HttpContext.Current.Session["ReportName"] = "TotalAllowableError";
            return "true";
        }
        else
        {
            return "false";
        }
    }
}
public class SigmaCLIA
{
    public string LabObservationID { get; set; }
    public string LabObservationName { get; set; }
    public string CLIA { get; set; }
    public string SavedID { get; set; }
}