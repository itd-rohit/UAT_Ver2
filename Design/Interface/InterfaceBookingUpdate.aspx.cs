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

public partial class Design_Master_InterfaceBookingUpdate : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            BindCompany();
        }

    }

    private void BindCompany()
    {
        using (DataTable dt = StockReports.GetDataTable("Select ID,CompanyName from f_Interface_Company_Master  order by CompanyName"))
        {
            ddlCompany.DataSource = dt;
            ddlCompany.DataTextField = "CompanyName";
            ddlCompany.DataValueField = "ID";
            ddlCompany.DataBind();
        }
    }

    [WebMethod]
    public static string searchInterface(string fromDate, string toDate, string CompanyName, string SearchType, string TypeOfOperation, string SearchField, string SearchData, int CompanyID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            if (TypeOfOperation.Trim() == "Patient Details")
            {
                sb.Append(" SELECT pd.ID,@TypeOfOperationTableName,pd.`InterfaceClient` InterfaceClient,'' WorkOrderID,pd.`PName` PatientName, ");
                sb.Append(" pd.`Patient_ID` UHIDNo,pd.`Gender` Gender,pd.`Age` Age,DATE_FORMAT(pd.`DOB`,'%d-%b-%Y') DOB,'' TPAName, ");
                sb.Append(" ''CorporateIDCard,pd.`Response` Response,pd.`IsUpdated`, ");
                sb.Append(" CASE  ");
                sb.Append(" WHEN pd.IsUpdated=1 THEN 'Updated'   ");
                sb.Append(" WHEN pd.IsUpdated=0 THEN 'Pending'   ");
                sb.Append(" WHEN pd.IsUpdated=-1 THEN 'Faild'  ");
                sb.Append(" END AS STATUS ");
                sb.Append(" FROM booking_data_update_patient_details pd  ");
                sb.Append(" WHERE pd.dtEntry>=@fromDate ");
                sb.Append(" AND pd.dtEntry<=@toDate ");
                if (SearchType.Trim() != "2")
                {
                    sb.Append(" AND pd.IsUpdated=@SearchType");
                }
                if (SearchField.Trim() == "Work Order ID" && SearchData.Trim() != string.Empty)
                {
                }
                else if (SearchField.Trim() == "UHID No" && SearchData.Trim() != string.Empty)
                {
                    sb.Append(" AND pd.Patient_ID=@SearchData ");
                }
                sb.Append("AND pd.InterfaceClientID=@CompanyNameID");
                sb.Append(" ORDER BY pd.ID ");
            }
            else if (TypeOfOperation.Trim() == "Visit Details")
            {
                sb = new StringBuilder();
                sb.Append(" SELECT  pd.ID,@TypeOfOperationTableName,pd.`InterfaceClient` InterfaceClient,'' WorkOrderID,''PatientName, ");
                sb.Append(" pd.`Patient_ID` UHIDNo,''Gender,'' Age,''DOB,pd.TPA_Name TPAName, ");
                sb.Append(" pd.Employee_ID CorporateIDCard,pd.`Response` Response,pd.`IsUpdated`,  ");
                sb.Append(" CASE  ");
                sb.Append(" WHEN pd.IsUpdated=1 THEN 'Updated'   ");
                sb.Append(" WHEN pd.IsUpdated=0 THEN 'Pending'   ");
                sb.Append(" WHEN pd.IsUpdated=-1 THEN 'Faild'  ");
                sb.Append(" END AS STATUS ");
                sb.Append(" FROM booking_data_update_visit_details pd  ");
                sb.Append(" WHERE pd.dtEntry>=@fromDate ");
                sb.Append(" AND pd.dtEntry<=@toDate ");
                if (SearchType.Trim() != "2")
                {
                    sb.Append(" AND pd.IsUpdated=@SearchType ");
                }
                if (SearchField.Trim() == "Work Order ID" && SearchData.Trim() != "")
                {
                    sb.Append(" AND pd.origin_patient_id=@SearchData ");
                }
                else if (SearchField.Trim() == "UHID No" && SearchData.Trim() != "")
                {
                    sb.Append(" AND pd.Patient_ID=@SearchData ");
                }
                sb.Append("AND pd.InterfaceClientID=@CompanyNameID ");
                sb.Append(" ORDER BY pd.ID ");
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@TypeOfOperation", TypeOfOperation),
                new MySqlParameter("@fromDate",string.Concat( Util.GetDateTime(fromDate).ToString("yyyy-MM-dd") , " 00:00:00")),
                new MySqlParameter("@toDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd") , " 23:59:59")),
                new MySqlParameter("@SearchType", SearchType),
                new MySqlParameter("@SearchData", SearchData),
                new MySqlParameter("@CompanyNameID", CompanyID)
                    ).Tables[0])
            {
                return Util.getJson(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return Util.getJson(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static string bindInstaCentre()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CentreID_interface CentreID,Interface_CentreName FROM `centre_master_interface` ORDER BY `Interface_CentreName` ").Tables[0])
            {
                return Util.getJson(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return ex.GetBaseException().ToString();
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod]
    public static bool compareDate(DateTime fromDate, DateTime toDate)
    {

        double diffDays = (toDate - fromDate).TotalDays;
        if (diffDays > 2 || diffDays < 0)
            return false;
        else
            return true;
    }
    [WebMethod]
    public static string resendInterface(string ID, string TableName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE ");
            if (TableName.Trim() == "Patient Details")
            {
                sb.Append(" booking_data_update_patient_details ");
            }
            else if (TableName.Trim() == "Visit Details")
            {
                sb.Append(" booking_data_update_visit_details ");
            }
            sb.Append(" SET IsUpdated='0',Response='' WHERE ID=@ID ");
            MySqlHelper.ExecuteScalar(con, CommandType.Text,sb.ToString(),
                new MySqlParameter("@ID", ID));
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