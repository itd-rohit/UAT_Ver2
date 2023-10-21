using CrystalDecisions.CrystalReports.Engine;
using MySql.Data.MySqlClient;
using Newtonsoft.Json;
using System;
using System.Data;

public partial class Design_Master_CentreMasterReport : System.Web.UI.Page
{
    protected void Page_Load()
    {
        if (!IsPostBack)
        {
            string LogID = Util.GetString(Common.Decrypt(Request.QueryString["LogID"]));

            bindCentre(LogID);
        }
    }

    private void bindCentre(string LogID)
    {
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();

        try
        {
            DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, "SELECT CentreID,Centre_master_log,f_panel_master_log,LogType,CreatedBy ,DATE_FORMAT(CreatedDate,'%d-%b-%Y')CreatedDate FROM Centre_master_log log  WHERE log.ID=@ID ",
               new MySqlParameter("@ID", LogID)).Tables[0];

            DataTable dt2 = (DataTable)JsonConvert.DeserializeObject(dt.Rows[0]["f_panel_master_log"].ToString(), (typeof(DataTable)));
            DataTable dt3 = (DataTable)JsonConvert.DeserializeObject(dt.Rows[0]["Centre_master_log"].ToString(), (typeof(DataTable)));

            dt2.Rows[0]["IntimationLimit"] = Util.GetString(Util.GetDecimal(dt2.Rows[0]["IntimationLimit"].ToString()) * Util.GetDecimal(-1));
            dt2.Rows[0]["CreditLimit"] = Util.GetString(Util.GetDecimal(dt2.Rows[0]["CreditLimit"].ToString()) * Util.GetDecimal(-1));
            dt2.Rows[0]["LabReportLimit"] = Util.GetString(Util.GetDecimal(dt2.Rows[0]["LabReportLimit"].ToString()) * Util.GetDecimal(-1));
            using (DataColumn dc = new DataColumn() { ColumnName = "Invoice", DefaultValue = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Company_Name FROM f_panel_master fpm WHERE fpm.Panel_ID=@InvoiceTo", new MySqlParameter("@InvoiceTo", dt2.Rows[0]["InvoiceTo"])) })
            {
                dt2.Columns.Add(dc);
            }

            using (DataColumn dc1 = new DataColumn() { ColumnName = "MRP", DefaultValue = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Company_Name FROM f_panel_master fpm WHERE fpm.Panel_ID=@PanelID_MRP", new MySqlParameter("@PanelID_MRP", dt2.Rows[0]["ReferringMrpID"])) })
            {
                dt2.Columns.Add(dc1);
            }

            using (DataColumn dc2 = new DataColumn() { ColumnName = "PatientNetRate", DefaultValue = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Company_Name FROM f_panel_master fpm WHERE fpm.Panel_ID=@ReferenceCode", new MySqlParameter("@ReferenceCode", dt2.Rows[0]["ReferenceCode"])) })
            {
                dt2.Columns.Add(dc2);
            }

            using (DataColumn dc3 = new DataColumn() { ColumnName = "PanelShare", DefaultValue = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Company_Name FROM f_panel_master fpm WHERE fpm.Panel_ID=@PanelShareID", new MySqlParameter("@PanelShareID", dt2.Rows[0]["ReferringShareID"])) })
            {
                dt2.Columns.Add(dc3);
            }

            using (DataColumn dc4 = new DataColumn() { ColumnName = "LogisticRate" })
            {
                if (dt2.Rows[0]["IsLogisticExpense"] == "1")
                {
                    dc4.DefaultValue = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Company_Name FROM f_panel_master fpm WHERE fpm.Panel_ID=@LogisticExpenseRateType",
                       new MySqlParameter("@LogisticExpenseRateType", dt2.Rows[0]["LogisticExpenseRateType"]));
                }
                else
                {
                    dc4.DefaultValue = string.Empty;
                }
                dt2.Columns.Add(dc4);
            }

            using (DataColumn dc5 = new DataColumn() { ColumnName = "ExpenseTo" })
            {
                if (dt2.Rows[0]["IsLogisticExpense"] == "1")
                {
                    dc5.DefaultValue = MySqlHelper.ExecuteScalar(con, CommandType.Text, "SELECT Company_Name FROM f_panel_master fpm WHERE fpm.Panel_ID=@LogisticExpenseToPanelID",
                       new MySqlParameter("@LogisticExpenseToPanelID", dt2.Rows[0]["LogisticExpenseToPanelID"]));
                }
                else
                {
                    dc5.DefaultValue = string.Empty;
                }
                dt2.Columns.Add(dc5);
            }

            dt2.AcceptChanges();

            if (dt.Rows.Count > 0)
            {
                DataSet ds = new DataSet();
                dt2.TableName = "PanelMaster";
                dt3.TableName = "CentreMaster";
                ds.Tables.Add(dt2.Copy());
                ds.Tables.Add(dt3.Copy());
                // ds.WriteXmlSchema(@"E:/CentreReport.xml");

                ReportDocument obj1 = new ReportDocument();
                obj1.Load(Server.MapPath("~/Reports/CentreMaster.rpt"));
                obj1.SetDataSource(ds);
                System.IO.Stream m = (System.IO.Stream)obj1.ExportToStream(CrystalDecisions.Shared.ExportFormatType.PortableDocFormat);
                byte[] byteArray = new byte[m.Length];
                m.Read(byteArray, 0, Convert.ToInt32(m.Length - 1));

                obj1.Close();
                obj1.Dispose();
                Response.ClearContent();
                Response.ClearHeaders();
                Response.Buffer = true;
                Response.ContentType = "application/pdf";

                Response.BinaryWrite(byteArray);
                Response.Flush();
                Response.Close();
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
}