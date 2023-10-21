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

public partial class Design_Coupon_LoyaltyCard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string saveLoyaltyCard(string CouponCode, string MobileNo)
    {
        try
        {
            //if (CouponCode.Trim().Length < 12)
            //{
            //    return JsonConvert.SerializeObject(new { status = false, response = "Please Enter Valid Loyalty Card No." });
            //}
            if (MobileNo.Trim().Length < 10)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Please Enter Mobile No." });
            }
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                int CoupanCodeCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE CoupanCode=@CoupanCode AND IssueType='OneCoupanOneMobile'",
                                                              new MySqlParameter("@CoupanCode", CouponCode)));
                if (CoupanCodeCount == 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Coupan Code Not Exits" });
                }
                CoupanCodeCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM coupan_code WHERE MobileNo=@MobileNo AND IssueType='OneCoupanOneMobile'",
                                                             new MySqlParameter("@MobileNo", MobileNo)));
                if (CoupanCodeCount > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Mobile No. Already Mapped with Coupon Code" });
                }
                using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT cm.`CoupanId`,cm.OneCouponOneMobileMultipleBilling,DATE_FORMAT(cm.ValidFrom,'%d-%b-%Y')ValidFrom,DATE_FORMAT(cm.validTo,'%d-%b-%Y')validTo,cc.MobileNo FROM coupan_master cm INNER JOIN coupan_code cc ON cm.`CoupanId`=cc.CoupanId WHERE cc.coupanCode=@coupanCode AND cm.approved=2 and cm.OneCouponOneMobileMultipleBilling=1 AND cc.IssueType='OneCoupanOneMobile' ",
                                                  new MySqlParameter("@CoupanCode", CouponCode)).Tables[0])
                {

                    if (dt.Rows.Count > 0)
                    {
                        int MobileNoCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM coupan_Loyalty WHERE MobileNo=@MobileNo AND IsActive=1",
                                                                    new MySqlParameter("@MobileNo", MobileNo)));
                        if (MobileNoCount > 0)
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = "Mobile No. Already Mapped with Coupon Code" });
                        }
                        if (dt.Rows[0]["MobileNo"].ToString() != string.Empty)
                        {
                            return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Mobile No. ", dt.Rows[0]["MobileNo"].ToString(), " Already Mapped with Coupon Code") });
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
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO coupan_Billtype(CoupanId,Type,Value)VALUES(@CoupanId,@Type,@Value)",
                                new MySqlParameter("@CoupanId", dt.Rows[0]["CoupanId"].ToString()),
                                new MySqlParameter("@Type", "OneCoupanOneMobile"),
                                new MySqlParameter("@Value", MobileNo));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO coupan_Loyalty(CoupanId,LoyaltyCardNo,MobileNo,CreatedByID,CreatedBy,CentreID)VALUES(@CoupanId,@LoyaltyCardNo,@MobileNo,@CreatedByID,@CreatedBy,@CentreID)",
                                new MySqlParameter("@CoupanId", dt.Rows[0]["CoupanId"].ToString()),
                                new MySqlParameter("@LoyaltyCardNo", CouponCode),
                                new MySqlParameter("@MobileNo", MobileNo),
                                new MySqlParameter("@CreatedByID", UserInfo.ID),
                                new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                                new MySqlParameter("@CentreID", UserInfo.Centre));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE coupan_code SET MobileNo=@MobileNo WHERE CoupanCode=@CoupanCode AND CoupanId=@CoupanId",
                                new MySqlParameter("@CoupanId", dt.Rows[0]["CoupanId"].ToString()),
                                new MySqlParameter("@MobileNo", MobileNo),
                                new MySqlParameter("@CoupanCode", CouponCode));
                    tnx.Commit();
                    return JsonConvert.SerializeObject(new { status = true, response = "Record Saved Successfully" });
                }
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
                con.Close();
                con.Dispose();
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
    }
}