using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_AddManufacture : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindmanufacture();
        }
    }

    [WebMethod(EnableSession = true)]
    public static string bindolditemname(string itemname)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT MAnufactureID itemidgroup,NAME itemnamegroup FROM `st_manufacture_master`  ");
        sb.Append(" where NAME like '%" + itemname + "%' and IsActive=1");
        sb.Append(" ORDER BY NAME limit 20");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    public void Reset()
    {
        txtname.Text="";
        txtconper.Text="";
        txtaddress1.Text="";
        txtaddress2.Text="";
        txtaddress3.Text="";
        txtphone.Text="";
        txtfax.Text="";
        txtemail.Text="";
        txtmobile.Text="";
        txtcountry.Text="";
        txtcity.Text="";
        txtpincode.Text="";
        txtdlno.Text="";
        txttinno.Text="";      
    }
    private void bindmanufacture()
    {
        string str = "SELECT ManufactureID ID, NAME, `Contact_Person`,Mobile ,if(isactive='1','Active','Deactive') Status,ADDRESS,Address2,Address3,PHONE,FAX,EMAIL,Country,City,PinCode,DLNO,TINNO FROM st_manufacture_master ORDER BY NAME  ";

        // string str = "SELECT ManufactureID ID, NAME, `Contact_Person`,Mobile ,if(isactive='1','Active','Deactive') Status FROM st_manufacture_master ORDER BY NAME  ";
        DataTable dt = StockReports.GetDataTable(str);
        mygrd.DataSource = dt;
        mygrd.DataBind();

    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string checkduplicate(string Name, string ID)
    {
        string query = "select count(*) from st_manufacture_master where NAME='" + Name.Trim() + "' ";
        if (ID != "")
        {
            query += " and MAnufactureID<>'" + ID + "'";
        }
        string count = StockReports.ExecuteScalar(query);
        return count;
    }
    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savedata(string name, string active, string con, string add, string add2, string add3, string ph, string mo, string fax, string country, string city, string pincode, string dlno, string tinno, string email)
    {

        if (HttpContext.Current.Session["RoleID"] == null)
        {
            HttpContext.Current.Response.Redirect("~/Design/Default.aspx");
        }
        // commented by aditya
        //string query = "INSERT INTO st_manufacture_master(NAME,Contact_Person,ADDRESS,Address2,Address3,PHONE,Mobile,FAX,Country, City,PinCode,DLNO, ";
        //   query +="  TINNO,EMAIL,IsActive, UserID, EntryDate) values ('" + name + "','" + con + "','" + add + "','" + add2 + "','" + add3 + "','" + ph + "','" + mo + "','" + fax + "','" + country + "','" + city + "','" + pincode + "','" + dlno + "','" + tinno + "','" + email + "','" + active + "','" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "',now())";
        //StockReports.ExecuteDML(query);
        //return "true";
        // commented by aditya

       
        MySqlConnection cn = Util.GetMySqlCon();
        cn.Open();
        MySqlTransaction tnx = cn.BeginTransaction(IsolationLevel.Serializable);
        int ManuFactureID = 0;

        try
        {
            string query = "INSERT INTO st_manufacture_master(NAME,Contact_Person,ADDRESS,Address2,Address3,PHONE,Mobile,FAX,Country, City,PinCode,DLNO, ";
             query +="  TINNO,EMAIL,IsActive, UserID, EntryDate) values ('" + name.ToUpper() + "','" + con + "','" + add + "','" + add2 + "','" + add3 + "','" + ph + "','" + mo + "','" + fax + "','" + country + "','" + city + "','" + pincode + "','" + dlno + "','" + tinno + "','" + email + "','" + active + "','" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "',now())";
               
                MySqlCommand cmd = new MySqlCommand(query.ToString(), cn, tnx);                
                cmd.ExecuteNonQuery();
                ManuFactureID = Convert.ToInt32(cmd.LastInsertedId);
            
            tnx.Commit();
            return Util.getJson(new { ManuFactureID = ManuFactureID, ManuFactureName = name.ToUpper() });
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            tnx.Rollback();
            return "0";
        }
        finally
        {
            tnx.Dispose();
            cn.Close();
            cn.Dispose();
        }
       
       
    }
    protected void mygrd_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)mygrd.SelectedRow.FindControl("Label1")).Text;
        string Name = ((Label)mygrd.SelectedRow.FindControl("Label2")).Text;
        string Contact_Person=((Label)mygrd.SelectedRow.FindControl("Label3")).Text;
        string mobile = ((Label)mygrd.SelectedRow.FindControl("Label4")).Text;
        string Status = ((Label)mygrd.SelectedRow.FindControl("Label5")).Text;
        string Address=((Label)mygrd.SelectedRow.FindControl("Label6")).Text;
        string Address2=((Label)mygrd.SelectedRow.FindControl("Label7")).Text;
        string Address3 = ((Label)mygrd.SelectedRow.FindControl("Label8")).Text;
        string PHONE=((Label)mygrd.SelectedRow.FindControl("Label9")).Text;
        string FAX=((Label)mygrd.SelectedRow.FindControl("Label10")).Text;
        string EMAIL=((Label)mygrd.SelectedRow.FindControl("Label11")).Text;
        string Country=((Label)mygrd.SelectedRow.FindControl("Label12")).Text;
        string City=((Label)mygrd.SelectedRow.FindControl("Label13")).Text;
        string PinCode=((Label)mygrd.SelectedRow.FindControl("Label14")).Text;
        string DLNO =((Label)mygrd.SelectedRow.FindControl("Label15")).Text;
        string TINNO=((Label)mygrd.SelectedRow.FindControl("Label16")).Text;
        string UserID = Util.GetString(Session["UserID"]);
        txtname.Text = Name;
        txtId.Text = ID;
        txtconper.Text = Contact_Person;
        txtmobile.Text = mobile;
        txtaddress1.Text = Address;
        txtaddress2.Text = Address2;
        txtaddress3.Text = Address3;
        txtphone.Text = PHONE;
        txtfax.Text = FAX;
        txtemail.Text = EMAIL;
        txtcountry.Text = Country;
        txtcity.Text = City;
        txtpincode.Text = PinCode;
        txtdlno.Text = DLNO;
        txttinno.Text = TINNO;
        
        if (Status == "Active")
        {
            ChkActivate.Checked = true;
        }
        else
        {
            ChkActivate.Checked = false;
        }
        btnUpdate.Visible = true;
        btnsave.Visible = false;
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
   if (txtname.Text == "")
        {
            lblMsg.Text = "Please Enter Name";
            return;
        }
        bool dt;
        string Active = "0";
        if (ChkActivate.Checked == true)
        {
            Active = "1";
        }
        StringBuilder sb = new StringBuilder();
        sb.Append("update st_manufacture_master set NAME='" + txtname.Text.ToUpper() + "', `Contact_Person`='" + txtconper.Text + "',Mobile='" + txtmobile.Text + "' ,IsActive='" + Active + "',ADDRESS='" + txtaddress1.Text + "',Address2='" + txtaddress2.Text + "',Address3='" + txtaddress3.Text + "',PHONE='" + txtphone.Text + "',FAX='" + txtfax.Text + "',EMAIL='" + txtemail.Text + "',Country='" + txtcountry.Text + "',City='" + txtcity.Text + "',PinCode='" + txtpincode.Text + "',DLNO='" + txtdlno.Text + "',TINNO='" + txttinno.Text + "',UserID='" + Util.GetString(HttpContext.Current.Session["ID"].ToString()) + "' where ManufactureID='" + txtId.Text + "'");

      //  sb.Append("update ManufactureID set NAME='" + txtname.Text + "',Active='" + Active + "' where SubCategoryID='" + txtId.Text + "'");
        dt = StockReports.ExecuteDML(sb.ToString());
        if (dt == true)
        {
            lblMsg.Text = "Record Updated..!";
            bindmanufacture();
            Reset();
            btnUpdate.Visible =false ;
            btnsave.Visible = true;
        }
    }
}