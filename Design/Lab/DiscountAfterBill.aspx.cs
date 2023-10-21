using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_EDP_DiscountAfterBill : System.Web.UI.Page
{
    public static string LabNo = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindApprovalType();
        }
    }

    private void BindApprovalType()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CONCAT(dm.`EmployeeID`,'#',em.DiscountPerBill_per,'#',em.DiscountPerMonth,'#',em.DiscountOnPackage,'#',em.AppBelowBaseRate,'#',dm.DiscShareType)value,");
        sb.Append(" em.`Name` label ");
        sb.Append(" FROM discount_approval_master dm ");
        sb.Append(" INNER JOIN employee_master em ON dm.`EmployeeID`=em.`Employee_ID` AND dm.`CentreID`=" + UserInfo.Centre + " AND dm.isActive=1 group by em.Employee_ID ");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt != null && dt.Rows.Count > 0)
            {
                ddlApproveBy.DataSource = dt;
                ddlApproveBy.DataTextField = "label";
                ddlApproveBy.DataValueField = "value";
                ddlApproveBy.DataBind();
                txtLabNo.Enabled = true;
            }
            else
            {
                ddlApproveBy.DataSource = null;
                ddlApproveBy.DataBind();
                txtLabNo.Enabled = false;
            }
            ddlApproveBy.Items.Insert(0, new ListItem("Discount Approved By", "0"));
        }
    }

    [WebMethod(EnableSession = true)]
    public static string searchData(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        string Roleid = Util.GetString(UserInfo.RoleID); string permissiontype = "DiscAfterBill"; string Labno = LabNo;
        string rresult = Util.RolePermission(Roleid, permissiontype, Labno);

        if (rresult == "true")
        {
            // return JsonConvert.SerializeObject(new { status = false, response = "Your From date ,To date Diffrence is too  Long" });
            return "-1";
        }
        StringBuilder sb = new StringBuilder();
        try
        {
            sb.Append(" select (select baserate from f_itemmaster where itemID=plo.itemid)baserate, lt.discountid, pm.Patient_ID ,pm.Title ,pm.PName ,pm.House_No ,pm.Street_Name ,pm.Locality ,pm.City , pm.PinCode , ");
            sb.Append(" (SELECT COUNT(*) FROM `patient_labinvestigation_opd` WHERE `LedgerTransactionNo`=@LedgerTransactionNo  AND IsRefund=1)IsARefundEntry, ");
            sb.Append(" pm.State ,pm.Country ,pm.Phone ,pm.Mobile ,pm.Email ,pm.Age ,pm.AgeYear ,pm.AgeMonth ,pm.AgeDays , ");
            sb.Append(" pm.TotalAgeInDays ,date_format(pm.DOB,'%d-%b-%Y')DOB ,pm.Gender ,pm.StateID ,pm.CityID ,pm.localityid,  ");
            sb.Append(" lt.LedgerTransactionID,lt.LedgerTransactionNo,lt.NetAmount,lt.GrossAmount,lt.IsCredit,lt.DiscountApprovedByID, ");
            sb.Append(" lt.DiscountApprovedByName,lt.Panel_ID,lt.PanelName,lt.Doctor_ID,lt.DoctorName, ");
            sb.Append(" lt.ReferLab,lt.OtherReferLab,lt.VIP,lt.CentreID,lt.Adjustment,lt.HomeVisitBoyID, ");
            sb.Append(" lt.PatientIDProof,lt.PatientIDProofNo,lt.PatientSource,lt.PatientType,lt.VisitType,");
            sb.Append(" lt.HLMPatientType,lt.HLMOPDIPDNo,lt.DiscountOnTotal,date_format(lt.date,'%d-%b-%Y')DATE,  ");
            sb.Append(" plo.BarcodeNo,plo.ItemId,plo.ItemCode,plo.ItemName,plo.Investigation_ID,plo.IsPackage,plo.SubCategoryID,SUM(plo.Rate)Rate,SUM(plo.DiscountAmt)DiscountAmt,SUM(plo.Amount)Amount,plo.Quantity,plo.IsRefund, ");
            sb.Append(" plo.IsReporting,plo.ReportType,plo.CentreID,plo.TestCentreID,");
            sb.Append(" IF(plo.`IsPackage`=1 AND (SELECT COUNT(1) FROM patient_labinvestigation_opd plo2 WHERE plo2.LedgerTransactionID = plo.`LedgerTransactionID` AND plo.ItemID=plo2.itemid AND plo2.IsSampleCollected='Y') >0 ,'Y', plo.IsSampleCollected) IsSampleCollected, ");
            sb.Append(" plo.SampleBySelf,plo.isUrgent,DATE_FORMAT(plo.DeliveryDate,'%Y-%m-%d')DeliveryDate,");
            sb.Append(" DATE_FORMAT(plo.SampleCollectionDate,'%Y-%m-%d')SampleCollectionDate,IFNULL(dis.DiscountReason,'')DiscountReason,TIMESTAMPDIFF(MINUTE,lt.DATE,NOW()) BillTimeDiff  ");
            sb.Append(" FROM patient_master pm  ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`Patient_ID`=pm.`Patient_ID` ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionID`=plo.`LedgerTransactionID` ");
            sb.Append(" LEFT JOIN f_ledgertransaction_discountreason dis ON dis.`LedgerTransactionID`=lt.`LedgerTransactionID` AND dis.IsActive=1");
            sb.Append(" WHERE (plo.`LedgerTransactionNo`=@LedgerTransactionNo or plo.Barcodeno=@LedgerTransactionNo)  AND plo.IsActive=1 GROUP BY plo.`ItemId` ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgerTransactionNo", LabNo.Trim())).Tables[0])
            {
                return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "No Record Found" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string saveData(List<myPLO> PLOData, string LabNo, int LabID, string ApprovedByData, string PrevBillAmount, string PrevTotalDiscount, string PrevNetBillAmount, string PrevTotalPaidAmount, string PrevDueAmount, string TotalDiscountAmount, string DiscountReason, string DiscountType, string DiscountID, int CentreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (AllLoad_Data.IsInvoiceCreated(con, LabID) > 0)
            {
                return JsonConvert.SerializeObject(new { Status = false, ErrorMsg = "Invoice Created, So Refund not Possible" });
            }
            string ApprovedByID = string.Empty;
            string ApprovedByName = string.Empty;
            decimal DiscountAmount = Util.GetDecimal((TotalDiscountAmount.Trim() == "") ? "0" : TotalDiscountAmount.Trim());
            decimal NetAmount = Util.GetDecimal(PrevBillAmount) - DiscountAmount;
            ApprovedByID = ApprovedByData.Split('#')[0];
            ApprovedByName = ApprovedByData.Split('#')[6];
            decimal DiscountPerMonth = Util.GetDecimal(ApprovedByData.Split('#')[2]);
			int Iscredit=Util.GetInt(MySqlHelper.ExecuteScalar(tnx,CommandType.Text,"SELECT iscredit FROM f_ledgertransaction WHERE ledgertransactionid="+ LabID +""));
			if (Iscredit >0)
			{
				tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString("Discount is not allowed on Credit Patient !!") });
			}
            if (DiscountAmount > 0)
            {
                decimal discthismonth = Util.GetDecimal(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT SUM(DiscountOnTotal) FROM f_ledgertransaction WHERE DiscountApprovedByID=@DiscountApprovedByID AND MONTH(date) =MONTH(NOW()) AND YEAR(date)=YEAR(NOW())  ",
                    new MySqlParameter("@DiscountApprovedByID", ApprovedByID)));
                discthismonth = discthismonth + DiscountAmount;
                decimal DiscountPending = DiscountPerMonth - discthismonth;
                if (DiscountPending <= 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString("Discount Limit for This Month (" + DiscountPerMonth + ") Exceed") });
                }
            }
            DateTime billDate = DateTime.Now;
            string BillType = "Debit-Discount Added";
            string DebitBillNo = AllLoad_Data.getBillNo(CentreID, "D", con, tnx);
            if (DebitBillNo == string.Empty)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "BillNo Error" });
            }
            StringBuilder sb = new StringBuilder();

            int ItemwiseDisc = PLOData.Select(x => x.ItemwiseDisc == 1).Count();

            if (ItemwiseDisc > 0)
            {
                PLOData = PLOData.Where(x => x.DiscountAmt > 0).ToList();
            }
            else
            {
            }
            List<myPLO> PLOData1 = PLOData.GroupBy(x => x.ItemId).Select(o => o.FirstOrDefault()).ToList();

            int[] Item_IDTags = PLOData1.Select(r => r.ItemId).ToArray();
            string[] Item_IDParamNames = Item_IDTags.Select((s, i) => "@tag" + i).ToArray();
            string ItemIDClause = string.Join(", ", Item_IDParamNames);

            foreach (myPLO ploLocData in PLOData)
            {
                sb = new StringBuilder();
                sb.Append("INSERT INTO patient_labinvestigation_opd(LedgerTransactionID,LedgerTransactionNo,BillNo,BarcodeNo,ItemId,ItemCode,ItemName,Investigation_ID,IsPackage,Date,SubCategoryID,SubCategoryName,Rate,");
                sb.Append(" Amount,DiscountAmt,CouponAmt,Quantity,DiscountByLab,IsRefund,IsReporting,IsActive,BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                sb.Append(" SampleTypeID,SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                sb.Append(" CurrentSampleDept,ToSampleDept,UpdateID,UpdateName,UpdateRemarks,ipAddress,");
                sb.Append(" Barcode_Group,IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                sb.Append(" PackageMRPPercentage,PackageMRPNet,SRADate,CreatedBy,CreatedByID,BaseCurrencyRound) ");
                sb.Append(" ");
                sb.Append(" SELECT t.* FROM ( ");
                sb.Append(" SELECT LedgerTransactionID,LedgerTransactionNo,@BillNo BillNo,'' BarcodeNo,ItemId,ItemCode,ItemName,Investigation_ID,IsPackage,@BillDate BillDate,SubCategoryID,SubCategoryName,0 Rate,");
                sb.Append(" @DiscountAmt*-1 Amount,@DiscountAmt DiscountAmt,CouponAmt,Quantity,DiscountByLab,0 IsRefund,0 IsReporting,1 IsActive,@BillType BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                sb.Append(" 0 SampleTypeID,'' SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                sb.Append(" CurrentSampleDept,ToSampleDept,0 UpdateID,'' UpdateName,'' UpdateRemarks,@ipAddress ipAddress,");
                sb.Append(" '' Barcode_Group,IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                sb.Append(" MachineID_Manual,IsScheduleRate,0 MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                sb.Append(" PackageMRPPercentage,PackageMRPNet,SRADate,@CreatedBy CreatedBy,@CreatedByID CreatedByID,@BaseCurrencyRound BaseCurrencyRound ");
                sb.Append(" FROM patient_labinvestigation_opd WHERE LedgerTransactionID=@LedgerTransactionID AND ItemID=@ItemID AND IsActive=1 AND IF(isPackage=1,`SubCategoryID`=15,`SubCategoryID`!=15) AND ");
                if (ploLocData.IsPackage == 1)
                {
                    sb.Append("  SubcategoryID=15 ");
                }
                else
                {
                    sb.Append(" SubcategoryID<>15 ");
                }
                sb.Append(" GROUP BY ItemID ");
                sb.Append(" )t ");
                int aa = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@LedgerTransactionID", LabID), new MySqlParameter("@ItemID", ploLocData.ItemId),
                        new MySqlParameter("@BillNo", DebitBillNo), new MySqlParameter("@BillDate", billDate),
                        new MySqlParameter("@BillType", BillType), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                        new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@DiscountAmt", ploLocData.DiscountAmt),

                        new MySqlParameter("@IsRefund", 0), new MySqlParameter("@IsReporting", 0), new MySqlParameter("@IsActive", 1),
                        new MySqlParameter("@BaseCurrencyRound", Resources.Resource.BaseCurrencyRound), new MySqlParameter("@ipAddress", StockReports.getip()));
            }

            sb = new StringBuilder();
            sb.Append(" INSERT INTO f_ledgertransaction_DiscountReason(LedgerTransactionID,LedgerTransactionNo,DiscountReason,CreatedByID,CreatedBy,BillNo,CreatedDate) ");
            sb.Append(" VALUES(@LedgerTransactionID,@LedgerTransactionNo,@DiscountReason,@CreatedByID,@CreatedBy,@BillNo,@CreatedDate)");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@LedgerTransactionID", LabID), new MySqlParameter("@LedgerTransactionNo", LabNo),
                        new MySqlParameter("@DiscountReason", DiscountReason.Trim()), new MySqlParameter("@CreatedByID", UserInfo.ID),
                        new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@BillNo", DebitBillNo),
                        new MySqlParameter("@CreatedDate", billDate));

            sb = new StringBuilder();
            sb.Append(" UPDATE f_ledgertransaction  ");
            sb.Append(" set DiscountOnTotal=@DiscountOnTotal, NetAmount=@NetAmount,  ");
            sb.Append(" DiscountID=@DiscountID, ");
            sb.Append(" DiscountApprovedByID=@DiscountApprovedByID, DiscountApprovedByName=@DiscountApprovedByName,  ");
            if (DiscountID.Trim() == "0")
            {
                sb.Append(" DiscountApprovedDate=now(),  ");
            }
            sb.Append(" UpdateID=@UpdateID,  UpdateName=@UpdateName,  UpdateRemarks='Discount After Bill',IsDiscountApproved=0  ");
            sb.Append(" where LedgerTransactionNo=@LedgerTransactionNo ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@DiscountOnTotal", DiscountAmount), new MySqlParameter("@NetAmount", NetAmount),
                new MySqlParameter("@DiscountID", DiscountID), new MySqlParameter("@DiscountApprovedByID", ApprovedByID.Trim()),
                new MySqlParameter("@DiscountApprovedByName", ApprovedByName.Trim()), new MySqlParameter("@UpdateID", UserInfo.ID),
                new MySqlParameter("@UpdateName", UserInfo.UserName), new MySqlParameter("@LedgerTransactionNo", LabNo.Trim()));

            sb = new StringBuilder();
            sb.Append(" INSERT INTO f_discountafterbill(LedgertransactionNo,LedgertransactionID,GrossAmount,DiscAmt,ApprovedBy,DiscReason,OldDiscAmt,Type,DiscountID,IpAddress,CreatedByID,CreatedBy,CreatedDate) ");
            sb.Append(" values (@LedgertransactionNo,@LedgertransactionID,@GrossAmount,@DiscAmt,@ApprovedBy,@DiscReason,@OldDiscAmt,'DiscountAfterBill',@DiscountID,@IpAddress,@CreatedByID,@CreatedBy,@CreatedDate)");
            sb.Append(" ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@LedgertransactionNo", Util.GetString(LabNo)), new MySqlParameter("@LedgertransactionID", LabID),
                new MySqlParameter("@GrossAmount", Util.GetDecimal(PrevBillAmount)),
                new MySqlParameter("@DiscAmt", ((DiscountAmount == Util.GetDecimal(PrevTotalDiscount)) ? 0 : DiscountAmount - Util.GetDecimal(PrevTotalDiscount))),
                new MySqlParameter("@ApprovedBy", ApprovedByID), new MySqlParameter("@DiscReason", DiscountReason),
                new MySqlParameter("@OldDiscAmt", PrevTotalDiscount), new MySqlParameter("@DiscountID", DiscountID),
                new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                new MySqlParameter("@CreatedDate", billDate), new MySqlParameter("@IpAddress", StockReports.getip()));

            Panel_Share ps = new Panel_Share();
            JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(LabID, tnx, con));
            if (IPS.status == false)
            {
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = IPS.response });
            }
            try
            {
                if (DiscountAmount > 0)
                {
                    using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT PName,Age,Gender,CentreID,GrossAmount,NetAmount FROM f_ledgertransaction WHERE LedgertransactionID=@LedgertransactionID",
                       new MySqlParameter("@LedgertransactionID", LabID)).Tables[0])
                    {
                        AllLoad_Data sd = new AllLoad_Data();
                        JSONResponse discApproval = JsonConvert.DeserializeObject<JSONResponse>(sd.sendDiscountVerificationMail(LabNo, dt.Rows[0]["PName"].ToString(), dt.Rows[0]["Age"].ToString(), dt.Rows[0]["Gender"].ToString(), Util.GetInt(ApprovedByID), Util.GetDecimal(dt.Rows[0]["GrossAmount"].ToString()), Util.GetDecimal(DiscountAmount), Util.GetDecimal(dt.Rows[0]["NetAmount"].ToString()), DiscountReason, Util.GetInt(dt.Rows[0]["CentreID"].ToString()), LabID, con, tnx));
                        if (discApproval.status == false)
                        {
                            tnx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = discApproval.response });
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Error in Discount Approval " });
            }

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,Remarks,OLDNAME,NEWNAME)VALUES(@LedgertransactionNo,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,now(),@DispatchCode,@Remarks,@OLDNAME,@NEWNAME) ",
                                                            new MySqlParameter("@LedgertransactionNo", LabNo.Trim()),                                        
                                                            new MySqlParameter("@Remarks", Util.GetString(DiscountReason).Trim()),
                                                             new MySqlParameter("@OLDNAME", ""),
                                                              new MySqlParameter("@NEWNAME", " Given Discount Amount is  " +((DiscountAmount == Util.GetDecimal(PrevTotalDiscount)) ? 0 : DiscountAmount - Util.GetDecimal(PrevTotalDiscount)) +"   Rs." ),
                                                            new MySqlParameter("@Status", "Discount After Bill  "), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                                                            new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = "true", LabID = Common.Encrypt(Util.GetString(LabID)) });
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.ToString()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class myPLO
    {
        public sbyte IsPackage { get; set; }
        public int ItemId { get; set; }
        public decimal Rate { get; set; }
        public decimal Amount { get; set; }
        public decimal DiscountAmt { get; set; }
        public sbyte ItemwiseDisc { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string removeDiscount(string LabNo, int LabID, string GrossAmount, string DiscAmtRemove)
    {
        if (LabNo.Trim() == string.Empty)
        {
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Lab No should not be blank" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (AllLoad_Data.IsInvoiceCreated(con, LabID) > 0)
            {
                return JsonConvert.SerializeObject(new { Status = false, ErrorMsg = "Invoice Created, So Refund not Possible" });
            }
            DateTime billDate = DateTime.Now;
            StringBuilder sb = new StringBuilder();
            int CentreID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CentreID FROM f_ledgertransaction WHERE LedgerTransactionID=@LedgerTransactionID ",
                 new MySqlParameter("@LedgerTransactionID", LabID)));

            if (CentreID != 0)
            {
                try
                {
                    string BillType = "Credit-Discount Removed";
                    string CreditBillNo = AllLoad_Data.getBillNo(CentreID, "C", con, tnx);
                    if (CreditBillNo == string.Empty)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "BillNo Error" });
                    }
                    //int[] Test_IDTags = dtTest_ID.AsEnumerable().Select(r => r.Field<int>("Test_ID")).ToArray();
                    //string[] Test_IDParamNames = Test_IDTags.Select((s, i) => "@tag" + i).ToArray();
                    //string ItemIDClause = string.Join(", ", Test_IDParamNames);

                    //sb = new StringBuilder();
                    //sb.Append(" UPDATE patient_labinvestigation_opd SET IsActive=0 WHERE Test_ID IN  ({0})  ");
                    //using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), ItemIDClause), con, tnx))
                    //{
                    //    for (int i = 0; i < Test_IDParamNames.Length; i++)
                    //    {
                    //        cmd.Parameters.Add(new MySqlParameter(Test_IDParamNames[i], Test_IDTags[i]));
                    //    }

                    //    cmd.ExecuteNonQuery();
                    //}

                    sb = new StringBuilder();
                    sb.Append("INSERT INTO patient_labinvestigation_opd(LedgerTransactionID,LedgerTransactionNo,BillNo,BarcodeNo,ItemId,ItemCode,ItemName,Investigation_ID,IsPackage,Date,SubCategoryID,SubCategoryName,Rate,");
                    sb.Append(" Amount,DiscountAmt,CouponAmt,Quantity,DiscountByLab,IsRefund,IsReporting,IsActive,BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                    sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                    sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                    sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                    sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                    sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                    sb.Append(" SampleTypeID,SampleTypeName,SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                    sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                    sb.Append(" CurrentSampleDept,ToSampleDept,UpdateID,UpdateName,UpdateRemarks,ipAddress,");
                    sb.Append(" Barcode_Group,IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                    sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                    sb.Append(" MachineID_Manual,IsScheduleRate,MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                    sb.Append(" PackageMRPPercentage,PackageMRPNet,SRADate,CreatedBy,CreatedByID,BaseCurrencyRound) ");
                    sb.Append(" ");
                    sb.Append(" SELECT LedgerTransactionID,LedgerTransactionNo,@BillNo,'',ItemId,ItemCode,ItemName,Investigation_ID,IsPackage,@BillDate,SubCategoryID,SubCategoryName,0 Rate,");
                    sb.Append(" SUM(DiscountAmt)Amount,SUM(DiscountAmt)*-1 DiscountAmt,CouponAmt,Quantity,DiscountByLab,0,0,1,@BillType,Patient_ID,AgeInDays,Gender,ReportType,CentreID,");
                    sb.Append(" CentreIDSession,TestCentreID,IsNormalResult,IsCriticalResult,PrintSeparate,isPartial_Result,Result_Flag,ResultEnteredBy,ResultEnteredDate,");
                    sb.Append(" ResultEnteredName,Approved,AutoApproved,MobileApproved,ApprovedBy,ApprovedDate,ApprovedName,ApprovedDoneBy,IsSampleCollected,SampleReceiveDate,");
                    sb.Append(" SampleReceivedBy,SampleReceiver,SampleBySelf,SampleCollectionBy,SampleCollector,SampleCollectionDate,isHold,HoldBy,HoldByName,");
                    sb.Append(" UnHoldBy,UnHoldByName,UnHoldDate,Hold_Reason,isForward,ForwardToCentre,ForwardToDoctor,ForwardBy,ForwardByName,ForwardDate,isPrint,IsFOReceive,");
                    sb.Append(" FOReceivedBy,FOReceivedByName,FOReceivedDate,IsDispatch,DispatchedBy,DispatchedByName,DispatchedDate,isUrgent,DeliveryDate,SlideNumber,");
                    sb.Append(" 0,'',SampleQty,LabOutsrcID,LabOutsrcName,LabOutSrcUserID,LabOutSrcBy,LabOutSrcDate,LabOutSrcRate,isHistoryReq,CPTCode,");
                    sb.Append(" isEmail,isRerun,ReRunReason,CombinationSample,");
                    sb.Append(" CurrentSampleDept,ToSampleDept,0,'','',@ipAddress,");
                    sb.Append(" '',IsLabOutSource,barcodePreprinted,CultureStatus,CultureStatusDate,reportNumber,HistoCytoSampleDetail,incubationDatetime,HistoCytoPerformingDoctor,HistoCytoStatus,");
                    sb.Append(" PackageName,PackageCode,ReRunDate,ReRunByID,ReRunByName,ItemID_Interface,Interface_companyName,CancelByInterface,");
                    sb.Append(" MachineID_Manual,IsScheduleRate,0 MRP,PackageRate,HoldType,PanelItemCode,PackageMRP,");
                    sb.Append(" PackageMRPPercentage,PackageMRPNet,SRADate,@CreatedBy,@CreatedByID,@BaseCurrencyRound ");
                    sb.Append(" FROM patient_labinvestigation_opd WHERE LedgerTransactionID =@LedgerTransactionID AND IsActive=1 GROUP BY ItemID    ");

                    using (MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx))
                    {
                        cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionID", LabID));
                        cmd.Parameters.Add(new MySqlParameter("@BillNo", CreditBillNo));
                        cmd.Parameters.Add(new MySqlParameter("@BillDate", billDate));
                        cmd.Parameters.Add(new MySqlParameter("@BillType", BillType));
                        cmd.Parameters.Add(new MySqlParameter("@CreatedBy", UserInfo.LoginName));
                        cmd.Parameters.Add(new MySqlParameter("@CreatedByID", UserInfo.ID));
                        cmd.Parameters.Add(new MySqlParameter("@BaseCurrencyRound", Resources.Resource.BaseCurrencyRound));
                        cmd.Parameters.Add(new MySqlParameter("@ipAddress", StockReports.getip()));
                        cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception ex)
                {
                    tnx.Rollback();
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                    return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "PLO Error" });
                }

                Panel_Share ps = new Panel_Share();
                JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(LabID, tnx, con));
                if (IPS.status == false)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = IPS.response });
                }

                sb = new StringBuilder();
                sb.Append(" UPDATE f_ledgertransaction SET DiscountID=0,DiscountOnTotal=0.00,NetAmount=GrossAmount,DiscountApprovedByID=0,DiscountApprovedByName='' WHERE `LedgerTransactionID`=@LedgerTransactionID");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@LedgerTransactionID", LabID));

                sb = new StringBuilder();
                sb.Append(" UPDATE f_discountafterbill SET IsActive=0 WHERE `LedgerTransactionID`=@LedgerTransactionID");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@LedgerTransactionID", LabID));

                sb = new StringBuilder();
                sb.Append(" INSERT INTO f_discount_remove_afterbill");
                sb.Append("(LedgertransactionNo,LedgertransactionID,GrossAmount,DiscAmtRemove,CreatedByID,CreatedBy,CreatedDate,IpAddress) ");
                sb.Append(" values(@LedgertransactionNo,@LedgertransactionID,@GrossAmount,@DiscAmtRemove,@CreatedByID,@CreatedBy,@CreatedDate,@IpAddress) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@LedgertransactionNo", LabNo), new MySqlParameter("@LedgertransactionID", LabID),
                   new MySqlParameter("@GrossAmount", GrossAmount), new MySqlParameter("@DiscAmtRemove", DiscAmtRemove),
                   new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                   new MySqlParameter("@CreatedDate", billDate), new MySqlParameter("@IpAddress", StockReports.getip()));

                sb = new StringBuilder();
                sb.Append("UPDATE f_ledgertransaction_discountreason SET IsActive=0 WHERE LedgertransactionID=@LedgertransactionID");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@LedgertransactionID", LabID));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode,Remarks,OLDNAME,NEWNAME)VALUES(@LedgertransactionNo,@Status,@UserID,@UserName,@IpAddress,@CentreID,@RoleID,now(),@DispatchCode,@Remarks,@OLDNAME,@NEWNAME) ",
                                                            new MySqlParameter("@LedgertransactionNo", LabNo.Trim()),
                                                            new MySqlParameter("@Remarks", "Remove  Discount Amount is  " + DiscAmtRemove +"  Rs."),
                                                             new MySqlParameter("@OLDNAME", ""),
                                                              new MySqlParameter("@NEWNAME", "Remove  Discount Amount is  " + DiscAmtRemove + "  Rs."),
                                                            new MySqlParameter("@Status", "Discount Remove  "), new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@UserName", UserInfo.LoginName),
                                                            new MySqlParameter("@IpAddress", StockReports.getip()), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@DispatchCode", string.Empty));
                tnx.Commit();
                return JsonConvert.SerializeObject(new { status = "true", LabID = Common.Encrypt(Util.GetString(LabID)) });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error" });
            }
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}