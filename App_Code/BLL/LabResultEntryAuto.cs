using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using Newtonsoft.Json;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for LabResultEntryAuto
/// </summary>
public class LabResultEntryAuto
{
	public LabResultEntryAuto()
	{
		//
		// TODO: Add constructor logic here
		//
	}
    
    public  DataTable LabObservationSearch(string LabNo, string TestID, float AgeInDays, string RangeType, string Gender, string MachineID, string macId,string centreid)
    {
        StringBuilder sbObs = new StringBuilder();

        sbObs.Append(" SELECT ");
        sbObs.Append(" '" + LabNo + "' LabNo,'" + AgeInDays + "' AgeInDays,pli.IsPackage,pli.BarcodeNo,pli.ItemName TestName ,om.Print_Sequence Dept_Sequence,om.name Dept, ");
        sbObs.Append(" im.PrintSeparate INV_PrintSeparate,lom.PrintSeparate OBS_PrintSeparate,'' Description,pli.IsSampleCollected,'' AS LabInvestigation_ID,pli.Investigation_ID,pli.test_id PLIID, pli.Test_ID,pli.Result_Flag,pli.Approved,pli.isHold,'' `Flag`, (CASE WHEN loi.Child_Flag='1' THEN 'HEAD'  Else ifnull(mac.MacReading,'') END ) `Value`,  mac.MacReading,mac.MachineID,mac.machinename,mac.MachineID1,mac.MachineID2,mac.MachineID3, IFNULL(CONCAT(DATE(mac.dtentry),' ',TIME(mac.dtentry)),'0001-01-01 00:00:00')  dtMacEntry, lom.DefaultValue,'' ID,LOM.LabObservation_ID,mac.Reading1,mac.Reading2,mac.Reading3, (CONCAT(loi.prefix,'',LOM.Name)) AS `LabObservationName`, IFNULL(lr.MinReading,lr2.MinReading) `MinValue`,  IFNULL(lr.MaxReading,lr2.MaxReading) `MaxValue`, ");
        sbObs.Append(" REPLACE(IFNULL(lr.DisplayReading,lr2.DisplayReading),'\n','~')DisplayReading, ");
        sbObs.Append("   IFNULL(lr.DefaultReading,lr2.DefaultReading)DefaultReading, ");
        sbObs.Append(" '1' rangetype,   ");
        sbObs.Append(" IFNULL(lr.ReadingFormat,lr2.ReadingFormat) ReadingFormat,        ");
        sbObs.Append(" IFNULL(lr.AbnormalValue,lr2.AbnormalValue)AbnormalValue,       IFNULL(loi.IsBold,0) IsBold,       IFNULL(loi.IsUnderLine,0)IsUnderLine,        ");
        sbObs.Append(" loi.PrintOrder Priorty,Im.ReportType,lom.ParentID,loi.Child_Flag, ifnull(loi.Formula,'')Formula,   ");

        sbObs.Append(" IFNULL(lr.MethodName,lr2.MethodName) `Method`,   ");
        sbObs.Append(" 1 PrintMethod,   im.Print_Sequence,lom.IsMultiChild,     ");
        sbObs.Append(" loi.IsCritical,IFNULL(lr.MinCritical,lr2.MinCritical)MinCritical,IFNULL(lr.MaxCritical,lr2.MaxCritical )MaxCritical  ,'' Help,   ");
        sbObs.Append(" im.IsMic,lom.IsComment,lom.ResultRequired   , pli.isPartial_Result,lom.DLCCheck,loi.isamr isAmr,loi.isreflex Isreflex,loi.helpvalueonly,IFNULL(lr.AMRMin,lr2.AMRMin) AmrMin,IFNULL(lr.AMRMax,lr2.AMRMax) AmrMax,ifnull(lr.AutoApprovedMin,lr2.AutoApprovedMin) AutoMin,IFNULL(lr.AutoApprovedMax,lr2.AutoApprovedMax) AutoMax,IFNULL(lr.reflexmin,lr2.reflexmin) ReflexMin,IFNULL(lr.reflexmax,lr2.reflexmax) ReflexMax,'' Status  ");
      
        sbObs.Append(" ,0 micro, om.Name DeptName,if(pli.isrerun=0,im.Name,concat(im.name,'(RERUN)')) as InvName ");
        sbObs.Append(" ,(SELECT COUNT(*) FROM `patient_labinvestigation_opd_remarks` WHERE Test_ID= pli.Test_ID and IsActive='1') Remarks,0 Inv ");
        sbObs.Append(" FROM (select * from patient_labinvestigation_opd where LedgerTransactionNo='" + LabNo + "' ");  // AND IsSampleCollected='Y'
        if (TestID != "")
        {
            sbObs.Append(" AND Test_ID in ('" + TestID.Replace(",", "','") + "') ");
        }
        sbObs.Append(" ) pli ");
        sbObs.Append(" INNER JOIN investigation_master im  ON pli.Investigation_ID=im.Investigation_Id  AND im.ReportType=1 and im.IsMic=0 and im.isCulture=0  ");
        sbObs.Append(" INNER JOIN investigation_observationtype io  ON io.Investigation_ID=im.Investigation_Id  ");
        sbObs.Append(" INNER JOIN observationtype_master om  ON om.ObservationType_ID=io.ObservationType_ID  ");
        sbObs.Append(" INNER JOIN labobservation_investigation loi ON im.Investigation_Id=loi.Investigation_Id    ");
        sbObs.Append(" INNER JOIN  labobservation_master lom ON loi.labObservation_ID=lom.LabObservation_ID and (lom.Gender= left('" + Gender + "',1) or lom.Gender='B') ");

       

        sbObs.Append(" LEFT OUTER JOIN   ");
        sbObs.Append(" ( SELECT LabNo,LabObservation_ID,Reading MacReading,Reading1,Reading2,Reading3,if('" + macId + "'<>'','" + macId + "',MachineID)MachineID,machinename,MachineID1,MachineID2,MachineID3,dtEntry,Test_ID FROM  mac_data WHERE LedgerTransactionNo='" + LabNo + "' and Reading<>''   ");
        sbObs.Append("      GROUP BY Test_ID,LabObservation_ID ) mac ON mac.Test_ID=pli.Test_ID  AND mac.LabObservation_ID= lom.LabObservation_ID   AND mac.LabNo = pli.`BarcodeNo`  ");

        sbObs.Append(" LEFT OUTER JOIN labobservation_range lr ON lr.Gender=LEFT('" + Gender + "',1) ");
        sbObs.Append(" AND lr.FromAge<=if(" + AgeInDays + "=0,4381," + AgeInDays + ") AND lr.ToAge>=if(" + AgeInDays + "=0,4381," + AgeInDays + ")   ");
        sbObs.Append(" AND lr.LabObservation_ID=lom.LabObservation_ID AND lr.macID = mac.MachineID and lr.CentreID=" + centreid + "  and lr.rangetype='" + RangeType + "' ");

        sbObs.Append(" LEFT OUTER JOIN labobservation_range lr2 ON lr2.Gender=LEFT('" + Gender + "',1) ");
        sbObs.Append(" AND lr2.FromAge<=if(" + AgeInDays + "=0,4381," + AgeInDays + ") AND lr2.ToAge>=if(" + AgeInDays + "=0,4381," + AgeInDays + ")  ");
      
        sbObs.Append(" AND lr2.LabObservation_ID=lom.LabObservation_ID AND   IFNULL(lr2.macID,'1') = if('" + macId + "'<>'','" + macId + "','1') and lr2.CentreID=1  and lr2.rangetype='" + RangeType + "' ");

        sbObs.Append(" ORDER BY Dept_Sequence,Dept, Print_Sequence,Priorty");
        DataTable dt = StockReports.GetDataTable(sbObs.ToString());
        return dt;

    }



  
    public  string SaveLabObservationOpdData(List<ResultEntryProperty> data, string ResultStatus, string ApprovedBy, string ApprovalName,string centre)
    {

        if (data.Count == 0)
            return "";

        DLC_Check(data, ResultStatus);

        ResultEntryProperty pOpd = new ResultEntryProperty();
        int noOfRowsUpdated = data.Count;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);      
        string deleteTestID = "";
        try
        {
            int i = 0;
            foreach (ResultEntryProperty pdeatil in data)
            {
                string ID = pdeatil.ID;
                string PLId = pdeatil.PLIID;
                string value = pdeatil.Value;
                string rangetype = pdeatil.rangetype;

                int ResultRequiredField = Util.GetInt(pdeatil.ResultRequired);
                string flag = pdeatil.Flag;
                if (flag == "Normal")
                    flag = "";


                if (deleteTestID != pdeatil.Test_ID)
                {

                    if (ResultStatus == "Approved")
                    {

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET AutoApproved=1, Approved = @Approved, ApprovedBy = @ApprovedBy, ApprovedName = @ApprovedName,ApprovedDoneBy=@ApprovedDoneBy,ApprovedDate=@ApprovedDate, ResultEnteredBy=if(Result_Flag=0,'" + ApprovedBy + "',ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,'" + ApprovalName + "',ResultEnteredName),Result_Flag=1 WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                            new MySqlParameter("@Approved", 1), new MySqlParameter("@ApprovedBy", ApprovedBy), new MySqlParameter("@ApprovedName", ApprovalName),
                            new MySqlParameter("@ApprovedDoneBy", ApprovedBy), new MySqlParameter("@ApprovedDate", DateTime.Now),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@isSampleCollected", 'Y'));
                    }
                    MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd WHERE `Test_ID`=@Test_ID",
                        new MySqlParameter("@Test_ID", pdeatil.Test_ID));
                    string audit = savestatus(tnx, pdeatil.BarcodeNo, pdeatil.LabNo, pdeatil.Test_ID, "Report " + ResultStatus + " For :" + pdeatil.TestName, ApprovedBy, ApprovalName, centre);
                    if (audit == "fail")
                    {
                        Exception ex = new Exception("Status Not Saved.Please Contact To Itdose..!");
                        throw (ex);
                    }
                    deleteTestID = pdeatil.Test_ID;
                }

                if (pdeatil.ReportType == "1")
                {
                    Patient_LabObservation_OPD objPLOI = new Patient_LabObservation_OPD(tnx);
                    objPLOI.LabObservation_ID = pdeatil.LabObservation_ID;
                    objPLOI.LabObservationName = pdeatil.LabObservationName;
                    objPLOI.MaxValue = pdeatil.MaxValue;
                    objPLOI.MinValue = pdeatil.MinValue;
                    objPLOI.Test_ID = pdeatil.Test_ID;
                    objPLOI.Value = ((Util.GetInt(pdeatil.IsComment) == 0) ? pdeatil.Value : pdeatil.Description);
                    objPLOI.ResultDateTime = Util.GetDateTime(DateTime.Now);
                    objPLOI.Priorty = i;
                    objPLOI.ReadingFormat = pdeatil.ReadingFormat;
                    objPLOI.DisplayReading = pdeatil.DisplayReading;
                    objPLOI.Description = pdeatil.Description;
                    objPLOI.OrganismID = pdeatil.OrganismID;
                    objPLOI.IsOrganism = Util.GetInt(pdeatil.IsOrganism);
                    objPLOI.ParamEnteredBy = ApprovedBy;
                    objPLOI.ParamEnteredByName = Util.GetString(ApprovalName);
                    objPLOI.MacReading = pdeatil.MacReading;
                    objPLOI.dtMacEntry = Util.GetDateTime(pdeatil.dtMacEntry);
                    objPLOI.MachineID = Util.GetInt(pdeatil.MachineID);
                    objPLOI.Method = pdeatil.Method;
                    objPLOI.PrintMethod = Util.GetInt(pdeatil.PrintMethod);
                    objPLOI.LedgerTransactionNo = pdeatil.LabNo;
                    objPLOI.IsCommentField = Util.GetInt(pdeatil.IsComment);
                    objPLOI.ResultRequiredField = Util.GetInt(pdeatil.ResultRequiredField);
                    objPLOI.IsCritical = Util.GetInt(pdeatil.IsCritical);
                    objPLOI.MinCritical = Util.GetString(pdeatil.MinCritical);
                    objPLOI.MaxCritical = Util.GetString(pdeatil.MaxCritical);
                    objPLOI.ResultEnteredBy = ApprovedBy;
                    objPLOI.ResultEnteredDate = DateTime.Now;
                    objPLOI.ResultEnteredName = Util.GetString(ApprovalName);
                    objPLOI.AbnormalValue = Util.GetString(pdeatil.AbnormalValue);
                    objPLOI.Flag = Util.GetString(pdeatil.Flag);

                    if (objPLOI.Value == "HEAD" && objPLOI.IsOrganism == 1)
                    {
                        objPLOI.IsBold = 1;
                        objPLOI.IsUnderLine = 1;
                    }
                    else
                    {
                        objPLOI.IsBold = Util.GetInt(pdeatil.IsBold);
                        objPLOI.IsUnderLine = Util.GetInt(pdeatil.IsUnderLine);
                    }

                    objPLOI.IsMic = Util.GetInt(pdeatil.isMic);
                    objPLOI.PrintSeparate = Util.GetInt(pdeatil.PrintSeparate);
                    objPLOI.Insert();
                    i++;

                    if (pdeatil.Investigation_ID == "8")// Glucose PP and Fasting Case 
                    {
                        string isfastingbook = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT  test_id FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNO`='" + pdeatil.LabNo + "' AND Investigation_ID='7'  "));

                        if (isfastingbook != "")
                        {
                            string ss = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT  test_id FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNO`='" + pdeatil.LabNo + "' AND Investigation_ID='7' and result_flag=1 "));
                            if (ss != "")
                            {
                                float fastingvalue = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT VALUE FROM `patient_labobservation_opd` plo INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=plo.`Test_ID` AND pli.`Investigation_ID`=7 AND pli.`LedgerTransactionNo`='" + pdeatil.LabNo + "' LIMIT 1 "));

                                float ppvalue = Util.GetFloat(pdeatil.Value);

                                if (fastingvalue > ppvalue)
                                {
                                    Exception ex = new Exception("Glucose Fasting (" + fastingvalue + ") can't greater then Glucose PP (" + ppvalue + ") ..! ");
                                    throw (ex);
                                }
                            }
                            else
                            {
                                Exception ex = new Exception("Please Enter Glucose Fasting Result First..! ");
                                throw (ex);
                            }
                        }

                    }
                    if (pdeatil.Investigation_ID == "7")// Glucose PP and Fasting Case 
                    {

                        string ss = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT  test_id FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNO`='" + pdeatil.LabNo + "' AND Investigation_ID='8' and result_flag=1 "));
                        if (ss != "")
                        {
                            float ppvalue = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT VALUE FROM `patient_labobservation_opd` plo INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=plo.`Test_ID` AND pli.`Investigation_ID`=8 AND pli.`LedgerTransactionNo`='" + pdeatil.LabNo + "' LIMIT 1 "));

                            float fastingvalue = Util.GetFloat(pdeatil.Value);

                            if (fastingvalue > ppvalue)
                            {
                                Exception ex = new Exception("Glucose Fasting (" + fastingvalue + ") can't greater then Glucose PP (" + ppvalue + ") ..! ");
                                throw (ex);
                            }
                        }


                    }



                }

            }
            // Saving Interpretation
            string oldInterTestID = string.Empty;
            foreach (ResultEntryProperty pdeatil in data)
            {
                if ((pdeatil.Inv == "1") || (pdeatil.Inv == "3"))
                    continue;

                else if (pdeatil.Inv == "2")
                {
                    continue;
                }

                int ObsQty = 0;
                int DoInter = 0;
                int DoInterObs = 0;
                string TypeOfInterpretation = string.Empty;
                DataTable dtTempInter = new DataTable();

                if (oldInterTestID != pdeatil.Test_ID)
                {
                    oldInterTestID = pdeatil.Test_ID;
                }
                else
                {
                    continue;
                }

                string ploDataFlag = Util.GetString(pdeatil.Flag);
                if (ploDataFlag.Trim() == "")
                    ploDataFlag = "Normal";

                ObsQty = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, " SELECT count(*) FROM `labobservation_investigation` WHERE investigation_id=@investigation_id ",
                        new MySqlParameter("@investigation_id", pdeatil.Investigation_ID)));

                dtTempInter = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, " SELECT labObservation_ID,flag,Interpretation,PrintInterTest,PrintInterPackage FROM labobservation_master_interpretation   where labObservation_ID=@labObservation_ID and flag=@flag and centreid=@centreid and macid=@macid ",
                        new MySqlParameter("@labObservation_ID", pdeatil.LabObservation_ID),
                        new MySqlParameter("@flag", ploDataFlag),
                        new MySqlParameter("@centreid", "1"),
                        new MySqlParameter("@macid", "1")).Tables[0];

                if (ObsQty == 1 && dtTempInter.Rows.Count > 0)  // Observation Wise Interpretation 
                {
                    if (pdeatil.IsPackage == "1" && Util.GetString(dtTempInter.Rows[0]["PrintInterPackage"]) == "1")
                    {
                        DoInterObs = 1;
                        TypeOfInterpretation = "ObservationWise";
                    }
                    else if (pdeatil.IsPackage == "0" && Util.GetString(dtTempInter.Rows[0]["PrintInterTest"]) == "1")
                    {
                        DoInterObs = 1;
                        TypeOfInterpretation = "ObservationWise";
                    }

                    if (DoInterObs == 1 && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "" && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br/>" && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br />")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " delete from patient_labinvestigation_opd_interpretation where Test_ID=@Test_ID and TYPE=@TYPE ",
                                    new MySqlParameter("@Test_ID", pdeatil.Test_ID), new MySqlParameter("@TYPE", "ObservationWise"));

                        StringBuilder myStr = new StringBuilder();
                        myStr.Append(" INSERT INTO patient_labinvestigation_opd_interpretation  ");
                        myStr.Append(" (Test_ID,Interpretation,PrintInterTest,PrintInterPackage,TYPE,dtEntry,EnteredByID,EnteredByName) ");
                        myStr.Append(" VALUES(@Test_ID,@Interpretation,@PrintInterTest,@PrintInterPackage,@TYPE,@dtEntry,@EnteredByID,@EnteredByName) ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, myStr.ToString(),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@Interpretation", dtTempInter.Rows[0]["Interpretation"].ToString()),
                            new MySqlParameter("@PrintInterTest", Util.GetString(dtTempInter.Rows[0]["PrintInterTest"])),
                            new MySqlParameter("@PrintInterPackage", Util.GetString(dtTempInter.Rows[0]["PrintInterPackage"])),
                            new MySqlParameter("@TYPE", TypeOfInterpretation),
                            new MySqlParameter("@dtEntry", DateTime.Now),
                            new MySqlParameter("@EnteredByID", ApprovedBy),
                            new MySqlParameter("@EnteredByName", Util.GetString(ApprovalName)));
                    }
                }
                // Investigation Wise Interpretation 

                dtTempInter = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, " SELECT Investigation_Id,Interpretation,PrintInterTest,PrintInterPackage FROM investigation_master_interpretation where Investigation_Id=@Investigation_Id and centreid=@centreid and macid=@macid ",
                    new MySqlParameter("@Investigation_Id", pdeatil.Investigation_ID),
                    new MySqlParameter("@centreid", "1"),
                    new MySqlParameter("@macid", "1")).Tables[0];

                if (dtTempInter.Rows.Count > 0)
                {

                    if (pdeatil.IsPackage == "1" && Util.GetString(dtTempInter.Rows[0]["PrintInterPackage"]) == "1")
                    {
                        DoInter = 1;
                        TypeOfInterpretation = "InvestigationWise";
                    }
                    else if (pdeatil.IsPackage == "0" && Util.GetString(dtTempInter.Rows[0]["PrintInterTest"]) == "1")
                    {
                        DoInter = 1;
                        TypeOfInterpretation = "InvestigationWise";
                    }
                    if (DoInter == 1 && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "" && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br/>" && Util.GetString(dtTempInter.Rows[0]["Interpretation"]).Trim() != "<br />")
                    {
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " delete from patient_labinvestigation_opd_interpretation where Test_ID=@Test_ID and TYPE=@TYPE ",
                               new MySqlParameter("@Test_ID", pdeatil.Test_ID), new MySqlParameter("@TYPE", "InvestigationWise"));

                        StringBuilder myStr = new StringBuilder();
                        myStr.Append(" INSERT INTO patient_labinvestigation_opd_interpretation  ");
                        myStr.Append(" (Test_ID,Interpretation,PrintInterTest,PrintInterPackage,TYPE,dtEntry,EnteredByID,EnteredByName) ");
                        myStr.Append(" VALUES(@Test_ID,@Interpretation,@PrintInterTest,@PrintInterPackage,@TYPE,@dtEntry,@EnteredByID,@EnteredByName) ");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, myStr.ToString(),
                            new MySqlParameter("@Test_ID", pdeatil.Test_ID),
                            new MySqlParameter("@Interpretation", dtTempInter.Rows[0]["Interpretation"].ToString()),
                            new MySqlParameter("@PrintInterTest", Util.GetString(dtTempInter.Rows[0]["PrintInterTest"])),
                            new MySqlParameter("@PrintInterPackage", Util.GetString(dtTempInter.Rows[0]["PrintInterPackage"])),
                            new MySqlParameter("@TYPE", TypeOfInterpretation),
                            new MySqlParameter("@dtEntry", DateTime.Now),
                            new MySqlParameter("@EnteredByID", ApprovedBy),
                            new MySqlParameter("@EnteredByName", Util.GetString(ApprovalName)));
                    }
                }
            }
            //
            tnx.Commit();
            
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            throw (ex);

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return "success";
    }


     string savestatus(MySqlTransaction tnx, string barcodeno, string LedgerTransactionNo, string ID, string status,string userid,string username,string centre)
    {
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                      new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                      new MySqlParameter("@SinNo", barcodeno), new MySqlParameter("@Test_ID", ID),
                      new MySqlParameter("@Status", status), new MySqlParameter("@UserID", userid), new MySqlParameter("@UserName", username),
                      new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", centre), new MySqlParameter("@RoleID", "177"), new MySqlParameter("@DispatchCode", ""));
            return "success";
        }
        catch
        {
            return "fail";
        }
    }

    private  void DLC_Check(List<ResultEntryProperty> data, string ResultStatus)
    {
        float DLC = 0f;
        float Semen = 0f;
        string test = "";
        string test1 = "";
        int atfile = 0;
        foreach (ResultEntryProperty pdeatil in data)
        {
            if (pdeatil.DLCCheck == "1")
            {
                DLC = DLC + Util.GetFloat(pdeatil.Value);
                test = test + ", " + pdeatil.LabObservationName;
            }
            if (pdeatil.LabObservation_ID == "1006" || pdeatil.LabObservation_ID == "1007")// semen report
            {
                Semen = Semen + Util.GetFloat(pdeatil.Value);
                test1 = test1 + ", " + pdeatil.LabObservationName;
            }
            if (pdeatil.LabObservationName == "Attached Report")
            {
                atfile = 1;
            }
            if ((pdeatil.ResultRequired == "1") && (pdeatil.Value == "") && (ResultStatus == "Approved") && (pdeatil.Method != "1") && (atfile == 0))
                throw (new Exception("All parameter needs to be filled before approval."));



        }
        test = test.Trim(',');
        test1 = test1.Trim(',');
        //if (Util.GetFloat(data[0].AgeInDays) > 4745)
        //{
        if ((DLC > 0) && (DLC != 100))
            throw (new Exception("Total " + test + " should be equal to 100."));

        if ((Semen > 0) && (Semen != 100))
            throw (new Exception("Total " + test1 + " should be equal to 100."));
        //}
    }
    public string SaveLabObservationOpdDataApproved(string Test_ID, string ResultStatus, string ApprovedBy, string ApprovalName, string centre)
    {
        string outputStatus = string.Empty;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (isNormalResult(Test_ID, tnx))
            {
                if (ResultStatus == "Approved")
                {
                    DataTable dtTemp = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "select BarcodeNo,LedgerTransactionNo,InvestigationName TestName,Investigation_ID from patient_labinvestigation_opd where Test_ID=@Test_ID",
                    new MySqlParameter("@Test_ID", Test_ID.Trim())).Tables[0];
                    if (dtTemp.Rows.Count > 0)
                    {
                        if (Util.GetString(dtTemp.Rows[0]["Investigation_ID"]) == "8")// Glucose PP and Fasting Case 
                        {
                            string isfastingbook = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT  test_id FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNO`='" + Util.GetString(dtTemp.Rows[0]["LedgerTransactionNo"]) + "' AND Investigation_ID='7'  "));

                            if (isfastingbook != "")
                            {
                                string ss = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT  test_id FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNO`='" + Util.GetString(dtTemp.Rows[0]["LedgerTransactionNo"]) + "' AND Investigation_ID='7' and result_flag=1 "));
                                if (ss != "")
                                {
                                    float fastingvalue = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT VALUE FROM `patient_labobservation_opd` plo INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=plo.`Test_ID` AND pli.`Investigation_ID`=7 AND pli.`LedgerTransactionNo`='" + Util.GetString(dtTemp.Rows[0]["LedgerTransactionNo"]) + "' LIMIT 1 "));

                                    float ppvalue = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT VALUE FROM `patient_labobservation_opd` plo INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=plo.`Test_ID` AND pli.`Investigation_ID`=8 AND pli.`LedgerTransactionNo`='" + Util.GetString(dtTemp.Rows[0]["LedgerTransactionNo"]) + "' LIMIT 1 "));
                                    if (fastingvalue == 0 || ppvalue == 0)
                                    {
                                        Exception ex = new Exception("Glucose PP and Fasting value can't be 0..!");
                                        throw (ex);
                                    }
                                    if (fastingvalue > ppvalue)
                                    {
                                        Exception ex = new Exception("Glucose Fasting (" + fastingvalue + ") can't greater then Glucose PP (" + ppvalue + ") ..! ");
                                        throw (ex);
                                    }
                                }
                                else
                                {
                                    Exception ex = new Exception("Please Enter Glucose Fasting Result First..! ");
                                    throw (ex);
                                }
                            }

                        }
                        if (Util.GetString(dtTemp.Rows[0]["Investigation_ID"]) == "7")// Glucose PP and Fasting Case 
                        {

                            string ss = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT  test_id FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNO`='" + Util.GetString(dtTemp.Rows[0]["LedgerTransactionNo"]) + "' AND Investigation_ID='8' and result_flag=1 "));
                            if (ss != "")
                            {
                                float ppvalue = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT VALUE FROM `patient_labobservation_opd` plo INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=plo.`Test_ID` AND pli.`Investigation_ID`=8 AND pli.`LedgerTransactionNo`='" + Util.GetString(dtTemp.Rows[0]["LedgerTransactionNo"]) + "' LIMIT 1 "));

                                float fastingvalue = Util.GetFloat(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT VALUE FROM `patient_labobservation_opd` plo INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=plo.`Test_ID` AND pli.`Investigation_ID`=7 AND pli.`LedgerTransactionNo`='" + Util.GetString(dtTemp.Rows[0]["LedgerTransactionNo"]) + "' LIMIT 1 "));
                                if (fastingvalue == 0 || ppvalue == 0)
                                {
                                    Exception ex = new Exception("Glucose PP and Fasting value can't be 0..!");
                                    throw (ex);
                                }
                                if (fastingvalue > ppvalue)
                                {
                                    Exception ex = new Exception("Glucose Fasting (" + fastingvalue + ") can't greater then Glucose PP (" + ppvalue + ") ..! ");
                                    throw (ex);
                                }
                            }
                        }

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET AutoApproved=1, Approved = @Approved, ApprovedBy = @ApprovedBy, ApprovedName = @ApprovedName,ApprovedDoneBy=@ApprovedDoneBy,ApprovedDate=@ApprovedDate WHERE Test_ID=@Test_ID ",
                                new MySqlParameter("@Approved", 1), new MySqlParameter("@ApprovedBy", ApprovedBy), new MySqlParameter("@ApprovedName", ApprovalName),
                                new MySqlParameter("@ApprovedDoneBy", ApprovedBy), new MySqlParameter("@ApprovedDate", DateTime.Now),
                                new MySqlParameter("@Test_ID", Test_ID.Trim()));

                        string audit = savestatus(tnx, Util.GetString(dtTemp.Rows[0]["BarcodeNo"]), Util.GetString(dtTemp.Rows[0]["LedgerTransactionNo"]), Test_ID.Trim(), "Report " + ResultStatus + " For :" + Util.GetString(dtTemp.Rows[0]["TestName"]), ApprovedBy, ApprovalName, centre);
                        if (audit == "fail")
                        {
                            Exception ex = new Exception("Status Not Saved.Please Contact To Itdose..!");
                            throw (ex);
                        }
                    }
                }
                outputStatus = "success";
            }
            else
            {
                outputStatus = "failed";
            }

            tnx.Commit();
           

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            // throw (ex);
            outputStatus = "failed";

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
        return outputStatus;
    }
    public bool isNormalResult(string Test_ID, MySqlTransaction tnxIsNormalResult)
    {
        Boolean retValue = false;
        DataTable data = new DataTable();

        try
        {
            StringBuilder sbPLO = new StringBuilder();
            sbPLO.Append(" SELECT plo.`LedgerTransactionNo` LabNo,pli.ReportType,pli.BarcodeNo,pli.InvestigationName TestName,plo.`ID`,plo.`LabObservation_ID`,plo.`Test_ID`,plo.`ResultDateTime`,plo.`Value`,plo.`Description`,plo.`MinValue`,plo.`MaxValue`,  ");
            sbPLO.Append(" plo.`LabObservationName`,plo.`Priorty`,plo.`InvPriorty`,plo.`ReadingFormat`,plo.`DisplayReading`,plo.`OrganismID`,plo.`IsOrganism`,  ");
            sbPLO.Append(" plo.`ParamEnteredBy`,plo.`ParamEnteredByName`,plo.`MacReading`,plo.`dtMacEntry`,plo.`MachineID`,plo.`MachineName`,plo.`Method`,  ");
            sbPLO.Append(" plo.`PrintMethod`,plo.`LedgerTransactionNo`,plo.`IsCommentField`,plo.`ResultRequiredField`,plo.`IsCritical`,plo.`MinCritical`,  ");
            sbPLO.Append(" plo.`MaxCritical`,plo.`Approved`,plo.`ApprovedBy`,plo.`ApprovedDate`,plo.`ApprovedName`,plo.`ResultEnteredBy`,plo.`ResultEnteredDate`,  ");
            sbPLO.Append("  plo.`ResultEnteredName`,plo.`AbnormalValue`,plo.`IsBold`,plo.`IsUnderLine`,plo.`isMic`,plo.`PrintSeparate`,plo.`UpdateID`,plo.`UpdateName`, ");
            sbPLO.Append(" plo.`Updatedate`,plo.`Flag`,plo.`isrerun`,plo.`abnormalimage`,plo.`SepratePrint`,plo.`isautoconsume`,plo.`Rerun`,plo.`ShowDeltaReport`  ");
            sbPLO.Append(" FROM `patient_labobservation_opd` plo ");
            sbPLO.Append(" INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Test_ID`=plo.`Test_ID` ");
            sbPLO.Append(" where pli.Test_ID=@Test_ID");
            data = MySqlHelper.ExecuteDataset(tnxIsNormalResult, CommandType.Text, sbPLO.ToString(),
                new MySqlParameter("@Test_ID", Test_ID.Trim())).Tables[0];

            foreach (DataRow drTempPLO in data.Rows)
            {
                ResultEntryProperty pdeatil = new ResultEntryProperty();
                pdeatil.LabNo = Util.GetString(drTempPLO["LabNo"]);
                pdeatil.Test_ID = Util.GetString(drTempPLO["Test_ID"]);
                pdeatil.LabObservation_ID = Util.GetString(drTempPLO["LabObservation_ID"]);
                pdeatil.LabObservationName = Util.GetString(drTempPLO["LabObservationName"]);
                pdeatil.Value = Util.GetString(drTempPLO["Value"]);
                pdeatil.MinValue = Util.GetString(drTempPLO["MinValue"]);
                pdeatil.MaxValue = Util.GetString(drTempPLO["MaxValue"]);
                pdeatil.MinCritical = Util.GetString(drTempPLO["MinCritical"]);
                pdeatil.MaxCritical = Util.GetString(drTempPLO["MaxCritical"]);
                pdeatil.AbnormalValue = Util.GetString(drTempPLO["AbnormalValue"]);
                pdeatil.Flag = Util.GetString(drTempPLO["Flag"]);
                pdeatil.IsCritical = Util.GetString(drTempPLO["IsCritical"]);
                pdeatil.ReportType = Util.GetString(drTempPLO["ReportType"]);
                pdeatil.BarcodeNo = Util.GetString(drTempPLO["BarcodeNo"]);
                pdeatil.TestName = Util.GetString(drTempPLO["TestName"]);

                if (pdeatil.Value != "" && pdeatil.Value == "HEAD")
                    continue;

                if (pdeatil.Value == "" || pdeatil.MinValue == "" || pdeatil.MaxValue == "")
                {
                    retValue = false;
                    break;
                }

                float re = 0;
                if (float.TryParse(pdeatil.Value, out re))
                {
                    if (Util.GetFloat(pdeatil.Value) >= Util.GetFloat(pdeatil.MinValue) && Util.GetFloat(pdeatil.Value) <= Util.GetFloat(pdeatil.MaxValue))
                    {
                        retValue = true;
                    }
                    else
                    {
                        retValue = false;
                        break;
                    }
                }
                else if (pdeatil.Value.Trim() != "")
                {
                    retValue = false;
                    break;
                }
                else
                {
                    retValue = false;
                    break;
                }
            }
        }
        catch
        {
            retValue = false;
        }
        return retValue;
    }
}