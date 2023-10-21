using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Camp_CampRequestMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtStartDate, txtEndDate);
            bindCampMaster();
            if (Util.GetString(Request.QueryString["ID"]) != string.Empty)
            {
                bindCampDetail(Request.QueryString["ID"].ToString());
            }
            else
            {
                bindDefaultPanel();

                calEndDate.StartDate = DateTime.Now;
                calStartDate.StartDate = DateTime.Now;

            }
        }
        txtStartDate.Attributes.Add("readOnly", "readOnly");
        txtEndDate.Attributes.Add("readOnly", "readOnly");

    }
    public void bindCampMaster()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,CampName FROM camp_request_master WHERE IsActive=1").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlCamp.DataSource = dt;
                    ddlCamp.DataTextField = "CampName";
                    ddlCamp.DataValueField = "ID";
                    ddlCamp.DataBind();

                }

                ddlCamp.Items.Insert(0, new ListItem("Select", "0"));
                ddlCamp.Items.Insert(dt.Rows.Count + 1, new ListItem("Other", "-1"));

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
    public void bindDefaultPanel()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT cm.CountryID, cm.stateid,cm.BusinessZoneID,pn.`Company_Name` ,CONCAT(pn.`Panel_ID`,'#',pn.ReferenceCodeOPD,'#',cm.CentreID,'#',pn.Panelid_mrp) Panel_ID ");
            sb.Append("   FROM Centre_Panel cp   ");
            sb.Append("  INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id  ");
            sb.Append("  INNER JOIN `centre_master` cm ON cm.`CentreID`=cp.`CentreId`  ");
            sb.Append("  AND cm.centreid =@CentreID ");
            sb.Append("  AND cp.isActive=1 AND pn.isActive=1  AND cp.IsCamp=0 AND pn.PanelType='Centre'");
            sb.Append("  ORDER BY pn.company_name  ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                 new MySqlParameter("@CentreID", UserInfo.Centre)
                                 ).Tables[0])
                if (dt.Rows.Count > 0)
                {
                    ddlPanel.DataSource = dt;
                    ddlPanel.DataTextField = "Company_Name";
                    ddlPanel.DataValueField = "Panel_ID";
                    ddlPanel.DataBind();
                    if (dt.Rows.Count > 1)
                    {
                        ddlPanel.Items.Insert(0, new ListItem("Select", "0"));
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

    public class CampRequestData
    {
        public int CampID { get; set; }
        public string CampName { get; set; }
        public string CampCoordinator { get; set; }
        public string CampAddress { get; set; }
        public string ContactNo { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int CentreID { get; set; }
        public int Panel_ID { get; set; }
        public int? ID { get; set; }
        public int CampTypeID { get; set; }
        public string CampType { get; set; }
    }
    public static string toFinancialYear(DateTime curDate)
    {
        string CurrentYear = curDate.ToString("yy");
        string PreviousYear = curDate.AddYears(-1).ToString("yy");
        string NextYear = curDate.AddYears(+1).ToString("yy");
        string FinYear = string.Empty;
        if (curDate.Month > 3)
        {
            FinYear = string.Concat(CurrentYear, "-", NextYear);
        }
        else
        {
            FinYear = string.Concat(PreviousYear, "-", CurrentYear);
        }
        return FinYear;
    }
    [WebMethod(EnableSession = true)]
    public static string SaveCampRequest(List<CampRequestData> CR, List<Patient_Lab_InvestigationOPD> CI, int IsAllowTinySms, int IsSendTinySmsBill)
    {
        if (CR[0].StartDate > CR[0].EndDate)
        {
            return JsonConvert.SerializeObject(new { Status = false, response = "Camp Start Date cannot greater then End Date", responseDetail = string.Empty, focusControl = "txtEndDate" });

        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            
            int CampName = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM camp_request WHERE ((StartDate BETWEEN @StartDate AND @EndDate) OR (EndDate BETWEEN @StartDate AND @EndDate)) AND Panel_ID=@Panel_ID and IsActive=1 AND CampTypeID=@CampTypeID",
                                                   new MySqlParameter("@StartDate", Util.GetDateTime(CR[0].StartDate).ToString("yyyy-MM-dd")),
                                                   new MySqlParameter("@EndDate", Util.GetDateTime(CR[0].EndDate).ToString("yyyy-MM-dd")),
                                                   new MySqlParameter("@Panel_ID", CR[0].Panel_ID),
                                                   new MySqlParameter("@CampTypeID", CR[0].CampTypeID)));

            if (CampName > 0)
            {
                return JsonConvert.SerializeObject(new { Status = false, response = string.Concat("Camp Already Created in Date :", Util.GetDateTime(CR[0].StartDate).ToString("dd-MMM-yyyy")), focusControl = "txtCampName" });

            }
            if (CR[0].CampTypeID == 1)
            {
                using (DataTable dtFreeCampTest = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT camp.ID,camp.ItemID,im.testcode FROM camp_freetest_master camp INNER JOIN f_itemmaster im ON im.ItemID=camp.ItemID WHERE camp.isActive=1 AND im.isActive=1").Tables[0])
                {
                    List<Patient_Lab_InvestigationOPD> FreeCampTest = new List<Patient_Lab_InvestigationOPD>();
                    FreeCampTest = (from DataRow row in dtFreeCampTest.Rows
                                    select new Patient_Lab_InvestigationOPD
                                    {
                                        ItemId = Util.GetInt(row["ItemID"].ToString()),
                                        ItemCode = Util.GetString(row["testcode"].ToString()),
                                    }).ToList();

                    HashSet<int> CampTestIDs = new HashSet<int>(FreeCampTest.Select(s => s.ItemId));
                    var getUnmatchedItemID = CI.Where(m => !CampTestIDs.Contains(m.ItemId)).ToList();
                    if (getUnmatchedItemID.Count() > 0)
                    {
                        return JsonConvert.SerializeObject(new { Status = false, response = string.Concat("Free Camp Test Code :", string.Join(",", getUnmatchedItemID.Select(s => s.ItemCode).ToArray()), " Mismatch with Master") });

                    }
                }
            }
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string FinancialYear = toFinancialYear(Util.GetDateTime(CR[0].StartDate));

                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT ca.Panel_ID ClientID, ");
                sb.Append(" IFNULL(ca.FinancialYear,'')FinancialYear,");
                sb.Append(" IFNULL(ca.AprCount,0)`Apr`,IFNULL(ca.MayCount,0)`May`,IFNULL(ca.JunCount,0)`Jun`,IFNULL(ca.JulCount,0)`Jul`,IFNULL(ca.AugCount,0)`Aug`,");
                sb.Append(" IFNULL(ca.SepCount,0)`Sep`,IFNULL(ca.OctCount,0)`Oct`,IFNULL(ca.NovCount,0)`Nov`,IFNULL(ca.DecCount,0)`Dec`,IFNULL(ca.JanCount,0)`Jan`,");
                sb.Append(" IFNULL(ca.FebCount,0)`Feb`,IFNULL(ca.MarCount,0)`Mar` ");
                sb.Append(" FROM camp_configurationmaster ca WHERE ca.IsActive=1");
                sb.Append("  AND ca.Panel_ID=@Panel_ID AND ca.FinancialYear=@FinancialYear");
                using (DataTable dtCamp = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                      new MySqlParameter("@Panel_ID", CR[0].Panel_ID),
                                                      new MySqlParameter("@FinancialYear", FinancialYear)).Tables[0])
                {
                    if (dtCamp.Rows.Count == 0)
                    {
                        return JsonConvert.SerializeObject(new { Status = false, response = "Camp Creation Count Not Set" });
                    }
                    else
                    {
                        int campCreated = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM camp_request WHERE Panel_ID=@Panel_ID AND IsActive=1 AND MONTH(StartDate)=MONTH(@StartDate)",
                                                                  new MySqlParameter("@StartDate", Util.GetDateTime(CR[0].StartDate).ToString("yyyy-MM-dd")),
                                                                  new MySqlParameter("@Panel_ID", CR[0].Panel_ID)));

                        string StartMonth = Util.GetDateTime(CR[0].StartDate).ToString("MMM");
                        int CampApprovedCount = Util.GetInt(dtCamp.Rows[0][StartMonth].ToString());
                        if (campCreated + 1 > CampApprovedCount)
                        {
                            return JsonConvert.SerializeObject(new { Status = false, response = "Maximum Camp Creation Count Exceed" });
                        }
                    }
                    sb = new StringBuilder();
                    sb.Append(" INSERT INTO camp_request(CampID,CampName,Address,Mobile,Contact_Person,CreatedByID,CreatedBy,StartDate,EndDate,CentreID,Panel_ID,CampTypeID,CampType");
                    if (CR[0].CampTypeID == 1)
                    {
                        sb.Append(" ,IsApproved,ApprovedByID,ApprovedBy,ApprovedDate");
                    }
                    sb.Append(" )VALUES(@CampID,@CampName,@Address,@Mobile,@Contact_Person,@CreatedByID,@CreatedBy,@StartDate,@EndDate,@CentreID,@Panel_ID,@CampTypeID,@CampType");
                    if (CR[0].CampTypeID == 1)
                    {
                        sb.Append(" ,1,@CreatedByID,@CreatedBy,NOW()");
                    }
                    sb.Append(" )");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@CampID", CR[0].CampID),
                                new MySqlParameter("@CampName", CR[0].CampName),
                                new MySqlParameter("@Address", CR[0].CampAddress),
                                new MySqlParameter("@Mobile", CR[0].ContactNo),
                                new MySqlParameter("@Contact_Person", CR[0].CampCoordinator),
                                new MySqlParameter("@CreatedByID", UserInfo.ID),
                                new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                                new MySqlParameter("@StartDate", CR[0].StartDate),
                                new MySqlParameter("@EndDate", CR[0].EndDate),
                                new MySqlParameter("@CentreID", CR[0].CentreID),
                                new MySqlParameter("@Panel_ID", CR[0].Panel_ID),
                                new MySqlParameter("@CampTypeID", CR[0].CampTypeID),
                                new MySqlParameter("@CampType", CR[0].CampType));
                    int RequestID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));
                    for (int i = 0; i < CI.Count; i++)
                    {
                        sb = new StringBuilder();
                        sb.Append(" INSERT INTO camp_request_ItemDetail(RequestID,ItemId,RequestedRate) ");
                        sb.Append(" VALUES(@RequestID,@ItemId,@RequestedRate)");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@RequestID", RequestID),
                                    new MySqlParameter("@ItemId", CI[i].ItemId),
                                    new MySqlParameter("@RequestedRate", CI[i].Rate));
                    }

                   // if (CR[0].CampTypeID == 1)
                   // {
                        PanelMaster objPanel = new PanelMaster(tnx);
                        objPanel.Company_Name = CR[0].CampName.ToUpper();
                        objPanel.PanelGroup = "Walk-In";
                        objPanel.PanelType = "Camp";
                        objPanel.SecurityDeposit = "0";
                        objPanel.MinBalReceive = "0";
                        objPanel.IsActive = 1;
                        objPanel.PanelGroupID = 1;
                        objPanel.Payment_Mode = "Cash";
                        objPanel.CentreType1 = "Camp";
                        objPanel.CentreType1ID = 0;
                        objPanel.SavingType = "FOFO";
                        objPanel.CreatedBy = UserInfo.LoginName;
                        objPanel.ReportDispatchMode = "BOTH";
                        objPanel.LabReportLimit = "0";
                        objPanel.IntimationLimit = "0";
                        objPanel.BarCodePrintedType = "System";
                        objPanel.Country = "INDIA";
                        objPanel.CountryID = 14;
                        objPanel.IsInvoice=1;
                        objPanel.Panel_Code = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CONCAT('CAMP',LPAD(IFNULL( MAX(REPLACE(Panel_Code,'CAMP','')),'')+1,4,'0')) FROM f_panel_master WHERE paneltype='Camp'").ToString();
                        string Panel_ID = objPanel.Insert();

                        using (DataTable TagBusinessLabDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT TagBusinessLabID,TagBusinessLab,InvoiceTo,CentreID FROM f_panel_master WHERE Panel_ID=@Panel_ID",
                                                                       new MySqlParameter("@Panel_ID", CR[0].Panel_ID)).Tables[0])
                        {

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET RequestedCamp_ID=@RequestedCamp_ID,CampTypeID=@CampTypeID,ReferenceCode=@PanelID,ReferenceCodeOPD=@PanelID,TagBusinessLab=@TagBusinessLab,TagBusinessLabId=@TagBusinessLabId,InvoiceTo=@InvoiceTo,CentreID=@CentreID  WHERE Panel_ID=@PanelID",
                                        new MySqlParameter("@PanelID", Panel_ID),
                                        new MySqlParameter("@RequestedCamp_ID", RequestID),
                                        new MySqlParameter("@CampTypeID", CR[0].CampTypeID),
                                        new MySqlParameter("@InvoiceTo", TagBusinessLabDetail.Rows[0]["InvoiceTo"].ToString()),
                                        new MySqlParameter("@CentreID", TagBusinessLabDetail.Rows[0]["CentreID"].ToString()),
                                        new MySqlParameter("@TagBusinessLab", TagBusinessLabDetail.Rows[0]["TagBusinessLab"].ToString()),
                                        new MySqlParameter("@TagBusinessLabId", TagBusinessLabDetail.Rows[0]["TagBusinessLabId"].ToString()));
                        }



                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO centre_panel(CentreID,PanelID,dtEntry,UserID,FromCampValidityDate,ToCampValidityDate,IsCamp)VALUES(@CentreID,@PanelID,NOW(),@ID,@FromDate,@Todate,1)",
                                    new MySqlParameter("@CentreID", CR[0].CentreID),
                                    new MySqlParameter("@PanelID", Panel_ID),
                                    new MySqlParameter("@ID", UserInfo.ID),
                                    new MySqlParameter("@FromDate", Util.GetDateTime(CR[0].StartDate).ToString("yyyy-MM-dd")),
                                    new MySqlParameter("@Todate", Util.GetDateTime(CR[0].EndDate).ToString("yyyy-MM-dd")));

                        for (int i = 0; i < CI.Count; i++)
                        {
                            RateList rl = new RateList(tnx);
                            rl.ItemID = Util.GetInt(CI[i].ItemId);
                            rl.Panel_ID = Util.GetInt(Panel_ID);
                            rl.Rate = Util.GetDecimal(CI[i].Rate);
                            rl.ERate = Util.GetDecimal(CI[i].Rate);
                            rl.IsCurrent = 1;
                            rl.FromDate = Util.GetDateTime(CR[0].StartDate);
                            rl.IsService = "YES";
                            rl.UpdateBy = Util.GetString(UserInfo.LoginName);
                            rl.UpdateRemarks = "Camp ";
                            rl.ItemDisplayName = CI[i].ItemName;
                            rl.UpdateDate = DateTime.Now;
                            rl.RateType = "LSP";
                            string RateListID = rl.Insert();
                        }

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE camp_request SET IsCreated=1,CampCreatedByID=@CampCreatedByID,CampCreatedBy=@CampCreatedBy,CampCreatedDate=NOW(),CampCreatedPanel_ID=@CampCreatedPanel_ID WHERE ID=@ID",
                                    new MySqlParameter("@CampCreatedByID", UserInfo.ID),
                                    new MySqlParameter("@CampCreatedBy", UserInfo.LoginName),
                                    new MySqlParameter("@CampCreatedPanel_ID", Panel_ID),
                                    new MySqlParameter("@ID", RequestID));

                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET AllowTinySMS=@AllowTinySMS,IsSendTinySMSBill=@IsSendTinySMSBill,SampleRecollectAfterReject=1 WHERE Panel_ID=@PanelID ",
                     new MySqlParameter("@AllowTinySMS", IsAllowTinySms),
                     new MySqlParameter("@IsSendTinySMSBill", IsSendTinySmsBill),
                     new MySqlParameter("@PanelID", Panel_ID));
                    //}

                  
                    tnx.Commit();
                    return JsonConvert.SerializeObject(new { Status = "true", response = "Record Saved Successfully", FromDate = DateTime.Now.ToString("dd-MMM-yyyy"), ToDate = DateTime.Now.ToString("dd-MMM-yyyy") });
                }
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { Status = false, response = "Error" });

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
            return JsonConvert.SerializeObject(new { Status = false, response = "Error" });
        }
        finally
        {

            con.Close();
            con.Dispose();
        }

    }
    private void bindCampDetail(string ID)
    {
        ID = Common.DecryptRijndael(ID.Replace(" ", "+"));
        lblCampID.Text = ID;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT cr.CampName,cr.Address,cr.Mobile,cr.Contact_Person,cr.CreatedBy,DATE_FORMAT(cr.StartDate,'%d-%b-%Y')StartDate,DATE_FORMAT(cr.EndDate,'%d-%b-%Y')EndDate,");
            sb.Append(" CONCAT(fpm.`Panel_ID`,'#',fpm.ReferenceCodeOPD,'#',fpm.CentreID,'#',fpm.Panelid_mrp)Panel_ID,fpm.Company_Name,cr.CampTypeID,cr.CampID ");
            sb.Append(" FROM camp_request cr ");
            sb.Append(" INNER JOIN f_Panel_Master fpm on fpm.Panel_ID=cr.Panel_ID  ");
            sb.Append(" WHERE cr.IsApproved=0 AND cr.ID=@ID  AND cr.IsActive=1"); //AND cr.IsCreated=0
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@ID", ID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    lblHeader.Text = "Camp Request Approval";
                    txtCampName.Text = dt.Rows[0]["CampName"].ToString();
                    txtCampCoOrdinator.Text = dt.Rows[0]["Contact_Person"].ToString();
                    txtCampAddress.Text = dt.Rows[0]["Address"].ToString();
                    txtCampContactNo.Text = dt.Rows[0]["Mobile"].ToString();
                    txtStartDate.Text = dt.Rows[0]["StartDate"].ToString();
                    txtEndDate.Text = dt.Rows[0]["EndDate"].ToString();
                    List<string> CampDetail = new List<string>();
                    CampDetail.Add(dt.Rows[0]["Panel_ID"].ToString());
                    CampDetail.Add(dt.Rows[0]["Company_Name"].ToString());
                    CampDetail.Add(dt.Rows[0]["CampTypeID"].ToString());
                    CampDetail.Add(dt.Rows[0]["CampID"].ToString());
                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    ScriptManager.RegisterStartupScript(this, GetType(), "myFunction", "bindCampRequestDetail('" + serializer.Serialize(CampDetail) + "');", true);

                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());

        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string GetCampItemDetails(int ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT crd.ID,crd.ItemID,IFNULL(crd.RequestedRate,0)RequestedRate,IFNULL(rat.Rate,0)Rate");
            sb.Append(" FROM camp_request_ItemDetail crd ");
            sb.Append(" INNER JOIN camp_request cr ON cr.ID=crd.RequestID INNER JOIN f_panel_master fpm ON fpm.Panel_ID=cr.Panel_ID");
            sb.Append(" Left JOIN f_ratelist rat on rat.ItemID=crd.ItemID AND rat.Panel_ID=fpm.ReferenceCode ");
            sb.Append("  WHERE crd.RequestID=@ID AND crd.IsActive=1");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                        new MySqlParameter("@ID", ID)).Tables[0]);



        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string RejectCampRequest(List<CampRequestData> CR, string RejectReason)
    {
        if (RejectReason == string.Empty)
        {
            return JsonConvert.SerializeObject(new { Status = false, response = "Please Enter Reject Reason" });

        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE camp_request SET IsActive=0,DeActivatedByID=@DeActivatedByID,DeActivatedBy=@DeActivatedBy,DeActivatedDate=NOW(),RejectReason=@RejectReason WHERE ID=@ID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@DeActivatedByID", UserInfo.ID),
                        new MySqlParameter("@DeActivatedBy", UserInfo.LoginName),
                        new MySqlParameter("@ID", CR[0].ID),
                        new MySqlParameter("@RejectReason", RejectReason));
            tnx.Commit();
            return JsonConvert.SerializeObject(new { Status = "true", response = "Camp Rejected Successfully", FromDate = DateTime.Now.ToString("dd-MMM-yyyy"), ToDate = DateTime.Now.ToString("dd-MMM-yyyy") });

        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { Status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string ApproveCampRequest(List<CampRequestData> CR, List<Patient_Lab_InvestigationOPD> CI)
    {
        if (CR[0].StartDate > CR[0].EndDate)
        {
            return JsonConvert.SerializeObject(new { Status = false, response = "Camp Start Date cannot greater then End Date", focusControl = "txtEndDate" });

        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int CampName = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM camp_request WHERE CampName=@CampName AND ID!=@ID AND IsApproved=0",
                                                   new MySqlParameter("@CampName", CR[0].CampName),
                                                   new MySqlParameter("@ID", CR[0].ID)));
            if (CampName > 0)
            {
                return JsonConvert.SerializeObject(new { Status = false, response = "Camp Name Already Exits", focusControl = "txtCampName" });

            }
            CampName = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM f_panel_master WHERE Company_Name=@Company_Name",
                                                   new MySqlParameter("@Company_Name", CR[0].CampName)));
            if (CampName > 0)
            {
                return JsonConvert.SerializeObject(new { Status = false, response = "Camp Name Already Exits", focusControl = "txtCampName" });
            }
            MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
            try
            {
                string FinancialYear = toFinancialYear(Util.GetDateTime(CR[0].StartDate));
                StringBuilder sb = new StringBuilder();
                sb.Append("SELECT ca.Panel_ID ClientID, ");
                sb.Append(" IFNULL(ca.FinancialYear,'')FinancialYear,");
                sb.Append(" IFNULL(ca.AprCount,0)`Apr`,IFNULL(ca.MayCount,0)`May`,IFNULL(ca.JunCount,0)`Jun`,IFNULL(ca.JulCount,0)`Jul`,IFNULL(ca.AugCount,0)`Aug`,");
                sb.Append(" IFNULL(ca.SepCount,0)`Sep`,IFNULL(ca.OctCount,0)`Oct`,IFNULL(ca.NovCount,0)`Nov`,IFNULL(ca.DecCount,0)`Dec`,IFNULL(ca.JanCount,0)`Jan`,");
                sb.Append(" IFNULL(ca.FebCount,0)`Feb`,IFNULL(ca.MarCount,0)`Mar` ");
                sb.Append(" FROM camp_configurationmaster ca WHERE ca.IsActive=1");
                sb.Append("  AND ca.Panel_ID=@Panel_ID AND ca.FinancialYear=@FinancialYear");
                using (DataTable dtCamp = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                      new MySqlParameter("@Panel_ID", CR[0].Panel_ID),
                                                      new MySqlParameter("@FinancialYear", FinancialYear)).Tables[0])
                {
                    if (dtCamp.Rows.Count == 0)
                    {
                        return JsonConvert.SerializeObject(new { Status = false, response = "Camp Creation Count Not Set" });
                    }
                    else
                    {
                        int campCreated = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM camp_request WHERE Panel_ID=@Panel_ID AND IsActive=1 AND MONTH(StartDate)=MONTH(@StartDate) AND ID!=@ID",
                                                                  new MySqlParameter("@StartDate", Util.GetDateTime(CR[0].StartDate).ToString("yyyy-MM-dd")),
                                                                  new MySqlParameter("@Panel_ID", CR[0].Panel_ID),
                                                                  new MySqlParameter("@ID", CR[0].ID)));

                        string StartMonth = Util.GetDateTime(CR[0].StartDate).ToString("MMM");
                        int CampApprovedCount = Util.GetInt(dtCamp.Rows[0][StartMonth].ToString());
                        if (campCreated + 1 > CampApprovedCount)
                        {
                            return JsonConvert.SerializeObject(new { Status = false, response = "Maximum Camp Creation Count Exceed" });
                        }
                    }
                    sb = new StringBuilder();
                    sb.Append(" UPDATE camp_request SET CampName=@CampName,Address=@Address,Mobile=@Mobile,Contact_Person=@Contact_Person,");
                    sb.Append(" StartDate=@StartDate,EndDate=@EndDate,IsApproved=1,ApprovedByID=@ApprovedByID,ApprovedBy=@ApprovedBy,ApprovedDate=NOW() WHERE ID=@ID");
                    sb.Append(" ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                new MySqlParameter("@CampName", CR[0].CampName),
                                new MySqlParameter("@Address", CR[0].CampAddress),
                                new MySqlParameter("@Mobile", CR[0].ContactNo),
                                new MySqlParameter("@Contact_Person", CR[0].CampCoordinator),
                                new MySqlParameter("@ApprovedByID", UserInfo.ID),
                                new MySqlParameter("@ApprovedBy", UserInfo.LoginName),
                                new MySqlParameter("@StartDate", CR[0].StartDate),
                                new MySqlParameter("@EndDate", CR[0].EndDate),
                                new MySqlParameter("@ID", CR[0].ID));
                    sb = new StringBuilder();
                    sb.Append(" SELECT ID,ItemID,RequestedRate,ApprovedRate,ItemID,IsActive ");
                    sb.Append(" FROM camp_request_ItemDetail WHERE RequestID=@ID");
                    DataTable dtCampItem = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                       new MySqlParameter("@ID", CR[0].ID)).Tables[0];

                    var CampItemDetail = dtCampItem.AsEnumerable().Select(i => new
            {
                ID = i.Field<Int32>("ID"),
                ItemID = i.Field<Int32>("ItemID"),
                IsActive = i.Field<sbyte>("IsActive")
            }).ToList();


                    var DeactiveID = CampItemDetail.Except(CampItemDetail.Where(o => CI.Select(s => s.ItemId).ToList().Contains(o.ItemID))).ToList();
                    if (DeactiveID.Count > 0)
                    {
                        sb = new StringBuilder();
                        sb.Append(" UPDATE camp_request_ItemDetail SET IsActive=0,DeActivatedByID=@DeActivatedByID,DeActivatedBy=@DeActivatedBy,DeActivatedDate=NOW()");
                        sb.Append("  WHERE ID IN (" + string.Join(",", DeactiveID) + ")");
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@DeActivatedByID", UserInfo.ID),
                                    new MySqlParameter("@DeActivatedBy", UserInfo.LoginName));
                    }

                    for (int i = 0; i < CI.Count; i++)
                    {
                        if (dtCampItem.AsEnumerable().Where(s => s.Field<Int32>("ItemID") == Util.GetInt(CI[i].ItemId)).Count() > 0)
                        {
                            sb = new StringBuilder();
                            sb.Append(" UPDATE camp_request_ItemDetail SET ApprovedRate=@ApprovedRate");
                            sb.Append("  WHERE ItemId=@ItemId AND RequestID=@RequestID ");
                        }
                        else
                        {
                            sb = new StringBuilder();
                            sb.Append(" INSERT INTO camp_request_ItemDetail(RequestID,ItemId,RequestedRate,ApprovedRate,IsApprovalEntry) ");
                            sb.Append(" VALUES(@RequestID,@ItemId,@RequestedRate,@ApprovedRate,1)");
                        }
                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                       new MySqlParameter("@RequestID", CR[0].ID),
                                       new MySqlParameter("@ItemId", CI[i].ItemId),
                                       new MySqlParameter("@RequestedRate", CI[i].Rate),
                                       new MySqlParameter("@ApprovedRate", CI[i].Rate));
                    }
                    tnx.Commit();
                    return JsonConvert.SerializeObject(new { Status = "true", response = "Camp Approved Successfully", FromDate = DateTime.Now.ToString("dd-MMM-yyyy"), ToDate = DateTime.Now.ToString("dd-MMM-yyyy") });
                }
            }
            catch (Exception ex)
            {
                tnx.Rollback();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
                return JsonConvert.SerializeObject(new { Status = false, response = "Error" });

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
            return JsonConvert.SerializeObject(new { Status = false, response = "Error" });
        }
        finally
        {

            con.Close();
            con.Dispose();
        }

    }
    [WebMethod(EnableSession = true)]
    public static string FreeCampDetail(int Panel_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT camp.ID,im.ItemID,im.testCode,IFNULL(rat.Rate,0)Rate,im.typeName FROM camp_freetest_master camp  ");
            sb.Append(" INNER JOIN f_itemmaster im ON camp.ItemID=im.ItemID ");
            sb.Append(" LEFT JOIN f_ratelist rat ON rat.ItemID=im.ItemID AND rat.Panel_ID=@Panel_ID ");
            sb.Append(" WHERE camp.IsActive=1 AND im.IsActive=1");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                              new MySqlParameter("@Panel_ID", Panel_ID)).Tables[0])
                return JsonConvert.SerializeObject(new { Status = true, response = Util.getJson(dt) });
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { Status = false, response = "Error" });
        }
        finally
        {

            con.Close();
            con.Dispose();
        }

    }
}