using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_FrontOffice_AddReferalDoctorPopup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtDocCode.Focus();
            AllLoad_Data.bindDocTypeList(ddlSpecial, 3, "Select");
           
            BindDegree();
            BindPRO();
            AllLoad_Data.bindState(ddlState,"Select");
           // string stateID = StockReports.ExecuteScalar("Select StateID from centre_master where CentreID='"+UserInfo.Centre+"'");
           // ddlState.SelectedIndex = ddlState.Items.IndexOf(ddlState.Items.FindByValue(stateID));
            
            
        }
        
    }

   

    private void BindDegree()
    {
        DataTable dt = StockReports.GetDataTable("SELECT ID, Degree from f_degreemaster WHERE degree<>'' order by degree");
        ddlDegree.DataSource = dt;
        ddlDegree.DataTextField = "Degree";
        ddlDegree.DataValueField = "ID";
        ddlDegree.DataBind();
        ddlDegree.Items.Insert(0, new   ListItem("Select","0"));
    }
    private void BindPRO()
    {
       // DataTable dt = StockReports.GetDataTable("SELECT PROID,PROName FROM pro_master WHERE IsActive=1 order by PROName");
       // ddlPRO.DataSource = dt;
       // ddlPRO.DataTextField = "PROName";
       // ddlPRO.DataValueField = "PROID";
       // ddlPRO.DataBind();
       // ddlPRO.Items.Insert(0, new ListItem("Select", "0"));
	    DataTable dt = StockReports.GetDataTable("SELECT `Employee_ID` PROID, NAME PROName FROM `employee_master`  WHERE `Designation`='pro' AND `isactive`=1");
        ddlPRO.DataSource = dt;
        ddlPRO.DataTextField = "PROName";
        ddlPRO.DataValueField = "PROID";
        ddlPRO.DataBind();
        ddlPRO.Items.Insert(0, new ListItem("Select", "0"));
    }
    private void Clear()
    {
        txtName.Text = string.Empty;
       
        TxtMobileNo.Text = string.Empty;
       
        ddlSpecial.SelectedIndex = 0;
      
    }

    

    [WebMethod]
    public static string savenewdegree(string degree)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con,CommandType.Text,"insert into f_degreemaster(Degree) values(@degree)",new MySqlParameter("@degree",degree));
            return JsonConvert.SerializeObject(new { status = true, response =  MySqlHelper.ExecuteScalar(con,CommandType.Text,"select max(id) from f_degreemaster").ToString() });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally {
            con.Close();
            con.Dispose();
        }

    }

    [WebMethod]
    public static string savenewspecil(string special)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO type_master(typeID,NAME,TYPE,updateDate) VALUES(3,@special,'Doctor-Specialization',NOW())", new MySqlParameter("@special", special));
            return JsonConvert.SerializeObject(new { status = true, response = MySqlHelper.ExecuteScalar(con, CommandType.Text, "select max(id) from type_master where typeID=3").ToString() });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string savecategory(string category)
    {
          MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, "INSERT INTO doctor_category(NAME) VALUES(@category)", new MySqlParameter("@category", category));
            return JsonConvert.SerializeObject(new { status = true, response = MySqlHelper.ExecuteScalar(con, CommandType.Text, "select max(id) from doctor_category").ToString() });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex.GetBaseException());
            return JsonConvert.SerializeObject(new { status = false, response = "Error" });
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    [WebMethod(EnableSession = true)]
    public static int SelectedZone()
    {
        return Util.GetInt(StockReports.ExecuteScalar("SELECT ZoneID FROM centre_master WHERE CentreID='" + UserInfo.Centre + "'"));

    }
}