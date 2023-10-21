using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Coupon_LoyaltyCardSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
        }
    }
    [WebMethod]
    public static string LoyaltyCardSearch(string CouponCode, string MobileNo, string FromDate, string ToDate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT cpm.`CoupanType`, cpm.CoupanId,cpm.coupanName,cpm.coupanCategory,cc.Coupancode,IFNULL(cc.LedgerTransactionNo,'')LedgerTransactionNo,DATE_FORMAT(cpm.ValidFrom,'%d-%b-%Y')ValidFrom,DATE_FORMAT(cpm.validTo,'%d-%b-%Y')validTo,");
            sb.Append("IFNULL(cpm.MinBookingAmount,0)MinBookingAmount,IFNULL(cpm.DiscountPercentage,0)DiscountPercentage,cpm.IsMultipleCouponApply,");
            sb.Append("IFNULL(cpm.DiscountAmount,0)DiscountAmount,cpm.UHID,cpm.Mobile,cpm.Issuetype ");
            sb.Append(",IF(cpm.Type=1,'Total Bill','Test Wise')Applicable ,IFNULL(cpm.isused,0)isused,cpm.Type CouponType,cpm.WeekEnd,cpm.HappyHours,cpm.DaysApplicable,");
            sb.Append("cpm.IsOneTimePatientCoupon,cpm.OneCouponOneMobileMultipleBilling,cl.MobileNo,cl.LoyaltyCardNo,cl.ID LoyaltyID ");
            sb.Append(" FROM coupan_master cpm INNER JOIN coupan_code cc ON cpm.`CoupanId`=cc.CoupanId AND cc.IssueType='OneCoupanOneMobile' AND cc.MobileNo!=''");
            sb.Append(" INNER JOIN coupan_Loyalty cl ON cl.CoupanId=cpm.CoupanId AND cc.MobileNo=cl.MobileNo AND cl.IsActive=1");
            sb.Append(" WHERE cpm.approved=2 AND cpm.OneCouponOneMobileMultipleBilling=1 ");
            if (CouponCode != string.Empty)
                sb.Append(" AND cl.LoyaltyCardNo=@CouponCode ");
            if (MobileNo != string.Empty)
                sb.Append(" AND cl.MobileNo=@MobileNo ");
            if (CouponCode == string.Empty && MobileNo == string.Empty)
                sb.Append(" AND cl.CreatedDate>=@FromDate AND cl.CreatedDate<=@ToDate ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                               new MySqlParameter("@coupanCode", CouponCode),
                                               new MySqlParameter("@MobileNo", MobileNo),
                                               new MySqlParameter("@FromDate", string.Concat(Util.GetDateTime(FromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                               new MySqlParameter("@ToDate", string.Concat(Util.GetDateTime(ToDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return JsonConvert.SerializeObject(new { status = true, response = JsonConvert.SerializeObject(dt) });
                else
                    return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string RemoveLoyaltyCard(string CouponCode, string MobileNo, int ID, string CoupanId)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int chkCoupon = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_code_all WHERE IssueType='OneCoupanOneMobile' AND CoupanCode=@CoupanCode",
                                                    new MySqlParameter("@CoupanCode", CouponCode)));
            if (chkCoupon > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Coupon Already Used" });
            }
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE coupan_Loyalty SET IsActive=0,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,UpdatedDate=NOW() WHERE ID=@ID",
                                    new MySqlParameter("@ID", ID),
                                    new MySqlParameter("@UpdatedByID", UserInfo.ID),
                                    new MySqlParameter("@UpdatedBy", UserInfo.LoginName));
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE coupan_code SET MobileNo='' WHERE CoupanCode=@CoupanCode AND CoupanId=@CoupanId",
                            new MySqlParameter("@CoupanCode", CouponCode),
                            new MySqlParameter("@CoupanId", CoupanId));
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM coupan_Billtype WHERE Value=@Value AND CoupanId=@CoupanId AND Type=@Type",
                            new MySqlParameter("@Value", MobileNo),
                            new MySqlParameter("@Type", "OneCoupanOneMobile"),
                            new MySqlParameter("@CoupanId", CoupanId));
                tnx.Commit();
                return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
            }
            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                tnx.Rollback();
                return JsonConvert.SerializeObject(new { status = false, response = "Error" });

            }
            finally
            {
                tnx.Dispose();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {

            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string EditLoyaltyCardChk(string CouponCode)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int chkCoupon = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_code_all WHERE IssueType='OneCoupanOneMobile' AND CoupanCode=@CoupanCode",
                                                    new MySqlParameter("@CoupanCode", CouponCode)));
            if (chkCoupon > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Coupon Already Used" });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = true });
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {

            con.Close();
            con.Dispose();
        }

    }
    [WebMethod]
    public static string UpdateCouponDetail(string CouponCode, string MobileNo, string ID, string CoupanId, string NewMobileNo)
    {
        if (NewMobileNo.Trim().Length < 10)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Please Enter Valid Mobile No." });
        }
        if (MobileNo.Trim() == NewMobileNo.Trim())
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Old and New Mobile No. cannot be same" });
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int CoupanCodeCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE CoupanCode=@CoupanCode",
                                                              new MySqlParameter("@CoupanCode", CouponCode)));
            if (CoupanCodeCount == 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Coupan Code Not Exits" });
            }
            CoupanCodeCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE MobileNo=@MobileNo AND IssueType='OneCoupanOneMobile'",
                                                             new MySqlParameter("@MobileNo", NewMobileNo)));
            if (CoupanCodeCount > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Mobile No. :", NewMobileNo, " Already Mapped with Coupon Code") });
            }
            int chkCoupon = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM coupan_code_all WHERE IssueType='OneCoupanOneMobile' AND CoupanCode=@CoupanCode",
                                                    new MySqlParameter("@CoupanCode", CouponCode)));
            if (chkCoupon > 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Coupon Already Used" });
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT cm.`CoupanId`,cm.OneCouponOneMobileMultipleBilling,DATE_FORMAT(cm.ValidFrom,'%d-%b-%Y')ValidFrom,DATE_FORMAT(cm.validTo,'%d-%b-%Y')validTo,cc.MobileNo FROM coupan_master cm INNER JOIN coupan_code cc ON cm.`CoupanId`=cc.CoupanId WHERE cc.coupanCode=@coupanCode AND cm.approved=2 and cm.OneCouponOneMobileMultipleBilling=1 AND cc.IssueType='OneCoupanOneMobile' ",
                                              new MySqlParameter("@CoupanCode", CouponCode)).Tables[0])
            {

                if (dt.Rows.Count > 0)
                {
                    int MobileNoCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM coupan_Loyalty WHERE MobileNo=@MobileNo AND IsActive=1",
                                                                new MySqlParameter("@MobileNo", NewMobileNo)));
                    if (MobileNoCount > 0)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Mobile No. ", dt.Rows[0]["MobileNo"].ToString(), " Already Mapped with Coupon Code") });
                    }
                    if (dt.Rows[0]["MobileNo"].ToString() == NewMobileNo)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Mobile No. ", dt.Rows[0]["MobileNo"].ToString(), " Already Mapped with Coupon Code") });
                    }
                    if (dt.Rows[0]["CoupanId"].ToString() != CoupanId)
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "CoupanId Mismatch" });
                    }
                    if (DateTime.Now > Util.GetDateTime(string.Concat(dt.Rows[0]["validTo"].ToString(), " 23:59:59")))
                    {
                        return JsonConvert.SerializeObject(new { status = false, response = "Coupon is Expired" });
                    }
                }
                else
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Coupon Not Found. Please Enter Valid Coupon Code" });
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE coupan_Loyalty SET IsActive=0,UpdatedByID=@UpdatedByID,UpdatedBy=@UpdatedBy,UpdatedDate=NOW() WHERE ID=@ID",
                                   new MySqlParameter("@ID", ID),
                                   new MySqlParameter("@UpdatedByID", UserInfo.ID),
                                   new MySqlParameter("@UpdatedBy", UserInfo.LoginName));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM coupan_Billtype WHERE Value=@Value AND CoupanId=@CoupanId AND Type=@Type",
                            new MySqlParameter("@Value", MobileNo),
                            new MySqlParameter("@Type", "OneCoupanOneMobile"),
                            new MySqlParameter("@CoupanId", dt.Rows[0]["CoupanId"].ToString()));

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO coupan_Billtype(CoupanId,Type,Value)VALUES(@CoupanId,@Type,@Value)",
                                new MySqlParameter("@CoupanId", dt.Rows[0]["CoupanId"].ToString()),
                                new MySqlParameter("@Type", "OneCoupanOneMobile"),
                                new MySqlParameter("@Value", NewMobileNo));
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO coupan_Loyalty(CoupanId,LoyaltyCardNo,MobileNo,CreatedByID,CreatedBy,CentreID)VALUES(@CoupanId,@LoyaltyCardNo,@MobileNo,@CreatedByID,@CreatedBy,@CentreID)",
                            new MySqlParameter("@CoupanId", dt.Rows[0]["CoupanId"].ToString()),
                            new MySqlParameter("@LoyaltyCardNo", CouponCode),
                            new MySqlParameter("@MobileNo", NewMobileNo),
                            new MySqlParameter("@CreatedByID", UserInfo.ID),
                            new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                            new MySqlParameter("@CentreID", UserInfo.Centre));
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE coupan_code SET MobileNo=@MobileNo WHERE CoupanCode=@CoupanCode AND CoupanId=@CoupanId",
                            new MySqlParameter("@CoupanId", dt.Rows[0]["CoupanId"].ToString()),
                            new MySqlParameter("@MobileNo", NewMobileNo),
                            new MySqlParameter("@CoupanCode", CouponCode));
                tnx.Commit();
            }

            return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });

        }
        finally
        {
            tnx.Dispose();
        }
    }
}