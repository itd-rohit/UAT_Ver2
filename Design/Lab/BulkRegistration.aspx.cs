using ClosedXML.Excel;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Master_BulkRegistration : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindAllData();
        }
    }
    private void bindAllData()
    {

    }
    private DataTable getExcelDetail()
    {
        DataTable dt = new DataTable();
        dt.TableName = "Orders";
        dt.Columns.Add("CENTRE CODE");
        dt.Columns.Add("CLIENT CODE");
        dt.Columns.Add("TITLE");
        dt.Columns.Add("PATIENT NAME");
        dt.Columns.Add("AGE in Year");
        dt.Columns.Add("AGE in Month");
        dt.Columns.Add("AGE in Days");
        dt.Columns.Add("GENDER");
        dt.Columns.Add("MOBILE");
        //dt.Columns.Add("CITY");
        dt.Columns.Add("ADDRESS");
        dt.Columns.Add("TEST CODE");
        dt.Columns.Add("SAMPLE ID");
        dt.Columns.Add("REFER DOCTOR");
        //dt.Columns.Add("COLLECTION DATE", typeof(string));
        dt.Columns.Add("SRF ID");
        dt.Columns.Add("EMAIL");

        DataRow dr1 = dt.NewRow();
        dr1["CENTRE CODE"] = "1";
        dr1["CLIENT CODE"] = "78";
        dr1["TITLE"] = "Mr.";
        dr1["PATIENT NAME"] = "Name";
        dr1["MOBILE"] = "8888888888";
        dr1["AGE in Year"] = "23";
        dr1["AGE in Month"] = "1";
        dr1["AGE in Days"] = "1";
        dr1["GENDER"] = "Male";
        dr1["REFER DOCTOR"] = "Self";
     //   dr1["COLLECTION DATE"] = "*2020-12-03 12:00:01";
        dr1["SRF ID"] = "0000000000";
        dr1["ADDRESS"] = "";
        //dr1["CITY"] = "";
        dr1["SAMPLE ID"] = "";
        dr1["EMAIL"] = "";
        dr1["TEST CODE"] = "7831";
        dt.Rows.Add(dr1.ItemArray);

        return dt;
    }

    public void exportExcel()
    {
        DataTable dt = getExcelDetail();
        string excelName = DateTime.Now.ToString("ddMMyyyyhhmmssfffff");
        using (XLWorkbook wb = new XLWorkbook())
        {
            excelName = excelName.Replace(",", "");
            var ws = wb.Worksheets.Add(dt, excelName.Trim());
            Response.Clear();
            Response.Buffer = true;
            Response.Charset = string.Empty;
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("content-disposition", "attachment;filename=" + excelName + ".xls");
            using (MemoryStream MyMemoryStream = new MemoryStream())
            {
                wb.SaveAs(MyMemoryStream);
                MyMemoryStream.WriteTo(Response.OutputStream);
                Response.Flush();
                Response.End();
                // Response.Clear();
            }
        }
        //btnDownloadExcel.Enabled = false;
        //btnDownloadExcel.Text = "Download Excel";
    }
    public class Panel_Code
    {
        public string ClientCode { get; set; }
        public int Panel_ID { get; set; }
        public int ReferenceCode { get; set; }
    }
    public class Centre_Code
    {
        public string CentreCode { get; set; }
        public int CentreID { get; set; }
    }
    public class TableColumnHeader
    {
        public string ColumnName { get; set; }
    }
    public class BarCodeData
    {
        public string BarCode_No { get; set; }
    }
    public class sampleTypeName
    {
        public string sampleType { get; set; }
        public int sampleTypeID { get; set; }
    }
    public class TestCodeDetail
    {
        public string TestCode { get; set; }
        public int ItemID { get; set; }
    }
    public class DictinctDetail
    {
        public string BarcodeNo { get; set; }
        public string PName { get; set; }
        public string MobileNo { get; set; }
    }
    protected void btnDownloadExcel_Click(object sender, EventArgs e)
    {
        exportExcel();
    }
    public static DataTable getExcelDatatable(byte[] b)
    {
        //Create a new DataTable.
        DataTable dt = new DataTable();
        dt.TableName = "WorkOrder";
        System.IO.Stream stream = new System.IO.MemoryStream(b);
        using (ClosedXML.Excel.XLWorkbook workBook = new ClosedXML.Excel.XLWorkbook(stream))
        {
            //Read the first Sheet from Excel file.
            ClosedXML.Excel.IXLWorksheet workSheet = workBook.Worksheet(1);



            //Loop through the Worksheet rows.
            bool firstRow = true;
            foreach (ClosedXML.Excel.IXLRow row in workSheet.Rows())
            {
                //Use the first row to add columns to DataTable.
                if (firstRow)
                {
                    foreach (ClosedXML.Excel.IXLCell cell in row.Cells())
                    {
                        dt.Columns.Add(cell.Value.ToString().Trim());
                    }
                    firstRow = false;
                }
                else
                {
                    //Add rows to DataTable.
                    DataRow dr = dt.NewRow();
                    string temp = "";
                    int i = 0;
                    for (int j = 1; j <= dt.Columns.Count; j++)
                    {
                        ClosedXML.Excel.IXLCell cell = row.Cell(j);
                        //if (j == 7 && cell.Value.ToString().Trim() != string.Empty)
                        //{
                        //    cell.Style.DateFormat.Format = "dd-MM-yyyy";
                        //    cell.SetDataType(XLCellValues.DateTime);
                        //}
                        //if (j == 22 && cell.Value.ToString().Trim() != string.Empty)
                        //{
                        //    cell.Style.DateFormat.Format = "dd-MM-yyyy HH:mm:ss";
                        //    cell.SetDataType(XLCellValues.DateTime);


                        //}
                        //if (j == 23 && cell.Value.ToString().Trim() != string.Empty)
                        //{

                        //    cell.Style.DateFormat.Format = "dd-MM-yyyy HH:mm:ss";
                        //    cell.SetDataType(XLCellValues.DateTime);
                        //}
                        temp += "" + cell.Value.ToString();
                        temp = temp.Trim();
                        dr[i] = cell.Value.ToString().Trim();

                        i++;
                    }
                    if (temp != "")
                    {
                        dt.Rows.Add(dr);
                    }
                }
            }
        }
        return dt;
    }

    protected void btnUpload_Click(object sender, EventArgs e)
    {
        if (txtWitness.Text.Trim() == string.Empty)
        {
            lblMsg.Text = string.Concat("Please Select File");
            return;
        }
        if (!fuExcel.HasFile)
        {
            lblMsg.Text = string.Concat("Please Select File");
            return;
        }
        string[] validFileTypes = { "xlsx", "xls" };
        string ext = Path.GetExtension(fuExcel.FileName);
        bool isValidFile = false;
        for (int i = 0; i < validFileTypes.Length; i++)
        {
            if (ext == "." + validFileTypes[i])
            {
                isValidFile = true;
                break;
            }
        }
        if (!isValidFile)
        {
            lblMsg.Text = string.Concat("Invalid File. Please upload a File with extension ", string.Join(",", validFileTypes));
            return;
        }
        FileUpload fl = fuExcel;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (fl != null)
            {
                BinaryReader b = new BinaryReader(fl.PostedFile.InputStream);
                byte[] binData = b.ReadBytes(fl.PostedFile.ContentLength);
                using (DataTable dt = getExcelDatatable(binData))
                {
                    if (dt.Rows.Count == 0)
                    {
                        lblMsg.Text = "Please Add data in Excel";
                        return;
                    }
                    List<string> dtColumnNames = dt.Columns.Cast<DataColumn>().Select(x => x.ColumnName).ToList();
                    List<string> dtTableNames = getExcelDetail().Columns.Cast<DataColumn>().Select(x => x.ColumnName).ToList();
                    var notMachColumn = dtColumnNames.Except(dtTableNames, StringComparer.OrdinalIgnoreCase).ToList();
                    if (notMachColumn.Count > 0)
                    {
                        lblMsg.Text = string.Concat("Please Enter Valid Header,Invalid Header Is ", string.Join(",", notMachColumn.ToArray()));
                        return;
                    }
                    dtColumnNames.Clear();
                    dtTableNames.Clear();


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

                        DataColumn dc1 = new DataColumn("WorkOrderID");
                        dtIncremented.Columns.Add(dc1);
                        dtIncremented.AcceptChanges();
                        //  var distinctValues = dtIncremented.AsEnumerable()
                        //.Select(row => new
                        //{
                        //    TESTCODE = row.Field<string>("TEST CODE"),
                        //    PName = row.Field<string>("PATIENT NAME*"),
                        //    MobileNo = row.Field<string>("PHONE NUMBER")
                        //})
                        //.Distinct();

                        //  if (distinctValues.Count() > 0)
                        //  {
                        //      lblMsg.Text = string.Concat("Please Enter Valid Data,Duplicate data found in Excel  : ", string.Join(" ,", String.Join(",", distinctValues.Select(s => string.Concat(s.PName, "#", s.MobileNo, "#", s.TESTCODE)))));
                        //     // return;
                        //  }
                        //SelectMany(dupRec => dupRec);

                        var distinctTest = dtIncremented.AsEnumerable().GroupBy(r1 => new
                             {
                                 SAMPLEID = r1.Field<string>("SAMPLE ID"),
                                 PATIENTNAME = r1.Field<string>("PATIENT NAME")
                             }).Where(gr => gr.Count() > 1).Select(g => g.Key).ToList();

                        if (distinctTest.Count() > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Data,Duplicate data found in Excel  : ", string.Join("  ,", String.Join(",", distinctTest.Select(s => string.Concat(s.PATIENTNAME, "#", s.SAMPLEID)))));
                            return;
                        }

                        var SAMPLEIDCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["SAMPLE ID"].ToString())).AsDataView().Count;
                        if (SAMPLEIDCount > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter SAMPLE ID in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("SAMPLE ID") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }



                        var NameCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["PATIENT NAME"].ToString())).AsDataView().Count;
                        if (NameCount > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter PATIENT NAME in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("PATIENT NAME") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }



                        //var MobileCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["PHONE NUMBER"].ToString())).AsDataView().Count;
                        //if (MobileCount > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Please Enter PHONE NUMBER in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("PHONE NUMBER") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}
                        //long num2;
                        //var MobileChkInt = dt.AsEnumerable().Where(myRow => !long.TryParse(myRow.Field<String>("PHONE NUMBER"), out num2)).Count();
                        //if (MobileChkInt > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Please Enter Valid PHONE NUMBER in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !long.TryParse(myRow.Field<String>("PHONE NUMBER"), out num2)).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}
                        ////To Check PHONE NUMBER Length
                        //List<string> MobileLength = dt.AsEnumerable().Select(row => row.Field<string>("PHONE NUMBER")).ToList();
                        //if (MobileLength.Count > 0)
                        //{
                        //    if (MobileLength.Where(x => x.Length > 10).Count() > 0)
                        //    {
                        //        lblMsg.Text = string.Concat("Please Enter Valid PHONE NUMBER Invalid PHONE NUMBER is :", string.Join(" ,", MobileLength.Where(x => x.Length > 10).ToList()));
                        //        return;
                        //    }
                        //}
                        //MobileLength.Clear();

                        //DateTime date;
                        //var DOBInvalidDates = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString().Replace("*", ""))).Where(myRow => !DateTime.TryParse(myRow.Field<String>("DOB").Replace("*", ""), out date)).Count();
                        //if (DOBInvalidDates > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Please Enter Valid DOB in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !DateTime.TryParse(myRow.Field<String>("DOB").Replace("*", ""), out date)).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}

                        //DOBInvalidDates = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString().Replace("*", ""))).Where(myRow => Util.GetDateTime(myRow.Field<String>("DOB").Replace("*", "")) > DateTime.Now).Count();
                        //if (DOBInvalidDates > 0)
                        //{
                        //    lblMsg.Text = string.Concat("DOB Can not be Future Date,Please Enter Valid DOB in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString().Replace("*", ""))).Where(myRow => Util.GetDateTime(myRow.Field<String>("DOB").Replace("*", "")) > DateTime.Now).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}
                        //DOBInvalidDates = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString().Replace("*", ""))).Where(myRow => Util.GetDateTime(myRow.Field<String>("DOB").Replace("*", "")) < DateTime.Now.Date.AddYears(-110)).Count();
                        //if (DOBInvalidDates > 0)
                        //{
                        //    lblMsg.Text = string.Concat("DOB Can not be greater than 110 Years,Please Enter Valid DOB in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["DOB"].ToString().Replace("*", ""))).Where(myRow => Util.GetDateTime(myRow.Field<String>("DOB").Replace("*", "")) < DateTime.Now.Date.AddYears(-110)).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}


                        //var DOBCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["DOB"].ToString().Replace("*", "")) && string.IsNullOrWhiteSpace(r["AGE in Year"].ToString()) && string.IsNullOrWhiteSpace(r["Age in Month"].ToString()) && string.IsNullOrWhiteSpace(r["Age in Days"].ToString())).AsDataView().Count;
                        //if (DOBCount > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Please Enter DOB in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["DOB"].ToString().Replace("*", "")) && string.IsNullOrWhiteSpace(r["AGE in Year"].ToString()) && string.IsNullOrWhiteSpace(r["Age in Month"].ToString()) && string.IsNullOrWhiteSpace(r["Age in Days"].ToString())).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}

                        var AgeYears = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["AGE in Year"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Month"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Days"].ToString())).AsDataView().Count;
                        var AgeMonths = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Age in Month"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Year"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Days"].ToString())).AsDataView().Count;
                        var AgeDays = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Age in Days"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Year"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Month"].ToString())).AsDataView().Count;
                        if (AgeYears > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter AGE in Year in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["AGE in Year"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Month"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Days"].ToString())).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }
                        else if (AgeMonths > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Age in Month in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Age in Month"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Year"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Days"].ToString())).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }
                        else if (AgeDays > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Age in Days in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Age in Days"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Year"].ToString()) && !string.IsNullOrWhiteSpace(r["Age in Month"].ToString())).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }

                        int num1;
                        var YearsChkInt = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["AGE in Year"].ToString())).Where(myRow => !int.TryParse(myRow.Field<String>("AGE in Year"), out num1)).Count();
                        if (YearsChkInt > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid AGE in Year in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["AGE in Year"].ToString())).Where(myRow => !int.TryParse(myRow.Field<String>("AGE in Year"), out num1)).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }


                        var MonthsChkInt = dt.AsEnumerable().Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE in Month"))).Where(myRow => !int.TryParse(myRow.Field<String>("Age in Month"), out num1)).Count();
                        if (MonthsChkInt > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Age in Month in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE in Month"))).Where(myRow => !int.TryParse(myRow.Field<String>("Age in Month"), out num1)).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }
                        MonthsChkInt = dt.AsEnumerable().Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE in Month"))).Where(myRow => !int.TryParse(myRow.Field<String>("Age in Month"), out num1)).Count();
                        if (MonthsChkInt > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Age in Month in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE in Month"))).Where(myRow => !int.TryParse(myRow.Field<String>("Age in Month"), out num1)).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }
                        var DaysChkInt = dt.AsEnumerable().Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE in Days"))).Where(myRow => !int.TryParse(myRow.Field<String>("Age in Days"), out num1)).Count();
                        if (DaysChkInt > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Age in Days in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE in Days"))).Where(myRow => !int.TryParse(myRow.Field<String>("Age in Days"), out num1)).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }
                        DaysChkInt = dt.AsEnumerable().Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE in Days"))).Where(myRow => !int.TryParse(myRow.Field<String>("Age in Days"), out num1)).Count();
                        if (DaysChkInt > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Age in Days in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !string.IsNullOrWhiteSpace(myRow.Field<String>("AGE in Days"))).Where(myRow => !int.TryParse(myRow.Field<String>("Age in Days"), out num1)).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }

                        var YearsCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["AGE in Year"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("AGE in Year")) > 110).Count();
                        if (YearsCount > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid AGE in Year in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["AGE in Year"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("AGE ( in YEARS)")) > 110).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }
                        var MonthsCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Age in Month"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("Age in Month")) > 12).Count();
                        if (MonthsCount > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Age in Month in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Age in Month"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("AGE ( in MONTHS)")) > 12).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }

                        var DaysCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Age in Days"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("Age in Days")) > 30).Count();
                        if (DaysCount > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Age in Days in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Age in Days"].ToString())).Where(myRow => Util.GetInt(myRow.Field<string>("AGE ( in DAYS)")) > 30).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }

                        var GenderCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["GENDER"].ToString())).AsDataView().Count;
                        if (GenderCount > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter GENDER in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("GENDER") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }
                        int GenderMFCount = dt.AsEnumerable().Where(c => c.Field<String>("GENDER").ToUpper() != "MALE" && c.Field<String>("GENDER").ToUpper() != "FEMALE" && c.Field<String>("GENDER").ToUpper() != "TRANS").Count();
                        if (GenderMFCount > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid GENDER in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(c => c.Field<String>("GENDER").ToUpper() != "MALE" && c.Field<String>("GENDER").ToUpper() != "FEMALE" && c.Field<String>("GENDER").ToUpper() != "TRANS").Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }


                        //  var ClientCodeCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["CLIENT Code"].ToString())).AsDataView().Count;
                        //  if (ClientCodeCount > 0)
                        //  {
                        //      lblMsg.Text = string.Concat("Please Enter CLIENT Code in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("CLIENT Code") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                        //      return;
                        //  }

                        //var ClinicianNameCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["REFER DOCTOR"].ToString())).AsDataView().Count;
                        //if (ClinicianNameCount > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Please Enter REFER DOCTOR in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("REFER DOCTOR") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}
                        //var TestCodeCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["HOSPITAL NAME"].ToString())).AsDataView().Count;
                        //if (TestCodeCount > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Please Enter HOSPITAL NAME in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("HOSPITAL NAME") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}

                    //   var SampleDateCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["COLLECTION DATE"].ToString())).AsDataView().Count;
                    //   if (SampleDateCount > 0)
                    //   {
                    //       lblMsg.Text = string.Concat("Please Enter COLLECTION DATE in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("COLLECTION DATE") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                    //       return;
                    //   }
                    //
                    //   var SampleDateCountStartWithStar = dtIncremented.AsEnumerable().Where(r => r["COLLECTION DATE"].ToString().StartsWith("*")).AsDataView().Count;
                    //   if (SampleDateCountStartWithStar == 0)
                    //   {
                    //       lblMsg.Text = string.Concat("Please Enter COLLECTION DATE Start With * in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("COLLECTION DATE") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                    //       return;
                    //   }
                    //   DateTime date;
                    //
                    //   var SampleDateInvalidDates = dt.AsEnumerable().Where(myRow => !DateTime.TryParse(myRow.Field<String>("COLLECTION DATE").Replace("*", ""), out date)).Count();
                    //   if (SampleDateInvalidDates > 0)
                    //   {
                    //       lblMsg.Text = string.Concat("Please Enter Valid COLLECTION DATE in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !DateTime.TryParse(myRow.Field<String>("COLLECTION DATE"), out date)).Select(cc => cc.Field<int>("ID") + 1)));
                    //       return;
                    //   }
                    //   SampleDateCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["COLLECTION DATE"].ToString())).Where(myRow => Convert.ToDateTime(myRow.Field<String>("COLLECTION DATE").Replace("*", ""), CultureInfo.InvariantCulture) > DateTime.Now).Count();
                    //   if (SampleDateCount > 0)
                    //   {
                    //       lblMsg.Text = string.Concat("COLLECTION DATE Can not be Future Date,Please Enter Valid COLLECTION DATE in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["COLLECTION DATE"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("COLLECTION DATE").Replace("*", "")) > DateTime.Now).Select(cc => cc.Field<int>("ID") + 1)));
                    //       return;
                    //   }
                    //   SampleDateCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["COLLECTION DATE"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("COLLECTION DATE").Replace("*", "")).TimeOfDay.TotalSeconds == 0).Count();
                    //   if (SampleDateCount > 0)
                    //   {
                    //       lblMsg.Text = string.Concat("COLLECTION DATE,Please Enter Valid Time in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["COLLECTION DATE"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("COLLECTION DATE").Replace("*", "")).TimeOfDay.TotalSeconds == 0).Select(cc => cc.Field<int>("ID") + 1)));
                    //       return;
                    //   }
                        var SRFID = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["SRF ID"].ToString())).AsDataView().Count;
                        if (SRFID > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter SRFID in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("SRF ID") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }
                        ////SampleDateCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["COLLECTION DATE"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("COLLECTION DATE")) < DateTime.Now.Date.AddDays(-10)).Count();
                        ////if (SampleDateCount > 0)
                        ////{
                        ////    lblMsg.Text = string.Concat("COLLECTION DATE Can not be less then 10 Days,Please Enter Valid COLLECTION DATE in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["COLLECTION DATE"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("COLLECTION DATE")) < DateTime.Now.Date.AddDays(-10)).Select(cc => cc.Field<int>("ID") + 1)));
                        ////    return;
                        ////}

                        //var ReceivingDateCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Receiving Time"].ToString())).AsDataView().Count;
                        //if (ReceivingDateCount > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Please Enter Receiving Time in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("Receiving Time") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}

                        //var ReceivingDateCountStartWithStar = dtIncremented.AsEnumerable().Where(r => r["COLLECTION DATE"].ToString().StartsWith("*")).AsDataView().Count;
                        //if (ReceivingDateCountStartWithStar == 0)
                        //{
                        //    lblMsg.Text = string.Concat("Please Enter Receiving Time Start With * in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("COLLECTION DATE") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}

                        //DateTime ReceivingTime;
                        //var ReceivingInvalidDates = dt.AsEnumerable().Where(myRow => !DateTime.TryParse(myRow.Field<String>("Receiving Time").Replace("*", ""), out ReceivingTime)).Count();
                        //if (ReceivingInvalidDates > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Please Enter Valid Receiving Time in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(myRow => !DateTime.TryParse(myRow.Field<String>("Receiving Time").Replace("*", ""), out ReceivingTime)).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}
                        //ReceivingDateCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Receiving Time"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("Receiving Time").Replace("*", "")).TimeOfDay.TotalSeconds == 0).Count();
                        //if (ReceivingDateCount > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Receiving Time,Please Enter Valid Time in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Receiving Time"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("Receiving Time").Replace("*", "")).TimeOfDay.TotalSeconds == 0).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}

                        //ReceivingDateCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Receiving Time"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("Receiving Time").Replace("*", "")) > DateTime.Now).Count();
                        //if (ReceivingDateCount > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Receiving Time Can not be Future Date,Please Enter Valid Receiving Time in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Receiving Time"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("Receiving Time").Replace("*", "")) > DateTime.Now).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}
                        ////ReceivingDateCount = dt.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Receiving Time"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("Receiving Time")) < DateTime.Now.Date.AddDays(-10)).Count();
                        ////if (ReceivingDateCount > 0)
                        ////{
                        ////    lblMsg.Text = string.Concat("Receiving Time Can not be less then 10 Days,Please Enter Valid Receiving Time in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Receiving Time"].ToString())).Where(myRow => Util.GetDateTime(myRow.Field<String>("Receiving Time")) < DateTime.Now.Date.AddDays(-10)).Select(cc => cc.Field<int>("ID") + 1)));
                        ////    return;
                        ////}


                        //Title with gender check
                        //var dtTitleGender = from data in dtIncremented.AsEnumerable()
                        //                    select new
                        //                    {
                        //                        Title = data.Field<string>("Title"),
                        //                        Gender = data.Field<string>("Gender").ToUpper(),
                        //                        ID = data.Field<int>("ID")
                        //                    };
                        //var TitleGenderList = dtTitleGender.Where(s => !TitleGender.Any(l => (l.Title == s.Title && s.Gender.ToUpper() == l.Gender.ToUpper()))).Where(s => TitleGender.Any(l => (l.Title == s.Title && l.Gender.ToUpper() != "UNKNOWN"))).ToList();

                        //if (TitleGenderList.Count > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Please Enter Valid Title with Gender,Invalid data in Excel S.No. : ", string.Join(",", TitleGenderList.Select(s => s.ID + 1).ToArray()));
                        //    return;

                        //}
                        //TitleGenderList.Clear();


                        string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\BulkRegistrationDocument");


                        if (!Directory.Exists(RootDir))
                            Directory.CreateDirectory(RootDir);

                        RootDir = RootDir + @"\" + DateTime.Now.ToString("yyyyMMdd");
                        if (!Directory.Exists(RootDir))
                            Directory.CreateDirectory(RootDir);

                        string fileExt = System.IO.Path.GetExtension(fuExcel.FileName);
                        string FileName = string.Concat(DateTime.Now.ToString("yyyyMMdd"), "##", Guid.NewGuid().ToString(), fileExt);
                        fuExcel.SaveAs(string.Concat(RootDir, @"\", FileName));


                        //check valid ClientCode
                        List<Panel_Code> PC = new List<Panel_Code>();
                        var distinctClientCode = dt.AsEnumerable().Select(row => row.Field<string>("CLIENT Code")).Distinct().ToList();
                        using (DataTable Panel_Code = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Panel_Code,ReferenceCode,Panel_ID FROM f_panel_master ").Tables[0])
                        {
                            PC = (from DataRow row in Panel_Code.Rows
                                  select new Panel_Code
                                  {
                                      ClientCode = row["Panel_Code"].ToString(),
                                      ReferenceCode = Util.GetInt(row["ReferenceCode"].ToString()),
                                      Panel_ID = Util.GetInt(row["Panel_ID"].ToString())
                                  }).ToList();

                            var notMachClientCode = distinctClientCode.Except(PC.Select(P => P.ClientCode), StringComparer.OrdinalIgnoreCase).ToList();
                            if (notMachClientCode.Count > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid CLIENT Code,Invalid CLIENT Code are ", string.Join(",", notMachClientCode.ToArray()));
                                return;
                            }


                        }

                        //check valid CentreCode
                        List<Centre_Code> CC = new List<Centre_Code>();
                        
                        using (DataTable Centre_Code = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CentreCode,CentreID FROM Centre_Master ").Tables[0])
                        {
                            CC = (from DataRow row in Centre_Code.Rows
                                  select new Centre_Code
                                  {
                                      CentreCode = row["CentreCode"].ToString(),
                                      CentreID = Util.GetInt(row["CentreID"].ToString())
                                  }).ToList();
                            var distinctCentreCode = dt.AsEnumerable().Select(row => row.Field<string>("CENTRE CODE")).Distinct().ToList();
                            var notMachCentreCode = distinctCentreCode.Except(CC.Select(P => P.CentreCode), StringComparer.OrdinalIgnoreCase).ToList();
                            if (notMachCentreCode.Count > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid Centre Code,Invalid Centre Code are ", string.Join(",", notMachCentreCode.ToArray()));
                                return;
                            }


                        }

                        ////check valid TestCode
                        List<TestCodeDetail> TC = new List<TestCodeDetail>();
                        using (DataTable TestCode = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ItemID,TestCode FROM f_itemmaster WHERE IsActive=1").Tables[0])
                        {
                            TC = (from DataRow row in TestCode.Rows
                                  select new TestCodeDetail
                                  {
                                      TestCode = row["TestCode"].ToString(),
                                      ItemID = Util.GetInt(row["ItemID"].ToString())
                                  }).ToList();

                            var distinctTestCode = dt.AsEnumerable().Select(row => row.Field<string>("TEST CODE")).Distinct().ToList();
                            var notMachTestCode = distinctTestCode.Except(TC.Select(P => P.TestCode), StringComparer.OrdinalIgnoreCase).ToList();
                            if (notMachTestCode.Count > 0)
                            {
                                lblMsg.Text = string.Concat("Please Enter Valid TEST CODE,Invalid TEST CODE are ", string.Join(",", notMachTestCode.ToArray()));
                                return;
                            }
                        }



                        DataTable distinctWorkOrder = new DataTable("WorkOrders");
                        distinctWorkOrder.Columns.Add("BarcodeNo", typeof(String));
                        distinctWorkOrder.Columns.Add("PName", typeof(String));
                        distinctWorkOrder.Columns.Add("Mobile", typeof(String));
                        distinctWorkOrder.Columns.Add("WorkOrderID", typeof(String));
                        distinctWorkOrder.Columns.Add("TotalAgeInDays", typeof(int));

                        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                        try
                        {
                            int GroupID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_Tran_id(@GroupName)",
                                new MySqlParameter("@GroupName", "booking_data_excel")));

                            StringBuilder sb = new StringBuilder();
                            sb.Append(" INSERT INTO `booking_data_excel`(WorkOrderID,Title,`PatientName`,`Mobile`,DOB,IsDOBActual,Age,AgeYear,AgeMonth,`AgeDays`,TotalAgeInDays,`Gender`,`Doctor_ID`,`DoctorName`,TestCode,ItemID,SampleTypeName,SampleTypeID,`BarcodeNo`,Panel_Code,Panel_ID,centrecode,ReferenceCode,GroupID,SRFID,IsReporting,PatientAddress,IsCredit) ");//SampleCollectionDate,
                            sb.Append(" VALUES (@WorkOrderID,@Title,@PatientName,@Mobile,@DOB,@IsDOBActual,@Age,@AgeYear,@AgeMonth,@AgeDays,@TotalAgeInDays,@Gender,@Doctor_ID,@DoctorName,@TestCode,@ItemID,@SampleTypeName,@SampleTypeID,@BarcodeNo,@Panel_Code,@Panel_ID,@CentreID,@ReferenceCode,@GroupID,@SRFID,'1',@address,@IsCredit);");//@SampleCollectionDate,

                            MySqlCommand myCmd = new MySqlCommand(sb.ToString(), con, tnx);
                            myCmd.CommandType = CommandType.Text;

                            for (int a = 0; a < dtIncremented.Rows.Count; a++)
                            {
                                int IsCredit = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT IF(Payment_mode='Cash','0','1') FROM f_panel_master WHERE panel_Code=@PanelCode",
                              new MySqlParameter("@PanelCode", dtIncremented.Rows[a]["Client Code"].ToString())));
                                ScriptManager.RegisterStartupScript(this.Page, Page.GetType(), "key1", "getdob(" + Util.GetInt(dtIncremented.Rows[a]["AGE in Year"].ToString()) + "," + Util.GetInt(dtIncremented.Rows[a]["Age in Month"].ToString()) + "," + Util.GetInt(dtIncremented.Rows[a]["Age in Days"].ToString()) + ");", true);

                                myCmd.Parameters.Clear();
                                var WorkOrderID = string.Empty;

                                var age = string.Empty; var TotalAgeInDays = 0; var IsDOBActual = 0; var AgeYear = 0; var AgeMonth = 0; var AgeDay = 0;

                                age = string.Concat(Util.GetInt(dtIncremented.Rows[a]["AGE in Year"].ToString()), " Y ", Util.GetInt(dtIncremented.Rows[a]["Age in Month"].ToString()), " M ", Util.GetInt(dtIncremented.Rows[a]["Age in Days"].ToString()), " D ");

                                TotalAgeInDays = Util.GetInt(dtIncremented.Rows[a]["AGE in Year"].ToString()) * 365 + Util.GetInt(dtIncremented.Rows[a]["Age in Month"].ToString()) * 30 + Util.GetInt(dtIncremented.Rows[a]["Age in Days"].ToString());
                                IsDOBActual = 0;
                                AgeYear = Util.GetInt(dtIncremented.Rows[a]["AGE in Year"].ToString());
                                AgeMonth = Util.GetInt(dtIncremented.Rows[a]["Age in Month"].ToString());
                                AgeDay = Util.GetInt(dtIncremented.Rows[a]["Age in Days"].ToString());

                              
                                
                                if (distinctWorkOrder.AsEnumerable().Where(z => z.Field<string>("PName") != dtIncremented.Rows[a]["PATIENT NAME"].ToString() && z.Field<string>("BarcodeNo") == dtIncremented.Rows[a]["SAMPLE ID"].ToString()).Count() > 0)
                                {
                                    lblMsg.Text = string.Concat("Duplicate SAMPLE ID Found; SAMPLE ID are ", dtIncremented.Rows[a]["SAMPLE ID"].ToString());
                                    tnx.Rollback();
                                    return;
                                }

                                if (distinctWorkOrder.AsEnumerable().Where(z => z.Field<string>("PName") == dtIncremented.Rows[a]["PATIENT NAME"].ToString() && z.Field<string>("Mobile") == dtIncremented.Rows[a]["MOBILE"].ToString() && z.Field<string>("BarcodeNo") == dtIncremented.Rows[a]["SAMPLE ID"].ToString()).Count() > 0)
                                {
                                    if (distinctWorkOrder.AsEnumerable().Where(z => z.Field<string>("PName") == dtIncremented.Rows[a]["PATIENT NAME"].ToString() && z.Field<string>("Mobile") == dtIncremented.Rows[a]["MOBILE"].ToString() && z.Field<string>("BarcodeNo") == dtIncremented.Rows[a]["SAMPLE ID"].ToString() && z.Field<int>("TotalAgeInDays") != Util.GetInt(TotalAgeInDays)).Count() > 0)
                                    {
                                        lblMsg.Text = string.Concat("Different Age Found; SAMPLE ID are ", dtIncremented.Rows[a]["SAMPLE ID"].ToString());
                                        tnx.Rollback();
                                        return;
                                    }
                                    WorkOrderID = distinctWorkOrder.AsEnumerable().Where(z => z.Field<string>("PName") == dtIncremented.Rows[a]["PATIENT NAME"].ToString() && z.Field<string>("Mobile") == dtIncremented.Rows[a]["MOBILE"].ToString() && z.Field<string>("BarcodeNo") == dtIncremented.Rows[a]["SAMPLE ID"].ToString()).Select(o => o.Field<string>("WorkOrderID")).FirstOrDefault();
                                }
                                else
                                {
                                    WorkOrderID = Guid.NewGuid().ToString();
                                }
                                dtIncremented.Rows[a]["WorkOrderID"] = WorkOrderID;
                            //  string Title = "";
                            //  if (dtIncremented.Rows[a]["GENDER"].ToString().ToUpper() == "MALE")
                            //      Title = "Mr.";
                            //  else if (dtIncremented.Rows[a]["GENDER"].ToString().ToUpper() == "FEMALE")
                            //      Title = "Mrs.";


                                myCmd.Parameters.AddWithValue("@WorkOrderID", WorkOrderID);
                                myCmd.Parameters.AddWithValue("@PatientName", dtIncremented.Rows[a]["PATIENT NAME"].ToString());
                                myCmd.Parameters.AddWithValue("@Title", dtIncremented.Rows[a]["TITLE"].ToString());
                                myCmd.Parameters.AddWithValue("@Mobile", dtIncremented.Rows[a]["MOBILE"].ToString());
                                myCmd.Parameters.AddWithValue("@Age", age);
                                myCmd.Parameters.AddWithValue("@DOB", Util.GetDateTime(txtDOB.Text).ToString("yyyy-MM-dd"));

                                myCmd.Parameters.AddWithValue("@IsDOBActual", IsDOBActual);
                                myCmd.Parameters.AddWithValue("@AgeYear", AgeYear);
                                myCmd.Parameters.AddWithValue("@AgeMonth", AgeMonth);
                                myCmd.Parameters.AddWithValue("@AgeDays", AgeDay);
                                myCmd.Parameters.AddWithValue("@TotalAgeInDays", TotalAgeInDays);
                                myCmd.Parameters.AddWithValue("@Gender", CultureInfo.InvariantCulture.TextInfo.ToTitleCase(dtIncremented.Rows[a]["GENDER"].ToString()));
                                myCmd.Parameters.AddWithValue("@Doctor_ID", "4899");   //Other Doctor ID
                                myCmd.Parameters.AddWithValue("@DoctorName", dtIncremented.Rows[a]["REFER DOCTOR"].ToString());


                                myCmd.Parameters.AddWithValue("@Panel_Code", dtIncremented.Rows[a]["CLIENT CODE"].ToString());
                                myCmd.Parameters.AddWithValue("@Panel_ID", 0);
                                myCmd.Parameters.AddWithValue("@CentreID", dtIncremented.Rows[a]["CENTRE CODE"].ToString());

                                // Covid Test Only
                                myCmd.Parameters.AddWithValue("@TestCode", dtIncremented.Rows[a]["TEST CODE"].ToString());


                           //    myCmd.Parameters.AddWithValue("@ItemID", 0);
                           //    myCmd.Parameters.AddWithValue("@SampleTypeName", "");
                           //
                           //    myCmd.Parameters.AddWithValue("@SampleTypeID", "0");
                               myCmd.Parameters.AddWithValue("@BarcodeNo", dtIncremented.Rows[a]["SAMPLE ID"].ToString());

                              //  myCmd.Parameters.AddWithValue("@SampleCollectionDate", Util.GetDateTime(dtIncremented.Rows[a]["COLLECTION DATE"].ToString().Replace("*", "")));

                                myCmd.Parameters.AddWithValue("@GroupID", GroupID);
                                myCmd.Parameters.AddWithValue("@SRFID", dtIncremented.Rows[a]["SRF ID"].ToString());
                                myCmd.Parameters.AddWithValue("@ReferenceCode", Util.GetInt(PC.Where(P => P.ClientCode.ToLower() == dtIncremented.Rows[a]["CLIENT CODE"].ToString().ToLower()).Select(P => P.ReferenceCode).ToList()[0].ToString()));
                                myCmd.Parameters.AddWithValue("@address", dtIncremented.Rows[a]["address"]);
                                myCmd.Parameters.AddWithValue("@IsCredit", IsCredit);

                                myCmd.ExecuteNonQuery();

                                DataRow row;
                                row = distinctWorkOrder.NewRow();
                                row["BarcodeNo"] = dtIncremented.Rows[a]["SAMPLE ID"].ToString();
                                row["Mobile"] = dtIncremented.Rows[a]["MOBILE"].ToString();
                                row["PName"] = dtIncremented.Rows[a]["PATIENT NAME"].ToString();
                                row["WorkOrderID"] = WorkOrderID;
                                row["TotalAgeInDays"] = TotalAgeInDays;
                                distinctWorkOrder.Rows.Add(row);


                            }

                            PC.Clear();

                            sb = new StringBuilder();
                            sb.Append(" SELECT COUNT(1) FROM  booking_data_excel bd INNER JOIN patient_labinvestigation_opd plo ");
                            sb.Append(" ON bd.BarcodeNo=plo.BarcodeNo   WHERE  bd.GroupID=@GroupID AND bd.BarcodeNo<>''");
                            int BarCodeCount = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@GroupID", GroupID)));
                            if (BarCodeCount > 0)
                            {
                                using (DataTable duplicateBarcode = MySqlHelper.ExecuteDataset(tnx, CommandType.Text, "SELECT DISTINCT bd.BarcodeNo FROM  booking_data_excel bd INNER JOIN patient_labinvestigation_opd plo ON bd.BarcodeNo=plo.BarcodeNo WHERE  bd.GroupID=@GroupID ",
                                      new MySqlParameter("@GroupID", GroupID)).Tables[0])
                                {
                                    lblMsg.Text = string.Concat("Duplicate SAMPLE ID Found; SAMPLE ID ID are ", string.Join(",", duplicateBarcode.AsEnumerable().Select(P => P.Field<string>("BarcodeNo")).ToArray()));
                                    tnx.Rollback();
                                    return;
                                }
                            }
                           
                            sb = new StringBuilder();
                            //sb.Append("INSERT INTO booking_data_excel(CampID,CampName,ReferenceID,WorkOrderID,RegistrationDate,Title,PatientName,PatientAddress,Mobile,Email,Gender,Age,AgeYear,AgeMonth,AgeDays,DOB,");
                            //sb.Append(" TotalAgeInDays,Doctor_ID,DoctorName,SampleCollectionDate,Comments,isUrgent,Panel_Code,Panel_ID,Status,Response,SampleTypeID,SampleTypeName,BarcodeNo,SubCategoryID,ItemID,TestCode,");
                            //sb.Append(" ItemName,Investigation_ID,IsPackage,InvestigationName,PackageName,PackageCode,CentreID,TagProcessingLabID,GroupID,IsDOBActual,ReportType,IsReporting,Rate,SalesManager,");
                            //sb.Append(" MRNNo,CaseID,NotificationID,CivilID,SubCategoryName,Nationality,Governorate,Wilayat,Village,SampleReceivingDate)");
                            //sb.Append(" SELECT bd.CampID,bd.CampName,bd.ReferenceID,bd.WorkOrderID,bd.RegistrationDate,bd.Title,bd.PatientName,bd.PatientAddress,bd.Mobile,bd.Email,bd.Gender,bd.Age,bd.AgeYear,bd.AgeMonth,bd.AgeDays,");
                            //sb.Append(" if(IsDOBActual=1,bd.DOB,DATE_FORMAT(DATE_ADD(NOW(),INTERVAL - bd.TotalAgeInDays DAY),'%Y-%m-%d'))DOB,");
                            //sb.Append(" bd.TotalAgeInDays,bd.Doctor_ID,bd.DoctorName,bd.SampleCollectionDate,bd.Comments,bd.isUrgent,bd.Panel_Code,fpm.Panel_ID,bd.Status,bd.Response,bd.SampleTypeID,bd.SampleTypeName,bd.BarcodeNo, ");
                            //sb.Append(" im.SubCategoryID,im.ItemID,im.TestCode,im.TypeName ItemName,im.Type_ID,0,im.TypeName,'' PackageName,'' PackageCode,2,2,@GroupID,bd.IsDOBActual,inv.ReportType,1,IFNULL(rat.Rate,0)Rate,fpm.SalesManager,");
                            //sb.Append(" bd.MRNNo,bd.CaseID,bd.NotificationID,bd.CivilID,sub.Name,bd.Nationality,bd.Governorate,bd.Wilayat,bd.Village,bd.SampleReceivingDate");
                            //sb.Append(" ");
                            //sb.Append(" FROM  booking_data_excel bd INNER JOIN f_itemmaster im ON im.TestCode=bd.TestCode AND im.IsActive=1 ");
                            //sb.Append(" INNER JOIN investigation_master inv ON inv.Investigation_Id=im.Type_ID ");
                            //sb.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_Code=bd.Panel_Code ");
                            //sb.Append(" INNER JOIN f_subcategorymaster sub on sub.SubCategoryID=im.SubCategoryID ");
                            //sb.Append(" INNER JOIN f_ratelist rat ON rat.ItemID=im.ItemID AND rat.Panel_ID=fpm.ReferenceCode");
                            //sb.Append(" WHERE bd.GroupID=@GroupID");


                            sb = new StringBuilder();

                            sb.Append(" UPDATE  booking_data_excel bde INNER JOIN f_itemmaster im ON im.TestCode=bde.TestCode AND im.IsActive=1 ");
                            sb.Append(" INNER JOIN investigation_master inv ON inv.Investigation_Id=im.Type_ID ");
                            sb.Append(" INNER JOIN investigations_sampletype invs on invs.Investigation_Id=inv.Investigation_Id and invs.isdefault=1");
                            sb.Append(" INNER JOIN f_panel_master fpm on fpm.Panel_Code=bde.Panel_Code ");
                            sb.Append(" INNER JOIN Centre_master cm on cm.CentreCode=bde.CentreCode ");
                            sb.Append(" INNER JOIN f_subcategorymaster sub on sub.SubCategoryID=im.SubCategoryID ");
                            sb.Append(" INNER JOIN f_ratelist rat ON rat.ItemID=im.ItemID AND rat.Panel_ID=fpm.ReferenceCode");
                            sb.Append(" SET bde.Rate=rat.Rate,bde.ItemID=im.ItemID,bde.SubCategoryName=sub.Name,bde.SubCategoryID=im.SubCategoryID,bde.Investigation_ID=im.Type_ID,bde.PackageName='',bde.PackageCode='', ");
                            sb.Append(" bde.centreid=cm.centreID,bde.SampleTypeID=invs.SampleTypeID,bde.SampleTypeName=invs.SampleTypeName,");
                            sb.Append(" bde.ReportType=inv.ReportType,bde.ItemName=im.TypeName,bde.ItemID=im.ItemID,bde.CentreID=1,bde.TagProcessingLabID=fpm.TagProcessingLabID,bde.InvestigationName=im.TypeName,bde.Panel_ID=fpm.Panel_ID, ");
                            sb.Append(" bde.DOB=if(bde.IsDOBActual=1,bde.DOB,DATE_FORMAT(DATE_ADD(NOW(),INTERVAL - bde.TotalAgeInDays DAY),'%Y-%m-%d')) ");
                            sb.Append(" ");
                            sb.Append(" WHERE bde.GroupID=@GroupID");
                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                  new MySqlParameter("@GroupID", GroupID));


                            sb = new StringBuilder();
                            sb.Append("  SELECT IFNULL(GROUP_CONCAT(DISTINCT t.TestCode),'')TestCode FROM ( ");
                            sb.Append("     SELECT rat.`ID`,bd.TestCode TestCode FROM booking_data_excel bd ");
                            sb.Append("     LEFT JOIN  `f_ratelist` rat ON rat.`ItemID`=bd.`ItemID` AND rat.`Panel_ID`=bd.ReferenceCode  AND rat.Rate!=0  WHERE bd.GroupID=@GroupID ");
                            sb.Append("     AND rat.`ID` IS NULL ");
                            sb.Append(" )t ");
                            string RateZeroTestCode = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, sb.ToString(),
                               new MySqlParameter("@GroupID", GroupID)));
                            if (RateZeroTestCode != string.Empty)
                            {
                                lblMsg.Text = string.Concat("TEST CODE Having Zero Rates are ", RateZeroTestCode);
                                tnx.Rollback();
                                return;
                            }



                            sb = new StringBuilder();
                            sb.Append("INSERT INTO booking_data_excel_ids(WorkOrderID,LedgerTransactionNo,Patient_ID,BillNo,GroupID,Username_web,Password_web)");
                            sb.Append(" SELECT WorkOrderID,get_ledgertransaction_centre(@CentreID),get_patientid_centre(@CentreID),get_Generate_Bill_No(@CentreID,'B'),@GroupID,`get_userid`(@CentreId),randString(6) ");
                            sb.Append(" FROM (SELECT WorkOrderID FROM  booking_data_excel WHERE GroupID=@GroupID");
                            sb.Append(" GROUP BY WorkOrderID ) aa ");
                            int Count = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                  new MySqlParameter("@GroupID", GroupID),
                                  new MySqlParameter("@CentreID", 1));

                            if (Count > 0)
                            {
                                DateTime billData = DateTime.Now;

                                // sb.Append(" -- patient_master  ");
                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO patient_master(Patient_ID,Title, PName,House_No,Street_Name,Locality,City,PinCode, ");
                                sb.Append(" State, Country,  Phone,  Mobile, Email, ");
                                sb.Append(" DOB, Age,  AgeYear,   AgeMonth, AgeDays, TotalAgeInDays,Gender, CentreID,ipAddress,StateID,CityID,localityid,UserID,Patient_ID_Interface,IsOnlineFilterData,IsDuplicate,IsDOBActual)");
                                sb.Append(" SELECT t.Patient_ID,bdx.Title, bdx.PatientName, bdx.`PatientAddress`  House_No,''  Street_Name,bdx.Village Locality,bdx.Wilayat  City,0 Pincode, ");
                                sb.Append(" bdx.Governorate State,'OMAN' Country,''  Phone, bdx.`Mobile` Mobile,bdx.`Email` Email, ");
                                sb.Append(" bdx.DOB, bdx.Age,  bdx.AgeYear,   bdx.AgeMonth, bdx.AgeDays, bdx.TotalAgeInDays,bdx.Gender, bdx.CentreID,'00:00:00' ipaddress,0 StateID, ");
                                sb.Append(" 0 CityID,0 localityID,@UserID,'' Patient_ID_Interface,'0' IsOnlineFilterData,'0' IsDuplicate,bdx.IsDOBActual IsDOBActual ");
                                sb.Append(" FROM `booking_data_excel` bdx  ");
                                sb.Append(" INNER JOIN booking_data_excel_ids t ON t.WorkOrderID = bdx.WorkOrderID ");
                                sb.Append(" WHERE bdx.GroupID=@GroupID GROUP BY t.Patient_ID; ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@GroupID", GroupID),
                                    new MySqlParameter("@UserID", UserInfo.ID));


                                // sb.Append(" -- f_ledgertransaction ");
                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO f_ledgertransaction(DATE,LedgerTransactionNo,DiscountOnTotal,NetAmount,GrossAmount,IsCredit,");
                                sb.Append(" Patient_ID,PName,Age,Gender,VIP,Panel_ID,");
                                sb.Append(" PanelName,Doctor_ID,DoctorName,ReferLab,OtherReferLab,");
                                sb.Append(" CentreId,Adjustment,AdjustmentDate,CreatedByID,HomeVisitBoyID,ipaddress,PatientIDProof,PatientIDProofNo,");
                                sb.Append(" PatientSource,PatientType,VisitType,");
                                sb.Append("  HLMPatientType , HLMOPDIPDNo ,DiscountApprovedByID,DiscountApprovedByName,CorporateIDType,CorporateIDCard,");
                                sb.Append("  Username_web, Password_web,ReVisit,CreatedBy,LedgerTransactionNo_InterfaceExcel,Interface_companyName,");
                                sb.Append(" DiscountID,OtherLabRefNo,IsCamp,CampID,InvoiceToPanelId,SRFno");
                                sb.Append(" ) ");
                                sb.Append(" SELECT @billData,t.LedgerTransactionNo,0 DiscountOnTotal,SUM(bdx.Rate) NetAmount ,SUM(bdx.Rate) GrossAmount, bdx.IsCredit , ");
                                sb.Append(" t.Patient_ID ,CONCAT(bdx.Title, bdx.patientName) PName,bdx.Age,bdx.Gender,0 VIP, pm.Panel_ID Panel_ID ,");
                                sb.Append(" pm.Company_Name PanelName ,bdx.Doctor_ID Doctor_ID , bdx.DoctorName  ,0 ReferLab ,'' OtherReferLab ,");
                                sb.Append(" bdx.CentreId ,0 Adjustment , @billData ,@Creator_UserID ,0 HomeVisitBoyID ,@IpAddress ipAddress , '1' PatientIDProof ,bdx.CivilID PatientIDProofNo ,");
                                sb.Append(" '' PatientSource ,'Auto' PatientType ,'Home Collection' VisitType ,");
                                sb.Append(" '' HLMPatientType ,'' HLMOPDIPDNo,0 DiscountApprovedByID,'' DiscountApprovedByName,'' CorporateIDType,'' CorporateIDCard,");
                                sb.Append(" IFNULL(t.Username_web,''), IFNULL(t.Password_web,''),0 ReVisit,'Offline' CreatorName,bdx.WorkOrderID,'' Interface_companyName,");
                                sb.Append(" 0 DiscountID,bdx.MRNNo OtherLabRefNo,1 IsCamp,bdx.GroupID CampID,pm.InvoiceTo,bdx.SRFID");
                                sb.Append(" FROM `booking_data_excel` bdx ");
                                sb.Append(" INNER JOIN booking_data_excel_ids t ON t.WorkOrderID = bdx.WorkOrderID ");
                                sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=bdx.Panel_ID  WHERE bdx.GroupID=@GroupID ");
                                sb.Append(" GROUP BY bdx.WorkOrderID;");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                            new MySqlParameter("@Creator_UserID", UserInfo.ID),
                                            new MySqlParameter("@GroupID", GroupID),
                                            new MySqlParameter("@billData", billData),
                                            new MySqlParameter("@IpAddress", StockReports.getip()));


                                // sb.Append("-- patient_labinvestigation_opd");
                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO `patient_labinvestigation_opd`(");
                                sb.Append(" `LedgerTransactionID`,`LedgerTransactionNo`,BillNo,`BarcodeNo`,`ItemId`,`Investigation_ID`,");
                                sb.Append(" `IsPackage`,`Date`,`SubCategoryID`,SubCategoryName,`Rate`,`Amount`,`DiscountAmt`,`Quantity`,`DiscountByLab`,");
                                sb.Append(" `IsRefund`,`IsReporting`,BillType,`Patient_ID`,`AgeInDays`,`Gender`,`ReportType`,`CentreID`,`CentreIDSession`,");
                                sb.Append(" `TestCentreID`,`IsNormalResult`,`IsCriticalResult`,`PrintSeparate`,`isPartial_Result`,`Result_Flag`,");
                                sb.Append(" `ResultEnteredBy`,`ResultEnteredDate`,`ResultEnteredName`,`Approved`,`AutoApproved`,`MobileApproved`,");
                                sb.Append(" `ApprovedBy`,`ApprovedDate`,`ApprovedName`,`ApprovedDoneBy`,");
                                sb.Append(" `IsSampleCollected`,`SampleReceivedBy`,`SampleReceiver`,`SampleBySelf`,");
                                sb.Append(" `SampleCollectionBy`,`SampleCollector`,`SampleCollectionDate`,`LedgerTransactionNoOLD`,`isHold`,`HoldBy`,`HoldByName`,");
                                sb.Append(" `UnHoldBy`,`UnHoldByName`,`UnHoldDate`,`Hold_Reason`,`isForward`,`ForwardToCentre`,`ForwardToDoctor`,`ForwardBy`,");
                                sb.Append(" `ForwardByName`,`ForwardDate`,`isPrint`,`IsFOReceive`,`FOReceivedBy`,`FOReceivedByName`,`FOReceivedDate`,");
                                sb.Append(" `IsDispatch`,`DispatchedBy`,`DispatchedByName`,`DispatchedDate`,`isUrgent`,`DeliveryDate`,`SlideNumber`,");
                                sb.Append(" `SampleTypeID`,`SampleTypeName`,`SampleQty`,`LabOutsrcID`,`LabOutsrcName`,`LabOutSrcUserID`,`LabOutSrcBy`,");
                                sb.Append(" `LabOutSrcDate`,`LabOutSrcRate`,`isHistoryReq`,`CPTCode`,`MacStatus`,`isEmail`,");
                                sb.Append(" `isrerun`,`ReRunReason`,");
                                sb.Append(" `UpdateID`,`UpdateName`,`UpdateRemarks`,`UpdateDate`,`ipAddress`,`Barcode_Group`,`IsLabOutSource`,");
                                sb.Append(" `barcodePreprinted`,`CultureStatus`,`CultureStatusDate`,`reportNumber`,`HistoCytoSampleDetail`,`incubationDatetime`,");
                                sb.Append(" `HistoCytoPerformingDoctor`,`HistoCytoStatus`,`ItemCode`,`ItemName`,`PackageName`,`PackageCode`,`ReRunDate`,");
                                sb.Append(" `ReRunByID`,`ReRunByName`,");
                                sb.Append(" `ItemID_Interface`,`Interface_companyName`,`CancelByInterface`,");
                                sb.Append(" `MachineID_Manual`,`IsScheduleRate`,`MRP`,createdByID,createdBy,IsSRA,SRADate,S_CountryID,BaseCurrencyRound) ");
                                sb.Append(" SELECT  ");
                                sb.Append(" lt.`LedgerTransactionID`,lt.`LedgerTransactionNo`,IFNULL(t.BillNo,'')BillNo,bdx.`BarcodeNo`,bdx.`ItemId`,bdx.`Investigation_ID`, ");
                                sb.Append(" bdx.`IsPackage`,lt.`Date`,bdx.`SubCategoryID`,bdx.SubCategoryName,bdx.Rate `Rate`,bdx.Rate `Amount`,0 `DiscountAmt`,1 `Quantity`,0 `DiscountByLab`, ");
                                sb.Append(" 0 `IsRefund`,bdx.`IsReporting`,'Credit-Test Add'BillType,lt.`Patient_ID`,bdx.`TotalAgeInDays`,lt.`Gender`,bdx.`ReportType`,bdx.`CentreID`,bdx.`CentreID` `CentreIDSession`, ");
                                sb.Append(" bdx.`TagProcessingLabID` `TestCentreID`,0 `IsNormalResult`,0 `IsCriticalResult`,0 `PrintSeparate`,0 `isPartial_Result`,0 `Result_Flag`, ");
                                sb.Append(" NULL`ResultEnteredBy`,NULL `ResultEnteredDate`,NULL `ResultEnteredName`,0 `Approved`,0 `AutoApproved`,0 `MobileApproved`, ");
                                sb.Append(" NULL `ApprovedBy`,NULL `ApprovedDate`,NULL `ApprovedName`,NULL `ApprovedDoneBy`, ");
                                sb.Append("  'N' `IsSampleCollected`, '0' `SampleReceivedBy`,'' `SampleReceiver`,0 `SampleBySelf`, ");
                                sb.Append(" '0'  `SampleCollectionBy`,'' `SampleCollector`,NULL `SampleCollectionDate`,'' `LedgerTransactionNoOLD`,0 `isHold`,0 `HoldBy`,NULL `HoldByName`, ");
                                sb.Append(" 0 `UnHoldBy`,NULL `UnHoldByName`,NULL `UnHoldDate`,NULL `Hold_Reason`,0 `isForward`,0 `ForwardToCentre`,0 `ForwardToDoctor`,0 `ForwardBy`, ");
                                sb.Append(" NULL `ForwardByName`,NULL `ForwardDate`,0 `isPrint`,0 `IsFOReceive`,0 `FOReceivedBy`,NULL `FOReceivedByName`,NULL `FOReceivedDate`, ");
                                sb.Append(" 0 `IsDispatch`,0 `DispatchedBy`,NULL `DispatchedByName`,NULL `DispatchedDate`,0 `isUrgent`,IFNULL(Get_DeliveryDate(bdx.`CentreID`,bdx.`Investigation_ID`,now()),'0001-01-01 00:00:00') `DeliveryDate`,'' `SlideNumber`, ");
                                sb.Append(" bdx.`SampleTypeID`,bdx.`SampleTypeName`,'1' `SampleQty`,0 `LabOutsrcID`,NULL `LabOutsrcName`,NULL `LabOutSrcUserID`,NULL `LabOutSrcBy`, ");
                                sb.Append(" NULL `LabOutSrcDate`,0 `LabOutSrcRate`,0 `isHistoryReq`,'' `CPTCode`,1 `MacStatus`,0 `isEmail`, ");
                                sb.Append(" 0 `isrerun`,NULL `ReRunReason`, ");
                                sb.Append(" '1' `UpdateID`,'Offline'`UpdateName`,'Offline'`UpdateRemarks`,@billData `Updatedate`,@IpAddress `ipaddress`,bdx.Barcodeno `Barcode_Group`, ");
                                sb.Append(" 0 `IsLabOutSource`, ");
                                sb.Append(" 0 `barcodePreprinted`,NULL `CultureStatus`,NULL `CultureStatusDate`,NULL `reportnumber`,NULL `HistoCytoSampleDetail`,NULL  `incubationdatetime`, ");
                                sb.Append(" NULL `HistoCytoPerformingDoctor`,NULL `HistoCytoStatus`,bdx.`TestCode`,bdx.`InvestigationName`,bdx.`PackageName`,bdx.`PackageCode`, ");
                                sb.Append(" NULL `ReRunDate`, NULL `ReRunByID`,NULL `ReRunByName`, ");
                                sb.Append(" NULL `ItemID_Interface`,NULL `Interface_companyName`,0 `CancelByInterface`, ");
                                sb.Append(" '0' `MachineID_Manual`,0 `IsScheduleRate`,0 `MRP`,@UpdateID createdByID,@createdBy createdBy,0 IsSRA,@billData SRADate,@S_CountryID S_CountryID,@BaseCurrencyRound BaseCurrencyRound ");
                                sb.Append(" FROM `booking_data_excel` bdx  ");
                                sb.Append(" INNER JOIN booking_data_excel_ids t ON t.WorkOrderID = bdx.WorkOrderID  ");
                                sb.Append(" INNER JOIN  f_ledgertransaction lt ON lt.LedgerTransactionNo=t.LedgerTransactionNo WHERE bdx.GroupID=@GroupID; ");

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@UpdateID", UserInfo.ID),
                                    new MySqlParameter("@GroupID", GroupID),
                                    new MySqlParameter("@billData", billData),
                                    new MySqlParameter("@createdBy", UserInfo.LoginName),
                                    new MySqlParameter("@S_CountryID", Resources.Resource.BaseCurrencyID),
                                    new MySqlParameter("@BaseCurrencyRound", Resources.Resource.BaseCurrencyRound),
                                    new MySqlParameter("@IpAddress", StockReports.getip()));


                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO `patient_labinvestigation_opd_share`( ");
                                sb.Append(" Centre_PanelID,Panel_ID,`LedgerTransactionID`,`LedgerTransactionNo`,`ItemId`,`Date`,`Rate`,Amount,DiscountAmt,Quantity,");
                                sb.Append(" DiscountByLab,PCCGrossAmt,PCCDiscAmt,PCCNetAmt,PCCSpecialFlag,PCCInvoiceAmt,PCCPercentage,BillNo,Test_ID)");
                                sb.Append(" SELECT ");
                                sb.Append(" pm.InvoiceTo Centre_PanelID,pm.InvoiceTo Panel_ID,plo.`LedgerTransactionID`,plo.`LedgerTransactionNo`,plo.`ItemId`,plo.`Date`,plo.`Rate`,plo.Amount,plo.DiscountAmt,plo.Quantity,");
                                sb.Append(" 0 DiscountByLab,plo.Amount PCCGrossAmt,0 PCCDiscAmt,plo.Amount PCCNetAmt,0 PCCSpecialFlag,plo.Amount PCCInvoiceAmt,0 PCCPercentage,plo.BillNo,plo.Test_ID");
                                sb.Append(" FROM `booking_data_excel` bdx  ");
                                sb.Append(" INNER JOIN booking_data_excel_ids t ON t.WorkOrderID = bdx.WorkOrderID  ");
                                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=t.LedgerTransactionNo AND plo.investigation_Id=bdx.investigation_Id  AND  IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15) ");
                                sb.Append(" INNER JOIN f_panel_master pm ON pm.Panel_ID=bdx.Panel_ID ");
                                sb.Append(" WHERE bdx.GroupID=@GroupID  AND  IF(bdx.isPackage=1,bdx.`SubCategoryID`=15,bdx.`SubCategoryID`!=15)   ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                     new MySqlParameter("@GroupID", GroupID));

                                // Update IsBooked 
                                sb = new StringBuilder();
                                sb.Append(" UPDATE `booking_data_excel` bdx  ");
                                sb.Append(" INNER JOIN booking_data_excel_ids t ON t.WorkOrderID = bdx.WorkOrderID   ");
                                sb.Append(" SET IsBooked=1 ,dtAccepted=@billData WHERE bdx.GroupID=@GroupID");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@GroupID", GroupID),
                                    new MySqlParameter("@billData", billData));


                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionID,LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                                sb.Append(" SELECT plo.LedgertransactionID,plo.LedgerTransactionNo,bdx.`BarcodeNo`,plo.Test_ID,CONCAT('Registration Done (', plo.ItemName, ')'), ");
                                sb.Append(" @UserID,@LoginName,@IpAddress,plo.CentreID,@RoleID,@billData,'' ");
                                sb.Append(" FROM `booking_data_excel` bdx  ");
                                sb.Append(" INNER JOIN booking_data_excel_ids t ON t.WorkOrderID = bdx.WorkOrderID  ");
                                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=t.LedgerTransactionNo AND plo.Investigation_ID=bdx.Investigation_ID  ");
                                sb.Append(" WHERE bdx.GroupID=@GroupID  GROUP BY plo.Test_ID  ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@RoleID", UserInfo.RoleID),
                                    new MySqlParameter("@LoginName", UserInfo.LoginName),
                                    new MySqlParameter("@UserID", UserInfo.ID),
                                    new MySqlParameter("@IpAddress", StockReports.getip()),
                                    new MySqlParameter("@GroupID", GroupID),
                                    new MySqlParameter("@billData", billData));



                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO sample_logistic(BarcodeNo,Barcode_Group,FromCentreID,ToCentreID,DispatchCode,Qty,EntryBy,");
                                sb.Append(" `Status`,dtLogisticReceive,LogisticReceiveDate,LogisticReceiveBy,ReceivedDate,testID) ");
                                sb.Append(" SELECT bdx.`BarcodeNo`,bdx.Barcodeno,plo.CentreID,bdx.`TagProcessingLabID`,'',1,@EntryBy,'Received',@billData,@billData,@LogisticReceiveBy,@billData,plo.Test_ID ");
                                sb.Append(" FROM `booking_data_excel` bdx  ");
                                sb.Append(" INNER JOIN booking_data_excel_ids t ON t.WorkOrderID = bdx.WorkOrderID  ");
                                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=t.LedgerTransactionNo AND plo.Investigation_ID=bdx.Investigation_ID ");
                                sb.Append(" WHERE bdx.GroupID=@GroupID  ");
                       //       MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                       //           new MySqlParameter("@EntryBy", UserInfo.ID),
                       //           new MySqlParameter("@LogisticReceiveBy", UserInfo.ID),
                       //           new MySqlParameter("@GroupID", GroupID),
                       //           new MySqlParameter("@billData", billData));

                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionID,LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
                                sb.Append(" SELECT plo.LedgertransactionID,plo.LedgerTransactionNo,bdx.`BarcodeNo`,plo.Test_ID,CONCAT('SRA done (', plo.ItemName, ')'), ");
                                sb.Append(" @UserID,@LoginName,@IpAddress,plo.CentreID,@RoleID,@billData,'' ");
                                sb.Append(" FROM `booking_data_excel` bdx  ");
                                sb.Append(" INNER JOIN booking_data_excel_ids t ON t.WorkOrderID = bdx.WorkOrderID  ");
                                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=t.LedgerTransactionNo  AND plo.Investigation_ID=bdx.Investigation_ID ");
                                sb.Append(" WHERE bdx.GroupID=@GroupID  GROUP BY plo.Test_ID  ");

                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@RoleID", UserInfo.RoleID),
                                    new MySqlParameter("@LoginName", UserInfo.LoginName),
                                    new MySqlParameter("@UserID", UserInfo.ID),
                                    new MySqlParameter("@IpAddress", StockReports.getip()),
                                    new MySqlParameter("@GroupID", GroupID),
                                    new MySqlParameter("@billData", billData));

                                // Insert Mac Data
                                //sb = new StringBuilder();

                                //sb.Append(" DROP TABLE IF EXISTS _mac_data_dummy; ");
                                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                                //sb = new StringBuilder();
                                //sb.Append(" CREATE TEMPORARY TABLE _mac_data_dummy (Test_ID int(11),LabNo varchar(50),LabObservation_ID varchar(50),dtEntry double,pname varchar(20),LedgerTransactionNo varchar(15),InvestigationName varchar(100),LabObservationName varchar(100),Status varchar(7),centreID INT(11),VialID varchar(15),SampleTypeID varchar(15))  ");

                                //sb.Append(" SELECT plo.test_ID Test_ID,CONCAT(bdx.BarcodeNo,IFNULL(lom.suffix,'')) AS LabNo,lom.LabObservation_ID,DATE_FORMAT(NOW(),'%Y%m%d%H%i%s') dtEntry, ");
                                //sb.Append(" IF(LENGTH(pm.PName)>20,LPAD(pm.pname,20,''),pm.pname) pname ,bdx.`LedgerTransactionNo`,inv.`Name` InvestigationName , ");
                                //sb.Append(" lom.`Name` LabObservationName ,plo.SampleTypeID ,bdx.TagProcessingLabID  centreID     ");
                                //sb.Append(" FROM `booking_data_excel` bdx  ");
                                //sb.Append(" INNER JOIN booking_data_excel_ids t ON t.WorkOrderID = bdx.WorkOrderID  ");
                                //sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=bdx.LedgerTransactionNo AND plo.Investigation_ID=bdx.Investigation_ID ");
                                //sb.Append(" INNER JOIN patient_master pm ON pm.Patient_ID=plo.Patient_ID  ");
                                //sb.Append(" INNER JOIN labobservation_investigation loi ON plo.Investigation_ID=loi.Investigation_Id  ");
                                //sb.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID` ");
                                //sb.Append(" INNER JOIN labobservation_master lom ON loi.labObservation_ID=lom.LabObservation_ID  ");
                                //sb.Append(" AND plo.BarcodeNo=bdx.`BarcodeNo`  ");
                                //sb.Append(" AND plo.`IsReporting`=1 AND bdx.GroupID=@GroupID");
                                //sb.Append(" GROUP BY plo.Test_ID,lom.LabObservation_ID; ");
                                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                //    new MySqlParameter("@GroupID", GroupID));

                                //sb = new StringBuilder();
                                //sb.Append(" ALTER TABLE _mac_data_dummy ADD KEY aa(Test_ID); ");
                                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());

                                sb = new StringBuilder();
                                sb.Append(" INSERT INTO mac_data(Test_ID,LabNo,LabObservation_ID,dtEntry,pname,LedgerTransactionNo,InvestigationName,LabObservationName,`Status`,centreid,`VialID`,Investigation_ID) ");
                                sb.Append(" SELECT plo.Test_ID,plo.BarcodeNo LabNo,lom.LabObservation_ID,DATE_FORMAT(NOW(),'%Y%m%d%H%i%s') dtEntry,");
                                sb.Append(" IF(LENGTH(bdx.PName)>20,LPAD(bdx.pname,20,''),bdx.pname) pname,plo.LedgerTransactionNo,inv.`Name` InvestigationName,");
                                sb.Append(" lom.`Name` LabObservationName,'Receive',bdx.CentreId CentreId,plo.SampleTypeID,plo.Investigation_ID ");
                                sb.Append(" FROM booking_data_excel bdx  ");
                                sb.Append(" INNER JOIN booking_data_excel_ids t ON t.WorkOrderID = bdx.WorkOrderID ");
                                sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=t.LedgerTransactionNo AND plo.Investigation_ID=bdx.Investigation_ID ");
                                sb.Append(" INNER JOIN labobservation_investigation loi ON plo.Investigation_ID=loi.Investigation_Id ");
                                sb.Append(" INNER JOIN investigation_master inv ON inv.`Investigation_Id`=plo.`Investigation_ID` ");
                                sb.Append(" INNER JOIN labobservation_master lom ON loi.labObservation_ID=lom.LabObservation_ID  ");
                                sb.Append(" AND plo.BarcodeNo=bdx.`BarcodeNo` ");
                                sb.Append(" AND plo.`IsReporting`=1 AND bdx.GroupID=@GroupID ");
                                sb.Append(" GROUP BY plo.Test_ID,lom.LabObservation_ID; ");
                                sb.Append(" ");
                                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                    new MySqlParameter("@GroupID", GroupID));

                                //sb = new StringBuilder();
                                //sb.Append(" UPDATE patient_labinvestigation_opd plo  ");
                                //sb.Append(" INNER JOIN _mac_data_dummy mdd ON plo.Test_ID=mdd.Test_ID SET plo.MacStatus=1;  ");
                                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString());


                                //sb = new StringBuilder();
                                //sb.Append(" UPDATE ( ");
                                //sb.Append("         SELECT   SUM(plo.Rate)Rate,SUM(plo.Amount)Amount,plo.LedgerTransactionID FROM  ");
                                //sb.Append("         `booking_data_excel` bdx INNER JOIN  patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=bdx.LedgerTransactionNo  ");
                                //sb.Append("         AND plo.ItemId=bdx.ItemID AND  IF(bdx.isPackage=1,bdx.`SubCategoryID`=15,bdx.`SubCategoryID`!=15)  ");
                                //sb.Append("         AND IF(plo.isPackage=1,plo.`SubCategoryID`=15,plo.`SubCategoryID`!=15)    ");
                                //sb.Append("         AND bdx.GroupID=@GroupID   GROUP BY plo.LedgerTransactionID )t  ");
                                //sb.Append(" INNER JOIN f_ledgertransaction lt  ON t.LedgerTransactionID=lt.LedgerTransactionID  ");
                                //sb.Append(" SET lt.grossamount=Rate,lt.netamount=Amount ");

                                //MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                //     new MySqlParameter("@GroupID", GroupID));

                                //      sb = new StringBuilder();
                                //      sb.Append(" INSERT INTO patient_labinvestigation_opd_sample(Test_ID,LedgerTransactionID,LedgerTransactionNo,BillNo,BarcodeNo,BarcodeGroup,SampleCollectionDate,");
                                //      sb.Append(" SampleCollectionBy,SampleCollector,SampleTypeID,SampleTypeName,IsSampleCollected)");
                                //      sb.Append(" SELECT plo.Test_ID,plo.LedgerTransactionID,plo.LedgerTransactionNo,plo.BillNo,plo.BarcodeNo,plo.Barcode_Group,plo.SampleCollectionDate,plo.SampleCollectionBy, ");
                                //      sb.Append(" plo.SampleCollector,plo.SampleTypeID,plo.SampleTypeName,plo.IsSampleCollected ");
                                //
                                //      sb.Append(" FROM `booking_data_excel` bdx  ");
                                //      sb.Append(" INNER JOIN booking_data_excel_ids t ON t.WorkOrderID = bdx.WorkOrderID  ");
                                //      sb.Append(" INNER JOIN patient_labinvestigation_opd plo ON plo.LedgerTransactionNo=t.LedgerTransactionNo AND plo.Investigation_ID=bdx.Investigation_ID  ");
                                //      sb.Append(" WHERE bdx.GroupID=@GroupID  ");
                                //      MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                //          new MySqlParameter("@GroupID", GroupID));

                                tnx.Commit();
                                lblMsg.Text = "Data Uploaded Successfully.";
                                txtWitness.Text = string.Empty;
                            }
                            else
                            {
                                lblMsg.Text = "Please Enter Valid Client Code";
                                tnx.Rollback();
                                return;
                            }
                        }
                        catch (Exception ex)
                        {
                            tnx.Rollback();
                            lblMsg.Text = ex.GetBaseException().ToString();
                            ClassLog objerror = new ClassLog();
                            objerror.errLog(ex);
                        }
                        finally
                        {
                            tnx.Dispose();
                            fuExcel.PostedFile.InputStream.Flush();
                            fuExcel.PostedFile.InputStream.Close();
                            fuExcel.FileContent.Dispose();
                        }

                    }
                }
            }
        }
        catch (Exception ex)
        {

            lblMsg.Text = ex.GetBaseException().ToString();
            ClassLog objerror = new ClassLog();
            objerror.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
}