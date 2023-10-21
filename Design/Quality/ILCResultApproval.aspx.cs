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

public partial class Design_Quality_ILCResultApproval : System.Web.UI.Page
{
    public string ApprovalId = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            ApprovalId = StockReports.ExecuteScalar("SELECT max(`Approval`)  FROM `f_approval_labemployee` WHERE `RoleID`='" + UserInfo.RoleID + "' AND IF(`TechnicalId`='',`EmployeeID`,`TechnicalId`)='" + UserInfo.ID + "' and Approval=4");
            ddlprocessinglab.DataSource = StockReports.GetDataTable(@"SELECT centreid,centre FROM centre_master cm WHERE centreid IN (SELECT DISTINCT tagprocessinglabid FROM centre_master) and ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 ORDER BY centre");
            ddlprocessinglab.DataValueField = "centreid";
            ddlprocessinglab.DataTextField = "centre";
            ddlprocessinglab.DataBind();
            //ddlprocessinglab.Items.Insert(0, new ListItem("Select Processing Lab", "0"));

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

            for (int a = DateTime.Now.Year - 2; a < DateTime.Now.Year+10; a++)
            {
                ddlyear.Items.Add(new ListItem(a.ToString(), a.ToString()));
            }

            ListItem selectedListItem1 = ddlyear.Items.FindByValue(DateTime.Now.Year.ToString());

            if (selectedListItem1 != null)
            {
                selectedListItem1.Selected = true;
            }



            if (ddlprocessinglab.Items.Count > 0)
            {
                // int AccessDays = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1)  FROM qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=2 AND DAY(NOW()) BETWEEN fromdate AND todate  and IsSpecial=0"));

                // if (AccessDays == 0)
                // {
                    // int AccessDaysSpecial = Util.GetInt(StockReports.ExecuteScalar("SELECT count(1)  FROM qc_ilcschedule WHERE `ProcessingLabID`=" + ddlprocessinglab.SelectedValue + " AND isactive=1 AND `ScheduleType`=2 AND DATE(NOW()) BETWEEN `Specialfrom` AND SpecialToDate  and IsSpecial=1"));
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
    public static string getilcresult(string processingcentre,  string regisyearandmonth,  string ilclab)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" select ifnull(qil.RCAType,'')RCAType,ifnull(qil.CAType,'')CAType,ifnull(qil.PAType,'')PAType, ");
        sb.Append("   qir.id savedid, qil.id mapid, qilm.ProcessingLabID, qilm.`ProcessingLabName`, qil.`OLDTest_id`,qir.LabItemName `LabObservationName`, qir.LabItemID `LabObservation_ID` ,");
        sb.Append("  IFNULL(qir.`oldvalue`,'') OLDValue,IFNULL(qir.`oldmethod`,'') oldmethod, '1' reporttype,'Observation' MapType,");
        sb.Append(" IFNULL(qir.`olddisplayreading`,'') olddisplayreading, ");
        sb.Append(" qilm.ilclabname, qil.`Test_id`, qilm.ilclabtypeid,qilm.ILCLabType,qilm.ILCLabID,");

        sb.Append(" ifnull(qir.newvalue,'') newValue,ifnull(qir.newValue1,'') newValue1,");
        sb.Append(" ifnull(qir.newmethod,'') newmethod, ");
        sb.Append(" ifnull(qir.newdisplayreading,'') newdisplayreading ");

        sb.Append(" ,qir.Acceptable AcceptablePer,qir.Variation, ifnull(qir.status,'')`status` ");
        sb.Append(" ,if(ifnull(qil.RCAType,'') ='','',if(qil.RCAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='RCA' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='RCA' and qqs.QCType='ILC')))RCA,  ");


        sb.Append(" if(ifnull(qil.CAType,'') ='','',if(qil.CAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='CorrectiveAction' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='CorrectiveAction' and qqs.QCType='ILC')))CorrectiveAction,  ");


        sb.Append(" if(ifnull(qil.PAType,'') ='','',if(qil.PAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='PreventiveAction' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='PreventiveAction' and qqs.QCType='ILC')))PreventiveAction  ");

        sb.Append(" ,DATE_FORMAT(qir.EntryDate,'%d-%b-%y')EntryDate,qir.EntryByName,Approved");
        sb.Append(" ,ifnull(DATE_FORMAT(qir.ApproveDate,'%d-%b-%y'),'')ApproveDate,ifnull(qir.ApprovedByName,'')ApprovedByName");
        sb.Append(",ifnull(qir.Remarks,'') Remarks,ifnull(UploadFileName,'')UploadFileName");
        sb.Append("  FROM qc_ilcregistration qil ");

