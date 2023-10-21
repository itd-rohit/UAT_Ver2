using System;
using System.Data;
using System.IO;

public partial class Design_Master_AddReportLetterHead : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["PanelID"] != null)
            {
                lblPanelID.Text = Common.Decrypt(Request.QueryString["PanelID"]);
                DataTable dt = StockReports.GetDataTable(" SELECT fpm.`Panel_ID`,fpm.`Company_Name`,Concat('~/App_Images/ReportBackGround/',fpm.`ReportBackGroundImage`)ReportBackGroundImage FROM f_panel_master fpm WHERE fpm.`Panel_ID`='" + lblPanelID.Text.Trim() + "' AND fpm.`IsActive`=1 ");
                lb.Text = dt.Rows[0]["Company_Name"].ToString();
                lblHeder.Text = "Create Letter Head For " + lb.Text;
                showHeaderFooter(dt.Rows[0]["ReportBackGroundImage"].ToString());
                imgDefaultHeader.ImageUrl = "~/App_Images/ReportBackGround/ReportLetterHead.png";            
            }
        }
    }
    private void showHeaderFooter(string HeaderImage)
    {
        if (HeaderImage != "")
        {
            imgHeader.ImageUrl = HeaderImage;
            div_HeaderFooter.Visible = true;
            imgHeader.Visible = true;
        }
        else
        {
            imgHeader.Visible = false;
            div_HeaderFooter.Visible = false;
        }        
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            string fileFullName = string.Empty;
            int Length = fuHeader.PostedFile.ContentLength;
            if (!fuHeader.HasFile && !chkDefaultHeader.Checked)
            {
                lblMsg.Text = "Please Select Letter Head Image to Upload";
                return;
            }            
            string headerExte = System.IO.Path.GetExtension((fuHeader).PostedFile.FileName);
            if (headerExte != "" && !chkDefaultHeader.Checked)
            {
                if (headerExte != ".jpg" && headerExte != ".jpeg" && headerExte != ".gif" && headerExte != ".JPG")
                {
                    lblMsg.Text = "Wrong File Extension of Selected Header";
                    return;
                }
            }
            string savingPath = "~/App_Images/ReportBackGround";
            bool IsExists = System.IO.Directory.Exists(Server.MapPath(savingPath));
            if (!IsExists)
            {
                System.IO.Directory.CreateDirectory(Server.MapPath(savingPath));
            }
            savingPath += "/" + lblPanelID.Text;

            string headerUrl = "";

            if (chkDefaultHeader.Checked)
            {
                //Static Code
               // headerUrl = "~/App_Images/ReportBackGround/nirupan pad finiel.jpg";
               // fileFullName = "nirupan pad finiel.jpg";

                //Dynamic Code Written BY Ashwani
                DataTable dt = StockReports.GetDataTable("SELECT `ReportBackGroundImage` FROM `f_panel_master` WHERE `panel_ID`=78");

                headerUrl = "App_Images/ReportBackGround/" + Util.GetString(dt.Rows[0]["ReportBackGroundImage"]);
                fileFullName = Util.GetString(dt.Rows[0]["ReportBackGroundImage"]);
            }
            else
            {
                string ImgName = fuHeader.FileName;
                headerUrl = Path.Combine(savingPath + "_Letter_Head" + headerExte);
                fuHeader.PostedFile.SaveAs(Server.MapPath(headerUrl));
                fileFullName = lblPanelID.Text+"_Letter_Head" + headerExte;
            }
            


            headerUrl = headerUrl.Replace("\\", "''");
            headerUrl = headerUrl.Replace("'", "\\");

            StockReports.ExecuteDML(" UPDATE f_panel_master SET `ReportBackGroundImage`='" + fileFullName + "' WHERE panel_id='" + lblPanelID.Text.Trim() + "' ");
            lblMsg.Text = "Letter Head Saved..!";

            showHeaderFooter(headerUrl);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}