using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Design_Lab_DeptWisePendingList : System.Web.UI.Page
{
    public string AccessDepartment = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtFromDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToDate.Text = DateTime.Now.ToString("dd-MMM-yyyy");           
            txtFromTime.Text = "00:00:00";
            txtToTime.Text = "23:59:59";
            AccessDepartment = StockReports.ExecuteScalar("SELECT AccessDepartment FROM employee_master WHERE Employee_ID='"+UserInfo.ID+"'");
        }
        txtFromDate.Attributes.Add("readOnly", "true");
        txtToDate.Attributes.Add("readOnly", "true");
        bindCentreMaster();
        BindDepartment();
        reportaccess();
    }
    private bool reportaccess()
    {
        lblMsg.Text = "";
        ReportAccessRestriction objreport = new ReportAccessRestriction();
        ReportAccessList response = JsonConvert.DeserializeObject<ReportAccessList>(objreport.ReportAccess(37));
        if (response.status == true)
        {
            if (response.DurationInDay > 0)
            {
                DateTime date = Util.GetDateTime(txtFromDate.Text).AddDays(response.DurationInDay);
                if (date < DateTime.Now.Date)
                {
                    lblMsg.Text = "You are not authorized to view more than " + response.DurationInDay + " days data";
                    return false;
                }
            }
            //if (response.ShowPdf == 1 && response.ShowExcel == 0)
            //{
            //    rblreportformat.Items[0].Enabled = true;
            //    rblreportformat.Items[1].Enabled = false;
            //    rblreportformat.Items[0].Selected = true;
            //}
            //else if (response.ShowExcel == 1 && response.ShowPdf == 0)
            //{
            //    rblreportformat.Items[1].Enabled = true;
            //    rblreportformat.Items[0].Enabled = false;
            //    rblreportformat.Items[1].Selected = true;
            //}
            //else if (response.ShowPdf == 0 && response.ShowExcel == 0)
            //{
            //    rblreportformat.Visible = false;
            //    lblMsg.Text = "Report format not allowed contect to admin";
            //    return false;
            //}
            //else
            //{
            //    rdoReportFormat.Items[0].Selected = true;
            //}
        }
        else
        {
            div1.Visible = false;
            div2.Visible = false;
            lblMsg.Text = "UnAuthorize Access";
            return false;
        }
        return true;
    }
    private void bindCentreMaster()
    {
        ddlCentre.DataSource = AllLoad_Data.getCentreByLogin();
        ddlCentre.DataTextField = "centre";
        ddlCentre.DataValueField = "centreid";
        ddlCentre.DataBind();
      //  ddlCentre.Items.Add(new ListItem("All", ""));
        //ListItem selectedListItem = ddlCentre.Items.FindByValue(UserInfo.Centre.ToString());

        //if (selectedListItem != null)
        //{
        //    selectedListItem.Selected = true;
        //}
    }

    private void BindDepartment()
    {
       
        ddldept.DataSource = AllLoad_Data.getDepartment();
        ddldept.DataTextField = "NAME";
        ddldept.DataValueField = "SubCategoryID";
        ddldept.DataBind();       
    }


    [WebMethod]
    public static string getReport(string dtFrom, string dtTo, string CentreID, string deptid, string centrename, string TimeFrom, string TimeTo, string AccessDepartmentEmpWise,string ItemID,string ReportType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            DateTime dateFrom = Convert.ToDateTime(dtFrom);
            DateTime dateTo = Convert.ToDateTime(dtTo);
            StringBuilder sb = new StringBuilder();
            sb.Append("  SELECT ");
            sb.Append("  cm.Centre TestCentre,plo.`LedgerTransactionNo` LabNo ");
            sb.Append(" ,plo.`BarcodeNo`,lt.`PName`, ");
            sb.Append("  GROUP_CONCAT(plo.ItemName)TestName,  ");
            if (ReportType == "Excel")
            {
                sb.Append("  DATE_FORMAT(sl.`ReceivedDate`,'%d-%m-%Y %h:%i%p') SRADateTime, ");
            }
            else
            {
                sb.Append("  DATE_FORMAT(sl.`ReceivedDate`,'%d-%m-%Y %h:%i%p') LogisticReceiveDate, "); // Here LogisticReceiveDate Used For SRADateTime            
            }
            sb.Append("  CASE When plo.issamplecollected='Y' and plo.CultureStatus='Incubation' THEN 'Incubation'   ");
            sb.Append("  When plo.issamplecollected='Y' and ifnull(plo.CultureStatus,'') != 'Incubation' THEN 'Dept. Received'   ");
            sb.Append("  ELSE 'SRA Done' End CurrentStatus  ");
            sb.Append(" ,IF(plo.isrerun=1,'Rerun','')IsRerun,'' ISReflexTest ");
            sb.Append(" FROM `patient_labinvestigation_opd` plo ");
            sb.Append(" INNER JOIN `f_ledgertransaction` lt ON plo.`LedgerTransactionID`=lt.`LedgerTransactionID` and plo.isactive=1 ");
            sb.Append(" INNER JOIN centre_master cm ON cm.CentreID=plo.CentreID ");
            sb.Append(" INNER JOIN investigation_observationtype iot ON plo.investigation_ID=iot.investigation_ID ");
            sb.Append(" inner join observationtype_master ot on ot.ObservationType_ID=iot.ObservationType_ID");
            if (deptid != "")
            {
                sb.Append(" and ot.ObservationType_ID in ({0})");
            }
            
            sb.Append(" INNER JOIN `sample_logistic` sl ON sl.`BarcodeNo`=plo.`BarcodeNo` and sl.testid=plo.test_id  and sl.isactive=1  ");//and sl.tocentreid=@CentreID
            if (CentreID.Trim() != "")
            {
                sb.Append("   and  sl.tocentreid  in ({1}) ");
            }
            sb.Append(" AND sl.`Status`='Received' AND plo.`IsSampleCollected` IN('S','Y') AND plo.`Result_Flag`=0 AND plo.IsRefund=0 ");
            if (ItemID.Trim() != "" && ItemID.Trim() != "All")
                sb.Append(" and plo.Itemid=@Itemid");
            sb.Append("  where  ");
            sb.Append(" plo.Date>=@fromDate and plo.Date<=@toDate");
            sb.Append("  Group by plo.Barcodeno ORDER BY sl.`ReceivedDate`,plo.`LedgerTransactionNo`,ot.Name,plo.`ItemName` ");


            DataTable dt = new DataTable();


            List<string> DeptDataList = new List<string>();
            DeptDataList = deptid.ToString().Split(',').ToList<string>();
            List<string> AccessDeptDataList = new List<string>();
            AccessDeptDataList = CentreID.ToString().Split(',').ToList<string>();

            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", DeptDataList), string.Join(",", AccessDeptDataList)), con))
            {
                for (int i = 0; i < DeptDataList.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@s", i), DeptDataList[i]);
                }
                for (int i = 0; i < AccessDeptDataList.Count; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(string.Concat("@a", i), AccessDeptDataList[i]);
                }
                da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(dateFrom).ToString("yyyy-MM-dd") , " " , TimeFrom.Trim()));
                da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(dateTo).ToString("yyyy-MM-dd") , " " ,TimeTo.Trim()));
                da.SelectCommand.Parameters.AddWithValue("@Itemid", ItemID.Trim());            
                da.Fill(dt);



                if (dt != null && dt.Rows.Count > 0)
                {
                    if (ReportType == "Excel")
                    {
                        HttpContext.Current.Session["dtExport2Excel"] = dt;
                        HttpContext.Current.Session["ReportName"] = "Pending report from " + Util.GetDateTime(dateFrom).ToString("dd-MM-yyyy") + " " + TimeFrom.Trim() + " To " + Util.GetDateTime(dateTo).ToString("dd-MM-yyyy") + " " + TimeTo.Trim() + "";
                        HttpContext.Current.Session["Period"] = "";
                    }
                    else
                    {
                        DataColumn dc1 = new DataColumn();
                        dc1.ColumnName = "ReportHeading";
                        dc1.DefaultValue =   Util.GetDateTime(dateFrom).ToString("dd-MM-yyyy") + " " + TimeFrom.Trim() + " To " + Util.GetDateTime(dateTo).ToString("dd-MM-yyyy") + " " + TimeTo.Trim() + "";
                        dt.Columns.Add(dc1);
                        DataColumn dc2 = new DataColumn();
                        dc2.ColumnName = "PrintedByID";
                        dc2.DefaultValue = Util.GetString(UserInfo.ID);
                        dt.Columns.Add(dc2);
                        DataColumn dc3 = new DataColumn();
                        dc3.ColumnName = "PrintedByName";
                        dc3.DefaultValue = UserInfo.LoginName;
                        dt.Columns.Add(dc3);

                        DataSet ds = new DataSet();
                        ds.Tables.Add(dt.Copy());
                        ds.Tables[0].TableName = "Table";
                        // ds.WriteXmlSchema(@"D://DeptPendingList.xml");
                        HttpContext.Current.Session["dtDeptPendingList"] = dt;                        
                    }
                    return "1";
                }
                else
                {
                    return "0";
                }
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
    [WebMethod(EnableSession = true)]    
    public static string GetDepartmentWiseItem(string SubCategoryID, string AccessDepartmentEmp)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("SELECT ItemID,CONCAT(TestCode,' ~ ',TypeName)TypeName FROM f_itemmaster WHERE IsActive=1 ");
        if (SubCategoryID.Trim() != "")
        {
            sb.Append(" AND SubcategoryID in(" + SubCategoryID + ") ");
        }
        else if (AccessDepartmentEmp.Trim()!="")
        {
            sb.Append(" AND SubcategoryID in(" +AccessDepartmentEmp + ") ");
        }
        sb.Append(" ORDER BY TypeName;");
        return Util.getJson(StockReports.GetDataTable(sb.ToString()));
    }   
}