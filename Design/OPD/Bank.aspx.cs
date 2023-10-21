using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_OPD_Bank : System.Web.UI.Page
{
    private string Bank_ID;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
        }
        Label1.Text = string.Empty;
    }

    private void LoadBank(string Bank)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();

        string strQuery = "Select BankName,Bank_ID from f_bank_master Where BankName like '%" + Bank + "%' order by BankName";
        DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, strQuery).Tables[0];

        con.Close();
        con.Dispose();

        GridView1.DataSource = dt;
        GridView1.DataBind();
    }

    protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
    {
        TextBox1.Text = GridView1.SelectedRow.Cells[0].Text;
        Bank_ID = ((Label)GridView1.SelectedRow.FindControl("lblBank")).Text;
        rdbEdit.Checked = true;

        if (ViewState["Bank_ID"] == null)
        {
            ViewState.Add("Bank_ID", Bank_ID);
        }
        else
        {
            ViewState["Bank_ID"] = Bank_ID;
        }
        Button1.Text = "EDIT";
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        if (TextBox2.Text.Trim() == string.Empty)
        {
            Label1.Text = "Please Provide atleast one character to Search...";
            return;
        }

        if (rdbEdit.Checked == true && TextBox2.Text.Trim() != string.Empty)
        {
            LoadBank(TextBox2.Text.Trim());
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (TextBox1.Text.Trim() == string.Empty)
        {
            Label1.Text = "Please Provide Bank Name...";
            return;
        }

        if (rdbEdit.Checked == true && Button1.Text.ToUpper() == "EDIT")
        {
            Bank_ID = ViewState["Bank_ID"].ToString();

            MySqlConnection con = new MySqlConnection();
            con = Util.GetMySqlCon();
            con.Open();
            try
            {
                string str = "Update f_bank_master Set BankName = '" + TextBox1.Text.Trim() + "' Where Bank_ID = " + Bank_ID;
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                con.Close();
                con.Dispose();

                Label1.Text = "Updated Successfully..";
                TextBox1.Text = string.Empty;
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
                int count = Util.GetInt(StockReports.ExecuteScalar("select count(*) from f_bank_master where BankName ='" + TextBox1.Text.Trim() + "'"));
                if (count > 0)
                {
                    Label1.Text = "Bank Already Exist";
                }
                else
                {
                    string str = "Insert into f_bank_master(BankName) values ('" + TextBox1.Text.Trim() + "')";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str);
                    con.Close();
                    con.Dispose();

                    Label1.Text = "Saved Successfully..";
                    TextBox1.Text = string.Empty;
                    TextBox2.Text = string.Empty;
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
        LoadBank(TextBox2.Text.Trim());
    }

    protected void rdbNew_CheckedChanged(object sender, EventArgs e)
    {
        TextBox1.Text = string.Empty;
        TextBox1.Focus();
        TextBox2.Text = string.Empty;
        Button1.Text = "SAVE";
    }

    protected void rdbEdit_CheckedChanged(object sender, EventArgs e)
    {
        TextBox1.Text = string.Empty;
        TextBox2.Text = string.Empty;
        TextBox2.Focus();
        Button1.Text = "EDIT";
    }
}