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

public partial class Design_Master_EstimateSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            string str = "select CentreID,Concat(CentreCode,' ',Centre)Centre from centre_master where IsActive=1 ";
            ddlCentre.DataSource = StockReports.GetDataTable(str.ToString());
            ddlCentre.DataTextField = "Centre";
            ddlCentre.DataValueField = "CentreID";
            ddlCentre.DataBind();
            ddlCentre.Items.Insert(0, new ListItem("All", "0"));
        }
    }
    [WebMethod(EnableSession = true)]
    public static string GetEstimateData(string fromDate, string toDate, string EstimateID, string CentreID, string CentreName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT es.EstimateID,CONCAT(es.title,es.pname) PName,");
            sb.Append("  es.`Age`,es.`Gender`,es.`Mobile`, fpm.Company_Name `PanelName`, DATE_FORMAT(es.`CreatedDate`,'%d-%b-%Y %h:%i%p') RegDate, ");
            sb.Append("  IFNULL(es.Address,'') Address, SUM(es.Rate) AS Rate,SUM(es.Amount)Amount, ");
            sb.Append("  SUM(es.`DiscAmt`)DiscAmt, es.CreatedBy CreatedBy  ");
            sb.Append(" FROM estimate_billDetail es  ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=es.`Panel_ID`  ");

           
           
            if (EstimateID == string.Empty)
                sb.Append(" WHERE es.CreatedDate>=@fromDate AND es.CreatedDate<=@toDate ");
            else
                sb.Append(" AND es.EstimateID=@EstimateID");
            if (CentreName != "All")
            {
                sb.Append(" And  es.Centreid=@CentreID");
            }
            sb.Append(" GROUP BY es.EstimateID ORDER BY es.EstimateID  ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CentreID", CentreID),
               new MySqlParameter("@EstimateID", EstimateID),
               new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
               new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0];
            if (dt.Rows.Count > 0)
                return JsonConvert.SerializeObject(new { status = "true", response = Util.getJson(dt) });
            else
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
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
    public static string GetEstimateReport(string fromDate, string toDate, string EstimateID, string CentreID, string CentreName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT es.EstimateID EstimateNo,CONCAT(es.title,es.pname)Name,");
            sb.Append("  es.`Age`,es.`Gender`,es.`Mobile`,IFNULL(es.Email,'')Email, fpm.Company_Name `ClientName`, IFNULL(es.Address,'') Address, ");
            sb.Append(" sc.`Name`DepartmentName,itm.TestCode,itm.TypeName ItemName,es.Rate AS Rate,es.`DiscAmt`,es.Amount, DATE_FORMAT(es.`CreatedDate`,'%d-%b-%Y') RegDate,");
            sb.Append("  es.CreatedBy CreatedBy ,(SELECT centre FROM `centre_master`  WHERE  centreid=es.Centreid)Centre  ");
            sb.Append(" FROM estimate_billDetail es  ");
            sb.Append("  INNER JOIN f_panel_master fpm ON fpm.Panel_ID=es.`Panel_ID`  ");
            sb.Append(" INNER JOIN f_itemmaster itm ON itm.ItemID=es.ItemID  ");           
            sb.Append(" INNER JOIN f_subcategorymaster sc ON sc.`SubCategoryID`=es.`SubCategoryID`");
            if (EstimateID == string.Empty)
                sb.Append(" WHERE es.CreatedDate>=@fromDate AND es.CreatedDate<=@toDate ");
            else
                sb.Append(" AND es.EstimateID=@EstimateID");
            if (CentreName != "All")
            {
                sb.Append(" And  es.Centreid=@CentreID");
            }
            sb.Append(" ORDER BY es.EstimateID  ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
            new MySqlParameter("@CentreID", CentreID),
            new MySqlParameter("@EstimateID", EstimateID),
               new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
               new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0];
            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Estimate Detail Report";
                return JsonConvert.SerializeObject(new { status = "true", response = "" });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });

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
    public static string GetEstimateItemData(string EstimateID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT es.EstimateID,CONCAT(es.title,es.pname) PName,DATE_FORMAT(es.`CreatedDate`,'%d-%b-%Y %h:%i%p') RegDate,");
            sb.Append(" es.Rate AS Rate,es.Amount Amount,es.`DiscAmt` DiscAmt, es.CreatedBy CreatedBy, itm.TypeName ItemName,itm.TestCode ");
            sb.Append(" FROM estimate_billDetail es  ");           
            sb.Append(" INNER JOIN f_itemmaster itm ON itm.ItemID=es.ItemID  ");
          
           sb.Append(" AND es.EstimateID=@EstimateID");
            sb.Append("  ORDER BY es.EstimateID  ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@EstimateID", EstimateID)
              ).Tables[0];
            if (dt.Rows.Count > 0)
                return JsonConvert.SerializeObject(new { status = "true", response = Util.getJson(dt) });
            else
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });
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
    public static string encryptEstimateID(string EstimateID)
    {

        return JsonConvert.SerializeObject(new { status = "true", responseDetail = Common.EncryptRijndael(Util.GetString(EstimateID)) });

    }
    [WebMethod(EnableSession = true)]
    public static string GetEstimateReportSummary(string fromDate, string toDate, string EstimateID, string CentreID, string CentreName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT es.EstimateID EstimateNo,CONCAT(es.title,es.pname) Name,");
            sb.Append("  es.`Age`,es.`Gender`,es.`Mobile`,IFNULL(es.Email,'')Email, fpm.Company_Name `ClientName`,  ");
            sb.Append("  IFNULL(es.Address,'') Address, SUM(es.Rate) AS Rate, SUM(es.`DiscAmt`)DiscAmt,SUM(es.Amount)Amount, ");
            sb.Append("  DATE_FORMAT(es.`CreatedDate`,'%d-%b-%Y') RegDate,es.CreatedBy CreatedBy,(SELECT centre FROM `centre_master`  WHERE  centreid=es.Centreid)Centre  ");
            sb.Append(" FROM estimate_billDetail es  ");
            sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=es.`Panel_ID`  ");
            if (EstimateID == string.Empty)
                sb.Append(" WHERE es.CreatedDate>=@fromDate AND es.CreatedDate<=@toDate ");
            else
                sb.Append(" AND es.EstimateID=@EstimateID");
            if (CentreName != "All")
            {
                sb.Append(" And  es.Centreid=@CentreID");
            }
            sb.Append(" GROUP BY es.EstimateID ORDER BY es.EstimateID  ");
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@CentreID", CentreID),
               new MySqlParameter("@EstimateID", EstimateID),
               new MySqlParameter("@fromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
               new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0];
            if (dt.Rows.Count > 0)
            {
                HttpContext.Current.Session["dtExport2Excel"] = dt;
                HttpContext.Current.Session["ReportName"] = "Estimate Summary Report";
                return JsonConvert.SerializeObject(new { status = "true", response = "" });
            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, response = "No Record Found" });

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
}