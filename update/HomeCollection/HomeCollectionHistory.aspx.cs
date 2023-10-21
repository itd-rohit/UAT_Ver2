using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;

public partial class Design_HomeCollection_HomeCollectionHistory : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtappdatere.Text = DateTime.Now.AddDays(1).ToString("dd-MMM-yyyy");
            CalendarExtender1.StartDate = DateTime.Now;
            CalendarExtender1.EndDate = DateTime.Now.AddDays(3);
            txtpid.Text = Util.GetString(Request.QueryString["UHID"]);
        }
    }

    [WebMethod(EnableSession = true)]
    public static string gethistory(string pid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select hc.RouteName, hc.PhlebotomistID, DATE_FORMAT(hc.EntryDateTime,'%d-%b-%Y %h:%i %p')EntryDateTime,hc.EntryByName, phl.Mobile PMobile");
            sb.Append(" , DATE_FORMAT(hc.appdatetime,'%d-%b-%Y %h:%i %p')appdate, plo.prebookingid,plo.Mobile,plo.Patient_ID, ");
            sb.Append(" concat(title,pname)patientname,plo.age,plo.gender,plo.locality,plo.city,plo.state,plo.pincode,cm.centre, ");
            sb.Append(" IFNULL(patientrating,'0')patientrating,IFNULL(PatientFeedback,'')PatientFeedback,IFNULL(phelborating,'0')phelborating ");
            sb.Append(" ,IFNULL(phelbofeedback,'')phelbofeedback,IF(checkin=1,DATE_FORMAT(checkindatetime,'%d-%b-%Y %h:%i %p'),'')checkindatetime, ");
            sb.Append(" IF(isbooked=1,DATE_FORMAT(bookeddate,'%d-%b-%Y %h:%i %p'),'')bookeddate,plo.vip,HardCopyRequired, ");
            sb.Append(" IF(isfinaldone=1,DATE_FORMAT(finaldonedate,'%d-%b-%Y %h:%i %p'),'')finaldonedate,");
            sb.Append(" hc.currentstatus cstatus ,DATE_FORMAT(currentstatusdate,'%d-%b-%Y %h:%i %p')currentstatusdate,phl.name phleboname,ifnull(hc.LedgerTransactionNo,'') visitid,");
            sb.Append(" hc.Alternatemobileno,hc.Client,hc.SourceofCollection,IF(Doctorid='2',OtherDoctor,ReferedDoctor) doctor, ");
            sb.Append(" if(isfinaldone=1,ifnull((SELECT GROUP_CONCAT(concat(id,'#',documentname)) FROM document_detail WHERE labno=hc.LedgerTransactionNo),''),");
            sb.Append(" ifnull((SELECT GROUP_CONCAT(concat(id,'#',documentname)) FROM document_detail WHERE labno=hc.PreBookingID),''))filename,");
            sb.Append(" hc.CancelReason,hc.cancelbyname,DATE_FORMAT(hc.canceldatetime,'%d-%b-%Y %h:%i %p')canceldatetime,");
            sb.Append(" group_concat(plo.ItemName) testname,sum(Rate)Rate,sum(discamt)discamt,sum(netamt) netamt,plo.PaymentMode");
            sb.Append(" ,plo.House_No,plo.landmark,hc.VerificationCode");
            sb.Append(" FROM `patient_labinvestigation_opd_prebooking` plo ");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc ON hc.`PreBookingID`=plo.`PreBookingID` and plo.iscancel=0  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.centreid=plo.PreBookingCentreID");
            sb.Append(" INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` phl ON phl.PhlebotomistID=hc.PhlebotomistID");
            sb.Append(" WHERE plo.Patient_ID=@Patient_ID");
            sb.Append(" GROUP BY plo.prebookingid ORDER BY hc.prebookingid desc ");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@Patient_ID", pid)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveCodeLog(string pid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "insert into " + Util.getApp("HomeCollectionDB") + ".hc_viewcodelog(PrebookingID,UserID,UserName,EntryDateTime) values (@PrebookingID,@UserID,@UserName,now())",
              new MySqlParameter("@PrebookingID", pid),
              new MySqlParameter("@UserID", UserInfo.ID),
              new MySqlParameter("@UserName", UserInfo.LoginName));
            return "";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}