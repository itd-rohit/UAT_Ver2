using System;
using System.Data;
using System.Text;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web.UI.WebControls;

public partial class Design_Store_AddUnit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindunit();
        }
    }


    [WebMethod(EnableSession = true)]
    public static string bindolditemname(string itemname)
    {
        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ID itemidgroup,Unitname itemnamegroup FROM `st_unit_master`  ");
        sb.Append(" where Unitname like '%" + itemname + "%'");
        sb.Append(" ORDER BY Unitname limit 20");
        return Newtonsoft.Json.JsonConvert.SerializeObject(StockReports.GetDataTable(sb.ToString()));
    }


    private void bindunit()
    {
       
        DataTable dt = StockReports.GetDataTable("SELECT ID ID,Unitname NAME,IF(AllowDecimalValue=1,'Yes','No')AllowDecimalValue FROM st_unit_master ORDER BY unitNAME  ");
        mygrd.DataSource = dt;
        mygrd.DataBind();

    }

    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string saveunit(string name, string AllowDecimalValue)
    {


        StockReports.ExecuteDML("INSERT INTO st_unit_master (unitName,AllowDecimalValue) VALUES ('" + name.ToUpper() + "','" + AllowDecimalValue + "')");
        int myid = Util.GetInt(StockReports.ExecuteScalar("select max(id) from st_unit_master "));
        return Util.getJson(new { UnitID =string.Concat( myid,'#',AllowDecimalValue), UnitName = name.ToUpper() });
    }
    protected void mygrd_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)mygrd.SelectedRow.FindControl("Label1")).Text;
        string Name = ((Label)mygrd.SelectedRow.FindControl("Label2")).Text;
        string AllowDecimalValue = ((Label)mygrd.SelectedRow.FindControl("lblAllowDecimalValue")).Text;
        if (AllowDecimalValue.ToUpper() == "YES")
            chkAllowDecimalValue.Checked = true;
        else
            chkAllowDecimalValue.Checked = false;
        txtname.Text = Name;
        txtId.Text = ID;
        btnUpdate.Visible = true;
        btnsave.Visible = false;

    }
    protected void btnUpdate_Click(object sender, EventArgs e)
    {

        if (txtname.Text == string.Empty)
        {
            lblMsg.Text = "Please Enter Name";
            return;
        }
       
        int AllowDecimalValue = chkAllowDecimalValue.Checked ? 1 : 0;

        bool dt = StockReports.ExecuteDML("update st_unit_master set Unitname='" + txtname.Text.ToUpper() + "',AllowDecimalValue='" + AllowDecimalValue + "' where ID='" + txtId.Text + "'");
        if (dt == true)
        {
            lblMsg.Text = "Record Updated..!";
            bindunit();
            txtname.Text = string.Empty;
            chkAllowDecimalValue.Checked = false;
            btnUpdate.Visible = false;
            btnsave.Visible = true;
        }
        else
        {
            lblMsg.Text = "Error";
        }
    }
}