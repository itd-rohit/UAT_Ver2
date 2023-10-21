using CrystalDecisions.CrystalReports.Engine;
using MySql.Data.MySqlClient;
using System;
using System.Data;
using System.Text;

public partial class Design_Master_CentreWelcomeLetter : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string CentreID = Util.GetString(Common.Decrypt(Request.QueryString["CentreID"]));

            bindCentre(CentreID);
        }
    }

    private void bindCentre(string CentreID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        ReportDocument obj1 = new ReportDocument();
        System.IO.Stream m = null;
        try
        {
            StringBuilder sb = new StringBuilder();

            sb = new StringBuilder();
            sb.Append(" SELECT DISTINCT cm.CentreID,cm.Centre,cm.Type1,IFNULL(fpm.OwnerName,'')OwnerName,fpm.LedgerReportPassword,(fpm.CreditLimit*(-1))CreditLimit,(fpm.LabReportLimit*(-1))LabReportLimit,(fpm.IntimationLimit*(-1))IntimationLimit,cm.contactpersoneMail,");
            sb.Append(" IFNULL(lo.UserName,'')UserName,IFNULL(lo.Password,'')Password ");
            sb.Append(" FROM f_panel_master fpm INNER JOIN centre_master cm ON fpm.CentreID=cm.CentreID AND fpm.PanelType='Centre'  ");
            sb.Append(" LEFT JOIN f_login lo ON lo.EmployeeID=fpm.Employee_ID AND lo.CentreID=cm.CentreID WHERE  cm.CentreID=@CentreID");
            sb.Append(" ");

            using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(), new MySqlParameter("@CentreID", CentreID)).Tables[0])
            {
                if (dt.Rows.Count > 0)
                {
                    DataSet ds = new DataSet();

                    dt.TableName = "CentreMaster";
                    ds.Tables.Add(dt.Copy());

                    // ds.WriteXmlSchema(@"E:/CentreWelcomeLetter.xml");

                    obj1.Load(Server.MapPath("~/Reports/CentreWelcomeLetter.rpt"));
                    obj1.SetDataSource(ds);
                    m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                    byte[] byteArray = new byte[m.Length];
                    m.Read(byteArray, 0, Convert.ToInt32(m.Length - 1));

                    Response.ClearContent();
                    Response.ClearHeaders();
                    Response.Buffer = true;
                    Response.ContentType = "application/pdf";

                    Response.BinaryWrite(byteArray);
                    Response.Flush();
                    Response.Close();
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
            obj1.Close();
            obj1.Dispose();
            m.Flush();
            m.Close();
            m.Dispose();
            con.Close();
            con.Dispose();
        }
    }
}