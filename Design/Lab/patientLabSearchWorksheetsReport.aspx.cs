using System;
using MW6BarcodeASPNet;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Data;
using System.Text;
using System.Web.UI;
using System.IO;
using CrystalDecisions.CrystalReports.Engine;
public partial class Design_Lab_patientLabSearchWorksheetsReport : System.Web.UI.Page
{
    private string FromDate;
    private string ToDate;
    private string macid = "";
    private string rerun = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        FromDate = Request.QueryString["FromDate"].ToString();
        ToDate = Request.QueryString["ToDate"].ToString();
        macid = Util.GetString(Request.QueryString["macid"].ToString());
        rerun = Util.GetString(Request.QueryString["rerun"].ToString());
        getANDbind();
    }

    public void getANDbind()
    {
        ViewState["Worksheet"] = null;

        string Patient_Details_ID = Session["WorkSheetData"].ToString();
        string TestID = "";
        string[] ID;
        char[] delimentor = new char[] { '|' };
        ID = Patient_Details_ID.Split(delimentor);

        DataTable dtPatientMaster = new DataTable();
        if (ID.Length > 0)
        {
            dtPatientMaster = getPatientMaster(ID[0].Split(',')[0]);
        }
        for (int i = 0; i <= ID.Length - 2; i++)
        {
            TestID = ID[i].ToString();
            getWorksheet(TestID.Split(',')[0], TestID.Split(',')[3], TestID.Split(',')[2], TestID.Split(',')[4],
                dtPatientMaster.Rows[0]["AGE_in_Days"].ToString(), dtPatientMaster.Rows[0]["Gender"].ToString());
        }
        DataTable dtWorksheet = (DataTable)ViewState["Worksheet"];
        if (dtWorksheet != null)
        {
            do
            {
                getChildTest(dtWorksheet);
            }
            while (dtWorksheet.Select("isParent=1", "").Length != 0);
        }

        dtWorksheet = (DataTable)ViewState["Worksheet"];

        if (dtWorksheet != null)
        {
            string PatientId = "";
            int ColumnLoc = 1;
            for (int i = 0; i < dtWorksheet.Rows.Count; i++)
            {
                if (i > 0 && Util.GetString(dtWorksheet.Rows[i - 1]["Department"]) == Util.GetString(dtWorksheet.Rows[i]["Department"]) &&
                    Util.GetString(dtWorksheet.Rows[i - 1]["PatientID"]) == Util.GetString(dtWorksheet.Rows[i]["PatientID"]))
                {
                    dtWorksheet.Rows[i - 1]["TestName3"] = Util.GetString(dtWorksheet.Rows[i]["TestName1"]);
                    dtWorksheet.Rows[i - 1]["TestName4"] = Util.GetString(dtWorksheet.Rows[i]["TestName2"]);

                    dtWorksheet.Rows[i].Delete();
                    dtWorksheet.AcceptChanges();
                    if (i < dtWorksheet.Rows.Count)
                    {
                        if (Util.GetString(dtWorksheet.Rows[i - 1]["Department"]) == Util.GetString(dtWorksheet.Rows[i]["Department"]) &&
                        Util.GetString(dtWorksheet.Rows[i - 1]["PatientID"]) == Util.GetString(dtWorksheet.Rows[i]["PatientID"]) && Util.GetString(dtWorksheet.Rows[i - 1]["TestName3"]) != "")
                        {
                            dtWorksheet.Rows[i - 1]["TestName5"] = Util.GetString(dtWorksheet.Rows[i]["TestName1"]);
                            dtWorksheet.Rows[i - 1]["TestName6"] = Util.GetString(dtWorksheet.Rows[i]["TestName2"]);
                            dtWorksheet.Rows[i].Delete();
                            dtWorksheet.AcceptChanges();
                        }
                    }
                }

                
            }
            DataColumn dc = new DataColumn("Period", Type.GetType("System.String"));
            dc.DefaultValue = "Period From : " + FromDate.ToString() + " To : " + ToDate.ToString();
            dtWorksheet.Columns.Add(dc);

            DataSet ds = new DataSet();
            ds.Tables.Add(dtWorksheet.Copy());
            ds.Tables[0].TableName = "Worksheet";

             ds.WriteXmlSchema(@"F:\LabWorkSheet2.xml");
            Session["ds"] = ds;
            Session["ReportName"] = "LabWorksheet2";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "location.href='../../Design/Common/Commonreport.aspx';", true);
        }
        else
        {
            string msg = "Please select investigation.";
        }
    }

    public DataTable getPatientMaster(string LabNo)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT lt.Patient_ID,IF(pm.DOB = '0001-01-01',pm.Age,DATEDIFF(NOW(),pm.DOB)/365)AGE,  ");
        sb.Append(" IF(pm.DOB = '0001-01-01',  ");
        sb.Append(" (CASE WHEN pm.AGE LIKE '%DAY%' THEN ((TRIM(REPLACE(pm.AGE,'DAY(S)',''))+0))  ");
        sb.Append(" WHEN pm.AGE LIKE '%MONTH%' THEN ((TRIM(REPLACE(pm.AGE,'MONTH(S)',''))+0)*30)  ");
        sb.Append(" ELSE ((TRIM(REPLACE(pm.AGE,'YRS',''))+0)*365) END),   ");
        sb.Append(" DATEDIFF(NOW(),pm.DOB))AGE_in_Days,pm.Gender,lt.LedgerTransactionNo   ");
        sb.Append(" FROM f_ledgertransaction lt INNER JOIN patient_master pm ON pm.Patient_ID = lt.Patient_ID    ");
        sb.Append(" WHERE lt.LedgerTransactionNo='" + LabNo + "'	");
        return StockReports.GetDataTable(sb.ToString());
    }

    private void getChildTest(DataTable dtWorksheet)
    {
        for (int i = 0; i < dtWorksheet.Rows.Count; i++)
        {
            DataRow dr = dtWorksheet.Rows[i];
            if (dr["isParent"].ToString() == "1")
            {
                DataTable dtTemp = new DataTable();
                StringBuilder sb = new StringBuilder();
                sb.Append(" SELECT * FROM labobservation_master WHERE Parentid='" + dr["InvestigationId"].ToString() + "'");
                dtTemp = StockReports.GetDataTable(sb.ToString());

                foreach (DataRow drChild in dtTemp.Rows)
                {
                    DataRow drWork = dtWorksheet.NewRow();
                    drWork["PatientID"] = dr["PatientID"].ToString();
                    drWork["PatientName"] = dr["PatientName"].ToString();
                    drWork["Age"] = dr["Age"].ToString();
                    drWork["Gender"] = dr["Gender"].ToString();
                    drWork["LabNo"] = dr["LabNo"].ToString();
                    //drWork["Department"] = ddlDepartment.SelectedItem.Text;
                    drWork["Department"] = "";
                    drWork["ReportType"] = "1";
                    drWork["TestName1"] = drChild["Name"].ToString() + "(" + dr["TestName1"].ToString() + ")";
                    drWork["TestName2"] = drChild["ReadingFormat"].ToString();
                    drWork["isParent"] = "0";
                    drWork["InvestigationId"] = drChild["LabObservation_ID"].ToString();
                    dtWorksheet.Rows.Add(drWork);

                    //6220180008400155258
                }
                dtWorksheet.Rows[i].Delete();
                dtWorksheet.AcceptChanges();
            }
        }
        ViewState["Worksheet"] = dtWorksheet;
    }

    private DataTable getTest(string LabNo, string TestId, string ReportType, string AGE_in_Days, string Gender)
    {
        DataTable dtTest = new DataTable();

        string LabType = "OPD";
        if (LabType == "OPD")
        {
            if (ReportType == "1")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("   SELECT DISTINCT IFNULL(IF(pli.LabOutsrcID=0, im.Name,CONCAT(im.name,'(OutSrc-',pli.LabOutsrcName,')')),im.name) Name,pli.Investigation_ID,pli.Test_ID,'' SlideNumber, ");
                sb.Append("   pli.Result_Flag,plo.Value,plo.ID,concat(Im.Name,' -(',pli.SampleTypeName,')') as IName,CASE WHEN pli.Approved IS NOT NULL THEN 'True' ELSE 'False' END AS Approved,   ");
                sb.Append("   pli.Investigation_ID,LOM.Name AS obName,pli.barcodeno,LOM.LabObservation_ID,      ");
                sb.Append("   IFNULL(lr.MinReading,'') Minimum ,      ");
                sb.Append("   IFNULL(lr.MaxReading,'') Maximum, ");
                sb.Append("   IFNULL(lr.ReadingFormat,'')ReadingFormat, ");
                sb.Append("   loi.Priorty ,Im.ReportType,lom.ParentID,lom.Child_Flag, ");
                sb.Append("   CONCAT(pm.Title,' ',pm.PName) AS PatientName,pm.Age,pm.Gender,lt.LedgerTransactionNo AS LabNo,pm.Patient_ID,    ");
                sb.Append("   (CASE WHEN fpm.Panel_id='78' && dm.Name = 'Others' THEN lt.otherDoctorName ");
                sb.Append("   WHEN fpm.Panel_id<>'78' THEN fpm.Company_Name ELSE   ");
                sb.Append("   IF(dm.Name !='WALKIN',CONCAT(dm.Title,' ',dm.NAME),dm.Name) END ) DoctorName, ");
                sb.Append("   lt.Remarks,lt.Remarks,IFNULL(pli.barcodeno,'') CardNo  ");
                sb.Append("   FROM ( SELECT Investigation_ID,LabOutsrcID,LabOutsrcName,Test_ID,Result_Flag,Approved,barcodeno,LedgerTransactionNo,SampleTypeName FROM patient_labinvestigation_opd  ");
                sb.Append("   WHERE Test_id='" + TestId + "' and LedgerTransactionNo='" + LabNo + "' ) pli  ");
                sb.Append("   INNER JOIN investigation_master im ON pli.Investigation_ID=im.Investigation_Id   ");
                sb.Append("   and im.ReportType=1  ");

                if (macid != "" && macid != "null")
                {
                   
                    sb.Append("   INNER JOIN labobservation_investigation loi ON im.Investigation_Id=loi.Investigation_Id   ");
                    sb.Append("   INNER JOIN  labobservation_master lom  ON loi.labObservation_ID=lom.LabObservation_ID  ");
                    sb.Append(" inner JOIN investigation_machinemaster imm ON imm.`CentreID`='" + UserInfo.Centre + "' AND imm.`Investigation_ID` = pli.`Investigation_ID`  ");
                    sb.Append(" and imm.MachineID='" + macid + "' ");
                    //sb.Append(" INNER JOIN " + AllGlobalFunction.MachineDB + ".mac_param_master macm ON macm.LabObservation_id=lom.LabObservation_ID  ");
                    //sb.Append(" INNER JOIN " + AllGlobalFunction.MachineDB + ".mac_machineparam mpm ON mpm.Machine_ParamID=macm.Machine_ParamID AND mpm.MACHINEID='" + macid + "'  ");
                }
                else
                {
                    sb.Append("   INNER JOIN labobservation_investigation loi ON im.Investigation_Id=loi.Investigation_Id   ");
                    sb.Append("   INNER JOIN  labobservation_master lom  ON loi.labObservation_ID=lom.LabObservation_ID  ");
                }
                
                sb.Append("   INNER JOIN investigation_observationtype io ON io.investigation_id = im.Investigation_Id ");
                sb.Append("   INNER JOIN observationtype_master obm ON obm.ObservationType_ID=io.ObservationType_Id ");
                sb.Append("   INNER JOIN f_ledgertransaction	LT ON LT.LedgerTransactionNo = pli.LedgerTransactionNo           ");
                sb.Append("   INNER JOIN f_panel_master fpm ON fpm.Panel_ID=LT.Panel_ID  ");
                sb.Append("   INNER JOIN doctor_referal dm ON dm.Doctor_ID=LT.Doctor_ID   ");
                sb.Append("                       ");
                sb.Append("   INNER JOIN patient_master pm ON pm.Patient_ID=LT.Patient_ID  ");
                sb.Append("   LEFT JOIN patient_labobservation_opd plo  ON pli.Test_ID=plo.Test_ID AND plo.LabObservation_ID=LOM.LabObservation_ID   ");
                if (rerun == "1")
                {
                    sb.Append(" and pli.isrerun='1' ");
                }

                sb.Append("   LEFT OUTER JOIN labobservation_range lr ON lr.LabObservation_ID=lom.LabObservation_ID and lr.rangetype='Normal' ");
                sb.Append("   AND lr.Investigation_ID=im.Investigation_ID  ");
                sb.Append("   AND lr.Gender='" + Gender.Substring(0, 1) + "' AND lr.FromAge<='" + AGE_in_Days + "' AND lr.ToAge>='" + AGE_in_Days + "' ");

                string CentreID = Util.GetString(Request.QueryString["CentreID"]);

                if (CentreID != "" && CentreID != "ALL")
                {
                    sb.Append(" and lr.CentreID=" + CentreID + " ");
                }
                else
                {
                    sb.Append(" and lr.CentreID=" + UserInfo.Centre + " ");
                }

                sb.Append("   ORDER BY pli.LedgerTransactionNo,obm.Name,im.Print_Sequence,loi.printOrder  ");

                dtTest = StockReports.GetDataTable(sb.ToString());
            }
            else if (ReportType == "3" || ReportType == "2")
            {
                StringBuilder sb = new StringBuilder();
                sb.Append("     SELECT IF(pli.Approved=1,'false','true')Approved,pli.ApprovedBy,pli.test_id ID,DATE_FORMAT(pli.Date,'%d-%b-%y')DATE,pli.Test_ID,pli.Result_Flag,pli.SlideNumber,  ");
                sb.Append("        pli.Investigation_ID,Im.Name AS IName,Im.ReportType,CONCAT(pm.Title,' ',pm.PName) AS PatientName,pm.Age,pm.Gender,pli.barcodeno  LabNo,pm.Patient_ID,");
                sb.Append(" '' DoctorName,lt.Remarks,lt.CardNo ");

                sb.Append(" FROM patient_labinvestigation_opd pli   ");
                sb.Append("        INNER JOIN investigation_master im ON pli.Investigation_ID=im.Investigation_Id   ");
                sb.Append(" INNER JOIN f_ledgertransaction	LT ON LT.LedgerTransactionNo = pli.LedgerTransactionNo   ");
                sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
                sb.Append("  ");
                

                sb.Append("        INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID    ");
                sb.Append("        WHERE  pli.LedgerTransactionNo='" + LabNo + "' AND pli.Test_id='" + TestId + "' AND im.ReportType IN(2,3)  ");

                dtTest = StockReports.GetDataTable(sb.ToString());
            }
        }
        

        return dtTest;
    }

    private void getWorksheet(string LabNo, string TestId, string ReportType, string Department, string AGE_in_Days, string Gender)
    {
        DataTable dtWorksheet = vs_getWorksheet();

        DataTable dtTest = getTest(LabNo, TestId, ReportType, AGE_in_Days, Gender);
       

        if (dtTest != null && dtTest.Rows.Count > 0)
        {
            if (ReportType == "3" || ReportType == "2")
            {
                DataRow drTest = dtTest.Rows[0];
                DataRow drWork = dtWorksheet.NewRow();
                drWork["PatientID"] = drTest["Patient_ID"].ToString();
                drWork["PatientName"] = drTest["PatientName"].ToString();
                drWork["Age"] = drTest["Age"].ToString();
                drWork["Gender"] = drTest["Gender"].ToString();
                drWork["LabNo"] = drTest["LabNo"].ToString();

                drWork["Department"] = Department;
                drWork["SlideNumber"] = drTest["SlideNumber"].ToString();
                drWork["ReportType"] = "2";
                drWork["TestName1"] = drTest["IName"].ToString();
                drWork["TestName2"] = "";
                drWork["isParent"] = "0";
                drWork["InvestigationId"] = "";
                drWork["DoctorName"] = drTest["DoctorName"].ToString();
                drWork["Remarks"] = drTest["Remarks"].ToString();
                drWork["CardNo"] = drTest["CardNo"].ToString();
                drWork["barcodeno"] = "";
                drWork["Invname"] = drTest["iname"].ToString();
                dtWorksheet.Rows.Add(drWork);
                ViewState["Worksheet"] = dtWorksheet;
            }
            else if ((ReportType == "1" && (dtTest.Rows.Count > 0)))
            {
                for (int k = 0; k < dtTest.Rows.Count; k++)
                {
                    DataRow drTest = dtTest.Rows[k];
                    DataRow drWork = dtWorksheet.NewRow();
                    drWork["PatientID"] = drTest["Patient_ID"].ToString();
                    drWork["PatientName"] = drTest["PatientName"].ToString();
                    drWork["Age"] = drTest["Age"].ToString();
                    drWork["Gender"] = drTest["Gender"].ToString();
                    drWork["LabNo"] = drTest["LabNo"].ToString();

                    drWork["Department"] = Department;
                    drWork["SlideNumber"] = drTest["SlideNumber"].ToString();
                    drWork["ReportType"] = "1";
                    drWork["TestName1"] = drTest["obName"].ToString();
                    drWork["TestName2"] = drTest["ReadingFormat"].ToString();
                    drWork["isParent"] = drTest["Child_Flag"].ToString();
                    drWork["InvestigationId"] = drTest["LabObservation_ID"].ToString();
                    drWork["DoctorName"] = drTest["DoctorName"].ToString();
                    drWork["Remarks"] = drTest["Remarks"].ToString();
                    drWork["CardNo"] = drTest["CardNo"].ToString();
                    drWork["barcodeno"] = drTest["barcodeno"].ToString();
                    drWork["Invname"] = drTest["iname"].ToString();
                    string barcode = new Barcode_alok().Save(Util.GetString(drTest["Barcodeno"].ToString())).Trim();
                    string x = barcode.Replace("data:image/png;base64,", "");
                    byte[] imageBytes = Convert.FromBase64String(x);
                    MemoryStream ms = new MemoryStream(imageBytes, 0, imageBytes.Length);
                    drWork["Image1"] = imageBytes;
                    dtWorksheet.Rows.Add(drWork);
                    ViewState["Worksheet"] = dtWorksheet;
                }
            }
        }
    }

    private DataTable vs_getWorksheet()
    {
        DataTable dtWorksheet = (DataTable)ViewState["Worksheet"];
        if (dtWorksheet != null)
        {
            return dtWorksheet;
        }
        else
        {
            dtWorksheet = new DataTable();
            dtWorksheet.Columns.Add("PatientID");
            dtWorksheet.Columns.Add("PatientName");
            dtWorksheet.Columns.Add("Age");
            dtWorksheet.Columns.Add("Gender");
            dtWorksheet.Columns.Add("LabNo");
            dtWorksheet.Columns.Add("Department");
            dtWorksheet.Columns.Add("SlideNumber");
            dtWorksheet.Columns.Add("ReportType");
            dtWorksheet.Columns.Add("TestName1");
            dtWorksheet.Columns.Add("TestName2");
            dtWorksheet.Columns.Add("TestName3");
            dtWorksheet.Columns.Add("TestName4");
            dtWorksheet.Columns.Add("TestName5");
            dtWorksheet.Columns.Add("TestName6");
            dtWorksheet.Columns.Add("isParent");
            dtWorksheet.Columns.Add("InvestigationId");
            dtWorksheet.Columns.Add("DoctorName");
            dtWorksheet.Columns.Add("Remarks");
            dtWorksheet.Columns.Add("CardNo");
            dtWorksheet.Columns.Add("barcodeno");
            dtWorksheet.Columns.Add("Invname");
            DataColumn dc1 = new DataColumn("Image1");
            dc1.DataType = System.Type.GetType("System.Byte[]");
            dtWorksheet.Columns.Add(dc1);         
            dtWorksheet.AcceptChanges();
            return dtWorksheet;
        }
    }
}