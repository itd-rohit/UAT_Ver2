using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_Quality_EQASResultReject : System.Web.UI.Page
{
    public string ApprovalId = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ApprovalId = StockReports.ExecuteScalar("SELECT max(`Approval`)  FROM `f_approval_labemployee` WHERE `RoleID`='" + UserInfo.RoleID + "' AND IF(`TechnicalId`='',`EmployeeID`,`TechnicalId`)='" + UserInfo.ID + "'");
            ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();
            ddlprocessinglab.Items.Insert(0, new ListItem("Select Processing Lab", "0"));

            txtcurrentyear.Text = DateTime.Now.Year.ToString();
            ddlcurrentmonth.Items.Add(new ListItem(DateTime.Now.ToString("MMMM"), DateTime.Now.Month.ToString()));

        }
    }


    [WebMethod]
    public static string getEQASresult(string processingcentre, string regisyearandmonth)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT isReject, cm.centre, qil.id, test_id,`LedgerTransactionNO`,barcodeno,InvestigationID,im.name TestName,LabobservationId,qil.programid, ");
        sb.Append(" qil.ProgramName,ProgramNo,CycleNo,DATE_FORMAT(EntryDateTime,'%d-%b-%y')EntryDateTime,EntryByUserName,");
        sb.Append(" (SELECT EqasProviderName FROM  qc_eqasprovidermaster qce INNER JOIN qc_eqasprogrammaster qcem ON qcem.`EqasProviderID`=qce.EqasProviderID");
        sb.Append(" WHERE qcem.ProgramID=qil.ProgramID GROUP BY EqasProviderName) EQASProvideName,");
        sb.Append(" if(isReject=1,RejectReason,'')RejectReason,if(isReject=1,RejectByName,'')RejectByName,");
        sb.Append(" if(isReject=1,DATE_FORMAT(RejectDateTime,'%d-%b-%y'),'')RejectDateTime,");
        sb.Append(" (case when qil.EQASDone=1 then 'EQASDone' when qil.ResultUploaded=1 then 'ResultUploaded' when qil.Approved=1 then 'Approved'  when qil.result_flag=1 then 'ResultDone' else 'New' end)custatus ");

        sb.Append(" FROM qc_eqasregistration qil ");
        sb.Append(" INNER JOIN investigation_master im ON im.`Investigation_Id`=qil.`InvestigationID` ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=qil.`CentreID`");
      
        sb.Append(" WHERE qil.centreid=" + processingcentre + " AND ");
        sb.Append(" entrymonth=" + regisyearandmonth.Split('#')[0] + " AND entryyear=" + regisyearandmonth.Split('#')[1] + "  ");
        sb.Append(" ORDER BY test_id ");



        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string rejectnow(List<string> ILCResultData, string rejectreason)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            foreach (string ilc in ILCResultData)
            {

                // Update Status of Result
                StringBuilder sb = new StringBuilder();

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set isReject=@isReject,RejectDateTime=@RejectDateTime,RejectByName=@RejectByName,RejectByID=@RejectByID,RejectReason=@RejectReason where id=@id",
                   new MySqlParameter("@isReject", "1"),
                   new MySqlParameter("@RejectDateTime", Util.GetDateTime(DateTime.Now)),
                   new MySqlParameter("@RejectByName", UserInfo.LoginName),
                   new MySqlParameter("@RejectByID", UserInfo.ID),
                   new MySqlParameter("@RejectReason", rejectreason),
                   new MySqlParameter("@id", ilc.Split('#')[0])
                   );


                string sql = " UPDATE `patient_labinvestigation_opd` SET `IsReporting`=0 WHERE  test_id = '" + ilc.Split('#')[1] + "';";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sql);
            }
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.Message);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}