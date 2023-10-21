using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Store_uploadposign : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        
            if (fu_Upload.PostedFile.ContentLength > 0)
            {
                string RootDir = Server.MapPath("~/Design/Store/POSign");

                if (!Directory.Exists(RootDir))
                    Directory.CreateDirectory(RootDir);

                fu_Upload.SaveAs(RootDir+"/" + Util.GetString(Request.QueryString["empid"].ToString()) + ".jpg");
                StockReports.ExecuteDML("delete from st_posign where EmpID='" + Util.GetString(Request.QueryString["empid"].ToString()) + "' ");
                StockReports.ExecuteDML("insert into st_posign(EmpID,FileName,EntryDate,EntryBy) values ('" + Util.GetString(Request.QueryString["empid"].ToString()) + "','" + Util.GetString(Request.QueryString["empid"].ToString())+".jpg" + "',now(),'"+UserInfo.ID+"')");
                lblmsg.Text = "File Uploaded";
            }

           
    }
}