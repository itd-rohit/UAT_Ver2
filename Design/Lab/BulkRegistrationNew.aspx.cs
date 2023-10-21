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

public partial class Design_Master_BulkRegistrationNew : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindAllData();

            txtWitness.Text = UserInfo.LoginName;

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
		     dt.Columns.Add("PROName");
			    dt.Columns.Add("PassportNo");
				   dt.Columns.Add("IdentityProof");
		 

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
       // dr1["SAMPLE ID"] = "";
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
                                 SAMPLEID = "abc",
                                 PATIENTNAME = r1.Field<string>("PATIENT NAME")
                             }).Where(gr => gr.Count() > 1).Select(g => g.Key).ToList();

                        if (distinctTest.Count() > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Data,Duplicate data found in Excel  : ", string.Join("  ,", String.Join(",", distinctTest.Select(s => string.Concat(s.PATIENTNAME, "#", s.SAMPLEID)))));
                            return;
                        }

                        //var SAMPLEIDCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["SAMPLE ID"].ToString())).AsDataView().Count;
                        //if (SAMPLEIDCount > 0)
                        //{
                        //    lblMsg.Text = string.Concat("Please Enter SAMPLE ID in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("SAMPLE ID") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                        //    return;
                        //}



                        var NameCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["PATIENT NAME"].ToString())).AsDataView().Count;
                        if (NameCount > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter PATIENT NAME in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("PATIENT NAME") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }                       


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
                            //if (notMachTestCode.Count > 0)
                            //{
                            //    lblMsg.Text = string.Concat("Please Enter Valid TEST CODE,Invalid TEST CODE are ", string.Join(",", notMachTestCode.ToArray()));
                            //    return;
                            //}
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
                            sb.Append(" INSERT INTO `booking_data_excelnew`(WorkOrderID,Title,`PName`,`Mobile`,DOB,Age,AgeYear,AgeMonth,`AgeDays`,`Gender`,`Doctor_ID`,`DoctorName`,SampleTypeName,SampleTypeID,Panel_ID,CentreID_Interface,Address,ItemId_interface,ItemName_interface,GroupID,TotalAgeInDays,Patient_id,PROName,PassportNo,Email,IdentityProof,CreatedBy) ");//SampleCollectionDate,
                            sb.Append(" VALUES (@WorkOrderID,@Title,@PatientName,@Mobile,@DOB,@Age,@AgeYear,@AgeMonth,@AgeDays,@Gender,@Doctor_ID,@DoctorName,@SampleTypeName,@SampleTypeID,@Panel_ID,@CentreID,@address,@ItemId,@ItemName,@GroupID,@TotalAgeInDays,@Patient_id,@PROName,@PassportNo,@Email,@IdentityProof,@CreatedBy);");//@SampleCollectionDate,

                            MySqlCommand myCmd = new MySqlCommand(sb.ToString(), con, tnx);
                            myCmd.CommandType = CommandType.Text;
                            
                            for (int a = 0; a < dtIncremented.Rows.Count; a++)
                            {
                                string Patient_id = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT get_patientid_centre(@CentreID);",
                                    new MySqlParameter("@CentreID", dtIncremented.Rows[a]["CENTRE CODE"].ToString())));
                                string TestCount = dtIncremented.Rows[a]["Test Code"].ToString();
                                for (int j = 0; j < TestCount.Split(',').Length; j++)
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



                                    if (distinctWorkOrder.AsEnumerable().Where(z => z.Field<string>("PName") != dtIncremented.Rows[a]["PATIENT NAME"].ToString() ).Count() > 0)
                                    {
                                        //lblMsg.Text = string.Concat("Duplicate SAMPLE ID Found; SAMPLE ID are ");
                                        //tnx.Rollback();
                                        //return;
                                    }

                                    if (distinctWorkOrder.AsEnumerable().Where(z => z.Field<string>("PName") == dtIncremented.Rows[a]["PATIENT NAME"].ToString() && z.Field<string>("Mobile") == dtIncremented.Rows[a]["MOBILE"].ToString() ).Count() > 0)
                                    {
                                        //if (distinctWorkOrder.AsEnumerable().Where(z => z.Field<string>("PName") == dtIncremented.Rows[a]["PATIENT NAME"].ToString() && z.Field<string>("Mobile") == dtIncremented.Rows[a]["MOBILE"].ToString() && z.Field<string>("BarcodeNo") == dtIncremented.Rows[a]["SAMPLE ID"].ToString() && z.Field<int>("TotalAgeInDays") != Util.GetInt(TotalAgeInDays)).Count() > 0)
                                        //{
                                        //    lblMsg.Text = string.Concat("Different Age Found; SAMPLE ID are ", dtIncremented.Rows[a]["SAMPLE ID"].ToString());
                                        //    tnx.Rollback();
                                        //    return;
                                        //}
                                        WorkOrderID = distinctWorkOrder.AsEnumerable().Where(z => z.Field<string>("PName") == dtIncremented.Rows[a]["PATIENT NAME"].ToString() && z.Field<string>("Mobile") == dtIncremented.Rows[a]["MOBILE"].ToString() ).Select(o => o.Field<string>("WorkOrderID")).FirstOrDefault();
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
                                    string itemid = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT Itemid FROM f_itemmaster WHERE TestCode=@ItemCode",
                                    new MySqlParameter("@ItemCode", TestCount.Split(',')[j].ToString())));

                                    string ItemName = Util.GetString(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT TypeName FROM f_itemmaster WHERE TestCode=@ItemCode",
                                    new MySqlParameter("@ItemCode", TestCount.Split(',')[j].ToString())));

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
                                    myCmd.Parameters.AddWithValue("@GroupID", GroupID);
                                    myCmd.Parameters.AddWithValue("@Panel_ID", dtIncremented.Rows[a]["Client CODE"].ToString());
                                    myCmd.Parameters.AddWithValue("@CentreID", dtIncremented.Rows[a]["CENTRE CODE"].ToString());

                                    myCmd.Parameters.AddWithValue("@Patient_id", Patient_id);
                                    myCmd.Parameters.AddWithValue("@ItemId", itemid);
                                    myCmd.Parameters.AddWithValue("@ItemName", ItemName);
                                    //myCmd.Parameters.AddWithValue("@BarcodeNo", dtIncremented.Rows[a]["SAMPLE ID"].ToString());

                                    myCmd.Parameters.AddWithValue("@address", dtIncremented.Rows[a]["address"]);
                                    myCmd.Parameters.AddWithValue("@PROName", dtIncremented.Rows[a]["PROName"]);
                                    myCmd.Parameters.AddWithValue("@PassportNo", dtIncremented.Rows[a]["PassportNo"]);
                                    myCmd.Parameters.AddWithValue("@Email", dtIncremented.Rows[a]["Email"]);
                                    myCmd.Parameters.AddWithValue("@IdentityProof", dtIncremented.Rows[a]["IdentityProof"]);
                                    myCmd.Parameters.AddWithValue("@CreatedBy", UserInfo.LoginName);

                                    myCmd.ExecuteNonQuery();

                                    DataRow row;
                                    row = distinctWorkOrder.NewRow();
                                    //row["BarcodeNo"] = dtIncremented.Rows[a]["SAMPLE ID"].ToString();
                                    row["Mobile"] = dtIncremented.Rows[a]["MOBILE"].ToString();
                                    row["PName"] = dtIncremented.Rows[a]["PATIENT NAME"].ToString();
                                    row["WorkOrderID"] = WorkOrderID;
                                    row["TotalAgeInDays"] = TotalAgeInDays;
                                    distinctWorkOrder.Rows.Add(row);

                                }
                            }
                            sb = new StringBuilder();
                            sb.Append(" UPDATE booking_data_excelnew bde INNER JOIN f_itemmaster im ON im.ItemId = bde.ItemID_interface AND im.IsActive = 1  ");
                            sb.Append(" INNER JOIN investigation_master inv ON inv.Investigation_Id = im.Type_ID ");
                            sb.Append(" INNER JOIN investigations_sampletype invs ON invs.Investigation_Id = inv.Investigation_Id  ");
                            sb.Append(" AND invs.isdefault = 1 INNER JOIN f_panel_master fpm ON fpm.Panel_id = bde.Panel_ID  ");
                            sb.Append(" INNER JOIN Centre_master cm ON cm.centreid = bde.Centreid_interface ");
                            sb.Append(" INNER JOIN f_subcategorymaster sub ON sub.SubCategoryID = im.SubCategoryID  ");
                            sb.Append(" LEFT JOIN f_ratelist rat ON rat.ItemID = im.ItemID AND rat.Panel_ID = fpm.ReferenceCode ");
                            sb.Append(" SET bde.Rate=IFNULL(rat.Rate,0), ");
                            sb.Append(" bde.SampleTypeName=invs.SampleTypeName,");
                            sb.Append(" bde.ItemName_Interface=im.TypeName, ");
                            sb.Append(" bde.DOB= DATE_FORMAT(DATE_ADD(NOW(),INTERVAL - bde.TotalAgeInDays DAY),'%Y-%m-%d') ");
                            sb.Append(" WHERE bde.GroupID=@GroupID");

                            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                                  new MySqlParameter("@GroupID", GroupID));
                            

                            MySqlHelper.ExecuteNonQuery(tnx,CommandType.Text,"CALL Proc_BulkRegistration();");

                                tnx.Commit();
                                lblMsg.Text = "Data Uploaded Successfully.";
                                //txtWitness.Text = string.Empty;
                            
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