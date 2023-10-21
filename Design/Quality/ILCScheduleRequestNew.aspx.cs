using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
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
            //DataTable dtProgram = StockReports.GetDataTable("SELECT ProgramID,ProgramName FROM qc_eqasprogrammaster WHERE isactive=1 ");
            //if (dtProgram.Rows.Count>0)
            //{
            //    ddlprogram.DataSource = dtProgram;
            //    ddlprogram.DataTextField = "ProgramName";
            //    ddlprogram.DataValueField = "ProgramID";
            //    ddlprogram.DataBind();
            //}


            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            //calFromDate.StartDate = DateTime.Now;

            //CalendarExtender1.StartDate = DateTime.Now;

            //CalendarExtender2.StartDate = DateTime.Now;

            //CalendarExtender3.StartDate = DateTime.Now;

            for (int a = DateTime.Now.Year - 2; a < DateTime.Now.Year + 10; a++)
            {
                txtcurrentyear.Items.Add(new ListItem(a.ToString(), a.ToString()));
            }

            ListItem selectedListItem1 = txtcurrentyear.Items.FindByValue(DateTime.Now.Year.ToString());

            if (selectedListItem1 != null)
            {
                selectedListItem1.Selected = true;
            }
        }
    }

    [WebMethod(EnableSession = true)]
    public static string GetAllProgram(string centreid)
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT pm.ProgramID,pm.ProgramName FROM qc_eqasprogrammaster pm INNER JOIN qc_eqasprogramlabmapping plm ON pm.ProgramID=plm.ProgramID AND pm.isactive=1 AND plm.ProcessingLabID='" + centreid + "' Group by pm.ProgramID "));
    }


    [WebMethod(EnableSession = true)]
    public static string bindCentre()
    {

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT centreid,centre FROM centre_master cm WHERE  cm.isActive=1 ORDER BY centre"));


    }


    [WebMethod]
    public static string SaveData(string centreid, string ProgramID, string YearID, List<MontDetail> MontDetail, string reason)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM qc_ilcschedule_request_new where ProcessingLabID=@ProcessingLabID and ProgramID=@ProgramID and Year=@Year",
                    new MySqlParameter("@ProcessingLabID", centreid),
                     new MySqlParameter("@ProgramID", ProgramID),
                      new MySqlParameter("@Year", YearID)
                   );
            foreach (MontDetail obj in MontDetail)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into qc_ilcschedule_request_new (ProcessingLabID,ProgramID,Year,MonthID,MonthName,MonthFromDate,MonthToDate,Remarks,IsActive,EntryDate,EntryByID,EntryByName) values (@ProcessingLabID,@ProgramID,@Year,@MonthID,@MonthName,@MonthFromDate,@MonthToDate,@Remarks,@IsActive,@EntryDate,@EntryByID,@EntryByName)",
                    new MySqlParameter("@ProcessingLabID", centreid),
                     new MySqlParameter("@ProgramID", ProgramID),
                      new MySqlParameter("@Year", YearID),
                       new MySqlParameter("@MonthID", obj.MonthID),
                       new MySqlParameter("@MonthName", obj.MonthName),
                         new MySqlParameter("@MonthFromDate", obj.FromDate),
                          new MySqlParameter("@MonthToDate", obj.ToDate),
                           new MySqlParameter("@Remarks", reason),
                            new MySqlParameter("@IsActive", obj.IsActive),
                            new MySqlParameter("@EntryDate", DateTime.Now),
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
    public static string GetMonth(string centreid, string ProgramID, string YearID)
    {

        try
        {
            DataTable dtDetail = new DataTable();
            dtDetail.Columns.Add("MonthName", typeof(String));
            dtDetail.Columns.Add("MonthID", typeof(Int32));
            dtDetail.Columns.Add("MonthDays", typeof(Int32));
            dtDetail.Columns.Add("SelectedMonthFromDay", typeof(Int32));
            dtDetail.Columns.Add("SelectedMonthToDay", typeof(Int32));
            dtDetail.Columns.Add("Remarks", typeof(String));
            dtDetail.Columns.Add("IsActive", typeof(Int32));
            DataTable dtMonthDetail = StockReports.GetDataTable("SELECT MonthName,MonthFromDate,MonthToDate,Remarks,IsActive FROM qc_ilcschedule_request_new WHERE ProcessingLabID=" + centreid + " AND ProgramID=" + ProgramID + " AND YEAR=" + YearID + "  ");
            if (dtMonthDetail.Rows.Count > 0)
            {
                for (int a = 0; a < dtMonthDetail.Rows.Count; a++)
                {
                    int days = DateTime.DaysInMonth(Util.GetInt(YearID), a+1);
                    DataRow dr = dtDetail.NewRow();
                    dr["MonthName"] = Util.GetString(dtMonthDetail.Rows[a]["MonthName"]);
                    dr["MonthID"] = a + 1;
                    dr["MonthDays"] = days;
                    dr["SelectedMonthFromDay"] = Util.GetString(dtMonthDetail.Rows[a]["MonthFromDate"]);
                    dr["SelectedMonthToDay"] = Util.GetString(dtMonthDetail.Rows[a]["MonthToDate"]);
                    dr["Remarks"] = Util.GetString(dtMonthDetail.Rows[a]["Remarks"]);
                    dr["IsActive"] = Util.GetString(dtMonthDetail.Rows[a]["IsActive"]);
                    dtDetail.Rows.Add(dr);
                }
            }
            else
            {
                DateTimeFormatInfo info = DateTimeFormatInfo.GetInstance(null);
                List<ListItem> liMonth = new List<ListItem>();
                for (int a = 1; a < 13; a++)
                {
                    int days = DateTime.DaysInMonth(Util.GetInt(YearID), a);
                    DataRow dr = dtDetail.NewRow();
                    dr["MonthName"] = info.GetMonthName(a);
                    dr["MonthID"] = a.ToString();
                    dr["MonthDays"] = days;
                    dr["SelectedMonthFromDay"] = "1";
                    dr["SelectedMonthToDay"] = "1";
                    dr["Remarks"] = "";
                    dr["IsActive"] = "0";
                    dtDetail.Rows.Add(dr);
                }
            }
            dtDetail.AcceptChanges();
            return Newtonsoft.Json.JsonConvert.SerializeObject(dtDetail);
        }
        catch (Exception ex)
        {
            return "";
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
public class MontDetail
{
    public int MonthID { get; set; }
    public string MonthName { get; set; }
    public int FromDate { get; set; }
    public int ToDate { get; set; }
    public int IsActive { get; set; }
}