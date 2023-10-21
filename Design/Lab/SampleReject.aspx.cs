using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using System.Threading.Tasks;
public partial class Design_Lab_SampleReject : System.Web.UI.Page
{
    public string testid = string.Empty;
    public string barcode = string.Empty;
   public  enum NotiifactonType
    {
        sampleRejection = 1
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch1", "document.getElementById('divMasterNav').style.display='none';", true);
        if (!IsPostBack)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                DataTable Rejections = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,`RejectionReason` FROM `samplerejection_master` WHERE isActive=1 ORDER BY RejectionReason;").Tables[0];
                ddlreason.DataSource = Rejections;
                ddlreason.DataTextField = "RejectionReason";
                ddlreason.DataValueField = "ID";
                ddlreason.DataBind();
                ddlreason.Items.Insert(0, new ListItem("", ""));
                ddlreason.Items.Add(new ListItem("Other", "0"));
                if (Util.GetString(Request.QueryString["test_id"]) != string.Empty)
                {
                    testid = Util.GetString(Common.Decrypt(Request.QueryString["test_id"]));
                }
                else
                {
                    barcode = Util.GetString(Common.Decrypt(Request.QueryString["BarcodeNo"]));
                }
                if (testid != string.Empty)
                {
                    ddltest.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, " select im.name,plo.test_id from patient_labinvestigation_opd plo  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` AND plo.test_id=@TestID",
                         new MySqlParameter("@TestID", testid)).Tables[0];
                    ddltest.DataValueField = "test_id";
                    ddltest.DataTextField = "name";
                    ddltest.DataBind();
                    if (ddltest.Items.Count == 0)
                    {
                        lblMsg.Text = "Wrong Data Selection Please Contact To Admin";
                        btnsave.Visible = false;
                    }
                    foreach (ListItem li in ddltest.Items)
                    {
                        li.Selected = true;
                        li.Enabled = false;
                        getdata(li.Value);
                    }
                }
                if (barcode != string.Empty)
                {
                    ddltest.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, " select im.name,plo.test_id from patient_labinvestigation_opd plo  INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` and plo.barcodeno=@barCodeNo",
                       new MySqlParameter("@barCodeNo", barcode)).Tables[0];
                    ddltest.DataValueField = "test_id";
                    ddltest.DataTextField = "name";
                    ddltest.DataBind();
                    if (ddltest.Items.Count == 0)
                    {
                        lblMsg.Text = "Wrong Data Selection Please Contact To Admin";
                        btnsave.Visible = false;
                    }
                    foreach (ListItem li in ddltest.Items)
                    {
                        li.Selected = true;
                        getdata(li.Value);
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
    }
    void getdata(string testid1)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sbQuery = new StringBuilder();
            sbQuery.Append(" SELECT plo.patient_id, plo.SampleQty, lt.PName,plo.Test_ID,plo.IsSampleCollected,plo.`Approved`, im.name,plo.`SampleTypeID`,plo.`SampleTypeName`,plo.`BarcodeNo`,plo.`LedgerTransactionNo`,plo.LedgerTransactionID, plo.SampleReceiver, plo.SampleCollector,");

            sbQuery.Append(" date_format(SampleCollectionDate,'%d-%b-%Y %h:%i %p') collDate,plo.SampleReceiver,date_format(SampleReceiveDate,'%d-%b-%Y %h:%i %p') recDate,");
            sbQuery.Append(" plo.UpdateRemarks,");
            sbQuery.Append(" IF(IFNULL(plo.SampleTypeID,0)=0,   ");
            sbQuery.Append(" IFNULL((SELECT CONCAT(ist.SampleTypeID ,'^',ist.SampleTypeName) FROM investigations_SampleType ist   ");
            sbQuery.Append("  WHERE ist.Investigation_Id =plo.Investigation_ID ORDER BY ist.isDefault DESC,ist.SampleTypeName LIMIT  1),'1|')  ");
            sbQuery.Append(" ,CONCAT(plo.`SampleTypeID`,'|',plo.`SampleTypeName`))  SampleID,    ");
            sbQuery.Append(" GROUP_CONCAT(DISTINCT inv_smpl.SampleTypeName ORDER BY  inv_smpl.SampleTypeName SEPARATOR ',')SampleTypes    ");
            sbQuery.Append("  ,fpm.IsInvoice,plo.`Result_Flag`,plo.`IsPackage`   ");
            sbQuery.Append(" FROM `patient_labinvestigation_opd` plo ");
            sbQuery.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgerTransactionID=plo.ledgerTransactionID   ");
            sbQuery.Append(" INNER JOIN `investigation_master` im ON im.`Investigation_Id`=plo.`Investigation_ID` ");
            sbQuery.Append(" INNER JOIN `f_panel_master` fpm ON lt.`Panel_ID`=fpm.Panel_id ");

