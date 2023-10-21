using CCA.Util;
using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Design_PaymentGateWay_ccavRequestHandler : System.Web.UI.Page
{
    CCACrypto ccaCrypto = new CCACrypto();
    string workingKey = "dsjfjdfjdbjdf";//put in the 32bit alpha numeric key in the quotes provided here
   // string workingKey = "ED0EF0FB9C96C4F9D29D73B7FAE1D431";//put in the 32bit alpha numeric key in the quotes provided here
    string ccaRequest = "";
    public string strEncRequest = "";

   // public string strAccessCode = "jfdhjkdsgksdjd";//  put the access key in the quotes provided here.
    public string strAccessCode = "shdfkldgnkjdfgd";//  put the access key in the quotes provided here.
  
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            foreach (string name in Request.Form)
            {
                if (name != null)
                {
                    if (!name.StartsWith("_"))
                    {
                        ccaRequest = ccaRequest + name + "=" + Request.Form[name] + "&";
                        /* Response.Write(name + "=" + Request.Form[name]);
                          Response.Write("</br>");*/
                    }
                }
            }
            strEncRequest = ccaCrypto.Encrypt(ccaRequest, workingKey);
            //Response.Write(ccaRequest);
            //Response.Write("</br>");

            //Response.Write(workingKey);
            //Response.Write("</br>");

            //Response.Write(strEncRequest);
            //Response.Write("</br>");
            //Response.End();
        }
    }
}