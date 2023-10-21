<%@ WebService Language="C#" Class="InterfaceBooking" %>

using System;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
// To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
// [System.Web.Script.Services.ScriptService]
public class InterfaceBooking : System.Web.Services.WebService
{

    [WebMethod]
    public string HelloWorld()
    {
        return "Hello World";
    }
    [WebMethod]
    public string booking()
    {
        InstaTransaction();
        return string.Empty;
    }
    public static int EmployeeID = 896;
    public static string EmployeeName = "Interface Booking";
    public static int RoleID = 9;
    public string InstaTransaction(string OptionSinNo = "")
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();


        string PatientID = string.Empty;
        try
        {
            byte ReVisit = 0;
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT  ");
            sb.Append(" Interface_Doctor_Mobile,Interface_Referal_MobileNo,Interface_Presc_Doctor_Mobile,Interface_PackageCategoryID,Interface_TPAID,Interface_SampleTypeID, ");
            sb.Append(" TechnicalRemarks,TPA_Name,Employee_id,PackageName,ID,InterfaceClientID,InterfaceClient,Type,WorkOrderID,WorkOrderID_Create,UniqueID,Patient_ID,Patient_ID_create,Title,PName,Address,localityID,Locality,cityID,City,stateID,State,PinCode,Country,Phone,Mobile, ");
            sb.Append(" Email,DOB,Age,AgeYear,AgeMonth,AgeDays,Gender,CentreID_Interface,VIP,isUrgent,Panel_ID,Doctor_ID,DoctorName,HLMPatientType,HLMOPDIPDNo,");
            sb.Append(" bed_type,ward_name,BarcodeNo,ItemId_interface,ItemName_interface,ItemID_AsItdose,SampleCollectionDate,SampleTypeID,SampleTypeName,");
            sb.Append(" IsBooked,dtAccepted,0 LedgerTransactionID,'' LedgerTransactionNo,AllowPrint,checkAllowPrint,Interface_BillNo,ClientPatientRate,CentreID ");
            sb.Append(" ");
            sb.Append(" ");
            sb.Append(" FROM booking_data ");
            sb.Append(" WHERE   `EntryDateTime` > DATE_ADD(NOW(), INTERVAL -7 DAY) AND if(IsBooked=-1, (Response !='Duplicate Entry' and Response !='Item ID Not Found in Package' AND Response !='Item ID Not Found'), IsBooked=0) ");

            if (OptionSinNo.Trim() != string.Empty)
            {
                sb.Append(" AND barcodeno=@barcodeno");
            }
            sb.Append(" Limit 1000 ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                       new MySqlParameter("@barcodeno", OptionSinNo.Trim())).Tables[0];
            if (dt.Rows.Count > 0)
            {
                for (int s = 0; s < dt.Rows.Count; s++)
                {
                    MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

                    int centreID = Util.GetInt(dt.Rows[s]["CentreID"].ToString());
                    int isError = 0;
                    if (dt.Rows[s]["Type"].ToString().ToUpper() == "NEW")
                    {

                        DataTable dtDoctor = new DataTable(); ;

                        if (Util.GetString(dt.Rows[s]["Doctor_ID"]) != string.Empty && dt.Rows[s]["Doctor_ID"].ToString() != "0")
                        {
                            string Interface_doctor_mobile = "";
                            if (Util.GetString(dt.Rows[s]["Interface_doctor_mobile"]) != string.Empty)
                            {
                                Interface_doctor_mobile = Util.GetString(dt.Rows[s]["Interface_doctor_mobile"]);
                            }
                            else if (Util.GetString(dt.Rows[s]["Interface_Referal_MobileNo"]) != string.Empty)
                            {
                                Interface_doctor_mobile = Util.GetString(dt.Rows[s]["Interface_Referal_MobileNo"]);
                            }
                            dtDoctor = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, " SELECT `Doctor_ID`,`Title`,`Name`,Mobile FROM `doctor_referal` WHERE `Interface_CompanyID`=@Interface_CompanyID AND `DoctorID_Interface`=@DoctorID_Interface AND isActive=1 ",
                                                   new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString()),
                                                   new MySqlParameter("@DoctorID_Interface", dt.Rows[s]["Doctor_ID"].ToString())).Tables[0];

                            if (dtDoctor.Rows.Count == 0)
                            {
                                sb = new StringBuilder();
                                sb.Append("INSERT INTO `doctor_referal`(`DoctorCode`,`Title`,`Name`,`Mobile`,email,`Interface_companyName`,`DoctorID_Interface`,`IsVisible`,`IsActive`,Interface_CompanyID)");
                                sb.Append(" VALUES(@DoctorCode,'',@Name,@Mobile,'',@Interface_companyName,@DoctorID_Interface,1,1,@Interface_CompanyID)");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@DoctorCode", dt.Rows[s]["Doctor_ID"].ToString()),
                                            new MySqlParameter("@Name", dt.Rows[s]["DoctorName"].ToString()),
                                            new MySqlParameter("@Mobile", Interface_doctor_mobile),
                                            new MySqlParameter("@Interface_companyName", dt.Rows[s]["InterfaceClient"].ToString()),
                                            new MySqlParameter("@DoctorID_Interface", dt.Rows[s]["Doctor_ID"].ToString()),
                                            new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString()));

                                dtDoctor = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT `Doctor_ID`,`Title`,`Name` FROM `doctor_referal` WHERE `Interface_CompanyID`=@Interface_CompanyID AND `DoctorID_Interface`=@DoctorID_Interface AND isActive=1 ",
                                                       new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString()),
                                                       new MySqlParameter("@DoctorID_Interface", dt.Rows[s]["Doctor_ID"].ToString())).Tables[0];

                            }
                            else if (Interface_doctor_mobile != string.Empty && Interface_doctor_mobile != Util.GetString(dtDoctor.Rows[0]["Mobile"]))
                            {

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referal SET Mobile=@Mobile WHERE  `Interface_CompanyID`=@Interface_CompanyID AND `DoctorID_Interface`=@DoctorID_Interface AND isActive=1  ",
                                            new MySqlParameter("@Mobile", Interface_doctor_mobile),
                                            new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString()),
                                            new MySqlParameter("@DoctorID_Interface", dt.Rows[s]["Doctor_ID"].ToString()));

                            }
                        }
                        string LedgerTransactionID = string.Empty;
                        string LedgerTransactionNo = string.Empty;
                        string LedgerTransactionNo_Interface = string.Empty;
                        string ItemID = string.Empty;
                        string WorkOrderIDSuffix = string.Empty;
                        DateTime BookingDate = DateTime.Now;
                        string IsSampleCollected = "S";
                        int checkHistoMicro = 0;
                        DataTable dt_sampleType = new DataTable();

                        int TotalAgeInDays = Util.GetInt(dt.Rows[s]["AgeYear"].ToString()) * 365 + Util.GetInt(dt.Rows[s]["AgeMonth"].ToString()) * 30 + Util.GetInt(dt.Rows[s]["AgeDays"].ToString());


                        string PanelRefCode = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(Company_Name,'#',ReferenceCodeOPD,'#',InvoiceTo,'#',IFNULL(SalesManager,0))Company_Name FROM f_panel_master WHERE Panel_ID=@Panel_ID ",
                                                                         new MySqlParameter("@Panel_ID", Util.GetInt(dt.Rows[s]["Panel_ID"].ToString()))));

                        DateTime billDate = DateTime.Now;
                        sb = new StringBuilder();
                        PatientID = string.Empty;
                        string retvalue = string.Empty;
                        sb = new StringBuilder();
                        sb.Append("SELECT CONCAT(LedgerTransactionID,'#',LedgerTransactionNo,'#',DATE_FORMAT(Date,'%d-%b-%Y %H:%i:%s'),'#',Patient_ID,'#',LedgerTransactionNo_Interface) FROM f_ledgertransaction  ");
                        if (Util.GetInt(dt.Rows[s]["WorkOrderID_Create"].ToString()) == 0)
                        {
                            sb.Append(" WHERE LedgerTransactionNo=@LedgerTransactionNo AND Interface_companyID = @Interface_companyID LIMIT 1 ");
                        }
                        else
                        {
                            sb.Append(" WHERE LedgerTransactionNo_Interface=@LedgerTransactionNo AND Interface_companyID = @Interface_companyID LIMIT 1 ");
                        }

                        retvalue = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                                                              new MySqlParameter("@LedgerTransactionNo", dt.Rows[s]["WorkOrderID"].ToString()),
                                                              new MySqlParameter("@Interface_companyID", dt.Rows[s]["InterfaceClientID"].ToString())));

                        if (retvalue != string.Empty)
                        {
                            PatientID = retvalue.Split('#')[3];
                        }

                        if (dt.Rows[s]["Patient_ID"].ToString() != string.Empty && dt.Rows[s]["Patient_ID"].ToString() != "0" && retvalue == string.Empty)
                        {
                            sb = new StringBuilder();
                            if (dt.Rows[s]["Patient_ID_create"].ToString() == "0")
                                sb.Append("SELECT Patient_ID FROM patient_master WHERE Patient_ID=@Patient_ID ");
                            else
                                sb.Append("SELECT Patient_ID FROM patient_master WHERE Patient_ID_Interface=@Patient_ID ");

                            PatientID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                                                                   new MySqlParameter("@Patient_ID", dt.Rows[s]["Patient_ID"].ToString())));
                        }

                        if (PatientID != string.Empty)
                        {
                            try
                            {
                                sb = new StringBuilder();
                                sb.Append(" UPDATE patient_master ");
                                sb.Append(" SET  ");
                                sb.Append(" Email = @Email,Age =@Age,AgeYear =@AgeYear,AgeMonth =@AgeMonth, AgeDays =@AgeDays,TotalAgeInDays =@TotalAgeInDays,DOB= @DOB, ");
                                sb.Append(" UpdateID = @UpdateID,UpdateName = @UpdateName,UpdateDate = NOW() ");
                                sb.Append(" WHERE Patient_ID = @Patient_ID;");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@Email", dt.Rows[s]["Email"].ToString()),
                                            new MySqlParameter("@Age", dt.Rows[s]["Age"].ToString()),
                                            new MySqlParameter("@AgeYear", dt.Rows[s]["AgeYear"].ToString()),
                                            new MySqlParameter("@AgeMonth", dt.Rows[s]["AgeMonth"].ToString()),
                                            new MySqlParameter("@AgeDays", dt.Rows[s]["AgeDays"].ToString()),
                                            new MySqlParameter("@TotalAgeInDays", TotalAgeInDays),
                                            new MySqlParameter("@DOB", Util.GetDateTime(dt.Rows[s]["DOB"].ToString()).ToString("yyyy-MM-dd")),
                                            new MySqlParameter("@UpdateID", Util.GetInt(EmployeeID)),
                                            new MySqlParameter("@UpdateName", Util.GetString(EmployeeName)),
                                            new MySqlParameter("@Patient_ID", PatientID));
                                ReVisit = 1;
                            }
                            catch (Exception ex)
                            {
                                isError = 1;
                                tnx.Rollback();
                                tnx.Dispose();
                                string Response = ex.ToString().Length > 200 ? ex.ToString().Substring(0, 200) : ex.ToString();
                                StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='" + Response + "' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                            }
                        }
                        else
                        {
                            try
                            {
                                Patient_Master objPM = new Patient_Master(tnx);
                                objPM.Title = dt.Rows[s]["Title"].ToString();
                                objPM.PName = dt.Rows[s]["PName"].ToString();
                                objPM.House_No = dt.Rows[s]["Address"].ToString();
                                objPM.Street_Name = string.Empty;
                                objPM.Locality = dt.Rows[s]["Locality"].ToString();
                                objPM.City = dt.Rows[s]["City"].ToString();
                                objPM.Pincode = Util.GetInt(dt.Rows[s]["PinCode"].ToString());
                                objPM.State = dt.Rows[s]["State"].ToString();
                                objPM.Country = dt.Rows[s]["Country"].ToString();
                                objPM.Phone = dt.Rows[s]["Phone"].ToString();
                                objPM.Mobile = dt.Rows[s]["Mobile"].ToString();
                                objPM.Email = dt.Rows[s]["Email"].ToString();
                                objPM.DOB = Util.GetDateTime(dt.Rows[s]["DOB"].ToString());
                                objPM.Age = dt.Rows[s]["Age"].ToString();
                                objPM.AgeYear = Util.GetInt(dt.Rows[s]["AgeYear"].ToString());
                                objPM.AgeMonth = Util.GetInt(dt.Rows[s]["AgeMonth"].ToString());
                                objPM.AgeDays = Util.GetInt(dt.Rows[s]["AgeDays"].ToString());
                                objPM.TotalAgeInDays = TotalAgeInDays;
                                objPM.Gender = dt.Rows[s]["Gender"].ToString();
                                objPM.CentreID = Util.GetInt(centreID);
                                objPM.StateID = Util.GetInt(dt.Rows[s]["stateID"].ToString());
                                objPM.CityID = Util.GetInt(dt.Rows[s]["cityID"].ToString());
                                objPM.LocalityID = Util.GetInt(dt.Rows[s]["localityID"].ToString());
                                objPM.UserID = EmployeeID;
                                objPM.Patient_ID_create = Util.GetInt(dt.Rows[s]["Patient_ID_create"].ToString());
                                objPM.Patient_ID_Interface = dt.Rows[s]["Patient_ID"].ToString();
                                objPM.IsAPIEntry = 1;
                                PatientID = objPM.Insert();
                            }
                            catch (Exception ex)
                            {
                                isError = 1;
                                tnx.Rollback();
                                tnx.Dispose();
                                string Response = ex.ToString().Length > 200 ? ex.ToString().Substring(0, 200) : ex.ToString();
                                StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='" + Response + "' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                            }
                        }
                        if (isError == 0)
                        {
                            sb = new StringBuilder();
                            if (Util.GetInt(dt.Rows[s]["ItemID_AsItdose"].ToString()) == 0)
                            {
                                ItemID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ItemID FROM f_itemmaster_interface WHERE ItemID_interface=@ItemID_interface AND Interface_CompanyID=@Interface_CompanyID AND isActive=1 ",
                                                                    new MySqlParameter("@ItemID_interface", dt.Rows[s]["ItemId_interface"].ToString()),
                                                                    new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString())));
                            }
                            else
                            {
                                ItemID = dt.Rows[s]["ItemId_interface"].ToString();
                            }
                            if (retvalue != string.Empty)
                            {
                                LedgerTransactionID = retvalue.Split('#')[0];
                                LedgerTransactionNo = retvalue.Split('#')[1];
                                BookingDate = Util.GetDateTime(retvalue.Split('#')[2]);
                                LedgerTransactionNo_Interface = retvalue.Split('#')[4];

                                string sampleType = string.Empty;
                                int itemCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_OPD plo  WHERE plo.`LedgerTransactionNo_Interface`=@LedgerTransactionNo_Interface AND ItemID=@ItemID AND  UniqueID=@UniqueID AND plo.`Interface_CompanyID`=@Interface_CompanyID ",
                                                                        new MySqlParameter("@LedgerTransactionNo_Interface", dt.Rows[s]["WorkOrderID"].ToString()),
                                                                        new MySqlParameter("@ItemID", ItemID),
                                                                        new MySqlParameter("@UniqueID", dt.Rows[s]["UniqueID"].ToString()),
                                                                        new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString())));
                                if (itemCount > 0)
                                {
                                    tnx.Commit();
                                    tnx.Dispose();
                                    StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='Duplicate Entry' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                                    continue;
                                }
                                else
                                {
                                    itemCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_OPD plo  WHERE plo.`LedgerTransactionNo_Interface`=@LedgerTransactionNo_Interface  AND plo.ItemID=@ItemID AND plo.`Interface_CompanyID`=@Interface_CompanyID ",
                                                                        new MySqlParameter("@LedgerTransactionNo_Interface", LedgerTransactionNo),
                                                                        new MySqlParameter("@ItemID", ItemID),
                                                                        new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString())));
                                    if (itemCount > 0)
                                    {
                                        if (itemCount > 26)
                                        {
                                            WorkOrderIDSuffix = "A" + Util.GetString((char)(64 + (itemCount - 26)));
                                        }
                                        else
                                        {
                                            WorkOrderIDSuffix = Util.GetString((char)(64 + itemCount));
                                        }
                                        if (Util.GetInt(dt.Rows[s]["WorkOrderID_Create"].ToString()) == 0)
                                        {
                                            sb = new StringBuilder();
                                            sb.Append("SELECT CONCAT(LedgerTransactionID,'#',LedgerTransactionNo,'#',DATE_FORMAT(Date,'%d-%b-%Y %H:%i:%s'),'#',Patient_ID,'#',LedgerTransactionNo_Interface) FROM f_ledgertransaction  ");
                                            sb.Append(" WHERE LedgerTransactionNo=@LedgerTransactionNo LIMIT 1 ");
                                            retvalue = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                                                                                  new MySqlParameter("@LedgerTransactionNo", dt.Rows[s]["WorkOrderID"].ToString() + WorkOrderIDSuffix.Trim())));
                                        }
                                        else
                                        {
                                            retvalue = string.Empty;
                                        }
                                    }
                                }
                            }
                            if (retvalue == string.Empty)
                            {
                                try
                                {
                                    int AllowPrint = Util.GetInt(dt.Rows[s]["AllowPrint"].ToString());
                                    if (Util.GetInt(dt.Rows[s]["checkAllowPrint"].ToString()) == 1)
                                    {
                                        sb = new StringBuilder();
                                        sb.Append(" SELECT AllowPrint FROM Booking_data_allowPrint WHERE IsProcess=0 AND InterfaceClientID=@InterfaceClientID ");
                                        sb.Append(" AND WorkOrderID=@WorkOrderID ORDER BY CreatedDate DESC LIMIT 1 ");
                                        using (DataTable dtAllowPrint = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                                                    new MySqlParameter("@InterfaceClientID", dt.Rows[s]["InterfaceClientID"].ToString()),
                                                                                    new MySqlParameter("@WorkOrderID", dt.Rows[s]["WorkOrderID"].ToString())).Tables[0])
                                        {
                                            if (dtAllowPrint.Rows.Count > 0)
                                            {
                                                AllowPrint = Util.GetInt(dtAllowPrint.Rows[0]["AllowPrint"].ToString());
                                            }
                                        }
                                    }

                                    Ledger_Transaction objlt = new Ledger_Transaction(tnx);
                                    objlt.DiscountOnTotal = 0;
                                    objlt.NetAmount = 0;
                                    objlt.GrossAmount = 0;
                                    objlt.IsCredit = 1;
                                    objlt.Patient_ID = PatientID;
                                    objlt.PName = string.Concat(dt.Rows[s]["Title"].ToString(), dt.Rows[s]["PName"].ToString().ToUpper());
                                    objlt.Age = dt.Rows[s]["Age"].ToString();
                                    objlt.Gender = dt.Rows[s]["Gender"].ToString();
                                    objlt.VIP = Util.GetByte(dt.Rows[s]["VIP"].ToString());
                                    objlt.Remarks = "Interface Data";
                                    objlt.Panel_ID = Util.GetInt(dt.Rows[s]["Panel_ID"].ToString());
                                    objlt.PanelName = PanelRefCode.Split('#')[0];

                                    if (Util.GetString(dt.Rows[s]["Doctor_ID"]) != string.Empty && dt.Rows[s]["Doctor_ID"].ToString() != "0")
                                    {
                                        objlt.Doctor_ID = dtDoctor.Rows[0]["Doctor_ID"].ToString();
                                        objlt.DoctorName = dtDoctor.Rows[0]["Name"].ToString();
                                    }
                                    else
                                    {
                                        objlt.Doctor_ID = "2";
                                        objlt.DoctorName = dt.Rows[s]["DoctorName"].ToString();
                                    }

                                    objlt.CentreID = Util.GetInt(centreID);
                                    objlt.Adjustment = 0;
                                    objlt.CreatedByID = EmployeeID;
                                    objlt.HomeVisitBoyID = string.Empty;
                                    objlt.PatientIDProof = string.Empty;
                                    objlt.PatientIDProofNo = string.Empty;
                                    objlt.PatientSource = string.Empty;
                                    objlt.PatientType = string.Empty;
                                    objlt.VisitType = "Centre Visit";
                                    objlt.HLMPatientType = dt.Rows[s]["HLMPatientType"].ToString();
                                    objlt.HLMOPDIPDNo = dt.Rows[s]["HLMOPDIPDNo"].ToString();
                                    objlt.DiscountReason = string.Empty;
                                    objlt.DiscountApprovedByID = 0;
                                    objlt.DiscountApprovedByName = string.Empty;
                                    objlt.CorporateIDCard = string.Empty;
                                    objlt.CorporateIDType = string.Empty;
                                    objlt.AttachedFileName = string.Empty;
                                    objlt.ReVisit = ReVisit;
                                    objlt.CreatedBy = EmployeeName;
                                    objlt.WorkOrderID_Create = Util.GetByte(dt.Rows[s]["WorkOrderID_Create"].ToString());
                                    objlt.WorkOrderID = dt.Rows[s]["WorkOrderID"].ToString();
                                    objlt.WorkOrderIDSuffix = WorkOrderIDSuffix;
                                    objlt.Interface_CompanyID = Util.GetInt(dt.Rows[s]["InterfaceClientID"].ToString());
                                    objlt.Interface_companyName = dt.Rows[s]["InterfaceClient"].ToString();
                                    objlt.OtherReferLab = dt.Rows[s]["TPA_Name"].ToString().Trim();
                                    objlt.CorporateIDCard = dt.Rows[s]["Employee_id"].ToString().Trim();
                                    objlt.Interface_TPAID = Util.GetString(dt.Rows[s]["Interface_TPAID"]).Trim();
                                    objlt.AllowPrint = Util.GetByte(AllowPrint);
                                    objlt.checkAllowPrint = Util.GetByte(dt.Rows[s]["checkAllowPrint"]);
                                    objlt.Interface_BillNo = Util.GetString(dt.Rows[s]["Interface_BillNo"]);
                                    objlt.InvoiceToPanelId = Util.GetInt(PanelRefCode.Split('#')[2]);
                                    objlt.SalesTagEmployee = Util.GetInt(PanelRefCode.Split('#')[3]);
                                    objlt.IsAPIEntry = 1;
                                    objlt.BillDate = billDate;
                                    retvalue = objlt.Insert();
                                    string EmployeeList = string.Empty;
                                    if (retvalue == string.Empty)
                                    {
                                        isError = 1;
                                        tnx.Rollback();
                                        tnx.Dispose();
                                        StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='LT Insert Error' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                                    }
                                    if (isError == 0)
                                    {
                                        if (Util.GetInt(PanelRefCode.Split('#')[3]) != 0)
                                            EmployeeList = AllLoad_Data.getSalesChildNode(con, Util.GetInt(PanelRefCode.Split('#')[3]));

                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO f_ledgertransaction_Sales(LedgerTransactionID,LedgerTransactionNo,Sales,CreatedDate) ");
                                        sb.Append(" VALUES(@LedgerTransactionID,@LedgerTransactionNo,@Sales,@CreatedDate)");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                                    new MySqlParameter("@LedgerTransactionID", retvalue.Split('#')[0]),
                                                                    new MySqlParameter("@LedgerTransactionNo", retvalue.Split('#')[1]),
                                                                    new MySqlParameter("@Sales", EmployeeList),
                                                                    new MySqlParameter("@CreatedDate", billDate));
                                    }

                                }
                                catch (Exception ex)
                                {
                                    isError = 1;
                                    tnx.Rollback();
                                    tnx.Dispose();
                                    string Response = ex.ToString().Length > 200 ? ex.ToString().Substring(0, 200) : ex.ToString();
                                    StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='" + Response + "' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                                }

                            }
                            if (isError == 0)
                            {
                                LedgerTransactionID = retvalue.Split('#')[0];
                                LedgerTransactionNo = retvalue.Split('#')[1];
                                LedgerTransactionNo_Interface = retvalue.Split('#')[4];
                                string sampleType = string.Empty;

                                string billNo = string.Empty;
                                sb = new StringBuilder();
                                sb.Append("SELECT IFNULL(BillNo,'')BillNo FROM patient_labinvestigation_opd  WHERE IsActive=1 AND LedgerTransactionID=@LedgerTransactionID  ");
                                sb.Append(" AND BillType='Credit-Test Add' AND DATE>=CONCAT(CURRENT_DATE(),' ','00:00:00') AND DATE<=CONCAT(CURRENT_DATE() ,' ','23:59:59') ");
                                billNo = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                                                                    new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)));

                                if (billNo == string.Empty)
                                {
                                    billNo = AllLoad_Data.getBillNo(Util.GetInt(centreID), "B", con, tnx);
                                    if (billNo == string.Empty)
                                    {
                                        isError = 1;
                                        tnx.Rollback();
                                        tnx.Dispose();
                                        StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='Bill Generation Error' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");

                                    }
                                }
                                if (isError == 0)
                                {
                                    string SubCategoryID = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT SubCategoryID FROM f_itemmaster WHERE ItemID=@ItemID ",
                                                                                      new MySqlParameter("@ItemID", ItemID)));

                                    sb = new StringBuilder();
                                    sb.Append(" SELECT im.SubCategoryID,im.ItemID,im.TypeName,CONCAT(im.TestCode,'~',im.TypeName)ItemName, ");
                                    sb.Append(" im.TestCode,imm.`Investigation_Id`,imm.Name InvestigationName,imm.Reporting,imm.ReportType, ");
                                    sb.Append("  IFNULL(Get_DeliveryDate_client(@centreID,imm.Investigation_ID,NOW(),@isUrgent),'01-Jan-0001 12:00 AM#01-Jan-0001 12:00 AM')DeliveryDate,sub.Name SubcategoryName ");
                                    sb.Append(" FROM f_itemmaster im ");
                                    sb.Append(" INNER JOIN `f_subcategorymaster` sub on sub.`SubCategoryID`=im.`SubCategoryID`");
                                    if (SubCategoryID == "15")
                                    {
                                        sb.Append(" INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID ");
                                        sb.Append(" INNER JOIN investigation_master imm ON pld.`InvestigationID`=imm.`Investigation_Id`  ");
                                    }
                                    else
                                    {
                                        sb.Append(" INNER JOIN investigation_master imm ON im.`Type_ID`=imm.`Investigation_Id` ");
                                    }
                                    sb.Append(" WHERE im.ItemID=@ItemID AND im.IsActive=1 ");
                                    if (SubCategoryID == "15")
                                        sb.Append(" GROUP BY im.ItemID ");
                                    DataTable ItemData = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                                     new MySqlParameter("@ItemID", ItemID),
                                                                     new MySqlParameter("@centreID", Util.GetInt(centreID)),
                                                                     new MySqlParameter("@isUrgent", Util.GetInt(dt.Rows[s]["isUrgent"].ToString()))).Tables[0];

                                    if (ItemData.Rows.Count > 0)
                                    {
                                        string ID = "";
                                        Patient_Lab_InvestigationOPD objPlo = new Patient_Lab_InvestigationOPD(tnx);
                                        try
                                        {
                                            string Barcode_new = string.Empty;
                                            if (ItemData.Rows[0]["SubCategoryID"].ToString() == "15")
                                            {
                                                IsSampleCollected = "N";
                                            }
                                            else
                                            {
                                                checkHistoMicro = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM `investigation_master` WHERE investigation_id=@investigation_id AND  (`container`=7 OR `isCulture`=1)",
                                                                                          new MySqlParameter("@investigation_id", ItemData.Rows[0]["Investigation_ID"].ToString())));
                                                if (checkHistoMicro > 0)
                                                {
                                                    Barcode_new = dt.Rows[s]["BarcodeNo"].ToString();
                                                    IsSampleCollected = "N";
                                                }
                                                else
                                                {
                                                    dt_sampleType = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(ist.`SampleTypeID`,'#',ist.SampleTypeName)SampleTypeID FROM `investigations_sampletype` ist WHERE `Investigation_Id`=@investigation_id  ",
                                                                                new MySqlParameter("@investigation_id", ItemData.Rows[0]["Investigation_ID"].ToString())).Tables[0];

                                                    if (dt_sampleType.Rows.Count == 1)
                                                    {
                                                        sampleType = dt_sampleType.Rows[0]["SampleTypeID"].ToString();
                                                    }
                                                    if (dt.Rows[s]["BarcodeNo"].ToString() == string.Empty)
                                                    {
                                                        Barcode_new = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT barcodeno FROM `patient_labinvestigation_opd` WHERE LedgerTransactionID = @LedgerTransactionID AND SampleTypeID=@SampleTypeID AND SubCategoryID=@SubCategoryID",
                                                                                                 new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                                                                                 new MySqlParameter("@SampleTypeID", dt_sampleType.Rows[0]["SampleTypeID"].ToString().Split('#')[0]),
                                                                                                 new MySqlParameter("@SubCategoryID", ItemData.Rows[0]["SubCategoryID"].ToString())));

                                                        if (Barcode_new.Trim() == string.Empty)
                                                        {
                                                            Barcode_new = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_barcode(@SubCategoryID)",
                                                                                      new MySqlParameter("@SubCategoryID", ItemData.Rows[0]["SubCategoryID"].ToString())).ToString();
                                                        }
                                                        IsSampleCollected = "N";
                                                    }
                                                    else
                                                    {
                                                        Barcode_new = dt.Rows[s]["BarcodeNo"].ToString();
                                                        if (dt_sampleType.Rows.Count != 1)
                                                        {
                                                            IsSampleCollected = "N";
                                                        }
                                                        else
                                                        {
                                                            sampleType = dt_sampleType.Rows[0]["SampleTypeID"].ToString();
                                                            IsSampleCollected = "S";
                                                        }
                                                    }
                                                }
                                            }
                                            objPlo.LedgerTransactionID = Util.GetInt(LedgerTransactionID);
                                            objPlo.LedgerTransactionNo = LedgerTransactionNo;
                                            objPlo.Patient_ID = PatientID;
                                            objPlo.AgeInDays = Util.GetInt(TotalAgeInDays);
                                            objPlo.Gender = dt.Rows[s]["Gender"].ToString();


                                            objPlo.ItemId = Util.GetInt(ItemData.Rows[0]["ItemID"].ToString());
                                            objPlo.ItemCode = ItemData.Rows[0]["TestCode"].ToString();
                                            objPlo.ItemName = ItemData.Rows[0]["ItemName"].ToString().ToUpper();


                                            if (ItemData.Rows[0]["SubCategoryID"].ToString() == "15")
                                            {
                                                objPlo.IsPackage = 1;
                                                if (dt.Rows[s]["PackageName"].ToString().Trim() != string.Empty)
                                                    objPlo.PackageName = dt.Rows[s]["PackageName"].ToString().Trim().ToUpper();
                                                else
                                                    objPlo.PackageName = ItemData.Rows[0]["TypeName"].ToString().ToUpper();

                                                objPlo.PackageCode = ItemData.Rows[0]["TestCode"].ToString();
                                                objPlo.BarcodeNo = string.Empty;
                                                objPlo.ItemName = string.Empty;
                                                objPlo.Investigation_ID = 0;
                                                objPlo.ReportType = 0;
                                                objPlo.IsReporting = 0;
                                            }
                                            else
                                            {
                                                objPlo.ItemName = ItemData.Rows[0]["InvestigationName"].ToString().ToUpper();
                                                if (dt.Rows[s]["PackageName"].ToString().Trim() != string.Empty)
                                                {
                                                    objPlo.IsPackage = 1;
                                                    objPlo.PackageName = dt.Rows[s]["PackageName"].ToString().Trim().ToUpper();
                                                }
                                                else
                                                {
                                                    objPlo.IsPackage = 0;
                                                    objPlo.PackageName = string.Empty;
                                                    objPlo.PackageCode = string.Empty;
                                                }
                                                objPlo.BarcodeNo = Barcode_new;
                                                objPlo.Investigation_ID = Util.GetInt(ItemData.Rows[0]["Investigation_ID"].ToString());
                                                objPlo.ReportType = Util.GetByte(ItemData.Rows[0]["ReportType"].ToString());
                                                objPlo.IsReporting = Util.GetByte(ItemData.Rows[0]["Reporting"].ToString());
                                            }

                                            objPlo.SubCategoryID = Util.GetInt(ItemData.Rows[0]["SubCategoryID"].ToString());

                                            decimal rate = Util.GetDecimal(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT IFNULL(Rate,0) Rate from f_ratelist WHERE ItemID='" + ItemID + "' AND Panel_ID='" + PanelRefCode.Split('#')[1] + "'"));
                                            objPlo.Rate = Util.GetDecimal(rate);
                                            objPlo.Amount = objPlo.Rate;
                                            objPlo.DiscountAmt = 0;
                                            objPlo.Quantity = 1;
                                            objPlo.IsRefund = 0;

                                            objPlo.CentreID = Util.GetInt(centreID);
                                            objPlo.TestCentreID = Util.GetInt(centreID);
                                            objPlo.IsSampleCollected = IsSampleCollected;
                                            objPlo.SampleCollector = EmployeeName;

                                            objPlo.SampleCollectionBy = EmployeeID;
                                            objPlo.SampleCollectionDate = Util.GetDateTime(dt.Rows[s]["SampleCollectionDate"].ToString());

                                            objPlo.barcodePreprinted = 0;

                                            if (sampleType != string.Empty)
                                            {
                                                objPlo.SampleTypeID = Util.GetInt(sampleType.Split('#')[0]);
                                                objPlo.SampleTypeName = sampleType.Split('#')[1];
                                            }
                                            else
                                            {
                                                objPlo.SampleTypeID = 0;
                                                objPlo.SampleTypeName = string.Empty;
                                            }
                                            objPlo.SampleBySelf = 0;
                                            objPlo.isUrgent = Util.GetByte(dt.Rows[s]["isUrgent"].ToString());

                                            objPlo.DeliveryDate = Util.GetDateTime(ItemData.Rows[0]["DeliveryDate"].ToString().Split('#')[1]);
                                            objPlo.SRADate = Util.GetDateTime(ItemData.Rows[0]["DeliveryDate"].ToString().Split('#')[0]);
                                            objPlo.IsActive = 1;
                                            objPlo.BillType = "Credit-Test Add";
                                            objPlo.BillNo = billNo;
                                            objPlo.Date = billDate;
                                            objPlo.ItemID_Interface = dt.Rows[s]["ItemId_interface"].ToString();
                                            objPlo.Interface_CompanyID = Util.GetInt(dt.Rows[s]["InterfaceClientID"].ToString());
                                            objPlo.Interface_companyName = dt.Rows[s]["InterfaceClient"].ToString();
                                            objPlo.UniqueID = dt.Rows[s]["UniqueID"].ToString();
                                            objPlo.Date = BookingDate;
                                            objPlo.SampleCollectionDate_Interface = Util.GetDateTime(dt.Rows[s]["SampleCollectionDate"].ToString());
                                            objPlo.Interface_PackageCategoryID = Util.GetString(dt.Rows[s]["Interface_PackageCategoryID"]).Trim();
                                            objPlo.Interface_SampleTypeID = Util.GetString(dt.Rows[s]["Interface_SampleTypeID"]).Trim();
                                            objPlo.ClientPatientRate = Util.GetDecimal(dt.Rows[s]["ClientPatientRate"]);
                                            objPlo.CreatedBy = EmployeeName;
                                            objPlo.CreatedByID = EmployeeID;
                                            objPlo.BaseCurrencyRound = Util.GetByte(Resources.Resource.BaseCurrencyRound);
                                            objPlo.SubCategoryName = Util.GetString(ItemData.Rows[0]["SubcategoryName"].ToString());
                                            objPlo.LedgerTransactionNo_Interface = LedgerTransactionNo_Interface;
                                            ID = objPlo.Insert();

                                            // Insert Remarks
                                            if (Util.GetString(dt.Rows[s]["TechnicalRemarks"]) != string.Empty)
                                            {
                                                sb = new StringBuilder();
                                                sb.Append(" INSERT INTO patient_labinvestigation_opd_remarks  ");
                                                sb.Append("  (`UserID`,`UserName`,`Test_ID`,`Remarks`,`LedgerTransactionNo`,`ShowOnline`,DATE,LedgerTransactionID) ");
                                                sb.Append("  VALUES (@UserID,@UserName,@Test_ID,@Remarks,@LedgerTransactionNo,0,NOW(),@LedgerTransactionID)");
                                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                            new MySqlParameter("@UserID", EmployeeID),
                                                            new MySqlParameter("@UserName", EmployeeName),
                                                            new MySqlParameter("@Test_ID", ID),
                                                            new MySqlParameter("@Remarks", Util.GetString(dt.Rows[s]["TechnicalRemarks"])),
                                                            new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                                            new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                                            }
                                        }
                                        catch (Exception ex)
                                        {
                                            isError = 1;
                                            tnx.Rollback();
                                            tnx.Dispose();
                                            string Response = ex.ToString().Length > 200 ? ex.ToString().Substring(0, 200) : ex.ToString();
                                            StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='" + Response + "' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                                        }

                                        if (ID != string.Empty)
                                        {
                                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                        new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                                                        new MySqlParameter("@SinNo", dt.Rows[s]["BarcodeNo"].ToString()),
                                                        new MySqlParameter("@Test_ID", ID),
                                                        new MySqlParameter("@Status", "Registration Done (" + ItemData.Rows[0]["ItemName"].ToString().ToUpper() + ")"),
                                                        new MySqlParameter("@UserID", EmployeeID),
                                                        new MySqlParameter("@UserName", EmployeeName),
                                                        new MySqlParameter("@IpAddress", StockReports.getip()),
                                                        new MySqlParameter("@CentreID", centreID),
                                                        new MySqlParameter("@RoleID", RoleID),
                                                        new MySqlParameter("@DispatchCode", ""),
                                                        new MySqlParameter("@dtEntry", billDate),
                                                        new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));

                                        }
                                        ID = string.Empty;
                                        if (isError == 0)
                                        {
                                            isError = 0;
                                            if (ItemData.Rows[0]["SubCategoryID"].ToString() == "15")
                                            {
                                                sb = new StringBuilder();
                                                sb.Append(" SELECT imm.`Name` ,imm.`Investigation_Id`,imm.`Type` sampleData,imm.`Reporting`,imm.`ReportType`,");
                                                sb.Append("  IFNULL(Get_DeliveryDate_client(@centreID,imm.Investigation_ID,NOW(),@isUrgent),'01-Jan-0001 12:00 AM#01-Jan-0001 12:00 AM')DeliveryDate, ");
                                                sb.Append(" (SELECT `SubCategoryID` FROM f_itemmaster WHERE type_id=imm.`Investigation_Id`)subcategoryID, ");
                                                sb.Append(" (SELECT IFNULL(Name,'')SubCategoryName FROM f_itemmaster fim INNER JOIN f_subcategorymaster sb ON sb.subcategoryid=fim.subcategoryid WHERE type_id=imm.`Investigation_Id`) SubCategoryName,pld.SampleDefinedPackage,imm.TestCode ");
                                                sb.Append("      FROM f_itemmaster im  ");
                                                sb.Append("      INNER JOIN package_labdetail pld  ON pld.PlabID=im.Type_ID   ");
                                                sb.Append("     INNER JOIN investigation_master imm  ON imm.Investigation_Id=pld.InvestigationID ");
                                                sb.Append("     AND  im.`ItemID`=@ItemID ");

                                                DataTable dtpackinfo = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                                                                                   new MySqlParameter("@ItemID", ItemID),
                                                                                   new MySqlParameter("@centreID", Util.GetInt(centreID)),
                                                                                   new MySqlParameter("@isUrgent", Util.GetInt(dt.Rows[s]["isUrgent"].ToString()))).Tables[0];
                                                if (dtpackinfo.Rows.Count > 0)
                                                {
                                                    foreach (DataRow dw in dtpackinfo.Rows)
                                                    {
                                                        sampleType = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CONCAT(ist.`SampleTypeID`,'#',ist.SampleTypeName) FROM `investigations_sampletype` ist where  `Investigation_Id`=@Investigation_Id AND ist.`IsDefault`=1",
                                                           new MySqlParameter("@Investigation_Id", dw["Investigation_ID"].ToString())));


                                                        string Barcode_new = string.Empty;
                                                        try
                                                        {
                                                            checkHistoMicro = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM `investigation_master` WHERE investigation_id=@Investigation_Id AND  (`container`=7 OR `isCulture`=1)",
                                                                new MySqlParameter("@Investigation_Id", dw["Investigation_ID"].ToString())));
                                                            if (checkHistoMicro > 0)
                                                            {
                                                                Barcode_new = dt.Rows[s]["BarcodeNo"].ToString();
                                                                IsSampleCollected = "N";
                                                            }
                                                            else
                                                            {
                                                                dt_sampleType = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CONCAT(ist.`SampleTypeID`,'#',ist.SampleTypeName)SampleTypeID FROM `investigations_sampletype` ist WHERE `Investigation_Id`=@Investigation_Id  ",
                                                                                            new MySqlParameter("@Investigation_Id", dw["Investigation_Id"].ToString())).Tables[0];
                                                                if (dt_sampleType.Rows.Count == 1)
                                                                {
                                                                    sampleType = dt_sampleType.Rows[0]["SampleTypeID"].ToString();
                                                                }
                                                                if (dt.Rows[s]["BarcodeNo"].ToString() == string.Empty)
                                                                {
                                                                    Barcode_new = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT barcodeno FROM `patient_labinvestigation_opd` WHERE LedgerTransactionID = @LedgerTransactionID AND SampleTypeID=@SampleTypeID AND SubCategoryID=@SubCategoryID",
                                                                                                             new MySqlParameter("@LedgerTransactionID", LedgerTransactionID),
                                                                                                             new MySqlParameter("@SampleTypeID", dt_sampleType.Rows[0]["SampleTypeID"].ToString().Split('#')[0]),
                                                                                                             new MySqlParameter("@SubCategoryID", dw["subcategoryID"].ToString())));


                                                                    if (Barcode_new.Trim() == string.Empty)
                                                                    {
                                                                        Barcode_new = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_barcode(@SubCategoryID)",
                                                                                                  new MySqlParameter("@SubCategoryID", dw["subcategoryID"].ToString())).ToString();
                                                                    }
                                                                    IsSampleCollected = "N";
                                                                }
                                                                else
                                                                {
                                                                    Barcode_new = dt.Rows[s]["BarcodeNo"].ToString();
                                                                    if (dt_sampleType.Rows.Count != 1)
                                                                    {
                                                                        IsSampleCollected = "N";
                                                                    }
                                                                    else
                                                                    {
                                                                        sampleType = dt_sampleType.Rows[0]["SampleTypeID"].ToString();
                                                                        IsSampleCollected = "S";
                                                                    }
                                                                }
                                                            }
                                                            objPlo = new Patient_Lab_InvestigationOPD(tnx);
                                                            objPlo.LedgerTransactionID = Util.GetInt(LedgerTransactionID);
                                                            objPlo.LedgerTransactionNo = LedgerTransactionNo;
                                                            objPlo.Patient_ID = PatientID;
                                                            objPlo.AgeInDays = Util.GetInt(TotalAgeInDays);
                                                            objPlo.Gender = dt.Rows[s]["Gender"].ToString();
                                                            objPlo.BarcodeNo = Barcode_new;
                                                            objPlo.ItemId = Util.GetInt(ItemData.Rows[0]["ItemID"].ToString());

                                                            objPlo.ItemName = dw["name"].ToString().ToUpper();
                                                            objPlo.ItemCode = dw["TestCode"].ToString();

                                                            if (dt.Rows[s]["PackageName"].ToString().Trim() != "")
                                                                objPlo.PackageName = dt.Rows[s]["PackageName"].ToString().Trim().ToUpper();
                                                            else
                                                                objPlo.PackageName = ItemData.Rows[0]["TypeName"].ToString().ToUpper();

                                                            objPlo.PackageCode = ItemData.Rows[0]["TestCode"].ToString();
                                                            objPlo.Investigation_ID = Util.GetInt(dw["Investigation_Id"].ToString());
                                                            objPlo.IsPackage = 1;
                                                            objPlo.SubCategoryID = Util.GetInt(dw["subcategoryID"].ToString());
                                                            objPlo.Rate = 0;
                                                            objPlo.Amount = 0;
                                                            objPlo.DiscountAmt = 0;
                                                            objPlo.Quantity = 1;
                                                            objPlo.IsRefund = 0;
                                                            objPlo.IsReporting = Util.GetByte(dw["Reporting"].ToString());
                                                            objPlo.ReportType = Util.GetByte(dw["ReportType"].ToString());
                                                            objPlo.CentreID = Util.GetInt(centreID);
                                                            objPlo.TestCentreID = Util.GetInt(centreID);
                                                            objPlo.IsSampleCollected = IsSampleCollected;
                                                            objPlo.SampleCollectionBy = EmployeeID;
                                                            objPlo.SampleCollector = EmployeeName;
                                                            objPlo.SampleCollectionDate = Util.GetDateTime(dt.Rows[s]["SampleCollectionDate"].ToString());
                                                            objPlo.barcodePreprinted = 0;
                                                            try
                                                            {
                                                                if (sampleType != string.Empty)
                                                                {
                                                                    objPlo.SampleTypeID = Util.GetInt(sampleType.Split('#')[0]);
                                                                    objPlo.SampleTypeName = sampleType.Split('#')[1];
                                                                }
                                                                else
                                                                {
                                                                    objPlo.SampleTypeID = 0;
                                                                    objPlo.SampleTypeName = string.Empty;
                                                                }
                                                            }
                                                            catch
                                                            {
                                                            }
                                                            objPlo.SampleBySelf = 0;
                                                            objPlo.isUrgent = Util.GetByte(dt.Rows[s]["isUrgent"].ToString());
                                                            objPlo.DeliveryDate = Util.GetDateTime(dw["DeliveryDate"].ToString().Split('#')[1]);
                                                            objPlo.SRADate = Util.GetDateTime(dw["DeliveryDate"].ToString().Split('#')[0]);
                                                            objPlo.IsActive = 1;
                                                            objPlo.BillType = "Credit-Test Add";
                                                            objPlo.BillNo = billNo;
                                                            objPlo.ItemID_Interface = dt.Rows[s]["ItemId_interface"].ToString();
                                                            objPlo.Interface_CompanyID = Util.GetInt(dt.Rows[s]["InterfaceClientID"].ToString());
                                                            objPlo.Interface_companyName = dt.Rows[s]["InterfaceClient"].ToString();
                                                            objPlo.UniqueID = dt.Rows[s]["UniqueID"].ToString();
                                                            objPlo.Date = BookingDate;
                                                            objPlo.SampleCollectionDate_Interface = Util.GetDateTime(dt.Rows[s]["SampleCollectionDate"].ToString());
                                                            objPlo.Interface_PackageCategoryID = Util.GetString(dt.Rows[s]["Interface_PackageCategoryID"]).Trim();
                                                            objPlo.Interface_SampleTypeID = Util.GetString(dt.Rows[s]["Interface_SampleTypeID"]).Trim();
                                                            objPlo.CreatedBy = EmployeeName;
                                                            objPlo.CreatedByID = EmployeeID;
                                                            objPlo.SubCategoryName = Util.GetString(dw["SubCategoryName"].ToString());
                                                            objPlo.LedgerTransactionNo_Interface = LedgerTransactionNo_Interface;
                                                            ID = objPlo.Insert();
                                                            // Insert Remarks
                                                            if (Util.GetString(dt.Rows[s]["TechnicalRemarks"]) != string.Empty)
                                                            {
                                                                sb = new StringBuilder();
                                                                sb.Append(" INSERT INTO patient_labinvestigation_opd_remarks  ");
                                                                sb.Append("  (`UserID`,`UserName`,`Test_ID`,`Remarks`,`LedgerTransactionNo`,`ShowOnline`,DATE,LedgerTransactionID) ");
                                                                sb.Append("  values (@EmployeeID,@EmployeeName,@Test_ID,@Remarks,@LedgerTransactionNo,0,now(),@LedgerTransactionID)");

                                                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                                            new MySqlParameter("@EmployeeID", EmployeeID),
                                                                            new MySqlParameter("@EmployeeName", EmployeeName),
                                                                            new MySqlParameter("@Test_ID", ID),
                                                                            new MySqlParameter("@Remarks", Util.GetString(dt.Rows[s]["TechnicalRemarks"])),
                                                                            new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo),
                                                                            new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                                                            }
                                                        }
                                                        catch (Exception ex)
                                                        {
                                                            isError = 1;
                                                            tnx.Rollback();
                                                            tnx.Dispose();
                                                            string Response = ex.ToString().Length > 200 ? ex.ToString().Substring(0, 200) : ex.ToString();
                                                            StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='" + Response + "' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                                                        }

                                                        if (ID != string.Empty)
                                                        {
                                                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,@dtEntry,@DispatchCode,@LedgerTransactionID) ",
                                                                        new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                                                                        new MySqlParameter("@SinNo", dt.Rows[s]["BarcodeNo"].ToString()),
                                                                        new MySqlParameter("@Test_ID", ID),
                                                                        new MySqlParameter("@Status", string.Format("Registration Done ({0})", objPlo.ItemName.ToUpper())),
                                                                        new MySqlParameter("@UserID", EmployeeID),
                                                                        new MySqlParameter("@UserName", EmployeeName),
                                                                        new MySqlParameter("@IpAddress", StockReports.getip()),
                                                                        new MySqlParameter("@CentreID", centreID),
                                                                        new MySqlParameter("@RoleID", RoleID),
                                                                        new MySqlParameter("@DispatchCode", string.Empty),
                                                                        new MySqlParameter("@dtEntry", billDate),
                                                                        new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                                                        }
                                                    }
                                                }
                                                else
                                                {
                                                    isError = 1;
                                                    tnx.Rollback();
                                                    tnx.Dispose();
                                                    StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='Item ID Not Found in Package' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                                                }

                                            }
                                        }
                                        if (isError == 0)
                                        {

                                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE booking_data SET isBooked=1, dtAccepted=NOW(),LedgerTransactionID=@LedgerTransactionID WHERE ID=@ID  ",
                                                new MySqlParameter("@ID", dt.Rows[s]["ID"].ToString()),
                                                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                                            sb = new StringBuilder();
                                            sb.Append(" UPDATE f_ledgertransaction set grossAmount=(SELECT sum(rate) from patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID), ");
                                            sb.Append(" netAmount=(SELECT sum(amount) from patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID),");
                                            sb.Append(" discountonTotal=(SELECT sum(discountAmt) from patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID)");
                                            sb.Append(" WHERE LedgerTransactionID=@LedgerTransactionID ");
                                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                        new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
                                        }
                                    }
                                    else
                                    {
                                        isError = 1;
                                        tnx.Rollback();
                                        tnx.Dispose();
                                        StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='Item ID Not Found' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");

                                    }
                                }
                            }
                            if (isError == 0)
                            {
                                if (Util.GetInt(dt.Rows[s]["checkAllowPrint"].ToString()) == 1)
                                {
                                    sb = new StringBuilder();
                                    sb.Append(" SELECT COUNT(1) FROM Booking_data_allowPrint WHERE IsProcess=0 AND InterfaceClientID=@InterfaceClientID ");
                                    sb.Append(" AND WorkOrderID=@WorkOrderID  ");
                                    int allowPrintFound = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                                                                                  new MySqlParameter("@InterfaceClientID", dt.Rows[s]["InterfaceClientID"].ToString()),
                                                                                  new MySqlParameter("@WorkOrderID", dt.Rows[s]["WorkOrderID"].ToString())));

                                    if (allowPrintFound > 0)
                                    {
                                        sb = new StringBuilder();
                                        sb.Append(" UPDATE f_ledgertransaction SET AllowPrint=@AllowPrint WHERE LedgerTransactionNo_Interface=@LedgerTransactionNo_Interface ");
                                        sb.Append(" AND Interface_CompanyID=@Interface_CompanyID");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                                    new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString()),
                                                    new MySqlParameter("@LedgerTransactionNo_Interface", dt.Rows[s]["WorkOrderID"].ToString()),
                                                    new MySqlParameter("@AllowPrint", dt.Rows[s]["AllowPrint"].ToString()));
                                    }
                                }
                            }
                        }
                        if (isError == 0)
                        {
                            tnx.Commit();
                            tnx.Dispose();
                        }
                    }
                    // for Cancel of test
                    else
                    {

                        DateTime billDate = DateTime.Now;
                        string ItemID = string.Empty; string LedgerTransactionNo = string.Empty;
                        if (Util.GetInt(dt.Rows[s]["ItemID_AsItdose"].ToString()) == 0)
                        {
                            ItemID = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT ItemID FROM f_itemmaster_interface WHERE ItemID_interface=@ItemID_interface AND Interface_CompanyID=@Interface_CompanyID AND isActive=1 ",
                                                                new MySqlParameter("@ItemID_interface", dt.Rows[s]["ItemId_interface"].ToString()),
                                                                new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString())));
                        }
                        else
                        {
                            ItemID = dt.Rows[s]["ItemId_interface"].ToString();
                        }
                        if (ItemID == string.Empty)
                        {
                            isError = 1;
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE booking_data SET isBooked=-1,Response='Item ID not Found' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                            tnx.Rollback();
                            tnx.Dispose();
                        }
                        if (isError == 0)
                        {
                            try
                            {
                                string DebitBillNo = string.Empty;

                                if (DebitBillNo == string.Empty)
                                {
                                    DebitBillNo = AllLoad_Data.getBillNo(Util.GetInt(dt.Rows[s]["CentreID"].ToString()), "C", con, tnx); ;
                                }
                                if (DebitBillNo == string.Empty)
                                {
                                    isError = 1;
                                    tnx.Rollback();
                                    tnx.Dispose();

                                    StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='Debit Bill No Generation Error' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");

                                }


                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO patient_labinvestigation_opd(LedgerTransactionID,LedgerTransactionNo,BillNo,BarcodeNo,ItemId,ItemName,Investigation_ID,IsPackage,Date,SubCategoryID,SubCategoryName,Rate,");
                                sb.Append(" Amount,DiscountAmt,CouponAmt,Quantity,DiscountByLab,IsRefund,IsReporting,IsActive,BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                                sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                                sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                                sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                                sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                                sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                                sb.Append(" SampleTypeID,SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                                sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                                sb.Append(" CurrentSampleDept,ToSampleDept,UpdateID,UpdateName,UpdateRemarks,ipAddress,");
                                sb.Append(" Barcode_Group,IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                                sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                                sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                                sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,SRADate,CreatedBy,CreatedByID,BaseCurrencyRound,DepartmentTokenNo,Interface_CompanyID,LedgerTransactionNo_Interface,UniqueID) ");
                                sb.Append(" ");
                                sb.Append(" SELECT LedgerTransactionID,LedgerTransactionNo,@BillNo,'',ItemId,ItemName,Investigation_ID,IsPackage,@BillDate,SubCategoryID,SubCategoryName,Rate,");
                                sb.Append(" Amount*-1,DiscountAmt*-1,CouponAmt,Quantity*-1,DiscountByLab,2,0,0,@BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                                sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                                sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                                sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                                sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                                sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                                sb.Append(" 0,'',SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                                sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                                sb.Append(" CurrentSampleDept,ToSampleDept,0,'','',@ipAddress,");
                                sb.Append(" '',IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                                sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,1 CancelByInterface,");
                                sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                                sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,SRADate,@CreatedBy,@CreatedByID,@BaseCurrencyRound,DepartmentTokenNo,@Interface_CompanyID,@LedgerTransactionNo_Interface,@UniqueID ");
                                sb.Append(" FROM patient_labinvestigation_opd WHERE LedgerTransactionNo_Interface=@LedgerTransactionNo_Interface ");
                                sb.Append(" AND ItemID=@ItemID AND Interface_CompanyID=@Interface_CompanyID AND UniqueID=@UniqueID AND IsActive=1");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@LedgerTransactionNo_Interface", dt.Rows[s]["WorkOrderID"].ToString()),
                                    new MySqlParameter("@ItemID", ItemID),
                                    new MySqlParameter("@BillDate", billDate),
                                    new MySqlParameter("@BillNo", DebitBillNo),
                                    new MySqlParameter("@BillType", "Debit-Test Removed"),
                                    new MySqlParameter("@ipAddress", StockReports.getip()),
                                    new MySqlParameter("@CreatedBy", EmployeeName),
                                    new MySqlParameter("@CreatedByID", EmployeeID),
                                    new MySqlParameter("@BaseCurrencyRound", Resources.Resource.BaseCurrencyRound),
                                    new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString()),
                                    new MySqlParameter("@UniqueID", dt.Rows[s]["UniqueID"].ToString()));


                                sb = new StringBuilder();
                                sb.Append(" UPDATE patient_labinvestigation_opd SET IsActive=0,IsReporting=0,UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateDate=NOW(),");
                                sb.Append(" UpdateRemarks='Investigation Removed' WHERE LedgerTransactionNo_Interface=@LedgerTransactionNo_Interface ");
                                sb.Append(" AND ItemID=@ItemID AND Interface_CompanyID=@Interface_CompanyID AND UniqueID=@UniqueID ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                        new MySqlParameter("@LedgerTransactionNo_Interface", dt.Rows[s]["WorkOrderID"].ToString()),
                                        new MySqlParameter("@ItemID", ItemID),
                                        new MySqlParameter("@UpdateID", EmployeeID),
                                        new MySqlParameter("@UpdateName", EmployeeName),
                                        new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString()),
                                        new MySqlParameter("@UniqueID", dt.Rows[s]["UniqueID"].ToString()));




                            }
                            catch (Exception ex)
                            {
                                isError = 1;
                                tnx.Rollback();
                                tnx.Dispose();
                                string Response = ex.ToString().Length > 200 ? ex.ToString().Substring(0, 200) : ex.ToString();
                                StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='" + Response + "' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                            }
                        }
                        if (isError == 0)
                        {
                            try
                            {
                                sb = new StringBuilder();
                                sb.Append(" UPDATE f_ledgertransaction set grossAmount=(select sum(rate) from patient_labinvestigation_opd where Interface_CompanyID=@Interface_CompanyID AND LedgerTransactionNo_Interface=@LedgerTransactionNo_Interface ), ");
                                sb.Append(" netAmount=(select sum(amount) from patient_labinvestigation_opd where Interface_CompanyID=@Interface_CompanyID AND LedgerTransactionNo_Interface=@LedgerTransactionNo_Interface ),");
                                sb.Append(" discountonTotal=(select sum(DiscountAmt) from patient_labinvestigation_opd where Interface_CompanyID=@Interface_CompanyID AND LedgerTransactionNo_Interface=@LedgerTransactionNo_Interface) ");
                                sb.Append(" WHERE Interface_CompanyID=@Interface_CompanyID AND LedgerTransactionNo_Interface=@LedgerTransactionNo_Interface  ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString()),
                                            new MySqlParameter("@LedgerTransactionNo_Interface", dt.Rows[s]["WorkOrderID"].ToString()));
                            }
                            catch (Exception ex)
                            {
                                isError = 1;
                                tnx.Rollback();
                                tnx.Dispose();
                                string Response = ex.ToString().Length > 200 ? ex.ToString().Substring(0, 200) : ex.ToString();
                                StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='" + Response + "' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                            }

                        }
                        if (isError == 0)
                        {
                            try
                            {
                                sb = new StringBuilder();
                                if (Util.GetInt(dt.Rows[s]["WorkOrderID_Create"].ToString()) == 0)
                                {
                                    sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)");
                                    sb.Append(" SELECT LedgertransactionNo,BarCodeNo,Test_ID,CONCAT('Item Removed (',ItemName,')'),@EmployeeID,@EmployeeName,@IpAddress,@centreID, ");
                                    sb.Append(" @RoleID,@dtEntry,'',@LedgerTransactionID FROM patient_labinvestigation_opd  WHERE  ItemID =@ItemID AND ");
                                    sb.Append("  Interface_CompanyID=@Interface_CompanyID AND ");
                                    sb.Append("  LedgerTransactionNo=@LedgerTransactionNo_Interface ");
                                }
                                else
                                {
                                    sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,LedgerTransactionID)");
                                    sb.Append(" SELECT plo.LedgertransactionNo,plo.BarCodeNo,plo.Test_ID,CONCAT('Item Removed (',plo.ItemName,')'),@EmployeeID,@EmployeeName,@IpAddress,@centreID, ");
                                    sb.Append(" @RoleID,@dtEntry,'',@LedgerTransactionID FROM patient_labinvestigation_opd plo ");
                                    sb.Append(" INNER JOIN f_ledgertransaction lt  ");
                                    sb.Append("  ON lt.`LedgertransactionID` = plo.`LedgertransactionID` ");
                                    sb.Append("    WHERE  plo.ItemID =@ItemID AND ");
                                    sb.Append("  plo.Interface_CompanyID=@Interface_CompanyID AND ");
                                    sb.Append("  lt.LedgerTransactionNo_Interface=@LedgerTransactionNo_Interface ");
                                }
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@ItemID", ItemID),
                                            new MySqlParameter("@RoleID", RoleID),
                                            new MySqlParameter("@dtEntry", billDate),
                                            new MySqlParameter("@Interface_CompanyID", dt.Rows[s]["InterfaceClientID"].ToString()),
                                            new MySqlParameter("@LedgerTransactionNo_Interface", dt.Rows[s]["WorkOrderID"].ToString()),
                                            new MySqlParameter("@EmployeeID", EmployeeID),
                                            new MySqlParameter("@EmployeeName", EmployeeName),
                                            new MySqlParameter("@IpAddress", StockReports.getip()),
                                            new MySqlParameter("@centreID", centreID),
                                            new MySqlParameter("@LedgerTransactionID", 0));
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE booking_data SET isBooked=1, dtAccepted=NOW() WHERE ID=@ID ",
                                            new MySqlParameter("@ID", dt.Rows[s]["ID"].ToString()));
                            }
                            catch (Exception ex)
                            {
                                isError = 1;
                                tnx.Rollback();
                                tnx.Dispose();
                                string Response = ex.ToString().Length > 200 ? ex.ToString().Substring(0, 200) : ex.ToString();
                                StockReports.ExecuteDML("UPDATE booking_data SET isBooked=-1,Response='" + Response + "' WHERE ID=" + dt.Rows[s]["ID"].ToString() + "  ");
                            }
                        }
                        if (isError == 0)
                        {
                            tnx.Commit();
                            tnx.Dispose();
                        }
                    }
                }
            }
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    public string Insta_Record_Updation_Patient_Details()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ID,InterfaceClientID,InterfaceClient,Patient_ID,Title,PName,Gender,DOB,Age,AgeYear,AgeMonth,AgeDays,TotalAgeInDays, ");
            sb.Append(" City,State,Country,Mobile,Email,Address,Inserted_TS,Exported_TS,IsUpdated,UpdateDateTime,Response,dtEntry ");
            sb.Append(" FROM booking_data_update_patient_details WHERE IsUpdated=0 ");
            DataTable dtUpdateData = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
            foreach (DataRow dr in dtUpdateData.Rows)
            {
                string response = UpdateInstaRecord("patient_details", dr, con);
                if (response.Trim() == "success")
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE booking_data_update_patient_details SET IsUpdated=@IsUpdated,UpdateDateTime=@UpdateDateTime,Response=@Response WHERE ID=@ID");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@IsUpdated", "1"),
                                new MySqlParameter("@UpdateDateTime", DateTime.Now),
                                new MySqlParameter("@Response", ""),
                                new MySqlParameter("@ID", Util.GetString(dr["ID"])));
                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE booking_data_update_patient_details SET IsUpdated=@IsUpdated,UpdateDateTime=@UpdateDateTime,Response=@Response WHERE ID=@ID");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@IsUpdated", "-1"),
                                new MySqlParameter("@UpdateDateTime", DateTime.Now),
                                new MySqlParameter("@Response", response),
                                new MySqlParameter("@ID", Util.GetString(dr["ID"])));
                }
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
        return "";
    }
    public string Insta_Record_Updation_Visit_Details()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ID,InterfaceClient,Patient_ID,origin_patient_id,Inserted_TS,Exported_TS,TPA_Name,Plan_Name, ");
            sb.Append(" Employee_ID,IsUpdated,UpdateDateTime,Response,dtEntry  ");
            sb.Append(" FROM booking_data_update_visit_details where IsUpdated=0  ");
            DataTable dtUpdateData = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0];
            foreach (DataRow dr in dtUpdateData.Rows)
            {
                string response = UpdateInstaRecord("visit_details", dr, con);
                if (response.Trim() == "success")
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE booking_data_update_visit_details SET IsUpdated=@IsUpdated,UpdateDateTime=@UpdateDateTime,Response=@Response WHERE ID=@ID");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@IsUpdated", "1"),
                                new MySqlParameter("@UpdateDateTime", DateTime.Now),
                                new MySqlParameter("@Response", ""),
                                new MySqlParameter("@ID", Util.GetString(dr["ID"])));
                }
                else
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE booking_data_update_visit_details SET IsUpdated=@IsUpdated,UpdateDateTime=@UpdateDateTime,Response=@Response WHERE ID=@ID");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@IsUpdated", "-1"),
                                new MySqlParameter("@UpdateDateTime", DateTime.Now),
                                new MySqlParameter("@Response", response),
                                new MySqlParameter("@ID", Util.GetString(dr["ID"]))
                        );
                }
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
        return "";
    }
    public string UpdateInstaRecord(string ActionToPerform, DataRow dr, MySqlConnection con)
    {
        string retValue = string.Empty;

        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            if (ActionToPerform.Trim() == "patient_details")
            {
                int ispatientidcreate = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT ispatientidcreate FROM `f_interface_company_master` WHERE ID=@ID ",
                                                                new MySqlParameter("@ID", Util.GetString(dr["InterfaceClientID"]))));

                sb = new StringBuilder();
                sb.Append(" SELECT LastUpdatedData,Patient_ID,Title,PName,House_No,Locality, ");
                sb.Append(" City,Pincode,State,Country,Phone,Mobile,Email,DOB,Gender FROM patient_master WHERE ");
                if (ispatientidcreate == 1)
                    sb.Append(" Patient_ID_interface=@Patient_ID ");

                else
                    sb.Append(" Patient_ID=@Patient_ID ");
                using (DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, sb.ToString(),
                                                  new MySqlParameter("@Patient_ID", Util.GetString(dr["Patient_ID"]))).Tables[0])
                {

                    if (dt.Rows.Count > 0)
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ledgertransaction SET Pname=@PName WHERE patient_id=@Patient_ID AND Interface_companyID=@Interface_companyID",
                                    new MySqlParameter("@PName", string.Concat(Util.GetString(dt.Rows[0]["Title"].ToString()), " ", Util.GetString(dr["PName"]))),
                                    new MySqlParameter("@Patient_ID", Util.GetString(dt.Rows[0]["Patient_ID"].ToString())),
                                    new MySqlParameter("@Interface_companyID", Util.GetString(dr["InterfaceClientID"])));


                        sb = new StringBuilder();
                        sb.Append(" UPDATE patient_master SET ");
                        sb.Append(" House_No=@House_No,City=@City,State=@State,Country=@Country,Mobile=@Mobile,Email=@Email,PName=@PName WHERE Patient_ID=@Patient_ID");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@House_No", Util.GetString(dr["Address"])),
                                    new MySqlParameter("@City", Util.GetString(dr["City"])),
                                    new MySqlParameter("@State", Util.GetString(dr["State"])),
                                    new MySqlParameter("@Country", Util.GetString(dr["Country"])),
                                    new MySqlParameter("@Mobile", Util.GetString(dr["Mobile"])),
                                    new MySqlParameter("@Email", Util.GetString(dr["Email"])),
                                    new MySqlParameter("@PName", Util.GetString(dr["PName"])),
                                    new MySqlParameter("@Patient_ID", Util.GetString(dt.Rows[0]["Patient_ID"].ToString())));


                        if (
                             (Util.GetString(dr["PName"]).ToLower() != Util.GetString(dt.Rows[0]["PName"]).ToLower()) &&
                             (Util.GetString(dr["Gender"]).ToLower() != Util.GetString(dt.Rows[0]["Gender"]).ToLower()))
                        {
                            tnx.Commit();
                            return "Can't change Pname with Gender together";

                        }
                        else if (
                             (Util.GetString(dr["PName"]).ToLower() != Util.GetString(dt.Rows[0]["PName"]).ToLower()) &&
                             (Util.GetString(dr["DOB"]).ToLower() != Util.GetString(dt.Rows[0]["DOB"]).ToLower()))
                        {
                            tnx.Commit();
                            return "Can't change Pname with DOB together";

                        }
                        else if (Util.GetString(dt.Rows[0]["LastUpdatedData"]).Trim() != string.Empty)
                        {
                            string[] WhichColumnPrevUpdated = Util.GetString(dt.Rows[0]["LastUpdatedData"]).Trim().Split(',');
                            if (WhichColumnPrevUpdated.Length > 0 && (Util.GetString(dr["PName"]).ToLower() != Util.GetString(dt.Rows[0]["PName"]).ToLower()) && Array.IndexOf(WhichColumnPrevUpdated, "DOB") > 0)
                            {
                                tnx.Commit();
                                return "Can't change Pname bcz DOB is already changed";
                            }
                            else if (WhichColumnPrevUpdated.Length > 0 && (Util.GetString(dr["DOB"]).ToLower() != Util.GetString(dt.Rows[0]["DOB"]).ToLower()) && Array.IndexOf(WhichColumnPrevUpdated, "PName") > 0)
                            {
                                tnx.Commit();
                                return "Can't change DOB bcz Pname is already changed";
                            }
                            else if (WhichColumnPrevUpdated.Length > 0 && (Util.GetString(dr["Gender"]).ToLower() != Util.GetString(dt.Rows[0]["Gender"]).ToLower()) && Array.IndexOf(WhichColumnPrevUpdated, "PName") > 0)
                            {
                                tnx.Commit();
                                return "Can't change Gender bcz Pname is already changed";
                            }
                            else if (WhichColumnPrevUpdated.Length > 0 && (Util.GetString(dr["PName"]).ToLower() != Util.GetString(dt.Rows[0]["PName"]).ToLower()) && Array.IndexOf(WhichColumnPrevUpdated, "Gender") > 0)
                            {
                                tnx.Commit();
                                return "Can't change Pname bcz Gender is already changed";
                            }
                            else
                            {
                                doChanges(tnx, dr, dt);
                            }
                        }
                        else
                        {
                            doChanges(tnx, dr, dt);
                        }
                        tnx.Commit();
                        retValue = "success";
                    }
                    else
                    {
                        retValue = "fail";
                    }
                }
            }
            else if (ActionToPerform.Trim() == "visit_details")
            {
                // Updation Of f_ledgertransaction
                if (Util.GetString(dr["origin_patient_id"]).Trim() != "")
                {
                    sb.Append(" UPDATE f_ledgertransaction SET OtherReferLab=@OtherReferLab,CorporateIDCard=@CorporateIDCard   ");
                    sb.Append(" WHERE Interface_companyName=@Interface_companyName AND LedgerTransactionNo_Interface=@LedgerTransactionNo_Interface  ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@OtherReferLab", Util.GetString(dr["TPA_Name"])),
                                new MySqlParameter("@CorporateIDCard", Util.GetString(dr["Employee_ID"])),
                                new MySqlParameter("@Interface_companyName", Util.GetString(dr["InterfaceClient"])),
                                new MySqlParameter("@LedgerTransactionNo_Interface", Util.GetString(dr["origin_patient_id"])));
                }
                else
                {
                    sb.Append(" UPDATE f_ledgertransaction SET OtherReferLab=@OtherReferLab,CorporateIDCard=@CorporateIDCard   ");
                    sb.Append(" WHERE Interface_companyName=@Interface_companyName AND Patient_ID=@Patient_ID  ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@OtherReferLab", Util.GetString(dr["TPA_Name"])),
                                new MySqlParameter("@CorporateIDCard", Util.GetString(dr["Employee_ID"])),
                                new MySqlParameter("@Interface_companyName", Util.GetString(dr["InterfaceClient"])),
                                new MySqlParameter("@Patient_ID", Util.GetString(dr["Patient_ID"])));
                }
                tnx.Commit();
                retValue = "success";
            }

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            retValue = ex.Message;
        }
        finally
        {
            tnx.Dispose();

        }
        return retValue;
    }

    public void doChanges(MySqlTransaction tnx, DataRow dr, DataTable dt)
    {

        int NotApproveReport = 0;

        int TotalAgeInDays = 0;
        string FinalAge = "";

        Age CAge = new Age(Util.GetDateTime(dr["DOB"]), DateTime.Now);
        TotalAgeInDays = ((CAge.Years * 365) + (CAge.Months * 30) + CAge.Days);
        FinalAge = "" + CAge.Years + " Y " + CAge.Months + " M " + CAge.Days + " D";


        string LastUpdatedData = "";

        if ((Util.GetString(dr["DOB"]) != Util.GetString(dt.Rows[0]["DOB"])))
        {
            NotApproveReport = 1;
            LastUpdatedData += "DOB,";
        }
        if ((Util.GetString(dr["Gender"]) != Util.GetString(dt.Rows[0]["Gender"])))
        {
            NotApproveReport = 1;
            LastUpdatedData += "Gender,";
        }
        if ((Util.GetString(dr["PName"]) != Util.GetString(dt.Rows[0]["PName"])))
        {
            LastUpdatedData += "PName,";
        }
        StringBuilder sb = new StringBuilder();
        string DemographicalChanges = string.Empty;

        // Updation Of Patient_Master
        sb = new StringBuilder();
        sb.Append(" UPDATE patient_master SET  Title=@Title, Gender=@Gender, PName=@PName ");
        sb.Append(" ,DOB=@DOB,AgeYear=@AgeYear,AgeMonth=@AgeMonth,AgeDays=@AgeDays,Age=@Age, ");
        sb.Append(" TotalAgeInDays=@TotalAgeInDays ,LastUpdatedData=@LastUpdatedData ");
        sb.Append(" WHERE Patient_ID=@Patient_ID ");
        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Title", Util.GetString(dr["Title"])),
                    new MySqlParameter("@Gender", Util.GetString(dr["Gender"])),
                    new MySqlParameter("@PName", Util.GetString(dr["PName"]).ToUpper()),
                    new MySqlParameter("@DOB", Util.GetDateTime(dr["DOB"])),
                    new MySqlParameter("@AgeYear", CAge.Years),
                    new MySqlParameter("@AgeMonth", CAge.Months),
                    new MySqlParameter("@AgeDays", CAge.Days),
                    new MySqlParameter("@Age", FinalAge),
                    new MySqlParameter("@TotalAgeInDays", TotalAgeInDays),
                    new MySqlParameter("@LastUpdatedData", Util.GetString(dt.Rows[0]["LastUpdatedData"]) + LastUpdatedData),
                    new MySqlParameter("@Patient_ID", Util.GetString(dr["Patient_ID"]))
            );

        // Updation Of f_ledgertransaction
        sb = new StringBuilder();
        sb.Append(" UPDATE f_ledgertransaction SET PName=@PName, Age=@Age, Gender=@Gender WHERE Patient_ID=@Patient_ID AND Interface_companyName=@Interface_companyName");
        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@PName", Util.GetString(dr["Title"]) + Util.GetString(dr["PName"]).ToUpper()),
                    new MySqlParameter("@Age", FinalAge),
                    new MySqlParameter("@Gender", Util.GetString(dr["Gender"])),
                    new MySqlParameter("@Interface_companyName", Util.GetString(dr["InterfaceClient"])),
                    new MySqlParameter("@Patient_ID", Util.GetString(dr["Patient_ID"]))
            );

        // Updation patient_labinvestigation_opd
        sb = new StringBuilder();
        sb.Append(" UPDATE patient_labinvestigation_opd ");
        sb.Append(" SET  ");
        sb.Append(" AgeInDays=@AgeInDays,Gender=@Gender WHERE Patient_ID=@Patient_ID AND Interface_companyName=@Interface_companyName ");
        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@AgeInDays", TotalAgeInDays),
                    new MySqlParameter("@Gender", Util.GetString(dr["Gender"])),
                    new MySqlParameter("@Patient_ID", Util.GetString(dr["Patient_ID"])),
                    new MySqlParameter("@Interface_companyName", Util.GetString(dr["InterfaceClient"])));


        if (NotApproveReport == 1)
        {
            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,'Not Approved bcz Gender/DOB is changed by insta Integration ','" + EmployeeID + "','" + EmployeeName + "','',CentreID, ");
            sb.Append(" '" + RoleID + "',NOW(),'' FROM patient_labinvestigation_opd   WHERE Patient_ID=@Patient_ID AND Interface_companyName=@Interface_companyName and Approved=1  ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@Patient_ID", Util.GetString(dr["Patient_ID"])),
                        new MySqlParameter("@Interface_companyName", Util.GetString(dr["InterfaceClient"])));



            sb = new StringBuilder();
            sb.Append(" INSERT INTO Report_Unapprove(LedgerTransactionNo, Test_ID,UnapprovebyID,Unapproveby,Comments,UnapproveDate) ");
            sb.Append(" SELECT plo.`LedgerTransactionNo`,plo.`Test_ID`,'" + EmployeeID + "'UnapprovebyID,'" + EmployeeName + "'Unapproveby, ");
            sb.Append(" 'Patient Demographical Details Changes From Insta'Comments,now() ");
            sb.Append(" FROM patient_labinvestigation_opd plo  WHERE plo.Patient_ID=@Patient_ID AND plo.Interface_companyName=@Interface_companyName and Approved=1 ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@Patient_ID", Util.GetString(dr["Patient_ID"])),
                        new MySqlParameter("@Interface_companyName", Util.GetString(dr["InterfaceClient"])));

            // For insta update to not approve the report
            if (Util.GetString(dr["InterfaceClient"]).ToLower().Trim() == "insta")
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO booking_data_notapproved ");
                sb.Append(" (Test_ID,ItemID_Interface,LedgerTransactionNo,dtEntry,IsSync,UniqueID) ");
                sb.Append(" SELECT plo.`Test_ID`,plo.`ItemID_Interface`,plo.`LedgerTransactionNoOLD`, ");
                sb.Append(" NOW(),'0',plo.`UniqueID` ");
                sb.Append(" FROM `patient_labinvestigation_opd` plo WHERE Patient_ID=@Patient_ID AND Interface_companyName=@Interface_companyName and Approved=1 ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@Patient_ID", Util.GetString(dr["Patient_ID"])),
                            new MySqlParameter("@Interface_companyName", Util.GetString(dr["InterfaceClient"])));
            }

            // Updation patient_labinvestigation_opd
            sb = new StringBuilder();
            sb.Append(" UPDATE patient_labinvestigation_opd ");
            sb.Append(" SET Approved = @Approved, isForward = @isForward, isPrint = @isPrint  ");
            sb.Append("  WHERE Patient_ID=@Patient_ID AND Interface_companyName=@Interface_companyName  AND Approved=1 ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@Approved", "0"),
                        new MySqlParameter("@isForward", "0"),
                        new MySqlParameter("@isPrint", "0"),
                        new MySqlParameter("@Patient_ID", Util.GetString(dr["Patient_ID"])),
                        new MySqlParameter("@Interface_companyName", Util.GetString(dr["InterfaceClient"])));


            // Updation patient_labobservation_opd_mic for microbiology approved reports
            sb = new StringBuilder();
            sb.Append(" UPDATE  ");
            sb.Append(" patient_labinvestigation_opd pli  ");
            sb.Append(" INNER JOIN patient_labobservation_opd_mic mic ON pli.test_id=mic.testid ");
            sb.Append(" AND mic.reporttype=pli.`reportnumber` ");
            sb.Append(" SET mic.`Approved`=@Approved ");
            sb.Append(" WHERE pli.Patient_ID=@Patient_ID AND pli.Interface_companyName=@Interface_companyName; ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@Approved", "0"),
                        new MySqlParameter("@Patient_ID", Util.GetString(dr["Patient_ID"])),
                        new MySqlParameter("@Interface_companyName", Util.GetString(dr["InterfaceClient"])));

        }


        sb = new StringBuilder();
        sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
        sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,'" + LastUpdatedData + " changed by insta Integration ','" + EmployeeID + "','" + EmployeeName + "','',CentreID, ");
        sb.Append(" '" + RoleID + "',NOW(),'' FROM patient_labinvestigation_opd   WHERE Patient_ID=@Patient_ID AND Interface_companyName=@Interface_companyName group by BarCodeNo ");
        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@Patient_ID", Util.GetString(dr["Patient_ID"])),
                    new MySqlParameter("@Interface_companyName", Util.GetString(dr["InterfaceClient"])));

    }

}