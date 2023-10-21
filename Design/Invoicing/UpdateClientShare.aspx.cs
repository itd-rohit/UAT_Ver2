using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Invoicing_UpdateClientShare : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtVisitNo.Focus();
        }
    }

    [WebMethod]
    public static string ClientShare(string VisitNo)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            List<String> labno = new List<string>();
            labno = VisitNo.Split(',').ToList();

            for (int i = 0; i < labno.Count; i++)
            {
                string LedgerTransactionIDData = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(LedgerTransactionID,'#',Date)LedgerTransactionID FROM f_ledgertransaction WHERE LedgerTransactionNo=@LedgerTransactionNo ",
                   new MySqlParameter("@LedgerTransactionNo", labno[i])));
                if (LedgerTransactionIDData == string.Empty)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Invalid Visit No. ", labno[i]) });
                }

                int LedgerTransactionID = Util.GetInt(LedgerTransactionIDData.Split('#')[0]);
                string BookingDate = Util.GetDateTime(LedgerTransactionIDData.Split('#')[1]).ToString("yyyy-MM-dd HH:mm:ss");

                int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_opd_share WHERE LedgerTransactionID=@LedgerTransactionID AND IFNULL(InvoiceNo,'')='' ",
                    new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)));
                if (count == 0)
                {
                    tnx.Rollback();
                    return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Invoice Generated, So Share Updation Not Possible ", labno[i]) });
                }
                else
                {
                    Panel_Share ps = new Panel_Share();
                    JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(LedgerTransactionID, tnx, con, Util.GetDateTime(BookingDate)));
                    if (IPS.status == false)
                    {
                        tnx.Rollback();
                        return JsonConvert.SerializeObject(new { status = false, response = string.Concat("Share Not Set,Contact to Account Team ", labno[i]) });
                    }



                }
            }
            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true, response = "Share Updated Successfully" });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Share Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    private DataTable getExcelDetail()
    {
        DataTable dt = new DataTable();
        dt.TableName = "Orders";
        dt.Columns.Add("LabNo");

        return dt;
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

                        var LabNoCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["LabNo"].ToString())).AsDataView().Count;
                        if (LabNoCount > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter LabNo in Excel S.No. : ", string.Join(" ,", dtIncremented.AsEnumerable().Where(p => p.Field<string>("LabNo") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                            return;
                        }

                        string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\UploadClientShare");
                        if (!Directory.Exists(RootDir))
                            Directory.CreateDirectory(RootDir);

                        RootDir = RootDir + @"\" + DateTime.Now.ToString("yyyyMMdd");
                        if (!Directory.Exists(RootDir))
                            Directory.CreateDirectory(RootDir);

                        string fileExt = System.IO.Path.GetExtension(fuExcel.FileName);
                        string FileName = string.Concat(DateTime.Now.ToString("yyyyMMdd"), "##", fuExcel.FileName.Replace(fileExt, "").Trim(), "##", Guid.NewGuid().ToString(), fileExt);
                        fuExcel.SaveAs(string.Concat(RootDir, @"\", FileName));

                        MySqlConnection con = Util.GetMySqlCon();
                        con.Open();
                        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                        try
                        {
                            for (int i = 0; i < dt.Rows.Count; i++)
                            {
                                string LedgerTransactionIDData = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(LedgerTransactionID,'#',Date)LedgerTransactionID FROM f_ledgertransaction WHERE LedgerTransactionNo=@LedgerTransactionNo ",
                                                                                            new MySqlParameter("@LedgerTransactionNo", dt.Rows[i]["LabNo"].ToString())));
                                if (LedgerTransactionIDData == string.Empty)
                                {
                                    tnx.Rollback();
                                    lblMsg.Text = string.Concat("Invalid Visit No. ", dt.Rows[i]["LabNo"].ToString());
                                    return;
                                }
                                //if (LedgerTransactionIDData.Split('#')[1] == "1")
                                //{
                                //    continue;
                                //}
                                int LedgerTransactionID = Util.GetInt(LedgerTransactionIDData.Split('#')[0]);

                                string BookingDate = Util.GetDateTime(LedgerTransactionIDData.Split('#')[1]).ToString("yyyy-MM-dd HH:mm:ss");

                                //int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM patient_labinvestigation_opd_share WHERE LedgerTransactionID=@LedgerTransactionID AND IFNULL(InvoiceNo,'')='' ",
                                //    new MySqlParameter("@LedgerTransactionID", LedgerTransactionID)));
                                //if (count == 0)
                                //{
                                //    tnx.Rollback();
                                //    lblMsg.Text = string.Concat("Invoice Generated, So Share Updation Not Possible ", dt.Rows[i]["LabNo"].ToString());
                                //    return;
                                //}
                                //else
                                //{
                                    Panel_Share ps = new Panel_Share();
                                    JSONResponse IPS = JsonConvert.DeserializeObject<JSONResponse>(ps.InsertPanel_Share(LedgerTransactionID, tnx, con, Util.GetDateTime(BookingDate)));
                                    if (IPS.status == false)
                                    {
                                        tnx.Rollback();
                                        lblMsg.Text = string.Concat("Share Not Set,Contact to Account Team ", dt.Rows[i]["LabNo"].ToString());
                                        return;
                                    }



                               //  }
                            }
                            tnx.Commit();
                            lblMsg.Text = "Share Updated Successfully";
                        }
                        catch (Exception ex)
                        {
                            tnx.Rollback();
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
                            lblMsg.Text = "Share Error";
                        }
                        finally
                        {
                            tnx.Dispose();
                            con.Close();
                            con.Dispose();
                        }

                    }
                }
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            lblMsg.Text = ex.Message;
        }
        finally
        {

        }

    }

}