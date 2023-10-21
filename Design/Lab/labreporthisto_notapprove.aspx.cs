using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using HiQPdf;
using System.Data;
using System.Drawing;
using System.IO;
using System.Text;
using System.Net;
using System.Linq;
using System.Drawing.Drawing2D;

using System.Diagnostics;
using System.Drawing.Printing;
using MySql.Data.MySqlClient;

public partial class Design_Lab_labreporthisto_notapprove : System.Web.UI.Page
{
    public string serverPath = string.Empty;
    DataTable dtObs = new DataTable();
    DataTable dtLabReport = new DataTable();
    DataTable dtOrganismStyle = new DataTable();
    DataTable dtReportHeader = new DataTable();
    DataTable dtAttachment = new DataTable();

    DataRow drcurrent;
    PdfLayoutInfo html1LayoutInfo;


    //Report Variables

    public string TestID = string.Empty;
    public List<string> Test_ID = new List<string>();
    string PHead = "0";
    public string LeftMargin = string.Empty;
    public string isOnlinePrint = "0";
    public string isEmail = string.Empty;

    //Page Property

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 550;
    int BrowserWidth = 800;
    bool showItdose = false;




    //Header Property
    int HeaderHeight = 0;//207
    int XHeader = 0;//20
    int YHeader = 20;//80
    int HeaderBrowserWidth = 800;




    // BackGround Property
    bool HeaderImage = false;
    string HeaderImg = "";

    //Footer Property 80
    float FooterHeight = 0;//95
    int XFooter = 20;

    //Report Setup
    bool printSeparateDepartment = true;
    bool printEndOfReportAtFooter = false;
    public string app = "0";





    StringBuilder sbCss = new StringBuilder();
    List<string> abnormalimg = new List<string>();

    string machinecomment = "";
    string deptcomment = "";
    public void showValidationMsg(string errorMsg, string isApp, int XPos, int YPos)
    {
        PdfPage page1 = document.AddPage(PdfPageSize.A4, new PdfDocumentMargins(5), PdfPageOrientation.Portrait);
        System.Drawing.Font errFont = new System.Drawing.Font("Cambria", 15, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point);
        PdfText errMsg = new PdfText(XPos, YPos, errorMsg, errFont);
        errMsg.ForeColor = System.Drawing.Color.Red;
        page1.Layout(errMsg);
        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
        document.AddPage(page1);
        byte[] pdfBuffer = document.WriteToMemory();
        HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
        HttpContext.Current.Response.BinaryWrite(pdfBuffer);
        HttpContext.Current.Response.End();
    }
    public string CheckAdvanceBalRestriction(string TID)
    {
        //TID = "'" + TID + "'";
        // TID = TID.Replace(",", "','");
        string query = "SELECT    IF(pm.MaxExpiry>NOW(),'1','0') timelimit,pm.TimeLimitExtend, UPPER(pm.`Payment_Mode`) pmode,  pm.`inamount` - pm.`outamount` + pm.`CreditLimit` AS 'balance' , plo.Test_ID FROM   f_ledgertransaction lt   INNER JOIN patient_labinvestigation_opd plo ON lt.`LedgerTransactionNo` =plo.LedgerTransactionNo   AND plo.test_id IN (" + TID + ") AND lt.iscancel=0   INNER JOIN f_panel_master pm     ON lt.`Panel_ID` = pm.`Panel_ID`";
        DataTable dt = StockReports.GetDataTable(query);
        string AdvPanelTestId = "";
        foreach (DataRow dr in dt.Rows)
        {
            if (Util.GetString(dr["pmode"]) == "ADVANCE")
            {
                if (Util.GetDecimal(dr["balance"]) <= Util.GetDecimal(0) && Util.getApp("BlockReportPrinting").Trim() == "Y")
                {
                    if (Util.GetString(dr["timelimit"]) == "0")
                    {
                        AdvPanelTestId += Util.GetString(dr[2]) + "|";
                    }
                }
            }
        }
        AdvPanelTestId = AdvPanelTestId.TrimEnd('|');
        return AdvPanelTestId;
    }

    PdfDocument document = new PdfDocument();

    PdfDocument tempDocument = new PdfDocument();

    protected void Page_Load(object sender, EventArgs e)
    {


        serverPath = Resources.Resource.LabReportPath;
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
            isOnlinePrint = Util.GetString(Request.QueryString["isOnlinePrint"]);
            TestID = Util.GetString(Request.QueryString["TestID"]);
            PHead = Util.GetString(Request.QueryString["PHead"]);
        }
        TestID = "'" + TestID + "'";
        TestID = TestID.Replace(",", "','");
        Test_ID = TestID.TrimEnd(',').Split(',').ToList<string>();
        if (PHead == "1")
        {
            HeaderImage = true;
        }

        if ((isOnlinePrint == "1") && (isEmail != "1"))
        {
            Session["LoginName"] = "Online";
        }
        else
        {
            /*  string RemoveAdvPanelTest = CheckAdvanceBalRestriction(TestID);
              if (RemoveAdvPanelTest.Trim() != "")
              {
                  string[] rmvTest = RemoveAdvPanelTest.Split('|');
                  foreach (string st in rmvTest)
                  {
                      TestID = TestID.Replace(st, "").Replace(",,", ",");
                  }
                  ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('Advance Panel Credit Limit Exceeds, Report Cannot be Printed');", true);
                  return;
              }
      */
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
                            // TestID = objVal.checkCancelByInterface(TestID);
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
            if (Util.GetInt(Session["RoleID"]) != 177)// open For Adminsitartor Role If Due
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
                                //  TestID = objVal.checkCancelByInterface(TestID);
                                //  if (TestID == "''" || TestID=="")
                                //  {
                                //      TestID = "-1";
                                //  }
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
            // Response.Write("<center><font style=\"color:red;font-weight:bolder;font-size:20px;\">Can't Open Report. Discount is Not Approved..!</font></center>");
            showValidationMsg("Can't Open Report. Discount is Not Approved..!", app, 170, 30);
            return;
        }
        else if (TestID == "")
        {
            // Response.Write("<center><font style=\"color:red;font-weight:bolder;font-size:20px;\">Can't Open Report. Amount is Due..!</font></center>");
            showValidationMsg("Can't Open Report. Amount is Due..!", app, 170, 30);
            return;
        }
        else if (TestID == "-1")
        {
            //  Response.Write("<center><font style=\"color:red;font-weight:bolder;font-size:20px;\">Can't Open Report. All the tests are cancelled by interface company..!</font></center>");
            showValidationMsg("Can't Open Report. All The Tests Are Cancelled By Interface Company..!", app, 70, 30);
            return;
        }
        else if (TestID == "-2")
        {
            // Response.Write("<center><font style=\"color:red;font-weight:bolder;font-size:20px;\">Can't Open Report. Kindly contact to ITDose..!</font></center>");
            showValidationMsg("Can't Open Report. Kindly Contact To ITDose..!", app, 170, 30);
            return;
        }
        else if (TestID == "-3")
        {
            showValidationMsg("Credit limit exceeded and your account is locked, Kindly contact to account department.......!", app, 0, 30);
            return;
        }
        if (dtObs.Rows.Count == 0 && dtAttachment.Rows.Count == 0)
        {
            showValidationMsg("", app, 70, 30);
            return;
        }


