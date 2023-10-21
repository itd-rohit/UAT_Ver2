using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_Store_AddCategoryType : System.Web.UI.Page
{


    [WebMethod(EnableSession = true)]
    public static string bindolditemname(string itemname)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT CategoryTypeID itemidgroup,CategoryTypeName itemnamegroup FROM `st_categorytypemaster`  ");
        sb.Append(" where CategoryTypeName like '%" + itemname + "%' and Active=1");
        sb.Append(" ORDER BY CategoryTypeName limit 20");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            binddepartment();
        }
    }

    private void binddepartment()
    {
        string str = "SELECT `CategoryTypeID`,`CategoryTypeName` ,if(active='1','Active','Deactive')Status,CategoryTypeCode,Description FROM st_categorytypemaster ORDER BY CategoryTypeName ";
        DataTable dt = StockReports.GetDataTable(str);
        mygrd.DataSource = dt;
        mygrd.DataBind();
       
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savegroup(string name, string active, string Code, string Description)
    {
        int Duplicatecheck = Util.GetInt(StockReports.ExecuteScalar(" Select count(CategoryTypeName) from st_categorytypemaster where upper(CategoryTypeName)='" + name.ToUpper() + "' "));
        if (Duplicatecheck > 0)
            return "0";
        
        StockReports.ExecuteDML("INSERT INTO st_categorytypemaster (CategoryTypeName,Active,CategoryTypeCode,Description) VALUES ('" + name + "','" + active + "','" + Code + "','" + Description + "')");
        int myid = Util.GetInt(StockReports.ExecuteScalar("select max(CategoryTypeID) from st_categorytypemaster"));
        return Util.getJson(new { success= 1, ID = myid, Name = name });
    }


    protected void mygrd_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)mygrd.SelectedRow.FindControl("Label1")).Text;
        string Name = ((Label)mygrd.SelectedRow.FindControl("Label2")).Text;
        string Status = ((Label)mygrd.SelectedRow.FindControl("Label3")).Text;
        string Code = ((Label)mygrd.SelectedRow.FindControl("Label4")).Text;
        string Description = ((Label)mygrd.SelectedRow.FindControl("Label5")).Text;


        txtname.Text = Name;
        txtId.Text = ID;
        txtCode.Text = Code;
        txtDescription.Text = Description;
        if (Status == "Active")
        {
            ChkActivate.Checked = true;
        }
        else
        {
            ChkActivate.Checked = false;
        }
        btnUpdate.Visible = true;
        Button1.Visible = false;
    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {
      
        if (txtname.Text == "")
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "key", "toast('Error','Please Enter Name');", true);
            return;
        }
        bool dt;
        string Active = "0";
        if (ChkActivate.Checked == true)
        {
            Active = "1";
        }
        StringBuilder sb = new StringBuilder();


        sb.Append("update st_categorytypemaster set CategoryTypeName='" + txtname.Text+ "',Active='" + Active + "',CategoryTypeCode='" + txtCode.Text + "',Description='" + txtDescription.Text + "' where CategoryTypeID='" + txtId.Text + "'");
        dt = StockReports.ExecuteDML(sb.ToString());
        if (dt == true)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "key", "toast('Success','Record Updated');", true);
            binddepartment();
            txtname.Text = "";
            btnUpdate.Visible =false ;
            Button1.Visible = true;
            txtDescription.Text = "";
            txtCode.Text = "";
        }
    }
  
}