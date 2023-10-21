using System;
using System.Data;
using System.Web.Script.Services;
using System.Web.Services;
using System.Web;
using System.Web.UI.WebControls;


public partial class Design_Master_PanelLabReportSetting : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblrange.Text = "* Range Height=1754 And Width=1241 *";
            bindpanel();
        }
    }

    private void bindpanel()
    {
        ddlpanel.DataSource = StockReports.GetDataTable("select company_name,panel_id from f_panel_master where isactive=1 order by IF (panel_id='78', -1, company_name) ");
        ddlpanel.DataValueField = "panel_id";
        ddlpanel.DataTextField = "company_name";
        ddlpanel.DataBind();
        ddlpanel.Items.Insert(0, new ListItem("--Select Panel--", "0"));
    }

    [WebMethod(EnableSession = true)]
    [ScriptMethod(ResponseFormat = ResponseFormat.Json)]
    public static string GetAlldata(string panelid)
    {
        DataTable dt = StockReports.GetDataTable(@"SELECT ShowSignature,ShowNABLLogo,ShowBarcode,barcode_x,barcode_y,ReportHeaderHeight,ReportHeaderXPosition,ReportHeaderYPosition,ReportFooterHeight,ReportBackGroundImage
        FROM f_panel_master where panel_id='" + panelid + "'");     
        return Newtonsoft.Json.JsonConvert.SerializeObject(dt);
    }

    protected void btn_Click(object sender, EventArgs e)
    {

        string ReportHeader = "";
      //  ReportHeader = StockReports.ExecuteScalar(" SELECT ReportBackGroundImage FROM f_panel_master where panel_id='" + ddlpanel.SelectedValue + "' ");
        if (chkWithOutHeader.Checked == false)
        {
            if (fuSign.PostedFile.ContentLength > 0)
            {
                // System.Drawing.Image img = System.Drawing.Image.FromStream(fuSign.PostedFile.InputStream);
                // int height = img.Height;
                // int width = img.Width;
                //// decimal size = Math.Round(((decimal)fuSign.PostedFile.ContentLength / (decimal)1024), 2);               
                // if (height > 1754 || width > 1241)
                // {
                //    // ClientScript.RegisterClientScriptBlock(this.GetType(), "alert", "alert('Height: " + height + "\\nWidth: " + width + " Please Add Valid Height Width');", true);
                //     lblMsg.Text = "Please Set Valid Height=1754 And Width=1241 Of Report Header  ";
                //     return;
                // }
                string ext = System.IO.Path.GetExtension(this.fuSign.PostedFile.FileName);

                if (ext == ".jpg" || ext == ".png" || ext == ".jpeg")
                {
                    if (true)
                    {
                    }
                    fuSign.SaveAs(Server.MapPath("~/App_Images/ReportBackGround/" + ddlpanel.SelectedValue + ".jpg"));
                    ReportHeader = "" + ddlpanel.SelectedValue + ".jpg";
                }
                else
                {
                    lblMsg.Text = "Please upload valid image";
                    return;
                }
            }
            else
            {
                lblMsg.Text = "Please upload the Header";
                return;
            }
            StockReports.ExecuteScalar("update f_panel_master set ReportHeaderHeight='" + txtReportHeaderHeight.Text + "' ,ReportHeaderXPosition='" + txtReportHeaderXPosition.Text + "',ReportHeaderYPosition='" + txtReportHeaderYPosition.Text + "',ReportFooterHeight='" + txtReportFooterHeight.Text + "', ReportBackGroundImage='" + ReportHeader + "', ShowSignature='" + ddlShowSignature.SelectedValue + "'   where panel_id='" + ddlpanel.SelectedValue + "'");
        }
        else
        {
            //, ShowBarcode='" + ddlBarcode.SelectedValue + "', barcode_x='" + x_txt.Text + "',barcode_y='" + y_txt.Text + "'
            StockReports.ExecuteScalar("update f_panel_master set ReportHeaderHeight='" + txtReportHeaderHeight.Text + "' ,ReportHeaderXPosition='" + txtReportHeaderXPosition.Text + "',ReportHeaderYPosition='" + txtReportHeaderYPosition.Text + "',ReportFooterHeight='" + txtReportFooterHeight.Text + "',  ShowSignature='" + ddlShowSignature.SelectedValue + "'   where panel_id='" + ddlpanel.SelectedValue + "'");
            chkWithOutHeader.Checked = false;
        }
        lblMsg.Text = "Record Saved";
        bindpanel();
    }

    protected void btnDownloadLetterHead_Click(object sender, EventArgs e)
    {
        string name=HiddenField1.Value;
		if(!name.Contains("~/"))
			name="~/"+name;
          // string filename=Server.MapPath(name);
           string filename=Server.MapPath(name);
           Response.ContentType = "image/JPEG";
           Response.AddHeader("Content-Disposition", "attachment; filename=" + filename+ "");
           Response.TransmitFile(filename);
           Response.End();
           
    }	

}