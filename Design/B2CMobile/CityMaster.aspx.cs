using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MySql.Data.MySqlClient;

public partial class Design_B2CMobile_CityMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            TxtCName.Text = "";
            bindArea();
            BtnSaveCentre.Text = "Save";
        }
    }
    private bool CheckDuplicate()
    {
        int count = Util.GetInt(StockReports.ExecuteScalar("SELECT COUNT(*) FROM app_b2c_city WHERE City='" + TxtCName.Text.Trim() + "'"));
        if (count > 0)
        {
            return true;
        }
        else
        {
            return false;
        }
    }
    protected void BtnSaveCentre_Click(object sender, EventArgs e)
    {
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tranX = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {

            if (TxtCName.Text == "")
            {

                ClientScript.RegisterStartupScript(GetType(), "id", " toast('Error', 'City Name can't be empty ', '');", true);
                return;
            }
            int check = CheckBox1.Checked ? 1 : 0;
            if (BtnSaveCentre.Text == "Update")
            {

                string str = "update app_b2c_city set IsActive=@IsActive,City=@City,IsDefault=@IsDefault   where ID=@ID";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str.ToString(),
                                           new MySqlParameter("@IsActive", ddlActive.SelectedValue), new MySqlParameter("@City", TxtCName.Text), new MySqlParameter("@IsDefault", check), new MySqlParameter("@ID", txtID.Text));

                string str1 = "update app_b2c_city set IsDefault='0'   where ID<>@ID";
                MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str1.ToString(),
                                          new MySqlParameter("@ID", txtID.Text));
                ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', Updated Successfully, '');", true);
                bindArea();
                BtnSaveCentre.Text = "Save";
                TxtCName.Text = "";
            }
            else
            {
                if (CheckDuplicate())
                {
                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Error', 'City already Exist....', '');", true);
                    return;
                }
                else
                {
                    if (check == 1)
                    {
                        string str1 = "update app_b2c_city set IsDefault='0' ";
                        MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, str1.ToString());
                    }
                    string instCentre = "insert into app_b2c_city (City,IsActive,EntryById,EntryBy,EntryDate,IsDefault) values(@City,@IsActive,@EntryById,@EntryBy,NOW(),@IsDefault)";
                    MySqlHelper.ExecuteNonQuery(tranX, CommandType.Text, instCentre.ToString(),
                                             new MySqlParameter("@IsActive", ddlActive.SelectedValue), new MySqlParameter("@City", TxtCName.Text), new MySqlParameter("@IsDefault", check), new MySqlParameter("@EntryById", UserInfo.ID), new MySqlParameter("@EntryBy", UserInfo.LoginName));

                    ClientScript.RegisterStartupScript(GetType(), "id", " toast('Success', 'Record Inserted Successfully', '');", true);
                    TxtCName.Text = "";

                    bindArea();
                }
            }
            tranX.Commit();
            bindArea();
        }

        catch (Exception ex)
        {
            tranX.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    private void bindArea()
    {
        string mystr = "SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,City Name,IF(IsDefault=0 OR IsDefault IS NULL,'No','Yes')IsDefault FROM app_b2c_city";
        DataTable dt = new DataTable();
        dt = StockReports.GetDataTable(mystr);
        GrdCentres.DataSource = dt;
        GrdCentres.DataBind();
    }
    protected void GrdCentres_SelectedIndexChanged(object sender, EventArgs e)
    {

        BtnSaveCentre.Text = "Update";
        string ID = ((Label)GrdCentres.SelectedRow.FindControl("local_ID")).Text;
        txtID.Text = ID;
        //DataTable dt = StockReports.GetDataTable("select * from centre_master where centreid=" + CentreId);


        DataTable dt = StockReports.GetDataTable("SELECT ID,IF(IsActive=0 OR IsActive IS NULL,'No','Yes')Active,City name,IsDefault FROM app_b2c_city where ID=" + ID);
        if (dt.Rows.Count > 0)
        {
            TxtCName.Text = dt.Rows[0]["name"].ToString();
            if (dt.Rows[0]["Active"].ToString() == "No")
            {
                ddlActive.SelectedIndex = 0;
            }
            else
            {
                ddlActive.SelectedIndex = 1;
            }
            if (dt.Rows[0]["IsDefault"].ToString() == "1")
            {
                CheckBox1.Checked = true;
            }
            else CheckBox1.Checked = false;

        }

    }
}
