using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Services;

public partial class Design_Lab_HistoImmunoChemistry : System.Web.UI.Page
{
    public static string TestID = string.Empty;
    public static string LabNo = string.Empty;

    public enum makejson
    {
        e_without_square_brackets,
        e_with_square_brackets
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        TestID = Util.GetString(Request.QueryString["TestID"]);
        LabNo = Util.GetString(Request.QueryString["LabNo"]);
        if (!IsPostBack)
        {
            MySqlConnection con = Util.GetMySqlCon();
            con.Open();
            try
            {
                bindantibiotic(con);

                string s = Util.GetString(MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT comments FROM patient_labhisto_immuno WHERE labno=@LabNo AND testid=@testid ",
                   new MySqlParameter("@LabNo", LabNo), new MySqlParameter("@testid", TestID)));
                txtcomments.Text = s;
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

    private void bindantibiotic(MySqlConnection con)
    {
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT id,name  FROM histoimmuno_master WHERE isActive=1 ORDER BY name").Tables[0])
        {
            lstlist.DataSource = dt;
            lstlist.DataValueField = "id";
            lstlist.DataTextField = "name";
            lstlist.DataBind();
        }
    }

    [WebMethod]
    public static string savedata(List<string[]> mydataadj)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);
        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "delete from patient_labhisto_immuno where testid=@testid and labno=@labno",
               new MySqlParameter("@testid", Util.GetString(mydataadj[0][0])), new MySqlParameter("@labno", Util.GetString(mydataadj[0][1])));

            StringBuilder sb = new StringBuilder();
            foreach (string[] ss in mydataadj)
            {
                sb = new StringBuilder();
                sb.Append("INSERT INTO patient_labhisto_immuno ");
                sb.Append("(labno,testid,antiname,antiid,Clone,`TYPE`,Result,Intensity,Pattern,Percentage,entrydate,entryby,interpretation,comments)");
                sb.Append("VALUES(@labno,@testid,@antiname,@antiid,@Clone");
                sb.Append(",@TYPE,@Result,@Intensity,@Pattern,@Percentage");
                sb.Append(",NOW(),@entryby,@interpretation,@comments)");
                MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, sb.ToString(),
                   new MySqlParameter("@labno", ss[1].ToString()),
                   new MySqlParameter("@testid", ss[0].ToString()),
                   new MySqlParameter("@antiname", ss[2].ToString()),
                   new MySqlParameter("@antiid", ss[3].ToString()),
                   new MySqlParameter("@Clone", ss[4].ToString()),
                   new MySqlParameter("@TYPE", ss[5].ToString()),
                   new MySqlParameter("@Result", ss[6].ToString()),
                   new MySqlParameter("@Intensity", ss[7].ToString()),
                   new MySqlParameter("@Pattern", ss[8].ToString()),
                   new MySqlParameter("@Percentage", ss[9].ToString()), new MySqlParameter("@interpretation", ss[10].ToString()),new MySqlParameter("@comments", ss[11].ToString()),
                   new MySqlParameter("@entryby", Util.GetString(HttpContext.Current.Session["ID"])));
            }

            tnx.Commit();

            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();

            throw (ex);
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }

    [WebMethod]
    public static string getdata(string labno, string testid)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("SELECT antiname,antiid,obsvalue,Clone,`TYPE`,Result,Intensity,Pattern,Percentage,interpretation FROM patient_labhisto_immuno WHERE labno=@labno AND testid=@testid ");
            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                 new MySqlParameter("@labno", labno), new MySqlParameter("@testid", testid)).Tables[0])
                return JsonConvert.SerializeObject(dt);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }
}