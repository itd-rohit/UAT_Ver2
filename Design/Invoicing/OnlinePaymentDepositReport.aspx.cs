using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Linq;
public partial class Design_Invoicing_OnlinePaymentDepositReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.bindBusinessZone(ddlBusinessZone, "Select");
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            chkCondition();
        }
    }

    private void chkCondition()
    {
        lblMsg.Text = string.Empty;

        if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6)
        {
            lblSearchType.Text = "1";
            ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script1", "showAccountSearch();", true);
        }
        else
        {
            if (HttpContext.Current.Session["IsSalesTeamMember"].ToString() == "1")
            {
                lblSearchType.Text = "2";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "hideSearchCriteria1();", true);
            }
            else
            {
                lblSearchType.Text = "3";
                ScriptManager.RegisterStartupScript(this.Page, this.GetType(), "script", "hideSearchCriteria();", true);
            }
        }
    }

    [WebMethod]
    public static string bindPanel(int BusinessZoneID, int StateID, int SearchType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int condition = 0;
            StringBuilder sb = new StringBuilder();
            if (UserInfo.RoleID == 1 || UserInfo.RoleID == 177 || UserInfo.RoleID == 6)
            {
                sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID Panel_ID,cm.Type1ID FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID");
                sb.Append(" WHERE fpm.isInvoice=1 ");
            }
            else
            {
                if (HttpContext.Current.Session["IsSalesTeamMember"].ToString() == "1")
                {
                    string SalesTeamMembers = AllLoad_Data.getSalesChildNode(con, UserInfo.ID);

                    string[] SalesManagerTags = SalesTeamMembers.Split(',');
                    string[] SalesManagerNames = SalesManagerTags.Select((s, i) => "@tags" + i).ToArray();
                    string SalesManagerClause = string.Join(", ", SalesManagerNames);

                    sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID Panel_ID,cm.Type1ID  ");
                    sb.Append(" FROM centre_master cm INNER JOIN f_panel_master fpm ON fpm.CentreID=cm.CentreID   ");
                    sb.Append(" AND fpm.SalesManager IN ({0})  ");
                    sb.Append(" WHERE   fpm.isInvoice=1   ");
                    using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), SalesManagerClause), con))
                    {
                        for (int i = 0; i < SalesManagerNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(SalesManagerNames[i], SalesManagerTags[i]);
                        }
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
                else
                {
                    condition = 1;
                    sb.Append("SELECT CONCAT(fpm.Panel_Code,' ~ ',fpm.Company_Name)Company_Name,fpm.Panel_ID Panel_ID,cm.Type1ID FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID");
                    sb.Append(" WHERE   fpm.isInvoice=1   ");
                    sb.Append("  AND ( cm.CentreID IN (SELECT CentreAccess FROM centre_access WHERE CentreID =@CentreID ) OR cm.CentreID =@CentreID ) ");
                }
            }

            if (condition == 0)
            {
                if (BusinessZoneID != 0)
                {
                    sb.Append(" AND cm.BusinessZoneID=@BusinessZoneID");
                }
                if (StateID != -1)
                {
                    sb.Append("  AND cm.StateID=@StateID ");
                }
                sb.Append(" AND cm.type1ID=@type1ID  ");
            }
            sb.Append(" AND fpm.Panel_ID=fpm.InvoiceTo   ");

            using (DataTable dt1 = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@BusinessZoneID", BusinessZoneID),
                 new MySqlParameter("@StateID", StateID),
                 new MySqlParameter("@type1ID", SearchType),
                 new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0])
            {
                if (dt1.Rows.Count > 0)
                    return Util.getJson(dt1);
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

    [WebMethod]
    public static string getReportData(string PanelID, DateTime FromDate, DateTime ToDate, int AllClient)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] PanelIDTags = PanelID.Split(',');
            string[] PanelIDNames = PanelIDTags.Select((s, i) => "@tag" + i).ToArray();
            string PanelIDClause = string.Join(", ", PanelIDNames);

            StringBuilder sb = new StringBuilder();

            sb.Append(" SELECT fpm.Panel_Code ClientCode, fpm.`Company_Name` ClientName,ivac.`ReceivedAmt` `Amount`, ivac.PaymentMode,ivac.EntryByName EntryBy,");
            sb.Append(" DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y') ReceiveDate ,DATE_FORMAT(ivac.EntryDate,'%d-%b-%Y %I:%i %p') `EntryDate`,");
            sb.Append("  IF(IFNULL(ivac.ApprovedOnDate,'')='','',DATE_FORMAT(ivac.Approvedondate,'%d-%b-%Y %I:%i %p'))`ApprovedDate`,CASE WHEN IsCancel=1 THEN 'Reject' WHEN ValidateStatus=0 THEN 'Pending' WHEN ValidateStatus=1 THEN 'Approve' END `Status`,");
            sb.Append(" IF(IsCancel=1,CancelReason,'')RejectReason,IsCancel,DATE_FORMAT(ivac.`receiveddate`,'%d-%b-%Y')ReceivedDate,CASE WHEN ivac.CreditNote=0 AND ivac.`ReceivedAmt`>0 THEN 'Deposit' WHEN ivac.CreditNote=1 THEN 'Credit Note' ");
            sb.Append(" WHEN ivac.CreditNote=2 THEN 'Debit Note' ELSE 'Cheque Bounce' END `Type`, IFNULL(eazyPayTransactionID,'')TnxID   FROM `invoicemaster_onaccount` ivac ");
            sb.Append(" INNER JOIN `f_panel_master` fpm ON ivac.`Panel_id` = fpm.`Panel_ID` WHERE  fpm.`Panel_ID`<>'' ");
            sb.Append(" AND ivac.PaymentMode='OnlinePayment' ");
            if (AllClient == 0)
                sb.Append(" AND ivac.panel_id IN({0}) ");
            sb.Append("  AND ivac.ValidateStatus=1  AND IsCancel=0 ");
            sb.Append(" AND ivac.`Approvedondate`>= @ApprovedFromDate AND  ivac.`EntryDate`<= @ApprovedToDate ");
            sb.Append(" ORDER BY `Approvedondate` ");
            string data = string.Empty;
            if (AllClient == 0)
                data = string.Format(sb.ToString(), PanelIDClause);
            else
                data = sb.ToString();
            using (MySqlDataAdapter da = new MySqlDataAdapter(data, con))
            {
                if (AllClient == 0)
                {
                    for (int i = 0; i < PanelIDNames.Length; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(PanelIDNames[i], PanelIDTags[i]);
                    }

                }

                da.SelectCommand.Parameters.AddWithValue("@ApprovedFromDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " 00:00:00"));
                da.SelectCommand.Parameters.AddWithValue("@ApprovedToDate", string.Concat(FromDate.ToString("yyyy-MM-dd"), " 23:59:59"));
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (dt != null && dt.Rows.Count > 0)
                    {
                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "Online Deposit Report ";
                        HttpContext.Current.Session["Period"] = "From : " + FromDate.ToString("dd-MMM-yyyy") + " To : " + ToDate.ToString("dd-MMM-yyyy");
                        return "1";
                    }
                    else
                    {
                        return "0";
                    }
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
}