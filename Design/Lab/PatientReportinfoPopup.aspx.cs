using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using MySql.Data.MySqlClient;
using System.Linq;
using System.Web;
using DevExpress.Web.ASPxRichEdit;
using DevExpress.Web.Office;
using System.Web.Services;
public partial class Design_OPD_PatientSampleinfoPopup : System.Web.UI.Page
{
    public string LedgerTransactionNo;
    public  string TestID;
    string Description = "";
    string DeptID;
    public string IsApproved = "";
    public string DocumentId { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
       
        LedgerTransactionNo = Request.QueryString["LabNo"].ToString();
        TestID = Request.QueryString["TestID"].ToString().Replace(",", "','");
        DeptID = Request.QueryString["SubCategoryID"].ToString();

        btnSave.Enabled = true;
        if (!IsPostBack)
        {
            DataTable dtdetails = StockReports.GetDataTable("SELECT Approved,isReportOpen,Date_Format(ReportOpenDateTime,'%d-%b-%y %I:%i%p')ReportOpenDateTime,ReportOpenBy FROM Patient_LabInvestigation_OPD WHERE Test_Id = '" + TestID + "'");
            IsApproved = Util.GetString(dtdetails.Rows[0]["Approved"]);
            BindDoctor();
            BindPanelinfo();
            if (Util.GetString(dtdetails.Rows[0]["isReportOpen"]) == "0")//|| Util.GetDateTime(dtdetails.Rows[0]["ReportOpenDateTime"]).AddMinutes(10) <= DateTime.Now
            {
                if (IsApproved == "1")
                {
                    ASPxRichEdit1.ReadOnly = true;
                    lblerrmsg.Text = "Report Approved (Editor Disabled)";
                    btnSave.Enabled = false;
                }
                else
                {
                    ASPxRichEdit1.ReadOnly = false;
                    lblerrmsg.Text = "";

                }
                List<ASPxRichEditAutoCorrectReplaceInfo> Autocollection = new List<ASPxRichEditAutoCorrectReplaceInfo>();
                DataTable dt = StockReports.GetDataTable(" Select AutoKey,AutoDescription from autocorrect_detail where SubCategoryID='" + DeptID + "' and isactive=1 ");
                if (dt.Rows.Count > 0)
                {
                    foreach (DataRow item in dt.Rows)
                    {
                        ASPxRichEditAutoCorrectReplaceInfo aa = new ASPxRichEditAutoCorrectReplaceInfo();
                        aa.What = Util.GetString(item["AutoKey"]);
                        aa.With = Util.GetString(item["AutoDescription"]);
                        Autocollection.Add(aa);

                    }
                    ASPxRichEdit1.Settings.AutoCorrect.ReplaceInfoCollectionSettings.AutoCorrectReplaceInfoCollection.AddRange(Autocollection);
                }
                txtnotappremarks.Text = "";


                BindAllTemplate();
                BindTemplate();
                LoadReport();
                BindApprovedBy(DeptID);

               StockReports.ExecuteDML("UPDATE patient_labinvestigation_opd SET isReportOpen = 1, ReportOpenDateTime = now(), ReportOpenBy = '" + UserInfo.LoginName + "("+StockReports.getip()+")' WHERE Test_ID= '" + TestID + "'");
            }
            else
            {
                ASPxRichEdit1.ReadOnly = true;
                lblerrmsg.Text = "Report Already Open By " + Util.GetString(dtdetails.Rows[0]["ReportOpenBy"]) + " at " + Util.GetString(dtdetails.Rows[0]["ReportOpenDateTime"]);
                btnSave.Enabled = false;
            }
        }
        Response.AppendHeader("Cache-Control", "no-store");
    }
    private void LoadReport()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string str = "SELECT `LabInves_Description`,Test_id FROM patient_labobservation_opd_text WHERE test_id=@LabObservation_ID ";
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str,
            new MySqlParameter("@LabObservation_ID", TestID)).Tables[0])
        {

            if (dt != null && dt.Rows.Count > 0)
            {
                byte[] ss = Encoding.UTF8.GetBytes(dt.Rows[0]["LabInves_Description"].ToString());

                if (DocumentManager.FindDocument(TestID) != null)
                {
                    DocumentManager.CloseDocument(TestID);
                }
                ASPxRichEdit1.Open(TestID, DevExpress.XtraRichEdit.DocumentFormat.Html, () => { return ss; });
              //  ASPxRichEdit1.Open(dt.Rows[0]["Test_id"].ToString(), DevExpress.XtraRichEdit.DocumentFormat.Html, () => { return ss; });
            }

        }

    }
    private void BindApprovedBy(string SubCategoryID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        using (DataTable dtApproval = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT DISTINCT em.Name, fa.EmployeeID FROM f_approval_labemployee fa INNER JOIN employee_master em ON em.Employee_ID=fa.EmployeeID   " +
   " AND IF(fa.`TechnicalId`='',fa.`EmployeeID`,fa.`TechnicalId`)=@EmployeeID AND fa.`RoleID`=@RoleID WHERE fa.Approval IN (1,3,4)  " +
   " ORDER BY fa.isDefault DESC,em.Name ",
    new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@EmployeeID", UserInfo.ID)).Tables[0])
        {
            ddlApprove.DataSource = dtApproval;
            ddlApprove.DataTextField = "Name";
            ddlApprove.DataValueField = "EmployeeID";
            ddlApprove.DataBind();
            if (dtApproval.Rows.Count == 1)
            {
                ddlApprove.Enabled = false;
            }
            else
            {
                ddlApprove.Enabled = true;
            }
        }

    }


    private void BindDoctor()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string str = "SELECT Employee_ID,NAME EmpName FROM employee_master emp INNER JOIN f_approval_labemployee eml ON emp.Employee_ID=eml.EmployeeID WHERE eml.Approval IN (1,3,4) GROUP BY emp.Employee_ID ";
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str).Tables[0])
        {
            if (dt.Rows.Count > 0)
            {
                ddlDoctor.DataSource = dt;
                ddlDoctor.DataTextField = "EmpName";
                ddlDoctor.DataValueField = "Employee_ID";
                ddlDoctor.DataBind();
                ddlDoctor.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", "0"));
            }

        }

    }
    private void BindAllTemplate()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string str = "SELECT inv.Template_ID,inv.Temp_Head FROM investigation_template inv INNER JOIN f_itemmaster itm ON inv.investigation_id = itm.Type_id WHERE itm.SubCategoryid=@SubCategoryid ";
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str,
            new MySqlParameter("@SubCategoryid", DeptID)).Tables[0])
        {
            if (dt.Rows.Count > 0)
            {
                dllAllTemplate.DataSource = dt;
                dllAllTemplate.DataTextField = "Temp_Head";
                dllAllTemplate.DataValueField = "Template_ID";
                dllAllTemplate.DataBind();
                dllAllTemplate.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", "0"));
            }

        }

    }
 
    private void BindTemplate()
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string str = "SELECT it.`Template_ID`,it.`Temp_Head` FROM `investigation_template` it INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Investigation_ID`= it.`Investigation_ID` " +
              " WHERE pli.`Test_ID`=@LabObservation_ID ";
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str,
            new MySqlParameter("@LabObservation_ID", TestID)).Tables[0])
        {
            if (dt.Rows.Count > 0)
            {
                ddlTemplate.DataSource = dt;
                ddlTemplate.DataTextField = "Temp_Head";
                ddlTemplate.DataValueField = "Template_ID";
                ddlTemplate.DataBind();
                ddlTemplate.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Select", "0")); 
            }

        }

    }
    private void BindPanelinfo()
    {
        List<string> Test_ID = TestID.TrimEnd(',').Split(',').ToList<string>();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("    SELECT date_format(pm.DOB,'%d-%b-%Y') DOB,date_format(lt.Date,'%d-%b-%Y') RegDate,plo.LedgerTransactionNo, IFNULL((SELECT ID FROM document_detail dd WHERE dd.`labNo`=lt.`LedgerTransactionNo` And IsActive=1 LIMIT 1 ),'')DocumentStatus,0 LmpWeek , ");
            sb.Append("    plo.BarcodeNo,lt.CreatedBy as WorkOrderBy,'' Comments,plo.isHold,if(plo.isHold=1,plo.holdByName,'')holdByName,plo.IsCritical,plo.IsCriticalFollow,");
            sb.Append("   if(plo.isHold=1,plo.Hold_Reason,'')Hold_Reason,DATE_FORMAT(plo.SampleCollectionDate,'%d-%b-%y %I:%i%p') SegratedDate,plo.SampleCollector,");
            sb.Append("   CONCAT(if(lt.`DoctorName`<>'SELF',CONCAT('Dr.',lt.`DoctorName`),''),',',if(lt.`SecondReference`<>'SELF',CONCAT('Dr.',lt.`SecondReference`),''),',',if(''<>'SELF',CONCAT('Dr.',''),'')) AS ReferDoctor ,");
            sb.Append("   lt.panelname Panel_Code, plo.Approved,  plo.ApprovedBy, plo.ApprovedName, ");
            sb.Append("   Date_Format(plo.ApprovedDate,'%d-%b-%y %I:%i%p')ApprovedDate, if(plo.IsSampleCollected='R',psr.RejectionReason,'')RejectionReason,");
            sb.Append("  plo.ResultEnteredName,DATE_FORMAT(plo.ResultEnteredDate,'%d-%b-%y %I:%i%p')ResultEnteredDate,(select Name from employee_master where Employee_ID=plo.ApprovedDoneBy)ApprovedDoneBy,  ");
            sb.Append("    plo.SampleTypeName SampleType,CONCAT(pm.Title,' ',pm.PName) PName, pm.Gender,CONCAT(pm.Age,'/',LEFT(pm.Gender,1)) Age,PM.Mobile Mobile,otm.Name DepartmentName, if(plo.IsSampleCollected='R',psr.RejectionReason,'')RejectionReason, plo.SampleCollector, DATE_FORMAT(plo.SampleCollectionDate, '%d-%b-%y %I:%i%p') SegratedDate,  ");
            sb.Append("    if(plo.IsSampleCollected='R',DATE_FORMAT(psr.entdate,'%d-%b-%y %I:%i%p'),'') RejectDate,  ");
            sb.Append("    DATE_FORMAT(plo.SampleReceiveDate,'%d-%b-%y %I:%i%p')SampleReceiveDate ,SampleReceiver SampleReceivedBy, ");

            sb.Append("  if(plo.IsSampleCollected='R',(SELECT NAME FROM employee_master WHERE Employee_ID=psr.UserID),'') RejectUser , im.name,'' HomeCollectionDate, ");
            sb.Append(" IF(plo.Subcategoryid=9 OR plo.Subcategoryid=10,Concat(plo.itemName,' ',IFNULL((SELECT Concat(',',ItemName) FROM patient_labinvestigation_opd plor WHERE plor.LedgerTransactionID =plo.LedgerTransactionID And ItemId IN(946,2184) LIMIT 1 ),'')),plo.itemName)itemName ");
            sb.Append("    ,IFNULL(plo.HistoCytoPerformingDoctor,0)HistoCytoPerformingDoctor FROM   ");
            sb.Append("    (SELECT * FROM patient_labinvestigation_opd WHERE LedgerTransactionNo=@LedgerTransactionNo AND Test_ID IN ({0}) ) plo  ");


            sb.Append("    INNER JOIN f_ledgertransaction lt on lt.LedgerTransactionNo=plo.LedgerTransactionNo  ");
            sb.Append("    INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID  ");
            sb.Append("    INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = plo.Investigation_ID  ");
            sb.Append("    INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id   ");
            sb.Append("    INNER JOIN investigation_master im ON im.Investigation_Id=iom.Investigation_ID");
            sb.Append("    LEFT JOIN (SELECT * FROM patient_sample_rejection psr WHERE psr.Test_ID IN ({0}) ORDER BY EntDate DESC LIMIT 1 ) psr ON psr.Test_ID=plo.test_ID  ");
            sb.Append("    GROUP BY plo.Investigation_Id  ");




            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", Test_ID)), con))
                {
                    da.SelectCommand.Parameters.AddWithValue("@LedgerTransactionNo", LedgerTransactionNo);
                    for (int i = 0; i < Test_ID.Count; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                    }
                    da.Fill(dt);
                    sb = new StringBuilder();
                    Test_ID.Clear();
                }





                if (dt.Rows.Count > 0)
                {

                   

                    lblLabNo.Text = dt.Rows[0]["LedgerTransactionNo"].ToString();

                    lblPatientName.Text = dt.Rows[0]["PName"].ToString();
                    lblSampleType.Text = dt.Rows[0]["Panel_Code"].ToString();
                    lblSinNo.Text = dt.Rows[0]["BarcodeNo"].ToString();
                    lblAge.Text = dt.Rows[0]["Age"].ToString().Replace("YRS", "Yrs");
                    lblDate.Text = dt.Rows[0]["RegDate"].ToString();
                  //  lblLmpDate.Text = dt.Rows[0]["LmpDate"].ToString();
                 //   lblLmpWeek.Text = dt.Rows[0]["LmpWeek"].ToString();
                    lblTestName.Text = dt.Rows[0]["itemName"].ToString();
                    lblReferDotor.Text = dt.Rows[0]["ReferDoctor"].ToString();
                    if (dt.Rows[0]["itemName"].ToString().Contains("CONSUMABLES CHARGES"))
                    {
                        hdnisContrast.Value = "1";
                    }
                    else
                    {
                        hdnisContrast.Value = "0";
                    }
                    chkIsCritical.Checked = Util.GetInt(dt.Rows[0]["IsCritical"]) == 1 ? true : false;
                    chkIsCriticalFollow.Checked = Util.GetInt(dt.Rows[0]["IsCriticalFollow"]) == 1 ? true : false;
                    ddlDoctor.SelectedValue = dt.Rows[0]["HistoCytoPerformingDoctor"].ToString();
                }
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
    protected void ASPxRichEdit1_Saving(object source, DevExpress.Web.Office.DocumentSavingEventArgs e)
    {
        e.Handled = true;
        string header = GetHtml();
        int IsCritical = (chkIsCritical.Checked == true) ? 1 : 0;
        int IsCriticalFollow = (chkIsCriticalFollow.Checked == true) ? 1 : 0;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (header == string.Empty)
            {
                Exception ex = new Exception(" value can't be blank.....!");
                throw (ex);
            }
            MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd_text WHERE `Test_ID`=@Test_ID",
                         new MySqlParameter("@Test_ID", TestID));
            StringBuilder myStr = new StringBuilder();
            myStr.Append("INSERT INTO `patient_labobservation_opd_text`(`PLO_ID`,`Test_ID`,`LabInves_Description`,`EntDate`,UserID) ");
            myStr.Append(" VALUES(@PLO_ID,@Test_ID,@LabInves_Description,@EntDate,@UserID)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, myStr.ToString(),
                new MySqlParameter("@PLO_ID", TestID),
                new MySqlParameter("@Test_ID", TestID),
                new MySqlParameter("@LabInves_Description", header),
                new MySqlParameter("@EntDate", DateTime.Now),
                new MySqlParameter("@UserID", UserInfo.ID));

        //    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsCritical = @IsCritical,IsCriticalFollow=@IsCriticalFollow WHERE Test_ID=@Test_ID ",
          //                 new MySqlParameter("@IsCritical", IsCritical),
            //                new MySqlParameter("@IsCriticalFollow", IsCriticalFollow),
              //             new MySqlParameter("@Test_ID", TestID));

           // string str = "update patient_labinvestigation_opd set  ResultEnteredBy=if(Result_Flag=0,@UserID,ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,@LoginName,ResultEnteredName),Result_Flag=1 ";
         //   str += " where test_id=@test_id  and isSampleCollected='Y' and approved=0 ";
         //   MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str,
           //    new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@LoginName", Util.GetString(HttpContext.Current.Session["LoginName"])),
           //    new MySqlParameter("@test_id", TestID));


            tnx.Commit();

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();

        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    protected void ddlTemplate_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (dllAllTemplate.Items.Count > 0)
        {
            dllAllTemplate.SelectedIndex = 0;
        }
        
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string str = "SELECT it.Template_Desc,it.Template_ID FROM `investigation_template` it INNER JOIN `patient_labinvestigation_opd` pli ON pli.`Investigation_ID`= it.`Investigation_ID` " +
              " WHERE pli.`Test_ID`=@LabObservation_ID  And it.Template_ID=@Template_ID";
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str,
            new MySqlParameter("@LabObservation_ID", TestID), new MySqlParameter("@Template_ID", ddlTemplate.SelectedValue)).Tables[0])
        {
            if (dt.Rows.Count > 0)
            {
                byte[] ss = Encoding.UTF8.GetBytes(dt.Rows[0]["Template_Desc"].ToString());

                if (dt != null && dt.Rows.Count > 0)
                {
                    if (DocumentManager.FindDocument(dt.Rows[0]["Template_ID"].ToString()) != null)
                    {
                        DocumentManager.CloseDocument(dt.Rows[0]["Template_ID"].ToString());
                    }
                    ASPxRichEdit1.Open(dt.Rows[0]["Template_ID"].ToString(), DevExpress.XtraRichEdit.DocumentFormat.Html, () => { return ss; });
                }
            }
            else
            {
                string str1 = "SELECT LabInves_Description from patient_labobservation_opd_text WHERE `Test_ID`=@Test_ID";
                using (DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, str1, new MySqlParameter("@Test_ID", TestID)).Tables[0])
                {
                    if (dt1.Rows.Count > 0)
                    {
                        byte[] ss = Encoding.UTF8.GetBytes(dt1.Rows[0]["LabInves_Description"].ToString());
                        if (DocumentManager.FindDocument("0") != null)
                        {
                            DocumentManager.CloseDocument("0");
                        }
                        ASPxRichEdit1.Open("0", DevExpress.XtraRichEdit.DocumentFormat.Html, () => { return ss; });
                    }
                    else
                    {
                        byte[] ss = Encoding.UTF8.GetBytes("");
                        if (DocumentManager.FindDocument("0") != null)
                        {
                            DocumentManager.CloseDocument("0");
                        }
                        ASPxRichEdit1.Open("0", DevExpress.XtraRichEdit.DocumentFormat.Html, () => { return ss; });
                    }
                }
            }

        }
    }

    protected void btnNotApproved_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
         MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
         try
         {
             StringBuilder sbNotApp = new StringBuilder();
             sbNotApp.Append(" INSERT INTO `patient_labInvestigation_opd_notApprove` ");
             sbNotApp.Append(" (`Test_ID`,`LedgerTransactionID`,`LedgerTransactionNo`,`BarcodeNo`,`ItemId`,`ItemName`, ");
             sbNotApp.Append(" `Investigation_ID`,`IsPackage`,`Date`,`SubCategoryID`,`Rate`,`Amount`,`DiscountAmt`,`Quantity`,");
             sbNotApp.Append(" `DiscountByLab`,`IsRefund`,`IsReporting`,`Patient_ID`,`AgeInDays`,`Gender`,`ReportType`,`CentreID`, ");
             sbNotApp.Append(" `CentreIDSession`,`TestCentreID`,`IsNormalResult`,`IsCriticalResult`,`PrintSeparate`,`isPartial_Result`,`Result_Flag`,");
             sbNotApp.Append(" `ResultEnteredBy`,`ResultEnteredDate`,`ResultEnteredName`,`Approved`,`AutoApproved`,`MobileApproved`,`ApprovedBy`,`ApprovedDate`, ");
             sbNotApp.Append(" `ApprovedName`,`ApprovedDoneBy`,`IsSampleCollected`,`SampleReceiveDate`,`SampleReceivedBy`,`SampleReceiver`,`SampleBySelf` ");
             sbNotApp.Append(" ,`SampleCollectionBy`,`SampleCollector`,`SampleCollectionDate`,`LedgerTransactionNoOLD`,`isHold`,`HoldBy`,`HoldByName`,`UnHoldBy`,");
             sbNotApp.Append(" `UnHoldByName`,`UnHoldDate`,`Hold_Reason`,`isForward`,`ForwardToCentre`,`ForwardToDoctor`,`ForwardBy`,`ForwardByName`,`ForwardDate`,");
             sbNotApp.Append(" `isPrint`,`IsFOReceive`,`FOReceivedBy`,`FOReceivedByName`,`FOReceivedDate`,`IsDispatch`,`DispatchedBy`,`DispatchedByName`,");
             sbNotApp.Append(" `DispatchedDate`,`isUrgent`,`DeliveryDate`,`SlideNumber`,`SampleTypeID`,`SampleTypeName`,`SampleQty`,`LabOutsrcID`,");
             sbNotApp.Append(" `LabOutsrcName`,`LabOutSrcUserID`,`LabOutSrcBy`,`LabOutSrcDate`,`LabOutSrcRate`,`isHistoryReq`,`CPTCode`,`MacStatus`,");
             sbNotApp.Append(" `isEmail`,`isrerun`,");
             sbNotApp.Append(" ");
             sbNotApp.Append(" `CombinationSample`,`CurrentSampleDept`,`ToSampleDept`,");
             sbNotApp.Append("  `UpdateID`,`UpdateName`,`UpdateRemarks`,");
             sbNotApp.Append(" `Updatedate`,`ipaddress`,`Barcode_Group`,`IsLabOutSource`,`barcodePreprinted`,`CultureStatus`,`CultureStatusDate`,`reportnumber`,");
             sbNotApp.Append(" `HistoCytoSampleDetail`,`incubationdatetime`,`HistoCytoPerformingDoctor`,`HistoCytoStatus`,");
             sbNotApp.Append(" `PackageName`,`PackageCode`,`ReRunDate`,`ReRunByID`,`ReRunReason`,`ReRunByName`,");
             sbNotApp.Append(" `ItemID_Interface`,`Interface_companyName`,");
             sbNotApp.Append(" `MachineID_Manual`,`CancelByInterface`,`IsScheduleRate`,`MRP`,DispatchModeID");

             sbNotApp.Append(" ) ");
             sbNotApp.Append(" SELECT `Test_ID`,`LedgerTransactionID`,`LedgerTransactionNo`,`BarcodeNo`,`ItemId`,`ItemName`,`Investigation_ID`,`IsPackage`,");
             sbNotApp.Append(" `Date`,`SubCategoryID`,`Rate`,`Amount`,`DiscountAmt`,`Quantity`,`DiscountByLab`,`IsRefund`,`IsReporting`,`Patient_ID`,`AgeInDays`,");
             sbNotApp.Append(" `Gender`,`ReportType`,`CentreID`,`CentreIDSession`,`TestCentreID`,`IsNormalResult`,`IsCriticalResult`,");
             sbNotApp.Append(" `PrintSeparate`,`isPartial_Result`,`Result_Flag`,`ResultEnteredBy`,`ResultEnteredDate`,`ResultEnteredName`,");
             sbNotApp.Append(" `Approved`,`AutoApproved`,`MobileApproved`,`ApprovedBy`,`ApprovedDate`,`ApprovedName`,`ApprovedDoneBy`,");
             sbNotApp.Append(" `IsSampleCollected`,`SampleReceiveDate`,`SampleReceivedBy`,`SampleReceiver`,`SampleBySelf`,");
             sbNotApp.Append(" `SampleCollectionBy`,`SampleCollector`,`SampleCollectionDate`,`LedgerTransactionNoOLD`,`isHold`,`HoldBy`,");
             sbNotApp.Append(" `HoldByName`,`UnHoldBy`,`UnHoldByName`,`UnHoldDate`,`Hold_Reason`,`isForward`,`ForwardToCentre`,`ForwardToDoctor`,");
             sbNotApp.Append(" `ForwardBy`,`ForwardByName`,`ForwardDate`,`isPrint`,`IsFOReceive`,`FOReceivedBy`,`FOReceivedByName`,`FOReceivedDate`,");
             sbNotApp.Append(" `IsDispatch`,`DispatchedBy`,`DispatchedByName`,`DispatchedDate`,`isUrgent`,`DeliveryDate`,`SlideNumber`,");
             sbNotApp.Append(" `SampleTypeID`,`SampleTypeName`,`SampleQty`,`LabOutsrcID`,`LabOutsrcName`,`LabOutSrcUserID`,`LabOutSrcBy`,`LabOutSrcDate`,");
             sbNotApp.Append(" `LabOutSrcRate`,`isHistoryReq`,`CPTCode`,`MacStatus`,`isEmail`,");
             sbNotApp.Append("  `isrerun`,");
             sbNotApp.Append(" ");
             sbNotApp.Append(" `CombinationSample`,`CurrentSampleDept`,`ToSampleDept`,");
             sbNotApp.Append("  `UpdateID`,`UpdateName`,`UpdateRemarks`,`UpdateDate`,`ipaddress`,`Barcode_Group`,");
             sbNotApp.Append(" `IsLabOutSource`,`barcodePreprinted`,`CultureStatus`,`CultureStatusDate`,`reportnumber`,`HistoCytoSampleDetail`,");
             sbNotApp.Append(" `incubationdatetime`,`HistoCytoPerformingDoctor`,`HistoCytoStatus`,`PackageName`,");
             sbNotApp.Append(" `PackageCode`,`ReRunDate`,`ReRunByID`,`ReRunReason`,`ReRunByName`,");
             sbNotApp.Append("  `ItemID_Interface`,`Interface_companyName`,");
             sbNotApp.Append(" `MachineID_Manual`,`CancelByInterface`,`IsScheduleRate`,`MRP`,0");

             sbNotApp.Append(" FROM `patient_labinvestigation_opd`  WHERE `Test_ID`=@Test_ID ");
             MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbNotApp.ToString(), new MySqlParameter("@Test_ID", TestID));

             string PLOID_NA = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LAST_INSERT_ID();"));


             sbNotApp = new StringBuilder();
             sbNotApp.Append(" INSERT INTO patient_labobservation_opd_text_notapprove ");
             sbNotApp.Append(" (`PLOID`,`PLO_ID`,`Test_id`,`reportstatustext`,`LabInves_Description`,`EntDate`,`UserID`,`Approved`,`ApprovedBy`,`ApprovedDate`,`ApprovedName`,`UpdateID`,`UpdateName`,`Updatedate`,`Uniid`) ");
             sbNotApp.Append(" SELECT  @PLOID,`PLO_ID`,`Test_id`,`reportstatustext`,`LabInves_Description`,`EntDate`,`UserID`,`Approved`,`ApprovedBy`,`ApprovedDate`,`ApprovedName`,`UpdateID`,`UpdateName`,`Updatedate`,`Uniid`  ");
             sbNotApp.Append(" FROM `patient_labObservation_opd_text`  WHERE `Test_ID`=@Test_ID ");
             MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sbNotApp.ToString(), new MySqlParameter("@Test_ID", TestID),
                new MySqlParameter("@PLOID", PLOID_NA));

             MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET Approved = @Approved, isForward = @isForward, isPrint = @isPrint WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected",
                 new MySqlParameter("@Approved", "0"), new MySqlParameter("@isForward", "0"), new MySqlParameter("@isPrint", "0"),
                 new MySqlParameter("@Test_ID", TestID),
                 new MySqlParameter("@isSampleCollected", 'Y'));


             // Save Not Approval Data in New Table
             MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO Report_Unapprove(LedgerTransactionNo, Test_ID,UnapprovebyID,Unapproveby,Comments,ipaddress,UnapproveDate) VALUES(@LedgerTransactionNo,@Test_ID,@UnapprovebyID, @Unapproveby ,@Comments,@ipaddress,now()) ",
                new MySqlParameter("@LedgerTransactionNo", Util.GetString(LedgerTransactionNo)), new MySqlParameter("@Test_ID", TestID),
                new MySqlParameter("@UnapprovebyID", Util.GetString(UserInfo.ID)), new MySqlParameter("@Unapproveby", Util.GetString(UserInfo.LoginName)),
                new MySqlParameter("@ipaddress", StockReports.getip()), new MySqlParameter("@Comments", txtnotappremarks.Text));
            
             tnx.Commit();
             lblerrmsg.Text = "Report Not Approved";
             ASPxRichEdit1.ReadOnly = false;
         }
         catch (Exception ex)
         {
             ClassLog cl = new ClassLog();
             cl.errLog(ex);
             tnx.Rollback();
             lblerrmsg.Text = "Somthhing Went Wrong";
         }
         finally
         {
             tnx.Dispose();
             con.Close();
             con.Dispose();
         }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        string header = GetHtml();
        int IsCritical = (chkIsCritical.Checked == true) ? 1 : 0;
        int IsCriticalFollow = (chkIsCriticalFollow.Checked == true) ? 1 : 0;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (header == string.Empty)
            {
                Exception ex = new Exception(" value can't be blank.....!");
                throw (ex);
            }
            MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd_text WHERE `Test_ID`=@Test_ID",
                         new MySqlParameter("@Test_ID", TestID));
            StringBuilder myStr = new StringBuilder();
            myStr.Append("INSERT INTO `patient_labobservation_opd_text`(`PLO_ID`,`Test_ID`,`LabInves_Description`,`EntDate`,UserID) ");
            myStr.Append(" VALUES(@PLO_ID,@Test_ID,@LabInves_Description,@EntDate,@UserID)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, myStr.ToString(),
                new MySqlParameter("@PLO_ID", TestID),
                new MySqlParameter("@Test_ID", TestID),
                new MySqlParameter("@LabInves_Description", header),
                new MySqlParameter("@EntDate", DateTime.Now),
                new MySqlParameter("@UserID", UserInfo.ID));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsCritical = @IsCritical,IsCriticalFollow=@IsCriticalFollow,HistoCytoPerformingDoctor=@HistoCytoPerformingDoctor WHERE Test_ID=@Test_ID ",
                           new MySqlParameter("@IsCritical", IsCritical),
                            new MySqlParameter("@IsCriticalFollow", IsCriticalFollow),
                            new MySqlParameter("@HistoCytoPerformingDoctor", ddlDoctor.SelectedValue),
                           new MySqlParameter("@Test_ID", TestID));

            if (IsApproved != "1")
            {
                string str = "update patient_labinvestigation_opd set  ResultEnteredBy=if(Result_Flag=0,@UserID,ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,@LoginName,ResultEnteredName),Result_Flag=1 ";
                str += " where test_id=@test_id  and isSampleCollected='Y' and approved=0 ";
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str,
                   new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@LoginName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                   new MySqlParameter("@test_id", TestID));
            }
            else
            {
                Exception ex = new Exception(" Report Already Approved.....!");
                throw (ex);
            }
            tnx.Commit();

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                      new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                      new MySqlParameter("@SinNo", ""), new MySqlParameter("@Test_ID", TestID),
                      new MySqlParameter("@Status", "Report Save"), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                      new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty));
            lblerrmsg.Text = "Save Successfully";

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblerrmsg.Text = ex.Message;
            tnx.Rollback();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnApprovedNew_Click(object sender, EventArgs e)
    {
        string header = GetHtml();
        int IsCritical = (chkIsCritical.Checked == true) ? 1 : 0;
        int IsCriticalFollow = (chkIsCriticalFollow.Checked == true) ? 1 : 0;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (header == string.Empty)
            {
                Exception ex = new Exception(" value can't be blank.....!");
                throw (ex);
            }
            MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "DELETE FROM patient_labobservation_opd_text WHERE `Test_ID`=@Test_ID",
                         new MySqlParameter("@Test_ID", TestID));
            StringBuilder myStr = new StringBuilder();
            myStr.Append("INSERT INTO `patient_labobservation_opd_text`(`PLO_ID`,`Test_ID`,`LabInves_Description`,`EntDate`,UserID) ");
            myStr.Append(" VALUES(@PLO_ID,@Test_ID,@LabInves_Description,@EntDate,@UserID)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, myStr.ToString(),
                new MySqlParameter("@PLO_ID", TestID),
                new MySqlParameter("@Test_ID", TestID),
                new MySqlParameter("@LabInves_Description", header),
                new MySqlParameter("@EntDate", DateTime.Now),
                new MySqlParameter("@UserID", UserInfo.ID));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET IsCritical = @IsCritical,IsCriticalFollow=@IsCriticalFollow,TATDelayRemark = @TATDelayRemark,HistoCytoPerformingDoctor=@HistoCytoPerformingDoctor  WHERE Test_ID=@Test_ID ",
                           new MySqlParameter("@IsCritical", IsCritical),
                            new MySqlParameter("@IsCriticalFollow", IsCriticalFollow),
                            new MySqlParameter("@TATDelayRemark", txtTATremark.Text),
                             new MySqlParameter("@HistoCytoPerformingDoctor", ddlDoctor.SelectedValue),
                           new MySqlParameter("@Test_ID", TestID));

            if (ddlApprove.SelectedValue != "")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET Approved = @Approved, ApprovedBy = @ApprovedBy, ApprovedName = @ApprovedName,ApprovedDoneBy=@ApprovedDoneBy,ApprovedDate=now(), ResultEnteredBy=if(Result_Flag=0,@UserID,ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,@LoginName,ResultEnteredName),Result_Flag=1 WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected and Approved=0  and ishold=0 ",
                    new MySqlParameter("@Approved", 1), new MySqlParameter("@ApprovedBy", ddlApprove.SelectedValue), new MySqlParameter("@ApprovedName", Util.GetString(ddlApprove.SelectedItem.Text)),
                          new MySqlParameter("@ApprovedDoneBy", UserInfo.ID),
                          new MySqlParameter("@Test_ID", TestID), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@LoginName", Util.GetString(HttpContext.Current.Session["LoginName"])),
                          new MySqlParameter("@isSampleCollected", 'Y'));

                if (hdnisContrast.Value == "1")
                {

                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET Approved = @Approved, ApprovedBy = @ApprovedBy, ApprovedName = @ApprovedName,ApprovedDoneBy=@ApprovedDoneBy,ApprovedDate=now() WHERE LedgerTransactionNo=@LedgerTransactionNo and ItemID=@ItemID",
                    new MySqlParameter("@Approved", 1), new MySqlParameter("@ApprovedBy", ddlApprove.SelectedValue), new MySqlParameter("@ApprovedName", Util.GetString(ddlApprove.SelectedItem.Text)),
                          new MySqlParameter("@ApprovedDoneBy", UserInfo.ID),
                          new MySqlParameter("@ItemID", DeptID == "9" ? "2184" : "946"),
                          new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo));
                }
            }
            else
            {
                Exception ex = new Exception("Don't have Approval Rights !");
                throw (ex);
            }
            tnx.Commit();
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                     new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                     new MySqlParameter("@SinNo", ""), new MySqlParameter("@Test_ID", TestID),
                     new MySqlParameter("@Status", "Report Approved"), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                     new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty));
            lblerrmsg.Text = "Save Successfully";
            ASPxRichEdit1.ReadOnly = true;
            lblerrmsg.Text = "Report Approved (Editor Disabled)";
            txtTATremark.Text = "";
            btnSave.Enabled = false;
            IsApproved = "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblerrmsg.Text = ex.Message;
            tnx.Rollback();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
       

    }
    protected void btnHold_Click(object sender, EventArgs e)
    {
        string header = GetHtml();
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (header == string.Empty)
            {
                Exception ex = new Exception(" value can't be blank.....!");
                throw (ex);
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  isHold = @isHold,HoldBy = @HoldBy,HoldByName=@HoldByName WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected and isHold =0 ",
                           new MySqlParameter("@isHold", "1"),
                           new MySqlParameter("@HoldBy", UserInfo.ID),
                           new MySqlParameter("@HoldByName", UserInfo.LoginName),
                           new MySqlParameter("@Test_ID", TestID),
                           new MySqlParameter("@isSampleCollected", 'Y'));
            tnx.Commit();
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                   new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                   new MySqlParameter("@SinNo", ""), new MySqlParameter("@Test_ID", TestID),
                   new MySqlParameter("@Status", "Report Hold"), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                   new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty));
            lblerrmsg.Text = "Hold Successfully";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblerrmsg.Text = ex.Message;
            tnx.Rollback();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }

    }
    private string GetHtml()
    {
        DocumentId = ASPxRichEdit1.DocumentId;
        byte[] ar = ASPxRichEdit1.SaveCopy(DevExpress.XtraRichEdit.DocumentFormat.Html);
        Description = Encoding.UTF8.GetString(ar);
        string header = "";
        header = Description;
        header = header.Replace("\'", "");
        header = header.Replace("–", "-");
        header = header.Replace("'", "");
        header = header.Replace("µ", "&micro;");
        header = header.Replace("ᴼ", "&deg;");
        header = header.Replace("#aaaaaa 1px dashed", "none");
        header = header.Replace("dashed", "none");
        return header;
    }
    protected void btnUnHold_Click(object sender, EventArgs e)
    {
        string header = GetHtml();
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            if (header == string.Empty)
            {
                Exception ex = new Exception(" value can't be blank.....!");
                throw (ex);
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  isHold = @isHold,UnHoldBy = @UnHoldBy,UnHoldByName=@UnHoldByName,unholddate=now() WHERE Test_ID=@Test_ID AND isSampleCollected=@isSampleCollected and isHold=1",
                              new MySqlParameter("@isHold", "0"),
                              new MySqlParameter("@UnHoldBy", UserInfo.ID),
                              new MySqlParameter("@UnHoldByName", UserInfo.LoginName),
                              new MySqlParameter("@Test_ID", TestID),
                              new MySqlParameter("@isSampleCollected", 'Y'));
            tnx.Commit();
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)VALUES(@LedgertransactionNo,@SinNo,@Test_ID,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,NOW(),@DispatchCode) ",
                   new MySqlParameter("@LedgertransactionNo", LedgerTransactionNo),
                   new MySqlParameter("@SinNo", ""), new MySqlParameter("@Test_ID", TestID),
                   new MySqlParameter("@Status", "Report UnHold"), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                   new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty));
            lblerrmsg.Text = "UnHold Successfully";

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblerrmsg.Text = ex.Message;
            tnx.Rollback();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void btnSaveImpression_Click(object sender, EventArgs e)
    {
        string Impression = txtImpression.Text;
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE patient_labinvestigation_opd SET  Impression = @Impression WHERE Test_ID=@Test_ID",
                              new MySqlParameter("@Impression", Impression), new MySqlParameter("@Test_ID", TestID));
            tnx.Commit();
            lblerrmsg.Text = "Save Successfully";

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblerrmsg.Text = ex.Message;
            tnx.Rollback();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string updateOpen(string Test_ID)
    {
        try
        {
            StockReports.ExecuteDML("UPDATE patient_labinvestigation_opd SET isReportOpen = 0 WHERE Test_ID= '" + Test_ID + "'");
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
    }
    [WebMethod]
    public static string bindimpression(string testid)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append(" SELECT Impression FROM `patient_labinvestigation_opd` WHERE `Test_id`=@Test_id ");
            return Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@Test_id", testid)));
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string checkTAT(string testid)
    {
        StringBuilder sb = new StringBuilder();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb.Append(" SELECT IF(NOW()>DeliveryDate,1,0) FROM `patient_labinvestigation_opd`  WHERE `Test_id`=@Test_id ");
            string IsTATDelay = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@Test_id", testid)));
            return IsTATDelay;
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void dllAllTemplate_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlTemplate.Items.Count > 0)
        {
            ddlTemplate.SelectedIndex = 0;
        }
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string str = "SELECT it.Template_Desc,it.Template_ID FROM `investigation_template` it where it.Template_ID=@Template_ID";
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str, new MySqlParameter("@Template_ID", dllAllTemplate.SelectedValue)).Tables[0])
        {
            if (dt.Rows.Count > 0)
            {
                byte[] ss = Encoding.UTF8.GetBytes(dt.Rows[0]["Template_Desc"].ToString());

                if (dt != null && dt.Rows.Count > 0)
                {
                    if (DocumentManager.FindDocument(dt.Rows[0]["Template_ID"].ToString()) != null)
                    {
                        DocumentManager.CloseDocument(dt.Rows[0]["Template_ID"].ToString());
                    }
                    ASPxRichEdit1.Open(dt.Rows[0]["Template_ID"].ToString(), DevExpress.XtraRichEdit.DocumentFormat.Html, () => { return ss; });
                }
            }
            else
            {
                string str1 = "SELECT LabInves_Description from patient_labobservation_opd_text WHERE `Test_ID`=@Test_ID";
                using (DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, str1, new MySqlParameter("@Test_ID", TestID)).Tables[0])
                {
                    if (dt1.Rows.Count > 0)
                    {
                        byte[] ss = Encoding.UTF8.GetBytes(dt1.Rows[0]["LabInves_Description"].ToString());
                        if (DocumentManager.FindDocument("0") != null)
                        {
                            DocumentManager.CloseDocument("0");
                        }
                        ASPxRichEdit1.Open("0", DevExpress.XtraRichEdit.DocumentFormat.Html, () => { return ss; });
                    }
                    else
                    {
                        byte[] ss = Encoding.UTF8.GetBytes("");
                        if (DocumentManager.FindDocument("0") != null)
                        {
                            DocumentManager.CloseDocument("0");
                        }
                        ASPxRichEdit1.Open("0", DevExpress.XtraRichEdit.DocumentFormat.Html, () => { return ss; });
                    }
                }
            }

        }
    }
}
