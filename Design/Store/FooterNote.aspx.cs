using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public partial class Design_Store_FooterNote : System.Web.UI.Page
{
   
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindData();
        }
    }


    protected void bindData()
    {
        DataTable dt = StockReports.GetDataTable("SELECT VendorNote,FooterNote FROM st_purchaseorder_footer_note ");
        if (dt.Rows.Count > 0)
        {
            txtVendorNote.Text = Util.GetString(dt.Rows[0]["VendorNote"]);
            txtFooterNote.Text = Util.GetString(dt.Rows[0]["FooterNote"]);
        }
        else
        {
            txtVendorNote.Text = "";
            txtFooterNote.Text = "";
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        lblMsg.Text = "";
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        string VendorNote = "";
        VendorNote = txtVendorNote.Text;
        VendorNote = VendorNote.Replace("\'", "");
        VendorNote = VendorNote.Replace("<br />", "<br>");
        VendorNote = VendorNote.Replace("–", "-");
        VendorNote = VendorNote.Replace("'", "");
        VendorNote = VendorNote.Replace("µ", "&micro;");
        VendorNote = VendorNote.Replace("ᴼ", "&deg;");
        VendorNote = VendorNote.Replace("#aaaaaa 1px dashed", "none");
        VendorNote = VendorNote.Replace("dashed", "none");
        string FooterNote = "";
        FooterNote = txtFooterNote.Text;
        FooterNote = FooterNote.Replace("\'", "");
        FooterNote = FooterNote.Replace("<br />", "<br>");
        FooterNote = FooterNote.Replace("–", "-");
        FooterNote = FooterNote.Replace("'", "");
        FooterNote = FooterNote.Replace("µ", "&micro;");
        FooterNote = FooterNote.Replace("ᴼ", "&deg;");
        FooterNote = FooterNote.Replace("#aaaaaa 1px dashed", "none");
        FooterNote = FooterNote.Replace("dashed", "none");

        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append(" select count(1) from st_purchaseorder_footer_note ");
            if (Util.GetInt(MySqlHelper.ExecuteScalar(tnx,CommandType.Text,sb.ToString())) == 0)
            {
                sb = new StringBuilder();
                sb.Append(" INSERT INTO st_purchaseorder_footer_note ");
                sb.Append(" (VendorNote,FooterNote,EnteredByID,EnteredByName) ");
                sb.Append(" VALUES ");
                sb.Append(" (@VendorNote,@FooterNote,@EnteredByID,@EnteredByName) ");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@VendorNote", VendorNote),
                    new MySqlParameter("@FooterNote", FooterNote),
                    new MySqlParameter("@EnteredByID", UserInfo.ID),
                    new MySqlParameter("@EnteredByName", UserInfo.LoginName));
            }
            else
            {
                sb = new StringBuilder();
                sb.Append(" update st_purchaseorder_footer_note ");
                sb.Append(" set VendorNote=@VendorNote,FooterNote=@FooterNote,UpdatedByID=@UpdatedByID,UpdatedByName=@UpdatedByName,dtUpdate=@dtUpdate where ID=@ID ");              
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                    new MySqlParameter("@VendorNote", VendorNote),
                    new MySqlParameter("@FooterNote", FooterNote),
                    new MySqlParameter("@UpdatedByID", UserInfo.ID),
                    new MySqlParameter("@ID", "1"),
                    new MySqlParameter("@dtUpdate", DateTime.Now),
                    new MySqlParameter("@UpdatedByName", UserInfo.LoginName));
            } 
            tnx.Commit();
            lblMsg.Text = "Record Saved Successfully....!";
            bindData();
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
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

}