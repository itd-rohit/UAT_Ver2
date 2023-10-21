using System;
using System.Collections.Generic;

using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;

public partial class Design_Mobile_DeltaCheck : System.Web.UI.Page
{
    public DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DATE_FORMAT(pli.`Date`,'%d-%b-%y %I:%i%p')BookingDate,plo.`LabObservationName`,plo.`Value`,plo.`ReadingFormat` ,plo.`MinValue`,plo.`MaxValue`,''`DisplayReading` ");
        sb.Append(" FROM `patient_labobservation_opd` plo  INNER JOIN `patient_labinvestigation_opd` pli ON plo.`Test_ID`=pli.`Test_ID` ");
        sb.Append(" AND pli.date>=DATE_ADD(CURRENT_DATE, INTERVAL -2 MONTH) ");
        sb.Append(" AND pli.`Patient_ID`=(SELECT patient_id FROM `patient_labinvestigation_opd` WHERE  Test_ID='" + Request.QueryString["TestID"].ToString() + "' ) AND plo.`LabObservation_ID`='" + Request.QueryString["LabObservation_ID"].ToString() + "' AND plo.`Value`<>'' and pli.`Approved`=1  ORDER BY pli.`Date` ");
        dt = StockReports.GetDataTable(sb.ToString());
        //if (dt.Rows.Count == 0)
        //{
        //    show.Visible = false;
        //}

    }

    public string getTags(string Value, string MinRange, string MaxRange, string AbnormalValue)
    {
        string ret_value = Value;

        if (Value == "HEAD")
            return "&nbsp;";

        try
        {
            if ((MinRange == "") && (MaxRange == ""))
                ret_value = Value;
            else
            {
                if ((MinRange != "") && (Util.GetFloat(Value) < Util.GetFloat(MinRange)))
                    ret_value = "<span class='AbnormalResult'>" + ret_value + "</span>";
                else if ((MaxRange != "") && (Util.GetFloat(Value) > Util.GetFloat(MaxRange)))
                    ret_value = "<span class='AbnormalResult'>" + ret_value + "</span>";


            }
            if (AbnormalValue != "" && AbnormalValue == Value)
                ret_value = "<span class='AbnormalResult'>" + ret_value + "</span>";
        }
        catch (Exception ex) { }

        return ret_value;

    }

    public string getTags_Flag(string Value, string MinRange, string MaxRange, string AbnormalValue)
    {
        string ret_value = Value;
        try
        {

            if ((MinRange != "") && (Util.GetFloat(Value) < Util.GetFloat(MinRange)))
                ret_value = "L";
            else if ((MaxRange != "") && (Util.GetFloat(Value) > Util.GetFloat(MaxRange)))
                ret_value = "H";
 
        }
        catch (Exception ex) { }

        if (ret_value == Value)
            ret_value = "";

        return ret_value;

    }
}