        sb.Append(" INNER JOIN qc_ilcparametermapping qilm ON qilm.`ProcessingLabID`=qil.`CentreID` AND qilm.`TestType`='Observation' ");
        sb.Append(" AND qilm.`TestID`=qil.`LabObservationID` and qil.isreject=0 ");
        sb.Append(" and qilm.ILCLabID='" + ilclab.Split('#')[1] + "'");

        sb.Append(" inner join qc_ilcresultentry qir on qir.ProcessingLabID=qil.`CentreID` and qir.MapType='Observation' ");
        sb.Append(" and qir.ilclabtypeid=qilm.ilclabtypeid and qir.ILCLabID=qilm.ILCLabID and qir.LabItemID=qil.`LabObservationID`");
        sb.Append(" and qir.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qir.EntryYear=" + regisyearandmonth.Split('#')[1] + "");

        
       
        sb.Append(" WHERE qil.`MapType`='Observation' ");
        sb.Append(" and qil.centreid='" + processingcentre + "' ");
       
        sb.Append(" and qil.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil.EntryYear=" + regisyearandmonth.Split('#')[1] + "");



        sb.Append(" union all");

        sb.Append("   select ifnull(qil.RCAType,'')RCAType,ifnull(qil.CAType,'')CAType,ifnull(qil.PAType,'')PAType, ");
        sb.Append("   ifnull(qir.id,'')savedid, qil.id mapid, qilm.ProcessingLabID, qilm.`ProcessingLabName`, qil.`OLDTest_id`,qir.LabItemName LabObservationName,qir.LabItemID LabObservation_ID ,");
        sb.Append("  ifnull(qir.oldvalue,'') OLDValue, ''oldmethod,'3' reporttype,'Investigation' MapType,''olddisplayreading,");

        sb.Append(" qilm.ilclabname, qil.`Test_id`, qilm.ilclabtypeid,qilm.ILCLabType,qilm.ILCLabID, ");
        sb.Append(" ifnull(qir.newValue,'') newValue,ifnull(qir.newValue1,'') newValue1,''newmethod,'' newdisplayreading,qir.Acceptable AcceptablePer,qir.Variation ,ifnull(qir.status,'')`status`");


        sb.Append(" ,if(ifnull(qil.RCAType,'') ='','',if(qil.RCAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='RCA' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='RCA' and qqs.QCType='ILC')))RCA,  ");


        sb.Append(" if(ifnull(qil.CAType,'') ='','',if(qil.CAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='CorrectiveAction' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='CorrectiveAction' and qqs.QCType='ILC')))CorrectiveAction,  ");


        sb.Append(" if(ifnull(qil.PAType,'') ='','',if(qil.PAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='PreventiveAction' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='PreventiveAction' and qqs.QCType='ILC')))PreventiveAction  ");


        sb.Append(" ,DATE_FORMAT(qir.EntryDate,'%d-%b-%y')EntryDate,qir.EntryByName,Approved");
        sb.Append(" ,ifnull(DATE_FORMAT(qir.ApproveDate,'%d-%b-%y'),'')ApproveDate,ifnull(qir.ApprovedByName,'')ApprovedByName");
        sb.Append(",ifnull(qir.Remarks,'') Remarks,ifnull(UploadFileName,'')UploadFileName");
        sb.Append("  FROM qc_ilcregistration qil ");

        sb.Append(" INNER JOIN qc_ilcparametermapping qilm ON qilm.`ProcessingLabID`=qil.`CentreID` AND qilm.`TestType`='Investigation' ");
        sb.Append(" AND qilm.`TestID`=qil.`InvestigationID` and qil.isreject=0");
        sb.Append(" and qilm.ILCLabID='" + ilclab.Split('#')[1] + "'");




       


        sb.Append(" INNER join qc_ilcresultentry qir on qir.ProcessingLabID=qil.`CentreID` and qir.MapType='Investigation' ");
        sb.Append(" and qir.ilclabtypeid=qilm.ilclabtypeid and qir.ILCLabID=qilm.ILCLabID and qir.LabItemID=qil.`InvestigationID` ");
        sb.Append(" and qir.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qir.EntryYear=" + regisyearandmonth.Split('#')[1] + "");

        sb.Append(" WHERE qil.`MapType`='Investigation' ");
        sb.Append(" and qil.centreid='" + processingcentre + "' ");
       
        sb.Append(" and qil.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil.EntryYear=" + regisyearandmonth.Split('#')[1] + "");



        // Non Mapped Test

        sb.Append(" union all");
        sb.Append("  select ifnull(qil.RCAType,'')RCAType,ifnull(qil.CAType,'')CAType,ifnull(qil.PAType,'')PAType, ");

