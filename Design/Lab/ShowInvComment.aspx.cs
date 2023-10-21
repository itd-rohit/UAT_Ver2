using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;

public partial class Design_Lab_ShowInvComment : System.Web.UI.Page
{
    string Test_ID = ""; string LabNo = ""; string Inv_ID = ""; string approved = "";
    protected void Page_Load(object sender, EventArgs e)
    {
         MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            Test_ID = Util.GetString(Request.QueryString["TestId"]);
            string Inv_ID1 =Util.GetString( MySqlHelper.ExecuteScalar(con, CommandType.Text, "select concat(investigation_id,'#',LedgertransactionNo,'#',Approved) from patient_labinvestigation_opd where test_id=@Test_ID",
               new MySqlParameter("@Test_ID", Test_ID)));
            Inv_ID = Inv_ID1.Split('#')[0];
            LabNo = Inv_ID1.Split('#')[1];
            approved = Inv_ID1.Split('#')[2];

            if (approved == "1")
            {
                ddl.Enabled = false;
                btn.Enabled = false;
            }
            if (!IsPostBack)
            {
                ddl.DataSource = MySqlHelper.ExecuteDataset(con, CommandType.Text, " SELECT comments_head,comments_id FROM investigation_comments WHERE investigation_id=@Inv_ID",
                     new MySqlParameter("@Inv_ID", Inv_ID)).Tables[0];
                ddl.DataValueField = "comments_id";
                ddl.DataTextField = "comments_head";
                ddl.DataBind();
                ddl.Items.Insert(0, new ListItem("Select", "0"));


                string comment = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, " SELECT comments FROM patient_labinvestigation_opd_comments where Test_ID=@Test_ID",
                   new MySqlParameter("@Test_ID", Test_ID)));
                if (comment != string.Empty)
                {
                    CKEditorControl1.Text = Server.HtmlDecode(Util.GetString(comment));
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
    protected void ddl_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddl.SelectedValue != "0")
        {
            using (DataTable dt = StockReports.GetDataTable("Select Comments from investigation_comments where Comments_ID =" + ddl.SelectedValue))
            {

                if (dt != null && dt.Rows.Count > 0)
                {

                    CKEditorControl1.Text = Server.HtmlDecode(Util.GetString(dt.Rows[0]["Comments"]));

                }
            }
        }
        else
        {

            CKEditorControl1.Text = "";
        }

    }
    protected void btn_Click(object sender, EventArgs e)
    {

     //  if (CKEditorControl1.Text == "")
     //  {
     //      Label1.Text = "Please enter the Comment ";
     //      return;
     //  }
        Label1.Text = "";
        string header = "";
        header = CKEditorControl1.Text;
        header = header.Replace("\'", "");
        header = header.Replace("–", "-");
        header = header.Replace("'", "");
        header = header.Replace("µ", "&micro;");
        header = header.Replace("ᴼ", "&deg;");
        header = header.Replace("#aaaaaa 1px dashed", "none");
        header = header.Replace("dashed", "none");


        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from patient_labinvestigation_opd_comments where Test_ID=@Test_ID",
                        new MySqlParameter("@Test_ID", Test_ID));
            if (CKEditorControl1.Text != "")
            {
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "insert into patient_labinvestigation_opd_comments(LedgerTransactionNo,Test_ID,comments,UserID,UserName) values(@LedgerTransactionNo,@Test_ID,@comments,@UserID,@UserName)",
                               new MySqlParameter("@LedgerTransactionNo", LabNo),
                               new MySqlParameter("@Test_ID", Test_ID),
                               new MySqlParameter("@comments", header),
                               new MySqlParameter("@UserID", UserInfo.ID),
                               new MySqlParameter("@UserName", UserInfo.LoginName)
                               );
                Label1.Text = "Comment Added";
            }
            tnx.Commit();
            if (CKEditorControl1.Text == "")
            {
                Label1.Text = "Comment Removed";
            }
        }
        catch
        {
            tnx.Rollback();
            Label1.Text = "Error";
        }
        finally
        {
          
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}