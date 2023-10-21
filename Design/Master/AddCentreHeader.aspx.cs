using System;
using System.Data;
using System.IO;

public partial class Design_Master_AddCentreHeader : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["centreID"] != null)
            {
                lblCentreID.Text = Common.Decrypt(Request.QueryString["centreID"]);

                DataTable dt = StockReports.GetDataTable("select isShowHeader,isShowFooter,centre,IFNULL(HeaderImage,'')HeaderImage,IFNULL(FooterImage,'')FooterImage from centre_master where centreID='" + lblCentreID.Text + "'  ");
                lb.Text = dt.Rows[0]["centre"].ToString();
                if (dt.Rows[0]["isShowHeader"].ToString() == "1")
                {
                    chkHeader.Checked = true;                   
                }
                if (dt.Rows[0]["isShowFooter"].ToString() == "1")
                {
                    chkFooter.Checked = true;
                }
                lblHeder.Text = "Create Header For " + lb.Text;
                showHeaderFooter(dt.Rows[0]["HeaderImage"].ToString(), dt.Rows[0]["FooterImage"].ToString());
                imgDefaultHeader.ImageUrl = Resources.Resource.DefaultHeader;
                imgDefaultFooter.ImageUrl = Resources.Resource.DefaultFooter;
            }
        }
    }
    private void showHeaderFooter(string HeaderImage, string FooterImage)
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
        if (FooterImage != "")
        {
            imgFooter.ImageUrl = FooterImage;
            imgFooter.Visible = true;
        }
        else
            imgFooter.Visible = false;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        try
        {
            int IsHeadershow = 0; int isFootershow = 0;
            int Length = fuHeader.PostedFile.ContentLength;
            if (!fuHeader.HasFile && !chkDefaultHeader.Checked)
            {
                lblMsg.Text = "Please Select Header Image to Upload";
                return;
            }
            if (!fuFooter.HasFile && !chkDefaultFooter.Checked)
            {
                lblMsg.Text = "Please Select Footer Image to Upload";
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
            string footerExte = System.IO.Path.GetExtension((fuFooter).PostedFile.FileName);
            if (footerExte != "" && !chkDefaultFooter.Checked)
            {
                if (footerExte != ".jpg" && footerExte != ".jpeg" && footerExte != ".gif" && footerExte != ".JPG")
                {
                    lblMsg.Text = "Wrong File Extension of Selected Footer";
                    return;
                }
            }

            string savingPath = "~/Design/Centre/Image";
            bool IsExists = System.IO.Directory.Exists(Server.MapPath(savingPath));
            if (!IsExists)
            {
                System.IO.Directory.CreateDirectory(Server.MapPath(savingPath));
            }


            savingPath += "/" + lblCentreID.Text;

            string headerUrl = "", footerUrl = "";

            if (chkDefaultHeader.Checked)
            {
                headerUrl = Resources.Resource.DefaultHeader;

            }
            else
            {
                string ImgName = fuFooter.FileName;
                headerUrl = Path.Combine(savingPath + "_Header" + headerExte);
                fuHeader.PostedFile.SaveAs(Server.MapPath(headerUrl));
            }
            if (chkDefaultFooter.Checked)
            {
                footerUrl = Resources.Resource.DefaultFooter;

            }
            else
            {
                string ImgName = fuFooter.FileName;
                footerUrl = Path.Combine(savingPath + "_Footer" + headerExte);
                fuFooter.PostedFile.SaveAs(Server.MapPath(footerUrl));
            }
            if (chkHeader.Checked)
            {
                IsHeadershow = 1;
            }

            if (chkFooter.Checked)
            {
                isFootershow = 1;
            }

            headerUrl = headerUrl.Replace("\\", "''");
            headerUrl = headerUrl.Replace("'", "\\");

            footerUrl = footerUrl.Replace("\\", "''");
            footerUrl = footerUrl.Replace("'", "\\");
            StockReports.ExecuteDML("update centre_master set isShowHeader=" + IsHeadershow + ",isShowFooter=" + isFootershow + ", HeaderImage='" + headerUrl + "',FooterImage='" + footerUrl + "' where centreID='" + lblCentreID.Text + "'");
            lblMsg.Text = "Header Saved..!";

            showHeaderFooter(headerUrl, footerUrl);
        }
        catch (Exception ex)
        {
            ClassLog cl = new ClassLog();
            cl.errLog(ex);
        }
    }
}