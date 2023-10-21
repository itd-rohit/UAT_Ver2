using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

public partial class Design_OPD_SubGroup : System.Web.UI.Page
{
    private string Sub_Group_ID;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            binddept();
        }
        Label1.Text = string.Empty;
    }
    private void binddept()
    {
        ddldept.DataSource = AllLoad_Data.loadObservationType();
        ddldept.DataTextField = "Name";
        ddldept.DataValueField = "ObservationType_ID";
        ddldept.DataBind();
        ddldept.Items.Insert(0, new ListItem("", ""));
    }
    private void Subgroup(string Subgroup)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        string strQuery = "Select SubgroupName,ID,(select Name from f_subcategorymaster where SubCategoryID=sg.SubCategoryID)DepartmentName,sg.SubCategoryID from f_itemsubgroup sg ";
        if (Subgroup != string.Empty)
            strQuery += " Where SubgroupName like '%" + Subgroup + "%' ";
        strQuery += " order by SubgroupName";
        DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, strQuery).Tables[0];

        con.Close();
        con.Dispose();

        GridView1.DataSource = dt;
        GridView1.DataBind();
    }

    protected void rdbEdit_CheckedChanged(object sender, EventArgs e)
    {
        TextBox1.Text = string.Empty;
        TextBox2.Text = string.Empty;
        TextBox2.Focus();
        Button1.Text = "EDIT";
    }
    protected void rdbNew_CheckedChanged(object sender, EventArgs e)
    {
        TextBox1.Text = string.Empty;
        TextBox1.Focus();
        TextBox2.Text = string.Empty;
        Button1.Text = "SAVE";
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (TextBox1.Text.Trim() == string.Empty)
        {
            Label1.Text = "Please Provide SubGroup Name...";
            return;
        }
        if (ddldept.SelectedItem.Text == string.Empty)
        {
            Label1.Text = "Please select Department Name...";
            return;
        }

        if (rdbEdit.Checked == true && Button1.Text.ToUpper() == "EDIT")
        {
            Sub_Group_ID = ViewState["SubGroup_ID"].ToString();

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            try
            {
                string str = "Update f_itemsubgroup Set SubgroupName = '" + TextBox1.Text.Trim() + "',SubCategoryID='" + ddldept.SelectedValue + "',DepartmentName='"+ddldept.SelectedItem.Text+"' Where ID = " + Sub_Group_ID;
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                con.Close();
                con.Dispose();

                Label1.Text = "Updated Successfully..";
                TextBox1.Text = string.Empty;
                ddldept.SelectedIndex = 0;
                Button1.Text = "SAVE";
            }
            catch (Exception ex)
            {
                con.Close();
                con.Dispose();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
        else if (rdbNew.Checked == true && Button1.Text.ToUpper() == "SAVE")
        {
            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            try
            {
                int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_itemsubgroup where SubgroupName ='" + TextBox1.Text.Trim() + "'"));
                if (count > 0)
                {
                    Label1.Text = "SubGroup Already Exist";
                }
                else
                {
                    string str = "Insert into f_itemsubgroup(SubgroupName,SubCategoryID,DepartmentName) values ('" + TextBox1.Text.Trim() + "','" + ddldept.SelectedValue + "','"+ddldept.SelectedItem.Text+"')";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                    con.Close();
                    con.Dispose();

                    Label1.Text = "Saved Successfully..";
                    TextBox1.Text = string.Empty;
                    TextBox2.Text = string.Empty;
                    ddldept.SelectedIndex = 0;
                    Button1.Text = "SAVE";
                }
            }
            catch (Exception ex)
            {
                con.Close();
                con.Dispose();
                ClassLog cl = new ClassLog();
                cl.errLog(ex);
            }
        }
        Subgroup(TextBox2.Text.Trim());
    }
    protected void Button2_Click(object sender, EventArgs e)
    {
        //if (TextBox2.Text.Trim() == string.Empty)
        //{
        //    Label1.Text = "Please Provide atleast one character to Search...";
        //    return;
        //}

        if (rdbEdit.Checked == true)
        {
            Subgroup(TextBox2.Text.Trim());
        }
    }
    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        TextBox1.Text = GridView1.SelectedRow.Cells[0].Text;
        ddldept.SelectedValue = ((Label)GridView1.SelectedRow.FindControl("lbldeptid")).Text;
        Sub_Group_ID = ((Label)GridView1.SelectedRow.FindControl("lblBank")).Text;
        rdbEdit.Checked = true;

        if (ViewState["SubGroup_ID"] == null)
        {
            ViewState.Add("SubGroup_ID", Sub_Group_ID);
        }
        else
        {
            ViewState["SubGroup_ID"] = Sub_Group_ID;
        }
        Button1.Text = "EDIT";
    }
}