        document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;


        DataTable dtTemp = StockReports.GetDataTable("select * from labreportmaster order by printOrder");

        sbCss.Append("<style>");
        sbCss.Append(".divContent{width:800px;page-break-inside:avoid; border:0.5px solid black;margin-bottom:15px;} ");
        sbCss.Append(".tbData{width:800px;border-collapse: collapse;  } .tbData tr td{border: 1px solid black;}");


        sbCss.Append(".tbData th{font-weight:bold;padding-bottom:5px;} .tbData tr th{border: 1px solid black;}");
        sbCss.Append("table.tbOrganism { border-collapse: collapse;}");
        sbCss.Append("table.tbOrganism, td.tbOrganism, th.tbOrganism{  border: 1px solid black;}");



        foreach (DataRow dr in dtTemp.Rows)
        {

            sbCss.Append("." + dr["Name"].ToString() + "{font-family:" + dr["FName"].ToString() +
            ";font-size:" + dr["Fsize"].ToString() + "px;text-align:" + dr["Alignment"].ToString() +
            ";" + (dr["Bold"].ToString() == "Y" ? "font-weight:bold;" : "") +
            "" + (dr["Under"].ToString() == "Y" ? "text-decoration:underline;" : "") +
            " " + (dr["Italic"].ToString() == "Y" ? "font-style:italic;" : "") + "width:" + dr["width"].ToString() + "px;Height:" + dr["Height"].ToString() + ";}");

        }
        sbCss.Append("</style>");


        // Exculding global style sheet

