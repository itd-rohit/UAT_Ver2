using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using MySql.Data.MySqlClient;
using HTMLReportEngine;
using HiQPdf;
using System.Web.Services;
using System.Web.Script.Services;
using System.Text.RegularExpressions;
public partial class Design_Dashboard_Reports : System.Web.UI.Page
{
    static string qry =string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            string RoleId = "";
            if (Util.GetString(Session["RoleID"]) != "" && Util.GetString(Session["RoleID"]) != null)
            RoleId = Util.GetString(Session["RoleID"]);

            dtFrom.Text = DateTime.Now.ToString("yyyy-MM-dd");
            dtTo.Text = DateTime.Now.ToString("yyyy-MM-dd");
            ddlReport.DataSource = StockReports.GetDataTable("SELECT `id`,`ReportName` FROM `dashboard_report_master` WHERE isActive=1 and  FIND_IN_SET('"+RoleId+"',RoleId) ORDER BY ReportName ");
            ddlReport.DataTextField = "ReportName";
            ddlReport.DataValueField = "id";
            ddlReport.DataBind();
            ddlReport.Items.Insert(0, new ListItem("Select Report", ""));

            this.Form.Target = "_blank";
            this.Form.Action = "output.aspx";





            //lblCentre.DataSource = StockReports.GetDataTable("SELECT CentreID,Concat(CentreCode,' = ',Centre) Centre FROM centre_master  WHERE isActive='1' order by centrecode,centre");
lblCentre.DataSource = StockReports.GetDataTable("SELECT CentreID,Concat(CentreCode,' = ',Centre) Centre FROM centre_master  WHERE isActive='1' order by centrecode,centre");

        //    lblCentre.DataSource = StockReports.GetDataTable("SELECT  CM.CentreID,Concat(CM.CentreCode,' = ',CM.Centre) Centre FROM centre_master cm INNER JOIN f_panel_master pm ON PM.Centreid=CM.Centreid   where ( cm.CentreID in (select CentreAccess from centre_access where CentreID ='" + UserInfo.Centre + "' ) or cm.CentreID ='" + UserInfo.Centre + "') and cm.isActive=1 GROUP BY  cm.CentreCode ORDER BY cm.CentreCode");
                       

lblCentre.DataTextField = "Centre";
            lblCentre.DataValueField = "CentreID";
            lblCentre.DataBind();


            lblDept.DataSource = StockReports.GetDataTable("select distinct sc.SubCategoryID,sc.name Description from f_configrelation c inner join f_subcategorymaster sc on sc.CategoryID = c.CategoryID  where ConfigRelationID=3 and sc.Active=1  order by sc.name ");
            lblDept.DataTextField = "Description";
            lblDept.DataValueField = "SubCategoryID";
            lblDept.DataBind();

            StringBuilder sb = new StringBuilder();
            //sb.Append(" SELECT pn.Company_Name,pn.Panel_ID  FROM Centre_Panel cp ");
            //sb.Append(" INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id WHERE cp.CentreId='" + Centre.Id + "' AND pn.PanelGroupid='4' AND cp.isActive=1 ORDER BY isDefault DESC,Company_Name ");
            sb.Append("SELECT Concat(Panel_Code,' = ',Company_Name) Company_Name,Panel_id FROM f_panel_master where panel_id<>referencecodeopd and isactive=1  ORDER BY panel_code,Company_Name");


            
            
            
            
            
            
            
            //lblPanel.DataSource = StockReports.GetDataTable(sb.ToString());
            //lblPanel.DataTextField = "Company_Name";
            //lblPanel.DataValueField = "Panel_ID";
            //lblPanel.DataBind();

            //lblItem

            lblItem.DataSource = StockReports.GetDataTable(" SELECT im.ItemID,Concat(im.TestCode,' = ',im.TypeName)TypeName FROM f_itemmaster im INNER JOIN f_subcategorymaster scm ON scm.SubCategoryID=im.SubCategoryID AND im.IsActive=1 AND scm.CategoryID IN ('LSHHI3','LSHHI44')  AND im.TypeName NOT IN ('','.')  ORDER BY im.testcode, im.TypeName ");
            lblItem.DataTextField = "TypeName";
            lblItem.DataValueField = "ItemID";
            lblItem.DataBind();





