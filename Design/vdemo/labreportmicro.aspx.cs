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
using MessagingToolkit.QRCode.Codec;

// using MessagingToolkit.QRCode.Codec;
public partial class Design_Lab_labreportmicro : System.Web.UI.Page
{
    public string serverPath = string.Empty;
    DataTable dtObs = new DataTable();
    DataTable dtLabReport = new DataTable();
    DataTable dtOrganismStyle = new DataTable();
    DataTable dtReportHeader = new DataTable();
    DataTable dtAttachment = new DataTable();

    DataRow drcurrent;
    PdfLayoutInfo html1LayoutInfo;
    string reportnumber = string.Empty;

    //Report Variables

    public string TestID = string.Empty;
    public List<string> Test_ID = new List<string>();
    string PHead = "0";
    public string LeftMargin = string.Empty;
    public string isOnlinePrint = "0";
    public string isEmail = string.Empty;
    int colspan = 4;
    int colspantd = 4;
    int aci = 65;
    public string app = "0";
    //Page Property

    int MarginLeft = 20;
    int MarginRight = 30;
    int PageWidth = 526;
    int BrowserWidth = 800;
    bool showItdose = true;




    //Header Property
    int HeaderHeight = 0;//207
    int XHeader = 0;//20
    int YHeader = 0;//80
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
    bool signatureonend = true;
    string barcodeno = "";




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

   string roleid = "";
    string PrintedByIDMain = "";
    string PrintedByNameMain = "";


