using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.Services;

public partial class Design_Master_DocumentMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtDocumentDate, txtDocumentDate);
            txtAmendDate.Attributes.Add("readOnly", "readOnly");
            txtDocumentDate.Attributes.Add("readOnly", "readOnly");
            calAmendDate.EndDate = DateTime.Now;
            calDocument.EndDate = DateTime.Now;
        }
    }

    [WebMethod]
    public static string getDepartment()
    {
        return JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ID,DepartmentName FROM Document_DepartmentMatser where IsActive=1 "));
    }

    [WebMethod]
    public static string getDepartmentList()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dtSearch = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT ID,DepartmentName FROM Document_DepartmentMatser Order by ID desc"
                ).Tables[0])

                return dtSearch.Rows.Count > 0 ? JsonConvert.SerializeObject(new { status = true, data = dtSearch }) : JsonConvert.SerializeObject(new { status = false, data = "No Record Found" });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string GetDocumentDetails(int DocID, string type = "dynamicImage")
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (type == "dynamicImage")
            {
                sb.Append(" SELECT documentID ID, dynamicImageHeaderPath, Date_Format(dynmicImageUploadDate,'%d-%M-%y') dynmicImageUploadDate,dynamicImageUploadName ");
                sb.Append("  FROM document_master_setup where IsActive=1  ");
                sb.Append("  AND IFNULL(dynamicImageHeaderPath,'')<>'' AND documentID=@ID  ");
                sb.Append(" order by documentID desc");
            }
            else
            {
                sb.Append(" SELECT documentID ID, documentPath dynamicImageHeaderPath, Date_Format(documentUploadDate,'%d-%M-%y') dynmicImageUploadDate,documentUploadByName dynamicImageUploadName ");
                sb.Append("FROM document_master_setup where IsActive=1  ");
                sb.Append("AND IFNULL(documentPath,'')<>'' AND documentID=@ID  ");
                sb.Append("order by documentID desc");

            }


            using (DataTable dtSearch = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@ID", DocID)
                ).Tables[0])
                return dtSearch.Rows.Count > 0 ? JsonConvert.SerializeObject(new { status = true, data = dtSearch }) : JsonConvert.SerializeObject(new { status = false, data = "No Record Found" });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string GetDocDetails(string DocName = "", string DocNo = "", string DeptIds = "")
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(@" SELECT documentID ID,documentName docName,documentno docNo,Date_Format(documentDate,'%d-%M-%y') docDate,IF(lastAmendmendDate='0001-01-01 00:00:00','',Date_Format(lastAmendmendDate,'%d-%M-%y')) lastAmendmendDate,lastAmendmendReason,depatrmentIDs,depatrmentNames,IFNULL(documentPath,'') docPath,IFNULL(dynamicImageHeaderPath,'') dynamicImageHeaderPath, Date_Format(EntryDate,'%d-%M-%y') EntryDate,EntryBy,EntryByName 
                         FROM document_master_setup where IsActive=1   order by documentID desc");

            using (DataTable dtSearch = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()
                ).Tables[0])
                return dtSearch.Rows.Count > 0 ? JsonConvert.SerializeObject(new { status = true, data = dtSearch }) : JsonConvert.SerializeObject(new { status = false, data = "No Record Found" });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });
        }

        finally
        {
            con.Close();
            con.Dispose();
        }
    }



    [WebMethod(EnableSession = true)]
    public static string SaveDepartment(string deptID, string deptName)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int count = 0;
            StringBuilder sb = new StringBuilder();
            if (deptID == string.Empty)
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM Document_DepartmentMatser WHERE DepartmentName=@DepartmentName",
                   new MySqlParameter("@DepartmentName", deptName.Trim())));
                if (count == 0)
                {
                    sb.Append(" Insert into Document_DepartmentMatser (DepartmentName,EntryBy,EntryByName) ");
                    sb.Append(" VALUES(@DepartmentName,@EntryBy,@EntryByName) ");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@DepartmentName", deptName),
                       new MySqlParameter("@EntryBy", UserInfo.ID),
                       new MySqlParameter("@EntryByName", UserInfo.LoginName));
                }


            }
            else
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM Document_DepartmentMatser WHERE DepartmentName=@DepartmentName AND ID!=@ID",
                   new MySqlParameter("@DepartmentName", deptName.Trim()),
                   new MySqlParameter("@ID", deptID)));
                if (count == 0)
                {
                    sb.Append(" Update Document_DepartmentMatser SET DepartmentName=@DepartmentName,UpdateUserID=@EntryBy,  UpdateUserName=@EntryByName,  UpdateDateTime=NOW() ");
                    sb.Append(" WHERE ID=@ID");
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@ID", deptID),
                       new MySqlParameter("@DepartmentName", deptName),
                       new MySqlParameter("@EntryBy", UserInfo.ID),
                       new MySqlParameter("@EntryByName", UserInfo.LoginName));
                }
            }
            if (count == 0)
                return JsonConvert.SerializeObject(new { status = true });
            else
                return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "DepartmentName Already Exit" });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveDocDetails(DocumentMaster DocDetails)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            int count = 0;
            string response = string.Empty;
            int MaxID = 0;
            if (DocDetails.ID == string.Empty)
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM document_master_setup WHERE documentName=@documentName",
                   new MySqlParameter("@documentName", DocDetails.DocName.Trim())));
                if (count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, data = "Document Name Already Exits" });
                }
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM document_master_setup WHERE documentNo=@documentNo",
                   new MySqlParameter("@documentNo", DocDetails.DocNo.Trim())));
                if (count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, data = "Document No. Already Exits" });
                }

                StringBuilder sb = new StringBuilder();
                sb.Append(" INSERT INTO  document_master_setup (documentName, documentNo,documentDate,lastAmendmendDate,lastAmendmendReason,depatrmentIDs,depatrmentNames,EntryBy,EntryByName) ");
                sb.Append(" VALUES (@docName, @docNo, @docDate, @lastAmendmendDate, @lastAmendmendReason, @depatrmentIDs, @depatrmentNames, @EntryBy, @EntryByName) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@docName", DocDetails.DocName),
                   new MySqlParameter("@docNo", DocDetails.DocNo),
                   new MySqlParameter("@docDate", Util.GetDateTime(DocDetails.docDate).ToString("yyyy-MM-dd")),
                   new MySqlParameter("@lastAmendmendDate", Util.GetDateTime(DocDetails.LastAmenmendDate).ToString("yyyy-MM-dd")),
                   new MySqlParameter("@lastAmendmendReason", DocDetails.LastAmenmendReason),
                   new MySqlParameter("@depatrmentIDs", DocDetails.DeptIds),
                   new MySqlParameter("@depatrmentNames", DocDetails.DeptNames),
                   new MySqlParameter("@EntryBy", UserInfo.ID),
                   new MySqlParameter("@EntryByName", UserInfo.LoginName));

                response = "Document Saved Successfully";
                MaxID = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT LAST_INSERT_ID() as AutoKey"));
            }
            else
            {
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM document_master_setup WHERE documentName=@documentName AND documentID!=@documentID",
                   new MySqlParameter("@documentName", DocDetails.DocName.Trim()),
                   new MySqlParameter("@documentID", DocDetails.ID)));
                if (count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, data = "Document Name Already Exits" });
                }
                count = Util.GetInt(MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "SELECT COUNT(1) FROM document_master_setup WHERE documentNo=@documentNo AND documentID!=@documentID",
                   new MySqlParameter("@documentNo", DocDetails.DocNo.Trim()),
                   new MySqlParameter("@documentID", DocDetails.ID)));
                if (count > 0)
                {
                    return JsonConvert.SerializeObject(new { status = false, data = "Document No. Already Exits" });
                }
                StringBuilder sb = new StringBuilder();
                sb.Append(" UPDATE document_master_setup set  documentName=@docName, documentNo=@docNo,documentDate=@docDate,lastAmendmendDate=@lastAmendmendDate,lastAmendmendReason=@lastAmendmendReason,depatrmentIDs=@depatrmentIDs,depatrmentNames=@depatrmentNames,UpdateUserID= @EntryBy,  UpdateUserName=@EntryByName,  UpdateDateTime=NOW() ");
                sb.Append(" where documentID=@ID ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@docName", DocDetails.DocName),
                   new MySqlParameter("@docNo", DocDetails.DocNo),
                   new MySqlParameter("@docDate", Util.GetDateTime(DocDetails.docDate).ToString("yyyy-MM-dd")),
                   new MySqlParameter("@lastAmendmendDate", Util.GetDateTime(DocDetails.LastAmenmendDate).ToString("yyyy-MM-dd")),
                   new MySqlParameter("@lastAmendmendReason", DocDetails.LastAmenmendReason),
                   new MySqlParameter("@depatrmentIDs", DocDetails.DeptIds),
                   new MySqlParameter("@depatrmentNames", DocDetails.DeptNames),
                   new MySqlParameter("@EntryBy", UserInfo.ID),
                   new MySqlParameter("@EntryByName", UserInfo.LoginName),
                   new MySqlParameter("@ID", DocDetails.ID));

                response = "Document Updated Successfully";
            }
            
            tnx.Commit();


            return JsonConvert.SerializeObject(new { status = true, data = MaxID, response = response });
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string deleteDoc(int DocID, string DocPath)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update document_master_setup set  documentPath='', documentDeleteBy= @EntryBy,  documentDeleteByName=@EntryByName,  documentDeleteDate=NOW() ");
            sb.Append(" where documentID=@ID ");
            int a = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@EntryBy", UserInfo.ID),
                new MySqlParameter("@EntryByName", UserInfo.LoginName),
                new MySqlParameter("@ID", DocID));

            if (a > 0)
            {
                if (File.Exists(string.Format("{0}\\ClientDocument\\{1}", Resources.Resource.DocumentPath, DocPath)))
                {
                    File.Delete(string.Format("{0}\\ClientDocument\\{1}", Resources.Resource.DocumentPath, DocPath));
                }
                tnx.Commit();
                return JsonConvert.SerializeObject(new { status = true });
            }
            else
            {
                tnx.Rollback();

                return JsonConvert.SerializeObject(new { status = false });
            }

        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = Util.GetString(ex.GetBaseException()) });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }


    public class DocumentMaster
    {
        public string ID { get; set; }
        public string DocName { get; set; }
        public string DocNo { get; set; }
        public string DocPDFPath { get; set; }
        public DateTime docDate { get; set; }
        public string DocDynamicImage { get; set; }
        public DateTime LastAmenmendDate { get; set; }
        public string LastAmenmendReason { get; set; }
        public string DeptIds { get; set; }
        public string DeptNames { get; set; }
    }
    [WebMethod]
    public static string getDocumentView( int ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string base64Image = string.Empty;
            string DocumentPath = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT DocumentPath FROM document_master_setup WHERE DocumentID=@ID ",
               new MySqlParameter("@ID", ID)));
            if (DocumentPath != string.Empty)
            {
                string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\ClientDocument\\", DocumentPath);
                byte[] imageArray = System.IO.File.ReadAllBytes(RootDir);
                base64Image = Convert.ToBase64String(imageArray);
            }
            return JsonConvert.SerializeObject(new { status = "true", response = base64Image });
        }
        catch (Exception ex)
        {

            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();

        }
    }
}