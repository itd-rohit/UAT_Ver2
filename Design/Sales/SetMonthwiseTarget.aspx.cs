using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Serialization;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Designation_SetMonthwiseTarget : System.Web.UI.Page
{
    decimal MonthTarget = 0;
    string MonthID = "", YearID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            MonthTarget = Util.GetDecimal(Request.QueryString["MonthTarget"].ToString());

            if (Util.GetInt(Request.QueryString["MonthID"].ToString()) >= 1 && Util.GetInt(Request.QueryString["MonthID"].ToString()) <= 9)
            {
                MonthID = Util.GetString(Util.GetInt(Request.QueryString["MonthID"].ToString()) + 3);
                YearID = Util.GetString(StockReports.ExecuteScalar("SELECT DATE_FORMAT(f.FromDate,'%Y') FROM f_financialyear_master f WHERE f.ID=" + Request.QueryString["FinacialYearID"].ToString() + " "));
            }
            else
            {
                MonthID = Util.GetString(Util.GetInt(Request.QueryString["MonthID"].ToString()) - 9);
                YearID = Util.GetString(StockReports.ExecuteScalar("SELECT DATE_FORMAT(f.ToDate,'%Y') FROM f_financialyear_master f WHERE f.ID=" + Request.QueryString["FinacialYearID"].ToString() + " "));
            }

            if (MonthID.Length == 1)
                MonthID = "0" + MonthID;


            BindYear(YearID);
            ddlMonth.SelectedIndex = ddlMonth.Items.IndexOf(ddlMonth.Items.FindByValue(MonthID));

            string Category = "";
            if (Request.QueryString["TargetTypeId"].ToString() == "1")
                Category = "Net Amount wise";
            if (Request.QueryString["TargetTypeId"].ToString() == "2")
                Category = "Test wise";
            if (Request.QueryString["TargetTypeId"].ToString() == "3")
                Category = "Test wise";

            lblHeader.Text = "Set " + Category + " Target of " + ddlMonth.SelectedItem.Text + " Month ( Value Enter in " + Request.QueryString["Format"].ToString() + " Format )";
            lblMonthTarget.Text = ddlMonth.SelectedItem.Text + " Target : " + Util.GetString(MonthTarget);
            lblFDetail.Text = Request.QueryString["TargetTypeId"].ToString() + "#" + Request.QueryString["Format"].ToString() + "#" + Request.QueryString["FinacialYearID"].ToString() + "#" + Request.QueryString["SalesCategoryID"].ToString() + "#" + Request.QueryString["MonthID"].ToString();
            BindMonthCheckEnable(Request.QueryString["MonthID"].ToString());
            btnSearch_Click(sender, e);
        }
    }

    private void BindMonthCheckEnable(string MonthID)
    {

        foreach (ListItem li in chkTargetMonth.Items)
        {
            int ListMonth = 0;
            if (Util.GetInt(li.Value) > 3)
                ListMonth = Util.GetInt(li.Value) - 3;
            else
                ListMonth = Util.GetInt(li.Value) + 9;

            if (ListMonth >= Util.GetInt(MonthID))
            {
                if (ddlMonth.SelectedItem.Value == li.Value)
                    li.Selected = true;

                li.Enabled = true;
                li.Attributes.CssStyle.Add("color", "Green");
            }
            else
            {
                li.Enabled = false;
                li.Attributes.CssStyle.Add("color", "Red");
            }
        }
    }
    private void BindYear(string YearID)
    {
        DataTable dt = StockReports.GetDataTable("SELECT Year FROM year_master");
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlYear.DataSource = dt;
            ddlYear.DataTextField = "Year";
            ddlYear.DataValueField = "Year";
            ddlYear.DataBind();
        }
        ddlYear.Items.Add(new ListItem("Select", "0"));
        ddlYear.SelectedIndex = ddlYear.Items.IndexOf(ddlYear.Items.FindByValue(YearID));
    }
    private void GetNewDepenedent(string DependentID, string Year, string Month)
    {
        int TargetTypeId = Util.GetInt(lblFDetail.Text.Split('#')[0].ToString());
        int FinancialYearId = Util.GetInt(lblFDetail.Text.Split('#')[2].ToString());
        string ItemId = "";
        if (TargetTypeId == 2)
            ItemId = Util.GetString(lblFDetail.Text.Split('#')[3].ToString());

        DataTable dtNew = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT em.Reporting_Employee_ID AS ReportingEmployeeID,CONCAT('<b> SELF</b> ( ',em1.Name,' )')SelfEmployee,IF(IFNULL((SELECT COUNT(*) FROM employee_master e INNER JOIN f_designation_msater dm ON dm.ID=e.DesignationID WHERE em.IsSalesTeamMember=1 AND dm.SequenceNo<>1 AND em.Employee_ID=e.Reporting_Employee_ID),0)>0,1,0)IsDependent,em.Employee_ID,dm.ID DesignationID, dm.SequenceNo, CONCAT('<b><span style=''color:',IFNULL(dm.DisplayColor,'black'),''' /> ',dm.Name,'</b> ( ',em.Name,' )') AS EmployeeName,IFNULL((SELECT ROUND(td.TargetAmount,0) FROM f_targetmonthwisedetail td WHERE td.IsGroup<>2 and td.ReportingEmployeeID='" + DependentID + "' AND td.DependentEmployeeID=em.Employee_ID AND td.IsCancel=0 AND td.Year=" + Year + " AND td.Month=" + Month + " and td.FinancialYearId =" + FinancialYearId + " and td.TargetTypeId =" + TargetTypeId + " ");
        if (TargetTypeId == 2)
            sb.Append(" and td.ItemId='" + ItemId + "' ");

        sb.Append("  limit 1 ),0)Target FROM employee_master em INNER JOIN f_designation_msater dm ON dm.ID=em.DesignationID INNER JOIN employee_master em1 ON em1.Employee_ID=em.Reporting_Employee_ID WHERE em.IsSalesTeamMember=1 AND dm.SequenceNo<>1 AND em.Reporting_Employee_ID='" + DependentID + "' ");
        dtNew = StockReports.GetDataTable(sb.ToString());
        if (dtNew.Rows.Count > 0)
        {
            sb.Length = 0;
            sb.Append(" SELECT ROUND(td.TargetAmount,0) FROM f_targetmonthwisedetail td WHERE td.IsGroup<>2 and td.ReportingEmployeeID='" + DependentID + "' AND td.DependentEmployeeID='" + DependentID + "' AND td.IsCancel=0 AND td.Year=" + Year + " AND td.Month=" + Month + " and td.FinancialYearId =" + FinancialYearId + " and td.TargetTypeId =" + TargetTypeId + " ");
            if (TargetTypeId == 2)
                sb.Append(" and td.ItemId='" + ItemId + "' ");

            sb.Append("   limit 1 ");
            decimal SelfTargetValue = Util.GetDecimal(StockReports.ExecuteScalar(sb.ToString()));

            plEmployee.Controls.Add(new LiteralControl("<div class='expander'></div><ul>"));
            plEmployee.Controls.Add(new LiteralControl(" <li><table style='width:400px;'><tr><td style='width:300px;'>" + dtNew.Rows[0]["SelfEmployee"].ToString() + "</td><td style='width:100px;'><input type='text' class='target' id='txt_" + dtNew.Rows[0]["ReportingEmployeeID"].ToString() + "_" + dtNew.Rows[0]["ReportingEmployeeID"].ToString() + "_1_0' style='width:70px;' value='" + SelfTargetValue + "' /></td></tr></table> "));
            for (int k = 0; k < dtNew.Rows.Count; k++)
            {
                plEmployee.Controls.Add(new LiteralControl(" <li><table style='width:400px;'><tr><td style='width:300px;'>" + dtNew.Rows[k]["EmployeeName"].ToString() + "</td><td style='width:100px;'><input type='text' class='target' id='txt_" + dtNew.Rows[k]["Employee_ID"].ToString() + "_" + dtNew.Rows[0]["ReportingEmployeeID"].ToString() + "_0_0' style='width:70px;' value='" + dtNew.Rows[k]["Target"].ToString() + "' /></td></tr></table> "));
                if (dtNew.Rows[k]["IsDependent"].ToString() == "1")
                {
                    GetNewDepenedent(dtNew.Rows[k]["Employee_ID"].ToString(), Year, Month);
                }
                plEmployee.Controls.Add(new LiteralControl(" </li>"));
            }
            plEmployee.Controls.Add(new LiteralControl("</ul>"));
        }

    }
    public void GetDesignationwithEmployee(string Year, string Month)
    {
        int TargetTypeId = Util.GetInt(lblFDetail.Text.Split('#')[0].ToString());
        int FinancialYearId = Util.GetInt(lblFDetail.Text.Split('#')[2].ToString());
        string ItemId = "";
        if (TargetTypeId == 2)
            ItemId = Util.GetString(lblFDetail.Text.Split('#')[3].ToString());

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT IF(IFNULL((SELECT COUNT(*) FROM employee_master e INNER JOIN f_designation_msater dm ON dm.ID=e.DesignationID WHERE em.IsSalesTeamMember=1 AND dm.SequenceNo<>1 AND em.Employee_ID=e.Reporting_Employee_ID),0)>0,1,0)IsDependent, em.Employee_ID,dm.ID DesignationID, dm.SequenceNo, CONCAT('<b><span style=''color:',IFNULL(dm.DisplayColor,'black'),''' /> ',dm.Name,'</b> ( ',em.Name,' )') AS EmployeeName,IFNULL((SELECT ROUND(t.TargetAmount,0) FROM f_targetmonthwisedetail t WHERE t.DependentEmployeeID=em.Employee_ID AND t.ReportingEmployeeID=em.Employee_ID AND t.IsCancel=0 and t.IsGroup=2 AND t.Year=" + Year + " AND t.Month=" + Month + "  and t.FinancialYearId =" + FinancialYearId + " and t.TargetTypeId =" + TargetTypeId + " ");
        if (TargetTypeId == 2)
            sb.Append(" and td.ItemId='" + ItemId + "' ");

        sb.Append(" limit 1 ),0)Target FROM employee_master em INNER JOIN f_designation_msater dm ON dm.ID=em.DesignationID WHERE em.IsSalesTeamMember=1 AND dm.SequenceNo=1 ");

        DataTable dt = StockReports.GetDataTable(sb.ToString());
        if (dt.Rows.Count > 0)
        {
            plEmployee.Controls.Add(new LiteralControl("<ul class='tree'>"));
            for (int i = 0; i < dt.Rows.Count; i++)
            {
                plEmployee.Controls.Add(new LiteralControl(" <li><table style='width:400px;'><tr><td style='width:300px;'>" + dt.Rows[i]["EmployeeName"].ToString() + "</td><td style='width:100px;'><input type='text' class='target' id='txt_" + dt.Rows[i]["Employee_ID"].ToString() + "_" + dt.Rows[i]["Employee_ID"].ToString() + "_0_1' style='width:70px;' value='" + dt.Rows[i]["Target"].ToString() + "' /></td></tr></table> "));

                if (dt.Rows[i]["IsDependent"].ToString() == "1")
                {
                    GetNewDepenedent(dt.Rows[i]["Employee_ID"].ToString(), Year, Month);
                }
                plEmployee.Controls.Add(new LiteralControl(" </li>"));

            }
            plEmployee.Controls.Add(new LiteralControl("</ul>"));
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        lblerrmsg.Text = "";
        if (ddlYear.SelectedItem.Value == "0")
        {
            lblerrmsg.Text = "Please Select Year";
            ddlYear.Focus();
            return;
        }
        if (ddlMonth.SelectedItem.Value == "Select")
        {
            lblerrmsg.Text = "Please Select Month";
            ddlMonth.Focus();
            return;
        }
        dvTarget.Visible = true;
        divSave.Visible = true;
        GetDesignationwithEmployee(ddlYear.SelectedItem.Value, ddlMonth.SelectedItem.Value);
    }

    [WebMethod]
    public static string Save(string Target, string Year, string Month, string MonthTarget, string FDetails, string SetMonthId)
    {
        int TargetTypeId = Util.GetInt(FDetails.Split('#')[0].ToString());
        string Format = Util.GetString(FDetails.Split('#')[1].ToString());
        int FinancialYearId = Util.GetInt(FDetails.Split('#')[2].ToString());
        string ItemId = "";
        if (TargetTypeId == 2)
            ItemId = Util.GetString(FDetails.Split('#')[3].ToString());

        int MonthId = Util.GetInt(SetMonthId);

        StringBuilder sb = new StringBuilder();
        decimal HeadTarget = 0, DependentTarget = 0, TargetValue = 0;
        List<TargetDataList> ObjTargetData = new List<TargetDataList>();
        ObjTargetData = JsonConvert.DeserializeObject<List<TargetDataList>>(Target);

        DataTable dtValid = new DataTable();
        dtValid.Columns.Add("EmployeeID");
        dtValid.Columns.Add("ReportingEmployeeID");
        dtValid.Columns.Add("IsSelf");
        dtValid.Columns.Add("TargetValue", typeof(decimal));
        dtValid.Columns.Add("IsFirst");
        for (int i = 0; i < ObjTargetData.Count; i++)
        {
            if (ObjTargetData[i].TargetValue == "" && ObjTargetData[i].TargetValue == string.Empty)
                TargetValue = 0;
            else
                TargetValue = Util.GetDecimal(ObjTargetData[i].TargetValue);

            DataRow dr = dtValid.NewRow();
            dr["EmployeeID"] = ObjTargetData[i].EmployeeID;
            dr["ReportingEmployeeID"] = ObjTargetData[i].ReportingEmployeeID;
            dr["IsSelf"] = ObjTargetData[i].IsSelf;
            dr["TargetValue"] = TargetValue;
            dr["IsFirst"] = ObjTargetData[i].IsFirst;
            dtValid.Rows.Add(dr);
        }

        dtValid.AcceptChanges();
        decimal MinMonthTarget = Util.GetDecimal(MonthTarget);
        decimal MainTarget = Util.GetDecimal(dtValid.Compute("sum(TargetValue)", "IsFirst=1"));
        if (MainTarget < MinMonthTarget)
        {
            return "3";
        }

        DataTable dtReportingHaed = StockReports.GetDataTable("SELECT DISTINCT e.Reporting_Employee_ID,(SELECT em.Reporting_Employee_ID FROM employee_master em WHERE em.Employee_ID=e.Reporting_Employee_ID)HeadEmpID FROM employee_master e WHERE e.IsSalesTeamMember=1 ");
        if (dtValid.Rows.Count > 0 && dtValid != null)
        {
            for (int i = 0; i < dtReportingHaed.Rows.Count; i++)
            {
                HeadTarget = Util.GetDecimal(dtValid.Compute("sum(TargetValue)", "IsSelf=0 and EmployeeID='" + dtReportingHaed.Rows[i]["Reporting_Employee_ID"].ToString() + "'"));

                DependentTarget = Util.GetDecimal(dtValid.Compute("sum(TargetValue)", "IsSelf=1 and EmployeeID=ReportingEmployeeID and ReportingEmployeeID='" + dtReportingHaed.Rows[i]["Reporting_Employee_ID"].ToString() + "' ")) + Util.GetDecimal(dtValid.Compute("sum(TargetValue)", "IsSelf=0 and EmployeeID<>ReportingEmployeeID and ReportingEmployeeID='" + dtReportingHaed.Rows[i]["Reporting_Employee_ID"].ToString() + "' "));

                int Totaldependent = Util.GetInt(StockReports.ExecuteScalar(" SELECT COUNT(*) FROM employee_master em WHERE em.IsSalesTeamMember=1 AND em.Employee_ID<>em.Reporting_Employee_ID AND em.Reporting_Employee_ID='" + dtReportingHaed.Rows[i]["Reporting_Employee_ID"].ToString() + "' "));

                if ((DependentTarget < HeadTarget) && Totaldependent > 0)
                {
                    return "txt_" + dtReportingHaed.Rows[i]["Reporting_Employee_ID"].ToString() + "_" + dtReportingHaed.Rows[i]["HeadEmpID"].ToString() + "_0";
                }
            }
        }
        else
            return "2";

        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string Sqlupdate = "UPDATE f_targetmonthwisedetail td SET td.IsCancel=1,td.LastUpdatedBy='" + UserInfo.ID + "',td.LastUpdatedDateTime=NOW() WHERE td.IsCancel=0 AND td.Year=" + Year + " AND td.Month=" + Month + " and td.FinancialYearId =" + FinancialYearId + " and td.TargetTypeId =" + TargetTypeId + " ";
            if (TargetTypeId == 2)
                Sqlupdate = Sqlupdate + " and ItemId='" + ItemId + "' ";

            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, Sqlupdate);


            //  for (int i = 0; i < dtReportingHaed.Rows.Count; i++)
            // {
            // HeadTarget = Util.GetDecimal(dtValid.Compute("sum(TargetValue)", "IsSelf=0 and EmployeeID='" + dtReportingHaed.Rows[i]["Reporting_Employee_ID"].ToString() + "'"));


            DataRow[] TargetFirst = dtValid.Select("IsFirst=1");
            foreach (DataRow drFirst in TargetFirst)
            {
                sb.Length = 0;
                sb.Append(" INSERT INTO f_targetmonthwisedetail(DependentEmployeeID,ReportingEmployeeID,TargetAmount,EntryDatetime,EntryBy,IsGroup,`Year`,`Month`,MonthId,MonthTarget,TargetTypeId,FinancialYearId) ");
                sb.Append(" VALUES(@DependentEmployeeID,@ReportingEmployeeID,@TargetAmount,NOW(),@EntryBy,@IsGroup,@Year,@Month,@MonthId,@MonthTarget,@TargetTypeId,@FinancialYearId) ");

                MySqlCommand cmd = new MySqlCommand(sb.ToString(), con, tnx);

                cmd.Parameters.AddWithValue("@DependentEmployeeID", drFirst["EmployeeID"].ToString());
                cmd.Parameters.AddWithValue("@ReportingEmployeeID", drFirst["ReportingEmployeeID"].ToString());
                cmd.Parameters.AddWithValue("@TargetAmount", Util.GetDecimal(drFirst["TargetValue"].ToString()));
                cmd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmd.Parameters.AddWithValue("@IsGroup", 2);
                cmd.Parameters.AddWithValue("@Year", Util.GetInt(Year));
                cmd.Parameters.AddWithValue("@Month", Util.GetInt(Month));
                cmd.Parameters.AddWithValue("@MonthId", MonthId);
                cmd.Parameters.AddWithValue("@MonthTarget", MonthTarget);
                cmd.Parameters.AddWithValue("@TargetTypeId", TargetTypeId);
                cmd.Parameters.AddWithValue("@FinancialYearId", FinancialYearId);
                cmd.ExecuteNonQuery();
            }


            DataRow[] TargetDept = dtValid.Select("IsSelf=1 and EmployeeID=ReportingEmployeeID ");
            foreach (DataRow drDependent in TargetDept)
            {
                sb.Length = 0;
                sb.Append(" INSERT INTO f_targetmonthwisedetail(DependentEmployeeID,ReportingEmployeeID,TargetAmount,EntryDatetime,EntryBy,IsGroup,`Year`,`Month`,MonthId,MonthTarget,TargetTypeId,FinancialYearId) ");
                sb.Append(" VALUES(@DependentEmployeeID,@ReportingEmployeeID,@TargetAmount,NOW(),@EntryBy,@IsGroup,@Year,@Month,@MonthId,@MonthTarget,@TargetTypeId,@FinancialYearId) ");
                MySqlCommand cmdd = new MySqlCommand(sb.ToString(), con, tnx);
                cmdd.Parameters.AddWithValue("@DependentEmployeeID", drDependent["EmployeeID"].ToString());
                cmdd.Parameters.AddWithValue("@ReportingEmployeeID", drDependent["ReportingEmployeeID"].ToString());
                cmdd.Parameters.AddWithValue("@TargetAmount", Util.GetDecimal(drDependent["TargetValue"].ToString()));
                cmdd.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdd.Parameters.AddWithValue("@IsGroup", 0);
                cmdd.Parameters.AddWithValue("@Year", Util.GetInt(Year));
                cmdd.Parameters.AddWithValue("@Month", Util.GetInt(Month));
                cmdd.Parameters.AddWithValue("@MonthId", MonthId);
                cmdd.Parameters.AddWithValue("@MonthTarget", MonthTarget);
                cmdd.Parameters.AddWithValue("@TargetTypeId", TargetTypeId);
                cmdd.Parameters.AddWithValue("@FinancialYearId", FinancialYearId);
                cmdd.ExecuteNonQuery();
            }

            TargetDept = dtValid.Select("IsSelf=0 and EmployeeID<>ReportingEmployeeID ");
            foreach (DataRow drDependent in TargetDept)
            {
                int GroupStatus = 0;
                string SqlDataISGroup = "SELECT COUNT(*) FROM employee_master e WHERE e.IsSalesTeamMember=1 AND e.Reporting_Employee_ID='" + drDependent["EmployeeID"].ToString() + "' AND Employee_ID<>'" + drDependent["EmployeeID"].ToString() + "' ";
                int IsGroup = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, SqlDataISGroup));

                if (IsGroup > 0)
                    GroupStatus = 1;

                sb.Length = 0;
                sb.Append(" INSERT INTO f_targetmonthwisedetail(DependentEmployeeID,ReportingEmployeeID,TargetAmount,EntryDatetime,EntryBy,IsGroup,`Year`,`Month`,MonthId,MonthTarget,TargetTypeId,FinancialYearId) ");
                sb.Append(" VALUES(@DependentEmployeeID,@ReportingEmployeeID,@TargetAmount,NOW(),@EntryBy,@IsGroup,@Year,@Month,@MonthId,@MonthTarget,@TargetTypeId,@FinancialYearId) ");
                MySqlCommand cmdself = new MySqlCommand(sb.ToString(), con, tnx);
                cmdself.Parameters.AddWithValue("@DependentEmployeeID", drDependent["EmployeeID"].ToString());
                cmdself.Parameters.AddWithValue("@ReportingEmployeeID", drDependent["ReportingEmployeeID"].ToString());
                cmdself.Parameters.AddWithValue("@TargetAmount", Util.GetDecimal(drDependent["TargetValue"].ToString()));
                cmdself.Parameters.AddWithValue("@EntryBy", UserInfo.ID);
                cmdself.Parameters.AddWithValue("@IsGroup", GroupStatus);
                cmdself.Parameters.AddWithValue("@Year", Util.GetInt(Year));
                cmdself.Parameters.AddWithValue("@Month", Util.GetInt(Month));
                cmdself.Parameters.AddWithValue("@MonthId", MonthId);
                cmdself.Parameters.AddWithValue("@MonthTarget", MonthTarget);
                cmdself.Parameters.AddWithValue("@TargetTypeId", TargetTypeId);
                cmdself.Parameters.AddWithValue("@FinancialYearId", FinancialYearId);
                cmdself.ExecuteNonQuery();
            }
            //  }

            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
            return ex.Message;
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    public class TargetDataList
    {
        private string _EmployeeID;
        private string _ReportingEmployeeID;
        private string _IsSelf;
        private string _TargetValue;
        private string _IsFirst;
        public string EmployeeID { get { return _EmployeeID; } set { _EmployeeID = value; } }
        public string ReportingEmployeeID { get { return _ReportingEmployeeID; } set { _ReportingEmployeeID = value; } }
        public string IsSelf { get { return _IsSelf; } set { _IsSelf = value; } }
        public string TargetValue { get { return _TargetValue; } set { _TargetValue = value; } }
        public string IsFirst { get { return _IsFirst; } set { _IsFirst = value; } }
    }

}