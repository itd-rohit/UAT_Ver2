using MySql.Data.MySqlClient;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;

public partial class Design_FrontOffice_DoctorReferalCentreMapping : System.Web.UI.Page
{
    public static string _DoctorID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (Util.GetString(Request.QueryString["Doctor_ID"]) != "")
            {
                _DoctorID = Common.Decrypt(Util.GetString(Request.QueryString["Doctor_ID"]));
                lblDoctorID.Text = _DoctorID;
                lblDoctorName.Text = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(Title,' ',NAME) FROM doctor_referal WHERE Doctor_ID=@DoctorID; ", new MySqlParameter("@DoctorID", _DoctorID)).ToString();
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "GetData();", true);
            }
            else
            {

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
        }
        finally {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string RemoveRecord(string DoctorID, string TestData)
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Error in CentreID" });
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            TestData = TestData.TrimEnd('#');
            int len = Util.GetInt(TestData.Split('#').Length);
            string[] Item = new string[len];
            Item = TestData.Split('#');

            for (int i = 0; i < len; i++)
            {

                sb = new StringBuilder();
                sb.Append(" DELETE FROM doctor_referal_centre WHERE CentreID=@CentreID AND Doctor_ID=@DoctorID;");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(), new MySqlParameter("@CentreID", Util.GetString(Item[i])), new MySqlParameter("@DoctorID", DoctorID));

                sb = new StringBuilder();
                sb.Append(" INSERT INTO  patient_labinvestigation_opd_update_status(LedgerTransactionNo,Test_ID,STATUS,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID,OLDID,NEWID)  ");
                sb.Append(" values (@DoctorID,@CentreID,'Doctor Centre Remove',@ID,@Login,NOW(),");
                sb.Append(" @IP,@Centre,@RoleID,'','');");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(), new MySqlParameter("@DoctorID", DoctorID), new MySqlParameter("@CentreID",Util.GetString(Item[i])),
                    new MySqlParameter("@ID", UserInfo.ID), new MySqlParameter("@Login", UserInfo.LoginName), new MySqlParameter("@IP", StockReports.getip()),
                    new MySqlParameter("@Centre", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID));


            }

            Tnx.Commit();

            return JsonConvert.SerializeObject(new { status = true, response = "Record Removed" });
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
	finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetCentreList(string CentreName)
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return null;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cm.CentreID,IFNULL(cm.`CentreCode`,'') CentreCode,cm.Centre,cm.City,cm.State  ");
            sb.Append(" FROM centre_master cm WHERE cm.Centre LIKE @CentreName ORDER BY cm.`Centre` LIMIT 20 ; ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con,CommandType.Text,sb.ToString(),new MySqlParameter("@CentreName",string.Concat("%",CentreName,"%"))).Tables[0])
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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetData(string DoctorID)
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return null;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT cm.CentreID,IFNULL(cm.`CentreCode`,'') CentreCode,cm.Centre,cm.City,cm.State,drc.`UserName`, ");
            sb.Append(" IFNULL(DATE_FORMAT(drc.`dtEntry`,'%d-%b-%Y %I:%i %p'),'') dtEntry  ");
            sb.Append(" FROM `doctor_referal_centre` drc  ");
            sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=drc.`CentreID` ");
            sb.Append(" WHERE drc.`Doctor_ID`=@DoctorID ORDER BY cm.`Centre`; ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@DoctorID", DoctorID)).Tables[0])
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
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string AddCentre(string DoctorID, string CentreID)
    {
        try
        {
            int valCentreID = UserInfo.Centre;
        }
        catch
        {
            return JsonConvert.SerializeObject(new { status = false, response ="Error in CentreID" });
        }

        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {

            if (MySqlHelper.ExecuteScalar(Tnx, CommandType.Text, "SELECT COUNT(1) FROM doctor_referal_centre WHERE Doctor_ID=@DoctorID AND CentreID=@CentreID; ", new MySqlParameter("@DoctorID", DoctorID), new MySqlParameter("@CentreID", CentreID)).ToString() != "1")
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO doctor_referal_centre(Doctor_ID,CentreID,UserID,UserName,dtEntry,IpAddress)  ");
                sb.Append(" values (@DoctorID,@CentreID,@ID,@Name,NOW(),@IP)");
                MySqlHelper.ExecuteNonQuery(Tnx, CommandType.Text, sb.ToString(),new MySqlParameter("@DoctorID",DoctorID),new MySqlParameter("@CentreID",CentreID),new MySqlParameter("@ID", UserInfo.ID),
                    new MySqlParameter("@Name", UserInfo.LoginName), new MySqlParameter("@IP", StockReports.getip()));
                Tnx.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = "Record Saved" });

            }
            else
                return JsonConvert.SerializeObject(new { status = false, response = "This Centre already mapped" });
           
        }
        catch (Exception ex)
        {
            Tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
	finally
        {
            Tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}