using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_WorksheetNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtFromTime.Text = "00:00:00";
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txtToTime.Text = "23:59:59";    
           Bindcenter();
            BindDepartment();
            BindOutsourceLabs();
            BindTagProcessingLab();           
        }
        else
        {            
        }
      //  dtFrom.Attributes.Add("readOnly", "readOnly");
      //  dtTo.Attributes.Add("readOnly", "readOnly");
    }

    private void BindOutsourceLabs()
    {           
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {            
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Distinct CONCAT(`OutsrclabId`,'#Outsource') AS CentreId ,OutsrcLabName  AS Centre FROM investigations_outsrclab WHERE CentreId=@CentreId",
                new MySqlParameter("@CentreId", UserInfo.Centre.ToString())).Tables[0])
            {

                ddlOutsourceLabs.DataSource = dt;
                ddlOutsourceLabs.DataTextField = "Centre";
                ddlOutsourceLabs.DataValueField = "CentreId";
                ddlOutsourceLabs.DataBind();                
            }
        }
        catch (Exception ex)
        {
            
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    
    }

    private void BindTagProcessingLab()
    {
        string CentreId = UserInfo.Centre.ToString();
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DISTINCT Concat(cm.TagProcessingLabID,'#Lab') as TagProcessingLabID,cm1.centre FROM centre_Master cm INNER JOIN centre_Master cm1 ON cm1.centreId=cm.TagProcessingLabID ");


        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {

            ddlTagProcessingLab.DataSource = dt;
            ddlTagProcessingLab.DataTextField = "Centre";
            ddlTagProcessingLab.DataValueField = "TagProcessingLabID";
            ddlTagProcessingLab.DataBind();
            //ddlTagProcessingLab.Items.Insert(0, new ListItem("--Select--", "0"));
        }
    }
    private void Bindcenter()
    {
        using (DataTable dt = AllLoad_Data.getCentreByLogin())
        {

            chlCentre.DataSource = dt;
            chlCentre.DataTextField = "Centre";
            chlCentre.DataValueField = "CentreID";
            chlCentre.DataBind();
            //  chlCentre.SelectedIndex = chlCentre.Items.IndexOf(chlCentre.Items.FindByValue(UserInfo.Centre.ToString()));
        }
    }
   

    protected void BindDepartment()
    {
        using (DataTable dt = AllLoad_Data.getDepartment())
        {
            if (dt.Rows.Count > 0)
            {
                ddlDepartment.DataSource = dt;
                ddlDepartment.DataTextField = "NAME";
                ddlDepartment.DataValueField = "SubCategoryID";
                ddlDepartment.DataBind();
            }
        }
    }



    protected void btnPreview_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            lblMsg.Text = "";


            if ((dtFrom.Text.Trim() == string.Empty) || (dtTo.Text.Trim() == string.Empty))
            {
                lblMsg.Text = "Please select date !";
                return;
            }

            string ReportOf = string.Empty;

            if (chkOutsource.Checked)
                ReportOf = "OutHouse Only";
            if (chkSampleCollected.Checked)
                ReportOf = "Sample Collected";
            if (chkDepartmentReceived.Checked)
                ReportOf = "Department Received";
            if (chkUnapprove.Checked)
                ReportOf = "Unappprove";
            if (chkResultNotDone.Checked)
                ReportOf = "Test Pending";
            if (chkAllPatient.Checked)
                ReportOf = "All Patients";

            string SelectedCentres = string.Empty;

            for (int i = 0; i < chlCentre.Items.Count; i++)
            {
                if (chlCentre.Items[i].Selected == true)
                {
                    SelectedCentres += chlCentre.Items[i].Value + ",";
                }
            }
            if (SelectedCentres.Length > 1)
            {
                SelectedCentres = SelectedCentres.Substring(0, SelectedCentres.Length - 1);
            }

            string Dept = "";
            if (ddlDepartment.SelectedIndex > 0)
                Dept = "Department : " + ddlDepartment.SelectedItem.Text;

            
            StringBuilder sb = new StringBuilder();

            sb.Append("  SELECT @ReportOf ReportOf,  cm.centre BookingCentre,(select centre from centre_master where centreid=plo.TestCentreID) TestCentre, ");
            sb.Append(" lt.Patient_ID PatientID,lt.HLMOPDIPDNo IP_OP_No,lt.PName,lt.Age,CONCAT('/ ',lt.Gender) Sex,IF(lt.`Doctor_ID`='2',lt.`DoctorName`,lt.`DoctorName`) DoctorName,  ");
            sb.Append("  plo.ledgertransactionNo VisitID,plo.BarcodeNo SINNo,  ");
            sb.Append("  plo.SubcategoryName DepartmentName,  ");
         
            sb.Append("IF( plo.centreid <> plo.TestCentreID, CONCAT(plo.ItemName,'',IF(plo.IsSampleCollected = 'R',CONCAT('- Rejected Remarks : ', plo.UpdateRemarks),'')), CONCAT(plo.ItemName,'',IF(plo.IsSampleCollected = 'R',CONCAT(' - Rejected Remarks : ', plo.UpdateRemarks),''))  ) TestName , ");
            sb.Append("  DATE_FORMAT(plo.Date,'%d-%b-%Y %I:%i%p') RegDateTime,  ");
            if (chkSampleCollected.Checked)
            {
                sb.Append("  DATE_FORMAT(plo.SampleCollectionDate,'%d-%b-%Y %h:%i %p') SampleCollectionDateTime,  ");
                sb.Append(" 'Coll. Date Time' as DepartmentReceiveDateTime,  ");
            }
            else if (chkAllPatient.Checked)
            {
                sb.Append("  DATE_FORMAT(plo.Date,'%d-%b-%Y %h:%i %p') SampleCollectionDateTime,  ");
                sb.Append(" 'Registration Date Time' DepartmentReceiveDateTime,  ");
            }
            else
            {
                sb.Append("  DATE_FORMAT(plo.SampleReceiveDate,'%d-%b-%Y %h:%i %p') SampleCollectionDateTime,  ");
                sb.Append(" 'Dept. Rcv. Date Time' DepartmentReceiveDateTime,  ");
            }
            if (hdnChkValue.Value != "")
            {
                string LbOut = hdnChkValue.Value.Split('#')[1];
                LbOut = LbOut.Split(',')[0];
                if (LbOut == "Outsource")
                {
                    sb.Append("  ifnull(io1.OutSrcLabName,(SELECT centre FROM centre_master cm1 INNER JOIN `test_centre_mapping`  TCP ON  cm1.centreid=tcp.`Test_Centre`  WHERE TCP.`Booking_Centre`=plo.`CentreID` AND tcp.`Test_Centre`=plo.`TestCentreID`  LIMIT 1)) outsrc");
                }
                else
                {
                    sb.Append(" (SELECT centre FROM centre_master cm1 INNER JOIN `test_centre_mapping`  TCP ON  cm1.centreid=tcp.`Test_Centre`  WHERE TCP.`Booking_Centre`=plo.`CentreID` AND tcp.`Test_Centre`=plo.`TestCentreID`  LIMIT 1) as outsrc");
                }
            }
            else
            {
                sb.Append(" (SELECT centre FROM centre_master cm1 INNER JOIN `test_centre_mapping`  TCP ON  cm1.centreid=tcp.`Test_Centre`  WHERE TCP.`Booking_Centre`=plo.`CentreID` AND tcp.`Test_Centre`=plo.`TestCentreID`  LIMIT 1) as outsrc");

            }
            sb.Append("  FROM patient_labinvestigation_opd plo   ");
            sb.Append("  INNER JOIN f_ledgertransaction LT ON LT.LedgerTransactionID = PLO.LedgerTransactionID   ");
            sb.Append("  AND plo.isActive=1   ");
            if (hdnDepartmentValue.Value != "")
            {
                sb.Append(" and plo.subcategoryId in (" + hdnDepartmentValue.Value + ")");
            }
            if (hdnCentre.Value != "" && ReportOf == "Test Pending")
            {
                if (hdnChkValue.Value != "")
                {
                    string testcentreId = hdnChkValue.Value.Split('#')[0].Substring(0, hdnChkValue.Value.Split('#')[0].Length - 1);
                    string LabOrOutsource = hdnChkValue.Value.Split('#')[1];
                    LabOrOutsource = LabOrOutsource.Split(',')[0];
                    if (LabOrOutsource == "Lab")
                        testcentreId = hdnChkValue.Value.Replace("#Lab", "");
                    else
                        testcentreId = hdnChkValue.Value.Replace("#Outsource", "");
                    sb.Append("  and plo.IsSampleCollected='Y' and plo.Approved<>1 and  LT.centreId in (" + hdnCentre.Value + ") and plo.testcentreId in (" + testcentreId + ") ");
                }
                else
                {
                    sb.Append("  and LT.centreId in (" + hdnCentre.Value + ") ");
                }
            }
            else if (hdnCentre.Value != "" && ReportOf != "Test Pending")
            {
                sb.Append("    and plo.Approved<>1 and LT.centreId in (" + hdnCentre.Value + ") ");
            }
            else
            {
                sb.Append(" and ( plo.TestCentreID in ( select ca.CentreAccess from   centre_access ca where  ca.Centreid=@CentreID )   or plo.TestCentreID =@CentreID) ");

            }

            sb.Append("  INNER JOIN centre_master cm ON cm.centreid=lt.centreid   ");
            if (hdnChkValue.Value != "")
            {
                string LabOrOutsource = hdnChkValue.Value.Split('#')[1];
                LabOrOutsource = LabOrOutsource.Split(',')[0];
                if (LabOrOutsource == "Lab")
                {
                    sb.Append(" INNER JOIN test_centre_mapping tcm ON (tcm.Test_Centre=plo.TestCentreID OR tcm.Test_Centre2= plo.TestCentreID OR tcm.Test_Centre3= plo.TestCentreID) AND tcm.Investigation_ID = PLO.Investigation_ID  ");
                }
                else
                {
                    sb.Append("  INNER JOIN   `investigations_outsrclab` io1 on io1.CentreID=plo.TestCentreID and  io1.Investigation_ID = PLO.Investigation_ID   ");
                }
            }
            sb.Append("  WHERE ''='' ");
            if (chkSampleCollected.Checked)
            {
                sb.Append(" AND plo.IsSampleCollected='S' and plo.approved=0 ");
                sb.Append("  AND plo.SampleCollectionDate >=@fromdate  ");
                sb.Append("  AND plo.SampleCollectionDate <=@todate ");
            }
            else if (chkDepartmentReceived.Checked)
            {
                sb.Append(" AND plo.IsSampleCollected='Y'  ");
                sb.Append("  AND plo.SampleReceiveDate >=@fromdate ");
                sb.Append("  AND plo.SampleReceiveDate <=@todate  ");
            }
            else if (chkResultNotDone.Checked)
            {
                sb.Append(" AND IF(plo.`reportnumber`<>'Final Report' and plo.Approved=0,0,plo.Result_Flag)=0   AND plo.IsSampleCollected = 'Y' ");
                sb.Append("  AND plo.SampleReceiveDate >=@fromdate  ");
                sb.Append("  AND plo.SampleReceiveDate <=@todate  ");
            }
            else if (chkUnapprove.Checked)
            {
                sb.Append(" AND plo.result_flag=1 and  plo.Approved =0 AND plo.IsSampleCollected ='Y' ");
                sb.Append("  AND plo.SampleReceiveDate >=@fromdate ");
                sb.Append("  AND plo.SampleReceiveDate <=@todate ");
            }
            else if (chkOutsource.Checked)
            {
                sb.Append(" AND io1.Investigation_ID IS NOT NULL ");
                sb.Append("  AND plo.SampleReceiveDate >=@fromdate  ");
                sb.Append("  AND plo.SampleReceiveDate <=@todate  ");
            }
            else if (chkAllPatient.Checked)
            {
                sb.Append("  AND plo.Date >=@fromdate  ");
                sb.Append("  AND plo.Date <=@todate  ");

            }
            if (hdnChkValue.Value != "")
            {
                string testcentreId = hdnChkValue.Value.Split('#')[0].Substring(0, hdnChkValue.Value.Split('#')[0].Length - 1);
                string LabOrOutsource = hdnChkValue.Value.Split('#')[1];
                LabOrOutsource = LabOrOutsource.Split(',')[0];
                if (LabOrOutsource == "Lab")
                    testcentreId = hdnChkValue.Value.Replace("#Lab", "");
                else
                    testcentreId = hdnChkValue.Value.Replace("#Outsource", "");
                if (LabOrOutsource == "Lab")
                {
                    sb.Append(" AND (tcm.Test_Centre in(" + testcentreId + ") ) ");
                }
                else
                {
                    sb.Append(" AND io1.OutsrclabId in (" + testcentreId + ") ");
                }
                sb.Append("  AND plo.SampleReceiveDate >=@fromdate  ");
                sb.Append("  AND plo.SampleReceiveDate <=@todate ");
            }
            if (hdnItemId.Value != "")
                sb.Append(" AND plo.Investigation_Id in ( " + hdnItemId.Value + " ) ");
            if (ddlhlmtype.SelectedIndex > 0)
                sb.Append(" AND LT.HLMPatientType =@HLMPatientType ");

            sb.Append(" AND plo.`IsReporting`=1 group by plo.Test_ID ");
            sb.Append("  ORDER BY BookingCentre,VisitID, testname  ");
            DataTable dtInvest = new DataTable();
            using (MySqlDataAdapter da = new MySqlDataAdapter(sb.ToString(), con))
            {
                da.SelectCommand.Parameters.AddWithValue("@fromdate", string.Concat(Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd")," ", txtFromTime.Text));
                da.SelectCommand.Parameters.AddWithValue("@todate", string.Concat(Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd"), " ", txtToTime.Text));
                da.SelectCommand.Parameters.AddWithValue("@HLMPatientType", ddlhlmtype.SelectedValue);
                da.SelectCommand.Parameters.AddWithValue("@CentreID", UserInfo.Centre);
                da.SelectCommand.Parameters.AddWithValue("@ReportOf", ReportOf);                      
                                
                da.Fill(dtInvest);                
            }                  
            hdnItemId.Value = "0";
            if (dtInvest != null && dtInvest.Rows.Count > 0)
            {
                DataColumn dc = new DataColumn();
                dc.ColumnName = "PrintCentre";
                dc.DefaultValue = UserInfo.CentreName;
                dtInvest.Columns.Add(dc);
                dc = new DataColumn();
                dc.ColumnName = "Period";
                dc.DefaultValue = "From: " + dtFrom.Text + " " + txtFromTime.Text + " To:" + dtTo.Text + " " + txtToTime.Text;
                dtInvest.Columns.Add(dc);

                lblMsg.Text = "Total  Test: " + Util.GetString(dtInvest.Rows.Count);

                if (rd1.SelectedValue == "1")
                {
                    Session["dtWorklistMax"] = dtInvest;
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('NewWorksheet.aspx');", true);
                }
                else
                {                   
                    Session["dtExport2Excel"] = dtInvest;
                    Session["ReportName"] = "WorkList";
                    Response.Redirect("../../common/ExportToExcel.aspx");
                }
            }
            else
            {
                lblMsg.Text = "No record found.";
            }
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.ToString();
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
        
    }

    [WebMethod]    
    public static string BindInvestigations(string DeptId)
    {
        if (DeptId != "")
        {
            string str = "select TypeName,ItemId from f_itemmaster Where SubCategoryId in (" + DeptId + ") order by TypeName";
            using (DataTable dt = StockReports.GetDataTable(str))
            {
                string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
                return rtrn;
            }
        }
        else
        {
            return "0";
        }        
    }

    [WebMethod]
    public static string gettype1()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("select ID,Type1 from centre_type1master Where IsActive=1 order by Type1 "));
    }

    [WebMethod]
    public static string bindCentre()
    {       
            using(DataTable dt = AllLoad_Data.getCentreByLogin())
            return Newtonsoft.Json.JsonConvert.SerializeObject(dt);       
    }    
    
}