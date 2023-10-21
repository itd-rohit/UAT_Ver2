using ClosedXML.Excel;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;

public partial class Design_Reports_ExcelReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.Form.Count > 0)
        {
            List<ReportData> reportData = JsonConvert.DeserializeObject<List<ReportData>>(Request.Form["ReportData"]);
            StringBuilder sb = new StringBuilder();
            DataTable dt = new DataTable();
            string Period = string.Empty;
            if (reportData[0].reportName == "BillWiseReport")
            {
                MySqlConnection con = Util.GetMySqlCon();
                con.Open();
                try
                {
                    sb.Append("  SELECT  if(fpm.paneltype<>'Centre',fpm.paneltype,if(cm.type1='PCC',CONCAT(cm.type1,'-',cm.coco_foco),cm.type1)) BusinessType,plo.BillNo,lt.Patient_ID UHIDNo,lt.PName PatientName, ");
                    sb.Append("  plo.LedgerTransactionNo VisitNo,DATE_FORMAT(plo.Date,'%d-%b-%Y') billDate,lt.DoctorName,");
                    sb.Append("  cm.CentreCode TaggedLabCode,cm.Centre TaggedLabName, ");
                    sb.Append("  SUM(plo.Rate*plo.Quantity) TotalAmt,SUM(plo.DiscountAmt) DiscountAmt,SUM(plo.Amount) NetAmt, ");
                    sb.Append("  plo.CreatedBy UserName,IF(lt.HLMPatientType='IPD','IP','OP') OPIPFlag,pm.Email MailId,pm.Mobile MobileNumber, ");
                    sb.Append("  IF(lt.IsCredit=1,SUM(plo.Amount),0) CustomerCreditAmount,IF(lt.IsCredit=0,SUM(plo.Amount),0)CustomerCashAmount, ");
                    sb.Append("  lt.HLMOPDIPDNo ReferenceNumber,lt.PanelName `ClientName`,fpm.Panel_Code `ClientCode`, ");
                    sb.Append("  DATE_FORMAT(plo.Date,'%d-%b-%Y %I:%i%p') CreatedDate, ");
                    sb.Append("  IF(lt.VisitType='Home Collection','Yes','No') HomeCollection, ");
                    sb.Append("  IF(lt.VisitType!='Home Collection','',(SELECT NAME FROM feildboy_master  WHERE `FeildboyID`=lt.`HomeVisitBoyID` LIMIT 1  )) FieldBoyName,  ");
                    sb.Append("  IF(lt.Revisit=1,'Yes','No')Revisit,  ");
                    sb.Append("  lt.username_web web_login_id,lt.Password_web web_login_pswd,lt.PatientSource, lt.OtherLabRefNo,lt.PreBookingID ");
                    sb.Append("  FROM f_ledgertransaction lt ");
                    sb.Append("   INNER JOIN `patient_labinvestigation_opd` plo ON plo.LedgerTransactionid=lt.LedgerTransactionid  ");
                    sb.Append("   INNER JOIN patient_master pm ON pm.patient_id=lt.patient_id  ");
                    sb.Append("   INNER JOIN f_panel_master fpm ON fpm.Panel_ID=lt.panel_id  ");
                    sb.Append("  INNER JOIN centre_master cm ON cm.CentreID=lt.CentreID INNER JOIN doctor_referal dr ON dr.Doctor_ID=lt.Doctor_ID  ");
                    sb.Append("  WHERE lt.Date>=@fromDate AND lt.Date<=@toDate  ");
                    sb.Append("  AND lt.CentreID IN ({0}) ");
                    if (reportData[0].billNo != string.Empty)
                        sb.Append("     AND lt.BillNo=@BillNo");
                    sb.Append(" GROUP BY plo.BillNo ");

                    string[] centreTags = String.Join(",", reportData[0].centreID).Split(',');
                    string[] centreParamNames = centreTags.Select(
                      (s, i) => "@tag" + i).ToArray();
                    string centreClause = string.Join(", ", centreParamNames);
                    using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString(), centreClause), con))
                    {
                        for (int i = 0; i < centreParamNames.Length; i++)
                        {
                            da.SelectCommand.Parameters.AddWithValue(centreParamNames[i], centreTags[i]);
                        }
                        da.SelectCommand.Parameters.AddWithValue("@BillNo", reportData[0].billNo);
                        da.SelectCommand.Parameters.AddWithValue("@fromDate", string.Concat(Util.GetDateTime(reportData[0].fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00"));
                        da.SelectCommand.Parameters.AddWithValue("@toDate", string.Concat(Util.GetDateTime(reportData[0].toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"));
                        da.Fill(dt);
                        sb = new StringBuilder();
                        Period = string.Concat("From : ", Util.GetDateTime(reportData[0].fromDate).ToString("dd-MMM-yyyy"), " To : ", Util.GetDateTime(reportData[0].toDate).ToString("dd-MMM-yyyy"));
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

            using (dt as IDisposable)
            {
                if (dt.Rows.Count > 0)
                {
                    string ReportName = Request.Form["ReportName"];
                    if (Request.Form["IsAutoIncrement"] == "1")
                    {
                        using (DataTable dtIncremented = new DataTable(dt.TableName))
                        {
                            DataColumn dc = new DataColumn("ID");
                            dc.AutoIncrement = true;
                            dc.AutoIncrementSeed = 1;
                            dc.AutoIncrementStep = 1;
                            dc.DataType = System.Type.GetType("System.Int32");
                            dtIncremented.Columns.Add(dc);
                            dtIncremented.BeginLoadData();
                            DataTableReader dtReader = new DataTableReader(dt);
                            dtIncremented.Load(dtReader);
                            dtIncremented.EndLoadData();
                            dtIncremented.AcceptChanges();
                        }
                    }

                    BindData(dt, ReportName, Period);
                    lblHeader.Text = ReportName;
                    lblPeriod.Text = Period;
                }
                else
                {
                    lblmsg.Text = "No Record Found";
                    btnExport.Visible = false;
                }
            }
        }
    }
    public MemoryStream GetStream(XLWorkbook excelWorkbook)
    {
        using (MemoryStream fs = new MemoryStream())
        {
            excelWorkbook.SaveAs(fs);
            fs.Position = 0;
            return fs;
        }
    }
    protected void BindData(DataTable dt, String ReportName, String Period)
    {
        lblmsg.Text = string.Empty;
        try
        {
            dt.TableName = "data";

            using (var wb = new XLWorkbook())
            {
                // Add a DataTable as a worksheet
                string WorksheetName = ReportName.Length > 30 ? ReportName.Substring(0, 30) : ReportName;
                var ws = wb.Worksheets.Add(WorksheetName);
                ws.Cell(1, 4).Style.Font.Bold = true;
                ws.Cell(2, 4).Style.Font.Bold = true;
                ws.Cell(1, 4).InsertData(new System.Collections.Generic.List<string[]> { new string[] { ReportName.ToString() } });
                ws.Cell(2, 4).InsertData(new System.Collections.Generic.List<string[]> { new string[] { string.Concat(Period.ToString(), "  (Print Date Time : ", DateTime.Now.ToString("dd-MMM-yyyy hh:mm tt"), ")") } });
                ws.Cell(3, 1).InsertTable(dt);

                using (MemoryStream stream = GetStream(wb))
                {
                    string attachment = string.Concat("attachment; filename=", ReportName.ToString(), ".xlsx");
                    Response.ClearContent();
                    Response.AddHeader("content-disposition", attachment);
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.BinaryWrite(stream.ToArray());
                    stream.Close();
                    stream.Dispose();
                    // Response.End();
                    Response.Flush();
                    // Response.Clear();
                    HttpContext.Current.Response.SuppressContent = true;
                    HttpContext.Current.ApplicationInstance.CompleteRequest();
                }
            }
        }
        catch (Exception ex)
        {
            lblmsg.Text = ex.Message;
        }
        finally
        {
        }
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        btnExport.Visible = false;
        lblmsg.Visible = false;

        string ReportName = lblHeader.Text;

        Response.Clear();
        //   application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
        Response.AddHeader("content-disposition", "attachment;filename=" + ReportName + ".xls");
        Response.Charset = "";
        Response.ContentType = "application/vnd.xls";

        StringWriter StringWriter = new System.IO.StringWriter();
        HtmlTextWriter HtmlTextWriter = new HtmlTextWriter(StringWriter);
        this.RenderControl(HtmlTextWriter);

        Response.Write(StringWriter.ToString());
        // Response.Clear();
        // Response.End();

        btnExport.Visible = true;
        lblmsg.Visible = true;
    }

    public class ReportData
    {
        public string fromDate { get; set; }
        public string toDate { get; set; }
        public string billNo { get; set; }
        public string centreID { get; set; }
        public string reportName { get; set; }
    }

    public class RootObject
    {
        public List<ReportData> ReportData { get; set; }
        public string ReportName { get; set; }
        public string Period { get; set; }
        public string ReportPath { get; set; }
    }
}