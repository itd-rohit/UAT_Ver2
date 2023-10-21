using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Lab_patientLabSearchWorksheetsReport : System.Web.UI.Page
{
    private string FromDate;
    private string ToDate;
    private string macid = "";
    private string rerun = "";
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;

    float HeaderHeight = 80;
    int XHeader = 20;
    int YHeader = 20;
    int HeaderBrowserWidth = 800;

    float FooterHeight = 50;
    int XFooter = 20;
    string Period = "";
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
        document = new PdfDocument();
        tempDocument = new PdfDocument();
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        try
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
                Period = string.Concat("Period From : ", FromDate.ToString(), " To : ", ToDate.ToString());


                StringBuilder sb = new StringBuilder();

                var distinctlabno = (from DataRow dr in dtWorksheet.Rows
                                     select new { LedgerTransactionID = dr["LabNo"], Department = dr["Department"] }).Distinct().ToList();
                for (int k = 0; k < distinctlabno.Count; k++)
                {
                    DataTable dtlabno = dtWorksheet.AsEnumerable().Where(k2 => k2.Field<string>("LabNo") == Util.GetString(distinctlabno[k].LedgerTransactionID)).CopyToDataTable();
                    sb.Append(" <div style='width:1000px;'> ");
                    sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;'>");
                    sb.Append(" <tr> ");

                    sb.Append(" <td colspan='8' style='font-size: 20px;font-weight: bold;text-align:center;'>" + Util.GetString(dtlabno.Rows[0]["Department"].ToString()) + "</td> ");

                    sb.Append(" </tr> ");
                    sb.Append(" <tr> ");
                    sb.Append(" <td  style='width: 7%;font-size: 15px;border-top:1px solid;'>LabNo : </td> ");
                    sb.Append(" <td  style='width: 8%;font-size: 15px;font-weight: bold;border-top:1px solid;text-align:left;'>" + Util.GetString(dtlabno.Rows[0]["LabNo"].ToString()) + "</td> ");
                    sb.Append(" <td  style='width: 10%;font-size: 15px;border-top:1px solid;'>PatientID : </td> ");
                    sb.Append(" <td  style='width: 13%;font-size: 15px;font-weight: bold;border-top:1px solid;text-align:left;'>" + Util.GetString(dtlabno.Rows[0]["PatientID"].ToString()) + "</td> ");
                    sb.Append(" <td  style='width: 11%;font-size: 15px;border-top:1px solid;'>PatientName : </td> ");
                    sb.Append(" <td  style='width: 15%;font-size: 15px;font-weight: bold;border-top:1px solid;text-align:left;'>" + Util.GetString(dtlabno.Rows[0]["PatientName"].ToString()) + "</td> ");
                    sb.Append(" <td  style='width: 12%;font-size: 15px;border-top:1px solid;'>Age/Gender : </td> ");
                    sb.Append(" <td  style='width: 16%;font-size: 15px;font-weight: bold;border-top:1px solid;text-align:left;'>" + Util.GetString(dtlabno.Rows[0]["Age"].ToString()) + '/' + Util.GetString(dtlabno.Rows[0]["Gender"].ToString()) + "</td> ");
                    sb.Append(" </tr> ");
                    sb.Append(" <tr> ");
                    sb.Append(" <td colspan='2' style='width: 15%;font-size: 15px;border-bottom:1px solid;'>Investigation Name : </td> ");
                    sb.Append(" <td colspan='4' style='font-size: 15px;font-weight: bold;border-bottom:1px solid;text-align:left;'>" + Util.GetString(dtlabno.Rows[0]["Invname"].ToString()) + "</td> ");
                    sb.Append(" <td  style='width: 12%;font-size: 15px;border-bottom:1px solid;'>Lab Serial No :</td> ");
                    sb.Append(" <td  style='width: 16%;font-size: 15px;border-bottom:1px solid;'>---</td> ");
                    sb.Append(" </tr> ");
                    sb.Append("</table>");
                    sb.Append("</div>");

                    sb.Append(" <div style='width:1000px;'> ");
                    sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
                   
                    var distinctInv = (from DataRow drw in dtlabno.Rows
                                       select new { InvestigationId = drw["InvestigationId"] }).Distinct().ToList();
                    sb.Append(" <tr> ");

                    sb.Append(" <td colspan= '6'; style='width: 100%;font-size: 16px;font-weight: bold;text-align:left;'>BarcodeNo : " + Util.GetString(dtlabno.Rows[0]["barcodeno"].ToString()) + "</td> ");
                    sb.Append(" </tr> ");
                    for (int j = 0; j < distinctInv.Count; j++)
                    {
                        DataTable dtInv = dtlabno.AsEnumerable().Where(x => x.Field<string>("InvestigationId") == Util.GetString(distinctInv[j].InvestigationId)).CopyToDataTable();
                      
                        for (int i = 0; i < dtInv.Rows.Count; i++)
                        {
                            sb.Append(" <tr> ");
                            sb.AppendFormat(" <td  style='width: 25%;font-size: 14px;padding-bottom: 10px;text-align:left;'>{0}</td>", Util.GetString(dtInv.Rows[i]["TestName1"].ToString()));
                            sb.AppendFormat(" <td  style='width: 10%;font-size: 14px;padding-bottom: 10px;text-align:left;'>{0}</td>","--", Util.GetString(dtInv.Rows[i]["TestName2"].ToString()));
                            sb.AppendFormat(" <td  style='width: 25%;font-size: 14px;padding-bottom: 10px;text-align:left;'>{0}</td>", Util.GetString(dtInv.Rows[i]["TestName3"].ToString()));
                            sb.AppendFormat(" <td  style='width: 10%;font-size: 14px;padding-bottom: 10px;text-align:left;'>{0}</td>","--", Util.GetString(dtInv.Rows[i]["TestName4"].ToString()));
                            sb.AppendFormat(" <td  style='width: 20%;font-size: 14px;padding-bottom: 10px;text-align:left;'>{0}</td>", Util.GetString(dtInv.Rows[i]["TestName5"].ToString()));
                            sb.AppendFormat(" <td  style='width: 10%;font-size: 14px;padding-bottom: 10px;text-align:left;'>{0}</td>","--", Util.GetString(dtInv.Rows[i]["TestName6"].ToString()));
                            sb.AppendFormat(" </tr> ");
                        }
                    }
                    sb.Append("</table>");
                    sb.Append("</div>");
                }


                AddContent(sb.ToString());
                SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
                mergeDocument();
                byte[] pdfBuffer = document.WriteToMemory();
                HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
                HttpContext.Current.Response.BinaryWrite(pdfBuffer);
                HttpContext.Current.Response.End();
            }
            else
            {
                Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'>Record Not Found.<span><br/></center>");
                return;
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            if (document != null)
            {
                document.Close();
            }
            if (tempDocument != null)
            {
                tempDocument.Close();
            }
            Session["WorkSheetData"] = "";
            Session.Remove("WorkSheetData");
        }
    }

    public DataTable getPatientMaster(string LabNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT lt.Patient_ID,IF(pm.DOB = '0001-01-01',pm.Age,DATEDIFF(NOW(),pm.DOB)/365)AGE,  ");
            sb.Append(" IF(pm.DOB = '0001-01-01',  ");
            sb.Append(" (CASE WHEN pm.AGE LIKE '%DAY%' THEN ((TRIM(REPLACE(pm.AGE,'DAY(S)',''))+0))  ");
            sb.Append(" WHEN pm.AGE LIKE '%MONTH%' THEN ((TRIM(REPLACE(pm.AGE,'MONTH(S)',''))+0)*30)  ");
            sb.Append(" ELSE ((TRIM(REPLACE(pm.AGE,'YRS',''))+0)*365) END),   ");
            sb.Append(" DATEDIFF(NOW(),pm.DOB))AGE_in_Days,pm.Gender,lt.LedgerTransactionNo   ");
            sb.Append(" FROM f_ledgertransaction lt INNER JOIN patient_master pm ON pm.Patient_ID = lt.Patient_ID    ");
            sb.Append(" WHERE lt.LedgerTransactionNo=@LedgerTransactionNo	");
            using (DataTable dtItem = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@LedgerTransactionNo", LabNo)).Tables[0])
            {
                return dtItem;
            }
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
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
        string CentreID = Util.GetString(Request.QueryString["CentreID"]);
        StringBuilder sb = new StringBuilder();
        DataTable dtTest = new DataTable();
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string LabType = "OPD";
            if (LabType == "OPD")
            {
                if (ReportType == "1")
                {
                     sb = new StringBuilder();
                    sb.Append("   SELECT IFNULL(IF(pli.LabOutsrcID=0, im.Name,CONCAT(im.name,'(OutSrc-',pli.LabOutsrcName,')')),im.name) Name,pli.Investigation_ID,pli.Test_ID,'' SlideNumber, ");
                    sb.Append(" Im.Name IName, ");
                    sb.Append("   pli.Result_Flag,plo.Value,plo.ID,CASE WHEN pli.Approved IS NOT NULL THEN 'True' ELSE 'False' END AS Approved,   ");
                    sb.Append("   pli.Investigation_ID,LOM.Name AS obName,pli.barcodeno,LOM.LabObservation_ID,      ");
                    sb.Append("   IFNULL(lr.MinReading,'') Minimum ,      ");
                    sb.Append("   IFNULL(lr.MaxReading,'') Maximum, ");
                    sb.Append("   IFNULL(lr.ReadingFormat,'')ReadingFormat, ");
                    sb.Append("   loi.Priorty ,Im.ReportType,lom.ParentID,lom.Child_Flag, ");
                    sb.Append("   CONCAT(pm.Title,' ',pm.PName) AS PatientName,pm.Age,pm.Gender,lt.LedgerTransactionNo AS LabNo,pm.Patient_ID,    ");
                    sb.Append("   (CASE WHEN fpm.Panel_id='78' && dm.Name = 'Others' THEN 'Other' ");
                    sb.Append("   WHEN fpm.Panel_id<>'78' THEN fpm.Company_Name ELSE   ");
                    sb.Append("   IF(dm.Name !='WALKIN',CONCAT(dm.Title,' ',dm.NAME),dm.Name) END ) DoctorName, ");
                    sb.Append("   '' Remarks,IFNULL(pli.barcodeno,'') CardNo  ");
                    sb.Append("   FROM ( SELECT Investigation_ID,LabOutsrcID,LabOutsrcName,Test_ID,Result_Flag,Approved,barcodeno,LedgerTransactionNo,isrerun FROM patient_labinvestigation_opd  ");
                    sb.Append("   WHERE Test_id=@Test_id and LedgerTransactionNo=@LedgerTransactionNo ) pli  ");
                    sb.Append("   INNER JOIN investigation_master im ON pli.Investigation_ID=im.Investigation_Id   ");
                    sb.Append("   and im.ReportType=1  ");

                    if (macid != "" && macid != "null")
                    {
                        sb.Append("   INNER JOIN labobservation_investigation loi ON im.Investigation_Id=loi.Investigation_Id   ");
                        sb.Append("   INNER JOIN  labobservation_master lom  ON loi.labObservation_ID=lom.LabObservation_ID  ");
                        sb.Append(" INNER JOIN " + AllGlobalFunction.MachineDB + ".mac_param_master macm ON macm.LabObservation_id=lom.LabObservation_ID  ");
                        sb.Append(" INNER JOIN " + AllGlobalFunction.MachineDB + ".mac_machineparam mpm ON mpm.Machine_ParamID=macm.Machine_ParamID AND mpm.MACHINEID=@macid  ");
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
                    sb.Append("   AND lr.Gender=@Gender AND lr.FromAge<=@AGE_in_Days AND lr.ToAge>=@AGE_in_Days ");

                    

                    if (CentreID != "" && CentreID != "ALL")
                    {
                        sb.Append(" and lr.CentreID in(" + CentreID + ") ");
                    }
                    //else
                    //{
                    //    sb.Append(" and lr.CentreID=@SessionCentre ");
                    //}

                    sb.Append("   ORDER BY pli.LedgerTransactionNo,obm.Name,im.Print_Sequence,loi.printOrder  ");
                }
                else if (ReportType == "3" || ReportType == "2")
                {
                     sb = new StringBuilder();
                    sb.Append("     SELECT IF(pli.Approved=1,'false','true')Approved,pli.ApprovedBy,pli.test_id ID,DATE_FORMAT(pli.Date,'%d-%b-%y')DATE,pli.Test_ID,pli.Result_Flag,pli.SlideNumber,  ");
                    sb.Append(" Im.Name IName ,");
                    sb.Append("        pli.Investigation_ID,Im.ReportType,CONCAT(pm.Title,' ',pm.PName) AS PatientName,pm.Age,pm.Gender,pli.barcodeno  LabNo,pm.Patient_ID,");
                    sb.Append(" '' DoctorName,'' Remarks,lt.CardNo ");
                    sb.Append(" FROM patient_labinvestigation_opd pli   ");
                    sb.Append("        INNER JOIN investigation_master im ON pli.Investigation_ID=im.Investigation_Id   ");
                    sb.Append(" INNER JOIN f_ledgertransaction	LT ON LT.LedgerTransactionNo = pli.LedgerTransactionNo   ");
                    sb.Append(" INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.Panel_ID ");
                    sb.Append("        INNER JOIN patient_master pm ON pm.Patient_ID=lt.Patient_ID    ");
                    sb.Append("        WHERE  pli.LedgerTransactionNo=@LedgerTransactionNo AND pli.Test_id=@Test_id AND im.ReportType IN(2,3)  ");

                   
                }
            }
            using (dtTest = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
               new MySqlParameter("@LedgerTransactionNo", LabNo),
                new MySqlParameter("@Test_id", TestId),
                new MySqlParameter("@Gender", Gender.Substring(0, 1)),
                new MySqlParameter("@AGE_in_Days", AGE_in_Days),
                new MySqlParameter("@macid", macid)
                  //new MySqlParameter("@SessionCentre", UserInfo.Centre)
                  ).Tables[0])
            {
                return dtTest;
            }
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
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
            dtWorksheet.AcceptChanges();
            return dtWorksheet;
        }
    }
    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        PdfPage page1 = eventParams.PdfPage;

        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
        SetFooter(page1);
    }


    private void SetHeader(PdfPage page)
    {
        page.CreateHeaderCanvas(HeaderHeight);
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakeHeader(), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);

    }
    private string MakeHeader()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" <div style='width:1000px;'> ");
        sb.Append("<table style='width: 1000px;border-collapse: collapse;font-family:Arial;margin-bottom: 10px;margin-top:15px;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");

        sb.Append("<span style='font-weight: bold;font-size:20px;'>Lab Work Sheet</span><br />");

        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("</table>");
        sb.Append(" </div> ");

        return sb.ToString();
    }
    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
        }
    }
    private void AddContent(string Content)
    {
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty);
        PdfHtml html1 = new PdfHtml();
        html1 = new PdfHtml(MarginLeft, 0, PageWidth, Content, null);
        html1.PageCreatingEvent += new PdfPageCreatingDelegate(htmlToPdfConverter_PageCreatingEvent);
        html1.FontEmbedding = false;
        html1.BrowserWidth = BrowserWidth;
        html1.ImagesCutAllowed = false;
        html1LayoutInfo = page1.Layout(html1);
    }
    private void mergeDocument()
    {
        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {
            PdfHtml linehtml = new PdfHtml(XFooter, -4, "<div style='width:1140px;border-top:3px solid black;'></div>", null);
            System.Drawing.Font pageNumberingFont =
            new System.Drawing.Font(new System.Drawing.FontFamily("Arial"), 8, System.Drawing.GraphicsUnit.Point);
            PdfText pageNumberingText = new PdfText(PageWidth - 20, FooterHeight - 40, String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;
            PdfText printdatetime = new PdfText(PageWidth - 520, FooterHeight - 40, DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), pageNumberingFont);
            printdatetime.ForeColor = System.Drawing.Color.Black;

            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);

            }
            p.Footer.Layout(linehtml);
            p.Footer.Layout(pageNumberingText);
            p.Footer.Layout(printdatetime);
            document.Pages.AddPage(p);
            pageno++;
        }
        tempDocument = new PdfDocument();
    }
}