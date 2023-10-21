using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using System.Linq;
public partial class Design_Online_Lab_ViewlabReportPanel : System.Web.UI.Page
{
    private string PID = string.Empty;
  //  private string LedgerTransactionNo = string.Empty;
    private string OnlinePanelID = string.Empty;
    private string OnlineDocID = string.Empty;
    private string OnlinePROID = string.Empty;

    protected void Page_Init(object Sender, EventArgs e)
    {
        Response.AddHeader("Cache-Control", "no-store");
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Util.GetString(Session["isLogin"]) != "true")
        {
            Response.Redirect("~/Design/OnlineLab/Default.aspx");
        }

        if (!string.IsNullOrEmpty(Request.QueryString["UserType"]))
        {
            lblUseType.Text = Common.Decrypt(HttpUtility.UrlDecode(Request.QueryString["UserType"]));
        }
        if (!string.IsNullOrEmpty(Request.QueryString["OnlinePanelID"]))
        {
            OnlinePanelID = Common.Decrypt(HttpUtility.UrlDecode(Request.QueryString["OnlinePanelID"]));
        }

        if (!string.IsNullOrEmpty(Request.QueryString["PID"]))
            PID =Common.Decrypt(HttpUtility.UrlDecode(Request.QueryString["PID"]));
        if (!string.IsNullOrEmpty(Request.QueryString["LedgerTransactionNo"]))
            Labno.Text = Common.Decrypt(HttpUtility.UrlDecode(Request.QueryString["LedgerTransactionNo"]));

        if (Request.QueryString["OnlineDocID"] != null)
            OnlineDocID = Request.QueryString["OnlineDocID"].ToString();
        if (Request.QueryString["OnlinePROID"] != null)
            OnlinePROID = Request.QueryString["OnlinePROID"].ToString();

