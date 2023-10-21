using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_PhleboLoginReport : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;



        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
    }

    [WebMethod]
    public static string getReport(string dtFrom, string dtTo, string type)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string retValue = "0";
            DateTime dateFrom = Convert.ToDateTime(dtFrom);
            DateTime dateTo = Convert.ToDateTime(dtTo);
            StringBuilder sb = new StringBuilder();
            if (type == "1")
            {
                sb.Append("  SELECT  DATE_FORMAT(entrydate,'%d-%b-%Y')AS LoginDate ,COUNT(1) 'NoOfLogin' FROM  ");
                sb.Append(" (SELECT DISTINCT   DATE(entrydate)entrydate,Phlebotomistid ");
                sb.Append(" FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phelbotomistloginupdate`) a ");
                sb.Append(" WHERE entrydate>=@fromDate AND entrydate<=@toDate ");
                sb.Append(" GROUP BY entrydate ORDER BY entrydate ");
            }
            else
            {
                sb.Append("  SELECT DATE_FORMAT(pl.entrydate,'%d-%b-%Y %h:%i %p') LoginDateTime,  ");
                sb.Append("   pm.Phlebotomistid , pm.Name,pm.`Age`,pm.Gender,pm.Mobile,pm.Email,pm.UserName,GROUP_CONCAT( DISTINCT  CONCAT(sm.`state`,'-',cm.`City`)) AS WorkLocation,IF(pm.`IsActive`=1,'Yes','No') ActiveUser,  ");
                sb.Append("  IF(pm.IsTemp=1,'Temporary Phelbo','Permanent Phelbo') 'Phelbo Type',pm.PhelboSource  ");
                sb.Append("  FROM " + Util.getApp("HomeCollectionDB") + ".`hc_phelbotomistloginupdate` pl  ");
                sb.Append("  INNER JOIN " + Util.getApp("HomeCollectionDB") + ".`hc_phlebotomistmaster` pm ON pm.`PhlebotomistID`=pl.`Phlebotomistid`  ");
                sb.Append("  INNER JOIN " + Util.getApp("HomeCollectionDB") + ".hc_phleboworklocation pw ON pw.`PhlebotomistID`=pl.`Phlebotomistid` ");
                sb.Append("  INNER JOIN state_master sm ON sm.`id`=pw.`StateId` ");
                sb.Append("  INNER JOIN `city_master` cm ON cm.`ID`=pw.`CityId` ");
                sb.Append(" WHERE pl.entrydate>=@fromDate AND pl.entrydate<=@toDate");
                sb.Append(" GROUP BY pl.`Phlebotomistid`, pl.`EntryDate` ");
                sb.Append("  ORDER BY pl.`Phlebotomistid`,pl.`EntryDate` ");
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@fromDate", Util.GetDateTime(dateFrom).ToString("yyyy-MM-dd") + " 00:00:00"),
                      new MySqlParameter("@toDate", Util.GetDateTime(dateTo).ToString("yyyy-MM-dd") + " 23:59:59")).Tables[0])
            {
                if (dt != null && dt.Rows.Count > 0)
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    if (type == "1")
                    {
                        HttpContext.Current.Session["ReportName"] = "Phlebo Login Summary Report";
                    }
                    else
                    {
                        HttpContext.Current.Session["ReportName"] = "Phlebo Login Details Report";
                    }
                    HttpContext.Current.Session["Period"] = "From : " + dateFrom.ToString("dd-MMM-yyyy") + " To : " + dateTo.ToString("dd-MMM-yyyy");
                    retValue = "1";
                }
                return retValue;
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

    protected void btnReport_Click(object sender, EventArgs e)
    {


        DateTime dateFrom = Convert.ToDateTime(txtFromDate.Text);
        DateTime dateTo = Convert.ToDateTime(txtToDate.Text);

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT cm.`Centre` BookingCentre,lt.`LedgerTransactionNo` VisitNo,lt.`Patient_ID` UHID,lt.`PName`,lt.`Age`,lt.`Gender`, ");
        sb.Append(" sm.`MOBILE_NO`,sm.SMS_TEXT,(CASE WHEN sm.`IsSend` =1 THEN 'Success' WHEN sm.`IsSend` =-1 THEN 'Fail' ELSE 'Pending' END )SMSStatus, ");
        sb.Append(" sm.`SMS_Type`, sm.`UserID`, DATE_FORMAT(sm.`EntDate`,'%d-%b-%Y %h:%i:%s %p')EntryDate ,lt.Interface_companyName InterfaceFrom ");
        sb.Append(", DATE_FORMAT(sm.`Updatedate`,'%d-%b-%Y %h:%i %s %p') SmsSendDate ");
        sb.Append(" FROM sms sm ");
        sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.`LedgerTransactionID`=sm.`LedgerTransactionID` ");
        sb.Append(" INNER JOIN centre_master cm ON cm.`CentreID`=lt.`CentreID` ");
        sb.Append(" where (sm.EntDate)>='" + dateFrom.ToString("yyyy-MM-dd") + " 00:00:00' and (sm.EntDate)<='" + dateTo.ToString("yyyy-MM-dd") + " 23:59:59' ");



        AllLoad_Data.exportToExcel(sb.ToString(), "SMS Log Report", null, "0", Page);
    }
}