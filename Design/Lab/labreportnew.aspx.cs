using CrystalDecisions.CrystalReports.Engine;
using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Web;
using System.Web.UI;
using MessagingToolkit.QRCode.Codec;
public partial class Design_Lab_labreportnew : System.Web.UI.Page
{
    public string serverPath = string.Empty;
    DataTable dtObs = new DataTable();
    DataTable dtLabReport = new DataTable();
    DataTable dtOrganismStyle = new DataTable();
    DataTable dtReportHeader = new DataTable();
    DataTable dtAttachment = new DataTable();
    DataTable dtInterpretation = new DataTable();

    DataRow drcurrent;
    PdfLayoutInfo html1LayoutInfo;


    //Report Variables

    public string TestID = string.Empty;
    public List<string> Test_ID = new List<string>();
    string PHead = "0";
    public string LeftMargin = "";
    public string isOnlinePrint = "0";
    public string IsPrev = "0";
    public string isEmail = "";
    public string app = "0";
    //Page Property

    public string DummyWater = string.Empty;
    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 526;
    int BrowserWidth = 800;
    bool showItdose = true;

    string barcodeno = string.Empty;

    //Header Property
    float HeaderHeight = 0;//207
    int XHeader = 0;//20
    int YHeader = 0;//80
    int HeaderBrowserWidth = 800;
    // BackGround Property
    bool HeaderImage = false;
    string HeaderImg = string.Empty;




    //Footer Property 80
    float FooterHeight = 0;//95
    int XFooter = 20;

    //Report Setup
    bool printSeparateDepartment = true;
    bool printEndOfReportAtFooter = false;
    bool signatureonend = true;
    StringBuilder sbCss = new StringBuilder();
    List<string> abnormalimg = new List<string>();

    string machinecomment = string.Empty;
    string deptcomment = string.Empty;
    public DataTable _Attachments;
    public DataTable _MacImage;
    public int papnumber = 1;
    int aci = 97;

    public void showValidationMsg(string errorMsg, string isApp, int XPos, int YPos)
    {
        PdfPage page1 = document.AddPage(PdfPageSize.A4, new PdfDocumentMargins(5), PdfPageOrientation.Portrait);
        Font errFont = new Font("Cambria", 15, FontStyle.Regular, GraphicsUnit.Point);
        PdfText errMsg = new PdfText(XPos, YPos, errorMsg, errFont) { ForeColor = Color.Red };
        page1.Layout(errMsg);
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        document.AddPage(page1);
        byte[] pdfBuffer = document.WriteToMemory();
        if (isApp.Trim() == "1")
        {
            HttpContext.Current.Response.AddHeader("Content-Disposition", String.Format("attachment; filename=PdfText.pdf; size={0}", pdfBuffer.Length.ToString()));
        }
        else
        {
            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
        }
        HttpContext.Current.Response.BinaryWrite(pdfBuffer);
        HttpContext.Current.Response.End();
    }