        sb.Append("   qir.id savedid, qil.id mapid, qilm.ProcessingLabID, qilm.`ProcessingLabName`, qil.`OLDTest_id`,qir.LabItemName `LabObservationName`, qir.LabItemID `LabObservation_ID` ,");
        sb.Append("  IFNULL(qir.`oldvalue`,'') OLDValue,IFNULL(qir.`oldmethod`,'') oldmethod, '1' reporttype,'Observation' MapType,");
        sb.Append(" IFNULL(qir.`olddisplayreading`,'') olddisplayreading, ");
        sb.Append(" qilm.ilclabname, qil.`Test_id`, qilm.ilclabtypeid,qilm.ILCLabType,qilm.ILCLabID,");

        sb.Append(" ifnull(qir.newvalue,'') newValue,ifnull(qir.newValue1,'') newValue1,");
        sb.Append(" ifnull(qir.newmethod,'') newmethod, ");
        sb.Append(" ifnull(qir.newdisplayreading,'') newdisplayreading ");

        sb.Append(" ,qir.Acceptable AcceptablePer,qir.Variation, ifnull(qir.status,'')`status` ");
        sb.Append(" ,if(ifnull(qil.RCAType,'') ='','',if(qil.RCAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='RCA' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='RCA' and qqs.QCType='ILC')))RCA,  ");


        sb.Append(" if(ifnull(qil.CAType,'') ='','',if(qil.CAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='CorrectiveAction' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='CorrectiveAction' and qqs.QCType='ILC')))CorrectiveAction,  ");


        sb.Append(" if(ifnull(qil.PAType,'') ='','',if(qil.PAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='PreventiveAction' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='PreventiveAction' and qqs.QCType='ILC')))PreventiveAction  ");
        sb.Append(" ,DATE_FORMAT(qir.EntryDate,'%d-%b-%y')EntryDate,qir.EntryByName,Approved");
        sb.Append(" ,ifnull(DATE_FORMAT(qir.ApproveDate,'%d-%b-%y'),'')ApproveDate,ifnull(qir.ApprovedByName,'')ApprovedByName");
        sb.Append(",ifnull(qir.Remarks,'') Remarks,ifnull(UploadFileName,'')UploadFileName");
        sb.Append("  FROM qc_ilcregistration qil ");

        sb.Append(" INNER JOIN qc_ilcparametermapping_special qilm ON qilm.`ProcessingLabID`=qil.`CentreID` AND qilm.`TestType`='Observation' ");
        sb.Append(" AND qilm.`TestID`=qil.`LabObservationID` and qil.isreject=0 ");
        sb.Append(" and qilm.ILCLabID='" + ilclab.Split('#')[1] + "'");
        sb.Append(" AND qilm.cyear=" + regisyearandmonth.Split('#')[1] + " AND qilm.cmonth=" + regisyearandmonth.Split('#')[0] + " ");

        sb.Append(" inner join qc_ilcresultentry qir on qir.ProcessingLabID=qil.`CentreID` and qir.MapType='Observation' ");
        sb.Append(" and qir.ilclabtypeid=qilm.ilclabtypeid and qir.ILCLabID=qilm.ILCLabID and qir.LabItemID=qil.`LabObservationID`");
        sb.Append(" and qir.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qir.EntryYear=" + regisyearandmonth.Split('#')[1] + "");



        sb.Append(" WHERE qil.`MapType`='Observation' ");
        sb.Append(" and qil.centreid='" + processingcentre + "' ");

        sb.Append(" and qil.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil.EntryYear=" + regisyearandmonth.Split('#')[1] + "");



        sb.Append(" union all");

        sb.Append("  select ifnull(qil.RCAType,'')RCAType,ifnull(qil.CAType,'')CAType,ifnull(qil.PAType,'')PAType, ");
        sb.Append("   ifnull(qir.id,'')savedid, qil.id mapid, qilm.ProcessingLabID, qilm.`ProcessingLabName`, qil.`OLDTest_id`,qir.LabItemName LabObservationName,qir.LabItemID LabObservation_ID ,");
        sb.Append("  ifnull(qir.oldvalue,'') OLDValue, ''oldmethod,'3' reporttype,'Investigation' MapType,''olddisplayreading,");

        sb.Append(" qilm.ilclabname, qil.`Test_id`, qilm.ilclabtypeid,qilm.ILCLabType,qilm.ILCLabID, ");
        sb.Append(" ifnull(qir.newValue,'') newValue,ifnull(qir.newValue1,'') newValue1,''newmethod,'' newdisplayreading,qir.Acceptable AcceptablePer,qir.Variation ,ifnull(qir.status,'')`status`");
        sb.Append(" ,if(ifnull(qil.RCAType,'') ='','',if(qil.RCAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='RCA' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='RCA' and qqs.QCType='ILC')))RCA,  ");


        sb.Append(" if(ifnull(qil.CAType,'') ='','',if(qil.CAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='CorrectiveAction' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='CorrectiveAction' and qqs.QCType='ILC')))CorrectiveAction,  ");


