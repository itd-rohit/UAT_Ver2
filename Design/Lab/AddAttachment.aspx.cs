using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Linq;
public partial class Design_Lab_AddAttachment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch1", "document.getElementById('divMasterNav').style.display='none';", true);
        if (!IsPostBack)
        {
            string TestID = Util.GetString(Request.QueryString["Test_ID"]);
            TestID = string.Format("'{0}'", TestID);
            TestID = TestID.Replace(",", "','");
            List<string> Test_ID = TestID.TrimEnd(',').Split(',').ToList<string>();

            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {

                StringBuilder sb = new StringBuilder();
                sb = new StringBuilder();
                sb.Append("SELECT pli.`Test_ID`,im.`Name` FROM `patient_labinvestigation_opd` pli ");
                sb.Append("INNER JOIN `investigation_master` im ");
                sb.Append("ON pli.`Investigation_ID`=im.`Investigation_Id` ");
                sb.Append("AND pli.`test_id` in({0}) ORDER BY im.`Name`");
                using (MySqlDataAdapter da = new MySqlDataAdapter(String.Format(sb.ToString(), string.Join(",", Test_ID)), con))
                {
                    for (int i = 0; i < Test_ID.Count; i++)
                    {
                        da.SelectCommand.Parameters.AddWithValue(string.Concat("@Test_IDParam", i), Test_ID[i]);
                    }
                    DataTable tests = new DataTable();
                    using (tests as IDisposable)
                    {
                        da.Fill(tests);
                        ddlTests.DataSource = tests;
                        ddlTests.DataTextField = "Name";
                        ddlTests.DataValueField = "Test_ID";
                        ddlTests.DataBind();
                        if (Util.GetString(Request.QueryString["Test_ID"]) != string.Empty)
                        {
                            // ddlTests.SelectedValue = Util.GetString(Request.QueryString["Test_ID"]);
                            // ddlTests.Enabled = false;
                        }
                    }
                }

                bindAttachment();
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
        lblMsg.Text = string.Empty;
    }

    private void bindAttachment()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pli.`id`,pli.`AttachedFile`,plo.Approved,CONCAT_WS('/',DATE_FORMAT(pli.`dtEntry`,'%Y%m%d'), pli.`FileUrl`)FileUrl,em.`Name` AS UploadedBy,DATE_FORMAT(pli.`dtEntry`,'%d-%b-%y') AS dtEntry  ");
            sb.Append(" FROM `patient_labinvestigation_attachment` pli  ");
            sb.Append(" inner join `patient_labinvestigation_opd` plo on pli.Test_ID=plo.Test_ID  ");
            sb.Append(" INNER JOIN `employee_master` em ON em.`Employee_ID`=pli.`UploadedBy` and pli.Test_ID=@Test_ID");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                       new MySqlParameter("@Test_ID", ddlTests.SelectedValue)).Tables[0])
            {
                grvAttachment.DataSource = dt;
                grvAttachment.DataBind();

                if (dt.Rows.Count > 0)
                {
                    if (dt.Rows[0]["Approved"].ToString() == "1")
                    {
                        //   grvAttachment.Columns[0].Visible = false;
                    }
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
    protected void btnSave_Click(object sender, EventArgs e)
    {
        string LedgerTransactionNo = Util.GetString(Request.QueryString["LedgerTransactionNo"]);
        string Test_ID = string.Empty;
        if (Util.GetString(Request.QueryString["Test_ID"]) != string.Empty)
        {
            //ddlTests.SelectedValue = Util.GetString(Request.QueryString["Test_ID"]);
        }
        Test_ID = Util.GetString(ddlTests.SelectedValue);

        if ((LedgerTransactionNo == string.Empty) || (Test_ID == string.Empty))
            return;

        string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\Uploaded Document");


        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);
        RootDir = string.Format(@"{0}\{1:yyyyMMdd}", RootDir, DateTime.Now);

        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);
        string fileExt = "";
       fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);
        if (fileExt == "")
        {
            lblMsg.Font.Size = 15;
            lblMsg.Text = "Please select file to upload.....";
            return;
        }
        string FileName = string.Format("{0}_{1}_{2:yyyyMMddHHmmss}{3}", LedgerTransactionNo, fu_Upload.FileName.Replace(fileExt, "").Trim(), DateTime.Now, fileExt);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            patient_labinvestigation_attachment plo = new patient_labinvestigation_attachment(tnx)
            {
                Test_ID_varchar = Test_ID,
                AttachedFile_varchar = fu_Upload.FileName,
                FileUrl_varchar = FileName,
                UploadedBy_varchar = Session["ID"].ToString()
            };
            plo.Insert();
            fu_Upload.SaveAs(string.Format(@"{0}\{1}", RootDir, FileName));
            tnx.Commit();
            lblMsg.Text = "File uploaded successfully.";
            bindAttachment();
        }
        catch (Exception ex)
        {
            lblMsg.Text = ex.Message;
            tnx.Rollback();
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
    protected void grvAttachment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Remove")
        {
            GridViewRow gvr = ((Control)e.CommandSource).Parent.Parent as GridViewRow;
            Label lblPath = (Label)gvr.FindControl("lblPath");
            if (File.Exists(string.Concat(Resources.Resource.DocumentPath, "\\Uploaded Document", lblPath.Text)))
            {
                File.Delete(string.Concat(Resources.Resource.DocumentPath, "\\Uploaded Document", lblPath.Text));
            }
            StockReports.ExecuteDML("delete from patient_labinvestigation_attachment where id='" + e.CommandArgument.ToString() + "'");
        }
        bindAttachment();
    }
    protected void ddlTests_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindAttachment();
    }
}