using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Master_ReportBackGound : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string panelid = Common.Decrypt(Request.QueryString["panelid"]);
            DataTable dt = StockReports.GetDataTable("select company_name,panel_id,ReportBackGroundImage from f_panel_master where panel_id='" + panelid + "'");

            if (dt.Rows.Count > 0)
            {
                ddlcentre.DataSource = dt;
                ddlcentre.DataValueField = "panel_id";
                ddlcentre.DataTextField = "company_name";
                ddlcentre.DataBind();

                lbfilename.Text = dt.Rows[0]["ReportBackGroundImage"].ToString();
                lblfilepath.Text = "App_Images/ReportBackGround";
                img.ImageUrl = "../../"+lblfilepath.Text + "/" + lbfilename.Text;
            }
        }
    }
    protected void btn_Click(object sender, EventArgs e)
    {
        if (file.HasFile)
        {
            string RootDir = Server.MapPath("~/App_Images/ReportBackGround");
            Random r = new Random();
            string filename = "ReportLetterHead_" + r.Next(10, 1000);
            string fileExt = System.IO.Path.GetExtension(file.FileName);
            string FileName = filename + fileExt;
	  if (fileExt.ToLower() == ".jpg" || fileExt.ToLower() == ".png" || fileExt.ToLower() == ".jpeg")
            {

            file.SaveAs(RootDir + @"\" + FileName);

            StockReports.ExecuteDML("update f_panel_master set ReportBackGroundImage='" + FileName + "' where panel_id='" + ddlcentre.SelectedValue + "'");

            img.ImageUrl = "../../" + "App_Images/ReportBackGround" + "/" + FileName;
            lbfilename.Text = FileName;
          }
            else {
                lb.Text = "Only Jpg or png files are allowed.";
            }
        }
        else
        {
            lb.Text = "Please Upload File";
        }
    }
}