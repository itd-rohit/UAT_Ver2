using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Master_DocumentSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string getDepartment()
    {
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable("SELECT ID,DepartmentName FROM Document_DepartmentMatser where IsActive=1 "));
    }

    [WebMethod(EnableSession = true)]
    public static string GetDocDetails(string DocName = "", string DocNo = "", string DeptIds = "")
    {


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            string[] deptTags = String.Join(",", Util.GetString(HttpContext.Current.Session["AccessDepartment"]).Replace(",", "','")).Split(',');
            string[] deptParamNames = deptTags.Select((s, i) => "@tag" + i).ToArray();
            string deptClause = string.Join(", ", deptParamNames);

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT t.*,IFNULL(dmr.ID,'0')IsRead FROM (SELECT  ");
            sb.Append("  dm.documentID ID,dm.documentName docName, dm.documentno docNo,DATE_FORMAT(dm.documentDate,'%d-%M-%y') docDate,");
            sb.Append("   IF(dm.lastAmendmendDate='0001-01-01 00:00:00','',DATE_FORMAT(dm.lastAmendmendDate,'%d-%M-%y')) lastAmendmendDate,");
            sb.Append("   dm.lastAmendmendReason,dm.depatrmentIDs,dm.depatrmentNames,IFNULL(dm.documentPath,'') docPath, ");
            sb.Append("   DATE_FORMAT(dm.EntryDate,'%d-%M-%y') EntryDate, dm.EntryBy, dm.EntryByName ");
            sb.Append("   FROM document_master_setup dm ");
            sb.Append("   INNER JOIN  Document_Master_Access  dma  ON dm.documentID=dma.documentID AND dma.`AccessType`='CentreId'");
            sb.Append("  AND dma.`AccessTypeto`=@CentreID");
            sb.Append("  WHERE dm.IsActive=1 AND IFNULL(dm.documentPath,'')<>'' ");
            sb.Append("  UNION ALL");
            sb.Append("    SELECT  ");
            sb.Append("     dm.documentID ID,dm.documentName docName, dm.documentno docNo,DATE_FORMAT(dm.documentDate,'%d-%M-%y') docDate,");
            sb.Append("    IF(dm.lastAmendmendDate='0001-01-01 00:00:00','',DATE_FORMAT(dm.lastAmendmendDate,'%d-%M-%y')) lastAmendmendDate,");
            sb.Append("    dm.lastAmendmendReason,dm.depatrmentIDs,dm.depatrmentNames,IFNULL(dm.documentPath,'') docPath, ");
            sb.Append("    DATE_FORMAT(dm.EntryDate,'%d-%M-%y') EntryDate, dm.EntryBy, dm.EntryByName ");
            sb.Append("    FROM document_master_setup dm ");
            sb.Append("    INNER JOIN  Document_Master_Access  dma  ON dm.documentID=dma.documentID AND dma.`AccessType`='RoleId'");
            sb.Append("    AND dma.`AccessTypeto`=@RoleID");
            sb.Append("    WHERE dm.IsActive=1 AND IFNULL(dm.documentPath,'')<>''  ");
            sb.Append(" UNION ALL");
            sb.Append("  SELECT  ");
            sb.Append("   dm.documentID ID,dm.documentName docName, dm.documentno docNo,DATE_FORMAT(dm.documentDate,'%d-%M-%y') docDate,");
            sb.Append("   IF(dm.lastAmendmendDate='0001-01-01 00:00:00','',DATE_FORMAT(dm.lastAmendmendDate,'%d-%M-%y')) lastAmendmendDate,");
            sb.Append("   dm.lastAmendmendReason,dm.depatrmentIDs,dm.depatrmentNames,IFNULL(dm.documentPath,'') docPath, ");
            sb.Append("   DATE_FORMAT(dm.EntryDate,'%d-%M-%y') EntryDate, dm.EntryBy, dm.EntryByName ");
            sb.Append("   FROM document_master_setup dm ");
            sb.Append("   INNER JOIN  Document_Master_Access  dma  ON dm.documentID=dma.documentID AND dma.`AccessType`='SubCategoryID'");
            sb.Append("   AND dma.`AccessTypeto` IN ({0})");
            sb.Append("   WHERE dm.IsActive=1 AND IFNULL(dm.documentPath,'')<>''  ");
            sb.Append(" UNION ALL");
            sb.Append("   SELECT  ");
            sb.Append("    dm.documentID ID,dm.documentName docName, dm.documentno docNo,DATE_FORMAT(dm.documentDate,'%d-%M-%y') docDate,");
            sb.Append("   IF(dm.lastAmendmendDate='0001-01-01 00:00:00','',DATE_FORMAT(dm.lastAmendmendDate,'%d-%M-%y')) lastAmendmendDate,");
            sb.Append("   dm.lastAmendmendReason,dm.depatrmentIDs,dm.depatrmentNames,IFNULL(dm.documentPath,'') docPath, ");
            sb.Append("   DATE_FORMAT(dm.EntryDate,'%d-%M-%y') EntryDate, dm.EntryBy, dm.EntryByName ");
            sb.Append("   FROM document_master_setup dm ");
            sb.Append("   INNER JOIN  Document_Master_Access  dma  ON dm.documentID=dma.documentID AND dma.`AccessType`='Employee_ID'");
            sb.Append("   AND dma.`AccessTypeto`=@EmployeeID");
            sb.Append("   WHERE dm.IsActive=1 AND IFNULL(dm.documentPath,'')<>''");
            sb.Append("   ) t LEFT JOIN document_master_readlog dmr ON dmr.DocumentID=t.ID   WHERE 1=1 ");

            if (DocName != string.Empty)
            {
                sb.Append(" AND t.docName LIKE @documentName ");
            }
            if (DocNo != string.Empty)
            {
                sb.Append(" AND t.docNo LIKE @documentno ");
            }
            


            sb.Append(" GROUP BY t.ID  ORDER by t.ID desc");
            DataTable dtSearch = new DataTable();

            using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), deptClause), con))
            {
                for (int i = 0; i < deptParamNames.Length; i++)
                {
                    da.SelectCommand.Parameters.AddWithValue(deptParamNames[i], deptTags[i]);
                }
                if (DocName != string.Empty)
                {
                    da.SelectCommand.Parameters.AddWithValue("@documentName", string.Format("{0}%", DocName));
                }
                if (DocNo != string.Empty)
                {
                    da.SelectCommand.Parameters.AddWithValue("@documentno", string.Format("{0}%", DocNo));

                }
                da.SelectCommand.Parameters.AddWithValue("@CentreID", UserInfo.Centre);
                da.SelectCommand.Parameters.AddWithValue("@RoleID", UserInfo.RoleID);
                da.SelectCommand.Parameters.AddWithValue("@EmployeeID", UserInfo.ID);

                da.Fill(dtSearch);
            }


            if (dtSearch.Rows.Count > 0)
            {
                return JsonConvert.SerializeObject(new { status = true, data = dtSearch });

            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false, data = "No Record Found" });
            }

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
    public static string DocumentReadLog(int DocID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();

            sb.Append(" INSERT INTO document_master_readlog ( DocumentID,ReadBy,ReadByID,ReadDate) ");
            sb.Append(" VALUES ( @DocumentID,@ReadBy,@ReadByID,NOW()) ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@DocumentID", DocID),
                new MySqlParameter("@ReadByID", UserInfo.ID),
                new MySqlParameter("@ReadBy", UserInfo.LoginName));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true });


        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return JsonConvert.SerializeObject(new { status = false, ErrorMsg = "Error" });
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string InsertDocViewLog(int DocID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" Update document_master_setup set isPrint=1 ");
            sb.Append(" where documentID=@ID ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@ID", DocID));

            sb = new StringBuilder();
            sb.Append(" Insert into document_master_log ( DocumentID,PrintedBy,PrintedByName,RoleID,CentreID,IpAddress) ");
            sb.Append("   VALUES ( @DocumentID,@PrintedBy,@PrintedByName,@RoleID,@CentreID,@IpAddress) ");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                new MySqlParameter("@DocumentID", DocID),
                new MySqlParameter("@PrintedBy", UserInfo.ID),
                new MySqlParameter("@PrintedByName", UserInfo.LoginName),
                new MySqlParameter("@RoleID", UserInfo.RoleID),
                new MySqlParameter("@CentreID", UserInfo.Centre),
                new MySqlParameter("@IpAddress", StockReports.getip()));

            tnx.Commit();
            return JsonConvert.SerializeObject(new { status = true });


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
}