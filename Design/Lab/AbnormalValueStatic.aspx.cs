using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Linq;
using MySql.Data.MySqlClient;
public partial class Design_Lab_AbnormalValueStatic : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            bindCentreMaster();
            calFromDate.EndDate = DateTime.Now;
            calToDate.EndDate = DateTime.Now;
        }
        txtFromDate.Attributes.Add("readOnly", "readOnly");
        txtToDate.Attributes.Add("readOnly", "readOnly");
    }

    private void bindCentreMaster()
    {
        using (DataTable dt = StockReports.GetDataTable("SELECT centreID,Centre FROM  centre_master WHERE IsActive=1 AND TagProcessingLabID='" + UserInfo.Centre + "'"))
        {
            if (dt.Rows.Count > 0)
            {
                chlCentres.DataSource = dt;
                chlCentres.DataTextField = "Centre";
                chlCentres.DataValueField = "centreID";
                chlCentres.DataBind();
                BindDepartment();
            }
        }
    }
    private void BindDepartment()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");
        if (Util.GetString(HttpContext.Current.Session["AccessDepartment"]) != "")
        {
            sb.Append("  and  SubCategoryID in ('" + Util.GetString(HttpContext.Current.Session["AccessDepartment"]).Replace(",", "','") + "') ");
        }
        sb.Append(" ORDER BY NAME");
        chkDept.DataSource = StockReports.GetDataTable(sb.ToString());
        chkDept.DataTextField = "NAME";
        chkDept.DataValueField = "SubCategoryID";
        chkDept.DataBind();
        //  ddlDepartment.Items.Insert(0, new ListItem("All Department", ""));
    }
    protected void btnPDFReport_Click(object sender, EventArgs e)
    {
        string Centres = AllLoad_Data.GetSelection(chlCentres);
        if (Centres.Trim() == string.Empty)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key11", "toast('Error','Please Select Centre');", true);
            return;
        }
        string Departments = AllLoad_Data.GetSelection(chkDept);
        if (Departments.Trim() == string.Empty)
        {
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key11", "toast('Error','Please Select Department');", true);
            return;
        }
        if (txtFromDate.Text == string.Empty || txtToDate.Text == string.Empty)
        {
            txtFromDate.Focus();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key11", "toast('Error',' Please Select the Date');", true);
            return;
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string[] CentreIDTags = Centres.Split(',');
            string[] CentreIDParamNames = CentreIDTags.Select((s, i) => "@tag" + i).ToArray();
            string CentreIDClause = string.Join(", ", CentreIDParamNames);


            string[] DepartmentIDTags = Departments.Split(',');
            string[] DepartmentIDParamNames = DepartmentIDTags.Select((s, i) => "@tag" + i).ToArray();
            string DepartmentClause = string.Join(", ", DepartmentIDParamNames);

            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT DISTINCT  pli.`ItemName` inv, ");
            sb.Append("  '' Center_name,  '" + txtFromDate.Text + "' Date_From,'" + txtToDate.Text + "' Date_To, om.Name RtCat,DATE_FORMAT(pli.date,'%d-%b-%y') AS VstDate, ");
            sb.Append("  DATE_FORMAT(pli.`SampleReceiveDate`,'%d-%b-%y %h:%i %p') AS sampledate,pli.LedgerTransactionNo AS VstDestination,'' RtLabNo,   ");
            sb.Append("   CONCAT(lt.Pname,' ',lt.Age,'(',IF(lt.Gender='FEMALE','F','M'),')') Pat_Name,plo.LabobservationName AS ParamName,   ");
            sb.Append("   plo.value TrResult,ROUND(plo.minvalue,2) ParamCriLow,ROUND(plo.maxvalue,2) ParamCriHigh,   ");
            sb.Append("   ''  Pat_Perm_No, lt.Patient_ID RefNo,lt.`PanelName` DocName,'' WardNo,'' WardContactNo   ");
            sb.Append("   FROM `patient_labobservation_opd` plo   ");
            sb.Append("  INNER JOIN `patient_labinvestigation_opd` pli ON plo.test_ID=pli.test_ID  AND pli.IsActive=1  ");
            sb.Append("  INNER JOIN `f_ledgertransaction` lt  ON lt.ledgertransactionID=pli.ledgertransactionID  ");
            sb.Append("   INNER JOIN investigation_observationtype io ON io.Investigation_ID=pli.Investigation_ID   ");
            sb.Append("  INNER JOIN observationtype_master om  ON om.ObservationType_ID=io.ObservationType_ID   ");
            sb.Append("   AND io.ObservationType_Id IN({0})   ");
            sb.Append("   WHERE  pli.Result_Flag=1  ");
            sb.Append("   AND ROUND(plo.minvalue)>0 AND ROUND(plo.maxvalue)>0 AND IsNumeric(plo.value)=1 ");
            sb.Append("  AND  ((plo.value*1)<(plo.minvalue*1 ) OR (plo.value*1)>(plo.maxvalue*1 ) )   ");

            if (ddlSearchByDate.SelectedValue == "Approval Date")
            {
                sb.Append("   AND pli.ApprovedDate>=@FromDate  ");
                sb.Append("   AND pli.ApprovedDate<=@ToDate  ");
            }
            else if (ddlSearchByDate.SelectedValue == "Registration Date")
            {
                sb.Append("   AND pli.Date >= @FromDate  ");
                sb.Append("   AND pli.Date <= @ToDate  ");
            }
            else
            {
                sb.Append("   AND pli.SampleReceiveDate >= @FromDate  ");
                sb.Append("   AND pli.SampleReceiveDate <= @ToDate  ");
            }
            sb.Append("  AND lt.centreid IN({0})  ");
            sb.Append(" ORDER BY  pli.LedgerTransactionNo,pli.test_id  ");

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), CentreIDClause, DepartmentClause), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@FromDate", string.Concat(Util.GetDateTime(txtFromDate.Text).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                da.SelectCommand.Parameters.AddWithValue("@ToDate", string.Concat(Util.GetDateTime(txtToDate.Text).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                for (int i = 0; i < CentreIDParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(CentreIDParamNames[i], CentreIDTags[i]);
                }
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    if (dt.Rows.Count > 0)
                    {
                        Session["ds"] = dt;
                        Session["ReportName"] = "Abnormal";
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../Design/Lab/AbnormalValueStaticReceipt.aspx');", true);

                    }
                    else
                    {
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key11", "toast('Info','Record not found');", true);
                    }
                }
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

}