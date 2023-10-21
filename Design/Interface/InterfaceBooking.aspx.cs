using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Master_InterfaceBooking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            BindCompany();
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    private void BindCompany()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "Select ID,CompanyName from f_Interface_Company_Master  order by CompanyName").Tables[0])
            {
                ddlCompany.DataSource = dt;
                ddlCompany.DataTextField = "CompanyName";
                ddlCompany.DataValueField = "ID";
                ddlCompany.DataBind();
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
    }

    

    [WebMethod]
    public static string searchInterface(string fromDate, string toDate, string CompanyName, string SearchType, string Status, string IsSearch, string SearchField, string SearchData, string CentreIDs, int CompanyID)
    {
       

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CentreIDTags = CentreIDs.Split(',');
            string[] CentreIDParamNames = CentreIDTags.Select((s, i) => "@tag" + i).ToArray();
            string CentreIDClause = string.Join(", ", CentreIDParamNames);

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT bd.ID,bd.InterfaceClient,bd.Type,bd.Doctor_id,bd.Doctorname,cm.Interface_centrename Centre,bd.WorkOrderID,CONCAT(bd.Title,' ',bd.PName)PatientName,bd.Patient_ID UHIDNo,bd.Mobile,bd.Gender,bd.Age,bd.ItemId_Interface TestCode, ");
            sb.Append(" bd.ItemName_Interface TestName,bd.BarcodeNo SinNo,if(bd.IsBooked=1,'',bd.Response)Response, ");
            sb.Append(" CASE WHEN bd.IsBooked=1 THEN 'Booked' WHEN  bd.IsBooked=0 THEN 'Pending' WHEN bd.IsBooked=-1 THEN 'Fail' ELSE '' END Status,bd.IsBooked, ");
            sb.Append(" DATE_FORMAT(bd.`StagingTableDateTime`,'%d-%b-%Y %I:%i:%s %p') StagingTableDateTime,  ");
            sb.Append(" DATE_FORMAT(bd.`EntryDateTime`,'%d-%b-%Y %I:%i:%s %p') ITDoseReceivedDateTime, ");
            sb.Append(" DATE_FORMAT(bd.`dtAccepted`,'%d-%b-%Y %I:%i:%s %p') ITDoseBookedDateTime,  ");
            sb.Append(" TIMEDIFF(bd.`EntryDateTime`,bd.`StagingTableDateTime`)ITDoseReceivedTimeDiffrence,  ");
            sb.Append(" TIMEDIFF(bd.`dtAccepted`,bd.`EntryDateTime`)ITDoseBookedTimeDiffrence, ");
            sb.Append(" IF(bd.isurgent=1,'Yes','No')isurgent,IF(bd.AllowPrint=1,'Yes','No')AllowPrint,IFNULL(bd.Interface_BillNo,'')Interface_BillNo ");
            if (IsSearch == "0")
            {
                sb.Append(" ,bd.WorkOrderID_Creat,bd.UniqueID,bd.Patient_ID_creat,bd.Title,bd.PName,bd.Address,bd.localityid,bd.Locality,bd.cityid,bd.City,bd.stateid,");
                sb.Append(" bd.State,bd.Pincode,bd.Country,bd.Phone,bd.Email,bd.CentreID_Interface,bd.VIP,bd.Panel_ID,bd.HLMPatientType,bd.HLMOPDIPDNo,bd.bed_type,");
                sb.Append(" bd.ward_name,bd.BarcodeNo,bd.ItemId_interface,bd.ItemName_interface,bd.ItemID_AsItdose,bd.SampleCollectionDate,bd.SampleTypeID,bd.SampleTypeName,");
                sb.Append(" bd.IsBooked,bd.dtAccepted,bd.EntryDateTime,bd.TPA_Name,bd.Employee_id,bd.PackageName,bd.TechnicalRemarks,bd.Interface_Doctor_Mobile,");
                sb.Append(" bd.Interface_Referal_MobileNo,bd.Interface_Presc_Doctor_Mobile,bd.Interface_PackageCategoryID,bd.Interface_TPAID,bd.Interface_SampleTypeID,bd.ItemID_AsItdose ");
            }
            sb.Append(" ,IFNULL(bd.`HLMOPDIPDNo`,'') AS HLMOPDIPDNo ,IFNULL(bd.`HLMPatientType`,'')HLMPatientType ");
            sb.Append(" FROM booking_data bd INNER JOIN `centre_master_interface` cm ON bd.CentreID_Interface=cm.CentreID_Interface and  cm.Interface_CompanyID=bd.InterfaceClientID ");
            sb.Append(" WHERE bd.InterfaceClientID=@CompanyID ");
            if (SearchType != "2")
                sb.Append(" AND IsBooked=@SearchType ");
            sb.Append("  ");
            sb.Append(" AND bd.EntryDateTime>=@fromDate ");
            sb.Append(" AND bd.EntryDateTime<=@toDate ");
            sb.Append(" AND bd.CentreID_Interface IN({0})");
            if (SearchData.Trim() != string.Empty)
            {
                if (SearchField != "bd.PName")
                {
                    sb.Append(" AND @SearchField=@SearchData ");
                }
                else
                {
                    sb.Append(" AND @SearchField like @SearchDataValue ");
                }
            }

            sb.Append(" UNION ALL  ");

            sb.Append(" SELECT bd.ID,bd.InterfaceClient,bd.Type,bd.Doctor_id,bd.Doctorname,cm.Interface_centrename Centre,bd.WorkOrderID,CONCAT(bd.Title,' ',bd.PName)PatientName,bd.Patient_ID UHIDNo,bd.Mobile,bd.Gender,bd.Age,bd.ItemId_Interface TestCode, ");
            sb.Append(" bd.ItemName_Interface TestName,bd.BarcodeNo SinNo,bd.Response, ");
            sb.Append(" CASE WHEN bd.IsBooked=1 THEN 'Booked' WHEN  bd.IsBooked=0 THEN 'Pending' WHEN bd.IsBooked=-1 THEN 'Fail' ELSE '' END Status,bd.IsBooked, ");
            sb.Append(" DATE_FORMAT(bd.`StagingTableDateTime`,'%d-%b-%Y %I:%i:%s %p') StagingTableDateTime,  ");
            sb.Append(" DATE_FORMAT(bd.`EntryDateTime`,'%d-%b-%Y %I:%i:%s %p') ITDoseReceivedDateTime, ");
            sb.Append(" DATE_FORMAT(bd.`dtAccepted`,'%d-%b-%Y %I:%i:%s %p') ITDoseBookedDateTime ,  ");
            sb.Append(" TIMEDIFF(bd.`EntryDateTime`,bd.`StagingTableDateTime`)ITDoseReceivedTimeDiffrence,  ");
            sb.Append(" TIMEDIFF(bd.`dtAccepted`,bd.`EntryDateTime`)ITDoseBookedTimeDiffrence ");
            sb.Append(" ,IF(bd.isurgent=1,'Yes','No')isurgent,IF(bd.AllowPrint=1,'Yes','No')AllowPrint,'' Interface_BillNo ");
            if (IsSearch == "0")
            {
                sb.Append(" ,bd.WorkOrderID_Creat,bd.UniqueID,bd.Patient_ID_creat,bd.Title,bd.PName,bd.Address,bd.localityid,bd.Locality,bd.cityid,bd.City,bd.stateid,");
                sb.Append(" bd.State,bd.Pincode,bd.Country,bd.Phone,bd.Email,bd.CentreID_Interface,bd.VIP,bd.Panel_ID,bd.HLMPatientType,bd.HLMOPDIPDNo,bd.bed_type,");
                sb.Append(" bd.ward_name,bd.BarcodeNo,bd.ItemId_interface,bd.ItemName_interface,bd.ItemID_AsItdose,bd.SampleCollectionDate,bd.SampleTypeID,bd.SampleTypeName,");
                sb.Append(" bd.IsBooked,bd.dtAccepted,bd.EntryDateTime,bd.TPA_Name,bd.Employee_id,bd.PackageName,bd.TechnicalRemarks,'' AS Interface_Doctor_Mobile,");
                sb.Append(" '' AS Interface_Referal_MobileNo,'' AS Interface_Presc_Doctor_Mobile,'' Interface_PackageCategoryID,'' Interface_TPAID,'' Interface_SampleTypeID,bd.ItemID_AsItdose ");
            }
            sb.Append(" ,IFNULL(bd.`HLMOPDIPDNo`,'') AS HLMOPDIPDNo ,IFNULL(bd.`HLMPatientType`,'')HLMPatientType ");
            sb.Append(" FROM " + Resources.Resource.LogDataBaseName + ".`booking_data_before_delete` bd INNER JOIN `centre_master_interface` cm ON bd.CentreID_Interface=cm.CentreID_Interface and  cm.Interface_CompanyID=bd.InterfaceClientID ");
            sb.Append(" WHERE bd.InterfaceClientID=@CompanyID ");
            if (SearchType != "2")
                sb.Append(" AND IsBooked=@SearchType ");
            sb.Append("  ");
            sb.Append(" AND bd.EntryDateTime>=@fromDate ");
            sb.Append(" AND bd.EntryDateTime<=@toDate ");
            sb.Append(" AND bd.CentreID_Interface in({0})");
            if (SearchData.Trim() != string.Empty)
            {
                if (SearchField != "bd.PName")
                {
                    sb.Append(" AND @SearchField=@SearchData ");
                }
                else
                {
                    sb.Append(" AND @SearchField like @SearchDataValue ");
                }
            }
            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), CentreIDClause), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@CompanyID", CompanyID);
                da.SelectCommand.Parameters.AddWithValue("@SearchType", SearchType);
                da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " 00:00:00"));
                da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " 23:59:59"));

                da.SelectCommand.Parameters.AddWithValue("@SearchData", SearchData.Trim());
                da.SelectCommand.Parameters.AddWithValue("@SearchField", SearchField);
                da.SelectCommand.Parameters.AddWithValue("@SearchDataValue", string.Format("%{0}%", SearchData.Trim().Split('#')[0]));
                for (int i = 0; i < CentreIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(CentreIDParamNames[i], CentreIDTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (IsSearch == "1")
                    {
                        return Util.getJson(dt);
                        
                    }
                    else
                    {
                        dt.Columns.Remove("ID");
                        dt.Columns.Remove("IsBooked");
                        dt.Columns.Remove("ItemID_AsItdose");
                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "InterfaceBooking";
                        return "";

                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "Error";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindInstaCentre()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT CentreID_interface CentreID,Interface_CentreName FROM `centre_master_interface` ORDER BY `Interface_CentreName` "
                ).Tables[0])
            {
                return Util.getJson(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.getJson(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static bool compareDate(DateTime fromDate, DateTime toDate)
    {
        double diffDays = (toDate - fromDate).TotalDays;
        if (diffDays > 2 || diffDays < 0)
            return false;
        else
            return true;
    }

    [WebMethod]
    public static string resendInterface(int ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            // Booking_data Update
            if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select count(*) from booking_data where ID=@ID ", new MySqlParameter("@ID", ID))) > 0)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE booking_data SET IsBooked=0 WHERE ID=@ID ", new MySqlParameter("@ID", ID));
            }
            // Booking_data_log Update
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO  apollo_live_new.booking_data ( ID ,  InterfaceClient ,  TYPE ,  WorkOrderID ,  WorkOrderID_Creat ,  UniqueID ,  Patient_ID ,  Patient_ID_creat ,  Title ,  PName ,  Address ,  localityid ,  Locality ,  cityid ,  City ,  stateid ,  State ,  Pincode ,  Country ,  Phone ,  Mobile ,  Email ,  DOB ,  Age ,  AgeYear ,  AgeMonth ,  AgeDays ,  Gender ,  CentreID_Interface ,  VIP ,  isUrgent ,  Panel_ID ,  Doctor_ID ,  DoctorName ,  HLMPatientType ,  HLMOPDIPDNo ,  bed_type ,  ward_name ,  BarcodeNo ,  ItemId_interface ,  ItemName_interface ,  ItemID_AsItdose ,  SampleCollectionDate ,  SampleTypeID ,  SampleTypeName ,   TPA_Name ,  Employee_id ,  PackageName ,  TechnicalRemarks ,  StagingTableDateTime    ) SELECT ID ,  InterfaceClient ,  TYPE ,  WorkOrderID ,  WorkOrderID_Creat ,  UniqueID ,  Patient_ID ,  Patient_ID_creat ,  Title ,  PName ,  Address ,  localityid ,  Locality ,  cityid ,  City ,  stateid ,  State ,  Pincode ,  Country ,  Phone ,  Mobile ,  Email ,  DOB ,  Age ,  AgeYear ,  AgeMonth ,  AgeDays ,  Gender ,  CentreID_Interface ,  VIP ,  isUrgent ,  Panel_ID ,  Doctor_ID ,  DoctorName ,  HLMPatientType ,  HLMOPDIPDNo ,  bed_type ,  ward_name ,  BarcodeNo ,  ItemId_interface ,  ItemName_interface ,  ItemID_AsItdose ,  SampleCollectionDate ,  SampleTypeID ,  SampleTypeName ,   TPA_Name ,  Employee_id ,  PackageName ,  TechnicalRemarks ,  StagingTableDateTime  FROM apollo_live_new_log.`booking_data_before_delete` where id=@ID ", new MySqlParameter("@ID", ID));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from apollo_live_new_log.`booking_data_before_delete` where id=@ID ", new MySqlParameter("@ID", ID));
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string encryptID(string ID)
    {
        return Common.EncryptRijndael(ID);
    }
}