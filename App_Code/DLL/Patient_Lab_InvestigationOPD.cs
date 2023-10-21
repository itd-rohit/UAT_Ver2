using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;


/// <summary>
/// Summary description for Patient_Lab_InvestigationOPD
/// </summary>
public class Patient_Lab_InvestigationOPD
{
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;
    public Patient_Lab_InvestigationOPD()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Patient_Lab_InvestigationOPD(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }

    public int LedgerTransactionID { get; set; }
    public string LedgerTransactionNo { get; set; }
    public string BarcodeNo { get; set; }
    public int ItemId { get; set; }
    public string ItemName { get; set; }
    public int Investigation_ID { get; set; }
    public byte IsPackage { get; set; }
    public int SubCategoryID { get; set; }
    public decimal Rate { get; set; }
    public decimal Amount { get; set; }
    public decimal DiscountAmt { get; set; }
    public decimal CouponAmt { get; set; }
    public decimal PayByPanel { get; set; }
    public decimal PayByPanelPercentage { get; set; }
    public decimal PayByPatient { get; set; }
    public SByte Quantity { get; set; }
    public Byte DiscountByLab { get; set; }
    public SByte IsRefund { get; set; }
    public Byte IsReporting { get; set; }
    public string Patient_ID { get; set; }
    public int AgeInDays { get; set; }
    public string Gender { get; set; }
    public Byte ReportType { get; set; }
    public int CentreID { get; set; }
    public int TestCentreID { get; set; }
    public string IsSampleCollected { get; set; }
    public int SampleBySelf { get; set; }
    public DateTime SampleCollectionDate { get; set; }
    public int SampleCollectionBy { get; set; }
    public string SampleCollector { get; set; }
    public Byte? isUrgent { get; set; }
    public DateTime DeliveryDate { get; set; }

    public string ipaddress { get; set; }
    public Byte barcodePreprinted { get; set; }
    public int SampleTypeID { get; set; }
    public string SampleTypeName { get; set; }
    public string PackageName { get; set; }
    public string PackageCode { get; set; }
    public string ItemID_Interface { get; set; }
    public string Interface_companyName { get; set; }
    public Byte? IsScheduleRate { get; set; }
    public decimal MRP { get; set; }
    public DateTime Date { get; set; }
    public Byte? IsReflexTest { get; set; }
    public DateTime SampleCollectionDate_Interface { get; set; }
    public DateTime SRADate { get; set; }
    public string Interface_PackageCategoryID { get; set; }
    public string Interface_SampleTypeID { get; set; }
    public decimal PackageMRP { get; set; }
    public decimal PackageMRPPercentage { get; set; }
    public decimal PackageMRPNet { get; set; }
    public string PanelItemCode { get; set; }
    public string RequiredAttachment { get; set; }
    public string RequiredAttachmentID { get; set; }
    public string BillNo { get; set; }
    public string BillType { get; set; }
    public Byte IsActive { get; set; }
    public int CreatedByID { get; set; }
    public string CreatedBy { get; set; }
    public string ItemCode { get; set; }
    public Byte BaseCurrencyRound { get; set; }
    public decimal BaseRate { get; set; }
    public string EncryptedRate { get; set; }
    public string EncryptedAmount { get; set; }
    public string EncryptedDiscAmt { get; set; }
    public string EncryptedItemID { get; set; }
    public string EncryptedMRP { get; set; }
    public int IsSampleCollectedByPatient { get; set; }
    public string DepartmentDisplayName { get; set; }
    public int DepartmentTokenNo { get; set; }

