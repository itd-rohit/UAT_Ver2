using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;

public partial class Design_Lab_SampleTracking : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {
            if (Request.QueryString["LabNo"] != null)
            {
                using (DataTable barcodegroup = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select lt.LedgerTransactionno,pname,  barcode_group from patient_labinvestigation_opd plo inner join f_ledgertransaction lt on lt.LedgerTransactionID=plo.LedgerTransactionID where lt.LedgerTransactionno=@LabNo",
                      new MySqlParameter("@LabNo", Util.GetString(Common.Decrypt(Request.QueryString["LabNo"])))).Tables[0])
                {
                    if (barcodegroup.Rows.Count > 0)
                    {
                        lbinfo.Text = string.Concat("LabNo.:", barcodegroup.Rows[0]["LedgerTransactionno"].ToString(), "  Patient Name:", barcodegroup.Rows[0]["pname"].ToString());
                        labDetailPatient(barcodegroup.Rows[0]["LedgerTransactionno"].ToString(), con);
                    }
                    else
                    {
                        lblerrmsg.Text = "No Status Found 1";
                        grd.DataSource = null;
                        grd.DataBind();
                    }
                }
            }
            else
            {
                using (DataTable barcodegroup = MySqlHelper.ExecuteDataset(con, CommandType.Text, "select plo.barcodeno,pname,  Test_id from patient_labinvestigation_opd plo inner join f_ledgertransaction lt on lt.LedgerTransactionID=plo.LedgerTransactionID where Test_id=@barcodeno",
                      new MySqlParameter("@barcodeno", Util.GetString(Common.Decrypt(Request.QueryString["barcodeno"])))).Tables[0])
                {
                    if (barcodegroup.Rows.Count > 0)
                    {
                        lbinfo.Text = string.Concat("SIN No.:", barcodegroup.Rows[0]["barcodeno"].ToString(), "  Patient Name:", barcodegroup.Rows[0]["pname"].ToString());
                        labDetail(barcodegroup.Rows[0]["Test_id"].ToString(), con);
                    }
                    else
                    {
                        lblerrmsg.Text = "No Status Found 2";
                        grd.DataSource = null;
                        grd.DataBind();
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

    public void labDetail(string BarcodeNo, MySqlConnection con)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DATE_FORMAT(plis.dtEntry,'%d-%b-%Y %h:%i %p')EntryDate, ");
        sb.Append(" (SELECT CONCAT(em.Title,' ',Em.Name)EntryBy FROM employee_master em WHERE em.employee_id=plis.UserID)EntryBy, ");
        sb.Append(" plis.Status, ");
        sb.Append(" (SELECT Centre FROM centre_master cm WHERE cm.CentreID=plis.CentreID)CentreName ");
        sb.Append(" FROM patient_labinvestigation_opd_update_status plis  ");
        sb.Append(" WHERE plis.Test_ID=@BarcodeNo  order by  ID ");// ( select plo.Test_ID from patient_labinvestigation_opd plo where  plo.Test_ID=@BarcodeNo ) 
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@BarcodeNo", BarcodeNo)).Tables[0])
        {

            if (dt.Rows.Count == 0)
            {
                lblerrmsg.Text = "No Status Found";
            }

            grd.DataSource = dt;
            grd.DataBind();
        }

    }
    public void labDetailPatient(string LabNo, MySqlConnection con)
    {

        StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT DATE_FORMAT(plis.dtEntry,'%d-%b-%Y %h:%i %p')EntryDate, ");
        sb.Append(" (SELECT CONCAT(em.Title,' ',Em.Name)EntryBy FROM employee_master em WHERE em.employee_id=plis.UserID)EntryBy, ");
        sb.Append(" plis.Status, ");
        sb.Append(" (SELECT Centre FROM centre_master cm WHERE cm.CentreID=plis.CentreID)CentreName ");
        sb.Append(" FROM patient_labinvestigation_opd_update_status plis  ");
        sb.Append(" WHERE plis.Ledgertransactionno=@LabNo  order by  ID ");//and (ifnull(BarcodeNo,'')='' or status  like'%Added New Item%' ) and status not like '%Registration Done%'
        using (DataTable dt = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
              new MySqlParameter("@LabNo", LabNo)).Tables[0])
        {

            if (dt.Rows.Count == 0)
            {
                lblerrmsg.Text = "No Status Found 4";
            }

            grd.DataSource = dt;
            grd.DataBind();
        }

    }
}