using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;
using System.Web.UI.WebControls;

public partial class Design_Investigation_labobservation_Help : System.Web.UI.Page
{
    public string InvID = " ";

    protected void Page_Load(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        InvID = Util.GetString(Request.QueryString["InvID"]);
        if (!IsPostBack)
        {
            ViewState["ID"] = Session["ID"].ToString();
            Bind_Investigation();
            BindObservation();
            BindHelp();
        }
    }

    private void Bind_Investigation()
    {
        string str = " select CONCAT(inv.Name,' - ',inv.TestCode) as Name ,inv.Investigation_id from f_itemmaster im   " +
                              " inner join f_subcategorymaster sc on sc.SubCategoryID=im.SubCategoryID  " +
                              " inner join f_configrelation c on c.CategoryID=sc.CategoryID " +
                              " inner join investigation_master inv on inv.Investigation_id=im.Type_id   " +
                              " and c.ConfigRelationID='3' and inv.ReportType=1 and im.IsActive=1 order by inv.Name ";

        DataTable dt = StockReports.GetDataTable(str);
        if (dt != null && dt.Rows.Count > 0)
        {
            ddlInvestigation.DataSource = dt;
            ddlInvestigation.DataTextField = "Name";
            ddlInvestigation.DataValueField = "Investigation_Id";
            ddlInvestigation.DataBind();
            ddlInvestigation.Items.Insert(0, new ListItem("----Select Investigation----", ""));
            if (!string.IsNullOrEmpty(InvID))
            {
                ddlInvestigation.Items.FindByValue(InvID).Selected = true;
                ddlInvestigation.Enabled = false;
            }
        }
    }

    private void BindObservation()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("select LOM.LabObservation_ID,LOM.Name as ObsName from labobservation_investigation LOI");
            sb.Append("  inner join labobservation_master LOM on");
            sb.Append(" LOI.labObservation_ID=LOM.LabObservation_ID and   loi.Investigation_Id=@Inv order by loi.printOrder");

            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@Inv",ddlInvestigation.SelectedValue)).Tables[0];

            ddlobservation.DataSource = dt;
            ddlobservation.DataTextField = "ObsName";
            ddlobservation.DataValueField = "LabObservation_ID";
            ddlobservation.DataBind();
            ddlobservation.Items.Insert(0, "---Select Observation---");
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally {
            con.Close();
            con.Dispose();
        }
    }

    private void BindHelp()
    {
        string str = "SELECT IF(ShortKey='',HELP,ShortKey)ShortKey,CONCAT(id,'#',HELP,'#',IFNULL(isBold,''))HELP FROM labobservation_help_master ORDER BY IF(ShortKey='',HELP,ShortKey)";
        DataTable dt = StockReports.GetDataTable(str);
        ListBox1.DataTextField = "ShortKey";
        ListBox1.DataValueField = "HELP";
        ListBox1.DataSource = dt;
        ListBox1.DataBind();
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            foreach (ListItem li in ListBox1.Items)
            {
                if (li.Selected)
                {
                    //string str = "Select ID from labobservation_help_master where HELP = '" + li.Value.Split('#')[1] + "' and ShortKey = '" + li.Text + "'";
                    string helpid = li.Value.Split('#')[0];
                    //string helpid = StockReports.ExecuteScalar(str);
                    string str = "DELETE FROM LabObservation_Help where LabObservation_ID=@Obs and HelpId = @helpid ";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str, new MySqlParameter("@Obs", ddlobservation.SelectedItem.Value), new MySqlParameter("@helpid", helpid));

                    str = "INSERT INTO LabObservation_Help(LabObservation_ID,HelpId) values(@Obs,@helpid)";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str, new MySqlParameter("@Obs", ddlobservation.SelectedItem.Value), new MySqlParameter("@helpid", helpid));
                    StockReports.ExecuteDML(str);
                }
            }

            bindMapping();
            lblMsg.Text = "Help Mapped..";
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

    protected void btnSave_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int count = Util.GetInt(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select count(*) from labobservation_help_master where HELP=@Help", new MySqlParameter("@Help", txtHelp.Text)));
            if (count > 0)
            {
                lblMsg.Text = "Help Already In The List";
                txtHelp.Text = "";
                return;
            }
            else
            {
                int isbold=0;
                if (chkisbold.Checked) {
                    isbold = 1;
                }
                string str = "INSERT INTO labobservation_help_master(HELP,ShortKey,IsBold) VALUES(@Help,@shortkey,@IsBold)";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str, new MySqlParameter("@Help", txtHelp.Text.Trim()), new MySqlParameter("@shortkey", txtshortkey.Text.Trim()), new MySqlParameter("@IsBold",isbold));
                BindHelp();
                lblMsg.Text = "Sucessfully Inserted";
                txtHelp.Text = "";
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

    protected void ddlobservation_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindMapping();
    }

    private void bindMapping()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            string str = "SELECT @ObsText name,loh.id,lhm.Help,lhm.ShortKey FROM LabObservation_Help loh INNER JOIN labobservation_master lom " +
                         "ON loh.LabObservation_id=lom.LabObservation_ID INNER JOIN LabObservation_Help_Master lhm " +
                         "ON lhm.id=loh.HelpId AND loh.LabObservation_id=@Obs";
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, str, new MySqlParameter("@Obs", ddlobservation.SelectedValue), new MySqlParameter("@ObsText", ddlobservation.SelectedItem.Text)).Tables[0];
            grdObs.DataSource = dt;
            grdObs.DataBind();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally {
            con.Close();
            con.Dispose();
        }
    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        try
        {
            txtEdit.Text = ListBox1.SelectedItem.Value.Split('#')[1];
            txtEdit.Attributes["ID"] = ListBox1.SelectedItem.Value.Split('#')[0];
            if(ListBox1.SelectedItem.Value.Split('#')[2]=="1")
            {
                chkisBoldEdit.Checked = true;
            }
            else{
                chkisBoldEdit.Checked = false;
            }   
            txtheader.Text = ListBox1.SelectedItem.Text;
            mdpEditHelp.Show();
        }
        catch
        {
            lblMsg.Text = "Please Select List";
            mdpEditHelp.Hide();
        }
    }

    protected void grdObs_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (e.CommandName == "imbRemove")
            {
                int args = Util.GetInt(e.CommandArgument);
                string id = ((Label)grdObs.Rows[args].FindControl("lblid")).Text;
                string str1 = "DELETE FROM LabObservation_Help where id=@id ";
                MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str1, new MySqlParameter("@id", id));

                bindMapping();
                lblMsg.Text = "Sucessfully Deleted";
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

    protected void btnEditUpdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            int isbold = 0;
            if (chkisBoldEdit.Checked)
            {
                isbold = 1;
            }
            string str = "UPDATE  labobservation_help_master set HELP =@Edit , ShortKey = @Header,IsBold=@isBold where id=@Attribute ";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, str, new MySqlParameter("@Edit", txtEdit.Text.Trim()), new MySqlParameter("@Header", txtheader.Text)
                 ,new MySqlParameter("@isBold",isbold)
                ,new MySqlParameter("@Attribute",txtEdit.Attributes["ID"].ToString()));

        BindHelp();

            bindMapping();
            lblMsg.Text = "Sucessfully Updated";
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

        }
        finally {
            con.Close();
            con.Dispose();
        }
    }

    protected void ddlInvestigation_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindObservation();
    }
}