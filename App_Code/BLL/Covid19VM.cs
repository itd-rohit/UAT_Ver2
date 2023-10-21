using MySql.Data.MySqlClient;

public class Covid19
{
    public string other_underlying_medical_conditions;

    public string patient_id { get; set; }
    public string gender { get; set; }
    public string contact_number { get; set; }
    public string email { get; set; }
    public string aadhar_number { get; set; }
    public string passport_number { get; set; }
    public string village_town { get; set; }
    public string patient_category { get; set; }
    public string ri_sari { get; set; }
    public string travel_to_foreign_country { get; set; }
    public string travel_history { get; set; }
    public string quarantined { get; set; }
    public string patient_name { get; set; }
    public string age_in { get; set; }
    public string age { get; set; }
    public string contact_number_belongs_to { get; set; }
    public string nationality { get; set; }
    public string state { get; set; }
    public string state_code { get; set; }
    public string district { get; set; }
    public string district_code { get; set; }
    public string address { get; set; }
    public string pincode { get; set; }
    public string aarogya_setu_app_downloaded { get; set; }
    public string date_of_arrival_in_india { get; set; }
    public string are_you_healthcare_worker { get; set; }
    public string ri_ili { get; set; }
    public string contact_with_lab_confirmed_patient { get; set; }
    public string confirmed_patient_name_if_contact_made { get; set; }
    public string quarantined_where { get; set; }
    public string final_status { get; set; }
    public string sample_cdate { get; set; }
    public string sample_type { get; set; }
    public string status { get; set; }
    public string underlying_medical_condition { get; set; }
    public string hospitalization_date { get; set; }
    public string hospital_state { get; set; }
    public string sample_tdate { get; set; }
    public string covid19_result_egene { get; set; }
    public string orf1b_confirmatory { get; set; }
    public string rdrp_confirmatory { get; set; }
    public string final_result_of_sample { get; set; }
    public string inf_a { get; set; }
    public string pinf { get; set; }
    public string h_metapneumovirus { get; set; }
    public string other_test_conducted { get; set; }
    public string result_of_other_test { get; set; }
    public string doctor_mobile { get; set; }
    public string sample_rdate { get; set; }
    public string sample_id { get; set; }
    public string date_of_onset_of_symptoms { get; set; }
    public string symptoms { get; set; }
public string hospitalized { get; set; }
public string hospital_name { get; set; }
public string hospital_district { get; set; }
public string testing_kit_used { get; set; }
public string ct_value_screening { get; set; }
public string ct_value_orf1b { get; set; }
public string ct_value_rdrp { get; set; }
public string repeat_sample { get; set; }
public string inf_b { get; set; }
public string rsv { get; set; }
public string adenovirus { get; set; }
public string rhinovirus { get; set; }
public string doctor_name { get; set; }
public string remarks { get; set; }
public string srf_id { get; set; }
public string SRFNO { get; set; }
    public int? LedgerTransactionID { get; set; }
    public int? CreatedBy { get; set; }

    public int? LimsStatus { get; set; }
    public string father_name { get; set; }
    public string patient_occupation { get; set; }
    public string mode_of_transport { get; set; }
    public string sample_collected_from { get; set; }

}