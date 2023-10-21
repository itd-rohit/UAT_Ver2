using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_Lab_getDistrict : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        int StateIndex = Util.GetInt(Request.QueryString["StateIndex"]);
        string Output = "";
        if (StateIndex > 0)
            Output = File.ReadLines(HttpContext.Current.Server.MapPath("~/district.txt")).ToList()[StateIndex-1];
        HttpContext.Current.Response.ClearContent();
        HttpContext.Current.Response.Output.Write(Output);
        HttpContext.Current.Response.End();
    }
}