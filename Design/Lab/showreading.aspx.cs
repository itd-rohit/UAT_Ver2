using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_showreading : System.Web.UI.Page
{
    public DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT");
        sb.Append(" plo.LabObservationName,plo.`Value`,plo.`MinValue`,plo.`MaxValue`,plo.readingFormat ");
        sb.Append(" FROM `patient_labobservation_opd` plo where Test_ID='" + Request.QueryString["TestID"].ToString() + "' ");
      

        dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count == 0)
        {
            show.Visible = false;
        }

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



            //if (AbnormalValue != "" && AbnormalValue == Value)
            //    ret_value = "<span class='AbnormalResult'>" + ret_value + "</span>";
        }
        catch (Exception ex) { }

        if (ret_value == Value)
            ret_value = "";

        return ret_value;

    }
}