    protected void Page_Load(object sender, EventArgs e)
    {

        serverPath = Server.MapPath("~/"); //Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/" + Request.Url.AbsolutePath.Split('/')[1] + "/";
         try
            {
                roleid = Common.Decrypt(Request.QueryString["RoleId"]);
                PrintedByIDMain = Common.Decrypt(Request.QueryString["PrintedByID"]);
                PrintedByNameMain = Common.Decrypt(Request.QueryString["PrintedByName"]);
            }
            catch
            {
            }
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
        //isOnlinePrint = Util.GetString(Request.QueryString["isOnlinePrint"]);

        reportnumber = Util.GetString(Request.QueryString["reportnumber"]);
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
            // string RemoveAdvPanelTest = CheckAdvanceBalRestriction(TestID);
            // if (RemoveAdvPanelTest.Trim() != "")
            // {
            //     string[] rmvTest = RemoveAdvPanelTest.Split('|');
            //     foreach (string st in rmvTest)
            //     {
            //         TestID = TestID.Replace(st, "").Replace(",,", ",");
            //    }
            //     ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('Advance Panel Credit Limit Exceeds, Report Cannot be Printed');", true);
            //     return;
            // }
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
            string PrintDueReport = StockReports.ExecuteScalar("SELECT PrintDueReport  from f_rolemaster  Where Active=1 and ID='" + Util.GetInt(Session["RoleID"]) + "' ");

            if (PrintDueReport != "1")
          //  if (Util.GetInt(roleid) != 177)// open For Adminsitartor Role If Due
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
        sbCss.Append(".divContent{width:800px;border:0.5px solid black;margin-bottom:0px;} ");//page-break-inside:avoid; 
        sbCss.Append(".tbData{width:800px;border-collapse: collapse;  } .tbData tr td{border: 1px solid black;}");


        sbCss.Append(".tbData th{font-weight:bold;padding-bottom:2px;} .tbData tr th{border: 1px solid black;}");
        sbCss.Append("table.tbOrganism { border-collapse: collapse;}");
        sbCss.Append("table.tbOrganism, td.tbOrganism, th.tbOrganism{  border: 1px solid black;}");



        foreach (DataRow dr in dtTemp.Rows)
        {

            sbCss.Append("." + dr["Name"].ToString() + "{font-family:" + dr["FName"].ToString() +
            ";font-size:" + dr["Fsize"].ToString() + "px;text-align:" + dr["Alignment"].ToString() +
            ";" + (dr["Bold"].ToString() == "Y" ? "font-weight:bold;" : "") +
            "" + (dr["Under"].ToString() == "Y" ? "text-decoration:underline;" : "") +
            " " + (dr["Italic"].ToString() == "Y" ? "font-style:italic;" : "") + "Height:" + dr["Height"].ToString() + ";}");

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
       // AzureStorage az = new AzureStorage();


        string OrganismName = "";
        string culturedata = "";
        string isheadingprint = "";
        int ismicrofound = 0;
        string microdata = "";
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
                (dr["SepratePrint"].ToString() == "1") ||
                (dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["test_id"].ToString() != dr["test_id"].ToString() && dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["TestCentreID"].ToString() != dr["TestCentreID"].ToString() && dr["isnabl"].ToString() == "1")
        ||
                Util.GetDateTime(dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["ApprovedDate"]).Date != Util.GetDateTime(dr["ApprovedDate"].ToString()).Date
                ||
                dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["PackageName"].ToString() != dr["PackageName"].ToString()
                ||
                 dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["test_id"].ToString() != dr["test_id"].ToString()
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

                        sb.Append("<tr><td class='Department'  colSpan='" + colspan + "' style='border:0px;'>&nbsp;</td></tr>");
                        sb.Append("<tr><td class='Department'  colSpan='" + colspan + "' style='border-top:1px solid black;border-left:0px;border-right:0px;border-bottom:0px;text-align:center;'>*** End Of Report ***</td></tr>");
                        sb.Append("<tr><td style='border:0px;' colSpan='" + colspan + "'>");
                        string pendingtest = StockReports.ExecuteScalar(@"SELECT ifnull(GROUP_CONCAT(NAME SEPARATOR ', '),'') FROM `patient_labinvestigation_opd` plo
INNER JOIN investigation_master im ON plo.investigation_id=im.investigation_id
WHERE `LedgertransactionNo`='" + drcurrent["LabNo"].ToString() + "' AND approved=0 AND isreporting=1 and IsSampleCollected<>'R'");

                        DataRow[] list = dtObs.Select("LabNo ='" + drcurrent["LabNo"].ToString() + "' and Approved=1");
                        if (list.Length > 0)
                        {
                            DataTable dataTable = list.CopyToDataTable();

                            DataView dv = dataTable.DefaultView.ToTable(true, "ApprovedBy").DefaultView;
                            dv.Sort = "ApprovedBy asc";
                            DataTable deptapp = dv.ToTable();
                            StringBuilder sbimg = new StringBuilder();

                            if (pendingtest != "")
                            {
                                sbimg.Append("<span style='font-size:13px;'>Result/s to Follow:<br/>" + pendingtest + "<br/></span>");

                            }
                            sbimg.Append("<div style='width:800px;page-break-inside:avoid;'>");
                            foreach (DataRow st in deptapp.Rows)
                            {

                                if (isSign(st["ApprovedBy"].ToString()))
                                {
                                    string imgname = serverPath + "Design/opd/signature/" + Util.GetString(st["ApprovedBy"]) + ".jpg";
                                    //string imgname = az.fileShowFromAzure(Util.GetString(st["ApprovedBy"]), Util.GetString(st["ApprovedBy"]) + ".jpg", "doctorsignature");
                                    sbimg.Append("<img style='float:left;padding-right:10px;' src='" + imgname + "'");
                                    sbimg.Append(" />");

                                }
                                else
                                {
                                    throw new Exception("Signature not found in Azure");
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

                OrganismName = "";
                culturedata = "";
                isheadingprint = "";
                ismicrofound = 0;
                microdata = "";



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
            if ((_FirstRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) - 1]["Test_ID"].ToString() != dr["Test_ID"].ToString()))
            {
                sb.Append("<tr valign='top'>");
                //sb.Append("<th style='padding-left:5px; width:50px;'></th>");
                sb.Append("<th class='InvName' colSpan='" + colspantd + "' style='padding-left:15px;' >TEST NAME : <span style='font-weight:normal'>");
                if (Util.GetString(dr["type1"]).Trim() == "PCC" && (Util.GetString(dr["TagProcessingLabID"]).Trim() != Util.GetString(dr["TestCentreID"]).Trim()))
                {
                    sb.Append("*" + dr["TestName"].ToString());
                }
                else if (Util.GetString(dr["type1"]).Trim() != "PCC" && (Util.GetString(dr["centreid"]).Trim() != Util.GetString(dr["TestCentreID"]).Trim()))
                {
                    sb.Append("*" + dr["TestName"].ToString());
                }
                else
                {
                    sb.Append(dr["TestName"].ToString());
                }
                sb.Append("</th></tr>");

                sb.Append("<tr valign='top'>");
                //sb.Append("<th style='padding-left:5px; width:50px;'></th>");
                sb.Append("<th  style='padding-left:15px;' colSpan='" + colspantd + "' class='InvName' >SPECIMEN TYPE : <span style='font-weight:normal'>" + dr["sampletypename"].ToString() + "</span>");
                sb.Append("</th></tr>");

                // sb.Append("<tr valign='top'><th style='border:0px;' class='InvName' ><br/></th></tr>");

                //unit and value comment
                //  sb.Append("<tr valign='top'>");
                //sb.Append("<th style='padding-left:5px; width:50px;'></th>");
                // sb.Append("<th style='padding-left:15px; width:350px;' class='InvName'>TEST NAME</td>");
                //  sb.Append("<th style='text-align: center;width:225px;' class='InvName'>Value</td>");
                // sb.Append("<th style='text-align: center;width:225px;' class='InvName'>Unit</td>");
                //  sb.Append("</tr>");


            }

            if (dr["labobservation_id"].ToString() != "0" && dr["value"].ToString() != "")
            {


                if (dr["value"].ToString().ToUpper() == "HEAD")
                {

                    int havechild = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM labobservation_investigation WHERE ParentId='" + dr["labobservation_id"].ToString() + "' AND investigation_id='" + dr["investigation_id"].ToString() + "'"));

                    if (havechild > 0)
                    {

                        int childcount = Util.GetInt(StockReports.ExecuteScalar(@"SELECT COUNT(*) FROM patient_labobservation_opd_mic pom 
INNER JOIN labobservation_investigation loi ON loi.labobservation_id =pom.labobservation_id
AND ParentId='" + dr["labobservation_id"].ToString() + "'  and reporttype='" + reportnumber + "' AND investigation_id='" + dr["investigation_id"].ToString() + "' AND testid='" + dr["test_id"].ToString() + "' AND IFNULL(VALUE,'')<>'' "));
                        if (childcount > 0)
                        {

                            sb.Append("<tr valign='top'>");
                            //sb.Append("<td style='width:50px;font-weight:bold;text-align:center;'>" + getchar(aci) + "</td>");
                            sb.Append("<td style='padding-left:15px;' colSpan='" + colspantd + "' class='InvName' >" + dr["labobservation_name"].ToString().Trim().ToUpper() + "</td>");

                            sb.Append("</tr>");


                            aci++;

                            ismicrofound = 1;
                        }
                    }
                    else
                    {

                        microdata = "<tr valign='top'><td style='padding-left:15px;text-align:center;background-color:lightgray;font-size:19px;' colSpan='" + colspantd + "' class='InvName' >" + dr["labobservation_name"].ToString().Trim().ToUpper() + "</td></tr>";
                        sb.Append(microdata);


                    }
                }
                else
                {




                    if (dr["labobservation_name"].ToString().Trim().ToUpper() == "CULTURE COMMENT")
                    {
                        culturedata += "<tr valign='top'><th style='border:0px;' class='InvName' ><br/></th></tr>";
                        culturedata += "<th  style='padding-left:15px;text-align:center;background-color:lightgray;font-size:19px;' colSpan='" + colspantd + "' class='InvName' >CULTURE";
                        culturedata += "</th></tr>";

                        culturedata += "<tr valign='top'>";
                        culturedata += "<td style='padding-left:15px' class='InvName' colspan='" + colspantd + "' ><span style='font-weight:normal'>" + dr["value"].ToString().Trim().ToUpper() + "</span></td>";


                        culturedata += "</tr>";

                        isheadingprint = "1";
                    }
                    else
                    {
                        sb.Append("<tr valign='top'>");
                        //sb.Append("<td style='padding-left:5px; width:50px;'></td>");
                        sb.Append("<td style='padding-left:30px;width:40% !important;' class='LabObservationName' >" + dr["labobservation_name"].ToString().Trim().ToUpper() + "</td>");
                        sb.Append("<td style='text-align: center;width:30% !important' class='Value'  >" + dr["value"].ToString().Trim().ToUpper() + "</td>");
                        sb.Append("<td style='text-align: center;width:30% !important' class='Unit'>" + dr["Unit"].ToString().Trim().ToUpper() + "</td>");
                        sb.Append("</tr>");
                    }


                }



                if (StripHTML(Util.GetString(dr["labobservationcomment"])).Trim() != "")
                {
                    sb.Append("<tr valign='top'>");
                    sb.Append("<td style='width:50px;font-weight:bold;text-align:left;'>COMMENTS:</td>");
                    sb.Append("<td   style='padding-left:15px;' colSpan='" + colspantd + "'>" + dr["labobservationcomment"].ToString() + "</td>");
                    sb.Append("</tr>");
                }


            }


            if (dr["labobservation_id"].ToString() == "1679" && StripHTML(Util.GetString(dr["labobservationcomment"])).Trim() != "")
            {

                sb.Append("<tr valign='top'><th style='border:0px;' class='InvName' colSpan='" + colspantd + "'><br/></th></tr>");
                sb.Append("<th  style='padding-left:15px;text-align:center;background-color:lightgray;font-size:19px;border:1px solid black;' colSpan='" + colspantd + "' class='InvName' >CULTURE");
                sb.Append("</th></tr>");

                sb.Append("<tr valign='top'>");
                //sb.Append("<td style='width:50px;font-weight:bold;text-align:center;'></td>");
                sb.Append("<td   style='padding-left:15px;' colSpan='" + colspantd + "'>" + dr["labobservationcomment"].ToString() + "</td>");
                sb.Append("</tr>");
            }


            if ((_LastRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) + 1]["Test_ID"].ToString() != dr["Test_ID"].ToString()))
            {


                if (ismicrofound == 0 && microdata != "")
                {
                    sb.Replace(microdata, "");
                }

                StringBuilder newquery = new StringBuilder();
                newquery.Append("   select colonycount,colonycountcomment, mic.labobservation_id, labobservation_name ,VALUE, unit,  ");
                newquery.Append("    OrganismID,if(OrganismName=OrganismNameDisplayname,OrganismName,if(ifnull(OrganismNameDisplayname,'')='',OrganismName,OrganismNameDisplayname)) OrganismName, OrganismGroupID, OrganismGroupName,EnzymeId, Enzymename, Enzymevalue,  ");
                newquery.Append("    EnzymeUnit,Antibioticid, AntibioticName, AntibioticGroupid,ifnull( AntibioticGroupname,'') AntibioticGroupname,  ");
                newquery.Append("   IF(AntibioticInterpreatation='Intermediate' || AntibioticInterpreatation='Sensitive' ,  ");
                newquery.Append("  CONCAT('',AntibioticInterpreatation,''), AntibioticInterpreatation)AntibioticInterpreatation,   ");
                newquery.Append("  (case when AntibioticInterpreatation='HIGHLY SENSITIVE' then '1' when AntibioticInterpreatation='MODERATELY SENSITIVE' then '2'  when AntibioticInterpreatation='INTERMEDIATE' then '3'  when AntibioticInterpreatation='RESISTANT' then '4' else '5' end ) ordercol, ");
                newquery.Append("   MIC, IF(MIC='','',BreakPoint)BreakPoint,  MIC_BP, mic.Reporttype  MicroReporType  from patient_labobservation_opd_mic mic where testid='" + dr["test_id"].ToString() + "' and labobservation_id=''  and reporttype='" + reportnumber + "' ORDER BY OrganismName,AntibioticName, ordercol");

                DataTable dtc = StockReports.GetDataTable(newquery.ToString());

                int counter = 1;
                sb.Append(culturedata);

                // sb.Append("<tr valign='top'><th style='border:0px;' class='InvName' colSpan='" + colspantd + "'><br/></th></tr>");

                if (dtc.Rows.Count > 0 && isheadingprint == "")
                {
                    sb.Append("<tr valign='top'><th style='border:0px;' colSpan='" + colspantd + "' class='InvName' ><br/></th></tr>");
                    sb.Append("<th  style='padding-left:15px;text-align:center;background-color:lightgray;font-size:19px;' colSpan='" + colspantd + "' class='InvName' >CULTURE");
                    sb.Append("</th></tr>");
                }
                foreach (DataRow drw in dtc.Rows)
                {
                    if (drw["OrganismName"].ToString() != OrganismName)
                    {
                        sb.Append("<tr valign='top'>");
                        // sb.Append("<th style='width:50px;font-weight:bold;text-align:center;'></th>");
                        if (counter == 1)
                        {
                            sb.Append("<th style='padding-left:15px;' colSpan='" + colspantd + "' class='InvName' >Organism : <span style='font-weight:normal'>" + drw["OrganismName"].ToString() + "</span></th></tr>");
                        }
                        else
                        {
                            sb.Append("<th style='padding-left:15px;' colSpan='" + colspantd + "' class='InvName' >Organism " + counter + " : <span style='font-weight:normal'>" + drw["OrganismName"].ToString() + "</span></th></tr>");
                        }

                        if (drw["colonycount"].ToString() != "")
                        {
                            sb.Append("<tr valign='top'>");
                            //sb.Append("<th style='width:50px;font-weight:bold;text-align:center;'></th>");
                            sb.Append("<th style='padding-left:15px;' colSpan='" + colspantd + "' class='InvName' >Colony Count : <span style='font-weight:normal'>" + drw["colonycount"].ToString() + "</span></th></tr>");
                        }

                        if (drw["colonycountcomment"].ToString() != "")
                        {
                            sb.Append("<tr valign='top'>");
                            //sb.Append("<th style='width:50px;font-weight:bold;text-align:center;'></th>");
                            sb.Append("<th style='padding-left:15px;' colSpan='" + colspantd + "' class='InvName' >Comment : <span style='font-weight:normal'>" + drw["colonycountcomment"].ToString() + "</span></th></tr>");
                        }
                        counter++;
                    }
                    OrganismName = drw["OrganismName"].ToString();

                }
                OrganismName = "";
                if (dtc.Rows.Count > 0)
                {
                    sb.Append("<tr valign='top'><th style='border:0px;' colSpan='" + colspantd + "' class='InvName' ><br/></th></tr>");
                    sb.Append("<tr valign='top'>");
                    //sb.Append("<th style='width:50px;font-weight:bold;text-align:center;'>III</th>");
                    sb.Append("<th  style='padding-left:15px;text-align:center;background-color:lightgray;font-size:19px;' colSpan='" + colspantd + "' class='InvName' >ANTIBIOTIC SUSCEPTIBILITY");
                    sb.Append("</th></tr>");
                }
                int counter1 = 1;
                foreach (DataRow drw in dtc.Rows)
                {
                    if (drw["OrganismName"].ToString() != OrganismName)
                    {
                        sb.Append("<tr valign='top'>");
                        //sb.Append("<th style='width:50px;font-weight:bold;text-align:center;'></th>");

                        if (counter1 > 1)
                        {
                            sb.Append("<tr valign='top'><th style='border:0px;' class='InvName' ><br/></th></tr>");
                        }

                        if (counter1 == 1)
                        {
                            sb.Append("<th style='padding-left:15px;' colSpan='" + colspantd + "' class='InvName' >Organism : <span style='font-weight:bold;'>" + drw["OrganismName"].ToString() + "</span></th></tr>");
                        }
                        else
                        {
                            sb.Append("<th style='padding-left:15px;' colSpan='" + colspantd + "' class='InvName' >Organism " + counter1 + " : <span style='font-weight:bold;'>" + drw["OrganismName"].ToString() + "</span></th></tr>");
                        }


                        sb.Append("<tr valign='top'>");
                        //sb.Append("<th style='padding-left:5px; width:50px;'></th>");
                        sb.Append("<th style='padding-left:15px;' class='InvName'>&nbsp;ANTIBIOTIC NAME</td>");
                        if (dtc.Select(" MIC<>'' ").Length > 0)
                            sb.Append("<th style='text-align: center' class='InvName'>&nbsp;INTERPRETATION</td>");
                        else
                            sb.Append("<th style='text-align: center' colspan='2' class='InvName'>&nbsp;INTERPRETATION</td>");

                        if (dtc.Select(" MIC<>'' ").Length > 0)
                            sb.Append("<th style='text-align: center' class='InvName'>&nbsp;MIC</td>");

                        // if (dtc.Select(" BreakPoint<>'' ").Length > 0)
                        // sb.Append("<th  class='InvName'>&nbsp;BREAKPOINTS</td>");

                        //if (dtc.Select(" MIC_BP<>'' ").Length > 0)
                        // sb.Append("<th  class='InvName'>&nbsp;MIC/BP</td>");

                        // if (dtc.Select(" AntibioticGroupname<>'' ").Length > 0)
                        // sb.Append("<th  class='InvName'>&nbsp;Group</td>");

                        sb.Append("</tr>");

                        counter1++;

                    }
                    OrganismName = drw["OrganismName"].ToString();


                    //if (drw["EnzymeName"].ToString() != EnzymeName && drw["EnzymeName"].ToString() != "" && dr["EnzymeValue"].ToString() != "")
                    //{
                    //    sb.Append("<tr valign='top'>");
                    //    sb.Append("<td style='font-weight:bold;'>&nbsp;Enzyme</td>");
                    //    sb.Append("<td colspan='2'>&nbsp;" + drw["EnzymeName"].ToString() + "</td>");
                    //    sb.Append("<td colspan='2'>&nbsp;" + drw["EnzymeValue"].ToString() + "</td>");
                    //    sb.Append("</tr>");
                    //}
                    //EnzymeName = drw["EnzymeName"].ToString();




                    if (drw["AntibioticInterpreatation"].ToString() != "")
                    {
                        sb.Append("<tr valign='top'>");
                        //sb.Append("<td style='padding-left:5px; width:50px;'></td>");
                        sb.Append("<td style='padding-left:15px;' class='LabObservationName'>&nbsp;" + drw["AntibioticName"].ToString() + "</td>");

                        if (dtc.Select(" MIC<>'' ").Length > 0)
                            sb.Append("<td style='text-align: center' class='Value'>&nbsp;" + drw["AntibioticInterpreatation"].ToString().ToUpper() + "</td>");
                        else
                            sb.Append("<td style='text-align: center' colspan='2' class='Unit'>&nbsp;" + drw["AntibioticInterpreatation"].ToString().ToUpper() + "</td>");




                        if (dtc.Select(" MIC<>'' ").Length > 0)
                            sb.Append("<td style='text-align: center'>&nbsp;" + drw["MIC"].ToString() + "</td>");

                        // if (dtc.Select(" BreakPoint<>'' ").Length > 0)
                        // sb.Append("<td >&nbsp;" + drw["BreakPoint"].ToString() + "</td>");

                        // if (dtc.Select(" MIC_BP<>'' ").Length > 0)
                        // sb.Append("<td >&nbsp;" + drw["MIC_BP"].ToString() + "</td>");

                        // if (dtc.Select(" AntibioticGroupname<>'' ").Length > 0)
                        // sb.Append("<td >&nbsp;" + drw["AntibioticGroupname"].ToString() + "</td>");

                        sb.Append("</tr>");
                    }



                }

            }




            // Adding Interpretaion

            if ((_LastRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) + 1]["Test_ID"].ToString() != dr["Test_ID"].ToString())
                &&
                (StripHTML(Util.GetString(dr["Interpretation"])).Trim() != "")
                )
            {


                if (Util.GetString(dr["Interpretation"]).Trim() != "<br>" && Util.GetString(dr["Interpretation"]).Trim() != "" && Util.GetString(dr["Interpretation"]).Trim() != "<br/>" && Util.GetString(dr["Interpretation"]).Trim() != "<br />")
                {
                    //Util.GetString(dr["Interpretation"]).Trim() != "<br>" &&
                    sb.Append("<tr valign='top'><th style='border:0px;' class='InvName' ><br/></th></tr>");
                    sb.Append("<tr valign='top'>");
                    //Interptation  comment
                    sb.Append("<td style='padding-left:15px;'  colSpan='" + colspantd + "'><br/><b>Comment:</b><br/>" + dr["Interpretation"].ToString() + "</td>");
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
                    sb.Append("<tr valign='top'><th style='border:0px;' class='InvName' colSpan='" + colspantd + "' ><br/></th></tr>");
                    sb.Append("<tr valign='top'>");
                    sb.Append("<td style='padding-left:15px;' colSpan='" + colspantd + "'>" + dr["Comments"].ToString() + "</td>");
                    sb.Append("</tr>");
                }
            }

            if ((_LastRow) ? true : (dtObs.Rows[dtObs.Rows.IndexOf(dr) + 1]["Test_ID"].ToString() != dr["Test_ID"].ToString()))
            {
                if (dr["investigation_id"].ToString() == "404" || dr["investigation_id"].ToString() == "406" || dr["investigation_id"].ToString() == "407" || dr["investigation_id"].ToString() == "1379")
                {
                    if (reportnumber == "Preliminary")
                    {
                        sb.Append("<tr valign='top'><td style='border:0px;'><br/></td></tr>");
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td style='padding-left:15px;border:0px;' colSpan='" + colspantd + "'>** Final to come</td>");
                        sb.Append("</tr>");

                    }
                }
                else if (dr["investigation_id"].ToString() == "410")
                {
                    if (reportnumber == "Preliminary")
                    {
                        sb.Append("<tr valign='top'><td style='border:0px;'><br/></td></tr>");
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td style='padding-left:15px;border:0px;' colSpan='" + colspantd + "'>** Preliminary 1 and Final to come</td>");
                        sb.Append("</tr>");

                    }
                    else if (reportnumber == "Preliminary 1")
                    {
                        sb.Append("<tr valign='top'><td style='border:0px;'><br/></td></tr>");
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td style='padding-left:15px;border:0px;' colSpan='" + colspantd + "'>**  Final to come</td>");
                        sb.Append("</tr>");
                    }
                }
                else if(dr["investigation_id"].ToString() == "405" || dr["investigation_id"].ToString() == "413" || dr["investigation_id"].ToString() == "1274" || dr["investigation_id"].ToString() == "1334")
                {
                    if (reportnumber == "Preliminary")
                    {
                        sb.Append("<tr valign='top'><td style='border:0px;'><br/></td></tr>");
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td style='padding-left:15px;border:0px;' colSpan='" + colspantd + "'>** Preliminary 1,2,3 and Final to come</td>");
                        sb.Append("</tr>");

                    }
                    if (reportnumber == "Preliminary 1")
                    {
                        sb.Append("<tr valign='top'><td style='border:0px;'><br/></td></tr>");
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td style='padding-left:15px;border:0px;' colSpan='" + colspantd + "'>** Preliminary 2,3 and Final to come</td>");
                        sb.Append("</tr>");

                    }
                    else if (reportnumber == "Preliminary 2")
                    {
                        sb.Append("<tr valign='top'><td style='border:0px;'><br/></td></tr>");
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td style='padding-left:15px;border:0px;' colSpan='" + colspantd + "'>** Preliminary 3 and Final to come</td>");
                        sb.Append("</tr>");
                    }
                    else if (reportnumber == "Preliminary 3")
                    {
                        sb.Append("<tr valign='top'><td style='border:0px;'><br/></td></tr>");
                        sb.Append("<tr valign='top'>");
                        sb.Append("<td style='padding-left:15px;border:0px;' colSpan='" + colspantd + "'>** Final to come</td>");
                        sb.Append("</tr>");
                    }
                   
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
                    sb.Append("<tr><td class='Department'  colSpan='" + colspan + "' style='border:0px;'>&nbsp;</td></tr>");
                    sb.Append("<tr><td class='Department'  colSpan='" + colspan + "' style='border-top:1px solid black;border-left:0px;border-right:0px;border-bottom:0px;text-align:center;'>*** End Of Report ***</td></tr>");
                    sb.Append("<tr><td style='border:0px;' colSpan='" + colspan + "'>");
                    string pendingtest = StockReports.ExecuteScalar(@"SELECT ifnull(GROUP_CONCAT(NAME SEPARATOR ', '),'') FROM `patient_labinvestigation_opd` plo
                    INNER JOIN investigation_master im ON plo.investigation_id=im.investigation_id
                    WHERE `LedgertransactionNo`='" + drcurrent["LabNo"].ToString() + "' AND approved=0 AND isreporting=1 and IsSampleCollected<>'R'");

                    DataRow[] list = dtObs.Select("LabNo ='" + drcurrent["LabNo"].ToString() + "' and Approved=1");
                    if (list.Length > 0)
                    {
                        DataTable dataTable = list.CopyToDataTable();

                        DataView dv = dataTable.DefaultView.ToTable(true, "ApprovedBy").DefaultView;
                        dv.Sort = "ApprovedBy asc";
                        DataTable deptapp = dv.ToTable();
                        StringBuilder sbimg = new StringBuilder();

                        if (pendingtest != "")
                        {
                            sbimg.Append("<span style='font-size:13px;'>Result/s to Follow:<br/>" + pendingtest + "<br/></span>");

                        }
                        sbimg.Append("<div style='width:800px;page-break-inside:avoid;'>");
                        foreach (DataRow st in deptapp.Rows)
                        {

                            if (isSign(st["ApprovedBy"].ToString()))
                            {
                                string signid = StockReports.ExecuteScalar(" SELECT SigantureID FROM f_approval_signature WHERE EmployeeID= " + Util.GetString(drcurrent["ApprovedBy"]) + " AND isActive=1 LIMIT 1 ");
                                string imgname = serverPath + "Design/opd/signature/" + signid + ".jpg";
                                //string imgname = az.fileShowFromAzure(Util.GetString(st["ApprovedBy"]), Util.GetString(st["ApprovedBy"]) + ".jpg", "doctorsignature");
                                sbimg.Append("<img style='float:left;padding-right:10px;' src='" + imgname + "'");
                                sbimg.Append(" />");

                            }
                            // else
                            // {
                                // throw new Exception("Signature not found in Azure");
                            // }

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
               // if (az.FileReadFromAzure("uploadedreport", drAtt["FileUrl"].ToString()))
              //  {
                //    _pdf = az.fileShowFromAzure(drAtt["FileUrl"].ToString(), drAtt["FileUrl"].ToString(), "uploadedreport");
               // }
              //  else
              //  {

               //     throw new Exception("Uploaded Report not found in Azure-" + drAtt["FileUrl"].ToString());
             //   }   
               if (File.Exists(_pdf))
                {
                    try
                    {
                      Stream stream11 = ConvertToStream(_pdf);
                        PdfDocument document1 = PdfDocument.FromStream(stream11);

                        PdfPage pdfPage1 = document1.Pages[0];
                        float pdfPageWidth = pdfPage1.Size.Width;
                        float pdfPageHeight = pdfPage1.Size.Height;
                        int htmlLogoWidthPx = 600;
                        float htmlLogoWidthPt = PdfDpiTransform.FromPixelsToPoints(htmlLogoWidthPx);
                        float htmlLogoHeightPt = 100;
                        PdfRepeatCanvas repeatedCanvas = document1.CreateRepeatedCanvas(
                                new System.Drawing.RectangleF(0,
                                        1500,
                                        htmlLogoWidthPt, htmlLogoHeightPt));
                        //PdfDocument document1 = PdfDocument.FromFile(_pdf);
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

            // histo report
            int ishisto = Util.GetInt(StockReports.ExecuteScalar("select count(1) from patient_labobservation_histo where Test_ID in(" + TestID + ")"));
            if (ishisto > 0)
            {
                string url = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/" + Request.Url.AbsolutePath.Split('/')[1] + "/Design/Lab/labreportnewhisto.aspx" + Request.Url.Query;

                Stream stream = ConvertToStream(url);

                PdfDocument pdfhisto = PdfDocument.FromStream(stream);
                document.AddDocument(pdfhisto);



            }
        }
        catch
        {
        }

        try
        {
            // write the PDF document to a memory buffer
            byte[] pdfBuffer = document.WriteToMemory();

            // inform the browser about the binary data format

            if (app == "1")
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
        FooterHeight = Util.GetInt(drcurrent["ReportFooterHeight"].ToString());


        int pageno = 1;
        foreach (PdfPage p in tempDocument.Pages)
        {




            System.Drawing.Font pageNumberingFont =
          new System.Drawing.Font(new System.Drawing.FontFamily("Times New Roman"), 8, System.Drawing.GraphicsUnit.Point);






            PdfText pageNumberingText = new PdfText(PageWidth - 100, FooterHeight-80 , String.Format(" Page {0} of {1}", pageno, tempDocument.Pages.Count), pageNumberingFont);
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

        if (Util.GetString(drcurrent["PatientType"]).ToLower() == "hlm")
        {
            //string SponsorNameFull = Util.GetString(drcurrent["OtherReferLab"]);
            //string SponsorNameFirstPart = string.Empty;
            //string SponsorNameSecordPart = string.Empty;
            //if (SponsorNameFull.Trim() != "")
            //{
            //    if (SponsorNameFull.Length <= 31)
            //    {
            //        SponsorNameFirstPart = SponsorNameFull;
            //    }
            //    else
            //    {
            //        SponsorNameFirstPart = SponsorNameFull.Substring(0, 31);
            //        SponsorNameSecordPart = SponsorNameFull.Substring(31);
            //    }
            //    Header = Header.Replace("Client Name", "Sponsor Name").Replace("{Company_Name}", SponsorNameFirstPart).Replace("Client Code", "&nbsp;").Replace(": {Panel_Code}", "&nbsp;" + SponsorNameSecordPart);
            //}
            //else
            //{
            //    Header = Header.Replace("Client Name", "&nbsp;").Replace(": {Company_Name}", "&nbsp;").Replace("Client Code", "&nbsp;").Replace(": {Panel_Code}", "&nbsp;");
            //}

            //if (Util.GetString(drcurrent["OtherReferLab"]) != "")
            //    Header = Header.Replace("Client Name", "Referred By");


            if (Util.GetString(drcurrent["CorporateIDCard"]).Trim() != "")
            {
                Header = Header.Replace("IP/OP NO", "Emp/Auth/TPA ID").Replace("{HLMOPDIPDNo}", Util.GetString(drcurrent["CorporateIDCard"]).Trim());
            }
           // Header = Header.Replace("IP/OP NO", "&nbsp;").Replace(": {HLMOPDIPDNo}", "&nbsp;");
          //  Header = Header.Replace("{LabNo}", Util.GetString(drcurrent["LedgerTransactionNo_Interface"]).Trim());
            Header = Header.Replace("{HLMOPDIPDNo}", Util.GetString(drcurrent["HLMOPDIPDNo"]).Trim());
        }
        for (int i = 0; i < dtObs.Columns.Count; i++)
        {
            Header = Header.Replace("{" + dtObs.Columns[i].ColumnName + "}", dr_Detail[i].ToString());
        }

        StringBuilder sb = new StringBuilder();
        sb.Append(sbCss.ToString());
        sb.Append("<div class='divContent' ><table class='tbData'>");





        //sb.Append("<tr valign='top' ><th class='Department'   colSpan='" + dtLabReport.Rows.Count + "'  >DEPARTMENT OF " + drcurrent["Dept"].ToString() + "</th></tr>");

        if (drcurrent["ispackage"].ToString() == "1")
        {
            sb.Append("<tr  valign='top'>");

            sb.Append("<th class='Department'   colSpan='" + dtLabReport.Rows.Count + "'>" + drcurrent["packagename"].ToString() + "</th>");

            sb.Append("</tr>");


        }


        sb.Append("</table></div>");


        return Header + "" + sb.ToString();



    }

    public string getTags_Flag(string Value, string MinRange, string MaxRange, string AbnormalValue, string labelname, DataRow drme, string flag1)
    {
        if (labelname == "labobservationname" && Util.GetString(drme["invHeader"]).Trim() == "0")
        {
            try
            {
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
                Value = m.Groups[0].ToString().Replace(m.Groups[1].ToString(), strTemp + m.Groups[1].ToString());

            }
            catch
            {
            }
        }
        if (labelname != "value")
            return Value;


        string ret_value = Value;
        string uploadedimgpath = Request.Url.Scheme + "://" + Request.Url.Host + ":" + Request.Url.Port + "/" + Request.Url.AbsolutePath.Split('/')[1] + "/";
        Value = Value.Replace("../../", uploadedimgpath);

        if (ret_value != Value)
            return Value;



        try
        {
            if (ret_value == "")
                ret_value = "";
            if ((MinRange == "") && (MaxRange == ""))
                ret_value = Value;
            else
            {
                if ((MinRange != "") && (Util.GetFloat(Value) < Util.GetFloat(MinRange)))
                    ret_value = "<b>" + ret_value + "</b>";
                else if ((MaxRange != "") && (Util.GetFloat(Value) > Util.GetFloat(MaxRange)))
                    ret_value = "<b>" + ret_value + "</b>";



            }
            if (AbnormalValue != "" && AbnormalValue == Value)
                ret_value = "<b>" + ret_value + "</b>";

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        //if (labelname == "value")
        //{
        //    if (flag1 == "H" || flag1 == "L")
        //    {
        //        ret_value = "<b>" + ret_value + "</b>";
        //    }
        //}
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
            return "" + ret_value + sb.ToString();
        }

        else
        {

            return "" + ret_value;
        }

    }


    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {
        FooterHeight = Util.GetInt(drcurrent["ReportFooterHeight"].ToString());
        PdfPage page1 = eventParams.PdfPage;
     //   AzureStorage az = new AzureStorage();
        //set background iamge in pdf report.
        if (HeaderImage == true)
        {
           
                HeaderImg = "App_Images/ReportBackGround/" + Util.GetString(drcurrent["ReportBackGroundImage"].ToString());
           // if (az.FileReadFromAzure("reportbackground", Util.GetString(drcurrent["ReportBackGroundImage"].ToString())))
            //{

               // var url = az.fileShowFromAzure(Util.GetString(drcurrent["ReportBackGroundImage"].ToString()), Util.GetString(drcurrent["ReportBackGroundImage"].ToString()), "reportbackground");
                //HeaderImg = url;

                string myimgheader = "<img src='" + HeaderImg + "' />";
                PdfHtml headerHtmlimg = new PdfHtml(0, 0, myimgheader, null);
                page1.Layout(headerHtmlimg);
           // }
           // else
            //{
             //   throw new Exception("ReportBackground not found in Azure");
            //}
           page1.Layout(getPDFImage(0, 0, HeaderImg));
        }
       // if (Util.GetInt(drcurrent["AAALogo"].ToString()) == 1)
        //{
        //     page1.Layout(getPDFImagewithresizeWaterMarkLogo(187, 320, 220, "App_Images/lupinreportlogonew.png"));
      //  }
        if (Util.GetString(drcurrent["ReportStatus1"].ToString()) == "Provisional Report")
        {
            System.Drawing.Font sysFontBold = new System.Drawing.Font("Arial",
        60, System.Drawing.FontStyle.Regular,
                 System.Drawing.GraphicsUnit.Point);
            PdfText titleRotatedText = new PdfText(50, 550, "Provisional Report", sysFontBold);
            titleRotatedText.ForeColor = System.Drawing.Color.LightGray;
            titleRotatedText.RotationAngle = 45;
            page1.Layout(titleRotatedText);
        }
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
            PdfText titleRotatedText = new PdfText(2, -20, "Powered By ITDOSE INFOSYSTEMS PVT. LTD.", sysFontBold);
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
            HeaderHeight = Util.GetInt(drcurrent["ReportHeaderHeight"].ToString());
        }

       HeaderHeight = HeaderHeight-6;
        page.CreateHeaderCanvas(HeaderHeight);

        // layout HTML in header

        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakeHeader("", drcurrent), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;

        //page.Header.Layout(headerHtml);

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
			 FooterHeight = Util.GetInt(drcurrent["ReportFooterHeight"].ToString());
             page.CreateFooterCanvas(FooterHeight + 60);

            StringBuilder sbimg = new StringBuilder();
			sbimg.Append("<div style='page-break-inside:avoid;'>");
			sbimg.Append("<table style='width:100%;font-family: Calibri;'>");
        
             sbimg.Append("<tr>");		   
			sbimg.Append("<td>Report Prepared by: <span style='font-weight:bold'> " + drcurrent["ResultEnteredName"] + "</span>.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Authorised by : <span style='font-weight:bold'> " + drcurrent["ApprovedName"] + "</span>.</td>");			
			sbimg.Append("</tr>");
            if (drcurrent["ShowSignature"].ToString() != "0")
            {
                if (!signatureonend)
                {
                    sbimg.Append("<tr><td>");
                    if (isSign(drcurrent["ApprovedBy"].ToString()))
                    {

                        string signid = StockReports.ExecuteScalar(" SELECT SigantureID FROM f_approval_signature WHERE EmployeeID= " + Util.GetString(drcurrent["ApprovedBy"]) + " AND isActive=1 LIMIT 1 ");
                        string imgname = serverPath + "Design/opd/signature/" + signid + ".jpg";
                        sbimg.AppendFormat("<img style='float:right;padding-right:50px;' src='{0}'", imgname);
                        sbimg.Append(" />");

                    }
                    sbimg.Append("</tr></td>");
                }
            }
          sbimg.Append("</div>");
          PdfHtml footerHtml = new PdfHtml(XFooter, 0, sbimg.ToString(), null);
          page.Footer.Layout(footerHtml);
           // page.Footer.Layout(getPDFImageforbarcode(10, 0, drcurrent["LabNo"].ToString(),"Y"));
            page.Footer.Layout(getPDFImageforbarcode(20, FooterHeight, drcurrent["LabNo"].ToString()));
            //PdfText pdf11 = new PdfText(22, 23, "SIN No:" + drcurrent["barcodeno"], new Font("Times New Roman", 10));
            //page.Footer.Layout(pdf11);
            if (Util.GetString(drcurrent["type1"]).Trim() == "PCC" && (Util.GetString(drcurrent["TagProcessingLabID"]).Trim() != Util.GetString(drcurrent["TestCentreID"]).Trim()))
            {
                page.Footer.Layout(new PdfText(70, FooterHeight+40, "* NOTE – This sample has been processed at our reference lab. For any query, write us", new Font("Times New Roman", 7)));
            }
            else if (Util.GetString(drcurrent["type1"]).Trim() != "PCC" && (Util.GetString(drcurrent["centreid"]).Trim() != Util.GetString(drcurrent["TestCentreID"]).Trim()))
            {
                page.Footer.Layout(new PdfText(70, FooterHeight+40, "* NOTE – This sample has been processed at our reference lab. For any query, write us", new Font("Times New Roman", 7)));
            }
        }

    }


    PdfText EndOfReport(float X, float Y)
    {
        return new PdfText(X, Y, "*** End Of Report ***", new Font("Times New Roman", 12));
    }

    bool isSign(string imgID)
    {
       // AzureStorage az = new AzureStorage();
        return (File.Exists(Server.MapPath("~/Design/opd/signature/") + "" + imgID + ".jpg"));

       // return (az.FileReadFromAzure("doctorsignature", imgID + ".jpg"));
    }

    public string StripHTML(string source)
    {
        try
        {
            string result;          
            result = source.Replace("\r", " ");
            result = result.Replace("\n", " ");
            result = result.Replace("\t", string.Empty);
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
        catch (Exception exp)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(exp);
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
    private PdfImage getPDFImageforabnormal(float X, float Y, string SignImg)
    {
        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, 70, Server.MapPath("~/" + SignImg));

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
    private PdfImage getPDFImageforbarcode(float X, float Y, string labno)
    {
        string image = "";

        //image = new Barcode_alok().Save(labno).Trim();

        string URL = Util.GetString("https://lims.lupindiagnostics.com/Lupin/Design/lab/LabReportView.aspx?LabNo=" + Common.EncryptRijndael(labno));//Common.Encrypt(drcurrent["LabNo"].ToString()
        // string URL = Util.GetString("http://20.204.137.155/Lupin/Design/lab/labreportnew_ShortSMS.aspx?LabNo=" + labno);
        image = getqrcode(URL);

        PdfImage transparentResizedPdfImage = new PdfImage(X, Y, Base64StringToImageQR(image));

        transparentResizedPdfImage.PreserveAspectRatio = true;

        //transparentResizedPdfImage.AlphaBlending = true;

        return transparentResizedPdfImage;
    }

    public System.Drawing.Image Base64StringToImageQR(string base64String)
    {
        byte[] imageBytes = Convert.FromBase64String(base64String.Replace("data:image/png;base64,", ""));
        MemoryStream memStream = new MemoryStream(imageBytes, 0, imageBytes.Length);

        memStream.Write(imageBytes, 0, imageBytes.Length);
        System.Drawing.Image image = System.Drawing.Image.FromStream(memStream);
        Bitmap newImage;


        newImage = new Bitmap(80, 80);

        using (Graphics graphics = Graphics.FromImage(newImage))
            graphics.DrawImage(image, 0, 0, 80, 80);
        return newImage;

    }


    public string getqrcode(string code, string ShowQR = "N")
    {

        // string yourcode = code;
        // QRCodeEncoder enc = new QRCodeEncoder();
        // enc.QRCodeEncodeMode = QRCodeEncoder.ENCODE_MODE.ALPHA_NUMERIC;
        // Bitmap qrcode = enc.Encode(yourcode);
        // using (MemoryStream ms = new MemoryStream())
        // {
        //     qrcode.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
        //     byte[] byteImage = ms.ToArray();
        //    return "data:image/png;base64," + Convert.ToBase64String(byteImage);
        // }
        string yourcode = code;
        QRCodeEncoder enc = new QRCodeEncoder();
        enc.QRCodeVersion = 0;
        Bitmap qrcode = enc.Encode(yourcode, System.Text.Encoding.UTF8);
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
        string[] tags = TestID.Replace("'", "").Split(',');
        if (isOnlinePrint != "1")
            tags = tags.Take(tags.Count() - 1).ToArray();

        string[] paramNames = tags.Select(
              (s, i) => "@tag" + i.ToString()).ToArray();


        string inClause = string.Join(", ", paramNames);
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        if (reportnumber == "")
        {

            string reportNo = "select pli.reportnumber from patient_labinvestigation_opd pli inner join patient_labobservation_opd_mic plo on pli.test_id=plo.testid where test_id IN ({0}) limit 1";

            MySqlCommand cmd = new MySqlCommand(string.Format(reportNo, inClause), con);

            for (int i = 0; i < paramNames.Length; i++)
            {
                cmd.Parameters.AddWithValue(paramNames[i], tags[i]);
            }
            reportnumber = cmd.ExecuteScalar().ToString();
            cmd.Dispose();
        }

        StringBuilder sb = new StringBuilder();


        sb.Append("    SELECT * FROM (SELECT   ");
        sb.Append("               t.*,  ");
        sb.Append("    (SELECT CASE WHEN IsPackage='1' AND PrintInterPackage='1' THEN  ");
        sb.Append("   Interpretation WHEN isPackage='0' AND PrintInterTest='1' THEN Interpretation ELSE '' END   ");
        sb.Append("  FROM investigation_master_interpretation WHERE `Investigation_ID`=im.`Investigation_ID` AND   ");
        sb.Append("  centreid=t.centreid AND macid=IF(t.MachineID='0','1',t.MachineID) LIMIT 1 ) AS Interpretation  ");
        sb.Append("          ,'3' ReportType,CONCAT(IF(t.IsPackage=1,'',''),    ");
        sb.Append("           IF(IM.PrintSampleName=0,IF(IFNULL(itm.Inv_ShortName,'')!='',IM.Name,IM.Name),im.name)) AS TestName,im.method,im.FileLimitationName, scm.deptinterpretaion,  ");
        sb.Append("    ");
        sb.Append("           otm.Name AS Dept,otm.isVisible AS DeptVisible,    ");
        sb.Append("            IM.Print_sequence AS Print_Sequence_Investigation,     ");
        sb.Append("    ");
        sb.Append("            im.PrintSeparate,im.printsamplename,   ");
        sb.Append("           IM.Description AS d1,t.labPriorty Priorty,IF(VALUE ='HEAD' ,'Y','N') IsParent,im.printHeader  AS invHeader ,   ");
        sb.Append("           '' SampleTypeID,cma.Centre CentreName,cma.Address,cma.Landline CentreLandline,cma.Mobile CentreMobile,cma.Email   ");
        sb.Append("           CentreEmail,cma.NablLogoPath,cma.CapLogoPath,'' printOrder , cma.type1, cmat.Centre TestCentreName ,cmat.Address TestCentreAddress,  ");
        sb.Append("           IFNULL((SELECT isNABL FROM `investiagtion_isnabl` WHERE Investigation_ID=im.Investigation_Id AND centreid=t.CentreID),0)isNABL,   ");
        sb.Append("           otm.Print_Sequence Print_Sequence_Dept,IFNULL(t.labPriorty,9999)printOrder_labObservation1,labPriorty printOrder_labObservation2    ");
        sb.Append("           ,otm.ObservationType_ID,pnl.`Panel_Code`,pnl.ShowSignature,IFNULL(LEFT(pnl.Add1,30),'')ClientAddress,   ");
        sb.Append(" pnl.ReportHeaderHeight,pnl.ReportHeaderXPosition,pnl.ReportHeaderYPosition,pnl.ReportFooterHeight,pnl.ReportBackGroundImage,pnl.AAALogo,pnl.TagProcessingLabID,pnl.mobile Company_no,upper(left(pnl.area,10)) Company_add  ");
        sb.Append("           FROM (        ");
        sb.Append("           SELECT   pm.Mobile,pm.House_No paddress,loi.ParentId, pli.laboutsrcid, ");
        sb.Append("           pli.LedgerTransactionNo AS LabNo,pli.test_id PLOID,pli.test_id,IF(lt.HomeVisitBoyID='N/A','N/A',(SELECT  flm.NAME FROM feildboy_master flm WHERE flm.FeildBoyID=lt.HomeVisitBoyID)) FieldExe,  ");
        sb.Append("           lt.PName,lt.Age,pli.BarcodeNo,LEFT(lt.Gender,1)Gender,mic.reporttype ReportStatus,IF(pli.Approved=0,'Provisional Report','Final Report')ReportStatus1,lt.OtherReferLab,lt.Interface_companyName,lt.CorporateIDCard,lt.LedgerTransactionNo_Interface,  ");
        sb.Append("           DATE_FORMAT(pli.date,'%d/%b/%Y %I:%i') DateEnrolled,lt.Patient_ID,'' Description,pli.SampleBySelf,   ");
        sb.Append("           DATE_FORMAT(pli.ResultEnteredDate,'%d-%b-%y')AS ResultDate, pli.ResultEnteredBy,pli.ForwardBy,  ");
        sb.Append("    ");
        sb.Append("   mic.labobservation_id, labobservation_name ,VALUE, unit,labobservationcomment,  ");
        sb.Append("    OrganismID,OrganismName, OrganismGroupID, OrganismGroupName,EnzymeId, Enzymename, Enzymevalue,  ");
        sb.Append("    EnzymeUnit,Antibioticid, AntibioticName, AntibioticGroupid, AntibioticGroupname,  ");
        sb.Append("   IF(AntibioticInterpreatation='Intermediate' || AntibioticInterpreatation='Sensitive' ,  ");
        sb.Append("  CONCAT('<b>',AntibioticInterpreatation,'<b>'), AntibioticInterpreatation)AntibioticInterpreatation,  MIC, IF(MIC='','',BreakPoint)BreakPoint,  ");
        sb.Append("    MIC_BP, mic.Reporttype  MicroReporType  ");
        sb.Append("      ");
        sb.Append("  ,pli.Investigation_ID, pli.SlideNumber,pli.TestCentreID,  ");
        sb.Append("                DATE_FORMAT(pli.SampleCollectionDate,'%d/%b/%Y %I:%i')SampleDate,   ");
        sb.Append("           DATE_FORMAT(pli.SampleReceiveDate,'%d/%b/%Y  %I:%i')ReceiveDate,   ");
        sb.Append("           DATE_FORMAT(pli.Date,'%d-%b-%y %h:%i')DATE,         ");
        sb.Append("           IF(pli.Approved=1,1,0)Approved,(SELECT comments FROM patient_labinvestigation_opd_comments ploc WHERE ploc.Test_ID = pli.Test_ID)comments,    ");
        sb.Append("            IF(pli.isHold=1,'Hold',    ");
        sb.Append("            IF(pli.Approved=1,'Approved',IF(pli.isForward=1,'Forward',''))) AS MYApproved,   ");
        sb.Append("            IF(pli.isHold=1,pli.HoldByName,IF(pli.Approved=1,'',IF(pli.isForward=1,pli.ForwardByName,'')))    ");
        sb.Append("            AS MYApprovedBy,       DATE_FORMAT(pli.Approveddate,'%d/%b/%Y %I:%i%p')ApprovedDate,   ");
        //sb.Append("            mic.ApprovedBy ApprovedBy,        DATE_FORMAT(mic.ResultEntrydateTime,'%d/%b/%Y %I:%i%p')ResultEnteredDate,   ");
        sb.Append("            (SELECT EmployeeID FROM f_approval_labemployee WHERE technicalID=pli.ApprovedBy AND (Approval=4 OR approval=3) LIMIT 1) ApprovedBy,(SELECT  CONCAT(Title, pli.`ApprovedName`) FROM  `employee_master`  WHERE  Employee_ID=pli.`ApprovedBy`)ApprovedName, DATE_FORMAT(mic.ResultEntrydateTime,'%d/%b/%Y %I:%i%p')ResultEnteredDate,   ");

        sb.Append("         (SELECT  CONCAT(Title, pli.`ResultEnteredName`) FROM  `employee_master`  WHERE  Employee_ID=pli.`ResultEnteredBy`)ResultEnteredName , 0 Child_Flag,   ");//  pli.ResultEnteredName ResultEnteredName,
        sb.Append("            loi.printOrder  labPriorty,'' DisplayReading,IF(pli.IsPackage=1,pli.PackageName,'') PackageName, pli.IsPackage,  ");
        sb.Append("             '' DispatchMode   ");
        sb.Append("    ");
        sb.Append("             ,'' ObsInterpretation ,  ");
        sb.Append("            '' MethodName,DATE_FORMAT(pli.sampleCollectiondate,'%d/%b/%Y %I:%i')SegratedDate,DATE_FORMAT(NOW(),'%d/%b/%Y %I:%i')PrintDate,'0' IsCommentField ,'0' IsOrganism,'' AbnormalValue,'' IsBold,'' IsUnderLine,'' `IsMic`,  ");
        sb.Append("           '' SepratePrint,   ");
        sb.Append("            1 isborder,0 MachineID  , lt.centreid,lt.Panel_ID,IF(lt.`DoctorName`='SELF',lt.`DoctorName`,CONCAT('Dr.', lt.`DoctorName`))ReferDoctor, IF(lt.OtherReferLab='',CONCAT(SUBSTRING(lt.panelname,1,33),'.'),lt.OtherReferLab) Company_Name ,'' Company_code,'' Company_add1,lt.`HLMPatientType`,lt.`HLMOPDIPDNo`,pli.SampleTypeName,IFNULL(lt.PatientType,'')PatientType  ");
        sb.Append("            FROM patient_labobservation_opd_mic mic     ");
        sb.Append("             INNER JOIN patient_labinvestigation_opd pli ON pli.Test_ID = mic.TestID and mic.labobservation_id<>''    ");
        sb.Append("            AND pli.Test_ID IN ({0})  AND pli.Result_Flag = 1 AND pli.ishold=0   and mic.reporttype='" + reportnumber + "'  ");
        sb.Append("            INNER JOIN f_ledgertransaction lt ON lt.LedgerTransactionID=pli.LedgerTransactionID   ");
        sb.Append("            INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id   ");
        sb.Append("              ");
        sb.Append("            LEFT JOIN `labobservation_investigation` loi ON loi.`Investigation_Id`=pli.`Investigation_ID` AND loi.`labObservation_ID`=mic.`labobservation_id`  ");
        sb.Append("             )t    ");
        sb.Append("    ");
        sb.Append("           INNER JOIN investigation_master IM ON IM.Investigation_Id = t.Investigation_ID     ");
        sb.Append("           INNER JOIN f_itemmaster itm ON itm.Type_ID = IM.Investigation_ID       ");
        sb.Append("           INNER JOIN `f_subcategorymaster` scm ON scm.`SubCategoryID`=itm.`SubCategoryID` AND scm.`CategoryID`='LSHHI3'     ");
        sb.Append("           INNER JOIN investigation_observationtype iot ON iot.Investigation_ID=im.Investigation_Id     ");
        sb.Append("           INNER JOIN observationtype_master otm ON otm.ObservationType_ID=iot.ObservationType_Id      ");
        sb.Append("           INNER JOIN centre_master cma ON cma.CentreID = t.CentreId     ");
        sb.Append(" inner JOIN centre_master cmat ON cmat.CentreID = t.TestCentreID   ");
        sb.Append("           INNER JOIN f_panel_master pnl ON pnl.`Panel_ID`=t.Panel_ID     ");
        sb.Append("            ORDER BY test_id,LabNo,IFNULL(printOrder,9999),labPriorty   )ttt   ");
        //System.IO.File.WriteAllText (@"C:\Itdose\Uat_live\UAT_Ver1\Design\vdemo\20junerr_sign.txt", sb.ToString());

        MySqlCommand cmd1 = new MySqlCommand(string.Format(sb.ToString(), inClause), con);
        //using (MySqlCommand cmd = new MySqlCommand(string.Format(sb.ToString(), inClause)),con)
        //{
        for (int i = 0; i < paramNames.Length; i++)
        {
            cmd1.Parameters.AddWithValue(paramNames[i], tags[i]);
        }

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


        if ((isOnlinePrint != "1") || (isEmail != "1"))
        {

            string PLO = "update patient_labinvestigation_opd set isPrint='1' where Test_ID IN ({0})  and isPrint='0' and Approved='1' ";
            MySqlCommand cmd4 = new MySqlCommand(string.Format(PLO, inClause), con);
            for (int i = 0; i < paramNames.Length; i++)
            {
                cmd4.Parameters.AddWithValue(paramNames[i], tags[i]);
            }
            cmd4.ExecuteNonQuery();
            cmd4.Dispose();
            string[] tid = TestID.Replace(",''", "").Split(',');//dtObs.Columns["Test_ID"].ToString();
            if (isOnlinePrint != "1")
            {
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

        con.Close();
        con.Dispose();
    }




}
