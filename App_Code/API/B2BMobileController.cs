using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;

[Route("api/[controller]/[action]")]
public class B2BMobileController : ApiController
{
    string url = Resources.Resource.RemoteLink;
    // POST: api/Authenticate
    [ActionName("Login")]
    public object Login([FromBody]B2BLogin _login)
    {
        HttpError err = new HttpError();
       
        if (_login == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.username))
        {
            err.Add("status", false);
            err.Add("message", "username can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.password))
        {
            err.Add("status", false);
            err.Add("message", "password can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
		string data="[]";

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT cm.Centre,cm.Type1,fl.EmployeeID,fl.EmployeeID as Employee_Id,pm.company_name as Panel_Name, pm.panel_id ,fl.UserName,Concat(em.Title,'',em.Name) AS NAME,em.Mobile,fl.RoleID,rm.RoleName,fl.CentreID,pm.IsInvoice,em.IsSalesTeamMember,em.`AccessDepartment`,em.IsHideRate,IFNULL(em.AccessStoreLocation,'')AccessStoreLocation ,pm.PanelType ");
                sb.Append(" FROM f_login fl INNER JOIN employee_master em on fl.EmployeeID = em.Employee_ID ");
                sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=fl.CentreID ");
                sb.Append(" INNER JOIN f_rolemaster rm ON rm.ID=fl.RoleID ");
                sb.Append(" INNER JOIN f_panel_Master pm ON pm.Employee_ID=em.Employee_ID  WHERE fl.Active = 1 AND em.IsActive=1 and fl.RoleID=183 ");
                sb.Append(" AND BINARY PASSWORD(fl.UserName) = PASSWORD(@Username) AND BINARY PASSWORD(fl.Password) = PASSWORD(@Password)  ORDER BY fl.isDefault desc LIMIT 1");
                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@Username", _login.username),
                 new MySqlParameter("@Password", _login.password)).Tables[0];
                
                    if (dt.Rows.Count > 0)
                    {
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO f_login_detail(RoleID,EmployeeID,EmployeeName,UserName,CentreID,Browser,ipAddress,HostName) ");
                        sb.Append(" VALUES(@RoleID,@EmployeeID,@EmployeeName,@UserName,@CentreID,@Browser,@ipAddress,@HostName) ");
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@RoleID", Util.GetString(dt.Rows[0]["RoleID"])), new MySqlParameter("@EmployeeID", Util.GetString(dt.Rows[0]["EmployeeID"])),
                            new MySqlParameter("@EmployeeName", Util.GetString(dt.Rows[0]["NAME"])), new MySqlParameter("@UserName", _login.username),
                            new MySqlParameter("@CentreID", Util.GetString(dt.Rows[0]["CentreID"])), new MySqlParameter("@HostName", "Mobile"));

                        err.Add("status", true);
                        err.Add("message", "Success");
                        err.Add("data", JArray.FromObject(dt));
                        return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                    }
                    else
                    {
                      string massege="{\"status\": false,\"message\": \"No Data Found\",\"data\": []}";
                        err.Add("status", false);
                        err.Add("message", "No Record Found");
                        err.Add("data", data);
						return JsonConvert.DeserializeObject(massege);
                   // return Request.CreateErrorResponse(HttpStatusCode.OK, massege);
                    }
                

            }
            catch (Exception ex)
            {
                err.Add("status", false);
                err.Add("message", "No Record Found");
                err.Add("data", "[]");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
    }


    [HttpPost]
    public HttpResponseMessage ChangePassword([FromBody]ChangePassword _ChangePassword)
    {
        HttpError err = new HttpError();
        if (string.IsNullOrWhiteSpace(_ChangePassword.NewPassword))
        {
            err.Add("status", false);
            err.Add("message", "Password can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_ChangePassword.UserName))
        {
            err.Add("status", false);
            err.Add("message", "UserName can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

        if (string.IsNullOrWhiteSpace(_ChangePassword.UserType))
        {
            err.Add("status", false);
            err.Add("message", "UserType can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            if (_ChangePassword.UserType.Trim() == "Employee")
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text,
                    "UPDATE `f_login` SET PASSWORD=@password,InvalidPassword=0 WHERE `EmployeeID`=@Employee_Id",
                    new MySqlParameter("@password", _ChangePassword.NewPassword),
                    new MySqlParameter("@Employee_Id", _ChangePassword.UserName));

                err.Add("status", true);
                err.Add("message", "Password successfully updated");
                err.Add("data", "[]");
            }
            else if (_ChangePassword.UserType.Trim() == "PUP")
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text,
                    " Update f_panel_master set PanelPassword=@PanelPassword where Panel_ID=@Panel_ID and IsActive=@IsActive And PanelType=@PanelType ",
                    new MySqlParameter("@PanelPassword", _ChangePassword.NewPassword.Trim()),
                    new MySqlParameter("@Panel_ID", _ChangePassword.UserName),
                    new MySqlParameter("@IsActive", "1"),
                    new MySqlParameter("@PanelType", "PUP"));
                err.Add("status", true);
                err.Add("message", "Password successfully updated");
                err.Add("data", "[]");
            }
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [HttpPost]
    public HttpResponseMessage DocumentMaster([FromBody]B2BLogin _login)
    {
        HttpError err = new HttpError();

        if (_login == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.username))
        {
            err.Add("status", false);
            err.Add("message", "username can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.password))
        {
            err.Add("status", false);
            err.Add("message", "password can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select ID,Name from document_master where isactive=1");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])

                if (dt.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {

                    err.Add("status", false);
                    err.Add("message", "No Record Found");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [HttpPost]
    public HttpResponseMessage StateMaster([FromBody]B2BLogin _login)
    {
        HttpError err = new HttpError();

        if (_login == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.username))
        {
            err.Add("status", false);
            err.Add("message", "username can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.password))
        {
            err.Add("status", false);
            err.Add("message", "password can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT ID,State FROM `state_master` where isactive=1");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])

                if (dt.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {

                    err.Add("status", false);
                    err.Add("message", "No Record Found");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [HttpPost]
    public HttpResponseMessage TitleMaster([FromBody]B2BLogin _login)
    {
        HttpError err = new HttpError();

        if (_login == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.username))
        {
            err.Add("status", false);
            err.Add("message", "username can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.password))
        {
            err.Add("status", false);
            err.Add("message", "password can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT ID,Title FROM `Title_master` where isactive=1");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])

                if (dt.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {

                    err.Add("status", false);
                    err.Add("message", "No Record Found");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
   
    [HttpPost]
    public HttpResponseMessage CityMaster([FromBody]B2BLogin _login)
    {
        HttpError err = new HttpError();

        if (_login == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.username))
        {
            err.Add("status", false);
            err.Add("message", "username can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.password))
        {
            err.Add("status", false);
            err.Add("message", "password can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT ID,City,StateID  FROM `City_master` where isactive=1");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])

                if (dt.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {

                    err.Add("status", false);
                    err.Add("message", "No Record Found");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [HttpPost]
    public HttpResponseMessage PaymentMode([FromBody]B2BLogin _login)
    {
        HttpError err = new HttpError();

        if (_login == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.username))
        {
            err.Add("status", false);
            err.Add("message", "username can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.password))
        {
            err.Add("status", false);
            err.Add("message", "password can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT PaymentModeID,PaymentMode FROM paymentmode_master WHERE Active=1 AND PaymentModeID<>4 AND IsVisible=1 ORDER BY Sequence+0 ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])

                if (dt.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {

                    err.Add("status", false);
                    err.Add("message", "No Record Found");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [HttpPost]
    public HttpResponseMessage Bankmaster([FromBody]B2BLogin _login)
    {
        HttpError err = new HttpError();

        if (_login == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.username))
        {
            err.Add("status", false);
            err.Add("message", "username can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.password))
        {
            err.Add("status", false);
            err.Add("message", "password can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT Bank_id,Bankname  FROM `f_bank_master` ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])

                if (dt.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {

                    err.Add("status", false);
                    err.Add("message", "No Record Found");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
	 [HttpPost]
    public HttpResponseMessage CentreMaster([FromBody]Dispatch _login)
    {
        HttpError err = new HttpError();

        if (_login == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_login.PanelID))
        {
            err.Add("status", false);
            err.Add("message", "PanelID can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
      
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT cm.centreid,cm.centre FROM centre_panel cp INNER JOIN centre_master cm ON cm.`CentreID`=cp.`CentreId` WHERE cp.`PanelId`='"+_login.PanelID+"' AND cp.isactive=1 GROUP BY  cm.centreid");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])

                if (dt.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {

                    err.Add("status", false);
                    err.Add("message", "No Record Found");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [HttpPost]
    public object Dispatch([FromBody]Dispatch _Dispatch)
    {
        HttpError err = new HttpError();
        if (string.IsNullOrWhiteSpace(_Dispatch.FromDate))
        {
            err.Add("status", false);
            err.Add("message", "FromDate can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_Dispatch.ToDate))
        {
            err.Add("status", false);
            err.Add("message", "ToDate can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }


       

        //if (string.IsNullOrWhiteSpace(_Dispatch.Status))
        //{
        //    err.Add("status", false);
        //    err.Add("message", "Status  can't be blank");
        //    err.Add("data", "[]");
        //    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        //}
		string data="[]";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {


            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT IFNULL((SELECT COUNT(*) FROM document_detail WHERE Labno=lt.Ledgertransactionno AND isactive=1),0) DocAttach,if(lt.SRFNo='0','',lt.SRFNo)SRFNo,plo.LedgerTransactionID,0 isold, plo.IsUrgent,DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i %p') EntryDate,lt.`LedgerTransactionNo`,plo.`BarcodeNo`,plo.barcode_group,plo.IsSampleCollected,IFNULL(plo.UpdateRemarks,'') UpdateRemarks,");
            sb.Append(" lt.`PName`,CONCAT(lt.`Age`,'/',lt.`Gender`) pinfo,pm.mobile,(SELECT centre FROM centre_master WHERE centreid=lt.centreid)centre,");
            sb.Append(" lt.`DoctorName`,lt.`PanelName`,obm.Name AS Dept,plo.`ItemName`,plo.`Test_ID`,CONCAT(DATE_FORMAT(plo.DATE,'%Y/%M/%d'),'/',Test_ID)Radiologyfilepath,");
            sb.Append("  CONCAT('http://itd-saas.cl-srv.ondgni.com/uat_ver1/Design/Lab/labreportnew.aspx?IsPrev=0&testid=',plo.Test_ID,',') IsPrevURL,  CONCAT('http://itd-saas.cl-srv.ondgni.com/uat_ver1/Design/Lab/labreportnew.aspx?IsPrev=undefined&PHead=1&testid=',plo.Test_ID,',') IsPrevURL,");
            sb.Append(" plo.Approved,'' SampleStatus,plo.ReportType,");
            sb.Append(" case when plo.PdfCreated=0  then 'Pending' when plo.PdfCreated=1  then 'Saved' when plo.PdfCreated=2 then 'Posted' else '' end `CovidStatus`, ");
            sb.Append(" CASE   WHEN plo.IsDispatch=1 AND plo.isFOReceive=1 THEN '#44A3AA' "); //Dispatched
            sb.Append(" WHEN plo.IsSampleCollected='R' THEN '#FF0000' ");//Sample Rejected
            sb.Append(" WHEN plo.isFOReceive=0 AND plo.Approved=1 AND plo.isPrint=1 THEN '#00FFFF'  "); //Printed
            sb.Append(" WHEN plo.isFOReceive='0' AND plo.Approved=1  THEN '#90EE90' "); //Approved
            sb.Append(" WHEN plo.Result_Flag=1 AND plo.isHold=0 AND plo.isForward=0 AND isPartial_Result=0 AND  plo.IsSampleCollected<>'R'  THEN '#FFC0CB'  "); //Tested
            sb.Append(" WHEN plo.isHold=1 THEN '#FFFF00' "); //Hold
            sb.Append(" WHEN plo.IsSampleCollected='N' THEN '#CC99FF'  ");//New
            sb.Append(" WHEN plo.IsSampleCollected='S' THEN 'bisque'  ");//Sample Collected
            sb.Append(" WHEN plo.IsSampleCollected='Y' THEN '#FFFFFF' "); //Department Receive
            sb.Append(" ELSE '#FFFFFF' END rowColor,  ");
            sb.Append(" if(plo.IsSampleCollected='S',(SELECT `Status` FROM  patient_labinvestigation_opd_update_status plus WHERE plus.BarcodeNo=plo.BarcodeNo ORDER BY dtEntry DESC LIMIT 1 ),'') LogisticStatus  ");

            sb.Append(" ,(SELECT COUNT(1) FROM `patient_labinvestigation_opd_remarks` WHERE Test_ID= plo.Test_ID AND isActive=1 ) Remarks, ");
            sb.Append(" (SELECT COUNT(1) FROM centre_master WHERE TagProcessingLabID=@SessionCentreID)ShowPrintPrev ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo  ");
            sb.Append(" INNER JOIN patient_master pm on pm.patient_id=plo.patient_id");
            sb.Append(" INNER JOIN f_ledgertransaction lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` ");

            

                if (_Dispatch.SearchType == "plo.BarcodeNo")
                {
                    sb.Append(" AND plo.`BarcodeNo`=@Dispatch");
                }
                if (_Dispatch.SearchType == "lt.Patient_ID")
                {
                    sb.Append(" AND lt.Patient_ID`=@Dispatch");
                }
                if (_Dispatch.SearchType == "plo.LedgerTransactionNo")
                {
                    sb.Append(" AND plo.LedgerTransactionNo`=@Dispatch");
                }
                if (_Dispatch.SearchType == "pm.mobile")
                {
                    sb.Append(" AND pm.mobile`=@Dispatch");
                }
                if (_Dispatch.SearchType == "pm.pname")
                {
                    sb.Append(" AND pm.pname`=@Dispatch");
                }
            

                sb.AppendFormat("  AND plo.Date>=@FromDate");
                sb.AppendFormat("  AND plo.Date<=@ToDate ");
         

            //sb.Append(" and plo.ItemID=@ItemID ");
            //sb.Append(" AND lt.`CreatedByID`=@CreatedByID");

           // sb.Append("  AND lt.CentreID=@CentreID");


            sb.Append(" INNER JOIN f_panel_master fpm  ON lt.`Panel_ID` = fpm.`Panel_ID` ");

            //if (_Dispatch.Status != "BOTH")
            //{
            //    sb.Append(" AND ReportDispatchMode=@ReportDispatchMode");
            //}

            sb.Append(" INNER JOIN f_subcategorymaster obm ON obm.subcategoryid=plo.subcategoryid ");

            //sb.Append("  AND obm.subcategoryid=@Department ");
            //sb.Append(" AND plo.IsReporting=1  ORDER BY plo.LedgerTransactionNo,plo.barcodeno, plo.`ItemName` ");//and plo.ReportType<>5



            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),

                     new MySqlParameter("@Dispatch", _Dispatch.SearchValue),
                     new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(_Dispatch.FromDate).ToString("yyyy-MM-dd"), " ")),
                     new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(_Dispatch.ToDate).ToString("yyyy-MM-dd"), " ")),
                     new MySqlParameter("@ReportDispatchMode", _Dispatch.Status)).Tables[0])

                if (dt.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {

                    string massege="{\"status\": false,\"message\": \"No Data Found\",\"data\": []}";
                        err.Add("status", false);
                        err.Add("message", "No Record Found");
                        err.Add("data", data);
						return JsonConvert.DeserializeObject(massege);
                }


        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "No Record Found");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [HttpPost]
    public HttpResponseMessage RecieptReprint([FromBody]Dispatch _Dispatch)
    {
        HttpError err = new HttpError();
        if (string.IsNullOrWhiteSpace(_Dispatch.FromDate))
        {
            err.Add("status", false);
            err.Add("message", "FromDate can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_Dispatch.ToDate))
        {
            err.Add("status", false);
            err.Add("message", "ToDate can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }




        //if (string.IsNullOrWhiteSpace(_Dispatch.Status))
        //{
        //    err.Add("status", false);
        //    err.Add("message", "Status  can't be blank");
        //    err.Add("data", "[]");
        //    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        //}
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
           // int SearchType = 1;

            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT IFNULL((SELECT COUNT(*) FROM document_detail WHERE Labno=lt.Ledgertransactionno AND isactive=1),0) DocAttach,lt.LedgerTransactionID ,DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i %p') EntryDate,DATE_FORMAT(lt.`Date`,'%d-%b-%Y')RegDate ,");
            sb.Append(" lt.`LedgerTransactionNo` LabNo,CONCAT(pm.`Title`,pm.`PName`) PName,CONCAT(pm.`Age`,'/',LEFT(pm.`Gender`,1)) Pinfo,");
            sb.Append(" pm.`Mobile`,lt.`DoctorName` DoctorName,lt.`PanelName`,lt.IsOPDConsultation,CONCAT('http://itd-saas.cl-srv.ondgni.com/uat_ver1/Design/Lab/PatientReceiptNew1.aspx?IsAPI=1&LabID','=',lt.LedgerTransactionID) CashReceipUrl,");
            sb.Append(" (SELECT centre FROM centre_master WHERE centreID=lt.centreid)CentreName,");
            sb.Append(" lt.CreatedBy UserName,lt.`GrossAmount`,lt.`DiscountOnTotal`,lt.`NetAmount`,lt.`Adjustment`,");
            sb.Append("  GROUP_CONCAT(REPLACE(inv.Name,',',' ')) AS ItemName,        ");
            sb.Append("  GROUP_CONCAT(IF(plo.Result_Flag=1 AND plo.Approved=0 ,'Y','N'))Result_Flag,   ");
            sb.Append("  GROUP_CONCAT(IF(plo.Approved=1 AND plo.isPrint=0,'Y','N'))Approved, ");
            sb.Append("  GROUP_CONCAT(IF(plo.isPrint=1 AND plo.Approved=1 ,'Y','N'))ReportPrint,CASE WHEN GROUP_CONCAT(DISTINCT plo.BarcodeNo SEPARATOR ',<br/>') !='undefined' THEN GROUP_CONCAT(DISTINCT plo.BarcodeNo SEPARATOR ',<br/>') ELSE '' END BarcodeNo,");
            sb.Append("  CASE    ");

            sb.Append(" WHEN  (SELECT SUM(Amount) FROM patient_labinvestigation_opd WHERE  LedgerTransactionID = plo.`LedgerTransactionID`)=0 and plo.isactive=0 THEN '#6699ff'  ");
            sb.Append(" WHEN (lt.NetAmount-lt.Adjustment)=0  AND lt.iscredit=0 THEN '#00FA9A'  ");
            sb.Append(" WHEN (lt.iscredit =1) THEN '#F0FFF0'  ");
            sb.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment>0 AND lt.iscredit=0 THEN '#F6A9D1'  ");
            // sb.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment=0 AND lt.iscredit=0 THEN '#DDA0DD' ");
            sb.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment=0 AND lt.iscredit=0 THEN '#FF457C' ");


            sb.Append(" ELSE '#F6A9D1'  END  rowColor,lt.Iscredit");
            sb.Append(" ,lt.IsDiscountApproved,lt.DiscountApprovedByID,IFNULL(lt.DiscountApprovedByName,'') DiscountApprovedByName,IFNULL(fpm.ReceiptType,'')ReceiptType   ");
            sb.Append(" ,(SELECT SUM(Amount) FROM patient_labinvestigation_opd WHERE  LedgerTransactionID = plo.`LedgerTransactionID`) Amount,(lt.NetAmount-lt.Adjustment)Due ");
            sb.Append(" FROM `f_ledgertransaction` lt ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  AND plo.IsActive=1");//AND plo.IsActive=1
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`");
            sb.Append(" INNER JOIN investigation_master inv ON inv.investigation_id = plo.investigation_id");

            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID = lt.Panel_ID");

          

                if (_Dispatch.SearchType == "plo.BarcodeNo")
                {
                    sb.Append(" AND plo.`BarcodeNo`=@Dispatch");
                }
                if (_Dispatch.SearchType == "lt.Patient_ID")
                {
                    sb.Append(" AND lt.Patient_ID`=@Dispatch");
                }
                if (_Dispatch.SearchType == "lt.LedgertransactionNo")
                {
                    sb.Append(" AND plo.LedgerTransactionNo`=@Dispatch");
                }
                if (_Dispatch.SearchType == "pm.Mobile")
                {
                    sb.Append(" AND pm.mobile`=@Dispatch");
                }
                if (_Dispatch.SearchType == "pm.pname")
                {
                    sb.Append(" AND pm.pname`=@Dispatch");
                }

                sb.Append(" AND lt.Panel_ID=@Panel_ID");
            sb.AppendFormat("  AND plo.Date>=@FromDate", _Dispatch.FromDate);
            sb.AppendFormat("  AND plo.Date<=@ToDate ", _Dispatch.ToDate);



            sb.Append(" GROUP BY lt.LedgerTransactionNo order by lt.date desc");



            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),

                     new MySqlParameter("@Dispatch", _Dispatch.SearchValue),
                     new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(_Dispatch.FromDate).ToString("yyyy-MM-dd"), " ")),
                     new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(_Dispatch.ToDate).ToString("yyyy-MM-dd"), " ")),
                     new MySqlParameter("@ReportDispatchMode", _Dispatch.Status), new MySqlParameter("@Panel_ID", _Dispatch.PanelID)).Tables[0])

                if (dt.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {

                    err.Add("status", false);
                    err.Add("message", "No Record Found");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }


        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "No Record Found");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

 [HttpPost]
    public HttpResponseMessage AdvancePaymentSubmit([FromBody]AdvancePaymentSubmit _PanelAdvanceAmount)
    {

        HttpError err = new HttpError();
        if (string.IsNullOrWhiteSpace(_PanelAdvanceAmount.DepositeDate))
        {
            err.Add("status", false);
            err.Add("message", "DepositeDate can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                int InvoiceCreatedOn = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT InvoiceCreatedOn FROM f_panel_master WHERE Panel_ID=@Panel_ID",
                    new MySqlParameter("@Panel_ID", _PanelAdvanceAmount.EmployeeID)));
                //if (InvoiceCreatedOn == 1 && Util.GetInt(_PanelAdvanceAmount.TypeOfPayment) == 0)
                //{
                //    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "For Patient Wise Client Deposit not Possible" });
                //}

                if (_PanelAdvanceAmount.IsAgainstinvoice == 1)
                {
                    DataTable invoiceDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ShareAmt,IsCancel FROM invoicemaster WHERE InvoiceNo=@InvoiceNo",
                       new MySqlParameter("@InvoiceNo", _PanelAdvanceAmount.InvoiceNo)).Tables[0];
                    //if (invoiceDetail.Rows[0]["IsCancel"].ToString() == "1")
                    //{
                    //    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Invoice already Cancel,Please Reopen Page" });
                    //}
                    //if (Util.GetDecimal(invoiceDetail.Rows[0]["ShareAmt"].ToString()) < Util.GetDecimal(_PanelAdvanceAmount.AdvAmount.Select(s => s.AdvAmount).Sum()))
                    //{
                    //    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Please Enter Valid Amount,Payment already received" });
                    //}

                    //decimal receivedAmtDetail = Util.GetDecimal(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, " SELECT SUM(ReceivedAmt)ReceivedAmt FROM Invoicemaster_Payment WHERE  InvoiceNo=@InvoiceNo AND ValidateStatus!=2",
                    //   new MySqlParameter("@InvoiceNo",_PanelAdvanceAmount.InvoiceNo)));
                    //if (Util.GetDecimal(invoiceDetail.Rows[0]["ShareAmt"].ToString()) < Util.GetDecimal(receivedAmtDetail) + Util.GetDecimal(AdvAmount.Select(s => s.AdvAmount).Sum()))
                    //{
                    //    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Please Enter Valid Amount,Payment already received" });
                    //}
                }

                //      List<PanelAdvanceAmount> AdvAmount = new JavaScriptSerializer().ConvertToType<List<PanelAdvanceAmount>>(PanelAdvanceAmountt);
                List<AdvancePaymentSubmit> AdvAmount = new List<AdvancePaymentSubmit>();
                AdvAmount.Add(_PanelAdvanceAmount);
                string receiptno = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT get_receiptno_invoice(@typeOfPayment,@PanelID,@dtAdv)",
                                                  new MySqlParameter("@typeOfPayment", Util.GetString(_PanelAdvanceAmount.TypeOfPayment)),
                                                  new MySqlParameter("@PanelID", Util.GetString(_PanelAdvanceAmount.EmployeeID)),
                                                  new MySqlParameter("@dtAdv", Util.GetDateTime(_PanelAdvanceAmount.DepositeDate).ToString("yyyy-MM-dd"))));
                int IsMainPayment = 1;
                // long MainPaymentIDOnAccount = 0;
                // long MainPaymentIDOnPayment = 0;
                DateTime EntryDate = DateTime.Now;
                //int MainPaymentIDOnAccount = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT get_Tran_id(@PaymentIDOnAccount)",
                //    new MySqlParameter("@PaymentIDOnAccount", "PaymentIDOnAccount")));
                //if (MainPaymentIDOnAccount == 0)
                //{
                //    Tranx.Rollback();
                //    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error in Generate PaymentIDOnAccount" });
                //}
                int MainPaymentIDOnPayment = Util.GetInt(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, "SELECT get_Tran_id(@PaymentIDOnPayment)",
                    new MySqlParameter("@PaymentIDOnPayment", "PaymentIDOnPayment")));
                //if (MainPaymentIDOnPayment == 0)
                //{
                //    Tranx.Rollback();
                //    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error in Generate PaymentIDOnPayment" });
                //}
                decimal AdvAmt = 1;
                //if (Util.GetInt(_PanelAdvanceAmount.TypeOfPayment) == 2 && Util.GetDouble(AdvAmt) > 0)
                //    AdvAmt = -1;
                //else if (Util.GetInt(_PanelAdvanceAmount.TypeOfPayment) == 3 && Util.GetDouble(AdvAmt) > 0)
                //{
                //    AdvAmt = -1;
                //}

                for (int i = 0; i < AdvAmount.Count; i++)
                {
                    StringBuilder sb = new StringBuilder();
                    sb.Append(" INSERT INTO invoicemaster_onaccount(ReceivedAmt,EntryDate,EntryBy,Panel_id ,`Type`, ");
                    sb.Append(" ReceiptNo,Remarks , EntryByName, receivedDate, CreditNote,EntryType,ValidateStatus,ApprovedBy,ApprovedByID,ApprovedOnDate,IsAccountPayment,CreditDebitNoteTypeID,CreditDebitNoteType, ");
                    sb.Append(" PaymentMode, BankName, CardNo, CardDate, Narration, PaymentModeID, S_Amount, S_CountryID, S_Currency, ");
                    sb.Append("   S_Notation, C_Factor, Currency_RoundOff, CurrencyRoundDigit, Converson_ID,InvoiceNo,IsMainPayment,MainPaymentID) ");
                    sb.Append(" VALUES (@ReceivedAmt,@Entrydate,@EntryBy,@PanelID,'ON ACCOUNT', ");
                    sb.Append(" @ReceiptNo, @Remarks, @EntryByName,@receivedDate ,@typeOfPayment,@EntryType,'1',@ApprovedBy,@ApprovedByID,@Entrydate,@IsAccountPayment,@CreditDebitNoteTypeID,@CreditDebitNoteType, ");
                    sb.Append(" @PaymentMode, @BankName, @CardNo, @CardDate, @Narration, @PaymentModeID, @S_Amount, @S_CountryID, @S_Currency, ");
                    sb.Append(" @S_Notation, @C_Factor, @Currency_RoundOff, @CurrencyRoundDigit, @Converson_ID,@InvoiceNo,@IsMainPayment,@MainPaymentID) ");
                    MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, Tranx);
                    cmd.Parameters.AddWithValue("@ReceivedAmt", Util.GetDecimal(AdvAmount[i].AdvAmount) * AdvAmt);
                    cmd.Parameters.AddWithValue("@EntryBy", AdvAmount[0].EmployeeID);
                    cmd.Parameters.AddWithValue("@Entrydate", EntryDate);
                    cmd.Parameters.AddWithValue("@PanelID", AdvAmount[0].EmployeeID);
                    cmd.Parameters.AddWithValue("@ReceiptNo", receiptno);
                    cmd.Parameters.AddWithValue("@Remarks", AdvAmount[0].Remarks);
                    cmd.Parameters.AddWithValue("@EntryByName", AdvAmount[0].Employeename);
                    cmd.Parameters.AddWithValue("@receivedDate", Util.GetDateTime(AdvAmount[0].DepositeDate).ToString("yyyy-MM-dd"));
                    cmd.Parameters.AddWithValue("@typeOfPayment", 0);
                    cmd.Parameters.AddWithValue("@ApprovedBy", AdvAmount[0].EmployeeID);
                    cmd.Parameters.AddWithValue("@ApprovedByID", AdvAmount[0].EmployeeID);
                    cmd.Parameters.AddWithValue("@IsAccountPayment", "1");
                    cmd.Parameters.AddWithValue("@CreditDebitNoteTypeID", AdvAmount[0].CreditDebitNoteTypeID);
                    cmd.Parameters.AddWithValue("@CreditDebitNoteType", AdvAmount[0].CreditDebitNoteType);
                    cmd.Parameters.AddWithValue("@EntryType", AdvAmount[0].EntryType);


                    if (i == 0)
                    {
                        IsMainPayment = 1;
                        cmd.Parameters.AddWithValue("@IsMainPayment", 1);
                        cmd.Parameters.AddWithValue("@BankName", AdvAmount[0].BankName);
                        cmd.Parameters.AddWithValue("@CardNo", AdvAmount[0].CardNo);
                        cmd.Parameters.AddWithValue("@CardDate", AdvAmount[0].CardDate);
                        cmd.Parameters.AddWithValue("@S_Amount", AdvAmount[0].S_Amount * AdvAmt);
                        cmd.Parameters.AddWithValue("@S_CountryID", AdvAmount[0].S_CountryID);
                        cmd.Parameters.AddWithValue("@S_Currency", AdvAmount[0].S_Currency);
                        cmd.Parameters.AddWithValue("@S_Notation", AdvAmount[0].S_Notation);
                        cmd.Parameters.AddWithValue("@C_Factor", AdvAmount[0].C_Factor);
                        cmd.Parameters.AddWithValue("@Currency_RoundOff", AdvAmount[0].Currency_RoundOff);
                        cmd.Parameters.AddWithValue("@CurrencyRoundDigit", AdvAmount[0].CurrencyRoundDigit);
                        cmd.Parameters.AddWithValue("@Converson_ID", AdvAmount[0].Converson_ID);

                    }
                    else
                    {
                        IsMainPayment = 0;
                        cmd.Parameters.AddWithValue("@IsMainPayment", 0);
                        cmd.Parameters.AddWithValue("@BankName", string.Empty);
                        cmd.Parameters.AddWithValue("@CardNo", string.Empty);
                        cmd.Parameters.AddWithValue("@CardDate", "0001-01-01");
                        cmd.Parameters.AddWithValue("@S_Amount", Util.GetDecimal(AdvAmount[i].AdvAmount) * AdvAmt);
                        cmd.Parameters.AddWithValue("@S_CountryID", Resources.Resource.BaseCurrencyID);
                        cmd.Parameters.AddWithValue("@S_Currency", Resources.Resource.BaseCurrencyNotation);
                        cmd.Parameters.AddWithValue("@S_Notation", Resources.Resource.BaseCurrencyNotation);
                        cmd.Parameters.AddWithValue("@C_Factor", 1);
                        cmd.Parameters.AddWithValue("@Currency_RoundOff", 0);
                        cmd.Parameters.AddWithValue("@CurrencyRoundDigit", Resources.Resource.BaseCurrencyRound);
                        cmd.Parameters.AddWithValue("@Converson_ID", 0);

                    }
                    cmd.Parameters.AddWithValue("@MainPaymentID", MainPaymentIDOnPayment);
                    cmd.Parameters.AddWithValue("@PaymentMode", AdvAmount[i].PaymentMode.Trim());
                    cmd.Parameters.AddWithValue("@Narration", AdvAmount[0].Narration ?? string.Empty);
                    cmd.Parameters.AddWithValue("@PaymentModeID", AdvAmount[i].PaymentModeID);
                    cmd.Parameters.AddWithValue("@InvoiceNo", AdvAmount[0].InvoiceNo);
                    cmd.ExecuteNonQuery();
                    long invoicemaster_onaccount_ID = cmd.LastInsertedId;

                    cmd.Dispose();
                    //if (i == 0)
                    //{
                    //    MainPaymentIDOnAccount = invoicemaster_onaccount_ID;
                    //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE Invoicemaster_Payment SET MainPaymentID=@ID WHERE ID=@ID",
                    //       new MySqlParameter("@ID", MainPaymentIDOnAccount));
                    //}
                    // if (Util.GetInt(AdvAmount[0].TypeOfPayment) == 0)
                    //  {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO Invoicemaster_Payment(ReceivedAmt,EntryDate,EntryBy,Panel_id ,`Type`,ReceiptNo, ");
                    sb.Append(" TDS,WriteOff,Remarks,EntryByName, receivedDate, CreditNote,IsMainPayment,EntryType,ValidateStatus,ValidateBy,ValidateByID,ValidateDate,invoicemaster_onaccount_ID, ");
                    sb.Append(" PaymentMode, BankName, CardNo, CardDate, Narration, PaymentModeID, S_Amount, S_CountryID, S_Currency, ");
                    sb.Append(" S_Notation, C_Factor, Currency_RoundOff, CurrencyRoundDigit, Converson_ID,MainPaymentID,InvoiceNo,InvoiceAmount) ");
                    sb.Append(" VALUES (@AdvAmt,@Entrydate,@EntryBy,@PanelID, 'ON ACCOUNT',@receiptNo, ");
                    sb.Append(" 0,0,@Remarks, @LoginName,@dtAdv,@typeOfPayment,@IsMainPayment,@EntryType,'1',@ValidateBy,@ValidateByID,@Entrydate,@invoicemaster_onaccount_ID, ");
                    sb.Append(" @PaymentMode, @BankName, @CardNo, @CardDate, @Narration, @PaymentModeID, @S_Amount, @S_CountryID, @S_Currency, ");
                    sb.Append(" @S_Notation, @C_Factor, @Currency_RoundOff, @CurrencyRoundDigit, @Converson_ID,@MainPaymentID,@InvoiceNo,@InvoiceAmount) ");

                    MySqlCommand cmd1 = new MySqlCommand(sb.ToString(), con, Tranx);

                    cmd1.Parameters.AddWithValue("@AdvAmt", Util.GetDecimal(AdvAmount[i].AdvAmount));
                    cmd1.Parameters.AddWithValue("@EntryBy", 1);
                    cmd1.Parameters.AddWithValue("@Entrydate", EntryDate);
                    cmd1.Parameters.AddWithValue("@PanelID", AdvAmount[0].EmployeeID);
                    cmd1.Parameters.AddWithValue("@Remarks", AdvAmount[0].Remarks);
                    cmd1.Parameters.AddWithValue("@LoginName", AdvAmount[0].EmployeeID);
                    cmd1.Parameters.AddWithValue("@dtAdv", Util.GetDateTime(AdvAmount[0].DepositeDate).ToString("yyyy-MM-dd"));
                    cmd1.Parameters.AddWithValue("@typeOfPayment", 0);
                    cmd1.Parameters.AddWithValue("@EntryType", AdvAmount[0].EntryType);
                    cmd1.Parameters.AddWithValue("@ValidateBy", AdvAmount[0].EmployeeID);
                    cmd1.Parameters.AddWithValue("@ValidateByID", AdvAmount[0].EmployeeID);
                    cmd1.Parameters.AddWithValue("@invoicemaster_onaccount_ID", invoicemaster_onaccount_ID);
                    cmd1.Parameters.AddWithValue("@PaymentMode", AdvAmount[i].PaymentModeID.Trim());
                    cmd1.Parameters.AddWithValue("@PaymentModeID", AdvAmount[i].PaymentModeID);
                    cmd1.Parameters.AddWithValue("@InvoiceNo", AdvAmount[0].InvoiceNo);
                    cmd1.Parameters.AddWithValue("@ReceiptNo", receiptno);
                    if (i == 0)
                    {
                        IsMainPayment = 1;
                        cmd1.Parameters.AddWithValue("@IsMainPayment", 1);
                        cmd1.Parameters.AddWithValue("@BankName", AdvAmount[0].BankName);
                        cmd1.Parameters.AddWithValue("@CardNo", AdvAmount[0].CardNo);
                        cmd1.Parameters.AddWithValue("@CardDate", AdvAmount[0].CardDate);
                        cmd1.Parameters.AddWithValue("@S_Amount", AdvAmount[0].S_Amount);
                        cmd1.Parameters.AddWithValue("@S_CountryID", AdvAmount[0].S_CountryID);
                        cmd1.Parameters.AddWithValue("@S_Currency", AdvAmount[0].S_Currency);
                        cmd1.Parameters.AddWithValue("@S_Notation", AdvAmount[0].S_Notation);

                        cmd1.Parameters.AddWithValue("@C_Factor", AdvAmount[0].C_Factor);
                        cmd1.Parameters.AddWithValue("@Currency_RoundOff", AdvAmount[0].Currency_RoundOff);
                        cmd1.Parameters.AddWithValue("@CurrencyRoundDigit", AdvAmount[0].CurrencyRoundDigit);
                        cmd1.Parameters.AddWithValue("@Converson_ID", AdvAmount[0].Converson_ID);
                        cmd1.Parameters.AddWithValue("@MainPaymentID", MainPaymentIDOnPayment);
                    }
                    else
                    {
                        IsMainPayment = 0;
                        cmd1.Parameters.AddWithValue("@IsMainPayment", 0);
                        cmd1.Parameters.AddWithValue("@BankName", string.Empty);
                        cmd1.Parameters.AddWithValue("@CardNo", string.Empty);
                        cmd1.Parameters.AddWithValue("@CardDate", "0001-01-01");
                        cmd1.Parameters.AddWithValue("@S_Amount", Util.GetDecimal(AdvAmount[i].AdvAmount));
                        cmd1.Parameters.AddWithValue("@S_CountryID", Resources.Resource.BaseCurrencyID);
                        cmd1.Parameters.AddWithValue("@S_Currency", Resources.Resource.BaseCurrencyNotation);
                        cmd1.Parameters.AddWithValue("@S_Notation", Resources.Resource.BaseCurrencyNotation);
                        cmd1.Parameters.AddWithValue("@C_Factor", 1);
                        cmd1.Parameters.AddWithValue("@Currency_RoundOff", 0);
                        cmd1.Parameters.AddWithValue("@CurrencyRoundDigit", Resources.Resource.BaseCurrencyRound);
                        cmd1.Parameters.AddWithValue("@Converson_ID", 0);
                        cmd1.Parameters.AddWithValue("@MainPaymentID", MainPaymentIDOnPayment);
                    }

                    cmd1.Parameters.AddWithValue("@Narration", AdvAmount[0].Narration ?? string.Empty);
                    cmd1.Parameters.AddWithValue("@InvoiceAmount", Util.GetDecimal(AdvAmount[0].InvoiceAmount));
                    cmd1.ExecuteNonQuery();
                    long Invoicemaster_Payment_ID = cmd1.LastInsertedId;
                    cmd1.Dispose();

                    //if (i == 0)
                    //{
                    //    MainPaymentIDOnPayment = Invoicemaster_Payment_ID;
                    //    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE Invoicemaster_Payment SET MainPaymentID=@MainPaymentIDOnPayment WHERE ID=@ID",
                    //       new MySqlParameter("@MainPaymentIDOnPayment", MainPaymentIDOnPayment),
                    //       new MySqlParameter("@ID", Invoicemaster_Payment_ID));
                    //}

                    int result = MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, "UPDATE invoicemaster_onaccount SET Invoicemaster_Payment_ID=@Invoicemaster_Payment_ID WHERE ID=@ID",
                                    new MySqlParameter("@Invoicemaster_Payment_ID", Invoicemaster_Payment_ID),
                                    new MySqlParameter("@ID", invoicemaster_onaccount_ID));
                    Tranx.Commit();
                    if (result == 1)
                    {

                        err.Add("status", true);
                        err.Add("message", "Success");
                        err.Add("data", "Record Save Successfully");
                        return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                    }
                    else
                    {
                        err.Add("status", true);
                        err.Add("message", "Success");
                        err.Add("data", "Record Not Save");
                        return Request.CreateErrorResponse(HttpStatusCode.OK, err);

                    }

                }

                //using (DataTable dtresult = PrevAdvPayment(Util.GetString(AdvAmount[0].PanelID), Util.GetInt(AdvAmount[0].TypeOfPayment), con))
                //{
                //    return JsonConvert.SerializeObject(new { status = true, data = dtresult });
                //}


            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                Tranx.Rollback();
                err.Add("status", false);
                err.Add("message", ex);
                err.Add("data", "[]");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            finally
            {
                Tranx.Dispose();
                con.Close();
                con.Dispose();

            }
            //return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        return Request.CreateErrorResponse(HttpStatusCode.OK, err);
    }


 [HttpPost]
    public object ClientDepositReport([FromBody]ClientDepositReport _ClientDepositReport)
    {

       // _ClientDepositReport.PanelID = String.Join(",", _ClientDepositReport.PanelID.Split(new char[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Split('#')[0]).ToList());
        HttpError err = new HttpError();

        if (_ClientDepositReport == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        //if (string.IsNullOrWhiteSpace(_ClientDepositReport.SearchType))
        //{
        //    err.Add("status", false);
        //    err.Add("message", "SearchType can't be blank");
        //    err.Add("data", "[]");
        //    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        //}
        if (string.IsNullOrWhiteSpace(_ClientDepositReport.DateType))
        {
            err.Add("status", false);
            err.Add("message", "DateType can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT * FROM ( ");
            sb.Append(" SELECT CONCAT(ivac.S_Amount,'(',ivac.S_Notation,')')BaseAmount, ivac.PaymentMode,");
            sb.Append(" (case when ivac.CreditNote='0' then 'Deposit' when ivac.CreditNote='1' then 'Credit Note' when ivac.CreditNote='2' then 'Debit Note' when ivac.CreditNote='3' then 'Cheque Bounce' else '' end )PaymentType,");
            sb.Append(" ivac.cardNo,DATE_FORMAT(ivac.`CardDate`, '%d-%b-%Y')CardDate,ivac.S_Currency PayCurrency,  ivac.`ReceivedAmt` PaidAmount,ivac.C_factor Conversion,ivac.Bank BankName,ivac.EntryByName EntryBy,");
            sb.Append(" DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y') DepositDate ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i %p') `EntryDate/ValidateDate`,");
            sb.Append(" CASE WHEN IsCancel=1 THEN 'Reject' WHEN ValidateStatus=0 THEN 'Pending' WHEN ValidateStatus=1 THEN 'Approve' END `Status`,ivac.ApprovedBy,");
            sb.Append(" DATE_FORMAT(ivac.`receivedDate`,'%d-%b-%Y')ReceivedDate,Remarks,IF(IsCancel=1,CancelReason,'')RejectReason,IsCancel,IFNULL(CreditDebitNoteType,'')CreditDebitNoteType  FROM `invoicemaster_onaccount` ivac ");
            sb.Append(" WHERE  ivac.`Panel_ID`<>'' ");
           
            
                sb.Append(" AND ivac.panel_id IN('" + _ClientDepositReport.PanelID + "') ");
           
            if (_ClientDepositReport.DateType == "Deposit")
                sb.Append(" AND ivac.`receivedDate`>=@FromDate AND  ivac.`receivedDate`<=@ToDate ");
            else if (_ClientDepositReport.DateType == "Entry")
                sb.Append(" AND ivac.`EntryDate`>=@FromDate AND  ivac.`EntryDate`<=@ToDate ");
            else
                sb.Append(" AND ivac.`EntryDate`>=@FromDate AND  ivac.`EntryDate`<=@ToDate ");

            sb.Append(" UNION ALL ");

            sb.Append("    SELECT CONCAT(ivac.S_Amount,'(',ivac.S_Notation,')')BaseAmount,");
            sb.Append(" ivac.PaymentMode, (case when ivac.CreditNote='0' then 'Deposit' when ivac.CreditNote='1' then 'Credit Note' when ivac.CreditNote='2' then 'Debit Note' when ivac.CreditNote='3' then 'Cheque Bounce' else '' end )PaymentType,");
            sb.Append(" ivac.cardNo,DATE_FORMAT(ivac.`CardDate`, '%d-%b-%Y')CardDate,ivac.S_Currency PayCurrency,  ivac.`ReceivedAmt` PaidAmount,ivac.C_factor Conversion,ivac.Bank BankName,ivac.EntryByName EntryBy, ");
            sb.Append("  DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y') DepositDate ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i %p') `EntryDate/ValidateDate`,CASE WHEN IsCancel=1 THEN 'Reject' WHEN ValidateStatus=0 THEN 'Pending' WHEN ValidateStatus=1 THEN 'Approve' END `Status`,'' ApprovedBy, ");
            sb.Append("  DATE_FORMAT(ivac.`receivedDate`,'%d-%b-%Y')ReceivedDate,Remarks,if(IsCancel=1,CancelReason,'')RejectReason,IsCancel,'' CreditDebitNoteType  FROM `Invoicemaster_Payment` ivac  ");
            sb.Append("  WHERE  ivac.`Panel_ID`<>''  AND ValidateStatus=0 ");

            sb.Append(" AND ivac.panel_id IN('" + _ClientDepositReport.PanelID + "') ");

 
            sb.Append(" AND ivac.`receivedDate`>= @FromDate AND  ivac.`receivedDate`<= @ToDate ");
           

            sb.Append(" )t ORDER BY STR_TO_DATE(t.`EntryDate/ValidateDate`, '%l:%i %p'); ");
           // DataTable dt = new DataTable();
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                //new MySqlParameter("@Employee_ID", Util.GetString(_Invocereprint.User)),
          new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(_ClientDepositReport.FromDate).ToString("yyyy-MM-dd"))),
          new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(_ClientDepositReport.ToDate).ToString("yyyy-MM-dd"))),
                //new MySqlParameter("@Centre", _Invocereprint.Centre),
                //new MySqlParameter("@LoginCentre", UserInfo.Centre),
                //new MySqlParameter("@LoginUser", UserInfo.ID),
                //new MySqlParameter("@LabNo", Util.GetString(_Invocereprint.LabNo)),
                new MySqlParameter("@SearchType", Util.GetString(_ClientDepositReport.SearchType)),
                //new MySqlParameter("@PName", string.Concat("%", Util.GetString(_Invocereprint.LabNo), "%")),
          new MySqlParameter("@Panel_ID", Util.GetString(_ClientDepositReport.PanelID))).Tables[0];
            
                if (dt.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);

                }
                else
                {

                   string massege="{\"status\": false,\"message\": \"No Data Found\",\"data\": []}";
                        err.Add("status", false);
                        err.Add("message", "No Record Found");
                        err.Add("data", "[]");
						return JsonConvert.DeserializeObject(massege);
                }



            

        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
            return Request.CreateErrorResponse(HttpStatusCode.OK, ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }


    }

 [HttpPost]
    public HttpResponseMessage SearchSampleCollection([FromBody]SearchSampleCollection _Invocereprint)
    {


        HttpError err = new HttpError();

        if (_Invocereprint == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_Invocereprint.PanelID))
        {
            err.Add("status", false);
            err.Add("message", "PanelID can't be blank");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        string dt = string.Concat(Util.GetDateTime(_Invocereprint.FromDate).ToString("yyyy-MM-dd"), ' ', "00:00:00");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" SELECT plo.ledgertransactionID, plo.IsSampleCollected,group_concat(distinct plo.BarcodeNo) BarcodeNo,CONCAT(lt.PName,'/',lt.age) as PName,plo.ledgerTransactionNO,  ");
            sbQuery.Append(" lt.panelname PanelName FROM  patient_labinvestigation_opd plo  ");
            sbQuery.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgerTransactionID=plo.ledgerTransactionID  AND plo.IsActive=1 ");
            
           
            sbQuery.Append(" INNER JOIN f_panel_master fpm on fpm.panel_id=lt.panel_Id ");
            
                sbQuery.Append("  AND fpm.panel_id=@PanelID ");
                switch (_Invocereprint.SampleStatus)
            {
                case "N": sbQuery.Append(" AND plo.IsSampleCollected='N' AND plo.IsReporting=1 ");
                    break;
                case "Y": sbQuery.Append(" AND plo.IsSampleCollected='Y' AND plo.IsReporting=1 ");
                    break;
                case "S": sbQuery.Append(" AND plo.IsSampleCollected='S' AND plo.IsReporting=1 ");
                    break;
                case "R": sbQuery.Append(" AND plo.IsSampleCollected='R'  ");
                    break;
            }
           
             sbQuery.Append(" AND lt.date >=@fromDate AND lt.date <=@toDate ");
            sbQuery.Append("  AND plo.Reporttype <> 5 ");
            sbQuery.Append("  GROUP BY plo.ledgertransactionNo  ");
            sbQuery.Append(" order by plo.`BarcodeNo` ");
            DataTable dtN = new DataTable();
             using ( dtN = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
                    new MySqlParameter("@PanelID", _Invocereprint.PanelID),
                    new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(_Invocereprint.FromDate).ToString("yyyy-MM-dd"), ' ', "00:00:00")),
                    new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(_Invocereprint.ToDate).ToString("yyyy-MM-dd"), ' ', "23:59:59"))).Tables[0])
           
                


                if (dtN.Rows.Count > 0)
                    {

                        err.Add("status", true);
                        err.Add("message", "Success");
                        err.Add("data", JArray.FromObject(dtN));
                        return Request.CreateErrorResponse(HttpStatusCode.OK, err);

                    }
                    else
                    {

                        err.Add("status", false);
                        err.Add("message", "No Record Found");
                        err.Add("data", "");
                        return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                    }

            

        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [HttpPost]
    public HttpResponseMessage SaveSampleDetail([FromBody]SearchSampleCollection _Invocereprint)
    {


        HttpError err = new HttpError();

        if (_Invocereprint == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_Invocereprint.TestID))
        {
            err.Add("status", false);
            err.Add("message", "TestID can't be blank");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_Invocereprint.PanelID))
        {
            err.Add("status", false);
            err.Add("message", "PanelID can't be blank");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        string[] data = _Invocereprint.TestID.Split(',');

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();

        try
        {

            foreach (string testid in data)
           // for (int i = 0; i < data; i++)
            {
                DateTime SampleCollectionDateTime = DateTime.Now;
                
                int b = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_opd where `LedgerTransactionNo` = @LedgerTransactionNo ",
                   new MySqlParameter("@LedgerTransactionNo", _Invocereprint.LedgertransactionNo.Trim())));
                if (b == 0)
                {
                    tnx.Rollback();
                    err.Add("status", false);
                    err.Add("message", "LedgerTransactionNo Not Exists in LIS");
                    err.Add("data", "");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                int a = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_opd where `LedgerTransactionNo` <> @LedgerTransactionNo AND BarcodeNo=@BarcodeNo   ",
                   new MySqlParameter("@LedgerTransactionNo", _Invocereprint.LedgertransactionNo.Trim()),
                   new MySqlParameter("@BarcodeNo", _Invocereprint.BarcodeNO.Trim())));
                if (a > 0)
                {
                    tnx.Rollback();
                    err.Add("status", false);
                    err.Add("message", "Barcode Alresdy Exists.");
                    err.Add("data", "");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
				
                StringBuilder sb = new StringBuilder();
                sb.Append("UPDATE patient_labinvestigation_opd set IsSampleCollectedByPatient=@IsSampleCollectedByPatient,IsSampleCollected='S',SampleCollector=@SampleCollector,SampleCollectionBy=@SampleCollectionBy,SampleCollectionDate=@SampleCollectionDate,SampleTypeID=@SampleTypeID,SampleTypeName=@SampleTypeName,HistoCytoSampleDetail=@HistoCytoSampleDetail,BarcodeNo=@BarcodeNo,Barcode_Group=@Barcode_Group WHERE Test_ID=@Test_ID AND IsSampleCollected !='S' ");//,BarcodeNo=@BarcodeNo,Barcode_Group=@Barcode_Group
                int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@SampleCollector", _Invocereprint.PanelID),
                     new MySqlParameter("@BarcodeNo", _Invocereprint.BarcodeNO.Trim()), new MySqlParameter("@Barcode_Group", _Invocereprint.BarcodeNO.Trim()),
                     new MySqlParameter("@SampleCollectionBy", _Invocereprint.PanelID), new MySqlParameter("@Test_ID", testid),
                     new MySqlParameter("@SampleTypeID", _Invocereprint.SampleTypeID), new MySqlParameter("@SampleTypeName", _Invocereprint.SampleTypeName),
                     new MySqlParameter("@HistoCytoSampleDetail",""),
                     new MySqlParameter("@SampleCollectionDate", DateTime.Now),
                     new MySqlParameter("@IsSampleCollectedByPatient",0 ));
                sb = new StringBuilder();
               
                if (cnt > 0)
                {
                    sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                    sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Sample Collected (',ItemName,')'),@ID,@LoginName,IPAddress,@Centre, ");
                    sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@Test_ID");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@RoleID", "183"), new MySqlParameter("@ID", _Invocereprint.PanelID),
                        new MySqlParameter("@LoginName", _Invocereprint.PanelID), new MySqlParameter("@IPAddress", ""),
                        new MySqlParameter("@Centre", _Invocereprint.PanelID), new MySqlParameter("@Test_ID", testid));
                }
                if (Resources.Resource.SRARequired == "1")
                {
                    sb = new StringBuilder();
                    sb.Append("INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,`Status`,dtLogisticReceive,LogisticReceiveDate,LogisticReceiveBy,testID) ");
                    sb.Append(" values(@BarcodeNo,@BarcodeNo,@FromCentreID,@ToCentreID,@DispatchCode,@Qty,@EntryBy,@STATUS,@dtLogisticReceive,@LogisticReceiveDate,@LogisticReceiveBy,@Test_ID);");

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@BarcodeNo", _Invocereprint.BarcodeNO.Trim()),
                        new MySqlParameter("@FromCentreID", "1"), new MySqlParameter("@ToCentreID", "1"),
                        new MySqlParameter("@DispatchCode", ""), new MySqlParameter("@Qty", 1),
                        new MySqlParameter("@EntryBy", _Invocereprint.PanelID),
                        new MySqlParameter("@STATUS", "Received at Hub"), new MySqlParameter("@dtLogisticReceive", DateTime.Now),
                        new MySqlParameter("@LogisticReceiveDate", DateTime.Now), new MySqlParameter("@LogisticReceiveBy",_Invocereprint.PanelID),
                        new MySqlParameter("@Test_ID", testid));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                           new MySqlParameter("@LedgertransactionNo", _Invocereprint.LedgertransactionNo.Trim()),
                           new MySqlParameter("@SinNo", _Invocereprint.BarcodeNO.Trim()), new MySqlParameter("@Test_ID", testid),
                           new MySqlParameter("@Status", string.Format("SIN No. {0} {1}", _Invocereprint.BarcodeNO.Trim(), "Received at Hub")), new MySqlParameter("@UserID", _Invocereprint.PanelID), new MySqlParameter("@UserName", _Invocereprint.PanelID),
                           new MySqlParameter("@IpAddress", ""), new MySqlParameter("@CentreID", "1"), new MySqlParameter("@RoleID", "183"),
                           new MySqlParameter("@DispatchCode", string.Empty));

                }
               
            }
            tnx.Commit();

              

                    err.Add("status", true);
                    err.Add("message", "Record save Successfully");
                    err.Add("data", "");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);



        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [HttpPost]
    public HttpResponseMessage SearchInvestigation([FromBody]SearchSampleCollection _Invocereprint)
    {


        HttpError err = new HttpError();

        if (_Invocereprint == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_Invocereprint.BarcodeNO))
        {
            err.Add("status", false);
            err.Add("message", "BarcodeNO can't be blank");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        string dt = string.Concat(Util.GetDateTime(_Invocereprint.FromDate).ToString("yyyy-MM-dd"), ' ', "00:00:00");
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" SELECT  IFNULL(if(im.IsLMPRequired=0,(SELECT GROUP_CONCAT(CAST(fieldid AS CHAR)) FROM investigation_requiredfield WHERE investigationID=im.`Investigation_Id` and ShowOnSampleCollection=1),''),'') RequiredFields, ");
            sbQuery.Append("  im.reporttype, plo.SampleQty, plo.HistoCytoSampleDetail, im.reporttype reporttype1, plo.patient_id,plo.IsSampleCollectedByPatient,");
            sbQuery.Append(" plo.SampleCollector,date_format(SampleCollectionDate,'%d-%b-%Y %h:%i %p') colldate,plo.SampleReceiver,date_format(SampleReceiveDate,'%d-%b-%Y %h:%i %p') recdate, ");
            sbQuery.Append(" case when plo.IsSampleCollected='S' then  'bisque' when plo.IsSampleCollected='Y' then 'lightgreen'  when plo.IsSampleCollected='R' then 'pink' else 'white' end rowcolor, ");
            sbQuery.Append(" lt.PName,plo.Test_ID,plo.IsSampleCollected, im.name,plo.`SampleTypeID`,plo.`SampleTypeName`,plo.`BarcodeNo`,plo.`LedgerTransactionNo`,pnl.SampleRecollectAfterReject,im.SampleQty MasterSampleQty,im.SampleRemarks, ");
            sbQuery.Append(" IF(IFNULL(plo.SampleTypeID,0)=0,   ");
            sbQuery.Append(" IFNULL((SELECT CONCAT(ist.SampleTypeID ,'^',ist.SampleTypeName) FROM investigations_SampleType ist   ");
            sbQuery.Append("  WHERE ist.Investigation_Id =plo.Investigation_ID ORDER BY ist.isDefault DESC,ist.SampleTypeName LIMIT  1),'1|')  ");
            sbQuery.Append(" ,CONCAT(plo.`SampleTypeID`,'|',plo.`SampleTypeName`))  SampleID,    ");
            sbQuery.Append(" GROUP_CONCAT(DISTINCT CONCAT(inv_smpl.SampleTypeID,'|',inv_smpl.SampleTypeName)ORDER BY  inv_smpl.SampleTypeName SEPARATOR '$')SampleTypes,IFNULL(lt.Interface_companyName,'')Interface_companyName,    ");
          
                sbQuery.Append(" (SELECT IFNULL(color,'') FROM sampletype_master WHERE id=(SELECT SampleTypeId FROM investigations_SampleType WHERE Investigation_id=plo.`SampleTypeID` LIMIT 1))ColorCode ");
            sbQuery.Append(" ,lt.BarCodePrintedType, lt.setOfBarCode,lt.BarCodePrintedCentreType,lt.BarCodePrintedHomeColectionType FROM `patient_labinvestigation_opd` plo ");
            sbQuery.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgerTransactionID=plo.ledgerTransactionID    AND plo.reporttype <> 5 ");
            sbQuery.Append(" INNER JOIN f_panel_master pnl  ON lt.Panel_ID=pnl.Panel_ID ");
            sbQuery.Append(" INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` ");
            
            sbQuery.Append(" LEFT JOIN `investigations_SampleType` inv_smpl  ");
            sbQuery.Append(" ON inv_smpl.`Investigation_ID`=im.`Investigation_Id` ");

            sbQuery.Append(" WHERE plo.`barcodeno` = @sinNo");
            
            sbQuery.Append(" AND plo.IsReporting=1 AND plo.IsActive=1 ");
           
            sbQuery.Append("  GROUP BY plo.LedgerTransactionNo,plo.Investigation_ID order by plo.SampleTypeId  ");
            DataTable dtN = new DataTable();
            using (dtN = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
                   new MySqlParameter("@sinNo", _Invocereprint.BarcodeNO)).Tables[0])




                if (dtN.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dtN));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);

                }
                else
                {

                    err.Add("status", false);
                    err.Add("message", "No Record Found");
                    err.Add("data", "");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }



        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }

     [HttpPost]
    public HttpResponseMessage GetRegistration([FromBody]GetRegistration _GetRegistration)
    {
        HttpError err = new HttpError();


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT   em.Employee_ID,IFNULL(em.Title,'')Title,ifnull(em.house_no,'')Address,IFNULL(em.Name,'')Name,IFNULL(fl.UserName,'')UserName,IFNULL(fl.PASSWORD,'')PASSWORD,IFNULL(em.Mobile,'')Mobile,IFNULL(em.Designation,'')Designation,GROUP_CONCAT(DISTINCT rm.RoleName)RoleName, 
        IFNULL(em.AccessDepartment,'')AccessDepartment,GROUP_CONCAT(DISTINCT cm.centre)centre,  IFNULL(em.House_No,'')House_No,IFNULL(em.Street_Name,'')Street_Name,IFNULL(em.Locality,'')Locality,IFNULL(em.City,'')City,IFNULL(em.Pincode,'')Pincode,IFNULL(em.PHouse_No,'')PHouse_No
        ,IFNULL(em.PLocality,'')PLocality, IFNULL(em.DOB,'')DOB,IFNULL(em.Qualification,'')Qualification,IFNULL(em.BloodGroup,'')BloodGroup,IFNULL(em.FatherName,'')FatherName,IFNULL(em.MotherName,'')MotherName,IFNULL(em.ESI_No,'')ESI_No,IFNULL(em.EPF_No,'')EPF_No,IFNULL(em.PAN_No,'')PAN_No,IFNULL(em.PassportNo,'')PassportNo,IFNULL(em.Email,'')Email,IFNULL(em.StartDate,'')StartDate,IFNULL(em.AllowSharing,'')AllowSharing,IFNULL(em.empgroupid,'')empgroupid
        ,IFNULL(em.CreatedByID,'')CreatedByID,IFNULL(em.ApproveSpecialRate,'')ApproveSpecialRate, IFNULL(em.AmrValueAccess,'')AmrValueAccess,IFNULL(em.DesignationID,'')DesignationID,IFNULL(em.ValidateLogin,'')ValidateLogin,IFNULL(em.IsMobileAccess,'')IsMobileAccess,IFNULL(em.PROID,'')PROID,IFNULL(em.CreatedBy,'')CreatedBy
FROM employee_master em");
            sb.Append(" INNER JOIN f_login fl ON fl.EmployeeID=em.Employee_ID  INNER JOIN f_rolemaster rm ON rm.id=fl.RoleID   INNER JOIN centre_master cm ON cm.CentreID=fl.CentreID ");
            sb.Append(" where  Employee_ID=@EmployeeID GROUP  BY em.Name ");
            DataTable dt = new DataTable();
          dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              
             new MySqlParameter("@EmployeeID", _GetRegistration.EmployeeID)).Tables[0];
             
            if (dt.Rows.Count > 0)
            {
               
                err.Add("status", true);
                err.Add("message", "Success");
                err.Add("data", JArray.FromObject(dt));
               // err.Add("data",JsonConvert.SerializeObject(dt));
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            else
            {

                err.Add("status", false);
                err.Add("message", "No Record Found");
                err.Add("data", "[]");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }


        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "No Record Found");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [HttpPost]
    public HttpResponseMessage InvoicReprint([FromBody]InvoiceReprint _Invocereprint)
    {


        HttpError err = new HttpError();

        if (_Invocereprint == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        //if (string.IsNullOrWhiteSpace(_Invocereprint.SearchType))
        //{
        //    err.Add("status", false);
        //    err.Add("message", "SearchType can't be blank");
        //    err.Add("data", "[]");
        //    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        //}
        //if (string.IsNullOrWhiteSpace(_Invocereprint.LabNo))
        //{
        //    err.Add("status", false);
        //    err.Add("message", "LabNo can't be blank");
        //    err.Add("data", "[]");
        //    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        //}

        //if (string.IsNullOrWhiteSpace(_Invocereprint.User))
        //{
        //    err.Add("status", false);
        //    err.Add("message", "User can't be blank");
        //    err.Add("data", "[]");
        //    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        //}

        //if (string.IsNullOrWhiteSpace(_Invocereprint.ToTime))
        //{
        //    err.Add("status", false);
        //    err.Add("message", "password can't be blank");
        //    err.Add("data", "[]");
        //    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        //}

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("");
            sb.Append("SELECT IFNULL((SELECT COUNT(*) FROM document_detail WHERE Labno=lt.Ledgertransactionno AND isactive=1),0) DocAttach, CONCAT('http://itd-saas.cl-srv.ondgni.com/uat_ver1/Design/Lab/SampleTracking.aspx?IsAPI=1&LabNo','=',lt.LedgerTransactionNo) ViewUrl,  CONCAT('http://itd-saas.cl-srv.ondgni.com/uat_ver1/Design/Lab/PatientReceiptNew1.aspx?IsAPI=1&LabID','=',lt.LedgerTransactionID) CashReceipUrl,lt.LedgerTransactionID ,DATE_FORMAT(lt.`Date`,'%d-%b-%Y %h:%i %p') EntryDate,DATE_FORMAT(lt.`Date`,'%d-%b-%Y')RegDate ,");
            sb.Append(" lt.`LedgerTransactionNo` LabNo,CONCAT(pm.`Title`,pm.`PName`) PName,CONCAT(pm.`Age`,'/',LEFT(pm.`Gender`,1)) Pinfo,");
            sb.Append(" pm.`Mobile`,lt.`DoctorName` DoctorName,lt.`PanelName`,lt.IsOPDConsultation,");
            sb.Append(" (SELECT centre FROM centre_master WHERE centreID=lt.centreid)CentreName,");
            sb.Append(" lt.CreatedBy UserName,lt.`GrossAmount`,lt.`DiscountOnTotal`,lt.`NetAmount`,lt.`Adjustment`,");
            sb.Append("  GROUP_CONCAT(REPLACE(inv.Name,',',' ')) AS ItemName,        ");
            sb.Append("  GROUP_CONCAT(IF(plo.Result_Flag=1 AND plo.Approved=0 ,'Y','N'))Result_Flag,   ");
            sb.Append("  GROUP_CONCAT(IF(plo.Approved=1 AND plo.isPrint=0,'Y','N'))Approved, ");
            sb.Append("  GROUP_CONCAT(IF(plo.isPrint=1 AND plo.Approved=1 ,'Y','N'))ReportPrint,CASE WHEN GROUP_CONCAT(DISTINCT plo.BarcodeNo SEPARATOR ',<br/>') !='undefined' THEN GROUP_CONCAT(DISTINCT plo.BarcodeNo SEPARATOR ',<br/>') ELSE '' END BarcodeNo,");
            sb.Append("  CASE    ");
           
           
                sb.Append(" WHEN  (SELECT SUM(Amount) FROM patient_labinvestigation_opd WHERE  LedgerTransactionID = plo.`LedgerTransactionID`)=0 and plo.isactive=0 THEN '#6699ff'  ");
                sb.Append(" WHEN (lt.NetAmount-lt.Adjustment)=0  AND lt.iscredit=0 THEN '#00FA9A'  ");
                sb.Append(" WHEN (lt.iscredit =1) THEN '#F0FFF0'  ");
                sb.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment>0 AND lt.iscredit=0 THEN '#F6A9D1'  ");
                // sb.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment=0 AND lt.iscredit=0 THEN '#DDA0DD' ");
                sb.Append(" WHEN  (lt.NetAmount-lt.Adjustment)>0 AND lt.Adjustment=0 AND lt.iscredit=0 THEN '#FF457C' ");
            

            sb.Append(" ELSE '#F6A9D1'  END  rowColor,lt.Iscredit");
            sb.Append(" ,lt.IsDiscountApproved,lt.DiscountApprovedByID,IFNULL(lt.DiscountApprovedByName,'') DiscountApprovedByName,IFNULL(fpm.ReceiptType,'')ReceiptType   ");
            sb.Append(" ,(SELECT SUM(Amount) FROM patient_labinvestigation_opd WHERE  LedgerTransactionID = plo.`LedgerTransactionID`) Amount,(lt.NetAmount-lt.Adjustment)Due ");
            sb.Append(" FROM `f_ledgertransaction` lt ");
            sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID`  AND plo.IsActive=1");//AND plo.IsActive=1
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`");
            sb.Append(" left JOIN investigation_master inv ON inv.investigation_id = plo.investigation_id");

            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID = lt.Panel_ID");
           
            
                sb.Append(" and fpm.Invoiceto =(select Panel_ID from f_panel_master where Employee_ID=@PanelID)");
            
          
           


           
           

            sb.Append(" GROUP BY lt.LedgerTransactionNo order by lt.date desc");

            DataTable dtN = new DataTable();


            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Employee_ID", Util.GetString(_Invocereprint.User)),
                    new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(_Invocereprint.FromDate).ToString("yyyy-MM-dd"), " ", _Invocereprint.FromTime)),
                    new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(_Invocereprint.ToDate).ToString("yyyy-MM-dd"), " ", _Invocereprint.ToTime)),
                    new MySqlParameter("@Centre", _Invocereprint.Centre),
                    new MySqlParameter("@PanelID", _Invocereprint.PanelID),
                    //new MySqlParameter("@LoginUser", UserInfo.ID),
                    new MySqlParameter("@LabNo", Util.GetString(_Invocereprint.LabNo)),
                    new MySqlParameter("@SearchType", Util.GetString(_Invocereprint.SearchValue)),
                    new MySqlParameter("@PName", string.Concat("%", Util.GetString(_Invocereprint.LabNo), "%"))).Tables[0])
            //
            {
                //  if (PageNo == "0")
                // {
                if (dt.Rows.Count > 0)
                // {

                    // dt.Columns.Add("URL_");
                   // // dt.Columns.Add("LabNo");
                    // foreach (DataRow dw in dt.Rows)
                    // {
                        // dw["URL_"] = dw["URL"] + Common.Encrypt(Util.GetString(dw["LabNo"])); ;
                       // // dw["LabNo"] = Common.Encrypt(Util.GetString(dw["LabNo"]));
                   // }
                // //    dt.AcceptChanges();
                // //    //dtN = dt.AsEnumerable().Skip(0).Take(Util.GetInt(PageSize)).CopyToDataTable();
                // //}
                // }
                if (dt.Rows.Count > 0)
                {

                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);

                }
                else
                {

                    err.Add("status", false);
                    err.Add("message", "No Record Found");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }

            }
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);

        }
        catch (Exception ex)
        {
            ClassLog CL = new ClassLog();
            CL.errLog(ex);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [HttpGet]
    [ActionName("GetPageData")]
    public HttpResponseMessage GetPageData()
    {
         MySqlConnection con=Util.GetMySqlCon();
            con.Open();
            HttpError err = new HttpError();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Color,WelcomeContent as WelcomePageContent,IFNULL(WelcomeText,'')WelcomeText,Concat('" + url + "/Design/B2CMobile/Images/','',if(Logo='','default.jpg',Logo))Logo,'ITDOSE INFO SYSTEMS PVT LTD' HeaderText,IsShowPoweredBy,IFNULL(HelpLineNo24x7,'')HelpLineNo24x7 from App_B2B_Setting Limit 1 ").Tables[0])
            {
                err.Add("status", true);
                err.Add("message", "Success");
                err.Add("data", JArray.FromObject(dt));
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("status", false);
            err.Add("message", "No Record Found");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [HttpPost]
    [ActionName("ForgotPassword")]
    public HttpResponseMessage ForgotPassword([FromBody]ForgotPassword _forgotpassword)
    {
        HttpError err = new HttpError();
        string EmpId = "";
        //if (_forgotpassword == null)
        //{
        //    err.Add("status", false);
        //    err.Add("message", "Invalid JSON Format");
        //    err.Add("data", "[]");
        //    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        //}
        if (string.IsNullOrWhiteSpace(_forgotpassword.Mobile))
        {
            err.Add("status", false);
            err.Add("message", "Mobile can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
       
       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            EmpId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text,
                    "SELECT f.`EmployeeID` FROM `f_login` f JOIN `employee_master` e ON f.`EmployeeID`=e.`Employee_ID` WHERe  e.`IsActive`=@IsActive AND  mobile=@Mobile LIMIT 1;",
                     new MySqlParameter("@IsActive", "1"),
                new MySqlParameter("@Mobile", _forgotpassword.Mobile)
                ));
            if (EmpId == "")
            {
                err.Add("status", false);
                err.Add("message", "Invalid Username/Mobile");
                err.Add("data", "[]");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            //else
            //{
                int limit = 0;
                if (limit == 3)
                {
                    err.Add("status", false);
                    err.Add("message", "Get Otp request exceeded.You can request only 3 times a day");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);

                }
                else
                {
                    //if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(*) FROM forget_password WHERE dtEntry>=CURRENT_DATE() AND employee_ID=@Employee_Id and UserType=@UserType", new MySqlParameter("@Employee_Id", EmpId), new MySqlParameter("@UserType", "Employee"))) < 3)
                    //{
                        string mobileOtp = Util.getOTP;
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                            "INSERT INTO `forget_password`(`code`,`Employee_Id`,`dtEntry`,UserType) VALUES(@code,@Employee_Id,@dtEntry,@UserType)",
                            new MySqlParameter("@code", mobileOtp),
                            new MySqlParameter("@Employee_Id", EmpId),
                            new MySqlParameter("@dtEntry", DateTime.Now),
                            new MySqlParameter("@UserType", "Employee"));

                        string OTPText = "Your OTP is: " + mobileOtp;
                        if (_forgotpassword.Mobile != string.Empty)
                        {
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text,
                            "INSERT INTO `sms`(`MOBILE_NO`,`SMS_TEXT`,`IsSend`,UserID,SMS_Type) VALUES(@MOBILE,@OTPText,@IsSend,@Employee_Id,@SMSType)",
                            new MySqlParameter("@MOBILE", _forgotpassword.Mobile),
                            new MySqlParameter("@OTPText", OTPText),
                            new MySqlParameter("@IsSend", 0),
                            new MySqlParameter("@Employee_Id", EmpId),
                            new MySqlParameter("@SMSType", "OTP"));

                            err.Add("status", true);
                            err.Add("message", "OTP sent");
                            err.Add("data", mobileOtp);
                        }
                   // }
                    //else
                    //{
                    //    err.Add("status", false);
                    //    err.Add("message", "OTP can be sent for maximum 2 times in a day. Please contact Administrator.");
                    //    err.Add("data", "[]");
                    //    return Request.CreateErrorResponse((HttpStatusCode.OK,, err);
                    //}

                    tnx.Commit();
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }

                   
                   
                

            }
            
        
        catch (Exception ex)
        {
            tnx.Rollback();
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
          
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [HttpPost]
    [ActionName("VerifyOtp")]
    public HttpResponseMessage VerifyOtp([FromBody]ForgotPassword _forgotpassword)
    {
        HttpError err = new HttpError();
        string EmpId = "";
       
        if (string.IsNullOrWhiteSpace(_forgotpassword.Mobile))
        {
            err.Add("status", false);
            err.Add("message", "Mobile can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_forgotpassword.OTP))
        {
            err.Add("status", false);
            err.Add("message", "otp can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            EmpId = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text,
                    "SELECT f.`EmployeeID` FROM `f_login` f JOIN `employee_master` e ON f.`EmployeeID`=e.`Employee_ID` WHERe  e.`IsActive`=@IsActive AND  mobile=@Mobile LIMIT 1;",
                     new MySqlParameter("@IsActive", "1"),
                new MySqlParameter("@Mobile", _forgotpassword.Mobile)
                ));
            if (EmpId == "")
            {
                err.Add("status", false);
                err.Add("message", "Invalid Username/Mobile");
                err.Add("data", "[]");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            string OTP = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text,
                    "SELECT Code FROM forget_password WHERE dtEntry>=CURRENT_DATE() AND employee_ID=@Employee_Id and UserType=@UserType ORDER BY dtentry DESC LIMIT 1",
                     new MySqlParameter("@Employee_Id", EmpId),
                new MySqlParameter("@UserType", "Employee")
                ));
            if (OTP == "")
            {
                err.Add("status", false);
                err.Add("message", "Invalid Username/Mobile");
                err.Add("data", "[]");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            if (OTP != _forgotpassword.OTP)
            {
                err.Add("status", false);
                err.Add("message", "Invalid Otp");
                err.Add("data", "[]");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            else
            {
                err.Add("status", true);
                err.Add("message", "Empid");
                err.Add("data", EmpId);
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);

            }
            
            

                tnx.Commit();
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            




        }


        catch (Exception ex)
        {
            tnx.Rollback();
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {

            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [HttpGet]
    public HttpResponseMessage GetDashBoardDetails(string EmployeeID)
    {
        HttpError err = new HttpError();
        if (string.IsNullOrWhiteSpace(EmployeeID))
        {
            err.Add("status", false);
            err.Add("message", "EmployeeID can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        DataTable dt = new DataTable();
        dt.Columns.Add("title",typeof(string));
        dt.Columns.Add("value",typeof(int));
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT COUNT(lt.LedgertransactionID) PatientCount");
            sb.Append(" FROM `f_ledgertransaction` lt ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` ");
            sb.Append(" AND lt.`Date`>=@fromdate AND lt.`Date`<=@todate ");
            sb.Append(" AND pm.`Employee_ID`=@Employee_ID  ");
            int ptcount =Util.GetInt( MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@fromdate", string.Concat(DateTime.Now.ToString("yyyy-MM-dd"), " 00:00:00")),
                    new MySqlParameter("@todate", string.Concat(DateTime.Now.ToString("yyyy-MM-dd"), " 23:59:59")),
                    new MySqlParameter("@Employee_ID", EmployeeID)));
            if (ptcount > 0)
            {
                dt.Rows.Add("PatientCount", ptcount);
            }
            //--------------------------- for NetAmount--------------------------
             sb = new StringBuilder();
            sb.Append(" SELECT Round(IFNULL(SUM(plo.Amount),0)) NetAmount ");
            sb.Append(" FROM `f_ledgertransaction` lt ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo on plo.LedgertransactionID=lt.LedgertransactionID ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` ");
            sb.Append(" AND plo.`Date`>=@fromdate AND plo.`Date`<=@todate ");
            sb.Append(" AND pm.`Employee_ID`=@Employee_ID  ");
            int NetAmount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@fromdate", string.Concat(DateTime.Now.ToString("yyyy-MM-dd"), " 00:00:00")),
                    new MySqlParameter("@todate", string.Concat(DateTime.Now.ToString("yyyy-MM-dd"), " 23:59:59")),
                    new MySqlParameter("@Employee_ID", EmployeeID)));
            if (NetAmount > 0)
            {
                dt.Rows.Add("NetAmount", NetAmount);
            }
                //--------------------------- for Monthly Count--------------------------
                sb = new StringBuilder();
                sb.Append("SELECT COUNT(lt.LedgertransactionID) MonthlyPatientCount");
                sb.Append(" FROM `f_ledgertransaction` lt");
                sb.Append(" INNER JOIN patient_labinvestigation_opd plo on plo.LedgertransactionID=lt.LedgertransactionID ");
                sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.`Employee_ID`=@Employee_ID");
                sb.Append(" WHERE MONTH(lt.`Date`) = MONTH(CURRENT_DATE()) ");
                sb.Append(" AND YEAR(lt.`Date`) = YEAR(CURRENT_DATE())");
                int MonthlyPatientCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Employee_ID", EmployeeID)));
                if (MonthlyPatientCount > 0)
                {
                    dt.Rows.Add("MonthlyPatientCount", MonthlyPatientCount);
                }

                //--------------------------- for Monthly Count--------------------------
                sb = new StringBuilder();
                sb.Append("SELECT Round(IFNULL(SUM(plo.Amount),0))  MonthlyNetAmount");
                sb.Append(" FROM `f_ledgertransaction` lt");
                sb.Append(" INNER JOIN patient_labinvestigation_opd plo on plo.LedgertransactionID=lt.LedgertransactionID ");
                sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.`Employee_ID`=@Employee_ID");
                sb.Append(" WHERE MONTH(lt.`Date`) = MONTH(CURRENT_DATE()) ");
                sb.Append(" AND YEAR(lt.`Date`) = YEAR(CURRENT_DATE())");
                int MonthlyNetAmount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Employee_ID", EmployeeID)));
                if (MonthlyNetAmount > 0)
                {
                    dt.Rows.Add("MonthlyNetAmount", MonthlyNetAmount);
                }
                //---------------------------- end for monthly count--------------------

                string InvoiceTo = "";
                InvoiceTo =Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT InvoiceTo FROM f_panel_master WHERE Employee_ID = @Employee_ID ",
                    new MySqlParameter("@Employee_ID", EmployeeID)));
                sb = new StringBuilder();
                if (InvoiceTo != string.Empty)
                {
                    sb.Append(" SELECT IFNULL(AvailAmt,0) AvailAmt FROM  ");
                    sb.Append(" (SELECT FPM.`Company_Name`,fpm.`SecurityDeposit`,IFNULL(imo.PaidAmount,0)PaidAmount, ");
                    sb.Append(" ROUND((IFNULL(imo.PaidAmount,0))-IFNULL(BillingAmount,0))AvailAmt  ");
                    sb.Append(" FROM f_panel_master fpm  ");
                    sb.Append(" LEFT JOIN(SELECT SUM(plo.Amount) BillingAmount,SUM(lt.`Adjustment`) PaidAmount1,pm1.InvoiceTo   ");
                    sb.Append(" FROM f_ledgertransaction lt  ");
                    sb.Append(" INNER JOIN patient_labinvestigation_opd plo on plo.LedgertransactionID=lt.LedgertransactionID ");
                    sb.Append(" INNER JOIN f_panel_master  pm1 ON pm1.panel_id=lt.panel_id WHERE pm1.InvoiceTo =@InvoiceTo  ");
                    sb.Append(" GROUP BY pm1.InvoiceTo) lt  ON lt.InvoiceTo=fpm.Panel_ID ");
                    sb.Append(" LEFT JOIN (  ");
                    sb.Append(" SELECT SUM(ino.ReceivedAmt) PaidAmount,ino.Panel_ID FROM invoicemaster_onaccount ino WHERE Panel_Id  =@InvoiceTo ");
                    sb.Append(" AND IFNULL(InvoiceNo,'')='' GROUP BY ino.Panel_ID) imo ON imo.Panel_ID=fpm.Panel_ID ");
                    sb.Append(" WHERE  fpm.Panel_Id  =@InvoiceTo) t  ");


                     int AvailAmtount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@InvoiceTo", InvoiceTo)));
                     if (AvailAmtount > 0)
                     {
                         dt.Rows.Add("AvailAmtount", AvailAmtount);
                     }

                }
                if (dt.Rows.Count == 0)
                {
                    err.Add("status", false);
                    err.Add("message", "No Data Found");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {
                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", JArray.FromObject(dt));
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
            
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [HttpPost]
    public HttpResponseMessage validateOTP([FromBody] ForgotPassword _forgotpassword)
    {
        HttpError err = new HttpError();
        if (_forgotpassword == null)
        {
            err.Add("status", false);
            err.Add("message", "Invalid JSON Format");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_forgotpassword.Mobile))
        {
            err.Add("status", false);
            err.Add("message", "Mobile can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(_forgotpassword.UserName))
        {
            err.Add("status", false);
            err.Add("message", "UserName can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

        string UserType = "Employee";
        string EmployeeId = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
              
            if (UserType.Trim() == "Employee")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT f.`code` FROM `forget_password` f");
                sb.Append(" JOIN (SELECT f.`EmployeeID` FROM `f_login` f JOIN `employee_master` e ON f.`EmployeeID`=e.`Employee_ID` WHERE  f.`UserName`=@UserName And (e.`Mobile`=@Mobile or e.Email=@Email) LIMIT 1)t");
                sb.Append(" ON t.EmployeeID=f.`Employee_Id`");
                sb.Append(" WHERE `code`=@code And UserType=@UserType AND `Employee_Id`=t.EmployeeID AND f.`isUsed`='0' AND date(`dtEntry`)=current_Date()");
                string otpupdate = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text,
                    sb.ToString(),
                    new MySqlParameter("@Mobile", _forgotpassword.Mobile),
                     new MySqlParameter("@Email", _forgotpassword.Email),
                    new MySqlParameter("@UserName", _forgotpassword.UserName),
                    new MySqlParameter("@code", _forgotpassword.OTP),
                    new MySqlParameter("@UserType", UserType.Trim())));
                if (otpupdate == "")
                {
                    err.Add("status", false);
                    err.Add("message", "Incorrect Informations");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE forget_password f ");
                    sb.Append(" INNER JOIN f_login fl ON f.`Employee_Id`=fl.`EmployeeID`");
                    sb.Append(" INNER JOIN employee_master em ON em.`Employee_ID`=fl.`EmployeeID` ");
                    sb.Append(" AND f.`code`=@code AND fl.`UserName`=@UserName AND (em.`Mobile`=@Mobile or em.Email=@Email) AND f.`isUsed`=0 And UserType=@UserType ");
                    sb.Append(" SET f.`isUsed`=@isUsed,`dtUsed`=@dtUsed ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text,
                    sb.ToString(),
                    new MySqlParameter("@Mobile", _forgotpassword.Mobile),
                     new MySqlParameter("@Email", _forgotpassword.Email),
                    new MySqlParameter("@UserType", UserType.Trim()),
                    new MySqlParameter("@UserName", _forgotpassword.UserName),
                    new MySqlParameter("@code", _forgotpassword.OTP),
                    new MySqlParameter("@isUsed", "1"),
                    new MySqlParameter("@dtUsed", DateTime.Now));
                    EmployeeId = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text,
                        "SELECT f.`EmployeeID` FROM `f_login` f JOIN `employee_master` e ON f.`EmployeeID`=e.`Employee_ID` WHERE (e.`Mobile`=@Mobile or e.`Email`=@EmailID)  AND f.`UserName`=@UserName LIMIT 1",
                        new MySqlParameter("@Mobile", _forgotpassword.Mobile),
                        new MySqlParameter("@EmailID", _forgotpassword.Email),
                        new MySqlParameter("@UserName", _forgotpassword.UserName)));
                   
                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", EmployeeId);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
            }
            else if (UserType.Trim() == "PUP")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT f.`code` FROM `forget_password` f");
                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=f.`Employee_Id` And PanelUserID=@PanelUserID AND (fpm.`Mobile`=@Mobile OR fpm.`EmailID`=@EmailID) ");
                sb.Append(" WHERE `code`=@code AND UserType=@UserType AND f.`isUsed`='0' AND DATE(`dtEntry`)=CURRENT_DATE() ");

                string otpupdate1 = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text,
                    sb.ToString(),
                    new MySqlParameter("@PanelUserID", _forgotpassword.UserName),
                    new MySqlParameter("@Mobile", _forgotpassword.Mobile),
                    new MySqlParameter("@EmailID", _forgotpassword.Email),
                    new MySqlParameter("@code", _forgotpassword.OTP),
                    new MySqlParameter("@UserType", UserType.Trim())));
                if (otpupdate1 == "")
                {
                    err.Add("status", false);
                    err.Add("message", "Incorrect Informations");
                    err.Add("data", "[]");
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE forget_password f ");
                    sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=f.`Employee_Id` And PanelUserID=@PanelUserID AND (fpm.`Mobile`=@Mobile OR fpm.`EmailID`=@EmailID) ");
                    sb.Append(" AND f.`code`=@code AND f.`isUsed`=0 And UserType=@UserType ");
                    sb.Append(" SET f.`isUsed`=@isUsed,`dtUsed`=@dtUsed ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text,
                    sb.ToString(),
                    new MySqlParameter("@PanelUserID", _forgotpassword.UserName),
                    new MySqlParameter("@Mobile", _forgotpassword.Mobile),
                    new MySqlParameter("@EmailID", _forgotpassword.Email),
                    new MySqlParameter("@UserType", UserType.Trim()),
                    new MySqlParameter("@code", _forgotpassword.OTP),
                    new MySqlParameter("@isUsed", "1"),
                    new MySqlParameter("@dtUsed", DateTime.Now));
                    EmployeeId = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text,
                        "SELECT Panel_ID FROM f_panel_master WHERE  PanelType=@PanelType AND IsActive=@IsActive AND PanelUserID=@PanelUserID AND (mobile=@mobile OR EmailID=@EmailID)",
                        new MySqlParameter("@PanelType", "PUP"),
                        new MySqlParameter("@IsActive", "1"),
                        new MySqlParameter("@PanelUserID", _forgotpassword.UserName),
                        new MySqlParameter("@mobile", _forgotpassword.Mobile),
                        new MySqlParameter("@EmailID", _forgotpassword.Email)));
                   
                    err.Add("status", true);
                    err.Add("message", "Success");
                    err.Add("data", EmployeeId);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
            }
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
           con.Close();
            con.Dispose();
        }
       
    }
    [HttpPost]
    public HttpResponseMessage ResetPassword([FromBody] Savenewpassword _forgotpassword)
   
    {
        HttpError err = new HttpError();
		string Password= _forgotpassword.Password;
		string Employeeid= _forgotpassword.Employeeid;
        if (string.IsNullOrWhiteSpace(Password))
        {
            err.Add("status", false);
            err.Add("message", "Password can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(Employeeid))
        {
            err.Add("status", false);
            err.Add("message", "Employeeid can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string UserType = "Employee";
            if (UserType.Trim() == "Employee")
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text,
                    "UPDATE `f_login` SET PASSWORD=@password,InvalidPassword=0 WHERE `EmployeeID`=@Employee_Id",
                    new MySqlParameter("@password", Password),
                    new MySqlParameter("@Employee_Id", Employeeid));
               
                err.Add("status", true);
                err.Add("message", "Password successfully updated");
                err.Add("data", "[]");
            }
            else if (UserType.Trim() == "PUP")
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text,
                    " Update f_panel_master set PanelPassword=@PanelPassword where Panel_ID=@Panel_ID and IsActive=@IsActive And PanelType=@PanelType ",
                    new MySqlParameter("@PanelPassword", Password.Trim()),
                    new MySqlParameter("@Panel_ID", Employeeid),
                    new MySqlParameter("@IsActive", "1"),
                    new MySqlParameter("@PanelType", "PUP"));
                err.Add("status", true);
                err.Add("message", "Password successfully updated");
                err.Add("data", "[]");
            }
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [HttpPost]
    [ActionName("EmployeeUpdate")]
    public object EmployeeUpdate(JObject patientupdate)
    {
        try
        {
            HttpError err = new HttpError();
            OrderResponseJArray res = new OrderResponseJArray();
            res.success = "false";
            string PatientID = "";
            PatientUpdate PatientUpdate = JsonConvert.DeserializeObject<PatientUpdate>(patientupdate.ToString());
            if (PatientUpdate == null)
            {
                string message = "{\"success\": false,\"message\":\"Invalid JSON Format\",\"data\":[]}";
                return JsonConvert.DeserializeObject(message);
            }

            if (string.IsNullOrWhiteSpace(PatientUpdate.Address))
            {
                string message = "{\"success\": false,\"message\":\"Address can't be blank\",\"data\":[]}";
                return JsonConvert.DeserializeObject(message);
            }
            if (string.IsNullOrWhiteSpace(PatientUpdate.EmpID))
            {
                string message = "{\"success\": false,\"message\":\"EmployeeId can't be blank\",\"data\":[]}";
                return JsonConvert.DeserializeObject(message);
            }
            if (Util.GetDateTime(PatientUpdate.DateOfBirth).ToString("dd/MM/yyyy") == "01/01/0001" && PatientUpdate.DateOfBirth == "")
            {

                string message = "{\"success\": false,\"message\":\"Wrong DOB Format\",\"data\":[]}";
                return JsonConvert.DeserializeObject(message);
            }
            string dob = Util.GetDateTime(PatientUpdate.DateOfBirth).ToString("yyyy-MM-dd");

           // string TotalAge = FormatAge(Util.GetDateTime(PatientUpdate.DateOfBirth), DateTime.Now);

            if (string.IsNullOrWhiteSpace(PatientUpdate.Title))
            {
                string message = "{\"success\": false,\"message\":\"Title can't be blank\",\"data\":[]}";
                return JsonConvert.DeserializeObject(message);
            }
           
            string title = PatientUpdate.Title;
            if (string.IsNullOrWhiteSpace(PatientUpdate.PName))
            {
                string message = "{\"success\": false,\"message\":\"Pname can't be blank\",\"data\":[]}";
                return JsonConvert.DeserializeObject(message);
            }
            if (string.IsNullOrWhiteSpace(PatientUpdate.Mobile))
            {
                string message = "{\"success\": false,\"message\":\"Mobile can't be blank\",\"data\":[]}";
                return JsonConvert.DeserializeObject(message);
            }
            
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            //  MySqlConnection con = Util.GetMySqlCon();
            try
            {

//                int centremaster = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(1) from mahajan_live.centre_master where centreid=@centreid",
//new MySqlParameter("@centreid", PatientUpdate.CentreID)));
//                if (centremaster == 0)
//                {
//                    err.Add("status", false);
//                    err.Add("data", "CentreID  " + PatientUpdate.CentreID + " does not exists in LIS.");
//                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);

//                }
//                int Patient_id = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(1) from mahajan_live.patient_master where Patient_id=@Patient_id",
//new MySqlParameter("@Patient_id", PatientUpdate.PatientID)));
//                if (Patient_id > 0)
//                {
//                    err.Add("status", false);
//                    err.Add("data", "PatientID  " + PatientUpdate.CentreID + " does not exists in LIS.");
//                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);

//                }
                string DocumentName = "";
                if (PatientUpdate.DocumentName == "PassportNo")
                {
                     DocumentName = PatientUpdate.DocumentNo;
                }

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE employee_master SET Title=@Title,Name=@PName,House_No=@House_No,City=@City,Pincode=@Pincode ,Mobile=@Mobile,DOB=@DOB,BloodGroup=@BloodGroup,Qualification=@Qualification,PAN_No=@PAN_No,PassportNo=@PassportNo WHERE employee_id=@employee_id",

 new MySqlParameter("@employee_id", PatientUpdate.EmpID),

 new MySqlParameter("@Title", title),
  new MySqlParameter("@PName", PatientUpdate.PName),
 new MySqlParameter("@House_No", PatientUpdate.Address),
 new MySqlParameter("@City", PatientUpdate.City),
 new MySqlParameter("@Pincode", PatientUpdate.Pincode),
 new MySqlParameter("@Mobile", PatientUpdate.Mobile),
 new MySqlParameter("@DOB", dob),

 new MySqlParameter("@BloodGroup", PatientUpdate.Bloodgroup),
 new MySqlParameter("@Qualification", PatientUpdate.Qualification),
 new MySqlParameter("@PAN_No", PatientUpdate.DocumentName),
 new MySqlParameter("@PassportNo", DocumentName));
                tnx.Commit();

              

                
               
                    string message = "{\"success\": true,\"message\":\"Update Successfully\",\"data\":[]}";
                    return JsonConvert.DeserializeObject(message);
                
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                string message = "{\"success\": false,\"message\":\"Error\",\"data\":[]}";
                return JsonConvert.DeserializeObject(message);
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            string message = "{\"success\": false,\"message\":\"Error\",\"data\":[]}";
            return JsonConvert.DeserializeObject(message);
        }

    }
    [HttpGet]
    public HttpResponseMessage GetBanner()
    {
        HttpError err = new HttpError();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string str1 = "";
            str1 = "SELECT ID,CONCAT('" + url + "/Design/B2BMobile/Images/','',if(Image='','default.jpg',Image))Images FROM App_B2B_Banner where IsActive=1 order by ShowOrder ";
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str1).Tables[0];
            if (dt.Rows.Count == 0)
            {
                err.Add("status", false);
                err.Add("message", "failure");
                err.Add("data", "[]");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            else
            {
                err.Add("status", true);
                err.Add("message", "exists");
                err.Add("data", JArray.FromObject(dt));
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [HttpGet]
    public HttpResponseMessage BindTabs()
    {
        HttpError err = new HttpError();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select ID,Title,ordering from app_b2B_tab where isactive=1 ORDER BY ordering").Tables[0];
            if (dt.Rows.Count == 0)
            {
                err.Add("status", false);
                err.Add("message", "failure");
                err.Add("data", "[]");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            else
            {
                err.Add("status", true);
                err.Add("message", "exists");
                err.Add("data", JArray.FromObject(dt));
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
        }
        catch (Exception ex)
        {
            err.Add("status", false);
            err.Add("message", "Error Occured. Please contact Administrator.");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    //-----------Added By Apurva-----------
    [HttpPost]
    [ActionName("GetPanel")]
    public HttpResponseMessage GetPanel([FromBody]B2BPatientRegistration _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.EmployeeId))
            {
                err.Add("message", "EmployeeId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }



            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" SELECT DISTINCT Concat(Panel_Code,' = ',Company_Name) Company_Name,Concat(Panel_Code,' = ',Company_Name)  as Name,fpm.Panel_ID,Panel_Code, fpm.CentreId Centre_ID,IFNULL(emp.IsHideRate,0)IsShowMRP,IFNULL(fpm.HideReceiptRate,0)IsShowNetAmount FROM f_panel_master fpm ");
                        sb.Append(" LEFT JOIN  Employee_master emp ON emp.Employee_Id=fpm.`Employee_id`");
                        sb.Append(" WHERE fpm.`Employee_id`=@EmployeeId and fpm.IsActive=1 order by fpm.`Company_Name` ; ");

                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@EmployeeId", Util.GetString(_data.EmployeeId))
                            ).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data", JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }




            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }


    [HttpPost]
    [ActionName("GetCenter")]
    public HttpResponseMessage GetCenter([FromBody]B2BPatientRegistration _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {

            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        StringBuilder sb = new StringBuilder();

                        if (string.IsNullOrWhiteSpace(_data.Id))
                        {
                            sb.AppendLine(@" SELECT cm.CentreID,cm.Centre AS NAME,cm.Mobile,cm.Email,cm.Address, IF(fpm.BarcodePrintedCentreType='0','PatientWise','SampleTypeWise') AS BarcodeType FROM  centre_master cm
                             INNER JOIN f_panel_master fpm ON cm.CentreId=fpm.CentreId   WHERE cm.IsActive=1 order by cm.Centre;  ");
                        }
                        else
                        {
                            if (_data.Id.Contains("LSHHI"))
                            {
                                sb.AppendLine(@" SELECT cm.CentreID,cm.Centre AS NAME,cm.Mobile,cm.Email,cm.Address, IF(fpm.BarcodePrintedCentreType='0','PatientWise','SampleTypeWise') AS BarcodeType 
                                     FROM  `centre_master` cm INNER JOIN f_login fl ON fl.CentreID=cm.`CentreID` 
                                    INNER JOIN f_panel_master fpm ON cm.CentreId=fpm.CentreId  
                                    WHERE cm.IsActive=1 ");
                                sb.AppendLine(" AND fl.`EmployeeID`= @Id  GROUP BY cm.`CentreID`;");
                            }
                            else
                            {
                                sb.AppendLine(@" SELECT cm.CentreID,cm.Centre AS NAME,cm.Mobile,cm.Email,cm.Address, IF(fpm.BarcodePrintedCentreType='0','PatientWise','SampleTypeWise') AS BarcodeType FROM  centre_master cm
                             INNER JOIN f_panel_master fpm ON cm.CentreId=fpm.CentreId   WHERE cm.IsActive=1 AND cm.CentreID= @Id order by cm.Centre;  ");
                               // sb.AppendLine(" SELECT CentreID,Centre AS NAME,Mobile,Email,Address,IF(BarcodeType='0','PatientWise','SampleTypeWise') AS BarcodeType FROM  `centre_master` WHERE IsActive=1 AND CentreID= @Id ");
                            }
                        }


                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@Id", Util.GetString(_data.Id))
                            ).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data",JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }




            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }


    [HttpPost]
    [ActionName("GetDoctor")]
    public HttpResponseMessage GetDoctor([FromBody]B2BPatientRegistration _data)
    {
        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        StringBuilder sb = new StringBuilder();

                        sb.Append("SELECT DISTINCT  Doctor_ID,NAME FROM doctor_master WHERE IsActive = 1  ");
                        sb.Append(" UNION ALL ");
                        sb.Append("SELECT 'Other Doctor' as NAME, 0  as Employee_ID ORDER BY NAME ");

                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data",JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);
                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }
            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }
    [HttpPost]
    [ActionName("B2BWelcome")]
    public object B2BWelcome([FromBody]B2BPatientRegistration _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PanelId))
            {
                err.Add("message", "PanelId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }



            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        StringBuilder sbSales = new StringBuilder();
                        StringBuilder sbSalesMonth = new StringBuilder();
                        System.Data.DataTable dtSalesMonth1 = new System.Data.DataTable();
                        System.Data.DataTable dtSales1 = new System.Data.DataTable();
                        string _InvoiceTo = ""; string _PanelBalance = "";
                        StringBuilder sbpaidamount = new StringBuilder();
                        System.Data.DataTable paidamount1 = new System.Data.DataTable(); if (Util.GetString(StockReports.ExecuteScalar("Select if(Payment_Mode='Credit','1','0') from f_panel_master where Employee_ID='" + _data.PanelId + "'")) == "1")
                        {

                            sbSales.Append(" SELECT COUNT(*) PatientCount,Round(sum(lt.NetAmount))NetAmount ");
                            sbSales.Append(" FROM f_ledgertransaction lt ");
                            sbSales.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_ID=lt.Panel_ID and  fpm.InvoiceTo IN (SELECT Panel_id FROM f_panel_master WHERE Employee_ID='" + _data.PanelId + "')  ");
                            sbSales.Append("    WHERE  lt.date>='" + DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00' AND lt.date<='" + DateTime.Now.ToString("yyyy-MM-dd") + " 59:59:59'    ");
                            //lt.isCancel=0 AND and lt.IsSampleCollected='Y'
                            dtSales1 = StockReports.GetDataTable(sbSales.ToString());



                            sbSalesMonth.Append(" SELECT COUNT(*) PatientCount,Round(sum(lt.NetAmount))NetAmount  ");
                            sbSalesMonth.Append(" FROM f_ledgertransaction lt ");
                            sbSalesMonth.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_ID=lt.Panel_ID AND fpm.InvoiceTo IN (SELECT Panel_id FROM f_panel_master WHERE Employee_ID='" + _data.PanelId + "')  ");
                            sbSalesMonth.Append(" WHERE  lt.date>='" + DateTime.Now.ToString("yyyy-MM") + "-01 00:00:00' AND lt.date<='" + DateTime.Now.ToString("yyyy-MM-dd") + " 59:59:59'    ");
                            //and lt.IsSampleCollected='Y'

                            dtSalesMonth1 = StockReports.GetDataTable(sbSalesMonth.ToString());
                            _InvoiceTo = StockReports.ExecuteScalar("Select InvoiceTo from f_panel_master where Employee_ID='" + _data.PanelId + "' ");

                            _PanelBalance = StockReports.ExecuteScalar("SELECT get_pcc_outstanding('" + _InvoiceTo + "');");


                            sbpaidamount.Append("  SELECT round(IFNULL(iof.PaidAmount2,0)) ReceivedAmt  FROM f_panel_master fpm1 ");
                            sbpaidamount.Append(" LEFT JOIN (SELECT SUM(lt.NetAmount) BillingAmount,SUM(lt.`Adjustment`) PaidAmount1,");
                            sbpaidamount.Append(" pnl.`employee_ID` FROM `f_ledgertransaction` lt ");
                            sbpaidamount.Append(" INNER JOIN  f_panel_master pnl ON lt.Panel_ID=pnl.Panel_ID WHERE  ");
                            sbpaidamount.Append(" pnl.`employee_ID`='" + _data.PanelId + "' ) ltf ON ltf.employee_ID=fpm1.employee_ID ");
                            sbpaidamount.Append(" LEFT JOIN (SELECT IFNULL(SUM(receivedamt),0) PaidAmount2,pnl1.employee_ID ");
                            sbpaidamount.Append(" FROM  invoicemaster_onaccount io ");
                            sbpaidamount.Append(" INNER JOIN f_panel_master pnl1 ON io.Panel_id=pnl1.Panel_ID  AND (creditnote=0 OR creditnote=1) ");
                            sbpaidamount.Append(" WHERE iscancel=0 AND IFNULL(io.`InvoiceNo`,'')='' ");
                            sbpaidamount.Append(" AND pnl1.`employee_ID`='" + _data.PanelId + "') iof ON iof.employee_ID=fpm1.employee_ID ");
                            sbpaidamount.Append(" WHERE fpm1.`employee_ID`='" + _data.PanelId + "' GROUP BY fpm1.`employee_ID` ;  ");
                            paidamount1 = StockReports.GetDataTable(sbpaidamount.ToString());
                        }
                        else
                        {

                            sbSales.Append(" SELECT COUNT(*) PatientCount,Round(sum(lt.NetAmount))NetAmount ");
                            sbSales.Append(" FROM f_ledgertransaction lt ");
                            sbSales.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_ID=lt.Panel_ID and  fpm.Employee_ID='" + _data.PanelId + "' ");
                            sbSales.Append("    WHERE  lt.date>='" + DateTime.Now.ToString("yyyy-MM-dd") + " 00:00:00' AND lt.date<='" + DateTime.Now.ToString("yyyy-MM-dd") + " 59:59:59'  ");
                            dtSales1 = StockReports.GetDataTable(sbSales.ToString());

                            sbSalesMonth.Append(" SELECT COUNT(*) PatientCount,Round(sum(lt.NetAmount))NetAmount  ");
                            sbSalesMonth.Append(" FROM f_ledgertransaction lt ");
                            sbSalesMonth.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_ID=lt.Panel_ID and  fpm.Employee_ID='" + _data.PanelId + "'  ");
                            sbSalesMonth.Append(" WHERE lt.date>='" + DateTime.Now.ToString("yyyy-MM") + "-01 00:00:00' AND lt.date<='" + DateTime.Now.ToString("yyyy-MM-dd") + " 59:59:59'  ");
                            dtSalesMonth1 = StockReports.GetDataTable(sbSalesMonth.ToString());

                            _InvoiceTo = StockReports.ExecuteScalar("Select Panel_ID from f_panel_master where Employee_ID='" + _data.PanelId + "' ");

                            _PanelBalance = StockReports.ExecuteScalar("select round(sum(ifnull(lt.`NetAmount`,0))-sum(ifnull(lt.`Adjustment`,0))) BalAmount from f_ledgertransaction lt where lt.Panel_id='" + _InvoiceTo + "' ;");
                            sbpaidamount.Append("   SELECT SUM(IFNULL(lt.`Adjustment`,0)) ReceivedAmt FROM f_ledgertransaction lt WHERE  lt.Panel_id='" + _InvoiceTo + "' ;  ");
                            paidamount1 = StockReports.GetDataTable(sbpaidamount.ToString());

                        }
                      string todayCount=  dtSales1.Rows[0]["PatientCount"].ToString();
                      string todayVal = dtSales1.Rows[0]["NetAmount"].ToString();
                      string MonthCount = dtSalesMonth1.Rows[0]["PatientCount"].ToString();
                      string MonthVal = dtSalesMonth1.Rows[0]["NetAmount"].ToString();
                      string MonthlyExpected = Util.GetString(Math.Round(Util.GetFloat(dtSalesMonth1.Rows[0]["PatientCount"]) / DateTime.Now.Day) * Math.Round(Util.GetFloat(DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month))));
                      string MonthlyExpectedval = Util.GetString(Math.Round(Util.GetFloat(dtSalesMonth1.Rows[0]["NetAmount"]) / DateTime.Now.Day) * Math.Round(Util.GetFloat(DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month))));
                      string Outstanding = _PanelBalance;
                      string Paidamount = paidamount1.Rows[0]["ReceivedAmt"].ToString();

                      List<Welcome> Departmentdetails = new List<Welcome>();
                     
                          Welcome response = new Welcome();

                          response.todayCount = todayCount;
                          response.todayVal = todayVal;
                          response.MonthCount = MonthCount;
                          response.MonthVal = MonthVal;
                          response.MonthlyExpected =MonthlyExpected;
                          response.MonthlyExpectedval = MonthlyExpectedval;
                          response.Outstanding = Outstanding;
                          response.Paidamount = Paidamount;
                         


                          Departmentdetails.Add(response);
                      

                      string message = "{\"success\": true,\"message\":\"success\",\"data\": " + JsonConvert.SerializeObject(Departmentdetails) + "}";
                      return JsonConvert.DeserializeObject(message);

                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }




            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }

    [HttpPost]
    [ActionName("GetPackage")]
    public HttpResponseMessage GetPackage([FromBody]B2BPatientRegistration _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PanelId))
            {
                err.Add("message", "PanelId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }



            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append(@" SELECT im.itemid typeid,im.testcode,rl.Rate,REPLACE(im.TypeName,',',' ') AS Item,
                        (SELECT GROUP_CONCAT(pl.investigationID) FROM package_labdetail pl WHERE pl.plabID=im.Type_ID)investigationID, 
                        (SELECT GROUP_CONCAT(DISTINCT `SampleTypeName`) FROM `investigations_sampletype` ist 
                        INNER JOIN `package_labdetail` pld ON pld.`InvestigationID`=ist.`Investigation_ID`
                        WHERE pld.`PlabID`=im.`Type_ID`) SampleType, 
                        IF(IFNULL(im.`Inv_ShortName`,'')<>'',IFNULL(im.`Inv_ShortName`,''),'') AS ShortName ,sm.`Name` AS SubCategory  
                        FROM f_itemmaster im   
                        INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = im.subcategoryid    AND im.IsActive=1 ");
                        sb.Append(@" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=@PanelId ");
                        sb.Append(@" INNER JOIN f_ratelist rl ON rl.ItemID=im.ItemID AND rl.Panel_ID=fpm.ReferenceCodeOPD
                        ORDER BY im.TypeName; ");

                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", Util.GetString(_data.PanelId))
                            ).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data",JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }




            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }


    [HttpPost]
    [ActionName("GetAllTest")]
    public HttpResponseMessage GetAllTest([FromBody]B2BPatientRegistration _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PanelId))
            {
                err.Add("message", "PanelId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PageNo))
            {
                err.Add("message", "PageNo can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }



            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {

                        int ofset = 0;

                        int pgno = Util.GetInt(_data.PageNo);
                        if (pgno > 1)
                            ofset = (pgno * 25);

                        StringBuilder sb = new StringBuilder();
                        sb.Append(" SELECT im.itemid typeid,rl.Rate,REPLACE(im.TypeName,',',' ') AS Item,SampleTypeID,IFNULL(ist.`SampleTypeName`,'') SampleType,");
                        sb.Append(" im.type_id investigationID,if(IFNULL(im.`Inv_ShortName`,'')<>'', IFNULL(im.`Inv_ShortName`,''),'') AS ShortName ,sm.`Name` AS SubCategory");
                        sb.Append(" ,invm.SampleQty,invm.SampleRemarks");
                        sb.Append(" FROM f_itemmaster im   ");
                        sb.Append(" INNER JOIN `investigation_master`  invm ON im.Type_ID = invm.Investigation_ID ");
                        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = im.subcategoryid  and sm.CategoryID='LSHHI3'  AND im.IsActive=1 ");
                        sb.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_ID=@PanelId ");
                        sb.Append(" INNER JOIN f_ratelist rl ON rl.ItemID=im.ItemID and rl.Panel_ID=fpm.ReferenceCodeOPD  ");
                        sb.Append(" INNER JOIN (SELECT Investigation_ID,SampleTypeID,SampleTypeName FROM investigations_sampletype  GROUP BY Investigation_ID ) ist on ist.Investigation_ID=im.Type_ID ");
                        sb.Append(" ORDER BY im.TypeName  limit 25  OFFSET @OffSet  ");

                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", Util.GetString(_data.PanelId)),
                            new MySqlParameter("@OffSet", Util.GetInt(ofset))
                            ).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data",JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }




            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }


    [HttpPost]
    [ActionName("GetSampleTypeBy")]
    public HttpResponseMessage GetSampleTypeBy([FromBody]B2BPatientRegistration _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.Investigation))
            {
                err.Add("message", "Investigation can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }



            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append(" SELECT Investigation_ID,SampleTypeName FROM investigations_sampletype WHERE Investigation_ID in ({0})  ");

                        string[] tags = _data.Investigation.Replace("'", "").Split(',');
                        string[] paramNames = tags.Select((s, i) => "@tag" + i.ToString()).ToArray();
                        string inClause = string.Join(", ", paramNames);


                        MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), inClause));
                        for (int i = 0; i < paramNames.Length; i++)
                        {
                            cmd.Parameters.AddWithValue(paramNames[i], tags[i]);
                        }
                        DataTable dt = new DataTable();
                        MySqlDataAdapter da = new MySqlDataAdapter();
                        cmd.CommandType = CommandType.Text;
                        cmd.Connection = con;
                       
                        da.SelectCommand = cmd;
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            err.Clear();
                            err.Add("status", true);
                            err.Add("data",JArray.FromObject(dt));
                            return Request.CreateResponse(HttpStatusCode.OK, err);

                        }
                        else
                        {
                            err.Add("message", "No data Found");
                            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                        }

                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }




            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }


    [HttpPost]
    [ActionName("GetPatient_TestDetailWithStatus")]
    public HttpResponseMessage GetPatient_TestDetailWithStatus([FromBody]B2BPatientRegistration _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.CenterId))
            {
                err.Add("message", "CenterId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PanelId))
            {
                err.Add("message", "PanelId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            if (string.IsNullOrWhiteSpace(_data.FromDate))
            {
                err.Add("message", "FromDate can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            if (string.IsNullOrWhiteSpace(_data.ToDate))
            {
                err.Add("message", "ToDate can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            if (string.IsNullOrWhiteSpace(_data.PageNo))
            {
                err.Add("message", "PageNo can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }



            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {

                        int ofset = 0;

                        int pgno = Util.GetInt(_data.PageNo);
                        if (pgno > 1)
                            ofset = (pgno * 25);

                        StringBuilder sb = new StringBuilder();
                        sb.Append(@"
                        SELECT pli.test_id, CONCAT(Title,pm.PName) NAME,pm.Gender,pm.Age,pli.LedgerTransactionNo LabID,DATE_FORMAT(pli.Date,'%d/%b/%y') AS DATE,DATE_FORMAT(pli.ApprovedDate,'%Y-%m-%d') ReportDate, 
                        DATE_FORMAT(pli.ApprovedDate,'%I:%i %p') ReportTime, 
                        im.Name ReportTitle,pli.Approved Report_Ready,ltd.NetAmount AS mrp_Rate 
                        ,CASE  WHEN pli.IsDispatch='1' AND pli.isFOReceive='1' THEN '#44A3AA' WHEN pli.isFOReceive='1'  THEN '#E9967A' WHEN pli.UpdateRemarks <> '' THEN '#F7273A'  WHEN pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1' THEN '#00FFFF'  WHEN pli.isFOReceive='0' AND pli.Approved='1'  THEN '#90EE90' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R'  THEN '#FFC0CB' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='1'  THEN '#A9A9A9' WHEN pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='1' THEN '#3399FF' WHEN pli.Result_Flag='0' AND pli.isrerun='1' THEN '#F781D8'  WHEN pli.Result_Flag='0' AND (SELECT COUNT(*) FROM mac_data mac WHERE  mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 THEN '#E2680A' WHEN pli.isHold='1' THEN '#DAA520'   WHEN pli.IsSampleCollected='N' THEN '#CC99FF' WHEN pli.IsSampleCollected='S' THEN '#FFCC99' WHEN pli.IsSampleCollected='R' THEN '#7AA3CC' ELSE '#FFFFFF' END rowColor  
                        ,CONCAT('http://74.208.87.150/Code2/Design/Finanace/PatientReceipt.aspx?isnew=1&LedgerTransactionNo=',pli.LedgerTransactionNo) ReceiptReportPath 
                        ,(SELECT IsSampleCollected FROM Patient_labinvestigation_opd pli2 WHERE pli2.LedgerTransactionNo=pli.LedgerTransactionNo AND pli2.IsSampleCollected='N' LIMIT 1) SampleStatus
                        FROM patient_labinvestigation_opd pli 
                        INNER JOIN f_ledgertransaction ltd  ON pli.LedgerTransactionId = ltd.LedgerTransactionId 
                        INNER JOIN patient_master pm ON pm.Patient_ID=ltd.Patient_ID  
                        INNER JOIN investigation_master im ON im.Investigation_Id=pli.Investigation_ID 
                        WHERE ltd.CentreId=@CentreId AND ltd.Panel_Id=@PanelId  AND  pli.date>=@FromDate AND  pli.date<=@ToDate ORDER BY pli.test_id DESC LIMIT 25  OFFSET @OffSet   

                        ");

                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", Util.GetString(_data.PanelId)),
                            new MySqlParameter("@CentreId", Util.GetString(_data.CenterId)),
                            new MySqlParameter("@FromDate", Util.GetDateTime(_data.FromDate).ToString("yyyy-MM-dd 00:00:00")),
                            new MySqlParameter("@ToDate", Util.GetDateTime(_data.ToDate).ToString("yyyy-MM-dd 23:59:59")),
                            new MySqlParameter("@OffSet", Util.GetInt(ofset))
                            ).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data", JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }




            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }

    [HttpPost]
    [ActionName("GetAccountReport")]
    public HttpResponseMessage GetAccountReport([FromBody]B2BPatientRegistration _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PanelId))
            {
                err.Add("message", "PanelId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            if (string.IsNullOrWhiteSpace(_data.FromDate))
            {
                err.Add("message", "FromDate can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            if (string.IsNullOrWhiteSpace(_data.ToDate))
            {
                err.Add("message", "ToDate can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
           
            if (string.IsNullOrWhiteSpace(_data.Type))
            {
                err.Add("message", "Type can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }



            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {

                        StringBuilder sb = new StringBuilder();
                        sb.Append(@"");
                        if (_data.Type == "Invoice")
                        {

                            sb.Append(@" 
                            SELECT CONCAT(pnl.Panel_Code,'-',pnl.`Company_Name`) AS PanelName,CASE  WHEN im.IsClose=1 THEN '#90EE90' ELSE '#F6A9D1'  END  rowColor  , 
                            im.InvoiceNo , DATE_FORMAT(im.InvoiceDate,'%d-%b-%y')DATE,SUM(im.NetAmount)InvoiceAmt,(SELECT CONCAT(title,NAME) FROM `employee_master` WHERE Employee_ID=im.EntryById)InvoiceCreatedBy,
                            (SUM(lt.NetAmount)-SUM(lt.Adjustment))DueAmt , 
                            (SELECT IFNULL( (SUM(ivca.receivedamt)),0) paidamt FROM `invoicemaster_onaccount` ivca WHERE ivca.`InvoiceNo` = im.InvoiceNo AND iscancel=0 ) PaidAmount , 
                            pnl.InvoiceDisplayAddress Address,pnl.Phone,DATE_FORMAT(lt.Date,'%d-%b-%y')LedgerDate,SUM(lt.GrossAmount)GrossAmount,SUM(lt.DiscountOnTotal)DiscountOnTotal,SUM(lt.NetAmount)NetAmount,SUM(lt.Adjustment)Adjustment,lt.LedgerTransactionNo
                            ,'' ReportPath 
                            FROM `f_ledgertransaction` lt 
                            INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID 
                            INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=lt.`Panel_ID` AND pnl.`Panel_ID`=@PanelId
                            INNER JOIN invoicemaster im ON im.PanelId=pnl.Panel_Id 
                            AND DATE(im.InvoiceDate)>=@FromDate
                            AND DATE(im.InvoiceDate)<=@ToDate
                            AND IFNULL(im.InvoiceNo,'')<>'' 
                            GROUP BY im.InvoiceNo 
                            ");
                        }
                        else if (_data.Type == "Business Report")
                        {
                            sb.Append(@"
                                SELECT dr.Name Doctor, pnl.Company_Name PanelName, DATE_FORMAT(lt.Date,'%d/%b/%Y')DATE,lt.LedgerTransactionNo LabNo,
                                plo.BillNo,lt.PatientIdProofNo CardNo,pm.PName,pm.Age,pm.Gender,pm.`Mobile`,'' `bedno`,plo.UpdateRemarks `Comments`,
                                lt.HomeVisitBoyId `collectionbobyname`,  
                                GROUP_CONCAT(IF(plo.`ItemID`<>'LSHHI6882',plo.`ItemName`,''))ItemName,ROUND(lt.`GrossAmount`)GrossAmount,  lt.DiscountOnTotal DiscountAmount,  ROUND(lt.`NetAmount`)NetAmount,
                                lt.Adjustment ReceivedAmt, (lt.NetAmount-lt.Adjustment) PendingAmt,SUM(IF(plo.`ItemID`='LSHHI6882',plo.`Rate`,0))CollectionCharge, SUM(IF(plo.`ItemID`<>'LSHHI6882',plo.`Rate`,0))TestCharge 
                                ,'' ReportPath 
                                FROM f_ledgertransaction lt   
                                INNER JOIN patient_labInvestigation_opd plo ON lt.LedgerTransactionId = plo.LedgerTransactionId   
                                 AND  lt.Date>=@FromDate AND lt.Date<=@ToDate  
                                INNER JOIN f_itemmaster itm ON itm.ItemID=plo.ItemID  
                                INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID  
                                INNER JOIN f_panel_master pnl ON pnl.Panel_ID=lt.Panel_ID   
                                AND pnl.Panel_ID =@PanelId   
                                INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_Id  
                                GROUP BY lt.LedgerTransactionNo  
                                ORDER BY pnl.Company_Name,lt.date,lt.LedgerTransactionNo ");
                        }
                        else if (_data.Type == "Ledger Statement")
                        {

                        }
                        else {
                            err.Add("message", "Invalid Type!");
                            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                        }


                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", Util.GetString(_data.PanelId)),
                            new MySqlParameter("@FromDate", Util.GetDateTime(_data.FromDate).ToString("yyyy-MM-dd 00:00:00")),
                            new MySqlParameter("@ToDate", Util.GetDateTime(_data.ToDate).ToString("yyyy-MM-dd 23:59:59"))
                            ).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data", JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }




            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }

    [HttpPost]
    [ActionName("GetLedgerReport")]
    public object GetLedgerReport([FromBody]B2BPatientRegistration _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PanelId))
            {
                err.Add("message", "PanelId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            if (string.IsNullOrWhiteSpace(_data.FromDate))
            {
                err.Add("message", "FromDate can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            if (string.IsNullOrWhiteSpace(_data.ToDate))
            {
                err.Add("message", "ToDate can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            //if (string.IsNullOrWhiteSpace(_data.Type))
            //{
            //    err.Add("message", "Type can't be blank");
            //    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            //}

string data="[]";

            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {

                        StringBuilder sb = new StringBuilder();
                       sb.Append(" SELECT '0001-01-01' DateOrder, 'OPENING' `Month`,'' MRP,'' Net,'' DepositAmount,  ");
            sb.Append(" round((ifnull(ReceivedAmt,0)-ifnull(NetAmount,0)),2) Closing FROM  ");
            sb.Append(" ( SELECT SUM(`ReceivedAmt`)ReceivedAmt FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` < @FromReceiveDate ) a ");
            sb.Append(" ,( SELECT SUM(plos.`PCCInvoiceAmt`)NetAmount  ");
            sb.Append(" FROM `patient_labinvestigation_opd_share` plos  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID`   ");
            sb.AppendFormat(" AND plos.date < @ToDate ");
           
            sb.Append(" AND pm.`InvoiceTo`=@PanelID) b ");

            sb.Append(" UNION ALL  ");


            sb.Append(" SELECT DateOrder,`Month`,round(SUM(MRP),2) MRP,round(SUM(Net),2) Net, round(SUM(DepositAmount),2) DepositAmount,0 Closing ");
            sb.Append(" FROM ( ");
            sb.Append(" SELECT ReceivedDate DateOrder, CONCAT(MONTHNAME(ReceivedDate),'-',YEAR(ReceivedDate)) `Month`,'0' MRP, ");
            sb.Append(" '0' Net, IFNULL(SUM(`ReceivedAmt`),0) DepositAmount,0 Closing ");
            sb.Append(" FROM `invoicemaster_onaccount` WHERE `IsCancel`=0 AND `Panel_ID`=@PanelID AND  ");
            sb.Append(" `ReceivedDate` >= @FromReceiveDate AND `ReceivedDate` <= @ToReceiveDate GROUP BY YEAR(ReceivedDate),MONTH(ReceivedDate) ");

            sb.Append(" UNION ALL   ");

            sb.AppendFormat(" SELECT plos.date DateOrder, CONCAT(MONTHNAME(plos.date),'-',YEAR(plos.date)) `Month`,  ");
            sb.Append(" SUM(IFNULL(r.rate,0)*plos.`Quantity`) MRP, ");
            sb.Append(" SUM(plos.`Amount`) Net, ");
            sb.Append(" 0 DepositAmount,0 Closing   ");
            sb.Append(" FROM  `patient_labinvestigation_opd_share` plos  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=plos.`LedgerTransactionID` ");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.`Panel_ID`=lt.`Panel_ID` AND pm.`InvoiceTo`=@PanelID ");
            sb.AppendFormat(" AND plos.date >= @FromDate AND plos.date <= @ToDate ");
           

            sb.Append(" INNER JOIN f_panel_master pm2 ON pm2.centreID=pm.TagProcessingLabID AND pm2.paneltype='Centre' ");
            sb.Append(" LEFT JOIN f_ratelist r ON r.ItemID=plos.ItemID AND r.panel_ID= pm2.`ReferenceCodeOPD`  ");
            sb.AppendFormat(" GROUP BY YEAR(plos.date),MONTH(plos.date) ");

            sb.Append(" ) aa GROUP BY `Month` ");
            sb.Append(" ORDER BY DateOrder ");
           // System.IO.File.WriteAllText (@"D:\Shat\aa.txt", sb.ToString());
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@PanelID", _data.PanelId),
                   new MySqlParameter("@FromDate", Util.GetDateTime(_data.FromDate).ToString("yyyy-MM-dd 00:00:00")),
                   new MySqlParameter("@ToDate", Util.GetDateTime(_data.ToDate).ToString("yyyy-MM-dd 23:59:59")),
                   new MySqlParameter("@FromReceiveDate", Util.GetDateTime(_data.FromDate).ToString("yyyy-MM-dd")),
                   new MySqlParameter("@ToReceiveDate",  Util.GetDateTime(_data.ToDate).ToString("yyyy-MM-dd"))).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data", JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                               string massege="{\"status\": false,\"message\": \"No Data Found\",\"data\": []}";
                        err.Add("status", false);
                        err.Add("message", "No Record Found");
                        err.Add("data", data);
						return JsonConvert.DeserializeObject(massege);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }




            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }

    [HttpPost]
    [ActionName("GetPatient_TestDetail")]
    public HttpResponseMessage GetPatient_TestDetail([FromBody]B2BPatientRegistration _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.CenterId))
            {
                err.Add("message", "CenterId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PanelId))
            {
                err.Add("message", "PanelId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            if (string.IsNullOrWhiteSpace(_data.FromDate))
            {
                err.Add("message", "FromDate can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            if (string.IsNullOrWhiteSpace(_data.ToDate))
            {
                err.Add("message", "ToDate can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }
            if (string.IsNullOrWhiteSpace(_data.PageNo))
            {
                err.Add("message", "PageNo can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }



            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {

                        int ofset = 0;

                        int pgno = Util.GetInt(_data.PageNo);
                        if (pgno > 1)
                            ofset = (pgno * 25);

                        StringBuilder sb = new StringBuilder();
                        sb.Append(@"
                                SELECT pli.test_id, CONCAT(Title,pm.PName) NAME,pm.Gender,pm.Age,pli.LedgerTransactionNo LabID,DATE_FORMAT(pli.Date,'%d/%b/%y') AS DATE,DATE_FORMAT(pli.ApprovedDate,'%Y-%m-%d') ReportDate, 
                                DATE_FORMAT(pli.ApprovedDate,'%I:%i %p') ReportTime, 
                                im.Name ReportTitle,pli.Approved Report_Ready 
                                FROM patient_labinvestigation_opd pli 
                                INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionId=pli.LedgertransactionId
                                INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID  
                                INNER JOIN investigation_master im ON im.Investigation_Id=pli.Investigation_ID 
                                WHERE pli.CentreId=@CentreId AND lt.Panel_Id=@PanelId  AND  pli.date>=@FromDate AND  pli.date<=@ToDate ORDER BY pli.test_id DESC LIMIT 25  OFFSET @OffSet  
                                ");

                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", Util.GetString(_data.PanelId)),
                            new MySqlParameter("@CentreId", Util.GetString(_data.CenterId)),
                            new MySqlParameter("@FromDate", Util.GetDateTime(_data.FromDate).ToString("yyyy-MM-dd 00:00:00")),
                            new MySqlParameter("@ToDate", Util.GetDateTime(_data.ToDate).ToString("yyyy-MM-dd 23:59:59")),
                            new MySqlParameter("@OffSet", Util.GetInt(ofset))
                            ).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data", JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }




            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }

    
    [HttpPost]
    [ActionName("SearchPrevAdvPayment")]
    public HttpResponseMessage SearchPrevAdvPayment([FromBody]B2BPatientRegistration _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PanelId))
            {
                err.Add("message", "PanelId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PageNo))
            {
                err.Add("message", "PageNo can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }



            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {

                        int ofset = 0;

                        int pgno = Util.GetInt(_data.PageNo);
                        if (pgno > 1)
                            ofset = (pgno * 25);

                        StringBuilder sb = new StringBuilder();
                        sb.Append(@" SELECT aa.ID,aa.imagefile,aa.Company_Name,aa.ReceivedAmt,aa.EntryBy,aa.Status,aa.AdvanceAmtDate,aa.EntryDate,aa.Logistic_charges,aa.Stationary_charges,aa.AmtGivenTo,aa.iscancel,aa.PaymentMode,aa.remarks
                                    FROM (  
                                    SELECT ivac.`ID`,'' imagefile, fpm.Panel_Code `Company_Name`,ivac.`ReceivedAmt` `ReceivedAmt`,ivac.EntryByName EntryBy,IF(iscancel = 0,'Open','Cancel') STATUS 
                                    ,DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y') AdvanceAmtDate ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i%p') EntryDate,0 Logistic_charges, 0 Stationary_charges,0 AmtGivenTo 
                                    ,ivac.iscancel,ivac.PaymentMode 
                                    , remarks,'' PrintReciept  FROM `invoicemaster_payment` ivac  
                                    left JOIN `f_panel_master` fpm ON ivac.`Panel_id` = fpm.`Panel_id` WHERE ivac.iscancel<>2 AND ivac.panel_id = @PanelId  
                                    UNION ALL 
                                    SELECT ivac.`ID`,'' imagefile, fpm.Panel_Code `Company_Name`,ivac.`ReceivedAmt` `ReceivedAmt`,ivac.EntryByName EntryBy,'Approve' STATUS 
                                    ,DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y %I:%i%p') AdvanceAmtDate ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i%p') EntryDate,0 Logistic_charges, 0 Stationary_charges,0 AmtGivenTo 
                                    ,ivac.iscancel,ivac.PaymentMode 
                                    , remarks,'' PrintReciept FROM `invoicemaster_onaccount` ivac  
                                    left JOIN `f_panel_master` fpm ON ivac.`Panel_id` = fpm.`Panel_id` WHERE ivac.iscancel=0 AND  ivac.panel_id =@PanelId  
                                    )aa  
                                    ORDER BY aa.`AdvanceAmtDate` DESC LIMIT 25  OFFSET @OffSet  ");

                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@PanelId", Util.GetString(_data.PanelId)),
                            new MySqlParameter("@OffSet", Util.GetInt(ofset))
                            ).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data", JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }




            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }

    
    [HttpPost]
    [ActionName("DailyCollection")]
    public HttpResponseMessage DailyCollection([FromBody]InvoiceReprint _data)
    {

        HttpError err = new HttpError();
        err.Add("status", false); 
        if (_data == null)
        {
            err.Add("message", "Invalid JSON Format");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

        if (string.IsNullOrWhiteSpace(_data.Centre))
        {
            err.Add("message", "centre can't be blank");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(Util.GetString(_data.FromDate)))
        {
            err.Add("status", false);
            err.Add("message", "FromDate can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (string.IsNullOrWhiteSpace(Util.GetString(_data.ToDate)))
        {
            err.Add("status", false);
            err.Add("message", "ToDate can't be blank");
            err.Add("data", "[]");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        // if (string.IsNullOrWhiteSpace(_data.User))
        // {
            // err.Add("message", "user can't be blank");
            // return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        // }

       
        try
        {
            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        StringBuilder sb = new StringBuilder();

                              sb.Append("  SELECT EmployeeName,SUM(GrossAmount)GrossAmount,SUM(NetAmount)NetAmount,SUM(DiscountAmt)DiscountAmt,SUM(CashAmt)CashAmt,");
                    sb.Append(" SUM(CardAmt)CardAmt,SUM(ChequeAmt)ChequeAmt,SUM(Amount)Amount,SUM(S_Amount)S_Amount,SUM(OnlineAmt)OnlineAmt,sum(DebitCardAmt) DebitCardAmt, ");
                    sb.Append(" SUM(CreditSale)CreditSale,SUM(AmtSubmission)AmtSubmission,SUM(SameDaySettlement)SameDaySettlement,SUM(BackDaySettlement)BackDaySettlement,SUM(CreditSaleReceiveSameDay)CreditSaleReceiveSameDay,sum(AppAmt) AppAmt,sum(ClientAdvanceAmt)ClientAdvanceAmt, ");
                    sb.Append("  SUM(NetAmount-SameDaySettlement-CreditSale+CreditSaleReceiveSameDay) SamedayOutstanding ");
                    sb.Append(" FROM ( ");
                    sb.Append(" SELECT SUM(Rate*Quantity)GrossAmount,SUM(Amount)NetAmount,SUM(DiscountAmt)DiscountAmt,0 Amount,0 S_Amount,  ");
                    sb.Append("  '' PaymentMode,0 PaymentModeID,plo.CreatedByID,plo.createdBy EmployeeName, ");
                    sb.Append(" 0 CashAmt,0 CardAmt,0 ChequeAmt,0 OnlineAmt,0 DebitCardAmt,  ");
                    sb.Append(" SUM(IF(lt.`IsCredit`=1,(Rate*Quantity),0)) CreditSale ,0 AmtSubmission,0 SameDaySettlement,0 BackDaySettlement,0 CreditSaleReceiveSameDay,0 AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM `patient_labinvestigation_opd` plo ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
                   
                    sb.Append("   AND lt.panel_id IN ('" + _data.Centre + "') ");
                    sb.Append(" AND plo.date >='" + Util.GetDateTime(_data.FromDate).ToString("yyyy-MM-dd") + "' AND plo.date <= '" + Util.GetDateTime(_data.ToDate).ToString("yyyy-MM-dd") + "'  AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                    sb.Append("  GROUP BY plo.CreatedById ");
                     //cash collection
                    sb.Append(" UNION ALL ");
                    sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,SUM(Amount)Amount,SUM(S_Amount)S_Amount, ");
                    sb.Append(" PaymentMode,PaymentModeID,rc.CreatedByID,rc.CreatedBy EmployeeName, ");
                    sb.Append(" SUM(IF(`PaymentModeID`=1,Amount,0))CashAmt,SUM(IF(`PaymentModeID`=3,Amount,0))CardAmt, ");
                    sb.Append("  SUM(IF(`PaymentModeID`=2,Amount,0))ChequeAmt,SUM(IF(`PaymentModeID`=10,Amount,0))OnlineAmt,SUM(IF(`PaymentModeID`=5,Amount,0))DebitCardAmt, ");
                    sb.Append(" 0 CreditSale,0 AmtSubmission, ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date >= '" + Util.GetDateTime(_data.FromDate).ToString("yyyy-MM-dd") + "'   AND lt.Date <=  '" + Util.GetDateTime(_data.ToDate).ToString("yyyy-MM-dd") + "' ,rc.Amount,0)),0)) SameDaySettlement, ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date < '" + Util.GetDateTime(_data.FromDate).ToString("yyyy-MM-dd") + "'  ,rc.Amount,0)),0)) BackDaySettlement,  ");
                    sb.Append(" SUM(IFNULL((IF( lt.Date >= '" + Util.GetDateTime(_data.FromDate).ToString("yyyy-MM-dd") + "'  AND lt.Date <=  '" + Util.GetDateTime(_data.ToDate).ToString("yyyy-MM-dd") + "'  AND lt.`IsCredit`=1,rc.Amount,0)),0)) CreditSaleReceiveSameDay,0 AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM f_receipt rc ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=rc.`LedgerTransactionID` ");
                    sb.Append(" AND rc.Iscancel=0 and  ifnull(rc.AppointmentID,'')='' AND rc.`PayBy`<>'C' ");
                   

                    sb.Append(" AND rc.panel_id IN ('" + _data.Centre + "') ");
                    sb.Append(" AND rc.`CreatedDate` >='" + Util.GetDateTime(_data.FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND rc.`CreatedDate` <= '" + Util.GetDateTime(_data.ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");                    
                    sb.Append("   GROUP BY rc.CreatedById ");
                   
                     sb.Append(" UNION ALL ");
                     sb.Append(" SELECT 0 GrossAmount,0 NetAmount,0 DiscountAmt,0 Amount,0 S_Amount,  ");
                     sb.Append("  PaymentMode, PaymentModeID,EntryBy CreatedByID,EntryByName EmployeeName, ");
                     sb.Append(" 0 CashAmt,0 CardAmt,  0 ChequeAmt,0 OnlineAmt,0 DebitCardAmt , ");
                     sb.Append(" 0 CreditSale,SUM(ReceivedAmt) AmtSubmission,0 SameDaySettlement,0 BackDaySettlement,0 CreditSaleReceiveSameDay,0 AppAmt,0 ClientAdvanceAmt ");
                    sb.Append(" FROM invoicemaster_onaccount im ");
                    sb.Append("   WHERE IsCancel=0   AND CreditNote = 0 AND ReceivedAmt > 0   ");
                  

                    sb.Append(" AND im.EntryDate >='" + Util.GetDateTime(_data.FromDate).ToString("yyyy-MM-dd") + " 00:00:00' AND im.EntryDate <= '" + Util.GetDateTime(_data.ToDate).ToString("yyyy-MM-dd") + " 23:59:59' ");
                    sb.Append("   GROUP BY EntryBy ");
                    sb.Append(" )a GROUP BY CreatedById ");

                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data", JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);
                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }
            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }
    [HttpGet]
    [ActionName("AddPaymentMode")]
    public HttpResponseMessage AddPaymentMode()
    {
        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        StringBuilder sb = new StringBuilder();

                        sb.Append(" SELECT PaymentModeId,PaymentMode,Remarks FROM `paymentmode_master` WHERE Active=1;");

                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data", JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);
                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }
            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }

    [HttpGet]
    [ActionName("TitleDetail")]
    public HttpResponseMessage TitleDetail()
    {
        HttpError err = new HttpError();
        err.Add("status", false);
        try
        {
            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        StringBuilder sb = new StringBuilder();

                        sb.Append("SELECT Id,Title FROM `title_master` WHERE IsActive=1;");

                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("status", true);
                                err.Add("data", JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);
                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.OK, err);
                }
                finally
                {
                    con.Close();
                }
            }
            //---------------------------------------------------

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("message", ex.GetBaseException().Message);
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }

    }
    [ActionName("BookingAPINew")]
    public HttpResponseMessage NewBookingData([FromBody]BookingData BookingData)
    {
        string labno = "";
        HttpError err = new HttpError();
        string WorkorderId = "";
        BookingData bd = BookingData;
        //  bd.patientId = "";
        DateTime cday = DateTime.Today;
        DateTime dob = DateTime.Today;
        if (Util.GetDateTime(bd.dob).ToString("dd/MM/yyyy") == "01/01/0001" && bd.age == "")
        {

            err.Add("status", false);
            err.Add("message", "Please enter Date of Birth,either Age.");
            err.Add("data", "");
            return Request.CreateErrorResponse(HttpStatusCode.OK, err);
        }
        if (bd.age == "")
        {
            dob = bd.dob;

        }
        else
        {

            if (bd.age.Length > 2)
            {
                err.Add("status", false);
                err.Add("message", "Please enter valid age");
                err.Add("data", "");
                return Request.CreateErrorResponse(HttpStatusCode.OK, err);
            }


            int finalAge = Convert.ToInt32(bd.age);

            bd.dob = cday.AddYears(-finalAge);
            dob = bd.dob;

        }

        Age age = new Age(dob, cday);

        var json = JsonConvert.SerializeObject(bd);
        var obj = JToken.Parse(json);
        string json1 = JsonConvert.SerializeObject(bd);
        var key = CreateMD5(json1);
        var comparer = new JTokenEqualityComparer();
        var hashCode = comparer.GetHashCode(obj);


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {


            //            DataTable dtCentreDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT panel_Id PanelID,centreID FROM `centre_master_interface` WHERE CentreId_interface=@centreIDInterface limit 1 ",
            //new MySqlParameter("@centreIDInterface", bd.billDetails.organizationIdLH)).Tables[0];

            //  bd.billDetails.orderNumber = "";
            //  if (bd.billDetails.orderNumber == "")
            //  {
            //     bd.billDetails.orderNumber = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT `get_ledgertransaction_centre`(@CentreID)",
            //                                                                             new MySqlParameter("@CentreID", dtCentreDetail.Rows[0]["centreID"])));

            int ordernoExists = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(1) from booking_alldata where workorderID=@workorderID  and Isbooked=1 ",
new MySqlParameter("@workorderID", bd.orderNumber)));
            if (ordernoExists > 0)
            {
                err.Add("status", false);
                err.Add("data", "The OrderNumber " + bd.orderNumber + " you are sending is already registered with us. Please send a unique order number.");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);

            }
            int Panel_id = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(1) from f_panel_master where panel_id=@panel_id ",
new MySqlParameter("@panel_id", bd.Panel_ID)));
            if (Panel_id == 0)
            {
                err.Add("status", false);
                err.Add("data", "panelID  " + bd.Panel_ID + " does not exists in LIS.");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);

            }
            int centremaster = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(1) from centre_master where centreid=@centreid",
new MySqlParameter("@centreid", bd.CentreID)));
            if (centremaster == 0)
            {
                err.Add("status", false);
                err.Add("data", "CentreID  " + bd.CentreID + " does not exists in LIS.");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);

            }
            WorkorderId = bd.orderNumber;

            //  }
            // if (bd.patientId == "" || bd.patientId == "0")
            // {
            // err.Add("status", false);
            // err.Add("data", "Patient Id is blank. Kindly send patient id.");
            // return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
            // //  bd.patientId = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT `get_patientid_centre`(@CentreID)",
            // //  new MySqlParameter("@CentreID", dtCentreDetail.Rows[0]["centreID"])));
            // }
            foreach (testList bddt in bd.testList)
            {
               

                    string SampleId = bddt.sampleId;
                    if (SampleId != "")
                    {

                        SampleId = SampleId + ",";
                        string[] CrmBarcode = SampleId.Split(',');
                        foreach (var Barcode in CrmBarcode)
                        {
                            if (Barcode != "")
                            {
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into crm_barcode (WorkorderID,Crm_BarcodeNo,dtEntry ) values (@WorkorderID, @Crm_BarcodeNo,@dtEntry)",
    new MySqlParameter("@WorkorderID", bd.orderNumber),
    new MySqlParameter("@dtEntry", DateTime.Now),
    new MySqlParameter("@Crm_BarcodeNo", Barcode));
                            }
                        }
                    }
                    else
                    {
                        
                    }

                    int Years = new DateTime(DateTime.Now.Subtract(Util.GetDateTime(bd.dob)).Ticks).Year - 1;

                    int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(1) from f_itemMaster where TestCode=@testCode",
                    new MySqlParameter("@testCode", bddt.testCode)));
                    if (count == 0)
                    {
                        err.Add("status", false);
                        err.Add("data", "This Testcode " + bddt.testCode + " is not available in LIMS. Kindly create this test first. ");
                        return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
                    }
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into booking_alldata (OrderID, InterfaceClient ,  TYPE ,  WorkOrderID ,  WorkOrderID_Create ,  Patient_ID ,  Patient_ID_creat ,  Title ,  PName ,  Address ,  localityid ,  Locality ,  cityid ,  City ,  stateid ,  State ,  Pincode ,  Country ,  Phone ,  Mobile ,  Email ,  DOB ,  Age ,  AgeYear ,  AgeMonth ,  AgeDays ,  Gender ,  CentreID_Interface ,  VIP ,  isUrgent ,  Panel_ID ,  Doctor_ID ,  DoctorName ,  HLMPatientType ,  HLMOPDIPDNo ,  bed_type ,  ward_name ,  BarcodeNo ,  ItemId_interface ,  ItemName_interface ,  ItemID_AsItdose ,  SampleCollectionDate ,  SampleTypeID ,  SampleTypeName ,  IsBooked ,  Response ,  dtAccepted ,  EntryDateTime ,  TPA_Name ,  Employee_id ,  PackageName ,  TechnicalRemarks ,  DoctorMobile ,  TestCount ,  IsAllowPrint ,  Rate,DiscountAmt ,SrfId,PassportNo,PrintDob,paymentType,paymentAmount,issueBank,chequeNo ) values (@OrderID, @InterfaceClient , @TYPE ,@WorkOrderID , @WorkOrderID_Creat , @Patient_ID , @Patient_ID_creat,@Title,@PName,@Address,@localityid,@Locality,@cityid,@City,@stateid,@State,@Pincode,@Country,@Phone,@Mobile,@Email,@DOB,@Age,@AgeYear,@AgeMonth,@AgeDays,@Gender,@CentreID_Interface,@VIP,@isUrgent,@Panel_ID,@Doctor_ID,@DoctorName,@HLMPatientType,@HLMOPDIPDNo,@bed_type,@ward_name,@BarcodeNo,@ItemId_interface,@ItemName_interface,@ItemID_AsItdose,@SampleCollectionDate,@SampleTypeID,@SampleTypeName,@IsBooked,@Response,@dtAccepted,Now(),@TPA_Name,@Employee_id,@PackageName,@TechnicalRemarks,@DoctorMobile,@TestCount,@IsAllowPrint,@Rate,@DiscountAmt,@srfNumber,@passportNo,@PrintDob,@paymentType,@paymentAmount,@issueBank,@chequeNo)",
     new MySqlParameter("@OrderID", ""),
     new MySqlParameter("@InterfaceClient", "NOIDA"),
     new MySqlParameter("@TYPE", "NW"),
     new MySqlParameter("@WorkOrderID", bd.orderNumber),
     new MySqlParameter("@WorkOrderID_Creat", "0"),
     new MySqlParameter("@Patient_ID", bd.patientId),
     new MySqlParameter("@Patient_ID_creat", "0"),
     new MySqlParameter("@Title", bd.designation),
     new MySqlParameter("@PName", bd.fullName),
     new MySqlParameter("@Address", bd.Address),
     new MySqlParameter("@localityid", bd.localityid),
     new MySqlParameter("@Locality", bd.area),
     new MySqlParameter("@cityid", bd.cityid),
     new MySqlParameter("@City", bd.city),
     new MySqlParameter("@stateid", bd.stateid),
     new MySqlParameter("@State", bd.State),
     new MySqlParameter("@Pincode", bd.Pincode),
     new MySqlParameter("@Country", bd.Country),
     new MySqlParameter("@Phone", bd.Phone),

     new MySqlParameter("@Mobile", bd.Mobile),
     new MySqlParameter("@Email", bd.Email),
     new MySqlParameter("@DOB", Util.GetDateTime(bd.dob)),
     new MySqlParameter("@Age", age.Years + " Y " + age.Months + " M " + age.Days + " D "),
     new MySqlParameter("@AgeYear", age.Years),
     new MySqlParameter("@AgeMonth", age.Months),
     new MySqlParameter("@AgeDays", age.Days),

     new MySqlParameter("@Gender", bd.gender),
     new MySqlParameter("@CentreID_Interface", bd.CentreID),
     new MySqlParameter("@VIP", bd.VIP),
     new MySqlParameter("@isUrgent", bd.isUrgent),
     new MySqlParameter("@Panel_ID", bd.Panel_ID),
     new MySqlParameter("@Doctor_ID", 2),
     new MySqlParameter("@DoctorName", bd.referralName),

     new MySqlParameter("@HLMPatientType", "OPD"),
     new MySqlParameter("@HLMOPDIPDNo", bd.HLMOPDIPDNo),
     new MySqlParameter("@bed_type", bd.bed_type),
     new MySqlParameter("@ward_name", bd.ward_name),
     new MySqlParameter("@BarcodeNo", bddt.sampleId),
     new MySqlParameter("@ItemId_interface", bddt.testCode),
     new MySqlParameter("@ItemName_interface", ""),
     new MySqlParameter("@ItemID_AsItdose", bd.ItemID_AsItdose),
     new MySqlParameter("@SampleCollectionDate", Util.GetDateTime(bd.SampleCollectionDate)),
     new MySqlParameter("@SampleTypeID", bddt.sampleId),
     new MySqlParameter("@SampleTypeName", bd.SampleTypeName),
     new MySqlParameter("@IsBooked", "0"),
     new MySqlParameter("@Response", bd.Response),
     new MySqlParameter("@dtAccepted", Util.GetDateTime(bd.dtAccepted)),

     new MySqlParameter("@TPA_Name", bd.TPA_Name),
     new MySqlParameter("@Employee_id", bd.Employee_id),
     new MySqlParameter("@PackageName", bd.PackageName),
     new MySqlParameter("@TechnicalRemarks", bd.TechnicalRemarks),
     new MySqlParameter("@DoctorMobile", bd.DoctorMobile),
     new MySqlParameter("@TestCount", bd.TestCount),
     new MySqlParameter("@IsAllowPrint", 1),

     new MySqlParameter("@Rate", bddt.Rate),

     new MySqlParameter("@DiscountAmt", bddt.DiscountAmt),
     new MySqlParameter("@srfNumber", bd.srfNumber),
                     new MySqlParameter("@PrintDob", bd.PrintDob),

                       new MySqlParameter("@paymentType", bd.paymentType),
                         new MySqlParameter("@paymentAmount", bd.paymentAmount),
                           new MySqlParameter("@issueBank", bd.issueBank),
                             new MySqlParameter("@chequeNo", bd.chequeNo),


     new MySqlParameter("@passportNo", bd.passportNo)

     );
                }
            

            tnx.Commit();

            StringBuilder sb = new StringBuilder();
           

            sb.Append(" SELECT pli.ledgertransactionno,pli.`AgeInDays` Age,pli.`Rate` testAmount,pli.`ItemCode` testCode,'' testCategory,pli.`SubCategoryName` departmentName,pli.`BarcodeNo` sampleid ");
            sb.Append("              ,'' dictionaryId,'' testID, pli.`Test_ID` CentreReportId,'' integrationCode, pli.`ItemName` AS testName, ");
            sb.Append("  pli.`Gender`,pli.`Patient_ID`  patientId , pli.`LedgerTransactionNo_Interface` billId ");

            sb.Append("  FROM `patient_labinvestigation_opd` pli  INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=pli.LedgerTransactionID  ");
            sb.Append("    WHERE pli.`LedgerTransactionNo_Interface`=@WorkOrderID    ");


            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "CALL Proc_BulkRegistrationHL7('" + WorkorderId + "')");
            int labid = 0;
         
           
            StringBuilder sb1 = new StringBuilder();
//            sb1.Append(" SELECT pli.ledgertransactionid FROM patient_labinvestigation_opd pli ");
//            sb1.Append(" INNER JOIN f_ledgertransaction lt ON lt.`LedgerTransactionID`=pli.LedgerTransactionID ");
//            sb1.Append(" WHERE pli.`LedgerTransactionNo_Interface`=@WorkOrderID LIMIT 1; ");
//            DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb1.ToString(),
//new MySqlParameter("@WorkOrderID", WorkorderId)).Tables[0];
//            if (dt.Rows.Count > 0)
//            {
//                foreach (DataRow item1 in dt.Rows)
//                {

//                    labid = Util.GetInt(item1["ledgertransactionid"]);
//                }
//            }
//            //labid = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select pli.ledgertransactionid from patient_labinvestigation_opd pli where pli.`LedgerTransactionNo_Interface`='" + WorkorderId + "' LIMIT 1;"));
//            //string  passwerdweb = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select lt.Password_web from f_ledgertransaction lt where lt.ledgertransactionID='"+labid+"' LIMIT 1;"));

//            Panel_Share ps = new Panel_Share();
//            JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(labid, tnx, con));
//            if (IPS.status == false)
//            {
//                tnx.Rollback();
//                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, IPS.response);

//            }

            // tnx.Commit();

            DataTable dtreturn = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
new MySqlParameter("@WorkOrderID", WorkorderId)).Tables[0];


            dynamic data = new JObject();
            if (dtreturn.Rows.Count > 0 && dtreturn != null)
            {
				data.Status=true;
                data.age = bd.age;
                data.code = "200";
                data.gender = bd.gender;
                data.Message = "Success";
                data.patientId = bd.patientId;
                data.billId = WorkorderId;

              

                dynamic results = new JObject();
                data.reportDetails = new JArray();
                foreach (DataRow item in dtreturn.Rows)
                {
                    dynamic investigations = new JObject();
                    investigations.testAmount = item["testAmount"].ToString();
                    investigations.testCode = item["testCode"].ToString();
                    investigations.testCategory = item["testCategory"].ToString();
                    investigations.departmentName = item["departmentName"].ToString();
                    investigations.sampleId = item["sampleId"].ToString();
                    investigations.dictionaryId = 0;
                    investigations.testID = 0;
                    investigations.CentreReportId = Util.GetInt(item["CentreReportId"]);
                    investigations.integrationCode = "";
                    investigations.ledgertransactionno = item["ledgertransactionno"].ToString();
                   
                    investigations.testName = item["testName"].ToString();
                    data.reportDetails.Add(investigations);
                }
            }
            return new HttpResponseMessage { Content = new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json") };

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            err.Add("status", false);
            err.Add("data", ex.ToString());
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, ex.ToString());
        }
        finally
        {
            con.Close();
            con.Dispose();
            tnx.Dispose();
        }


    }
    public static string CreateMD5(string input)
    {
        // Use input string to calculate MD5 hash
        using (System.Security.Cryptography.MD5 md5 = System.Security.Cryptography.MD5.Create())
        {
            byte[] inputBytes = System.Text.Encoding.ASCII.GetBytes(input);
            byte[] hashBytes = md5.ComputeHash(inputBytes);

            // Convert the byte array to hexadecimal string
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < hashBytes.Length; i++)
            {
                sb.Append(hashBytes[i].ToString("X2"));
            }
            return sb.ToString();
        }
    }

}
