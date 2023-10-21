using MySql.Data.MySqlClient;
using System;
using System.Collections.Specialized;
using System.Data;
using System.Text;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Support_ViewTicket : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromTime.Text = "06:00:00";
            txtToTime.Text = "23:59:59";
            txtFormDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFormDate.Attributes.Add("readonly", "readonly");
            txtToDate.Attributes.Add("readonly", "readonly");
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                if (Util.GetString(Session["IsPanel"]) == "Yes")
                {
                    string PanelCode = Util.GetString(MySqlHelper.ExecuteScalar(con, System.Data.CommandType.Text, "SELECT `panel_code` FROM f_panel_master WHERE `EmployeeID`=@EmployeeID",
                        new MySql.Data.MySqlClient.MySqlParameter("@EmployeeID", UserInfo.ID)));
                    txtPcc.Text = PanelCode;
                    txtPcc.Attributes.Add("readonly", "readonly");
                }

                ddldept.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT NAME,`ObservationType_ID`  FROM  `observationtype_master` WHERE isactive=1 and name<>'Discount Card' ORDER BY NAME ").Tables[0];
                ddldept.DataTextField = "NAME";
                ddldept.DataValueField = "ObservationType_ID";
                ddldept.DataBind();
                ddldept.Items.Insert(0, new ListItem("", ""));
                ddldept.Items.Add(new ListItem("ALL", "ALL"));
            }

            catch (Exception ex)
            {
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }

    }

    protected void btn_clickExportToExcel(object sender, EventArgs e)
    {


        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT s.`ID` `Ticket No` ,tcm.CategoryName,s.EmailID,s.`Subject`,s.`VialId` `Barcode No`,s.RegNo,IF(s.`PanelId`='','',IFNULL(fpm.`Company_Name`,'')) Client, s.itemid LabNo,");
            sb.Append("   DATE_FORMAT(s.`dtAdd`,'%d %b %Y %h:%i %p') Date,s.STATUS,s.`EmpName` `Raised By`,");
            sb.Append("   CONCAT(s.SessionCentreName,'-',s.SessionRoleName) `Raised From` , DATE_FORMAT(s.`Updatedate`,'%d %b %Y %h:%i %p')UpdateDate,s.`UpdateName` `Updated By` FROM `support_error_record` s");
            sb.Append("   INNER JOIN support_error_Access sea ");
            sb.Append("   ON s.ID= sea.TicketID");

            sb.Append(" INNER JOIN `ticketing_category_master` tcm ON tcm.`ID`=s.`CategoryID` ");
            sb.Append("   INNER JOIN ticketing_categoryemployee tce ON tce.`CategoryID`=tcm.ID");

            sb.Append(" LEFT JOIN f_panel_master fpm ON fpm.`Panel_ID`=s.`PanelId` ");

            sb.Append(" WHERE s.`dtAdd` >=@FromDate AND s.`dtAdd` <=@ToDate ");
            sb.Append("  AND sea.Employee_ID=@Employee_ID AND IF(tce.`CentreID`=0,1=1,tce.`CentreID`=@CentreID)");

            if (txtIssueNo.Text != string.Empty)
            {
                sb.Append(" AND s.`ID`=@ID ");
            }
            if (txtVialId.Text != string.Empty)
            {
                sb.Append(" AND s.`VialId`=@VialId");
            }
            if (txtRegNo.Text != string.Empty)
            {
                sb.Append(" AND s.`RegNo`=@RegNo");
            }
            if (txtPcc.Text != string.Empty)
            {
                sb.Append(" AND fpm.`Company_name` Like @Company_name");
            }



            sb.Append(" GROUP BY s.`Employee_Id`,S.ID ORDER BY   s.dtAdd DESC");

            string Period = string.Format("{0} {1}-{2} {3}", txtFormDate.Text, txtFromTime.Text, txtToDate.Text, txtToTime.Text);


            NameValueCollection collections = new NameValueCollection();
            collections.Add("ReportDisplayName", Common.EncryptRijndael("Customer care Report (Detail)"));
            collections.Add("ID#0", Common.EncryptRijndael(txtIssueNo.Text.ToUpper().Replace("PIM", "")));

            collections.Add("FromDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd"), " ", txtFromTime.Text)));
            collections.Add("ToDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), " ", txtToTime.Text)));
            collections.Add("VialId#0", Common.EncryptRijndael(txtVialId.Text));
            collections.Add("Employee_ID#0", Common.EncryptRijndael(Util.GetString(UserInfo.ID)));
            collections.Add("CentreID#0", Common.EncryptRijndael(Util.GetString(UserInfo.Centre)));
            collections.Add("RegNo#0", Common.EncryptRijndael(txtRegNo.Text));
            collections.Add("Company_name#3", Common.EncryptRijndael(txtPcc.Text));
            collections.Add("Query", Common.EncryptRijndael(sb.ToString()));
            collections.Add("Period", Common.EncryptRijndael(Period));

            AllLoad_Data.ExpoportToExcelEncrypt(collections, 2, this.Page);



            
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally
        {


        }
    }

    private DataTable createtable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("SrNo");
        dt.Columns.Add("Description");
        dt.Columns.Add("No");
        return dt;
    }

    protected void btnExTOExcel2_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("   SELECT");
            sb.Append("   COUNT(*) No_of_Tickets_received ");
            sb.Append(" , 0 Ticekts_picked_up_within_escalation_time ");
            sb.Append(" , 0 `Tickets_ecalated(to_Team_lead_&_above)` ");
            sb.Append(" , SUM(IF(s.`VialId`<>'','0','1')) Tickets_shared_with_Department ");
            sb.Append(" , 0 Tickets_resolved_by_Department_within_escalation_time ");
            sb.Append(" , 0 `Tickets_escalated(department_Head_and_above)` ");
            sb.Append(" , 0 Tickets_resolved_within_TAT ");
            sb.Append(" , SUM(IF(STATUS='New' || STATUS='Support Reply',1,0)) Tickets_pending");
            sb.Append(" , SUM(IF(STATUS='Resolved',1,0)) Tickets_resolved");
            sb.Append(" , SUM(IF(STATUS='Closed',1,0)) Ticket_closed");
            sb.Append("  FROM support_error_record s");
            sb.Append(" WHERE s.`dtAdd` >=@FromDate AND s.`dtAdd` <=@ToDate");






            using (DataTable mydata = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@FromDate", string.Concat(Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd"), " ", txtFromTime.Text)),
                 new MySqlParameter("@ToDate", string.Concat(Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), " ", txtToTime.Text))).Tables[0])
            {
                if (mydata.Rows.Count < 1)
                {
                    ScriptManager.RegisterClientScriptBlock(this, GetType(), "key", "toast('Info','No Record Found');", true);
                    return;
                }
                DataTable dtc = createtable();
                int a = 1;
                foreach (DataColumn dc in mydata.Columns)
                {
                    DataRow dw = dtc.NewRow();
                    dw["SrNo"] = a.ToString();
                    dw["Description"] = dc.ColumnName.Replace('_', ' ');
                    dw["No"] = mydata.Rows[0][dc.ColumnName].ToString();
                    dtc.Rows.Add(dw);
                    a++;
                }

                Session["dtExport2Excel"] = dtc;
                Session["ReportName"] = "Customer care Report (Summary)";
                Session["Period"] = string.Format("{0} {1}-{2} {3}", txtFormDate.Text, txtFromTime.Text, txtToDate.Text, txtToTime.Text);
                ScriptManager.RegisterClientScriptBlock(this, GetType(), "key1", "window.open('../Common/ExportToExcel.aspx');", true);

            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }

    protected void btnExcel3_Click(object sender, EventArgs e)
    {

        StringBuilder sb = new StringBuilder();

        sb.Append(" SELECT DISTINCT s.`ID` ,tcm.CategoryName,s.`Subject`,s.EmailID,s.`VialId` `Barcode No`,s.RegNo,IF(s.`PanelId`='','',IFNULL(fpm.`Company_Name`,'')) Client, s.itemid LabNo, ");
        sb.Append("  DATE_FORMAT(s.`dtAdd`,'%d %b %Y %h:%i %p') Date,s.STATUS,s.`EmpName` `Raised By`, ");
        sb.Append("   CONCAT(s.SessionCentreName,'-',s.SessionRoleName) `Raised From`, ser.`Answer` `Remark`,DATE_FORMAT(ser.dtEntry,'%d %b %Y %h:%i %p') `Remark Date` FROM `support_error_record` s ");
        sb.Append("   INNER JOIN support_error_Access sea ");
        sb.Append("   ON s.ID= sea.TicketID");
        sb.Append(" INNER JOIN support_error_reply ser ON ser.`TicketId`=s.`ID`");
        sb.Append(" INNER JOIN `ticketing_category_master` tcm ON tcm.`ID`=s.`CategoryID` ");
        sb.Append("   INNER JOIN ticketing_categoryemployee tce ON tce.`CategoryID`=tcm.ID");

        sb.Append(" LEFT JOIN f_panel_master fpm ON fpm.`Panel_ID`=s.`PanelId` ");

        sb.Append(" WHERE s.`dtAdd` >=@FromDate AND s.`dtAdd` <=@ToDate ");
        sb.Append("AND sea.Employee_ID=@Employee_ID AND IF(tce.`CentreID`=0,1=1,tce.`CentreID`=@CentreID)");

        if (txtIssueNo.Text != string.Empty)
        {
            sb.Append(" AND s.`ID`=@ID ");
        }
        if (txtVialId.Text != string.Empty)
        {
            sb.Append(" AND s.`VialId`=@VialId");
        }
        if (txtRegNo.Text != string.Empty)
        {
            sb.Append(" AND s.`RegNo`=@RegNo");
        }



        if (txtPcc.Text != string.Empty)
        {
            sb.Append(" AND fpm.`Company_name` like @Company_name");
        }


        sb.Append(" ORDER BY   s.dtAdd DESC");

        string Period = string.Format("{0} {1}-{2} {3}", txtFormDate.Text, txtFromTime.Text, txtToDate.Text, txtToTime.Text);


        NameValueCollection collections = new NameValueCollection();
        collections.Add("ReportDisplayName", Common.EncryptRijndael("Customer care Report (Detail)"));
        collections.Add("ID#0", Common.EncryptRijndael(txtIssueNo.Text.ToUpper().Replace("PIM", "")));

        collections.Add("FromDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtFormDate.Text).ToString("yyyy-MM-dd"), " ", txtFromTime.Text)));
        collections.Add("ToDate#0", Common.EncryptRijndael(string.Concat(Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), " ", txtToTime.Text)));
        collections.Add("VialId#0", Common.EncryptRijndael(txtVialId.Text));
        collections.Add("Employee_ID#0", Common.EncryptRijndael(Util.GetString(UserInfo.ID)));
        collections.Add("CentreID#0", Common.EncryptRijndael(Util.GetString(UserInfo.Centre)));
        collections.Add("RegNo#0", Common.EncryptRijndael(txtRegNo.Text));
        collections.Add("Company_name#3", Common.EncryptRijndael(txtPcc.Text));
        collections.Add("Query", Common.EncryptRijndael(sb.ToString()));
        collections.Add("Period", Common.EncryptRijndael(Period));

        AllLoad_Data.ExpoportToExcelEncrypt(collections, 2, this.Page);
    }
    [WebMethod]
    public static string encryptData(string ID)
    {
        return Common.EncryptRijndael(ID);
    }
}