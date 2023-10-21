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

public partial class Design_Quality_EQASProgrammaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlprovider.DataSource = StockReports.GetDataTable("select EqasProviderID,EqasProviderName from qc_eqasprovidermaster where EqasProviderID='" + Request.QueryString["eqasprovider"].ToString() + "'");
            ddlprovider.DataValueField = "EqasProviderID";
            ddlprovider.DataTextField = "EqasProviderName";
            ddlprovider.DataBind();


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

        sb.Append(" SELECT concat(im.investigation_id,'#0') type_id,CONCAT(testcode,' ~ ',NAME) typename FROM investigation_master im ");
        sb.Append(" INNER JOIN `investigation_observationtype` iot ON im.`Investigation_Id`=iot.`Investigation_ID` ");
        sb.Append(" and iot.ObservationType_Id=" + department + "  -- AND im.`ReportType`=1");
        sb.Append(" ORDER BY typename  ");
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
    public static string savedata(List<ProgramData> prodata)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {

            int programid = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IFNULL(MAX(ProgramID)+1,1) FROM qc_eqasprogrammaster"));
            foreach (ProgramData proda in prodata)
            {

               
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO qc_eqasprogrammaster ");
                    sb.Append("  (EQASProviderID,ProgramID,ProgramName,Rate,DepartmentID,DepartmentName, ");
                    sb.Append("   InvestigationID,InvestigationName,LabObservationID,EntryDate,EntryByID,EntryByName,Frequency,Age,Gender,ResultWithin) ");
                    sb.Append("  VALUES (@EQASProviderID,@ProgramID,@ProgramName,@Rate,@DepartmentID,@DepartmentName, ");
                    sb.Append("            @InvestigationID,@InvestigationName,@LabObservationID,@EntryDate,@EntryByID,@EntryByName,@Frequency,@Age,@Gender,@ResultWithin); ");

                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@EQASProviderID", proda.EQASProviderID),
                       new MySqlParameter("@ProgramID", programid),
                       new MySqlParameter("@ProgramName", proda.ProgramName),
                       new MySqlParameter("@Rate", proda.Rate),
                       new MySqlParameter("@DepartmentID", proda.DepartmentID),
                       new MySqlParameter("@DepartmentName", proda.DepartmentName),
                       new MySqlParameter("@InvestigationID", proda.InvestigationID),
                       new MySqlParameter("@InvestigationName", proda.InvestigationName),
                       new MySqlParameter("@LabObservationID", proda.LabObservationID),
                       new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                       new MySqlParameter("@EntryByID", UserInfo.ID),
                       new MySqlParameter("@EntryByName", UserInfo.LoginName),
                       new MySqlParameter("@Frequency", proda.Frequency),
                       new MySqlParameter("@Age", proda.Age),
                       new MySqlParameter("@Gender", proda.Gender),
                       new MySqlParameter("@ResultWithin", proda.ResultWithin)
                       );
                

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
    public static string SearchRecords(string eqasproviderid)
    {

        DataTable dt = StockReports.GetDataTable("SELECT EQASProviderID,ProgramID,ProgramName,Rate,GROUP_CONCAT(InvestigationName) InvestigationName,DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate, EntryByName FROM qc_eqasprogrammaster WHERE EQASProviderID=" + eqasproviderid + " and isactive=1 GROUP BY ProgramID ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public static string deleteprogram(string id)
    {
        StockReports.ExecuteScalar("update qc_eqasprogrammaster set isactive=0,updatedate=now(),UpdateByID=" + UserInfo.ID + ",UpdateByName='"+UserInfo.LoginName+"' where ProgramID=" + id + " ");
        return "";
    }

    [WebMethod]
    public static string SearchRecordsProgram(string programid)
    {
        DataTable dt = StockReports.GetDataTable("SELECT id,EQASProviderID,ProgramID,ProgramName,Rate,DepartmentID,DepartmentName,InvestigationID,InvestigationName,LabObservationID,Frequency,Age,Gender,ResultWithin FROM qc_eqasprogrammaster WHERE ProgramID=" + programid + " and isactive=1 ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }



    [WebMethod]
    public static string updatedata(List<ProgramData> prodata, string delitemid)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            int programid = Util.GetInt(prodata[0].ProgramID);
           

            foreach (ProgramData proda in prodata)
            {

                if (proda.ISNew == "1")
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO qc_eqasprogrammaster ");
                    sb.Append("  (EQASProviderID,ProgramID,ProgramName,Rate,DepartmentID,DepartmentName, ");
                    sb.Append("   InvestigationID,InvestigationName,LabObservationID,EntryDate,EntryByID,EntryByName,Frequency,Age,Gender,ResultWithin) ");
                    sb.Append("  VALUES (@EQASProviderID,@ProgramID,@ProgramName,@Rate,@DepartmentID,@DepartmentName, ");
                    sb.Append("            @InvestigationID,@InvestigationName,@LabObservationID,@EntryDate,@EntryByID,@EntryByName,@Frequency,@Age,@Gender,@ResultWithin); ");

                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@EQASProviderID", proda.EQASProviderID),
                       new MySqlParameter("@ProgramID", programid),
                       new MySqlParameter("@ProgramName", proda.ProgramName),
                       new MySqlParameter("@Rate", proda.Rate),
                       new MySqlParameter("@DepartmentID", proda.DepartmentID),
                       new MySqlParameter("@DepartmentName", proda.DepartmentName),
                       new MySqlParameter("@InvestigationID", proda.InvestigationID),
                       new MySqlParameter("@InvestigationName", proda.InvestigationName),
                       new MySqlParameter("@LabObservationID", proda.LabObservationID),
                       new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                       new MySqlParameter("@EntryByID", UserInfo.ID),
                       new MySqlParameter("@EntryByName", UserInfo.LoginName),
                       new MySqlParameter("@Frequency", proda.Frequency),
                       new MySqlParameter("@Age", proda.Age),
                       new MySqlParameter("@Gender", proda.Gender),
                       new MySqlParameter("@ResultWithin", proda.ResultWithin)
                       );
                }


            }

            if (delitemid.Trim(',') != "")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasprogrammaster set isactive=0,updatedate=now(),UpdateByID=" + UserInfo.ID + ",UpdateByName='" + UserInfo.LoginName + "' where id in (" + delitemid.Trim(',') + ") ");
            }

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasprogrammaster set ProgramName=@ProgramName,rate=@rate,age=@age,Gender=@Gender,Frequency=@Frequency,ResultWithin=@ResultWithin, updatedate=@updatedate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where programid=@programid"
               , new MySqlParameter("@ProgramName", prodata[0].ProgramName),
                new MySqlParameter("@rate", prodata[0].Rate),
                 new MySqlParameter("@updatedate", Util.GetDateTime(DateTime.Now)),
                 new MySqlParameter("@UpdateByID", UserInfo.ID),
                  new MySqlParameter("@UpdateByName", UserInfo.LoginName), new MySqlParameter("@programid", programid),
                   new MySqlParameter("@Frequency", prodata[0].Frequency),
                       new MySqlParameter("@Age", prodata[0].Age),
                       new MySqlParameter("@Gender", prodata[0].Gender),
                       new MySqlParameter("@ResultWithin", prodata[0].ResultWithin)
               );



            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {





            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {

            tnx.Dispose();
            con.Close();
            con.Dispose();
        }


    }


    [WebMethod]
    public static string checkduplicateprogramname(string programid, string programname,string labid)
    {
        if (programid == "")
        {
            return StockReports.ExecuteScalar(" select count(1) from qc_eqasprogrammaster where ProgramName='" + programname.Trim() + "' and EQASProviderID=" + labid + " ");
        }
        else
        {
            return StockReports.ExecuteScalar(" select count(1) from qc_eqasprogrammaster where ProgramName='" + programname.Trim() + "' and EQASProviderID=" + labid + " and ProgramID<>'" + programid + "' ");
        }
    }

    [WebMethod]
    public static string exporttoexcel(string eqasproviderid, string eqasprovidername)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT EQASProviderID,'" + eqasprovidername + "' eqasprovidername,ProgramID,ProgramName,Rate,InvestigationName TestName,");
        sb.Append(" CONCAT(Frequency,' Month')Frequency,CONCAT(ResultWithin,' Days')ResultWithin,");
        sb.Append(" DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate, EntryByName FROM qc_eqasprogrammaster ");
        sb.Append(" WHERE EQASProviderID=" + eqasproviderid + " and isactive=1 order BY ProgramID,InvestigationName ");
       

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
            HttpContext.Current.Session["ReportName"] = "EQASProgramList";
            return "true";
        }
        else
        {
            return "false";
        }


    }
    
}


public class ProgramData
{
    public int EQASProviderID { get; set; }
    public int ProgramID { get; set; }
    public string ProgramName { get; set; }
    public float Rate { get; set; }
    public int DepartmentID { get; set; }
    public string DepartmentName { get; set; }
    public int InvestigationID { get; set; }
    public string InvestigationName { get; set; }
    public int LabObservationID { get; set; }
    
    public int Frequency { get; set; }
   
    public int Age { get; set; }
    public string Gender { get; set; }
    public int ResultWithin { get; set; }
    public string ISNew { get; set; }

}