using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;

public partial class Design_Finanace_ExportToExcel : System.Web.UI.Page
{
    public override void VerifyRenderingInServerForm(Control control)
    {
        return;
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindData();
            string Period="";
            string ReportName = Session["ReportName"].ToString();
        
            if (Session["Period"] != null)
                Period = Session["Period"].ToString();
            else
                Period = "";

            lblHeader.Text = ReportName;
            lblPeriod.Text = Period;
          

        }
    }
    protected void BindData()
    {
        lblmsg.Text = "";
        try
        {
            DataTable dt = ((DataTable)Session["dtExport2Excel"]);            
            EmployeeGrid.DataSource = dt;
            EmployeeGrid.DataBind();
            if (EmployeeGrid.Rows.Count > 0)
            {
                btnExport.Visible = true;
            }
            else
            {
                btnExport.Visible = false;
            }
        }
        catch (Exception ex)
        {

            lblmsg.Text = ex.Message;
        }
        finally
        {
            Session["dtExport2Excel"] = "";
            Session.Remove("dtExport2Excel");
        }
    }
    protected void btnExport_Click(object sender, EventArgs e)
    {
        
        btnExport.Visible = false;
        lblmsg.Visible = false;

        string ReportName = Session["ReportName"].ToString();        

        Response.Clear();
      //   application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
        Response.AddHeader("content-disposition", "attachment;filename=" + ReportName + ".xls");
        Response.Charset = "";        
       Response.ContentType = "application/vnd.xls";        
              
        StringWriter StringWriter = new System.IO.StringWriter();
        HtmlTextWriter HtmlTextWriter = new HtmlTextWriter(StringWriter);
        this.RenderControl(HtmlTextWriter);
        //EmployeeGrid.RenderControl(HtmlTextWriter);
        Response.Write(StringWriter.ToString());
        Response.End();

        Session["dtExport2Excel"] = "";
        Session.Remove("dtExport2Excel");

        Session["ReportName"] = "";
        Session.Remove("ReportName");

        Session["Period"] = "";
        Session.Remove("Period");

        btnExport.Visible = true;
        lblmsg.Visible = true;

    }


}
