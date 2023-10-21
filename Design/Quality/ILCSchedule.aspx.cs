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

public partial class Design_Quality_ILCSchedule : System.Web.UI.Page
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


            for (int a = 1; a <= 28; a++)
            {
                ddlfromdate.Items.Add(new ListItem(a.ToString(),a.ToString()));
                ddltodate.Items.Add(new ListItem(a.ToString(), a.ToString()));
            }
            ddlfromdate.Items.Insert(0, new ListItem("Select From Date","0"));
            ddltodate.Items.Insert(0, new ListItem("Select To Date", "0"));



        }
    }


  
    

    [WebMethod(EnableSession = true)]
    public static string bindCentre(string TypeId)
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre FROM centre_master   WHERE Type1Id =" + TypeId + " and centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) ORDER BY centre"));


    }



    [WebMethod]
    public static string SaveData(string centreid, string fromdate, string todate, string scheduletype)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            foreach (string centre in centreid.Split(','))
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_ilcschedule set IsActive=@IsActive,UpdateDate=@UpdateDate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where ProcessingLabID=@ProcessingLabID and ScheduleType=@ScheduleType and IsSpecial=@IsSpecial",
                     new MySqlParameter("@ProcessingLabID",centre),
                      new MySqlParameter("@ScheduleType",scheduletype),
                       new MySqlParameter("@IsSpecial","0"),
                        new MySqlParameter("@IsActive","0"),
                         new MySqlParameter("@UpdateDate",DateTime.Now),
                          new MySqlParameter("@UpdateByID",UserInfo.ID),
                          new MySqlParameter("@UpdateByName",UserInfo.LoginName)

                    );

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into qc_ilcschedule (ProcessingLabID,ScheduleType,FromDate,ToDate,IsSpecial,EntryDate,EntryByID,EntryBy) values (@ProcessingLabID,@ScheduleType,@FromDate,@ToDate,@IsSpecial,@EntryDate,@EntryByID,@EntryBy)",
                    new MySqlParameter("@ProcessingLabID",centre),
                     new MySqlParameter("@ScheduleType",scheduletype),
                      new MySqlParameter("@FromDate",fromdate),
                       new MySqlParameter("@ToDate",todate),
                        new MySqlParameter("@IsSpecial","0"),
                         new MySqlParameter("@EntryDate",DateTime.Now),
                          new MySqlParameter("@EntryByID",UserInfo.ID),
                           new MySqlParameter("@EntryBy",UserInfo.LoginName)
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
            return Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string deletedata(string id)
    {
        try
        {
            StockReports.ExecuteDML("update qc_ilcschedule set IsActive=0,UpdateDate=now(),UpdateByID="+UserInfo.ID+",UpdateByName='"+UserInfo.LoginName+"' where id="+id+"");
            return "1";
        }
        catch
        {
            return "0";
        }
    }
    

    [WebMethod]
    public static string GetAllDate()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  ql.id,cm.`CentreID`,cm.`CentreCode`,cm.`Centre`, ");
        sb.Append(" (case when ql.`ScheduleType`=1 then 'ILC Registration' when ql.`ScheduleType`=2 then 'ILC Result Entry and Approval' when ql.`ScheduleType`=3");
        sb.Append(" then 'EQAS Registration'  when ql.ScheduleType='4' then 'EQAS Result Entry and Approval' end) ScheduleType, ");
        sb.Append(" ql.fromdate,ql.todate, ");
        sb.Append(" DATE_FORMAT(ql.`EntryDate`,'%d-%b-%Y')EntryDate,ql.entryby ");
        sb.Append(" FROM qc_ilcschedule ql  ");
        sb.Append(" INNER JOIN centre_master cm ON cm.centreid=ql.`ProcessingLabID`");
        sb.Append(" WHERE ql.isactive=1 AND `IsSpecial`=0");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


}