            lblUser.DataSource = StockReports.GetDataTable("SELECT DISTINCT CONCAT(flg.username,'-',em.Title,' ',NAME)AS NAME,em.Employee_ID FROM employee_master em INNER JOIN f_login flg ON flg.EmployeeID = em.Employee_ID  ");
                lblUser.DataTextField = "Name";
                lblUser.DataValueField = "Employee_ID";
                lblUser.DataBind();


        }
    }

    

    protected void btnReport_Click(object sender, EventArgs e)
    {
        if (ddlReport.SelectedValue == "")
        {
            lblMsg.Text = "Select report";
            return;
        }
        else
            lblMsg.Text = "";

        string ReportId = ddlReport.SelectedValue;
        string ReportName = "";
        DataTable dtReport = StockReports.GetDataTable("select ReportSql,ReportName from dashboard_report_master where id=" + ReportId);

        ReportName = dtReport.Rows[0]["ReportName"].ToString();


        StringBuilder sb = new StringBuilder();
        sb.Append(dtReport.Rows[0]["ReportSql"].ToString());



        dtReport = new DataTable();
        DataSet ds = new DataSet();
        MySqlConnection con = new MySqlConnection();
        con = Util.GetMySqlCon();

        MySqlCommand cmd = new MySqlCommand(sb.ToString());

      //  cmd.Parameters.AddWithValue("@dtFrom",dtFrom.Text);
      //  cmd.Parameters.AddWithValue("@dtTo", dtTo.Text);

cmd.Parameters.AddWithValue("@dtFrom", Util.GetDateTime(dtFrom.Text).ToString("yyyy-MM-dd") + " 00:00:00");
        cmd.Parameters.AddWithValue("@dtTo",  Util.GetDateTime(dtTo.Text).ToString("yyyy-MM-dd") + " 11:59:59");



        MySqlDataAdapter da = new MySqlDataAdapter();
        cmd.CommandType = CommandType.Text;
        cmd.Connection = con;
    
        con.Open();
        da.SelectCommand = cmd;
        da.Fill(ds);
        da.Dispose();
        cmd.Dispose();
        

        
        
        //ds.Tables.Add(dtReport);
        //ds.Tables[0].TableName=ddlReport.SelectedItem.Text;


        Report report = new Report();
        report.ReportTitle =ddlReport.SelectedItem.Text;

        report.ReportSource = ds ;

        foreach(DataColumn dc in ds.Tables[0].Columns)
            report.ReportFields.Add(new Field(dc.ColumnName, dc.ColumnName));

        
        if(ds.Tables[0].Rows.Count==0)
        {
            lblMsg.Text = "No record found.";
            return;
        }
        else
            lblMsg.Text = "";

        
        
        //lblReport.Text = report.GenerateReport();
        //ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "openReport('" + report.GenerateReport() + "');", true);



        PdfDocument document = new PdfDocument();
        document.SerialNumber = "g8vq0tPn-5c/q4fHi-8fq7rbOj-sqO3o7uy-t6Owsq2y-sa26urq6";
        PdfPage page1 = document.AddPage(PdfPageSize.A4, PdfDocumentMargins.Empty);

        PdfHtml html1 = new PdfHtml();
        html1 = new PdfHtml(5, 5, 580, report.GenerateReport(), null);
        html1.PageCreatingEvent += new PdfPageCreatingDelegate(htmlToPdfConverter_PageCreatingEvent);
        html1.FontEmbedding = false;
        html1.BrowserWidth = 850;
        page1.Layout(html1);

        try
        {
            // write the PDF document to a memory buffer
            byte[] pdfBuffer = document.WriteToMemory();



            // inform the browser about the binary data format
            HttpContext.Current.Response.AddHeader("Content-Type", "application/pdf");

            //// let the browser know how to open the PDF document and the file name
            //HttpContext.Current.Response.AddHeader("Content-Disposition", String.Format("attachment; filename=PdfText.pdf; size={0}",
            //            pdfBuffer.Length.ToString()));

            HttpContext.Current.Response.AddHeader("Content-Disposition", String.Format("attachment; filename="+ddlReport.SelectedItem.Text+".pdf; size={0}",
                                    pdfBuffer.Length.ToString()));

            // write the PDF buffer to HTTP response
            HttpContext.Current.Response.BinaryWrite(pdfBuffer);

            // call End() method of HTTP response to stop ASP.NET page processing
            HttpContext.Current.Response.End();

        }

        finally
        {

            document.Close();


        }

    }


    void htmlToPdfConverter_PageCreatingEvent(PdfPageCreatingParams eventParams)
    {

        PdfPage page1 = eventParams.PdfPage;
        page1.CreateFooterCanvas(20);
        page1.CreateHeaderCanvas(20);

    }


    [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string getReportInfo(string ReportID)
    {
        DataTable dtInfo = new DataTable();
        dtInfo.Columns.Add("Filter");
        dtInfo.Columns.Add("Columns");
        dtInfo.Columns.Add("GroupBy");
        


        DataTable dt = StockReports.GetDataTable("select * from dashboard_report_master where id="+ReportID);
        dt.TableName = "ReportInfo";
        
        string Filter = "";
        foreach (Match match in Regex.Matches(dt.Rows[0]["ReportSql"].ToString(), "(\\@\\w+)"))
        {
            //Console.WriteLine(match.Groups[1].Value);
            Filter = Filter + "," + match.Groups[1].Value.Replace("@", ""); 
        }
        Filter = Filter.TrimEnd(',').TrimStart(',');

        string Col = "";


        //DataTable dtColumn = StockReports.GetDataTable(dt.Rows[0]["ReportSql"].ToString());
        //foreach (DataColumn dc in dtColumn.Columns)
        //{
        //    Col = Col + "," + dc.ColumnName;
        //}

        //Col = Col.TrimEnd(',').TrimStart(',');

        DataRow dr = dtInfo.NewRow();
        dr["Filter"] = Filter;
        dr["Columns"] = Col;
        dr["GroupBy"] = "";
        dtInfo.Rows.Add(dr);

        return Newtonsoft.Json.JsonConvert.SerializeObject(dtInfo);
    }



    [WebMethod]
    public static string bindPanel(string type)
    {
        StringBuilder sb = new StringBuilder();
        //sb.Append(" SELECT pn.Company_Name,pn.Panel_ID  FROM Centre_Panel cp ");
        //sb.Append(" INNER JOIN f_panel_master pn ON cp.PanelId=pn.panel_id WHERE cp.CentreId='" + Centre.Id + "' AND pn.PanelGroupid='4' AND cp.isActive=1 ORDER BY isDefault DESC,Company_Name ");



        if (type == "PUP Special Test Report")
        {
            sb.Append("SELECT Concat(Panel_Code,' = ',Company_Name) Company_Name,Panel_id FROM f_panel_master ");
            sb.Append(" WHERE Panel_ID=ReferenceCode AND TagProcessingLabID IN (SELECT CentreID FROM centre_master WHERE   ");

            sb.Append(" IsActive=1 AND PanelType='PUP'  AND IsActive=1  ) ORDER BY Company_Name");
        }
        else if (type == "PCC Special Test Report")
        {
            sb.Append("SELECT  Concat(fpm.Panel_Code,' = ',fpm.Company_Name) Company_Name,fpm.Panel_id FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID ");
            sb.Append(" WHERE     ");

            sb.Append(" cm.IsActive=1  AND cm.type1='PCC' ORDER BY fpm.Company_Name");
        }
        else if (type == "PCL Special Test Report")
        {
            sb.Append("SELECT Concat(fpm.Panel_Code,' = ',fpm.Company_Name) Company_Name,fpm.Panel_id FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID ");
            sb.Append(" WHERE   ");

            sb.Append("  cm.IsActive=1  AND cm.type1='PCL' ORDER BY fpm.Company_Name");
        }
        else if (type == "DDC Special Test Report")
        {
            sb.Append("SELECT Concat(fpm.Panel_Code,' = ',fpm.Company_Name) Company_Name,fpm.Panel_id FROM centre_master cm INNER JOIN f_panel_master fpm ON cm.CentreID=fpm.CentreID ");
            sb.Append(" WHERE     ");

            sb.Append("  cm.IsActive=1  AND cm.type1='DDC' ORDER BY fpm.Company_Name");
        }
        else if (type == "PUP Details Before Creation")
        {
            sb.Append("SELECT `Company_Name`,Company_Name Panel_id FROM sales_enrolment_master WHERE  panel_id IS NULL AND isactive=1");

        }
        else
        {
            sb.Append("SELECT Concat(Panel_Code,' = ',Company_Name) Company_Name,Panel_id FROM f_panel_master where panel_id<>referencecodeopd and isactive=1  ORDER BY panel_code,Company_Name");
        }

        using (DataTable dt = StockReports.GetDataTableReadOnly(sb.ToString()))
        {
            if (dt.Rows.Count > 0)
                return Util.getJson(dt);
            else
                return string.Empty;
        }
    }



     [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string BindInlineReport(string Report)
    {
        string rtrn = "";
        string str = "SELECT ReportSql FROM dashboard_report_master WHERE ReportName='" + Report + "'";
        using (DataTable dt = StockReports.GetDataTable(str))
        {
            if (dt.Rows.Count > 0)
            {
                 qry = dt.Rows[0][0].ToString();

                if (qry.Contains("@dtFrom"))
                {
                    rtrn += "@dtFrom,";
                }
                if (qry.Contains("@dtTo"))
                {
                    rtrn += "@dtTo,";
                }
                if (qry.Contains("@Centre"))
                {
                    rtrn += "@Centre,";
                }
                if (qry.Contains("@Panel"))
                {
                    rtrn += "@Panel,";
                }
                if (qry.Contains("@Item"))
                {
                    rtrn += "@Item,";
                }
                if (qry.Contains("@User"))
                {
                    rtrn += "@User,";
                }
            }
           
            return rtrn;
        }
    }
      [WebMethod]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
     public static string GetInlineReport(string ReportFilters)
    {
          string[] filters=ReportFilters.Split('#');

        if (qry.Contains("@dtFrom"))
        {
            for(int i=0;i<filters.Length;i++)
            {
                if (filters[i].Contains("@dtFrom"))
                {
                  // qry = qry.Replace("@dtFrom", "'" + filters[i].Split('~')[1] + "'");
 string fromdate = Util.GetDateTime(filters[i].Split('~')[1]).ToString("yyyy-MM-dd") + " 00:00:00";
                    qry = qry.Replace("@dtFrom", "'" + fromdate + "'");

                }
            }
        }
        if (qry.Contains("@dtTo"))
        {
            for (int i = 0; i < filters.Length; i++)
            {
                if (filters[i].Contains("@dtTo"))
                {
                 //  qry = qry.Replace("@dtTo", "'" + filters[i].Split('~')[1] + "'");
 string todate = Util.GetDateTime(filters[i].Split('~')[1]).ToString("yyyy-MM-dd") + " 23:59:59";
                    qry = qry.Replace("@dtTo", "'" + todate + "'");
 

                }
            }  
        }

        if (qry.Contains("@Centre"))
        {
            for (int i = 0; i < filters.Length; i++)
            {
                if (filters[i].Contains("@Centre"))
                {
                    qry = qry.Replace("@Centre", "" + filters[i].Split('~')[1] + "");

                }
            }
        }
        if (qry.Contains("@Panel"))
        {
            for (int i = 0; i < filters.Length; i++)
            {
                if (filters[i].Contains("@Panel"))
                {
                    qry = qry.Replace("@Panel", "" + filters[i].Split('~')[1] + "");
                }
            }
        }

        if (qry.Contains("@Item"))
        {
            for (int i = 0; i < filters.Length; i++)
            {
                if (filters[i].Contains("@Item"))
                {
                    qry = qry.Replace("@Item", "" + filters[i].Split('~')[1] + "");
                }
            }
        }

        if (qry.Contains("@User"))
        {
            for (int i = 0; i < filters.Length; i++)
            {
                if (filters[i].Contains("@User"))
                {
                    qry = qry.Replace("@User", "" + filters[i].Split('~')[1] + "");
                }
            }
        }

        using (DataTable dt = StockReports.GetDataTableReadOnly(qry))
        {
            string rtrn = Newtonsoft.Json.JsonConvert.SerializeObject(dt);
            return rtrn;
        }
    }

    

   
}