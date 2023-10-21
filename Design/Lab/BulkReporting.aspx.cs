using MW6BarcodeASPNet;
using MySql.Data.MySqlClient;
using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

public partial class Design_Lab_BulkReporting : System.Web.UI.Page
{
    private static Bitmap objBitmap;
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Util.GetString(Session["RoleID"]) == "")
            {
                Response.Redirect("~/Design/Default.aspx");
            }

            txtFromDate.Enabled = false;
            txtToDate.Enabled = false;
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtSampleDate1.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txt_SampleTime.Text = DateTime.Now.ToString("HH:mm:ss");
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";


            using (DataTable dt = AllLoad_Data.getCentreByLogin())
            {
                if (dt.Rows.Count > 0)
                {
                    ddlCentreAccess.DataSource = dt;
                    ddlCentreAccess.DataTextField = "Centre";
                    ddlCentreAccess.DataValueField = "CentreID";
                    ddlCentreAccess.DataBind();
                }
            }
            
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveData(string TestID, string Status, string ModDate, string ModTime)
    {
        //try
        //{
        //    string checkSession = UserInfo.Centre;
        //}
        //catch
        //{
        //    return "-1";
        //}
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string ParameterID = "1469";
            string ParameterName = "COVID-19 Virus QUALITATIVE RT-PCR";
            string MethodName = "";  //RT-PCR
            string Investigaiton_ID = "7368";
            string ApprovedByID = "484";
            string ApprovedBy = "SATISH KR MAGU 3";
            int InterpretationID = 0;
            StringBuilder sb = new StringBuilder();
            TestID = TestID.TrimEnd(',');
            TestID = "'" + TestID + "'";
            TestID = TestID.Replace(",", "','");

             DataTable  dtTempInter = MySqlHelper.ExecuteDataset(tranx, CommandType.Text, " SELECT id,Investigation_Id,Interpretation,PrintInterTest,PrintInterPackage FROM investigation_master_interpretation where Investigation_Id=@Investigation_Id and centreid=@centreid and macid=@macid and isactive=1 ",
                    new MySqlParameter("@Investigation_Id", Investigaiton_ID),
                    new MySqlParameter("@centreid", "1"),
                    new MySqlParameter("@macid", "1")).Tables[0];
             if (dtTempInter.Rows.Count > 0)
             {
                 InterpretationID = Util.GetInt(dtTempInter.Rows[0]["ID"]);
             }


            //collection
            if (Status == "1")
            {
                sb = new StringBuilder();
                sb.Append(@" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,BarcodeNo,Test_ID,`Status`,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID)
                             SELECT plo.`LedgerTransactionNo`,plo.BarcodeNo,plo.Test_ID,'Bulk Sample Collection(" + Util.GetDateTime(ModDate).ToString("yyyy-MM-dd") + " " + ModTime + ")' `Status`,'" + UserInfo.ID + @"' UserID,'" + UserInfo.LoginName + @"' UserName,NOW() dtEntry,
                             '" + StockReports.getip() + @"' IpAddress,'" + UserInfo.Centre + @"' CentreID,'" + UserInfo.RoleID + @"' RoleID
                             FROM patient_labinvestigation_opd plo
                             INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo`
                             INNER JOIN investigation_master inv ON inv.Investigation_Id=plo.Investigation_ID  and inv.Investigation_Id='" + Investigaiton_ID + @"'
                             INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=inv.`Investigation_Id` AND ist.`IsDefault`=1
                             WHERE plo.Test_ID in (" + TestID + @") AND plo.`IsSampleCollected`='N' GROUP BY plo.test_id;  ");
       
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                sb.Append(@"     UPDATE patient_labinvestigation_opd plo
                                 INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo`
                                 INNER JOIN investigation_master inv ON inv.Investigation_Id=plo.Investigation_ID  and inv.Investigation_Id='" + Investigaiton_ID + @"'
                                 INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=inv.`Investigation_Id` AND ist.`IsDefault`=1
                                 SET plo.IsSampleCollected = 'S',
                                 plo.SampleTypeID=ist.`SampleTypeID`,
                                 plo.SampleTypeName=ist.`SampleTypeName`,
                                 plo.SampleCollectionDate='" + Util.GetDateTime(ModDate).ToString("yyyy-MM-dd") + @" " + ModTime + @"',
                                 plo.SampleCollectionBy = '" + UserInfo.ID + @"',
                                 plo.SampleCollector = '" + UserInfo.LoginName + @"',
                                 plo.UpdateID ='" + UserInfo.ID + @"',
                                 plo.UpdateName='" + UserInfo.LoginName + @"',
                                 plo.UpdateRemarks='Bulk CR',
                                 plo.Updatedate=NOW()
                                 WHERE plo.Test_ID in (" + TestID + @") AND plo.`IsSampleCollected`='N'    ");

                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
            }
            //Receive
            else if (Status == "2")
            {
                sb = new StringBuilder();
                sb.Append(@" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,BarcodeNo,Test_ID,`Status`,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID)
                             SELECT plo.`LedgerTransactionNo`,plo.BarcodeNo,plo.Test_ID,'Bulk Sample Receive(" + Util.GetDateTime(ModDate).ToString("yyyy-MM-dd") + " " + ModTime + ")' `Status`,'" + UserInfo.ID + @"' UserID,'" + UserInfo.LoginName + @"' UserName,NOW() dtEntry,
                             '" + StockReports.getip() + @"' IpAddress,'" + UserInfo.Centre + @"' CentreID,'" + UserInfo.RoleID + @"' RoleID
                             FROM patient_labinvestigation_opd plo
                             INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo`
                             INNER JOIN investigation_master inv ON inv.Investigation_Id=plo.Investigation_ID  and inv.Investigation_Id='" + Investigaiton_ID + @"'
                             INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=inv.`Investigation_Id` AND ist.`IsDefault`=1
                             WHERE plo.Test_ID in (" + TestID + @") AND plo.`IsSampleCollected`='S' GROUP BY plo.test_id;  ");

 
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
                sb = new StringBuilder();
                sb.Append(@"     UPDATE patient_labinvestigation_opd plo
                                 INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo`
                                 INNER JOIN investigation_master inv ON inv.Investigation_Id=plo.Investigation_ID  and inv.Investigation_Id='" + Investigaiton_ID + @"'
                                 INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=inv.`Investigation_Id` AND ist.`IsDefault`=1
								 LEFT JOIN test_centre_mapping tcm ON plo.`CentreID`=tcm.`Booking_Centre` AND plo.`Investigation_ID`=tcm.`Investigation_ID`
                                 SET TestCentreID='1',plo.IsSampleCollected = 'Y',
                                 plo.SampleTypeID=ist.`SampleTypeID`,
                                 plo.SampleTypeName=ist.`SampleTypeName`,
                                 plo.SampleReceiveDate='" + Util.GetDateTime(ModDate).ToString("yyyy-MM-dd") + @" " + ModTime + @"',
                                 plo.SampleReceiver='" + UserInfo.LoginName + @"',
                                 plo.SampleReceivedBy='" + UserInfo.ID + @"',
                                 plo.UpdateID ='" + UserInfo.ID + @"',
                                 plo.UpdateName='" + UserInfo.LoginName + @"',
                                 plo.UpdateRemarks='Bulk CR',
                                 plo.Updatedate=NOW()
                                 WHERE plo.Test_ID in (" + TestID + @") AND plo.`IsSampleCollected`='S'  ;  ");
 
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
            }
            //reject
            else if (Status == "6")
            {
                sb = new StringBuilder();
                sb.Append(@" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,BarcodeNo,Test_ID,`Status`,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID)
                             SELECT plo.`LedgerTransactionNo`,plo.BarcodeNo,plo.Test_ID,'Bulk Sample Reject(" + Util.GetDateTime(ModDate).ToString("yyyy-MM-dd") + " " + ModTime + ")' `Status`,'" + UserInfo.ID + @"' UserID,'" + UserInfo.LoginName + @"' UserName,NOW() dtEntry,
                             '" + StockReports.getip() + @"' IpAddress,'" + UserInfo.Centre + @"' CentreID,'" + UserInfo.RoleID + @"' RoleID
                             FROM patient_labinvestigation_opd plo
                             INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo`
                             INNER JOIN investigation_master inv ON inv.Investigation_Id=plo.Investigation_ID  and inv.Investigation_Id='" + Investigaiton_ID + @"'
                             INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=inv.`Investigation_Id` AND ist.`IsDefault`=1
                             WHERE plo.Test_ID in (" + TestID + @") AND plo.Result_Flag=0 and plo.Approved=0 GROUP BY plo.test_id;  ");


                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
                sb = new StringBuilder();
                sb.Append(@"     UPDATE patient_labinvestigation_opd plo
                                 INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionNo`=plo.`LedgerTransactionNo`
                                 INNER JOIN investigation_master inv ON inv.Investigation_Id=plo.Investigation_ID  and inv.Investigation_Id='" + Investigaiton_ID + @"'
                                 INNER JOIN `investigations_sampletype` ist ON ist.`Investigation_ID`=inv.`Investigation_Id` AND ist.`IsDefault`=1
                                 SET plo.IsSampleCollected = 'R',
                                 plo.SampleTypeID=ist.`SampleTypeID`,
                                 plo.SampleTypeName=ist.`SampleTypeName`,
                                 plo.UpdateID ='" + UserInfo.ID + @"',
                                 plo.UpdateName='" + UserInfo.LoginName + @"',
                                 plo.UpdateRemarks='Bulk Reject',
                                 plo.Updatedate=NOW()
                                 WHERE plo.Test_ID in (" + TestID + @") AND plo.Result_Flag=0 and plo.Approved=0  ;  ");
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
            }
            //Save Result
            else if (Status == "3")
            {
                sb = new StringBuilder();
                sb.Append(@" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,BarcodeNo,Test_ID,`Status`,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID)
                             SELECT plo.`LedgerTransactionNo`,plo.BarcodeNo,plo.Test_ID,'Bulk Result Save Negative(" + Util.GetDateTime(ModDate).ToString("yyyy-MM-dd") + " " + ModTime + ")' `Status`,'" + UserInfo.ID + @"' UserID,'" + UserInfo.LoginName + @"' UserName,NOW() dtEntry,
                             '" + StockReports.getip() + @"' IpAddress,'" + UserInfo.Centre + @"' CentreID,'" + UserInfo.RoleID + @"' RoleID
                             FROM patient_labinvestigation_opd plo
                             WHERE plo.Test_ID IN (" + TestID + @") AND plo.`IsSampleCollected`='Y' AND Result_Flag=0;  "); 
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());

                string strDelete = " DELETE t.* FROM patient_labobservation_opd t INNER JOIN patient_labinvestigation_opd plo on plo.Test_ID=t.Test_ID WHERE plo.Test_ID IN (" + TestID + ") AND plo.`IsSampleCollected`='Y' AND plo.Result_Flag=0; ";

                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strDelete);

                sb = new StringBuilder();
                sb.Append(@"  INSERT INTO patient_labobservation_opd(LabObservation_ID,Test_ID,ResultDateTime,`Value`,`LabObservationName`,Priorty,InvPriorty,
                               DisplayReading,LedgerTransactionNo,Method)
                               SELECT '" + ParameterID + @"' LabObservation_ID,plo.Test_ID,CURRENT_DATE() ResultDateTime,'Negative' `Value`,
                               '" + ParameterName + @"' LabObservationName,99 Priorty,99 InvPriorty,'Negative' DisplayReading,plo.LedgerTransactionNo,'"+ MethodName + @"' Method
                               FROM patient_labinvestigation_opd plo
                               WHERE plo.Test_ID IN (" + TestID + @") AND plo.`IsSampleCollected`='Y' AND Result_Flag=0;  ");
               
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
                string Interpretation = Util.GetString(MySqlHelper.ExecuteScalar(tranx, CommandType.Text, "SELECT Interpretation FROM investigation_master WHERE Investigation_ID='" + Investigaiton_ID + "'"));
               
//                strDelete = " DELETE t.* FROM patientwise_interpretation t INNER JOIN patient_labinvestigation_opd plo on plo.Test_ID=t.Test_ID WHERE plo.Test_ID IN (" + TestID + ") AND plo.`IsSampleCollected`='Y' AND plo.Result_Flag=0; ";
               
//                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, strDelete);
//                sb = new StringBuilder();
//                sb.Append(" INSERT INTO patientwise_interpretation(LedgertransactionNo,Investigation_ID,LabObservation_ID,Test_ID,UserID,UserName,dtEntry,IpAddress,Interpretation,Updatedate) ");
//                sb.Append(" SELECT plo.LedgertransactionNo,'" + Investigaiton_ID + @"' Investigation_ID,0 LabObservation_ID, plo.Test_ID,
//                            '" + UserInfo.ID + @"' UserID,'" + UserInfo.LoginName + @"' UserName,NOW() dtEntry, '" + StockReports.getip() + @"' IpAddress   ,'" + Interpretation + @"' Interpretation, NOW() Updatedate
//                                from Patient_LabInvestigation_OPD plo where plo.Test_ID IN (" + TestID + @") AND plo.`IsSampleCollected`='Y' AND plo.Result_Flag=0;  ");
               
//                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                sb.Append(@"  UPDATE patient_labinvestigation_opd plo
                              SET  InterpretationID='"+ InterpretationID +"',InterpretationType='InvestigationWise',Result_Flag=1,ResultEnteredBy='" + UserInfo.ID + @"',ResultEnteredName='" + UserInfo.LoginName + @"',ResultEnteredDate=NOW(),
                              Approved=0,IsHold=0,isPartial_Result=0,isForward=0,AutoApproved=3,ReportType=1,
                              plo.UpdateID ='" + UserInfo.ID + @"',plo.UpdateName='" + UserInfo.LoginName + @"',plo.UpdateRemarks='Bulk Result Save',plo.Updatedate=NOW()
                              WHERE plo.Test_ID IN (" + TestID + @") AND plo.`IsSampleCollected`='Y' AND Result_Flag=0;  ");
                
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());

            }
            //Hold
            else if (Status == "4")
            {
                sb = new StringBuilder();
                sb.Append(@" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,BarcodeNo,Test_ID,`Status`,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID)
                             SELECT plo.`LedgerTransactionNo`,plo.BarcodeNo,plo.Test_ID,'Bulk Hold(" + Util.GetDateTime(ModDate).ToString("yyyy-MM-dd") + " " + ModTime + ")' `Status`,'" + UserInfo.ID + @"' UserID,'" + UserInfo.LoginName + @"' UserName,NOW() dtEntry,
                             '" + StockReports.getip() + @"' IpAddress,'" + UserInfo.Centre + @"' CentreID,'" + UserInfo.RoleID + @"' RoleID
                             FROM patient_labinvestigation_opd plo
                             INNER JOIN patient_labobservation_opd ploo ON ploo.`Test_ID`=plo.`Test_ID` AND ploo.`Value`='Negative'
                             WHERE plo.Test_ID IN (" + TestID + @") AND plo.`IsSampleCollected`='Y' AND plo.Result_Flag=1 AND plo.Approved=0 GROUP BY plo.`Test_ID`; ");
             
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                sb.Append(@"  UPDATE patient_labinvestigation_opd plo
                              INNER JOIN patient_labobservation_opd ploo ON ploo.`Test_ID`=plo.`Test_ID` AND ploo.`Value`='Negative'
                              SET IsHold=1 , HoldByName='" + UserInfo.LoginName + @"',HoldBy='" + UserInfo.ID + @"',AutoApproved=3
                              WHERE plo.Test_ID IN (" + TestID + @") AND plo.`IsSampleCollected`='Y' AND Result_Flag=1 AND plo.Approved=0 ;  ");
                
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
            }

         //Approved
            else if (Status == "5")
            {
                sb = new StringBuilder();
                sb.Append(@" INSERT INTO patient_labinvestigation_opd_update_status(LedgerTransactionNo,BarcodeNo,Test_ID,`Status`,UserID,UserName,dtEntry,IpAddress,CentreID,RoleID)
                             SELECT plo.`LedgerTransactionNo`,plo.BarcodeNo,plo.Test_ID,'Bulk Approved Negative(" + Util.GetDateTime(ModDate).ToString("yyyy-MM-dd") + " " + ModTime + ")' `Status`,'" + UserInfo.ID + @"' UserID,'" + UserInfo.LoginName + @"' UserName,NOW() dtEntry,
                             '" + StockReports.getip() + @"' IpAddress,'" + UserInfo.Centre + @"' CentreID,'" + UserInfo.RoleID + @"' RoleID
                             FROM patient_labinvestigation_opd plo
                             INNER JOIN patient_labobservation_opd ploo ON ploo.`Test_ID`=plo.`Test_ID` AND ploo.`Value`='Negative'
                             WHERE plo.Test_ID IN (" + TestID + @") AND plo.`IsSampleCollected`='Y' AND plo.Result_Flag=1 AND plo.Approved=0 GROUP BY plo.`Test_ID`; ");
             
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());

                sb = new StringBuilder();
                sb.Append(@"  UPDATE patient_labinvestigation_opd plo
                              INNER JOIN patient_labobservation_opd ploo ON ploo.`Test_ID`=plo.`Test_ID` AND ploo.`Value`='Negative'
                              SET InterpretationID='"+ InterpretationID +"',InterpretationType='InvestigationWise',plo.Approved=1,plo.ApprovedBy='" + ApprovedByID + @"',plo.ApprovedDate='" + Util.GetDateTime(ModDate).ToString("yyyy-MM-dd") + @" " + ModTime + @"',
                              plo.ApprovedName='" + ApprovedBy + @"',plo.ApprovedDoneBy='" + UserInfo.ID + @"',plo.IsHold=0,plo.isPartial_Result=0,plo.isForward=0,plo.AutoApproved=4
                              WHERE plo.Test_ID IN (" + TestID + @") AND plo.`IsSampleCollected`='Y' AND plo.Result_Flag=1 AND plo.Approved=0 ;  ");
              
                MySqlHelper.ExecuteNonQuery(tranx, CommandType.Text, sb.ToString());
            }
            tranx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tranx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SearchData(string Status, string LabNo, string RegNo, string PName, string Mobile, string FromDate, string ToDate, string CentreID, string PanelID, string DoctorID, string TimeFrm, string TimeTo, int isDeptSearch)
    {
        StringBuilder sb = new StringBuilder();

        try
        {
            string Investigaiton_ID = "7368";
            sb.AppendLine(" SELECT  pli.Test_ID, ");
            sb.AppendLine(" (SELECT Centre FROM centre_master cm WHERE cm.CentreID=lt.CentreID) Centre,  ");
            sb.AppendLine(" DATE_FORMAT(lt.Date,'%d-%b-%Y %I:%i %p') RegDate,  ");
            sb.AppendLine(" lt.LedgerTransactionNo LabNo,pli.BarcodeNo,CONCAT(pm.Title,' ',pm.PName) PName,  ");
            sb.AppendLine(" CONCAT(pm.Age,'/',LEFT(pm.Gender,1)) AgeGender,pm.Mobile,  ");
            sb.AppendLine(" lt.srfno,lt.DoctorName DocName,  ");
            sb.AppendLine(" lt.PanelName PanelName,  ");
            sb.AppendLine(" otm.Name DeptName,inv.Name Investigation,CASE  WHEN pli.IsDispatch='1' AND pli.isFOReceive='1' THEN '#44A3AA' WHEN pli.IsFOReceive='1' THEN '#E9967A' WHEN pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1' THEN '#00FFFF' WHEN pli.Approved='1' And pli.isHold='0' THEN '#90EE90' WHEN pli.Result_Flag='1'And pli.isHold='0' And pli.isForward='0'AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R' THEN '#FFC0CB' WHEN pli.Result_Flag='1'And pli.isHold='0' And pli.isForward='0' AND isPartial_Result='1'  THEN '#A9A9A9' WHEN pli.Result_Flag='1'And pli.isHold='0' And pli.isForward='1' THEN '#3399FF' when pli.Result_Flag='0' and pli.isrerun='1' then '#F781D8'  WHEN pli.Result_Flag='0' And (SELECT COUNT(*) FROM mac_data mac WHERE mac.LedgerTransactionNO=pli.LedgerTransactionNO AND mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 THEN '#E2680A' WHEN pli.isHold='1' THEN '#FFFF00'  WHEN pli.IsSampleCollected='N' AND pli.Result_Flag='0' THEN '#CC99FF' WHEN pli.IsSampleCollected='S' AND pli.Result_Flag='0' THEN '#89f2f2' WHEN pli.IsSampleCollected='R' THEN '#B0C4DE' ELSE '#FFFFFF' END rowColor,  ");//when  pli.IsSampleCollected='Y' and pli.isautoconsume=0 and pli.autoconsumeoption>0 then '#A9A518'
            sb.AppendLine(" 0 IsPatientPreparation,'' PatientPreparationBy,DATE_FORMAT(NOW(),'%d-%b-%Y %I:%i %p') PatientPreparationDateTime,DATE_FORMAT(pli.SampleReceiveDate,'%d-%b-%Y %I:%i %p')SampleReceiveDate  ");
            sb.AppendLine(" FROM patient_labinvestigation_opd pli   ");
            sb.AppendLine(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo and pli.isreporting=1 and pli.IsHold=0  ");
            if (LabNo.Trim() == "" && isDeptSearch == 0)
            {
                sb.AppendLine(" and lt.date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm + "' and LT.date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + TimeTo + "' ");
            }
            else if (LabNo.Trim() == "" && isDeptSearch == 1)
            {
                sb.AppendLine(" and pli.SampleReceiveDate>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm + "' and pli.SampleReceiveDate<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + TimeTo + "' ");
            }
            if (LabNo.Trim() != string.Empty)
            {
                sb.AppendLine(" and (lt.LedgerTransactionNo='" + LabNo + "' or srfno='"+ LabNo +"') ");
            }
            if (Status == "13")
            {
                sb.AppendLine(" and pli.isrerun=1  AND pli.Result_flag=0 ");
            }

            if (Status == "22")
            {
                sb.AppendLine(" and pli.isautoconsume=0 and pli.autoconsumeoption>0 AND pli.Result_flag=0 and IsSampleCollected='Y' ");
            }
            else if (Status == "1")
            {
                sb.AppendLine(" and pli.Result_Flag='0' And (SELECT COUNT(*) FROM mac_data mac WHERE mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 ");
                //sb.AppendLine(" AND mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 ");
            }
            else if (Status == "2")
            {
                sb.AppendLine(" AND pli.IsSampleCollected = 'R' ");
            }
            else if (Status == "3")
            {
                sb.AppendLine(" AND pli.IsSampleCollected='N'  ");
            }
            else if (Status == "4")
            {
                sb.AppendLine(" AND  pli.Result_Flag=1  and (pli.Approved is null or pli.Approved=0) and isForward=0 and pli.isHold=0  AND pli.isPartial_Result=0  ");
            }
            else if (Status == "5")
            {
                sb.AppendLine(" AND  pli.Result_Flag=0  and pli.IsSampleCollected='Y'   ");
            }
            else if (Status == "6")
            {
                sb.AppendLine(" AND   pli.Approved='0' AND  pli.Result_Flag=0  and pli.IsSampleCollected='S'   ");
            }
            else if (Status == "7")
            {
                sb.AppendLine(" AND  pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='1' AND   pli.Approved='0'  ");
            }
            else if (Status == "8")
            {
                sb.AppendLine(" AND   pli.isHold='1'  ");
            }
            else if (Status == "9")
            {
                sb.AppendLine(" AND  pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='1'  ");
            }
            else if (Status == "10")
            {
                sb.AppendLine(" AND  pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1'  ");
            }
            else if (Status == "11")
            {
                sb.AppendLine(" AND  pli.IsFOReceive='1'  ");
            }
            else if (Status == "12")
            {
                sb.AppendLine(" AND  pli.IsDispatch='1' AND pli.isFOReceive='1'  ");
            }
            else if (Status == "25")
            {
                sb.AppendLine(" AND  lt.AgainstPONo<>''   ");
            }
            //Bilal- 06.05.2019
            else if (Status == "99")
            {
                sb.AppendLine(" AND  pli.IsSchedulerApproval=1 ");
            }
            if (RegNo.Trim() != "")
            {
                RegNo = RegNo.Replace("LSHHI", "");
                sb.AppendLine(" and lt.Patient_ID='LSHHI" + RegNo + "' ");
            }
            if (CentreID != "" && CentreID != "ALL")
            {
                sb.AppendLine(" and lt.CentreID IN (" + CentreID + ") ");
            }
            else if (CentreID == "ALL")
            {
                sb.AppendLine(" and (lt.CentreID in ( SELECT DISTINCT CentreAccess FROM centre_access WHERE CentreID='" + UserInfo.Centre + "'  ) or lt.CentreID=" + UserInfo.Centre + " ) ");
            }
            else
            {
                sb.AppendLine(" and lt.CentreID=" + UserInfo.Centre + " ");
            }

            if (PanelID != string.Empty)
            {
                sb.AppendLine(" and lt.Panel_ID IN (" + PanelID + ") ");
            }

         
            sb.AppendLine(" INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID  ");
            if (PName.Trim() != "")
            {
                sb.AppendLine(" and pm.PName Like '" + PName + "%' ");
            }
            if (Mobile.Trim() != string.Empty)
            {
                sb.AppendLine(" and pm.Mobile='" + Mobile + "' ");
            }

            sb.AppendLine(" INNER JOIN Investigation_master inv ON inv.Investigation_Id=pli.Investigation_ID AND inv.`Investigation_Id`='" + Investigaiton_ID + @"'");
            sb.AppendLine(" INNER JOIN investigation_observationtype iot ON iot.Investigation_ID=inv.Investigation_Id  ");
            sb.AppendLine(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_Id ");
            sb.AppendLine(" Order by lt.LedgerTransactionNo,otm.Name,inv.Name");
            if (Util.GetString(HttpContext.Current.Session["ID"]) == "1")
            {
                   //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\Bulkregistrationsearch.txt", sb.ToString());
            }
			  //   System.IO.File.WriteAllText(@"D:\Live_MediBird\jjjj.txt",sb.ToString());
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            return makejsonoftable(dt, makejson.e_without_square_brackets); ;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    [WebMethod(EnableSession = true)]
    public static string PrintWorksheet(string Status, string LabNo, string RegNo, string PName, string Mobile, string FromDate, string ToDate, string CentreID, string PanelID, string DoctorID, string TimeFrm, string TimeTo, string TestID)
    {
        StringBuilder sb = new StringBuilder();

        try
        {
            string Investigaiton_ID = "7368";
            sb.AppendLine(" SELECT pli.Internalno, pli.Test_ID, ");
            sb.AppendLine(" (SELECT Centre FROM centre_master cm WHERE cm.CentreID=lt.CentreID) Centre,  ");
            sb.AppendLine(" DATE_FORMAT(lt.Date,'%d-%b-%Y %I:%i %p') RegDate,  ");
            sb.AppendLine(" lt.LedgerTransactionNo LabNo,pli.BarcodeNo,CONCAT(pm.Title,' ',pm.PName) PName,  ");
            sb.AppendLine(" pm.Age,pm.Gender,pm.Mobile,  ");
            sb.AppendLine(" lt.DoctorName DocName,  ");
            sb.AppendLine(" lt.PanelName PanelName,  ");
            sb.AppendLine(" otm.Name DeptName,inv.Name Investigation,CASE  WHEN pli.IsDispatch='1' AND pli.isFOReceive='1' THEN '#44A3AA' WHEN pli.IsFOReceive='1' THEN '#E9967A' WHEN pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1' THEN '#00FFFF' WHEN pli.Approved='1' And pli.isHold='0' THEN '#90EE90' WHEN pli.Result_Flag='1'And pli.isHold='0' And pli.isForward='0'AND isPartial_Result='0' AND  pli.IsSampleCollected<>'R' THEN '#FFC0CB' WHEN pli.Result_Flag='1'And pli.isHold='0' And pli.isForward='0' AND isPartial_Result='1'  THEN '#A9A9A9' WHEN pli.Result_Flag='1'And pli.isHold='0' And pli.isForward='1' THEN '#3399FF' when pli.Result_Flag='0' and pli.isrerun='1' then '#F781D8'  WHEN pli.Result_Flag='0' And (SELECT COUNT(*) FROM mac_data mac WHERE mac.LedgerTransactionNO=pli.LedgerTransactionNO AND mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 THEN '#E2680A' WHEN pli.isHold='1' THEN '#FFFF00'  WHEN pli.IsSampleCollected='N' AND pli.Result_Flag='0' THEN '#CC99FF' WHEN pli.IsSampleCollected='S' AND pli.Result_Flag='0' THEN '#89f2f2' WHEN pli.IsSampleCollected='R' THEN '#B0C4DE' ELSE '#FFFFFF' END rowColor,  ");//when  pli.IsSampleCollected='Y' and pli.isautoconsume=0 and pli.autoconsumeoption>0 then '#A9A518'
            sb.AppendLine(" 0 IsPatientPreparation,'' PatientPreparationBy,DATE_FORMAT(NOW(),'%d-%b-%Y %I:%i %p') PatientPreparationDateTime  ");
            sb.AppendLine(" FROM patient_labinvestigation_opd pli   ");
            sb.AppendLine(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo and pli.Approved=0 and pli.IsHold=0  ");
            sb.AppendLine(" and pli.test_ID in(" + TestID.TrimEnd(',')  + ") ");
            if (LabNo.Trim() == "")
            {
                sb.AppendLine(" and lt.date>='" + Util.GetDateTime(FromDate).ToString("yyyy-MM-dd") + " " + TimeFrm + "' and LT.date<='" + Util.GetDateTime(ToDate).ToString("yyyy-MM-dd") + " " + TimeTo + "' ");
            }
            if (LabNo.Trim() != string.Empty)
            {
                sb.AppendLine(" and lt.LedgerTransactionNo='" + LabNo + "' ");
            }
            if (Status == "13")
            {
                sb.AppendLine(" and pli.isrerun=1  AND pli.Result_flag=0 ");
            }

            if (Status == "22")
            {
                sb.AppendLine(" and pli.isautoconsume=0 and pli.autoconsumeoption>0 AND pli.Result_flag=0 and IsSampleCollected='Y' ");
            }
            else if (Status == "1")
            {
                sb.AppendLine(" and pli.Result_Flag='0' And (SELECT COUNT(*) FROM mac_data mac WHERE mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 ");
                //sb.AppendLine(" AND mac.Test_ID=pli.Test_ID AND IFNULL(Reading,'')<>'')>0 ");
            }
            else if (Status == "2")
            {
                sb.AppendLine(" AND pli.IsSampleCollected = 'R' ");
            }
            else if (Status == "3")
            {
                sb.AppendLine(" AND pli.IsSampleCollected='N'  ");
            }
            else if (Status == "4")
            {
                sb.AppendLine(" AND  pli.Result_Flag=1  and (pli.Approved is null or pli.Approved=0) and isForward=0 and pli.isHold=0  AND pli.isPartial_Result=0  ");
            }
            else if (Status == "5")
            {
                sb.AppendLine(" AND  pli.Result_Flag=0  and pli.IsSampleCollected='Y'   ");
            }
            else if (Status == "6")
            {
                sb.AppendLine(" AND   pli.Approved='0' AND  pli.Result_Flag=0  and pli.IsSampleCollected='S'   ");
            }
            else if (Status == "7")
            {
                sb.AppendLine(" AND  pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='0' AND isPartial_Result='1' AND   pli.Approved='0'  ");
            }
            else if (Status == "8")
            {
                sb.AppendLine(" AND   pli.isHold='1'  ");
            }
            else if (Status == "9")
            {
                sb.AppendLine(" AND  pli.Result_Flag='1'AND pli.isHold='0' AND pli.isForward='1'  ");
            }
            else if (Status == "10")
            {
                sb.AppendLine(" AND  pli.isFOReceive='0' AND pli.Approved='1' AND pli.isPrint='1'  ");
            }
            else if (Status == "11")
            {
                sb.AppendLine(" AND  pli.IsFOReceive='1'  ");
            }
            else if (Status == "12")
            {
                sb.AppendLine(" AND  pli.IsDispatch='1' AND pli.isFOReceive='1'  ");
            }
            else if (Status == "25")
            {
                sb.AppendLine(" AND  lt.AgainstPONo<>''   ");
            }
            //Bilal- 06.05.2019
            else if (Status == "99")
            {
                sb.AppendLine(" AND  pli.IsSchedulerApproval=1 ");
            }
            if (RegNo.Trim() != "")
            {
                RegNo = RegNo.Replace("LSHHI", "");
                sb.AppendLine(" and lt.Patient_ID='LSHHI" + RegNo + "' ");
            }
            if (CentreID != "" && CentreID != "ALL")
            {
                sb.AppendLine(" and lt.CentreID IN (" + CentreID + ") ");
            }
            else if (CentreID == "ALL")
            {
                sb.AppendLine(" and (lt.CentreID in ( SELECT DISTINCT CentreAccess FROM centre_access WHERE CentreID='" + UserInfo.Centre + "'  ) or lt.CentreID=" + UserInfo.Centre + " ) ");
            }
            else
            {
                sb.AppendLine(" and lt.CentreID=" + UserInfo.Centre + " ");
            }

            if (PanelID != string.Empty)
            {
                sb.AppendLine(" and lt.Panel_ID IN (" + PanelID + ") ");
            }


            sb.AppendLine(" INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID  ");
            if (PName.Trim() != "")
            {
                sb.AppendLine(" and pm.PName Like '" + PName + "%' ");
            }
            if (Mobile.Trim() != string.Empty)
            {
                sb.AppendLine(" and pm.Mobile='" + Mobile + "' ");
            }

            sb.AppendLine(" INNER JOIN Investigation_master inv ON inv.Investigation_Id=pli.Investigation_ID AND inv.`Investigation_Id`='" + Investigaiton_ID + @"'");
            sb.AppendLine(" INNER JOIN investigation_observationtype iot ON iot.Investigation_ID=inv.Investigation_Id  ");
            sb.AppendLine(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_Id ");
            sb.AppendLine(" Order by lt.LedgerTransactionNo,otm.Name,inv.Name");
            if (Util.GetString(HttpContext.Current.Session["ID"]) == "1")
            {
                //   System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\Bulkregistrationsearch.txt", sb.ToString());
            }
            //   System.IO.File.WriteAllText(@"D:\Live_MediBird\jjjj.txt",sb.ToString());
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
              
                dt.Columns.Add("Image", System.Type.GetType("System.Byte[]"));
                for (int i = 0; i < dt.Rows.Count; i++)
                {
                    OutputImg(Util.GetString(dt.Rows[i]["barcodeno"].ToString()));
                    dt.Rows[i]["Image"] = GetBitmapBytes(objBitmap);
                }
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
               // ds.WriteXmlSchema("E:/covid.xml");
                HttpContext.Current.Session["ds"] = ds;
                HttpContext.Current.Session["ReportName"] = "COVID Worksheet";
                return "1";
            }
            else
                return "0";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
    }
    private static void OutputImg(string LedgerTranNo)
    {

        string FontName = "";
        Graphics objGraphics;
        Point p;

        //Response.ContentType = "image/Jpeg";
        Barcode MyBarcode = new Barcode();
        MyBarcode.BackColor = Color.White;
        MyBarcode.BarColor = Color.Black;
        MyBarcode.CheckDigit = true;
        MyBarcode.CheckDigitToText = true;
        MyBarcode.Data = LedgerTranNo;
        MyBarcode.BarHeight = 1.0F;
        MyBarcode.NarrowBarWidth = 0.03F;
        MyBarcode.Orientation = MW6BarcodeASPNet.enumOrientation.or0;
        MyBarcode.SymbologyType = MW6BarcodeASPNet.enumSymbologyType.syCode128;
        MyBarcode.ShowText = false;
        MyBarcode.Wide2NarrowRatio = 0.5F;
        FontName = "Verdana, Arial, sans-serif";
        MyBarcode.TextFont = new Font(FontName, 8.0F);
        MyBarcode.SetSize(300, 45);
        objBitmap = new Bitmap(300, 45);
        objGraphics = Graphics.FromImage(objBitmap);
        p = new Point(0, 0);
        MyBarcode.Render(objGraphics, p);
        objGraphics.Flush();
        if (System.IO.File.Exists(HttpContext.Current.Server.MapPath(@"~\Design\2.jpeg")))
        {
            System.IO.File.Delete(HttpContext.Current.Server.MapPath(@"~\Design\2.jpeg"));
        }
    }
    private static byte[] GetBitmapBytes(Bitmap Bitmap1)    //  getting Stream of Bar Code image
    {
        MemoryStream memStream = new MemoryStream();
        byte[] bytes;

        try
        {
            // Save the bitmap to the MemoryStream.
            Bitmap1.Save(memStream, System.Drawing.Imaging.ImageFormat.Jpeg);

            // Create the byte array.
            bytes = new byte[memStream.Length];

            // Rewind.
            memStream.Seek(0, SeekOrigin.Begin);

            // Read the MemoryStream to get the bitmap's bytes.
            memStream.Read(bytes, 0, bytes.Length);

            // Return the byte array.
            return bytes;
        }

        finally
        {
            // Cleanup.
            memStream.Close();
            memStream.Dispose();
        }
    }
    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("\"{0}\":\"{1}\"", fieldname, fieldvalue));
            }
            sb.Append(sb2.ToString());
            sb.Append("}");
        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();
    }
}