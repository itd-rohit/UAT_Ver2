using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
using System.Linq;
public partial class Design_Lab_AddReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, this.GetType(), "keysearch1", "document.getElementById('divMasterNav').style.display='none';", true);
        lblMsg.Text = "";
        if (!IsPostBack)
        {
            string TestID = Common.DecryptRijndael(Request.QueryString["Test_ID"].Replace(" ", "+"));
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
                sb.Append("AND pli.`test_id` in({0}) AND pli.`IsSampleCollected`='Y' ORDER BY im.`Name`");
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
                        if (tests.Rows.Count == 0)
                        {
                            lblMsg.Text = "Test Sample Not Collected / Received At Processing Centre.";
                        }
                        else
                        {
                            lblMsg.Text = "";
                        }
                        ddlTests.DataSource = tests;
                        ddlTests.DataTextField = "Name";
                        ddlTests.DataValueField = "Test_ID";
                        ddlTests.DataBind();

                    }
                }
                bindAttachment();
                sb.Clear();
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
    }
    private void bindAttachment()
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {

            StringBuilder sb = new StringBuilder();
            sb.Append(" SELECT pli.`id`,pli.`AttachedFile`,plo.Approved,CONCAT_WS('/',DATE_FORMAT(pli.`dtEntry`,'%Y%m%d'), pli.`FileUrl`)FileUrl,em.`Name` AS UploadedBy,DATE_FORMAT(pli.`dtEntry`,'%d-%b-%y') AS dtEntry  ");
            sb.Append(" FROM `patient_labinvestigation_attachment_report` pli  ");
            sb.Append(" inner join `patient_labinvestigation_opd` plo on pli.Test_ID=plo.Test_ID  ");

            sb.Append(" INNER JOIN `employee_master` em ON em.`Employee_ID`=pli.`UploadedBy` and pli.Test_ID=@Test_ID ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@Test_ID", ddlTests.SelectedValue)).Tables[0])
            {
                grvAttachment.DataSource = dt;
                grvAttachment.DataBind();

                if (dt.Rows.Count > 0)
                {
                    if (dt.Rows[0]["Approved"].ToString() == "1")
                    {
                        grvAttachment.Columns[0].Visible = false;
                    }
                    else
                    {
                        grvAttachment.Columns[0].Visible = true;
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

        string LedgerTransactionNo = Common.DecryptRijndael(Request.QueryString["LedgerTransactionNo"].Replace(" ", "+"));
        string Test_ID = string.Empty;





        Test_ID = Util.GetString(ddlTests.SelectedValue);

        if ((LedgerTransactionNo == string.Empty) || (Test_ID == ""))
            return;
        string RootDir = string.Concat(Resources.Resource.DocumentPath, "\\Uploaded Report");

        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);
        RootDir = string.Format(@"{0}\{1:yyyyMMdd}", RootDir, DateTime.Now);
        if (!Directory.Exists(RootDir))
            Directory.CreateDirectory(RootDir);
        string fileExt = System.IO.Path.GetExtension(fu_Upload.FileName);
        string FileName = string.Format("{0}_{1}_{2:yyyyMMddHHmmss}{3}", LedgerTransactionNo, fu_Upload.FileName.Replace(fileExt, "").Trim(), DateTime.Now, fileExt);
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            string department = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT `SubCategoryID` FROM `patient_labinvestigation_opd` plo WHERE plo.`Test_ID`=@Test_ID",
                new MySqlParameter("@Test_ID", Test_ID)));
            patient_labinvestigation_attachment plo = new patient_labinvestigation_attachment(tnx)
            {
                Test_ID_varchar = Test_ID,
                AttachedFile_varchar = fu_Upload.FileName,
                FileUrl_varchar = FileName,
                UploadedBy_varchar = Session["ID"].ToString()
            };
            string IsOutSrc = "0";
            if (Util.GetString(Request.QueryString["OutSrc"]) != string.Empty)
                IsOutSrc = Common.DecryptRijndael(Request.QueryString["OutSrc"]);
            
            plo.V_IsOutSrc = IsOutSrc;
            plo.InsertReport();
            fu_Upload.SaveAs(string.Format(@"{0}\{1}", RootDir, FileName));
            StringBuilder sb = new StringBuilder();
            sb.Append("update patient_labinvestigation_opd set  ResultEnteredBy=if(Result_Flag=0,@UserID,ResultEnteredBy),ResultEnteredDate=if(Result_Flag=0,NOW(),ResultEnteredDate),ResultEnteredName=if(Result_Flag=0,@LoginName,ResultEnteredName),Result_Flag=1 ");
            if (IsOutSrc == "1")
            {
                sb.Append(" ,TestCentreID=@TestCentreID,IsSampleCollected='Y',SampleReceiver=@LoginName,SampleReceivedBy=@UserID,sampleCollectionDate=NOW(),SampleReceiveDate=NOW()  ");
                if (department == "10" || department == "7" || department == "4")
                {
                    sb.Append(",Approved='1',ApprovedName=@ApprovedName,ApprovedBy=@ApprovedBy,ApprovedDate=NOW(),ApprovedDoneBy=@ApprovedDoneBy  ");
                }
            }
            sb.Append(" where test_id=@Test_ID   ");
            if (Util.GetString(Request.QueryString["OutSrc"]) == string.Empty)
            {
                sb.Append(" and isSampleCollected='Y' ");
            }
            int RowsAffected = MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@LoginName", Util.GetString(HttpContext.Current.Session["LoginName"])),
               new MySqlParameter("@TestCentreID", UserInfo.Centre), new MySqlParameter("@Test_ID", Test_ID),
               new MySqlParameter("@ApprovedName", UserInfo.LoginName), new MySqlParameter("@ApprovedBy", UserInfo.ID), new MySqlParameter("@ApprovedDoneBy", UserInfo.ID));
            sb = new StringBuilder();
            sb.Append(" INSERT INTO patient_labinvestigation_opd_update_status(LedgertransactionNo,BarcodeNo,Test_ID,Status,UserID,UserName,IpAddress,CentreID,RoleID,dtEntry,DispatchCode)");
            if (IsOutSrc == "1")
                sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('OutSource Report Added (',ItemName,')'),@UserID,@LoginName,@IpAddress,@CentreID, ");
            else
                sb.Append(" SELECT LedgerTransactionNo,BarCodeNo,Test_ID,CONCAT('Report Added (',ItemName,')'),@UserID,@LoginName,@IpAddress,@CentreID, ");
            sb.Append(" @RoleID,NOW(),'' FROM patient_labinvestigation_opd  WHERE  Test_ID =@Test_ID");
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
               new MySqlParameter("@UserID", UserInfo.ID), new MySqlParameter("@RoleID", UserInfo.RoleID), new MySqlParameter("@LoginName", UserInfo.LoginName),
               new MySqlParameter("@Test_ID", Test_ID), new MySqlParameter("@CentreID", UserInfo.Centre), new MySqlParameter("@IpAddress", StockReports.getip()));
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

            if (File.Exists(string.Concat(Resources.Resource.DocumentPath, "\\Uploaded Report", lblPath.Text)))
            {
                File.Delete(string.Concat(Resources.Resource.DocumentPath, "\\Uploaded Report", lblPath.Text));
            }
            StockReports.ExecuteDML(string.Format("delete from patient_labinvestigation_attachment_report where id='{0}'", e.CommandArgument));
        }
        bindAttachment();
    }
    protected void ddlTests_SelectedIndexChanged(object sender, EventArgs e)
    {
        bindAttachment();
    }
}