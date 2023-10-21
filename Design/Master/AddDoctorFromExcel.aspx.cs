using ClosedXML.Excel;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Master_AddDoctorFromExcel : System.Web.UI.Page
{
    public static string Columns = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindcentre();
            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "$bindStateCityLocality();", true);
        }
    }

    private void bindcentre()
    {
        DataTable dt = StockReports.GetDataTable(" SELECT  cm.CentreID,IFNULL(cm.`CentreCode`,'') CentreCode,cm.Centre,cm.City,cm.State FROM centre_master cm WHERE  cm.IsActive=1 ");
        if (dt.Rows.Count > 0)
        {
            ddlCenter.DataTextField = "Centre";
            ddlCenter.DataValueField = "CentreID";
            ddlCenter.DataSource = dt;
            ddlCenter.DataBind();
        }
    }

    public class ClsQuery
    {
        public string Title { get; set; }
        public string Name { get; set; }
        public string MobileNo { get; set; }
        public string EmailID { get; set; }
        public string Address { get; set; }
        public string Degree { get; set; }
        public string Specialization { get; set; }
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

    protected void btnupload_Click(object sender, EventArgs e)
    {
        try
        {
            int count = 0;
            foreach (System.Web.UI.WebControls.ListItem item in ddlCenter.Items)
            {
                if (item.Selected)
                {
                    count = 1;
                }
                if (count > 0)
                    break;
            }
            if (count == 0)
            {
                lblMsg.Text = "Please select Centre ";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindAllField();", true);
                return;
            }
            if (file1.HasFile)
            {
                string FileExtension = Path.GetExtension(file1.PostedFile.FileName);
                if (FileExtension.ToLower() != ".xlsx" && FileExtension.ToLower() != ".xls")
                {
                    lblMsg.Text = "Please select excel file only ";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindAllField();", true);
                    return;
                }
            }
            else
            {
                lblMsg.Text = "Please select excel file";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindAllField();", true);
                return;
            }
            string FileName = "";

            string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\DoctorExcel");
            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);

            RootDir = string.Format(@"{0}\{1:yyyyMMdd}", RootDir, DateTime.Now);
            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);
            string fileExt = System.IO.Path.GetExtension(file1.FileName);
            FileName = string.Format("{0}_{1:yyyyMMddHHmmss}{2}", file1.FileName.Replace(fileExt, "").Trim(), DateTime.Now, fileExt);
            file1.SaveAs(string.Format(@"{0}\{1}", RootDir, FileName));

            FileUpload fl = file1;
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
                    List<string> dtTableNames = getDocRowDetail().Columns.Cast<DataColumn>().Select(x => x.ColumnName).ToList();
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

                        var TitleCount = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Title"].ToString())).AsDataView().Count;
                        if (TitleCount > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Title in Excel S.No. : ", string.Join(", ", dtIncremented.AsEnumerable().Where(p => p.Field<string>("Title") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindAllField();", true);
                            return;
                        }
                        TitleCount = dt.AsEnumerable().Where(c => c.Field<String>("Title") != "Mr." && c.Field<String>("Title") != "Dr." && c.Field<String>("Title") != "Ms.").Count();
                        if (TitleCount > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Title(Mr., Dr., Ms.) in Excel S.No. : ", string.Join(", ", dtIncremented.AsEnumerable().Where(c => c.Field<String>("Title") != "Mr." && c.Field<String>("Title") != "Dr." && c.Field<String>("Title") != "Ms.").Select(cc => cc.Field<int>("ID") + 1)));
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindAllField();", true);
                            return;
                        }
                        var chkName = dtIncremented.AsEnumerable().Where(r => string.IsNullOrWhiteSpace(r["Name"].ToString())).AsDataView().Count;
                        if (chkName > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Name in Excel S.No. : ", string.Join(", ", dtIncremented.AsEnumerable().Where(p => p.Field<string>("Name") == string.Empty).Select(cc => cc.Field<int>("ID") + 1)));
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindAllField();", true);
                            return;
                        }
                        int EmailInvalid = dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Email"].ToString())).Where(myRow => !Regex.IsMatch(myRow.Field<String>("Email").Trim(), @"^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$")).Count();
                        if (EmailInvalid > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Email in Excel S.No. : ", string.Join(", ", dtIncremented.AsEnumerable().Where(r => !string.IsNullOrWhiteSpace(r["Email"].ToString())).Where(myRow => !Regex.IsMatch(myRow.Field<String>("Email").Trim(), @"^[\w-\.]+@([\w-]+\.)+[\w-]{2,6}$")).Select(cc => cc.Field<int>("ID") + 1)));
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindAllField();", true);
                            return;
                        }

                        long num2;
                        var MobileChkInt = dtIncremented.AsEnumerable().Where(myRow => !long.TryParse(myRow.Field<String>("Mobile"), out num2)).Count();
                        if (MobileChkInt > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Mobile in Excel S.No. : ", string.Join(", ", dtIncremented.AsEnumerable().Where(myRow => !long.TryParse(myRow.Field<String>("Mobile"), out num2)).Select(cc => cc.Field<int>("ID") + 1)));
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindAllField();", true);
                            return;
                        }
                        var chkMobileLength = dtIncremented.AsEnumerable().Where(p => p.Field<string>("Mobile").Length != 10).AsDataView().Count;
                        if (chkMobileLength > 0)
                        {
                            lblMsg.Text = string.Concat("Please Enter Valid Mobile in Excel S.No. : ", string.Join(", ", dtIncremented.AsEnumerable().Where(myRow => myRow.Field<string>("Mobile").Length != 10).Select(cc => cc.Field<int>("ID") + 1)));
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindAllField();", true);
                            return;
                        }
                        var duplicatedMobileNo = dtIncremented.AsEnumerable().GroupBy(r => r.Field<string>("Mobile")).Where(gr => gr.Count() > 1).ToList();
                        if (duplicatedMobileNo.Any())
                        {
                            lblMsg.Text = string.Concat("Duplicate mobile no Found In Excel  and Mobile Nos are : ", string.Join(", ", duplicatedMobileNo.Select(dupl => dupl.Key)));
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindAllField();", true);
                            return;
                        }
                        MySqlConnection con = Util.GetMySqlCon();
                        con.Open();
                        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
                        try
                        {
                            var mobilelist = dtIncremented.AsEnumerable().Select(r => new
                            {
                                Mobile = r.Field<string>("Mobile"),
                            }).ToList();
                            using (DataTable CheckMobile = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT Mobile FROM doctor_referal WHERE IsActive=1  AND Mobile<>'' ").Tables[0])
                            {
                                List<doctor_mobile> dmb = new List<doctor_mobile>();
                                dmb = (from DataRow row in CheckMobile.Rows
                                       select new doctor_mobile
                                       {
                                           Mobile = row["Mobile"].ToString()
                                       }).ToList();
                                HashSet<string> alreadyEnterMobileNo = new HashSet<string>(dmb.Select(s => s.Mobile));
                                var MachedMobileNo = mobilelist.Where(m => alreadyEnterMobileNo.Contains(m.Mobile)).ToList();

                                if (MachedMobileNo.Count > 0)
                                {
                                    lblMsg.Text = string.Concat("Please Enter Valid Mobile No. These mobile no already exists : ", string.Join(", ", MachedMobileNo.Select(s => s.Mobile).ToArray()));
                                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "bindAllField();", true);
                                    return;
                                }
                                dmb.Clear();
                            }
                            var distinctDegree = dt.AsEnumerable().Select(row => row.Field<string>("Degree")).Distinct().ToList();
                            using (DataTable degree = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT degree from f_degreemaster where degree<>'' ").Tables[0])
                            {
                                List<degree_Name> dcg = new List<degree_Name>();
                                dcg = (from DataRow row in degree.Rows
                                       select new degree_Name
                                       {
                                           degree = row["Degree"].ToString()
                                       }).ToList();

                                var notMachDegree = distinctDegree.Except(dcg.Select(P => P.degree), StringComparer.OrdinalIgnoreCase).ToList();
                                if (notMachDegree.Count > 0)
                                {
                                    foreach (var item in notMachDegree)
                                    {
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO f_degreemaster(Degree) values(@degree)",
                                            new MySqlParameter("@degree", item));
                                    }
                                }
                                dcg.Clear();
                            }
                            var specialization = dt.AsEnumerable().Select(row => row.Field<string>("Specialization")).Distinct().ToList();
                            using (DataTable spec = AllLoad_Data.loadDocTypeList(3))
                            {
                                List<Specialization> PC = new List<Specialization>();
                                PC = (from DataRow row in spec.Rows
                                      select new Specialization
                                      {
                                          SpName = row["Name"].ToString()
                                      }).ToList();

                                var notMachspecialization = specialization.Except(PC.Select(P => P.SpName), StringComparer.OrdinalIgnoreCase).ToList();
                                if (specialization.Count > 0)
                                {
                                    foreach (var item in specialization)
                                    {
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "INSERT INTO type_master(Name,TypeID,type) values(@Name,3,@type)",
                                            new MySqlParameter("@Name", item), new MySqlParameter("@type", "Doctor-Specialization"));
                                    }
                                }
                                PC.Clear();
                            }
                            StringBuilder sb = new StringBuilder();
                            foreach (DataRow dr in dtIncremented.Rows)
                            {
                                DoctorMasterReferal objDMR = new DoctorMasterReferal(tnx);
                                objDMR.Title = Util.GetString(dr["Title"]);
                                objDMR.Name = Util.GetString(dr["Name"]);
                                objDMR.Phone1 = string.Empty;
                                objDMR.Mobile = Util.GetString(dr["Mobile"]);
                                objDMR.Street_Name = Util.GetString(dr["Address"]);
                                objDMR.Specialization = Util.GetString(dr["Specialization"]);
                                objDMR.Email = Util.GetString(dr["Email"]);
                                objDMR.AddedBy = HttpContext.Current.Session["ID"].ToString();
                                objDMR.ClinicName = string.Empty;
                                objDMR.Degree = Util.GetString(dr["Degree"]);
                                objDMR.State = txtStateID.Text;
                                objDMR.City = txtCityID.Text;
                                objDMR.Locality = txtLocalityID.Text;
                                objDMR.ZoneID = 0;
                                objDMR.DoctorCode = string.Empty;
                                objDMR.IsVisible = "1";
                                objDMR.IsLock = "1";
                                string Doctor_ID = objDMR.Insert();
                                foreach (System.Web.UI.WebControls.ListItem item in ddlCenter.Items)
                                {
                                    if (item.Selected)
                                    {
                                        sb = new StringBuilder();
                                        sb.Append(" INSERT INTO doctor_referal_centre(Doctor_ID,CentreID,UserID,UserName,dtEntry,IpAddress) ");
                                        sb.Append(" values (@DoctorID,@CentreID,@ID,@Name,NOW(),@IP)");
                                        MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(), new MySqlParameter("@DoctorID", Doctor_ID),
                                            new MySqlParameter("@CentreID", item.Value), new MySqlParameter("@ID", UserInfo.ID),
                                            new MySqlParameter("@Name", UserInfo.LoginName), new MySqlParameter("@IP", StockReports.getip()));
                                    }
                                }
                            }
                            tnx.Commit();
                            lblMsg.Text = "Record Saved Successfully";
                            txtCityID.Text = string.Empty;
                            txtLocalityID.Text = string.Empty;
                            txtStateID.Text = string.Empty;
                            txtSelectedCountryID.Text = string.Empty;
                            ScriptManager.RegisterStartupScript(this, this.GetType(), "key1", "$bindStateCityLocality();", true);
                        }
                        catch (Exception ex)
                        {
                            tnx.Rollback();
                            lblMsg.Text = "Error";
                            ClassLog cl = new ClassLog();
                            cl.errLog(ex);
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
            lblMsg.Text = ex.Message.Replace("table", "Excel sheet");
        }
        finally
        {
        }
    }

    public class degree_Name
    {
        public string degree { get; set; }
    }

    public class Specialization
    {
        public string SpName { get; set; }
    }

    public class doctor_mobile
    {
        public string Mobile { get; set; }
    }

    private DataTable getDocRowDetail()
    {
        DataTable dt = new DataTable();
        dt.TableName = "Orders";
        dt.Columns.Add("Title");
        dt.Columns.Add("Name");
        dt.Columns.Add("Mobile");
        dt.Columns.Add("Email");
        dt.Columns.Add("Degree");
        dt.Columns.Add("Specialization");
        dt.Columns.Add("Address");
        return dt;
    }

    protected void lnk1_Click(object sender, EventArgs e)
    {
        using (DataTable dt = getDocRowDetail())
        {
            using (XLWorkbook wb = new XLWorkbook())
            {
                wb.Worksheets.Add(dt, "DoctorReffral");
                Response.Clear();
                Response.Buffer = true;
                Response.Charset = "";
                Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                Response.AddHeader("content-disposition", "attachment;filename=DoctorReffral.xlsx");
                using (MemoryStream MyMemoryStream = new MemoryStream())
                {
                    wb.SaveAs(MyMemoryStream);
                    MyMemoryStream.WriteTo(Response.OutputStream);
                    Response.Flush();
                    // Response.End();
                }
            }
        }
    }

    public class TableColumnHeader
    {
        public string ColumnName { get; set; }
    }

    public class MobileNoDetail
    {
        public string MobileNo { get; set; }
    }
}