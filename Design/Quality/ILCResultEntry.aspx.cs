using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_Quality_ILCResultEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();
            //ddlprocessinglab.Items.Insert(0, new ListItem("Select Processing Lab", "0"));



            txtcurrentyear.Text = DateTime.Now.Year.ToString();
            ddlcurrentmonth.Items.Add(new ListItem(DateTime.Now.ToString("MMMM"), DateTime.Now.Month.ToString()));


            if (ddlprocessinglab.Items.Count > 0)
            {
                // int AccessDays = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1)  FROM qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=2 AND DAY(NOW()) BETWEEN fromdate AND todate and IsSpecial=0"));

                // if (AccessDays == 0)
                // {
                    // int AccessDaysSpecial = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1)  FROM qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=2   AND DATE(NOW()) BETWEEN `Specialfrom` AND SpecialToDate and IsSpecial=1"));
                    // if (AccessDaysSpecial == 0)
                    // {
                        // string s = StockReports.ExecuteScalar("select concat(fromdate,'-',todate) from qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=2 and IsSpecial=0");

                        // string msg = "This page only accessible between " + s + " (Every Month). Send request for increase time";
                        // ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "$('#btnsearch').hide();$('#disp1').show();$('#disp1').text('" + msg + "');showerrormsg('" + msg + "');", true);
                        // return;
                    // }
                // }

            }
            else
            {
                string msg = "No Processing Lab Found. Please Select Proper Centre.";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "$('#btnsearch').hide();$('#disp1').show();$('#disp1').text('" + msg + "');showerrormsg('" + msg + "');", true);
                return;
            }

        }
    }
	[WebMethod]
    public static string bindilc(string processingcentre)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT * FROM(SELECT CONCAT(ilclabtypeid,'#',ilclabid)labid,CONCAT(ilclabname,'#',ilclabtype)labname FROM qc_ilcparametermapping ");
        sb.Append(" WHERE processinglabid=" + processingcentre + " AND isactive=1  ");
        sb.Append(" UNION  ALL  ");

        sb.Append(" SELECT CONCAT(ilclabtypeid,'#',ilclabid)labid,CONCAT(ilclabname,'#',ilclabtype)labname FROM `qc_ilcparametermapping_special` ");
        sb.Append("  WHERE processinglabid=" + processingcentre + " AND isactive=1 AND cyear=" + DateTime.Now.Year + " AND cmonth=" + DateTime.Now.Month + ")t  ");

        sb.Append("  GROUP BY labid ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

    }

    [WebMethod]
    public static string bindremarks(string type)
    {
        DataTable dt = StockReports.GetDataTable("select RemarksTitle Remarks,ID from qc_remarkmaster where RemarksType='" + type + "'  and isactive=1 order by id");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string bindremarksdetail(string id)
    {
        return StockReports.ExecuteScalar(" select Remarks from qc_remarkmaster where id='" + id + "'");
    }
    


    [WebMethod]
    public static string getilcresult(string processingcentre, string searchvalue, string regisyearandmonth, string searchvalue1, string ilclab)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  ");
        sb.Append("  SELECT ifnull(qir.id,'0')savedid, ifnull(qil.id,'0') mapid, qilm.ProcessingLabID, qilm.`ProcessingLabName`, qil.`OLDTest_id`,ploold.`LabObservationName`, ploold.`LabObservation_ID` ,");
        sb.Append("  IFNULL(ploold.`Value`,'') OLDValue,IFNULL(ploold.`Method`,'') oldmethod, '1' reporttype,'Observation' MapType,");
        sb.Append(" IFNULL(ploold.`DisplayReading`,'') olddisplayreading, ");
        sb.Append(" qilm.ilclabname, qil.`Test_id`, qilm.ilclabtypeid,qilm.ILCLabType,qilm.ILCLabID,");

        sb.Append(" if(ifnull(qir.id,'')='', IFNULL(plonew.`Value`,''),ifnull(qir.newvalue,'')) newValue,ifnull(qir.newvalue1,'')newValue1,");
        sb.Append(" if(ifnull(qir.id,'')='', IFNULL(plonew.`Method`,''),ifnull(qir.newmethod,'')) newmethod, ");
        sb.Append(" if(ifnull(qir.id,'')='', IFNULL(plonew.`DisplayReading`,''),ifnull(qir.newdisplayreading,'')) newdisplayreading ");

        sb.Append(" ,qilm.AcceptablePer, ifnull(qir.status,'')`status` ");
        sb.Append(" ,ifnull(RCA,'')RCA ,ifnull(CorrectiveAction,'') CorrectiveAction ,ifnull(PreventiveAction,'') PreventiveAction,ifnull(qir.approved,'0')approved ");
        sb.Append(",ifnull(qir.Remarks,'') Remarks,ifnull(UploadFileName,'')UploadFileName");
        sb.Append("  FROM qc_ilcregistration qil ");

        sb.Append(" INNER JOIN qc_ilcparametermapping qilm ON qilm.`ProcessingLabID`=qil.`CentreID` AND qilm.`TestType`='Observation' ");
        sb.Append(" AND qil.ILCLabID = qilm.`ILCLabID` ");
        sb.Append(" AND qilm.`TestID`=qil.`LabObservationID` and qil.isreject=0");
        sb.Append(" and qilm.ILCLabID='" + ilclab.Split('#')[1] + "'");

        sb.Append(" left join qc_ilcresultentry qir on qir.ProcessingLabID=qil.`CentreID` and qir.MapType='Observation' ");
        sb.Append(" and qir.ilclabtypeid=qilm.ilclabtypeid and qir.ILCLabID=qilm.ILCLabID and qir.LabItemID=qil.`LabObservationID`");
        sb.Append(" and qir.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qir.EntryYear=" + regisyearandmonth.Split('#')[1] + "");

        sb.Append(" INNER JOIN `patient_labobservation_opd` ploold ON qil.`OLDTest_id`=ploold.`Test_ID` AND qil.`LabObservationID`=ploold.`LabObservation_ID` ");
        sb.Append(" LEFT JOIN patient_labobservation_opd plonew ON qil.`Test_id`=plonew.`Test_ID` AND qil.`LabObservationID`=plonew.`LabObservation_ID` ");
        sb.Append(" WHERE qil.`MapType`='Observation' ");
        sb.Append(" and qil.centreid='" + processingcentre + "' ");
        if (searchvalue != "")
        {
            sb.Append(" and (qil.barcodeno='" + searchvalue + "' or qil.OLDbarcodeNo='" + searchvalue + "') ");
        }

       //if (searchvalue1 != "")
        //{
        //    sb.Append(" and (qil.OLDLedgerTransactionNo='" + searchvalue + "' or qil.LedgerTransactionNo='" + searchvalue + "') ");
        //}
        sb.Append(" and qil.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil.EntryYear=" + regisyearandmonth.Split('#')[1] + "");



        sb.Append(" union all");

        sb.Append("  ");
        sb.Append("  SELECT ifnull(qir.id,'0')savedid, ifnull(qil.id,'0') mapid, qilm.ProcessingLabID, qilm.`ProcessingLabName`, qil.`OLDTest_id`,ploold.ItemName LabObservationName,ploold.itemid LabObservation_ID ,");
        sb.Append("  ifnull(qir.oldvalue,'') OLDValue, ''oldmethod,'3' reporttype,'Investigation' MapType,''olddisplayreading,");

        sb.Append(" qilm.ilclabname, qil.`Test_id`, qilm.ilclabtypeid,qilm.ILCLabType,qilm.ILCLabID, ");
        sb.Append(" ifnull(qir.newValue,'') newValue,ifnull(qir.newValue1,'') newValue1,''newmethod,'' newdisplayreading,0 AcceptablePer ,ifnull(qir.status,'')`status`");
        sb.Append(" ,ifnull(RCA,'')RCA ,ifnull(CorrectiveAction,'') CorrectiveAction ,ifnull(PreventiveAction,'') PreventiveAction,ifnull(qir.approved,'0')approved");
        sb.Append(",ifnull(qir.Remarks,'') Remarks,ifnull(UploadFileName,'')UploadFileName");
        sb.Append("  FROM qc_ilcregistration qil ");

        sb.Append(" INNER JOIN qc_ilcparametermapping qilm ON qilm.`ProcessingLabID`=qil.`CentreID` AND qilm.`TestType`='Investigation' ");
        sb.Append(" AND qil.ILCLabID = qilm.`ILCLabID` ");
        sb.Append(" AND qilm.`TestID`=qil.`InvestigationID` and qil.isreject=0");
        sb.Append(" and qilm.ILCLabID='" + ilclab.Split('#')[1] + "'");

      


        sb.Append(" INNER JOIN `patient_labinvestigation_opd` ploold ON qil.`OLDTest_id`=ploold.`Test_ID` ");
        sb.Append(" LEFT JOIN patient_labinvestigation_opd plonew ON qil.`Test_id`=plonew.`Test_ID`  ");

        sb.Append(" left join qc_ilcresultentry qir on qir.ProcessingLabID=qil.`CentreID` and qir.MapType='Investigation' ");
        sb.Append(" and qir.ilclabtypeid=qilm.ilclabtypeid and qir.ILCLabID=qilm.ILCLabID and qir.LabItemID=ploold.`itemid`");
        sb.Append(" and qir.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qir.EntryYear=" + regisyearandmonth.Split('#')[1] + "");

        sb.Append(" WHERE qil.`MapType`='Investigation' ");
        sb.Append(" and qil.centreid='" + processingcentre + "' ");
        if (searchvalue != "")
        {
            sb.Append(" and (qil.barcodeno='" + searchvalue + "' or qil.OLDbarcodeNo='" + searchvalue + "') ");
        }
        //if (searchvalue1 != "")
        //{
           // sb.Append(" and (qil.OLDLedgerTransactionNo='" + searchvalue + "' or qil.LedgerTransactionNo='" + searchvalue + "') ");
        //}
        sb.Append(" and qil.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil.EntryYear=" + regisyearandmonth.Split('#')[1] + "");




        // Not Mapped Test
        sb.Append(" union all"); 
        sb.Append("  SELECT ifnull(qir.id,'0')savedid, ifnull(qil.id,'0') mapid, qilm.ProcessingLabID, qilm.`ProcessingLabName`, qil.`OLDTest_id`,ploold.`LabObservationName`, ploold.`LabObservation_ID` ,");
        sb.Append("  IFNULL(ploold.`Value`,'') OLDValue,IFNULL(ploold.`Method`,'') oldmethod, '1' reporttype,'Observation' MapType,");
        sb.Append(" IFNULL(ploold.`DisplayReading`,'') olddisplayreading, ");
        sb.Append(" qilm.ilclabname, qil.`Test_id`, qilm.ilclabtypeid,qilm.ILCLabType,qilm.ILCLabID,");

        sb.Append(" if(ifnull(qir.id,'')='', IFNULL(plonew.`Value`,''),ifnull(qir.newvalue,'')) newValue,ifnull(qir.newvalue1,'')newValue1,");
        sb.Append(" if(ifnull(qir.id,'')='', IFNULL(plonew.`Method`,''),ifnull(qir.newmethod,'')) newmethod, ");
        sb.Append(" if(ifnull(qir.id,'')='', IFNULL(plonew.`DisplayReading`,''),ifnull(qir.newdisplayreading,'')) newdisplayreading ");

        sb.Append(" ,qilm.AcceptablePer, ifnull(qir.status,'')`status` ");
        sb.Append(" ,ifnull(RCA,'')RCA ,ifnull(CorrectiveAction,'') CorrectiveAction ,ifnull(PreventiveAction,'') PreventiveAction,ifnull(qir.approved,'0')approved ");
        sb.Append(",ifnull(qir.Remarks,'') Remarks,ifnull(UploadFileName,'')UploadFileName");
        sb.Append("  FROM qc_ilcregistration qil ");

        sb.Append(" INNER JOIN qc_ilcparametermapping_special qilm ON qilm.`ProcessingLabID`=qil.`CentreID` AND qilm.`TestType`='Observation' ");
        sb.Append(" AND qil.ILCLabID = qilm.`ILCLabID` ");
        sb.Append(" AND qilm.`TestID`=qil.`LabObservationID` and qil.isreject=0");
        sb.Append(" and qilm.ILCLabID='" + ilclab.Split('#')[1] + "'");
        sb.Append(" AND qilm.cyear=" + regisyearandmonth.Split('#')[1] + " AND qilm.cmonth=" + regisyearandmonth.Split('#')[0] + " ");

        sb.Append(" left join qc_ilcresultentry qir on qir.ProcessingLabID=qil.`CentreID` and qir.MapType='Observation' ");
        sb.Append(" and qir.ilclabtypeid=qilm.ilclabtypeid and qir.ILCLabID=qilm.ILCLabID and qir.LabItemID=qil.`LabObservationID`");
        sb.Append(" and qir.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qir.EntryYear=" + regisyearandmonth.Split('#')[1] + "");

        sb.Append(" INNER JOIN `patient_labobservation_opd` ploold ON qil.`OLDTest_id`=ploold.`Test_ID` AND qil.`LabObservationID`=ploold.`LabObservation_ID` ");
        sb.Append(" LEFT JOIN patient_labobservation_opd plonew ON qil.`Test_id`=plonew.`Test_ID` AND qil.`LabObservationID`=plonew.`LabObservation_ID` ");
        sb.Append(" WHERE qil.`MapType`='Observation' ");
        sb.Append(" and qil.centreid='" + processingcentre + "' ");
        if (searchvalue != "")
        {
            sb.Append(" and (qil.barcodeno='" + searchvalue + "' or qil.OLDbarcodeNo='" + searchvalue + "') ");
        }

        //if (searchvalue1 != "")
       // {
        //    sb.Append(" and (qil.OLDLedgerTransactionNo='" + searchvalue + "' or qil.LedgerTransactionNo='" + searchvalue + "') ");
        //}
        sb.Append(" and qil.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil.EntryYear=" + regisyearandmonth.Split('#')[1] + "");



        sb.Append(" union all");

        sb.Append("  ");
        sb.Append("  SELECT ifnull(qir.id,'0')savedid, ifnull(qil.id,'0') mapid, qilm.ProcessingLabID, qilm.`ProcessingLabName`, qil.`OLDTest_id`,ploold.ItemName LabObservationName,ploold.itemid LabObservation_ID ,");
        sb.Append("  ifnull(qir.oldvalue,'') OLDValue, ''oldmethod,'3' reporttype,'Investigation' MapType,''olddisplayreading,");

        sb.Append(" qilm.ilclabname, qil.`Test_id`, qilm.ilclabtypeid,qilm.ILCLabType,qilm.ILCLabID, ");
        sb.Append(" ifnull(qir.newValue,'') newValue,ifnull(qir.newValue1,'') newValue1,''newmethod,'' newdisplayreading,0 AcceptablePer ,ifnull(qir.status,'')`status`");
        sb.Append(" ,ifnull(RCA,'')RCA ,ifnull(CorrectiveAction,'') CorrectiveAction ,ifnull(PreventiveAction,'') PreventiveAction,ifnull(qir.approved,'0')approved");
        sb.Append(",ifnull(qir.Remarks,'') Remarks,ifnull(UploadFileName,'')UploadFileName");
        sb.Append("  FROM qc_ilcregistration qil ");

        sb.Append(" INNER JOIN qc_ilcparametermapping_special qilm ON qilm.`ProcessingLabID`=qil.`CentreID` AND qilm.`TestType`='Investigation' ");
        sb.Append(" AND qil.ILCLabID = qilm.`ILCLabID` ");
        sb.Append(" AND qilm.`TestID`=qil.`InvestigationID` and qil.isreject=0");
        sb.Append(" and qilm.ILCLabID='" + ilclab.Split('#')[1] + "'");
        sb.Append(" AND qilm.cyear=" + regisyearandmonth.Split('#')[1] + " AND qilm.cmonth=" + regisyearandmonth.Split('#')[0] + " ");



        sb.Append(" INNER JOIN `patient_labinvestigation_opd` ploold ON qil.`OLDTest_id`=ploold.`Test_ID` ");
        sb.Append(" LEFT JOIN patient_labinvestigation_opd plonew ON qil.`Test_id`=plonew.`Test_ID`  ");

        sb.Append(" left join qc_ilcresultentry qir on qir.ProcessingLabID=qil.`CentreID` and qir.MapType='Investigation' ");
        sb.Append(" and qir.ilclabtypeid=qilm.ilclabtypeid and qir.ILCLabID=qilm.ILCLabID and qir.LabItemID=ploold.`itemid`");
        sb.Append(" and qir.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qir.EntryYear=" + regisyearandmonth.Split('#')[1] + "");

        sb.Append(" WHERE qil.`MapType`='Investigation' ");
        sb.Append(" and qil.centreid='" + processingcentre + "' ");
        if (searchvalue != "")
        {
            sb.Append(" and (qil.barcodeno='" + searchvalue + "' or qil.OLDbarcodeNo='" + searchvalue + "') ");
        }
        //if (searchvalue1 != "")
       // {
        //    sb.Append(" and (qil.OLDLedgerTransactionNo='" + searchvalue + "' or qil.LedgerTransactionNo='" + searchvalue + "') ");
        //}
        sb.Append(" and qil.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil.EntryYear=" + regisyearandmonth.Split('#')[1] + "");









        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }


    [WebMethod]
    public static string saveresult(List<ILCResult> ILCResultData)
    {

        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string id =string.Join("," ,ILCResultData.Select(x => x.ILCRegistrationID).ToArray());

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from qc_ilcresultentry where id in ("+id+")");


            foreach (ILCResult ilc in ILCResultData)
            {
                // Insert in Result
                StringBuilder sb = new StringBuilder();


                sb.Append("  INSERT INTO qc_ilcresultentry ");
                sb.Append("  (  ");
                sb.Append("   EntryMonth, EntryYear, ProcessingLabID, ProcessingLabName, ");
                sb.Append("   ilclabtypeid,ILCLabType,ILCLabID,ilclabname, ");
                sb.Append("   ReportType,MapType,OLDTest_id,LabItemID, LabItemName, ");
                sb.Append("   Test_id, ");
                sb.Append("   oldvalue, oldmethod, olddisplayreading, ");
                sb.Append("   newvalue,newvalue1,  newmethod, newdisplayreading, ");
                sb.Append("   Acceptable, Variation, STATUS,Remarks, ");
                sb.Append("   RCA, CorrectiveAction,PreventiveAction,UploadFileName ,");
                sb.Append("   EntryDate, EntryByID, EntryByName, ");
                sb.Append("   Approved) ");
                sb.Append("   VALUES  ( ");
                sb.Append("   @EntryMonth, @EntryYear, @ProcessingLabID, @ProcessingLabName, ");
                sb.Append("   @ilclabtypeid,@ILCLabType,@ILCLabID,@ilclabname, ");
                sb.Append("   @ReportType,@MapType,@OLDTest_id,@LabItemID, @LabItemName, ");
                sb.Append("   @Test_id, ");
                sb.Append("   @oldvalue, @oldmethod, @olddisplayreading, ");
                sb.Append("   @newvalue, @newvalue1,  @newmethod, @newdisplayreading, ");
                sb.Append("   @Acceptable, @Variation, @STATUS,@Remarks, ");
                sb.Append("   @RCA, @CorrectiveAction,@PreventiveAction,@UploadFileName, ");
                sb.Append("   @EntryDate, @EntryByID, @EntryByName, ");
                sb.Append("   @Approved) ");


                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@EntryMonth", ilc.EntryMonth),
                     new MySqlParameter("@EntryYear", ilc.EntryYear),
                      new MySqlParameter("@ProcessingLabID", ilc.ProcessingLabID),
                       new MySqlParameter("@ProcessingLabName", ilc.ProcessingLabName),
                        new MySqlParameter("@ilclabtypeid", ilc.ilclabtypeid),
                         new MySqlParameter("@ILCLabType", ilc.ILCLabType),
                          new MySqlParameter("@ILCLabID", ilc.ILCLabID),
                           new MySqlParameter("@ilclabname", ilc.ilclabname),
                            new MySqlParameter("@ReportType", ilc.ReportType),
                             new MySqlParameter("@MapType", ilc.MapType),
                              new MySqlParameter("@OLDTest_id", ilc.OLDTest_id),
                               new MySqlParameter("@LabItemID", ilc.LabItemID),
                                new MySqlParameter("@LabItemName", ilc.LabItemName),
                                 new MySqlParameter("@Test_id", ilc.Test_id),
                                  new MySqlParameter("@oldvalue", ilc.oldvalue),
                                   new MySqlParameter("@oldmethod", ilc.oldmethod),
                                    new MySqlParameter("@olddisplayreading", ilc.olddisplayreading),
                                     new MySqlParameter("@newvalue", ilc.newvalue), new MySqlParameter("@newvalue1", ilc.newvalue1),
                                      new MySqlParameter("@newmethod", ilc.newmethod),
                                       new MySqlParameter("@newdisplayreading", ilc.newdisplayreading),
                                        new MySqlParameter("@Acceptable", ilc.Acceptable),
                                         new MySqlParameter("@Variation", ilc.Variation),
                                          new MySqlParameter("@STATUS", ilc.Status), new MySqlParameter("@Remarks", ilc.Remarks),
                                           new MySqlParameter("@RCA", ilc.RCA),
                                            new MySqlParameter("@CorrectiveAction", ilc.CorrectiveAction),
                                             new MySqlParameter("@PreventiveAction", ilc.PreventiveAction),
                                              new MySqlParameter("@UploadFileName", ilc.UploadFileName),
                                               new MySqlParameter("@EntryDate", Util.GetDateTime(DateTime.Now)),
                                                new MySqlParameter("@EntryByID", UserInfo.ID),
                                                 new MySqlParameter("@EntryByName", UserInfo.LoginName),
                                                   new MySqlParameter("@Approved", "0")
                    );



                


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

public class ILCResult
{
    public string ILCRegistrationID { get; set; }
    public string EntryMonth { get; set; }
    public string EntryYear { get; set; }
    public string ProcessingLabID { get; set; }
    public string ProcessingLabName { get; set; }
    public string ilclabtypeid { get; set; }
    public string ILCLabType { get; set; }
    public string ILCLabID { get; set; }
    public string ilclabname { get; set; }
    public string ReportType { get; set; }
    public string MapType { get; set; }
    public string OLDTest_id { get; set; }
    public string LabItemID { get; set; }
    public string LabItemName { get; set; }
    public string Test_id { get; set; }
    public string oldvalue { get; set; }
    public string oldmethod { get; set; }
    public string olddisplayreading { get; set; }

    public string newvalue { get; set; }
    public string newvalue1 { get; set; }
    public string newmethod { get; set; }
    public string newdisplayreading { get; set; }

    public string Acceptable { get; set; }
    public string Variation { get; set; }
    public string Status { get; set; }
    public string Remarks { get; set; }

    public string RCA { get; set; }
    public string CorrectiveAction { get; set; }
    public string PreventiveAction { get; set; }
    public string UploadFileName { get; set; }




}