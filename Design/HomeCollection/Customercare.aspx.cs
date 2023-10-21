using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_Customercare : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtmobile.Focus();
            ddltitle.DataSource = AllGlobalFunction.NameTitle;
            ddltitle.DataBind();
            AllLoad_Data.bindState(ddlstate);
            ddlstate.Items.Insert(0, new ListItem("Select", "0"));

            string mobileno = Util.GetString(Request.QueryString["mobileno"]);
            if (mobileno != "")
            {
                txtmobile.Text = mobileno;
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "searcholdpatientbymobile();", true);
            }
        }
    }
    [WebMethod]
    public static string bindhcrequestdata(string hcrequestid, string mobileno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT mobileno,Patient_id, Pname,Age,Gender,Pincode,Address,Test,Homecollectiondatetime,ifnull(filename,'')filename  ");

            sb.Append(" FROM `call_whatsapp_homecollection` WHERE id=@hcrequestid and mobileno=@mobileno");

            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@hcrequestid", hcrequestid),
                new MySqlParameter("@mobileno", mobileno)).Tables[0];


            return JsonConvert.SerializeObject(dt);
        }
        catch
        {
            return JsonConvert.SerializeObject(dt);

        }
        finally
        {
            if (con.State == ConnectionState.Open)
            {
                con.Close();
                con.Dispose();
            }
        }
    }


    [WebMethod]
    public static string bindfollowdata(string followupcallid, string mobileno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT contactno mobileno,'' Patient_id,name Pname,Ageyear Age,Gender,Pincode,Address,'' Test,'' Homecollectiondatetime,'' filename  ");

            sb.Append(" FROM `call_ProductMaster_detail` WHERE id=@hcrequestid and contactno=@mobileno");

            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@hcrequestid", followupcallid),
                new MySqlParameter("@mobileno", mobileno)).Tables[0];


            return JsonConvert.SerializeObject(dt);
        }
        catch
        {
            return JsonConvert.SerializeObject(dt);

        }
        finally
        {

            con.Close();
            con.Dispose();

        }
    }

    [WebMethod(EnableSession = true)]
    public static string BindOldPatient(string searchdata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT CONCAT(title,pname) NAME,Age,Gender,Patient_id,house_no,localityid,Locality,cityid,City,Pincode,stateid,State,Mobile,Email,title,pname ");
            sb.Append(" ,DATE_FORMAT(pm.dtEntry,'%d-%b-%Y %h:%I %p') visitdate,'' LastCall, '' ReasonofCall,'' ReferDoctor,'' Source, date_format(dob,'%d-%b-%Y')dob,");
            sb.Append(" ifnull((select currentstatus from  " + Util.getApp("HomeCollectionDB") + ".hc_homecollectionbooking where patient_id=pm.patient_id order by id desc limit 1),'') lasthcstatus");

            sb.Append(" FROM patient_master pm WHERE mobile=@mobile ");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@mobile", searchdata)).Tables[0];


            return JsonConvert.SerializeObject(dt);
        }
        catch (Exception Ex)
        {
            return JsonConvert.SerializeObject(Ex);

        }
        finally
        {
           
                con.Close();
                con.Dispose();
            
        }

    }
    [WebMethod(EnableSession = true)]
    public static string BindOldPatientHomeCollectionData(string searchdata)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DATE_FORMAT(hc.appdatetime,'%d-%b-%Y %h:%i %p')appdate,currentstatus,");
            sb.Append(" iFNULL(hc.ledgertransactionno,'') visitid,hc.prebookingid, ");
            sb.Append(" IFNULL(hc.`PhelboRating`,0)PhelboRating,IFNULL(hc.`PatientRating`,0)PatientRating ");
            sb.Append(" FROM  " + Util.getApp("HomeCollectionDB") + ".`hc_homecollectionbooking` hc WHERE patient_id=@searchdata ORDER BY id DESC LIMIT 1");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@searchdata", searchdata)).Tables[0])
            {
                return JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(ex);
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    public static string bindpincode(string LocalityID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IFNULL(pincode,'')pincode FROM `f_locality` WHERE ID=@LocalityID",
                                            new MySqlParameter("@LocalityID", LocalityID)));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveNewPatient(Patient_Master PatientDatamain)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (Util.GetString(PatientDatamain.Mobile).Trim() != string.Empty)
            {
                int totPatientOnMob = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM patient_master  WHERE Mobile=@PatientDatamain  ",
                    new MySqlParameter("@PatientDatamain", PatientDatamain.Mobile)));
                if (totPatientOnMob >= 5)
                {
                    tnx.Rollback();
                    return "Already More Than 5 Patient Registered With That Mobile No. : " + PatientDatamain.Mobile + " , Kindly Use Another Mobile No.";
                }
            }
            Patient_Master objPM = new Patient_Master(tnx);
            objPM.Title = PatientDatamain.Title;
            objPM.PName = PatientDatamain.PName;
            objPM.House_No = PatientDatamain.House_No;
            objPM.Street_Name = PatientDatamain.Street_Name;
            objPM.Locality = PatientDatamain.Locality;
            objPM.City = PatientDatamain.City;
            objPM.Pincode = PatientDatamain.Pincode;
            objPM.State = PatientDatamain.State;
            objPM.Country = PatientDatamain.Country;
            objPM.Street_Name = PatientDatamain.Street_Name;
            objPM.Phone = PatientDatamain.Phone;
            objPM.Mobile = PatientDatamain.Mobile;
            objPM.Email = PatientDatamain.Email;
            objPM.DOB = PatientDatamain.DOB;
            objPM.Age = PatientDatamain.Age;
            objPM.AgeYear = PatientDatamain.AgeYear;
            objPM.AgeMonth = PatientDatamain.AgeMonth;
            objPM.AgeDays = PatientDatamain.AgeDays;
            objPM.TotalAgeInDays = PatientDatamain.TotalAgeInDays;
            objPM.Gender = PatientDatamain.Gender;
            objPM.CentreID = UserInfo.Centre;
            objPM.StateID = PatientDatamain.StateID;
            objPM.CityID = PatientDatamain.CityID;
            objPM.LocalityID = PatientDatamain.LocalityID;
            objPM.IsOnlineFilterData = PatientDatamain.IsOnlineFilterData;
            objPM.IsDuplicate = PatientDatamain.IsDuplicate;
            objPM.IsDOBActual = PatientDatamain.IsDOBActual;
            objPM.EmployeeID = PatientDatamain.EmployeeID;
            objPM.Relation = PatientDatamain.Relation;
            objPM.Patient_ID_Interface = PatientDatamain.Patient_ID_Interface;
            objPM.CountryID=PatientDatamain.CountryID;
            string PatientID=objPM.Insert();

            String SMSTemplate = Util.GetString(MySqlHelper.ExecuteScalar(tnx,CommandType.Text,"Select Template from sms_configuration where IsActive=1 and id=24 and IsPatient=1"));
            //String WhatsappTemplate = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select Template from whatsapp_configuration where IsActive=1 and id=1 and IsPatient=1"));
            SMSTemplate = SMSTemplate.Replace("{PName}", PatientDatamain.PName).Replace("{PatientID}", PatientID).Replace("{Age}",PatientDatamain.Age).Replace("{Gender}",PatientDatamain.Gender).Replace("{DOB}",PatientDatamain.DOB.ToString());
            //WhatsappTemplate = WhatsappTemplate.Replace("{PName}", PatientDatamain.PName).Replace("{PatientID}", PatientID).Replace("{Age}", PatientDatamain.Age).Replace("{Gender}", PatientDatamain.Gender).Replace("{DOB}", PatientDatamain.DOB.ToString());
            if (SMSTemplate != "")
            {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO " + Util.getApp("HomeCollectionDB") + ".sms(Mobile_No,SMS_text,SMS_Type,LedgertransactionID,UserID,IsSend)VALUES(@MobileNo,@SMS_text,@SMS_Type,@LedgertransactionID,@UserID,'0')",
                                               new MySqlParameter("@MobileNo", PatientDatamain.Mobile),
                                               new MySqlParameter("@SMS_text", SMSTemplate),
                                               new MySqlParameter("@SMS_Type", "CallCentre"),
                                               new MySqlParameter("@LedgertransactionID", 0),
                                               new MySqlParameter("@UserID", UserInfo.ID));

            }
            //if (WhatsappTemplate != "")
            //{
            //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO " + Util.getApp("HomeCollectionDB") + ".hc_sms_whatsapp(Mobile_No,SMS_text,Type,Labno,UserID,IsSend)VALUES(@MobileNo,@SMS_text,@SMS_Type,@LedgertransactionID,@UserID,'0')",
            //                               new MySqlParameter("@MobileNo", PatientDatamain.Mobile),
            //                               new MySqlParameter("@SMS_text", WhatsappTemplate),
            //                               new MySqlParameter("@SMS_Type", "CallCentre"),
            //                               new MySqlParameter("@LedgertransactionID", 0),
            //                               new MySqlParameter("@UserID", UserInfo.ID));

            //}
            // Email To Patient
            String EmailTemplate = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "Select Concat(Subject,'#',Template) from Email_configuration sc inner join Email_configuration_client scc on sc.id=scc.emailconfigurationid where sc.IsActive=1  and sc.id=8 and IsPatient=1 LIMIT 1"));
			if (EmailTemplate != "" && PatientDatamain.Email != string.Empty)
            {
            EmailTemplate = EmailTemplate.Split('#')[1].Replace("{PName}", PatientDatamain.PName).Replace("{PatientID}", PatientID).Replace("{Age}", PatientDatamain.Age).Replace("{Gender}", PatientDatamain.Gender).Replace("{DOB}", PatientDatamain.DOB.ToString());
            //Whatsapp To Patient
           
                StringBuilder sbSMS = new StringBuilder();
                sbSMS.Append(" INSERT INTO " + Util.getApp("HomeCollectionDB") + ".hc_email_sender(PreBookingID,EmailID,EmailIDCC,EmailIDBCC,Subject,EmailBody,EmailType,EmailReceiver,EntryDateTime,EntryByID,EntryByName) ");
                sbSMS.Append(" values(@PreBookingID, @EmailID,'','',@Subject,@EmailBody,'CallCentre','',now(),@EntryByID,@EntryByName) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbSMS.ToString(),
                            new MySqlParameter("@PreBookingID", 0),
                            new MySqlParameter("@Subject", EmailTemplate.Split('#')[0]),
                            new MySqlParameter("@EmailBody", EmailTemplate.ToString()),
                            new MySqlParameter("@EntryByID", UserInfo.ID),
                            new MySqlParameter("@EntryByName", UserInfo.LoginName),
                            new MySqlParameter("@EmailID", Util.GetString(PatientDatamain.Email)));
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
    [WebMethod(EnableSession = true)]
    public static string getCallDetail(string ContactNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DATE_FORMAT(dtEntry,'%d-%b-%Y %h:%i %p')CallDateTime,IFNULL(Call_Type,'')Call_Type,UserName,IFNULL(Remarks,'')Remarks FROM Call_Centre_Log WHERE Mobile=@Mobile ORDER BY dtEntry DESC",
               new MySqlParameter("@Mobile", ContactNo)).Tables[0];

            if (dt.Rows.Count > 0)
                return JsonConvert.SerializeObject(new { status = "true", response = "Record Found", responseDetail = Util.getJson(dt) });
            else
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found", responseDetail = "null" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error", responseDetail = "null" });
        }

        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveNewPatientforMisc(Patient_Master PatientDatamain)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  INSERT INTO call_misc_patient_master ");
            sb.Append(" (Title,PName,House_No,Street_Name,localityid,Locality,cityid,City,Pincode,stateid,");
            sb.Append(" State,Country,Mobile,Email,DOB,Age,AgeYear,AgeMonth,AgeDays,TotalAgeInDays,Gender,ipaddress,dtEntry,UserID) ");
            sb.Append(" values ");
            sb.Append(" (@Title,@PName,@House_No,@Street_Name,@localityid,@Locality,@cityid,@City,@Pincode,@stateid,");
            sb.Append(" @State,@Country,@Mobile,@Email,@DOB,@Age,@AgeYear,@AgeMonth,@AgeDays,@TotalAgeInDays,@Gender,@ipaddress,@dtEntry,@UserID) ");
            if (PatientDatamain.PName == "")
            {
                PatientDatamain.Title = "";
            }
            if (PatientDatamain.TotalAgeInDays == 0)
            {
                PatientDatamain.Age = "";
            }
            if (PatientDatamain.Title == "")
            {
                PatientDatamain.Gender = "";
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Title", PatientDatamain.Title),
                 new MySqlParameter("@PName", PatientDatamain.PName),
                  new MySqlParameter("@House_No", PatientDatamain.House_No),
                   new MySqlParameter("@Street_Name", PatientDatamain.Street_Name),
                    new MySqlParameter("@localityid", PatientDatamain.LocalityID),
                     new MySqlParameter("@Locality", PatientDatamain.Locality),
                      new MySqlParameter("@cityid", PatientDatamain.CityID),
                       new MySqlParameter("@City", PatientDatamain.City),
                        new MySqlParameter("@Pincode", PatientDatamain.Pincode),
                         new MySqlParameter("@stateid", PatientDatamain.StateID),
                          new MySqlParameter("@State", PatientDatamain.State),
                           new MySqlParameter("@Country", "India"),
                            new MySqlParameter("@Mobile", PatientDatamain.Mobile),
                             new MySqlParameter("@Email", PatientDatamain.Email),
                             new MySqlParameter("@DOB", PatientDatamain.DOB),
                              new MySqlParameter("@Age", PatientDatamain.Age),
                               new MySqlParameter("@AgeYear", PatientDatamain.AgeYear),
                                new MySqlParameter("@AgeMonth", PatientDatamain.AgeMonth),
                                 new MySqlParameter("@AgeDays", PatientDatamain.AgeDays),
                                  new MySqlParameter("@TotalAgeInDays", PatientDatamain.TotalAgeInDays),
                                   new MySqlParameter("@Gender", PatientDatamain.Gender),
                                    new MySqlParameter("@ipaddress", StockReports.getip()),
                                     new MySqlParameter("@dtEntry", DateTime.Now),
                                      new MySqlParameter("@UserID", UserInfo.ID));

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


}