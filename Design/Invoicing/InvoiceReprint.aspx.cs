using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
public partial class Design_Invoicing_InvoiceReprint : System.Web.UI.Page
{


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");

            chkCondition();

            DateTime LastMonthLastDate = DateTime.Today.AddDays(0 - DateTime.Today.Day);
            DateTime LastMonthFirstDate = LastMonthLastDate.AddDays(1 - LastMonthLastDate.Day);

            dtFrom.Text = LastMonthFirstDate.ToString("dd-MMM-yyyy");
            dtTo.Text = LastMonthLastDate.ToString("dd-MMM-yyyy");
            dtFrom.Attributes.Add("readOnly", "readOnly");
            dtTo.Attributes.Add("readOnly", "readOnly");
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;

            lstcentre.DataSource = StockReports.GetDataTable(Util.GetCentreAccessQuery());
            lstcentre.DataTextField = "Centre";
            lstcentre.DataValueField = "CentreID";
            lstcentre.DataBind();
        }
    }
    [WebMethod]
    public static string BindPanel(int BusinessZoneID, int StateID, int SearchType, string PaymentMode, string TagBusinessLab, string PanelGroup, int? IsInvoicePanel, string BillingCycle, string BusinessUnitID)
    {
        HttpContext ctx = HttpContext.Current;
        string InvoicePanelID = StockReports.ExecuteScalar("select Invoiceto from f_panel_master where employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,CONCAT(fpm.Panel_ID,'#','PUP','#','7')Panel_ID,'PUP' Type1 FROM f_panel_master fpm ");
        sb.Append(" WHERE  fpm.IsInvoice=1  "); //and fpm.Panel_ID=fpm.Invoiceto
        if (BusinessUnitID != "")
        {
            sb.Append(" and Panel_ID in(select PanelID from centre_panel where centreID in( " + BusinessUnitID + "))");
        }
        if (Util.GetString(ctx.Session["PanelType"]) == "PCC")
        {
            sb.Append(" and fpm.InvoiceTo =" + InvoicePanelID + " ");
        }
        else if (Util.GetString(ctx.Session["PanelType"]).ToUpper() == "SUBPCC")
        {
            sb.Append(" and fpm.employee_ID=" + Util.GetString(ctx.Session["ID"]) + " ");
        }
        else if (UserInfo.Centre !=1)
        {
            sb.Append(" and Panel_ID in(select PanelID from centre_panel where centreID= " + UserInfo.Centre + ") ");
        }
        sb.Append(" ORDER BY fpm.Company_Name");

        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);

        }
    }
    private void chkCondition()
    {
        ddlDateType.SelectedIndex = 1;
        if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6)
        {
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "showAccountSearch();", true);
            lblSearchType.Text = "1";
        }
        else
        {
            if (Session["IsSalesTeamMember"].ToString() == "1")
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "hideSearchCriteria();", true);

                lblSearchType.Text = "2";
            }
            else
            {
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "hideSearchCriteria1();", true);

                lblSearchType.Text = "3";
            }
        }
    }

    [WebMethod]
    public static string SearchStatus(string DateType, string dtFrom, string dtTo, string PanelID, string InvoiceNo, string PrintInvoiceReport)
    {
        PanelID = String.Join(",", PanelID.Split(new char[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Split('#')[0]).ToList());

        string[] PanelIDTags = PanelID.Split(',');
        string[] PanelIDNames = PanelIDTags.Select((s, i) => "@tag" + i).ToArray();
        string PanelIDClause = string.Join(", ", PanelIDNames);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pnl.Panel_ID,pnl.Panel_Code,pnl.`Company_Name` AS PanelName, ");
            sb.Append(" im.InvoiceNo , DATE_FORMAT(im.InvoiceDate,'%d-%b-%y')DATE,im.EntryByName InvoiceCreatedBy, ");
            sb.Append(" pnl.Add1 Address,pnl.Mobile,IFNULL(pnl.emailid,'')PanelInvoiceEmailID ,");
            sb.Append("  im.ShareAmt,im.InvoiceType,im.`PanelID`,pnl.InvoiceEmailTo,pnl.InvoiceEmailCC,im.IsDispatch,(select centre from centre_master where centreID in(select CentreId from Centre_Panel where PanelId=pnl.Panel_ID )LIMIT 1) Centre ");
            sb.Append(" FROM invoiceMaster im  INNER JOIN `f_panel_master` pnl ON pnl.`Panel_ID`=im.`PanelID`  ");
            if (InvoiceNo.Trim() != string.Empty)
                sb.Append(" AND im.InvoiceNo=@InvoiceNo");
            if (PanelID != string.Empty)
                sb.Append(" AND pnl.`InvoiceTo` IN ({0})");

            sb.Append(" WHERE im.isCancel=0 ");
            if (InvoiceNo.Trim() == string.Empty)
            {
                 sb.Append(" AND " + DateType + ">=@dtFrom");
                sb.Append(" AND " + DateType + "<=@dtTo");

            }
            sb.Append(" ORDER BY im.InvoiceNo ");

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), PanelIDClause), con))
            {
                for (int i = 0; i < PanelIDNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(PanelIDNames[i], PanelIDTags[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@InvoiceNo", InvoiceNo.Trim());
                da.SelectCommand.Parameters.AddWithValue("@dtFrom", string.Concat(Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd")," ","00:00:00"));
                da.SelectCommand.Parameters.AddWithValue("@dtTo", string.Concat(Util.GetDateTime(dtTo).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                        return Util.getJson(dt);
                    else
                        return null;
                }
            }
        }


        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string SearchInvoiceSummary(string DateType, string dtFrom, string dtTo, string PanelID, string CentreID, string InvoiceNo, string paymentMode)
    {
        try
        {
            int s = UserInfo.Centre ;
        }
        catch
        {
            return "-1";
        }
        StringBuilder sb = new StringBuilder();
        try
        {
            //string _IsPanel = HttpContext.Current.Session["IsPanel"].ToString();
            sb.Append(" SELECT InvoiceNo,fpm.BusinessUnit,fpm.`Panel_ID` ClientCode,fpm.`Company_Name` ClientName,im.NetAmount,im.shareAmt`InvoiceAmount`, ");
            sb.Append(" DATE_FORMAT(im.`InvoiceDate`,'%d-%b-%Y') InvoiceDate,im.`FromDate`,im.`ToDate`, ");
            sb.Append(" im.EntryByname InvoiceCreatedBy, ");
            sb.Append(" DATE_FORMAT(im.`EntryDate`,'%d-%b-%Y') InvoiceCreatedOn  ");
            sb.Append(" FROM invoicemaster im ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=im.`PanelID` ");
            sb.Append(" WHERE im.`IsCancel`=0   ");
            sb.Append(" AND fpm.InvoiceTo = fpm.panel_id  ");
            if (PanelID != "")
            {
                sb.Append(" AND fpm.`Panel_ID` in (" + PanelID + ") ");
            }

            if (UserInfo.IsSalesTeamMember == 1)
            {
                sb.Append(" AND  fpm.SalesManagerID IN (" + UserInfo.AccessPROIDs + ") ");
            }
            else
            {
                if ((HttpContext.Current.Session["LoginType"].ToString() == "PCC" || HttpContext.Current.Session["LoginType"].ToString() == "SUBPCC") && PanelID == "")
                {
                    // sb.Append(" and fpm.`Panel_ID` IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ) ");
                    sb.Append(" and (fpm.panel_id IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ) ");
                    sb.Append(" or fpm.panel_id IN (SELECT panel_id FROM f_panel_master WHERE invoiceto IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ))) ");

                }
                if (PanelID == "")//UserInfo.IsCollectionCentre == "Yes" &&
                {
                    sb.Append("and fpm.");
                    sb.Append(Util.CCpanelchanges(HttpContext.Current.Session["ID"].ToString()));
                }
            }
            if (InvoiceNo.Trim() != "")
            {
                sb.Append(" AND im.InvoiceNo='" + InvoiceNo.Trim() + "'");
            }
            if (paymentMode == "1")//Credit
            {
                sb.Append(" and pnl.payment_mode ='Credit' and pnl.RollingAdvance=0");
            }
            if (paymentMode == "2")//Rolling Advance
            {
                sb.Append(" and pnl.payment_mode ='Credit' and pnl.RollingAdvance=1");
            }
            if (CentreID != "")
            {
                sb.Append(" and fpm.TagBusinessLabID IN (" + CentreID + ") ");
            }
            if (InvoiceNo.Trim() != string.Empty)
            {
                sb.Append(" AND im.InvoiceNo='" + InvoiceNo.Trim() + "'");
            }
            else
            {
                sb.Append(" AND DATE(" + DateType + ")>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + "'");
                sb.Append(" AND DATE(" + DateType + ")<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + "'");
            }
            sb.Append(" ORDER BY im.`InvoiceDate`,fpm.`Company_Name`  DESC ");
            if (Util.GetString(HttpContext.Current.Session["ID"]) == "1")
            {
               // System.IO.File.WriteAllText("C:\\Invoicereprint.txt", sb.ToString());
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                HttpContext.Current.Session["ReportName"] = "Invoice Summary Report";
                HttpContext.Current.Session["Period"] = "";
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                return "1";
            }
            else
            {
                return "0";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "2";
        }
    }
    [WebMethod]
    public static string cancelinvoice(string DateType, string dtFrom, string dtTo, string PanelID, string CentreID, string InvoiceNo, string paymentMode)
    {
        try
        {
            int s = UserInfo.Centre;
        }
        catch
        {
            return "-1";
        }
        StringBuilder sb = new StringBuilder();
        try
        {
           // string _IsPanel = HttpContext.Current.Session["IsPanel"].ToString();
            sb.Append(" SELECT InvoiceNo,fpm.`Panel_ID` ClientCode,fpm.`Company_Name` ClientName,im.ShareAmt`InvoiceAmount`, ");
            sb.Append(" DATE_FORMAT(im.`InvoiceDate`,'%d-%b-%Y') InvoiceDate,im.`FromDate`,im.`ToDate`, ");
            sb.Append(" im.EntryByname InvoiceCreatedBy, ");
            sb.Append(" DATE_FORMAT(im.`EntryDate`,'%d-%b-%Y') InvoiceCreatedOn, ");
            sb.Append(" (SELECT NAME FROM employee_master WHERE Employee_ID=im.`Cancel_UserID`) InvoiceCancelBy, ");
            sb.Append(" DATE_FORMAT(im.`CancelDate`,'%d-%b-%Y') InvoiceCancelOn ");
            sb.Append(" FROM invoicemaster im ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.`Panel_ID`=im.`PanelID` ");
            sb.Append(" WHERE im.`IsCancel`=1   ");
            sb.Append(" AND fpm.InvoiceTo = fpm.panel_id ");
            if (PanelID != "")
            {
                sb.Append(" AND fpm.`Panel_ID` in (" + PanelID + ") ");
            }
            if (UserInfo.IsSalesTeamMember == 1)
            {
                sb.Append(" AND  fpm.SalesManagerID IN (" + UserInfo.AccessPROIDs + ") ");
            }
            else
            {
                if ((HttpContext.Current.Session["LoginType"].ToString() == "PCC" || HttpContext.Current.Session["LoginType"].ToString() == "SUBPCC") && PanelID == "")
                {
                    //  sb.Append(" and fpm.Panel_ID IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ) ");
                    sb.Append(" and (fpm.panel_id IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ) ");
                    sb.Append(" or fpm.panel_id IN (SELECT panel_id FROM f_panel_master WHERE invoiceto IN (SELECT panel_id FROM f_panel_master WHERE employeeID='" + HttpContext.Current.Session["ID"].ToString() + "' ))) ");

                }
                if (PanelID == "")//UserInfo.IsCollectionCentre == "Yes"
                {
                    sb.Append("and fpm.");
                    sb.Append(Util.CCpanelchanges(HttpContext.Current.Session["ID"].ToString()));
                }
            }
            if (InvoiceNo.Trim() != "")
            {
                sb.Append(" AND im.InvoiceNo='" + InvoiceNo.Trim() + "'");
            }
            if (CentreID != "")
            {
                sb.Append(" and fpm.TagBusinesslabid IN (" + CentreID + ") ");
            }
            if (paymentMode == "1")//Credit
            {
                sb.Append(" and pnl.payment_mode ='Credit' and pnl.RollingAdvance=0");
            }
            if (paymentMode == "2")//Rolling Advance
            {
                sb.Append(" and pnl.payment_mode ='Credit' and pnl.RollingAdvance=1");
            }
            if (InvoiceNo.Trim() != string.Empty)
            {
                sb.Append(" AND im.InvoiceNo='" + InvoiceNo.Trim() + "'");
            }
            else
            {
                sb.Append(" AND im.`CancelDate`>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00'");
                sb.Append(" AND im.`CancelDate`<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59'");
            }
            sb.Append(" ORDER BY im.`CancelDate` DESC ");
            DataTable dt = StockReports.GetDataTable(sb.ToString());
            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                ds.Tables.Add(dt.Copy());
                HttpContext.Current.Session["ReportName"] = "Invoice Cancel Report";
                HttpContext.Current.Session["Period"] = "";
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                return "1";
            }
            else
            {
                return "0";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return "2";
        }
    }
    [WebMethod]
    public static string EmailReport(string InvoiceNo, string emailID, string emailCCID, string InvoiceType)
    {
        string ss = GetEmailReport(InvoiceNo, emailID, emailCCID, InvoiceType);
        return ss;
    }
    private static string GetEmailReport(string InvoiceNo, string emailid, string emailCCID, string InvoiceType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DataTable dt = serviceWiseCollection(InvoiceNo, 1, con);




            if (dt.Rows.Count > 0)
            {


                StringBuilder sbInvoice = new StringBuilder();
                sbInvoice.Append(" SELECT InvoiceNo,DATE_FORMAT(InvoiceDate,'%d-%m-%Y')InvoiceDate, ");
                sbInvoice.Append(" CONCAT(DATE_FORMAT(fromDate,'%d-%b-%Y'),' to ',DATE_FORMAT(toDate,'%d-%b-%Y')) Period,im.InvoiceType");

                sbInvoice.Append(" FROM InvoiceMaster im ");
                sbInvoice.Append("  WHERE InvoiceNo =@InvoiceNo ");


                DataTable dtInvoice = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbInvoice.ToString(),
               new MySqlParameter("@InvoiceNo", InvoiceNo)).Tables[0];
                if (dtInvoice.Rows.Count > 0)
                {
                    ReportEmailClass REmail = new ReportEmailClass(); 
                    sbInvoice = new StringBuilder();
                    sbInvoice.Append("<div> Dear Valued Customer, </div>");
                    sbInvoice.Append("<br/>");
                    sbInvoice.AppendFormat(" Greetings from {0},", Resources.Resource.EmailSignature);
                    sbInvoice.Append("<br/>"); sbInvoice.Append("<br/>");
                    sbInvoice.Append("Please find the attached Invoice and Billing Detailed Report for the period <b>" + dtInvoice.Rows[0]["Period"] + " </b>");
                    sbInvoice.Append("<br/>"); sbInvoice.Append("<br/>"); 
                    sbInvoice.Append("If you find any discrepancies, Please revert in next 2 working days otherwise balances will be considered as confirmed.");
                    sbInvoice.Append("<br/>"); sbInvoice.Append("<br/>");
                    sbInvoice.Append(" This is computer generated email, please do not reply.");
                    sbInvoice.Append("<br/>"); sbInvoice.Append("<br/>"); sbInvoice.Append("<br/>");
                    sbInvoice.Append("Thanks & Regards,"); sbInvoice.Append("<br/>");
                    sbInvoice.Append("Accounts Team,"); sbInvoice.Append("<br/>");
                    sbInvoice.AppendFormat("{0}.", Resources.Resource.EmailSignature); sbInvoice.Append("<br/>"); 
                    string IsSend = REmail.sendPanelInvoiceNew(InvoiceNo,emailid, dt.Rows[0]["PanelName"].ToString(), sbInvoice.ToString(), emailCCID, "", dt, dt.Rows[0]["PanelName"].ToString(), dtInvoice.Rows[0]["InvoiceDate1"].ToString());
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO Invoice_Emaildispatch(InvoiceNo,CreatedBy,CreatedByID,IsDispatch,EmailTo,EmailCC)VALUES(@InvoiceNo,@CreatedBy,@CreatedByID,@IsDispatch,@EmailTo,@EmailCC)",
                              new MySqlParameter("@InvoiceNo", InvoiceNo), new MySqlParameter("@CreatedBy", UserInfo.LoginName), new MySqlParameter("@CreatedByID", UserInfo.ID), new MySqlParameter("@IsDispatch", IsSend),
                    new MySqlParameter("@EmailTo", emailid), new MySqlParameter("@EmailCC", emailCCID));
                    if (IsSend == "1")
                    {


                        MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "UPDATE invoiceMaster SET IsDispatch=1 WHERE InvoiceNo=@InvoiceNo",
                                                    new MySqlParameter("@InvoiceNo", InvoiceNo));

                    }
                }



            }
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

    public static MemoryStream ConvertToStream(string fileUrl)
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(fileUrl);
        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        MemoryStream result;
        try
        {
            MemoryStream mem = CopyStream(response.GetResponseStream());
            result = mem;
        }
        finally
        {
            response.Close();
        }
        return result;
    }
    public static MemoryStream CopyStream(Stream input)
    {
        MemoryStream output = new MemoryStream();
        byte[] buffer = new byte[16384];
        int read;
        while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
        {
            output.Write(buffer, 0, read);
        }
        return output;
    } 
    [WebMethod]
    public static string CollectionReport(string InvoiceNo, int? PanelID, int IsPassword, string password)
    {

        if (UserInfo.RoleID != 1 && UserInfo.RoleID != 177 && UserInfo.RoleID != 6 && HttpContext.Current.Session["IsSalesTeamMember"].ToString() == "0" && IsPassword == 0)
        {
            if (AllLoad_Data.getLedgerReportPassword(PanelID) != string.Empty)
                return "8";
        }
        if (IsPassword == 1 && AllLoad_Data.getLedgerPasswordMatches(password, AllLoad_Data.getLedgerReportPassword(PanelID)) == 0)
        {
            return "5";
        }

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            HttpContext.Current.Session["dtExport2Excel"] = serviceWiseCollection(InvoiceNo, 1, con);
            HttpContext.Current.Session["ReportName"] = "ServiceWise Collection Report";
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

    public static DataTable serviceWiseCollection(string InvoiceNo, int condition, MySqlConnection con)
    {
        StringBuilder sb = new StringBuilder();

        sb.Append("  SELECT lt.`PanelName`,lt.LedgerTransactionno Visitno,DATE_FORMAT(plos.Date,'%d-%b-%Y') billdate,lt.PName `PatientName`,concat(lt.Age,'/',Left(lt.Gender,1))AgeGender,");
        sb.Append(" lt.SRFno SRFID,pm.House_No Paddress, im.`TypeName` `ServiceName`,plos.Rate GrossAmt,plos.DiscountAmt DiscountAmt,plos.Amount NetAmt,plos.PCCInvoiceAmt InvoiceAmt ");
        sb.Append("  FROM f_ledgertransaction lt  ");
        sb.Append("  INNER JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID=lt.LedgerTransactionID  ");
        sb.Append("  INNER JOIN `f_itemmaster` im ON im.`ItemID`=plos.ItemID  INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id  ");
        sb.Append("  INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_ID");
        sb.Append("  INNER JOIN invoiceMaster ims ON ims.`InvoiceNo`=plos.`InvoiceNo` AND ims.IsCancel=0 ");
        sb.Append(" WHERE plos.InvoiceNo=@InvoiceNo AND plos.`DiscountAmt` =0  ORDER BY plos.Date ");
        return MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
           new MySqlParameter("@InvoiceNo", InvoiceNo)).Tables[0];
    }
    [WebMethod(EnableSession = true)]
    public static string encryptInvoice(string InvoiceNo, string InvoiceType, int PanelID, string password, int IsPassword)
    {
        if (UserInfo.RoleID != 1 && UserInfo.RoleID != 177 && UserInfo.RoleID != 6 && HttpContext.Current.Session["IsSalesTeamMember"].ToString() == "0" && IsPassword == 0)
        {
            if (AllLoad_Data.getLedgerReportPassword(PanelID) != string.Empty)
                return "8";
        }
        if (IsPassword == 1 && AllLoad_Data.getLedgerPasswordMatches(password, AllLoad_Data.getLedgerReportPassword(PanelID)) == 0)
        {
            return "5";
        }
        List<string> addEncrypt = new List<string>();
        addEncrypt.Add(Common.Encrypt(InvoiceNo));
        addEncrypt.Add(Common.Encrypt(InvoiceType));
        addEncrypt.Add(Common.Encrypt("1"));
        return JsonConvert.SerializeObject(addEncrypt);
    }
}