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

public partial class Design_Quality_EQASProgramLabMapping : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           

            ddlcentretype.DataSource = StockReports.GetDataTable(@" SELECT DISTINCT TYPE1id,TYPE1  FROM centre_master WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY TYPE1");
            ddlcentretype.DataValueField = "TYPE1id";
            ddlcentretype.DataTextField = "TYPE1";
            ddlcentretype.DataBind();
            ddlcentretype.Items.Insert(0, new ListItem("Type", "0"));


            ddleqasprovider.DataSource = StockReports.GetDataTable(@"SELECT `EQASProviderID`,`EqasProviderName` FROM `qc_eqasprovidermaster` WHERE isactive=1 ORDER BY EqasProviderName");
            ddleqasprovider.DataValueField = "EQASProviderID";
            ddleqasprovider.DataTextField = "EqasProviderName";
            ddleqasprovider.DataBind();
            ddleqasprovider.Items.Insert(0, new ListItem("Select EQAS Provider", "0"));

      
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre FROM centre_master   WHERE Type1Id =" + TypeId + " and centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY centre"));


    }

    [WebMethod(EnableSession = true)]
    public static string bindprogram(string eqasproid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT programid,concat(programname,' @',rate)programname FROM `qc_eqasprogrammaster` WHERE `EQASProviderID`=" + eqasproid + " AND isactive=1 GROUP BY programid ORDER BY programname"));
        
    }

    [WebMethod(EnableSession = true)]
    public static string bindprogramdata(string programid)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT programid,programname,rate,investigationid,investigationname,concat(ResultWithin,' Days')`ResultWithin`,concat(`Frequency`,' Month')Frequency,departmentname FROM `qc_eqasprogrammaster` WHERE programid in(" + programid + ") AND isactive=1 order by programid"));
        
    }

    [WebMethod(EnableSession = true)]
    public static string saveprogrammapping(string data)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            foreach (string maindata in data.TrimEnd('^').Split('^'))
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasprogramlabmapping set isactive=0,UpdateDateTime=now(),UpdateBy='" + UserInfo.ID + "',UpdateByName='" + UserInfo.LoginName + "' where ProcessingLabID=@ProcessingLabID and EQASProviderID=@EQASProviderID and ProgramID=@ProgramID ",
                    new MySqlParameter("@ProcessingLabID", maindata.Split('#')[0]),
                    new MySqlParameter("@EQASProviderID", maindata.Split('#')[1]),
                    new MySqlParameter("@ProgramID", maindata.Split('#')[2]));

                StringBuilder sb = new StringBuilder();
                sb.Append("  INSERT INTO qc_eqasprogramlabmapping ");
                sb.Append("  (ProcessingLabID,EQASProviderID,ProgramID, EntryBy,EntryDateTime,EntryByName) ");
                sb.Append("  VALUES (@ProcessingLabID,@EQASProviderID,@ProgramID,@EntryBy,@EntryDateTime,@EntryByName)  ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@ProcessingLabID", maindata.Split('#')[0]),
                   new MySqlParameter("@EQASProviderID", maindata.Split('#')[1]),
                   new MySqlParameter("@ProgramID", maindata.Split('#')[2]),
                   new MySqlParameter("@EntryDateTime", Util.GetDateTime(DateTime.Now)),
                   new MySqlParameter("@EntryBy", UserInfo.ID),
                   new MySqlParameter("@EntryByName", UserInfo.LoginName));
            }
            /*
            foreach (string maindata in data.TrimEnd('^').Split('^'))
            {
                StringBuilder sb = new StringBuilder();

                sb.Append(" SELECT qe.ProcessingLabID,qe.programid,eqm.programname,InvestigationName ");
                sb.Append(" FROM qc_eqasprogramlabmapping qe ");
                sb.Append(" INNER JOIN `qc_eqasprogrammaster` eqm ON eqm.programid=qe.programid AND eqm.isactive=1 and qe.isactive=1 ");
                sb.Append(" WHERE qe.isactive=1 and qe.ProcessingLabID=" + maindata.Split('#')[0] + "");
                sb.Append(" GROUP BY Investigationid  HAVING COUNT(*) >1 ");
                sb.Append(" ORDER BY programid ");

                DataTable dtDuplicate = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString()).Tables[0];

                if (dtDuplicate.Rows.Count > 0)
                {
                    Exception ex = new Exception(dtDuplicate.Rows[0]["InvestigationName"].ToString() + " Found duplicate in " + dtDuplicate.Rows[0]["programname"].ToString());
                    throw (ex);
                   
                }

            }
             */

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.Message);

        }
        finally
        {

            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }


    [WebMethod(EnableSession = true)]
    public static string getprogramlist(string processinglabid)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(@"SELECT qe.id, qe.ProcessingLabID,cm.centre,qcem.EqasProviderName,qe.programid,eqm.programname,
GROUP_CONCAT(InvestigationName) testname,qe.entrybyname,DATE_FORMAT(entrydatetime,'%d-%b-%Y') entrydatetime
 FROM qc_eqasprogramlabmapping qe
INNER JOIN centre_master cm ON cm.centreid=qe.ProcessingLabID
INNER JOIN `qc_eqasprogrammaster` eqm ON eqm.programid=qe.programid and eqm.IsActive=1
INNER JOIN `qc_eqasprovidermaster` qcem ON qcem.EqasProviderID=qe.EQASProviderID
WHERE qe.isactive=1 and qe.ProcessingLabID in ( " + processinglabid + ") GROUP BY ProcessingLabID,qe.programid"));
    }

    [WebMethod(EnableSession = true)]
    public static string deletedata(string id)
    {
        StockReports.ExecuteDML("update  qc_eqasprogramlabmapping set isactive=0,UpdateDateTime=now(),UpdateBy='" + UserInfo.ID + "',UpdateByName='" + UserInfo.LoginName + "' where id='" + id + "' ");
        return "1";
    }



    [WebMethod]
    public static string exporttoexcel(string processinglabid)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT  qe.ProcessingLabID centreid,cm.centre,qcem.EqasProviderName,qe.programid,eqm.programname,");
        sb.Append(" InvestigationName testname,qe.entrybyname,DATE_FORMAT(entrydatetime,'%d-%b-%Y') entrydatetime ");
        sb.Append(" FROM qc_eqasprogramlabmapping qe ");
        sb.Append(" INNER JOIN centre_master cm ON cm.centreid=qe.ProcessingLabID ");
        sb.Append(" INNER JOIN `qc_eqasprogrammaster` eqm ON eqm.programid=qe.programid ");
        sb.Append(" INNER JOIN `qc_eqasprovidermaster` qcem ON qcem.EqasProviderID=qe.EQASProviderID ");
        if (processinglabid != "")
        {
            sb.Append(" WHERE qe.isactive=1 and qe.ProcessingLabID  in ( " + processinglabid + ") order by qe.ProcessingLabID,qe.programid,InvestigationName");
        }
        else
        {
            sb.Append(" WHERE qe.isactive=1 order by qe.ProcessingLabID,qe.programid,InvestigationName");
        }



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
            HttpContext.Current.Session["ReportName"] = "EQASProgramLabMapping";
            return "true";
        }
        else
        {
            return "false";
        }


    }
    
    
    
}