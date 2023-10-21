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

public partial class Design_Master_DocumentMaster_access : System.Web.UI.Page
{
    public string DocID = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        DocID = Request.QueryString["DocID"].ToString();
        if (!IsPostBack)
        {
            bindData();
        }
    }

    [WebMethod]
    public static string getAccessDetails(string DocID, string accessType)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();

            if (accessType == "Employee_ID")
            {
                sb.Append(@" SELECT dma.AccessTypeto Employee_ID, Concat(em.Title,'',em.Name) `Name` FROM Document_Master_Access dma 
                            INNER join employee_master em on dma.AccessTypeto=em.Employee_ID AND DocumentID=@DocumentID AND AccessType=@AccessType ");
            }
            else
            {
                sb.Append(" SELECT Group_Concat(AccessTypeto) AccessTypeto FROM Document_Master_Access WHERE DocumentID=@DocumentID AND AccessType=@AccessType  group by AccessType");
            }

            DataTable dtSearch = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@DocumentID",DocID),
                new MySqlParameter("@AccessType",accessType)
               ).Tables[0];
            con.Close();
            con.Dispose();
            if (dtSearch.Rows.Count > 0)
            {
                return JsonConvert.SerializeObject(new { status = true, data = dtSearch });

            }
            else
            {
                return JsonConvert.SerializeObject(new { status = false });
            }

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            con.Close();
            con.Dispose();
            return JsonConvert.SerializeObject(new { status = false, data = ex.ToString() });
        }

    }

    private void bindData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = AllLoad_Data.getCentreByLogin())
            {
                if (dt.Rows.Count > 0)
                {
                    chklCentres.DataSource = dt;
                    chklCentres.DataTextField = "Centre";
                    chklCentres.DataValueField = "CentreID";
                    chklCentres.DataBind();
                }
            }

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT ID,RoleName FROM `f_rolemaster` where Active=1 ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString()).Tables[0])
            {

                chklistRole.DataSource = dt;
                chklistRole.DataTextField = "RoleName";
                chklistRole.DataValueField = "ID";
                chklistRole.DataBind();
            }


            sb = new StringBuilder();
            sb.Append("  SELECT `SubCategoryID`,NAME FROM f_subcategorymaster WHERE active=1 AND `CategoryID`='LSHHI3'   ");
          
            sb.Append(" ORDER BY NAME");

            using (MySqlDataAdapter da = new MySqlDataAdapter(string.Format(sb.ToString()), con))
            {
                DataTable dt = new DataTable();
                using (dt as IDisposable)
                {
                    da.Fill(dt);
                    chklistDepartment.DataSource = dt;
                    chklistDepartment.DataTextField = "NAME";
                    chklistDepartment.DataValueField = "SubCategoryID";
                    chklistDepartment.DataBind();
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
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string SaveDocAccess(List<DocumentAccess> documentdata, string DocumentID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, " delete from document_master_access where DocumentID=@DocumentID ",
                 new MySqlParameter("@DocumentID", DocumentID));


            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT into document_master_access (DocumentID,  AccessType , AccessTypeto ,  EntryBy,  EntryByName)");
            sb.Append(" VALUES (@DocumentID,  @AccessType,  @AccessTypeto,  @EntryBy,  @EntryByName) ");
            foreach (DocumentAccess item in documentdata)
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                  new MySqlParameter("@DocumentID", item.DocumentID),
                  new MySqlParameter("@AccessType", item.AccessType),
                  new MySqlParameter("@AccessTypeto", item.AccessTypeto),
                  new MySqlParameter("@EntryBy", UserInfo.ID),
                  new MySqlParameter("@EntryByName", UserInfo.LoginName));
            }
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

    public class DocumentAccess
    {
        public int DocumentID { get; set; }
        public string AccessType { get; set; }
        public int AccessTypeto { get; set; }
    }

}