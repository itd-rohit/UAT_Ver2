using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;
public partial class Design_Lab_PreviewConcentForm : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            bindAttachment();
        }
        lblMsg.Text = "";
    }

    private void bindAttachment()
    {
        string filename=Request.QueryString["filename"];
        string mmc = Convert.ToBase64String(File.ReadAllBytes(Server.MapPath("~/Design/ConcentForm") + "/" + filename));
        string ext = System.IO.Path.GetExtension((Server.MapPath("~/Design/ConcentForm") + "/" + filename));
        if (ext.Replace(".", "").ToUpper() != "PDF")
        {
            mm.Attributes["src"] = @"data:image/" + ext.Replace(".", "") + ";base64," + mmc;
            // mm2.Attributes["src"] = @"data:image/" + ext.Replace(".", "") + ";base64," + mmc;
        }
        else
        {
            mm.Attributes["src"] = @"data:application/pdf;base64," + mmc;
            //mm2.Attributes["src"] = @"data:application/pdf;base64," + mmc;
        }

    }
   
}