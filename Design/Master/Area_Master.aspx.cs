using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Web.UI.WebControls;

public partial class Design_Master_Area_Master : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblMsg.Text = string.Empty;
            TxtCName.Text = string.Empty;
            bindallData();
            BtnSaveCentre.Text = "Save";
        }
    }
    protected void BtnSaveCentre_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction Tranx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            if (TxtCName.Text.Trim() == string.Empty)
            {
                lblMsg.Text = "Area Name can't be empty";
                return;
            }
            if (BtnSaveCentre.Text == "Update")
            {
                string str = "update f_Locality set Active=@IsActive,name=@Name,UpdatedBy=@LoginName,UpdatedByID=@ID,UpdatedOn=NOW(),CountryID=@CountryId,Country=@CountryName  where ID=@LId";
                MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, str.ToString(),
                      new MySqlParameter("@IsActive", Util.GetInt(ddlActive.SelectedValue)),
                           new MySqlParameter("@Name", Util.GetString(TxtCName.Text)),
                           new MySqlParameter("@LoginName", Util.GetString(Session["LoginName"])),
                         new MySqlParameter("@ID", Util.GetString(Session["ID"])),
                          new MySqlParameter("@CountryId", Util.GetInt(ddlCountry.SelectedValue)),
                         new MySqlParameter("@CountryName", Util.GetString(ddlCountry.SelectedItem.Text)),
                          new MySqlParameter("@LId", Util.GetString(txtID.Text))
                                 );
                lblMsg.Text = "Updated";
                bindallData();
                BtnSaveCentre.Text = "Save";
                TxtCName.Text = string.Empty;
            }
            else
            {
                int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT COUNT(*) FROM f_Locality WHERE NAME=@Name",
                new MySqlParameter("@Name", TxtCName.Text.Trim())));
                if (count > 0)
                {
                    lblMsg.Text = "Area already Exist....";
                    return;
                }
                else
                {
                    string instCentre = "insert into f_Locality (name,active,CreatedByID,CreatedBy,CreatedOn,CountryID,Country) values(@Name,@IsActive,@ID,@LoginName,NOW(),@CountryId,@CountryName)";
                    MySqlHelper.ExecuteNonQuery(Tranx, CommandType.Text, instCentre.ToString(),
                         new MySqlParameter("@IsActive", Util.GetInt(ddlActive.SelectedValue)),
                    new MySqlParameter("@Name", Util.GetString(TxtCName.Text)),
                           new MySqlParameter("@LoginName", Util.GetString(Session["LoginName"])),
                         new MySqlParameter("@ID", Util.GetString(Session["ID"])),
                          new MySqlParameter("@CountryId", Util.GetInt(ddlCountry.SelectedValue)),
                         new MySqlParameter("@CountryName", Util.GetString(ddlCountry.SelectedItem.Text)));
                    TxtCName.Text = "";
                    bindallData();
                }
            }

            Tranx.Commit();
            Tranx.Dispose();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            Tranx.Rollback();
            Tranx.Dispose();
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
    private void bindallData()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT l.ID,IF(l.Active=0 OR l.Active IS NULL,'No','Yes')Active,l.NAME,c.NAME as CountryName FROM f_Locality l Left JOIN country_master c ON c.CountryID=l.CountryID order by l.Id desc ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    GrdCentres.DataSource = dt;
                    GrdCentres.DataBind();

                }
            }
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT CountryID,NAME ,IsBaseCurrency FROM country_master WHERE IsActive=1 ORDER BY NAME ").Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    ddlCountry.DataSource = dt;
                    ddlCountry.DataTextField = "NAME";
                    ddlCountry.DataValueField = "CountryID";
                    ddlCountry.DataBind();

                }
                ddlCountry.Items.Insert(0, new ListItem("Select", "0"));
                DataRow[] foundRows = dt.Select("IsBaseCurrency=1");
                ddlCountry.Items.FindByValue(foundRows[0][0].ToString()).Selected = true;
            }
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
    protected void GrdCentres_SelectedIndexChanged(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            BtnSaveCentre.Text = "Update";
            string ID = ((Label)GrdCentres.SelectedRow.FindControl("local_ID")).Text;
            txtID.Text = ID;
            ///DataTable dt = StockReports.GetDataTable("=" + ID);
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT ID,IF(Active=0 OR Active IS NULL,'No','Yes')Active,name,CountryID FROM F_Locality where ID=@ID", new MySqlParameter("@ID", ID)).Tables[0])


                if (dt.Rows.Count > 0)
                {
                    ddlCountry.ClearSelection();
                    TxtCName.Text = dt.Rows[0]["name"].ToString();
                    ddlCountry.Items.FindByValue(dt.Rows[0]["CountryID"].ToString()).Selected = true;
                    if (dt.Rows[0]["Active"].ToString() == "No")
                    {
                        ddlActive.SelectedIndex = 0;
                    }
                    else
                    {
                        ddlActive.SelectedIndex = 1;
                    }
                }
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
    protected void GrdCentres_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GrdCentres.PageIndex = e.NewPageIndex;
        bindallData();
    }
}