    public Byte? IsMemberShipFreeTest { get; set; }
    public decimal? MemberShipDisc { get; set; }
    public int? MemberShipTableID { get; set; }
    public Byte? IsMemberShipDisc { get; set; }
    public string SubCategoryName { get; set; }
    public string UniqueID { get; set; }
    public Decimal ClientPatientRate { get; set; }
    public int? Interface_CompanyID { get; set; }
    public string LedgerTransactionNo_Interface { get; set; }
    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Lab_InvestigationOPD");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlParameter paramTnxID = new MySqlParameter() { ParameterName = "@testid", MySqlDbType = MySqlDbType.Int32, Size = 20, Direction = ParameterDirection.Output };
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans) { CommandType = CommandType.StoredProcedure };


            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionID", LedgerTransactionID));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo", LedgerTransactionNo.ToUpper()));
            cmd.Parameters.Add(new MySqlParameter("@BarcodeNo", Util.GetString(BarcodeNo)));
            cmd.Parameters.Add(new MySqlParameter("@ItemId", ItemId));
            cmd.Parameters.Add(new MySqlParameter("@ItemName", Util.GetString(ItemName)));
            cmd.Parameters.Add(new MySqlParameter("@Investigation_ID", Util.GetInt(Investigation_ID)));
            cmd.Parameters.Add(new MySqlParameter("@IsPackage", IsPackage));
            cmd.Parameters.Add(new MySqlParameter("@SubCategoryID", SubCategoryID));
            cmd.Parameters.Add(new MySqlParameter("@Rate", Rate));
            cmd.Parameters.Add(new MySqlParameter("@Amount", Amount));
            cmd.Parameters.Add(new MySqlParameter("@DiscountAmt", DiscountAmt));
            cmd.Parameters.Add(new MySqlParameter("@CouponAmt", Util.GetDecimal(CouponAmt)));
            cmd.Parameters.Add(new MySqlParameter("@PayByPanel", Util.GetDecimal(PayByPanel)));
            cmd.Parameters.Add(new MySqlParameter("@PayByPanelPercentage", Util.GetDecimal(PayByPanelPercentage)));
            cmd.Parameters.Add(new MySqlParameter("@PayByPatient", Util.GetDecimal(PayByPatient)));
            cmd.Parameters.Add(new MySqlParameter("@Quantity", Quantity));
            cmd.Parameters.Add(new MySqlParameter("@DiscountByLab", Util.GetInt(DiscountByLab)));
            cmd.Parameters.Add(new MySqlParameter("@IsRefund", IsRefund));
            cmd.Parameters.Add(new MySqlParameter("@IsReporting", IsReporting));
            cmd.Parameters.Add(new MySqlParameter("@Patient_ID", Patient_ID));
            cmd.Parameters.Add(new MySqlParameter("@AgeInDays", Util.GetInt(AgeInDays)));
            cmd.Parameters.Add(new MySqlParameter("@Gender", Gender));
            cmd.Parameters.Add(new MySqlParameter("@ReportType", ReportType));
            cmd.Parameters.Add(new MySqlParameter("@CentreID", CentreID));
            if (Util.GetString(ItemID_Interface) == string.Empty)
                cmd.Parameters.Add(new MySqlParameter("@CentreIDSession", UserInfo.Centre));
            else
                cmd.Parameters.Add(new MySqlParameter("@CentreIDSession", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@TestCentreID", Util.GetInt(TestCentreID)));
            cmd.Parameters.Add(new MySqlParameter("@IsSampleCollected", Util.GetString(IsSampleCollected)));
            cmd.Parameters.Add(new MySqlParameter("@SampleBySelf", Util.GetInt(SampleBySelf)));
            cmd.Parameters.Add(new MySqlParameter("@isUrgent", isUrgent));
            cmd.Parameters.Add(new MySqlParameter("@DeliveryDate", Util.GetDateTime(DeliveryDate)));

            cmd.Parameters.Add(new MySqlParameter("@ipaddress", Util.GetString(StockReports.getip())));
            cmd.Parameters.Add(new MySqlParameter("@SampleCollectionDate", Util.GetDateTime(SampleCollectionDate)));
            cmd.Parameters.Add(new MySqlParameter("@SampleCollectionBy", Util.GetInt(SampleCollectionBy)));
            cmd.Parameters.Add(new MySqlParameter("@SampleCollector", Util.GetString(SampleCollector)));
            cmd.Parameters.Add(new MySqlParameter("@barcodePreprinted", Util.GetInt(barcodePreprinted)));
            cmd.Parameters.Add(new MySqlParameter("@SampleTypeID", Util.GetString(SampleTypeID)));
            cmd.Parameters.Add(new MySqlParameter("@SampleTypeName", Util.GetString(SampleTypeName)));
            cmd.Parameters.Add(new MySqlParameter("@PackageName", Util.GetString(PackageName)));
            cmd.Parameters.Add(new MySqlParameter("@PackageCode", Util.GetString(PackageCode)));
            cmd.Parameters.Add(new MySqlParameter("@ItemID_Interface", Util.GetString(ItemID_Interface)));
            cmd.Parameters.Add(new MySqlParameter("@Interface_companyName", Util.GetString(Interface_companyName)));
            cmd.Parameters.Add(new MySqlParameter("@IsScheduleRate", IsScheduleRate));
            cmd.Parameters.Add(new MySqlParameter("@MRP", Util.GetDecimal(MRP)));
            cmd.Parameters.Add(new MySqlParameter("@vDate", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@IsReflexTest", IsReflexTest));
            cmd.Parameters.Add(new MySqlParameter("@SampleCollectionDate_Interface", Util.GetDateTime(SampleCollectionDate_Interface)));
            cmd.Parameters.Add(new MySqlParameter("@SRADate", Util.GetDateTime(SRADate)));
            cmd.Parameters.Add(new MySqlParameter("@Interface_PackageCategoryID", Util.GetString(Interface_PackageCategoryID)));
            cmd.Parameters.Add(new MySqlParameter("@Interface_SampleTypeID", Util.GetString(Interface_SampleTypeID)));
            cmd.Parameters.Add(new MySqlParameter("@PackageMRP", Util.GetFloat(PackageMRP)));
            cmd.Parameters.Add(new MySqlParameter("@PackageMRPPercentage", Util.GetDecimal(PackageMRPPercentage)));
            cmd.Parameters.Add(new MySqlParameter("@PackageMRPNet", Util.GetDecimal(PackageMRPNet)));
            cmd.Parameters.Add(new MySqlParameter("@PanelItemCode", Util.GetString(PanelItemCode)));

            cmd.Parameters.Add(new MySqlParameter("@BillNo", BillNo));
            cmd.Parameters.Add(new MySqlParameter("@BillType", Util.GetString(BillType)));
            cmd.Parameters.Add(new MySqlParameter("@IsActive", IsActive));

            cmd.Parameters.Add(new MySqlParameter("@CreatedBy", CreatedBy));
            cmd.Parameters.Add(new MySqlParameter("@CreatedByID", CreatedByID));
            cmd.Parameters.Add(new MySqlParameter("@ItemCode", Util.GetString(ItemCode)));
            cmd.Parameters.Add(new MySqlParameter("@BaseCurrencyRound", BaseCurrencyRound));
            cmd.Parameters.Add(new MySqlParameter("@IsSampleCollectedByPatient", IsSampleCollectedByPatient));
            cmd.Parameters.Add(new MySqlParameter("@DepartmentTokenNo", DepartmentTokenNo));

            cmd.Parameters.Add(new MySqlParameter("@IsMemberShipFreeTest", Util.GetByte(IsMemberShipFreeTest)));
            cmd.Parameters.Add(new MySqlParameter("@MemberShipDisc", Util.GetDecimal(MemberShipDisc)));
            cmd.Parameters.Add(new MySqlParameter("@MemberShipTableID", Util.GetInt(MemberShipTableID)));
            cmd.Parameters.Add(new MySqlParameter("@IsMemberShipDisc", Util.GetByte(IsMemberShipDisc)));
            cmd.Parameters.Add(new MySqlParameter("@SubCategoryName", Util.GetString(SubCategoryName)));

            cmd.Parameters.Add(new MySqlParameter("@UniqueID", Util.GetString(UniqueID)));
            cmd.Parameters.Add(new MySqlParameter("@ClientPatientRate", Util.GetDecimal(ClientPatientRate)));
            cmd.Parameters.Add(new MySqlParameter("@Interface_CompanyID", Util.GetInt(Interface_CompanyID)));
            cmd.Parameters.Add(new MySqlParameter("@LedgerTransactionNo_Interface", Util.GetString(LedgerTransactionNo_Interface)));
            cmd.Parameters.Add(paramTnxID);
            string id = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return id;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            // Util.WriteLog(ex);
            throw (ex);
        }
    }


}