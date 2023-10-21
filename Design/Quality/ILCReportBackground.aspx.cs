using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Quality_ILCReportBackground : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string centreID = Request.QueryString["centreID"];
            DataTable dt = StockReports.GetDataTable("select centre,centreid,ILCReportBackGroundImage from centre_master where centreid='" + centreID + "'");

            if (dt.Rows.Count > 0)
            {
                ddlcentre.DataSource = dt;
                ddlcentre.DataValueField = "centreid";
                ddlcentre.DataTextField = "centre";
                ddlcentre.DataBind();

                lbfilename.Text = dt.Rows[0]["ILCReportBackGroundImage"].ToString();
                lblfilepath.Text = "App_Images/ILCReportBackGround";
                img.ImageUrl = "../../" + lblfilepath.Text + "/" + lbfilename.Text;
            }
        }
    }
    protected void btn_Click(object sender, EventArgs e)
    {
        if (file.HasFile)
        {
            string RootDir = Server.MapPath("~/App_Images/ILCReportBackGround");
            Random r = new Random();
            string filename = "ILCReportLetterHead_" + r.Next(10, 1000);
            string fileExt = System.IO.Path.GetExtension(file.FileName);
            string FileName = filename + fileExt;
            file.SaveAs(RootDir + @"\" + FileName);

            StockReports.ExecuteDML("update centre_master set ILCReportBackGroundImage='" + FileName + "' where centreid='" + ddlcentre.SelectedValue + "'");

            img.ImageUrl = "../../" + "App_Images/ILCReportBackGround" + "/" + FileName;
            lbfilename.Text = FileName;

        }
        else
        {
            lb.Text = "Please Upload File";
        }
    }
}