using MySql.Data.MySqlClient;
using Newtonsoft.Json;
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

public partial class Design_HomeCollection_PhleboShareMISRepot : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            DateTimeFormatInfo info = DateTimeFormatInfo.GetInstance(null);
            for (int a = 1; a < 13; a++)
            {
                ddlfrommonth.Items.Add(new ListItem(info.GetMonthName(a), a.ToString()));
                ddltomonth.Items.Add(new ListItem(info.GetMonthName(a), a.ToString()));
                ddlmonthdaywise.Items.Add(new ListItem(info.GetMonthName(a), a.ToString()));

            }

            ListItem selectedListItem = ddlfrommonth.Items.FindByValue(DateTime.Now.Month.ToString());

            if (selectedListItem != null)
            {
                selectedListItem.Selected = true;
            }

            ListItem selectedListItem1 = ddltomonth.Items.FindByValue(DateTime.Now.Month.ToString());

            if (selectedListItem1 != null)
            {
                selectedListItem1.Selected = true;
            }

            ListItem selectedListItem111 = ddlmonthdaywise.Items.FindByValue(DateTime.Now.Month.ToString());

            if (selectedListItem111 != null)
            {
                selectedListItem111.Selected = true;
            }

            for (int a = DateTime.Now.Year - 2; a < DateTime.Now.Year + 10; a++)
            {
                ddlyear.Items.Add(new ListItem(a.ToString(), a.ToString()));
                ddlyeardaywise.Items.Add(new ListItem(a.ToString(), a.ToString()));

            }

            ListItem selectedListItem11 = ddlyear.Items.FindByValue(DateTime.Now.Year.ToString());

            if (selectedListItem11 != null)
            {
                selectedListItem11.Selected = true;
            }

            ListItem selectedListItem112 = ddlyeardaywise.Items.FindByValue(DateTime.Now.Year.ToString());

            if (selectedListItem112 != null)
            {
                selectedListItem112.Selected = true;
            }


            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ddlzone.DataSource = StockReports.GetDataTable("SELECT businesszoneid,businesszonename FROM `businesszone_master`");
            ddlzone.DataValueField = "businesszoneid";
            ddlzone.DataTextField = "businesszonename";
            ddlzone.DataBind();
            ddlzone.Items.Insert(0, new ListItem("Select Zone", "0"));
        }
    }

    [WebMethod]
    public static string bindstate(int zoneid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,state FROM state_master WHERE businesszoneid=@zoneid order by state",
               new MySqlParameter("@zoneid", zoneid)).Tables[0]);

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindcity(int stateid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,city FROM city_master WHERE stateid=@stateid order by city",
           new MySqlParameter("@stateid", stateid)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindPhelbo(int cityid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT hp.`PhlebotomistID`,hp.`Name` FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phleboworklocation` hw ON hp.`PhlebotomistID`=hw.`PhlebotomistID` AND hp.`IsActive`=1 AND hw.`CityId`=@cityid ORDER BY NAME ",
                new MySqlParameter("@cityid", cityid)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod]
    public static string getreport(int reporttype, string fromdate, string todate, string year, string frommonth, string tomonth, string daywiseyear, string daywisemonth, string phlebotomist)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = new DataTable();
            StringBuilder sb = new StringBuilder();
            string[] phlebotomistTags = phlebotomist.Split(',');
            string[] phlebotomistParamNames = phlebotomistTags.Select(
              (s, i) => "@tag" + i).ToArray();
            string phlebotomistClause = string.Join(", ", phlebotomistParamNames);
            string Query = string.Empty;
            if (reporttype == 1)
            {
                sb = new StringBuilder();
                sb.Append(" SELECT hc.State,hc.City,  hp.Name PhlebotomistName,count(1) HomeCollectionCount, SUM(PhleboCharge) Total_Collection_Rupees FROM   " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hc");
                sb.Append(" inner join " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp on hc.PhlebotomistID=hp.`PhlebotomistID`");
                sb.Append(" WHERE CurrentStatus = 'BookingCompleted' ");
                if (phlebotomist != string.Empty)
                {
                    sb.Append(" AND hp.PhlebotomistID in({0}) ");
                }
                sb.Append(" and appdatetime>=@fromdate ");
                sb.Append(" and appdatetime<=@todate ");
                sb.Append(" GROUP BY hp.Name ORDER BY hp.Name ");
                if (phlebotomist != string.Empty)
                    Query = string.Format(sb.ToString(), phlebotomistClause);
                else
                    Query = sb.ToString();
                using (MySqlDataAdapter da = new MySqlDataAdapter(Query, con))
                {
                    if (phlebotomist != string.Empty)
                    {
                        for (int i = 0; i < phlebotomistParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(phlebotomistParamNames[i], phlebotomistTags[i]);
                        }
                    }
                    da.SelectCommand.Parameters.AddWithValue("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                    da.SelectCommand.Parameters.AddWithValue("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "PhleboCollectionSummary";
                        return "true";
                    }
                    else
                    {
                        return "false";
                    }
                }
            }
            else if (reporttype == 2)
            {
                sb = new StringBuilder();

                sb.Append("  SELECT hc.State,hc.City,  hp.Name PhlebotomistName,concat(Month(appdatetime),'~',MONTHNAME(appdatetime)) Month_Name, SUM(PhleboCharge) Total_Collection  ");
                sb.Append(" FROM    " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hc  ");
                sb.Append("  INNER JOIN  " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp ON hc.PhlebotomistID=hp.`PhlebotomistID`  ");
                sb.Append("  WHERE CurrentStatus = 'BookingCompleted'   ");
                if (phlebotomist != string.Empty)
                {
                    sb.Append(" AND hp.PhlebotomistID in({0}) ");
                }
                sb.Append("  AND YEAR(appdatetIme)=@year  ");
                sb.Append("  AND MONTH(appdatetime)>=@frommonth AND MONTH(appdatetime)<=@tomonth  ");
                sb.Append("  GROUP BY  hp.Name , MONTH(appdatetime) ORDER BY MONTH(appdatetime)  ");

                if (phlebotomist != string.Empty)
                    Query = string.Format(sb.ToString(), phlebotomistClause);
                else
                    Query = sb.ToString();
                using (MySqlDataAdapter da = new MySqlDataAdapter(Query, con))
                {
                    if (phlebotomist != string.Empty)
                    {
                        for (int i = 0; i < phlebotomistParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(phlebotomistParamNames[i], phlebotomistTags[i]);
                        }
                    }
                    da.SelectCommand.Parameters.AddWithValue("@year", year);
                    da.SelectCommand.Parameters.AddWithValue("@tomonth", tomonth);
                    da.SelectCommand.Parameters.AddWithValue("@frommonth", frommonth);
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        dt = changedatatable(dt);
                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "PhleboCollectionMonthWise";
                        return "true";
                    }
                    else
                    {
                        return "false";
                    }
                }
            }
            else if (reporttype == 3)
            {
                sb = new StringBuilder();
                sb.Append("   SELECT hc.State,hc.City,  hp.Name PhlebotomistName,DAY(appdatetime)Day_Name, SUM(PhleboCharge) Total_Collection  ");
                sb.Append("  FROM   " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking hc  ");
                sb.Append("  INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` hp ON hc.PhlebotomistID=hp.`PhlebotomistID`  ");
                sb.Append("   WHERE CurrentStatus = 'BookingCompleted'   ");
                if (phlebotomist != string.Empty)
                {
                    sb.Append(" AND hp.PhlebotomistID in({0}) ");
                }
                sb.Append("   AND YEAR(appdatetIme)=@daywiseyear  ");
                sb.Append("   AND MONTH(appdatetime)=@daywisemonth   ");
                sb.Append("   GROUP BY  hp.Name , DAY(appdatetime) ORDER BY DAY(appdatetime)  ");
                if (phlebotomist != string.Empty)
                    Query = string.Format(sb.ToString(), phlebotomistClause);
                else
                    Query = sb.ToString();
                using (MySqlDataAdapter da = new MySqlDataAdapter(Query, con))
                {
                    if (phlebotomist != string.Empty)
                    {
                        for (int i = 0; i < phlebotomistParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(phlebotomistParamNames[i], phlebotomistTags[i]);
                        }
                    }
                    da.SelectCommand.Parameters.AddWithValue("@daywiseyear", daywiseyear);
                    da.SelectCommand.Parameters.AddWithValue("@daywisemonth", daywisemonth);
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        dt = changedatatable1(dt);
                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "PhleboCollectionDayWise";
                        return "true";
                    }
                    else
                    {
                        return "false";
                    }
                }
            }
            else if (reporttype == 4)
            {
                sb = new StringBuilder();
                sb.Append(" select hc.State,hc.city,hc.locality Area, if(cm.type1='PCC',concat(cm.centre,'~',cm.COCO_FOCO),cm.centre) as centre,hc.currentstatus  , DATE_FORMAT(hc.EntryDateTime,'%d-%b-%Y %h:%i %p')EntryDateTime,hc.EntryByName,");
                sb.Append(" DATE_FORMAT(hc.appdatetime,'%d-%b-%Y %h:%i %p')AppointmentDate, plo.prebookingid,plo.Mobile,plo.Patient_ID, ");
                sb.Append(" concat(title,pname)patientname,plo.age,plo.gender,plo.locality,plo.city,plo.state,plo.pincode, ");
                sb.Append(" group_concat(itemname) TestName,sum(Rate) Rate,sum(DiscAmt) DiscAmt,sum(NetAmt) NetAmt,");
                sb.Append(" phl.name phleboname, phl.Mobile phleboMobile,IFNULL (PhelboSource,'') PhelboSource,IF(phl.`IsTemp`=0,'Permanent Phelbo','Temporary Phelbo') AS PhelboType,ifnull(hc.LedgerTransactionNo,'') visitid,");
                sb.Append(" hc.Alternatemobileno,hc.Client,hc.SourceofCollection,IF(Doctorid='2',OtherDoctor,ReferedDoctor) doctor ,");
                sb.Append(" IFNULL(patientrating,'0')patientrating,IFNULL(PatientFeedback,'')PatientFeedback,IFNULL(phelborating,'0')phelborating ");
                sb.Append(" ,IFNULL(phelbofeedback,'')phelbofeedback,IF(checkin=1,DATE_FORMAT(checkindatetime,'%d-%b-%Y %h:%i %p'),'')checkindatetime, ");
                sb.Append(" IF(isbooked=1,DATE_FORMAT(bookeddate,'%d-%b-%Y %h:%i %p'),'')bookeddate,plo.vip,HardCopyRequired,plo.Remarks,hc.PhleboCharge PhleboCollection ");
                sb.Append(" ");
                sb.Append(" FROM `patient_labinvestigation_opd_prebooking` plo ");
                sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ON hc.`PreBookingID`=plo.`PreBookingID`  ");
                sb.Append(" INNER JOIN centre_master cm ON cm.centreid=plo.PreBookingCentreID");
                sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` phl ON phl.PhlebotomistID=hc.PhlebotomistID");
                sb.Append(" WHERE ");
                sb.Append(" hc.appdatetime>=@fromdate ");
                sb.Append(" and hc.appdatetime<=@todate ");
                if (phlebotomist != string.Empty)
                {
                    sb.Append(" and phl.PhlebotomistID in({0}) ");
                }
                sb.Append(" GROUP BY plo.prebookingid ORDER BY prebookingid ");
                if (phlebotomist != string.Empty)
                    Query = string.Format(sb.ToString(), phlebotomistClause);
                else
                    Query = sb.ToString();
                using (MySqlDataAdapter da = new MySqlDataAdapter(Query, con))
                {
                    if (phlebotomist != string.Empty)
                    {
                        for (int i = 0; i < phlebotomistParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(phlebotomistParamNames[i], phlebotomistTags[i]);
                        }
                    }
                    da.SelectCommand.Parameters.AddWithValue("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                    da.SelectCommand.Parameters.AddWithValue("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "PhleboCollectionDetail";
                        return "true";
                    }
                    else
                    {
                        return "false";
                    }
                }
            }
            return "false";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "false";

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public static DataTable changedatatable(DataTable dt)
    {
        DataTable dtme = new DataTable();
        dtme.Columns.Add("State");
        dtme.Columns.Add("City");
        dtme.Columns.Add("PhlebotomistName");

        DataView dv1 = dt.DefaultView.ToTable(true, "PhlebotomistName").DefaultView;
        dv1.Sort = "PhlebotomistName asc";
        DataTable dtCentre1 = dv1.ToTable();


        DataView dv = dt.DefaultView.ToTable(true, "Month_Name").DefaultView;
        dv.Sort = "Month_Name asc";
        DataTable dtCentre = dv.ToTable();

        DataColumn dc;
        foreach (DataRow dw in dtCentre.Rows)
        {
            dc = new DataColumn(dw["Month_Name"].ToString());
            dtme.Columns.Add(dc);

        }

        foreach (DataRow dwrr in dtCentre1.Rows)
        {
            DataRow dwr = dtme.NewRow();

            dwr["PhlebotomistName"] = dwrr["PhlebotomistName"].ToString();
            DataRow[] dwme = dt.Select("PhlebotomistName='" + dwrr["PhlebotomistName"].ToString() + "'");

            foreach (DataRow dwm in dwme)
            {
                dwr["State"] = dwm["State"].ToString();
                dwr["City"] = dwm["City"].ToString();
                dwr[dwm["Month_Name"].ToString()] = dwm["total_collection"].ToString();
            }
            dtme.Rows.Add(dwr);

        }


        return dtme;
    }

    public static DataTable changedatatable1(DataTable dt)
    {
        DataTable dtme = new DataTable();
        dtme.Columns.Add("State");
        dtme.Columns.Add("City");
        dtme.Columns.Add("PhlebotomistName");

        DataView dv1 = dt.DefaultView.ToTable(true, "PhlebotomistName").DefaultView;
        dv1.Sort = "PhlebotomistName asc";
        DataTable dtCentre1 = dv1.ToTable();


        DataView dv = dt.DefaultView.ToTable(true, "Day_Name").DefaultView;
        dv.Sort = "Day_Name asc";
        DataTable dtCentre = dv.ToTable();

        DataColumn dc;
        foreach (DataRow dw in dtCentre.Rows)
        {
            dc = new DataColumn(dw["Day_Name"].ToString());
            dtme.Columns.Add(dc);

        }

        foreach (DataRow dwrr in dtCentre1.Rows)
        {
            DataRow dwr = dtme.NewRow();

            dwr["PhlebotomistName"] = dwrr["PhlebotomistName"].ToString();
            DataRow[] dwme = dt.Select("PhlebotomistName='" + dwrr["PhlebotomistName"].ToString() + "'");

            foreach (DataRow dwm in dwme)
            {
                dwr["State"] = dwm["State"].ToString();
                dwr["City"] = dwm["City"].ToString();
                dwr[dwm["Day_Name"].ToString()] = dwm["total_collection"].ToString();
            }
            dtme.Rows.Add(dwr);

        }


        return dtme;
    }
}