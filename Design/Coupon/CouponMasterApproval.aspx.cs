using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Coupon_CouponMasterApproval : System.Web.UI.Page
{
    public string approvaltypechecker = "0";
    public string approvaltypereject = "0";
    public string approvaltypeapproval = "0";
    public string approvaltypeedit = "0";
    public string approvaltypenotapproval = "0";

    protected void Page_Load(object sender, EventArgs e)
    {
        string dt = Util.GetString(StockReports.ExecuteScalar("SELECT IFNULL(GROUP_CONCAT(typename),0) FROM Coupan_approvalright WHERE apprightfor='Coupon' and active=1 AND employeeid='" + UserInfo.ID + "' "));
        if (dt != "0" || dt != "")
        {
            if (dt.Contains("Checker"))
            {
                approvaltypechecker = "1";
            }
            if (dt.Contains("Reject"))
            {
                approvaltypereject = "1";
            }
            if (dt.Contains("Approval"))
            {
                approvaltypeapproval = "1";
            }
            if (dt.Contains("Edit"))
            {
                approvaltypeedit = "1";
            }
            if (dt.Contains("NotApproval"))
            {
                approvaltypenotapproval = "1";
            }
        }

        if (!IsPostBack)
        {
            BindCouponCategory();
            BindCouponType();
        }
        txtentrydatefrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        txtentrydateto.Text = DateTime.Now.ToString("dd-MMM-yyyy");
    }

    public void BindCouponCategory()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,CoupanCategory FROM CoupanCategory_master");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            lblcouponcategory.Text += "<option value='" + dt.Rows[i]["ID"].ToString() + "'>" + dt.Rows[i]["CoupanCategory"].ToString() + "</option>";
        }
        ddlcouponcategory.DataSource = dt;
        ddlcouponcategory.DataTextField = "CoupanCategory";
        ddlcouponcategory.DataValueField = "ID";
        ddlcouponcategory.DataBind();
        ddlcouponcategory.Items.Insert(0, new ListItem("Select", "0"));
    }

    public void BindCouponType()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID,CoupanType FROM CoupanType_master");
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            lblcoupontype.Text += "<option value='" + dt.Rows[i]["ID"].ToString() + "'>" + dt.Rows[i]["CoupanType"].ToString() + "</option>";
        }
        ddlcoupontype.DataSource = dt;
        ddlcoupontype.DataValueField = "ID";
        ddlcoupontype.DataTextField = "CoupanType";
        ddlcoupontype.DataBind();
        ddlcoupontype.Items.Insert(0, new ListItem("Select", "0"));
    }

    [WebMethod]
    public static string SearchData(string fromdate, string todate, string status, string coupantype, string couponcategory, string coupanname)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT cm.coupanid,IFNULL(cc.LedgertransactionNo,'')LedgertransactionNo,cm.approved,cm.coupantypeid,cm.coupanname,cm.coupantype,cm.coupancategoryid,cm.coupancategory,DATE_FORMAT(cm.validfrom,'%d-%b-%Y')validfrom,DATE_FORMAT(cm.validto,'%d-%b-%Y')validto,cm.minbookingamount,cm.issuetype,");
        sb.Append("CASE WHEN TYPE=1 THEN 'Total Bill' ELSE 'Test Wise' END TYPE,if(type=1,cm.discountamount,0)discountamount,Remark,if(type=1,cm.discountpercentage,0)discountpercentage,ifnull(cm.ApplicableFor,'')ApplicableFor,CASE WHEN IsMultipleCouponApply=1 THEN 'Yes' ELSE 'No' END IsMultipleCouponApply,CASE WHEN WeekEnd=1 THEN 'WeekEnd' WHEN HappyHours=1 THEN 'HappyHours' ELSE '' END WeekEnd,DaysApplicable FROM coupan_master cm ");
        sb.Append("  INNER JOIN coupan_code cc  ON cc.coupanid=cm.coupanid ");
        sb.Append(" where cm.dtEntry>='" + Util.GetDateTime(fromdate).ToString("yyyy-MM-dd") + " 00:00:00' ");
        sb.Append(" AND cm.dtEntry<='" + Util.GetDateTime(todate).ToString("yyyy-MM-dd") + " 23:59:59' and  cm.isactive = 1");
        if (coupantype != "0")
        {
            sb.Append(" AND  cm.coupantypeid=" + coupantype + " ");
        }
        if (couponcategory != "0")
        {
            sb.Append(" AND  cm.coupancategoryid=" + couponcategory + " ");
        }
        if (coupanname != "")
        {
            sb.Append(" AND coupanname LIKE '%" + coupanname + "%' ");
        }
        if (status != "")
            sb.Append(" AND Approved=" + status + " ");

        sb.Append(" GROUP BY cm.coupanid ");

        return JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    [WebMethod(EnableSession = true)]
    public static string BindCenterModal(string CouponID)
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT Concat(pm.panel_code,'~',pm.company_name)Centre FROM `coupan_applicable_panel` CAC INNER JOIN f_panel_master pm ON CAC.panel_id=pm.panel_id WHERE CAC.CoupanID IN(" + CouponID + ")"));
    }

    [WebMethod(EnableSession = true)]
    public static string BindTestModal(string CouponID)
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT Concat(fi.TestCode,'~',fi.typename)typename,ct.discper,ct.discamount FROM f_itemmaster fi INNER JOIN coupan_testwise ct ON ct.itemid=fi.itemid WHERE coupanid IN(" + CouponID + ")"));
    }

    [WebMethod(EnableSession = true)]
    public static string BindCouponCodeModal(string CouponID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT coupancode FROM coupan_code WHERE CoupanID=@CouponID ",
                                                           new MySqlParameter("@CouponID", CouponID)).Tables[0]);
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
    [WebMethod(EnableSession = true)]
    public static string Approved(string CouponID, string Status)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (Status == "2")
            {
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update coupan_master set approved=@Status,ApprovedById=@ApprovedById,ApprovedByName=@ApprovedByName WHERE CoupanID=@CoupanID ",
                           new MySqlParameter("@Status", Status),
                           new MySqlParameter("@ApprovedById", UserInfo.ID),
                           new MySqlParameter("@ApprovedByName", UserInfo.LoginName),
                           new MySqlParameter("@CoupanID", CouponID));
                return "1#Coupan Approved Successfully";
            }
            else if (Status == "1")
            {
                // check coupon share is set or not
                DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, @"SELECT cm.type1,cm.coco_foco,centre,coupanid,pm1.company_name FROM `coupan_applicable_panel` cp
INNER JOIN centre_panel pm   ON cp.panel_id=pm.panelid
INNER JOIN centre_master cm ON cm.centreid=pm.centreid
INNER JOIN f_panel_master pm1 ON pm1.panel_id=cp.panel_id
WHERE  pm1.CentreType1ID in(8,16,17,2) AND cm.coco_foco='FOFO' AND CoupanID=@CoupanID ",
                                                                     new MySqlParameter("@CoupanID", CouponID)).Tables[0];

                if (dt.Rows.Count == 0)
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update coupan_master SET approved=@Status,CheckedById=@CheckedById,CheckedByName=@CheckedByName WHERE CoupanID=@CouponID ",
                                new MySqlParameter("@Status", Status),
                                new MySqlParameter("@CheckedById", UserInfo.ID),
                                new MySqlParameter("@CheckedByName", UserInfo.LoginName),
                                new MySqlParameter("@CouponID", CouponID));
                    return "1#Coupan Checked Successfully";
                }
                else
                {
                    int OneCouponOneMobileMultipleBilling = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT OneCouponOneMobileMultipleBilling FROM coupan_master WHERE coupanid=@CouponID",
                                                                                    new MySqlParameter("@CouponID", CouponID)));

                    if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_panel_share_items_coupon WHERE coupanid=@CouponID",
                                                new MySqlParameter("@CouponID", CouponID))) == 0 && OneCouponOneMobileMultipleBilling == 0)
                    {
                        return "0#Default % or Share is not set for this Coupon  in master";
                    }
                    else
                    {
                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update coupan_master set approved=@Status,CheckedById=@CheckedById,CheckedByName=@CheckedByName WHERE CoupanID=@CouponID ",
                                    new MySqlParameter("@Status", Status),
                                    new MySqlParameter("@CheckedById", UserInfo.ID),
                                    new MySqlParameter("@CheckedByName", UserInfo.LoginName),
                                    new MySqlParameter("@CouponID", CouponID));
                        return "1#Coupan Checked Successfully";
                    }
                }
            }
            else
            {
                if (Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select count(1) from coupan_code where CoupanID=@CouponID and LedgerTransactionNo<>''",
                                            new MySqlParameter("@CouponID", CouponID))) == 0)
                {
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "Update coupan_master set approved=0,NotApprovedByID=@NotApprovedByID,NotApprovedByName=@NotApprovedByName,NotApprovedBydate=now() WHERE CoupanID=@CouponID ",
                                new MySqlParameter("@NotApprovedByID", UserInfo.ID),
                                new MySqlParameter("@NotApprovedByName", UserInfo.LoginName),
                                new MySqlParameter("@CouponID", CouponID));
                    return "1#Coupan Not Approved Successfully";
                }
                else
                {
                    return "0#Coupan Already Used";
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0#" + Util.GetString(ex.Message);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string RejectCoupon(string CouponID, string Remark)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, @"SELECT cp.CoupanName,cp.approved,em.`Name` makername,em.`Email` makeremail,em1.`Name` checkername,em1.`Email` checkeremail,em2.`Name` rejectbyname FROM coupan_master cp
                                                        INNER JOIN employee_master em ON cp.`EntryById`=em.`Employee_ID` Left JOIN employee_master em1 ON em1.`Employee_ID`=cp.`CheckedById` Left JOIN employee_master em2 ON em2.`Employee_ID`=cp.`RejectById` where cp.CoupanID=@CouponID",
                                        new MySqlParameter("@CouponID", CouponID)).Tables[0];

            string EmailID = "";
            if (dt.Rows[0]["approved"].ToString() == "1")
            {
                EmailID = dt.Rows[0]["checkeremail"].ToString() + "," + dt.Rows[0]["makeremail"].ToString();
            }
            if (dt.Rows[0]["approved"].ToString() == "0")
            {
                EmailID = dt.Rows[0]["makeremail"].ToString();
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update coupan_master set approved=3,RejectById=@RejectById,RejectByName=@RejectByName,Remark=@Remark,RejectDate=now() WHERE CoupanID=@CouponID ",
                        new MySqlParameter("@RejectById", UserInfo.ID),
                        new MySqlParameter("@RejectByName", UserInfo.LoginName),
                        new MySqlParameter("@Remark", Remark),
                        new MySqlParameter("@CouponID", CouponID));
            if (EmailID != string.Empty)
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("<div> Dear All , </div>");
                sb.Append("<br/>");
                sb.AppendFormat(" Greetings from {0}", Resources.Resource.EmailSignature);
                sb.Append("<br/>"); sb.Append("<br/>");
                sb.Append("Please check Coupan Name <b>" + dt.Rows[0]["CoupanName"].ToString() + "</b>");
                sb.Append("<br/><br/><br/><br/>");
                sb.Append("Thanks & Regards,");
                sb.Append("<br/>");
                sb.AppendFormat("{0}", Resources.Resource.EmailSignature);
                sb.Append("<br/>");
            }
            tnx.Commit();
            return "Coupon Reject Successfully";
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

    [WebMethod(EnableSession = true)]
    public static string UpdateData(UpdateCoupan objupdate)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int Couponnameexist = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT count(1) FROM `coupan_master` where UPPER(CoupanName)=UPPER(@coupanname) ",
                                                          new MySqlParameter("@coupanname", objupdate.coupanName)));
            if (Couponnameexist > 0)
            {
                tnx.Rollback();
                return "Coupan Name Already Exist !!";
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update coupan_master set coupanname=@coupanname,coupantypeid=@coupantypeid,coupantype=@coupantype,coupancategory=@coupancategory,coupancategoryid=@coupancategoryid,validfrom=@validfrom,validto=@validto,updatedon=now(),updatedbyid=@updatedbyid,updatedbyname=@updatedbyname where coupanid=@coupanid",
          new MySqlParameter("@coupanname", objupdate.coupanName),
          new MySqlParameter("@coupantypeid", objupdate.coupanTypeId),
          new MySqlParameter("@coupantype", objupdate.coupanType),
          new MySqlParameter("@coupancategoryid", objupdate.coupanCategoryId),
          new MySqlParameter("@coupancategory", objupdate.coupanCategory),
          new MySqlParameter("@validfrom", Util.GetDateTime(objupdate.validFrom + " 00:00:00")),
          new MySqlParameter("@validto", Util.GetDateTime(objupdate.validTo + " 23:59:59")),
          new MySqlParameter("@updatedbyid", UserInfo.ID),
          new MySqlParameter("@updatedbyname", UserInfo.LoginName),
           new MySqlParameter("@coupanid", objupdate.coupanId)
            );

            tnx.Commit();
            return "Coupon Update Successfully";
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
    }
}