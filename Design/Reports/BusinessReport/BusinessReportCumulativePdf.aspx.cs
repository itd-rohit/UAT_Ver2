using HiQPdf;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Web;

public partial class Design_Reports_BusinessReport_BusinessReportCumulativePdf : System.Web.UI.Page
{
    PdfDocument document;
    PdfDocument tempDocument;
    PdfLayoutInfo html1LayoutInfo;

    int MarginLeft = 20;
    int MarginRight = 20;
    int PageWidth = 550;
    int BrowserWidth = 800;


    float HeaderHeight = 70;//207
    int XHeader = 20;//20
    int YHeader = 20;//80
    int HeaderBrowserWidth = 800;


    //Footer Property 80
    float FooterHeight = 50;
    int XFooter = 20;
    string Period = "";
    string ReportType = "";
    string ReportOption = "";
    DataTable dt=new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            document = new PdfDocument();
            tempDocument = new PdfDocument();
            document.SerialNumber = Resources.Resource.HiQPdfSerialNumber;
            try
            {
                StringBuilder sb = new StringBuilder();
                try
                {
                    using (dt = ((DataTable)Session["BusinessCumulativeReport"]))
                    {

                        if (dt != null && dt.Rows.Count > 0)
                        {
                            Period = string.Concat(" Period :", Util.GetString(Session["Period"]));
                            ReportType = Util.GetString(Session["ReportName"].ToString().Split('&')[0]);
                            ReportOption = Util.GetString(Session["ReportName"].ToString().Split('&')[1]);
                            sb = new StringBuilder();
                            sb.Append(" <div style='width:1300px;'> ");
                            sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;'>");

                            if (ReportType == "Cumulative" && ReportOption == "ClientWise")
                            {
                                int j = 1;
                                for (int i = 0; i < dt.Rows.Count; i++)
                                {

                                    sb.Append("<tr> ");
                                    sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>"+j+"</td> ");
                                    sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["ClientName"]));
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["ClientType"]));
                                    sb.AppendFormat(" <td style='width: 9%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["BusinessUnit"]));
                                    sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["GrossSales"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 7%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["Disc"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 8%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["NetSales"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: %;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["Pt_Count"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["SampleCount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["CashSameDate"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["BankSameDate"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["CollectionSameDay"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["Cash_OS_Same_Day"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["Cr_SalesSameDay"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["CashPrev_Day"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["BankPrev_Day"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["TotalReceivedAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["TotalCashAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 5%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["TotalBankAmount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);


                                    sb.Append(" </tr> ");
                                    j = j + 1;
                                }
                                sb.Append("<tr> ");
                                sb.Append(" <td colspan='3' style='text-align:right;font-weight: bold;' >Total: </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("GrossSales"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Disc"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("NetSales"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Int64>("Pt_Count"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Int64>("SampleCount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("CashSameDate"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");

                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("BankSameDate"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("CollectionSameDay"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Cash_OS_Same_Day"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Cr_SalesSameDay"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("CashPrev_Day"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("BankPrev_Day"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");

                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("TotalReceivedAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("TotalCashAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("TotalBankAmount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td colspan='12' style='text-align:right;font-weight: bold;' ></td> ");
                                sb.Append(" </tr> ");

                            }
                            else if (ReportType == "Cumulative" && ReportOption == "DepartmentWise")
                            {
                                for (int i = 0; i < dt.Rows.Count; i++)
                                {
                                    sb.Append("<tr> ");
                                    sb.AppendFormat(" <td style='width: 25%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Util.GetString(dt.Rows[i]["Department"]));

                                    sb.AppendFormat(" <td style='width: 15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["Rate"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["Disc"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["Net"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["PatientCount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.AppendFormat(" <td style='width: 15%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", Math.Round(Util.GetDecimal(dt.Rows[i]["SampleCount"]), Util.GetInt(Resources.Resource.BaseCurrencyRound)), MidpointRounding.AwayFromZero);
                                    sb.Append(" </tr> ");
                                }
                                sb.Append("<tr> ");
                                sb.Append(" <td style='text-align:right;font-weight: bold;' >Total : </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Rate"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Disc"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<decimal>("Net"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Int64>("PatientCount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" <td  style='border-bottom: 3px solid;padding-top: 3px;font-size: 16px;'><span style='font-weight: bold;float: left;'>" + Math.Round(Util.GetDecimal(dt.AsEnumerable().Sum(x => x.Field<Int64>("SampleCount"))), Util.GetInt(Resources.Resource.BaseCurrencyRound), MidpointRounding.AwayFromZero) + "</span> </td> ");
                                sb.Append(" </tr> ");
                            }
                            else if (ReportType == "Cumulative" && ReportOption == "TestWise")
                            {
                                //Adding DataRow.

                                sb.Append(" <tr> ");
                                foreach (DataColumn column in dt.Columns)//set table header dynamic
                                {
                                    sb.Append(" <td style='width: 10%;font-weight: bold;border-bottom: 2px solid;border-top: 2px solid;font-size: 16px !important;word-wrap: break-word;padding-bottom:30px;'>" + column.ColumnName.ToString() + "</td> ");
                                }
                                sb.Append(" </tr> ");

                                foreach (DataRow row in dt.Rows)//set table row dynamic
                                {
                                    sb.Append("<tr>");
                                    foreach (DataColumn column in dt.Columns)
                                    {
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", row[column.ColumnName].ToString());
                                    }
                                    sb.Append("</tr>");
                                }
                            }
                            else if (ReportType == "MonthWiseTrend" && ReportOption == "ClientWise")
                            {
                                //Adding DataRow.

                                sb.Append(" <tr> ");
                                foreach (DataColumn column in dt.Columns)//set table header dynamic
                                {
                                    sb.Append(" <td style='width: 10%;font-weight: bold;border-bottom: 2px solid;border-top: 2px solid;font-size: 16px !important;word-wrap: break-word;padding-bottom:30px;'>" + column.ColumnName.ToString() + "</td> ");
                                }
                                sb.Append(" </tr> ");

                                foreach (DataRow row in dt.Rows)//set table row dynamic
                                {
                                    sb.Append("<tr>");
                                    foreach (DataColumn column in dt.Columns)
                                    {
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", row[column.ColumnName].ToString());
                                    }
                                    sb.Append("</tr>");
                                }
                            }
                            else if (ReportType == "MonthWiseTrend" && ReportOption == "DepartmentWise")
                            {
                                //Adding DataRow.

                                sb.Append(" <tr> ");
                                foreach (DataColumn column in dt.Columns)//set table header dynamic
                                {
                                    sb.Append(" <td style='width: 10%;font-weight: bold;border-bottom: 2px solid;border-top: 2px solid;font-size: 16px !important;word-wrap: break-word;padding-bottom:30px;'>" + column.ColumnName.ToString() + "</td> ");
                                }
                                sb.Append(" </tr> ");

                                foreach (DataRow row in dt.Rows)//set table row dynamic
                                {
                                    sb.Append("<tr>");
                                    foreach (DataColumn column in dt.Columns)
                                    {
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", row[column.ColumnName].ToString());
                                    }
                                    sb.Append("</tr>");
                                }
                            }
                            else if (ReportType == "MonthWiseTrend" && ReportOption == "TestWise")
                            {
                                //Adding DataRow.

                                sb.Append(" <tr> ");
                                foreach (DataColumn column in dt.Columns)//set table header dynamic
                                {
                                    sb.Append(" <td style='width: 10%;font-weight: bold;border-bottom: 2px solid;border-top: 2px solid;font-size: 16px !important;word-wrap: break-word;padding-bottom:30px;'>" + column.ColumnName.ToString() + "</td> ");
                                }
                                sb.Append(" </tr> ");

                                foreach (DataRow row in dt.Rows)//set table row dynamic
                                {
                                    sb.Append("<tr>");
                                    foreach (DataColumn column in dt.Columns)
                                    {
                                        sb.AppendFormat(" <td style='width: 10%;border-bottom: 1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", row[column.ColumnName].ToString());
                                    }
                                    sb.Append("</tr>");
                                }
                            }
                            else if (ReportType == "DateWiseTrend" && ReportOption == "ClientWise")
                            {

                                sb.Append(" <tr> ");
                                foreach (DataColumn column in dt.Columns)//set table header dynamic
                                {
                                    sb.Append(" <td style='width: 5%;font-weight: bold;border:1px solid;font-size: 16px !important;word-wrap: break-word;padding-bottom:30px;'>" + column.ColumnName.ToString() + "</td> ");
                                }
                                sb.Append(" </tr> ");

                                foreach (DataRow row in dt.Rows)//set table row dynamic
                                {
                                    sb.Append("<tr>");
                                    foreach (DataColumn column in dt.Columns)
                                    {
                                        sb.AppendFormat(" <td style='width: 5%;border:1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", row[column.ColumnName].ToString());
                                    }
                                    sb.Append("</tr>");
                                }
                            }
                            else if (ReportType == "DateWiseTrend" && ReportOption == "DepartmentWise")
                            {

                                sb.Append(" <tr> ");
                                foreach (DataColumn column in dt.Columns)//set table header dynamic
                                {
                                    sb.Append(" <td style='width: 5%;font-weight: bold;border:1px solid;font-size: 16px !important;word-wrap: break-word;padding-bottom:30px;'>" + column.ColumnName.ToString() + "</td> ");
                                }
                                sb.Append(" </tr> ");

                                foreach (DataRow row in dt.Rows)//set table row dynamic
                                {
                                    sb.Append("<tr>");
                                    foreach (DataColumn column in dt.Columns)
                                    {
                                        sb.AppendFormat(" <td style='width: 5%;border:1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", row[column.ColumnName].ToString());
                                    }
                                    sb.Append("</tr>");
                                }
                            }
                            else if (ReportType == "DateWiseTrend" && ReportOption == "TestWise")
                            {

                                sb.Append(" <tr style='border:1px solid'> ");
                                foreach (DataColumn column in dt.Columns)//set table header dynamic
                                {
                                    sb.Append(" <td style='width: 5%;font-weight: bold;border:1px solid;font-size: 16px !important;word-wrap: break-word;padding-bottom:30px;'>" + column.ColumnName.ToString() + "</td> ");
                                }
                                sb.Append(" </tr> ");

                                foreach (DataRow row in dt.Rows)//set table row dynamic
                                {
                                    sb.Append("<tr style='border:1px solid'>");
                                    foreach (DataColumn column in dt.Columns)
                                    {
                                        sb.AppendFormat(" <td style='width: 5%;border:1px solid;font-size: 14px !important;word-wrap: break-word;'>{0}</td> ", row[column.ColumnName].ToString());
                                    }
                                    sb.Append("</tr>");
                                }
                            }
                            sb.Append("</table>");
                            sb.Append("</div>");

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
                            Response.Write("<center> <span style='text-align:centre;font-weight:bold;color:red;font-size:20px;'> No Record Found<span><br/></center>");
                            return;
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
                Session["BusinessCumulativeReport"] = "";
                Session["ReportName"] = "";
                Session["Period"] = "";
                Session.Remove("BusinessCumulativeReport");
                Session.Remove("ReportName");
                Session.Remove("Period");
            }
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
        if (ReportType == "Cumulative" && ReportOption != "TestWise")
        {
          //  YHeader = YHeader;
        }
        else
        {
            YHeader = YHeader + 20;

        }
        PdfHtml headerHtml = new PdfHtml(XHeader, YHeader, PageWidth, MakeHeader(), null);
        headerHtml.FitDestWidth = true;
        headerHtml.FontEmbedding = false;
        headerHtml.BrowserWidth = HeaderBrowserWidth;
        page.Header.Layout(headerHtml);

    }
    private string MakeHeader()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" <div style='width:1300px;'> ");
        sb.Append("<table style='width: 1300px;border-collapse: collapse;font-family:Arial;'>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;'>");

        sb.AppendFormat("<span style='font-weight: bold;font-size:20px;'>{0}</span><br />",string.Concat(ReportType," & ",ReportOption," Report"));

        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("<tr>");
        sb.Append("<td style='width:100%; text-align: center;padding-top: 1em;'>");
        sb.AppendFormat(" <span style='font-size: 14px;'>{0}</span>", Period);
        sb.Append("</td>");
        sb.Append("</tr>");
        sb.Append("</table>");
        sb.Append(" </div> ");
        if (ReportType == "Cumulative" && ReportOption!="TestWise")
        {
            sb.Append(" <div style='width:1300px;'>");
            sb.Append("<table style='width:1300px;border-top:2px solid #000;border-bottom:2px solid #000; font-family:Times New Roman;font-size:16px;'>");
            if (ReportType == "Cumulative" && ReportOption == "ClientWise")
            {
                sb.Append(" <tr> ");
                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Sr.No</td> ");
                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Client Name</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Client Type</td> ");
                sb.Append(" <td style='width: 9%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Business Unit</td> ");
                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>GrossSales</td> ");
                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Disc</td> ");
                sb.Append(" <td style='width: 7%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetSales</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Pt Count</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Sample Count</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Cash S.Date</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Bank S.Date</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Coll. S.Day</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Cash_OS S.Day</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Cr_Sales S.Day</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>CashPrev Day</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>BankPrev Day</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>TRec Amt</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>TCash Amt</td> ");
                sb.Append(" <td style='width: 5%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>TBank Amt</td> ");
                sb.Append(" </tr> ");
            }
            else if (ReportType == "Cumulative" && ReportOption == "DepartmentWise")
            {
                sb.Append(" <tr> ");
                sb.Append(" <td style='width: 25%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Dapartment Name</td> ");
                sb.Append(" <td style='width: 15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Rate</td> ");
                sb.Append(" <td style='width: 15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Disc</td> ");
                sb.Append(" <td style='width: 15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>NetAmt</td> ");
                sb.Append(" <td style='width: 15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Patient Count</td> ");
                sb.Append(" <td style='width: 15%;font-weight: bold;font-size: 16px !important;word-wrap: break-word;'>Sample Count</td> ");
                sb.Append(" </tr> ");
            }

            sb.Append("</table>");
            sb.Append(" </div> ");
        }
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
        html1 = new PdfHtml(MarginLeft, ((html1LayoutInfo == null) ? 0 : html1LayoutInfo.LastPageRectangle.Height), PageWidth, Content, null);
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