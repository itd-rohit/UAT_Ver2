using System;
using System.Data;
using System.IO;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Web;
public partial class Design_common_Commonreport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        System.IO.Stream oStream = null;
        ReportDocument obj1 = new ReportDocument();
        try
        {
            if (Request.QueryString.Count == 0 && Util.GetString(Request.QueryString["access"]) == "")
            {
                Response.Redirect(Request.RawUrl + "?access=" + Util.getHash(), false);
            }
            else if (Request.QueryString.Count > 0 && Util.GetString(Request.QueryString["access"]) == "")
            {
                Response.Redirect(Request.RawUrl + "&access=" + Util.getHash());
            }
            string cmd = Util.GetString(Request.QueryString["cmd"]);


           
            DataSet ds = new DataSet();

            ds = (DataSet)Session["ds" + cmd];
            string ReportName = "";

            if (Session["ReportName" + cmd] != null)
            {
                ReportName = Session["ReportName" + cmd].ToString();
                Session.Remove("ReportName" + cmd);
                Session.Remove("ds" + cmd);
                switch (ReportName)
                {
                    case "COVID Worksheet":
                        {
                            obj1.Load(Server.MapPath("~/Reports/COVIDWorksheet.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LabWorkSheetHisto":
                        {
                            obj1.Load(Server.MapPath("~/Reports/LabWorkSheetHisto.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RemoveLogisticTransactionReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/RemoveLogisticTransactionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "Abnormal":
                        {
                            obj1.Load(Server.MapPath("~/Reports/Abnormal.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "MonthlyInvestigationAnalysisReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/MonthlyInvestigationAnalysisReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "MonthlyInvestigationAmountReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/MonthlyInvestigationAmountReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "LabInvestigationAnalysis":
                        {
                            obj1.Load(Server.MapPath("~/Reports/LabInvestigationAnalysis.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "LabInvestigationAnalysisDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/LabInvestigationAnalysisDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "LabPackageAnalysis":
                        {
                            obj1.Load(Server.MapPath("~/Reports/LabPackageAnalysis.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "LabPackageAnalysisDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/LabPackageAnalysisDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "PatientDetails":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\PatientDetails.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PatientInfoKarauli":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\PatientInfoKarauli.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Patient_Information_Summary":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Patient_Information_Summary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionReportSummary":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\CollectionReportSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CollectionReport_PatientWise":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\CollectionReport_PatientWise.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "RefundReportDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/RefundReportDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "CancelReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/CancelReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SettlementReportSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/SettlementReportSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SettlementReportDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/SettlementReportDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OutSrcLabSampleCollectionReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/OutSrcLabSampleCollectionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "OutSrcLabSampleCollectionReportWithOutRate":
                        {
                            obj1.Load(Server.MapPath("~/Reports/OutSrcLabSampleCollectionReportWithOutRate.rpt"));
                            obj1.SetDataSource(ds);
                            break;

                        }
                    case "SampleRejectionReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/SampleRejectionReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "UserByDiscountReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/UserByDiscountReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                    case "WorkSheetNew":
                        {
                            obj1.Load(Server.MapPath("~/Reports/WorkSheetNew.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LabWorksheet2":
                        {
                            obj1.Load(Server.MapPath("~/Reports/LabWorksheet2.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LabWorksheet":
                        {
                            obj1.Load(Server.MapPath("~/Reports/LabWorksheet.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "LabWorksheet3":
                        {
                            obj1.Load(Server.MapPath("~/Reports/LabWorksheet3.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BilWiseCollectionReportWithDeposite":
                        {
                            obj1.Load(Server.MapPath("~/Reports/BilWiseCollectionReportWithDeposite.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "BilWiseCollectionReportWithoutDeposite":
                        {
                            obj1.Load(Server.MapPath("~/Reports/BilWiseCollectionReportWithoutDeposite.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PostitiveValuereport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/PostitiveValuereport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SalesReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/SalesReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "SampleTypeCount":
                        {
                            obj1.Load(Server.MapPath("~/Reports/SampleTypeCount.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "DepartmentWiseSalesReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/DepartmentWiseSalesReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "TechnicianPendingReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/TechnicianPendingReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "EmployeeAccessReport":
                        {
                            obj1.Load(Server.MapPath("~/Reports/EmployeeAccessReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "MachineAnalysis":
                        {
                            obj1.Load(Server.MapPath("~/Reports/MachineAnalysis.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
  case "ClientWiseSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/ClientWiseSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
			  case "NorthernRailway_PatientSummary":
                        {
                            obj1.Load(Server.MapPath("~/Reports/NorthernRailwayPatientSummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "NorthernRailway_PatientDetail":
                        {
                            obj1.Load(Server.MapPath("~/Reports/NorthernRailway_PatientDetail.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Invoice_Cash":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Invoice_Cash.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Invoice_Cash_Credit":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Invoice_Cash_Credit.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "Invoice_Cash_Debit":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\Invoice_Cash_Debit.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
						 case "InvoiceReport":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\InvoiceReport.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PanelWiseBusssinessReportPCC":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\PanelWiseBusssinessReportPCC.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }
                    case "PanelWiseBusssinessReportPCCsummary":
                        {
                            obj1.Load(Server.MapPath(@"~\Reports\PanelWiseBusssinessReportPCCsummary.rpt"));
                            obj1.SetDataSource(ds);
                            break;
                        }

                }




                //  System.IO.Stream oStream = null;
                byte[] byteArray = null;
                oStream = obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                byteArray = new byte[oStream.Length];
                oStream.Read(byteArray, 0, Convert.ToInt32(oStream.Length - 1));
                Response.ClearContent();
                Response.ClearHeaders();
                Response.ContentType = "application/pdf";
                Response.BinaryWrite(byteArray);
                Response.Flush();
                Response.Close();
                HttpContext.Current.Response.SuppressContent = true;
                HttpContext.Current.ApplicationInstance.CompleteRequest();



            }

        }
        catch (Exception ex)
        {
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            obj1.Close();      
            obj1.Dispose();
            oStream.Flush();
            oStream.Close();
            oStream.Dispose();
        }


    }
}
