using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Collections.Generic;
using System.Text;

public partial class Design_B2CMobile_Slot_Master : System.Web.UI.Page
{
    List<int> holidayList = new List<int>();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindSlot();
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dtdetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DAY(HolidayDate)HoliDay FROM app_b2c_holiday_master where MONTH(HolidayDate)=@Month And YEAR(HolidayDate)=@Year  ORDER BY   HolidayDate", new MySqlParameter("@Month", DateTime.Now.Month), new MySqlParameter("@Year", DateTime.Now.Year)).Tables[0];
        con.Close();

        if (dtdetail.Rows.Count > 0)
        {
            for (int i = 0; i < dtdetail.Rows.Count; i++)
            {
                holidayList.Add(Util.GetInt(dtdetail.Rows[i]["HoliDay"]));
            }
        }
    }
    List<DateTime> li = new List<DateTime>();
    public List<DateTime> SelectedDates
    {
        get
        {
            if (ViewState["Dates"] != null)
                return (List<DateTime>)ViewState["Dates"];
            else
                li.Add(DateTime.MaxValue.AddDays(-2));
            return li;

        }
        set
        {
            ViewState["Dates"] = value;
        }

    }
    private void bindSlot()
    {
        string mystr = "SELECT StartTime,EndTime,AvgTimeMin FROM app_b2c_slot_master order by StartTime,EndTime;";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(mystr);
        GrdSlots.DataSource = dt;
        GrdSlots.DataBind();

    }
    protected void Calendar1_PreRender(object sender, EventArgs e)
    {
        Calendar1.SelectedDates.Clear();
        foreach (DateTime dt in SelectedDates)
            Calendar1.SelectedDates.Add(dt);
    }
    protected void Calendar1_SelectionChanged(object sender, EventArgs e)
    {
        if (SelectedDates.Contains(Calendar1.SelectedDate))
            SelectedDates.Remove(Calendar1.SelectedDate);
        else
            SelectedDates.Add(Calendar1.SelectedDate);
        ViewState["Dates"] = SelectedDates;
    }
    protected void Calendar1_DayRender(object sender, System.Web.UI.WebControls.DayRenderEventArgs e)
    {
        if (e.Day.IsOtherMonth)
        {
            e.Day.IsSelectable = false;
            e.Cell.Text = "X";
        }
        if (holidayList.Contains(Util.GetInt(e.Day.DayNumberText)) && !e.Day.IsOtherMonth)
        {
            e.Cell.BackColor = System.Drawing.Color.DarkBlue;

        }
    }


    protected void BtnSaveSlot_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);

        List<DateTime> dtli = (List<DateTime>)ViewState["Dates"];


        DateTime dtstart = Util.GetDateTime(ddlStartTime.SelectedValue);
        DateTime dtend = Util.GetDateTime(ddlEndTime.SelectedValue);

        int TotalMin = Util.GetInt(dtend.Subtract(dtstart).TotalMinutes);
        int GapMin = Util.GetInt(dllGappingSlot.SelectedValue);
        int NoOfSlots = Util.GetInt(txtNoOfSlots.Text);

        int TotalCount = TotalMin / GapMin;
        //if (TotalCount > 0)
        //{
        //    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Error', 'Start time And End Time Cannto Be same', '');", true);
        //    return;
        //}
        try
        {

            string Delete = "DELETE FROM app_b2c_slot_master";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, Delete);
            for (int i = 0; i < TotalCount; i++)
            {
                for (int j = 0; j < NoOfSlots; j++)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append("INSERT INTO app_b2c_slot_master(Starttime,Endtime,AvgTimeMin,CreatedBy,CreatedDate)");
                    sb.Append("VALUES (@Starttime,@Endtime,@AvgTimeMin,@CreatedBy,now())");
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@Starttime", dtstart.TimeOfDay),
                                new MySqlParameter("@Endtime", dtstart.AddMinutes(GapMin).TimeOfDay),
                                 new MySqlParameter("@AvgTimeMin", GapMin),
                              new MySqlParameter("@CreatedBy", UserInfo.LoginName)


                              );
                }
                dtstart = dtstart.AddMinutes(Util.GetDouble(GapMin));
            }


            string DeleteHoliday = "DELETE FROM app_b2c_holiday_master where MONTH(HolidayDate)=@month And YEAR(HolidayDate)=@HolidayDate";
            MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, DeleteHoliday.ToString(),
                                 new MySqlParameter("@month", DateTime.Now.Month),
                                new MySqlParameter("@HolidayDate", DateTime.Now.Year)
                                );

            if (dtli != null)
            {
                foreach (DateTime dt in dtli)
                {
                    int Year = dt.Year;
                    if (Year != 9999)
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append("INSERT INTO app_b2c_holiday_master(HolidayDate,CreatedBy,CreatedDate)");
                        sb.Append("VALUES (@HolidayDate,@CreatedBy,now())");
                        MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@HolidayDate", dtstart.TimeOfDay),
                               new MySqlParameter("@CreatedBy", UserInfo.LoginName)
                               );
                    }
                }
            }
            ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', 'Slot Addedd Successfully', '');", true);
            Tranx.Commit();
            Tranx.Dispose();
            bindSlot();
        }
        catch (Exception ex)
        {
            Tranx.Rollback();
            ClientScript.RegisterStartupScript(GetType(), "id", " toast('Error', 'Error occured', '');", true);

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    protected void GrdSlots_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
}

