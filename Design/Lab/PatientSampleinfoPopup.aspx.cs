using System;
using System.Data;
using System.Collections.Generic;
using System.Text;
using MySql.Data.MySqlClient;
using System.Linq;
public partial class Design_OPD_PatientSampleinfoPopup : System.Web.UI.Page
{
    string LedgerTransactionNo;
    string TestID;
    protected void Page_Load(object sender, EventArgs e)
    {
        LedgerTransactionNo = Request.QueryString["LabNo"].ToString();
        TestID = Request.QueryString["TestID"].ToString().Replace(",", "','");
        BindPanelinfo();

    }
    private void BindPanelinfo()
    {
        List<string> Test_ID = TestID.TrimEnd(',').Split(',').ToList<string>();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append("    SELECT date_format(pm.DOB,'%d-%b-%Y') DOB,plo.LedgerTransactionNo, IFNULL((SELECT ID FROM document_detail dd WHERE dd.`labNo`=lt.`LedgerTransactionNo` And IsActive=1 LIMIT 1 ),'')DocumentStatus, ");
            sb.Append("    plo.BarcodeNo,lt.CreatedBy as WorkOrderBy,'' Comments,plo.isHold,if(plo.isHold=1,plo.holdByName,'')holdByName,");
            sb.Append("   if(plo.isHold=1,plo.Hold_Reason,'')Hold_Reason,DATE_FORMAT(plo.SampleCollectionDate,'%d-%b-%y %I:%i%p') SegratedDate,plo.SampleCollector,");
            sb.Append("   lt.doctorname AS ReferDoctor  ,lt.panelname Panel_Code, plo.Approved,  plo.ApprovedBy, plo.ApprovedName, ");
            sb.Append("   Date_Format(plo.ApprovedDate,'%d-%b-%y %I:%i%p')ApprovedDate, if(plo.IsSampleCollected='R',psr.RejectionReason,'')RejectionReason,");
            sb.Append("  plo.ResultEnteredName,DATE_FORMAT(plo.ResultEnteredDate,'%d-%b-%y %I:%i%p')ResultEnteredDate,(select Name from employee_master where Employee_ID=plo.ApprovedDoneBy)ApprovedDoneBy,  ");
            sb.Append("    plo.SampleTypeName SampleType,CONCAT(pm.Title,' ',pm.PName) PName, pm.Gender,CONCAT(pm.Age,'/',LEFT(pm.Gender,1)) Age,PM.Mobile Mobile,otm.Name DepartmentName, if(plo.IsSampleCollected='R',psr.RejectionReason,'')RejectionReason, plo.SampleCollector, DATE_FORMAT(plo.SampleCollectionDate, '%d-%b-%y %I:%i%p') SegratedDate,  ");
            sb.Append("    if(plo.IsSampleCollected='R',DATE_FORMAT(psr.entdate,'%d-%b-%y %I:%i%p'),'') RejectDate,  ");
            sb.Append("    DATE_FORMAT(plo.SampleReceiveDate,'%d-%b-%y %I:%i%p')SampleReceiveDate ,SampleReceiver SampleReceivedBy, ");

            sb.Append("    if(plo.IsSampleCollected='R',(SELECT NAME FROM employee_master WHERE Employee_ID=psr.UserID),'') RejectUser , im.name,'' HomeCollectionDate, ");
            sb.Append(" (SELECT STATUS FROM patient_labinvestigation_opd_update_status WHERE STATUS LIKE 'printed by%' AND ledgertransactionNo = @LedgerTransactionNo LIMIT 1) printby ");
            sb.Append("    FROM   ");
            sb.Append("    (SELECT * FROM patient_labinvestigation_opd WHERE LedgerTransactionNo=@LedgerTransactionNo AND Test_ID IN ({0}) ) plo  ");


            sb.Append("    INNER JOIN f_ledgertransaction lt on lt.LedgerTransactionNo=plo.LedgerTransactionNo  ");
            sb.Append("    INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID  ");
            sb.Append("    INNER JOIN investigation_observationtype iom ON iom.Investigation_ID = plo.Investigation_ID  ");
            sb.Append("    INNER JOIN observationtype_master otm ON otm.ObservationType_Id = iom.ObservationType_Id   ");
            sb.Append("    INNER JOIN investigation_master im ON im.Investigation_Id=iom.Investigation_ID");
            sb.Append("    LEFT JOIN (SELECT * FROM patient_sample_rejection psr WHERE psr.Test_ID IN ({0}) ORDER BY EntDate DESC LIMIT 1 ) psr ON psr.Test_ID=plo.test_ID  ");
            sb.Append("    GROUP BY plo.Investigation_Id  ");




            DataTable dt = new DataTable();
            using (dt as IDisposable)
            {
                using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", Test_ID)), con))
                {
                    da.SelectCommand.Parameters.AddWithValue("@LedgerTransactionNo", LedgerTransactionNo);
                    for (int i = 0; i < Test_ID.Count; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                    }
                    da.Fill(dt);
                    sb = new StringBuilder();
                    Test_ID.Clear();
                }





                if (dt.Rows.Count > 0)
                {

                    hlAttachment.NavigateUrl = "../Lab/AddFileRegistration.aspx?labno=" + dt.Rows[0]["LedgerTransactionNo"].ToString();
                    hlAttachment.Target = "_blank";


                    lblLabNo.Text = dt.Rows[0]["LedgerTransactionNo"].ToString();

                    lblPatientName.Text = dt.Rows[0]["PName"].ToString();
                    lblSampleType.Text = dt.Rows[0]["SampleType"].ToString();
                    lblRefDoctor.Text = dt.Rows[0]["ReferDoctor"].ToString();
                    lblAge.Text = dt.Rows[0]["Age"].ToString().Replace("YRS", "Yrs");
                    lblpanel.Text = dt.Rows[0]["Panel_Code"].ToString();

                    lblComments.Text = dt.Rows[0]["Comments"].ToString();
                    lblVial.Text = dt.Rows[0]["BarcodeNo"].ToString();
                    lblMobile.Text = dt.Rows[0]["Mobile"].ToString();
                    lblDepartment.Text = dt.Rows[0]["DepartmentName"].ToString();
                    llbob.Text = dt.Rows[0]["DOB"].ToString();

                    grdTestDetails.DataSource = dt;
                    grdTestDetails.DataBind();




                    grdrequiredfile.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select FieldName FieldName ,concat(FieldValue,' ',ifnull(unit,'')) FieldValue from patient_labinvestigation_opd_requiredField where LedgerTransactionNo=@LedgerTransactionNo",
                       new MySqlParameter("@LedgerTransactionNo", dt.Rows[0]["LedgerTransactionNo"].ToString()));
                    grdrequiredfile.DataBind();


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
