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

public partial class Design_Quality_ILCScheduleRequest : System.Web.UI.Page
{


    public string approvaltypemaker = "0";
    public string approvaltypechecker = "0";
    public string approvaltypeapproval = "0";


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {


            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM qc_approvalright WHERE apprightfor='ILCSE' AND employeeid='" + UserInfo.ID + "' ");
            if (dt != "0")
            {
                if (dt.Contains("Checker"))
                {
                    approvaltypechecker = "1";
                }
                if (dt.Contains("Approval"))
                {
                    approvaltypeapproval = "1";
                }
                if (dt.Contains("Maker"))
                {
                    approvaltypemaker = "1";
                }
            }


            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            calFromDate.StartDate = DateTime.Now;

            CalendarExtender1.StartDate = DateTime.Now;

            CalendarExtender2.StartDate = DateTime.Now;

            CalendarExtender3.StartDate = DateTime.Now;
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
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_ilcschedule_request set IsActive=@IsActive,UpdateDate=@UpdateDate,UpdateByID=@UpdateByID,UpdateByName=@UpdateByName where ProcessingLabID=@ProcessingLabID and ScheduleType=@ScheduleType and ApprovalStatus=@ApprovalStatus and MONTH(RequestFrom)=@mymonth",
                     new MySqlParameter("@ProcessingLabID", centre),
                      new MySqlParameter("@ScheduleType", scheduletype),
                       new MySqlParameter("@ApprovalStatus", "0"),
                        new MySqlParameter("@IsActive", "0"),
                         new MySqlParameter("@UpdateDate", DateTime.Now),
                          new MySqlParameter("@UpdateByID", UserInfo.ID),
                          new MySqlParameter("@UpdateByName", UserInfo.LoginName),
                           new MySqlParameter("@mymonth", Util.GetDateTime(fromdate).Month)

                    );

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into qc_ilcschedule_request (ProcessingLabID,ScheduleType,RequestFrom,RequestTo,EntryDate,EntryByID,EntryByName,Remarks) values (@ProcessingLabID,@ScheduleType,@RequestFrom,@RequestTo,@EntryDate,@EntryByID,@EntryByName,@Remarks)",
                    new MySqlParameter("@ProcessingLabID", centre),
                     new MySqlParameter("@ScheduleType", scheduletype),
                      new MySqlParameter("@RequestFrom", Util.GetDateTime(fromdate)),
                       new MySqlParameter("@RequestTo", Util.GetDateTime(todate)),
                         new MySqlParameter("@EntryDate", DateTime.Now),
                          new MySqlParameter("@EntryByID", UserInfo.ID),
                           new MySqlParameter("@EntryByName", UserInfo.LoginName),
                            new MySqlParameter("@Remarks", reason)
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
        sb.Append(" SELECT  ql.id,cm.`CentreID`,cm.`CentreCode`,cm.`Centre`,ifnull(ql.Remarks,'')Remarks, ");
        
        sb.Append(" (case when ql.`ScheduleType`=1 then 'ILC Registration' when ql.`ScheduleType`=2 then 'ILC Result Entry and Approval' when ql.`ScheduleType`=3");
        sb.Append(" then 'EQAS Registration'  when ql.ScheduleType='4' then 'EQAS Result Entry and Approval' end) ScheduleType, ");

        sb.Append(" DATE_FORMAT(ql.RequestFrom,'%d-%b-%Y')  fromdate,DATE_FORMAT(ql.RequestTo,'%d-%b-%Y')  todate, ");
        sb.Append(" DATE_FORMAT(ql.`EntryDate`,'%d-%b-%Y')EntryDate,ql.EntryByName entryby, ");
        sb.Append(" ifnull(DATE_FORMAT(ql.`CheckDate`,'%d-%b-%Y'),'')CheckDate,ifnull(ql.CheckByName,'') CheckByName, ");
        sb.Append(" ifnull(DATE_FORMAT(ql.`ApproveDate`,'%d-%b-%Y'),'')ApproveDate,ifnull(ql.ApproveByName,'') ApproveByName, ");
        sb.Append("(case when ApprovalStatus=0 then 'Request Send' when ApprovalStatus=1 then 'Request Checked' else 'Request Approved' end) ApprovalStatus,  ");
        sb.Append("(case when ApprovalStatus=0 then 'lightyellow' when ApprovalStatus=1 then 'Pink' else 'lightgreen' end) RowColor  ");
        sb.Append(" FROM qc_ilcschedule_request ql  ");
        sb.Append(" INNER JOIN centre_master cm ON cm.centreid=ql.`ProcessingLabID`");
        sb.Append(" and cm.centreid=" + centreid + " and MONTH(RequestFrom)=month(now())");
        sb.Append(" WHERE ql.isactive=1");
        sb.Append(" order by ql.`EntryDate` desc");

        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public static string deletedata(string id)
    {
        try
        {
            StockReports.ExecuteDML("update qc_ilcschedule_request set IsActive=0,UpdateDate=now(),UpdateByID=" + UserInfo.ID + ",UpdateByName='" + UserInfo.LoginName + "' where id=" + id + "");
            return "1";
        }
        catch
        {
            return "0";
        }
    }


    [WebMethod]
    public static string checkme(string id, string fromdate, string todate, string reason)
    {

        StockReports.ExecuteDML("update qc_ilcschedule_request set ApprovalStatus=1,CheckDate=now(),CheckByID=" + UserInfo.ID + ",CheckByName='" + UserInfo.LoginName + "',Remarks='" + reason + "',RequestFrom='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + "',RequestTo='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + "' where id=" + id + " ");
        return "1";
    }


    [WebMethod]
    public static string approveme(string id, string fromdate, string todate, string reason)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_ilcschedule_request set ApprovalStatus=2,ApproveDate=now(),ApproveByID=" + UserInfo.ID + ",ApproveByName='" + UserInfo.LoginName + "',Remarks='" + reason + "',RequestFrom='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + "',RequestTo='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + "' where id=" + id + " ");

            StringBuilder sb = new StringBuilder();
            sb.Append(" insert into qc_ilcschedule (ProcessingLabID,ScheduleType,SpecialFrom,SpecialToDate,IsSpecial,SpecialEntryDate, ");
            sb.Append(" SpecialEntry,SpecialEntryBy,SpecialRemarks)");
            sb.Append(" select ProcessingLabID,ScheduleType,RequestFrom,RequestTo,'1',ApproveDate,ApproveByID,ApproveByName,Remarks ");
            sb.Append(" from qc_ilcschedule_request");


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,sb.ToString());

            

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


}