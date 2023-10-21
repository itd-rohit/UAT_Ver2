using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;

public partial class Design_Support_CategoryMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindRole();
        }
    }

    private void BindRole()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            lstRole.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT UPPER(rm.RoleName) RoleName,rm.ID FROM f_login fl INNER JOIN f_rolemaster rm " +
                           "ON fl.RoleID=rm.ID AND fl.EmployeeID=@EmployeeID AND fl.Active=1 AND rm.Active=1 and fl.CentreID=@CentreID ORDER BY rm.RoleName",
                           new MySqlParameter("@EmployeeID", UserInfo.ID),
                  new MySqlParameter("@CentreID", UserInfo.Centre)).Tables[0];
            lstRole.DataTextField = "RoleName";
            lstRole.DataValueField = "ID";
            lstRole.DataBind();
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

    public static StringBuilder getCategoryDetail()
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT Roles ShowRole1, ID,  CategoryName,  IF(ShowClient=1,'Yes','No') ShowClient,  IF(ShowRole=1,'Yes','No') ShowRole, ");
        sb.Append(" IF(ShowCentre=1,'Yes','No') ShowCentre,  IF(ShowBarcodeNo=1,'Yes','No') ShowBarcodeNo, IF(ShowLabNo=1,'Yes','No') ShowLabNo,");
        sb.Append(" IF(ShowTestCode=1,'Yes','No') ShowTestCode,  IF(MandatoryClient=1,'Yes','No') MandatoryClient,  IF(MandatoryRole=1,'Yes','No') MandatoryRole,");
        sb.Append(" IF(MandatoryCentre=1,'Yes','No') MandatoryCentre,  IF(MandatoryBarcodeNo=1,'Yes','No') MandatoryBarcodeNo, ");
        sb.Append(" IF(MandatoryLabNo=1,'Yes','No') MandatoryLabNo,  IF(MandatoryTestCode=1,'Yes','No') MandatoryTestCode,");
        sb.Append(" IF(IsActive=1,'Active','DeActive') IsActive FROM ticketing_category_master order by CategoryName ");
        return sb;
    }

    [WebMethod]
    public static string GetCategoryList(int Id)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            if (Id > 0)
            {
                sb.Append(" SELECT Roles ShowRole1, ID,  CategoryName,  ShowClient,  ShowRole,  ShowCentre,  ShowBarcodeNo, ShowLabNo,  ShowTestCode,  MandatoryClient, ");
                sb.Append(" MandatoryRole,  MandatoryCentre,  MandatoryBarcodeNo,  MandatoryLabNo,  MandatoryTestCode,  IsActive FROM ticketing_category_master ");
                sb.Append(" where ID=@ID order by ID Desc");
            }
            else
            {
                sb = getCategoryDetail();
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@ID", Id)).Tables[0])
            {
                return JsonConvert.SerializeObject(new { status = true, response = string.Empty, responseDetail = Util.getJson(dt) });
            }
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

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string UpdateDetails(int ID, string CategoryName, int ShowClient, int ShowRole, int ShowCentre, int ShowBarcodeNo, int ShowLabNo, int ShowTestCode, int MandatoryClient, int MandatoryRole, int MandatoryCentre, int MandatoryBarcodeNo, int MandatoryLabNo, int MandatoryTestCode, int IsActive, string Roles)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" UPDATE  ticketing_category_master SET CategoryName=@CategoryName,ShowClient=@ShowClient,ShowRole=@ShowRole,ShowCentre=@ShowCentre,ShowBarcodeNo=@ShowBarcodeNo,");
            sb.Append(" ShowLabNo=@ShowLabNo,ShowTestCode=@ShowTestCode,MandatoryClient=@MandatoryClient,MandatoryRole=@MandatoryRole,MandatoryCentre=@MandatoryCentre,");
            sb.Append(" MandatoryBarcodeNo=@MandatoryBarcodeNo,MandatoryLabNo=@MandatoryLabNo,MandatoryTestCode=@MandatoryTestCode,IsActive=@IsActive,UpdatedBy=@UpdatedBy,");
            sb.Append(" UpdatedID=@UpdatedID,UpdatedDate=@UpdatedDate,Roles=@Roles WHERE ID=@ID");

            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CategoryName", CategoryName),
                new MySqlParameter("@ShowClient", ShowClient),
                new MySqlParameter("@ShowRole", ShowRole),
                new MySqlParameter("@ShowCentre", ShowCentre),
                new MySqlParameter("@ShowBarcodeNo", ShowBarcodeNo),
                new MySqlParameter("@ShowLabNo", ShowLabNo),
                new MySqlParameter("@ShowTestCode", ShowTestCode),
                new MySqlParameter("@MandatoryClient", MandatoryClient),
                new MySqlParameter("@MandatoryRole", MandatoryRole),
                new MySqlParameter("@MandatoryCentre", MandatoryCentre),
                new MySqlParameter("@MandatoryBarcodeNo", MandatoryBarcodeNo),
                new MySqlParameter("@MandatoryLabNo", MandatoryLabNo),
                new MySqlParameter("@MandatoryTestCode", MandatoryTestCode),
                new MySqlParameter("@IsActive", IsActive),
                new MySqlParameter("@UpdatedBy", UserInfo.LoginName),
                new MySqlParameter("@UpdatedID", UserInfo.ID),
                new MySqlParameter("@Roles", Roles.TrimEnd(',')),
                new MySqlParameter("@ID", ID));

            return JsonConvert.SerializeObject(new
            {
                status = true,
                response = "Record Updated Successfully",
                responseDetail = Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, getCategoryDetail().ToString()).Tables[0])
            });
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string InsertCategoryDetails(string CategoryName, int ShowClient, int ShowRole, int ShowCentre, int ShowBarcodeNo, int ShowLabNo, int ShowTestCode, int MandatoryClient, int MandatoryRole, int MandatoryCentre, int MandatoryBarcodeNo, int MandatoryLabNo, int MandatoryTestCode, int IsActive, string Roles)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" INSERT INTO ticketing_category_master(CategoryName,ShowClient,ShowRole,ShowCentre,ShowBarcodeNo,ShowLabNo,ShowTestCode,MandatoryClient,MandatoryRole,");
            sb.Append(" MandatoryCentre,MandatoryBarcodeNo,MandatoryLabNo,MandatoryTestCode,IsActive,CreatedBy,CreatedID,Roles) ");
            sb.Append(" VALUES (@CategoryName,@ShowClient,@ShowRole,@ShowCentre,@ShowBarcodeNo,@ShowLabNo,@ShowTestCode,@MandatoryClient,@MandatoryRole,");
            sb.Append(" @MandatoryCentre,@MandatoryBarcodeNo,@MandatoryLabNo,@MandatoryTestCode,@IsActive,@CreatedBy,@CreatedID,@Roles)");
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, sb.ToString(),
                new MySqlParameter("@CategoryName", CategoryName),
                new MySqlParameter("@ShowClient", ShowClient),
                new MySqlParameter("@ShowRole", ShowRole),
                new MySqlParameter("@ShowCentre", ShowCentre),
                new MySqlParameter("@ShowBarcodeNo", ShowBarcodeNo),
                new MySqlParameter("@ShowLabNo", ShowLabNo),
                new MySqlParameter("@ShowTestCode", ShowTestCode),
                new MySqlParameter("@MandatoryClient", MandatoryClient),
                new MySqlParameter("@MandatoryRole", MandatoryRole),
                new MySqlParameter("@MandatoryCentre", MandatoryCentre),
                new MySqlParameter("@MandatoryBarcodeNo", MandatoryBarcodeNo),
                new MySqlParameter("@MandatoryLabNo", MandatoryLabNo),
                new MySqlParameter("@MandatoryTestCode", MandatoryTestCode),
                new MySqlParameter("@IsActive", IsActive),
                new MySqlParameter("@CreatedBy", UserInfo.LoginName),
                new MySqlParameter("@CreatedID", UserInfo.ID),
                new MySqlParameter("@Roles", Roles.TrimEnd(',')));
            return JsonConvert.SerializeObject(new
            {
                status = true,
                response = "Record Saved Successfully",
                responseDetail = Util.getJson(MySqlHelper.ExecuteDataset(con, CommandType.Text, getCategoryDetail().ToString()).Tables[0])
            });
        }
        catch (Exception Ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(Ex);
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string encryptData(string CategoryName, string ID)
    {
        return JsonConvert.SerializeObject(new
        {
            status = true,
            CategoryName = Common.EncryptRijndael(CategoryName),
            ID = Common.EncryptRijndael(ID)
        });
    }
}