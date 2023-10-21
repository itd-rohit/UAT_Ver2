using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Text;


public partial class Design_OPD_ApprovalReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FrmDate.SetCurrentDate();
            ToDate.SetCurrentDate();
            BindDoctors(ddl_type.SelectedValue.ToString());
          
            chlCentre.DataSource = AllLoad_Data.getCentreByLogin();
            chlCentre.DataTextField = "Centre";
            chlCentre.DataValueField = "CentreID";
            chlCentre.DataBind();
            chlDept.DataSource = AllLoad_Data.loadObservationType();
            chlDept.DataTextField = "Name";
            chlDept.DataValueField = "ObservationType_ID";
            chlDept.DataBind();
            chlTest.DataSource = StockReports.GetDataTable(AllLoad_Data.GetInvestigationQuery());
            chlTest.DataTextField = "NAME";
            chlTest.DataValueField = "Investigation_Id";
            chlTest.DataBind();
        }

    }
    private void BindDoctors(string Type_Val )
    {
        string str = "";
        if (Type_Val.Trim() == "0" )
        {
            str = "SELECT em.Name,al.EmployeeID FROM employee_master em INNER JOIN (SELECT DISTINCT(EmployeeID) FROM f_approval_labemployee)al ON em.Employee_ID=al.EmployeeID WHERE em.`IsActive`='1' ORDER BY em.`Name` ";
        }
        else if (Type_Val.Trim() == "1")
        {
            str = "SELECT em.Name,em.Employee_ID EmployeeID FROM employee_master em  INNER JOIN (SELECT DISTINCT(EmployeeID),RoleID FROM f_login) fl ON fl.`EmployeeID`=em.Employee_ID AND fl.`RoleID` IN ('11','15') WHERE em.`IsActive` = '1' ORDER BY em.`Name`  ";
        }
        // else
        // {
            // str = "SELECT em.Name,em.Employee_ID EmployeeID FROM employee_master em WHERE `UserTypeID`='Technician' and isactive='1' order by name";
        // }
            DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(str);
        chlDoctors.Items.Clear();
        chlDoctors.DataSource = dt;
        chlDoctors.DataTextField = "Name";
        chlDoctors.DataValueField = "EmployeeID";
        chlDoctors.DataBind();


    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        string Doctor = StockReports.GetSelection(chlDoctors);
        string Test = StockReports.GetSelection(chlTest);
        string  Dept = StockReports.GetSelection(chlDept);
        string CentreData = StockReports.GetSelection(chlCentre);
        if (CentreData == "")
        {
            lblMsg.Text = "Please Select the centre";
            return;
        }
        lblMsg.Text = "";
        //if (Doctor != string.Empty && Test != string.Empty)
        //{
            StringBuilder sb = new StringBuilder();

            if (rbtnReportType.SelectedItem.Value == "1")
            {

                sb.Append(" SELECT im.Name Investigation,Round(plo.Amount,0)TestRate,otm.Name Department,CONCAT(em.Title,' ',em.Name)ApprovedBy, ");

                sb.Append(" CONCAT(em1.Title, ' ', em1.Name) DoctorApproval,DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y %I:%i%p')ApprovedDate, ");

                sb.Append(" lt.LedgertransactionNo,DATE_FORMAT(lt.date,'%d-%b-%Y %I:%i%p') DATE,pm.PName,pm.Age,pm.Gender,cm.Centre ");

                sb.Append(" FROM  ");
                sb.Append(" (SELECT * FROM patient_labinvestigation_opd plo ");

                if (ddl_type.SelectedValue == "0")
                {
                    sb.Append(" WHERE Approved=1 ");
                    sb.Append(" AND " + ddldatetype.SelectedValue.ToString() + ">='" + FrmDate.GetDateForDataBase() + "' AND  " + ddldatetype.SelectedValue.ToString() + "<='" + ToDate.GetDateForDataBase() + "' ");
                    if (Doctor != "")
                    {
                        sb.Append(" AND ApprovedBy IN (" + Doctor + ") ");
                    }

                }
                else if (ddl_type.SelectedValue == "1")
                {
                    sb.Append(" where `Result_Flag`=1 ");
                    sb.Append(" AND " + ddldatetype.SelectedValue.ToString() + ">='" + FrmDate.GetDateForDataBase() + "' AND  " + ddldatetype.SelectedValue.ToString() + "<='" + ToDate.GetDateForDataBase() + "' ");
                    if (Doctor != "")
                    {
                        sb.Append(" AND ResultEnteredBy IN (" + Doctor + ")  ");
                    }
                }
                else if (ddl_type.SelectedValue == "2")
                {
                    sb.Append(" where " + ddldatetype.SelectedValue.ToString() + ">='" + FrmDate.GetDateForDataBase() + "' AND  " + ddldatetype.SelectedValue.ToString() + "<='" + ToDate.GetDateForDataBase() + "' ");
                    if (Doctor != "")
                    {
                        sb.Append("  AND `TechnicianID` IN (" + Doctor + ")  ");
                    }
                }

                if (Test != "")
                {
                    sb.Append(" AND Investigation_ID IN (" + Test + ") ");
                }
                sb.Append(" ) plo ");
                sb.Append(" INNER JOIN f_ledgertransaction lt  ");
                sb.Append(" ON lt.LedgerTransactionNo=plo.LedgerTransactionNo  ");
                if (CentreData != "")
                {
                    sb.Append(" and lt.CentreID IN ("+CentreData+") ");
                }
                 sb.Append(" Inner join `centre_master` cm  on cm.`CentreID`=lt.`CentreID` ");
                 sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID  " );
                if (ddl_type.SelectedValue == "0")
                {
                    sb.Append(" INNER JOIN employee_master em ON em.Employee_ID = plo.ApprovedBy ");
                        
                }
                else if (ddl_type.SelectedValue == "1")
                {
                    sb.Append(" INNER JOIN employee_master em ON em.Employee_ID = plo.ResultEnteredBy ");
                }
                else if (ddl_type.SelectedValue == "2")
                {
                    sb.Append("   inner JOIN employee_master em ON em.`Employee_ID`=plo.`TechnicianID` ");
                }
                sb.Append(" INNER JOIN employee_master em1 ON em1.Employee_ID = plo.ApprovedBy ");
                sb.Append(" INNER JOIN investigation_master im ON im.Investigation_ID = plo.Investigation_ID ");
                sb.Append(" INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID ");
                sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=io.ObservationType_Id  ");
                if (Dept != "")
                {
                    sb.Append(" and otm.ObservationType_ID IN (" + Dept + ") ");
                }

                sb.Append(" Order by lt.LedgertransactionNo ");

            }
            else
            {

                sb.Append(" SELECT (CONCAT(em.Title,' ',em.Name))ApprovedBy, otm.Name Department,count(*) Cnt," + ddl_type.SelectedValue + " ReportType,cm.Centre  ");
                sb.Append(" FROM  f_ledgertransaction lt  ");
                sb.Append(" Inner join `centre_master` cm  on cm.`CentreID`=lt.`CentreID` ");
                sb.Append(" inner join patient_labinvestigation_opd plo ON lt.LedgerTransactionNo=plo.LedgerTransactionNo  ");
                if (CentreData != "")
                {
                    sb.Append(" and lt.CentreID IN (" + CentreData + ") ");
                }
                if (ddl_type.SelectedValue == "0")
                {
                    sb.Append(" and plo.Approved=1 ");
                    sb.Append(" AND " + ddldatetype.SelectedValue.ToString() + ">='" + FrmDate.GetDateForDataBase() + "' AND  " + ddldatetype.SelectedValue.ToString() + "<='" + ToDate.GetDateForDataBase() + "' ");
                    if (Doctor != "")
                    {
                        sb.Append(" AND plo.ApprovedBy IN (" + Doctor + ") ");
                    }

                }
                else if (ddl_type.SelectedValue == "1")
                {
                    sb.Append(" and plo.`Result_Flag`=1 ");
                    sb.Append(" AND " + ddldatetype.SelectedValue.ToString() + ">='" + FrmDate.GetDateForDataBase() + "' AND  " + ddldatetype.SelectedValue.ToString() + "<='" + ToDate.GetDateForDataBase() + "' ");
                    if (Doctor != "")
                    {
                        sb.Append(" AND plo.ResultEnteredBy IN (" + Doctor + ")  ");
                    }
                }
                else if (ddl_type.SelectedValue == "2")
                {
                    sb.Append(" AND " + ddldatetype.SelectedValue.ToString() + ">='" + FrmDate.GetDateForDataBase() + "' AND  " + ddldatetype.SelectedValue.ToString() + "<='" + ToDate.GetDateForDataBase() + "' ");
                    if (Doctor != "")
                    {
                        sb.Append("  AND plo.`TechnicianID` IN (" + Doctor + ")  ");
                    }
                }
                if (Test != "")
                {
                    sb.Append(" AND plo.Investigation_ID IN (" + Test + ") ");
                }
               // sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID  ");
                if (ddl_type.SelectedValue == "0")
                {
                    sb.Append(" INNER JOIN employee_master em ON em.Employee_ID = plo.ApprovedBy ");
                }
                else if (ddl_type.SelectedValue == "1")
                {
                    sb.Append(" INNER JOIN employee_master em ON em.Employee_ID = plo.ResultEnteredBy ");
                }
                else if (ddl_type.SelectedValue == "2")
                {
                    sb.Append("   inner JOIN employee_master em ON em.`Employee_ID`=plo.`TechnicianID` ");
                }
                sb.Append(" INNER JOIN investigation_master im ON im.Investigation_ID = plo.Investigation_ID ");
                sb.Append(" INNER JOIN investigation_observationtype io ON im.Investigation_Id = io.Investigation_ID ");
                sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=io.ObservationType_Id  ");
                if (Dept != "")
                {
                    sb.Append(" and otm.ObservationType_ID IN (" + Dept + ") ");
                }
                sb.Append(" group by em.Employee_ID, otm.ObservationType_ID ");
            
            }
            DataTable dt = new DataTable();
            dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "User";
                dc.DefaultValue = UserInfo.LoginName;
                dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "Period From : " + FrmDate.GetDateForDisplay() + " To : " + ToDate.GetDateForDisplay();
                dt.Columns.Add(dc);

                //dc = new DataColumn();
                //dc.ColumnName = "Centre";
                //dc.DefaultValue = "";
                //dt.Columns.Add(dc);

                dc = new DataColumn();
                dc.ColumnName = "Header";
                if (ddl_type.SelectedValue == "0")
                {
                    dc.DefaultValue = "Approval Report";
                }
                else if (ddl_type.SelectedValue == "1")
                {
                    dc.DefaultValue = "Result Entry Report";
                }
                else
                {
                    dc.DefaultValue = "Technician Report";
                }
                dt.Columns.Add(dc);

                if (rbtnReportType.SelectedItem.Value == "1")
                {
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                   // ds.WriteXmlSchema(@"E:\ApprovalReport.xml");
                   // Session["ds"] = ds;
                    Session["ReportName"] = "ApprovalReport"; 
                    if (rdoPDF.Checked)
                    {
                        //ds.WriteXmlSchema(@"E:\ApprovalReport.xml");
                        Session["ds"] = ds;
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
                    }
                    else
                    {
                        ds.Tables[0].Columns["PName"].ColumnName = "Name";
                        ds.Tables[0].Columns["LedgertransactionNo"].ColumnName = "Lab No.";
                        ds.Tables[0].Columns["DATE"].ColumnName = "Prescribed Date";
                        ds.Tables[0].Columns.Remove("User");
                        ds.Tables[0].Columns.Remove("Header");
                        //ds.Tables[0].Columns.Remove("Centre");
                        ds.Tables[0].Columns.Remove("Period");

                        //dc = new DataColumn();
                        //dc.ColumnName = "Centre";
                        //dc.DefaultValue = "";
                        //ds.Tables[0].Columns.Add(dc);



                        //TestRate
                        ds.Tables[0].Columns["ApprovedDate"].SetOrdinal(0);
                        ds.Tables[0].Columns["Department"].SetOrdinal(1);
                        ds.Tables[0].Columns["Investigation"].SetOrdinal(2);
                        ds.Tables[0].Columns["TestRate"].SetOrdinal(3);
                        ds.Tables[0].Columns["Lab No."].SetOrdinal(4);
                        ds.Tables[0].Columns["Name"].SetOrdinal(5);
                        ds.Tables[0].Columns["Age"].SetOrdinal(6);
                        ds.Tables[0].Columns["Gender"].SetOrdinal(7);

                        Session["dtExport2Excel"] = ds.Tables[0];
                        Session["Period"] = "Period From : " + FrmDate.GetDateForDisplay() + " To : " + ToDate.GetDateForDisplay();
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
                    }
                }
                else
                {
                    DataSet ds = new DataSet();
                    ds.Tables.Add(dt.Copy());
                   // ds.WriteXmlSchema(@"D:\ApprovalReportSummary.xml");
                    Session["ds"] = ds;
                    Session["ReportName"] = "ApprovalReportSummary";


                    Session["Period"] = "Period From : " + FrmDate.GetDateForDisplay() + " To : " + ToDate.GetDateForDisplay();
                  //  ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/DocAccount/CommonReportsExcel.aspx');", true);
                    if (rdoPDF.Checked)
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/Commonreport.aspx');", true);
                    }
                    else
                    {
                        ds.Tables[0].Columns["Cnt"].ColumnName = "Count";
                        ds.Tables[0].Columns.Remove("Header");
                        ds.Tables[0].Columns.Remove("User");
                        ds.Tables[0].Columns.Remove("ReportType");
                        ds.Tables[0].Columns.Remove("Period");
                        //ds.Tables[0].Columns.Remove("Centre");

                        //dc = new DataColumn();
                        //dc.ColumnName = "Centre";
                        //dc.DefaultValue = "";
                        //ds.Tables[0].Columns.Add(dc);
                       
                        Session["dtExport2Excel"] = ds.Tables[0];
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Common/ExportToExcel.aspx');", true);
                    }
                
                
                }
                
            }
            else
                lblMsg.Text = "No Records Found..";
        //}
        //else
        //{  
        //    if (Doctor == string.Empty)
        //    lblMsg.Text = "Select Lab Doctor !!!";
        //   else
        //    lblMsg.Text = "Select Lab Test !!!";
        //}
    }
    protected void ddl_type_SelectedIndexChanged(object sender, EventArgs e)
    {
        chkDoctors.Checked = false;
        BindDoctors(ddl_type.SelectedValue.ToString());
    }

}
