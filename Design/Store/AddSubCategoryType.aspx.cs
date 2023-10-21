using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_Store_AddSubCategoryType : System.Web.UI.Page
{



    [WebMethod(EnableSession = true)]
    public static string bindolditemname(string itemname)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT SubCategoryTypeID itemidgroup,concat(SubCategoryTypeName,' # ',st_categorytypemaster.CategoryTypeName) itemnamegroup FROM `st_Subcategorytypemaster`  ");
        sb.Append(" inner join st_categorytypemaster on st_categorytypemaster.CategoryTypeID=st_Subcategorytypemaster.CategoryTypeID and st_categorytypemaster.Active=1");
        sb.Append(" where SubCategoryTypeName like '%" + itemname + "%' and st_Subcategorytypemaster.Active=1 ");
        sb.Append(" ORDER BY SubCategoryTypeName limit 20");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            binddepartment();
            bindcattype();
        }
    }

    private void binddepartment()
    {
        string str = "SELECT st_Subcategorytypemaster.Description,st_categorytypemaster.CategoryTypeCode,Code, st_categorytypemaster.CategoryTypeID,st_categorytypemaster.CategoryTypeName, `SubCategoryTypeID`,`SubCategoryTypeName` ,if(st_Subcategorytypemaster.active='1','Active','Deactive') Status FROM st_Subcategorytypemaster" +
        " inner join st_categorytypemaster on st_categorytypemaster.CategoryTypeID=st_Subcategorytypemaster.CategoryTypeID  ORDER BY SubCategoryTypeName ";
        DataTable dt = StockReports.GetDataTable(str);
        mygrd.DataSource = dt;
        mygrd.DataBind();
       
    }

    void bindcattype()
    {
        ddlcattype.DataSource = StockReports.GetDataTable("SELECT `CategoryTypeID`,`CategoryTypeName` FROM st_categorytypemaster where active=1 ORDER BY CategoryTypeName ");
        ddlcattype.DataTextField = "CategoryTypeName";
        ddlcattype.DataValueField = "CategoryTypeID";
        ddlcattype.DataBind();
        //ddlcattype.Items.Insert(0, new ListItem("Select", "0"));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savegroup(string name, string active, string Category,string Code,string Description)
    {
        int Duplicatecheck = Util.GetInt(StockReports.ExecuteScalar(" Select count(SubCategoryTypeName) from st_Subcategorytypemaster where Upper(SubCategoryTypeName)='" + name.ToUpper() + "' and CategoryTypeID='" + Category + "'"));
        if (Duplicatecheck > 0)
            return "0";

        StockReports.ExecuteDML("INSERT INTO st_Subcategorytypemaster (SubCategoryTypeName,Active,CategoryTypeID,Code,Description) VALUES ('" + name + "','" + active + "','" + Category + "','" + Code + "','" + Description + "')");

        int myid = Util.GetInt(StockReports.ExecuteScalar("select max(SubCategoryTypeID) from st_Subcategorytypemaster "));
        return Util.getJson(new { success = 1, ID = myid, Name = name });
    }


    protected void mygrd_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)mygrd.SelectedRow.FindControl("Label1")).Text;
        string Name = ((Label)mygrd.SelectedRow.FindControl("Label2")).Text;
        string Status = ((Label)mygrd.SelectedRow.FindControl("Label3")).Text;
        string txtCategoryType = ((Label)mygrd.SelectedRow.FindControl("lbl2category1")).Text;

        string Code = ((Label)mygrd.SelectedRow.FindControl("Label4")).Text;
        string Description = ((Label)mygrd.SelectedRow.FindControl("Label5")).Text;

        ddlcattype.SelectedValue = txtCategoryType;
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
      
        if (txtname.Text == string.Empty)
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


        sb.Append("update st_Subcategorytypemaster set SubCategoryTypeName='" + txtname.Text + "',Active='" + Active + "',CategoryTypeID='" + ddlcattype.SelectedValue + "',Code='" + txtCode.Text + "',Description='" + txtDescription.Text + "' where SubCategoryTypeID='" + txtId.Text + "'");
        dt = StockReports.ExecuteDML(sb.ToString());
        if (dt == true)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "key", "toast('Success','Record Updated');", true);
           
            binddepartment();
            txtname.Text = "";
            btnUpdate.Visible =false ;
            Button1.Visible = true;
            txtCode.Text = "";
            txtDescription.Text = "";
            txtId.Text = "";
        }
    }
  
}