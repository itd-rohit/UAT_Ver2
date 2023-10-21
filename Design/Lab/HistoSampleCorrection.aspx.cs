using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_Lab_HistoSampleCorrection : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string getdatatestonly(string sinno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select distinct test_id,im.name   ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo");
            sb.Append(" INNER JOIN investigation_master im ON im.`Investigation_Id`=plo.`Investigation_ID` AND im.`ReportType`=7");
            sb.Append(" where plo.TestCentreID=@TestCentreID ");
            sb.Append(" and( plo.`BarcodeNo`=@sinno OR plo.`LedgerTransactionNo`=@sinno) ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@TestCentreID", UserInfo.Centre), new MySqlParameter("@sinno", sinno)).Tables[0])
                return JsonConvert.SerializeObject(dt);

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

    [WebMethod]
    public static string getdata(string sinno)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" ");
            sb.Append(" SELECT plo.slidenumber, plo.`Test_ID`,pm.`Age`,pm.`Gender`,pm.`PName`,im.`Name` testname,plo.`IsSampleCollected`,plo.`Result_Flag`,");
            sb.Append(" plo.`HistoCytoPerformingDoctor`,plo.`HistoCytoSampleDetail`,plo.`BarcodeNo`,plo.`LedgerTransactionNo`,");
            sb.Append(" plo.`SampleTypeName`,(SELECT centre FROM centre_master cm WHERE cm.centreid=plo.centreid) BookingCentre,");
            sb.Append(" (SELECT centre FROM centre_master cm WHERE cm.centreid=plo.TestCentreID) ProcessingCentre");
            sb.Append(" FROM `patient_labinvestigation_opd` plo");
            sb.Append(" INNER JOIN investigation_master im ON im.`Investigation_Id`=plo.`Investigation_ID` AND im.`ReportType`=7");
            sb.Append(" INNER JOIN `patient_master` pm ON pm.`Patient_ID`=plo.`Patient_ID`");
            sb.Append(" where plo.TestCentreID=@TestCentreID ");
            sb.Append(" and plo.Test_ID=@Test_ID ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@TestCentreID", UserInfo.Centre), new MySqlParameter("@Test_ID", sinno)).Tables[0])
                return JsonConvert.SerializeObject(dt);
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

    [WebMethod]
    public static string getdoclist()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DISTINCT fl.employeeid,em.`Name` FROM f_login fl ");
            sb.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=fl.`EmployeeID` ");
            sb.Append(" INNER JOIN f_approval_labemployee fa ON fa.`EmployeeID`=fl.`EmployeeID` ");
            sb.Append("  WHERE centreid=@centreid ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@centreid", UserInfo.Centre)).Tables[0])
                return JsonConvert.SerializeObject(dt);
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

    [WebMethod]
    public static string savedata(string testid, string specimen, string doc, string sampleinfo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("update patient_labinvestigation_opd set SampleTypeName=@SampleTypeName, HistoCytoSampleDetail=@HistoCytoSampleDetail,HistoCytoPerformingDoctor=@HistoCytoPerformingDoctor where Test_ID=@testid ");
           MySqlHelper.ExecuteNonQuery(con,CommandType.Text,sb.ToString(),
              new MySqlParameter("@SampleTypeName", specimen), new MySqlParameter("@HistoCytoSampleDetail", sampleinfo), new MySqlParameter("@HistoCytoPerformingDoctor", doc),
              new MySqlParameter("@testid", testid));
            return "1";
        }
        catch (Exception ex)
        {
            return ex.InnerException.ToString();
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

}