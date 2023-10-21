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

public partial class Design_Quality_CAPQCMaster : System.Web.UI.Page
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

    

        sb.Append(" SELECT concat(im.investigation_id,'#0') type_id,CONCAT(testcode,' ~ ',NAME) typename FROM investigation_master im ");
        sb.Append(" INNER JOIN `investigation_observationtype` iot ON im.`Investigation_Id`=iot.`Investigation_ID` ");
        sb.Append(" and iot.ObservationType_Id=" + department + "  AND im.`ReportType`=1");
        sb.Append(" ORDER BY typename  ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));

        //return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    public static string SearchRecords()
    {

        DataTable dt = StockReports.GetDataTable("SELECT ProgramID,ProgramName,ResultWithin,Description,GROUP_CONCAT(InvestigationName) InvestigationName,DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate, EntryByName FROM qc_capprogrammaster WHERE  isactive=1 GROUP BY ProgramID ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }


    [WebMethod]
    public static string deleteprogram(string id)
    {
        StockReports.ExecuteScalar("update qc_capprogrammaster set isactive=0,updatedate=now(),UpdateByID=" + UserInfo.ID + ",UpdateByName='" + UserInfo.LoginName + "' where ProgramID=" + id + " ");
        return "";
    }

    [WebMethod]
    public static string SearchRecordsProgram(string programid)
    {
        DataTable dt = StockReports.GetDataTable("SELECT id,ProgramID,ProgramName,Description,ResultWithin,DepartmentID,DepartmentName,InvestigationID,InvestigationName,LabObservationID FROM qc_capprogrammaster WHERE ProgramID=" + programid + " and isactive=1 ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string savedata(List<CAPProgramData> prodata)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            int programid = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT IFNULL(MAX(ProgramID)+1,1) FROM qc_capprogrammaster"));
            foreach (CAPProgramData proda in prodata)
            {


                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO qc_capprogrammaster ");
                sb.Append("  (ProgramID,ProgramName,ResultWithin,Description,DepartmentID,DepartmentName, ");
                sb.Append("   InvestigationID,InvestigationName,LabObservationID,EntryDate,EntryByID,EntryByName) ");
                sb.Append("  VALUES (@ProgramID,@ProgramName,@ResultWithin,@ProgramDiscription,@DepartmentID,@DepartmentName, ");
                sb.Append("            @InvestigationID,@InvestigationName,@LabObservationID,@EntryDate,@EntryByID,@EntryByName); ");

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),

                   new MySqlParameter("@ProgramID", programid),
                   new MySqlParameter("@ProgramName", proda.ProgramName),
                   new MySqlParameter("@ResultWithin", proda.ResultWithin),
                   new MySqlParameter("@ProgramDiscription", proda.ProgramDiscription),
                   new MySqlParameter("@DepartmentID", proda.DepartmentID),
                   new MySqlParameter("@DepartmentName", proda.DepartmentName),
                   new MySqlParameter("@InvestigationID", proda.InvestigationID),
                   new MySqlParameter("@InvestigationName", proda.InvestigationName),
                   new MySqlParameter("@LabObservationID", proda.LabObservationID),
                   new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                   new MySqlParameter("@EntryByID", UserInfo.ID),
                   new MySqlParameter("@EntryByName", UserInfo.LoginName)

                   );


            }

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
    public static string updatedata(List<CAPProgramData> prodata, string delitemid)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {

            int programid = Util.GetInt(prodata[0].ProgramID);


            foreach (CAPProgramData proda in prodata)
            {

                if (proda.ISNew == "1")
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO qc_capprogrammaster ");
                    sb.Append("  (ProgramID,ProgramName,ResultWithin,Description,DepartmentID,DepartmentName, ");
                    sb.Append("   InvestigationID,InvestigationName,LabObservationID,EntryDate,EntryByID,EntryByName) ");
                    sb.Append("  VALUES (@ProgramID,@ProgramName,@ResultWithin,@ProgramDiscription,@DepartmentID,@DepartmentName, ");
                    sb.Append("            @InvestigationID,@InvestigationName,@LabObservationID,@EntryDate,@EntryByID,@EntryByName); ");

                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@ProgramID", programid),
                       new MySqlParameter("@ProgramName", proda.ProgramName),
                       new MySqlParameter("@ResultWithin", proda.ResultWithin),
                       new MySqlParameter("@ProgramDiscription", proda.ProgramDiscription),
                       new MySqlParameter("@DepartmentID", proda.DepartmentID),
                       new MySqlParameter("@DepartmentName", proda.DepartmentName),
                       new MySqlParameter("@InvestigationID", proda.InvestigationID),
                       new MySqlParameter("@InvestigationName", proda.InvestigationName),
                       new MySqlParameter("@LabObservationID", proda.LabObservationID),
                       new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                       new MySqlParameter("@EntryByID", UserInfo.ID),
                       new MySqlParameter("@EntryByName", UserInfo.LoginName)
                       );
                }


            }

            if (delitemid.Trim(',') != "")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_capprogrammaster set isactive=0,updatedate=now(),UpdateByID=" + UserInfo.ID + ",UpdateByName='" + UserInfo.LoginName + "' where id in (" + delitemid.Trim(',') + ") ");
            }

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_capprogrammaster set ProgramName=@ProgramName,Description=@Description,ResultWithin=@ResultWithin,updatedate=@updatedate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where programid=@programid"
               , new MySqlParameter("@ProgramName", prodata[0].ProgramName), new MySqlParameter("@ResultWithin", prodata[0].ResultWithin),
                new MySqlParameter("@Description", prodata[0].ProgramDiscription),
                 new MySqlParameter("@updatedate", Util.GetDateTime(DateTime.Now)),
                 new MySqlParameter("@UpdateByID", UserInfo.ID),
                  new MySqlParameter("@UpdateByName", UserInfo.LoginName), new MySqlParameter("@programid", programid)
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
    public static string exporttoexcel()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ProgramID,ProgramName,Description,ResultWithin,InvestigationName TestName,");
        sb.Append(" DATE_FORMAT(EntryDate,'%d-%b-%Y')EntryDate, EntryByName FROM qc_capprogrammaster ");
        sb.Append(" WHERE  isactive=1 order BY ProgramID,InvestigationName ");


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
            HttpContext.Current.Session["ReportName"] = "CAPEQASProgramList";
            return "true";
        }
        else
        {
            return "false";
        }


    }

}


public class CAPProgramData
{
    
    public int ProgramID { get; set; }
    public string ProgramName { get; set; }
    public int ResultWithin { get; set; }
    public string ProgramDiscription { get; set; }
    public int DepartmentID { get; set; }
    public string DepartmentName { get; set; }
    public int InvestigationID { get; set; }
    public string InvestigationName { get; set; }
    public int LabObservationID { get; set; }
    public string ISNew { get; set; }
   

}