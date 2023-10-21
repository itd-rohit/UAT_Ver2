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
using System.Text.RegularExpressions;
using System.Web.Http;
[Route("api/[controller]/[action]")]
public class UpdateBookingAPIController : ApiController
{
    [HttpPost]
    [ActionName("UpdateBookingAPI")]
    public OrderResponse UpdateBookingAPI(JObject _BookingData)
    {
        OrderResponse res = new OrderResponse();
        res.success = "false";
        try
        {
            UpdateBookingAPIVM BookingDataList = JsonConvert.DeserializeObject<UpdateBookingAPIVM>(_BookingData.ToString());
            if (BookingDataList == null)
            {
                res.message = "Invalid JSON Format";
                return res;
            }
            if (string.IsNullOrWhiteSpace(BookingDataList.InterfaceClient))
            {
                res.message = "InterfaceClient can't be blank";
                return res;
            }
            CreateFolder cf = new CreateFolder();
            cf.CreateNewFolder(_BookingData.ToString(), "UpdateBookingAPI", Util.GetString(BookingDataList.InterfaceClient));

            if (string.IsNullOrWhiteSpace(BookingDataList.UserName))
            {
                res.message = "UserName can't be blank";
                return res;
            }
            if (string.IsNullOrWhiteSpace(BookingDataList.Password))
            {
                res.message = "Password can't be blank";
                return res;
            }
            if (string.IsNullOrWhiteSpace(BookingDataList.CentreID_interface))
            {
                res.message = "CentreID_interface can't be blank";
                return res;
            }
            if (string.IsNullOrWhiteSpace(BookingDataList.Patient_ID))
            {
                res.message = "Patient_ID can't be blank";
                return res;
            }
            if (BookingDataList.Patient_ID.Length > 15)
            {
                res.message = "Patient_ID characters should not more than 15";
                return res;
            }
            if (string.IsNullOrWhiteSpace(BookingDataList.Title))
            {
                res.message = "Title can't be blank";
                return res;
            }
            if (BookingDataList.Title.Length > 10)
            {
                res.message = "Title characters should not more than 10";
                return res;
            }
            if (string.IsNullOrWhiteSpace(BookingDataList.PName))
            {
                res.message = "PName can't be blank";
                return res;
            }
            if (BookingDataList.PName.Length > 100)
            {
                res.message = "PName characters should not more than 100";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.Address) && BookingDataList.Address.Length > 150)
            {
                res.message = "Address characters should not more than 150";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.City) && BookingDataList.City.Length > 35)
            {
                res.message = "City characters should not more than 35";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.State) && BookingDataList.State.Length > 50)
            {
                res.message = "State characters should not more than 50";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.Country) && BookingDataList.Country.Length > 50)
            {
                res.message = "Country characters should not more than 50";
                return res;
            }
            long num1;
            if (!string.IsNullOrWhiteSpace(BookingDataList.Pincode) && !long.TryParse(BookingDataList.Pincode, out num1))
            {
                res.message = "Invalid Pincode";
                return res;
            }
            //to check pincode length
            if (!string.IsNullOrWhiteSpace(BookingDataList.Pincode) && BookingDataList.Pincode.Length > 6)
            {
                res.message = "Invalid Pincode";
                return res;
            }
            if (string.IsNullOrWhiteSpace(BookingDataList.DOB))
            {
                res.message = "DOB can't be blank";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.Mobile) && !long.TryParse(BookingDataList.Mobile, out num1))
            {
                res.message = "Invalid Mobile";
                return res;
            }
            //To Check Mobile Length
            if (!string.IsNullOrWhiteSpace(BookingDataList.Mobile) && BookingDataList.Mobile.Length > 10)
            {
                res.message = "Invalid Mobile No.";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.Email) && !Regex.IsMatch(BookingDataList.Email.Trim(), @"^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$"))
            {
                res.message = "Invalid Email";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.Email) && BookingDataList.Email.Length > 100)
            {
                res.message = "Email characters should not more than 100";
                return res;
            }
            DateTime _DateOfBirth;
            try
            {
                _DateOfBirth = Util.GetDateTime(BookingDataList.DOB);
            }
            catch
            {
                res.message = "Invalid DOB";
                return res;
            }
            if (_DateOfBirth.Date > System.DateTime.Now.Date)
            {
                res.message = "DOB can't be greater than current date";
                return res;
            }
            if (_DateOfBirth.Date < DateTime.Now.Date.AddYears(-110))
            {
                res.message = "DOB can't be greater than 110 Years";
                return res;
            }
            if (string.IsNullOrWhiteSpace(BookingDataList.Gender))
            {
                res.message = "Gender can't be blank";
                return res;
            }
            if (BookingDataList.Gender.ToUpper() != "MALE" && BookingDataList.Gender.ToUpper() != "FEMALE")
            {
                res.message = "Invalid Gender";
                return res;
            }
            if (string.IsNullOrWhiteSpace(BookingDataList.Doctor_ID))
            {
                res.message = "Doctor_ID can't be blank";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.Doctor_ID) && !long.TryParse(BookingDataList.Doctor_ID, out num1))
            {
                res.message = "Invalid Doctor_ID";
                return res;
            }
            if (string.IsNullOrWhiteSpace(BookingDataList.DoctorName))
            {
                res.message = "DoctorName can't be blank";
                return res;
            }
            if (BookingDataList.DoctorName.Length > 100)
            {
                res.message = "DoctorName characters should not more than 50";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.HLMPatientType) && BookingDataList.HLMPatientType.Length > 10)
            {
                res.message = "HLMPatientType characters should not more than 10";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.HLMOPDIPDNo) && BookingDataList.HLMOPDIPDNo.Length > 20)
            {
                res.message = "HLMOPDIPDNo characters should not more than 20";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.TPA_Name) && BookingDataList.TPA_Name.Length > 100)
            {
                res.message = "TPA_Name characters should not more than 100";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.Employee_id) && BookingDataList.Employee_id.Length > 50)
            {
                res.message = "Employee_id characters should not more than 50";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.TechnicalRemarks) && BookingDataList.TechnicalRemarks.Length > 200)
            {
                res.message = "TechnicalRemarks characters should not more than 200";
                return res;
            }
            if (!string.IsNullOrWhiteSpace(BookingDataList.Interface_Doctor_Mobile) && BookingDataList.Interface_Doctor_Mobile.Length > 10)
            {
                res.message = "Invalid Interface_Doctor_Mobile";
                return res;
            }
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                string _CentreID = string.Empty;
                string _Panel_ID = string.Empty;
                string _Interface_CompanyID = string.Empty;


                if (AllLoad_Data.validateAPIUserNamePassword(BookingDataList.UserName, BookingDataList.Password, BookingDataList.InterfaceClient, con) == 0)
                {
                    res.message = "Invalid UserName or Password";
                    return res;
                }
                string interfaceData = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(ID,'#',IsPatientIDCreate)ID FROM f_interface_company_master WHERE companyname=@Interface_companyName ",
                                                                  new MySqlParameter("@Interface_companyName", BookingDataList.InterfaceClient)));
                if (string.IsNullOrWhiteSpace(interfaceData))
                {
                    res.message = "Invalid Interface_companyName";
                    return res;
                }

                int Interface_CompanyID = Util.GetInt(interfaceData.Split('#')[0]);
                int patient_idcreate = Util.GetInt(interfaceData.Split('#')[1]);
                string _Flag = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(`CentreID`,'#',`Panel_id`,'#',Interface_CompanyID) FROM `centre_master_interface` WHERE `CentreID_interface`=@CentreID_interface  AND `Interface_CompanyID`=@Interface_CompanyID ;",
                                                          new MySqlParameter("@CentreID_interface", BookingDataList.CentreID_interface),
                                                          new MySqlParameter("@Interface_CompanyID", Interface_CompanyID)));

                if (string.IsNullOrWhiteSpace(_Flag))
                {
                    res.message = "Invalid InterfaceClient or CentreID";
                    return res;
                }

                _CentreID = _Flag.Split('#')[0];
                _Panel_ID = _Flag.Split('#')[1];
                StringBuilder sb = new StringBuilder();
                sb = new StringBuilder();
                sb.Append(" SELECT LastUpdatedData,Patient_ID,Title,PName,House_No,Locality,City,Pincode,State,Country,Phone,Mobile,Email,DOB,Gender ");
                sb.Append("  FROM patient_master WHERE if(patient_idcreate=1,Patient_ID_interface=@Patient_ID,Patient_ID=@Patient_ID) ");
                if (patient_idcreate == 1)
                    sb.Append(" Patient_ID_interface=@Patient_ID ");
                else
                    sb.Append(" Patient_ID=@Patient_ID ");
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@Patient_ID", Util.GetString(BookingDataList.Patient_ID))).Tables[0])
                {

                    if (dt.Rows.Count > 0)
                    {
                        if (
                            (Util.GetString(BookingDataList.PName).ToLower() != Util.GetString(dt.Rows[0]["PName"]).ToLower()) &&
                            (Util.GetString(BookingDataList.Gender).ToLower() != Util.GetString(dt.Rows[0]["Gender"]).ToLower()))
                        {
                            res.message = "Can't change PName with Gender together";
                            return res;
                        }
                        else if (
                             (Util.GetString(BookingDataList.PName).ToLower() != Util.GetString(dt.Rows[0]["PName"]).ToLower()) &&
                             (Util.GetString(BookingDataList.DOB).ToLower() != Util.GetString(dt.Rows[0]["DOB"]).ToLower()))
                        {
                            res.message = "Can't change PName with DOB together";
                            return res;
                        }
                        else if (Util.GetString(dt.Rows[0]["LastUpdatedData"]).Trim() != string.Empty)
                        {
                            string[] WhichColumnPrevUpdated = Util.GetString(dt.Rows[0]["LastUpdatedData"]).Trim().Split(',');
                            if (WhichColumnPrevUpdated.Length > 0 && (Util.GetString(BookingDataList.PName).ToLower() != Util.GetString(dt.Rows[0]["PName"]).ToLower()) && Array.IndexOf(WhichColumnPrevUpdated, "DOB") > 0)
                            {
                                res.message = "Can't change PName bcz DOB is already changed";
                                return res;
                            }
                            else if (WhichColumnPrevUpdated.Length > 0 && (Util.GetString(BookingDataList.DOB).ToLower() != Util.GetString(dt.Rows[0]["DOB"]).ToLower()) && Array.IndexOf(WhichColumnPrevUpdated, "PName") > 0)
                            {
                                res.message = "Can't change DOB bcz PName is already changed";
                                return res;
                            }
                            else if (WhichColumnPrevUpdated.Length > 0 && (Util.GetString(BookingDataList.Gender).ToLower() != Util.GetString(dt.Rows[0]["Gender"]).ToLower()) && Array.IndexOf(WhichColumnPrevUpdated, "PName") > 0)
                            {
                                res.message = "Can't change Gender bcz PName is already changed";
                                return res;
                            }
                            else if (WhichColumnPrevUpdated.Length > 0 && (Util.GetString(BookingDataList.PName).ToLower() != Util.GetString(dt.Rows[0]["PName"]).ToLower()) && Array.IndexOf(WhichColumnPrevUpdated, "Gender") > 0)
                            {
                                res.message = "Can't change PName bcz Gender is already changed";
                                return res;
                            }
                        }
                    }
                }
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO `booking_data_update_patient_details`(InterfaceClientID,`InterfaceClient`,`CentreID_Interface`,`Patient_ID`,`Title`,`PName`,`Address`,`City`, ");
                    sb.Append(" `State`,`Pincode`,`Country`,`Mobile`,`Email`,AgeYear,AgeMonth,AgeDays,`Age`,DOB,`Gender`,`Doctor_ID`,`DoctorName`,");
                    sb.Append(" `Interface_Doctor_Mobile`,HLMPatientType,HLMOPDIPDNo,TPA_Name,Employee_id,TechnicalRemarks,TotalAgeInDays) ");
                    sb.Append(" VALUES (@InterfaceClientID,@InterfaceClient,@CentreID_Interface,@Patient_ID,@Title,@PName,@Address,@City,");
                    sb.Append(" @State,@Pincode,@Country,@Mobile,@Email,@AgeYear,@AgeMonth,@AgeDays,@Age,@DOB,@Gender,@Doctor_ID,@DoctorName, ");
                    sb.Append(" @Interface_Doctor_Mobile,@HLMPatientType,@HLMOPDIPDNo,@TPA_Name,@Employee_id,@TechnicalRemarks,@TotalAgeInDays);");
                    using (MySqlCommand cmd = new MySqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.Transaction = tnx;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = sb.ToString();

                        var age = string.Empty; var TotalAgeInDays = 0; var IsDOBActual = 0; var AgeYear = 0; var AgeMonth = 0; var AgeDay = 0;
                        cmd.Parameters.Add(new MySqlParameter("@InterfaceClientID", _Interface_CompanyID));
                        cmd.Parameters.Add(new MySqlParameter("@InterfaceClient", BookingDataList.InterfaceClient));
                        cmd.Parameters.Add(new MySqlParameter("@CentreID_Interface", BookingDataList.CentreID_interface));
                        cmd.Parameters.Add(new MySqlParameter("@Patient_ID", BookingDataList.Patient_ID));
                        cmd.Parameters.Add(new MySqlParameter("@Title", BookingDataList.Title));
                        cmd.Parameters.Add(new MySqlParameter("@PName", BookingDataList.PName));
                        cmd.Parameters.Add(new MySqlParameter("@Address", BookingDataList.Address));
                        cmd.Parameters.Add(new MySqlParameter("@City", BookingDataList.City));
                        cmd.Parameters.Add(new MySqlParameter("@State", BookingDataList.State));
                        cmd.Parameters.Add(new MySqlParameter("@Pincode", BookingDataList.Pincode == null ? 0 : Util.GetInt(BookingDataList.Pincode)));
                        cmd.Parameters.Add(new MySqlParameter("@Country", BookingDataList.Country));
                        cmd.Parameters.Add(new MySqlParameter("@Mobile", BookingDataList.Mobile));
                        cmd.Parameters.Add(new MySqlParameter("@Email", BookingDataList.Email));
                        cmd.Parameters.Add(new MySqlParameter("@DOB", Util.GetDateTime(BookingDataList.DOB).ToString("yyyy-MM-dd")));

                        TimeSpan ts = DateTime.Now - Convert.ToDateTime(BookingDataList.DOB);
                        DateTime Age = DateTime.MinValue.AddDays(ts.Days);
                        age = string.Concat(Age.Year - 1, " Y ", Age.Month - 1, " M ", Age.Day - 1, " D");
                        TotalAgeInDays = Util.GetInt((Age.Year - 1) * 365 + (Age.Month - 1) * 30 + (Age.Day - 1));
                        AgeYear = Age.Year - 1;
                        AgeMonth = Age.Month - 1;
                        AgeDay = Age.Day - 1;
                        IsDOBActual = 1;

                        cmd.Parameters.Add(new MySqlParameter("@Age", age));
                        cmd.Parameters.Add(new MySqlParameter("@AgeYear", AgeYear));
                        cmd.Parameters.Add(new MySqlParameter("@AgeMonth", AgeMonth));
                        cmd.Parameters.Add(new MySqlParameter("@AgeDays", AgeDay));
                        cmd.Parameters.Add(new MySqlParameter("@Gender", string.Concat(BookingDataList.Gender.First().ToString().ToUpper(), BookingDataList.Gender.Substring(1))));
                        cmd.Parameters.Add(new MySqlParameter("@Doctor_ID", BookingDataList.Doctor_ID));
                        cmd.Parameters.Add(new MySqlParameter("@DoctorName", BookingDataList.DoctorName));
                        cmd.Parameters.Add(new MySqlParameter("@Interface_Doctor_Mobile", BookingDataList.Interface_Doctor_Mobile));
                        cmd.Parameters.Add(new MySqlParameter("@HLMPatientType", BookingDataList.HLMPatientType));
                        cmd.Parameters.Add(new MySqlParameter("@HLMOPDIPDNo", BookingDataList.HLMOPDIPDNo));
                        cmd.Parameters.Add(new MySqlParameter("@TPA_Name", BookingDataList.TPA_Name));
                        cmd.Parameters.Add(new MySqlParameter("@Employee_id", BookingDataList.Employee_id));
                        cmd.Parameters.Add(new MySqlParameter("@TechnicalRemarks", BookingDataList.TechnicalRemarks));
                        cmd.Parameters.Add(new MySqlParameter("@TotalAgeInDays", TotalAgeInDays));
                        cmd.ExecuteNonQuery();
                    }
                    tnx.Commit();
                    sb.Clear();
                    res.success = "true";
                    res.message = "Data Transferred Successfully";
                    return res;
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    res.message = ex.GetBaseException().Message;
                    return res;
                }
                finally
                {
                    tnx.Dispose();
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                res.message = ex.GetBaseException().Message;
                return res;
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
            res.message = ex.GetBaseException().Message;
            return res;
        }
        finally
        {

        }
    }
}
