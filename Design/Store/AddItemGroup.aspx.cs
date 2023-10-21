using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;
using System.Web.UI;

public partial class Design_Store_AddItemGroup : System.Web.UI.Page
{



    [WebMethod(EnableSession = true)]
    public static string bindolditemname(string itemname)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT SubCategoryID itemidgroup,CONCAT(im.Name,' # ',st.SubCategoryTypeName,' # ',ct.CategoryTypeName) itemnamegroup FROM `st_subcategorymaster` im  ");
        sb.Append(" inner join st_Subcategorytypemaster st on st.SubCategoryTypeID=im.SubCategoryTypeID and st.Active=1");
        sb.Append("   INNER JOIN st_categorytypemaster ct ON ct.CategoryTypeID=st.CategoryTypeID AND ct.active=1 ");
        sb.Append(" where Name like '%" + itemname + "%' and im.Active=1 ");
        sb.Append(" ORDER BY Name limit 20");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            binddepartment();
            bindSubcattype();
        }
    }

    private void binddepartment()
    {
        string str = "SELECT st_categorytypemaster.CategoryTypeName,st_categorytypemaster.CategoryTypeCode, st_subcategorytypemaster.Code ItemCategoryCode,st_subcategorytypemaster.SubCategoryTypeName ItemCategoryName, st_subcategorymaster.Code SubCategoryCode,NAME SubCategoryName," +
        " st_subcategorymaster.Description, st_subcategorytypemaster.subcategorytypeid Id, st_subcategorymaster.SubCategoryID ID,IF(st_subcategorymaster.active='1','Active','Deactive') STATUS FROM st_subcategorymaster" +
        " INNER JOIN st_subcategorytypemaster ON st_subcategorytypemaster.`SubCategoryTypeID`=st_subcategorymaster.`SubCategoryTypeID` INNER JOIN st_categorytypemaster ON st_categorytypemaster.`CategoryTypeID`=st_subcategorytypemaster.CategoryTypeID ORDER BY NAME ";
        DataTable dt = StockReports.GetDataTable(str);
        mygrd.DataSource = dt;
        mygrd.DataBind();
       
    }

    void bindSubcattype()
    {
        ddlsubcattype.DataSource = StockReports.GetDataTable("SELECT `SubCategoryTypeID`,`SubCategoryTypeName` FROM st_Subcategorytypemaster where active=1 ORDER BY SubCategoryTypeName ");
        ddlsubcattype.DataTextField = "SubCategoryTypeName";
        ddlsubcattype.DataValueField = "SubCategoryTypeID";
        ddlsubcattype.DataBind();
        //ddlsubcattype.Items.Insert(0, new ListItem("Select", "0"));
    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string savegroup(string name, string active, string SubCategoryId,string Code,string Description)
    {
        int Duplicatecheck = Util.GetInt(StockReports.ExecuteScalar(" Select count(NAME) from st_subcategorymaster where upper(Name)='" + name.ToUpper() + "' and SubCategoryTypeID='" + SubCategoryId + "' "));
        if (Duplicatecheck > 0)
            return "0";

        StockReports.ExecuteDML("INSERT INTO st_subcategorymaster (`SubCategoryTypeID`,NAME,Active,Code,Description) VALUES ('" + SubCategoryId + "','" + name + "','" + active + "','" + Code + "','" + Description + "')");
        int myid = Util.GetInt(StockReports.ExecuteScalar("select max(SubCategoryID) from st_subcategorymaster "));
        return Util.getJson(new { success = 1, ID = myid, Name = name});
    }


    protected void mygrd_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)mygrd.SelectedRow.FindControl("Label1")).Text;
        string Name = ((Label)mygrd.SelectedRow.FindControl("Label2")).Text;
        string Status = ((Label)mygrd.SelectedRow.FindControl("Label3")).Text;
        string subCategory = ((Label)mygrd.SelectedRow.FindControl("lbl2category1")).Text;
        string Code = ((Label)mygrd.SelectedRow.FindControl("lblsubCategoryCode")).Text;
        string Description = ((Label)mygrd.SelectedRow.FindControl("lblDescription")).Text;

        ddlsubcattype.SelectedValue = subCategory;

        txtname.Text = Name;
        txtId.Text = ID;
        txtSubCategoryCode.Text = Code;
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
      //  int Duplicatecheck = Util.GetInt(StockReports.ExecuteScalar(" Select count(NAME) from st_subcategorymaster where Name='" + txtname.Text.Trim() + "' "));
     //   if (Duplicatecheck > 0)
     //   {
      //      lblMsg.Text = "Category Name is Already Exist ...!";
       //     return;
       // }
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


        sb.Append("update st_subcategorymaster set NAME='" + txtname.Text.ToUpper() + "',Active='" + Active + "',SubCategoryTypeID='" + ddlsubcattype.SelectedValue + "',Code='" + txtSubCategoryCode.Text+ "',Description='" + txtDescription.Text + "' where SubCategoryID='" + txtId.Text + "'");
        dt = StockReports.ExecuteDML(sb.ToString());
        if (dt == true)
        {
            ScriptManager.RegisterClientScriptBlock(this, GetType(), "key", "toast('Success','Record Updated');", true);
            binddepartment();
            txtname.Text = "";
            btnUpdate.Visible =false ;
            Button1.Visible = true;
            txtDescription.Text = "";
            txtSubCategoryCode.Text = "";
        }
    }
  
}