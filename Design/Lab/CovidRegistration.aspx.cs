using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using RestSharp;
using System.Net;
using System.Text.RegularExpressions;
public partial class Design_Lab_CovidRegistration : System.Web.UI.Page
{
     public StringBuilder sbResponse = new StringBuilder();
     public StringBuilder sbDis = new StringBuilder();
     public StringBuilder sbResult = new StringBuilder();
    public string CentreID="";
     string LedgerTransactionID = "";
     DataTable dtCentre = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
		
        if (!IsPostBack)
        {
            LedgerTransactionID = Util.GetString(Request.QueryString["LedgerTransactionID"]);

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                string Ltdata = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select Concat(srfno,'#',Centreid) from f_ledgertransaction where LedgerTransactionID=@LedgerTransactionID"
                 , new MySqlParameter("@LedgerTransactionID", LedgerTransactionID))).Trim();
                string srfno = Ltdata.Split('#')[0];
                CentreID = Ltdata.Split('#')[1];
                dtCentre = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select ICMR_UserID,ICMR_Password from Centre_Master where CentreID=@CentreID and ICMR_UserID  <> '' and ICMR_Password <>'' "
                     , new MySqlParameter("@CentreID", CentreID)).Tables[0];
                if (srfno != "")
                {
                   int _count= Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select count(1) from covid19 where LedgerTransactionID=@LedgerTransactionID"
                 , new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)));

                    if(_count==0 && dtCentre.Rows.Count>0)
                    ProcessSRFNo(srfno);
                }

                ///Fill Detail From LIS
                DataTable dtCov = new DataTable();
                //if (CentreID == "2")
                //{
                //    dtCov = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select lt.patient_id,IFNULL(DATE_FORMAT(ApprovedDate,'%d-%m-%Y %T'),'') sample_tdate,SampleCollectionDate sample_cdate,SampleReceiveDate sample_rdate,CardNo SRFNO,lt.LedgerTransactionno sample_id,(select value from  patient_labobservation_opd pli where pli.Test_Id =plo.Test_ID and pli.Value<>'' AND plo.`Approved`=1 LIMIT 1)Value  from Patient_labinvestigation_opd plo  inner join f_ledgertransaction lt on lt.LedgerTransactionID=plo.LedgerTransactionID and plo.ItemID in ('2118','2164','2162') where lt.LedgerTransactionID=@LedgerTransactionID "
                //    , new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)).Tables[0];
                //}
                //else
                //{
                    dtCov = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select plo.barcodeno patient_id,IFNULL(DATE_FORMAT(ApprovedDate,'%d-%m-%Y %T'),'') sample_tdate,SampleCollectionDate sample_cdate,SampleReceiveDate sample_rdate,SRFNO,lt.LedgerTransactionno sample_id,(select value from  patient_labobservation_opd pli where pli.Test_Id =plo.Test_ID AND pli.LabObservation_Id = '1469'  AND plo.`Approved`=1)Value  from Patient_labinvestigation_opd plo  inner join f_ledgertransaction lt on lt.LedgerTransactionID=plo.LedgerTransactionID and plo.ItemID in ('7831') where lt.LedgerTransactionID=@LedgerTransactionID "
                         , new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)).Tables[0];
              //  }
                if (dtCov.Rows.Count > 0)
                {
                    for (int i = 0; i < dtCov.Columns.Count; i++)
                    {
                        if (dtCov.Columns[i].ColumnName == "Value")
                        {
                            string PVal = dtCov.Rows[0][dtCov.Columns[i].ColumnName].ToString();
                            if (PVal.ToUpper() == "DETECTED") PVal = "Positive";
                            if (PVal.ToUpper() == "NOT DETECTED") PVal = "Negative";
                            if (PVal.ToUpper() == "POSITIVE" || PVal.ToUpper() == "NEGATIVE")
                            {
                                sbResult.Append("$('#covid19_result_egene').val('" + PVal + "');");
                                sbResult.Append("$('#final_result_of_sample').val('" + PVal + "');");

                                    if (PVal.ToUpper() == "NEGATIVE") PVal = "Negative";
                                    if (PVal.ToUpper() == "POSITIVE") PVal = "Positive";
                                    sbResult.Append("$('#covid19_result_egene').val('" + PVal + "');");
                                    sbResult.Append("$('#final_result_of_sample').val('" + PVal + "');");
                                    sbResult.Append("$('#rdrp_confirmatory').val('" + PVal + "');");
                               
                            }
                        }
                        else if (dtCov.Columns[i].ColumnName == "sample_id")
                        {
                            sbResult.Append("$('#" + dtCov.Columns[i].ColumnName + "').val('" + dtCov.Rows[0][dtCov.Columns[i].ColumnName].ToString() + "');");
                            if (CentreID == "1")
                            {
                               // sbResult.Append("$('#patient_id').val('" + dtCov.Rows[0]["patient_id"].ToString() + "');");
                            }
                            

                        }
                        else if (dtCov.Columns[i].ColumnName == "patient_id")
                        {
                           
                                sbResult.Append("$('#patient_id').val('" + dtCov.Rows[0]["patient_id"].ToString() + "');");
                           
                        }
                        else
                        {
                            sbResult.Append("$('#" + dtCov.Columns[i].ColumnName + "').val('" + dtCov.Rows[0][dtCov.Columns[i].ColumnName].ToString() + "');");
                        }
                    }


                    //if (CentreID == "1")
                    //{
                    //    sbResult.Append("$('#sample_type').val('Nasopharyngeal_Oropharyngeal');");
                    //    sbResult.Append("$('#testing_kit_used').val('True_PCR_Kelpest');");
                    //}
                    //else if (CentreID == "2")
                    //{
                    //    sbResult.Append("$('#sample_type').val('Oropharyngeal swab');");
                    //    sbResult.Append("$('#testing_kit_used').val('Truenat_duplex_molbio');");

                    //    sbResult.Append("$('#quarantined').val('Yes');");
                    //    sbResult.Append("$('#hospitalized').val('No');");
                       
                    //}
                }
                
            }
            catch
            {

            }
            finally {
                con.Close();
                con.Dispose();
            }

        
        }
    }
    private void ProcessSRFNo(string SRFNo)
    {


        try
        {
            var loginAddress = "https://cvstatus.icmr.gov.in/login.php";
            System.Net.ServicePointManager.SecurityProtocol |= SecurityProtocolType.Tls12;
            var client = new RestClient(loginAddress);
            client.UserAgent = "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.129 Safari/537.36";
            client.CookieContainer = new System.Net.CookieContainer();
            var request = new RestRequest(Method.GET);
            IRestResponse response = client.Execute(request);

            client.BaseUrl = new Uri("https://cvstatus.icmr.gov.in/authentication.php");
            request = new RestRequest(Method.POST);
            //request.AddParameter("application/x-www-form-urlencoded", "username=" + Util.getApp("icmr_username") + "&password=" + Util.getApp("icmr_password"), ParameterType.RequestBody);
            request.AddParameter("application/x-www-form-urlencoded", "username=" + dtCentre.Rows[0]["ICMR_UserID"].ToString() + "&password=" + dtCentre.Rows[0]["ICMR_Password"].ToString() + "", ParameterType.RequestBody);
            response = client.Execute(request);

            if (response.Content.ToString().Contains("Yes|DEO"))
            {

                client.BaseUrl = new Uri("https://cvstatus.icmr.gov.in/add_record.php");
                request = new RestRequest(Method.POST);
                request.AddParameter("application/x-www-form-urlencoded", "srf_id=" + SRFNo + "&srf_patient_id=&srf_icmr_id=0&srf_repeat_sample=0", ParameterType.RequestBody);
                response = client.Execute(request);

                string _response = response.Content.ToString();


                
				_response = _response.Replace("$.post('state_district_selection.php', { state: $(this).val() })", "$.get('getDistrict.aspx', { stateindex: $('#state').find(':selected').index() })");
                _response = _response.Replace("$('#patient_id').val('');", "");
           


                if (!_response.Contains(SRFNo))
                    return;

                string[] _content = _response.Split('\r');

                int _start = Array.IndexOf(_content, _content.Where(x => x.Contains("$('#srf_id').val('"+SRFNo+"');")).FirstOrDefault());

                if (_start == -1)
                    return;

                int _end = _start + 43;


                for (int i = _start; i <= _end; i++)
                {
                    sbResponse.Append(_content[i]);
                }
                int a = sbResponse.ToString().IndexOf("$.post('state_district_selection_new.php");
                if (a > 0)
                {
                    string PreRes = sbResponse.ToString().Substring(0, a);
                    string PostRes = sbResponse.ToString().Substring(PreRes.Length, sbResponse.ToString().Length - PreRes.Length);
                    int b = PostRes.ToString().IndexOf("});");
                    string PostNew = PostRes.Substring(b + 3, PostRes.Length - b - 3);
                    int PosDis = sbResponse.ToString().IndexOf("$('#district').val('");
                    string PreDis = sbResponse.ToString().Substring(PosDis, 30);
                    sbDis.Append(Regex.Split(PreDis, "'")[3].ToString());
                    sbResponse = new StringBuilder();
                    sbResponse.Append(PreRes + " " + PostNew);
                }
                else
                {
                    int b = sbResponse.ToString().IndexOf("$('#doctor_email').val('')");
                    if (b > 0)
                    {
                        string PreRes = sbResponse.ToString().Substring(0, b);
                        sbResponse = new StringBuilder();
                        sbResponse.Append(PreRes);
                        sbResponse.Append("$('#nationality').val('India');");
                    }
                }
            }
        }
        catch { 
        }
    }


    [WebMethod(EnableSession =true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Create(Covid19 data)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (data.LimsStatus == 0)
            {
                updateSRF(data,con,tnx);
                tnx.Commit();
                tnx.Dispose();
                con.Close();
                con.Dispose();
                return Newtonsoft.Json.JsonConvert.SerializeObject(data);
            }
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update covid19 set isActive=0 where @LedgerTransactionID=LedgerTransactionID"
                , new MySqlParameter("@LedgerTransactionID", data.LedgerTransactionID));

            StringBuilder myStr = new StringBuilder();
            myStr.Append("INSERT INTO `covid19`(`LedgerTransactionID`,`patient_id`,`gender`,`contact_number`,`email`,`aadhar_number`,`passport_number`,`village_town`,`ri_sari`,`travel_to_foreign_country`,`travel_history`,`quarantined`,`patient_name`,`age_in`,`age`,`contact_number_belongs_to`,`nationality`,`state`,`state_code`,`district`,`district_code`,`address`,`pincode`,`aarogya_setu_app_downloaded`,`date_of_arrival_in_india`,`are_you_healthcare_worker`,`ri_ili`,`contact_with_lab_confirmed_patient`,`confirmed_patient_name_if_contact_made`,`quarantined_where`,`final_status`,`sample_cdate`,`sample_type`,`status`,`underlying_medical_condition`,`hospitalization_date`,`hospital_state`,`sample_tdate`,`covid19_result_egene`,`orf1b_confirmatory`,`rdrp_confirmatory`,`final_result_of_sample`,`inf_a`,`pinf`,`h_metapneumovirus`,`other_test_conducted`,`result_of_other_test`,`doctor_mobile`,`sample_rdate`,`sample_id`,`date_of_onset_of_symptoms`,`hospitalized`,`hospital_name`,`hospital_district`,`testing_kit_used`,`ct_value_screening`,`ct_value_orf1b`,`ct_value_rdrp`,`repeat_sample`,`inf_b`,`rsv`,`adenovirus`,`rhinovirus`,`doctor_name`,`remarks`,`srf_id`,`CreatedBy`,`symptoms`,`patient_category`,`LimsStatus`,SRFNO,father_name,patient_occupation,mode_of_transport,sample_collected_from) ");
            myStr.Append(" VALUES (@LedgerTransactionID,@patient_id,@gender,@contact_number,@email,@aadhar_number,@passport_number,@village_town,@ri_sari,@travel_to_foreign_country,@travel_history,@quarantined,@patient_name,@age_in,@age,@contact_number_belongs_to,@nationality,@state,@state_code,@district,@district_code,@address,@pincode,@aarogya_setu_app_downloaded,@date_of_arrival_in_india,@are_you_healthcare_worker,@ri_ili,@contact_with_lab_confirmed_patient,@confirmed_patient_name_if_contact_made,@quarantined_where,@final_status,@sample_cdate,@sample_type,@status,@underlying_medical_condition,@hospitalization_date,@hospital_state,@sample_tdate,@covid19_result_egene,@orf1b_confirmatory,@rdrp_confirmatory,@final_result_of_sample,@inf_a,@pinf,@h_metapneumovirus,@other_test_conducted,@result_of_other_test,@doctor_mobile,@sample_rdate,@sample_id,@date_of_onset_of_symptoms,@hospitalized,@hospital_name,@hospital_district,@testing_kit_used,@ct_value_screening,@ct_value_orf1b,@ct_value_rdrp,@repeat_sample,@inf_b,@rsv,@adenovirus,@rhinovirus,@doctor_name,@remarks,@srf_id,@CreatedBy,@symptoms,@patient_category,@LimsStatus,@SRFNO,@father_name,@patient_occupation,@mode_of_transport,@sample_collected_from); ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, myStr.ToString(),
                new MySqlParameter("@LedgerTransactionID", data.LedgerTransactionID),
                new MySqlParameter("@CreatedBy", UserInfo.ID),
new MySqlParameter("@patient_id", data.patient_id),
new MySqlParameter("@gender", data.gender),
new MySqlParameter("@contact_number", data.contact_number),
//new MySqlParameter("@email", data.email),
new MySqlParameter("@aadhar_number", data.aadhar_number),
new MySqlParameter("@passport_number", data.passport_number),
new MySqlParameter("@village_town", data.village_town),
new MySqlParameter("@ri_sari", data.ri_sari),
new MySqlParameter("@travel_to_foreign_country", data.travel_to_foreign_country),
new MySqlParameter("@travel_history", data.travel_history),
new MySqlParameter("@quarantined", data.quarantined),
new MySqlParameter("@patient_name", data.patient_name),
new MySqlParameter("@age_in", data.age_in),
new MySqlParameter("@age", data.age),
new MySqlParameter("@contact_number_belongs_to", data.contact_number_belongs_to),
new MySqlParameter("@nationality", data.nationality),
new MySqlParameter("@state", data.state),
new MySqlParameter("@state_code", Util.GetInt(data.state_code)),
new MySqlParameter("@district", data.district),
new MySqlParameter("@district_code", Util.GetInt(data.district_code)),
new MySqlParameter("@address", data.address),
new MySqlParameter("@pincode", data.pincode),
new MySqlParameter("@aarogya_setu_app_downloaded", data.aarogya_setu_app_downloaded),
new MySqlParameter("@date_of_arrival_in_india", data.date_of_arrival_in_india),
new MySqlParameter("@are_you_healthcare_worker", data.are_you_healthcare_worker),
new MySqlParameter("@ri_ili", data.ri_ili),
new MySqlParameter("@contact_with_lab_confirmed_patient", data.contact_with_lab_confirmed_patient),
new MySqlParameter("@confirmed_patient_name_if_contact_made", data.confirmed_patient_name_if_contact_made),
new MySqlParameter("@quarantined_where", data.quarantined_where),
new MySqlParameter("@final_status", data.final_status),
new MySqlParameter("@sample_cdate", data.sample_cdate),
new MySqlParameter("@sample_type", data.sample_type),
new MySqlParameter("@status", data.status),
new MySqlParameter("@underlying_medical_condition", data.underlying_medical_condition),
new MySqlParameter("@hospitalization_date", data.hospitalization_date),
new MySqlParameter("@hospital_state", data.hospital_state),
new MySqlParameter("@sample_tdate", data.sample_tdate),
new MySqlParameter("@covid19_result_egene", data.covid19_result_egene),
new MySqlParameter("@orf1b_confirmatory", data.orf1b_confirmatory),
new MySqlParameter("@rdrp_confirmatory", data.rdrp_confirmatory),
new MySqlParameter("@final_result_of_sample", data.final_result_of_sample),
new MySqlParameter("@inf_a", data.inf_a),
new MySqlParameter("@pinf", data.pinf),
new MySqlParameter("@h_metapneumovirus", data.h_metapneumovirus),
new MySqlParameter("@other_test_conducted", data.other_test_conducted),
new MySqlParameter("@result_of_other_test", data.result_of_other_test),
new MySqlParameter("@doctor_mobile", data.doctor_mobile),
new MySqlParameter("@sample_rdate", data.sample_rdate),
new MySqlParameter("@sample_id", data.sample_id),
new MySqlParameter("@date_of_onset_of_symptoms", data.date_of_onset_of_symptoms),
new MySqlParameter("@symptoms", data.symptoms),

new MySqlParameter("@hospitalized", data.hospitalized),
new MySqlParameter("@hospital_name", data.hospital_name),
new MySqlParameter("@hospital_district", data.hospital_district),
new MySqlParameter("@testing_kit_used", data.testing_kit_used),
new MySqlParameter("@ct_value_screening", data.ct_value_screening),
new MySqlParameter("@ct_value_orf1b", data.ct_value_orf1b),
new MySqlParameter("@ct_value_rdrp", data.ct_value_rdrp),
new MySqlParameter("@repeat_sample", data.repeat_sample),
new MySqlParameter("@inf_b", data.inf_b),
new MySqlParameter("@rsv", data.rsv),
new MySqlParameter("@adenovirus", data.adenovirus),
new MySqlParameter("@rhinovirus", data.rhinovirus),
new MySqlParameter("@doctor_name", data.doctor_name),
new MySqlParameter("@remarks", data.remarks),
new MySqlParameter("@patient_category", data.patient_category),
new MySqlParameter("@LimsStatus", data.LimsStatus),
new MySqlParameter("@father_name", data.father_name),
new MySqlParameter("@patient_occupation", data.patient_occupation),
new MySqlParameter("@mode_of_transport", data.mode_of_transport),
new MySqlParameter("@sample_collected_from", data.sample_collected_from),
new MySqlParameter("@SRFNO", data.SRFNO),
new MySqlParameter("@srf_id", data.SRFNO));

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update Patient_LabInvestigation_opd set pdfCreated=@pdfCreated where @LedgerTransactionID=LedgerTransactionID"
                , new MySqlParameter("@LedgerTransactionID", data.LedgerTransactionID)
                , new MySqlParameter("@pdfCreated", data.LimsStatus));


            tnx.Commit();
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            tnx.Dispose();
            con.Close();
            con.Dispose();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            throw (ex);

        }
        return Newtonsoft.Json.JsonConvert.SerializeObject(data);
    }

    private static void updateSRF(Covid19 data, MySqlConnection con, MySqlTransaction tnx)
    {
        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "update f_ledgertransaction set CardNo=@CardNo where LedgerTransactionID=@LedgerTransactionID"
                 , new MySqlParameter("@CardNo", data.SRFNO)   
                 , new MySqlParameter("@LedgerTransactionID", data.LedgerTransactionID));

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Get(int LedgerTransactionID)
    {
        
        DataTable dt = new DataTable();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        

        try
        {
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "  select SRFNO, `id`,`LedgerTransactionID`,`patient_id`,`gender`,`contact_number`,`email`,`aadhar_number`,`passport_number`,`village_town`,`ri_sari`,`travel_to_foreign_country`,`travel_history`,`quarantined`,`patient_name`,`age_in`,`age`,`contact_number_belongs_to`,`nationality`,`state`,`state_code`,`district`,`district_code`,`address`,`pincode`,`aarogya_setu_app_downloaded`,`date_of_arrival_in_india`,`are_you_healthcare_worker`,`ri_ili`,`contact_with_lab_confirmed_patient`,`confirmed_patient_name_if_contact_made`,`quarantined_where`,`final_status`,`sample_cdate`,`sample_type`,`status`,`underlying_medical_condition`,`hospitalization_date`,`hospital_state`,`sample_tdate`,`covid19_result_egene`,`orf1b_confirmatory`,`rdrp_confirmatory`,`final_result_of_sample`,`inf_a`,`pinf`,`h_metapneumovirus`,`other_test_conducted`,`result_of_other_test`,`doctor_mobile`,`sample_rdate`,`sample_id`,`date_of_onset_of_symptoms`,`hospitalized`,`hospital_name`,`hospital_district`,`testing_kit_used`,`ct_value_screening`,`ct_value_orf1b`,`ct_value_rdrp`,`repeat_sample`,`inf_b`,`rsv`,`adenovirus`,`rhinovirus`,`doctor_name`,`remarks`,`srf_id`,`CreatedBy`,`isActive`,`symptoms`,`patient_category`,`LimsStatus`,father_name,patient_occupation,mode_of_transport,sample_collected_from from covid19 where isActive=1 and LedgerTransactionID=@LedgerTransactionID",
                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)
                ).Tables[0];

            if (dt.Rows.Count == 0)
            {

                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT lt.`patient_id`,SUBSTR(pm.`gender`,1,1)`gender`,pm.`mobile` AS `contact_number`, ");
                sb.Append(" pm.`email`,'' SRFNO ");
                sb.Append(" , pm.Pname `patient_name`, ");
                sb.Append(" CASE WHEN pm.ageyear > 0 THEN pm.ageyear WHEN pm.agemonth > 0 THEN pm.agemonth ELSE pm.agedays END `age`, ");
                sb.Append(" CASE WHEN pm.ageyear > 0 THEN 'Years' WHEN pm.agemonth > 0 THEN 'Months' ELSE 'Days' END `age_in`, ");
                sb.Append(" REPLACE(pm.house_no, '^', ' ') `address`, pm.pincode ");
                sb.Append(" FROM `f_ledgertransaction` lt ");
                sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`= lt.`Patient_ID`  ");
                sb.Append(" WHERE lt.`LedgerTransactionID`= @LedgerTransactionID; ");
                //System.IO.File.WriteAllText(@"D:\Production\SARAL_LIVE\ItdoseLab\ErrorLog\cov.txt", sb.ToString());
                DataTable dtRecord= MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)
                ).Tables[0];
                DataRow dr = dt.NewRow();
                if (dtRecord.Rows.Count == 1)
                {
                    
                    foreach (DataColumn dc in dtRecord.Columns)
                    {
                        if (dt.Columns.Contains(dc.ColumnName))
                            dr[dc.ColumnName] = dtRecord.Rows[0][dc.ColumnName].ToString();
                    }
                   
                }
                dt.Rows.Add(dr);
                dt.AcceptChanges();
            }

            con.Close();
            con.Dispose();
        }
        catch (Exception ex)
        {
            con.Close();
            con.Dispose();
            throw (ex);

        }

        if (dt.Rows.Count == 1)
        {
            DataRow dr = dt.Rows[0];
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
        }
        else
        {
            DataRow dr = dt.NewRow();



        }
        return "";

    }

   

    }