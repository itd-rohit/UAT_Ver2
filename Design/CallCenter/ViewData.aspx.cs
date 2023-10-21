using System;
using System.Data;

public partial class Design_Websitedata_ViewData : System.Web.UI.Page
{
    public DataTable dt = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            binddata(Util.GetString(Request.QueryString["id"]), Util.GetString(Request.QueryString["type"]));
        }
    }

    private void binddata(string id, string type)
    {
        if (type == "GN")
        {
            dt = StockReports.GetDataTable("SELECT GEFNAME Firstname,GELNAME Lastname,GEMBNO Mobile,GEEMAILID Email, GECOMMENT Comment FROM gen_enq where id='" + id + "'");
        }
        else if (type == "OnlineApp")
        {
            dt = StockReports.GetDataTable("SELECT OAFNAME Firstname , OALNAME Lastname ,OAMBNO Mobile,  OAEMAILID  Email, OATEST TestName,  OADATE Appdate FROM onlineapp where id='" + id + "'");
        }
        else if (type == "Feedback")
        {
            String st = @"SELECT FBNAME	NAME,DATE_FORMAT(FBDOV,'%d-%b-%Y') VisitDate,
FBADDRESS Address,FBMBNO	Mobile,FBEMAILID EmailID,
 FBVISTITIME	`What_time_did_you_visit_us?`,
 FBKNOWABT	`How_did_you_come_to_know_Overview?`,
 FBWHYCCL	`Why_did_you_choose_CCL_Lab?`,
 FBREGPROCESS	`Was_the_registration_process_easy_and_convenient?`,
 FBSTAFF `Was_the_staff_at_registration_counter_courteous?`,FBBLOODTIME	`How_long_was_the_waiting_time_before_drawing_blood?`,
 FBTECH  `Was_the_technician_courteous_and_efficient?`,
 FBREPORT	`How_would_you_like_to_collect_your_report?`,
 FBREPSERVICE	`Are_you_aware_of_our_home_collection_and_report_delivery_service?`,
 FBRATE	    `How_would_you_rate_our_overall_services_of_the_lab?`,
 FBRECMMEND	`Would_you_recommend_our_services_to_others?`,
 FBFEEDBACK      `Please_share_your_feedback_to_help_us_serve_you_better` FROM feedback where id='" + id + "'";
            dt = StockReports.GetDataTable(st);
        }
        else if (type == "busopp")
        {
            string st1 = @"SELECT
BOTITLE Title,
  BONAME NAME,
  BOOCCP Occupation,
  BOTCITY Temporary_Address_City,
  BOTSTATE Temporary_Address_State,
  BOTPIN Temporary_Address_Pin,
  BOPCITY Permanent_Address_city,
  BOPSTATE Permanent_Address_State,
  BOPPIN Permanent_Address_Pin,
  BOBCITY Business_Address_city,
  BOBSTATE Business_Address_state,
  BOBPIN Business_Address_pin,
  BOTELR Contacts_Telephone_R,
  BOTELO Contacts_Telephone_O,
  BOFAX Contacts_Fax,
  BOEMAIL  Contacts_Email,
  BOAPPCITY ApplyFor_City,
  BOAPPSTATE ApplyFor_State,
  BOFIN1 Financial_Credentials1,
  BOFIN2 Financial_Credentials2,
  BOEXP1 `Experience_in_the_Medical/Diagnostic_Fields1`,
  BOEXP2 `Experience_in_the_Medical/Diagnostic_Fields2`,
  BOBUSSOPP1 Business_Operations1,
  BOBUSSOPP2 Business_Operations2
  FROM bus_opp where id='" + id + "'";
            dt = StockReports.GetDataTable(st1);
        }
        else if (type == "busoppcol")
        {
            string st2 = @"SELECT
BOTITLE Title,
  BONAME NAME,
  BOOCCP Occupation,
  BOTCITY Temporary_Address_City,
  BOTSTATE Temporary_Address_State,
  BOTPIN Temporary_Address_Pin,
  BOPCITY Permanent_Address_city,
  BOPSTATE Permanent_Address_State,
  BOPPIN Permanent_Address_Pin,
  BOBCITY Business_Address_city,
  BOBSTATE Business_Address_state,
  BOBPIN Business_Address_pin,
  BOTELR Contacts_Telephone_R,
  BOTELO Contacts_Telephone_O,
  BOFAX Contacts_Fax,
  BOEMAIL  Contacts_Email,
  BOAPPCITY ApplyFor_City,
  BOAPPSTATE ApplyFor_State,
  BOFIN1 Financial_Credentials1,
  BOFIN2 Financial_Credentials2,
  BOEXP1 `Experience_in_the_Medical/Diagnostic_Fields1`,
  BOEXP2 `Experience_in_the_Medical/Diagnostic_Fields2`,
  BOBUSSOPP1 Business_Operations1,
  BOBUSSOPP2 Business_Operations2
  FROM bus_opp_col where id='" + id + "'";
            dt = StockReports.GetDataTable(st2);
        }
    }
}