        sb.Append(" if(ifnull(qil.PAType,'') ='','',if(qil.PAType='Comment',(select Comment from qc_qcfaildata qqf where qqf.Type='PreventiveAction' and QCType='ILC' and qqf.MacDataId=qil.Test_id and qqf.isactive=1),");
        sb.Append(" (select count(1) from qc_questionanswer_saved  qqs where qqs.IsActive=1 and SavedId=qil.Test_id  and qqs.Type='PreventiveAction' and qqs.QCType='ILC')))PreventiveAction  ");
        sb.Append(" ,DATE_FORMAT(qir.EntryDate,'%d-%b-%y')EntryDate,qir.EntryByName,Approved");
        sb.Append(" ,ifnull(DATE_FORMAT(qir.ApproveDate,'%d-%b-%y'),'')ApproveDate,ifnull(qir.ApprovedByName,'')ApprovedByName");
        sb.Append(",ifnull(qir.Remarks,'') Remarks,ifnull(UploadFileName,'')UploadFileName");
        sb.Append("  FROM qc_ilcregistration qil ");

        sb.Append(" INNER JOIN qc_ilcparametermapping_special qilm ON qilm.`ProcessingLabID`=qil.`CentreID` AND qilm.`TestType`='Investigation' ");
        sb.Append(" AND qilm.`TestID`=qil.`InvestigationID` and qil.isreject=0");
        sb.Append(" and qilm.ILCLabID='" + ilclab.Split('#')[1] + "'");
        sb.Append(" AND qilm.cyear=" + regisyearandmonth.Split('#')[1] + " AND qilm.cmonth=" + regisyearandmonth.Split('#')[0] + " ");







        sb.Append(" INNER join qc_ilcresultentry qir on qir.ProcessingLabID=qil.`CentreID` and qir.MapType='Investigation' ");
        sb.Append(" and qir.ilclabtypeid=qilm.ilclabtypeid and qir.ILCLabID=qilm.ILCLabID and qir.LabItemID=qil.`InvestigationID` ");
        sb.Append(" and qir.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qir.EntryYear=" + regisyearandmonth.Split('#')[1] + "");

        sb.Append(" WHERE qil.`MapType`='Investigation' ");
        sb.Append(" and qil.centreid='" + processingcentre + "' ");

        sb.Append(" and qil.EntryMonth=" + regisyearandmonth.Split('#')[0] + " and qil.EntryYear=" + regisyearandmonth.Split('#')[1] + "");




        DataTable dt = StockReports.GetDataTable(sb.ToString());
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string approveresult(List<ILCResult1> ILCResultData)
    {

        
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            foreach (ILCResult1 ilc in ILCResultData)
            {
                // Update Status of Result
                StringBuilder sb = new StringBuilder();

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update qc_ilcresultentry set Approved=@Approved,ApproveDate=@ApproveDate,ApprovedByName=@ApprovedByName,ApproveByID=@ApproveByID where id=@id",
                   new MySqlParameter("@Approved", "1"),
                   new MySqlParameter("@ApproveDate", Util.GetDateTime(DateTime.Now)),
                   new MySqlParameter("@ApprovedByName", UserInfo.LoginName),
                   new MySqlParameter("@ApproveByID", UserInfo.ID),
                   new MySqlParameter("@id", ilc.ILCRegistrationID)
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

    [WebMethod]
    public static string printreport(List<ILCResult1> ILCResultData, string printtype)
    {

        if (printtype == "Excel")
        {
            string id = string.Join(",", ILCResultData.Select(x => x.ILCRegistrationID).ToArray());
            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT MONTHNAME(STR_TO_DATE(Entrymonth, '%m'))Entrymonth,EntryYear, ProcessingLabName,ilclabname ILCLabName,LabItemName Parameter,oldvalue LaboratoryValue,oldmethod LaboratoryMethod,olddisplayreading LaboratoryDisplayReading,newvalue ReferanceLabValue,newvalue1 ReferanceLabValue1,newmethod ReferanceLabMethod,newdisplayreading ReferanceLabDisplayreading, ");
            sb.Append(" Variation PercentageDifference,Acceptable AccepetanceCriteria,STATUS Accepted_UnAccepeted ,Remarks ");
            sb.Append(" FROM qc_ilcresultentry WHERE id IN (" + id + ") ");


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
                HttpContext.Current.Session["ReportName"] = "ILCSummaryReport";
                return "true";
            }
            else
            {
                return "false";
            }
        }
        else
        {
            return Common.Encrypt(string.Join(",", ILCResultData.Select(x => x.ILCRegistrationID).ToArray()));
        }
    }
    
}

public class ILCResult1
{
    public string ILCRegistrationID { get; set; }
}