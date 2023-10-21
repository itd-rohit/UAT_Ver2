using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Master_Invoice_Creation : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            DateTime LastMonthLastDate = DateTime.Today.AddDays(0 - DateTime.Today.Day);
            DateTime LastMonthFirstDate = LastMonthLastDate.AddDays(1 - LastMonthLastDate.Day);

            dtFrom.Text = LastMonthFirstDate.ToString("dd-MMM-yyyy");
            dtTo.Text = LastMonthLastDate.ToString("dd-MMM-yyyy");           
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;           
            txtInvoiceDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
           // dtFrom.Text = Util.GetDateTime(txtInvoiceDate.Text).AddMonths(-1).ToString("01-MMM-yyyy");
            //dtTo.Text = string.Format("{0}-{1:MMM-yyyy}", DateTime.DaysInMonth(Util.GetDateTime(txtInvoiceDate.Text).AddMonths(-1).Year, Util.GetDateTime(txtInvoiceDate.Text).AddMonths(-1).Month), Util.GetDateTime(txtInvoiceDate.Text).AddMonths(-1));

        }
        txtInvoiceDate.Attributes.Add("readOnly", "true");
        dtFrom.Attributes.Add("readOnly", "true");
        dtTo.Attributes.Add("readOnly", "true");
    }

    protected void txtInvoiceDate_TextChanged(object sender, EventArgs e)
    {
        dtFrom.Text = Util.GetDateTime(txtInvoiceDate.Text).AddMonths(-1).ToString("01-MMM-yyyy");
        dtTo.Text = string.Format("{0}-{1:MMM-yyyy}", DateTime.DaysInMonth(Util.GetDateTime(txtInvoiceDate.Text).AddMonths(-1).Year, Util.GetDateTime(txtInvoiceDate.Text).AddMonths(-1).Month), Util.GetDateTime(txtInvoiceDate.Text).AddMonths(-1));
    }
    [WebMethod(EnableSession = true)]
    public static string SearchInvoice(string dtFrom, string dtTo, string PanelID, string type, DateTime InvoiceDate, string SearchType, int SearchTypeID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (Convert.ToDateTime(dtTo) > Convert.ToDateTime(InvoiceDate))
            {
                return JsonConvert.SerializeObject(new { status = false, response = "Invoice Date is Greater then OR Equal to To Date" });
            }
            else
            {
                PanelID = String.Join(",", PanelID.Split(new char[] { ' ', ',' }, StringSplitOptions.RemoveEmptyEntries).Select(s => s.Split('#')[0]).ToList());

                string[] PanelIDTags = PanelID.Split(',');
                string[] PanelIDNames = PanelIDTags.Select((s, i) => "@tag" + i).ToArray();
                string PanelIDClause = string.Join(", ", PanelIDNames);


                StringBuilder sb = new StringBuilder();
                sb.Append(@" SELECT GROUP_CONCAT(DISTINCT plos.InvoiceNo )InvoiceNo  
                             FROM `f_ledgertransaction` lt 
                             INNER JOIN f_panel_master pnl1 ON pnl1.Panel_ID=lt.Panel_ID 
                             INNER JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID=lt.LedgerTransactionID  ");
                sb.AppendFormat(" WHERE plos.{0}>=@dtFrom ", Resources.Resource.LedgerReportDate);
                sb.AppendFormat("  AND plos.{0}<=@dtTo", Resources.Resource.LedgerReportDate);
                sb.Append(" AND   IFNULL(plos.InvoiceNo,'')<>''  ");
                if (PanelID != string.Empty)
                {
                    sb.Append(" AND pnl1.InvoiceTo IN ({0})  ");
                }
                sb.Append("  GROUP BY plos.InvoiceNo ");
				//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\inv2.txt",sb.ToString());
                string getInvoiceNo = string.Empty;
                using (MySqlCommand m = new MySqlCommand(string.Format(sb.ToString(), PanelIDClause), con))
                {
                    for (int i = 0; i < PanelIDNames.Length; i++)
                    {
                        m.Parameters.Add(new MySqlParameter(PanelIDNames[i], PanelIDTags[i]));
                    }
                    m.Parameters.AddWithValue("@dtFrom", string.Concat(Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd"), " 00:00:00"));
                    m.Parameters.AddWithValue("@dtTo", string.Concat(Util.GetDateTime(dtTo).ToString("yyyy-MM-dd"), " 23:59:59"));
                    getInvoiceNo = Util.GetString(m.ExecuteScalar());
                }
                if (getInvoiceNo != string.Empty && PanelID.Length == 1)
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Invoice No. :", getInvoiceNo, " Generated During Selected Period") });

                else
                {
                    sb = new StringBuilder();
                    sb.Append(" SELECT * FROM ( ");
                    sb.Append(" SELECT pnl1.InvoiceTo Panel_ID,pnlinv.Panel_Code,pnlinv.Company_Name AS PanelName, ");
                    sb.Append("  ROUND(SUM(plos.PCCInvoiceAmt),0)ShareAmt ");
                    sb.AppendFormat(" ,'{0}' SearchType,'{1}' fromDate,'{2}' toDate,'{3}' SearchTypeID,pnl1.PatientPayTo,pnl1.Payment_Mode  ", SearchType, dtFrom, dtTo, SearchTypeID);
                    sb.Append(" FROM  patient_labinvestigation_opd_share plos ");
                    sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgertransactionID = plos.LedgertransactionID ");
                 
                    sb.Append(" INNER JOIN f_panel_master pnl1 ON pnl1.Panel_ID=lt.Panel_ID ");
                    sb.Append(" INNER JOIN f_panel_master pnlinv ON pnl1.InvoiceTo=pnlinv.Panel_ID ");
                    sb.AppendFormat(" AND plos.{0}>=@dtFrom ", Resources.Resource.LedgerReportDate);
                    sb.AppendFormat(" AND plos.{0}<=@dtTo", Resources.Resource.LedgerReportDate);
                    sb.Append("  AND IFNULL(plos.InvoiceNo,'')=''   ");
                    if (PanelID != string.Empty)
                    {
                        sb.Append(" AND pnl1.InvoiceTo IN ({0})  ");
                    }
                    sb.Append(" GROUP BY pnl1.InvoiceTo ");
                    sb.Append(" ORDER BY pnl1.Company_Name ");
                    sb.Append(" )t WHERE t.ShareAmt>0");
					//System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\inv.txt",sb.ToString());
                    using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), PanelIDClause), con))
                    {
                        for (int i = 0; i < PanelIDNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(PanelIDNames[i], PanelIDTags[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@type1ID", SearchType);
                        da.SelectCommand.Parameters.AddWithValue("@dtFrom", string.Concat(Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd"), " 00:00:00"));
                        da.SelectCommand.Parameters.AddWithValue("@dtTo", string.Concat(Util.GetDateTime(dtTo).ToString("yyyy-MM-dd"), " 23:59:59"));
                        DataTable dt = new DataTable();
                        using (dt as IDisposable)
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                                return JsonConvert.SerializeObject(new { status = true, response = Util.getJson(dt) });
                            else
                                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
                        }
                    }
                }
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

    [WebMethod(EnableSession = true)]
    public static string SearchInvoicePatient(string Panel_ID, string SearchType, string fromDate, string toDate, int SearchTypeID, string PatientPayTo, string PaymentMode)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DATE_FORMAT(plos.date,'%d-%b-%Y')RegDate,plos.LedgerTransactionNo,CONCAT(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'/',LEFT(pm.Gender,1))Age,  ");
            sb.Append(" im.TypeName ItemName  ,plos.Rate,plos.Quantity,lt.GrossAmount,ROUND((IFNULL(((plos.Rate*plos.Quantity)-plos.Amount),0 )),2)Discount, lt.NetAmount,Sum(plos.Amount)Amount,   ");
            sb.Append(" ROUND((IFNULL( ((lt.Adjustment*plos.Rate*plos.Quantity)/lt.GrossAmount),0)),2)    PaidAmt,  ");
            sb.Append(" ROUND((IFNULL((plos.Amount- ((lt.Adjustment*plos.Rate*plos.Quantity)/lt.GrossAmount)),0)),2)    BalanceAmt,lt.panel_ID, ");
            sb.Append(" ROUND(plos.PCCInvoiceAmt,2)PCCInvoiceAmt,plos.PCCSpecialFlag, ");
            sb.Append(" IF(plos.PCCSpecialFlag=1,ROUND(plos.PCCNetAmt,2),0)SuperShare,IF(plos.PCCSpecialFlag=0,ROUND(plos.PCCNetAmt,2),0)NormalShare,");
            sb.Append(" ROUND(plos.PCCInvoiceAmt,2)ClientShare  "); 
            sb.Append(" , 0 HLM_Price,0  AmountTobeRefund ");
            sb.AppendFormat(" ,'{0}' SearchType FROM f_ledgertransaction lt    ", SearchType); 
            sb.Append(" INNER JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = lt.LedgerTransactionID  ");//AND plos.PCCInvoiceAmt>0
          
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plos.ItemID");
            sb.Append(" INNER JOIN f_Panel_Master fpm ON fpm.panel_ID=lt.panel_ID "); 
            sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID = lt.Patient_ID   ");
            sb.Append(" WHERE fpm.InvoiceTo =@InvoiceTo  AND IFNULL(plos.InvoiceNo, '') = ''  ");
            sb.AppendFormat(" AND plos.{0}>=@fromDate", Resources.Resource.LedgerReportDate);
            sb.AppendFormat(" AND plos.{0}<=@toDate AND plos.Rate<>0", Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append("  Group by plos.LedgerTransactionID,plos.itemid ORDER BY plos.Date "); 
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@InvoiceTo", Panel_ID),
               new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
               new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                    return Util.getJson(dt);
                else
                    return null;
            }
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
    [WebMethod(EnableSession = true)]
    public static string ExcelDetail(string Panel_ID, string SearchType, string fromDate, string toDate, int SearchTypeID, string PatientPayTo, string PaymentMode)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT DATE_FORMAT(plos.date,'%d-%b-%Y')RegDate,plos.LedgerTransactionNo,fpm.Company_Name Panel,CONCAT(pm.Title,' ',pm.PName)PName,CONCAT(pm.Age,'/',LEFT(pm.Gender,1))Age,  ");
            sb.Append(" im.TypeName ItemName ,plos.Amount NetAmount,plos.PCCInvoiceAmt ");
            sb.Append(" FROM f_ledgertransaction lt    ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID = lt.LedgerTransactionID  "); 
            sb.Append(" INNER JOIN f_itemmaster im ON im.ItemID=plos.ItemID");
            sb.Append(" INNER JOIN f_Panel_Master fpm ON fpm.panel_ID=lt.panel_ID ");
            sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID = lt.Patient_ID   ");
            sb.Append(" WHERE fpm.InvoiceTo =@InvoiceTo  ");
            sb.AppendFormat(" AND plos.{0}>=@fromDate", Resources.Resource.LedgerReportDate);
            sb.AppendFormat(" AND plos.{0}<=@toDate AND IFNULL(plos.InvoiceNo, '') = '' ", Resources.Resource.LedgerReportDate);
            if (Resources.Resource.LedgerReportDate == "SRADate")
                sb.Append(" AND plos.IsSRA=1 ");
            sb.Append("   ORDER BY plos.Date ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@InvoiceTo", Panel_ID),
               new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
               new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = "Invoice Report";
                    return "1";
                }
                else
                    return "0";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "-1";
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static string SaveInvoice(string data, string InvoiceDate, string fromDate, string toDate, string SearchType, int SearchTypeID, string PatientPayTo, string PaymentMode)
    {
        string[] PanelIDTags = data.Split(',');
        string[] PanelIDNames = PanelIDTags.Select((s, i) => "@tag" + i).ToArray();
        string PanelIDClause = string.Join(", ", PanelIDNames);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            string InvoiceNo = string.Empty;
            string[] rowData = data.Split(',');
            for (int j = 0; j < rowData.Length; j++)
            {
                string PanelID = Util.GetString(rowData[j]);
                string NewSaveLabNo = string.Empty;
                InvoiceNo = Util.GetString(MySqlHelper.ExecuteScalar(Tranx, CommandType.Text, " SELECT get_invoice_no(@SearchType,@InvoiceDate) ",
                   new MySqlParameter("@SearchType", SearchType),
                   new MySqlParameter("@InvoiceDate", Util.GetDateTime(InvoiceDate).ToString("yyyy-MM-dd"))));

                sb = new StringBuilder();
                sb.Append(@" SELECT ROUND(SUM(plos.Rate*plos.quantity),0) GrossAmount,ROUND(SUM(plos.DiscountAmt),0) DiscountOnTotal,ROUND(SUM(plos.Amount),0) NetAmount,ROUND(SUM(plos.PCCInvoiceAmt),0)ShareAmt 
                             FROM `f_ledgertransaction` lt  
                             INNER JOIN patient_labinvestigation_opd_share plos ON plos.LedgerTransactionID=lt.LedgerTransactionID  
                            
                             INNER JOIN f_panel_master pnl1 ON pnl1.Panel_ID=lt.Panel_ID
                     INNER JOIN f_panel_master pnlinv ON pnl1.InvoiceTo=pnlinv.Panel_ID ");
                sb.AppendFormat(" AND plos.{0}>=@fromDate ", Resources.Resource.LedgerReportDate);
                sb.AppendFormat(" AND plos.{0}<=@toDate", Resources.Resource.LedgerReportDate);
                if (Resources.Resource.LedgerReportDate == "SRADate")
                    sb.Append(" AND plos.IsSRA=1 ");
                sb.Append("  AND IFNULL(plos.InvoiceNo,'')=''  ");
                if (PanelID != string.Empty)
                    sb.Append(" AND pnl1.InvoiceTo =@PanelID ");
                sb.Append(" GROUP BY pnl1.InvoiceTo ");
              //  System.IO.File.WriteAllText(@"D:\ITDose\Jitm\ErrorLog\inv_creation.txt",sb.ToString());
               DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@PanelID", PanelID),
               new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " 00:00:00")),
               new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " 23:59:59"))).Tables[0]; 

                sb = new StringBuilder();
                sb.Append(" INSERT INTO invoiceMaster(InvoiceNo,PanelID,InvoiceDate,EntryByID,fromDate,toDate,ShareAmt,GrossAmount,DiscountOnTotal,NetAmount,EntryByName,InvoiceType)VALUES( ");
                sb.Append(" @InvoiceNo,@PanelID,@InvoiceDate,@EntryByID,@fromDate,@toDate,@ShareAmt, @GrossAmount,@DiscountOnTotal,@NetAmount,@EntryByName,@InvoiceType) ");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@InvoiceNo", InvoiceNo),
                   new MySqlParameter("@PanelID", PanelID),
                   new MySqlParameter("@InvoiceDate", Util.GetDateTime(InvoiceDate).ToString("yyyy-MM-dd")),
                   new MySqlParameter("@EntryByID", UserInfo.ID),
                   new MySqlParameter("@fromDate", Util.GetDateTime(fromDate).ToString("yyyy-MM-dd")),
                   new MySqlParameter("@toDate", Util.GetDateTime(toDate).ToString("yyyy-MM-dd")),
                   new MySqlParameter("@ShareAmt", Util.GetDecimal(dt.Rows[0]["ShareAmt"])),
                   new MySqlParameter("@GrossAmount", Util.GetDecimal(dt.Rows[0]["GrossAmount"])),
                   new MySqlParameter("@DiscountOnTotal", Util.GetDecimal(dt.Rows[0]["DiscountOnTotal"])),
                   new MySqlParameter("@NetAmount", Util.GetDecimal(dt.Rows[0]["NetAmount"])),
                   new MySqlParameter("@EntryByName", UserInfo.LoginName),
                   new MySqlParameter("@InvoiceType", SearchType));

                sb = new StringBuilder();
                sb.Append(" UPDATE patient_labinvestigation_opd_share plos inner join  `f_ledgertransaction` lt ON plos.LedgerTransactionID=lt.LedgerTransactionID   ");
             //   sb.Append(" inner join patient_labinvestigation_opd plo on plo.LedgertransactionID=plos.LedgertransactionID and plos.ItemID=plo.ItemID  AND IsActive=1 AND IF(isPackage=1,`SubCategoryID`=15,`SubCategoryID`!=15) ");
                sb.Append(" INNER JOIN f_panel_master pnl1 ON pnl1.Panel_ID=lt.Panel_ID  INNER JOIN f_panel_master pnlinv ON pnl1.InvoiceTo=pnlinv.Panel_ID   SET  ");
                sb.Append(" plos.InvoiceNo=@InvoiceNo,  ");
                sb.Append(" plos.InvoiceCreatedBy=@InvoiceCreatedBy,  ");
                sb.Append(" plos.InvoiceCreatedByID=@InvoiceCreatedByID,  ");
                sb.Append(" plos.InvoiceCreatedDate=NOW(),InvoiceAmt=@InvoiceAmt,plos.InvoiceDate=@InvoiceDate   ");
                sb.AppendFormat(" WHERE plos.{0}>=@fromDate  ", Resources.Resource.LedgerReportDate);
                sb.AppendFormat(" AND plos.{0}<=@toDate ", Resources.Resource.LedgerReportDate);
                if (Resources.Resource.LedgerReportDate == "SRADate")
                    sb.Append(" AND plos.IsSRA=1 ");
                sb.Append("  AND IFNULL(plos.InvoiceNo,'')=''  AND pnl1.InvoiceTo=@PanelID");
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, sb.ToString(),
                     new MySqlParameter("@InvoiceNo", InvoiceNo),
                     new MySqlParameter("@InvoiceCreatedBy", UserInfo.LoginName),
                     new MySqlParameter("@InvoiceCreatedByID", UserInfo.ID),
                     new MySqlParameter("@InvoiceAmt", Util.GetDecimal(dt.Rows[0]["ShareAmt"])),
                     new MySqlParameter("@InvoiceDate", Util.GetDateTime(InvoiceDate).ToString("yyyy-MM-dd")),
                     new MySqlParameter("@PanelID", PanelID),
                     new MySqlParameter("@fromDate", Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") + " 00:00:00"),
                     new MySqlParameter("@toDate", Util.GetDateTime(toDate).ToString("yyyy-MM-dd") + " 23:59:59")
                    );

                int isallow = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1)  FROM sms_configuration WHERE id=20 AND IsClient=1"));
                if (isallow == 1)
                {
                    DataTable dtclient = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Company_Name,Mobile,CentreType1ID FROM f_panel_master WHERE Panel_ID=@Panel_ID",
                        new MySqlParameter("@Panel_ID", PanelID)).Tables[0];
                    SMSDetail sd = new SMSDetail();
                    JSONResponse SMSResponse = new JSONResponse();

                    List<SMSDetailListRegistration> SMSDetail = new List<SMSDetailListRegistration>{  
                                                             new SMSDetailListRegistration {
                                                                 LabNo=Util.GetString(InvoiceNo), 
                                                                 PName = Util.GetString(dtclient.Rows[0]["Company_Name"]), 
                                                                 NetAmount=Util.GetString(Util.GetDecimal(dt.Rows[0]["ShareAmt"])),
                                                               GrossAmount=Util.GetString(Util.GetDecimal(dt.Rows[0]["GrossAmount"])),
                                                             AppointmentDate=Util.GetString(InvoiceDate)}};

                    if (Util.GetString(dtclient.Rows[0]["Mobile"]) != string.Empty)
                    {
                        SMSResponse = JsonConvert.DeserializeObject<JSONResponse>(sd.RegistrationSMS(20, Util.GetInt(PanelID), Util.GetInt(dtclient.Rows[0]["CentreType1ID"]), "Client", Util.GetString(dtclient.Rows[0]["Mobile"]), Util.GetInt(PanelID), con, Tranx, SMSDetail));
                        if (SMSResponse.status == false)
                        {
                            Tranx.Rollback();
                            return JsonConvert.SerializeObject(new { status = false, response = SMSResponse.response });
                        }
                    }
                    SMSDetail.Clear();
                }
            }

            Tranx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Record Save Successfully" });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            Tranx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


}