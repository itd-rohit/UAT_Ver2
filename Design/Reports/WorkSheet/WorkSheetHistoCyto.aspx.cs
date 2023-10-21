using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

public partial class Design_Lab_WorkSheetHistoCyto : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            dtFrom.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            dtTo.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            //bindcentre();
            //BindDepartment();
        }
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
       MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        lblMsg.Text = "";
        try
        {
            StringBuilder sb = new StringBuilder();
        sb.Append(" SELECT ReslideOption isreslide, plo.barcodeno, plo.slidenumber testid, cm.centre centrename, DATE_FORMAT(plo.date,'%d/%m/%Y') grossdate,plo.ledgertransactionno labno, ");
        sb.Append(" lt.pname,im.name testname,plg.blockid,pls.slideno,pls.slidecomment ");
        sb.Append(" FROM patient_labinvestigation_opd plo ");
        sb.Append(" INNER JOIN f_ledgertransaction lt ON lt.ledgertransactionid=plo.ledgertransactionid and ReportType=7 ");
        sb.Append(" inner join centre_master cm on cm.centreid=plo.TestCentreID and plo.TestCentreID=@TestCentreID");
        sb.Append(" INNER JOIN investigation_master im ON im.investigation_id=plo.investigation_id ");
        sb.Append(" left JOIN patient_labhisto_gross plg ON plo.test_id=plg.testid ");
        sb.Append(" left JOIN patient_labhisto_slides pls ON pls.testid=plg.testid AND plg.blockid=pls.blockid ");
        sb.Append(" where plo.date>=@fromdate  ");
        sb.Append(" and plo.date<=@todate ");

        if (ddltype.SelectedValue == "SlideComplete")
        {
            sb.Append(" and plo.HistoCytoStatus='SlideComplete' ");
        }
        else{
            sb.Append(" and plo.HistoCytoStatus<>'SlideComplete' ");
        }
        sb.Append(" ORDER BY plg.entrydate,plo.ledgertransactionno ,plg.id,pls.id ");

      using(DataTable dt =MySqlHelper.ExecuteDataset(con,CommandType.Text,sb.ToString(),
          new MySqlParameter("@fromdate",string.Concat(Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") , " 00:00:00")),
           new MySqlParameter("@todate",string.Concat(Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") , " 23:59:59")),
           new MySqlParameter("@TestCentreID", UserInfo.Centre)).Tables[0])
          if (dt.Rows.Count > 0)
          {
              lblMsg.Text = "";
              if (rblreportformat.SelectedValue == "1")
              {
                  DataColumn dc = new DataColumn();
                  dc.ColumnName = "Period";
                  dc.DefaultValue = "Period From : " + dtFrom.Text + " To : " + dtTo.Text;
                  dt.Columns.Add(dc);
      
                  Session["dtworksheethistocyto"] = dt;
                  ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('../../../Design/Reports/WorkSheet/WorkSheetHistoCytoPdf.aspx');", true);
              }
              else
              {
                  Session["dtExport2Excel"] = dt;
                  Session["ReportName"] = "Work Sheet Histo";
                  Response.Redirect("../../common/ExportToExcel.aspx");
              }
          }
          else
          {
              lblMsg.Text = "No Data Found..!";
          }
        }
        catch(Exception ex)
        {
        }
        finally
        {
            con.Close();
            con.Dispose();
        }        
    }
}