using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_HomeCollection_ViewHCImage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string path = StockReports.ExecuteScalar(" select CONCAT('/',DATE_FORMAT(CreatedDate,'%Y%m%d'),'/',filename,'^',filename) from document_detail where id=" + Request.QueryString["id"].ToString().Replace(",","") + "");
            img.Attributes.Add("src", "http://59.99.112.130/ClientImages/Uploaded%20Document" + path.Split('^')[0]);
          
         
        }
    }
}