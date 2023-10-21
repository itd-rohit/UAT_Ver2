using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

[Route("api/[controller]/[action]")]
public class B2BPatientRegistrationAPIController : ApiController
{
    // GET api/<controller>
    [HttpPost]
    [ActionName("GetPanel")]
    public HttpResponseMessage GetPanel([FromBody]B2BPatientRegistrationVM _data)
    {

        HttpError err = new HttpError();
        err.Add("success", "false");
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
            }

            if (string.IsNullOrWhiteSpace(_data.EmployeeId))
            {
                err.Add("message", "EmployeeId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
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
                                err.Add("success", "true");
                                err.Add("data", JArray.FromObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
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
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }

    }


    [HttpPost]
    [ActionName("GetCenter")]
    public HttpResponseMessage GetCenter([FromBody]B2BPatientRegistrationVM _data)
    {

        HttpError err = new HttpError();
        err.Add("success", "false");
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

                        if (string.IsNullOrWhiteSpace(_data.EmployeeId))
                        {
                            sb.AppendLine(" SELECT CentreID,Centre AS NAME,Mobile,Email,Address, IF(BarcodeType='0','PatientWise','SampleTypeWise') AS BarcodeType FROM  `centre_master` WHERE IsActive=1 order by Centre;  ");
                        }
                        else
                        {
                            if (_data.EmployeeId.Contains("LSHHI"))
                            {
                                sb.AppendLine(@" SELECT cm.CentreID,cm.Centre AS NAME,cm.Mobile,cm.Email,cm.Address, IF(cm.BarcodeType='0','PatientWise','SampleTypeWise') AS BarcodeType 
                                     FROM  `centre_master` cm INNER JOIN f_login fl ON fl.CentreID=cm.`CentreID` WHERE cm.IsActive=1 ");
                                sb.AppendLine(" AND fl.`EmployeeID`= @Id  GROUP BY cm.`CentreID`;");
                            }
                            else
                            {
                                sb.AppendLine(" SELECT CentreID,Centre AS NAME,Mobile,Email,Address,IF(BarcodeType='0','PatientWise','SampleTypeWise') AS BarcodeType FROM  `centre_master` WHERE IsActive=1 AND CentreID= @Id ");
                            }
                        }


                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@Id", Util.GetString(_data.Id))
                            ).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("success", "true");
                                err.Add("data", Newtonsoft.Json.JsonConvert.SerializeObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
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
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }

    }


    [HttpPost]
    [ActionName("GetDoctor")]
    public HttpResponseMessage GetDoctor([FromBody]B2BPatientRegistrationVM _data)
    {

        HttpError err = new HttpError();
        err.Add("success", "false");
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

                        sb.Append("SELECT DISTINCT  Doctor_ID,NAME FROM doctor_master WHERE IsActive = 1 ORDER BY NAME ");
                        sb.Append(" UNION ALL ");
                        sb.Append("SELECT 'Other Doctor' as NAME, 0  as Employee_ID  ");

                        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
                        {
                            if (dt.Rows.Count > 0)
                            {
                                err.Clear();
                                err.Add("success", "true");
                                err.Add("data", Newtonsoft.Json.JsonConvert.SerializeObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
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
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }

    }


    [HttpPost]
    [ActionName("GetPackage")]
    public HttpResponseMessage GetPackage([FromBody]B2BPatientRegistrationVM _data)
    {

        HttpError err = new HttpError();
        err.Add("success", "false");
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PanelId))
            {
                err.Add("message", "PanelId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
            }



            using (MySqlConnection con = Util.GetMySqlCon())
            {
                con.Open();
                try
                {
                    using (MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable))
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append(@" SELECT im.itemid typeid,rl.Rate,REPLACE(im.TypeName,',',' ') AS Item,
                        (SELECT GROUP_CONCAT(pl.investigationID) FROM package_labdetail pl WHERE pl.plabID=im.Type_ID)investigationID, 
                        (SELECT GROUP_CONCAT(DISTINCT `SampleTypeName`) FROM `investigations_sampletype` ist 
                        INNER JOIN `package_labdetail` pld ON pld.`InvestigationID`=ist.`Investigation_ID`
                        WHERE pld.`PlabID`=im.`Type_ID`) SampleType, 
                        IF(IFNULL(im.`Inv_ShortName`,'')<>'',IFNULL(im.`Inv_ShortName`,''),'') AS ShortName ,sm.`Name` AS SubCategory  
                        FROM f_itemmaster im   
                        INNER JOIN f_subcategorymaster sm ON sm.subcategoryid = im.subcategoryid  AND sm.CategoryID='LSHHI44'  AND im.IsActive=1 ");
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
                                err.Add("success", "true");
                                err.Add("data", Newtonsoft.Json.JsonConvert.SerializeObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
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
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }

    }


    [HttpPost]
    [ActionName("GetAllTest")]
    public HttpResponseMessage GetAllTest([FromBody]B2BPatientRegistrationVM _data)
    {

        HttpError err = new HttpError();
        err.Add("success", "false");
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PanelId))
            {
                err.Add("message", "PanelId can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
            }

            if (string.IsNullOrWhiteSpace(_data.PageNo))
            {
                err.Add("message", "PageNo can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
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
                                err.Add("success", "true");
                                err.Add("data", Newtonsoft.Json.JsonConvert.SerializeObject(dt));
                                return Request.CreateResponse(HttpStatusCode.OK, err);

                            }
                            else
                            {
                                err.Add("message", "No data Found");
                                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
                            }
                        }


                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
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
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }

    }


    [HttpPost]
    [ActionName("GetSampleTypeBy")]
    public HttpResponseMessage GetSampleTypeBy([FromBody]B2BPatientRegistrationVM _data)
    {

        HttpError err = new HttpError();
        err.Add("success", "false");
        try
        {
            if (_data == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
            }

            if (string.IsNullOrWhiteSpace(_data.Investigation))
            {
                err.Add("message", "Investigation can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
            }



            using (MySqlConnection con = Util.GetMySqlCon())
            {
               
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
                        con.Open();
                        da.SelectCommand = cmd;
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            err.Clear();
                            err.Add("success", "true");
                            err.Add("data", Newtonsoft.Json.JsonConvert.SerializeObject(dt));
                            return Request.CreateResponse(HttpStatusCode.OK, err);

                        }
                        else
                        {
                            err.Add("message", "No data Found");
                            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
                        }

                    }
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
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
            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
        }

    }

    public class ValidationActionFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(HttpActionContext actionContext)
        {
            var modelState = actionContext.ModelState;

            if (!modelState.IsValid)
            {
                actionContext.Response = actionContext.Request
                     .CreateErrorResponse(HttpStatusCode.BadRequest, modelState);
            }
        }
    }

}