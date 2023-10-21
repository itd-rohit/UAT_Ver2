using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;
using System.Text;

public partial class Design_Lab_ReferenceRange : System.Web.UI.Page
{
     
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            if (Util.GetString(Session["RoleID"]) == "11" || Util.GetString(Session["RoleID"]) == "177")
            {
                  MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    int isApproved = Util.GetInt(StockReports.ExecuteScalar("SELECT Approved FROM patient_labinvestigation_opd WHERE Test_id='" + Util.GetString(Request.QueryString["Test_ID"]) + "'  "));
                    if (isApproved == 0)
                    {
                        StringBuilder sb = new StringBuilder();
                        sb.Append("UPDATE patient_labinvestigation_opd plo  ");
                        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=plo.LedgerTransactionNo  ");
                       // sb.Append(" INNER JOIN patient_medical_history pmh ON pmh.Transaction_ID=lt.`Transaction_ID`  ");
                        sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.`Patient_ID`  ");
                        sb.Append(" INNER JOIN patient_labobservation_opd ploo ON ploo.Test_ID=plo.Test_ID   ");
                        sb.Append(" INNER JOIN labobservation_range lor ON lor.LabObservation_ID=ploo.LabObservation_ID     ");
                        // sb.Append(" AND lor.CentreID=plo.`TestCentre`  ");
                        sb.Append(" AND lor.MacID=1   ");
                        sb.Append(" AND RangeType='Normal'   ");
                        sb.Append(" AND TotalAgeInDays>=FromAge   ");
                        sb.Append(" AND TotalAgeInDays<=ToAge   ");
                        sb.Append("  AND lor.CentreID=plo.`TestCentreID` ");
                        sb.Append(" AND lor.`Gender`=LEFT(pm.Gender,1)  ");
                        sb.Append(" SET ploo.MinValue=lor.MinReading,   ");
                        sb.Append(" ploo.MaxValue=lor.MaxReading,   ");
                        sb.Append(" ploo.ReadingFormat=lor.ReadingFormat,   ");
                        sb.Append(" ploo.DisplayReading=lor.DisplayReading ");
                        sb.Append(" WHERE plo.Test_ID=@TestID ");
                        //StockReports.ExecuteDML(sb.ToString());

                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@TestID",  Util.GetString(Request.QueryString["TestID"]) ));

                        //string strLog = "INSERT INTO patient_labinvestigation_opd_update_status(Test_ID,`Status`,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID) Values ('" + Request.QueryString["Test_ID"] + "','Update Reference Range','" + HttpContext.Current.Session["ID"] + "','" + HttpContext.Current.Session["LoginName"] + "',NOW(),'" + StockReports.getip() + "','"+Util.GetString(Centre.Id)+"','"+Util.GetString(Session["RoleID"])+"')";
                        //StockReports.ExecuteDML(strLog);
                        Response.Write("Ranges Updated Successfully !!");
                    }
                    else
                    {
                        Response.Write("Test is Already Approved !!");
                    }
                    
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex.GetBaseException());
                }
                 finally
                {
                    con.Close();
                    con.Dispose();
                }
            }
           // ClientScript.RegisterStartupScript(typeof(Page), "closePage", "window.close();", true);
        }
    }
}

    

    
