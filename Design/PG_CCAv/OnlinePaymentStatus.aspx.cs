using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Services;
using System.Web.Script.Services;
using MySql.Data.MySqlClient;

public partial class Design_Master_OnlinePaymentStatus : System.Web.UI.Page
{
    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DataTable dt = StockReports.GetDataTable("select Panel_Id ID,Company_Name Name from f_Panel_Master where IsActive=1 order by Company_Name;");
            if (dt.Rows.Count > 0)
            {
                ddlCompany.DataSource = dt;
                ddlCompany.DataTextField = "Name";
                ddlCompany.DataValueField = "ID";
                ddlCompany.DataBind();
                ddlCompany.Items.Insert(0, new ListItem("Select", "Select"));
            }
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");

        }
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string Search(string CompanyID, string dtFrom, string dtTo, string Amount, string SearchType)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT mtb.Name as PanelName,mtb.ID,Date_Format(mtb.ScheduleEntryDate,'%d-%m-%y')ScheduleEntryDate,mtb.Panel_Code,mtb.Remark, mtb.IsSuccess, ");
        sb.Append(" mtb.Amount,Date_Format(mtb.EntryDate,'%d-%m-%y')EntryDate,mtb.OrderId OrderNo,mtb.payUTracking_id BankRefNo,  ");
        sb.Append(" CASE WHEN mtb.IsSuccess=1 THEN 'Success' WHEN mtb.IsSuccess=0 THEN 'Pending' WHEN mtb.IsSuccess=2 THEN 'Canceled' ELSE '' END STATUS, ");
        sb.Append(" CASE WHEN mtb.IsSuccess = '2' THEN '#B0C4DE'  WHEN mtb.IsSuccess = '1' THEN '#90EE90' WHEN mtb.IsSuccess = '0' THEN '#FFFFFF' ");
        sb.Append("  ELSE '#FFFFFF' END rowColor ");
        sb.Append(" FROM `panel_paymentprev_details` mtb ");       
        sb.Append(" WHERE mtb.EntryDate>='" + Util.GetDateTime(dtFrom).ToString("yyyy-MM-dd") + " 00:00:00' AND mtb.EntryDate<='" + Util.GetDateTime(dtTo).ToString("yyyy-MM-dd") + " 23:59:59' ");
        if (CompanyID.Trim() != "")
        {
            sb.AppendLine(" and mtb.Panel_Id='" + CompanyID.Trim() + "' ");
        }
        if (Amount.Trim() != "")
        {
            sb.Append(" and mtb.Amount='" + Amount.Trim() + "' ");
        }
        if (SearchType != "")
        {
            sb.Append(" " + SearchType);
        }
        sb.Append(" order by mtb.EntryDate desc");
        if (Util.GetString(HttpContext.Current.Session["ID"]) == "EMP001")
        {
             System.IO.File.WriteAllText("C:\\PaymentSearch.txt", sb.ToString());
        }
        DataTable dt = StockReports.GetDataTable(sb.ToString());

        return makejsonoftable(dt, makejson.e_without_square_brackets);
    }
    [WebMethod]
    public static string resendUpdateRequst(int ID)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string str = "UPDATE panel_paymentprev_details SET IsSuccess=0 WHERE ID='" + ID + "'";
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, str);
            tnx.Commit();
            con.Close();
            con.Dispose();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            con.Close();
            con.Dispose();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return "0";
        }

    }
    public static string makejsonoftable(DataTable table, makejson e)
    {
        StringBuilder sb = new StringBuilder();
        foreach (DataRow dr in table.Rows)
        {
            if (sb.Length != 0)
                sb.Append(",");
            sb.Append("{");
            StringBuilder sb2 = new StringBuilder();
            foreach (DataColumn col in table.Columns)
            {
                string fieldname = col.ColumnName;
                string fieldvalue = dr[fieldname].ToString();
                if (sb2.Length != 0)
                    sb2.Append(",");
                sb2.Append(string.Format("{0}:\"{1}\"", fieldname, fieldvalue));


            }
            sb.Append(sb2.ToString());
            sb.Append("}");


        }
        if (e == makejson.e_with_square_brackets)
        {
            sb.Insert(0, "[");
            sb.Append("]");
        }
        return sb.ToString();


    }
}