        DataView view = new DataView(dtTemp);
        view.RowFilter = "Print = 1";
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
                dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["PackageName"].ToString() != dr["PackageName"].ToString())
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

                        sb.Append("<tr><td class='Department'  colSpan='" + dtLabReport.Rows.Count + "' style='border:0px;'>&nbsp;</td></tr>");
                        sb.Append("<tr><td class='Department'  colSpan='" + dtLabReport.Rows.Count + "' style='border-top:1px solid black;border-left:0px;border-right:0px;border-bottom:0px;text-align:center;'>*** End Of Report ***</td></tr>");
                        sb.Append("<tr><td style='border:0px;' colSpan='" + dtLabReport.Rows.Count + "'>");
                        string pendingtest = StockReports.ExecuteScalar(@"SELECT ifnull(GROUP_CONCAT(NAME SEPARATOR ', '),'') FROM `patient_labinvestigation_opd` plo
INNER JOIN investigation_master im ON plo.investigation_id=im.investigation_id
WHERE `LedgertransactionNo`='" + drcurrent["LabNo"].ToString() + "' AND approved=0 AND isreporting=1");
                        DataRow[] list = dtObs.Select("LabNo ='" + drcurrent["LabNo"].ToString() + "' and Approved=1");
                        if (list.Length > 0)
                        {
                            DataTable dataTable = list.CopyToDataTable();

                            DataView dv = dataTable.DefaultView.ToTable(true, "ApprovedBy").DefaultView;
                            dv.Sort = "ApprovedBy asc";
                            DataTable deptapp = dv.ToTable();

                            DataView dv1 = dataTable.DefaultView.ToTable(true, "ForwardBy").DefaultView;
                            dv1.Sort = "ForwardBy asc";
                            DataTable deptapp1 = dv1.ToTable();

                            StringBuilder sbimg = new StringBuilder();

                            if (pendingtest != "")
                            {
                                sbimg.Append("<span style='font-size:13px;'>Result/s to Follow:<br/>" + pendingtest + "<br/></span>");

                            }
                            sbimg.Append("<div style='width:800px;page-break-inside:avoid;'>");
                            foreach (DataRow st in deptapp1.Rows)
                            {
                                if (isSign(st["ForwardBy"].ToString()))
                                {
                                    string imgname = serverPath + "Design/opd/signature/" + Util.GetString(st["ForwardBy"]) + ".jpg";
                                    sbimg.Append("<img style='float:left;padding-right:10px;' src='" + imgname + "'");
                                    sbimg.Append(" />");
                                }
                            }
                            foreach (DataRow st in deptapp.Rows)
                            {

                                if (isSign(st["ApprovedBy"].ToString()))
                                {
                                    string imgname = serverPath + "Design/opd/signature/" + Util.GetString(st["ApprovedBy"]) + ".jpg";
                                    sbimg.Append("<img style='float:left;padding-right:10px;' src='" + imgname + "'");
                                    sbimg.Append(" />");

                                }

                            }
                            sbimg.Append("</div>");
                            sb.Append(sbimg);




                        }

                    }
                }

                sb.Append("</td></tr>");
                sb.Append("</table></div>");
                html1LayoutInfo = null;
                AddContent(sb.ToString(), dr, _LastRow);

                SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);


                if (_LastRow ? false : dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["LabNo"].ToString() != dr["LabNo"].ToString())
                {

                    mergeDocument();
                }


                sb = new StringBuilder();
                sb.Append(sbCss.ToString());
                sb.Append("<div class='divContent' ><table class='tbData'>");




            }










            sb.Append("<tr valign='top'  >");

            int colspan = dtLabReport.Rows.Count - 1;
            //sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:18px;padding:3px;text-transform: uppercase;font-family:Calibri;'>Test:</td>");
            //sb.Append("<td valign='top' colSpan='" + colspan + "'  style='font-size:18px;padding:3px;'>" );
            //if (Util.GetString(dr["TagProcessingLabID"]).Trim() != Util.GetString(dr["TestCentreID"]).Trim())
            //    {
            //        sb.Append("*"+dr["TestName"].ToString() + "</td>");
            //    }
            //    else
            //    {
            //        sb.Append(dr["TestName"].ToString() + "</td>");
            //    }

            //sb.Append("</tr>");

            sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
            sb.Append("</tr>");

            sb.Append("<tr valign='top'  >");


            sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:18px;padding:3px;text-transform: uppercase;font-family:Calibri;'>Specimen:</td>");
            sb.Append("<td valign='top' colSpan='" + colspan + "'  style='font-size:18px;padding:3px;'>");
            if (Util.GetString(dr["type1"]).Trim() == "PCC" && (Util.GetString(dr["TagProcessingLabID"]).Trim() != Util.GetString(dr["TestCentreID"]).Trim()))
            {
                sb.Append("*" + dr["specimen_title"].ToString());
            }
            else if (Util.GetString(dr["type1"]).Trim() != "PCC" && (Util.GetString(dr["centreid"]).Trim() != Util.GetString(dr["TestCentreID"]).Trim()))
            {
                sb.Append("*" + dr["specimen_title"].ToString());
            }
            else
            {
                sb.Append(dr["specimen_title"].ToString());
            }
            sb.Append("</tr>");
            sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
            sb.Append("</tr>");
            sb.Append("<tr valign='top'  >");

            if (dr["Clinicalhistory"].ToString() != "")
            {
                sb.Append("<tr valign='top'  >");
                sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:19px;padding:3px;text-transform: uppercase;font-family:Calibri;'>Clinical History:</td>");
                sb.Append("<td valign='top' colSpan='" + colspan + "'  style='font-size:18px;padding:3px;'>" + dr["Clinicalhistory"].ToString() + "</td>");
                sb.Append("</tr>");

                sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
                sb.Append("</tr>");



            }



            if (dr["Dept"].ToString().ToUpper() == "HISTOPATHOLOGY")
            {
                sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:18px;padding:3px;text-transform: uppercase;font-family:Calibri;'>Biopsy No:</td>");
            }
            else
            {
                sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:18px;padding:3px;text-transform: uppercase;font-family:Calibri;'>Cytology No:</td>");
            }
            sb.Append("<td valign='top' colSpan='" + colspan + "'  style='font-size:18px;padding:3px;'>" + dr["SlideNumber"].ToString() + "</td>");
            sb.Append("</tr>");

            sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
            sb.Append("</tr>");


            if (dr["gross"].ToString() != "")
            {
                sb.Append("<tr valign='top'  >");
                sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:19px;padding:3px;text-transform: uppercase;font-family:Calibri;'>Gross:</td>");
                sb.Append("<td valign='top' colSpan='" + colspan + "'  style='font-size:18px;padding:3px;'>" + dr["gross"].ToString() + "</td>");
                sb.Append("</tr>");
                sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
                sb.Append("</tr>");

            }

            if (dr["microscopic"].ToString() != "")
            {
                sb.Append("<tr valign='top'  >");
                sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:19px;padding:3px;text-transform: uppercase;font-family:Calibri;'>Microscopic:</td>");
                sb.Append("<td valign='top' colSpan='" + colspan + "'  style='font-size:18px;padding:3px; '>" + dr["microscopic"].ToString() + "</td>");
                sb.Append("</tr>");
                sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
                sb.Append("</tr>");
            }



            if (dr["impression"].ToString() != "")
            {
                sb.Append("<tr valign='top'  >");
                sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:19px;padding:3px;text-transform: uppercase;font-family:Calibri;'>Impression:</td>");
                sb.Append("<td valign='top' colSpan='" + colspan + "'  style='font-size:18px;padding:3px;'>" + dr["impression"].ToString() + "</td>");
                sb.Append("</tr>");

                sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
                sb.Append("</tr>");
            }
            StringBuilder sbihc = new StringBuilder();
            sbihc.Append(" SELECT plh.Clone,plh.`TYPE`,plh.Result,plh.Intensity,plh.Pattern,plh.Percentage,plh.interpretation,plh.comments, ");
            sbihc.Append("  plh.antiname,plh.obsvalue");
            sbihc.Append(" FROM  patient_labhisto_immuno plh ");
            sbihc.Append(" where plh.testid='" + dr["test_id"].ToString() + "'  ");
            DataTable dtsbihc = StockReports.GetDataTable(sbihc.ToString());
            if (dtsbihc.Rows.Count > 0)
            {
                sb.Append("<tr valign='top'  >");
                sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:19px;padding:3px;text-transform: uppercase;font-family:Calibri;'>IHC:</td>");
                sb.Append("<td valign='top' colSpan='" + colspan + "'  style='font-size:18px;padding:3px;'>");
                sb.Append("<table  style='border-collapse: collapse;'>");
                sb.Append("<tr>");
                sb.Append("<th class='InvName'>IHC Antibody</th>");
                if (dtsbihc.Select(" Clone<>'' ").Length > 0)
                    sb.Append("<th class='InvName'>Clone</th>");
                if (dtsbihc.Select(" type<>'' ").Length > 0)
                    sb.Append("<th class='InvName'>Type</th>");
                if (dtsbihc.Select(" Result<>'' ").Length > 0)
                    sb.Append("<th class='InvName'>Staining Result</th>");
                if (dtsbihc.Select(" Intensity<>'' ").Length > 0)
                    sb.Append("<th class='InvName'>Intensity</th>");
                if (dtsbihc.Select(" Pattern<>'' ").Length > 0)
                    sb.Append("<th class='InvName'>Pattern</th>");
                if (dtsbihc.Select(" Percentage<>'' ").Length > 0)
                    sb.Append("<th class='InvName'>Percentage</th>");
                sb.Append("</tr>");
                foreach (DataRow dwc in dtsbihc.Rows)
                {
                    sb.Append("<tr>");
                    sb.Append("<td>" + dwc["antiname"].ToString() + "</td>");
                    if (dtsbihc.Select(" Clone<>'' ").Length > 0)
                        sb.Append("<td>" + dwc["Clone"].ToString() + "</td>");
                    if (dtsbihc.Select(" type<>'' ").Length > 0)
                        sb.Append("<td>" + dwc["type"].ToString() + "</td>");
                    if (dtsbihc.Select(" Result<>'' ").Length > 0)
                        sb.Append("<td>" + dwc["Result"].ToString() + "</td>");
                    if (dtsbihc.Select(" Intensity<>'' ").Length > 0)
                        sb.Append("<td>" + dwc["Intensity"].ToString() + "</td>");
                    if (dtsbihc.Select(" Pattern<>'' ").Length > 0)
                        sb.Append("<td>" + dwc["Pattern"].ToString() + "</td>");
                    if (dtsbihc.Select(" Percentage<>'' ").Length > 0)
                        sb.Append("<td>" + dwc["Percentage"].ToString() + "</td>");
                    sb.Append("</tr>");
                }
                sb.Append("</table>");
                sb.Append("</td>");
                sb.Append("</tr>");
                sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
                sb.Append("</tr>");
                if (dtsbihc.Rows[0]["comments"].ToString() != "")
                {
                    sb.Append("<tr valign='top'  >");
                    sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:19px;padding:3px;text-transform: uppercase;font-family:Calibri;'>IHC Comment:</td>");
                    sb.Append("<td valign='top' colSpan='" + colspan + "'  style='font-size:18px;padding:3px;text-align: justify;'>" + dtsbihc.Rows[0]["comments"].ToString() + "</td>");
                    sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
                    sb.Append("</tr>");
                }
                if (dtsbihc.Rows[0]["interpretation"].ToString() != "")
                {
                    sb.Append("<tr valign='top'  >");
                    sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:19px;padding:3px;text-transform: uppercase;font-family:Calibri;'>Final Diagnosis:</td>");
                    sb.Append("<td valign='top' colSpan='" + colspan + "'  style='font-size:18px;padding:3px;'>" + dtsbihc.Rows[0]["interpretation"].ToString() + "</td>");
                    sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
                    sb.Append("</tr>");
                }
            }

            if (dr["advice"].ToString() != "")
            {
                sb.Append("<tr valign='top'  >");
                sb.Append("<td valign='top' colSpan='1' style='font-weight:bold;font-size:19px;padding:3px;text-transform: uppercase;font-family:Calibri;'>Advice:</td>");
                sb.Append("<td valign='top' colSpan='" + colspan + "'  style='font-size:18px;padding:3px;'>" + dr["advice"].ToString() + "</td>");
                sb.Append("</tr>");

                sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
                sb.Append("</tr>");



            }

            if (dr["detail"].ToString() != "")
            {
                string uploadedimgpath = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/" + Request.Url.AbsolutePath.Split('/')[1] + "/";
                string img = dr["detail"].ToString().Replace("../../", uploadedimgpath);



                sb.Append("<td valign='top' colSpan='" + dtLabReport.Rows.Count + "'  style='font-size:19px;padding:5px;'>" + img + "</td>");
                sb.Append("</tr>");

                sb.Append("<tr valign='top' style='height:12px;' ><td style='border:0px;'>&nbsp;</td>");
                sb.Append("</tr>");
            }

            //Observation wise Interpretation
            if (StripHTML(Util.GetString(dr["ObsInterpretation"])).Trim() != "")
            {
                sb.Append("<tr valign='top'>");
                sb.Append("<td colSpan='" + dtLabReport.Rows.Count + "'>" + dr["ObsInterpretation"].ToString() + "</td>");
                sb.Append("</tr>");
            }
            if (StripHTML(Util.GetString(dr["Description"])).Trim() != "")
            {
                sb.Append("<tr valign='top'>");
                sb.Append("<td colSpan='" + dtLabReport.Rows.Count + "'>" + dr["Description"].ToString() + "</td>");
                sb.Append("</tr>");
            }



            // Page Break After 








            // Adding Interpretaion

            if ((_LastRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) + 1]["Test_ID"].ToString() != dr["Test_ID"].ToString())
                &&
                (StripHTML(Util.GetString(dr["Interpretation"])).Trim() != "")
                )
            {


                if (Util.GetString(dr["Interpretation"]).Trim() != "" && Util.GetString(dr["Interpretation"]).Trim() != "<br/>" && Util.GetString(dr["Interpretation"]).Trim() != "<br />")
                {


                    sb.Append("<tr valign='top'>");
                    sb.Append("<td style='padding:8px;'  colSpan='" + dtLabReport.Rows.Count + "'><br/><b>Comment:</b><br/>" + dr["Interpretation"].ToString() + "</td>");
                    sb.Append("</tr>");
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
                    sb.Append("<td style='padding:8px;' colSpan='" + dtLabReport.Rows.Count + "'>" + dr["Comments"].ToString() + "</td>");
                    sb.Append("</tr>");
                }
            }






            drcurrent = dtObs.Rows[dtObs.Rows.IndexOf(dr)];

            //SetHeader(page1);
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
                    sb.Append("<tr><td class='Department'  colSpan='" + dtLabReport.Rows.Count + "' style='border:0px;'>&nbsp;</td></tr>");
                    sb.Append("<tr><td class='Department'  colSpan='" + dtLabReport.Rows.Count + "' style='border-top:1px solid black;border-left:0px;border-right:0px;border-bottom:0px;text-align:center;'>*** End Of Report ***</td></tr>");
                    sb.Append("<tr><td style='border:0px;' colSpan='" + dtLabReport.Rows.Count + "'>");
                    string pendingtest = StockReports.ExecuteScalar(@"SELECT ifnull(GROUP_CONCAT(NAME SEPARATOR ', '),'') FROM `patient_labinvestigation_opd` plo
INNER JOIN investigation_master im ON plo.investigation_id=im.investigation_id
WHERE `LedgertransactionNo`='" + drcurrent["LabNo"].ToString() + "' AND approved=0 AND isreporting=1");

                    DataRow[] list = dtObs.Select("LabNo ='" + drcurrent["LabNo"].ToString() + "' and Approved=1");
                    if (list.Length > 0)
                    {
                        DataTable dataTable = list.CopyToDataTable();

                        DataView dv = dataTable.DefaultView.ToTable(true, "ApprovedBy").DefaultView;
                        dv.Sort = "ApprovedBy asc";
                        DataTable deptapp = dv.ToTable();
                        DataView dv1 = dataTable.DefaultView.ToTable(true, "ForwardBy").DefaultView;
                        dv1.Sort = "ForwardBy asc";
                        DataTable deptapp1 = dv1.ToTable();
                        StringBuilder sbimg = new StringBuilder();

                        if (pendingtest != "")
                        {
                            sbimg.Append("<span style='font-size:13px;'>Result/s to Follow:<br/>" + pendingtest + "<br/></span>");

                        }
                        sbimg.Append("<div style='width:800px;page-break-inside:avoid;'>");
                        foreach (DataRow st in deptapp1.Rows)
                        {
                            if (isSign(st["ForwardBy"].ToString()))
                            {
                                string imgname = serverPath + "Design/opd/signature/" + Util.GetString(st["ForwardBy"]) + ".jpg";
                                sbimg.Append("<img style='float:left;padding-right:10px;' src='" + imgname + "'");
                                sbimg.Append(" />");
                            }
                        }
                        foreach (DataRow st in deptapp.Rows)
                        {
                            if (isSign(st["ApprovedBy"].ToString()))
                            {
                                string imgname =string.Concat( serverPath , "Design/opd/signature/" , Util.GetString(st["ApprovedBy"]) + ".jpg");
                                sbimg.Append("<img style='float:left;padding-right:10px;' src='" + imgname + "'");
                                sbimg.Append(" />");
                            }
                        }
                        sbimg.Append("</div>");
                        sb.Append(sbimg);
                    }
                }
            }
            sb.Append("</td></tr>");
            sb.Append("</table></div>");
            html1LayoutInfo = null;
            AddContent(sb.ToString(), drcurrent, _LastRow);
            SetFooter(tempDocument.Pages[tempDocument.Pages.Count - 1]);
        }
        mergeDocument();
        foreach (DataRow drAtt in dtAttachment.Rows)
        {
            string _pdf = "";
            if (drAtt["FileUrl"].ToString().EndsWith(".pdf"))
            {
                _pdf = Server.MapPath("~/Uploaded Report/") + drAtt["FileUrl"].ToString();
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
                        ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('" + _pdf + "');", true);

                    }
                    //document.Pages.AddPage(); 
                }
            }
        }
        //151713 urine 
        //PdfPage page12 = document.AddPage(PdfPageSize.A4, new PdfDocumentMargins(5), PdfPageOrientation.Portrait);
        //SetHeader(page12);
        //document.AddPage(page12);
        try
        {
            // write the PDF document to a memory buffer
            byte[] pdfBuffer = document.WriteToMemory();

            // inform the browser about the binary data format

            if (Util.GetString(Request.QueryString["app"]) == "1")
            {
                HttpContext.Current.Response.AddHeader("Content-Disposition", String.Format("attachment; filename=PdfText.pdf; size={0}",
                           pdfBuffer.Length.ToString()));
                //  print();
            }
            else
            {
                HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");
            }
            //// let the browser know how to open the PDF document and the file name
            //HttpContext.Current.Response.AddHeader("Content-Disposition", String.Format("attachment; filename=PdfText.pdf; size={0}",
            //            pdfBuffer.Length.ToString()));



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
        foreach (PdfPage p in tempDocument.Pages)
        {




            System.Drawing.Font pageNumberingFont =
          new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);






            PdfText pageNumberingText = new PdfText(PageWidth - 50, FooterHeight + 20, String.Format("                 Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
            pageNumberingText.ForeColor = System.Drawing.Color.Black;
            if (p.Footer == null)
            {
                p.CreateFooterCanvas(FooterHeight);


            }

            p.Footer.Layout(pageNumberingText);

            document.Pages.AddPage(p);
            pageno++;
        }
        tempDocument = new PdfDocument();
    }

    public string MakeHeader(string Header, DataRow dr_Detail)
    {

        if (dtReportHeader.Select("PanelId='" + dr_Detail["Panel_id"].ToString() + "'").Length > 0)
            Header = dtReportHeader.Select("PanelId='" + dr_Detail["Panel_id"].ToString() + "'")[0]["ReportHeader"].ToString();
        else
            Header = dtReportHeader.Select("PanelId='78'")[0]["ReportHeader"].ToString();

        if (Util.GetString(drcurrent["Interface_companyName"]).ToLower() == "insta")
        {
            string SponsorNameFull = Util.GetString(drcurrent["OtherReferLab"]);
            string SponsorNameFirstPart = string.Empty;
            string SponsorNameSecordPart = string.Empty;
            if (SponsorNameFull.Trim() != "")
            {
                if (SponsorNameFull.Length <= 31)
                {
                    SponsorNameFirstPart = SponsorNameFull;
                }
                else
                {
                    SponsorNameFirstPart = SponsorNameFull.Substring(0, 31);
                    SponsorNameSecordPart = SponsorNameFull.Substring(31);
                }
                Header = Header.Replace("Client Name", "Sponsor Name").Replace("{Company_Name}", SponsorNameFirstPart).Replace("Client Code", "&nbsp;").Replace(": {Panel_Code}", "&nbsp;" + SponsorNameSecordPart);
            }
            else
            {
                Header = Header.Replace("Client Name", "&nbsp;").Replace(": {Company_Name}", "&nbsp;").Replace("Client Code", "&nbsp;").Replace(": {Panel_Code}", "&nbsp;");
            }

            if (Util.GetString(drcurrent["OtherReferLab"]) != "")
                Header = Header.Replace("Client Name", "Referred By");

            if (Util.GetString(drcurrent["CorporateIDCard"]).Trim() != "")
            {
                Header = Header.Replace("IP/OP NO", "Emp/Auth/TPA ID").Replace("{HLMOPDIPDNo}", Util.GetString(drcurrent["CorporateIDCard"]).Trim());
            }
            Header = Header.Replace("IP/OP NO", "&nbsp;").Replace(": {HLMOPDIPDNo}", "&nbsp;");
            Header = Header.Replace("{LabNo}", Util.GetString(drcurrent["LedgerTransactionNo_Interface"]).Trim());
        }
        for (int i = 0; i < dtObs.Columns.Count; i++)
        {
            Header = Header.Replace("{" + dtObs.Columns[i].ColumnName + "}", dr_Detail[i].ToString());
        }

        StringBuilder sb = new StringBuilder();
        sb.Append(sbCss.ToString());
        sb.Append("<div class='divContent' ><table class='tbData'>");





        sb.Append("<tr valign='top' ><th class='Department'   colSpan='" + dtLabReport.Rows.Count + "'  >DEPARTMENT OF " + drcurrent["Dept"].ToString() + "</th></tr>");

        if (drcurrent["ispackage"].ToString() == "1")
        {
            sb.Append("<tr  valign='top'>");

            sb.Append("<th class='Department'   colSpan='" + dtLabReport.Rows.Count + "'>" + drcurrent["packagename"].ToString() + "</th>");

            sb.Append("</tr>");


        }


        sb.Append("</table></div>");


        return Header + "" + sb.ToString();



    }


    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        FooterHeight = Util.GetInt(drcurrent["ReportFooterHeight"].ToString());
        PdfPage page1 = eventParams.PdfPage;
        //set background iamge in pdf report.
        if (HeaderImage == true)
        {
            HeaderImg = "App_Images/ReportBackGround/" + Util.GetString(drcurrent["ReportBackGroundImage"].ToString());
            page1.Layout(getPDFImage(0, 0, HeaderImg));
        }
        if (Util.GetInt(drcurrent["AAALogo"].ToString()) == 1)
        {
            page1.Layout(getPDFImagewithresizeWaterMarkLogo(187, 320, 220, "App_Images/AAALogo.png"));
        }
        //if (Util.GetString(drcurrent["ReportStatus"].ToString()) == "Provisional Report")
        //{
        //    System.Drawing.Font sysFontBold = new System.Drawing.Font("Arial",
        //60, System.Drawing.FontStyle.Regular,
        //         System.Drawing.GraphicsUnit.Point);
        //    PdfText titleRotatedText = new PdfText(50, 550, "Provisional Report", sysFontBold);
        //    titleRotatedText.ForeColor = System.Drawing.Color.LightGray;
        //    titleRotatedText.RotationAngle = 45;
        //    page1.Layout(titleRotatedText);
        //}       
            System.Drawing.Font sysFontBold = new System.Drawing.Font("Arial",
        60, System.Drawing.FontStyle.Regular,
                 System.Drawing.GraphicsUnit.Point);
            PdfText titleRotatedText = new PdfText(50, 550, "Amended Report", sysFontBold);
            titleRotatedText.ForeColor = System.Drawing.Color.LightGray;
            titleRotatedText.RotationAngle = 45;
            page1.Layout(titleRotatedText);
        
        SetHeader(page1);
        page1.CreateFooterCanvas(FooterHeight);
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
            System.Drawing.Font sysFontBold = new System.Drawing.Font("Arial",
            6, System.Drawing.FontStyle.Regular,
                    System.Drawing.GraphicsUnit.Point);
            PdfText titleRotatedText = new PdfText(2, -20, "ITDOSE INFOSYSTEMS PVT. LTD.", sysFontBold);
            titleRotatedText.ForeColor = System.Drawing.Color.Gray;
            titleRotatedText.RotationAngle = 90;
            page1.Layout(titleRotatedText);
        }
    }
    private void SetHeader(PdfPage page)
    {
        // create the document header
        HeaderHeight = Util.GetInt(drcurrent["ReportHeaderHeight"].ToString());
        XHeader = Util.GetInt(drcurrent["ReportHeaderXPosition"].ToString());
        YHeader = Util.GetInt(drcurrent["ReportHeaderYPosition"].ToString());
        if (drcurrent["ispackage"].ToString() == "1")
        {
            HeaderHeight = Util.GetInt(drcurrent["ReportHeaderHeight"].ToString());
        }
        else
        {
            HeaderHeight = Util.GetInt(drcurrent["ReportHeaderHeight"].ToString()) - 20;
        }
        page.CreateHeaderCanvas(HeaderHeight);
        // layout HTML in header
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakeHeader("", drcurrent), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        // page.Header.Layout(headerHtml);
        if (drcurrent["isnabl"].ToString().Trim() == "1")
        {
            // To Set NABL Logo And Its Position
            if (Util.GetString(drcurrent["NablLogoPath"]).Trim() != "")
                page.Header.Layout(getPDFImagewithresize1(270, 15, 55, "App_Images" + drcurrent["NablLogoPath"].ToString().Trim()));
        }
        else if (drcurrent["isnabl"].ToString().Trim() == "2")
        {
            // To Set Cap Logo And Its Position
            if (Util.GetString(drcurrent["CapLogoPath"]).Trim() != "")
                page.Header.Layout(getPDFImagewithresize(350, 22, "App_Images" + drcurrent["CapLogoPath"].ToString().Trim()));
        }
        page.Header.Layout(headerHtml);
    }
    private void SetFooter(PdfPage page)
    {
        if (page.Footer != null)
        {
            //PdfText pdf11 = new PdfText(20, 0, "Technician ID:" + drcurrent["ResultEnteredBy"].ToString(), new Font("Times New Roman", 12));
            //page.Footer.Layout(pdf11);
            page.Footer.Layout(getPDFImageforbarcode(10, 0, drcurrent["LabNo"].ToString()));

            PdfText pdf11 = new PdfText(22, 23, "SIN No:" + drcurrent["barcodeno"], new Font("Times New Roman", 10));
            page.Footer.Layout(pdf11);
            if (Util.GetString(drcurrent["type1"]).Trim() == "PCC" && (Util.GetString(drcurrent["TagProcessingLabID"]).Trim() != Util.GetString(drcurrent["TestCentreID"]).Trim()))
            {
                page.Footer.Layout(new PdfText(22, 33, string.Concat("* NOTE – This sample has been processed at our reference lab. For any query, write us to ", Resources.Resource.ClientEmail), new Font("Times New Roman", 7)));
            }
            else if (Util.GetString(drcurrent["type1"]).Trim() != "PCC" && (Util.GetString(drcurrent["centreid"]).Trim() != Util.GetString(drcurrent["TestCentreID"]).Trim()))
            {
                page.Footer.Layout(new PdfText(22, 33, string.Concat("* NOTE – This sample has been processed at our reference lab. For any query, write us to ", Resources.Resource.ClientEmail), new Font("Times New Roman", 7)));
            }
        }
    }
    PdfText EndOfReport(float X, float Y)
    {
        return new PdfText(X, Y, "*** End Of Report ***", new Font("Times New Roman", 12));
    }

    bool isSign(string imgID)
    {
        return (File.Exists(Server.MapPath("~/Design/opd/signature/") + "" + imgID + ".jpg"));
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
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Server.MapPath("~/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private PdfImage getPDFImagewithresize(float X, float Y, string SignImg)
    {
        // PdfImage transparentResizedPdfImage = new PdfImage(X, Y, 60, Server.MapPath("~/" + SignImg));
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Server.MapPath("~/" + SignImg));
        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private PdfImage getPDFImagewithresize1(float X, float Y, float Z, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Z, Server.MapPath("~/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private PdfImage getPDFImagewithresizeWaterMarkLogo(float X, float Y, float Z, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Z, Server.MapPath("~/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    private PdfImage getPDFImageforabnormal(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, 70, Server.MapPath("~/" + SignImg));

        transparentResizedPdfImage.PreserveAspectRatio = true;
        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }

    private PdfImage getPDFImageforbarcode(float X, float Y, string labno)
    {
        string image = "";

        image = new Barcode_alok().Save(labno).Trim();



        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Base64StringToImage(image));

        transparentResizedPdfImage.PreserveAspectRatio = true;

        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
        //imageLayoutInfo = page1.Layout(transparentResizedPdfImage);
    }
    //convert bytearray to image
    public System.Drawing.Image byteArrayToImage(byte[] byteArrayIn)
    {
        using (MemoryStream mStream = new MemoryStream(byteArrayIn))
        {
            //System.Drawing.Image.FromStream(mStream).Save(@"E:\abcnew.jpg");
            return System.Drawing.Image.FromStream(mStream, true, true);
        }
    }

    public System.Drawing.Image Base64StringToImage(string base64String)
    {
        byte[] imageBytes = Convert.FromBase64String(base64String.Replace("data:image/png;base64,", ""));
        MemoryStream memStream = new MemoryStream(imageBytes, 0, imageBytes.Length);

        memStream.Write(imageBytes, 0, imageBytes.Length);
        System.Drawing.Image image = System.Drawing.Image.FromStream(memStream);
        Bitmap newImage = new Bitmap(240, 30);




        if (AllGlobalFunction.showqrcodeinprintlabreport == "Y")
        {
            using (Graphics graphics = Graphics.FromImage(newImage))
                graphics.DrawImage(image, 0, 0, 120, 300);
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
        TestID = TestID + ",";
        string[] tags = TestID.Replace("'", "").Split(',');
        if (isOnlinePrint != "1")
            tags = tags.Take(tags.Count() - 1).ToArray();

        string[] paramNames = tags.Select(
              (s, i) => "@tag" + i.ToString()).ToArray();


        string inClause = string.Join(", ", paramNames);
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        StringBuilder sb = new StringBuilder();


        sb.Append("    SELECT * FROM (SELECT   ");
        sb.Append("               t.*,  ");
        sb.Append("    (SELECT CASE WHEN IsPackage='1' AND PrintInterPackage='1' THEN  ");
        sb.Append("   Interpretation WHEN isPackage='0' AND PrintInterTest='1' THEN Interpretation ELSE '' END   ");
        sb.Append("  FROM investigation_master_interpretation WHERE `Investigation_ID`=im.`Investigation_ID` AND   ");
        sb.Append("  centreid=1 AND macid=IF(t.MachineID='0','1',t.MachineID) LIMIT 1 ) AS Interpretation  ");
        sb.Append("          ,'3' ReportType,CONCAT(IF(t.IsPackage=1,'',''),    ");
        sb.Append("           IF(IM.PrintSampleName=0,IF(IFNULL(itm.Inv_ShortName,'')!='',IM.Name,IM.Name),im.name)) AS TestName,im.method,im.FileLimitationName, scm.deptinterpretaion,  ");
        sb.Append("    ");
        sb.Append("           otm.Name AS Dept,otm.isVisible AS DeptVisible,    ");
        sb.Append("            IM.Print_sequence AS Print_Sequence_Investigation,     ");
        sb.Append("    ");
        sb.Append("            im.PrintSeparate,im.printsamplename,   ");
        sb.Append("           IM.Description AS d1,t.labPriorty Priorty,'N' IsParent,im.printHeader  AS invHeader ,   ");
        sb.Append("           '' SampleTypeID,cma.Centre CentreName,cma.Address,cma.Landline CentreLandline,cma.Mobile CentreMobile,cma.Email   ");
        sb.Append("           CentreEmail,cma.NablLogoPath,cma.CapLogoPath,'' printOrder ,cma.type1,  ");
        sb.Append("           IFNULL((SELECT isNABL FROM `investiagtion_isnabl` WHERE Investigation_ID=im.Investigation_Id AND centreid=t.CentreID),0)isNABL,   ");
        sb.Append("           otm.Print_Sequence Print_Sequence_Dept,IFNULL(t.labPriorty,9999)printOrder_labObservation1,labPriorty printOrder_labObservation2    ");
        sb.Append("           ,otm.ObservationType_ID,pnl.`Panel_Code`,   ");
        sb.Append(" pnl.ReportHeaderHeight,pnl.ReportHeaderXPosition,pnl.ReportHeaderYPosition,pnl.ReportFooterHeight,pnl.ReportBackGroundImage,pnl.AAALogo,pnl.TagProcessingLabID  ");
        sb.Append("           FROM (        ");
        sb.Append("           SELECT     ");
        sb.Append("           pli.LedgerTransactionNo AS LabNo,pli.test_id PLOID,pli.test_id,IF(lt.HomeVisitBoyID='N/A','N/A',(SELECT  flm.NAME FROM feildboy_master flm WHERE flm.FeildBoyID=lt.HomeVisitBoyID)) FieldExe,  ");
        sb.Append("           lt.PName,lt.Age,pli.BarcodeNo,LEFT(lt.Gender,1)Gender,mic.Specimen_Title Specimen_Title, lt.OtherReferLab,lt.Interface_companyName,lt.CorporateIDCard,lt.LedgerTransactionNo_Interface,  ");
        sb.Append("           DATE_FORMAT(pli.date,'%d/%b/%Y %I:%i%p') DateEnrolled,lt.Patient_ID,'' Description,pli.SampleBySelf,   ");
        sb.Append("           DATE_FORMAT(pli.ResultEnteredDate,'%d-%b-%y')AS ResultDate, pli.ResultEnteredBy,if(pli.ForwardBy=pli.ApprovedBy,'',pli.ForwardBy) ForwardBy, IF(pli.Approved=0,'Provisional Report','Final Report')ReportStatus, ");
        sb.Append("    ");
        sb.Append("   mic.Detail, mic.Gross ,mic.Microscopic, mic.Impression,mic.Advice,mic.ClinicalHistory ");

        sb.Append("  ,pli.Investigation_ID, pli.SlideNumber,pli.TestCentreID,  ");
        sb.Append("                DATE_FORMAT(pli.SampleCollectionDate,'%d/%b/%Y %I:%i%p')SampleDate,   ");
        sb.Append("           DATE_FORMAT(pli.SampleReceiveDate,'%d/%b/%Y  %I:%i%p')ReceiveDate,   ");
        sb.Append("           DATE_FORMAT(pli.Date,'%d-%b-%y %h:%i %p')DATE,         ");
        sb.Append("           IF(pli.Approved=1,1,0)Approved,(SELECT comments FROM patient_labinvestigation_opd_comments ploc WHERE ploc.Test_ID = pli.Test_ID)comments,    ");
        sb.Append("            IF(pli.isHold=1,'Hold',    ");
        sb.Append("            IF(pli.Approved=1,'Approved',IF(pli.isForward=1,'Forward',''))) AS MYApproved  ");
        sb.Append("               ");
        sb.Append("            ,       DATE_FORMAT(pli.ApprovedDate,'%d/%b/%Y %I:%i%p')ApprovedDate,   ");
        sb.Append("            pli.ApprovedBy ApprovedBy,        DATE_FORMAT(pli.ResultEnteredDate,'%d/%b/%Y %I:%i%p')ResultEnteredDate,   ");
        sb.Append("             pli.ResultEnteredName,0 Child_Flag,   ");
        sb.Append("             ''  labPriorty,'' DisplayReading,IF(pli.IsPackage=1,pli.PackageName,'') PackageName, pli.IsPackage,  ");
        sb.Append("             '' DispatchMode   ");
        sb.Append("    ");
        sb.Append("             ,'' ObsInterpretation ,  ");
        sb.Append("            '' MethodName,DATE_FORMAT(pli.sampleCollectiondate,'%d/%b/%Y %I:%i%p')SegratedDate,DATE_FORMAT(NOW(),'%d/%b/%Y %I:%i%p')PrintDate,'0' IsCommentField ,'0' IsOrganism,'' AbnormalValue,'' IsBold,'' IsUnderLine,'' `IsMic`,  ");
        sb.Append("           '' SepratePrint,   ");
        sb.Append("            1 isborder,0 MachineID  , lt.centreid,lt.Panel_ID,Concat('Dr.',lt.`DoctorName`) ReferDoctor, IF(lt.OtherReferLab='',left(lt.panelname,34),lt.OtherReferLab) Company_Name ,'' Company_code,'' Company_add,lt.`HLMPatientType`,lt.`HLMOPDIPDNo`,pli.SampleTypeName  ");
        sb.Append("            FROM patient_labobservation_histo_notapprove mic     ");
        sb.Append("             INNER JOIN patient_labInvestigation_opd_notApprove pli ON pli.Test_ID = mic.Test_ID   and  pli.UnapproveDate = mic.UnapproveDate  and pli.UnapproveDate=@UnapproveDate  ");
        sb.Append("            AND pli.Test_ID IN ({0})  AND pli.Result_Flag = 1 AND pli.ishold=0   ");
        sb.Append("            INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID=pli.LedgerTransactionID   ");
        sb.Append("              ");
        sb.Append("            ");
        sb.Append("             )t    ");
        sb.Append("    ");
        sb.Append("           INNER JOIN investigation_master IM ON IM.Investigation_Id = t.Investigation_ID     ");
        sb.Append("           INNER JOIN f_itemmaster itm ON itm.Type_ID = IM.Investigation_ID       ");
        sb.Append("           INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=itm.`SubCategoryID` AND scm.`CategoryID`='LSHHI3'     ");
        sb.Append("           INNER JOIN investigation_observationtype iot ON iot.Investigation_ID=im.Investigation_Id     ");
        sb.Append("           INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_Id      ");
        sb.Append("           INNER JOIN centre_master cma ON cma.CentreID = t.CentreId     ");
        sb.Append("           INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=t.Panel_ID     ");
        sb.Append("            ORDER BY LabNo,IFNULL(printOrder,9999),labPriorty   )ttt   ");
        //System.IO.File.WriteAllText (@"D:\Shat\aa.txt", sb.ToString());

        MySqlCommand cmd1 = new MySqlCommand(string.Format(sb.ToString(), inClause), con);
        //using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), inClause)),con)
        //{
        for (int i = 0; i < paramNames.Length; i++)
        {
            cmd1.Parameters.AddWithValue(paramNames[i], tags[i]);
        }
        cmd1.Parameters.AddWithValue("@UnapproveDate", Request.QueryString["unid"]);
        MySqlDataAdapter da = new MySqlDataAdapter();
        cmd1.CommandType = CommandType.Text;



        da.SelectCommand = cmd1;
        da.Fill(dtObs);
        da.Dispose();
        cmd1.Dispose();


        //  dtObs = StockReports.GetDataTable(sb.ToString());

        if (dtObs.Rows.Count > 0)
        {
            dtReportHeader = StockReports.GetDataTable(" SELECT * FROM centre_Panel WHERE `ReportHeader` IS NOT NULL ");

        }

        //dtAttachment = StockReports.GetDataTable(@"SELECT test_id, CONCAT(DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`) FileUrl FROM patient_labinvestigation_attachment_report  WHERE Test_ID IN ({0})   ");


        string sbAttachmentReport = "SELECT test_id, CONCAT(DATE_FORMAT(`dtEntry`,'%Y%m%d'),'/', `FileUrl`) FileUrl FROM patient_labinvestigation_attachment_report  WHERE Test_ID IN ({0})   ";

        MySqlCommand cmd3 = new MySqlCommand(string.Format(sbAttachmentReport.ToString(), inClause), con);
        for (int i = 0; i < paramNames.Length; i++)
        {
            cmd3.Parameters.AddWithValue(paramNames[i], tags[i]);
        }

        MySqlDataAdapter da2 = new MySqlDataAdapter();
        cmd3.CommandType = CommandType.Text;
        da2.SelectCommand = cmd3;
        da2.Fill(dtAttachment);
        da2.Dispose();
        cmd3.Dispose();
        if (dtAttachment.Rows.Count > 0)
        {
            dtObs.Clear();
        }

        if ((isOnlinePrint != "1") && (isEmail != "1"))
        {

            string PLO = "update patient_labinvestigation_opd set isPrint='1' where Test_ID IN ({0})  and isPrint='0' and Approved='1' ";
            MySqlCommand cmd4 = new MySqlCommand(string.Format(PLO, inClause), con);
            for (int i = 0; i < paramNames.Length; i++)
            {
                cmd4.Parameters.AddWithValue(paramNames[i], tags[i]);
            }
            cmd4.ExecuteNonQuery();
            cmd4.Dispose();
        }

        con.Close();
        con.Dispose();
    }




}
