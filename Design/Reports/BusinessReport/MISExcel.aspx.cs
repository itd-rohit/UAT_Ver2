using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Text;
using System.Data;
using System.IO;
using ClosedXML.Excel;
using MySql.Data.MySqlClient;

public partial class Design_MIS_MISExcel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ucDateFrom.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");
            ucDateTo.Text = System.DateTime.Now.ToString("dd-MMM-yyyy");

        }
        ucDateFrom.Attributes.Add("readOnly", "true");
        ucDateTo.Attributes.Add("readOnly", "true");
    }
    protected void btnReport_Click(object sender, EventArgs e)
    {
        string url = "";
        if (rblReportType.SelectedItem.Value == "1")
            url = Server.MapPath("~/Design/Reports/Transactional.xlsx");
        else
            url = Server.MapPath("~/Design/Reports/Clinical.xlsx");

        if (File.Exists(url))
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                StringBuilder sbQry = new StringBuilder();
                if (rblReportType.SelectedItem.Value == "1")
                {
                    sbQry.Append("   SELECT t.*,t.GrossAmt TotalBilledAmt,t.PanelName Company_Name,SM.Name SubGroupName,CM.Name GroupName,Pm.PName,pm.Mobile,t2.ReceiptNo,t.centreID,t.centreName      ");
                    sbQry.Append(" FROM (  ");
                    sbQry.Append(" SELECT t.DoctorID,t.doctor,t.LedgerTransactionNo,t.Amount,t.Rate,t.Quantity,(t.Rate*t.Quantity)GrossAmt, ");
                    sbQry.Append("  (t.DiscountAmt/(t.Rate*t.Quantity)*100) DiscountPercentage, t.DiscountAmt DisAmt,IF(t.IsPackage = 0,'No','Yes')Package,itemname, ");
                    sbQry.Append("  t.Panel_ID PanelID,t.PanelName,'' TransactionID,t.Date,t.BillNo,'OPD' TnxType,'' typeofTnx,t.GrossAmount BillAmt,t.ItemID,t.PatientID, ");
                    sbQry.Append("  SubCategoryID,t.centreID,t.centreName     FROM (  ");
                    sbQry.Append("   SELECT plo.SubCategoryID,plo.itemname,lt.`Doctor_ID` DoctorID,lt.DoctorName Doctor,lt.LedgerTransactionNo,plo.Amount, ");
                    sbQry.Append("   plo.Rate,plo.Quantity,Plo.DiscountAmt, plo.IsPackage,LT.Date,plo.BillNo,plo.ItemID,lt.GrossAmount ,lt.`Patient_ID` PatientID, ");
                    sbQry.Append("   plo.Date EntryDate,cmt.centreID,cmt.Centre centreName,lt.`Panel_ID`,lt.PanelName  ");
                    sbQry.Append("   FROM f_ledgertransaction lt  ");
                    sbQry.Append("   INNER JOIN patient_labinvestigation_opd plo  ");
                    sbQry.Append("  ON lt.LedgerTransactionID=plo.LedgerTransactionID   ");
                    sbQry.Append("  INNER JOIN centre_master cmt ON cmt.`CentreID`=lt.`CentreID` ");
                    sbQry.Append("   WHERE lt.Date  >= @fromdate AND lt.Date  <= @todate  ");
                    sbQry.Append("   )t  ");

                    sbQry.Append("   WHERE t.Date >= @fromdate AND T.Date <= @todate ");
                    sbQry.Append("   )t  ");
                    sbQry.Append("   INNER JOIN f_subcategorymaster SM ON SM.SubCategoryID = t.SubCategoryID  ");
                    sbQry.Append("   INNER JOIN f_categorymaster CM ON SM.CategoryID = CM.CategoryID  ");
                    sbQry.Append("   INNER JOIN patient_master PM ON pm.Patient_ID = t.PatientID  ");
                    sbQry.Append("   LEFT JOIN (  ");
                    sbQry.Append("   SELECT ReceiptNo,LedgerTransactionNo FROM f_receipt WHERE LedgerTransactionNo <> ''  ");
                    sbQry.Append("   AND CreatedDate >= @fromdate ");
                    sbQry.Append("   AND CreatedDate <= @todate  ");
                    sbQry.Append("    ) t2 ON T.LedgerTransactionNo = t2.LedgerTransactionNo  ORDER BY t.date  ");
                }
                else
                {
                    //Add Query for Patient Clinical data
                    sbQry.Clear();
                    sbQry.Append(" ");
                }

                DataTable dtExcel = MySqlHelper.ExecuteDataset(con, CommandType.Text, sbQry.ToString(),
                    new MySqlParameter("@fromdate", string.Concat(Util.GetDateTime(ucDateFrom.Text).ToString("yyyy-MM-dd")," 00:00:00")),
                    new MySqlParameter("@todate", string.Concat(Util.GetDateTime(ucDateTo.Text).ToString("yyyy-MM-dd")," 23:59:59"))).Tables[0];

                if (dtExcel.Rows.Count > 0)
                {
                    XLWorkbook wb = new XLWorkbook(url);
                    StringBuilder sb = new StringBuilder();

                    var sheet = wb.Worksheet("RowData");

                    var source = sheet.Cell(1, 1).InsertTable(dtExcel, true);
                    Response.Clear();
                    Response.Buffer = true;
                    Response.Charset = "";
                    Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                    Response.AddHeader("content-disposition", "attachment;filename=MISExcel.xlsx");
                    using (MemoryStream MyMemoryStream = new MemoryStream())
                    {
                        wb.SaveAs(MyMemoryStream);
                        MyMemoryStream.WriteTo(Response.OutputStream);
                        Response.Flush();
                        //Response.End();
                    }
                }
                else
                    lblMsg.Text = "Record Not Found";
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "alert('" + ex.Message + "');", true);
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
    }
}