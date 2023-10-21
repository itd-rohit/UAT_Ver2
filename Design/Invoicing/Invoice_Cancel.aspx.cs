using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Services;

public partial class Design_Invoicing_Invoice_Cancel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }
    [WebMethod]
    public static string SearchInvoiceCancel(string dtFrom, string dtTo, string PanelID, string InvoiceNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT CONCAT(pnl.Panel_Code,'-',pnl.`Company_Name`) AS PanelName, ");
            sb.Append(" im.InvoiceNo ,  DATE_FORMAT(im.`InvoiceDate`,'%d-%b-%Y')Date,im.GrossAmount InvoiceAmt,EntryByName InvoiceCreatedBy,im.EntryByID ");
            sb.Append(" FROM  `invoiceMaster` im ");
            sb.Append(" INNER JOIN `f_Panel_master` pnl ON pnl.`Panel_ID`=im.`PanelID` AND pnl.InvoiceCreatedOn=2");
            if (InvoiceNo != string.Empty)
                sb.Append(" AND im.InvoiceNo=@InvoiceNo");
            if (InvoiceNo == string.Empty)
            {
                if (PanelID != string.Empty)
                    sb.Append(" AND pnl.`Panel_ID`=@Panel_ID");
                if (dtFrom != string.Empty)
                    sb.Append(" AND im.`InvoiceDate`>=@fromInvoiceDate");
                if (dtTo != string.Empty)
                    sb.Append("  AND im.`InvoiceDate`<=@toInvoiceDate");
            }
            sb.Append(" AND im.`isCancel`=0 ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@InvoiceNo", InvoiceNo),
                new MySqlParameter("@Panel_ID", PanelID),
                new MySqlParameter("@fromInvoiceDate", string.Concat(Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                new MySqlParameter("@toInvoiceDate", string.Concat(Util.GetDateTime(dtTo).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
                return Util.getJson(dt);
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

    public class InvoiceData
    {
        public string InvoiceNo { get; set; }
        public double InvoiceAmt { get; set; }
        public int InvoiceCreatedBy { get; set; }
        public string InvoiceDate { get; set; }
    }

    [WebMethod]
    public static string SaveInvoiceCancel(object InvoiceDetail, string CancelReason)
    {
        List<InvoiceData> InvoiceDetails = new JavaScriptSerializer().ConvertToType<List<InvoiceData>>(InvoiceDetail);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        StringBuilder sb = new StringBuilder();
        try
        {
            for (int k = 0; k < InvoiceDetails.Count; k++)
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1)  FROM invoicemaster_onaccount WHERE InvoiceNo=@InvoiceNo AND isCancel=0",
                   new MySqlParameter("@InvoiceNo", Util.GetString(InvoiceDetails[k].InvoiceNo))));

                if (count > 0)
                {
                    return Util.GetString(Util.GetString(InvoiceDetails[k].InvoiceNo)) + "$" + "2";
                }

                else
                {
                    sb = new StringBuilder();
                    sb.Append(" UPDATE `patient_labinvestigation_opd_Share` SET   ");
                    sb.Append(" InvoiceNo_old=InvoiceNo,InvoiceAmt_old=InvoiceAmt,InvoiceCreatedBy_old=InvoiceCreatedBy,");
                    sb.Append(" InvoiceCreatedByID_old=InvoiceCreatedByID,InvoiceCreatedDate_old=InvoiceCreatedDate,InvoiceDate_old=InvoiceDate,");
                    sb.Append(" InvoiceNo='',InvoiceAmt='0.0',InvoiceDate='0001-01-01',InvoiceCreatedDate='0001-01-01 00:00:00',InvoiceCreatedBy='',InvoiceCreatedByID=0 ");
                   
                    sb.Append("  WHERE InvoiceNo=@InvoiceNo  ");
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                        new MySqlParameter("@InvoiceNo", InvoiceDetails[k].InvoiceNo));
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "Update invoiceMaster SET IsCancel=1,CancelDate=NOW(),CancelReason=@CancelReason,Cancel_UserID=@Cancel_UserID WHERE InvoiceNo=@InvoiceNo",
                       new MySqlParameter("@CancelReason", CancelReason),
                       new MySqlParameter("@Cancel_UserID", UserInfo.ID),
                       new MySqlParameter("@InvoiceNo", InvoiceDetails[k].InvoiceNo));
                }
            }
            tnx.Commit();
            return " " + "$" + "1"; ;
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string bindPanel(int BusinessZoneID, int StateID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID FROM f_panel_master fpm");
            sb.Append(" WHERE fpm.Panel_ID=fpm.InvoiceTo   ");
            if (BusinessZoneID != 0)
                sb.Append(" and fpm.BusinessZoneID=@BusinessZoneID");
            if (StateID != -1)
                sb.Append("  AND fpm.StateID=@StateID ");

            //sb.Append("      ");//AND cm.IsActive=1  
            sb.Append("   AND fpm.IsActive=1  AND fpm.IsInvoice=1 AND fpm.InvoiceCreatedOn=2 AND fpm.IsPermanentClose=0");
            sb.Append(" ORDER BY fpm.Company_Name");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@BusinessZoneID", BusinessZoneID),
               new MySqlParameter("@StateID", StateID)).Tables[0])
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
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}