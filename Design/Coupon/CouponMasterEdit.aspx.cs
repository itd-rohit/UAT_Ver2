using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.Services;
using System.Web.UI;

public partial class Design_Coupon_CouponMasterEdit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            calFromDate.StartDate = DateTime.Now;
            if (Request.QueryString["CouponId"] != null && Request.QueryString["CouponId"] != "")
            {
                string CouponId = Request.QueryString["CouponId"].ToString();

                if (CouponId != "")
                {
                    BindData(CouponId);
                }
            }
        }
    }

    public void BindData(string Coupanid)
    {
        DataTable dtcoupondata = StockReports.GetDataTable("SELECT coupanid,coupanName,CoupanTypeid,CoupanType,CoupanCategoryid,CoupanCategory,DATE_FORMAT(validfrom,'%d-%b-%Y')validfrom,DATE_FORMAT(validto,'%d-%b-%Y')validto,`MinBookingAmount`,`ApplicableFor`,`IsMultipleCouponApply`,IsMultiplePatientCoupon,IsOneTimePatientCoupon,WeekEnd,HappyHours,DaysApplicable,OneCouponOneMobileMultipleBilling FROM coupan_master where coupanid=" + Coupanid + "");
        if (dtcoupondata.Rows.Count > 0)
        {
            txtCouponName.Text = dtcoupondata.Rows[0]["coupanName"].ToString();
            txtentrydatefrom.Text = dtcoupondata.Rows[0]["validfrom"].ToString();
            txtentrydateto.Text = dtcoupondata.Rows[0]["validto"].ToString();
            txtminbooking.Text = dtcoupondata.Rows[0]["MinBookingAmount"].ToString();
            if (dtcoupondata.Rows[0]["IsMultipleCouponApply"].ToString() == "1")
            {
                chkmulticoupon.Checked = true;
            }
            else
            {
                chkmulticoupon.Checked = false;
            }
            if (dtcoupondata.Rows[0]["OneCouponOneMobileMultipleBilling"].ToString() == "1")
            {
                chkOneCouponOneMobile.Checked = true;
            }
            else
            {
                chkOneCouponOneMobile.Checked = false;
            }
            string[] Allapplicable = dtcoupondata.Rows[0]["ApplicableFor"].ToString().Split(',');
            for (int j = 0; j < Allapplicable.Length; j++)
            {
                for (int i = 0; i < chkapplicable.Items.Count; i++)
                {
                    if (chkapplicable.Items[i].Value == Allapplicable[j])
                    {
                        chkapplicable.Items[i].Selected = true;
                    }
                }
            }
            string coupontype = dtcoupondata.Rows[0]["CoupanType"].ToString();
            ListCouponType.DataSource = StockReports.GetDataTable("SELECT ID,CoupanType FROM CoupanType_master");
            ListCouponType.DataValueField = "ID";
            ListCouponType.DataTextField = "CoupanType";
            ListCouponType.DataBind();
            for (int j = 0; j < ListCouponType.Items.Count; j++)
            {
                if (ListCouponType.Items[j].Value == dtcoupondata.Rows[0]["CoupanTypeid"].ToString())
                {
                    ListCouponType.Items[j].Selected = true;
                }
            }

            ListCouponCategory.DataSource = StockReports.GetDataTable("SELECT ID,CoupanCategory FROM CoupanCategory_master ");
            ListCouponCategory.DataValueField = "ID";
            ListCouponCategory.DataTextField = "CoupanCategory";
            ListCouponCategory.DataBind();
            for (int j = 0; j < ListCouponCategory.Items.Count; j++)
            {
                if (ListCouponCategory.Items[j].Value == dtcoupondata.Rows[0]["CoupanCategoryid"].ToString())
                {
                    ListCouponCategory.Items[j].Selected = true;
                }
            }

            lblcoupanid.Text = Coupanid;

            if (dtcoupondata.Rows[0]["IsMultiplePatientCoupon"].ToString() == "1")
            {
                chkMultiplePatient.Checked = true;
            }
            else
            {
                chkMultiplePatient.Checked = false;
            }
            if (dtcoupondata.Rows[0]["IsOneTimePatientCoupon"].ToString() == "1")
            {
                chkOneTimePatient.Checked = true;
            }
            else
            {
                chkOneTimePatient.Checked = false;
            }

            if (dtcoupondata.Rows[0]["WeekEnd"].ToString() == "1")
            {
                chkWeekEnd.Checked = true;
            }
            else
            {
                chkWeekEnd.Checked = false;
            }
            if (dtcoupondata.Rows[0]["HappyHours"].ToString() == "1")
            {
                chkHappyHours.Checked = true;
            }
            else
            {
                chkHappyHours.Checked = false;
            }
            chkmulticoupon.Attributes.Add("disabled", "disabled");
            chkMultiplePatient.Attributes.Add("disabled", "disabled");
            chkOneTimePatient.Attributes.Add("disabled", "disabled");
            chkWeekEnd.Attributes.Add("disabled", "disabled");
            chkHappyHours.Attributes.Add("disabled", "disabled");
            List<string> DaysApplicable = dtcoupondata.Rows[0]["DaysApplicable"].ToString().Split(',').ToList();
            for (int j = 0; j < DaysApplicable.Count; j++)
            {
                for (int i = 0; i < chklDaysApplicable.Items.Count; i++)
                {
                    if (chklDaysApplicable.Items[i].Value == DaysApplicable[j])
                    {
                        chklDaysApplicable.Items[i].Selected = true;
                    }
                }
            }
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script10", "showHappyHours();", true);
        }
    }

    [WebMethod(EnableSession = true)]
    public static string UpdateData(UpdateCoupan objupdate, List<AllData> Allitem)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int Couponnameexist = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT count(1) FROM `coupan_master` where UPPER(CoupanName)=UPPER('" + objupdate.coupanName + "') and coupanid<>" + objupdate.coupanId + " "));
            if (Couponnameexist > 0)
            {
                tnx.Rollback();
                return "Coupan Name Already Exist !!";
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update coupan_master set coupanname=@coupanname,coupantypeid=@coupantypeid,coupantype=@coupantype,coupancategory=@coupancategory,coupancategoryid=@coupancategoryid,validfrom=@validfrom,validto=@validto,MinBookingAmount=@MinBookingAmount,ApplicableFor=@ApplicableFor,IsMultipleCouponApply=@IsMultipleCouponApply,updatedon=now(),updatedbyid=@updatedbyid,updatedbyname=@updatedbyname,type=@type,discountamount=@discountamount,discountpercentage=@discountpercentage,DaysApplicable=@DaysApplicable where coupanid=@coupanid",
                        new MySqlParameter("@coupanname", objupdate.coupanName),
                        new MySqlParameter("@coupantypeid", objupdate.coupanTypeId),
                        new MySqlParameter("@coupantype", objupdate.coupanType),
                        new MySqlParameter("@coupancategoryid", objupdate.coupanCategoryId),
                        new MySqlParameter("@coupancategory", objupdate.coupanCategory),
                        new MySqlParameter("@validfrom", Util.GetDateTime(objupdate.validFrom + " 00:00:00")),
                        new MySqlParameter("@validto", Util.GetDateTime(objupdate.validTo + " 23:59:59")),
                        new MySqlParameter("@MinBookingAmount", objupdate.MinBillAmount),
                        new MySqlParameter("@ApplicableFor", objupdate.ApplicableFor.TrimEnd(',')),
                        new MySqlParameter("@IsMultipleCouponApply", objupdate.IsmultipleApply),
                        new MySqlParameter("@updatedbyid", UserInfo.ID),
                        new MySqlParameter("@updatedbyname", UserInfo.LoginName),
                        new MySqlParameter("@type", objupdate.billtype),
                        new MySqlParameter("@discountamount", objupdate.discountamount),
                        new MySqlParameter("@discountpercentage", objupdate.discountpercent),
                        new MySqlParameter("@coupanid", objupdate.coupanId),
                        new MySqlParameter("@DaysApplicable", objupdate.DaysApplicable.TrimEnd(',')));

            objupdate.Center = objupdate.Center.TrimEnd(',');
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from Coupan_Applicable_panel WHERE coupanid=@coupanid",
                        new MySqlParameter("@coupanid", objupdate.coupanId));

            List<string> Rows = new List<string>();

            StringBuilder Command = new StringBuilder();
            Command.Append("insert into Coupan_Applicable_panel(CoupanId,panel_id) values ");
            for (int i = 0; i < objupdate.Center.Split(',').Length; i++)
            {
                Command.Append(" (");
                Command.Append("'" + objupdate.coupanId + "',");
                Command.Append("'" + objupdate.Center.Split(',')[i] + "'");
                Command.Append(" ),");
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Command.ToString().Trim().TrimEnd(','));

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from coupan_testwise where coupanid=@coupanid",
                        new MySqlParameter("@coupanid", objupdate.coupanId));

            if (objupdate.billtype == "2")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("INSERT INTO Coupan_TestWise(coupanid,subcategoryid,itemid,discper,DiscAmount) VALUES ");
                foreach (var data in Allitem)
                {
                    int coupanId = Util.GetInt(objupdate.coupanId);
                    int SubcategoryId = Util.GetInt(data.subcategoryids);
                    int itemid = Util.GetInt(data.items);
                    double DiscPer = Util.GetDouble(data.discountpercent);
                    double DiscAmount = Util.GetDouble(data.discountamount);
                    sb.Append(" (" + coupanId + "," + SubcategoryId + "," + itemid + "," + DiscPer + "," + DiscAmount + "),");
                }
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString().Trim().TrimEnd(','));
            }
            tnx.Commit();
            return "Coupan Update Successfully";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.Message);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string BindCenterData(string coupanid)
    {
        DataTable dt = StockReports.GetDataTable("SELECT pm.panel_id centreid,CONCAT(pm.`panel_code`,'~',pm.company_name)centre FROM `coupan_applicable_panel` cac INNER JOIN f_panel_master pm ON pm.panel_id=cac.panel_id where cac.coupanid=" + coupanid + " ");
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    [WebMethod]
    public static string BindCouponDetail(string coupanid)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("");
        sb.Append(" SELECT cp.type,cp.discountamount,cp.discountpercentage,cp.issuetype,cp.uhid,cp.mobile, ");
        sb.Append(" ct.`DiscAmount`,ct.`DiscPer`,ct.`ItemId`,ct.`SubCategoryId`, ");
        sb.Append(" im.`TestCode`,im.`TypeName`,sm.`Name` department ");
        sb.Append(" FROM coupan_master cp ");
        sb.Append(" LEFT JOIN coupan_testwise ct ON cp.`CoupanId`=ct.`CoupanId` ");
        sb.Append(" LEFT JOIN f_itemmaster im ON im.`ItemID`=ct.`ItemId` ");
        sb.Append(" LEFT JOIN `f_subcategorymaster` sm ON sm.`SubCategoryID`=ct.`SubCategoryId` ");
        sb.Append(" WHERE cp.CoupanId='" + coupanid + "'");
        return JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    public class UpdateCoupan
    {
        public int coupanId { get; set; }
        public string coupanName { get; set; }
        public int coupanTypeId { get; set; }
        public string coupanType { get; set; }
        public int coupanCategoryId { get; set; }
        public string coupanCategory { get; set; }
        public string validFrom { get; set; }
        public string validTo { get; set; }
        public string Center { get; set; }
        public string MinBillAmount { get; set; }
        public string ApplicableFor { get; set; }
        public string IsmultipleApply { get; set; }
        public string discountpercent { get; set; }
        public string discountamount { get; set; }
        public string billtype { get; set; }
        public string Issuefor { get; set; }
        public string Mobile { get; set; }
        public string UHID { get; set; }
        public string DaysApplicable { get; set; }
    }

    public class AllData
    {
        public string subcategoryids { get; set; }
        public string items { get; set; }
        public string discountpercent { get; set; }
        public string discountamount { get; set; }
    }
}