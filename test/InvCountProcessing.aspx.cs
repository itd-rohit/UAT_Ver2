using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_OPD_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            txtfromdate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            txttodate.Text = DateTime.Now.ToString("dd-MMM-yyyy");
            binddept();
            bindcentre();

        }
    }
    void bindcentre()
    {
        ddlcentre.DataSource = StockReports.GetDataTable("SELECT centreid,centre FROM centre_master WHERE  isactive=1 ORDER BY centre");
        ddlcentre.DataTextField = "centre";
        ddlcentre.DataValueField = "centreid";
        ddlcentre.DataBind();
        ddlcentre.Items.Insert(0, new ListItem("Select", "0"));
    }
    void binddept()
    {
        ddldepartment.DataSource = StockReports.GetDataTable("select SubCategoryID,name from f_subcategorymaster where SubCategoryID<>'LSHHI24' and active=1 order by name");
        ddldepartment.DataTextField = "name";
        ddldepartment.DataValueField = "SubCategoryID";
        ddldepartment.DataBind();
        ddldepartment.Items.Insert(0, new ListItem("Select", "0"));
    }

    protected void btnsearch_Click(object sender, EventArgs e)
    {
        DataTable dtme = getreport();
        if (dtme.Rows.Count > 0)
        {
            DataTable dt = changedatatablepaneldetail1(dtme, "Department");

            lblMsg.Text = "";
            grd.DataSource = dt;
            grd.DataBind();

            try
            {
                int i = 0;
                int j = 0;
                int sum = 0;
                for (i = 2; i <= dt.Columns.Count - 1; i++)
                {
                    for (j = 0; j <= dt.Rows.Count - 1; j++)
                    {
                        sum += Util.GetInt(dt.Rows[j][i].ToString());
                    }
                    grd.FooterRow.Cells[0].Text = "Total";
                    grd.FooterRow.Cells[i].Text = sum.ToString();
                    sum = 0;
                }
            }
            catch
            {
            }
        }
        else
        {
            grd.DataSource = "";
            grd.DataBind();
            lblMsg.Text = "No Record Found..!";
            return;
        }
    }
    DataTable changedatatablepaneldetail1(DataTable dt, string type)
    {
        try
        {
            DataTable dtc = new DataTable();
            dtc.Columns.Add("Department");
            dtc.Columns.Add("TestName");


            DataView dv = dt.DefaultView.ToTable(true, "day").DefaultView;
            dv.Sort = "day asc";
            DataTable day = dv.ToTable();

            foreach (DataRow dw in day.Rows)
            {
                dtc.Columns.Add(dw["day"].ToString());
            }
            dtc.Columns.Add("Total");

            DataView dvmonth = dt.DefaultView.ToTable(true, "Department", "TestName").DefaultView;
            dvmonth.Sort = "Department,TestName asc";
            DataTable dept = dvmonth.ToTable();



            foreach (DataRow dw in dept.Rows)
            {
                DataRow dwr = dtc.NewRow();
                dwr["Department"] = dw["Department"].ToString();
                dwr["TestName"] = dw["TestName"].ToString();



                DataRow[] dwme = dt.Select("TestName='" + dw["TestName"].ToString() + "'");
                int a = 0;
                foreach (DataRow dwm in dwme)
                {
                    dwr[dwm["day"].ToString()] = dwm["CountMe"].ToString();
                    int c = 0;
                    if (int.TryParse(dwm["CountMe"].ToString(), out c))
                    {
                        a = a + c;
                    }
                }
                dwr["Total"] = a.ToString();
                dtc.Rows.Add(dwr);

            }


         

            return dtc;

        }
        catch (Exception ex)
        {
            return dt;
        }

    }


    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (grd.Rows.Count == 0)
        {
            lblMsg.Text = "No Data To Export..!";
            return;

        }
        //string filename = "DoctorShare" + ".xls";
        Response.ClearContent();

        Response.AddHeader("content-disposition", "attachment; filename=InvCountdayWise.xls");


        Response.ContentType = "application/excel";
        StringWriter sw = new StringWriter();
        HtmlTextWriter htw = new HtmlTextWriter(sw);
        grd.RenderControl(htw);
        //grdallshare.RenderControl(htw);
        string style = @"<style> td { mso-number-format:\@;} </style>";
        // Response.Write(style);
        Response.Write(sw.ToString());
        Response.End();
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        /* Confirms that an HtmlForm control is rendered for the specified ASP.NET
           server control at run time. */
    }

    public DataTable getreport()
    {
        string fromdate = Util.GetDateTime(txtfromdate.Text).ToString("yyyy-MM-dd") + " 00:00:00";
        string todate = Util.GetDateTime(txttodate.Text).ToString("yyyy-MM-dd") + " 23:59:59";
        StringBuilder sb;
        MySqlConnection con = Util.GetMySqlCon();
        con.Open();
        try
        {           
            sb = new StringBuilder();
            sb.Append(" SELECT plo.SubcategoryName Department, ");
            sb.Append(" concat(plo.ItemCode,'-', plo.ItemName) TestName, ");
            sb.Append(" day(plo.ApprovedDate) Day,count(plo.investigation_id ) CountMe,plo.investigation_id,plo.`SubCategoryID`  ");
            sb.Append(" from patient_labinvestigation_opd  plo  ");

            sb.Append(" where plo.IsActive = 1 AND plo.IsSampleCollected='Y' and plo.Approved=1 and plo.`SubCategoryID`!=15 ");
            sb.Append(" AND plo.ApprovedDate >=@fromdate  AND  plo.ApprovedDate <=@todate ");
            if (ddlcentre.SelectedValue != "0")
            {
                if (rblcentreType.SelectedValue == "0")
                    sb.Append(" and plo.centreid=@centreid ");
                else
                    sb.Append(" and plo.TestCentreID=@centreid ");
            }         
            if (ddldepartment.SelectedValue != "0")
            {
                sb.Append("  and plo.`SubCategoryID`=@SubCategoryID ");
            }
            sb.Append(" GROUP BY plo.investigation_id,day(plo.ApprovedDate) ");
            sb.Append(" ORDER BY day(plo.ApprovedDate),TestName");

            using (DataTable dtme = MySqlHelper.ExecuteDataset(con, CommandType.Text, sb.ToString(),
                            new MySqlParameter("@fromdate", fromdate),
                            new MySqlParameter("@todate", todate),
                            new MySqlParameter("@centreid", ddlcentre.SelectedValue),
                            new MySqlParameter("@SubCategoryID", ddldepartment.SelectedValue)).Tables[0])
                return dtme;                  
        }
        catch (Exception ex)
        {
            return null;
        }
        finally
        {
            con.Close();
            con.Dispose();
        }
    }

    protected void btnPdf_Click(object sender, EventArgs e)
    {
        DataTable dt = getreport();
        if (dt.Rows.Count > 0)
        {
            Session["dtinvCount"] = dt;
            ScriptManager.RegisterStartupScript(this, this.GetType(), "Key1", "window.open('InvCountProcessingPdf.aspx');", true);
        }
        else
            lblMsg.Text = "No Record Found..!";
    }
}