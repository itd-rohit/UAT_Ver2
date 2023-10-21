using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_GRNInvoiceEdit : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    void clear()
    {
        txtchallandate.Text = "";
        txtchallanno.Text = "";
        txtinvoicedate.Text = "";
        txtinvoiceno.Text = "";
        txtgateentryno.Text = "";

        txtgrnid.Text = "";
    }
    protected void btnsearch_Click(object sender, EventArgs e)
    {
        lbmsg.Text = "";
        if (txtgrnno.Text == "")
        {
            lbmsg.Text = "Please Enter GRN No";
            txtgrnno.Focus();
            clear();
            btndata.Visible = false;
            return;
        }


        DataTable dt = StockReports.GetDataTable("select lt.LedgerTransactionID, lt.InvoiceNo,if(lt.InvoiceDate='0001-01-01 00:00:00','', date_format(lt.InvoiceDate,'%d-%b-%Y'))InvoiceDate,lt.ChalanNo,if(lt.ChalanDate='0001-01-01 00:00:00','', date_format(lt.ChalanDate,'%d-%b-%Y'))ChalanDate,lt.GatePassInWard from st_ledgertransaction lt where lt.LedgerTransactionNo='" + txtgrnno.Text + "'");

        if (dt.Rows.Count == 0)
        {
            lbmsg.Text = "Wrong GRN No";
            txtgrnno.Focus();
            clear();
            btndata.Visible = false;
            return;
        }


        txtchallandate.Text = dt.Rows[0]["ChalanDate"].ToString();
        txtchallanno.Text = dt.Rows[0]["ChalanNo"].ToString();
        txtinvoicedate.Text = dt.Rows[0]["InvoiceDate"].ToString();
        txtinvoiceno.Text = dt.Rows[0]["InvoiceNo"].ToString();
        txtgateentryno.Text = dt.Rows[0]["GatePassInWard"].ToString();

        txtgrnid.Text = dt.Rows[0]["LedgerTransactionID"].ToString();
        btndata.Visible = true;


    }
    protected void btnupdate_Click(object sender, EventArgs e)
    {
          if (txtinvoiceno.Text== "" &&  txtchallanno.Text == "") {
               lbmsg.Text = "Please Enter Invoice No or Chalan No";
                return;
          }

          if (txtinvoicedate.Text == "" && txtchallandate.Text == "")
          {
              lbmsg.Text = "Please Select Invoice Date or Chalan Date";
              return;
          }


          StockReports.ExecuteDML(" update st_ledgertransaction set InvoiceNo='" + txtinvoiceno.Text + "',ChalanNo='" + txtchallanno.Text + "',GatePassInWard='" + txtgateentryno.Text + "',InvoiceDate='" + Util.GetDateTime(txtinvoicedate.Text).ToString("yyyy-MM-dd hh:mms:ss") + "',ChalanDate='" + Util.GetDateTime(txtchallandate.Text).ToString("yyyy-MM-dd hh:mms:ss") + "' where LedgerTransactionID='" + txtgrnid.Text + "'");

          lbmsg.Text = "Record Updated";
    }
}