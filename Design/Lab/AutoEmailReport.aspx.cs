using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Lab_AutoEmailReport : System.Web.UI.Page
{
    public static string labno = "";
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string sendAutoEmailReport()
    {
        string IsSend = "0";
        try
        {
            DataTable dtEmailData = StockReports.GetDataTable("CALL get_email_data_patient();");
            if (dtEmailData.Rows.Count > 0)
            {
                foreach (DataRow drTemp in dtEmailData.Rows)
                {
                    if (Util.GetString(drTemp["Email"])!="" && Util.GetString(drTemp["PanelType"]) != "PUP")
                    {
                        try
                        {
                            ReportEmailClass RMail = new ReportEmailClass();
                            StringBuilder EmailBody = new StringBuilder();
                            string EmailSubject = string.Empty;

                            // For (PCC) All ( Except STAT , HLM , PUP )
                            if (Util.GetString(drTemp["PanelType"]) == "PCC" || Util.GetString(drTemp["PanelType"]) == "NRL" || Util.GetString(drTemp["PanelType"]) == "RRL" || Util.GetString(drTemp["PanelType"]) == "SL" || Util.GetString(drTemp["PanelType"]) == "DDC")
                            {
                                EmailBody.Append(System.IO.File.ReadAllText(HttpContext.Current.Server.MapPath("~/EmailBody/PCC_Report_Email_Template.html")));
                            }
                            // For STAT And HLM
                            else if (Util.GetString(drTemp["PanelType"]) == "HLM" || Util.GetString(drTemp["PanelType"]) == "STAT")
                            {
                                EmailBody.Append(System.IO.File.ReadAllText(HttpContext.Current.Server.MapPath("~/EmailBody/HLM_Report_Email_Template.html")));
                            }

                            EmailBody.Replace("{CentreName}", Util.GetString(drTemp["Centre"])).Replace("{UserID}", Util.GetString(drTemp["UserID"])).Replace("{Password}", Util.GetString(drTemp["Password"])).Replace("{UHID}", Util.GetString(drTemp["Patient_ID"])).Replace("{PName}", Util.GetString(drTemp["PName"]));
                            EmailSubject = "Your Reports for UHID " + Util.GetString(drTemp["Patient_ID"]);
                            if (EmailBody.ToString().Trim() != "" && EmailSubject.Trim() != "")
                            {
                                IsSend = RMail.sendEmail(Util.GetString(drTemp["Email"]), EmailSubject.Trim(), EmailBody.ToString(), "", "", Util.GetString(drTemp["LedgerTransactionNo"]), Util.GetString(drTemp["Test_id"]), "PDF Report","1", "PDF Report Email","Patient");
                            }
                        }
                        catch (Exception ex)
                        {
                            IsSend = "-1";
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
                        }
                    }
                }
            }
            return IsSend;
        }
        catch (Exception ex)
        {
            IsSend = "-1";
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return IsSend;
        }

    }  
}
