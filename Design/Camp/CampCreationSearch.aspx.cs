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

public partial class Design_Camp_CampCreationSearch : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            AllLoad_Data.getCurrentDate(txtFromDate, txtToDate);
            lblView.Text = Common.Encrypt("1");

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                ddlType.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,Type1 FROM centre_type1master Where IsActive=1  ORDER BY Type1").Tables[0];
                ddlType.DataTextField = "Type1";
                ddlType.DataValueField = "ID";
                ddlType.DataBind();
                ddlType.Items.Insert(0, new ListItem("All", "0"));
                if (checkApprovalRight(con) == 0)
                {
                    lblMsg.Text = "You do not have right to access this page";
                    ScriptManager.RegisterStartupScript(this, this.GetType(), "key11", "accessRight();", true);
                    return;
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
    }
    public static int checkApprovalRight(MySqlConnection con)
    {
        return Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(1) FROM camp_approvalright_master WHERE VerificationType='CampCreation' AND IsActive=1 AND ApprovalID=@ApprovalID",
                                            new MySqlParameter("@ApprovalID", UserInfo.ID)));
    }
    [WebMethod]
    public static string SearchCampRequest(string fromDate, string toDate, int searchType, int status, int TypeID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT fpm.Panel_Code,fpm.Company_Name, cr.CampName,DATE_FORMAT(cr.StartDate,'%d-%b-%Y')StartDate,DATE_FORMAT(cr.EndDate,'%d-%b-%Y')EndDate,");
            sb.Append(" cr.CreatedBy,DATE_FORMAT(cr.CreatedDate,'%d-%b-%Y')CreatedDate,DATE_FORMAT(cr.ApprovedDate,'%d-%b-%Y')ApprovedDate,cr.IsActive,cr.IsApproved,cr.IsCreated,cr.ID,cr.CampType");
            sb.Append("");
            sb.Append(" FROM camp_request cr");
            sb.Append(" INNER JOIN f_Panel_master fpm on cr.Panel_ID=fpm.Panel_ID ");
            sb.Append(" WHERE cr.CreatedDate>=@FromDate AND cr.CreatedDate<=@ToDate  AND cr.IsApproved=1 ");
            if (searchType == 0)
            {
                if (status == 0)
                    sb.Append(" AND cr.IsApproved=1 AND cr.IsActive=1 AND cr.IsCreated=0 ");
                else if (status == 1)
                    sb.Append(" AND cr.IsCreated=1 AND cr.IsActive=1 ");
                else if (status == 2)
                    sb.Append(" AND  cr.IsActive=0 ");
            }
            else if (searchType == 2)
                sb.Append(" AND cr.IsApproved=1 AND cr.IsActive=1 AND cr.IsCreated=0 ");
            else if (searchType == 3)
                sb.Append(" AND cr.IsCreated=1 AND cr.IsActive=1 ");
            else if (searchType == 4)
                sb.Append("  cr.IsActive=0 ");
            if (TypeID != 0)
            {
                sb.Append("  AND fpm.CentreType1ID=@TypeID  ");
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                                             new MySqlParameter("@TypeID", TypeID),
                                             new MySqlParameter("@FromDate", string.Concat(Util.GetDateTime(fromDate).ToString("yyyy-MM-dd"), " ", "00:00:00")),
                                             new MySqlParameter("@ToDate", string.Concat(Util.GetDateTime(toDate).ToString("yyyy-MM-dd"), " ", "23:59:59"))).Tables[0])
            {

                return Util.getJson(dt);
            }
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }

    }
    [WebMethod]
    public static string CreateCampRequest(int ID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (checkApprovalRight(con) == 0)
            {
                return JsonConvert.SerializeObject(new { status = false, response = "You do not have right to access this page" });

            }
            string dtcamp = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT CONCAT(IsApproved,'#',IsActive,'#',IsCreated)CampDetail FROM camp_request WHERE ID=@ID",
                                                       new MySqlParameter("@ID", ID)));
            if (Util.GetInt(dtcamp.Split('#')[0]) == 0)
            {
                return JsonConvert.SerializeObject(new { Status = false, response = "Camp Request Approval for Pending" });

            }
            if (Util.GetInt(dtcamp.Split('#')[1]) == 0)
            {
                return JsonConvert.SerializeObject(new { Status = false, response = "Camp Request Deactive"});

            }
            if (Util.GetInt(dtcamp.Split('#')[2]) == 1)
            {
                return JsonConvert.SerializeObject(new { Status = false, response = "Camp Request Already Created" });

            }

            return JsonConvert.SerializeObject(new { Status = true, response = Common.EncryptRijndael(Util.GetString(ID)) });

        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return string.Empty;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}