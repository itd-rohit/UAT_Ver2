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

public partial class Design_Quality_ILCScheduleSpecial : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM qc_approvalright WHERE apprightfor='ILCSE' AND active=1 AND employeeid='" + UserInfo.ID + "' and typename='Approval'");
            if (dt == "0")
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Right To Extend ILC Schedule');", true);
                return;
            }


            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            calFromDate.StartDate = DateTime.Now;

            CalendarExtender1.StartDate = DateTime.Now;
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindCentre()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre"));


    }



    [WebMethod]
    public static string SaveData(string centreid, string fromdate, string todate, string scheduletype, string reason)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            foreach (string centre in centreid.Split(','))
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_ilcschedule set IsActive=@IsActive,UpdateDate=@UpdateDate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where ProcessingLabID=@ProcessingLabID and ScheduleType=@ScheduleType and IsSpecial=@IsSpecial and MONTH(SpecialFrom)=@mymonth",
                     new MySqlParameter("@ProcessingLabID", centre),
                      new MySqlParameter("@ScheduleType", scheduletype),
                       new MySqlParameter("@IsSpecial", "1"),
                        new MySqlParameter("@IsActive", "0"),
                         new MySqlParameter("@UpdateDate", DateTime.Now),
                          new MySqlParameter("@UpdateByID", UserInfo.ID),
                          new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                           new MySqlParameter("@mymonth", Util.GetDateTime(fromdate).Month)

                    );

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into qc_ilcschedule (ProcessingLabID,ScheduleType,SpecialFrom,SpecialToDate,IsSpecial,SpecialEntryDate,SpecialEntry,SpecialEntryBy,SpecialRemarks) values (@ProcessingLabID,@ScheduleType,@SpecialFrom,@SpecialToDate,@IsSpecial,@SpecialEntryDate,@SpecialEntry,@SpecialEntryBy,@SpecialRemarks)",
                    new MySqlParameter("@ProcessingLabID", centre),
                     new MySqlParameter("@ScheduleType", scheduletype),
                      new MySqlParameter("@SpecialFrom",Util.GetDateTime(fromdate)),
                       new MySqlParameter("@SpecialToDate",Util.GetDateTime(todate)),
                        new MySqlParameter("@IsSpecial", "1"),
                         new MySqlParameter("@SpecialEntryDate", DateTime.Now),
                          new MySqlParameter("@SpecialEntry", UserInfo.ID),
                           new MySqlParameter("@SpecialEntryBy", UserInfo.LoginName),
                            new MySqlParameter("@SpecialRemarks", reason)
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
    public static string GetAllDate(string centreid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT  ql.id,cm.`CentreID`,cm.`CentreCode`,cm.`Centre`,ifnull(ql.SpecialRemarks,'')SpecialRemarks, ");
        sb.Append(" IF(ql.`ScheduleType`=1,'ILC Registration','ILC Result Entry and Approval') ScheduleType, ");
        sb.Append(" DATE_FORMAT(ql.SpecialFrom,'%d-%b-%Y')  fromdate,DATE_FORMAT(ql.SpecialToDate,'%d-%b-%Y')  todate, ");
        sb.Append(" DATE_FORMAT(ql.`SpecialEntryDate`,'%d-%b-%Y')EntryDate,ql.SpecialEntryBy entryby ");
        sb.Append(" FROM qc_ilcschedule ql  ");
        sb.Append(" INNER JOIN centre_master cm ON cm.centreid=ql.`ProcessingLabID`");
        sb.Append(" and cm.centreid=" + centreid + " ");
        sb.Append(" WHERE ql.isactive=1 AND `IsSpecial`=1");
        sb.Append(" order by ql.`SpecialEntryDate` desc");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public static string deletedata(string id)
    {
        try
        {
            StockReports.ExecuteDML("update qc_ilcschedule set IsActive=0,UpdateDate=now(),UpdateByID=" + UserInfo.ID + ",UpdateByName='" + UserInfo.LoginName + "' where id=" + id + "");
            return "1";
        }
        catch
        {
            return "0";
        }
    }


}