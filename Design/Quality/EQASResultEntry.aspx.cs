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


public partial class Design_Quality_EQASResultEntry : System.Web.UI.Page
{


    public string cansave = "0";
    public string canapprove = "0";
    public string canupload = "0";
    public string canfinaldone = "0";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            string dt = StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typeid),0) FROM qc_approvalright WHERE apprightfor='EQAS' and typeid!=8 AND employeeid='" + UserInfo.ID + "' ");
            if (dt != "0")
            {
                if (dt.Contains("4"))
                {
                    cansave = "1";
                }
                if (dt.Contains("5"))
                {
                    canapprove = "1";
                }
                if (dt.Contains("6"))
                {
                    canupload = "1";
                }
                if (dt.Contains("7"))
                {
                    canfinaldone = "1";
                }
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "document.getElementById('Pbody_box_inventory').style.display = 'none';showerrormsg('Dear User You Did not Have Right To View This Page');", true);
                return;
            }


            ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();
            // ddlprocessinglab.Items.Insert(0,new ListItem("Select Processing Lab","0"));

            for (int a = DateTime.Now.Year - 2; a < DateTime.Now.Year + 10; a++)
            {
                txtcurrentyear.Items.Add(new ListItem(a.ToString(), a.ToString()));
            }

            ListItem selectedListItem1 = txtcurrentyear.Items.FindByValue(DateTime.Now.Year.ToString());

            if (selectedListItem1 != null)
            {
                selectedListItem1.Selected = true;
            }


            DateTimeFormatInfo info = DateTimeFormatInfo.GetInstance(null);
            for (int a = 1; a < 13; a++)
            {
                ddlcurrentmonth.Items.Add(new ListItem(info.GetMonthName(a), a.ToString()));
            }

            ListItem selectedListItem = ddlcurrentmonth.Items.FindByValue(DateTime.Now.Month.ToString());

            if (selectedListItem != null)
            {
                selectedListItem.Selected = true;
            }

            if (ddlprocessinglab.Items.Count > 0)
            {
                // int AccessDays = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1)  FROM qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=4 AND DAY(NOW()) BETWEEN fromdate AND todate and IsSpecial=0"));

                // if (AccessDays == 0)
                // {
                    // int AccessDaysSpecial = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1)  FROM qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=4 AND DATE(NOW()) BETWEEN `Specialfrom` AND SpecialToDate and IsSpecial=1"));
                    // if (AccessDaysSpecial == 0)
                    // {
                        // string s = StockReports.ExecuteScalar("select concat(fromdate,'-',todate) from qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=4 and IsSpecial=0 ");

                        // string msg = "This page only accessible between " + s + " (Every Month). Send request for increase time";
                        // ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "$('#Pbody_box_inventory').hide();$('#disp1').show();$('#disp1').text('" + msg + "');showerrormsg('" + msg + "');", true);
                        // return;
                    // }
                // }

            }
            else
            {
                string msg = "No Processing Lab Found. Please Select Proper Centre.";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Messagebox", "$('#Pbody_box_inventory').hide();$('#disp1').show();$('#disp1').text('" + msg + "');showerrormsg('" + msg + "');", true);
                return;
            }


        }
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


    [WebMethod(EnableSession = true)]
    public static string bindresult(string labid, string regisyearandmonth, string programid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select qcr.cycleno, plo.ledgertransactionno as VisitNo, qcr.LabObservationName,qcr.`LabObservationID`, ifnull(qcr.RCAType,'')RCAType,ifnull(qcr.CAType,'')CAType,ifnull(qcr.PAType,'')PAType,");
        sb.Append("  qcr.centreid,qcr.ProgramName programname,");
        sb.Append(" (SELECT `EqasProviderName` FROM `qc_eqasprovidermaster` qe  ");
        sb.Append(" INNER JOIN qc_eqasprogrammaster qeq ON qe.EQASProviderID=qeq.EQASProviderID WHERE qeq.programid=qcr.programid LIMIT 1)ProvideName");

        sb.Append(" , qcr.programid,qcr.test_id,investigationid,plo.barcodeno,labobservationid, ");
        sb.Append(" DATE_FORMAT(plo.date,'%d-%b-%Y') regdate,plo.itemname `InvestigationName`,sm.name departmant,plo.`ReportType`, ");
        sb.Append(" IFNULL(ploo.`Value`,ifnull(qcr.value,'')) ResultValue,IFNULL(ploo.minvalue,'') minvalue,IFNULL(ploo.`MaxValue`,'')`MaxValue`, ");
        sb.Append(" ifnull(ploo.MacReading,'')MacReading ,ifnull(ploo.MachineName,'')MachineName, ");
        sb.Append(" IFNULL(ploo.`DisplayReading`,'')DisplayReading,IFNULL(ploo.`ReadingFormat`,'')ReadingFormat,IFNULL(ploo.flag,'')flag, ");

        sb.Append(" if(ifnull(qcr.RCAType,'') ='','',if(qcr.RCAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='RCA' and QCType='EQAS' and qqf.MacDataId=qcr.test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qcr.Test_id  and qqs.Type='RCA' and qqs.QCType='EQAS')))RCA,  ");


        sb.Append(" if(ifnull(qcr.CAType,'') ='','',if(qcr.CAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='CorrectiveAction' and QCType='EQAS' and qqf.MacDataId=qcr.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qcr.Test_id  and qqs.Type='CorrectiveAction' and qqs.QCType='EQAS')))CorrectiveAction,  ");


        sb.Append(" if(ifnull(qcr.PAType,'') ='','',if(qcr.PAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='PreventiveAction' and QCType='ILC' and qqf.MacDataId=qcr.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qcr.Test_id  and qqs.Type='PreventiveAction' and qqs.QCType='EQAS')))PreventiveAction,  ");


        sb.Append(" ifnull(qcr.EQASVALUE,'')EQASVALUE ");

        sb.Append(" ,(case when qcr.EQASDone=1 then 'aqua' when qcr.ResultUploaded=1 then 'lightsalmon' when qcr.Approved=1 then 'lightgreen'  when qcr.result_flag=1 then 'bisque' else 'lightgoldenrodyellow' end)rowcolor, ");
        sb.Append(" (case when qcr.EQASDone=1 then 'EQASDone' when qcr.ResultUploaded=1 then 'ResultUploaded' when qcr.Approved=1 then 'Approved'  when qcr.result_flag=1 then 'ResultDone' else 'New' end)custatus ");
        sb.Append(" ,if(ResultUploaded=1,date_format(ExpectedResultDate,'%d-%b-%Y'),'')ExpectedResultDate ");

        sb.Append(" FROM `qc_eqasregistration` qcr  ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`Test_ID`=qcr.`Test_id` ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
        sb.Append(" left JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID` AND ploo.`LabObservation_ID`=qcr.`LabObservationID` ");
        sb.Append(" WHERE qcr.programid=" + programid + " and qcr.centreid=" + labid + " AND entrymonth=" + regisyearandmonth.Split('#')[0] + " AND entryyear=" + regisyearandmonth.Split('#')[1] + " AND isreject=0 ");

        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod]
    public static string saveresult(List<EQASResult> EQASResultData, string flag)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            foreach (EQASResult eqas in EQASResultData)
            {
                // Update Status of Result
                StringBuilder sb = new StringBuilder();
                if (flag == "0")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set result_flag=@result_flag,ResultEnteredDate=@ResultEnteredDate,ResultEnteredName=@ResultEnteredName,ResultEnteredBy=@ResultEnteredBy,VALUE=@Value,EQASVALUE=@EQASVALUE,EQASStatus=@EQASStatus where test_id=@test_id and LabObservationID=@LabObservationID",
                       new MySqlParameter("@result_flag", "1"),
                       new MySqlParameter("@ResultEnteredDate", Util.GetDateTime(DateTime.Now)),
                       new MySqlParameter("@ResultEnteredName", UserInfo.LoginName),
                       new MySqlParameter("@ResultEnteredBy", UserInfo.ID), new MySqlParameter("@test_id", eqas.test_id),
                       //new MySqlParameter("@rca", eqas.RCA),
                       //new MySqlParameter("@CorrectiveAction", eqas.CorrectiveAction),
                       //new MySqlParameter("@PreventiveAction", eqas.PreventiveAction),
                       new MySqlParameter("@Value", eqas.Value),
                       new MySqlParameter("@EQASVALUE", eqas.EQASvalue),
                       new MySqlParameter("@EQASStatus", eqas.EQASStatus),
                       new MySqlParameter("@LabObservationID", eqas.LabObservationID)
                       );
                }
                else if (flag == "1")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set result_flag=@result_flag,ResultEnteredDate=if(Result_Flag=0,@ResultEnteredDate,ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,@ResultEnteredName,ResultEnteredName),ResultEnteredBy=if(Result_Flag=0,@ResultEnteredBy,ResultEnteredBy) ,Approved=@Approved,ApprovedDate=@ApprovedDate,ApprovedName=@ApprovedName,ApprovedBy=@ApprovedBy,VALUE=@Value,EQASVALUE=@EQASVALUE,EQASStatus=@EQASStatus where test_id=@test_id and LabObservationID=@LabObservationID ",
                      new MySqlParameter("@result_flag", "1"),
                      new MySqlParameter("@ResultEnteredDate", Util.GetDateTime(DateTime.Now)),
                      new MySqlParameter("@ResultEnteredName", UserInfo.LoginName),
                      new MySqlParameter("@ResultEnteredBy", UserInfo.ID),
                      new MySqlParameter("@test_id", eqas.test_id),
                      new MySqlParameter("@Approved", "1"),
                      new MySqlParameter("@ApprovedDate", Util.GetDateTime(DateTime.Now)),
                      new MySqlParameter("@ApprovedName", UserInfo.LoginName),
                      new MySqlParameter("@ApprovedBy", UserInfo.ID),
                      //new MySqlParameter("@rca", eqas.RCA),
                      //new MySqlParameter("@CorrectiveAction", eqas.CorrectiveAction),
                      //new MySqlParameter("@PreventiveAction", eqas.PreventiveAction),
                      new MySqlParameter("@Value", eqas.Value),
                      new MySqlParameter("@EQASVALUE", eqas.EQASvalue),
                      new MySqlParameter("@EQASStatus", eqas.EQASStatus),
                        new MySqlParameter("@LabObservationID", eqas.LabObservationID)
                      );
                }



                else if (flag == "2")
                {
                    int result = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select ResultWithin from qc_eqasprogrammaster where ProgramID=" + eqas.ProgramID + " limit 1 "));

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set ResultUploaded=@ResultUploaded,ResultUploadedBy=@ResultUploadedBy,ResultUploadedDate=@ResultUploadedDate,ResultUploadedName=@ResultUploadedName,ExpectedResultDate=DATE_ADD(NOW(),INTERVAL " + result + " DAY) where test_id=@test_id and LabObservationID=@LabObservationID ",
                     new MySqlParameter("@ResultUploaded", "1"),
                     new MySqlParameter("@ResultUploadedDate", Util.GetDateTime(DateTime.Now)),
                     new MySqlParameter("@ResultUploadedName", UserInfo.LoginName),
                     new MySqlParameter("@ResultUploadedBy", UserInfo.ID),
                     new MySqlParameter("@test_id", eqas.test_id),
                     new MySqlParameter("@LabObservationID", eqas.LabObservationID)
                     );
                }

                if ((flag == "0" || flag == "1") && eqas.RCA != "" && eqas.RCA != "0")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set RCAType='Comment' where Test_id=@Test_id and LabObservationID=@LabObservationID ",
                   new MySqlParameter("@Test_id", eqas.test_id),
                   new MySqlParameter("@LabObservationID", eqas.LabObservationID));

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_qcfaildata set IsActive=@IsActive,Updatedate=@Updatedate,UpdatebyId=@UpdatebyId,UpdateByname=@UpdateByname where MacDataId=@Test_id and  Type=@Type and QCType=@QCType",
          new MySqlParameter("@IsActive", "0"),
          new MySqlParameter("@Updatedate", DateTime.Now),
          new MySqlParameter("@UpdateByID", UserInfo.ID),
          new MySqlParameter("@UpdateByname", UserInfo.LoginName),
          new MySqlParameter("@Test_id", eqas.test_id),
          new MySqlParameter("@Type", "RCA"),
          new MySqlParameter("@QCType", "EQAS")

          );


                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " insert into  qc_qcfaildata(MacDataId,Type,QCType,Comment,EntryDate,EntryByID,EntryByName) values (@Test_id,@Type,@QCType,@Comment,@EntryDate,@EntryByID,@EntryByName)",
                             new MySqlParameter("@Test_id", eqas.test_id),
                             new MySqlParameter("@Type", "RCA"),
                             new MySqlParameter("@QCType", "EQAS"),
                             new MySqlParameter("@Comment", eqas.RCA),
                             new MySqlParameter("@EntryDate", DateTime.Now),
                             new MySqlParameter("@EntryByID", UserInfo.ID),
                             new MySqlParameter("@EntryByName", UserInfo.LoginName));
                }

                if ((flag == "0" || flag == "1") && eqas.CorrectiveAction != "" && eqas.CorrectiveAction != "0")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set CAType='Comment' where Test_id=@Test_id and LabObservationID=@LabObservationID ",
                   new MySqlParameter("@Test_id", eqas.test_id),
                   new MySqlParameter("@LabObservationID", eqas.LabObservationID));

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_qcfaildata set IsActive=@IsActive,Updatedate=@Updatedate,UpdatebyId=@UpdatebyId,UpdateByname=@UpdateByname where MacDataId=@Test_id and  Type=@Type and QCType=@QCType",
          new MySqlParameter("@IsActive", "0"),
          new MySqlParameter("@Updatedate", DateTime.Now),
          new MySqlParameter("@UpdateByID", UserInfo.ID),
          new MySqlParameter("@UpdateByname", UserInfo.LoginName),
          new MySqlParameter("@Test_id", eqas.test_id),
          new MySqlParameter("@Type", "CorrectiveAction"),
          new MySqlParameter("@QCType", "EQAS")
          );


                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " insert into  qc_qcfaildata(MacDataId,Type,QCType,Comment,EntryDate,EntryByID,EntryByName) values (@Test_id,@Type,@QCType,@Comment,@EntryDate,@EntryByID,@EntryByName)",
                             new MySqlParameter("@Test_id", eqas.test_id),
                             new MySqlParameter("@Type", "CorrectiveAction"),
                             new MySqlParameter("@QCType", "EQAS"),
                             new MySqlParameter("@Comment", eqas.CorrectiveAction),
                             new MySqlParameter("@EntryDate", DateTime.Now),
                             new MySqlParameter("@EntryByID", UserInfo.ID),
                             new MySqlParameter("@EntryByName", UserInfo.LoginName));
                }

                if ((flag == "0" || flag == "1") && eqas.PreventiveAction != "" && eqas.PreventiveAction != "0")
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set PAType='Comment' where Test_id=@Test_id and LabObservationID=@LabObservationID ",
                  new MySqlParameter("@Test_id", eqas.test_id),
                  new MySqlParameter("@LabObservationID", eqas.LabObservationID));

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_qcfaildata set IsActive=@IsActive,Updatedate=@Updatedate,UpdatebyId=@UpdatebyId,UpdateByname=@UpdateByname where MacDataId=@Test_id and  Type=@Type and QCType=@QCType",
          new MySqlParameter("@IsActive", "0"),
          new MySqlParameter("@Updatedate", DateTime.Now),
          new MySqlParameter("@UpdateByID", UserInfo.ID),
          new MySqlParameter("@UpdateByname", UserInfo.LoginName),
          new MySqlParameter("@Test_id", eqas.test_id),
          new MySqlParameter("@Type", "PreventiveAction"),
          new MySqlParameter("@QCType", "EQAS")
          );


                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " insert into  qc_qcfaildata(MacDataId,Type,QCType,Comment,EntryDate,EntryByID,EntryByName) values (@Test_id,@Type,@QCType,@Comment,@EntryDate,@EntryByID,@EntryByName)",
                             new MySqlParameter("@Test_id", eqas.test_id),
                             new MySqlParameter("@Type", "PreventiveAction"),
                             new MySqlParameter("@QCType", "EQAS"),
                             new MySqlParameter("@Comment", eqas.PreventiveAction),
                             new MySqlParameter("@EntryDate", DateTime.Now),
                             new MySqlParameter("@EntryByID", UserInfo.ID),
                             new MySqlParameter("@EntryByName", UserInfo.LoginName));
                }
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


    [WebMethod(EnableSession = true)]
    public static string exporttoexcel(string labid, string regisyearandmonth, string programid)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" select qcr.centreid,(select centre from centre_master where centreid=" + labid + ") Centre,MONTHNAME(STR_TO_DATE(Entrymonth, '%m'))Entrymonth,EntryYear,");
        
        sb.Append(" (SELECT `EqasProviderName` FROM `qc_eqasprovidermaster` qe  ");
        sb.Append(" INNER JOIN qc_eqasprogrammaster qeq ON qe.EQASProviderID=qeq.EQASProviderID WHERE qeq.programid=qcr.programid LIMIT 1)ProvideName,");
        sb.Append(" qcr.programid,qcr.ProgramName programname");
        sb.Append(" ,qcr.LedgerTransactionNo VisitNo, qcr.test_id,plo.barcodeno SinNo, ");
        sb.Append("  sm.name departmant,plo.itemname InvestigationName,qcr.LabObservationName, ");
        sb.Append(" IFNULL(ploo.`Value`,ifnull(qcr.value,'')) ResultValue,IFNULL(ploo.minvalue,'') minvalue,IFNULL(ploo.`MaxValue`,'')`MaxValue`, ");
        sb.Append(" ifnull(ploo.MacReading,'')MacReading ,ifnull(ploo.MachineName,'')MachineName, ");
        sb.Append(" IFNULL(ploo.`DisplayReading`,'')DisplayReading,IFNULL(ploo.`ReadingFormat`,'')Unit,IFNULL(ploo.flag,'')flag, ");
        sb.Append(" ifnull(qcr.EQASVALUE,'')EQASVALUE,EQASStatus ");
        sb.Append(" ,(case when qcr.EQASDone=1 then 'EQASDone' when qcr.ResultUploaded=1 then 'ResultUploaded' when qcr.Approved=1 then 'Approved'  when qcr.result_flag=1 then 'ResultDone' else 'New' end)CurrentStatus, ");

        sb.Append(" if(ResultUploaded=1,date_format(ExpectedResultDate,'%d-%b-%Y'),'')ExpectedResultDate, ");

        sb.Append(" DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y') ResultApprovedinLabDate,plo.ApprovedName ResultApprovedinLabBy,");


        sb.Append(" DATE_FORMAT(qcr.EntryDateTime,'%d-%b-%Y') EQASRegistrationDate,qcr.EntryByUserName EQASRegistrationBy,");
        sb.Append(" DATE_FORMAT(qcr.ResultEnteredDate,'%d-%b-%Y') EQASResultEnteredDate,qcr.ResultEnteredName EQASResultEnteredBy,");
        sb.Append(" DATE_FORMAT(qcr.ApprovedDate,'%d-%b-%Y') EQASResultApprovedDate,qcr.ApprovedName EQASResultApprovedBy,");
        sb.Append(" DATE_FORMAT(qcr.ResultUploadedDate,'%d-%b-%Y') EQASResultUploadedDate,qcr.ResultUploadedName EQASResultUploadedBy,");
        sb.Append(" DATE_FORMAT(qcr.EQASDoneDate,'%d-%b-%Y') EQASFinalDoneDate,qcr.EQASDoneName EQASFinalDoneBy");
       

        sb.Append(" FROM `qc_eqasregistration` qcr  ");
        sb.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`Test_ID`=qcr.`Test_id`  ");
        sb.Append(" INNER JOIN f_subcategorymaster sm ON sm.`SubCategoryID`=plo.`SubCategoryID` ");
        sb.Append(" LEFT JOIN `patient_labobservation_opd` ploo ON ploo.`Test_ID`=plo.`Test_ID` AND ploo.`LabObservation_ID`=qcr.`LabObservationID` ");
        sb.Append(" WHERE qcr.programid=" + programid + " and qcr.centreid=" + labid + " AND entrymonth=" + regisyearandmonth.Split('#')[0] + " AND entryyear=" + regisyearandmonth.Split('#')[1] + " AND isreject=0 ");


        DataTable dt = StockReports.GetDataTable(sb.ToString());





        DataColumn column = new DataColumn();
        column.ColumnName = "S.No";
        column.DataType = System.Type.GetType("System.Int32");
        column.AutoIncrement = true;
        column.AutoIncrementSeed = 0;
        column.AutoIncrementStep = 1;

        dt.Columns.Add(column);
        int index = 0;
        foreach (DataRow row in dt.Rows)
        {
            row.SetField(column, ++index);
        }
        dt.Columns["S.No"].SetOrdinal(0);
        if (dt.Rows.Count > 0)
        {

            HttpContext.Current.Session["dtExport2Excel"] = dt;
            HttpContext.Current.Session["ReportName"] = "EQASResult";
            return "true";
        }
        else
        {
            return "false";
        }


    }


    [WebMethod]
    public static string removercaandcapa(string MacDataId, string Type, string QCType)
    {

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {




            if (Type == "RCA")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set RCAType='' where Test_id=@id",
                    new MySqlParameter("@id", MacDataId));
            }
            else if (Type == "CorrectiveAction")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set CAType='' where Test_id=@id",
                   new MySqlParameter("@id", MacDataId));
            }
            else if (Type == "PreventiveAction")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_eqasregistration set PAType='' where Test_id=@id",
                   new MySqlParameter("@id", MacDataId));
            }



            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_qcfaildata set IsActive=@IsActive,Updatedate=@Updatedate,UpdatebyId=@UpdatebyId,UpdateByname=@UpdateByname where MacDataId=@MacDataId and  Type=@Type and QCType=@QCType",
              new MySqlParameter("@IsActive", "0"),
              new MySqlParameter("@Updatedate", DateTime.Now),
              new MySqlParameter("@UpdateByID", UserInfo.ID),
              new MySqlParameter("@UpdateByname", UserInfo.LoginName),
              new MySqlParameter("@MacDataId", MacDataId),
              new MySqlParameter("@Type", Type),
              new MySqlParameter("@QCType", QCType)
              );




            tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {

            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.GetString(ex.GetBaseException());

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    
}


public class EQASResult
{
    public string ProgramID { get; set; }
    public string test_id { get; set; }
    public string Value { get; set; }
    public string EQASvalue { get; set; }
    public string EQASStatus { get; set; }
    public string RCA { get; set; }
    public string CorrectiveAction { get; set; }
    public string PreventiveAction { get; set; }
    public string UploadFileName { get; set; }
    public int LabObservationID { get; set; }

}