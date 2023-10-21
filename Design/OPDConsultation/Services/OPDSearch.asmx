<%@ WebService Language="C#" Class="OPDSearch" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Data;
using System.Collections.Generic;
using System.Web.Script;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Text;
using MySql.Data.MySqlClient;


/// <summary>
/// Summary description for OPDSearch
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
[ScriptService]

// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class OPDSearch : System.Web.Services.WebService
{

    public OPDSearch()
    {

        //Uncomment the following line if using designed components 
        //InitializeComponent(); 
    }

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    public string GetLastTokenNo(string centre)
    {
        string str = "SELECT concat(MAX(lt.`OPDConsultationTokenNo`),'#',MAX(lt.`OPDConsultationTokenNo`)+1)token FROM f_ledgertransaction lt  WHERE  DATE(lt.`Date`) = CURRENT_DATE() and centreId=" + centre + "";
        string Result = StockReports.ExecuteScalar(str);
        return Newtonsoft.Json.JsonConvert.SerializeObject(Result);
    }
    [WebMethod(EnableSession = true)]
    public string bindoldpatient(string regno, string pname, string mobile)
    {
        

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                string PopUpQuery = "";

                PopUpQuery = @"SELECT DISTINCT ''  empid, CONCAT(pm.Title,pm.PName) patname,pm.Patient_ID,pm.Age,pm.Gender,IF(pm.DOB='0001-01-01' || pm.DOB='0000-00-00',' ',pm.DOB)DOB,
                 DATE_FORMAT(pm.dtEntry,'%d-%b-%Y') AS 'Date',pm.House_No,IF(pm.mobile = '',pm.phone,pm.Mobile) AS Contact_No,pm.city,
                  pm.state FROM patient_master pm inner join appointment app on app.Patient_ID=pm.Patient_ID WHERE app.Patient_ID <> '' ";
                if (regno != "")
                {
                    PopUpQuery = PopUpQuery + " and pm.Patient_ID = @Patient_ID";
                }
                if (pname != "")
                {
                    PopUpQuery = PopUpQuery + " and pm.PName like @PName ";
                }
                if (mobile != "")
                {
                    PopUpQuery = PopUpQuery + " and pm.Mobile=@Mobile";
                }

                PopUpQuery = PopUpQuery + " order by pm.ID limit 100";
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, PopUpQuery,
                    new MySqlParameter("@Patient_ID", regno.Trim()),
                    new MySqlParameter("@PName","%" + pname.Trim() + "%"),
                    new MySqlParameter("@Mobile", mobile.Trim())).Tables[0])
                {
                    return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                }
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
    public string SearchOldPatient(string PID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT pm.Title, pm.PName,pm.Patient_ID,pm.Age, pm.Locality, pm.State,IF(pm.DOB='0001-01-01',pm.Age,DATE_FORMAT(pm.DOB,'%d-%b-%Y'))DOB,pm.Gender,pm.Phone,pm.Mobile,pm.Email, ");
            sb.Append("  pm.House_no,pm.City from patient_master pm ");

            sb.Append(" inner join appointment app on app.patient_id=pm.patient_id");
            sb.Append(" where pm.patient_id=@patient_id");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@patient_id",PID)).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
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
    public string getdocsheduleforopd(string docid)
    {
        StringBuilder sb = new StringBuilder();
       // sb.Append("SELECT DAY AS 'Day',TIME_FORMAT(starttime,'%r') starttime,TIME_FORMAT(endtime,'%r') endtime,avgtime,room_no,'' fee FROM doctor_hospital ");
	   sb.Append("SELECT DAY AS 'Day',TIME_FORMAT(starttime,'%r') starttime,TIME_FORMAT(endtime,'%r') endtime,avgtime,room_no,(select ConsultantFee from doctor_master where doctor_id='" + docid + "') fee FROM doctor_hospital ");
        sb.Append(" WHERE doctor_id='" + docid + "' ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }
}

