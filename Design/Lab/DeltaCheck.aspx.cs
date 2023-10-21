using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using MySql.Data.MySqlClient;
public partial class Design_Lab_DeltaCheck : System.Web.UI.Page
{
    public DataTable dt = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DATE_FORMAT(pli.`Date`,'%d-%b-%y %I:%i%p')BookingDate,plo.`LabObservationName`,plo.`Value`,plo.`ReadingFormat` ,plo.`MinValue`,plo.`MaxValue`,''`DisplayReading` ");
            sb.Append(" FROM `patient_labobservation_opd` plo  INNER JOIN `patient_labinvestigation_opd` pli ON plo.`Test_ID`=pli.`Test_ID` ");
            sb.Append(" AND pli.date>=DATE_ADD(CURRENT_DATE, INTERVAL -2 MONTH) ");
            sb.Append(" AND pli.`Patient_ID`=(SELECT patient_id FROM `patient_labinvestigation_opd` WHERE  Test_ID=@Test_ID ) AND plo.`LabObservation_ID`=@LabObservation_ID AND plo.`Value`<>'' and pli.`Approved`=1  ORDER BY pli.`Date` ");
            dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@Test_ID", Request.QueryString["TestID"].ToString()), new MySqlParameter("@LabObservation_ID", Request.QueryString["LabObservation_ID"].ToString())).Tables[0];
            if (dt.Rows.Count == 0)
            {
                show.Visible = false;
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
    public string getTags(string Value, string MinRange, string MaxRange, string AbnormalValue)
    {
        string ret_value = Value;
        if (Value == "HEAD")
            return "&nbsp;";
        try
        {
            if ((MinRange == string.Empty) && (MaxRange == string.Empty))
                ret_value = Value;
            else
            {
                if ((MinRange != string.Empty) && (Util.GetFloat(Value) < Util.GetFloat(MinRange)))
                    ret_value = string.Format("<span class='AbnormalResult'>{0}</span>", ret_value);
                else if ((MaxRange != "") && (Util.GetFloat(Value) > Util.GetFloat(MaxRange)))
                    ret_value = string.Format("<span class='AbnormalResult'>{0}</span>", ret_value);
            }
            if (AbnormalValue != string.Empty && AbnormalValue == Value)
                ret_value = string.Format("<span class='AbnormalResult'>{0}</span>", ret_value);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        return ret_value;
    }
    public string getTags_Flag(string Value, string MinRange, string MaxRange, string AbnormalValue)
    {
        string ret_value = Value;
        try
        {
            if ((MinRange != string.Empty) && (Util.GetFloat(Value) < Util.GetFloat(MinRange)))
                ret_value = "L";
            else if ((MaxRange != string.Empty) && (Util.GetFloat(Value) > Util.GetFloat(MaxRange)))
                ret_value = "H";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        if (ret_value == Value)
            ret_value = string.Empty;
        return ret_value;
    }
}