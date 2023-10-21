using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_CentreAppointmentSearch : System.Web.UI.Page
{
    public int roleid = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            roleid = UserInfo.RoleID;
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            AllLoad_Data.bindState(ddlstate);
            ddlstate.Items.Insert(0, new ListItem("Select", "0"));
            CalendarExtender1.StartDate = DateTime.Now;
            CalendarExtender1.EndDate = DateTime.Now.AddDays(3);


        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindcentre(string areaid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT droplocationid,centre FROM " + Util.getApp("HomeCollectionDB") + ".hc_area_droplocation_mapping hc INNER JOIN centre_master cm ON cm.centreid=hc.droplocationid WHERE hc.localityid=@areaid",
                new MySqlParameter("@areaid", areaid)).Tables[0]);
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

    [WebMethod(EnableSession = true)]
    public static string bindphelbo(string areaid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT hc.PhlebotomistID,`name` FROM " + Util.getApp("HomeCollectionDB") + ".hc_area_phlebotomist_mapping hc INNER JOIN " + Util.getApp("HomeCollectionDB") + ".hc_phlebotomistmaster cm ON cm.PhlebotomistID=hc.PhlebotomistID WHERE hc.localityid=@areaid",
                new MySqlParameter("@areaid", areaid)).Tables[0]);
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

    [WebMethod(EnableSession = true)]
    public static string getdata(string fromdate, string todate, string stateId, string cityid, string areaid, string pincode, string centre, string phelbo, string mobileno, string pname, string status, string dateoption, string prebookingno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select '' RouteName, '' PhlebotomistID, DATE_FORMAT(plo.CreatedDate,'%d-%b-%Y %h:%i %p')EntryDateTime,plo.CreatedBy EntryByName, '' PMobile,plo.Remarks");
            sb.Append(" , DATE_FORMAT(plo.CentreVisitDateTime,'%d-%b-%Y %h:%i %p')appdate, plo.prebookingid,plo.Mobile,plo.Patient_ID, ");
            sb.Append(" concat(title,pname)patientname,plo.age,plo.gender,plo.locality,plo.city,plo.state,plo.pincode,if(cm.type1='PCC',concat(cm.centre,'~',cm.COCO_FOCO),cm.centre) as centre, ");
            sb.Append(" '' patientrating,'' PatientFeedback,'' phelborating ");
            sb.Append(" ,'' phelbofeedback,'' checkindatetime, ");
            sb.Append(" IF(ifnull(LedgertransactionID,'0')<>0,DATE_FORMAT(plo.BookingDate,'%d-%b-%Y %h:%i %p'),'')bookeddate,plo.vip,0 HardCopyRequired, ");
            sb.Append(" '' finaldonedate,");
            sb.Append(" if(ifnull(LedgertransactionID,'0')<>0,'BookingCompleted','Pending') cstatus ,'' currentstatusdate,'' phleboname,ifnull(plo.LedgerTransactionID,'') visitid,");
            sb.Append(" '' Alternatemobileno,'' Client,'' SourceofCollection,IF(Doctorid='2',OtherDoctor,ReferedDoctor) doctor, ");
            sb.Append(" '' filename,");
            sb.Append(" plo.CancelReasonVisit CancelReason,'' cancelbyname,'' canceldatetime");
            sb.Append(" ,'' cancelremarks,");
            sb.Append(" '' requestedremarks,");
            sb.Append(" '' requestdate");

            sb.Append(" ,plo.House_No,plo.landmark,'' VerificationCode");
            sb.Append(" ,'' PhelboType,'' PhelboSource ");
            sb.Append(" FROM `patient_labinvestigation_opd_prebooking` plo ");

            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=plo.PreBookingCentreID and plo.visittype='Center Visit'");

            sb.Append(" WHERE plo.CentreVisitDateTime IS NOT NULL and ");
            sb.Append(" " + dateoption + ">=@fromdate ");
            sb.Append(" and " + dateoption + "<=@todate ");

            if (stateId != "0")
            {
                sb.Append(" and plo.stateid=@stateId ");
            }
            if (cityid != "0" && cityid != null && cityid != string.Empty)
            {
                sb.Append(" and plo.cityid=@cityid ");
            }
            if (areaid != "0" && areaid != null && areaid != string.Empty)
            {
                sb.Append(" and plo.localityid=@areaid ");
            }
            if (pincode != string.Empty)
            {
                sb.Append(" and plo.pincode=@pincode ");
            }
            if (centre != "0" && centre != null && centre != string.Empty)
            {
                sb.Append(" and plo.PreBookingCentreID=@centre ");
            }
            if (phelbo != "0" && phelbo != null && phelbo != string.Empty)
            {
                sb.Append(" and plo.PhlebotomistID=@phelbo ");
            }

            if (pname != string.Empty)
            {
                sb.Append(" and plo.pname like @pname ");
            }
            if (mobileno != string.Empty)
            {
                sb.Append(" and plo.mobile=@mobileno ");
            }
            if (prebookingno != string.Empty)
            {
                sb.Append("and plo.prebookingid=@prebookingno ");
            }
            if (status != string.Empty)
            {
                sb.Append(" and hc.currentstatus='@currentstatus");
            }
            sb.Append(" GROUP BY plo.prebookingid ORDER BY prebookingid ");

            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@currentstatus", status),
               new MySqlParameter("@prebookingno", prebookingno),
               new MySqlParameter("@mobileno", mobileno),
               new MySqlParameter("@phelbo", phelbo),
               new MySqlParameter("@centre", centre),
               new MySqlParameter("@pincode", pincode),
               new MySqlParameter("@areaid", areaid),
               new MySqlParameter("@cityid", cityid),
               new MySqlParameter("@stateId", stateId),
               new MySqlParameter("@pname", string.Format("%{0}%", Util.GetString(pname))),
                   new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                   new MySqlParameter("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59"))
               ).Tables[0]);
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

    [WebMethod(EnableSession = true)]
    public static string BindItemDetail(string prebookingid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT itemid,itemname,IF(subcategoryid=15,'Package','Test')itemtype,rate,discamt,netamt ,paymentmode ");
            sb.Append("FROM patient_labinvestigation_opd_prebooking where prebookingid=@prebookingid and iscancel=0  order by itemname");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@prebookingid", prebookingid)).Tables[0]);
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

    [WebMethod(EnableSession = true)]
    public static string exporttoexcel(string fromdate, string todate, string stateId, string cityid, string areaid, string pincode, string centre, string phelbo, string mobileno, string pname, string dateoption, string prebookingno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select if(cm.type1='PCC',concat(cm.centre,'~',cm.COCO_FOCO),cm.centre) as centre,hc.currentstatus  , DATE_FORMAT(hc.EntryDateTime,'%d-%b-%Y %h:%i %p')EntryDateTime,hc.EntryByName,");
            sb.Append(" DATE_FORMAT(hc.appdatetime,'%d-%b-%Y %h:%i %p')AppointmentDate, plo.prebookingid,plo.Mobile,plo.Patient_ID, ");
            sb.Append(" concat(title,pname)patientname,plo.age,plo.gender,plo.locality,plo.city,plo.state,plo.pincode, ");
            sb.Append(" group_concat(itemname) TestName,sum(Rate) Rate,sum(DiscAmt) DiscAmt,sum(NetAmt) NetAmt,");
            sb.Append(" phl.name phleboname, phl.Mobile PMobile,IFNULL (PhelboSource,'') PhelboSource,IF(phl.`IsTemp`=0,'Permanent Phelbo','Temporary Phelbo') AS PhelboType,ifnull(hc.LedgerTransactionNo,'') visitid,");
            sb.Append(" hc.Alternatemobileno,hc.Client,hc.SourceofCollection,IF(Doctorid='2',OtherDoctor,ReferedDoctor) doctor ,");
            sb.Append(" IFNULL(patientrating,'0')patientrating,IFNULL(PatientFeedback,'')PatientFeedback,IFNULL(phelborating,'0')phelborating ");
            sb.Append(" ,IFNULL(phelbofeedback,'')phelbofeedback,IF(checkin=1,DATE_FORMAT(checkindatetime,'%d-%b-%Y %h:%i %p'),'')checkindatetime, ");
            sb.Append(" IF(isbooked=1,DATE_FORMAT(bookeddate,'%d-%b-%Y %h:%i %p'),'')bookeddate,plo.vip,HardCopyRequired,plo.Remarks ");
            sb.Append(" ");

            sb.Append(" FROM `patient_labinvestigation_opd_prebooking` plo ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ON hc.`PreBookingID`=plo.`PreBookingID`  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=plo.PreBookingCentreID");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` phl ON phl.PhlebotomistID=hc.PhlebotomistID");
            sb.Append(" WHERE ");
            sb.Append(" " + dateoption + ">=@fromdate ");
            sb.Append(" and " + dateoption + "<=@todate ");

            if (stateId != "0")
            {
                sb.Append(" and plo.stateid=@stateId ");
            }
            if (cityid != "0" && cityid != null && cityid != string.Empty)
            {
                sb.Append(" and plo.cityid=@cityid ");
            }
            if (areaid != "0" && areaid != null && areaid != string.Empty)
            {
                sb.Append(" and plo.localityid=@areaid ");
            }
            if (pincode != string.Empty)
            {
                sb.Append(" and plo.pincode=@pincode ");
            }
            if (centre != "0" && centre != null && centre != string.Empty)
            {
                sb.Append(" and plo.PreBookingCentreID=@centre ");
            }
            if (phelbo != "0" && phelbo != null && phelbo != string.Empty)
            {
                sb.Append(" and plo.PhlebotomistID=@phelbo ");
            }

            if (pname != string.Empty)
            {
                sb.Append(" and plo.pname like @pname ");
            }
            if (mobileno != string.Empty)
            {
                sb.Append(" and plo.mobile=@mobileno ");
            }
            if (prebookingno != string.Empty)
            {
                sb.Append("and plo.prebookingid=@prebookingno ");
            }

            //if (status != "")
            //{
            //    sb.Append(" and hc.currentstatus='" + status + "'");
            //}
            sb.Append(" GROUP BY plo.prebookingid ORDER BY prebookingid ");

            DataTable dt =  MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@prebookingno", prebookingno),
               new MySqlParameter("@mobileno", mobileno),
               new MySqlParameter("@phelbo", phelbo),
               new MySqlParameter("@centre", centre),
               new MySqlParameter("@pincode", pincode),
               new MySqlParameter("@areaid", areaid),
               new MySqlParameter("@cityid", cityid),
               new MySqlParameter("@stateId", stateId),
               new MySqlParameter("@pname", string.Format("%{0}%", Util.GetString(pname))),
                   new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(fromdate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                   new MySqlParameter("@todate", string.Concat(Util.GetDateTime(todate).ToString("yyyy-MM-dd"), " ", "23:59:59")))
               .Tables[0];
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
                HttpContext.Current.Session["ReportName"] = "HomeCollectionReport";
                return "true";
            }
            else
            {
                return "false";
            }
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

}