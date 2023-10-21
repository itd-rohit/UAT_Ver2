using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_DocAccount_DocShareStatus : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string UpdateDocStatus(string Doctor_ID, int ReferShare)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        MySqlTransaction tnx = con.BeginTransaction(IsolationLevel.Serializable);

        try
        {
            MySqlHelper.ExecuteNonQuery(tnx, CommandType.Text, "UPDATE doctor_referal SET ReferMasterShare=@ReferShare WHERE Doctor_ID=@Doctor_ID",
               new MySqlParameter("@Doctor_ID", Doctor_ID), new MySqlParameter("@ReferShare", ReferShare));
            tnx.Commit();
            return "1";
        }
        catch (Exception ex)
        {
            tnx.Rollback();
            ClassLog cl = new ClassLog();
            cl.errLog(ex);

            return "0";
        }
        finally
        {
            tnx.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}