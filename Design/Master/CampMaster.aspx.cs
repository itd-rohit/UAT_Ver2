using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.UI;
public partial class Design_Master_CampMaster : System.Web.UI.Page
{
    private static StringBuilder sb = new StringBuilder();

    protected void Page_Load(object sender, EventArgs e)
    {
        string cmd = Util.GetString(Request.QueryString["cmd"]);
        string rtrn = "";

        if (cmd == "GetTestList")
        {
            rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(GetTestList());
            Response.Clear();
            Response.ContentType = "application/json; charset=utf-8";
            Response.Write(rtrn);
            Response.End();

            return;
        }

        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

            lblCurrentDate.Text = System.DateTime.Now.ToString("DD/MM/YYYY h:mm a");
            BindTagBusinessLab();
            if (Util.GetString(Request.QueryString["ID"]) != string.Empty)
            {
                bindCampDetail(Request.QueryString["ID"].ToString().Replace(" ", "+"));
            }
            else
            {
                lblCampRequestID.Text = "0";
                calFromDate.StartDate = DateTime.Now;
                calToDate.StartDate = DateTime.Now;
            }
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }


    private void BindTagBusinessLab()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT  cm.`CentreID`,cm.`Centre` FROM centre_master cm  WHERE cm.IsActive=1 AND Category='Lab' ORDER BY centre"))
        {
            if (dt.Rows.Count > 0)
            {
                ddlTagBusinessLab.DataSource = dt;
                ddlTagBusinessLab.DataTextField = "Centre";
                ddlTagBusinessLab.DataValueField = "CentreID";
                ddlTagBusinessLab.DataBind();
            }
            ddlTagBusinessLab.Items.Insert(0, new ListItem("Select", "-1"));
        }
    }

    [WebMethod]
    public static string getCampDetail(string Panel_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb = new StringBuilder();
            sb.Append(" SELECT pm.Panel_Code,pm.Company_Name, cm.CentreID,cm.Centre CentreName,DATE_FORMAT(cp.FromCampValidityDate,'%d-%b-%Y')FromValidDate,DATE_FORMAT(cp.ToCampValidityDate,'%d-%b-%Y')ToValidDate ");
            sb.Append(" FROM Centre_Panel cp  INNER JOIN centre_master cm ON cp.CentreID=cm.CentreID AND cm.IsActive=1 AND cp.IsActive=1 AND cp.IsCamp=1");
            sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=cp.PanelID AND pm.IsActive=1");
            sb.Append(" WHERE  cp.PanelID=@PanelID ");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@PanelID", Panel_ID)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return JsonConvert.SerializeObject("");
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string getCampItemDetail(string Panel_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb = new StringBuilder();
            sb.Append(" SELECT  im.ItemID,im.TypeName ItemName,rl.Rate,im.TestCode");
            sb.Append(" FROM f_ratelist rl INNER JOIN f_itemmaster im ON rl.ItemID=im.ItemID AND im.IsActive=1 AND rl.Panel_ID=@PanelID ");

            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@PanelID", Panel_ID)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindCentre(string BusinessZoneID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb = new StringBuilder();
            sb.Append(" SELECT CentreID,Centre FROM centre_master WHERE IsActive=1 AND Category='LAB' AND BusinessZoneID=@BusinessZoneID");
            return JsonConvert.SerializeObject(MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                                           new MySqlParameter("@BusinessZoneID", BusinessZoneID)).Tables[0]);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return JsonConvert.SerializeObject(new { status = true, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string getCampCount(string Company_Name, string Panel_ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb = new StringBuilder();
            sb.Append(" SELECT count(*) FROM f_panel_master WHERE Company_Name =@Panel");
            if (Panel_ID != "")
                sb.Append(" AND Panel_ID!=@PanelID ");

            return JsonConvert.SerializeObject(new { status = true, response = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, sb.ToString(), new MySqlParameter("@Panel", Company_Name), new MySqlParameter("@PanelID", Panel_ID))) });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    private DataTable GetTestList()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            sb = new StringBuilder();
            sb.Append(" SELECT im.itemid value,typeName label,if(subcategoryID='15','Package','Test') type,0 Rate from f_itemmaster im ");
            sb.Append(" WHERE isActive=1 ");
            if (Request.QueryString["SearchType"] == "1")
                sb.Append(" AND typeName like @typeName");
            else if (Request.QueryString["SearchType"] == "0")
                sb.Append(" AND im.testcode LIKE @typeName ");
            else
                sb.Append(" AND typeName like @typeName ");

            sb.Append("  order by typename limit 20 ");

            //return
            return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@typeName", string.Concat("%", Request.QueryString["TestName"].ToString(), "%"))).Tables[0];
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
    public static string saveCamp(object CampDetail, object ItemDetail, string CampRequestID)
    {
        List<campData> campDetails = new JavaScriptSerializer().ConvertToType<List<campData>>(CampDetail);
        List<campItemData> campItemDetails = new JavaScriptSerializer().ConvertToType<List<campItemData>>(ItemDetail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (Util.GetString(CampRequestID) != string.Empty && Util.GetString(CampRequestID) != "0")
            {

            }
            else
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT count(1) FROM f_panel_master WHERE Company_Name =@Panel",
                                                    new MySqlParameter("@Panel", campDetails[0].Company_Name)));
                if (count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, response = "Camp Name Already Exists" });
                }
            }

            PanelMaster objPanel = new PanelMaster(tnx);
            objPanel.Company_Name = campDetails[0].Company_Name.ToUpper();
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
            objPanel.Panel_Code = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT CONCAT('CAMP',LPAD(IFNULL( MAX(REPLACE(Panel_Code,'CAMP','')),'')+1,4,'0')) FROM f_panel_master WHERE paneltype='Camp'").ToString();
            string Panel_ID = objPanel.Insert();
            int CampTypeID = 0;
            DataTable InvoiceDetail = new DataTable();
            if (Util.GetString(CampRequestID) != string.Empty && Util.GetString(CampRequestID) != "0")
            {
                CampTypeID = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CampTypeID FROM camp_request WHERE ID=@CampRequestID",
                                                        new MySqlParameter("@CampRequestID", CampRequestID)));
                InvoiceDetail = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT fpm.InvoiceTo,fpm.CentreID FROM camp_request cr INNER JOIN f_panel_master fpm ON cr.Panel_ID=fpm.Panel_ID WHERE cr.ID=@CampRequestID AND fpm.PanelType='Centre'",
                                            new MySqlParameter("@CampRequestID", CampRequestID)).Tables[0];
                if (InvoiceDetail.Rows.Count > 0)
                {
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET InvoiceTo=@InvoiceTo,CentreID=@CentreID,showBalanceAmt=1 WHERE Panel_ID=@PanelID",
                                new MySqlParameter("@PanelID", Panel_ID),
                                new MySqlParameter("@InvoiceTo", InvoiceDetail.Rows[0]["InvoiceTo"].ToString()),
                                new MySqlParameter("@CentreID", InvoiceDetail.Rows[0]["CentreID"].ToString()));
                }

            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET CampTypeID=@CampTypeID,ReferenceCode=@PanelID,ReferenceCodeOPD=@PanelID,TagBusinessLab=@TagBusinessLab,TagBusinessLabId=@TagBusinessLabId,RequestedCamp_ID=@RequestedCamp_ID  WHERE Panel_ID=@PanelID",
                        new MySqlParameter("@PanelID", Panel_ID),
                        new MySqlParameter("@CampTypeID", CampTypeID),
                        new MySqlParameter("@RequestedCamp_ID", CampRequestID),
                        new MySqlParameter("@TagBusinessLab", campDetails[0].TagBusinessLab),
                        new MySqlParameter("@TagBusinessLabId", campDetails[0].TagBusinessLabId));

            for (int i = 0; i < campDetails.Count; i++)
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO centre_panel(CentreID,PanelID,dtEntry,UserID,FromCampValidityDate,ToCampValidityDate,IsCamp)VALUES(@CentreID,@PanelID,NOW(),@ID,@FromDate,@Todate,1)",
                            new MySqlParameter("@CentreID", campDetails[i].CentreID),
                            new MySqlParameter("@PanelID", Panel_ID),
                            new MySqlParameter("@ID", UserInfo.ID),
                            new MySqlParameter("@FromDate", Util.GetDateTime(campDetails[i].FromValidDate).ToString("yyyy-MM-dd")),
                            new MySqlParameter("@Todate", Util.GetDateTime(campDetails[i].ToValidDate).ToString("yyyy-MM-dd")));
            }
            for (int i = 0; i < campItemDetails.Count; i++)
            {
                RateList rl = new RateList(tnx);
                rl.ItemID = Util.GetInt(campItemDetails[i].ItemID);
                rl.Panel_ID = Util.GetInt(Panel_ID);
                rl.Rate = Util.GetDecimal(campItemDetails[i].Rate);
                rl.ERate = Util.GetDecimal(campItemDetails[i].Rate);
                rl.IsCurrent = 1;
                rl.FromDate = Util.GetDateTime(campDetails[0].FromValidDate);
                rl.IsService = "YES";
                rl.UpdateBy = Util.GetString(UserInfo.LoginName);
                rl.UpdateRemarks = "Camp ";
                rl.ItemDisplayName = campItemDetails[i].ItemName;
                rl.UpdateDate = DateTime.Now;
                rl.RateType = "LSP";
                string RateListID = rl.Insert();
            }
            if (Util.GetString(CampRequestID) != string.Empty && Util.GetString(CampRequestID) != "0")
            {

                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE camp_request SET IsCreated=1,CampCreatedByID=@CampCreatedByID,CampCreatedBy=@CampCreatedBy,CampCreatedDate=NOW(),CampCreatedPanel_ID=@CampCreatedPanel_ID WHERE ID=@ID",
                            new MySqlParameter("@CampCreatedByID", UserInfo.ID),
                            new MySqlParameter("@CampCreatedBy", UserInfo.LoginName),
                            new MySqlParameter("@CampCreatedPanel_ID", Panel_ID),
                            new MySqlParameter("@ID", CampRequestID));
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class campData
    {
        public int Panel_ID { get; set; }
        public string Company_Name { get; set; }
        public string FromValidDate { get; set; }
        public string ToValidDate { get; set; }
        public int CentreID { get; set; }
        public int TagBusinessLabId { get; set; }
        public string TagBusinessLab { get; set; }
    }

    public class campItemData
    {
        public string ItemName { get; set; }
        public int ItemID { get; set; }
        public decimal Rate { get; set; }
        public string TestCode { get; set; }
    }

    [WebMethod(EnableSession = true)]
    public static string updateCamp(object CampDetail, object ItemDetail)
    {
        List<campData> campDetails = new JavaScriptSerializer().ConvertToType<List<campData>>(CampDetail);
        List<campItemData> campItemDetails = new JavaScriptSerializer().ConvertToType<List<campItemData>>(ItemDetail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT count(1) FROM f_panel_master WHERE Company_Name =@Company AND Panel_ID!=@PanelID",
                                            new MySqlParameter("@Company", campDetails[0].Company_Name),
                                            new MySqlParameter("@PanelID", campDetails[0].Panel_ID)));
        if (count > 0)
        {
            return JsonConvert.SerializeObject(new { status = false, response = "Camp Name Already Exists" });
        }
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_panel_master SET Company_Name=@Company,UpdateID=@ID,UpdateDate=NOW(),UpdateName=@Login WHERE Panel_ID=PanelID ",
                        new MySqlParameter("@Company", campDetails[0].Company_Name.ToUpper()),
                        new MySqlParameter("@ID", UserInfo.ID),
                        new MySqlParameter("@Login", UserInfo.LoginName),
                        new MySqlParameter("@PanelID", campDetails[0].Panel_ID));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM centre_panel WHERE PanelID=@PanelID",
                        new MySqlParameter("@PanelID", campDetails[0].Panel_ID));
            for (int i = 0; i < campDetails.Count; i++)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO centre_panel(CentreID,PanelID,dtEntry,UserID,FromCampValidityDate,ToCampValidityDate,IsCamp)VALUES(@CentreID,@PanelID,NOW(),@ID,@FromDate,@ToDate,1)",
                            new MySqlParameter("@CentreID", campDetails[i].CentreID),
                            new MySqlParameter("@PanelID", campDetails[0].Panel_ID),
                            new MySqlParameter("@ID", UserInfo.ID),
                            new MySqlParameter("@FromDate", Util.GetDateTime(campDetails[i].FromValidDate).ToString("yyyy-MM-dd")),
                            new MySqlParameter("@ToDate", Util.GetDateTime(campDetails[i].ToValidDate).ToString("yyyy-MM-dd")));
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE f_ratelist SET DeletedByID=@DeletedByID,DeletedBy=@DeletedBy ,DeletedDate=NOW() WHERE Panel_ID=@Panel_ID ",
                        new MySqlParameter("@DeletedByID", UserInfo.ID),
                        new MySqlParameter("@DeletedBy", UserInfo.LoginName),
                        new MySqlParameter("@Panel_ID", campDetails[0].Panel_ID));
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "DELETE FROM f_ratelist WHERE Panel_ID=@PanelID",
                        new MySqlParameter("@PanelID", campDetails[0].Panel_ID));
            for (int i = 0; i < campItemDetails.Count; i++)
            {
                RateList rl = new RateList(tnx);
                rl.ItemID = Util.GetInt(campItemDetails[i].ItemID);
                rl.Panel_ID = Util.GetInt(campDetails[0].Panel_ID);
                rl.Rate = campItemDetails[i].Rate;
                rl.ERate = campItemDetails[i].Rate;
                rl.IsCurrent = 1;
                rl.FromDate = Util.GetDateTime(campDetails[0].FromValidDate);
                rl.IsService = "YES";
                rl.UpdateBy = Util.GetString(UserInfo.LoginName);
                rl.UpdateRemarks = "Camp ";
                rl.ItemDisplayName = campItemDetails[i].ItemName;
                rl.UpdateDate = DateTime.Now;
                string RateListID = rl.Insert();
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    private void bindCampDetail(string ID)
    {
        ID = Common.DecryptRijndael(ID);
        lblCampRequestID.Text = ID;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT cr.CampName,cr.Address,cr.Mobile,cr.Contact_Person,cr.CreatedBy,DATE_FORMAT(cr.StartDate,'%d-%b-%Y')StartDate,DATE_FORMAT(cr.EndDate,'%d-%b-%Y')EndDate,");
            sb.Append(" cm.BusinessZoneID,cm.CentreID,cm.Centre,cm.TagProcessingLabID,cm.TagProcessingLab,cr.CampTypeID ");
            sb.Append(" FROM camp_request cr ");
            sb.Append(" INNER JOIN centre_master cm on cm.CentreID=cr.CentreID  ");
            sb.Append(" WHERE cr.IsApproved=1 AND cr.ID=@ID AND cr.IsCreated=0 ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                         new MySqlParameter("@ID", ID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    txtCampName.Text = dt.Rows[0]["CampName"].ToString();
                    txtFromDate.Text = dt.Rows[0]["StartDate"].ToString();
                    txtToDate.Text = dt.Rows[0]["EndDate"].ToString();

                    List<string> BusinessDetail = new List<string>();
                    BusinessDetail.Add(dt.Rows[0]["BusinessZoneID"].ToString());
                    BusinessDetail.Add("");

                    BusinessDetail.Add(dt.Rows[0]["CentreID"].ToString());
                    BusinessDetail.Add(dt.Rows[0]["Centre"].ToString());
                    BusinessDetail.Add(dt.Rows[0]["TagProcessingLabID"].ToString());
                    BusinessDetail.Add(dt.Rows[0]["TagProcessingLab"].ToString());

                    JavaScriptSerializer serializer = new JavaScriptSerializer();
                    ScriptManager.RegisterStartupScript(this, GetType(), "myFunction", "bindCampBusinessDetail('" + serializer.Serialize(BusinessDetail) + "');", true);

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
            sb.Append("SELECT im.ItemID,im.testCode,im.typeName,IFNULL(crd.RequestedRate,0)RequestedRate");
            sb.Append(" FROM camp_request_ItemDetail crd INNER JOIN f_itemmaster im ON im.ItemID=crd.ItemID WHERE crd.RequestID=@ID AND crd.IsActive=1");
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
}