        if (!IsPostBack)
        {
            FrmDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            ToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
            SearchPatient();
            string[] cookies = Request.Cookies.AllKeys;
            string CacheID = Request.UserHostAddress;

            foreach (string cookie in cookies)
                if (cookie != "ASP.NET_SessionId")
                    if (cookie == CacheID)
                        Response.Cookies[cookie].Expires = DateTime.Now.AddDays(-1);
            lblOnlineStatus.Text = Common.Encrypt("1");
        }
        lblMsg.Text = "You can Download only Approved Report";
        FrmDate.Attributes.Add("readOnly", "readOnly");
        ToDate.Attributes.Add("readOnly", "readOnly");
        if (lblUseType.Text == "Patient")
        {
            Chk_Header.Checked = true;
        }
    }

    protected void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT DISTINCT ot.Name,ot.ObservationType_ID FROM investigation_master im INNER JOIN investigation_observationtype io  ");
        sb.Append(" ON im.Investigation_Id = io.Investigation_ID INNER JOIN observationtype_master ot ON ot.ObservationType_ID = io.ObservationType_Id  ORDER BY ot.Name ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            ddlDepartment.DataSource = dt;
            ddlDepartment.DataValueField = "ObservationType_ID";
            ddlDepartment.DataTextField = "Name";
            ddlDepartment.DataBind();
            ddlDepartment.Items.Insert(0, new ListItem("Select", "0"));
        }
    }

    private void SearchPatient()
    {
        if (lblUseType.Text == "Patient")
        {
            BindDepartment();
            divUserType.Visible = true;
            menu.Visible = false;
            menupat.Visible = true;
        }
        if (lblUseType.Text == "Panel")
        {
            BindDepartment();
            divUserType.Visible = true;
            menu.Visible = true;
        }
    }

    protected void ink_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("~/Design/onlinelab/Default.aspx");
    }

    [WebMethod]
    public static string bindLabReport(string LedgerTransactionNo, string LabNo, string UHIDNo, string PName, string mobileNo, string dept, string fromDate, string toDate, string Status, string PatientType, string UserType, string OnlinePanelID, string OnlineDocID, string OnlinePROID, string BarCodeNo)
    {
        TimeSpan sp2 = Util.GetDateTime(toDate).Subtract(Util.GetDateTime(fromDate));

        if (sp2.Days > 365)
        {
            //lblMsg.Text = "Timeframe can't be more than 365 days ";
            return "2";
        }

        string currentDate = DateTime.Now.ToString();
        // DateTime dt = Convert.ToDateTime(fromDate);
        //DateTime dt1 = Convert.ToDateTime(dtTo);
        // DateTime dt1 = DateTime.Now;
        // TimeSpan ts = dt1.Subtract(dt);
        // string diff = ts.Days.ToString();
        //if (Util.GetInt(diff) > 7 || Util.GetInt(diff) < -7)
        // if (Util.GetInt(diff) > 7)
        // {
        //lblMsg.Text = "Not Authorisec to view " + diff+" days older Reports";
        //return;
        // }

        string LabType = "OPD";
        StringBuilder sb = new StringBuilder();
        if (LabType == "OPD")
        {
            if (UserType == "Patient")
            {
                if (LedgerTransactionNo.Contains(","))
                {
                    LedgerTransactionNo = LedgerTransactionNo.Replace(",", "','");
                }

                /*This is for MOLQ and Others*/
                sb.Append("  SELECT pli.Reportdownload, pli.Approved, pli.Test_ID, pli.LedgerTransactionNo, PM.Patient_ID PID,PM.PName,pm.Age,pm.Gender,fpm.Company_Name as Panel, ");
                sb.Append(" DATE_FORMAT(pli.date,'%d-%b-%y')InDate,CONCAT(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,");
                sb.Append(" im.name testName ");
                sb.Append(" ,IF(pli.approved=1,'Approved','Not Approved')Rmks,pli.Investigation_ID,im.isCulture  ");
                sb.Append(" ,IF(lt.NetAmount-lt.Adjustment<=0 or lt.IsCredit=1,'Y', 'N') AllowPrint ");//or lt.AmtCredit=0
                sb.Append(" FROM patient_labinvestigation_opd pli  ");
                sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionNo=pli.LedgerTransactionNo              ");
                sb.Append(" AND PLI.LedgerTransactionNo in ('" + LedgerTransactionNo + "')  ");
                sb.Append("  ");
                sb.Append(" INNER JOIN patient_master PM ON lt.Patient_ID = PM.Patient_ID ");
                sb.Append(" INNER JOIN investigation_master im ON pli.Investigation_ID = im.Investigation_Id ");
                sb.Append(" INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID ");
                sb.Append(" INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id  ");
                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID  ");

                sb.Append("  ORDER BY lt.LedgerTransactionNo ");
            }
            if (UserType == "Panel")
            {
                sb.Append(" SELECT pli.Reportdownload, pli.Approved, pli.Test_ID,fpm.Company_Name as Panel,pli.LedgerTransactionNo,PM.Patient_ID PID,PM.PName,pm.Age,pm.Gender, ");
                sb.Append(" DATE_FORMAT(pli.date,'%d-%b-%y')InDate,CONCAT(pm.House_No,pm.Street_Name,pm.Locality,pm.City,pm.Pincode)Address,  ");
                sb.Append(" im.name testName ");

                sb.Append(" ,IF(pli.approved=1,'Approved','Not Approved')Rmks,pli.Investigation_ID,im.isCulture  ");
                if (OnlinePanelID != string.Empty)
                {
                    string PaymentMode = "SELECT Payment_Mode FROM f_panel_master WHERE Panel_ID=@Panel_ID";
                    string PanelPayMode = Util.GetString(MySqlHelper.ExecuteScalar(Util.GetMySqlCon(), CommandType.Text, PaymentMode,
                    new MySql.Data.MySqlClient.MySqlParameter("@Panel_ID", OnlinePanelID.Trim())));

                    if (PanelPayMode == "Cash" || PanelPayMode == "Both")
                        sb.Append(" , if( (((lt.NetAmount - lt.Adjustment)<=0 and lt.IsCredit=0) or lt.IsCredit=1),'Y','N' ) AllowPrint ");
                    else
                        sb.Append(", 'Y'  AllowPrint ");
                }
                else
                    sb.Append(", 'Y'  AllowPrint ");

                sb.Append(" FROM patient_labinvestigation_opd pli  ");
                sb.Append(" INNER JOIN f_ledgertransaction lt on lt.LedgerTransactionNo=pli.LedgerTransactionNo  ");
                if (fromDate != string.Empty)
                    sb.Append(" AND (lt.Date) >=@fromDate");

                if (toDate != string.Empty)
                    sb.Append(" AND (lt.Date) <=@toDate");

                if (LabNo != string.Empty)
                    sb.Append(" AND PLI.LedgerTransactionNo=@LabNo");
                if (Status == "1")
                    sb.Append(" AND pli.Approved=1");
                if (Status == "2")
                    sb.Append(" AND pli.Approved=0 ");
                if (BarCodeNo != string.Empty)
                    sb.Append(" AND pli.BarCodeNo=@BarCodeNo ");

                if (PatientType == "1")
                    sb.Append(" AND lt.PatientType='Urgent' ");

                if (OnlineDocID != string.Empty)
                    sb.Append(" AND lt.ReferedBy=@OnlineDocID ");

                if (OnlinePanelID != string.Empty)
                    sb.Append("  AND lt.Panel_ID=@OnlinePanelID ");

                sb.Append(" INNER JOIN patient_master PM on lt.Patient_ID = PM.Patient_ID  ");
                if (UHIDNo != string.Empty)
                    sb.Append(" and PM.Patient_ID=@UHIDNo");

                if (PName != string.Empty)
                    sb.Append(" AND PM.PName LIKE @PName ");

                if (mobileNo.Trim() != string.Empty)
                    sb.Append(" AND PM.Mobile LIKE @mobileNo ");

                sb.Append(" INNER JOIN investigation_master im on pli.Investigation_ID = im.Investigation_Id ");
                sb.Append(" INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID ");
                if (dept != "0")
                    sb.Append(" AND io.ObservationType_ID=@dept");

                sb.Append(" INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id  ");
                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID  ");

                sb.Append(" order by lt.LedgerTransactionNo ");
            }
        }

        DataTable dtInvest = MySqlHelper.ExecuteDataset(Util.GetMySqlCon(), CommandType.Text, sb.ToString(),
                        new MySql.Data.MySqlClient.MySqlParameter("@BarCodeNo", BarCodeNo), new MySql.Data.MySqlClient.MySqlParameter("@dept", dept),
                        new MySql.Data.MySqlClient.MySqlParameter("@UHIDNo", UHIDNo), new MySql.Data.MySqlClient.MySqlParameter("@OnlinePanelID", OnlinePanelID),
                        new MySql.Data.MySqlClient.MySqlParameter("@OnlineDocID", OnlineDocID), new MySql.Data.MySqlClient.MySqlParameter("@OnlinePROID", OnlinePROID),
                        new MySql.Data.MySqlClient.MySqlParameter("@LabNo", LabNo), new MySql.Data.MySqlClient.MySqlParameter("@fromDate", Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " " + "00:00:00"),
                        new MySql.Data.MySqlClient.MySqlParameter("@toDate", Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " " + "23:59:59"),
                        new MySql.Data.MySqlClient.MySqlParameter("@PName", "" + PName + "%"), new MySql.Data.MySqlClient.MySqlParameter("@mobileNo", "" + mobileNo + "%")
                        ).Tables[0];

        return Util.getJson(dtInvest);
    }

    [WebMethod]
    public static string printLabReport(string testID, string UserType)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] tags = testID.Replace("'", "").Split(',');


            string[] paramNames = tags.Select(
                  (s, i) => "@tag" + i.ToString()).ToArray();


            string inClause = string.Join(", ", paramNames);

            string PLO = "update patient_labinvestigation_opd set Reportdownload='1',reportDownloaddate=now(),reportDownloadby='" + UserType + "' WHERE test_id IN ({0})";


            MySqlCommand cmd4 = new MySqlCommand(string.Format(PLO, inClause), con);
            for (int i = 0; i < paramNames.Length; i++)
            {
                cmd4.Parameters.AddWithValue(paramNames[i], tags[i]);
            }
            cmd4.ExecuteNonQuery();

            cmd4.Dispose();
            
            return "1";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}