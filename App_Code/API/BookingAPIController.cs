using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Http;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;

[Route("api/[controller]/[action]")]
public class BookingAPIController : ApiController
{
    // GET api/<controller>
    [HttpPost]

    [Authorize]
    [ActionName("BookingAPI")]
    public HttpResponseMessage BookingAPI([FromBody]BookingAPIVM _BookingData)
    {
      
        HttpError err = new HttpError();
        err.Add("success", "false");
        try
        {
            if (_BookingData == null)
            {
                err.Add("message", "Invalid JSON Format");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);           
            }
            if (string.IsNullOrWhiteSpace(_BookingData.InterfaceClient))
            {               
                err.Add("message", "InterfaceClient can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            CreateFolder cf = new CreateFolder();
            cf.CreateNewFolder(JsonConvert.SerializeObject(_BookingData, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore }), "BookingAPI", Util.GetString(_BookingData.InterfaceClient));

            if (string.IsNullOrWhiteSpace(_BookingData.UserName))
            {
                err.Add("message", "UserName can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 

            }
            if (string.IsNullOrWhiteSpace(_BookingData.Password))
            {
                err.Add("message", "Password can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }


            if (string.IsNullOrWhiteSpace(_BookingData.CentreID_interface))
            {
                err.Add("message", "CentreID_interface can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (string.IsNullOrWhiteSpace(_BookingData.Type))
            {
                err.Add("message", "Type can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.Type.ToUpper() != "NEW" && _BookingData.Type.ToUpper() != "DELETE")
            {
                err.Add("message", "Invalid Type");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (string.IsNullOrWhiteSpace(_BookingData.WorkOrderID))
            {
                err.Add("message", "WorkOrderID can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.WorkOrderID.Length > 50)
            {
                err.Add("message", "WorkOrderID characters should not more than 50");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (string.IsNullOrWhiteSpace(_BookingData.Patient_ID))
            {
                err.Add("message", "Patient_ID can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.Patient_ID.Length > 15)
            {
                err.Add("message", "Patient_ID characters should not more than 15");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (string.IsNullOrWhiteSpace(_BookingData.Title))
            {
                err.Add("message", "Title can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.Title.Length > 10)
            {
                err.Add("message", "Title characters should not more than 10");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (string.IsNullOrWhiteSpace(_BookingData.PName))
            {
                err.Add("message", "PName can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.PName.Length > 100)
            {
                err.Add("message", "PName characters should not more than 100");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (!string.IsNullOrWhiteSpace(_BookingData.Address) && _BookingData.Address.Length > 150)
            {
                err.Add("message", "Address characters should not more than 150");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (!string.IsNullOrWhiteSpace(_BookingData.City) && _BookingData.City.Length > 35)
            {
                err.Add("message", "City characters should not more than 35");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (!string.IsNullOrWhiteSpace(_BookingData.State) && _BookingData.State.Length > 50)
            {
                err.Add("message", "State characters should not more than 50");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (!string.IsNullOrWhiteSpace(_BookingData.Country) && _BookingData.Country.Length > 50)
            {
                err.Add("message", "Country characters should not more than 50");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (string.IsNullOrWhiteSpace(_BookingData.DOB) && _BookingData.Type.ToUpper() == "NEW")
            {
                err.Add("message", "DOB can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.Type.ToUpper() == "NEW")
            {
                DateTime _DateOfBirth;
                try
                {
                    _DateOfBirth = Util.GetDateTime(_BookingData.DOB);
                }
                catch
                {
                    err.Add("message", "Invalid DOB");
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 

                }
                if (_DateOfBirth.Date > System.DateTime.Now.Date)
                {
                    err.Add("message", "DOB can't be greater than current date");
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                }
                if (_DateOfBirth.Date < DateTime.Now.Date.AddYears(-110))
                {
                    err.Add("message", "DOB can't be greater than 110 Years");
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                }
            }

            if (string.IsNullOrWhiteSpace(_BookingData.Gender) && _BookingData.Type.ToUpper() == "NEW")
            {
                err.Add("message", "Gender can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.Gender.ToUpper() != "MALE" && _BookingData.Gender.ToUpper() != "FEMALE" && _BookingData.Type.ToUpper() == "NEW")
            {
                err.Add("message", "Invalid Gender");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.isUrgent != "0" && _BookingData.isUrgent != "1")
            {
                err.Add("message", "Invalid isUrgent");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (string.IsNullOrWhiteSpace(_BookingData.Doctor_ID) && _BookingData.Type.ToUpper() == "NEW")
            {
                err.Add("message", "Doctor_ID can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            long num1;
            if (!string.IsNullOrWhiteSpace(_BookingData.Doctor_ID) && !long.TryParse(_BookingData.Doctor_ID, out num1))
            {
                err.Add("message", "Invalid Doctor_ID");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }

            if (string.IsNullOrWhiteSpace(_BookingData.DoctorName) && _BookingData.Type.ToUpper() == "NEW")
            {
                err.Add("message", "DoctorName can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.DoctorName.Length > 100 && _BookingData.Type.ToUpper() == "NEW")
            {
                err.Add("message", "DoctorName characters should not more than 50");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.tests.Where(c => string.IsNullOrWhiteSpace(c.ItemId_interface)).Count() > 0)
            {
                err.Add("message", "ItemId_interface can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.tests.Where(x => x.ItemId_interface.Length > 50).ToList().Count() > 0)
            {
                err.Add("message", "ItemId_interface characters should not more than 50");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.tests.Where(c => string.IsNullOrWhiteSpace(c.ItemName_interface)).Count() > 0)
            {
                err.Add("message", "ItemName_interface can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.tests.Where(x => x.ItemName_interface.Length > 100).ToList().Count() > 0)
            {
                err.Add("message", "ItemName_interface characters should not more than 100");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.tests.Where(c => !string.IsNullOrWhiteSpace(c.BarcodeNo)).Where(x => x.BarcodeNo.Length > 15).ToList().Count() > 0)
            {
                err.Add("message", "BarcodeNo characters should not more than 15");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            DateTime date;
            if (_BookingData.tests.Where(c => !string.IsNullOrWhiteSpace(c.SampleCollectionDate)).Where(myRow => !DateTime.TryParse(myRow.SampleCollectionDate, out date)).Count() > 0)
            {
                err.Add("message", "Invalid SampleCollectionDate");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }

            if (_BookingData.tests.Where(c => !string.IsNullOrWhiteSpace(c.PackageName) && string.IsNullOrWhiteSpace(c.Interface_PackageCategoryID)).Count() > 0)
            {
                err.Add("message", "Interface_PackageCategoryID can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.tests.Where(c => string.IsNullOrWhiteSpace(c.PackageName) && !string.IsNullOrWhiteSpace(c.Interface_PackageCategoryID)).Count() > 0)
            {
                err.Add("message", "PackageName can't be blank");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.tests.Where(c => !string.IsNullOrWhiteSpace(c.PackageName)).Where(x => x.PackageName.Length > 100).ToList().Count() > 0)
            {
                err.Add("message", "PackageName characters should not more than 100");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.tests.Where(c => !string.IsNullOrWhiteSpace(c.SampleTypeID)).Where(x => x.SampleTypeID.Length > 50).ToList().Count() > 0)
            {
                err.Add("message", "SampleTypeID characters should not more than 50");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.tests.Where(c => !string.IsNullOrWhiteSpace(c.SampleTypeName)).Where(x => x.SampleTypeName.Length > 100).ToList().Count() > 0)
            {
                err.Add("message", "SampleTypeName characters should not more than 100");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.tests.Where(c => !string.IsNullOrWhiteSpace(c.Interface_PackageCategoryID)).Where(x => x.Interface_PackageCategoryID.Length > 10).ToList().Count() > 0)
            {
                err.Add("message", "Interface_PackageCategoryID characters should not more than 10");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            decimal patientRate;
            if (_BookingData.tests.Where(c => !string.IsNullOrWhiteSpace(c.ClientPatientRate)).Where(myRow => !decimal.TryParse(Util.GetString(myRow.ClientPatientRate), out patientRate)).Count() > 0)
            {
                err.Add("message", "Invalid ClientPatientRate Data Type");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (_BookingData.tests.Where(c => !string.IsNullOrWhiteSpace(c.ClientPatientRate)).Where(myRow => (myRow.ClientPatientRate.ToString().Split('.').Count() > 1 ? myRow.ClientPatientRate.ToString().Split('.').ToList().ElementAt(1).Length : 0) > 2).Count() > 0)
            {
                err.Add("message", "Two digits after a decimal number allow in ClientPatientRate");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }



            if (!string.IsNullOrWhiteSpace(_BookingData.Pincode) && !long.TryParse(_BookingData.Pincode, out num1))
            {
                err.Add("message", "Invalid Pincode");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }

            //to check pincode length
            if (!string.IsNullOrWhiteSpace(_BookingData.Pincode) && _BookingData.Pincode.Length > 6)
            {
                err.Add("message", "Invalid Pincode");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }


            if (!string.IsNullOrWhiteSpace(_BookingData.Mobile) && !long.TryParse(_BookingData.Mobile, out num1))
            {
                err.Add("message", "Invalid Mobile");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            //To Check Mobile Length
            if (!string.IsNullOrWhiteSpace(_BookingData.Mobile) && _BookingData.Mobile.Length > 10)
            {
                err.Add("message", "Invalid Mobile No.");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (!string.IsNullOrWhiteSpace(_BookingData.Interface_Doctor_Mobile) && _BookingData.Interface_Doctor_Mobile.Length > 10)
            {
                err.Add("message", "Invalid Interface_Doctor_Mobile");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }

            if (string.IsNullOrWhiteSpace(_BookingData.DOB) && _BookingData.Type.ToUpper() == "NEW" && !DateTime.TryParse(_BookingData.DOB, out date))
            {
                err.Add("message", "Invalid DOB");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (string.IsNullOrWhiteSpace(_BookingData.DOB) && _BookingData.Type.ToUpper() == "NEW" && Util.GetDateTime(_BookingData.DOB) > DateTime.Now)
            {
                err.Add("message", "DOB can't be greater than current date");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            // Regex regex = new Regex(@"^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$");

            if (!string.IsNullOrWhiteSpace(_BookingData.Email) && !Regex.IsMatch(_BookingData.Email.Trim(), @"^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$"))
            {
                err.Add("message", "Invalid Email");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }

            if (!string.IsNullOrWhiteSpace(_BookingData.Email) && _BookingData.Email.Length > 100)
            {
                err.Add("message", "Email characters should not more than 100");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (!string.IsNullOrWhiteSpace(_BookingData.HLMPatientType) && _BookingData.HLMPatientType.Length > 10 && _BookingData.Type.ToUpper() == "NEW")
            {
                err.Add("message", "HLMPatientType characters should not more than 10");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (!string.IsNullOrWhiteSpace(_BookingData.HLMOPDIPDNo) && _BookingData.HLMOPDIPDNo.Length > 20 && _BookingData.Type.ToUpper() == "NEW")
            {
                err.Add("message", "HLMOPDIPDNo characters should not more than 20");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (!string.IsNullOrWhiteSpace(_BookingData.TPA_Name) && _BookingData.TPA_Name.Length > 100)
            {
                err.Add("message", "TPA_Name characters should not more than 100");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (!string.IsNullOrWhiteSpace(_BookingData.TechnicalRemarks) && _BookingData.TechnicalRemarks.Length > 200)
            {
                err.Add("message", "TechnicalRemarks characters should not more than 200");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (!string.IsNullOrWhiteSpace(_BookingData.Employee_id) && _BookingData.Employee_id.Length > 50)
            {
                err.Add("message", "Employee_id characters should not more than 50");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }
            if (!string.IsNullOrWhiteSpace(_BookingData.BillNo) && _BookingData.BillNo.Length > 25)
            {
                err.Add("message", "BillNo characters should not more than 25");
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
            }

            var distinctTest = _BookingData.tests.GroupBy(r1 => new
            {
                ItemId_interface = r1.ItemId_interface

            }).Where(gr => gr.Count() > 1).Select(g => g.Key).ToList();

            if (distinctTest.Count() > 0)
            {
                err.Add("message", string.Concat("Duplicate ItemId_interface Found ", string.Join("  ,", String.Join(",", distinctTest.Select(s => string.Concat(s.ItemId_interface))))));
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 

            }

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                string _CentreID = string.Empty;
                string _Panel_ID = string.Empty;
                string _Interface_CompanyID = string.Empty;

                StringBuilder sb = new StringBuilder();

                if (AllLoad_Data.validateAPIUserNamePassword(_BookingData.UserName, _BookingData.Password, _BookingData.InterfaceClient, con) == 0)
                {
                    err.Add("message", "Invalid UserName or Password");
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                }

                int barcodeRequired = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_interface_company_master WHERE CompanyName=@CompanyName AND IsBarcodeRequired=1",
                                                              new MySqlParameter("@CompanyName", _BookingData.InterfaceClient)));
                if (barcodeRequired > 0)
                {
                    if (_BookingData.tests.Where(c => string.IsNullOrWhiteSpace(c.BarcodeNo)).ToList().Count() > 0)
                    {
                        err.Add("message", "BarcodeNo can't be blank");
                        return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                    }
                }

                string interfaceData = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(IsWorkOrderIDCreate,'#',`IsPatientIDCreate`,'#',AllowPrint,'#',IsBarcodeRequired,'#',ItemID_AsItdose,'#',ID) FROM f_interface_company_master WHERE companyname=@Interface_companyName ",
                                                                  new MySqlParameter("@Interface_companyName", _BookingData.InterfaceClient)));
                if (string.IsNullOrWhiteSpace(interfaceData))
                {
                    err.Add("message", "Invalid Interface_companyName");
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                }
                string patient_idcreate = interfaceData.Split('#')[1];
                string workorder_idcreate = interfaceData.Split('#')[0];
                int checkAllowPrint = Util.GetInt(interfaceData.Split('#')[2]);
                int IsBarcodeRequired = Util.GetInt(interfaceData.Split('#')[3]);
                int ItemID_AsItdose = Util.GetInt(interfaceData.Split('#')[4]);
                int Interface_CompanyID = Util.GetInt(interfaceData.Split('#')[5]);

                var ItemId_interface = String.Join(",", _BookingData.tests.Select(s => s.ItemId_interface).ToList());
                string[] ItemIDTags = ItemId_interface.Split(',');
                string[] ItemIDParamNames = ItemIDTags.Select(
                  (s, i) => "@tag" + i).ToArray();
                string ItemIDClause = string.Join(", ", ItemIDParamNames);
                List<TestDetail> TD = new List<TestDetail>();

                if (ItemID_AsItdose == 1)
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT ItemID FROM f_itemmaster WHERE ItemID IN({0}) AND IsActive=1 ", ItemIDClause), con))
                    {

                        for (int i = 0; i < ItemIDParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(ItemIDParamNames[i], ItemIDTags[i]);
                        }
                        DataTable dt = new DataTable();
                        using (dt as IDisposable)
                        {
                            da.Fill(dt);
                            TD = (from DataRow row in dt.Rows
                                  select new TestDetail
                                  {
                                      ItemID = row["ItemID"].ToString()
                                  }).ToList();

                            var ExceptItemDetail = _BookingData.tests.Select(s => s.ItemId_interface).Except(TD.Select(s => s.ItemID), StringComparer.OrdinalIgnoreCase).ToList();
                            if (ExceptItemDetail.Count > 0)
                            {
                                err.Add("message", string.Concat("ItemId_interface not Found ", String.Join(",", ExceptItemDetail.ToArray())));
                                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                            }
                        }
                    }
                }
                else
                {
                    using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format("SELECT ItemId_Interface,ItemID FROM f_itemmaster_interface WHERE ItemId_Interface IN({0}) AND IsActive=1 AND Interface_CompanyID=@Interface_CompanyID", ItemIDClause), con))
                    {
                        da.SelectCommand.Parameters.AddWithValue("@Interface_CompanyID", Interface_CompanyID);
                        for (int i = 0; i < ItemIDParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(ItemIDParamNames[i], ItemIDTags[i]);
                        }
                        DataTable dt = new DataTable();
                        using (dt as IDisposable)
                        {
                            da.Fill(dt);
                            TD = (from DataRow row in dt.Rows
                                  select new TestDetail
                                  {
                                      ItemID = row["ItemID"].ToString(),
                                      ItemId_Interface = row["ItemId_Interface"].ToString()
                                  }).ToList();


                            var ExceptItemDetail = _BookingData.tests.Select(s => s.ItemId_interface).Except(TD.Select(s => s.ItemID), StringComparer.OrdinalIgnoreCase).ToList();
                            if (ExceptItemDetail.Count > 0)
                            {
                                err.Add("message", string.Concat("ItemId_interface not Found ", String.Join(",", ExceptItemDetail.ToArray())));
                                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                            }
                            // HashSet<string> sentIDs = new HashSet<string>(_BookingData.tests.Select(s => s.ItemId_interface));
                            //  itemDetail.Where(m => !sentIDs.Contains(m.ItemID)).ToList();

                        }
                    }
                }

                string _Flag = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(`CentreID`,'#',`Panel_id`,'#',Interface_CompanyID) FROM `centre_master_interface` WHERE `CentreID_interface`=@CentreID_interface  AND `Interface_CompanyID`=@Interface_CompanyID ;",
                                                          new MySqlParameter("@CentreID_interface", _BookingData.CentreID_interface),
                                                          new MySqlParameter("@Interface_CompanyID", Interface_CompanyID)));

                if (string.IsNullOrWhiteSpace(_Flag))
                {
                    err.Add("message", "Invalid InterfaceClient or CentreID");
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                }
                _CentreID = _Flag.Split('#')[0];
                _Panel_ID = _Flag.Split('#')[1];
                _Interface_CompanyID = _Flag.Split('#')[2];


                int AllowPrint = 0;
                if (checkAllowPrint == 1)
                {
                    if (string.IsNullOrWhiteSpace(_BookingData.AllowPrint) && _BookingData.Type.ToUpper() == "NEW")
                    {
                        err.Add("message", "AllowPrint can't be blank");
                        return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                    }
                    if (_BookingData.AllowPrint != "0" && _BookingData.AllowPrint != "1" && _BookingData.Type.ToUpper() == "NEW")
                    {
                        err.Add("message", "Invalid AllowPrint");
                        return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                    }
                    AllowPrint = Util.GetInt(_BookingData.AllowPrint);
                }
                else
                    AllowPrint = 1;
                foreach (BookingTest t in _BookingData.tests)
                {
                    if (_BookingData.Type.ToUpper() == "NEW")
                    {
                        if (Util.GetString(t.BarcodeNo).Trim() != string.Empty)
                        {
                            int duplicateBarcode = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT COUNT(1) FROM booking_data bd WHERE bd.WorkOrderID!=@WorkOrderID AND bd.BarcodeNo=@BarcodeNo  AND bd.Type='New' ",
                                                                           new MySqlParameter("@WorkOrderID", _BookingData.WorkOrderID),
                                                                           new MySqlParameter("@BarcodeNo", t.BarcodeNo)));

                            if (duplicateBarcode > 0)
                            {
                                err.Add("message", string.Concat("Duplicate Barcode found"));
                                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                            }

                            sb = new StringBuilder();
                            sb.Append(" SELECT COUNT(1) FROM f_ledgertransaction lt ");
                            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.LedgerTransactionID=plo.LedgerTransactionID  ");
                            sb.Append(" WHERE lt.LedgerTransactionNo_Interface!=@WorkOrderID ");
                            sb.Append(" AND plo.BarcodeNo=@BarcodeNo  ");
                            duplicateBarcode = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                                                                       new MySqlParameter("@WorkOrderID", _BookingData.WorkOrderID),
                                                                       new MySqlParameter("@BarcodeNo", t.BarcodeNo)));
                            if (duplicateBarcode > 0)
                            {
                                err.Add("message", string.Concat("Duplicate Barcode found"));
                                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                            }
                        }
                    }
                    if (_BookingData.Type.ToUpper() == "DELETE")
                    {
                        sb = new StringBuilder();
                        sb.Append(" SELECT COUNT(1) FROM booking_data ");
                        sb.Append(" WHERE WorkOrderID=@WorkOrderID AND ItemId_interface=@ItemId_interface AND Type='New' AND InterfaceClient=@InterfaceClient  ");
                        int deleteCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                                                                  new MySqlParameter("@ItemID_interface", t.ItemId_interface),
                                                                  new MySqlParameter("@WorkOrderID", _BookingData.WorkOrderID),
                                                                  new MySqlParameter("@InterfaceClient", _BookingData.InterfaceClient)));
                        if (deleteCount == 0)
                        {
                            err.Add("message", "ItemID_interface not found for this WorkOrderID");
                            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                        }
                        sb = new StringBuilder();
                        sb.Append(" SELECT COUNT(1) FROM booking_data ");
                        sb.Append(" WHERE WorkOrderID=@WorkOrderID AND ItemId_interface=@ItemId_interface AND Type='New' AND IsBooked=2 AND InterfaceClient=@InterfaceClient ");
                        deleteCount = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                                                              new MySqlParameter("@ItemID_interface", t.ItemId_interface),
                                                              new MySqlParameter("@WorkOrderID", _BookingData.WorkOrderID),
                                                              new MySqlParameter("@InterfaceClient", _BookingData.InterfaceClient)));
                        if (deleteCount > 0)
                        {
                            err.Add("message", "ItemID_interface already deleted for this WorkOrderID");
                            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                        }
                        sb = new StringBuilder();
                        sb.Append(" SELECT IFNULL(plo.IsSampleCollected,'')IsSampleCollected FROM f_ledgertransaction lt ");
                        sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.LedgerTransactionID=plo.LedgerTransactionID ");
                        sb.Append(" WHERE lt.LedgerTransactionNo_Interface=@WorkOrderID AND plo.ItemID_Interface=@ItemId_interface ");
                        sb.Append(" AND lt.Interface_companyName=@Interface_companyName ");
                        string IsSampleCollected = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                                                                              new MySqlParameter("@ItemID_interface", t.ItemId_interface),
                                                                              new MySqlParameter("@WorkOrderID", _BookingData.WorkOrderID),
                                                                              new MySqlParameter("@Interface_companyName", _BookingData.InterfaceClient)));
                        if (IsSampleCollected == "Y" && IsSampleCollected != "")
                        {
                            err.Add("message", string.Concat("Sample already collected for ItemId_interface ", t.ItemId_interface));
                            return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err); 
                        }
                    }
                }
                MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                try
                {
                    sb = new StringBuilder();
                    sb.Append("INSERT INTO `booking_data`(InterfaceClientID,`InterfaceClient`,`Type`,`CentreID_Interface`,`WorkOrderID`,WorkOrderID_Create,`Patient_ID`,Patient_ID_create,");
                    sb.Append(" `Title`,`PName`,`Address`,`City`,`State`,`Pincode`,`Country`,`Mobile`,`Email`,AgeYear,AgeMonth,AgeDays,`Age`,DOB,`Gender`,`Doctor_ID`,");
                    sb.Append(" `DoctorName`,`Interface_Doctor_Mobile`,HLMPatientType,HLMOPDIPDNo,BarcodeNo,`ItemId_interface`,`ItemName_interface`,`SampleCollectionDate`,");
                    sb.Append(" SampleTypeID,SampleTypeName,TPA_Name,Employee_id,PackageName,Interface_PackageCategoryID,TechnicalRemarks,Panel_ID,ItemID_AsItdose,");
                    sb.Append(" AllowPrint,checkAllowPrint,Interface_BillNo,ClientPatientRate,CentreID,ItemID_Itdose)");
                    sb.Append(" VALUES (@InterfaceClientID,@InterfaceClient,@Type,@CentreID_Interface,@WorkOrderID,@WorkOrderID_Create,@Patient_ID,@Patient_ID_create,");
                    sb.Append(" @Title,@PName,@Address,@City,@State,@Pincode,@Country,@Mobile,@Email,@AgeYear,@AgeMonth,@AgeDays,@Age,@DOB,@Gender,@Doctor_ID,");
                    sb.Append(" @DoctorName,@Interface_Doctor_Mobile,@HLMPatientType,@HLMOPDIPDNo,@BarcodeNo,@ItemId_interface,@ItemName_interface,@SampleCollectionDate,");
                    sb.Append(" @SampleTypeID,@SampleTypeName,@TPA_Name,@Employee_id,@PackageName,@Interface_PackageCategoryID,@TechnicalRemarks,@Panel_ID,@ItemID_AsItdose,");
                    sb.Append(" @AllowPrint,@checkAllowPrint,@Interface_BillNo,@ClientPatientRate,@CentreID,@ItemID_Itdose);");



                    using (MySqlCommand cmd = new MySqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.Transaction = tnx;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = sb.ToString();

                        var age = string.Empty; var TotalAgeInDays = 0; var IsDOBActual = 0; var AgeYear = 0; var AgeMonth = 0; var AgeDay = 0;
                        cmd.Parameters.Add(new MySqlParameter("@InterfaceClientID", _Interface_CompanyID));
                        cmd.Parameters.Add(new MySqlParameter("@InterfaceClient", _BookingData.InterfaceClient));
                        cmd.Parameters.Add(new MySqlParameter("@Type", _BookingData.Type));
                        cmd.Parameters.Add(new MySqlParameter("@CentreID_Interface", _BookingData.CentreID_interface));
                        cmd.Parameters.Add(new MySqlParameter("@WorkOrderID", _BookingData.WorkOrderID));
                        cmd.Parameters.Add(new MySqlParameter("@WorkOrderID_Create", workorder_idcreate));
                        cmd.Parameters.Add(new MySqlParameter("@Patient_ID", _BookingData.Patient_ID));
                        cmd.Parameters.Add(new MySqlParameter("@Patient_ID_create", patient_idcreate));
                        cmd.Parameters.Add(new MySqlParameter("@Title", _BookingData.Title));
                        cmd.Parameters.Add(new MySqlParameter("@PName", _BookingData.PName));
                        cmd.Parameters.Add(new MySqlParameter("@Address", _BookingData.Address));
                        cmd.Parameters.Add(new MySqlParameter("@City", _BookingData.City));
                        cmd.Parameters.Add(new MySqlParameter("@State", _BookingData.State));
                        cmd.Parameters.Add(new MySqlParameter("@Pincode", _BookingData.Pincode == null ? 0 : Util.GetInt(_BookingData.Pincode)));
                        cmd.Parameters.Add(new MySqlParameter("@Country", _BookingData.Country));
                        cmd.Parameters.Add(new MySqlParameter("@Mobile", _BookingData.Mobile));
                        cmd.Parameters.Add(new MySqlParameter("@Email", _BookingData.Email));
                        cmd.Parameters.Add(new MySqlParameter("@DOB", Util.GetDateTime(_BookingData.DOB).ToString("yyyy-MM-dd")));

                        TimeSpan ts = DateTime.Now - Convert.ToDateTime(_BookingData.DOB);
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
                        cmd.Parameters.Add(new MySqlParameter("@Gender", string.Concat(_BookingData.Gender.First().ToString().ToUpper(), _BookingData.Gender.Substring(1))));
                        cmd.Parameters.Add(new MySqlParameter("@isUrgent", _BookingData.isUrgent));
                        cmd.Parameters.Add(new MySqlParameter("@Doctor_ID", _BookingData.Doctor_ID));
                        cmd.Parameters.Add(new MySqlParameter("@DoctorName", _BookingData.DoctorName));
                        cmd.Parameters.Add(new MySqlParameter("@Interface_Doctor_Mobile", _BookingData.Interface_Doctor_Mobile));
                        cmd.Parameters.Add(new MySqlParameter("@HLMPatientType", _BookingData.HLMPatientType));
                        cmd.Parameters.Add(new MySqlParameter("@HLMOPDIPDNo", _BookingData.HLMOPDIPDNo));

                        cmd.Parameters.Add(new MySqlParameter("@TPA_Name", _BookingData.TPA_Name));
                        cmd.Parameters.Add(new MySqlParameter("@Employee_id", _BookingData.Employee_id));
                        cmd.Parameters.Add(new MySqlParameter("@TechnicalRemarks", _BookingData.TechnicalRemarks));
                        cmd.Parameters.Add(new MySqlParameter("@Panel_ID", _Panel_ID));
                        cmd.Parameters.Add(new MySqlParameter("@ItemID_AsItdose", ItemID_AsItdose));
                        cmd.Parameters.Add(new MySqlParameter("@AllowPrint", AllowPrint));
                        cmd.Parameters.Add(new MySqlParameter("@checkAllowPrint", checkAllowPrint));
                        cmd.Parameters.Add(new MySqlParameter("@Interface_BillNo", Util.GetString(_BookingData.BillNo)));
                        cmd.Parameters.Add(new MySqlParameter("@CentreID", _CentreID));

                        foreach (BookingTest t in _BookingData.tests)
                        {
                            if (t.ItemId_interface != string.Empty && t.ItemName_interface != string.Empty)
                            {
                                cmd.Parameters.Add(new MySqlParameter("@ItemId_interface", t.ItemId_interface));
                                cmd.Parameters.Add(new MySqlParameter("@ItemName_interface", t.ItemName_interface));
                                cmd.Parameters.Add(new MySqlParameter("@BarcodeNo", t.BarcodeNo));
                                cmd.Parameters.Add(new MySqlParameter("@SampleCollectionDate", DateTime.ParseExact(t.SampleCollectionDate, "dd-MMM-yyyy HH:mm:ss", CultureInfo.InstalledUICulture, DateTimeStyles.None)));
                                cmd.Parameters.Add(new MySqlParameter("@SampleTypeID", t.SampleTypeID));
                                cmd.Parameters.Add(new MySqlParameter("@SampleTypeName", t.SampleTypeName));
                                cmd.Parameters.Add(new MySqlParameter("@PackageName", t.PackageName));
                                cmd.Parameters.Add(new MySqlParameter("@Interface_PackageCategoryID", t.Interface_PackageCategoryID));
                                cmd.Parameters.Add(new MySqlParameter("@ClientPatientRate", Util.GetDecimal(t.ClientPatientRate)));
                                if (ItemID_AsItdose == 1)
                                {
                                    cmd.Parameters.Add(new MySqlParameter("@ItemID_Itdose", t.ItemId_interface));
                                }
                                else
                                {
                                    var ItemIDDetails = TD.Where(P => P.ItemId_Interface.ToLower() == t.ItemId_interface.ToLower()).Select(P => P.ItemID).ToList();
                                    cmd.Parameters.Add(new MySqlParameter("@ItemID_Itdose", ItemIDDetails[0].ToString()));
                                }

                                cmd.ExecuteNonQuery();
                                cmd.Parameters.RemoveAt("@ItemId_interface");
                                cmd.Parameters.RemoveAt("@ItemName_interface");
                                cmd.Parameters.RemoveAt("@BarcodeNo");
                                cmd.Parameters.RemoveAt("@SampleCollectionDate");
                                cmd.Parameters.RemoveAt("@SampleTypeID");
                                cmd.Parameters.RemoveAt("@SampleTypeName");
                                cmd.Parameters.RemoveAt("@PackageName");
                                cmd.Parameters.RemoveAt("@Interface_PackageCategoryID");
                                cmd.Parameters.RemoveAt("@ClientPatientRate");
                                cmd.Parameters.RemoveAt("@ItemID_Itdose");

                                if (_BookingData.Type.ToUpper() == "DELETE")
                                {
                                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE booking_data SET IsBooked=2,Response='Item Deleted' WHERE ItemID_Interface=@ItemID_Interface AND InterfaceClient=@InterfaceClient AND WorkOrderID=@WorkOrderID AND Type='New' ",
                                                new MySqlParameter("@ItemID_Interface", t.ItemId_interface),
                                                new MySqlParameter("@InterfaceClient", _BookingData.InterfaceClient),
                                                new MySqlParameter("@WorkOrderID", _BookingData.WorkOrderID));
                                }
                            }
                        }
                    }
                    tnx.Commit();
                    sb.Clear();
                    err.Clear();
                    err.Add("success", "true");
                    err.Add("message", "Data Transferred Successfully");
                    return Request.CreateResponse(HttpStatusCode.OK, err);
                    
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    tnx.Rollback();
                    err.Add("message", ex.GetBaseException().Message);
                    return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
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
                err.Add("message", ex.GetBaseException().Message);
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, err);
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
    public class TestDetail
    {
        public string ItemId_Interface { get; set; }
        public string ItemID { get; set; }
    }
}