<%@ WebService Language="C#" Class="CommonServices" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
using System.Linq;
using Newtonsoft.Json;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
[System.Web.Script.Services.ScriptService]
public class CommonServices : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    public string encryptData(string ID)
    {
        return Common.Encrypt(ID);
    }
    [WebMethod]
    public string bindCity(int StateID)
    {
        return Util.getJson(AllLoad_Data.loadCity(StateID));
    }
    [WebMethod]
    public string bindCityFromBusinessZone(int StateID, int BusinessZoneID)
    {
        return Util.getJson(AllLoad_Data.loadCity(StateID, BusinessZoneID));
    }
    [WebMethod]
    public string bindDept(string CategoryID)
    {
        return Util.getJson(AllLoad_Data.loadDept(CategoryID));
    }
    [WebMethod]
    public string bindCategory()
    {
        return Util.getJson(AllLoad_Data.loadcategory());
    }
    [WebMethod]
    public string bindZone(int CityID)
    {
        return Util.getJson(AllLoad_Data.loadZone(CityID));
    }
    [WebMethod]
    public string bindLocalityByZone(int ZoneID)
    {
        return Util.getJson(AllLoad_Data.loadLocalityByZone(ZoneID));
    }
    [WebMethod]
    public string bindLocalityByCity(int CityID)
    {
        return Util.getJson(AllLoad_Data.loadLocalityByCity(CityID));
    }
    [WebMethod]
    public string bindLocalityByAllCity(int CityID, int StateID)
    {
        return Util.getJson(AllLoad_Data.loadLocalityByCity(CityID, StateID));
    }
    [WebMethod]
    public string bindCentreLoad(string BusinessZoneID, string StateID, string CityID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CentreID,Centre FROM centre_master WHERE IsActive=1 ");
        if (BusinessZoneID != "0" && BusinessZoneID != "-1")
            sb.Append(" AND BusinessZoneID in(" + BusinessZoneID + ") ");
        if (StateID != "0" && StateID != "-1")
            sb.Append(" AND StateID in (" + StateID + ") ");
        if (CityID != "0" && CityID != "-1")
            sb.Append(" AND CityID in (" + CityID + " )");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public bool CompareDate(DateTime FromDate, DateTime ToDate)
    {
        double NrOfDays = (ToDate - FromDate).TotalDays;
        if (NrOfDays > 30)
            return false;
        else
            return true;
    }
    [WebMethod]
    public string bindState(int CountryID, int BusinessZoneID)
    {
        return Util.getJson(AllLoad_Data.loadState(CountryID, BusinessZoneID));
    }
    [WebMethod]
    public string bindBusinessZone()
    {
        return Util.getJson(AllLoad_Data.loadBusinessZone());
    }
    [WebMethod(EnableSession = true)]
    public string getCentreBusinessZone()
    {
        return Util.getJson(AllLoad_Data.getCentreBusinessZone());
    }
    [WebMethod]
    public int CompareFromToDate(DateTime FromDate, DateTime ToDate)
    {
        if (Convert.ToDateTime(FromDate) > Convert.ToDateTime(ToDate))
            return 0;
        else
            return 1;
    }
    [WebMethod]
    public string GetItemMaster(string ItemID, string Type, string Rate)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IFNULL( im.testcode,'')testCode,typeName,IF(im.TestCode='',typeName,CONCAT(im.TestCode,'~',typeName)) Item,im.`ItemID`");
        sb.Append(" FROM f_itemmaster im  WHERE im.isActive=1 AND im.`ItemID`='" + ItemID + "'");
        System.Data.DataTable dt = StockReports.GetDataTable(sb.ToString());
        return JsonConvert.SerializeObject(dt);
    }
    [WebMethod]
    public string bindBusinessZoneWiseState(object BusinessZoneID)
    {
        return Util.getJson(StockReports.GetDataTable("SELECT ID,State FROM state_master WHERE BusinessZoneID IN(" + BusinessZoneID + ") AND IsActive=1 ORDER BY State"));
    }
    [WebMethod]
    public string bindBusinessZoneAndStateWiseCity(string BusinessZoneID, string StateID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Ct.`ID`,ct.`City` FROM city_master ct");
        sb.Append(" INNER JOIN state_master sm ON sm.`id`=ct.`stateID` ");
        sb.Append(" INNER JOIN BusinessZone_master bm ON bm.`BusinessZoneID`=sm.`BusinessZoneID` ");
        sb.Append(" AND ct.`IsActive`=1 AND sm.`id` in(" + StateID + ") AND bm.`BusinessZoneID` in (" + BusinessZoneID + ") ");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string bindTypeLoad()
    {
        return Util.getJson(StockReports.GetDataTable("SELECT id,type1,MaxID FROM `centre_type1master` WHERE IsActive=1"));
    }
    [WebMethod]
    public string bindTypeLoadWithoutPCCPUP()
    {
        return Util.getJson(StockReports.GetDataTable("SELECT id,type1,MaxID FROM `centre_type1master` WHERE IsActive='1' AND type1<>'PUP'"));
    }
    [WebMethod]
    public string bindCentreLoadType(string BusinessZoneID, string StateID, string CityID, string TypeID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CentreID,Centre FROM centre_master WHERE IsActive=1 ");
        if (BusinessZoneID != "0" && BusinessZoneID != "-1")
            sb.Append(" AND BusinessZoneID in(" + BusinessZoneID + ") ");
        if (StateID != "0" && StateID != "-1")
            sb.Append(" AND StateID in (" + StateID + ") ");
        if (CityID != "0" && CityID != "-1")
            sb.Append(" AND CityID in (" + CityID + " )");
        if (TypeID != "0" && TypeID != "-1")
            sb.Append(" AND type1ID in (" + TypeID + " )");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string WelcomeLogin(string UserName, string Password)
    {
        string IsAdrenalinUser = "0";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT em.`Name`,em.`ValidateLogin` FROM employee_master em  ");
            sb.Append(" INNER JOIN f_login fl ON em.`Employee_ID`=fl.`EmployeeID` ");
            sb.Append(" AND PASSWORD(LOWER(fl.UserName)) = PASSWORD(LOWER(@Username)) and PASSWORD(LOWER(fl.Password)) = PASSWORD(LOWER(@Password)) ");
            sb.Append(" AND em.`IsActive`=1 AND fl.`Active`=1 LIMIT 1 ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
             new MySqlParameter("@Username", UserName.Trim()),
             new MySqlParameter("@Password", Password.Trim())).Tables[0])
            {
                if (Util.GetString(dt.Rows[0]["ValidateLogin"]) == "1")
                    IsAdrenalinUser = "1";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        return IsAdrenalinUser;
    }
    [WebMethod]
    public string validateAdrenalin(string EmployeeCode)
    {
        string retValue = "0";
        try
        {
            System.Data.SqlClient.SqlConnection conAdrenalin = new System.Data.SqlClient.SqlConnection(Util.getApp("AdrenalinConString"));
            System.Data.SqlClient.SqlDataAdapter daAdrenalin = new System.Data.SqlClient.SqlDataAdapter("Select * from ADRENALIN_MASTER_FOR_ITAS where EMPLOYEE_EMPLOYEE_ID='" + EmployeeCode + "'", conAdrenalin);
            System.Data.DataSet dsAdrenalin = new System.Data.DataSet();
            daAdrenalin.Fill(dsAdrenalin);
            if (dsAdrenalin.Tables[0].Rows.Count > 0)
            {
                retValue = "1";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        return retValue;
    }
    [WebMethod(EnableSession = true)]
    public string GetNotificationDetail(int RoleID, string UserID)
    {
        using (DataTable dt = StockReports.GetDataTable(" CALL NotificationDetail(" + RoleID + ",'" + UserID + "') "))
            return JsonConvert.SerializeObject(dt);
    }
    [WebMethod(EnableSession = true)]
    public string ViewNotification(int NotificationID)
    {
        string retValue = "0";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" update notification_detail set IsView=1 ");
            sb.Append(" where ID=@ID ");
            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sb.ToString(),
               new MySqlParameter("@ID", NotificationID));
           
          MySqltrans.Commit();
          retValue = "1";
                
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw (ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        return retValue;
    }
    [WebMethod]
    public string PasswordValidation(string UserName, string Password)
    {
        string retValue = "0";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbEmp = new StringBuilder();
            sbEmp.Append("  SELECT COUNT(1) FROM employee_master em  ");
            sbEmp.Append("  INNER JOIN f_login fl ON fl.`EmployeeID`=em.`Employee_ID`  ");
            sbEmp.Append("  AND fl.`UserName`=@UserName  AND BINARY fl.`Password`=@Password AND em.`IsLoginBlocked`='1'  ");
            if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sbEmp.ToString(),
                new MySqlParameter("@UserName", UserName.Trim()),
                new MySqlParameter("@Password", Password.Trim()))) > 0)
            {
                Exception ex = new Exception("showAlert#You have exceeded the maximum number of allowed <br/> login attempts.Your account is locked , Please contact to Admin....!");
                throw (ex);
            }

            sbEmp = new StringBuilder();
            sbEmp.Append(" SELECT em.Employee_ID,fl.UserName  FROM f_login fl  ");
            sbEmp.Append(" INNER JOIN employee_master em ON fl.EmployeeID = em.Employee_ID  ");
            sbEmp.Append(" AND fl.`UserName`=@UserName AND BINARY fl.`Password`=@Password      ");
            sbEmp.Append(" AND em.`IsPasswordReset`=@IsPasswordReset limit 1  ");
            using (DataTable dtEmp = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbEmp.ToString(),
              new MySqlParameter("@UserName", UserName.Trim()),
              new MySqlParameter("@Password", Password.Trim()),
              new MySqlParameter("@IsPasswordReset", "1")).Tables[0])
            {
                if (dtEmp.Rows.Count > 0)
                {
                    Exception ex = new Exception("PasswordReset#Dear User, <br/>You Have Logged In First Time So Please Reset Your Password...!#" + Util.GetString(dtEmp.Rows[0]["Employee_ID"]) + "#" + Util.GetString(dtEmp.Rows[0]["UserName"]));
                    throw (ex);
                }
                else
                {
                    sbEmp = new StringBuilder();
                    sbEmp.Append(" SELECT ");
                    sbEmp.Append(" CASE  ");
                    sbEmp.Append(" WHEN DATE_ADD(em.`LastPasswordChangeDateTime`, INTERVAL em.`PasswordChangeFrequencyInDays`  DAY)<NOW() ");
                    sbEmp.Append("  THEN 'PasswordExpired' ");
                    sbEmp.Append(" WHEN FLOOR(HOUR(TIMEDIFF(DATE_ADD(em.`LastPasswordChangeDateTime`, INTERVAL em.`PasswordChangeFrequencyInDays`DAY),NOW())) / 24)<=2 ");
                    sbEmp.Append(" THEN ");
                    sbEmp.Append(" CONCAT('Dear User,<br/>Your Password Is Expired In ',  ");
                    sbEmp.Append(" FLOOR(HOUR(TIMEDIFF(DATE_ADD(em.`LastPasswordChangeDateTime`, INTERVAL em.`PasswordChangeFrequencyInDays`DAY),NOW())) / 24), ' Days ', ");
                    sbEmp.Append(" MOD(HOUR(TIMEDIFF(DATE_ADD(em.`LastPasswordChangeDateTime`, INTERVAL em.`PasswordChangeFrequencyInDays`DAY),NOW())), 24), ' Hours ', ");
                    sbEmp.Append(" MINUTE(TIMEDIFF(DATE_ADD(em.`LastPasswordChangeDateTime`, INTERVAL em.`PasswordChangeFrequencyInDays`DAY),NOW())), ' Minutes') ");
                    sbEmp.Append(" ELSE '' END Result ");
                    sbEmp.Append(" FROM f_login fl   ");
                    sbEmp.Append(" INNER JOIN employee_master em ON fl.EmployeeID = em.Employee_ID   ");
                    sbEmp.Append(" AND fl.`UserName`=@UserName AND BINARY fl.`Password`=@Password ");
                    sbEmp.Append(" AND em.`IsPasswordChangeRequired`=@IsPasswordChangeRequired LIMIT 1 ");
                    using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbEmp.ToString(),
                                     new MySqlParameter("@UserName", UserName.Trim()),
                                     new MySqlParameter("@Password", Password.Trim()),
                                     new MySqlParameter("@IsPasswordChangeRequired", "1")).Tables[0])
                    {
                        if (dt.Rows.Count > 0)
                        {
                            if (Util.GetString(dt.Rows[0]["Result"]).Trim() != string.Empty)
                            {
                                if (Util.GetString(dt.Rows[0]["Result"]).Trim() == "PasswordExpired")
                                {
                                    Exception ex = new Exception("PasswordExpired#Dear User, <br/>Your Password Is Expired. Please Contact To Admin....!");
                                    throw (ex);
                                }
                                else
                                {
                                    Exception ex = new Exception(string.Concat("PasswordAboutToExpired#", Util.GetString(dt.Rows[0]["Result"])));
                                    throw (ex);
                                }
                            }
                        }
                    }
                }
            }
            retValue = "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            throw (ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        return retValue;
    }
    [WebMethod]
    public string ChangePassword(string EmployeeID, string UserName, string ResetPassword, string ResetConfirmPassword)
    {
        string retValue = string.Concat(EmployeeID, "#", UserName);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction MySqltrans = con.BeginTransaction();
        try
        {

            StringBuilder sbEmp = new StringBuilder();
            sbEmp.Append(" SELECT COUNT(1) FROM  ");
            sbEmp.Append(" (SELECT ep.PASSWORD,ep.EmployeeID FROM Employee_Master_Password ep   ");
            sbEmp.Append(" INNER JOIN `employee_master` emm ON emm.`Employee_ID`=ep.`EmployeeID` ");
            sbEmp.Append(" AND emm.`Employee_ID`=@Employee_ID AND ep.`dtEntry`<=emm.`LastPasswordChangeDateTime` ");
            sbEmp.Append(" ORDER BY ep.ID DESC LIMIT 5)a  ");
            sbEmp.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=a.EmployeeID   ");
            sbEmp.Append(" AND BINARY a.Password=@Password ");
            if (Util.GetInt(MySqlHelper.ExecuteScalar(MySqltrans, CommandType.Text, sbEmp.ToString(),
                new MySqlParameter("@Employee_ID", EmployeeID),
                new MySqlParameter("@Password", ResetPassword.Trim()))) > 0)
            {
                Exception ex = new Exception("Choose a password that is different from your last 4 passwords");
                throw (ex);
            }
            else
            {
                sbEmp = new StringBuilder();
                sbEmp.Append(" INSERT INTO Employee_Master_Password ");
                sbEmp.Append(" (EmployeeID,PASSWORD,dtEntry,IPAddress,CreatedByID,CreatedByName) ");
                sbEmp.Append(" VALUES ");
                sbEmp.Append(" (@EmployeeID,@PASSWORD,@dtEntry,@IPAddress,@CreatedByID,@CreatedByName) ");
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sbEmp.ToString(),
                    new MySqlParameter("@EmployeeID", EmployeeID),
                    new MySqlParameter("@CreatedByID", EmployeeID),
                    new MySqlParameter("@CreatedByName", UserName),
                    new MySqlParameter("@PASSWORD", ResetPassword.Trim()),
                    new MySqlParameter("@dtEntry", DateTime.Now),
                    new MySqlParameter("@IPAddress", StockReports.getip()));

                sbEmp = new StringBuilder();
                sbEmp.Append(" update employee_master set LastPasswordChangeDateTime=@LastPasswordChangeDateTime,IsPasswordReset=@IsPasswordReset");
                sbEmp.Append(" where Employee_ID=@Employee_ID ");
                MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sbEmp.ToString(),
                   new MySqlParameter("@Employee_ID", EmployeeID),
                   new MySqlParameter("@IsPasswordReset", "0"),
                   new MySqlParameter("@LastPasswordChangeDateTime", DateTime.Now));

            }

            sbEmp = new StringBuilder();
            sbEmp.Append(" update f_login set lastpass_dt=@lastpass_dt, ");
            sbEmp.Append(" password=@password,UserName=@UserName where  EmployeeID=@EmployeeID ");
            MySqlHelper.ExecuteNonQuery(MySqltrans, CommandType.Text, sbEmp.ToString(),
                  new MySqlParameter("@EmployeeID", EmployeeID),
                  new MySqlParameter("@lastpass_dt", DateTime.Now),
                  new MySqlParameter("@UserName", UserName),
                  new MySqlParameter("@password", ResetPassword.Trim()));

            MySqltrans.Commit();
            retValue += "#1";
        }
        catch (Exception ex)
        {
            MySqltrans.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            retValue += "#0#" + ex.Message;
        }
        finally
        {
            MySqltrans.Dispose();
            con.Close();
            con.Dispose();
        }
        return retValue;

    }

    [WebMethod]
    public string bindCentreLoadLAB(string BusinessZoneID, string StateID, string CityID)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CentreID,Centre FROM centre_master WHERE IsActive=1 AND Category='LAB' ");
        if (BusinessZoneID != "0" && BusinessZoneID != "-1")
            sb.Append(" AND BusinessZoneID in(" + BusinessZoneID + ") ");
        if (StateID != "0" && StateID != "-1")
            sb.Append(" AND StateID in (" + StateID + ") ");
        if (CityID != "0" && CityID != "-1")
            sb.Append(" AND CityID in (" + CityID + " )");

        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }


    [WebMethod]
    public string bindCentrePanel(string CentreID)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT pn.Panel_Id,pn.Company_Name  FROM  ");
        sb.Append("  f_panel_master pn WHERE "); // and  cp.CentreId IN (" + CentreID + ") 
        sb.Append("  pn.isActive=1 ");
        sb.Append(" AND  pn.Panel_Id=pn.ReferenceCodeOPD  ");
        sb.Append(" order by pn.company_name  ");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }
    [WebMethod]
    public string getBankMaster()
    {

        return JsonConvert.SerializeObject(AllLoad_Data.loadBank());

    }
    [WebMethod]
    public string bindTitleWithGender()
    {
        return JsonConvert.SerializeObject(AllGlobalFunction.NameTitleWithGender);
    }
    [WebMethod]
    public string bindStateCityLocality(int CountryID, int StateID, int CityID, byte IsStateBind, int CentreID, byte IsCountryBind, byte IsFieldBoyBind, byte IsCityBind, byte IsLocality)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dtCountry = new DataTable();
            using (dtCountry as IDisposable)
            {
                if (IsCountryBind == 1)
                    dtCountry = CacheQuery.loadCountry(con);
                DataTable dtState = new DataTable();
                using (dtState as IDisposable)
                {
                    if (IsStateBind == 1)
                        dtState = CacheQuery.loadState(CountryID, con);
                    DataTable dtCity = new DataTable();
                    using (dtCity as IDisposable)
                    {
                        if (IsCityBind == 1)
                            dtCity = CacheQuery.loadCity(StateID, con);
                        DataTable dtLocality = new DataTable();
                        using (dtLocality as IDisposable)
                        {
                            if (IsLocality == 1)
                                dtLocality = CacheQuery.loadLoality(StateID, CityID, con);
                            DataTable dtFeildboy = new DataTable();
                            using (dtFeildboy as IDisposable)
                            {
                                if (IsFieldBoyBind == 1)
                                {
                                    AllLoad_Data ad = new AllLoad_Data();
                                    dtFeildboy = ad.bindFieldBoyCentreWise(CentreID, con);
                                }
                                return Util.getJson(new { countryData = dtCountry, stateData = dtState, cityData = dtCity, localityData = dtLocality, fieldBoyData = dtFeildboy });
                            }
                        }
                    }
                }
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
    [WebMethod]
    public string bindCardHolderRelation()
    {
        AllGlobalFunction al = new AllGlobalFunction();
        return Util.getJson(al.CardHolderRelation());
    }
    [WebMethod]
    public string bindPatientDocument(string labno, string Filename, string PatientID, int oldPatientSearch, int documentDetailID, int isEdit)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (oldPatientSearch == 1)
            {
                sb.Append(" SELECT '' Panel_ID, dd.id ID,DocumentName,filename AttachedFile,IF(LabNo='','0','1') Approved,DocumentID,");
                sb.Append(" CONCAT('/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',filename) fileurl,CreatedBy UploadedBy,DATE_FORMAT(CreatedDate,'%d-%b-%y')  dtEntry ");
                if (PatientID != string.Empty)
                {
                    sb.Append(" FROM document_detail dd ");
                    sb.Append(" INNER JOIN document_master dm on dd.DocumentID=dm.ID and dm.isAddressProof=1 ");
                    sb.Append(" WHERE PatientID=@PatientID  ");
                }
              //  sb.Append(" AND DocumentID<>2 ");
                if (isEdit == 1)
                {
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT '' Panel_ID, dd.id ID,DocumentName,filename AttachedFile,IF(LabNo='','0','1') Approved,DocumentID,");
                    sb.Append(" CONCAT('/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',filename) fileurl,CreatedBy UploadedBy,DATE_FORMAT(CreatedDate,'%d-%b-%y')  dtEntry ");
                    sb.Append(" FROM document_detail dd ");
                    sb.Append(" INNER JOIN document_master dm on dd.DocumentID=dm.ID and dm.isAddressProof=0 ");
                    sb.Append(" WHERE labNo=@labNo AND dd.IsActive=1   ");//AND DocumentID=2
                }
            }
            else
            {

                sb.Append(" SELECT '' Panel_ID, id ID,DocumentName,filename AttachedFile,IF(LabNo='','0','1') Approved,DocumentID,");
                sb.Append(" CONCAT('/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',filename) fileurl,CreatedBy UploadedBy,DATE_FORMAT(CreatedDate,'%d-%b-%y')  dtEntry ");
                if (labno != string.Empty)
                {
                    sb.Append(" FROM document_detail WHERE labNo=@labNo ");
                }
                else
                {
                    sb.Append(" FROM document_detail WHERE labNo=@Filename  ");
                }
                sb.Append(" AND ID=@ID AND IsActive=1");
            }

            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@Filename", Filename), new MySqlParameter("@labNo", labno), new MySqlParameter("@PatientID", PatientID),
                   new MySqlParameter("@ID", documentDetailID)).Tables[0]);
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
    public string bindmanualDocument(string labno, string Filename, string PatientID, int oldPatientSearch, int documentDetailID, int isEdit)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (oldPatientSearch == 1)
            {
                sb.Append(" SELECT  Panel_ID, dd.id ID,DocumentName,filename AttachedFile,IF(LabNo='','0','1') Approved,DocumentID,");
                sb.Append(" CONCAT('/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',filename) fileurl,CreatedBy UploadedBy,DATE_FORMAT(CreatedDate,'%d-%b-%y')  dtEntry ");
                if (PatientID != string.Empty)
                {
                    sb.Append(" FROM document_detail dd ");
                   // sb.Append(" INNER JOIN document_master dm on dd.DocumentID=dm.ID and dm.isAddressProof=1 ");
                    sb.Append(" inner join f_panel_master pm on dd.PanelID= pm.Panel_ID ");
                    sb.Append(" WHERE Panel_ID=@PatientID  ");
                }
                //  sb.Append(" AND DocumentID<>2 ");
                if (isEdit == 1)
                {
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT '' Panel_ID, dd.id ID,DocumentName,filename AttachedFile,IF(LabNo='','0','1') Approved,DocumentID,");
                    sb.Append(" CONCAT('/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',filename) fileurl,CreatedBy UploadedBy,DATE_FORMAT(CreatedDate,'%d-%b-%y')  dtEntry ");
                    sb.Append(" FROM document_detail dd ");
                    sb.Append(" INNER JOIN document_master dm on dd.DocumentID=dm.ID and dm.isAddressProof=0 ");
                    sb.Append(" WHERE labNo=@labNo AND dd.IsActive=1   ");//AND DocumentID=2
                }
            }
            else
            {

                sb.Append(" SELECT '' Panel_ID, id ID,DocumentName,filename AttachedFile,IF(LabNo='','0','1') Approved,DocumentID,");
                sb.Append(" CONCAT('/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',filename) fileurl,CreatedBy UploadedBy,DATE_FORMAT(CreatedDate,'%d-%b-%y')  dtEntry ");
                if (labno != string.Empty)
                {
                    sb.Append(" FROM document_detail WHERE labNo=@labNo ");
                }
                else
                {
                    sb.Append(" FROM document_detail WHERE labNo=@Filename  ");
                }
                sb.Append(" AND ID=@ID AND IsActive=1");
            }

            return Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@Filename", Filename), new MySqlParameter("@labNo", labno), new MySqlParameter("@PatientID", PatientID),
                   new MySqlParameter("@ID", documentDetailID)).Tables[0]);
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
    public string deletePatientDocument(string deletePath, string ID)
    {
        string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\UploadedDocument");
        if (System.IO.File.Exists(string.Concat(RootDir, deletePath)))
            System.IO.File.Delete(string.Concat(RootDir, deletePath));
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "delete from document_detail Where ID=@ID",
               new MySqlParameter("@ID", ID));
            return JsonConvert.SerializeObject(new { status = true, response = "Document Deleted Successfully" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error Occurred" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string encryptDynamicData(string LabNo)
    {
        return JsonConvert.SerializeObject(new { LabNo = Common.Encrypt(LabNo) });
    }
    [WebMethod(EnableSession = true)]
    public string getClientBalanceAmt()
    {
        AllLoad_Data al = new AllLoad_Data();
        return al.getClientBalanceAmt();
    }
    [WebMethod]
    public string decryptData(string ID)
    {
        return Common.Decrypt(ID);
    }
    [WebMethod]
    public string LoadCurrencyDetail()
    {
        DataTable dtDetail = AllLoad_Data.LoadCurrencyFactor("");
        DataRow[] dr = dtDetail.Select("IsBaseCurrency=1");
        var baseNotation = dr[0]["Notation"].ToString();
        var baseCountryID = dr[0]["B_CountryID"].ToString();
        var baseCurrency = dr[0]["B_Currency"].ToString();
        return JsonConvert.SerializeObject(new { currancyDetails = dtDetail, baseNotation = baseNotation, baseCountryID = baseCountryID, baseCurrency = baseCurrency });
    }
    [WebMethod]
    public decimal GetConversionFactor(int countryID)
    {
        AllLoad_Data al = new AllLoad_Data();
        return al.GetConversionFactor(countryID);
    }
    [WebMethod]
    public string bindPaymentMode()
    {
        DataTable dtPaymentMode = AllLoad_Data.bindPaymentMode();
        if (dtPaymentMode.Rows.Count > 0)
            return JsonConvert.SerializeObject(dtPaymentMode);
        else
            return "";
    }
    [WebMethod]
    public string getConvertCurrecncy(int countryID, decimal Amount)
    {
        AllLoad_Data al = new AllLoad_Data();
        return al.ConvertCurrencyBase(countryID, Amount);
    }
    [WebMethod]
    public decimal ConvertCurrency(int countryID, decimal Amount)
    {
        AllLoad_Data al = new AllLoad_Data();
        return al.ConvertCurrency(countryID, Amount);
    }
    [WebMethod]
    public decimal getOPDBalanceAmt(string Patient_ID)
    {
        AllLoad_Data al = new AllLoad_Data();
        return al.getOPDBalanceAmt(Patient_ID, null);
    }
    [WebMethod]
    public string bindDiscountApprovalAndOutStandingEmp(int CentreID, byte IsDiscountApproval, byte IsOutStandingEmp)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            AllLoad_Data al = new AllLoad_Data();

            DataTable dtDiscountApproval = new DataTable();
            DataTable dtOutStandingEmp = new DataTable();

            using (dtDiscountApproval as IDisposable)
            {
                using (dtOutStandingEmp as IDisposable)
                {
                    if (IsDiscountApproval == 1)
                    {
                        dtDiscountApproval = al.bindDiscountApproval(CentreID, con);
                    }
                    if (IsOutStandingEmp == 1)
                    {
                        dtOutStandingEmp = al.bindOutstandingEmployee(CentreID, con);
                    }
                }
                return Util.getJson(new { DiscountApprovalData = dtDiscountApproval, OutstandingEmployeeData = dtOutStandingEmp });

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
    [WebMethod]
    public string bindBusinessZoneWithCountry(int CountryID)
    {
        return JsonConvert.SerializeObject(AllLoad_Data.loadBusinessZoneWithCountry(CountryID));
    }
    [WebMethod]
    public string ReadNotification(string NotificationId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {                  
          MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE notification_detail SET IsView=1,ViewDate=NOW() WHERE ID=@Id",
                    new MySqlParameter("@Id",NotificationId));
                   
          return "1";                            
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
    public string SetDefaultRole(int roleID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " UPDATE f_login f SET f.isDefault=0 WHERE  f.EmployeeID=@EmployeeID",
                                        new MySqlParameter("@EmployeeID", UserInfo.ID));

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, " UPDATE f_login f SET f.isDefault=1 WHERE  f.EmployeeID=@EmployeeID AND f.RoleID=@RoleID",
                                        new MySqlParameter("@EmployeeID", UserInfo.ID),
                                        new MySqlParameter("@RoleID", roleID));
            return JsonConvert.SerializeObject(new { status = true, response = "Set Successfully" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public string ChangeRole(int roleID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT fl.RoleID,rm.RoleName FROM f_login fl INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID");
            sb.Append(" WHERE fl.Active = 1 AND fl.RoleID = @RoleID AND fl.EmployeeId = @EmployeeId AND fl.CentreID=@CentreID");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                             new MySqlParameter("@RoleID", roleID),
                                             new MySqlParameter("@EmployeeId", UserInfo.ID),
                                             new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    Session["LoginType"] = dt.Rows[0]["RoleName"];
                    Session["RoleID"] = Util.GetString(dt.Rows[0]["RoleID"]);

                }
            }

            return JsonConvert.SerializeObject(new { status = true, response = "Change Successfully" });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public string EmpStatus()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT em.`IsActive` FROM f_login fl INNER JOIN employee_master em on fl.EmployeeID = em.Employee_ID");
            sb.Append(" WHERE fl.EmployeeId = @EmployeeId And fl.Active = 1 AND em.`IsActive`=1 ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                             
                                             new MySqlParameter("@EmployeeId", UserInfo.ID)).Tables[0])
                                           
            if(dt.Rows.Count>0)
            {

               return JsonConvert.SerializeObject(new { status = true, response = "true" });
            }
             return JsonConvert.SerializeObject(new { status = false, response = "false" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Newtonsoft.Json.JsonConvert.SerializeObject(new { status = false, response = "Error occurred, Please contact administrator", message = ex.Message });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public string loadDeptartment(string CategoryID)
    {
        return Util.getJson(AllLoad_Data.loadDeptartment(CategoryID));
    }
    [WebMethod]
    public string bindDeptcategory()
    {
        return Util.getJson(AllLoad_Data.loadObservationType());
    }
    [WebMethod]//investigation on registration 
    public string bindinvestigation(string ItemID ,string ReferenceCodeOPD, string CentreCode, string Gender, string DOB, string Panel_Id, string PanelType, string DiscountTypeID, string PanelID_MRP, string MemberShipCardNo, string SubcategoryID,string SubgroupID)
    {
        return Util.getJson(AllLoad_Data.loadinvestigation(ItemID,ReferenceCodeOPD, CentreCode, Gender, DOB, Panel_Id, PanelType, DiscountTypeID, PanelID_MRP, MemberShipCardNo, SubcategoryID,SubgroupID));
    }
    [WebMethod]
    public string loadsubgroup(string deptID)
    {
        return Util.getJson(AllLoad_Data.loadsubgroup(deptID));
    }

}