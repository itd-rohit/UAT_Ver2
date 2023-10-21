using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.IO;
using System.Web.UI.WebControls;
using System.Web.UI;
public partial class Design_Investigation_ConcentFormMaster : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindGrid();
            BindGrid1();
        }
    }

    private void BindGrid()
    {
        string query = "select id,Fieldsname from concentform_fieldsmaster order by id  ";

        DataTable dt = StockReports.GetDataTable(query);
        mygrid.DataSource = dt;
        mygrid.DataBind();
    }

    private void BindGrid1()
    {
        string query = "SELECT id,concentformname,Filename,DATE_FORMAT(Entrydate,'%d-%b-%y %h:%i %p') endate FROM investigation_concentform ORDER BY concentformname  ";

        DataTable dt = StockReports.GetDataTable(query);
        grd.DataSource = dt;
        grd.DataBind();
    }

    protected void btnsave_Click(object sender, EventArgs e)
    {



        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string count = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select count(*) from investigation_concentform where concentformname=@Name", new MySqlParameter("@Name", txtname.Text)).ToString();
            if (count == "1")
            {
                lblMsg.Text = "Form Name Already Exist.!";
                return;
            }

        //System.Drawing.Image imgFile = System.Drawing.Image.FromStream(file.PostedFile.InputStream);
        //if (imgFile.PhysicalDimension.Width > 850 || imgFile.PhysicalDimension.Height > 1169)
        //{
        //    lblMsg.Text = "Size of Image Should be 850X1169 or less";
        //    return;
        //}

        string RootDir = Server.MapPath("~/Design/ConcentForm");
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);

        string fileExt = System.IO.Path.GetExtension(file.FileName);
        string FileName = "";
        if (fileExt == ".pdf")
        {
            RootDir = string.Format(@"{0}\{1:yyyyMMdd}", RootDir, DateTime.Now);
            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);
            fileExt = System.IO.Path.GetExtension(file.FileName);
            FileName = string.Format("{0}_{1:yyyyMMddHHmmss}{2}", file.FileName.Replace(fileExt, "").Trim(), DateTime.Now, fileExt);
           
        }
        else {

            System.Drawing.Image imgFile = System.Drawing.Image.FromStream(file.PostedFile.InputStream);
            if (imgFile.PhysicalDimension.Width > 850 || imgFile.PhysicalDimension.Height > 1169)
            {
                lblMsg.Text = "Size of Image Should be 850X1169 or less";
                return;
            }
        }
               FileName = txtname.Text + fileExt;


            string q = "insert into investigation_concentform (concentformname,Filename,EntryBy,Entrydate,Type) values(@Name,@FileName,@ID,now(),'Concentform') ";
            MySqlHelper.ExecuteNonQuery(con, CommandType.Text, q, new MySqlParameter("@Name", txtname.Text.ToUpper()), new MySqlParameter("@FileName", FileName), new MySqlParameter("@ID", Session["ID"].ToString()));

            string id = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "select max(id) from investigation_concentform"));
            foreach (GridViewRow grd in mygrid.Rows)
            {
                CheckBox ck = (CheckBox)grd.FindControl("ch");
                if (ck.Checked)
                {
                    Label lbname = (Label)grd.FindControl("Label1");
                    Label lbid = (Label)grd.FindControl("Label2");
                    TextBox txtleft = (TextBox)grd.FindControl("txtleft");
                    TextBox txttop = (TextBox)grd.FindControl("txttop");
                    DropDownList ddlfont = (DropDownList)grd.FindControl("ddlfont");
                    CheckBox ckbold = (CheckBox)grd.FindControl("chbold");
                    DropDownList ddlfontsize = (DropDownList)grd.FindControl("ddlfontsize");

                    int bold = ckbold.Checked ? 1 : 0;
                    string q1 = "insert into investigation_concentform_detail (formid,formname,fieldsid,FieldsName,`Left`,`Top`,fontname,isbold,fontsize,EntryBy,Entrydate) values(@id,@Name,@lbid,@lbname,@left,@top,@font,@bold,@fontsize,@ID,now()) ";
                    MySqlHelper.ExecuteNonQuery(con, CommandType.Text, q1, new MySqlParameter("@id", id), new MySqlParameter("@Name", txtname.Text),
                        new MySqlParameter("@lbid", lbid.Text), new MySqlParameter("@lbname", lbname.Text),
                        new MySqlParameter("@left", txtleft.Text), new MySqlParameter("@top", txttop.Text),
                        new MySqlParameter("@font", ddlfont.SelectedValue), new MySqlParameter("@bold", bold),
                        new MySqlParameter("@fontsize", ddlfontsize.SelectedValue), new MySqlParameter("@ID", Session["ID"].ToString()));
                }
            }
            tnx.Commit();

            file.SaveAs(RootDir + @"\" + FileName);
            txtname.Text = "";
            mm.Attributes["src"] = "";
            BindGrid();
            BindGrid1();
            lblMsg.Text = "Record Saved..!";
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void grd_SelectedIndexChanged(object sender, EventArgs e)
    {
        string ID = ((Label)grd.SelectedRow.FindControl("Label5")).Text;
        string Name = ((Label)grd.SelectedRow.FindControl("Label2")).Text;
        string filname = ((Label)grd.SelectedRow.FindControl("Label3")).Text;
        try
        {
            //modelmultiplepaymentmode.Show();
            string mmc = Convert.ToBase64String(File.ReadAllBytes(Server.MapPath("~/Design/ConcentForm") + "/" + filname));
            string ext = System.IO.Path.GetExtension((Server.MapPath("~/Design/ConcentForm") + "/" + filname));
            if (ext.Replace(".", "").ToUpper() != "PDF")
            {
                mm.Attributes["src"] = @"data:image/" + ext.Replace(".", "") + ";base64," + mmc;
               // mm2.Attributes["src"] = @"data:image/" + ext.Replace(".", "") + ";base64," + mmc;
            }
            else
            {
                mm.Attributes["src"] = @"data:application/pdf;base64," + mmc;
                //mm2.Attributes["src"] = @"data:application/pdf;base64," + mmc;
            }
            ScriptManager.RegisterStartupScript(Page, Page.GetType(), "onclick", "window.open('../../Design/ConcentForm/PrintConcentFrom.aspx?Name=" + filname.Replace(ext,"") + "','_blank');", true);

        }
        catch
        {
        }
        txtname.Text = Name;
        mmid.Text = ID;
        btnsave.Visible = false;
        btnupdate.Visible = true;

        foreach (GridViewRow dwr in mygrid.Rows)
        {
            Label id = (Label)dwr.FindControl("Label2");
            TextBox left = (TextBox)dwr.FindControl("txtleft");
            TextBox right = (TextBox)dwr.FindControl("txttop");
            CheckBox ch = (CheckBox)dwr.FindControl("ch");
            DropDownList ddlfont = (DropDownList)dwr.FindControl("ddlfont");
            CheckBox ckbold = (CheckBox)dwr.FindControl("chbold");
            DropDownList ddlfontsize = (DropDownList)dwr.FindControl("ddlfontsize");
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                DataTable dtc = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT `Left`,Top,fontname,isbold,fontsize FROM investigation_concentform_detail WHERE formid=@ID and fieldsid=@FID  ",
                    new MySqlParameter("@ID", ID), new MySqlParameter("@FID",id.Text)).Tables[0];
                if (dtc.Rows.Count > 0)
                {
                    left.Text = dtc.Rows[0]["Left"].ToString();
                    right.Text = dtc.Rows[0]["Top"].ToString();
                    ddlfont.SelectedIndex = ddlfont.Items.IndexOf(ddlfont.Items.FindByText(dtc.Rows[0]["fontname"].ToString()));
                    ddlfontsize.SelectedIndex = ddlfontsize.Items.IndexOf(ddlfontsize.Items.FindByText(dtc.Rows[0]["fontsize"].ToString()));
                    if (dtc.Rows[0]["isbold"].ToString() == "1")
                    {
                        ckbold.Checked = true;
                    }
                    else
                    {
                        ckbold.Checked = false;
                    }
                    ch.Checked = true;
                }
                else
                {
                    left.Text = "";
                    right.Text = "";
                    ddlfont.SelectedIndex = 0;
                    ddlfontsize.SelectedIndex = 0;
                    ckbold.Checked = false;
                    ch.Checked = false;
                }
            }
            catch (Exception ex)
            {
                ClassLog objClassLog = new ClassLog();
                objClassLog.errLog(ex);
            }
            finally
            {
                con.Close();
                con.Dispose();
            }
        }
    }

    protected void btnupdate_Click(object sender, EventArgs e)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string count = MySqlHelper.ExecuteScalar(tnx, CommandType.Text, "select count(*) from investigation_concentform where concentformname=@Name and id<>@mmid", new MySqlParameter("@Name", txtname.Text), new MySqlParameter("@mmid", mmid.Text)).ToString();
            if (count == "1")
            {
                lblMsg.Text = "Form Name Already In Used.!";
                return;
            }
            if (file.HasFile)
            {
                string RootDir = Server.MapPath("~/Design/ConcentForm");
                if (!Directory.Exists(RootDir))
                    Directory.CreateDirectory(RootDir);

            if (!Directory.Exists(RootDir))
                Directory.CreateDirectory(RootDir);

                string fileExt = System.IO.Path.GetExtension(file.FileName);
                string FileName = txtname.Text + fileExt;
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update investigation_concentform set concentformname=@Name,filename=@FileName where id=@mmid",
                    new MySqlParameter("@Name", txtname.Text.ToUpper()), new MySqlParameter("@FileName", FileName),
                    new MySqlParameter("@mmid", mmid.Text));
                file.SaveAs(RootDir + @"\" + FileName);
            }
            else
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "update investigation_concentform set concentformname=@Name where id=@mmid",
                    new MySqlParameter("@Name", txtname.Text.ToUpper()), new MySqlParameter("@mmid", mmid.Text));
            }
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from investigation_concentform_detail where formid=@mmid", new MySqlParameter("@mmid", mmid.Text));
            foreach (GridViewRow grd in mygrid.Rows)
            {
                CheckBox ck = (CheckBox)grd.FindControl("ch");
                if (ck.Checked)
                {
                    Label lbname = (Label)grd.FindControl("Label1");
                    Label lbid = (Label)grd.FindControl("Label2");
                    TextBox txtleft = (TextBox)grd.FindControl("txtleft");
                    TextBox txttop = (TextBox)grd.FindControl("txttop");
                    DropDownList ddlfont = (DropDownList)grd.FindControl("ddlfont");
                    CheckBox ckbold = (CheckBox)grd.FindControl("chbold");
                    DropDownList ddlfontsize = (DropDownList)grd.FindControl("ddlfontsize");
                    int bold = ckbold.Checked ? 1 : 0;
                    string q1 = "insert into investigation_concentform_detail (formid,formname,fieldsid,FieldsName,`Left`,`Top`,fontname,isbold,fontsize,EntryBy,Entrydate) values(@mmid,@Name,@lbid,@lbname,@left,@top,@font,@bold,@FSize,@ID,now()) ";
                    MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, q1, new MySqlParameter("@mmid", mmid.Text),
                        new MySqlParameter("@Name", txtname.Text), new MySqlParameter("@lbid", lbid.Text), new MySqlParameter("@lbname", lbname.Text),
                        new MySqlParameter("@left", txtleft.Text), new MySqlParameter("@top", txttop.Text), new MySqlParameter("@font", ddlfont.SelectedValue),
                        new MySqlParameter("@bold", bold), new MySqlParameter("@FSize", ddlfontsize.SelectedValue), new MySqlParameter("@ID", Session["ID"].ToString()));
                }
            }
            tnx.Commit();
            txtname.Text = "";
            mm.Attributes["src"] = "";
            BindGrid();
            BindGrid1();
            lblMsg.Text = "Record Updated..!";
            btnsave.Visible = true;
            btnupdate.Visible = false;
            mmid.Text = "";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog objClassLog = new ClassLog();
            objClassLog.errLog(ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    protected void btnrefresh_Click(object sender, EventArgs e)
    {
        BindGrid();
    }

    protected void mygrid_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DropDownList ddl = (DropDownList)e.Row.FindControl("ddlfont");

            System.Drawing.Text.InstalledFontCollection col = new System.Drawing.Text.InstalledFontCollection();
            foreach (System.Drawing.FontFamily family in col.Families)
            {
                ddl.Items.Add(family.Name);
            }
        }
    }
}