            sbQuery.Append(" LEFT JOIN `investigations_SampleType` inv_smpl  ");
            sbQuery.Append(" ON inv_smpl.`Investigation_ID`=im.`Investigation_Id` ");
            sbQuery.Append(" WHERE plo.`test_id`=@test_id ");
            sbQuery.Append(" AND plo.IsReporting=1 AND plo.IsActive=1 ");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQuery.ToString(),
                new MySqlParameter("@test_id", testid1)).Tables[0];

            if (dt.Rows.Count > 0)
            {
                lblMsg.Text = string.Empty;
                tr1.Visible = false;
                tr2.Visible = false;
                btnsave.Visible = true;
                lblabno.Text = dt.Rows[0]["LedgerTransactionNo"].ToString();
                lblabID.Text = dt.Rows[0]["LedgerTransactionID"].ToString();
                lbname.Text = dt.Rows[0]["PName"].ToString();
                lbtestid.Text = dt.Rows[0]["Test_ID"].ToString();
                lbsinno.Text = dt.Rows[0]["BarcodeNo"].ToString();
                lbpid.Text = dt.Rows[0]["patient_id"].ToString();
                Label1.Text = dt.Rows[0]["collDate"].ToString();
                Label4.Text = dt.Rows[0]["SampleCollector"].ToString();
                if (dt.Rows[0]["SampleTypeName"].ToString() != "")
                {
                    lbsampletype.Text = dt.Rows[0]["SampleTypeName"].ToString();
                }
                else
                {
                    lbsampletype.Text = dt.Rows[0]["SampleTypes"].ToString();
                }
                lbsampletype0.Text = dt.Rows[0]["SampleQty"].ToString();
                if (dt.Rows[0]["IsSampleCollected"].ToString() == "R")
                {
                    lblMsg.Text = "Sample Already Rejected";
                    Label2.Text = dt.Rows[0]["recDate"].ToString();
                    lbsampletype1.Text = dt.Rows[0]["UpdateRemarks"].ToString();
                    tr1.Visible = true;
                    btnsave.Visible = false;
                }

                if (dt.Rows[0]["IsSampleCollected"].ToString() == "Y" && dt.Rows[0]["Approved"].ToString() == "0")
                {
                    lblMsg.Text = "Sample Received At Department";
                    Label3.Text = dt.Rows[0]["recDate"].ToString();
                    lbsampletype2.Text = dt.Rows[0]["SampleReceiver"].ToString();
                    tr2.Visible = true;
                    btnsave.Visible = true;
                }
                if (dt.Rows[0]["IsSampleCollected"].ToString() == "Y" && dt.Rows[0]["Approved"].ToString() == "1")
                {
                    lblMsg.Text = "Result Approved";
                    Label3.Text = dt.Rows[0]["recDate"].ToString();
                    lbsampletype2.Text = dt.Rows[0]["SampleReceiver"].ToString();
                    tr2.Visible = true;
                    btnsave.Visible = false;
                }
                if (dt.Rows[0]["LedgerTransactionNo"].ToString() == string.Empty)
                {
                    btnsave.Visible = false;
                }

            }
            else
            {
                lblMsg.Text = "Wrong Data Selection Please Contact To Admin";
                btnsave.Visible = false;
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
    public class getItemDetail
    {
        public int ItemID { get; set; }
        public int Test_ID { get; set; }
        public int SubcategoryID { get; set; }
        public sbyte IsPackage { get; set; }
    }
    protected void btnsave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = string.Empty;
        if (ddlreason.SelectedValue == string.Empty)
        {
            lblMsg.Text = "Please Select Reason";
            return;
        }
        if (ddlreason.SelectedValue == "0" && txtreason.Text == string.Empty)
        {
            lblMsg.Text = "Please Enter Reason";
            txtreason.Focus();
            return;
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction();
        try
        {
            string reason = string.Empty;

            if (ddlreason.SelectedValue == "0")
            {
                reason = txtreason.Text;
            }
            else
            {
                reason = ddlreason.SelectedItem.Text;
            }
            StringBuilder sb = new StringBuilder();
            List<getItemDetail> Test_ID = new List<getItemDetail>();
            foreach (ListItem li in ddltest.Items)
            {
                if (li.Selected)
                {
                    sb = new StringBuilder();
                    sb.Append("UPDATE patient_labinvestigation_opd SET Result_Flag=0,issra=0,IsSampleCollected='R',SampleReceiveDate=NOW(),");
                    sb.Append(" SampleReceivedBy=@SampleReceivedBy,SampleReceiver=@SampleReceiver,UpdateID=@UpdateID,UpdateName=@UpdateName,");
                    sb.Append(" UpdateDate=NOW() WHERE Test_ID=@Test_ID AND IsSampleCollected!='R' ");
                    int cnt = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@SampleReceivedBy", UserInfo.ID),
                         new MySqlParameter("@SampleReceiver", UserInfo.LoginName),
                         new MySqlParameter("@UpdateID", UserInfo.ID),
                         new MySqlParameter("@UpdateName", UserInfo.LoginName),
                         new MySqlParameter("@Test_ID", li.Value));

                    sb = new StringBuilder();
                    sb.Append("UPDATE sample_logistic SET isactive=0");
                    sb.Append("  WHERE TestID=@Test_ID  ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                         new MySqlParameter("@Test_ID", li.Value));

                    sb = new StringBuilder();
                    if (cnt > 0)
                    {
                        sb.Append("INSERT INTO patient_sample_rejection(Patient_ID,LedgerTransactionNo,Test_ID,RejectionReason,UserID,RejectionReason_ID,LedgerTransactionID,CreatedBy) ");
                        sb.Append(" VALUES(@Patient_ID,@LedgerTransactionNo,@Test_ID,@RejectionReason,@UserID,@RejectionReason_ID,@LedgerTransactionID,@CreatedBy)");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@Patient_ID", lbpid.Text),
                            new MySqlParameter("@LedgerTransactionNo", lblabno.Text), new MySqlParameter("@LedgerTransactionID", lblabID.Text),
                            new MySqlParameter("@Test_ID", li.Value),
                            new MySqlParameter("@RejectionReason", reason),
                            new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                            new MySqlParameter("@RejectionReason_ID", ddlreason.SelectedValue));

                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,LedgerTransactionID,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                        sb.Append(" SELECT LedgerTransactionNo,LedgerTransactionID,BarCodeNo,Test_ID,CONCAT('Sample Rejected (',ItemName,')',' Rejected Reason : " + reason + "'),@UserID,@LoginName,@IpAddress,@CentreID, ");
                        sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@Test_ID");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                           new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@LoginName", UserInfo.LoginName),
                           new MySqlParameter("@IpAddress", StockReports.getip()), 
                           //,new MySqlParameter("@reason", reason),
                           new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID),
                           new MySqlParameter("@Test_ID", li.Value));
                    }
                    Test_ID.Add(new getItemDetail { Test_ID = Util.GetInt(li.Value) });


                }
            }


         string returnData=   Notification_Insert.notificationInsert(1, lblabID.Text, tnx, Util.GetInt(lblabID.Text), "", 0, 0, string.Concat("Sample Rejection For Lab ID ", lblabID.Text), "", "patient_sample_rejection", "LedgerTransactionNo", "SampleRejection");

         if (returnData == "0")
         {
             tnx.Rollback();
             lblMsg.Text = "Error in Notification Insert";
             return;
         }

            int[] Test_IDTags = Test_ID.Select(r => r.Test_ID).ToArray();
            string[] Test_IDParamNames = Test_IDTags.Select((s, i) => "@tag" + i).ToArray();
            string ItemIDClause = string.Join(", ", Test_IDParamNames);

            sb = new StringBuilder();
            sb.Append(" SELECT  pm.Mobile PatientMobileno,pm.PName,lt.IsCredit, cm.Type1,cm.Type1ID,lt.`Panel_ID`,fpm.Mobile clientMobileNo,dr.Mobile DoctorMobileNo,lt.CentreID,lt.LedgerTransactionID,fpm.SampleRecollectAfterReject ");
            sb.Append(" FROM f_ledgertransaction lt  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.`Patient_ID`=lt.Patient_ID ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID  ");
            sb.Append(" INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_ID ");
            sb.Append(" INNER JOIN `f_panel_master` fpm ON lt.`Panel_ID`=fpm.Panel_id ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.LedgertransactionID=plo.LedgertransactionID ");
            sb.Append(" WHERE plo.Test_ID IN ({0}) AND plo.IsPackage=0 AND plo.Result_Flag=0 AND plo.IsActive=1");
            DataTable dt = new DataTable();
            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), ItemIDClause), con))
            {

                for (int i = 0; i < Test_IDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(Test_IDParamNames[i], Test_IDTags[i]);
                }
                da.Fill(dt);
            }
            if (dt.Rows.Count > 0)
            {
               // if (dt.Rows[0]["SampleRecollectAfterReject"].ToString() == "0")
               // {
                 //   if (dt.Rows[0]["IsCredit"].ToString() == "1" || dt.Rows[0]["Type1"].ToString() == "CC")
                  //  {
                        if (dt.Rows.Count > 0)
                        {
                            DateTime billDate = DateTime.Now;
                            string BillType = "Debit- Test Refund";
                            string DebitBillNo = AllLoad_Data.getBillNo(Util.GetInt(dt.Rows[0]["CentreID"].ToString()), "D", con, tnx);
                            if (DebitBillNo == string.Empty)
                            {
                                tnx.Rollback();
                                lblMsg.Text = "BillNo Error";
                            }

                            sb = new StringBuilder();
                            sb.Append("INSERT INTO patient_labinvestigation_opd(LedgerTransactionID,LedgerTransactionNo,BarcodeNo,ItemId,ItemName,Investigation_ID,IsPackage,Date,SubCategoryID,Rate,");
                            sb.Append(" Amount,DiscountAmt,CouponAmt,Quantity,DiscountByLab,IsRefund,IsReporting,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                            sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                            sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                            sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                            sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                            sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                            sb.Append(" SampleTypeID,SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                            sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                            sb.Append(" CurrentSampleDept,ToSampleDept,ipAddress,");
                            sb.Append(" Barcode_Group,IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                            sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                            sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                            sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,BillNo,BillDate,BillType,SRADate,CreatedBy,CreatedByID,BaseCurrencyRound, ");
                            sb.Append(" SubcategoryName,IsSRA,MacStatus,DepartmentTokenNo) ");
                            sb.Append(" ");
                            sb.Append(" SELECT LedgerTransactionID,LedgerTransactionNo,BarcodeNo,ItemId,ItemName,Investigation_ID,IsPackage,@BillDate,SubCategoryID,Rate,");
                            sb.Append(" Amount*-1,DiscountAmt*-1,CouponAmt,Quantity*-1,DiscountByLab,1,1,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                            sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                            sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                            sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                            sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                            sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                            sb.Append(" SampleTypeID,SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                            sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                            sb.Append(" CurrentSampleDept,ToSampleDept,@ipAddress,");
                            sb.Append(" Barcode_Group,IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                            sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                            sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                            sb.Append(" PackageMRPPercentage,PackageMRPNet,ItemCode,@BillNo,@BillDate,@BillType,SRADate,@CreatedBy,@CreatedByID,@BaseCurrencyRound, ");
                            sb.Append(" SubcategoryName,IsSRA,MacStatus,DepartmentTokenNo ");
                            sb.Append(" FROM patient_labinvestigation_opd WHERE Test_ID IN ({0})  AND IsPackage=0   ");//AND Result_Flag=0

                            using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), ItemIDClause), con, tnx))
                            {

                                for (int i = 0; i < Test_IDParamNames.Length; i++)
                                {
                                    cmd.Parameters.Add(new MySqlParameter(Test_IDParamNames[i], Test_IDTags[i]));
                                }
                                cmd.Parameters.Add(new MySqlParameter("@BillNo", DebitBillNo));
                                cmd.Parameters.Add(new MySqlParameter("@BillDate", billDate));
                                cmd.Parameters.Add(new MySqlParameter("@BillType", BillType));
                                cmd.Parameters.Add(new MySqlParameter("@CreatedBy", UserInfo.LoginName));
                                cmd.Parameters.Add(new MySqlParameter("@CreatedByID", UserInfo.ID));
                                cmd.Parameters.Add(new MySqlParameter("@BaseCurrencyRound", Resources.Resource.BaseCurrencyRound));
                                cmd.Parameters.Add(new MySqlParameter("@ipAddress", StockReports.getip()));
                                cmd.ExecuteNonQuery();
                            }

                            sb = new StringBuilder();
                            sb.Append(" UPDATE patient_labinvestigation_opd SET IsRefund=1,UpdateID=@UpdateID,UpdateName=@UpdateName,UpdateDate=NOW() ");
                            sb.Append(" WHERE Test_ID IN ({0}) ");
                            using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), ItemIDClause), con, tnx))
                            {
                                for (int i = 0; i < Test_IDParamNames.Length; i++)
                                {
                                    cmd.Parameters.Add(new MySqlParameter(Test_IDParamNames[i], Test_IDTags[i]));
                                }
                                cmd.Parameters.AddWithValue("@UpdateID", UserInfo.ID);
                                cmd.Parameters.AddWithValue("@UpdateName", UserInfo.LoginName);
                                cmd.ExecuteNonQuery();
                            }
                            Panel_Share ps = new Panel_Share();
                            JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(Util.GetInt(dt.Rows[0]["LedgerTransactionID"].ToString()), tnx, con));
                            if (IPS.status == false)
                            {
                                tnx.Rollback();
                                lblMsg.Text = IPS.response;
                            }

                            sb = new StringBuilder();
                            sb.Append(" UPDATE f_ledgertransaction set grossAmount=(SELECT IFNULL(SUM(Rate*Quantity),0)  FROM patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID), ");
                            sb.Append(" netAmount=(SELECT SUM(amount) from patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID),");
                            sb.Append(" discountonTotal=(SELECT sum(discountAmt) FROM patient_labinvestigation_opd WHERE LedgerTransactionID = @LedgerTransactionID)");
                            sb.Append(" WHERE LedgerTransactionID=@LedgerTransactionID ");

                            int b1 = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@LedgerTransactionID", Util.GetInt(dt.Rows[0]["LedgerTransactionID"].ToString())));
                            if (b1 == 0)
                            {
                                tnx.Rollback();
                                lblMsg.Text = IPS.response;

                            }


                            //sb = new StringBuilder();
                            //sb.Append(" INSERT INTO opd_refund(old_LedgerTransactionNo,new_LedgerTransactionNo,old_ReceiptNo,New_ReceiptNo,Patient_ID,Refund_Amt,UserID,EntDate,RefundDoneByID) ");
                            //sb.Append(" values(@old_LedgerTransactionNo,@new_LedgerTransactionNo,@old_ReceiptNo,@New_ReceiptNo,@Patient_ID,@Refund_Amt,@UserID,now(),@RefundDoneByID) ");

                            // MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                            //    new MySqlParameter("@old_LedgerTransactionNo", dt.Rows[0]["LedgertransactionNo"].ToString()), new MySqlParameter("@new_LedgerTransactionNo", LedgerTransactionNo.Trim()),
                            //        new MySqlParameter("@old_ReceiptNo", string.Empty), new MySqlParameter("@New_ReceiptNo", newReceiptNo.Trim()),
                            //        new MySqlParameter("@Patient_ID", PatientID.Trim()), new MySqlParameter("@Refund_Amt", Util.GetDouble(dt.AsEnumerable().Sum(x => Util.GetDouble(x["Amount"]))) * (-1)),
                            //        new MySqlParameter("@UserID", dt.Rows[0]["CreatedByID"].ToString()), new MySqlParameter("@RefundDoneByID", UserInfo.ID));
                           
                        }
                  //  }
               // }
                //sms
                int isallow = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1)  FROM sms_configuration WHERE id=14 AND (`IsPatient`=1 OR IsDoctor=1 OR IsClient=1)"));
                if (isallow == 1)
                {
                    SMSDetail sd = new SMSDetail();
                    JSONResponse SMSResponse = new JSONResponse();

                    List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>{  
                            new SMSDetailListRegistration {
                                                LabNo=Util.GetString(dt.Rows[0]["LedgerTransactionID"]),
                                                PName = Util.GetString(dt.Rows[0]["PName"]),
                                                ItemName=ddltest.SelectedItem.Text.ToString()
                                               }};
                    if (Util.GetString(dt.Rows[0]["PatientMobileno"]) != string.Empty)
                    {
                        SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(14, Util.GetInt(dt.Rows[0]["Panel_ID"]), Util.GetInt(dt.Rows[0]["Type1ID"]), "Patient", Util.GetString(dt.Rows[0]["PatientMobileno"]), Util.GetInt(dt.Rows[0]["LedgerTransactionID"]), con, tnx, SMSDetail));

                        if (SMSResponse.status == false)
                        {
                            tnx.Rollback();
                            lblMsg.Text = SMSResponse.response;
                        }
                    }
                    if (Util.GetString(dt.Rows[0]["clientMobileNo"]) != string.Empty)
                    {
                        SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(14, Util.GetInt(dt.Rows[0]["Panel_ID"]), Util.GetInt(dt.Rows[0]["Type1ID"]), "Client", Util.GetString(dt.Rows[0]["clientMobileNo"]), Util.GetInt(dt.Rows[0]["LedgerTransactionID"]), con, tnx, SMSDetail));

                        if (SMSResponse.status == false)
                        {
                            tnx.Rollback();
                            lblMsg.Text = SMSResponse.response;
                        }
                    }
                    if (Util.GetString(dt.Rows[0]["DoctorMobileNo"]) != string.Empty)
                    {
                        SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(14, Util.GetInt(dt.Rows[0]["Panel_ID"]), Util.GetInt(dt.Rows[0]["Type1ID"]), "Doctor", Util.GetString(dt.Rows[0]["DoctorMobileNo"]), Util.GetInt(dt.Rows[0]["LedgerTransactionID"]), con, tnx, SMSDetail));

                        if (SMSResponse.status == false)
                        {
                            tnx.Rollback();
                            lblMsg.Text = SMSResponse.response;
                        }
                    }
                    SMSDetail.Clear();
                }
            }

            tnx.Commit();
            lblMsg.Text = "Sample Rejected.!";
            btnsave.Visible = false;
        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
            tnx.Rollback();
            lblMsg.Text = ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void ddltest_SelectedIndexChanged(object sender, EventArgs e)
    {
        getdata(ddltest.SelectedValue);
    }
    protected void ddlreason_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlreason.SelectedValue == "0")
        {
            tr.Visible = true;
        }
        else
        {
            tr.Visible = false;
        }
        ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch111", "hideDiv()", true);

    }
}