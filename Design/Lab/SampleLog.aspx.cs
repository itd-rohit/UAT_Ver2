using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Lab_SampleLog : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string Test_Id = Util.GetString(Request["Test_Id"]);
        if (Test_Id != "")
        {
            BindLog(Test_Id);
        }
    }

    private void BindLog(string Test_Id)
    {
        StringBuilder sb = new StringBuilder();
        string ReportType = Util.GetString(Request["ReportType"]);
        if (ReportType == "")
        {
            sb.Append(" SELECT plo.PLOID PLOID, plo.Test_Id, plo.ItemName, lt.PName,lt.Age,lt.Gender,pm.Mobile, cm.Centre,lt.PanelName,plo.BarcodeNo,DATE_FORMAT(plo.ApprovedDate,'%d-%b-%Y %h:%i %p') DATE,plo.ApprovedName,lt.LedgertransactionNo FROM patient_labinvestigation_opd_notApprove plo ");
            sb.Append(" INNER JOIN f_Ledgertransaction lt ON lt.LedgertransactionId=plo.LedgertransactionId ");
            sb.Append(" INNER JOIN patient_master pm ON pm.Patient_Id=lt.Patient_Id ");
            sb.Append(" INNER JOIN Centre_Master cm ON lt.CentreId=cm.CentreId WHERE plo.Test_Id ='" + Test_Id + "' ");
        }
        else if (ReportType == "Histo")
        {

            sb.Append("  SELECT plo.PLOID PLOID, plo.Test_Id, pli.ItemName, lt.PName,lt.Age,lt.Gender,pm.Mobile, cm.Centre,lt.PanelName,pli.BarcodeNo,DATE_FORMAT(pli.ApprovedDate,'%d-%b-%Y %h:%i %p') DATE,pli.ApprovedName,lt.LedgertransactionNo  ");
            sb.Append(" FROM patient_labobservation_histo_notapprove plo  ");
            sb.Append(" INNER JOIN patient_labinvestigation_opd pli ON plo.Test_Id=pli.Test_Id  ");
            sb.Append(" INNER JOIN f_Ledgertransaction lt ON lt.LedgertransactionId=pli.LedgertransactionId  ");
            sb.Append(" INNER JOIN patient_master pm ON pm.Patient_Id=lt.Patient_Id  ");
            sb.Append(" INNER JOIN Centre_Master cm ON lt.CentreId=cm.CentreId  WHERE plo.Test_Id ='" + Test_Id + "' ");

        }
        using (DataTable dt = StockReports.GetDataTable(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
            {
                lblName.Text = Util.GetString(dt.Rows[0]["PName"]);
                lblAge.Text = Util.GetString(dt.Rows[0]["Age"]);
                lblGender.Text = Util.GetString(dt.Rows[0]["Gender"]);
                lblMobile.Text = Util.GetString(dt.Rows[0]["Mobile"]);
                lblCentre.Text = Util.GetString(dt.Rows[0]["Centre"]);
                lblPanel.Text = Util.GetString(dt.Rows[0]["PanelName"]);
                lblTest.Text = Util.GetString(dt.Rows[0]["ItemName"]);

                grdData.DataSource = dt;
                grdData.DataBind();

            }
        }

    }

    [WebMethod(EnableSession = true)]
    public static string bindCentre()
    {
        return "";
    }



    [WebMethod]
    public static string GetReport(string Month, string Year, string Type, string CallFor)
    {


        int mon = Util.GetInt(Month);
        int Yr = Util.GetInt(Year);

        DateTime _date = new DateTime(Yr, mon, 1);


        string FromDateTime = _date.ToString("yyyy-MM-dd") + " 00:00:00";



        string ToDateTime = _date.AddMonths(1).AddDays(-1).ToString("yyyy-MM-dd") + " 23:59:59";





        try
        {
            StringBuilder sb = new StringBuilder();

            if (Type == "1")
            {
                sb.Append(" SELECT CONCAT(EMP.Title,' ',EMP.Name) NAME,DATE_FORMAT(SS.`LastShownDateTime`,'%d-%b-%Y %h:%i %p') ShownOn ");
                sb.Append(" FROM `salesstatusshown_log` SS");
                sb.Append(" INNER JOIN Employee_Master EMP ON EMP.EMployee_Id=SS.Employee_Id");
                sb.Append("  WHERE SS.`LastShownDateTime` >= '" + FromDateTime + "' AND SS.`LastShownDateTime` <=  '" + ToDateTime + "' ");
                sb.Append(" ORDER BY SS.`LastShownDateTime` DESC ");
            }
            else if (Type == "2")
            {
                sb.Append(" SELECT CONCAT(EMP.Title,' ',EMP.Name) NAME,DATE_FORMAT(tpl.`dtEntry`,'%d-%b-%Y %h:%i %p') ShownOn  ");
                sb.Append(" FROM `technicianpendinglistshown_log` tpl ");
                sb.Append(" INNER JOIN Employee_Master EMP ON EMP.EMployee_Id=tpl.Employee_Id ");
                sb.Append("  WHERE tpl.`dtEntry` >= '" + FromDateTime + "' AND tpl.`dtEntry` <= '" + ToDateTime + "' ");
                sb.Append(" ORDER BY tpl.`dtEntry` DESC ");
            }
            else if (Type == "3")
            {
                sb.Append("   SELECT INL.InvoiceNo,PNL.Company_Name CLIENT,CONCAT(EM.Title,' ',EM.Name) NAME, ");
                sb.Append("  IF(INL.IsView=1,'Yes','No') IsViewed,IF(INL.IsClosed=1,'Yes','No') IsClose ,DATE_FORMAT(INL.dtEntry,'%d-%b-%Y %h:%i %p') DATE ");
                sb.Append("  FROM  InvoiceMaster_Notification_log INL ");
                sb.Append("  INNER JOIN Employee_Master EM ON INL.Employee_Id=EM.EMployee_Id ");
                sb.Append("  INNER JOIN f_Panel_Master PNL ON INL.PanelId=PNL.Panel_Id ");
                sb.Append("  WHERE INL.dtEntry >= '" + FromDateTime + "' AND INL.dtEntry <= '" + ToDateTime + "' ");
                sb.Append(" ORDER BY INL.dtEntry DESC ");
            }
            DataTable dt = StockReports.GetDataTable(sb.ToString());

            if (dt.Rows.Count > 0)
            {
                string ReportName = string.Empty;
                if (Type == "1")
                {
                    ReportName = "SalesStatusShownLog";
                }
                else if (Type == "2")
                {
                    ReportName = "TechnicianPendingLog";
                }
                else if (Type == "3")
                {
                    ReportName = "InvoiceNotificationLog";
                }

                if (CallFor == "Download")
                {
                    HttpContext.Current.Session["dtExport2Excel"] = dt;
                    HttpContext.Current.Session["ReportName"] = ReportName;
                    return "1";
                }
                else
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
        catch (Exception ex)
        {
            return "0";
        }
    }



}