    PdfDocument document = new PdfDocument();
    PdfDocument tempDocument = new PdfDocument();
    protected void Page_Load(object sender, EventArgs e)
    {

        serverPath = Resources.Resource.LabReportPath;
        DummyWater = Resources.Resource.DummyWaterMark;

        if (!string.IsNullOrEmpty(Request.QueryString["isOnlinePrint"]))
        {
            isOnlinePrint = Common.Decrypt(Request.QueryString["isOnlinePrint"].ToString());
            TestID = Common.Decrypt(HttpUtility.UrlDecode(Request.QueryString["TestID"]));
            PHead = Common.Decrypt(HttpUtility.UrlDecode(Request.QueryString["PHead"]));
            if (!string.IsNullOrEmpty(Request.QueryString["app"]))
                app = Common.Decrypt(HttpUtility.UrlDecode(Request.QueryString["app"]));
        }
        else
        {
            TestID = Util.GetString(Request.QueryString["TestID"]);
            PHead = Util.GetString(Request.QueryString["PHead"]);
        }
        TestID = string.Format("'{0}'", TestID);
        TestID = TestID.Replace(",", "','");

        Test_ID = TestID.TrimEnd(',').Split(',').ToList<string>();

        if (!string.IsNullOrEmpty(Request.QueryString["IsPrev"]))
            IsPrev = Request.QueryString["IsPrev"].ToString();

        if (PHead == "1")
        {
            HeaderImage = true;
        }

        if ((isOnlinePrint == "1") && (isEmail != "1"))
        {
            Session["LoginName"] = "Online";
        }
        if (isOnlinePrint == "1")
        {
            try
            {
                validation objVal = new validation();
                TestID = objVal.isPanelLocked(Test_ID);
                if (TestID.Trim() != "-3")
                {
                    TestID = objVal.lock_PrintReport_ByPanelMaster_TestID(TestID);
                    if (TestID == "''")
                    {
                        TestID = "";
                    }
                    if (TestID != "" && TestID != "''")
                    {
                        TestID = objVal.checkdiscountapproved(TestID);
                        if (TestID == "''")
                        {
                            TestID = "0";
                        }
                        if (TestID != "" && TestID != "''" && TestID != "0")
                        {
                            //TestID = objVal.checkCancelByInterface(TestID);
                            // if (TestID == "''" || TestID=="")
                            // {
                            //     TestID = "-1";
                            // }
                        }
                    }
                }
            }
            catch
            {
                TestID = "-2";
            }
            finally
            {

            }
        }

        else
        {
            if (Util.GetString(Request.QueryString["GetReportBase64"]) != "1")
            {
                
                string PrintDueReport = StockReports.ExecuteScalar("SELECT PrintDueReport  from f_rolemaster  Where Active=1 and ID='" + Util.GetInt(Session["RoleID"]) + "' ");

                if (PrintDueReport != "1")// open For Adminsitartor Role If DueUserInfo.RoleID != 177 ||
                {
                    try
                    {
                        validation objVal = new validation();
                        TestID = objVal.isPanelLocked(Test_ID);
                        if (TestID.Trim() != "-3")
                        {
                            TestID = objVal.lock_PrintReport_ByPanelMaster_TestID(TestID);
                            if (TestID == "''")
                            {
                                TestID = "";
                            }

                            if (TestID != "" && TestID != "''")
                            {
                                TestID = objVal.checkdiscountapproved(TestID);
                                if (TestID == "''")
                                {
                                    TestID = "0";
                                }
                                if (TestID != "" && TestID != "''" && TestID != "0")
                                {
                                    // TestID = objVal.checkCancelByInterface(TestID);
                                    //if (TestID == "''" || TestID == "")
                                    // {
                                    // TestID = "-1";
                                    // }
                                }
                            }
                        }
                    }
                    catch
                    {
                        TestID = "-2";
                    }
                    finally
                    {

                    }
                }
            }

        }
        if (TestID != "" && TestID != "0" && TestID != "-1" && TestID != "-2" && TestID != "-3")
        {
            bindReport();
            if (dtObs.Rows.Count > 0)
            {
                LeftMargin = Util.GetString(dtReportHeader.Rows[0]["LeftMargin"]);
            }
        }
        else if (TestID == "0")
        {
            showValidationMsg("Can't Open Report. Discount is Not Approved..!", app, 170, 30);
            return;
        }
        else if (TestID == "")
        {
            
            showValidationMsg("Can't Open Report. Amount is Due..!", app, 170, 30);
            return;
        }
        else if (TestID == "-1")
        {
            showValidationMsg("Can't Open Report. All The Tests Are Cancelled By Interface Company..!", app, 70, 30);
            return;
        }
        else if (TestID == "-2")
        {
            showValidationMsg("Can't Open Report. Kindly Contact To ITDose..!", app, 170, 30);
            return;
        }
        else if (TestID == "-3")
        {
            showValidationMsg("Credit limit exceeded and your account is locked, Kindly contact to account department.......!", app, 0, 30);
            return;
        }
        if (dtObs.Rows.Count == 0 && dtAttachment.Rows.Count == 0 && document.Pages.Count == 0)
        {
            showValidationMsg("", app, 70, 30);
            return;
        }
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        DataTable dtTemp = StockReports.GetDataTable("select * from labreportmaster order by printOrder");
        sbCss.Append("<style>");
        sbCss.Append(".divContent{width:800px;page-break-inside:avoid; border:0.5px solid black;margin-bottom:15px;} ");
        sbCss.Append(".tbData{width:900px;border-collapse: collapse;  } .tbData tr td{border: 1px solid black;}");
        sbCss.Append(".tbData th{font-weight:bold;} .tbData tr th{border: 1px solid black;}");
        sbCss.Append("table.tbOrganism { border-collapse: collapse;}");
        sbCss.Append("table.tbOrganism, td.tbOrganism, th.tbOrganism{  border: 1px solid black;}");
        foreach (DataRow dr in dtTemp.Rows)
        {
            sbCss.AppendFormat(".{0}{{font-family:{1};font-size:{2}px;text-align:{3};{4}{5} {6}width:{7}px;Height:{8};}}", dr["Name"], dr["FName"], dr["Fsize"], dr["Alignment"], dr["Bold"].ToString() == "Y" ? "font-weight:bold;" : "", dr["Under"].ToString() == "Y" ? "text-decoration:underline;" : "", dr["Italic"].ToString() == "Y" ? "font-style:italic;" : "", dr["width"], dr["Height"]);
        }
        sbCss.Append("</style>");
        // Exculding global style sheet
        DataView view = new DataView(dtTemp) { RowFilter = "Print = 1" };
        dtLabReport = view.ToTable().Copy();
        view.RowFilter = "Print = 2";
        dtOrganismStyle = view.ToTable().Copy();
        bool _FirstRow = true, _LastRow = false;
        StringBuilder sb = new StringBuilder();
        for (int k = 0; k < dtObs.Rows.Count; k++)
        {

            DataRow dr = dtObs.Rows[k];

            if (_FirstRow)
            {
                sb.Append(sbCss.ToString());
                sb.Append("<div class='divContent' ><table class='tbData'>");
            }
            if (dtObs.Rows.IndexOf(dr) == dtObs.Rows.Count - 1)
                _LastRow = true;

            if (dtObs.Rows.Count > 1)
            {
                if ((_FirstRow) ? (dtObs.Rows.Count == 1) : (dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["Test_ID"].ToString() != dr["Test_ID"].ToString()))
                    sb.Append("</table></div>");
            }

            // Condition to check new Page
            if ((_FirstRow) ? false : (dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["LabNo"].ToString() != dr["LabNo"].ToString())
                    ||

                ((printSeparateDepartment == true) ? dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["Dept"].ToString() != dr["Dept"].ToString() : false)
                 ||
                (dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["test_id"].ToString() != dr["test_id"].ToString() && (dr["PrintSeparate"].ToString() == "1" || dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["PrintSeparate"].ToString() != dr["PrintSeparate"].ToString()))
                ||
                dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["approved"].ToString() != dr["approved"].ToString()
                ||
                (dr["SepratePrint"].ToString() == "1")
                ||
                (dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["test_id"].ToString() != dr["test_id"].ToString() && dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["TestCentreID"].ToString() != dr["TestCentreID"].ToString() && dr["isnabl"].ToString() == "1")
        ||
                Util.GetDateTime(dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["ApprovedDate"]).Date != Util.GetDateTime(dr["ApprovedDate"].ToString()).Date
                ||
                dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["PackageName"].ToString() != dr["PackageName"].ToString()

                 ||

                  dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["SignatureID"].ToString() != dr["SignatureID"].ToString()

                )
            {

                if (!printEndOfReportAtFooter)
                {
                    if ((dtObs.Rows.IndexOf(drcurrent) < dtObs.Rows.Count - 1 ? dtObs.Rows[dtObs.Rows.IndexOf(drcurrent) + 1]["LabNo"].ToString() != drcurrent["LabNo"].ToString() : false)
                      ||
                          dtObs.Rows.IndexOf(drcurrent) == dtObs.Rows.Count - 1)
                    {
                        if (dtObs.Rows.Count > 1)
                        {
                            if ((_FirstRow) ? (dtObs.Rows.Count == 1) : (dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["Test_ID"].ToString() != dr["Test_ID"].ToString()))
                                sb.Append("<div class='divContent' ><table class='tbData'>");
                        }

                        sb.AppendFormat("<tr><td class='Department'  colSpan='{0}' style='border:0px;'>&nbsp;</td></tr>", dtLabReport.Rows.Count);
                        sb.AppendFormat("<tr><td class='Department'  colSpan='{0}' style='border-top:1px solid black;border-left:0px;border-right:0px;border-bottom:0px;text-align:center;'>*** End Of Report ***</td></tr>", dtLabReport.Rows.Count);
                        sb.AppendFormat("<tr><td style='border:0px;' colSpan='{0}'>", dtLabReport.Rows.Count);
                     
                        if (drcurrent["ShowSignature"].ToString() != "0")
                        {
                            if (signatureonend == true)
                            {

                                DataRow[] list = dtObs.Select(string.Format("LabNo ='{0}' and Approved=1", drcurrent["LabNo"]));
                                if (list.Length > 0)
                                {
                                    DataTable dataTable = list.CopyToDataTable();
                                    DataView dv = dataTable.DefaultView.ToTable(true, "SignatureID").DefaultView;
                                    dv.Sort = "SignatureID asc";
                                    DataTable deptapp = dv.ToTable();

                                    DataView dv1 = dataTable.DefaultView.ToTable(true, "ForwardBy").DefaultView;
                                    dv1.Sort = "ForwardBy asc";
                                    DataTable deptapp1 = dv1.ToTable();
                                    StringBuilder sbimg = new StringBuilder();
                                    sbimg.Append("<div style='width:800px;page-break-inside:avoid;'>");
                                    foreach (DataRow st in deptapp1.Rows)
                                    {
                                        if (isSign(st["ForwardBy"].ToString()))
                                        {
                                            string imgname = string.Format("{0}Design/opd/signature/{1}.jpg", serverPath, Util.GetString(st["ForwardBy"]));
                                            sbimg.AppendFormat("<img style='float:left;padding-right:10px;' src='{0}'", imgname);
                                            sbimg.Append(" />");
                                        }
                                    }
                                    foreach (DataRow st in deptapp.Rows)
                                    {

                                        if (isSign(st["SignatureID"].ToString()))
                                        {
                                            string imgname = string.Format("{0}Design/opd/signature/{1}.jpg", serverPath, Util.GetString(st["SignatureID"]));
                                            sbimg.AppendFormat("<img style='float:left;padding-right:10px;' src='{0}'", imgname);
                                            sbimg.Append(" />");
                                        }
                                    }
                                    sbimg.Append("</div>");
                                    sb.Append(sbimg);
                                }
                            }
                        }
                    }
                }
                sb.Append("</td></tr>");
                sb.Append("</table></div>");
                html1LayoutInfo = null;
                AddContent(sb.ToString(), dr, _LastRow);
                if (_LastRow ? false : dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["LabNo"].ToString() != dr["LabNo"].ToString())
                {
                    mergeDocument();
                }
                sb = new StringBuilder();
            }
            //Condition To Print Test Name
            if (dtObs.Rows.Count > 1)
            {
                if ((_FirstRow) ? (dtObs.Rows.Count == 1) : (dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["Test_ID"].ToString() != dr["Test_ID"].ToString()))
                {
                    sb.Append(sbCss.ToString());
                    sb.Append("<div class='divContent'><table class='tbData' >");
                }
            }
            if ((Util.GetString(dr["invHeader"]) == "1") &&
                ((_FirstRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["Test_ID"].ToString() != dr["Test_ID"].ToString())))
            {
                sb.Append("<tr valign='top'>");
                sb.AppendFormat("<th  colSpan='{0}' class='InvName' style='padding-left:5px;'>", dtLabReport.Rows.Count);
                if (Util.GetString(dr["type1"]).Trim() == "PCC" && (Util.GetString(dr["TagProcessingLabID"]).Trim() != Util.GetString(dr["TestCentreID"]).Trim()))
                {
                    sb.Append("*" + dr["TestName"]);
                }
                //if (Util.GetString(dr["type1"]).Trim() != "PCC" && (Util.GetString(dr["centreid"]).Trim() != Util.GetString(dr["TestCentreID"]).Trim()))
                // {
                //     sb.Append("*" + dr["TestName"].ToString());
                // }
                else if (dr["isnabl"].ToString() == "1")
                {
                    sb.Append(dr["TestName"].ToString());
                }
                else if (dr["laboutsrcid"].ToString() != "0")
                {
                    sb.Append(dr["TestName"]);
                }
                else
                {
                    sb.Append(dr["TestName"]);
                }
                if (dr["investigation_id"].ToString() == "1187" || dr["investigation_id"].ToString() == "165")
                    sb.AppendFormat("  , <span style='font-size:13px;font-style:italic;font-weight:normal'>{0}</span>", dr["samplename"]);
                if (dr["method"].ToString() != "")
                {
                    //  sb.Append("<br/><span class='MethodName'>(" + dr["method"].ToString() + ")<span>");
                }
                sb.Append("</th></tr>");
                if (dr["samplename"].ToString() != "" && Util.GetString(dr["ReportType"]) != "3")
                {
                    sb.Append("<tr valign='top' >");
                    sb.AppendFormat("<th  colSpan='{0}' class='InvName' style='padding:5px;'>", dtLabReport.Rows.Count);
                    sb.Append("Sample Type : " + dr["samplename"].ToString());
                    sb.Append("</th></tr>");
                }
            }
            if (dr["investigation_id"].ToString() != "001")//&& dr["investigation_id"].ToString() != "1187"
            {

                if (dr["Value"].ToString() == "HEAD")
                {
                    sb.Append("<tr valign='top'  >");
                    sb.AppendFormat("<th style='border:1px solid gray' class='SubHeader' colspan='{0}'>{1}</th>", dtLabReport.Rows.Count, dr["LabObservationName"]);
                    sb.Append("</tr>");
                }
                else if (dr["isOrganism"].ToString() == "0")
                {
                    if (dr["isborder"].ToString() == "1")
                    {
                        sb.Append("<tr valign='top' style='border-left:1px solid black;border-right:1px solid black;' >");
                    }
                    else
                    {
                        sb.Append("<tr valign='top'  >");
                    }
                    string newTD = "";
                    int colSpan = 1;

                    if (Util.GetString(dr["ReportType"]) == "1")
                    {
                        for (int j = dtLabReport.Rows.Count - 1; j >= 0; j--)
                        {
                            DataRow drc = dtLabReport.Rows[j];
                            if (dr["isborder"].ToString() == "1")
                            {
                                newTD = string.Format("<td style='border:0px;' class='{0}' colSpan='{1}'>{2}</td>{3}", drc["Name"], colSpan, getTags_Flag(dr[drc["Name"].ToString()].ToString(), dr["MinValue"].ToString(), dr["MaxValue"].ToString(), dr["AbnormalValue"].ToString(), drc["Name"].ToString().ToLower(), dr, dr["flag"].ToString()), newTD);
                                colSpan = 1;
                            }
                            else
                            {
                                newTD = string.Format("<td  class='{0}' colSpan='{1}'>{2}</td>{3}", drc["Name"], colSpan, getTags_Flag(dr[drc["Name"].ToString()].ToString(), dr["MinValue"].ToString(), dr["MaxValue"].ToString(), dr["AbnormalValue"].ToString(), drc["Name"].ToString().ToLower(), dr, dr["flag"].ToString()), newTD);
                                colSpan = 1;
                            }
                        }
                        sb.Append(newTD);
                    }
                    else
                    {
                        for (int j = dtLabReport.Rows.Count - 1; j >= 0; j--)
                        {
                            DataRow drc = dtLabReport.Rows[j];
                            if (dr["isborder"].ToString() == "1")
                            {
                                if (dr[drc["Name"].ToString()].ToString() != "")
                                {
                                    newTD = string.Format("<td style='border:0px;text-align:left;padding-left:5px; ! important;' class='{0}' colSpan='{1}'>{2}</td>{3}", drc["Name"], colSpan, getTags_Flag(dr[drc["Name"].ToString()].ToString(), dr["MinValue"].ToString(), dr["MaxValue"].ToString(), dr["AbnormalValue"].ToString(), drc["Name"].ToString().ToLower(), dr, dr["flag"].ToString()), newTD);
                                    colSpan = 1;
                                }
                                else
                                {
                                    colSpan++;
                                }
                            }
                            else
                            {
                                if (dr[drc["Name"].ToString()].ToString() != "")
                                {

                                    newTD = string.Format("<td style='text-align:left ! important;padding-left:5px;'  class='{0}' colSpan='{1}'>{2}</td>{3}", drc["Name"], colSpan, getTags_Flag(dr[drc["Name"].ToString()].ToString(), dr["MinValue"].ToString(), dr["MaxValue"].ToString(), dr["AbnormalValue"].ToString(), drc["Name"].ToString().ToLower(), dr, dr["flag"].ToString()), newTD);
                                    colSpan = 1;
                                }
                                else
                                {
                                    colSpan++;
                                }
                            }
                        }
                        sb.Append(newTD);
                    }
                    sb.Append("</tr>");

// Observation wise interpretetion
                    if ((_LastRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) + 1]["LabObservation_ID"].ToString() != dr["LabObservation_ID"].ToString()))
                    {
                        //if (dtInterpretation.Select(string.Format("Test_ID='{0}' and Type='ObservationWise'", dr["Test_ID"])).Length == 1)
                        //{
                        //    //Observation wise Interpretation
                        //    if (StripHTML(Util.GetString(dtInterpretation.Select(string.Format("Test_ID='{0}' and Type='ObservationWise'", dr["Test_ID"]))[0]["Interpretation"])).Trim() != "")
                        //    {

                        //sb.Append("<tr valign='top'>");
                        //sb.AppendFormat("<td style='padding:8px;' colSpan='{0}'><br/>{1}</td>", dtLabReport.Rows.Count, dtInterpretation.Select(string.Format("Test_ID='{0}' and Type='ObservationWise'", dr["Test_ID"]))[0]["Interpretation"]);
                        //sb.Append("</tr>");
                        //    }
                        //}
                        string Interpretation = StockReports.ExecuteScalar("SELECT Interpretation FROM labobservation_master_Interpretation WHERE LabObservation_ID='" + dr["LabObservation_ID"] + "' and centreid='" + dr["TestCentreID"] + "' AND isactive=1 ");

                        if (StripHTML(Util.GetString(Interpretation)).Trim() != "")
                        {
                            sb.Append("<tr valign='top'>");
                            sb.Append("<td style='padding:8px;' colSpan='" + dtLabReport.Rows.Count + "'>" + Interpretation + "</td>");
                            sb.Append("</tr>");
                        }

                    }
                    if (StripHTML(Util.GetString(dr["Description"])).Trim() != "")
                    {
                        sb.Append("<tr valign='top'>");
                        sb.AppendFormat("<td   colSpan='{0}'>{1}</td>", dtLabReport.Rows.Count, dr["Description"]);
                        sb.Append("</tr>");
                    }
                    // Page Break After 
                }
            }
            // Adding Comments
            if ((_LastRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) + 1]["Test_ID"].ToString() != dr["Test_ID"].ToString())
                &&
                (StripHTML(Util.GetString(dr["Comments"])).Trim() != "")
                )
            {
                if (Util.GetString(dr["Comments"]) != "")
                {
                    sb.Append("<tr valign='top'>");
                    sb.AppendFormat("<td style='padding:8px;' colSpan='{0}'>{1}</td>", dtLabReport.Rows.Count, dr["Comments"]);
                    sb.Append("</tr>");
                }
            }
            // Adding Interpretaion
            if ((_LastRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) + 1]["Test_ID"].ToString() != dr["Test_ID"].ToString())
                //&&
                //(StripHTML(Util.GetString(dr["Interpretation"])).Trim() != "")
                )
            {
                if (dr["InterpretationID"].ToString() != "0" && dr["InterpretationType"].ToString() == "InvestigationWise")
                {
                    string Interpretation = StockReports.ExecuteScalar("SELECT Interpretation FROM investigation_master_Interpretation WHERE id=" + dr["InterpretationID"].ToString() + "  ");

                    if (StripHTML(Util.GetString(Interpretation)).Trim() != "")
                    {
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td style='padding:8px;' colSpan='" + dtLabReport.Rows.Count + "'>" + Interpretation + "</td>");
                        sb.Append("</tr>");
                    }
                }
                else if (dr["InterpretationID"].ToString() == "0")
                {
                    string Interpretation = StockReports.ExecuteScalar("SELECT Interpretation FROM investigation_master_Interpretation WHERE investigation_id=" + dr["investigation_id"].ToString() + "  AND centreid=1 AND macid=1 AND isactive=1 Limit 1 ");

                    if (StripHTML(Util.GetString(Interpretation)).Trim() != "")
                    {
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td style='padding:8px;' colSpan='" + dtLabReport.Rows.Count + "'>" + Interpretation + "</td>");
                        sb.Append("</tr>");
                    }
                }
            }
            if ((_LastRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) + 1]["Test_ID"].ToString() != dr["Test_ID"].ToString()))
            {
                if (barcodeno.Contains(dr["barcodeno"].ToString()))
                {

                }
                else
                {
                    barcodeno += dr["barcodeno"] + ",";
                }
                //barcodeno += dr["barcodeno"].ToString() + ",";
            }
            //adding patient sample comment          
            if ((_LastRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) + 1]["Test_ID"].ToString() != dr["Test_ID"].ToString())
                &&
                (StripHTML(Util.GetString(dr["IsSampleCollectedByPatient"])).Trim() == "1")
                )
            {
                // sb.AppendFormat("<tr><td class='Department'  colSpan='{0}' style='border-top:1px solid black;border-left:0px;border-right:0px;border-bottom:0px;text-align:left;'>****Sample Collected By Patient Itself</td></tr>", dtLabReport.Rows.Count);
            }

            //Attachments 05.06.17 shat
            if ((_LastRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) + 1]["Test_ID"].ToString() != dr["Test_ID"].ToString()))
            {

                if (_MacImage.Select(string.Format("Test_ID='{0}'", dr["Test_ID"])).Length > 0)
                {
                    DataRow[] drAllMacImage = _MacImage.Select(string.Format("Test_ID='{0}'", dr["Test_ID"]));
                    foreach (DataRow drMacImage in drAllMacImage)
                    {
                        string _img = Util.GetString(drMacImage["Base64Image"]);
                        sb.Append("<tr valign='top'>");
                        sb.AppendFormat("<td colSpan='{0}' style='padding:5px;page-break-before :always;vertical-align:top;  '> ", dtLabReport.Rows.Count);
                        sb.AppendFormat("<img src='data:image/jpeg;base64,{0}' style='width:650px;height:600px;' /></td>", _img);
                        sb.Append("</tr>");
                    }
                }
                if (_Attachments.Rows.Count > 0)
                {
                    if (_Attachments.Select(string.Format("Test_ID='{0}' and AttachedFile like '%.jpg'", dr["Test_ID"])).Length > 0)
                    {
                        string _img = string.Format("{0}/uploaded document/{1}", Resources.Resource.DocumentPath, _Attachments.Select(string.Format("Test_ID='{0}' and AttachedFile like '%.jpg'", dr["Test_ID"]))[0]["fileurl"]);
                        string base64String = "";
                        using (Image image = Image.FromFile(_img))
                        {
                            using (MemoryStream m = new MemoryStream())
                            {
                                image.Save(m, image.RawFormat);
                                byte[] imageBytes = m.ToArray();

                                // Convert byte[] to Base64 String
                                base64String = Convert.ToBase64String(imageBytes);

                            }
                        }
                        // sb.Append("<tr valign='top'>");
                        // sb.AppendFormat("<td colSpan='{0}' style='padding:5px;page-break-before :always;vertical-align:top; '><img src='{1}' style='max-width:700px;' /></td>", dtLabReport.Rows.Count, _img);
                        // sb.Append("</tr>");
                        sb.Append("<tr valign='top'>");
                        sb.AppendFormat("<td colSpan='{0}' style='padding:5px;page-break-before :always;vertical-align:top;  '> ", dtLabReport.Rows.Count);
                        sb.AppendFormat("<img src='data:image/jpeg;base64,{0}' style='width:780px;height:600px;' /></td>", base64String);
                        sb.Append("</tr>");
                    }

                    if (Util.GetString(Request.QueryString["email"]) != "1" && Util.GetString(dr["Investigation_ID"]) != "1014" && Util.GetString(dr["Investigation_ID"]) != "1013" && Util.GetString(dr["Investigation_ID"]) != "1016" && Util.GetString(dr["Investigation_ID"]) != "924" && Util.GetString(dr["Investigation_ID"]) != "936" && Util.GetString(dr["Investigation_ID"]) != "933" && Util.GetString(dr["Investigation_ID"]) != "1012" && Util.GetString(dr["Investigation_ID"]) != "1015")
                    {
                        if (_Attachments.Select(string.Format("Test_ID='{0}' and AttachedFile like '%.pdf'", dr["Test_ID"])).Length > 0)
                        {

                            string _pdf = string.Format(string.Concat("http://localhost", Resources.Resource.ApplicationName, "/Design/uploaded document/{0}"), _Attachments.Select(string.Format("Test_ID='{0}' and AttachedFile like '%.pdf'", dr["Test_ID"]))[0]["fileurl"]);
                            sb.Append("<tr valign='top'>");
                            sb.AppendFormat("<a href=\"{0}\">PDF Attached</a>", _pdf);
                            sb.Append("</tr>");
                        }
                    }
                }
            }
            drcurrent = dtObs.Rows[dtObs.Rows.IndexOf(dr)];
            _FirstRow = false;
        }
        if (dtObs.Rows.Count > 0)
        {
            if (!printEndOfReportAtFooter)
            {
                if ((dtObs.Rows.IndexOf(drcurrent) < dtObs.Rows.Count - 1 ? dtObs.Rows[dtObs.Rows.IndexOf(drcurrent) + 1]["LabNo"].ToString() != drcurrent["LabNo"].ToString() : false)
                  ||
                      dtObs.Rows.IndexOf(drcurrent) == dtObs.Rows.Count - 1)
                {
                    sb.AppendFormat("<tr><td class='Department'  colSpan='{0}' style='border:0px;'>&nbsp;</td></tr>", dtLabReport.Rows.Count);
                    sb.AppendFormat("<tr><td class='Department'  colSpan='{0}' style='border-top:1px solid black;border-left:0px;border-right:0px;border-bottom:0px;text-align:center;'>*** End Of Report ***</td></tr>", dtLabReport.Rows.Count);
                    sb.AppendFormat("<tr><td style='border:0px;' colSpan='{0}'>", dtLabReport.Rows.Count);
                   
                    if (drcurrent["ShowSignature"].ToString() != "0") 
                    {
                    if (signatureonend == true)
                    {
                        DataRow[] list = dtObs.Select(string.Format("LabNo ='{0}' and Approved=1", drcurrent["LabNo"]));
                        if (list.Length > 0)
                        {
                            DataTable dataTable = list.CopyToDataTable();
                            DataView dv = dataTable.DefaultView.ToTable(true, "SignatureID").DefaultView;
                            dv.Sort = "SignatureID asc";
                            DataTable deptapp = dv.ToTable();
                            DataView dv1 = dataTable.DefaultView.ToTable(true, "ForwardBy").DefaultView;
                            dv1.Sort = "ForwardBy asc";
                            DataTable deptapp1 = dv1.ToTable();
                            StringBuilder sbimg = new StringBuilder();
                            sbimg.Append("<div style='width:800px;page-break-inside:avoid;'>");
                            foreach (DataRow st in deptapp1.Rows)
                            {
                                if (isSign(st["ForwardBy"].ToString()))
                                {
                                    string imgname = string.Format("{0}Design/opd/signature/{1}.jpg", serverPath, Util.GetString(st["ForwardBy"]));
                                    sbimg.AppendFormat("<img style='float:left;padding-right:10px;' src='{0}'", imgname);
                                    sbimg.Append(" />");
                                }
                            }
                            foreach (DataRow st in deptapp.Rows)
                            {
                                if (isSign(st["SignatureID"].ToString()))
                                {
                                    // string imgname = "" + Util.GetString(st["ApprovedBy"]) + ".jpg";
                                    string imgname = string.Format("{0}Design/opd/signature/{1}.jpg", serverPath, Util.GetString(st["SignatureID"]));
                                    sbimg.AppendFormat("<img style='float:left;padding-right:10px;' src='{0}'", imgname);
                                    sbimg.Append(" />");
                                }
                            }
                            sbimg.Append("</div>");
                            sb.Append(sbimg);
                        }
                    }
                  }
                }
            }
            sb.Append("</td></tr>");
            sb.Append("</table></div>");
            html1LayoutInfo = null;
            StringBuilder sbimg12 = new StringBuilder();
            sbimg12.Append("<div style='padding-left:-100;'>");
            sbimg12.Append("<table style='width:100%'>");
            if (drcurrent["ShowSignature"].ToString() != "0")
            {
                if (!signatureonend)
                {
                    sbimg12.Append("<tr ><td >");
                    if (isSign(drcurrent["ApprovedBy"].ToString()))
                    {
                        string imgname = string.Format("{0}Design/opd/signature/{1}.jpg", serverPath, Util.GetString(drcurrent["ApprovedBy"]));
                        sbimg12.AppendFormat("<img style='' src='{0}'", imgname);
                        sbimg12.Append(" />");
                    }
                    sbimg12.Append("</tr></td>");
                }
            }

            sbimg12.Append("</table>");
            sbimg12.Append("</div>");
            sb.Append(sbimg12);


        }
        //  if (UserInfo.ID == 1) System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\lab3.txt", sb.ToString());
        if (dtObs.Rows.Count > 0)
        {
            AddContent(sb.ToString(), drcurrent, _LastRow);
        }
        mergeDocument();
        //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\lab3.txt", sb.ToString());
        foreach (DataRow drAtt in dtAttachment.Rows)
        {
            string _pdf = "";
            if (drAtt["FileUrl"].ToString().ToUpper().EndsWith(".PDF"))
            {
                //  _pdf = Server.MapPath("~/Uploaded Report/") + drAtt["FileUrl"];
                _pdf = string.Concat(Resources.Resource.DocumentPath, "\\Uploaded Report") + "\\" + drAtt["FileUrl"];
                if (File.Exists(_pdf))
                {
                    //    System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\po1.txt", _pdf);
                    try
                    {
                        PdfDocument document1 = PdfDocument.FromFile(_pdf);
                        document.AddDocument(document1);
                    }
                    catch (Exception ex)
                    {
                        ClassLog cl = new ClassLog();
                        cl.errLog(ex);
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", string.Format("window.open('{0}');", _pdf), true);
                    }
                }
            }
        }
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            //micro report
            string[] tags = TestID.Replace("'", "").Split(',');
            string[] paramNames = tags.Select(
              (s, i) => "@tag" + i).ToArray();
            string inClause = string.Join(", ", paramNames);
            int isculture = 0;
            int isRadiology = 0;
            //radiology report

            using (MySqlCommand cmd = new MySqlCommand(string.Format("SELECT count(1) from patient_labinvestigation_opd where Test_ID in({0}) and ReportType=5", inClause), con))
            {
                for (int i = 0; i < paramNames.Length; i++)
                {
                    cmd.Parameters.AddWithValue(paramNames[i], tags[i]);
                }
                isRadiology = Util.GetInt(cmd.ExecuteScalar());

            }
            if (isRadiology > 0 && dtObs.Rows.Count > 0)
            {
                string url = string.Format("{0}://{1}/{2}/Design/Lab/labreportnewradio.aspx{3}", Request.Url.Scheme, "localhost", Request.Url.AbsolutePath.Split('/')[1], Request.Url.Query);
                //if (UserInfo.ID == 1) System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\ioiu.txt", url);
                try
                {
                    Stream stream = ConvertToStream(url);
                    PdfDocument pdfradio = PdfDocument.FromStream(stream);
                    document.AddDocument(pdfradio);
                }
                catch (Exception ex)
                {
                    ClassLog cl = new ClassLog();
                    cl.errLog(ex);
                }
            }
            //micro report
            using (MySqlCommand cmd = new MySqlCommand(string.Format("SELECT count(1) from patient_labobservation_opd_mic where TestID in({0})", inClause), con))
            {
                for (int i = 0; i < paramNames.Length; i++)
                {
                    cmd.Parameters.AddWithValue(paramNames[i], tags[i]);
                }
                isculture = Util.GetInt(cmd.ExecuteScalar());
            }
            if (isculture > 0)
            {
                string url = string.Format("{0}://{1}:{2}/{3}/Design/Lab/labreportmicro.aspx{4}", Request.Url.Scheme, Request.Url.Host, Request.Url.Port, Request.Url.AbsolutePath.Split('/')[1], Request.Url.Query);
                Stream stream = ConvertToStream(url);
                PdfDocument pdfculture = PdfDocument.FromStream(stream);
                document.AddDocument(pdfculture);
            }
            // histo report

            int ishisto = 0;
            using (MySqlCommand cmd = new MySqlCommand(string.Format("SELECT count(1) from patient_labobservation_histo where Test_ID in({0})", inClause), con))
            {
                for (int i = 0; i < paramNames.Length; i++)
                {
                    cmd.Parameters.AddWithValue(paramNames[i], tags[i]);
                }
                ishisto = Util.GetInt(cmd.ExecuteScalar());

            }
            if (ishisto > 0)
            {
                string url = string.Format("{0}://{1}:{2}/{3}/Design/Lab/labreportnewhisto.aspx{4}", Request.Url.Scheme, "localhost", Request.Url.Port, Request.Url.AbsolutePath.Split('/')[1], Request.Url.Query);
                //	System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\ioiu.txt",url);
                Stream stream = ConvertToStream(url);
                PdfDocument pdfhisto = PdfDocument.FromStream(stream);
                document.AddDocument(pdfhisto);
            }
            //Show Delta Report
            DataRow[] rowsArray = dtObs.Select("ShowDeltaReport=1");

            if (rowsArray.Length > 0)
            {
                DataTable DataObsNew = rowsArray.CopyToDataTable();

                if (DataObsNew.Rows.Count > 0)
                {

                    List<string> labobs_id = new List<string>();
                    labobs_id = DataObsNew.AsEnumerable().Select(x => x["LabObservation_ID"].ToString()).ToList();

                    //string labobsid = string.Join(",", DataObsNew.Rows.OfType<DataRow>().Select(r => r["LabObservation_ID"].ToString()));
                    //labobsid = string.Format("'{0}'", labobsid);
                    //labobsid = labobsid.Replace(",", "','");
                    sb = new StringBuilder();
                    sb.Append("");
                    sb.Append(" SELECT labobservationname, DATE_FORMAT(`ResultDateTime`,'%d-%b-%y %h:%i:%s') ResultdDate,VALUE,lt.pname,lt.LedgerTransactionno,lt.patient_id,lt.Age, ");
                    sb.Append(" lt.gender  FROM patient_labobservation_opd plo ");
                    sb.Append(" INNER JOIN `patient_labinvestigation_opd` pli ON pli.test_id=plo.test_id AND `IsNumeric`(VALUE)=1 ");
                    sb.Append(" and pli.investigation_ID in (select investigation_id from patient_labinvestigation_opd where test_id IN({0})) ");
                    sb.Append(" INNER JOIN `f_ledgertransaction` lt ON lt.LedgerTransactionID=pli.LedgerTransactionID ");
                    sb.Append(" WHERE lt.patient_id =(SELECT patient_id FROM patient_labinvestigation_opd WHERE test_id IN({0}) LIMIT 1) ");
                    sb.Append(" and LabObservation_ID IN ({1})");
                    sb.Append(" ORDER BY labobservationName,plo.ResultDateTime ASC ");

                    using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", Test_ID), string.Join(",", labobs_id)), con))
                    {
                        for (int i = 0; i < Test_ID.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                        }
                        for (int i = 0; i < labobs_id.Count; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(string.Concat("@labobs_idParam", i), labobs_id[i]);
                        }

                        DataTable dt = new DataTable();
                        using (dt as IDisposable)
                        {
                            da.Fill(dt);
                            if (dt.Rows.Count > 0)
                            {
                                //ReportDocument rpt = new ReportDocument();
                                DataSet ds = new DataSet();
                                ds.Tables.Add(dt.Copy());
                                dt.TableName = "DeltaData";
                                //ds.WriteXmlSchema("d:/DeltaData.xml");
                                //rpt.Load(Server.MapPath(@"~\Reports\DeltaCheckGraph.rpt"));
                               // rpt.SetDataSource(ds);
                                //System.IO.Stream oStream = rpt.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                               // byte[] byteArray = null;
                                //byteArray = new byte[oStream.Length];
                                // oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
                                // PdfDocument pdfhisto = PdfDocument.FromStream(oStream);
                                // document.AddDocument(pdfhisto);
                            }
                        }
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
        try
        {
            // write the PDF document to a memory buffer
            byte[] pdfBuffer = document.WriteToMemory();
            // inform the browser about the binary data format

            if (app == "1")
            {
                HttpContext.Current.Response.AddHeader("Content-Disposition", String.Format("attachment; filename=PdfText.pdf; size={0}", pdfBuffer.Length));
            }
            else if (Util.GetString(Request.QueryString["GetReportBase64"]) == "1")
            {
                try
                {
                    string FileName = string.Format("{0}_{1}.pdf", dtObs.Rows[0]["pname"], Util.GetString(Request.QueryString["LabNo"]));
                    string FilePath = string.Format(@"{0}LabReports\{1}\{2}\{3}\", Util.getApp("LabReportPath"), DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
                    Directory.CreateDirectory(FilePath);
                    if (!File.Exists(FilePath + FileName))
                        File.WriteAllBytes(FilePath + FileName, pdfBuffer);
                }
                catch { }
            }
            else
            {
                //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\po2.txt", "3");
                HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
            }
            // write the PDF buffer to HTTP response
            HttpContext.Current.Response.BinaryWrite(pdfBuffer);
            // call End() method of HTTP response to stop ASP.NET page processing
            HttpContext.Current.Response.End();
            //            PdfAction jAction = PdfAction.JavaScript("this.print(true);\r", writer);
            //writer.AddJavaScript(jAction);
        }
        finally
        {
            document.Close();
        }
    }
    string romanno(int digit)
    {
        string roman = "";
        switch (digit)
        {
            case 1:
                roman = "I";
                break;
            case 2:
                roman = "II";
                break;
            case 3:
                roman = "III";
                break;
            case 4:
                roman = "IV";
                break;
            case 5:
                roman = "V";
                break;
        }
        return roman;

    }
    public string getchar(int asccivalue)
    {

        char character = (char)asccivalue;
        return character.ToString();
    }
    private static Stream ConvertToStream(string fileUrl)
    {
        HttpWebRequest request = (HttpWebRequest)WebRequest.Create(fileUrl);
        HttpWebResponse response = (HttpWebResponse)request.GetResponse();
        try
        {
            MemoryStream mem = new MemoryStream();
            Stream stream = response.GetResponseStream();
            stream.CopyTo(mem, 4096);
            return mem;
        }
        finally
        {
            response.Close();
        }
    }

    private void mergeDocument()
    {
        // add page numbering in a text element

        //document = new PdfDocument();

        try
        {
            FooterHeight = Util.GetInt(drcurrent["ReportFooterHeight"].ToString());
        }
        catch
        {
        }
        int pageno = 1;
        //System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\lko.txt", tempDocument.Pages.Count.ToString());
        foreach (PdfPage p in tempDocument.Pages)
        {
            Font pageNumberingFont = new Font(new FontFamily("Times New Roman"), 8, GraphicsUnit.Point);
            PdfText pageNumberingText = new PdfText(PageWidth + 12, FooterHeight, String.Format("Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = Color.Black;
            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight + 60);
            }
            p.Footer.Layout(pageNumberingText);

            PdfText reportline1 = new PdfText(PageWidth - 450, FooterHeight + 25, Util.GetString(drcurrent["ReportLine1"]), pageNumberingFont);
            p.Footer.Layout(reportline1);

            PdfText reportline2 = new PdfText(PageWidth - 450, FooterHeight + 40, Util.GetString(drcurrent["ReportLine2"]), pageNumberingFont);
            p.Footer.Layout(reportline2);

            PdfText reportline3 = new PdfText(PageWidth - 450, FooterHeight + 40, Util.GetString(drcurrent["TCentreAdd"]), pageNumberingFont);
            p.Footer.Layout(reportline3);

            document.Pages.AddPage(p);
            pageno++;
        }

        //Attachments 05.06.17 shat
        if (Util.GetString(Request.QueryString["email"]) != "1")
        {
            foreach (DataRow dr in _Attachments.Rows)
            {
                string _pdf = "";
                if (dr["FileUrl"].ToString().EndsWith(".pdf") && (dr["LedgerTransactionNo"].ToString() == drcurrent["LabNo"].ToString()))
                {
                    _pdf = Server.MapPath("~/Uploaded Document/") + dr["FileUrl"].ToString();
                    if (File.Exists(_pdf))
                    {
                        try
                        {
                            PdfDocument document1 = PdfDocument.FromFile(_pdf);
                            document.AddDocument(document1);
                        }
                        catch (Exception ex)
                        {
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", string.Format("window.open('{0}');", _pdf), true);

                        }
                        //document.Pages.AddPage(); 
                    }
                }
            }
        }
        tempDocument = new PdfDocument();
    }
    public string MakeHeader(string Header, DataRow dr_Detail)
    {
        if (dtReportHeader.Select(string.Format("PanelId='{0}'", dr_Detail["Panel_id"])).Length > 0)
            Header = dtReportHeader.Select(string.Format("PanelId='{0}'", dr_Detail["Panel_id"]))[0]["ReportHeader"].ToString();
        else
            Header = dtReportHeader.Select("PanelId='78'")[0]["ReportHeader"].ToString();

        if (Util.GetString(drcurrent["PatientType"]).ToLower() == "hlm")
        {
            // string SponsorNameFull = Util.GetString(drcurrent["OtherReferLab"]);
            // string SponsorNameFirstPart = string.Empty;
            // string SponsorNameSecordPart = string.Empty;
            // if (SponsorNameFull.Trim() != "")
            // {
            //     if (SponsorNameFull.Length <= 31)
            //     {
            //         SponsorNameFirstPart = SponsorNameFull;
            //     }
            //     else
            //     {
            //         SponsorNameFirstPart = SponsorNameFull.Substring(0, 31);
            //         SponsorNameSecordPart = SponsorNameFull.Substring(31);
            //     }
            //    Header = Header.Replace("Client Name", "Sponsor Name").Replace("{Company_Name}", SponsorNameFirstPart).Replace("Client Code", "&nbsp;").Replace(": {Panel_Code}", "&nbsp;" + SponsorNameSecordPart);
            // }
            // else
            // {
            //    Header = Header.Replace("Client Name", "&nbsp;").Replace(": {Company_Name}", "&nbsp;").Replace("Client Code", "&nbsp;").Replace(": {Panel_Code}", "&nbsp;");
            //  }

            if (Util.GetString(drcurrent["CorporateIDCard"]).Trim() != "")
            {
                Header = Header.Replace("IP/OP NO", "Emp/Auth/TPA ID").Replace("{HLMOPDIPDNo}", Util.GetString(drcurrent["CorporateIDCard"]).Trim());
            }
            //Header = Header.Replace("IP/OP NO", "&nbsp;").Replace(": {HLMOPDIPDNo}", "&nbsp;");
            Header = Header.Replace("{HLMOPDIPDNo}", Util.GetString(drcurrent["HLMOPDIPDNo"]).Trim());
        }
        for (int i = 0; i < dtObs.Columns.Count; i++)
        {
            Header = Header.Replace(string.Format("{{{0}}}", dtObs.Columns[i].ColumnName), dr_Detail[i].ToString());
        }
        if (Util.GetString(drcurrent["OtherReferLab"]) != "")
            Header = Header.Replace("CLIENT NAME", "REFERRED BY");
        StringBuilder sb = new StringBuilder();
        sb.Append(sbCss.ToString());
        sb.Append("<div class='divContent' ><table class='tbData'>");
        if (dtObs.Select(string.Format("Test_ID='{0}' and isOrganism=1", drcurrent["Test_ID"])).Length == 0)
        {

            sb.AppendFormat("<tr valign='top' ><th style='border:0px !important;'  colspan='{0}'  ></th></tr>", dtLabReport.Rows.Count);
            sb.AppendFormat("<tr valign='top' ><th class='Department'   colspan='{0}'  >DEPARTMENT OF {1}</th></tr>", dtLabReport.Rows.Count, drcurrent["Dept"]);
            
           
             
            if (drcurrent["ispackage"].ToString() == "1" && Util.GetString(StockReports.ExecuteScalar("SELECT  itm.ShowInReport FROM f_itemmaster itm  WHERE    itm.`ItemID`=" + drcurrent["ItemId"].ToString() + " "))== "1")
            {
                sb.Append("<tr  valign='top'>");
                sb.AppendFormat("<th class='Department'   colspan='{0}'>{1}</th>", dtLabReport.Rows.Count, drcurrent["packagename"]);
                sb.Append("</tr>");
            }
            if (Util.GetString(drcurrent["ReportType"]) == "1" && Util.GetString(drcurrent["investigation_id"]) != "183")
            {
                sb.Append("<tr  valign='bottom'>");
                foreach (DataRow drc in dtLabReport.Rows)
                {
                    sb.AppendFormat("<th  style='text-align:center!important;'   class='{0}'>{1}</th>", drc["Name"], drc["Label"]);
                }
                sb.Append("</tr>");
            }
        }
        sb.Append("</table></div>");
        return string.Format("{0}{1}", Header, sb);
    }
    public string tempTest_ID = string.Empty;
    public string getTags_Flag(string Value, string MinRange, string MaxRange, string AbnormalValue, string labelname, DataRow drme, string flag1)
    {
        if (labelname == "labobservationname" && Util.GetString(drme["invHeader"]).Trim() == "0")
        {
            try
            {
                if (tempTest_ID != Util.GetString(drme[1]).Trim())
                {
                    tempTest_ID = Util.GetString(drme[1]).Trim();
                    string strTemp = string.Empty;
                    if (Util.GetString(drme["type1"]).Trim() == "PCC" && (Util.GetString(drme["TagProcessingLabID"]).Trim() != Util.GetString(drme["TestCentreID"]).Trim()))
                    {
                        strTemp = "*";
                    }
                    else if (Util.GetString(drme["type1"]).Trim() != "PCC" && (Util.GetString(drme["centreid"]).Trim() != Util.GetString(drme["TestCentreID"]).Trim()))
                    {
                        strTemp = "*";
                    }
                    System.Text.RegularExpressions.Match m = System.Text.RegularExpressions.Regex.Match(Value, "<div[^>]*.*?>(.*?)</div>");
                    Value = m.Groups[0].ToString().Replace(m.Groups[1].ToString(), strTemp + m.Groups[1]);
                }
            }
            catch
            {
            }
        }
        if (labelname != "value")
            return Value;
        string ret_value = Value;
        string uploadedimgpath = string.Format("{0}://{1}:{2}/{3}/", Request.Url.Scheme, Request.Url.Host, Request.Url.Port, Request.Url.AbsolutePath.Split('/')[1]);
        Value = Value.Replace("../../", uploadedimgpath);
        if (ret_value != Value)
            return Value;
        try
        {
            int IsBold = Util.GetInt(StockReports.ExecuteScalar("SELECT lhm.IsBold FROM `labobservation_help` lh Inner JOIN labobservation_help_master lhm ON lh.`HelpId`=lhm.`id` AND helpid =(SELECT id FROM labobservation_help_master WHERE HELP='" + Util.GetString(drme["value"]) + "' Limit 1) WHERE labobservation_id='" + Util.GetString(drme["labobservation_id"]) + "' "));
            if (IsBold == 1)
            {
                ret_value = string.Format("<span style='color:black;font-weight:bold;'><strong>{0}<strong></span>", ret_value);//   ret_value = "<b>" + ret_value + "</b>";
            }
            else
            {
            if (ret_value == "")
                ret_value = "";
          //  if ((MinRange == "") && (MaxRange == ""))
            if (Util.GetString(drme["ReportType"]) == "1" && (Value == "DETECTED" || Value == "DETECTED (+)" || Value == "DETECTED (++)" || Value == "DETECTED (+++)" || Value == "REACTIVE" || Value == "POSITIVE" || Value.ToUpper() == "TRACE" || Value.ToUpper() == "HIGH" || Value == "DETECTED (++++)" || Value.Contains(">") || Value.Contains("<")))
					ret_value = string.Format("<span style='font-size: 17px;'><strong>{0}<strong></span>", Value);//   ret_value = "<b>" + ret_value + "</b>";
            //   else
		//	   ret_value = Value;
			
            else
            {
                if ((MinRange != "") && (Util.GetFloat(Value) < Util.GetFloat(MinRange)))
                    ret_value = string.Format("<span style='color:red;font-size: 17px;'><strong>{0}<strong></span>", ret_value); // ret_value = "<b>"+ ret_value + "</b>";
                else if ((MaxRange != "") && (Util.GetFloat(Value) > Util.GetFloat(MaxRange)))
                    ret_value = string.Format("<span style='color:red;font-size: 17px;'><strong>{0}<strong></span>", ret_value);// ret_value = "<b>" + ret_value + "</b>";
            }
            if (AbnormalValue != "" && AbnormalValue == Value)
                ret_value = string.Format("<span style='color:red;font-size: 17px;'><strong>{0}<strong></span>", ret_value);//   ret_value = "<b>" + ret_value + "</b>";
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }

        StringBuilder sb = new StringBuilder();
        if (labelname == "labobservationname")
        {
            if (Util.GetString(drme["MethodName"]).Trim() != "")
            {
                if (Util.GetString(drme["invHeader"]) == "1")
                {
                    // sb.Append("<span style='font-family:Times New Roman;padding-left:11px; font-size:13px;'colSpan='" + dtLabReport.Rows.Count + "'>" + drme["MethodName"].ToString() + "</span>");
                }
                else
                {
                    // sb.Append("<span class='MethodName'>" + drme["MethodName"].ToString() + "</span>");
                }
            }
            return string.Format("{0}{1}", ret_value, sb);
        }
        else
        {
            return "" + ret_value;
        }
    }
    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        if (dtObs.Rows.Count > 0)
        {
            FooterHeight = Util.GetInt(drcurrent["ReportFooterHeight"].ToString());
            PdfPage page1 = eventParams.PdfPage;
            if (HeaderImage == true)
            {
                HeaderImg = "App_Images/ReportBackGround/" + Util.GetString(drcurrent["ReportBackGroundImage"].ToString());
                page1.Layout(getPDFImage(0, 0, HeaderImg));
            }
            if (Util.GetString(drcurrent["ReportStatus"].ToString()) == "Provisional Report")
            {
                Font sysFontBold = new Font("Arial", 60, FontStyle.Regular, GraphicsUnit.Point);
                PdfText titleRotatedText = new PdfText(50, 550, "Provisional Report", sysFontBold) { ForeColor = Color.LightGray, RotationAngle = 45 };
                page1.Layout(titleRotatedText);
            }
            if (Util.GetString(drcurrent["ReportStatus"].ToString()) == "Final Report")
            {
                if (DummyWater == "1")
                {
                    Font sysFontBold = new Font("Arial", 60, FontStyle.Regular, GraphicsUnit.Point);
                    PdfText titleRotatedText = new PdfText(50, 550, "Dummy Report", sysFontBold) { ForeColor = Color.LightGray, RotationAngle = 45 };
                    page1.Layout(titleRotatedText);
                }
            }
            SetHeader(page1);
            SetFooter(page1);
        }

    }
    private void AddContent(string Content, DataRow dr, bool rowin)
    {
        PdfPage page1 = tempDocument.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty);
        PdfHtml html1 = new PdfHtml();
        rowin = dtObs.Rows.IndexOf(drcurrent) == dtObs.Rows.Count - 1;
        html1 = new PdfHtml(MarginLeft, ((html1LayoutInfo == null) ? 0 : html1LayoutInfo.LastPageRectangle.Height), PageWidth, Content, null);
        html1.PageCreatingEvent += new PdfPageCreatingDelegate(htmlToPdfConverter_PageCreatingEvent);
        html1.FontEmbedding = false;
        html1.BrowserWidth = BrowserWidth;
        html1.ImagesCutAllowed = false;
        html1LayoutInfo = page1.Layout(html1);
        if (showItdose)
        {
            Font sysFontBold = new Font("Arial", 6, FontStyle.Regular, GraphicsUnit.Point);
            PdfText titleRotatedText = new PdfText(2, -20, "Powered By ITDOSE INFOSYSTEMS PVT. LTD.", sysFontBold) { ForeColor = Color.Gray, RotationAngle = 90 };
            page1.Layout(titleRotatedText);
        }
    }
    private void SetHeader(PdfPage page)
    {
        // create the document header
        HeaderHeight = Util.GetFloat(drcurrent["ReportHeaderHeight"].ToString());
        XHeader = Util.GetInt(drcurrent["ReportHeaderXPosition"].ToString());
        YHeader = Util.GetInt(drcurrent["ReportHeaderYPosition"].ToString());
        if (drcurrent["ispackage"].ToString() == "1")
        {
            HeaderHeight = Util.GetFloat(drcurrent["ReportHeaderHeight"].ToString())+40;
        }
        else
        {
            HeaderHeight = Util.GetFloat(drcurrent["ReportHeaderHeight"].ToString());
        }
        if (drcurrent["ReportType"].ToString() != "1")
        {
            HeaderHeight = HeaderHeight - 20;
        }
        if (drcurrent["investigation_id"].ToString() == "183")
        {

            HeaderHeight = HeaderHeight - 20;
        }
        page.CreateHeaderCanvas(HeaderHeight);
        // layout HTML in header
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakeHeader("", drcurrent), null) { FitDestWidth = true, FontEmbedding = false, BrowserWidth = HeaderBrowserWidth };
        
            if (drcurrent["isnabl"].ToString().Trim() == "1" || drcurrent["isnabl"].ToString().Trim() == "5")
            {
                // To Set NABL Logo And Its Position
                if (Util.GetString(drcurrent["NablLogoPath"]).Trim() != "")
                    page.Header.Layout(getPDFImagewithresize1(270, 10, 45, "App_Images" + drcurrent["NablLogoPath"].ToString().Trim()));
            }
            if (drcurrent["isnabl"].ToString().Trim() == "2" || drcurrent["isnabl"].ToString().Trim() == "5")
            {
                // To Set Cap Logo And Its Position
                if (Util.GetString(drcurrent["CapLogoPath"]).Trim() != "")
                    page.Header.Layout(getPDFImagewithresize(350, 10, "App_Images" + drcurrent["CapLogoPath"].ToString().Trim()));
            }
            if (drcurrent["isnabl"].ToString().Trim() == "3")
            {
                // To Set Cap Logo And Its Position
                if (Util.GetString(drcurrent["NabhLogoPath"]).Trim() != "")
                    page.Header.Layout(getPDFImagewithresize(350, 10, "App_Images" + drcurrent["NabhLogoPath"].ToString().Trim()));
            }
        

        page.Header.Layout(headerHtml);
        int X = 25;
        int Y = YHeader - 5;
        //PdfHtml headerHtmlSRF = new PdfHtml(X, Y, PageWidth, "SRF ID: " + drcurrent["SRFNo"].ToString(), null) { FitDestWidth = true, FontEmbedding = false, BrowserWidth = HeaderBrowserWidth };
        Font errFont = new Font("Cambria", 10, FontStyle.Regular, GraphicsUnit.Point);
        PdfText headerHtmlSRF = new PdfText(X, Y, "SRF ID: " + drcurrent["SRFNo"].ToString(), errFont);
        if (drcurrent["SRFNo"].ToString() != "" && drcurrent["SRFNo"].ToString() != "N/A")
        {
            page.Header.Layout(headerHtmlSRF);
            X += 120;
        }
        PdfText Passport = new PdfText(X, Y, "Passport No: " + drcurrent["PassPortNo"].ToString(), errFont);
        if (drcurrent["PassPortNo"].ToString() != "")
        {
            page.Header.Layout(Passport);
            X += 140;
        }
        PdfText Adhar = new PdfText(X, Y, "Aadhaar Card No: " + drcurrent["PatientIDProofno"].ToString(), errFont);
        if (drcurrent["PatientIDProofno"].ToString() != "" && (drcurrent["PatientIDProof"].ToString() == "1" || drcurrent["PatientIDProof"].ToString() == "Aadhaar Card"))
        {
            page.Header.Layout(Adhar);
            X += 170;
        }
        PdfText Nationality = new PdfText(X, Y, "Nationality: " + drcurrent["Nationality"].ToString(), errFont);
        if (drcurrent["Nationality"].ToString() != "")
        {
            page.Header.Layout(Nationality);
            X += 140;
        }

        PdfText PureHealthID = new PdfText(X, Y, "Pure Health ID: " + drcurrent["PureHealthID"].ToString(), errFont);
        if (drcurrent["PureHealthID"].ToString() != "")
        {
            page.Header.Layout(PureHealthID);

        }
    }

    private void SetFooter(PdfPage page)
    {
        FooterHeight = Util.GetInt(drcurrent["ReportFooterHeight"].ToString());
        page.CreateFooterCanvas(FooterHeight + 60);
        StringBuilder sbimg = new StringBuilder();
        //sbimg.Append("<div style='page-break-inside:avoid;'>");
        //sbimg.Append("<table style='width:100%'>");
        //if (drcurrent["ShowSignature"].ToString() != "0")
        //{
            //if (!signatureonend)
            //{
            //    sbimg.Append("<tr><td>");
            //    if (isSign(drcurrent["SignatureID"].ToString()))
            //    {
            //        string imgname = string.Format("{0}Design/opd/signature/{1}.jpg", serverPath, Util.GetString(drcurrent["SignatureID"]));
            //        sbimg.AppendFormat("<img style='float:left;padding-right:10px;' src='{0}'", imgname);
            //        sbimg.Append(" />");
            //    }
            //    sbimg.Append("</tr></td>");
            //}
     //   }
        //sbimg.Append("<tr><td>");
        //sbimg.AppendFormat("<img style='margin-left:-15px;' src='{0}'", new Barcode_alok().Save(drcurrent["LabNo"].ToString()).Trim());
        //sbimg.Append(" />");
        //sbimg.Append("</td></tr>");
        //sbimg.Append("<tr><td style='font-family: TimesNewRoman;'>");
        //sbimg.Append("SIN No:" + drcurrent["barcodeno"]);
        //sbimg.Append("</td></tr>");
        //sbimg.Append("</table>");
        //sbimg.Append("</div>");
        barcodeno = string.Empty;
        // if (Util.GetString(drcurrent["type1"]).Trim() != "PCC" && Util.GetString(drcurrent["isnabl"]).Trim() == "1" || (Util.GetString(drcurrent["centreid"]).Trim() == Util.GetString(drcurrent["TestCentreID"]).Trim()) && Util.GetString(drcurrent["isnabl"]).Trim() == "1")
        //    page.Footer.Layout(new PdfText(169, 55, "Note: Test Marked with * are Not NABL Accredited and # Marked as Outsource Test", new Font("Times New Roman", 7)));
        PdfHtml footerHtml = new PdfHtml(XFooter, 0, sbimg.ToString(), null);
        page.Footer.Layout(footerHtml);


        page.Footer.Layout(getPDFImageforbarcode(20, FooterHeight + 5, drcurrent["LabNo"].ToString(), "Yes"));
        if (Util.GetString(drcurrent["Address"]) != "" && Util.GetString(drcurrent["PrintTestCentre"]) == "1") //YES - 1
        {
            page.Footer.Layout(CovidMessage(XHeader + 110, 102, Util.GetString(drcurrent["Address"])));
        }

    }
    PdfText CovidMessage(float X, float Y, string _CentreName)
    {
        //bilal

        System.Drawing.Font sysFontBold = new System.Drawing.Font("Arial",
           8, System.Drawing.FontStyle.Regular,
                   System.Drawing.GraphicsUnit.Point);
        PdfText titleRotatedText = new PdfText(X, Y, "Test Performed at: " + _CentreName, sysFontBold);
        titleRotatedText.ForeColor = System.Drawing.Color.Gray;
        titleRotatedText.ForeColor = System.Drawing.Color.Gray;

        return titleRotatedText;
    }
    PdfText EndOfReport(float X, float Y)
    {
        return new PdfText(X, Y, "*** End Of Report ***", new Font("Times New Roman", 12));
    }
    bool isSign(string imgID)
    {
        return (File.Exists(string.Format("{0}{1}.jpg", Server.MapPath("~/Design/opd/signature/"), imgID)));
    }
    public string StripHTML(string source)
    {
        try
        {
            string result;

            // Remove HTML Development formatting
            // Replace line breaks with space
            // because browsers inserts space
            result = source.Replace("\r", " ");
            // Replace line breaks with space
            // because browsers inserts space
            result = result.Replace("\n", " ");
            // Remove step-formatting
            result = result.Replace("\t", string.Empty);
            // Remove repeating spaces because browsers ignore them
            result = System.Text.RegularExpressions.Regex.Replace(result,
                                                                  @"( )+", " ");

            // Remove the header (prepare first by clearing attributes)
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*head([^>])*>", "<head>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"(<( )*(/)( )*head( )*>)", "</head>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(<head>).*(</head>)", string.Empty,
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // remove all scripts (prepare first by clearing attributes)
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*script([^>])*>", "<script>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"(<( )*(/)( )*script( )*>)", "</script>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            //result = System.Text.RegularExpressions.Regex.Replace(result,
            //         @"(<script>)([^(<script>\.</script>)])*(</script>)",
            //         string.Empty,
            //         System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"(<script>).*(</script>)", string.Empty,
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // remove all styles (prepare first by clearing attributes)
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*style([^>])*>", "<style>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"(<( )*(/)( )*style( )*>)", "</style>",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(<style>).*(</style>)", string.Empty,
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // insert tabs in spaces of <td> tags
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*td([^>])*>", "\t",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // insert line breaks in places of <BR> and <LI> tags
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*br( )*>", "\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*li( )*>", "\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // insert line paragraphs (double line breaks) in place
            // if <P>, <DIV> and <TR> tags
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*div([^>])*>", "\r\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*tr([^>])*>", "\r\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<( )*p([^>])*>", "\r\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // Remove remaining tags like <a>, links, images,
            // comments etc - anything that's enclosed inside < >
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"<[^>]*>", string.Empty,
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // replace special characters:
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @" ", " ",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&bull;", " * ",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&lsaquo;", "<",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&rsaquo;", ">",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&trade;", "(tm)",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&frasl;", "/",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&lt;", "<",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&gt;", ">",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&copy;", "(c)",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&reg;", "(r)",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            // Remove all others. More can be added, see
            // http://hotwired.lycos.com/webmonkey/reference/special_characters/
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     @"&(.{2,6});", string.Empty,
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // for testing
            //System.Text.RegularExpressions.Regex.Replace(result,
            //       this.txtRegex.Text,string.Empty,
            //       System.Text.RegularExpressions.RegexOptions.IgnoreCase);

            // make line breaking consistent
            result = result.Replace("\n", "\r");

            // Remove extra line breaks and tabs:
            // replace over 2 breaks with 2 and over 4 tabs with 4.
            // Prepare first to remove any whitespaces in between
            // the escaped characters and remove redundant tabs in between line breaks
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\r)( )+(\r)", "\r\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\t)( )+(\t)", "\t\t",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\t)( )+(\r)", "\t\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\r)( )+(\t)", "\r\t",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            // Remove redundant tabs
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\r)(\t)+(\r)", "\r\r",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            // Remove multiple tabs following a line break with just one tab
            result = System.Text.RegularExpressions.Regex.Replace(result,
                     "(\r)(\t)+", "\r\t",
                     System.Text.RegularExpressions.RegexOptions.IgnoreCase);
            // Initial replacement target string for line breaks
            string breaks = "\r\r\r";
            // Initial replacement target string for tabs
            string tabs = "\t\t\t\t\t";
            for (int index = 0; index < result.Length; index++)
            {
                result = result.Replace(breaks, "\r\r");
                result = result.Replace(tabs, "\t\t\t\t");
                breaks = breaks + "\r";
                tabs = tabs + "\t";
            }

            // That's it.
            return result;
        }
        catch
        {
            return source;
        }
    }

    #region ImageProcess
    public String ConvertImageURLToBase64(String url)
    {
        StringBuilder _sb = new StringBuilder();
        Byte[] _byte = this.GetImage(url);
        _sb.Append(Convert.ToBase64String(_byte, 0, _byte.Length));
        return _sb.ToString();
    }
    private byte[] GetImage(string url)
    {
        Stream stream = null;
        byte[] buf;
        try
        {
            WebProxy myProxy = new WebProxy();
            HttpWebRequest req = (HttpWebRequest)WebRequest.Create(url);
            HttpWebResponse response = (HttpWebResponse)req.GetResponse();
            stream = response.GetResponseStream();
            using (BinaryReader br = new BinaryReader(stream))
            {
                int len = (int)(response.ContentLength);
                buf = br.ReadBytes(len);
                br.Close();
            }
            stream.Close();
            response.Close();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            buf = null;
        }
        return (buf);
    }
    private PdfImage getPDFImage(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Server.MapPath("~/" + SignImg)) { PreserveAspectRatio = true };
        //transparentResizedPdfImage.AlphaBlending = true;
        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private PdfImage getPDFImagewithresize(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, 60, Server.MapPath("~/" + SignImg)) { PreserveAspectRatio = true };
        //transparentResizedPdfImage.AlphaBlending = true;
        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private PdfImage getPDFImagewithresize1(float X, float Y, float Z, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Z, Server.MapPath("~/" + SignImg)) { PreserveAspectRatio = true };
        //transparentResizedPdfImage.AlphaBlending = true;
        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private PdfImage getPDFImageforabnormal(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, 70, Server.MapPath("~/" + SignImg)) { PreserveAspectRatio = true };
        //transparentResizedPdfImage.AlphaBlending = true;
        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private PdfImage getPDFImagewithresizeWaterMarkLogo(float X, float Y, float Z, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Z, Server.MapPath("~/" + SignImg)) { PreserveAspectRatio = true };
        //transparentResizedPdfImage.AlphaBlending = true;
        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private PdfImage getPDFImageforbarcode(float X, float Y, string labno, string ShowQR)
    {
        string image = "";
        PdfImage transparentResizedPdfImage = new PdfImage();
        if (ShowQR == "Yes")
        {
           // string URL = Util.GetString("http://localhost:5225/uat_ver1/Design/lab/labreportnew_ShortSMS.aspx?LabNo=" + drcurrent["LabNo"].ToString());//_" + drcurrent["Password_Web"].ToString()
             string URL = Util.GetString("http://itd-saas.cl-srv.ondgni.com/UAT_Ver1/Design/lab/labreportnew_ShortSMS.aspx?LabNo=" + drcurrent["LabNo"].ToString());//_" + drcurrent["Password_Web"].ToString()
            image = getqrcode(URL);
            transparentResizedPdfImage = new PdfImage(X, Y, 60, Base64StringToImage(image, ShowQR));
        }
        else
        {
            image = new Barcode_alok().Save(labno).Trim();
            transparentResizedPdfImage = new PdfImage(X, Y, Base64StringToImage(image, ShowQR));
        }



        transparentResizedPdfImage.PreserveAspectRatio = true;

        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }



    public string getqrcode(string code)
    {
        string yourcode = code;
        QRCodeEncoder enc = new QRCodeEncoder();
        //enc.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.ALPHA_NUMERIC;
        Bitmap qrcode = enc.Encode(yourcode);
        using (MemoryStream ms = new MemoryStream())
        {
            qrcode.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
            byte[] byteImage = ms.ToArray();
            return "data:image/png;base64," + Convert.ToBase64String(byteImage);
        }
    }
    //convert bytearray to image
    public System.Drawing.Image byteArrayToImage(byte[] byteArrayIn)
    {
        using (MemoryStream mStream = new MemoryStream(byteArrayIn))
        {
            return System.Drawing.Image.FromStream(mStream, true, true);
        }
    }
    public System.Drawing.Image Base64StringToImage(string base64String, string ShowQR = "No")
    {
        byte[] imageBytes = Convert.FromBase64String(base64String.Replace("data:image/png;base64,", ""));
        MemoryStream memStream = new MemoryStream(imageBytes, 0, imageBytes.Length);

        memStream.Write(imageBytes, 0, imageBytes.Length);
        System.Drawing.Image image = System.Drawing.Image.FromStream(memStream);
        Bitmap newImage;

        if (ShowQR == "Yes")
        {
            newImage = new Bitmap(100, 100);
        }
        else
            newImage = new Bitmap(240, 30);



        if (ShowQR == "Yes")
        {
            using (Graphics graphics = Graphics.FromImage(newImage))
                graphics.DrawImage(image, 0, 0, 80, 80);
            return newImage;
        }
        else
        {
            using (Graphics graphics = Graphics.FromImage(newImage))
                graphics.DrawImage(image, 0, 0, 240, 30);
            return newImage;
        }
    }
    #endregion
    private void bindReport()
    {
        _Attachments = new DataTable();
        StringBuilder sb = new StringBuilder();
        sb.Append("   SELECT * FROM (SELECT ");
        sb.Append("   t.ItemId, t.Password_Web,  t.LabNo,t.PLOID,t.laboutsrcid,t.FieldExe,t.InterpretationID,t.InterpretationType,   ");
        sb.Append("   substr(t.PName,1,35)PName, t.Age, t.BarcodeNo, t.Gender,t.ReportStatus,t.OtherReferLab,t.Interface_companyName,t.CorporateIDCard,t.PatientIDProofNo,t.PatientIDProof,t.LedgerTransactionNo_Interface,   ");
        sb.Append("   t.DateEnrolled, t.PassPortNo,t.PureHealthID,t.Nationality,t.SRFNo, t.Patient_ID, t.Description, t.SampleBySelf, t.LabObservation_ID, t.Test_ID,   ");
        sb.Append("   t.ResultDate,  t.ResultEnteredBy ,t.ForwardBy,        ");
        sb.Append("   t.Value,t.`MinValue`,t.`MaxValue`,IF(t.flag='','N',IF(t.flag='High','H','L'))  flag,t.abnormalimage ,t.samplename,IF(im.printHeader=0 || t.IsCommentField=1,CONCAT('<div style=''font-weight:bold;''>',t.LabObservationName,'</div>'),IF(t.IsBold='1' && t.isunderline='1',CONCAT('<div style= ''padding-left:10px;text-decoration: underline;font-weight:bold;''>',t.LabObservationName,'</div>'),IF(t.isbold='1',CONCAT('<div style= ''padding-left:10px;font-weight:bold;''>',t.LabObservationName,'</div>'), IF(t.isunderline='1' ,CONCAT('<div style= ''padding-left:10px;text-decoration: underline;''>',t.LabObservationName,'</div>'),CONCAT('<div style= ''padding-left:10px;''>',t.LabObservationName,'</div>')))))LabObservationName,t.Investigation_ID, t.SlideNumber,t.TestCentreID,  ");
        sb.Append("   t.SampleDate,  ");
        sb.Append("   t.ReceiveDate,  ");
        sb.Append("   t.DATE,        ");
        sb.Append("   t.Approved,t.comments, t.MYApproved,  ");
        sb.Append("   t.MYApprovedBy,t.ApprovedDate,  ");
        sb.Append("   t.ApprovedBy,t.SignatureID, t.ResultEnteredDate,  ");
        sb.Append("   t.ResultEnteredName, t.Unit,t.Child_Flag,  ");
        sb.Append("   t.labPriorty,t.DisplayReading,t.PackageName, t.IsPackage, ");
        sb.Append("   t.DispatchMode,  ");
        sb.Append("   t.ObsInterpretation ,  ");
        sb.Append("   t.MethodName,t.SegratedDate,t.PrintDate,t.IsCommentField,t.IsOrganism, ");
        sb.Append(" t.OrganismID,t.AbnormalValue,t.IsBold,t.IsUnderLine,t.`IsMic`,t.SepratePrint,t.ShowDeltaReport,t.isborder,t.MachineID,");
        sb.Append("  t.centreid,t.Panel_ID,t.ReferDoctor,left(pnl.Company_Name,30)Company_Name ,t.Company_code,t.Company_add,t.`HLMPatientType`,t.`HLMOPDIPDNo`,t.IsSampleCollectedByPatient,t.PatientType,");
        sb.Append("  '' AS Interpretation");
        sb.Append(",'1' ReportType,CONCAT(IF(t.IsPackage=1,'',''), ");
        sb.Append(" IF(IM.PrintSampleName=0,IF(IFNULL(itm.Inv_ShortName,'')!='',IM.Name,IM.Name),im.name)) AS TestName,im.PrintTestCentre,im.method,im.FileLimitationName, scm.deptinterpretaion,scm.ReportLine1,scm.ReportLine2,(select Address from centre_master where CentreId=t.TestCentreID)TCentreAdd,");
        sb.Append(" otm.Name AS Dept,otm.isVisible AS DeptVisible,  ");
        sb.Append("  IM.Print_sequence AS Print_Sequence_Investigation,   ");
        sb.Append("  im.PrintSeparate,im.printsamplename,itm.ShowInReport, ");
        sb.Append(" IM.Description AS d1,t.labPriorty Priorty,IF(VALUE ='HEAD' ,'Y','N') IsParent,im.printHeader  AS invHeader , ");
        sb.Append(" '' SampleTypeID,cma.Centre CentreName,cma.Address,cma.Landline CentreLandline,cma.Mobile CentreMobile,cma.Email ");
        sb.Append(" CentreEmail,ifnull((select NablLogoPath from centre_master where centreID=t.TestCentreID),'')NablLogoPath,ifnull((select CapLogoPath from centre_master where centreID=t.TestCentreID),'')CapLogoPath,ifnull((select NabhLogoPath from centre_master where centreID=t.TestCentreID),'')NabhLogoPath,'' printOrder ,cma.type1, ");
        sb.Append(" IFNULL((SELECT isNABL FROM `investiagtion_isnabl` WHERE Investigation_ID=im.Investigation_Id AND centreid=t.TestCentreID LIMIT 1),0 )isNABL, ");
        sb.Append(" otm.Print_Sequence Print_Sequence_Dept,IFNULL(t.labPriorty,9999)printOrder_labObservation1,labPriorty printOrder_labObservation2  ");
        sb.Append(" ,otm.ObservationType_ID,pnl.`Panel_Code`, pnl.`ShowSignature`, pnl.`ShowNABLLogo`, ");
        sb.Append(" pnl.ReportHeaderHeight,pnl.ReportHeaderXPosition,pnl.ReportHeaderYPosition,pnl.ReportFooterHeight,pnl.ReportBackGroundImage, pnl.AAALogo,pnl.TagProcessingLabID,IFNULL(LEFT(Add1,30),'')ClientAddress ");
        sb.Append(" FROM (      ");
        sb.Append(" SELECT   ");
        sb.Append(" pli.ItemId, lt.Password_Web,  pli.LedgerTransactionNo AS LabNo,pli.test_id PLOID,pli.laboutsrcid,IF(lt.HomeVisitBoyID='N/A','N/A',(SELECT  flm.NAME FROM feildboy_master flm WHERE flm.FeildBoyID=lt.HomeVisitBoyID)) FieldExe,pli.InterpretationID,pli.InterpretationType,");
      //abhijeet 30-11-22
        sb.Append(" lt.PName , lt.Age,pli.BarcodeNo,left(lt.Gender,1)Gender,IF(pli.Approved=0,'Provisional Report','Final Report')ReportStatus,lt.OtherReferLab,lt.Interface_companyName,lt.CorporateIDCard,lt.PatientIDProofNo,lt.PatientIDProof,lt.LedgerTransactionNo_Interface, ");
        sb.Append(" DATE_FORMAT(pli.date,'%d/%b/%Y %I:%i%p') DateEnrolled,lt.PassPortNo,lt.PureHealthID,lt.Nationality,lt.SRFNo,lt.Patient_ID,pl.Description,pli.SampleBySelf,pl.LabObservation_ID,pl.Test_ID, ");
        sb.Append(" DATE_FORMAT(pli.ResultEnteredDate,'%d-%b-%y')AS ResultDate, pli.ResultEnteredBy,if(pli.ForwardBy=pli.ApprovedBy,'',pli.ForwardBy) ForwardBy,");
        sb.Append(" IF(pl.IsCommentField =1,'',IF(IsNumeric(pl.Value)=1 && lm.RoundUpto <>-1,CONVERT(FORMAT(TRIM(pl.Value) ,lm.RoundUpto) USING utf8),pl.Value))VALUE,pl.`MinValue`,pl.`MaxValue`, pl.`Flag`,pl.abnormalimage,pli.SampleTypeName samplename,pl.LabObservationName,pli.Investigation_ID, pli.SlideNumber,pli.TestCentreID, ");
        sb.Append("      DATE_FORMAT(pli.SampleCollectionDate,'%d/%b/%Y %I:%i%p')SampleDate, ");
        sb.Append(" DATE_FORMAT(pli.SampleReceiveDate,'%d/%b/%Y  %I:%i%p')ReceiveDate, ");
        sb.Append(" DATE_FORMAT(pli.Date,'%d-%b-%y %h:%i %p')DATE,       ");
        sb.Append(" IF(pli.Approved=1,1,0)Approved,(SELECT comments FROM patient_labinvestigation_opd_comments ploc WHERE ploc.Test_ID = pli.Test_ID)comments,  ");
        sb.Append("  IF(pli.isHold=1,'Hold',  ");
        sb.Append("  IF(pli.Approved=1,'Approved',IF(pli.isForward=1,'Forward',''))) AS MYApproved, ");
        sb.Append("  IF(pli.isHold=1,pli.HoldByName,IF(pli.Approved=1,'',IF(pli.isForward=1,pli.ForwardByName,'')))  ");
        sb.Append("  AS MYApprovedBy,       DATE_FORMAT(pli.ApprovedDate,'%d/%b/%Y %I:%i%p')ApprovedDate, ");
        sb.Append("  pli.ApprovedBy,pli.SignatureID,        DATE_FORMAT(pli.ResultEnteredDate,'%d/%b/%Y %I:%i%p')ResultEnteredDate, ");
        sb.Append("   pli.ResultEnteredName,        pl.ReadingFormat AS Unit,lm.Child_Flag, ");
        sb.Append("   pl.Priorty labPriorty,REPLACE(IFNULL(pl.DisplayReading,''),'\n','<br />')DisplayReading,if(pli.IsPackage=1,pli.PackageName,'') PackageName, pli.IsPackage,");
        sb.Append("   '' DispatchMode ");
        sb.Append("   ,'' AS ObsInterpretation ,");
        sb.Append("  IF(pl.PrintMethod='1' AND pl.Method <>'' , CONCAT('',pl.Method),'') MethodName,DATE_FORMAT(pli.sampleCollectiondate,'%d/%b/%Y %I:%i%p')SegratedDate,DATE_FORMAT(NOW(),'%d/%b/%Y %I:%i%p')PrintDate,pl.IsCommentField ,pl.IsOrganism, pl.OrganismID,pl.AbnormalValue,pl.IsBold,pl.IsUnderLine,pl.`IsMic`,");
        sb.Append(" pl.SepratePrint,pl.ShowDeltaReport, ");
        sb.Append("  (SELECT isborder FROM labobservation_investigation WHERE investigation_id=pli.investigation_id AND LabObservation_ID=pl.LabObservation_ID) isborder,pl.MachineID  , lt.centreid,lt.Panel_ID,IF(UPPER(lt.DoctorName) = 'SELF', LEFT(UPPER(lt.DoctorName),28),LEFT(CONCAT('Dr.', UPPER(lt.`DoctorName`)),28)) ReferDoctor, IF(lt.OtherReferLab='',left(lt.panelname,25),lt.OtherReferLab)  Company_Name ,'' Company_code,'' Company_add,lt.`HLMPatientType`,lt.`HLMOPDIPDNo`,pli.IsSampleCollectedByPatient,IFNULL(lt.PatientType,'')PatientType ");
        sb.Append("  FROM patient_labobservation_opd pl   ");
        sb.Append("   INNER JOIN patient_labinvestigation_opd pli ON pli.Test_ID = pl.Test_ID AND TRIM(pl.value)<>'' AND pli.ReportType='1' ");
        //      sb.Append(" and 0=(select count(*) from patient_labinvestigation_attachment_report plar where plar.`Test_id`=pl.`Test_ID`) ");
        sb.Append("  AND pli.Test_ID IN ({0})  AND pli.Result_Flag = 1 AND pli.ishold=0 ");
        sb.Append("  INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID=pli.LedgerTransactionID ");
        sb.Append("  INNER JOIN labobservation_master lm ON lm.LabObservation_ID = pl.LabObservation_ID and lm.PrintInLabReport='1'  ");
        sb.Append(" LEFT JOIN Patient_master_VIP PMV on PMV.Paitent_ID=lt.Patient_ID");
        sb.Append("       )t  ");
        sb.Append(" INNER JOIN investigation_master IM ON IM.Investigation_Id = t.Investigation_ID   ");
        sb.Append(" INNER JOIN f_itemmaster itm ON itm.Type_ID = IM.Investigation_ID     ");
        sb.Append(" INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=itm.`SubCategoryID` AND scm.`CategoryID`='LSHHI3'   ");
        sb.Append(" INNER JOIN investigation_observationtype iot ON iot.Investigation_ID=im.Investigation_Id   ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_Id    ");
        sb.Append(" inner JOIN centre_master cma ON cma.CentreID = t.CentreId   ");
        sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=t.Panel_ID   ");
        sb.Append("  ORDER BY LabNo,IFNULL(printOrder,9999),labPriorty )ttt ");
        sb.Append(" UNION ALL");
        sb.Append("  SELECT t.*, ");
        sb.Append("  '' AS Interpretation,");
        sb.Append(" '3' ReportType,IF(IM.PrintSampleName=0,IF(IFNULL(itm.Inv_ShortName,'')!='',IM.Name,IM.Name),im.name) AS TestName,im.PrintTestCentre,im.method,");
        sb.Append(" im.FileLimitationName,scm.deptinterpretaion,scm.ReportLine1,scm.ReportLine2,(select Address from centre_master where CentreId=t.TestCentreID)TCentreAdd,");
        sb.Append("  otm.Name AS Dept,otm.isVisible AS DeptVisible, ");
        sb.Append(" IM.Print_sequence AS Print_Sequence_Investigation ,");
        sb.Append(" im.PrintSeparate,im.printsamplename,itm.ShowInReport, ");
        sb.Append(" IM.Description AS d1,'' Priorty,'' IsParent,im.printHeader   ");
        sb.Append("  AS invHeader    ,");
        sb.Append(" '' SampleTypeID,cma.Centre CentreName,cma.Address,cma.Landline CentreLandline,cma.Mobile CentreMobile,cma.Email CentreEmail,ifnull((select NablLogoPath from centre_master where centreID=t.TestCentreID),'')NablLogoPath,ifnull((select CapLogoPath from centre_master where centreID=t.TestCentreID),'')CapLogoPath,ifnull((select NabhLogoPath from centre_master where centreID=t.TestCentreID),'')NabhLogoPath,'' printOrder ,cma.type1,");
        sb.Append("  IFNULL((SELECT isNABL FROM `investiagtion_isnabl` WHERE Investigation_ID=im.Investigation_Id AND centreid=t.TestCentreID),0)isNABL ");
        sb.Append("  ,otm.Print_Sequence Print_Sequence_Dept,999 printOrder_labObservation1,999 printOrder_labObservation2 ,");
        sb.Append(" otm.ObservationType_ID, pnl.`Panel_Code`, pnl.`ShowSignature`, pnl.`ShowNABLLogo`, ");
        sb.Append(" pnl.ReportHeaderHeight,pnl.ReportHeaderXPosition,pnl.ReportHeaderYPosition,pnl.ReportFooterHeight,pnl.ReportBackGroundImage,pnl.AAALogo,pnl.TagProcessingLabID,IFNULL(LEFT(pnl.Add1,30),'')ClientAddress  ");
        sb.Append(" FROM (   ");
        sb.Append(" SELECT  ");
        sb.Append("  pli.ItemId,lt.Password_Web,  pli.LedgerTransactionNo AS LabNo,pli.test_id PLOID,pli.laboutsrcid,IF(lt.HomeVisitBoyID='N/A','N/A',(SELECT  flm.NAME FROM feildboy_master flm WHERE flm.FeildBoyID=lt.HomeVisitBoyID)) FieldExe,pli.InterpretationID,pli.InterpretationType,");
        sb.Append("   lt.PName,lt.age Age,pli.BarcodeNo,left(lt.Gender,1)Gender,IF(pli.Approved=0,'Provisional Report','Final Report')ReportStatus ,lt.OtherReferLab,lt.Interface_companyName,lt.CorporateIDCard,lt.PatientIDProofNo,lt.PatientIDProof,lt.LedgerTransactionNo_Interface, ");
        sb.Append(" DATE_FORMAT(pli.date,'%d/%b/%Y %I:%i%p') DateEnrolled,lt.PassPortNo,lt.PureHealthID,lt.Nationality,lt.SRFNo,lt.Patient_ID Patient_ID,'' Description,pli.SampleBySelf,'' LabObservation_ID,pli.Test_ID, ");
        sb.Append(" DATE_FORMAT(pli.ResultEnteredDate,'%d-%b-%y')AS ResultDate,pli.ResultEnteredBy ,if(pli.ForwardBy=pli.ApprovedBy,'',pli.ForwardBy) ForwardBy ,       ");
        sb.Append(" (SELECT LabInves_Description FROM patient_labobservation_opd_text WHERE PLO_ID = pli.test_id) VALUE,'' `MinValue`,'' `MaxValue`, '' Flag,'' abnormalimage,pli.sampletypename samplename,'' LabObservationName,pli.Investigation_ID,pli.SlideNumber,pli.TestCentreID, ");
        sb.Append("     DATE_FORMAT(pli.SampleCollectionDate,'%d/%b/%Y %I:%i%p')SampleDate, ");
        sb.Append(" DATE_FORMAT(pli.SampleReceiveDate,'%d/%b/%Y %I:%i%p')ReceiveDate, DATE_FORMAT(pli.Date,'%d-%b-%y %h:%i %p')DATE, ");
        sb.Append(" IF(pli.Approved=1,1,0)Approved,(SELECT comments FROM patient_labinvestigation_opd_comments ploc WHERE ploc.Test_ID = pli.Test_ID)comments,        IF(pli.isHold=1,'Hold', ");
        sb.Append(" IF(pli.Approved=1,'Approved',IF(pli.isForward=1,'Forward',''))) AS MYApproved, ");
        sb.Append(" IF(pli.isHold=1,pli.HoldByName,IF(pli.Approved=1,'',IF(pli.isForward=1,pli.ForwardByName,'')))  ");
        sb.Append(" AS MYApprovedBy,       DATE_FORMAT(pli.ApprovedDate,'%d/%b/%Y %I:%i%p')ApprovedDate,   ");
        sb.Append(" pli.ApprovedBy, pli.SignatureID,       DATE_FORMAT(pli.ResultEnteredDate,'%d/%b/%Y %I:%i%p')ResultEnteredDate,   ");
        sb.Append(" pli.ResultEnteredName,        '' AS Unit,'' Child_Flag,   ");
        sb.Append(" ''  labPriorty,'' DisplayReading,if(pli.IsPackage=1,pli.PackageName,'') PackageName, pli.IsPackage,  ");
        sb.Append(" '' DispatchMode   ");
        sb.Append(" ,'' ObsInterpretation, '' MethodName,DATE_FORMAT(pli.SamplecollectionDate,'%d/%b/%Y %I:%i%p')SegratedDate,DATE_FORMAT(NOW(),'%d/%b/%Y %I:%i%p')PrintDate,'0' IsCommentField ,0 IsOrganism,'' OrganismID,'' AbnormalValue,0 IsBold,0 IsUnderLine,0 `IsMic`,0 SepratePrint ,0 ShowDeltaReport,0 isborder,'1' MachineID   ");
        sb.Append(" , lt.centreid,lt.Panel_ID,IF(UPPER(lt.DoctorName) = 'SELF', LEFT(UPPER(lt.DoctorName),28),LEFT(CONCAT('Dr.', UPPER(lt.`DoctorName`)),30)) ReferDoctor, IF(lt.OtherReferLab='',left(lt.panelname,25),lt.OtherReferLab) Company_Name ,'' Company_code,'' Company_add,lt.`HLMPatientType`,lt.`HLMOPDIPDNo`,pli.IsSampleCollectedByPatient,IFNULL(lt.PatientType,'')PatientType");
        sb.Append(" FROM patient_labinvestigation_opd pli    ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID=pli.LedgerTransactionID  ");
        sb.Append(" AND pli.Test_ID IN ({0})  AND pli.Result_Flag = 1  AND pli.ReportType in(3,5) AND pli.ishold=0   ");
        sb.Append("  )t    ");
        sb.Append("INNER JOIN investigation_master IM ON IM.Investigation_Id = t.Investigation_ID and t.value<>''  ");
        //   sb.Append(" AND 0=(SELECT COUNT(*) FROM patient_labinvestigation_attachment_report plar WHERE plar.`Test_id`=t.`Test_ID`)  ");
        sb.Append("INNER JOIN f_itemmaster itm ON itm.Type_ID = IM.Investigation_ID     ");
        sb.Append("INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=itm.`SubCategoryID` AND scm.`CategoryID`='LSHHI3'    ");
        sb.Append(" INNER JOIN investigation_observationtype iot ON iot.Investigation_ID=im.Investigation_Id   ");
        sb.Append(" INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_Id     ");
        sb.Append(" inner JOIN centre_master cma ON cma.CentreID = t.CentreId   ");
        sb.Append(" INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=t.Panel_ID   ");
        sb.Append("  ORDER BY Company_Name,LabNo,approved ,Print_Sequence_Dept,Dept,Print_Sequence_Investigation ,printOrder_labObservation1,printOrder_labObservation2 ; ");
        //if (UserInfo.ID==1)
         //  System.IO.File.WriteAllText (@"C:\ITDOSE\UAT_Ver1\ErrorLog\q1213223.txt", sb.ToString());
        string[] tags = TestID.Replace("'", "").Split(',');
        if (isOnlinePrint != "1")
            tags = tags.Take(tags.Count() - 1).ToArray();
        string[] paramNames = tags.Select(
              (s, i) => "@tag" + i).ToArray();
        string inClause = string.Join(", ", paramNames);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), inClause), con))
            {
                for (int i = 0; i < paramNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(paramNames[i], tags[i]);
                }
                da.Fill(dtObs);
            }
            if (dtObs.Rows.Count == 0)
            {
                int isRadiology = 0;
                //radiology report
                using (MySqlCommand cmd = new MySqlCommand(string.Format("SELECT count(1) from patient_labinvestigation_opd where Test_ID in({0}) and ReportType=5", inClause), con))
                {
                    for (int i = 0; i < paramNames.Length; i++)
                    {
                        cmd.Parameters.AddWithValue(paramNames[i], tags[i]);
                    }
                    isRadiology = Util.GetInt(cmd.ExecuteScalar());
                }
                if (isRadiology > 0)
                {
                    string url = string.Format("{0}://{1}/{2}/Design/Lab/labreportnewradio.aspx{3}", Request.Url.Scheme, "itd-saas.cl-srv.ondgni.com", Request.Url.AbsolutePath.Split('/')[1], Request.Url.Query);
                    // System.IO.File.WriteAllText (@"C:\ITDOSE\UAT_Ver1\ErrorLog\25Novblank1Url1.txt", url);
					//  if (UserInfo.ID == 1) System.IO.File.WriteAllText(@"F:\Lims 6.0\live_Code\Mdrc\ErrorLog\ioiu.txt", url);
                    Stream stream = ConvertToStream(url);
                    PdfDocument pdfradio = PdfDocument.FromStream(stream);
                    document.AddDocument(pdfradio);
                }
                MySqlCommand cmd1 = new MySqlCommand(string.Format("select count(1) from patient_labobservation_opd_mic where TestID IN ({0})", inClause), con);
                for (int i = 0; i < paramNames.Length; i++)
                {
                    cmd1.Parameters.AddWithValue(paramNames[i], tags[i]);
                }
                int isculture = Util.GetInt(cmd1.ExecuteScalar().ToString());
                if (isculture > 0)
                {
                    Response.Redirect(string.Concat("labreportmicro.aspx", Request.Url.Query));
                }
                MySqlCommand cmd2 = new MySqlCommand(string.Format("select count(1) from patient_labobservation_histo where Test_ID IN ({0})", inClause), con);
                for (int i = 0; i < paramNames.Length; i++)
                {
                    cmd2.Parameters.AddWithValue(paramNames[i], tags[i]);
                }
                int ishisto = Util.GetInt(cmd2.ExecuteScalar().ToString());
                if (ishisto > 0)
                {
                    Response.Redirect(string.Concat("labreportnewhisto.aspx", Request.Url.Query));
                }
            }
            if (dtObs.Rows.Count > 0)
            {
                dtReportHeader = StockReports.GetDataTable(" SELECT * FROM centre_Panel WHERE `ReportHeader` IS NOT NULL ");

                StringBuilder sbAttachment = new StringBuilder();
                sbAttachment.Append(" SELECT pli.`id`,plo.`LedgerTransactionNo`,plo.`Test_ID`,pli.`AttachedFile`,CONCAT_WS('/',DATE_FORMAT(pli.`dtEntry`,'%Y%m%d'), pli.`FileUrl`)FileUrl,em.`Name` AS UploadedBy,DATE_FORMAT(pli.`dtEntry`,'%d-%b-%Y %I:%i %p') AS dtEntry  ");
                sbAttachment.Append(" FROM `patient_labinvestigation_attachment` pli  ");
                sbAttachment.Append(" INNER JOIN `patient_labinvestigation_opd` plo ON plo.`Test_ID`=pli.`Test_ID`  ");
                sbAttachment.Append(" INNER JOIN `employee_master` em ON em.`Employee_ID`=pli.`UploadedBy` and pli.Test_ID IN ({0})  ");
                using (MySqlDataAdapter da1 = new MySqlDataAdapter(String.Format(sbAttachment.ToString(), inClause), con))
                {
                    for (int i = 0; i < paramNames.Length; i++)
                    {
                        da1.SelectCommand.Parameters.AddWithValue(paramNames[i], tags[i]);
                    }
                    da1.Fill(_Attachments);
                }
            }
            else
            {
                _Attachments = new DataTable();
            }
            _MacImage = new DataTable();
            sb = new StringBuilder();
            sb.Append(" SELECT Test_ID,BarcodeNo,Investigation_ID,Base64Image,MachineID  ");
            sb.Append(" FROM patient_labinvestigation_opd_image ");
            sb.Append(" WHERE Test_ID IN ({0}) ");
            using (MySqlDataAdapter da5 = new MySqlDataAdapter(String.Format(sb.ToString(), inClause), con))
            {
                for (int i = 0; i < paramNames.Length; i++)
                {
                    da5.SelectCommand.Parameters.AddWithValue(paramNames[i], tags[i]);
                }
                da5.Fill(_MacImage);
            }
            string sbAttachmentReport = "SELECT test_id, CONCAT(DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`) FileUrl FROM patient_labinvestigation_attachment_report  WHERE Test_ID IN ({0})   ";
            using (MySqlDataAdapter da2 = new MySqlDataAdapter(String.Format(sbAttachmentReport.ToString(), inClause), con))
            {
                for (int i = 0; i < paramNames.Length; i++)
                {
                    da2.SelectCommand.Parameters.AddWithValue(paramNames[i], tags[i]);
                }
                da2.Fill(dtAttachment);
            }
            if ((isOnlinePrint != "1") && (isEmail != "1"))
            {
                if ((IsPrev != "1"))
                {
                    string PLO = "update patient_labinvestigation_opd set isPrint='1' WHERE Test_ID IN ({0})   AND isPrint='0' AND Approved='1' ";
                    MySqlCommand cmd4 = new MySqlCommand(string.Format(PLO.ToString(), inClause), con);
                    for (int i = 0; i < paramNames.Length; i++)
                    {
                        cmd4.Parameters.AddWithValue(paramNames[i], tags[i]);
                    }
                    cmd4.ExecuteNonQuery();
                    cmd4.Dispose();
                    string[] tid = TestID.Replace(",''", "").Split(',');//dtObs.Columns["Test_ID"].ToString();

                    for (int i = 0; i < tid.Length; i++)
                    {
                        if (tid[i] != "")
                        {
                            sb = new StringBuilder();
                            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status (Test_ID,LedgerTransactionNo,Status,UserID,UserName,dtEntry,CentreID,RoleID,BarcodeNo) ");
                            sb.Append(" VALUES ('" + dtObs.Rows[i]["Test_ID"].ToString() + "','" + dtObs.Rows[i]["LabNo"].ToString() + "','Printed By " + UserInfo.LoginName + "','" + UserInfo.ID + "','" + UserInfo.UserName + "',now(),'" + UserInfo.Centre + "','" + UserInfo.RoleID + "','" + dtObs.Rows[i]["BarcodeNo"].ToString() + "')");
                            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString());
                        }
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